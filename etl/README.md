# ETL – Pentaho Data Integration

Carga del almacén de datos `dw` (esquema en estrella) desde las tres fuentes originales de `datos/raw/`.
Las transformaciones (.ktr) están en `etl/transformaciones/` y el trabajo (.kjb) en `etl/trabajos/`.

## Motor y versión
- Pentaho Data Integration (Spoon) Community 9.4.0.0-343, con Java 11 (OpenJDK).
- Base de datos: MySQL 8.4 administrado en la nube (Aiven, plan gratuito, 1 GB), base `dw`.
- Driver: MySQL Connector/J 8.4.0, copiado en `data-integration/lib` de PDI.
- No se usa capa de staging: PDI lee los archivos originales y escribe directamente en el almacén.

## Parámetros de conexión (sin contraseñas)
Las transformaciones no contienen credenciales: usan variables que cada integrante define en su propio
`~/.kettle/kettle.properties` (en Windows, `C:\Users\<usuario>\.kettle\kettle.properties`).
Ese archivo no se sube al repositorio. En `etl/kettle.properties.example` está la plantilla.

| Variable | Contenido |
|---|---|
| `RUTA_RAW` | Ruta absoluta de la carpeta `datos/raw/` de la copia local del repositorio, con barras `/` |
| `DB_HOST` | Servidor MySQL |
| `DB_PORT` | Puerto |
| `DB_NAME` | Base de datos (`dw`) |
| `DB_USER` | Usuario |
| `DB_PASS` | Contraseña (se entrega a cada integrante por un canal privado) |

La conexión `aiven_dw` usa `sslMode=REQUIRED` (Aiven exige SSL) y `rewriteBatchedStatements=true`
para que las cargas se hagan en lotes.

## Ubicación esperada de las fuentes
Se leen tal como se descargaron, sin abrirlas ni limpiarlas antes de PDI:

| Fuente | Archivo en `datos/raw/` | Formato | Nota |
|---|---|---|---|
| F1 ICFES | `F1_ICFES_Saber11_Bogota_2016-2022.csv` | CSV | En el repositorio viene dentro de un `.zip`; hay que descomprimirlo en la misma carpeta |
| F2 SED | `F2_SED_Colegios_Bogota_sep2026.geojson` | GeoJSON | Se lee con el paso *JSON input* |
| F3 MEN | `F3_MEN_Establecimientos_Educativos_2015-2025.csv` | CSV | Igual que F1, viene dentro de un `.zip` |

Los CSV descomprimidos están en `.gitignore` (pesan más de 100 MB). Cómo obtener cada fuente: `datos/descarga.md`.

## Preparación
1. Crear la base `dw` en MySQL y ejecutar en orden los scripts de `dw/ddl/` (`01` a `06`).
   El `00_drop_all.sql` borra las tablas y sirve para repetir la prueba desde cero.
2. Definir las variables de la tabla anterior en `kettle.properties` y reiniciar Spoon.
3. Descomprimir F1 y F3 en `datos/raw/`.

## Orden de ejecución
Primero las dimensiones y al final los hechos, porque la tabla de hechos busca las llaves en las dimensiones.

| # | Transformación | Lee | Carga | Estado |
|---|---|---|---|---|
| 0 | `dw/ddl/06_poblar_dim_tiempo.sql` | — | `dim_tiempo` (14 semestres) | Hecho |
| 1 | `t_dim_contexto.ktr` | F3 | `dim_contexto_colegio_anio` | Hecho |
| 2 | `t_dim_perfil.ktr` | F1 | `dim_perfil_estudiante` | Hecho |
| 3 | `t_dim_colegio.ktr` | F2 y F1 | `dim_colegio` | Pendiente |
| 4 | `t_fact_resultado_saber11.ktr` | F1 | `fact_resultado_saber11` | Pendiente |
| 5 | `job_carga_dw.kjb` | — | Ejecuta 1 a 4 en orden | Pendiente |

## Periodos faltantes
El ICFES no publicó los periodos 2018-2, 2020-2 y 2021-2 (el conjunto de datos dice cubrir de 2010 a 2022).
Estos periodos **no se inventan ni se rellenan con datos**:
- `dim_tiempo` contiene los 14 semestres entre 2016-1 y 2022-2 sin huecos, para que las comparaciones por
  etapa (prepandemia, pandemia, pospandemia) tengan su calendario completo.
- Los semestres 2018-2, 2020-2 y 2021-2 quedan en la dimensión sin ningún hecho asociado.
- En los hechos hay resultados de 11 periodos: 2016-1, 2016-2, 2017-1, 2017-2, 2018-1, 2019-1, 2019-2, 2020-1,
  2021-1, 2022-1 y 2022-2.
- Los códigos de periodo del ICFES cambian (`20172` hasta 2017 y `20194` desde 2019): el ETL de hechos los
  normaliza a año y semestre.

## Reglas de limpieza de t_dim_contexto
| Regla | Paso de PDI | Efecto en la ejecución completa |
|---|---|---|
| Solo establecimientos de Bogotá (`COD_DANE_DEPARTAMENTO = 11`) | `filtra_bogota` | 583.694 filas descartadas de 606.206 |
| Quitar puntos de miles de `AÑO`, `CODIGO_DANE`, `TOTAL_MATRICULA` y `CANTIDAD_SEDES` | `quita_puntos_miles` | Se aplica a las 22.512 filas de Bogotá |
| Solo años 2016 a 2022 (excluye también el año 2023 con volumen anómalo) | `filtra_anios` | 7.835 filas descartadas |
| Excluir datos personales (`RECTOR`, `TELEFONO`, `EMAIL`) | `selecciona_columnas` | Las columnas no pasan al almacén |
| Clasificar la matrícula (pequeño ≤ 500, mediano ≤ 1.500, grande > 1.500) | `calcula_rango_matricula` | 14.677 filas |
| Una fila por establecimiento y año | `quita_repetidos` | 0 repetidos |

Resultado: 14.677 filas cargadas en `dim_contexto_colegio_anio`.
Conciliación de F3: 606.206 leídas = 14.677 cargadas + 583.694 + 7.835 descartadas.

## Reglas de limpieza de t_dim_perfil
| Regla | Paso de PDI | Efecto en la ejecución completa |
|---|---|---|
| Contar los campos del perfil vacíos o con `Sin Estrato` en cada fila | `marca_perfil_incompleto` | 523.922 filas revisadas |
| Separar las filas que hay que corregir de las que no | `filtra_perfil_incompleto` | 26.654 filas por corregir |
| Reemplazar vacíos y `Sin Estrato` por `Sin dato` en género, estrato, internet, computador y educación de madre y padre | `limpia_vacios_perfil` | 26.654 filas afectadas |
| Excluir `ESTU_FECHANACIMIENTO` y las demás columnas que no son del perfil | `selecciona_perfil` | Solo pasan 6 de las 51 columnas |
| Una fila por combinación de perfil | `quita_repetidos_perfil` | 523.922 filas se resumen en 6.632 combinaciones |

Resultado: 6.632 combinaciones cargadas en `dim_perfil_estudiante` (más la fila `-1` Sin dato).
Campos corregidos en F1 (de 523.922 filas): estrato 20.638 (17.773 vacíos y 2.865 `Sin Estrato`),
internet 17.211, educación de la madre 16.725, educación del padre 16.835, computador 8.922 y género 63.

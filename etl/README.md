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
| 3 | `t_dim_colegio.ktr` | F1 y F2 | `dim_colegio` | Hecho |
| 4 | `t_fact_resultado_saber11.ktr` | F1 | `fact_resultado_saber11` | Hecho |
| 5 | `job_carga_dw.kjb` (en `etl/trabajos/`) | — | Recrea las tablas (scripts `dw/ddl/00` a `06`) y ejecuta 1 a 4 en orden | Hecho |

## Cómo ejecutar la carga completa
1. Servicio MySQL encendido y las variables de `kettle.properties` definidas (ver arriba).
2. Descomprimir F1 y F3 en `datos/raw/`.
3. En Spoon, abrir `etl/trabajos/job_carga_dw.kjb` y presionar **Run** (nivel de log *Basic*).
   El trabajo borra y recrea las cinco tablas del almacén, puebla `dim_tiempo` y carga las dimensiones y los hechos.
   Es una carga completa: se puede ejecutar sobre una base vacía o repetir sin duplicar datos.
4. Duración aproximada: 12 minutos (la mayor parte, 5 minutos, es el ordenamiento de los 523.922 resultados de F1).
5. Verificar con las consultas de `dw/conciliacion/`.

Resultado de la última ejecución completa (sin errores, 13 pasos del trabajo):

| Tabla | Registros |
|---|---|
| `dim_tiempo` | 14 |
| `dim_colegio` | 1.323 (más la fila `-1`) |
| `dim_contexto_colegio_anio` | 14.677 (más la fila `-1`) |
| `dim_perfil_estudiante` | 6.632 (más la fila `-1`) |
| `fact_resultado_saber11` | 361.719 |

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
| Valores vacíos con guion en `CARACTER` (problema de calidad de la Entrega 1) | `selecciona_columnas` | 881 de las 14.677 filas de Bogotá 2016-2022 traen `-`; la columna no pasa al almacén porque el modelo no la usa |
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

## Reglas de limpieza de t_dim_colegio
La dimensión tiene una fila por sede con resultados en el Saber 11 (F1) enriquecida con el directorio de la SED (F2).

| Regla | Paso de PDI | Efecto en la ejecución completa |
|---|---|---|
| `BOGOTÁ` y `BOGOTA` se unifican en `BOGOTA` | `filtra_depto_con_tilde` y `unifica_bogota` | 330.259 de 523.922 filas corregidas |
| Una fila por sede, la del periodo más reciente (817 de las 1.323 sedes cambian de atributos entre periodos) | `ordena_por_sede` y `quita_repetidos_sede` | 523.922 filas se resumen en 1.323 sedes |
| Coordenadas de EPSG 3857 (metros) a latitud y longitud en grados (EPSG 4326) | `convierte_coordenadas` (User Defined Java Expression) | 2.176 sedes del directorio; las 1.171 que cruzan con F1 quedan en la dimensión |
| Códigos de F2 sin etiqueta a texto (`SECTOR`, `CLASE_TIPO`, `CALENDARIO`, `ZONA`, `COD_LOCA`) con el dominio del servicio REST de la SED (`datos/diccionarios/apoyo_dominios_sed.csv`) | `traduce_sector`, `traduce_clase`, `traduce_calendario`, `traduce_zona` y `traduce_localidad` | 2.176 filas cada uno |
| Etiquetas de F1 (`OFICIAL`/`NO OFICIAL`, `URBANO`/`RURAL`, `S`/`N`) al mismo vocabulario que F2 | `traduce_naturaleza`, `traduce_area` y `traduce_bilingue` | 1.323 filas cada uno |
| Cruce de F1 con el directorio por código DANE de sede; si la sede no está en F2 se conservan sus datos de F1 y la localidad queda `Sin dato` | `busca_en_directorio_sed` y `consolida_atributos` | 1.171 sedes con directorio y 152 sin directorio (18.903 resultados, el 3,6 %) |
| Excluir datos personales y las columnas que no son del colegio | `selecciona_colegios` y `selecciona_columnas_colegio` | Solo pasan 11 de las 51 columnas de F1 |
| Archivo y servicio REST de la SED con distinta cobertura y fecha de corte (problema de calidad de la Entrega 1) | `lee_f2_json` | Se lee solo el archivo GeoJSON: 2.176 sedes con corte 30/09/2026; el servicio REST (2.211 sedes, corte 31/12/2025) solo se consultó para los dominios de los códigos |
| `NATU_JUR` codificado y con diccionarios contradictorios (problema de calidad de la Entrega 1) | `lee_f2_json` | La columna no se lee porque el modelo no la usa; 2 de las 2.176 sedes traen el código 19, que no existe en el catálogo |

Decisiones:
- Archivo frente a servicio REST de la SED: se usa el archivo GeoJSON (2.176 sedes, corte 30/09/2026). El servicio REST
  (2.211 sedes, corte 31/12/2025) solo se consultó para los dominios de los códigos.
- `NATU_JUR` no se carga al almacén: el modelo no tiene esa columna, así que su contradicción de diccionarios no afecta la carga.
- Las 1.005 sedes del directorio que no aparecen en F1 no se cargan: no tienen resultados del Saber 11.
- La jornada de la sede es la del periodo más reciente en que aparece.

Resultado: 1.323 sedes cargadas en `dim_colegio` (más la fila `-1` Sin dato): 414 oficiales y 909 no oficiales.
Conciliación de F2: 2.176 sedes leídas = 1.171 usadas en la dimensión + 1.005 sin resultados en F1.

## Reglas de limpieza de t_fact_resultado_saber11
| Regla | Paso de PDI | Efecto en la ejecución completa |
|---|---|---|
| Resultados duplicados: una fila por estudiante y periodo (`ESTU_CONSECUTIVO` + `PERIODO`) | `quita_duplicados` | 523.922 leídas, 361.719 únicas: 162.203 duplicados quitados (159.417 en 2019 y 2022 y 2.786 en 2016-2, 2017-2 y 2018-1), todos idénticos |
| Códigos de periodo del ICFES (`20172` hasta 2017 y `20194` desde 2019) a año y semestre; el último dígito 1 es semestre 1 y 2 o 4 es semestre 2 | `normaliza_periodo` | 361.719 filas; 159.085 traían el código `…4` (`filtra_periodo_recodificado` y `cuenta_periodo_recodificado`) |
| Perfil con vacíos o `Sin Estrato` pasa a `Sin dato` (misma regla de `t_dim_perfil`) | `marca_perfil_incompleto`, `filtra_perfil_incompleto` y `limpia_vacios_perfil` | 16.341 filas afectadas |
| Llave de cada dimensión; si no hay pareja la fila apunta al miembro `-1` Sin dato | `busca_sk_tiempo`, `busca_sk_colegio`, `busca_sk_contexto` y `busca_sk_perfil` | Sin tiempo: 0. Sin colegio: 0. Sin perfil: 0. Sin contexto del MEN: 634 (28 combinaciones establecimiento-año) |
| Excluir datos personales (`ESTU_FECHANACIMIENTO` y demás columnas del estudiante) | `selecciona_hechos` | Solo pasan 16 de las 51 columnas |

Resultado: 361.719 filas cargadas en `fact_resultado_saber11`, con la suma de `punt_global` igual a 99.459.431 en la fuente
(sin duplicados) y en el almacén. Periodos faltantes: ver la sección anterior; los hechos cubren 11 de los 14 semestres de `dim_tiempo`.

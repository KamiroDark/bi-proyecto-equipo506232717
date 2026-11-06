# Secretaría de Educación del Distrito de Bogotá: ¿la pandemia amplió la brecha entre colegios oficiales y no oficiales en el Saber 11?

Proyecto final de **Business Intelligence** – Fundación Universitaria Konrad Lorenz. Docente: Leandro Pájaro Fuentes.

## Caso
La Secretaría de Educación del Distrito (SED) de Bogotá necesita decidir a qué colegios oficiales y localidades dirigir
sus programas de refuerzo académico. Los resultados del Saber 11 (ICFES), el directorio de colegios (SED) y la matrícula
(MEN) están separados y con códigos distintos. Este proyecto los integra en un almacén dimensional, un tablero y un
modelo predictivo.

**Pregunta principal (P0):** ¿En qué localidades de Bogotá creció más la brecha de puntaje global del Saber 11 entre colegios no oficiales y oficiales al comparar 2016-2019 con 2022?

## Integrantes
| Nombre | Código |
|---|---|
| Laura Valentina López García | 506232714 |
| Juan Camilo Prieto Mestizo | 506232717 |
| Diego Alejandro Gil Moreno | 507232716 |

## Herramientas
- ETL: Pentaho Data Integration (Spoon)
- Almacén: MySQL 8.4 en la nube (Aiven), administrado con DBeaver
- Tablero: Power BI
- Modelo predictivo: Python (pandas, scikit-learn)
- Diagramas: draw.io

## Estructura
```
README.md           caso, integrantes, herramientas y cómo reproducir
docs/entregas/      PDF de cada entrega
docs/diagramas/     arquitectura, esquema dimensional (PNG + draw.io) y modelo físico generado desde la base
datos/raw/          fuentes originales sin modificar (los CSV de F1 y F3 van dentro de un .zip)
datos/muestras/     20 filas por fuente (CSV)
datos/diccionarios/ un diccionario por fuente + dominios de códigos de la SED
datos/descarga.md   URL, fecha, licencia y pasos para obtener cada fuente
dw/ddl/             scripts CREATE TABLE (Entrega 2)
dw/conciliacion/    consultas de conteo y promedios contra cifras oficiales (Entrega 2)
etl/transformaciones/ archivos .ktr de Pentaho (Entrega 2)
etl/trabajos/       archivos .kjb de Pentaho (Entrega 2)
etl/README.md       orden de ejecución y parámetros
dashboard/          archivo .pbix y capturas (Entrega 2)
modelo/             notebooks del modelo predictivo (Entrega 3)
```

## Cómo reproducir la solución
1. **Fuentes:** descomprimir en `datos/raw/` los archivos `.zip` de F1 (ICFES) y F3 (MEN); F2 (SED) ya está como `.geojson`.
   Cómo obtener cada fuente desde su origen: `datos/descarga.md`.
2. **Base de datos:** crear la base `dw` en MySQL 8 (el equipo usa MySQL 8.4 en Aiven). Las tablas las crea el trabajo de
   Pentaho; también se pueden crear a mano con los scripts de `dw/ddl/` en orden (`01` a `06`).
3. **Carga (ETL):** configurar las variables de conexión en `kettle.properties` (plantilla en `etl/kettle.properties.example`,
   sin contraseñas) y ejecutar en Spoon el trabajo `etl/trabajos/job_carga_dw.kjb`. Los detalles, el orden de ejecución
   y las reglas de limpieza están en `etl/README.md`.
4. **Conciliación:** ejecutar las consultas de `dw/conciliacion/` sobre la base `dw` para verificar los conteos, los totales
y la comparación con los boletines de la SED.
5. **Tablero:** abrir `dashboard/tablero_saber11.pbix` en Power BI Desktop, cambiar el origen de datos a la base `dw` y actualizar.
6. **Documentación:** los PDF de cada entrega están en `docs/entregas/` y los diagramas en `docs/diagramas/`.

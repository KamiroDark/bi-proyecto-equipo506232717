# ETL – Pentaho Data Integration

Orden de ejecución previsto (se implementa en la Entrega 2):

Las transformaciones (.ktr) van en `etl/transformaciones/` y los trabajos (.kjb) en `etl/trabajos/`.

1. `ext_icfes.ktr` – lee F1, quita filas duplicadas (ESTU_CONSECUTIVO + PERIODO), deriva año, semestre y calendario
   desde PERIODO, unifica "BOGOTÁ/BOGOTA", excluye ESTU_FECHANACIMIENTO y carga `staging.stg_icfes`.
2. `ext_colegios_sed.ktr` – lee F2 con el paso *JSON Input*, convierte x/y de EPSG 3857 a EPSG 4326 con el paso *Formula*
   (lon = x/6378137·180/π; lat = (2·atan(e^(y/6378137)) − π/2)·180/π) y carga `staging.stg_colegios_sed`.
3. `ext_men.ktr` – lee F3, quita los puntos de miles de AÑO, CODIGO_DANE y TOTAL_MATRICULA, marca el año 2023, excluye RECTOR, TELEFONO y EMAIL y carga
   `staging.stg_men`.
4. `homologacion_dane.ktr` – traduce códigos SECTOR, CLASE_TIPO, CALENDARIO, ZONA y localidad con
   `datos/diccionarios/apoyo_dominios_sed.csv` y homologa el código DANE entre las tres fuentes.
5. `carga_dimensiones.ktr` – carga dim_tiempo, dim_colegio, dim_contexto_colegio_anio y dim_perfil_estudiante.
6. `carga_hechos.ktr` – carga fact_resultado_saber11.
7. `job_carga_anual.kjb` – orquesta los pasos 1 a 6.

Parámetros: `RUTA_RAW` (carpeta /datos/raw), `DB_HOST`, `DB_NAME`, `DB_USER` (MySQL).

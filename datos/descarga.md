# Descarga y trazabilidad de las fuentes

| Fuente | Entidad | URL | Archivo en /datos/raw | Formato | Fecha de descarga | Licencia |
|---|---|---|---|---|---|---|
| F1 | ICFES | https://www.datos.gov.co/Educaci-n/Resultados-nicos-Saber-11/kgxf-xxbe | F1_ICFES_Saber11_Bogota_2016-2022.zip (contiene el .csv) | CSV | 22/10/2026 | CC BY-SA 4.0 |
| F2 | Secretaría de Educación del Distrito | https://datosabiertos.bogota.gov.co/dataset/colegios-bogota-d-c | F2_SED_Colegios_Bogota_sep2026.geojson | GeoJSON | 22/10/2026 | CC BY-SA 4.0 |
| F3 | Ministerio de Educación Nacional | https://www.datos.gov.co/Educaci-n/MEN_ESTABLECIMIENTOS_EDUCATIVOS_PREESCOLAR_B-SICA_/cfw5-qzt5 | F3_MEN_Establecimientos_Educativos_2015-2025.zip (contiene el .csv) | CSV | 22/10/2026 | CC BY-SA 4.0 |

Los CSV de F1 y F3 se guardan dentro de un .zip, sin ningún cambio, porque GitHub no acepta archivos de más de 100 MB
(pesan 275 MB y 182 MB). Al descomprimir el .zip se obtiene el CSV original con el mismo nombre.

## Pasos para obtener cada fuente

**F1 – Resultados únicos Saber 11 (ICFES)**
1. Abrir la URL de F1 en datos.gov.co.
2. Filtrar `cole_cod_depto_ubicacion = 11` (Bogotá) y `periodo >= 20161`, y exportar en CSV.
   La exportación sin filtro del conjunto completo se corta con un error 500, por eso se filtra.
3. Alternativa por API (el límite sin token es de velocidad, no de filas):
   `https://www.datos.gov.co/resource/kgxf-xxbe.csv?$where=cole_cod_depto_ubicacion='11' AND periodo>='20161'&$limit=2000000`
4. Resultado: 523.922 filas, 51 columnas, periodos 20161 a 20224 (faltan 20182, 20204 y 20214).

**F2 – Colegios. Bogotá D.C. (SED)**
1. Abrir la URL de F2 en Datos Abiertos Bogotá.
2. En *Recursos*, descargar **Colegios 09.26** en formato GeoJSON (2.176 sedes, corte 30/09/2026).
3. Las coordenadas vienen en EPSG 3857 (metros); el ETL las convierte a EPSG 4326.
4. Documentos de apoyo del mismo conjunto (Catálogo de Productos y Metadatos de Bogotá, registro 2990):
   catálogo de objetos, especificación técnica, evaluación de calidad y metadato XML.
   https://catalogopmb.catastrobogota.gov.co/PMBWeb/cr/hie/web?cmd=output&ID_REGISTRO=2990&TIPO=GIG-05-FR-01_V2_CATALOGODEOBJETOS&FORMATO=pdf
5. Servicio REST (dominios de códigos y validación, 2.211 sedes, corte 31/12/2025):
   https://serviciosgis.catastrobogota.gov.co/arcgis/rest/services/educacion/infraestructuraeducativa/MapServer/0

**F3 – Establecimientos educativos (MEN)**
1. Abrir la URL de F3 en datos.gov.co.
2. **Exportar** → **CSV** (606.206 filas, 24 columnas, años 2015 a 2025; 22.512 filas de Bogotá).

## Documentos de referencia (no se cargan al almacén)
- Boletines estadísticos de la SED 2017-2023 (PDF): https://www.educacionbogota.edu.co/portal_institucional/conoce-nuestras-cifras
  Se usan para conciliar los promedios Saber 11 por localidad y como contexto de deserción.

No se usan datos sintéticos. Los resultados del ICFES vienen anonimizados por la entidad. Por privacidad, el ETL
excluye `ESTU_FECHANACIMIENTO` de F1 (cuasi-identificador) y `RECTOR` de F3 (nombre de una persona), y esas dos
columnas tampoco aparecen en las muestras de `datos/muestras`. Los archivos de `datos/raw` se conservan tal como los
publica cada entidad.

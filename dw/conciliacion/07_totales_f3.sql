-- Conciliacion 7: totales de las metricas de F3 (MEN) en dim_contexto_colegio_anio
-- Esperado desde la fuente: F3, Bogota, anios 2016 a 2022 (14677 filas)
--   total_matricula 9111294, cantidad_sedes 17026
-- F2 (directorio de la SED) no tiene metricas que sumar: se concilia solo por conteo (01_conteo_por_tabla.sql)
SELECT SUM(total_matricula) AS total_matricula,
       SUM(cantidad_sedes)  AS cantidad_sedes,
       COUNT(*)             AS filas
FROM dim_contexto_colegio_anio
WHERE sk_contexto <> -1;
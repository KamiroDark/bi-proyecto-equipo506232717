-- Conciliacion 1: registros cargados en cada tabla del almacen (se comparan con las metricas de PDI)
-- Esperado: dim_tiempo 14, dim_colegio 1324, dim_contexto_colegio_anio 14678,
--           dim_perfil_estudiante 6633, fact_resultado_saber11 361719
-- Cada dimension incluye ademas la fila -1 Sin dato (dim_tiempo no la tiene)
SELECT 'dim_tiempo' AS tabla, COUNT(*) AS registros FROM dim_tiempo
UNION ALL SELECT 'dim_colegio', COUNT(*) FROM dim_colegio
UNION ALL SELECT 'dim_contexto_colegio_anio', COUNT(*) FROM dim_contexto_colegio_anio
UNION ALL SELECT 'dim_perfil_estudiante', COUNT(*) FROM dim_perfil_estudiante
UNION ALL SELECT 'fact_resultado_saber11', COUNT(*) FROM fact_resultado_saber11;

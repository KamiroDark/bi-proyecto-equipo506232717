-- Extraccion del conjunto de datos para el modelo de la Entrega 3 (P3)
-- Una fila por colegio oficial (establecimiento) y anio, solo segundo semestre (calendario A)
-- Se ejecuta desde modelo/modelo_saber11.ipynb con SQLAlchemy
SELECT c.cod_dane_establecimiento,
       MAX(c.nombre_establecimiento) AS nombre_establecimiento,
       MAX(c.localidad)              AS localidad,
       t.anio,
       COUNT(*)                      AS n_estudiantes,
       AVG(f.punt_global)            AS punt_global,
       MAX(x.total_matricula)        AS total_matricula,
       AVG(CASE WHEN p.tiene_internet   = 'Sin dato' THEN NULL ELSE p.tiene_internet   = 'Si' END) AS pct_internet,
       AVG(CASE WHEN p.tiene_computador = 'Sin dato' THEN NULL ELSE p.tiene_computador = 'Si' END) AS pct_computador,
       AVG(CASE WHEN p.estrato_vivienda = 'Sin dato' THEN NULL
                ELSE p.estrato_vivienda IN ('Estrato 1', 'Estrato 2') END)                     AS pct_estrato_1_2,
       AVG(CASE WHEN p.educacion_madre IN ('Sin dato', 'No sabe', 'No Aplica') THEN NULL
                ELSE p.educacion_madre IN ('Educación profesional completa', 'Postgrado') END) AS pct_madre_profesional
FROM fact_resultado_saber11 f
JOIN dim_tiempo                t ON t.sk_tiempo   = f.sk_tiempo
JOIN dim_colegio               c ON c.sk_sede     = f.sk_sede
JOIN dim_contexto_colegio_anio x ON x.sk_contexto = f.sk_contexto
JOIN dim_perfil_estudiante     p ON p.sk_perfil   = f.sk_perfil
WHERE c.sector = 'Oficial'
  AND t.semestre = 2
  AND f.punt_global IS NOT NULL
GROUP BY c.cod_dane_establecimiento, t.anio
ORDER BY c.cod_dane_establecimiento, t.anio;
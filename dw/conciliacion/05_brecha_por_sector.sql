-- Conciliacion 5: puntaje global promedio por sector en el segundo semestre (calendario A)
-- Se compara con las cifras de la Entrega 1 (calculo propio con datos del ICFES):
-- la brecha entre no oficiales y oficiales pasa de 24,9 puntos en 2019 a 30,7 en 2022.
-- Esperado desde la fuente: 2016 22,8; 2017 22,0; 2019 24,9; 2022 30,7
SELECT t.anio,
       ROUND(AVG(CASE WHEN c.sector = 'Oficial' THEN f.punt_global END), 1) AS promedio_oficial,
       ROUND(AVG(CASE WHEN c.sector = 'No oficial' THEN f.punt_global END), 1) AS promedio_no_oficial,
       ROUND(AVG(CASE WHEN c.sector = 'No oficial' THEN f.punt_global END)
           - AVG(CASE WHEN c.sector = 'Oficial' THEN f.punt_global END), 1) AS brecha
FROM fact_resultado_saber11 f
JOIN dim_tiempo t ON t.sk_tiempo = f.sk_tiempo
JOIN dim_colegio c ON c.sk_sede = f.sk_sede
WHERE t.semestre = 2
GROUP BY t.anio
ORDER BY t.anio;

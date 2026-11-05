-- Conciliacion 2: hechos y suma de punt_global por periodo, contra la fuente F1 sin duplicados
-- Esperado (resultados, suma de punt_global):
--   2016-1: 2596, 952379      2016-2: 89900, 24908243   2017-1: 2530, 884358    2017-2: 88426, 24195374
--   2018-1: 4979, 1487330     2019-1: 2446, 856481      2019-2: 82832, 22017091  2020-1: 3610, 1071621
--   2021-1: 3259, 1057151     2022-1: 4888, 1422343     2022-2: 76253, 20607060
-- Los periodos 2018-2, 2020-2 y 2021-2 no se publicaron: aparecen sin hechos (LEFT JOIN)
SELECT t.periodo, COUNT(f.sk_resultado) AS resultados, SUM(f.punt_global) AS suma_punt_global
FROM dim_tiempo t
LEFT JOIN fact_resultado_saber11 f ON f.sk_tiempo = t.sk_tiempo
GROUP BY t.sk_tiempo, t.periodo
ORDER BY t.sk_tiempo;

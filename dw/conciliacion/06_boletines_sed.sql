-- Conciliacion 6: comparacion con los boletines estadisticos de la SED (Saber 11, calendario A)
-- Se agrupa por clase de colegio del directorio de la SED, porque el boletin reporta colegios distritales y privados
-- Boletin 2019, Tabla 89: colegios oficiales (IED) 39.650 evaluados y 257,1; privados 33.645 y 290,3
-- Boletin 2022, Tabla 95 (datos provisionales): distritales 38.062 y 258,52; privados 30.400 y 296,95
-- Resultado en el almacen: 2019-2 Distrital 43.300 y 253,7; Privado 33.055 y 281,3
--                          2022-2 Distrital 40.898 y 256,0; Privado 30.174 y 288,8
SELECT t.periodo,
       c.clase,
       COUNT(*)                     AS evaluados,
       ROUND(AVG(f.punt_global), 1) AS promedio_global
FROM fact_resultado_saber11 f
JOIN dim_tiempo  t ON t.sk_tiempo = f.sk_tiempo
JOIN dim_colegio c ON c.sk_sede   = f.sk_sede
WHERE t.periodo IN ('2019-2', '2022-2')
GROUP BY t.periodo, c.clase
ORDER BY t.periodo, c.clase;
-- Conciliacion 4: hechos que apuntan al miembro -1 Sin dato de cada dimension
-- Esperado: sin tiempo 0, sin colegio 0, sin contexto del MEN 634, sin perfil 0
-- Los 634 corresponden a 28 combinaciones establecimiento-anio que no estan en F3
SELECT COUNT(*) AS resultados,
       SUM(sk_tiempo = -1) AS sin_tiempo,
       SUM(sk_sede = -1) AS sin_colegio,
       SUM(sk_contexto = -1) AS sin_contexto,
       SUM(sk_perfil = -1) AS sin_perfil
FROM fact_resultado_saber11;

-- Sedes del almacen que no estan en el directorio de la SED (F2): esperado 152 sedes
SELECT COUNT(*) AS sedes_sin_directorio
FROM dim_colegio
WHERE sk_sede <> -1 AND localidad = 'Sin dato';

-- Resultados de esas sedes: esperado 18903 (3,6 % de 523922 filas de F1 con duplicados)
-- En el almacen, sin duplicados, el numero es menor
SELECT COUNT(*) AS resultados_sedes_sin_directorio
FROM fact_resultado_saber11 f
JOIN dim_colegio c ON c.sk_sede = f.sk_sede
WHERE c.localidad = 'Sin dato';

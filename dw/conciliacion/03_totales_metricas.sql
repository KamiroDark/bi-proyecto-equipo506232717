-- Conciliacion 3: total de cada metrica de la tabla de hechos en el almacen
-- Fuente: F1 sin duplicados (361.719 resultados). Esperado:
--   punt_global 99459431, punt_lectura_critica 20432435, punt_matematicas 19983520,
--   punt_sociales_ciudadanas 19290581, punt_c_naturales 19685933, punt_ingles 20414297
--   (punt_ingles tiene 39 resultados vacios), cantidad_estudiantes 361719
SELECT COUNT(*) AS resultados,
       SUM(punt_global) AS suma_punt_global,
       SUM(punt_lectura_critica) AS suma_lectura_critica,
       SUM(punt_matematicas) AS suma_matematicas,
       SUM(punt_sociales_ciudadanas) AS suma_sociales_ciudadanas,
       SUM(punt_c_naturales) AS suma_c_naturales,
       SUM(punt_ingles) AS suma_ingles,
       COUNT(punt_ingles) AS ingles_con_dato,
       SUM(cantidad_estudiantes) AS suma_cantidad_estudiantes
FROM fact_resultado_saber11;

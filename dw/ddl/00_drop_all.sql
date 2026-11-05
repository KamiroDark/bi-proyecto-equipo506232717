-- Borra las tablas del DW para poder recrearlas desde cero (hechos primero por las llaves foraneas)
DROP TABLE IF EXISTS fact_resultado_saber11;
DROP TABLE IF EXISTS dim_perfil_estudiante;
DROP TABLE IF EXISTS dim_contexto_colegio_anio;
DROP TABLE IF EXISTS dim_colegio;
DROP TABLE IF EXISTS dim_tiempo;

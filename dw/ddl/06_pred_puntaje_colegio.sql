-- Tabla de predicciones del modelo de la Entrega 3: puntaje global predicho por colegio oficial en la aplicacion de prueba (2022-2)
-- sk_tiempo se une con dim_tiempo y sk_contexto con dim_contexto_colegio_anio. No se declaran FOREIGN KEY para que el job de PDI pueda borrar y recrear las dimensiones
CREATE TABLE pred_puntaje_colegio (
    sk_tiempo                INT          NOT NULL,
    sk_contexto              INT          NOT NULL,
    cod_dane_establecimiento VARCHAR(12)  NOT NULL,
    nombre_establecimiento   VARCHAR(150) NULL,
    localidad                VARCHAR(40)  NOT NULL,
    valor_real               DECIMAL(6,2) NOT NULL,
    valor_predicho           DECIMAL(6,2) NOT NULL,
    error                    DECIMAL(6,2) NOT NULL,
    priorizar                TINYINT      NOT NULL,
    modelo                   VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_pred_puntaje_colegio PRIMARY KEY (sk_tiempo, cod_dane_establecimiento)
);

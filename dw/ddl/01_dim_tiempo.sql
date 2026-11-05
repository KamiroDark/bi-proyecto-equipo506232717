-- Dimension Tiempo: una fila por semestre de aplicacion. Jerarquia: periodo > semestre > anio > etapa
CREATE TABLE dim_tiempo (
    sk_tiempo             INT         NOT NULL,
    periodo               VARCHAR(7)  NOT NULL,
    anio                  SMALLINT    NOT NULL,
    semestre              TINYINT     NOT NULL,
    calendario_aplicacion CHAR(1)     NOT NULL,
    etapa                 VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dim_tiempo PRIMARY KEY (sk_tiempo),
    CONSTRAINT uq_dim_tiempo_periodo UNIQUE (anio, semestre)
);

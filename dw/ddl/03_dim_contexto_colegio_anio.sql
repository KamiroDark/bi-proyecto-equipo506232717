-- Dimension Contexto del colegio en el anio (matricula del MEN). Una fila por establecimiento y anio
-- sk_contexto = -1 es el miembro Sin dato para colegios sin registro en el MEN
CREATE TABLE dim_contexto_colegio_anio (
    sk_contexto              INT         NOT NULL AUTO_INCREMENT,
    cod_dane_establecimiento VARCHAR(12) NOT NULL,
    anio                     SMALLINT    NOT NULL,
    total_matricula          INT         NULL,
    rango_matricula          VARCHAR(10) NOT NULL,
    cantidad_sedes           SMALLINT    NULL,
    sector_men               VARCHAR(12) NULL,
    CONSTRAINT pk_dim_contexto PRIMARY KEY (sk_contexto),
    CONSTRAINT uq_dim_contexto UNIQUE (cod_dane_establecimiento, anio)
);

INSERT INTO dim_contexto_colegio_anio (sk_contexto, cod_dane_establecimiento, anio, total_matricula, rango_matricula, cantidad_sedes, sector_men)
VALUES (-1, '-1', 0, NULL, 'Sin dato', NULL, 'Sin dato');

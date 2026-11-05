-- Dimension Colegio (sede). Jerarquia: sede > establecimiento > UPZ > localidad
-- sk_sede = -1 es el miembro Sin dato para sedes del ICFES que no estan en el directorio de la SED
CREATE TABLE dim_colegio (
    sk_sede                  INT           NOT NULL AUTO_INCREMENT,
    cod_dane_sede            VARCHAR(12)   NOT NULL,
    cod_dane_establecimiento VARCHAR(12)   NOT NULL,
    nombre_sede              VARCHAR(150)  NULL,
    nombre_establecimiento   VARCHAR(150)  NULL,
    sector                   VARCHAR(12)   NOT NULL,
    clase                    VARCHAR(40)   NULL,
    jornada                  VARCHAR(30)   NULL,
    calendario               VARCHAR(10)   NULL,
    bilingue                 VARCHAR(10)   NULL,
    zona                     VARCHAR(60)   NULL,
    upz                      VARCHAR(10)   NULL,
    localidad                VARCHAR(40)   NOT NULL,
    latitud                  DECIMAL(10,7) NULL,
    longitud                 DECIMAL(10,7) NULL,
    CONSTRAINT pk_dim_colegio PRIMARY KEY (sk_sede),
    CONSTRAINT uq_dim_colegio_sede UNIQUE (cod_dane_sede)
);

INSERT INTO dim_colegio (sk_sede, cod_dane_sede, cod_dane_establecimiento, nombre_sede, nombre_establecimiento, sector, localidad)
VALUES (-1, '-1', '-1', 'Sin dato', 'Sin dato', 'Sin dato', 'Sin dato');

-- Dimension Perfil del estudiante (mini-dimension): una fila por combinacion de condiciones del hogar
-- sk_perfil = -1 es el miembro Sin dato
CREATE TABLE dim_perfil_estudiante (
    sk_perfil        INT         NOT NULL AUTO_INCREMENT,
    genero           VARCHAR(10) NOT NULL,
    estrato_vivienda VARCHAR(20) NOT NULL,
    tiene_internet   VARCHAR(10) NOT NULL,
    tiene_computador VARCHAR(10) NOT NULL,
    educacion_madre  VARCHAR(80) NOT NULL,
    educacion_padre  VARCHAR(80) NOT NULL,
    CONSTRAINT pk_dim_perfil PRIMARY KEY (sk_perfil),
    CONSTRAINT uq_dim_perfil UNIQUE (genero, estrato_vivienda, tiene_internet, tiene_computador, educacion_madre, educacion_padre)
);

INSERT INTO dim_perfil_estudiante (sk_perfil, genero, estrato_vivienda, tiene_internet, tiene_computador, educacion_madre, educacion_padre)
VALUES (-1, 'Sin dato', 'Sin dato', 'Sin dato', 'Sin dato', 'Sin dato', 'Sin dato');

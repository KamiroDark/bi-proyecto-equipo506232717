-- Tabla de hechos. Granularidad: un resultado de un estudiante en una aplicacion del Saber 11
-- estu_consecutivo es la dimension degenerada (identificador anonimizado del estudiante)
CREATE TABLE fact_resultado_saber11 (
    sk_resultado             BIGINT      NOT NULL AUTO_INCREMENT,
    sk_tiempo                INT         NOT NULL,
    sk_sede                  INT         NOT NULL,
    sk_contexto              INT         NOT NULL,
    sk_perfil                INT         NOT NULL,
    estu_consecutivo         VARCHAR(20) NOT NULL,
    punt_global              SMALLINT    NULL,
    punt_lectura_critica     SMALLINT    NULL,
    punt_matematicas         SMALLINT    NULL,
    punt_sociales_ciudadanas SMALLINT    NULL,
    punt_c_naturales         SMALLINT    NULL,
    punt_ingles              SMALLINT    NULL,
    cantidad_estudiantes     SMALLINT    NOT NULL DEFAULT 1,
    CONSTRAINT pk_fact_resultado PRIMARY KEY (sk_resultado),
    CONSTRAINT uq_fact_estudiante_periodo UNIQUE (estu_consecutivo, sk_tiempo),
    CONSTRAINT fk_fact_tiempo   FOREIGN KEY (sk_tiempo)   REFERENCES dim_tiempo (sk_tiempo),
    CONSTRAINT fk_fact_colegio  FOREIGN KEY (sk_sede)     REFERENCES dim_colegio (sk_sede),
    CONSTRAINT fk_fact_contexto FOREIGN KEY (sk_contexto) REFERENCES dim_contexto_colegio_anio (sk_contexto),
    CONSTRAINT fk_fact_perfil   FOREIGN KEY (sk_perfil)   REFERENCES dim_perfil_estudiante (sk_perfil)
);

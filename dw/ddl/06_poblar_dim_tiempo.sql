-- Puebla dim_tiempo con los 14 semestres de 2016-1 a 2022-2, sin huecos
-- Calendario A = segundo semestre, calendario B = primer semestre
-- Etapa: prepandemia hasta 2019, pandemia 2020 y 2021, pospandemia desde 2022
INSERT INTO dim_tiempo (sk_tiempo, periodo, anio, semestre, calendario_aplicacion, etapa) VALUES
(1,  '2016-1', 2016, 1, 'B', 'prepandemia'),
(2,  '2016-2', 2016, 2, 'A', 'prepandemia'),
(3,  '2017-1', 2017, 1, 'B', 'prepandemia'),
(4,  '2017-2', 2017, 2, 'A', 'prepandemia'),
(5,  '2018-1', 2018, 1, 'B', 'prepandemia'),
(6,  '2018-2', 2018, 2, 'A', 'prepandemia'),
(7,  '2019-1', 2019, 1, 'B', 'prepandemia'),
(8,  '2019-2', 2019, 2, 'A', 'prepandemia'),
(9,  '2020-1', 2020, 1, 'B', 'pandemia'),
(10, '2020-2', 2020, 2, 'A', 'pandemia'),
(11, '2021-1', 2021, 1, 'B', 'pandemia'),
(12, '2021-2', 2021, 2, 'A', 'pandemia'),
(13, '2022-1', 2022, 1, 'B', 'pospandemia'),
(14, '2022-2', 2022, 2, 'A', 'pospandemia');

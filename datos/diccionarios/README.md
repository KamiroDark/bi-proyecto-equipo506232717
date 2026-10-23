# Diccionarios de datos


## F1 – Resultados únicos Saber 11 (ICFES), 51 campos; se listan los usados en el modelo

| Campo | Tipo | Descripción | Ejemplo | Problema de calidad |
|---|---|---|---|---|
| PERIODO | Texto | Año + aplicación (1 = primer semestre, 2 o 4 = segundo) | 20224 | Cambia de …2 a …4; faltan periodos. |
| ESTU_CONSECUTIVO | Texto | Identificador anonimizado del evaluado | SB11201940000018 | Duplicado en 2019 y 2022. |
| COLE_COD_DANE_ESTABLECIMIENTO | Texto | Código DANE del colegio | 111001000132 | Sin pareja en la SED para el 5,6 % de filas. |
| COLE_COD_DANE_SEDE | Texto | Código DANE de la sede | 111001000132 | Sin problema detectado. |
| COLE_NATURALEZA | Texto | Oficial o no oficial | OFICIAL | Etiqueta distinta a la de la SED (SECTOR 1/2). |
| COLE_AREA_UBICACION | Texto | Urbano o rural | URBANO | Solo 1 % rural en Bogotá. |
| COLE_JORNADA | Texto | Jornada de la sede | MAÑANA | Valores mezclan jornada y modalidad (NOCHE, SABATINA). |
| COLE_DEPTO_UBICACION | Texto | Departamento del colegio | BOGOTÁ | "BOGOTÁ" y "BOGOTA". |
| ESTU_GENERO | Texto | Género del evaluado | F | Sin problema detectado. |
| ESTU_FECHANACIMIENTO | Texto (fecha) | Fecha de nacimiento | 17/10/2003 | Cuasi-identificador: se excluye en el ETL. |
| FAMI_ESTRATOVIVIENDA | Texto | Estrato de la vivienda | Estrato 2 | 17.773 vacíos y valor "Sin Estrato". |
| FAMI_TIENEINTERNET | Texto | Hogar con internet | Si | 17.211 vacíos. |
| PUNT_GLOBAL | Número | Puntaje global (0-500) | 190 | Sin vacíos. |
| PUNT_MATEMATICAS | Número | Puntaje de matemáticas (0-100) | 35 | Sin problema detectado. |

## F2 – Colegios. Bogotá D.C. (SED), 31 campos; se listan los usados en el modelo

| Campo | Tipo | Descripción | Ejemplo | Problema de calidad |
|---|---|---|---|---|
| DANE12_EST | Texto | Código DANE del establecimiento | 111001000132 | Solo sedes vigentes en 2026; faltan colegios cerrados. |
| DANE12_SED | Texto | Código DANE de la sede | 111001000132 | Sin duplicados (verificado). |
| NOMBRE_EST | Texto | Nombre del establecimiento | COLEGIO AQUILEO PARRA (IED) | Texto libre; no sirve como llave. |
| SECTOR | Entero (código) | 1 No oficial · 2 Oficial | 2 | Código sin etiqueta en el archivo. |
| NATU_JUR | Entero (código) | Naturaleza jurídica | 9 | Dominio distinto en catálogo y servicio REST. |
| CLASE_TIPO | Entero (código) | 1 Distrital … 6 Privado régimen especial | 4 | Código sin etiqueta. |
| CALENDARIO | Entero (código) | 1 A · 2 A-B · 3 B · 4 B-Otro · 5 Otro | 1 | Código sin etiqueta. |
| ZONA | Entero (código) | 1 Urbana · 2 Rural · 3-6 mixtas | 1 | Sin dominio en el catálogo PDF. |
| COD_LOCA | Texto (código) | Localidad (01-20) | 01 | Alias "Nombre de la localidad" pero trae código. |
| NOM_UPZ | Texto (código) | UPZ | 9 | Se llama "NOM" pero trae código. |
| ESTRATO | Texto (código) | Estrato del predio (0 y 7 = sin dato) | 7 | Códigos de "sin dato" mezclados con estratos. |
| FECHA | Fecha | Fecha de corte | 2026-09-30 | El servicio REST dice 2025-12-31. |
| geometry | Punto | Ubicación de la sede | (-8242002,85; 531131,02) | En EPSG 3857, no en grados. |

## F3 – Establecimientos educativos (MEN), 24 campos; se listan los usados en el modelo

| Campo | Tipo | Descripción | Ejemplo | Problema de calidad |
|---|---|---|---|---|
| AÑO | Texto | Año del registro | 2.015 | Punto de miles en el año. |
| COD_DANE_DEPARTAMENTO | Texto | Código del departamento | 11 | Sin problema detectado. |
| CODIGO_DANE | Texto | Código DANE del establecimiento | 111.001.000.132 | Punto de miles; 2023 casi sin códigos. |
| NOMBRE_ESTABLECIMIENTO | Texto | Nombre del colegio | COLEGIO AQUILEO PARRA (IED) | Texto libre; no sirve como llave. |
| SECTOR | Texto | OFICIAL / NO_OFICIAL | NO_OFICIAL | Tercera forma de escribir el sector. |
| CALENDARIO | Texto | Calendario académico | A | Sin problema detectado. |
| CARACTER | Texto | Carácter de la media | - | Vacíos escritos como "-". |
| TOTAL_MATRICULA | Número | Estudiantes matriculados | 3.201 | Punto de miles. |
| CANTIDAD_SEDES | Número | Número de sedes | 1 | Sin problema detectado. |

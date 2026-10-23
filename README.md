# Secretaría de Educación del Distrito de Bogotá: ¿la pandemia amplió la brecha entre colegios oficiales y no oficiales en el Saber 11?

Proyecto final de **Business Intelligence** – Fundación Universitaria Konrad Lorenz. Docente: Leandro Pájaro Fuentes.

## Caso
La Secretaría de Educación del Distrito (SED) de Bogotá necesita decidir a qué colegios oficiales y localidades dirigir
sus programas de refuerzo académico. Los resultados del Saber 11 (ICFES), el directorio de colegios (SED) y la matrícula
(MEN) están separados y con códigos distintos. Este proyecto los integra en un almacén dimensional, un tablero y un
modelo predictivo.

**Pregunta principal (P0):** ¿En qué localidades de Bogotá creció más la brecha de puntaje global del Saber 11 entre colegios no oficiales y oficiales al comparar 2016-2019 con 2022?

## Integrantes
| Nombre | Código |
|---|---|
| Laura Valentina López García | 506232714 |
| Juan Camilo Prieto Mestizo | 506232717 |
| Diego Alejandro Gil Moreno | 507232716 |

## Herramientas
- ETL: Pentaho Data Integration (Spoon)
- Almacén: MySQL (administrado con DBeaver)
- Tablero: Power BI
- Modelo predictivo: Python (pandas, scikit-learn)
- Diagramas: draw.io

## Estructura
```
README.md           caso, integrantes, herramientas y cómo reproducir
docs/entregas/      PDF de cada entrega
docs/diagramas/     arquitectura y esquema dimensional (PNG + draw.io)
datos/raw/          fuentes originales sin modificar (los CSV de F1 y F3 van dentro de un .zip)
datos/muestras/     20 filas por fuente (CSV)
datos/diccionarios/ un diccionario por fuente + dominios de códigos de la SED
datos/descarga.md   URL, fecha, licencia y pasos para obtener cada fuente
dw/ddl/             scripts CREATE TABLE (Entrega 2)
dw/conciliacion/    consultas de conteo y promedios contra cifras oficiales (Entrega 2)
etl/transformaciones/ archivos .ktr de Pentaho (Entrega 2)
etl/trabajos/       archivos .kjb de Pentaho (Entrega 2)
etl/README.md       orden de ejecución y parámetros
dashboard/          archivo .pbix y capturas (Entrega 3)
modelo/             notebooks del modelo predictivo (Entrega 3)
```

## Cómo reproducir (Entrega 1)
1. Descargar las fuentes siguiendo `datos/descarga.md` (o descomprimir las copias de `datos/raw/`).
2. Revisar los diccionarios en `datos/diccionarios/` y las muestras en `datos/muestras/`.
3. El diseño (arquitectura y modelo dimensional) está en `docs/entregas/` y `docs/diagramas/`.

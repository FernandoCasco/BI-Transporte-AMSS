# ETL — Extracción, transformación y carga

Notebook de Google Colab (Python 3 + pandas) que realiza el proceso ETL del proyecto.

- **Entrada:** los 6 CSV de `Datos_crudos/` (leídos directamente desde el repositorio).
- **Proceso:** limpieza de nulos, duplicados, normalización de codificación (UPPER/TRIM), corrección de tipos y escalas.
- **Salida:** los 6 CSV depurados de `Datos_limpios/`.

**Resultado:** 57,230 registros crudos → 56,181 registros limpios (1,049 eliminados, 1.8%).

Para ejecutarlo: abrir el notebook en Google Colab y correr todas las celdas en orden.

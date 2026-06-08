# Datos limpios

Archivos CSV resultantes del proceso ETL (carpeta `ETL/`), depurados y listos para cargarse al Data Warehouse en SQL Server. Se eliminaron 1,049 registros con errores (1.8%).

| Archivo | Registros |
|---|---|
| FACT_Parada_Servicio_clean.csv | 44,191 |
| DIM_Parada_clean.csv | 9,353 |
| DIM_Ruta_clean.csv | 1,178 |
| DIM_Tarifa_clean.csv | 1,430 |
| DIM_Municipio_clean.csv | 14 |
| DIM_Departamento_clean.csv | 15 |
| **Total** | **56,181** |

> Nota: al cargar `DIM_Departamento` al DWH, un registro se descartó por un valor no numérico en la columna NA3, quedando 14 en SQL Server (ver sección 6.2 del informe).

# Data_limpia

Esta carpeta contiene los **6 archivos CSV procesados y listos para cargar al Data Warehouse** en SQL Server, resultado del proceso ETL ejecutado sobre los datos de `../Datos_crudos/`.

---

## Archivos

| Archivo | Descripción | Registros limpios |
|---------|-------------|------------------|
| `FACT_Parada_Servicio_clean.csv` | Tabla de hechos sin duplicados ni nulos inválidos | ~38,200 |
| `DIM_Parada_clean.csv` | Paradas deduplicadas y normalizadas | ~8,387 |
| `DIM_Ruta_clean.csv` | Rutas con encoding corregido y km validados | ~1,188 |
| `DIM_Tarifa_clean.csv` | Tarifas sin valores $0.00 ni nulos | ~1,426 |
| `DIM_Municipio_clean.csv` | 14 municipios AMSS completos | 14 |
| `DIM_Departamento_clean.csv` | 15 departamentos validados | 15 |

**Total registros limpios: ~49,230**  
**Reducción por ETL: ~28% de registros con errores eliminados o corregidos**

---

## Transformaciones aplicadas

- `FACT_Parada_Servicio`: eliminación de duplicados por clave compuesta `(Codigo_Ruta, Parada, Tipo_Dia, Hora_Salida)`; registros con `Frecuencia_Min = NULL` marcados como fuera de servicio
- `DIM_Parada`: deduplicación por `(Codigo_Ruta, Nombre_Parada)`; coordenadas (0,0) eliminadas
- `DIM_Ruta`: `UPPER(TRIM(SENTIDO))` para normalizar `IDA/Ida` → `IDA`; `Km_Recorrido` nulos → mediana de la ruta
- `DIM_Tarifa`: registros con `Tarifa_USD = 0` o NULL eliminados; tipo de unidad derivado del prefijo `AB/MB`
- `DIM_Municipio`: zona AMSS validada (Norte/Sur/Oriente/Poniente/Centro)
- `DIM_Departamento`: área y perímetro redondeados a 2 decimales

---

> Estos archivos son el insumo directo para los scripts SQL.


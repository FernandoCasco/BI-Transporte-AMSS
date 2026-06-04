# Datos_crudos

Esta carpeta contiene los **6 archivos CSV con la data original sin procesar**, extraída directamente de las fuentes públicas del VMT y construida a partir de ellas.

---

## Archivos

| Archivo | Descripción | Registros crudos | Fuente original |
|---------|-------------|-----------------|-----------------|
| `FACT_Parada_Servicio.csv` | Tabla de hechos: parada × tipo de día × período × hora de salida | 45,229 | Shapefile Paradas VMT + horarios operativos |
| `DIM_Parada.csv` | Paradas georreferenciadas del AMSS | 9,354 | Shapefile VMT (`Paradas Transporte Colectivo AMSS`) |
| `DIM_Ruta.csv` | Rutas urbanas, interurbanas e interdepartamentales | 1,188 | Shapefiles VMT (3 capas) |
| `DIM_Tarifa.csv` | Tarifas autorizadas por código de ruta | 1,430 | Excel VMT (`tarifariociudadano.vmt.gob.sv`) |
| `DIM_Municipio.csv` | 14 municipios del AMSS con datos geográficos | 14 | OPAMSS Atlas Metropolitano |
| `DIM_Departamento.csv` | Límites departamentales de El Salvador | 15 | Shapefile VMT (`Límites Departamentales`) |

**Total registros crudos: 57,230**

---

## Problemas de calidad documentados

Estos errores son **contables y documentados** para ser corregidos en el proceso ETL:

| Problema | Cantidad | Columna afectada |
|----------|----------|-----------------|
| Nulos en frecuencia (rutas sin servicio nocturno dominical) | 1,038 | `Frecuencia_Min` |
| Registros duplicados en FACT | 2,986 | `FACT_Parada_Servicio` |
| Duplicados en DIM_Parada (shapefile original) | 967 | `DIM_Parada` |
| Tarifas $0.00 o nulas | 4 | `DIM_Tarifa` |
| Encoding inconsistente en SENTIDO (`IDA` vs `Ida`) | 8 | `DIM_Ruta` |
| Códigos de ruta distintos entre fuentes | Variable | `Codigo_Ruta` |

---

> Para limpiar esta data, ejecutar el notebook en `../ETL/ETL_BI_AMSS.ipynb`


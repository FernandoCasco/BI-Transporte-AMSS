# ETL

Esta carpeta contiene el **notebook de Google Colab** con el proceso ETL completo del proyecto, desde la extracción de los datos crudos hasta la generación de los CSV limpios listos para el Data Warehouse.

---

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `ETL_BI_AMSS.ipynb` | Notebook principal con el proceso ETL completo |
| `requirements.txt` | Librerías Python necesarias para ejecutar el ETL |

---

## Fases del ETL

### Fase 1 — Extracción
- Lectura de los 6 CSV desde `../Datos_crudos/`
- Inspección inicial: shape, tipos de dato, valores únicos
- Reporte automático de nulos y duplicados por tabla

### Fase 2 — Limpieza
- Eliminación de duplicados por clave compuesta en cada tabla
- Imputación o eliminación de nulos según la regla de negocio
- Normalización de encoding (`SENTIDO`, nombres de municipios)
- Validación de rangos (`Tarifa_USD`, `Km_Recorrido`, coordenadas)
- Eliminación de registros con coordenadas inválidas (0, 0)

### Fase 3 — Transformación
- Creación de surrogate keys (`ID_Parada`, `ID_Municipio`, `ID_Tiempo`, `ID_TipoUnidad`)
- Mapeo de códigos de ruta entre fuentes (`101-D` ↔ `AB101D0`)
- Derivación de `Tipo_Unidad` desde prefijo del `Codigo_Ruta`
- Generación de `DIM_Tiempo` (3 tipos de día × 4 períodos = 12 registros)

### Fase 4 — Carga
- Exportación de los 6 CSV limpios a `../Data_limpia/`
- Log de errores: cantidad de registros eliminados por tabla
- Reporte final: registros crudos vs. registros limpios

---

## Cómo ejecutar

### Opción A — Google Colab (recomendado)
1. Ir a [colab.research.google.com](https://colab.research.google.com)
2. `Archivo → Subir notebook` → seleccionar `ETL_BI_AMSS.ipynb`
3. Subir los archivos de `../Datos_crudos/` cuando la celda lo solicite
4. `Entorno de ejecución → Ejecutar todo`
5. Descargar los CSV generados desde el panel de archivos de Colab

### Opción B — Local
```bash
pip install -r requirements.txt
jupyter notebook ETL_BI_AMSS.ipynb
```

---

## Librerías utilizadas

```
pandas==2.1.0
numpy==1.25.0
pyodbc==5.0.1
openpyxl==3.1.2
```


# BI-Transporte-AMSS

## Sistema de Inteligencia de Negocios para el Análisis del Transporte Público Colectivo en el Área Metropolitana de San Salvador (AMSS)

---

## Descripción del Proyecto

Este proyecto desarrolla un sistema de Business Intelligence que integra y analiza datos públicos del transporte colectivo del AMSS, consolidando información de **rutas, tarifas, paradas y cobertura geográfica** del Viceministerio de Transporte (VMT) y la OPAMSS.

El sistema sigue un flujo completo de BI:

```
Fuentes VMT/OPAMSS → ETL (Python/Colab) → Data Warehouse (SQL Server) → Dashboard (Power BI)
```

---

## Integrantes del Equipo

| Nombre | Carnet |
|--------|-----|
| Perez Casco, Fernando Miguel | 25-03592022 |
| Vicente Beltran, Mario Ernesto | 25-0745-2022 |
| Rosales Velasquez, Jose David | 14-0671-2022 |

**Docente:** Ing.Jorge Machado 
**Fecha de entrega:** 07 Junio 2025 

---

## Estructura del Repositorio

```
BI-Transporte-AMSS/
│
├── 📂 Datos_crudos/          → 6 archivos CSV con data original sin procesar (~57,230 registros)
├── 📂 Data_limpia/           → 6 archivos CSV procesados y listos para el DWH (~41,200 registros)
├── 📂 ETL/                   → Notebook de Google Colab con el proceso ETL completo
├── 📂 Diagramas/             → Diagramas draw.io de arquitectura y modelo estrella
├── 📂 Power BI/              → Archivo .pbix del dashboard interactivo
└── README.md                  → Este archivo
```

---

## Fuentes de Datos

| Fuente | Tipo | Registros |
|--------|------|-----------|
| VMT Tarifario (`tarifariociudadano.vmt.gob.sv`) | Excel .xlsx | 1,430 |
| VMT Paradas AMSS (`consultamapautt.vmt.gob.sv`) | Shapefile | 9,354 |
| VMT Rutas Urbanas | Shapefile | 864 |
| VMT Rutas Interurbanas | Shapefile | 900 |
| VMT Rutas Interdepartamentales | Shapefile | 619 |
| VMT Transporte Colectivo SV | Shapefile | 2,383 |
| OPAMSS Atlas Metropolitano | PDF / tablas | 14 municipios |

---

## Tecnologías Utilizadas

- **ETL:** Python 3 · pandas · Google Colab
- **Data Warehouse:** SQL Server 2019+
- **Visualización:** Power BI Desktop / Power BI Service
- **Diagramas:** draw.io
- **Control de versiones:** Git / GitHub

---

## Cómo ejecutar el ETL

1. Asegurarse de que los archivos de `Datos_crudos/` estén commiteados en el repositorio
2. Abrir el notebook `ETL/ETL_BI_AMSS.ipynb` en Google Colab
3. Ejecutar todas las celdas en orden (los CSV se cargan automáticamente desde GitHub)
4. Descargar los CSV limpios generados al final del notebook
5. Subirlos a la carpeta `Data_limpia/` del repositorio
6. Cargar los CSV limpios a SQL Server.

---

## KPIs del Dashboard

1. Tarifa promedio por kilómetro recorrido
2. Número de rutas por municipio (índice de cobertura)
3. Diferencia tarifaria Autobús vs Microbús
4. Cobertura de frecuencias por período y tipo de día
5. Porcentaje de paradas con cobertura de retorno
6. Frecuencia promedio de servicio por zona AMSS

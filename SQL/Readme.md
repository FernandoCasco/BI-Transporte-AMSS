# SQL — Data Warehouse y cubo analítico

Scripts del Data Warehouse en SQL Server.

| Archivo | Descripción |
|---|---|
| `DWH_AMSS.sql` | Creación de la base `DWH_Transporte_AMSS`, las 8 tablas del modelo estrella (1 hecho + 7 dimensiones) y la carga de datos (BULK INSERT + INSERT manual). |
| `Consultas SQL y métricas.sql` | Cubo analítico: 6 vistas SQL (una por KPI) con sus consultas de explotación. |

**Orden de ejecución:** primero `DWH_AMSS.sql` (crear y cargar), luego `Consultas SQL y métricas.sql` (crear vistas y consultar).

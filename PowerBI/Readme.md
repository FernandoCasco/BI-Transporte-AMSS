# Power BI

Esta carpeta contiene el **archivo del dashboard interactivo** desarrollado en Power BI Desktop, conectado al Data Warehouse en SQL Server.

---

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `Dashboard_AMSS.pbix` | Reporte Power BI con los 6 KPIs y visualizaciones del sistema de transporte AMSS |

---

## Páginas del Dashboard

| Página | Visualizaciones principales |
|--------|-----------------------------|
| **Resumen General** | 6 tarjetas KPI con semáforo de meta, filtros globales |
| **Cobertura Geográfica** | Mapa de paradas por municipio, rutas activas por zona AMSS |
| **Análisis Tarifario** | Comparativa AB vs MB, tarifa promedio por km, ranking de rutas |
| **Frecuencias y Horarios** | Heatmap período × tipo de día, déficit nocturno y dominical |
| **Detalle por Ruta** | Drill-through por ruta: paradas, tarifa, cobertura de retorno |

---

## Conexión a SQL Server

El archivo `.pbix` está configurado para conectarse a:
- **Servidor:** `localhost` (o el servidor SQL Server del equipo)
- **Base de datos:** `DWH_Transporte_AMSS`
- **Autenticación:** Windows Authentication

> Si la conexión falla al abrir el archivo, ir a `Inicio → Transformar datos → Configuración del origen de datos` y actualizar el servidor.

---

## Publicación

El dashboard fue publicado en Power BI Service. Enlace de acceso:  
🔗 **[Agregar enlace aquí una vez publicado]**


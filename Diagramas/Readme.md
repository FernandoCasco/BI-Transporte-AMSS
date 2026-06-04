# Diagramas

Esta carpeta contiene los **diagramas técnicos del proyecto** en formato draw.io (`.xml`), editables y listos para exportar como imagen.

---

## Archivos

| Archivo | Sección | Descripción |
|---------|---------|-------------|
| `Arquitectura_31_AMSS.xml` | 3.1 | Flujo completo de la arquitectura: Fuentes → ETL → DWH → Cubo → Power BI |
| `ModeloEstrella_33_AMSS.xml` | 3.3 | Esquema estrella con FACT y 5 dimensiones, campos y tipos de dato SQL |

---

##  Cómo abrir en draw.io

**Opción A — Web (sin instalar nada)**
1. Ir a [app.diagrams.net](https://app.diagrams.net)
2. `Extras → Edit Diagram` (`Ctrl+Shift+X`)
3. Pegar el contenido del archivo `.xml` → **OK**

**Opción B — Importar archivo**
1. Ir a [app.diagrams.net](https://app.diagrams.net)
2. `File → Import from → Device`
3. Seleccionar el archivo `.xml`

---

## Contenido de cada diagrama

### `Arquitectura_31_AMSS.xml`
- 5 capas con código de colores: Fuentes (azul oscuro) · ETL Python (verde) · DWH SQL Server (café) · Cubo Analítico (morado) · Power BI (naranja)
- Detalle de componentes, herramientas y volumen de datos en cada capa
- Flechas etiquetadas con el tipo de operación entre capas

### `ModeloEstrella_33_AMSS.xml`
- `FACT_Parada_Servicio` en el centro con todos sus campos y tipos de dato SQL
- 5 dimensiones posicionadas en cruz: `DIM_Tiempo` (arriba), `DIM_Ruta` (izquierda), `DIM_Parada` (derecha), `DIM_Municipio` (abajo), `DIM_TipoUnidad` (abajo-derecha)
- Relaciones N:1 con notación de cardinalidad
- Volumen de registros por tabla


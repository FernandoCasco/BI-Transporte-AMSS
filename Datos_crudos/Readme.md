# Datos crudos

Archivos CSV originales extraídos de las fuentes del VMT y la OPAMSS, **antes** del proceso ETL. Contienen los errores e inconsistencias documentados (nulos, duplicados, problemas de codificación y escala).

| Archivo | Contenido | Registros |
|---|---|---|
| FACT_Parada_Servicio.csv | Servicios: parada × tipo de día × período × hora | 45,229 |
| DIM_Parada.csv | Paradas georreferenciadas | 9,354 |
| DIM_Ruta.csv | Rutas y atributos operativos | 1,188 |
| DIM_Tarifa.csv | Tarifario por ruta y tipo de unidad | 1,430 |
| DIM_Municipio.csv | Municipios del AMSS | 14 |
| DIM_Departamento.csv | Límites departamentales | 15 |
| **Total** | | **57,230** |

> Estos archivos son la entrada del notebook de la carpeta `ETL/`.

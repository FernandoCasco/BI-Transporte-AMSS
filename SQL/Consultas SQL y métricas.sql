USE DWH_Transporte_AMSS;
GO

-- ══════════════════════════════════════════════════════════════
-- 4.3 CUBO ANALÍTICO — Vistas SQL por KPI
-- ══════════════════════════════════════════════════════════════

-- ── KPI 1: Tarifa promedio por kilómetro recorrido ───────────
CREATE VIEW V_KPI1_Tarifa_Por_Km AS
SELECT
    f.Codigo_Ruta,
    f.Tipo_Unidad,
    AVG(f.Tarifa_USD)                                  AS Tarifa_Promedio,
    AVG(r.Km_Recorrido)                                AS Km_Promedio,
    CASE 
        WHEN AVG(r.Km_Recorrido) > 0 
        THEN ROUND(AVG(f.Tarifa_USD) / AVG(r.Km_Recorrido), 4)
        ELSE NULL 
    END                                                AS Tarifa_Por_Km
FROM FACT_Parada_Servicio f
LEFT JOIN DIM_Ruta r ON f.Codigo_Ruta = r.Codigo_Ruta
WHERE r.Km_Recorrido > 0
GROUP BY f.Codigo_Ruta, f.Tipo_Unidad;
GO


-- ── KPI 2: Número de rutas por municipio ─────────────────────
CREATE VIEW V_KPI2_Rutas_Por_Municipio AS
SELECT
    Municipio,
    Departamento,
    COUNT(DISTINCT Codigo_Ruta)                         AS Total_Rutas,
    COUNT(DISTINCT CASE WHEN Tipo_Unidad = 'AUTOBUS'  THEN Codigo_Ruta END) AS Rutas_Autobus,
    COUNT(DISTINCT CASE WHEN Tipo_Unidad = 'MICROBUS' THEN Codigo_Ruta END) AS Rutas_Microbus,
    CASE
        WHEN COUNT(DISTINCT Codigo_Ruta) >= 5 THEN 'Cobertura Alta'
        WHEN COUNT(DISTINCT Codigo_Ruta) >= 3 THEN 'Cobertura Media'
        ELSE 'Cobertura Crítica'
    END                                                 AS Nivel_Cobertura
FROM FACT_Parada_Servicio
GROUP BY Municipio, Departamento;
GO

-- ── KPI 3: Diferencia tarifaria Autobús vs Microbús ──────────
CREATE VIEW V_KPI3_Tarifa_AB_vs_MB AS
SELECT
    Departamento,
    ISNULL(CAST(ROUND(AVG(CASE WHEN Tipo_Unidad = 'AUTOBUS'  THEN Tarifa_USD END), 2) AS VARCHAR), 'N/A') AS Tarifa_Autobus,
    ISNULL(CAST(ROUND(AVG(CASE WHEN Tipo_Unidad = 'MICROBUS' THEN Tarifa_USD END), 2) AS VARCHAR), 'N/A') AS Tarifa_Microbus,
    CASE
        WHEN AVG(CASE WHEN Tipo_Unidad = 'AUTOBUS'  THEN Tarifa_USD END) IS NULL THEN 'Solo Microbús'
        WHEN AVG(CASE WHEN Tipo_Unidad = 'MICROBUS' THEN Tarifa_USD END) IS NULL THEN 'Solo Autobús'
        WHEN ABS(AVG(CASE WHEN Tipo_Unidad = 'AUTOBUS'  THEN Tarifa_USD END) -
                 AVG(CASE WHEN Tipo_Unidad = 'MICROBUS' THEN Tarifa_USD END)) <= 0.05
        THEN 'Equitativo'
        WHEN ABS(AVG(CASE WHEN Tipo_Unidad = 'AUTOBUS'  THEN Tarifa_USD END) -
                 AVG(CASE WHEN Tipo_Unidad = 'MICROBUS' THEN Tarifa_USD END)) <= 0.10
        THEN 'Diferencia Moderada'
        ELSE 'Inequidad Tarifaria'
    END                                                                     AS Evaluacion
FROM FACT_Parada_Servicio
WHERE Tarifa_USD IS NOT NULL
GROUP BY Departamento;
GO

-- ── KPI 4: Cobertura de frecuencias por período y tipo de día 
CREATE VIEW V_KPI4_Cobertura_Frecuencias AS
SELECT
    Tipo_Dia,
    Periodo_Dia,
    COUNT(*)                                           AS Total_Registros,
    SUM(CASE WHEN Frecuencia_Min IS NOT NULL THEN 1 ELSE 0 END) AS Con_Frecuencia,
    SUM(CASE WHEN Frecuencia_Min IS NULL     THEN 1 ELSE 0 END) AS Sin_Frecuencia,
    ROUND(
        100.0 * SUM(CASE WHEN Frecuencia_Min IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)
    , 1)                                               AS Pct_Cobertura,
    CASE
        WHEN ROUND(100.0 * SUM(CASE WHEN Frecuencia_Min IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) >= 80
        THEN 'Cobertura Adecuada'
        WHEN ROUND(100.0 * SUM(CASE WHEN Frecuencia_Min IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) >= 50
        THEN 'Cobertura Parcial'
        ELSE 'Déficit de Servicio'
    END                                                AS Estado
FROM FACT_Parada_Servicio
GROUP BY Tipo_Dia, Periodo_Dia;
GO

-- ── KPI 5: Porcentaje de paradas con cobertura de retorno ────
CREATE VIEW V_KPI5_Cobertura_Retorno AS
SELECT
    Municipio,
    COUNT(*)                                           AS Total_Paradas,
    SUM(CASE WHEN Sentido = 'I' THEN 1 ELSE 0 END)    AS Paradas_Ida,
    SUM(CASE WHEN Sentido = 'R' THEN 1 ELSE 0 END)    AS Paradas_Retorno,
    ROUND(
        100.0 * SUM(CASE WHEN Sentido = 'R' THEN 1 ELSE 0 END) / COUNT(*)
    , 1)                                               AS Pct_Retorno,
    CASE
        WHEN ROUND(100.0 * SUM(CASE WHEN Sentido = 'R' THEN 1 ELSE 0 END) / COUNT(*), 1) >= 90
        THEN 'Cobertura Completa'
        WHEN ROUND(100.0 * SUM(CASE WHEN Sentido = 'R' THEN 1 ELSE 0 END) / COUNT(*), 1) >= 70
        THEN 'Cobertura Parcial'
        ELSE 'Déficit de Retorno'
    END                                                AS Estado
FROM FACT_Parada_Servicio
GROUP BY Municipio;
GO

-- ── KPI 6: Frecuencia promedio por zona AMSS ─────────────────
CREATE VIEW V_KPI6_Frecuencia_Por_Zona AS
SELECT
    Municipio,
    Departamento,
    Tipo_Dia,
    Periodo_Dia,
    COUNT(DISTINCT Codigo_Ruta)                         AS Total_Rutas,
    ROUND(AVG(CAST(Frecuencia_Min AS FLOAT)), 1)        AS Frecuencia_Promedio_Min,
    CASE
        WHEN AVG(CAST(Frecuencia_Min AS FLOAT)) <= 20 THEN 'Frecuencia Alta'
        WHEN AVG(CAST(Frecuencia_Min AS FLOAT)) <= 45 THEN 'Frecuencia Media'
        ELSE 'Frecuencia Baja'
    END                                                 AS Nivel_Frecuencia
FROM FACT_Parada_Servicio
WHERE Frecuencia_Min IS NOT NULL
GROUP BY Municipio, Departamento, Tipo_Dia, Periodo_Dia;
GO


-- KPI 1: Tarifa por km
SELECT TOP 5 * FROM V_KPI1_Tarifa_Por_Km
ORDER BY Tarifa_Por_Km DESC;

-- KPI 2: Rutas por municipio
SELECT * FROM V_KPI2_Rutas_Por_Municipio
ORDER BY Total_Rutas DESC;

-- KPI 3: Diferencia tarifaria AB vs MB
SELECT * FROM V_KPI3_Tarifa_AB_vs_MB 
ORDER BY Departamento;

--KPI 4: Cobertura de frecuencias
SELECT * FROM V_KPI4_Cobertura_Frecuencias
ORDER BY Tipo_Dia, Periodo_Dia;

--KPI 5: Cobertura de retorno
SELECT TOP 5 * FROM V_KPI5_Cobertura_Retorno
ORDER BY Pct_Retorno ASC;

--KPI 6: Frecuencia por zona
SELECT TOP 8 * FROM V_KPI6_Frecuencia_Por_Zona 
ORDER BY Municipio, Tipo_Dia;

-- ══════════════════════════════════════════════════════════════════════
-- DWH_Transporte_AMSS — Script Final Actualizado
-- Sistema BI Transporte Público Colectivo AMSS
-- Estructura real verificada en SQL Server
-- ══════════════════════════════════════════════════════════════════════

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DWH_Transporte_AMSS')
BEGIN
    ALTER DATABASE DWH_Transporte_AMSS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DWH_Transporte_AMSS;
END
GO

CREATE DATABASE DWH_Transporte_AMSS;
GO

USE DWH_Transporte_AMSS;
GO

-- ══════════════════════════════════════════════════════════════════════
-- DIMENSIONES
-- ══════════════════════════════════════════════════════════════════════

-- ── DIM_Departamento ──────────────────────────────────────────────────
-- Fuente: Shapefile VMT Límites Departamentales
-- Registros: 15
CREATE TABLE DIM_Departamento (
    FCODE       VARCHAR(10),
    COD         INT,
    NA2         VARCHAR(80),
    NA3         VARCHAR(10),        -- VARCHAR para aceptar valor 'N_A'
    NAM         VARCHAR(80),
    AREA_KM     DECIMAL(10,4),
    PERIMETRO   DECIMAL(10,4),
    Shape_Leng  DECIMAL(15,10),
    Shape_Area  DECIMAL(15,10)
);
GO

-- ── DIM_Municipio ─────────────────────────────────────────────────────
-- Fuente: OPAMSS Atlas Metropolitano
-- Registros: 14 municipios del AMSS
CREATE TABLE DIM_Municipio (
    ID_Municipio    INT             PRIMARY KEY,
    Municipio       VARCHAR(80)     NOT NULL,
    Departamento    VARCHAR(80),
    Area_Km2        DECIMAL(8,2),
    Poblacion_2024  INT,
    Zona_AMSS       VARCHAR(20)
);
GO

-- ── DIM_Parada ────────────────────────────────────────────────────────
-- Fuente: Shapefile VMT Paradas Transporte Colectivo AMSS
-- Registros: 9,353
CREATE TABLE DIM_Parada (
    FID_L0Coor      INT,
    Ruta            VARCHAR(50),
    Cod             VARCHAR(5),
    Parada_PGO      VARCHAR(500),
    Latitud         DECIMAL(15,10),
    Longitud        DECIMAL(15,10),
    NA2             VARCHAR(80),
    NAM             VARCHAR(80),
    Municipio       VARCHAR(80),
    Municipio_AMSS  VARCHAR(80)     -- Agregado: municipio del AMSS asignado por ruta
);
GO

-- ── DIM_Ruta ──────────────────────────────────────────────────────────
-- Fuente: Shapefiles VMT (Rutas Urbanas + Interurbanas + Interdepartamentales)
-- Registros: 1,178
CREATE TABLE DIM_Ruta (
    Codigo_Ruta     VARCHAR(50),
    Numero_Ruta     VARCHAR(100),
    Sentido         VARCHAR(20),
    Tipo_Unidad     VARCHAR(50),
    Subtipo         VARCHAR(50),
    Departamento    VARCHAR(80),
    Km_Recorrido    DECIMAL(8,2),
    Cantidad_Dias   INT,
    Tarifa_USD      DECIMAL(5,2)
);
GO

-- ── DIM_Tarifa ────────────────────────────────────────────────────────
-- Fuente: Excel VMT Tarifario Ciudadano
-- Registros: 1,430
CREATE TABLE DIM_Tarifa (
    Codigo_Ruta VARCHAR(50),
    Tarifa_USD  DECIMAL(5,2),
    Tipo_Unidad VARCHAR(10)
);
GO

-- ── DIM_Tiempo ────────────────────────────────────────────────────────
-- Fuente: Generada manualmente
-- Registros: 12 (3 tipos de día × 4 períodos)
CREATE TABLE DIM_Tiempo (
    ID_Tiempo   INT IDENTITY(1,1)  PRIMARY KEY,
    Tipo_Dia    VARCHAR(10)         NOT NULL,
    Periodo_Dia VARCHAR(20)         NOT NULL,
    Hora_Inicio TIME,
    Hora_Fin    TIME
);
GO

-- ── DIM_TipoUnidad ────────────────────────────────────────────────────
-- Fuente: Generada manualmente
-- Registros: 2 (AUTOBUS / MICROBUS)
CREATE TABLE DIM_TipoUnidad (
    ID_TipoUnidad   INT IDENTITY(1,1)  PRIMARY KEY,
    Tipo            VARCHAR(10)         NOT NULL,
    Prefijo_Codigo  CHAR(2)             NOT NULL,
    Descripcion     VARCHAR(100)
);
GO

-- ══════════════════════════════════════════════════════════════════════
-- TABLA DE HECHOS
-- ══════════════════════════════════════════════════════════════════════

-- ── FACT_Parada_Servicio ──────────────────────────────────────────────
-- Granularidad: parada × tipo de día × período del día × hora de salida
-- Registros: 44,191
CREATE TABLE FACT_Parada_Servicio (
    ID_Servicio     INT IDENTITY(1,1)  PRIMARY KEY,
    Codigo_Ruta     VARCHAR(50),
    Tipo_Unidad     VARCHAR(10),
    Parada          VARCHAR(500),
    Sentido         CHAR(1),
    Municipio_AMSS  VARCHAR(80),       -- Municipio del AMSS (14 municipios)
    Departamento    VARCHAR(80),
    Latitud         DECIMAL(15,10),
    Longitud        DECIMAL(15,10),
    Tipo_Dia        VARCHAR(10),
    Periodo_Dia     VARCHAR(20),
    Hora_Salida     TIME,
    Frecuencia_Min  DECIMAL(5,1),
    Tarifa_USD      DECIMAL(5,2)
);
GO

-- ══════════════════════════════════════════════════════════════════════
-- CARGA DE DATOS
-- Nota: Ajustar la ruta según el equipo donde se ejecute
-- ══════════════════════════════════════════════════════════════════════

BULK INSERT DIM_Departamento
FROM 'C:\Users\ADMIN\Desktop\AMSS\DATOS_LIMPIOS\DIM_Departamento_clean.csv'
WITH ( FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', FIRSTROW=2, TABLOCK, CODEPAGE='65001' );
PRINT 'DIM_Departamento: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros';
GO

BULK INSERT DIM_Municipio
FROM 'C:\Users\ADMIN\Desktop\AMSS\DATOS_LIMPIOS\DIM_Municipio_clean.csv'
WITH ( FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', FIRSTROW=2, TABLOCK, CODEPAGE='65001' );
PRINT 'DIM_Municipio: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros';
GO

BULK INSERT DIM_Parada
FROM 'C:\Users\ADMIN\Desktop\AMSS\DATOS_LIMPIOS\DIM_Parada_clean.csv'
WITH ( FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', FIRSTROW=2, TABLOCK, CODEPAGE='65001' );
PRINT 'DIM_Parada: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros';
GO

BULK INSERT DIM_Ruta
FROM 'C:\Users\ADMIN\Desktop\AMSS\DATOS_LIMPIOS\DIM_Ruta_clean.csv'
WITH ( FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', FIRSTROW=2, TABLOCK, CODEPAGE='65001' );
PRINT 'DIM_Ruta: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros';
GO

BULK INSERT DIM_Tarifa
FROM 'C:\Users\ADMIN\Desktop\AMSS\DATOS_LIMPIOS\DIM_Tarifa_clean.csv'
WITH ( FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', FIRSTROW=2, TABLOCK, CODEPAGE='65001' );
PRINT 'DIM_Tarifa: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros';
GO

-- ── FACT_Parada_Servicio: usar Importar archivo plano en SSMS ─────────
-- El archivo CSV debe cargarse con el wizard "Importar archivo plano"
-- con los siguientes tipos de dato:
--   Parada          → nvarchar(500)
--   Frecuencia_Min  → int
--   Tarifa_USD      → float
--   Municipio_AMSS  → nvarchar(80)
-- Luego ejecutar INSERT INTO FACT_Parada_Servicio SELECT ... FROM tabla_import

-- ── DIM_Tiempo manual ─────────────────────────────────────────────────
INSERT INTO DIM_Tiempo (Tipo_Dia, Periodo_Dia, Hora_Inicio, Hora_Fin) VALUES
('Hábil',   'Mañana',   '05:00', '09:00'),
('Hábil',   'Mediodia', '09:00', '13:00'),
('Hábil',   'Tarde',    '13:00', '18:00'),
('Hábil',   'Noche',    '18:00', '22:00'),
('Sábado',  'Mañana',   '05:00', '09:00'),
('Sábado',  'Mediodia', '09:00', '13:00'),
('Sábado',  'Tarde',    '13:00', '18:00'),
('Sábado',  'Noche',    '18:00', '22:00'),
('Domingo', 'Mañana',   '05:00', '09:00'),
('Domingo', 'Mediodia', '09:00', '13:00'),
('Domingo', 'Tarde',    '13:00', '18:00'),
('Domingo', 'Noche',    '18:00', '22:00');
PRINT 'DIM_Tiempo: 12 registros';
GO

-- ── DIM_TipoUnidad manual ─────────────────────────────────────────────
INSERT INTO DIM_TipoUnidad (Tipo, Prefijo_Codigo, Descripcion) VALUES
('AUTOBUS',  'AB', 'Autobús de transporte colectivo urbano e interurbano'),
('MICROBUS', 'MB', 'Microbús de transporte colectivo urbano e interurbano');
PRINT 'DIM_TipoUnidad: 2 registros';
GO

-- ══════════════════════════════════════════════════════════════════════
-- CORRECCIONES APLICADAS DURANTE LA CARGA
-- (documentadas para reproducibilidad)
-- ══════════════════════════════════════════════════════════════════════

-- Corregir Tarifa_USD multiplicada por 100
-- UPDATE FACT_Parada_Servicio SET Tarifa_USD = Tarifa_USD / 100.0;

-- Corregir registros con tarifa < $0.10 (división doble)
-- UPDATE FACT_Parada_Servicio SET Tarifa_USD = Tarifa_USD * 10.0 WHERE Tarifa_USD < 0.10;

-- Corregir Frecuencia_Min multiplicada por 10
-- UPDATE FACT_Parada_Servicio SET Frecuencia_Min = Frecuencia_Min / 10.0;

-- Corregir coordenadas con divisor incorrecto
-- UPDATE FACT_Parada_Servicio SET Latitud = Latitud / 10.0 WHERE Latitud > 90;
-- UPDATE FACT_Parada_Servicio SET Longitud = Longitud / 10.0 WHERE Longitud < -180;

-- ══════════════════════════════════════════════════════════════════════
-- VERIFICACIÓN FINAL
-- ══════════════════════════════════════════════════════════════════════
SELECT 'DIM_Departamento'    AS Tabla, COUNT(*) AS Registros FROM DIM_Departamento    UNION ALL
SELECT 'DIM_Municipio',                COUNT(*)               FROM DIM_Municipio       UNION ALL
SELECT 'DIM_Parada',                   COUNT(*)               FROM DIM_Parada          UNION ALL
SELECT 'DIM_Ruta',                     COUNT(*)               FROM DIM_Ruta            UNION ALL
SELECT 'DIM_Tarifa',                   COUNT(*)               FROM DIM_Tarifa          UNION ALL
SELECT 'DIM_Tiempo',                   COUNT(*)               FROM DIM_Tiempo          UNION ALL
SELECT 'DIM_TipoUnidad',               COUNT(*)               FROM DIM_TipoUnidad      UNION ALL
SELECT 'FACT_Parada_Servicio',         COUNT(*)               FROM FACT_Parada_Servicio
ORDER BY Tabla;

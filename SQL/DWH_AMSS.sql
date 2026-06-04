CREATE DATABASE DWH_Transporte_AMSS;
GO

USE DWH_Transporte_AMSS;
GO

-- DIMENSIONES

-- DIM_Departamento 
-- CSV: FCODE, COD, NA2, NA3, NAM, AREA_KM, PERIMETRO, Shape_Leng, Shape_Area
CREATE TABLE DIM_Departamento (
    FCODE       VARCHAR(10),
    COD         INT,
    NA2         VARCHAR(80),
    NA3         INT,
    NAM         VARCHAR(80),
    AREA_KM     DECIMAL(10,4),
    PERIMETRO   DECIMAL(10,4),
    Shape_Leng  DECIMAL(15,10),
    Shape_Area  DECIMAL(15,10)
);
GO

-- DIM_Municipio 
-- CSV: ID_Municipio, Municipio, Departamento, Area_Km2, Poblacion_2024, Zona_AMSS
CREATE TABLE DIM_Municipio (
    ID_Municipio    INT             PRIMARY KEY,
    Municipio       VARCHAR(80)     NOT NULL,
    Departamento    VARCHAR(80),
    Area_Km2        DECIMAL(8,2),
    Poblacion_2024  INT,
    Zona_AMSS       VARCHAR(20)
);
GO

-- DIM_Parada 
-- CSV: FID_L0Coor, Ruta, Cod, Parada_PGO, Latitud, Longitud, NA2, NAM, Municipio
CREATE TABLE DIM_Parada (
    FID_L0Coor  INT,
    Ruta        VARCHAR(50),
    Cod         VARCHAR(5),
    Parada_PGO  VARCHAR(500),
    Latitud     DECIMAL(15,10),
    Longitud    DECIMAL(15,10),
    NA2         VARCHAR(80),
    NAM         VARCHAR(80),
    Municipio   VARCHAR(80)
);
GO

-- DIM_Ruta 
-- CSV: Codigo_Ruta, Numero_Ruta, Sentido, Tipo_Unidad, Subtipo, Departamento, Km_Recorrido, Cantidad_Dias, Tarifa_USD
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

-- DIM_Tarifa 
-- CSV: Codigo_Ruta, Tarifa_USD, Tipo_Unidad
CREATE TABLE DIM_Tarifa (
    Codigo_Ruta VARCHAR(50),
    Tarifa_USD  DECIMAL(5,2),
    Tipo_Unidad VARCHAR(10)
);
GO

-- DIM_Tiempo 
-- Insertada manualmente (no viene en CSV)
CREATE TABLE DIM_Tiempo (
    ID_Tiempo   INT IDENTITY(1,1) PRIMARY KEY,
    Tipo_Dia    VARCHAR(10) NOT NULL,
    Periodo_Dia VARCHAR(20) NOT NULL,
    Hora_Inicio TIME,
    Hora_Fin    TIME
);
GO

-- DIM_TipoUnidad 
-- Insertada manualmente (no viene en CSV)
CREATE TABLE DIM_TipoUnidad (
    ID_TipoUnidad   INT IDENTITY(1,1) PRIMARY KEY,
    Tipo            VARCHAR(10)  NOT NULL,
    Prefijo_Codigo  CHAR(2)      NOT NULL,
    Descripcion     VARCHAR(100)
);
GO

-- TABLA DE HECHOS

-- CSV: ID_Servicio, Codigo_Ruta, Tipo_Unidad, Parada, Sentido, Municipio,
--      Departamento, Latitud, Longitud, Tipo_Dia, Periodo_Dia, Hora_Salida,
--      Frecuencia_Min, Tarifa_USD

CREATE TABLE FACT_Parada_Servicio (
    ID_Servicio     INT             PRIMARY KEY,
    Codigo_Ruta     VARCHAR(50),
    Tipo_Unidad     VARCHAR(10),
    Parada          VARCHAR(500),
    Sentido         CHAR(1),
    Municipio       VARCHAR(80),
    Departamento    VARCHAR(80),
    Latitud         DECIMAL(15,10),
    Longitud        DECIMAL(15,10),
    Tipo_Dia        VARCHAR(10),
    Periodo_Dia     VARCHAR(20),
    Hora_Salida     TIME,
    Frecuencia_Min  INT,
    Tarifa_USD      DECIMAL(5,2)
);
GO

-- CARGA DE DATOS — BULK INSERT

-- Corregir NA3 a VARCHAR para aceptar N_A
ALTER TABLE DIM_Departamento
ALTER COLUMN NA3 VARCHAR(10);
GO

BULK INSERT DIM_Departamento
FROM 'C:\Users\ADMIN\Desktop\AMSS\DATOS_LIMPIOS\DIM_Departamento_clean.csv'
WITH ( FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', FIRSTROW=2, TABLOCK, CODEPAGE='65001' );
PRINT 'DIM_Departamento cargada: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros';
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

-- Cambiar Frecuencia_Min a DECIMAL para aceptar 12.0
ALTER TABLE FACT_Parada_Servicio
ALTER COLUMN Frecuencia_Min DECIMAL(5,1);
GO

-- Cargar la FACT
BULK INSERT FACT_Parada_Servicio
FROM 'C:\Users\ADMIN\Desktop\AMSS\DATOS_LIMPIOS\FACT_Parada_Servicio_clean.csv'
WITH ( FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', FIRSTROW=2, TABLOCK, CODEPAGE='65001' );
PRINT 'FACT_Parada_Servicio: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros';
GO

-- DIM_Tiempo manual
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

-- DIM_TipoUnidad manual
INSERT INTO DIM_TipoUnidad (Tipo, Prefijo_Codigo, Descripcion) VALUES
('AUTOBUS',  'AB', 'Autobús de transporte colectivo urbano e interurbano'),
('MICROBUS', 'MB', 'Microbús de transporte colectivo urbano e interurbano');
PRINT 'DIM_TipoUnidad: 2 registros';
GO

-- Verificación final
SELECT 'DIM_Departamento'    AS Tabla, COUNT(*) AS Registros FROM DIM_Departamento    UNION ALL
SELECT 'DIM_Municipio',                COUNT(*)               FROM DIM_Municipio       UNION ALL
SELECT 'DIM_Parada',                   COUNT(*)               FROM DIM_Parada          UNION ALL
SELECT 'DIM_Ruta',                     COUNT(*)               FROM DIM_Ruta            UNION ALL
SELECT 'DIM_Tarifa',                   COUNT(*)               FROM DIM_Tarifa          UNION ALL
SELECT 'DIM_Tiempo',                   COUNT(*)               FROM DIM_Tiempo          UNION ALL
SELECT 'DIM_TipoUnidad',               COUNT(*)               FROM DIM_TipoUnidad      UNION ALL
SELECT 'FACT_Parada_Servicio',         COUNT(*)               FROM FACT_Parada_Servicio
ORDER BY Tabla;
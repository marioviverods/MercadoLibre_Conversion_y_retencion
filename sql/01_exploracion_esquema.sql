-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 1: Exploración del esquema y del flujo de usuario
-- ============================================================

-- 1.1 Vista previa de la tabla del embudo
--     Objetivo: conocer columnas y tipo de datos de mercadolibre_funnel
SELECT *
FROM mercadolibre_funnel
LIMIT 5;

-- 1.2 Vista previa de la tabla de retención
--     Objetivo: conocer columnas y tipo de datos de mercadolibre_retention
SELECT *
FROM mercadolibre_retention
LIMIT 5;

-- 1.3 Tipos de evento únicos
--     Objetivo: confirmar la secuencia del embudo
--               (de first_visit a purchase)
SELECT DISTINCT event_name
FROM mercadolibre_funnel
ORDER BY event_name;

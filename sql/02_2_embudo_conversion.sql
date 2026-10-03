-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 2.2: Porcentaje de conversión de cada etapa
--            respecto a first_visit
-- Periodo: 2025-01-01 a 2025-08-31
-- Lógica: se reutilizan las CTEs por etapa (usuarios únicos),
--         se cuentan en funnel_counts y se calcula
--         etapa actual * 100.0 / usuarios_first_visit.
--         NULLIF evita la división entre cero.
-- ============================================================

WITH first_visit AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'first_visit'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
select_item AS (
  -- Esta etapa incluye select_item y select_promotion
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name IN ('select_item', 'select_promotion')
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_to_cart AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'add_to_cart'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
begin_checkout AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'begin_checkout'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_shipping_info AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'add_shipping_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_payment_info AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'add_payment_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
purchase AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'purchase'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
funnel_counts AS (
  SELECT
    COUNT(fv.user_id)  AS usuarios_first_visit,
    COUNT(si.user_id)  AS usuarios_select_item,
    COUNT(a.user_id)   AS usuarios_add_to_cart,
    COUNT(bc.user_id)  AS usuarios_begin_checkout,
    COUNT(asi.user_id) AS usuarios_add_shipping_info,
    COUNT(api.user_id) AS usuarios_add_payment_info,
    COUNT(p.user_id)   AS usuarios_purchase
  FROM first_visit fv
  LEFT JOIN select_item si        ON fv.user_id = si.user_id
  LEFT JOIN add_to_cart a         ON fv.user_id = a.user_id
  LEFT JOIN begin_checkout bc     ON fv.user_id = bc.user_id
  LEFT JOIN add_shipping_info asi ON fv.user_id = asi.user_id
  LEFT JOIN add_payment_info api  ON fv.user_id = api.user_id
  LEFT JOIN purchase p            ON fv.user_id = p.user_id
)
SELECT
  ROUND(usuarios_select_item * 100.0 / NULLIF(usuarios_first_visit, 0), 2)
    AS conversion_select_item,
  ROUND(usuarios_add_to_cart * 100.0 / NULLIF(usuarios_first_visit, 0), 2)
    AS conversion_add_to_cart,
  ROUND(usuarios_begin_checkout * 100.0 / NULLIF(usuarios_first_visit, 0), 2)
    AS conversion_begin_checkout,
  ROUND(usuarios_add_shipping_info * 100.0 / NULLIF(usuarios_first_visit, 0), 2)
    AS conversion_add_shipping_info,
  ROUND(usuarios_add_payment_info * 100.0 / NULLIF(usuarios_first_visit, 0), 2)
    AS conversion_add_payment_info,
  ROUND(usuarios_purchase * 100.0 / NULLIF(usuarios_first_visit, 0), 2)
    AS conversion_purchase
FROM funnel_counts;

-- Resultado (% de usuarios de first_visit que llega a cada etapa):
-- select_item 76.90 | add_to_cart 11.01 | begin_checkout 4.00
-- add_shipping_info 2.42 | add_payment_info 2.09 | purchase 1.25

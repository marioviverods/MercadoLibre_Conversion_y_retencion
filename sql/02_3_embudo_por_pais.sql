-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 2.3: Embudo de conversión segmentado por país
-- Periodo: 2025-01-01 a 2025-08-31
-- Lógica: cada CTE incluye user_id y country; los LEFT JOIN
--         unen por usuario y país, anclados en first_visits;
--         se agrupa por país y se calcula la conversión de cada
--         etapa como % de los usuarios de first_visit.
--         Se ordena por conversion_purchase de mayor a menor.
-- ============================================================

WITH first_visits AS (
  SELECT DISTINCT user_id, country
  FROM mercadolibre_funnel
  WHERE event_name = 'first_visit'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
select_item AS (
  -- Esta etapa incluye select_item y select_promotion
  SELECT DISTINCT user_id, country
  FROM mercadolibre_funnel
  WHERE event_name IN ('select_item', 'select_promotion')
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_to_cart AS (
  SELECT DISTINCT user_id, country
  FROM mercadolibre_funnel
  WHERE event_name = 'add_to_cart'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
begin_checkout AS (
  SELECT DISTINCT user_id, country
  FROM mercadolibre_funnel
  WHERE event_name = 'begin_checkout'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_shipping_info AS (
  SELECT DISTINCT user_id, country
  FROM mercadolibre_funnel
  WHERE event_name = 'add_shipping_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_payment_info AS (
  SELECT DISTINCT user_id, country
  FROM mercadolibre_funnel
  WHERE event_name = 'add_payment_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
purchase AS (
  SELECT DISTINCT user_id, country
  FROM mercadolibre_funnel
  WHERE event_name = 'purchase'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
funnel_counts AS (
  SELECT
    fv.country,
    COUNT(fv.user_id)  AS usuarios_first_visit,
    COUNT(si.user_id)  AS usuarios_select_item,
    COUNT(a.user_id)   AS usuarios_add_to_cart,
    COUNT(bc.user_id)  AS usuarios_begin_checkout,
    COUNT(asi.user_id) AS usuarios_add_shipping_info,
    COUNT(api.user_id) AS usuarios_add_payment_info,
    COUNT(p.user_id)   AS usuarios_purchase
  FROM first_visits fv
  LEFT JOIN select_item si        ON fv.user_id = si.user_id  AND fv.country = si.country
  LEFT JOIN add_to_cart a         ON fv.user_id = a.user_id   AND fv.country = a.country
  LEFT JOIN begin_checkout bc     ON fv.user_id = bc.user_id  AND fv.country = bc.country
  LEFT JOIN add_shipping_info asi ON fv.user_id = asi.user_id AND fv.country = asi.country
  LEFT JOIN add_payment_info api  ON fv.user_id = api.user_id AND fv.country = api.country
  LEFT JOIN purchase p            ON fv.user_id = p.user_id   AND fv.country = p.country
  GROUP BY fv.country
)
SELECT
  country,
  usuarios_select_item * 100.0 / NULLIF(usuarios_first_visit, 0)
    AS conversion_select_item,
  usuarios_add_to_cart * 100.0 / NULLIF(usuarios_first_visit, 0)
    AS conversion_add_to_cart,
  usuarios_begin_checkout * 100.0 / NULLIF(usuarios_first_visit, 0)
    AS conversion_begin_checkout,
  usuarios_add_shipping_info * 100.0 / NULLIF(usuarios_first_visit, 0)
    AS conversion_add_shipping_info,
  usuarios_add_payment_info * 100.0 / NULLIF(usuarios_first_visit, 0)
    AS conversion_add_payment_info,
  usuarios_purchase * 100.0 / NULLIF(usuarios_first_visit, 0)
    AS conversion_purchase
FROM funnel_counts
ORDER BY conversion_purchase DESC;

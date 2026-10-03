-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 2: Embudo de conversión (usuarios únicos por etapa)
-- Periodo: 2025-01-01 a 2025-08-31
-- Lógica: una CTE por etapa con usuarios únicos; se unen con
--         LEFT JOIN encadenados, partiendo de first_visit, para
--         contar solo a los usuarios que llegaron a cada etapa
--         habiendo pasado por todas las anteriores.
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
)
SELECT
    COUNT(fv.user_id)  AS usuarios_first_visit,
    COUNT(si.user_id)  AS usuarios_select_item,
    COUNT(atc.user_id) AS usuarios_add_to_cart,
    COUNT(bc.user_id)  AS usuarios_begin_checkout,
    COUNT(asi.user_id) AS usuarios_add_shipping_info,
    COUNT(api.user_id) AS usuarios_add_payment_info,
    COUNT(p.user_id)   AS usuarios_purchase
FROM first_visit fv
LEFT JOIN select_item si        ON fv.user_id  = si.user_id
LEFT JOIN add_to_cart atc       ON si.user_id  = atc.user_id
LEFT JOIN begin_checkout bc     ON atc.user_id = bc.user_id
LEFT JOIN add_shipping_info asi ON bc.user_id  = asi.user_id
LEFT JOIN add_payment_info api  ON asi.user_id = api.user_id
LEFT JOIN purchase p            ON api.user_id = p.user_id;

-- Resultado:
-- first_visit 1199 | select_item 922 | add_to_cart 132 | begin_checkout 48
-- add_shipping_info 29 | add_payment_info 25 | purchase 15

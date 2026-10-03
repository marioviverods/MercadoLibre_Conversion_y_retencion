-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 3.2: Porcentaje de retención por país (D7, D14, D21, D28)
-- Lógica: usuarios activos acumulados en cada hito, multiplicados
--         por 100.0 y divididos entre el total de usuarios únicos
--         del país. NULLIF evita la división entre cero y
--         ROUND deja 1 decimal.
-- ============================================================

SELECT
  country,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN active = 1 AND day_after_signup >= 7 THEN user_id
    END) * 100.0
    / NULLIF(COUNT(DISTINCT user_id), 0),
  1) AS retention_d7_pct,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN active = 1 AND day_after_signup >= 14 THEN user_id
    END) * 100.0
    / NULLIF(COUNT(DISTINCT user_id), 0),
  1) AS retention_d14_pct,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN active = 1 AND day_after_signup >= 21 THEN user_id
    END) * 100.0
    / NULLIF(COUNT(DISTINCT user_id), 0),
  1) AS retention_d21_pct,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN active = 1 AND day_after_signup >= 28 THEN user_id
    END) * 100.0
    / NULLIF(COUNT(DISTINCT user_id), 0),
  1) AS retention_d28_pct

FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;

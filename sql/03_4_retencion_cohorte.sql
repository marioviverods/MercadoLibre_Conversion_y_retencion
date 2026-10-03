-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 3.4: Retención por cohorte mensual (D7, D14, D21, D28)
-- Periodo: activity_date entre 2025-01-01 y 2025-08-31
-- Lógica: CTE cohort (mes de registro por usuario) + CTE activity
--         (actividad de cada usuario con su cohorte). El SELECT
--         final calcula, por cohorte, el % de usuarios activos
--         acumulados en cada hito sobre el tamaño de la cohorte.
-- ============================================================

WITH cohort AS (
  SELECT
    user_id,
    MIN(signup_date) AS signup_date,
    TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
  FROM mercadolibre_retention
  GROUP BY user_id
),
activity AS (
  SELECT
    r.user_id,
    c.cohort,
    r.day_after_signup,
    r.active
  FROM mercadolibre_retention r
  LEFT JOIN cohort c
    ON r.user_id = c.user_id
  WHERE r.activity_date BETWEEN '2025-01-01' AND '2025-08-31'
)
SELECT
  cohort,
  ROUND(
    100.0 * COUNT(DISTINCT CASE
      WHEN day_after_signup >= 7 AND active = 1 THEN user_id
    END) / NULLIF(COUNT(DISTINCT user_id), 0),
    1
  ) AS retention_d7_pct,
  ROUND(
    100.0 * COUNT(DISTINCT CASE
      WHEN day_after_signup >= 14 AND active = 1 THEN user_id
    END) / NULLIF(COUNT(DISTINCT user_id), 0),
    1
  ) AS retention_d14_pct,
  ROUND(
    100.0 * COUNT(DISTINCT CASE
      WHEN day_after_signup >= 21 AND active = 1 THEN user_id
    END) / NULLIF(COUNT(DISTINCT user_id), 0),
    1
  ) AS retention_d21_pct,
  ROUND(
    100.0 * COUNT(DISTINCT CASE
      WHEN day_after_signup >= 28 AND active = 1 THEN user_id
    END) / NULLIF(COUNT(DISTINCT user_id), 0),
    1
  ) AS retention_d28_pct
FROM activity
GROUP BY cohort
ORDER BY cohort;

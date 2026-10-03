-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 3.3: Definición de la cohorte mensual de registro
-- Lógica: la cohorte de cada usuario es el mes (YYYY-MM) de su
--         primera fecha de registro (MIN(signup_date)).
-- Validación: se muestran solo las primeras 5 filas.
-- ============================================================

SELECT
  user_id,
  MIN(signup_date) AS signup_date,
  TO_CHAR(
    DATE_TRUNC('month', MIN(signup_date)),
    'YYYY-MM'
  ) AS cohort
FROM mercadolibre_retention
GROUP BY user_id
LIMIT 5;

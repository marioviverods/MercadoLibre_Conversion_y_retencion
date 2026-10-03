-- ============================================================
-- Análisis de embudo y retención - MercadoLibre
-- Parte 3.1: Usuarios activos acumulados por país (D7, D14, D21, D28)
-- Periodo: activity_date entre 2025-01-01 y 2025-08-31
-- Definición: un usuario cuenta en D<N> si tiene active = 1 en
--             algún día con day_after_signup >= N.
--             COUNT(DISTINCT ...) evita duplicados.
-- ============================================================

SELECT
  country,

  COUNT(DISTINCT CASE
    WHEN active = 1 AND day_after_signup >= 7 THEN user_id
  END) AS users_d7,

  COUNT(DISTINCT CASE
    WHEN active = 1 AND day_after_signup >= 14 THEN user_id
  END) AS users_d14,

  COUNT(DISTINCT CASE
    WHEN active = 1 AND day_after_signup >= 21 THEN user_id
  END) AS users_d21,

  COUNT(DISTINCT CASE
    WHEN active = 1 AND day_after_signup >= 28 THEN user_id
  END) AS users_d28

FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;

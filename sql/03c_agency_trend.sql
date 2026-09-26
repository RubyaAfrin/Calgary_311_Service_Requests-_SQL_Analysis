WITH yearly AS (
        SELECT agency, request_year,
               PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY resolution_days) AS p90_days
        FROM requests_v
        WHERE NOT is_duplicate
          AND resolution_days IS NOT NULL
        GROUP BY agency, request_year
        HAVING COUNT(*) >= 1000
    )
    SELECT
        agency,
        MAX(p90_days) FILTER (WHERE request_year = 2021) AS p90_2021,
        MAX(p90_days) FILTER (WHERE request_year = 2023) AS p90_2023,
        MAX(p90_days) FILTER (WHERE request_year = 2025) AS p90_2025,
        MAX(p90_days) FILTER (WHERE request_year = 2025)
          - MAX(p90_days) FILTER (WHERE request_year = 2021) AS change_2021_to_2025
    FROM yearly
    GROUP BY agency
    HAVING COUNT(*) = 5              -- only departments with enough data in all five years
    ORDER BY change_2021_to_2025 DESC

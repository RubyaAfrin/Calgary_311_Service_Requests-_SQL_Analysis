WITH yearly AS (
        SELECT current_agency, request_year,
               COUNT(*)                                                      AS closed_requests,
               MEDIAN(resolution_days)                                       AS median_days,
               PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY resolution_days)  AS p90_days
        FROM requests_mapped
        WHERE NOT is_duplicate AND resolution_days IS NOT NULL
        GROUP BY current_agency, request_year
        HAVING COUNT(*) >= 1000
    )
    SELECT
        current_agency,
        MAX(p90_days) FILTER (WHERE request_year = 2021) AS p90_2021,
        MAX(p90_days) FILTER (WHERE request_year = 2023) AS p90_2023,
        MAX(p90_days) FILTER (WHERE request_year = 2025) AS p90_2025,
        MAX(p90_days) FILTER (WHERE request_year = 2025)
          - MAX(p90_days) FILTER (WHERE request_year = 2021) AS change_2021_to_2025
    FROM yearly
    GROUP BY current_agency
    HAVING COUNT(*) = 5
    ORDER BY change_2021_to_2025 DESC

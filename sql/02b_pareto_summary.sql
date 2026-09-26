WITH services AS (
        SELECT service_name, COUNT(*) AS requests
        FROM requests_v
        WHERE NOT is_duplicate
        GROUP BY service_name
    ),
    ranked AS (
        SELECT ROW_NUMBER() OVER (ORDER BY requests DESC) AS rnk,
               100.0 * SUM(requests) OVER (ORDER BY requests DESC
                                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                     / SUM(requests) OVER () AS cumulative_pct
        FROM services
    )
    SELECT
        COUNT(*)                                   AS total_service_types,
        MIN(rnk) FILTER (WHERE cumulative_pct >= 50) AS types_covering_50_pct,
        MIN(rnk) FILTER (WHERE cumulative_pct >= 80) AS types_covering_80_pct
    FROM ranked

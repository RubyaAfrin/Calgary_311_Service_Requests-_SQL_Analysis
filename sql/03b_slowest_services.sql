SELECT
        service_name,
        agency,
        COUNT(*)                                                      AS closed_requests,
        MEDIAN(resolution_days)                                       AS median_days,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY resolution_days)  AS p90_days
    FROM requests_v
    WHERE NOT is_duplicate
      AND resolution_days IS NOT NULL
    GROUP BY service_name, agency
    HAVING COUNT(*) >= 1000
    ORDER BY p90_days DESC
    LIMIT 15

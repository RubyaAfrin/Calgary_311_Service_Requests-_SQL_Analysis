SELECT
        community,
        COUNT(*)                                                      AS closed_requests,
        MEDIAN(resolution_days)                                       AS median_days,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY resolution_days)  AS p90_days
    FROM requests_v
    WHERE NOT is_duplicate AND resolution_days IS NOT NULL AND community IS NOT NULL
    GROUP BY community
    HAVING COUNT(*) >= 2000
    ORDER BY p90_days DESC

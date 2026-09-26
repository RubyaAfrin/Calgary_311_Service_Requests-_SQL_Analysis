SELECT
        agency,
        COUNT(*)                                                         AS closed_requests,
        MEDIAN(resolution_days)                                          AS median_days,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY resolution_days)     AS p90_days,
        ROUND(100.0 * AVG(CASE WHEN resolution_days <= 7 THEN 1 ELSE 0 END), 1) AS pct_closed_within_7_days
    FROM requests_v
    WHERE NOT is_duplicate
      AND resolution_days IS NOT NULL
    GROUP BY agency
    HAVING COUNT(*) >= 5000
    ORDER BY p90_days DESC

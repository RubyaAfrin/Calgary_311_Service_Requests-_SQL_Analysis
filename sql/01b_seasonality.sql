SELECT
        MONTH(requested_at)                                          AS month_num,
        MONTHNAME(requested_at)                                      AS month,
        ROUND(COUNT(*) / COUNT(DISTINCT request_year), 0)            AS avg_requests_per_year
    FROM requests_v
    WHERE NOT is_duplicate
    GROUP BY month_num, month
    ORDER BY month_num

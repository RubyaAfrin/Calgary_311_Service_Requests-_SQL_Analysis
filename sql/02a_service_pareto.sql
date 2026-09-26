WITH services AS (
        SELECT service_name, agency, COUNT(*) AS requests
        FROM requests_v
        WHERE NOT is_duplicate
        GROUP BY service_name, agency
    ),
    ranked AS (
        SELECT *,
               RANK() OVER (ORDER BY requests DESC)                                   AS rnk,
               SUM(requests) OVER (ORDER BY requests DESC
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS running_total,
               SUM(requests) OVER ()                                                  AS grand_total
        FROM services
    )
    SELECT rnk, service_name, agency, requests,
           ROUND(100.0 * requests / grand_total, 2)      AS pct_of_all,
           ROUND(100.0 * running_total / grand_total, 1) AS cumulative_pct
    FROM ranked
    ORDER BY rnk
    LIMIT 15

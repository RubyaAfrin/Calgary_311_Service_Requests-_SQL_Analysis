WITH yearly AS (
        SELECT request_year, COUNT(*) AS requests
        FROM requests_v
        WHERE NOT is_duplicate
        GROUP BY request_year
    )
    SELECT
        request_year,
        requests,
        LAG(requests) OVER (ORDER BY request_year)                          AS previous_year,
        ROUND(100.0 * (requests - LAG(requests) OVER (ORDER BY request_year))
              / LAG(requests) OVER (ORDER BY request_year), 1)              AS yoy_change_pct
    FROM yearly
    ORDER BY request_year

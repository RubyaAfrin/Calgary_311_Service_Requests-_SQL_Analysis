SELECT service_name, COUNT(*) AS requests,
           ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_no_community
    FROM requests_v
    WHERE NOT is_duplicate AND community IS NULL
    GROUP BY service_name
    ORDER BY requests DESC
    LIMIT 10

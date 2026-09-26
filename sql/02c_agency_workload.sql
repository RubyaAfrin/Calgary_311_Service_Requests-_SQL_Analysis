SELECT
        agency,
        COUNT(*)                                            AS requests,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct_of_all,
        COUNT(DISTINCT service_name)                        AS service_types
    FROM requests_v
    WHERE NOT is_duplicate
    GROUP BY agency
    ORDER BY requests DESC
    LIMIT 15

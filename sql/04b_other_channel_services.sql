SELECT
        service_name,
        agency,
        COUNT(*)                                                     AS requests,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)           AS pct_of_other_channel
    FROM requests_v
    WHERE NOT is_duplicate
      AND channel = 'Other'
    GROUP BY service_name, agency
    ORDER BY requests DESC
    LIMIT 10

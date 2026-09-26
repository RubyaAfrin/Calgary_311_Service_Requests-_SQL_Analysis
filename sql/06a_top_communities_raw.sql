SELECT community, COUNT(*) AS requests
    FROM requests_v
    WHERE NOT is_duplicate AND community IS NOT NULL
    GROUP BY community
    ORDER BY requests DESC
    LIMIT 10

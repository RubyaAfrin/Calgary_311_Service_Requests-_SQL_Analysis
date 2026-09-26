SELECT
        request_year,
        ROUND(100.0 * COUNT(*) FILTER (WHERE channel = 'Phone') / COUNT(*), 1) AS phone_pct,
        ROUND(100.0 * COUNT(*) FILTER (WHERE channel = 'App')   / COUNT(*), 1) AS app_pct,
        ROUND(100.0 * COUNT(*) FILTER (WHERE channel = 'Web')   / COUNT(*), 1) AS web_pct,
        ROUND(100.0 * COUNT(*) FILTER (WHERE channel = 'Other') / COUNT(*), 1) AS other_pct
    FROM requests_v
    WHERE NOT is_duplicate
    GROUP BY request_year
    ORDER BY request_year

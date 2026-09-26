SELECT
        status,
        COUNT(*) FILTER (WHERE closed_at IS NULL)     AS no_closed_date,
        COUNT(*) FILTER (WHERE closed_at IS NOT NULL) AS has_closed_date
    FROM requests_v
    GROUP BY status
    ORDER BY status

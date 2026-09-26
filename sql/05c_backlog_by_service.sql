SELECT service_name, agency, COUNT(*) AS open_requests
    FROM requests_v
    WHERE status = 'Open' AND closed_at IS NULL
    GROUP BY service_name, agency
    ORDER BY open_requests DESC
    LIMIT 10

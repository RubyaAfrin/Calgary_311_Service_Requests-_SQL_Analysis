WITH by_service AS (
        SELECT
            service_name,
            COUNT(*) FILTER (WHERE request_year = 2022) AS y2022,
            COUNT(*) FILTER (WHERE request_year = 2023) AS y2023,
            COUNT(*) FILTER (WHERE request_year = 2024) AS y2024,
            COUNT(*) FILTER (WHERE request_year = 2025) AS y2025
        FROM requests_v
        WHERE NOT is_duplicate
        GROUP BY service_name
    )
    SELECT *,
           y2023 - y2022 AS change_2022_to_2023,
           y2025 - y2023 AS change_2023_to_2025
    FROM by_service
    ORDER BY change_2022_to_2023 DESC
    LIMIT 10

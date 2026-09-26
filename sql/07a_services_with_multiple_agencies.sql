WITH service_agencies AS (
        SELECT service_name,
               COUNT(DISTINCT agency) AS agency_names,
               COUNT(*)               AS requests
        FROM requests_v
        WHERE NOT is_duplicate
        GROUP BY service_name
    )
    SELECT
        COUNT(*)                                          AS total_service_types,
        COUNT(*) FILTER (WHERE agency_names > 1)          AS types_with_multiple_agency_names,
        ROUND(100.0 * SUM(requests) FILTER (WHERE agency_names > 1) / SUM(requests), 1)
                                                          AS pct_of_requests_affected
    FROM service_agencies

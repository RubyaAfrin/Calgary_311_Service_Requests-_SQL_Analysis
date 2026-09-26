WITH counts AS (
        SELECT community, service_name, COUNT(*) AS requests
        FROM requests_v
        WHERE NOT is_duplicate AND request_year IN (2021, 2022)
          AND community IN ('DOWNTOWN COMMERCIAL CORE', 'SOUTHVIEW', 'MONTGOMERY', 'INGLEWOOD', 'SHAGANAPPI')
        GROUP BY community, service_name
    ),
    ranked AS (
        SELECT *,
               ROUND(100.0 * requests / SUM(requests) OVER (PARTITION BY community), 1) AS pct_of_community,
               ROW_NUMBER() OVER (PARTITION BY community ORDER BY requests DESC)        AS rn
        FROM counts
    )
    SELECT community, rn AS rank_in_community, service_name, requests, pct_of_community
    FROM ranked
    WHERE rn <= 3
    ORDER BY community, rn

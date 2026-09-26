WITH community_requests AS (
        SELECT comm_code AS join_key, MAX(community) AS community,
               COUNT(*) / 2.0 AS avg_requests_per_year
        FROM requests_v
        WHERE NOT is_duplicate AND request_year IN (2021, 2022) AND comm_code IS NOT NULL
        GROUP BY comm_code
    ),
    joined AS (
        SELECT c.community, p.population, c.avg_requests_per_year,
               1000.0 * c.avg_requests_per_year / p.population AS per_1000
        FROM community_requests c
        JOIN community_population p ON p.join_key = c.join_key
        WHERE p.population >= 1000
    )
    SELECT
        community,
        population,
        ROUND(avg_requests_per_year, 0)                          AS avg_requests_per_year,
        ROUND(per_1000, 1)                                       AS requests_per_1000_residents,
        ROUND(per_1000 / AVG(per_1000) OVER (), 2)               AS times_city_average,
        RANK() OVER (ORDER BY per_1000 DESC)                     AS per_capita_rank,
        RANK() OVER (ORDER BY avg_requests_per_year DESC)        AS raw_count_rank
    FROM joined
    ORDER BY per_capita_rank

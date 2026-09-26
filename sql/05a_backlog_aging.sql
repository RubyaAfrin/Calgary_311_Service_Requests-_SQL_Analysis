WITH open_requests AS (
        SELECT *, DATE_DIFF('day', CAST(requested_at AS DATE), DATE '2026-09-26') AS age_days
        FROM requests_v
        WHERE status = 'Open' AND closed_at IS NULL
    )
    SELECT
        CASE
            WHEN age_days < 365       THEN '1. Under 1 year'
            WHEN age_days < 2 * 365   THEN '2. 1-2 years'
            WHEN age_days < 3 * 365   THEN '3. 2-3 years'
            ELSE                           '4. Over 3 years'
        END                                                  AS age_bucket,
        COUNT(*)                                             AS open_requests,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)   AS pct_of_backlog
    FROM open_requests
    GROUP BY age_bucket
    ORDER BY age_bucket

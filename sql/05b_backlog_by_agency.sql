WITH open_requests AS (
        SELECT *, DATE_DIFF('day', CAST(requested_at AS DATE), DATE '2026-09-26') AS age_days
        FROM requests_v
        WHERE status = 'Open' AND closed_at IS NULL
    ),
    agency_totals AS (                        -- all non-duplicate requests per department, for context
        SELECT agency, COUNT(*) AS total_requests
        FROM requests_v
        WHERE NOT is_duplicate
        GROUP BY agency
    )
    SELECT
        o.agency,
        COUNT(*)                                              AS open_requests,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)    AS pct_of_backlog,
        ROUND(100.0 * COUNT(*) / MAX(t.total_requests), 2)    AS pct_of_agency_requests_still_open,
        MEDIAN(o.age_days)                                    AS median_age_days
    FROM open_requests o
    JOIN agency_totals t ON t.agency = o.agency               -- a JOIN combines the two results by department
    GROUP BY o.agency
    ORDER BY open_requests DESC
    LIMIT 10

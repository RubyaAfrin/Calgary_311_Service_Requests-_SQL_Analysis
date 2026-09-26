SELECT
        COUNT(*)                                             AS requests_with_community,
        COUNT(p.join_key)                                    AS matched_to_census,
        ROUND(100.0 * COUNT(p.join_key) / COUNT(*), 1)       AS pct_matched
    FROM requests_v r
    LEFT JOIN community_population p ON p.join_key = r.comm_code
    WHERE NOT r.is_duplicate AND r.comm_code IS NOT NULL

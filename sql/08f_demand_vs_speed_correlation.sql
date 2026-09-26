SELECT
        COUNT(*)                                                         AS communities,
        ROUND(CORR(p.requests_per_1000_residents, s.median_days), 2)     AS corr_demand_vs_median_days,
        ROUND(CORR(p.requests_per_1000_residents, s.p90_days), 2)        AS corr_demand_vs_p90_days
    FROM percap_df p
    JOIN speed_df s ON s.community = p.community

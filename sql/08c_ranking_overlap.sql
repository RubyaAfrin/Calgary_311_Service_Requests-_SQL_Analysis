SELECT
        COUNT(*) FILTER (WHERE raw_count_rank <= 15)                          AS top15_by_raw_count,
        COUNT(*) FILTER (WHERE raw_count_rank <= 15 AND per_capita_rank <= 15) AS also_top15_per_capita
    FROM read_csv_auto('/content/drive/MyDrive/calgary_311_project/results/08b_requests_per_1000_residents.csv')

Calgary 311 Service Requests: SQL Analysis (2021–2025)
An end-to-end SQL analysis of 2.5 million City of Calgary 311 service requests, joined with 2021 census population data to compare demand fairly across communities.
Tools: SQL (DuckDB) · Python (Pandas, Matplotlib) · Google Colab
Data: 311 Service Requests and 2021 Federal Census Population and Dwellings by Community, City of Calgary Open Data
---
Key findings
Raw request counts hide the communities with the highest demand. Only 3 of the 15 highest-demand communities per 1,000 residents also rank in the top 15 by raw volume. Southview ranks 2nd per capita but 118th by volume, Shaganappi 5th vs 130th, and Rosedale 9th vs 151st.
A few service types drive most of the work. Of 799 service types, 31 account for 50% of requests and 98 (12%) account for 80%.
Typical requests are fast, but the slowest ones are very slow. Mobility resolves a typical request in 2 days, but its slowest 10% take 250+ days.
Several departments got slower from 2021 to 2025 (90th-percentile days to resolve): Development, Business and Building Services 7 → 49, Calgary Fire 33 → 62, Water Services 27 → 51, and Calgary Transit 28 → 49. Mobility improved the most, from 378 to 73.
The open backlog is old. Of 41,091 open requests, 49% are more than three years old. Mobility holds 36% of the backlog. Two customer-service units still show 41% and 25% of all their requests as open.
High-demand communities wait longer in the slowest cases. Demand per resident correlates 0.46 with 90th-percentile resolution time across 183 communities, but only 0.15 with the median.
---
Business questions and results
1. Demand trends
Excluding duplicates, requests rose to a peak of 546,139 in 2023 (+9.6%), then fell 7.2% in 2024 and 5.0% in 2025.
Year	Requests	Change
2021	480,844	–
2022	498,252	+3.6%
2023	546,139	+9.6%
2024	506,838	−7.2%
2025	481,645	−5.0%
Growth in 2023–2024 was driven by pothole requests (2,645 in 2022 → 7,636 in 2023 → 11,316 in 2024 → 5,318 in 2025) and sidewalk snow-and-ice complaints (12,861 → 17,035 in 2023). Several building-inspection service types appear only in 2023–2024, which points to a change in how requests were categorized rather than a change in demand.
2. Workload
Demand is highly concentrated: 98 of 799 service types (12%) generate 80% of requests. Emergency Management and Community Safety (10.7%) and Mobility (9.7%) carry the most requests.
3. Service performance
The 90th percentile (how long the slowest 10% of requests take) reveals problems the median hides:
Department	Median days	90th percentile days	Closed within 7 days
OS – Mobility	2	250	70.8%
OS – Water Services	2	71	66.6%
TRAN – Roads	1	69	73.4%
OS – Waste and Recycling	2	8	89.4%
CFOD – Finance	5	8	89.8%
4. Backlog
Age of open request	Requests	Share
Under 1 year	1,576	3.8%
1–2 years	10,244	24.9%
2–3 years	9,186	22.4%
Over 3 years	20,085	48.9%
Ages measured in September 2026.
5. Communities: requests per 1,000 residents
Per-capita demand is highest in established inner-city communities, at 1.7–2.8 times the community average. Needs differ by community:
Inglewood: graffiti is 10% of all requests.
Southview: sewage back-ups (6.0%) and encampment concerns (4.9%) lead.
Montgomery and Shaganappi: waste carts and sidewalk snow lead.
Service speed varies too. The slowest 10% of requests take up to 48 days in Kingsland, Rosedale, and Elboya, versus 14–16 days in newer suburbs such as Homestead, Rangeview, and Glacier Ridge. One likely explanation is the type of requests in older areas, such as ageing infrastructure and mature trees. That's a hypothesis for the City to test, not a conclusion.
---
Recommendations
Use per-capita demand, not raw counts, to prioritize communities. Raw counts point resources to populous suburbs and miss smaller inner-city communities with the highest need.
Target community-specific programs: graffiti prevention in Inglewood, and sewer infrastructure review in Southview.
Track the 90th percentile as a service KPI alongside the median. Medians of 2–4 days hide waits of 50–250 days.
Investigate the departments that slowed down, starting with Development, Business and Building Services, Calgary Fire, Water Services, and Transit.
Review the 20,000 requests open for more than three years, and confirm whether customer-service inquiries are being formally closed.
Improve data consistency: keep stable department and service identifiers across reorganizations, and restore the phone and web channel codes (see below).
---
Data quality issues found
Checking the data before analyzing it changed several conclusions:
Department names changed during the period. 421 of 799 service types (85.9% of requests) appear under more than one department name after a City reorganization. I mapped each service to its current department (`ROW_NUMBER() OVER (PARTITION BY ...)`), which raised the number of departments comparable across all five years from 5 to 15.
The channel field changed, not residents' behaviour. Phone fell from 54.0% of requests in 2021 to 0% in 2025, while "Other" rose from 29.5% to 81.3%. Phone and web requests appear to have been relabelled as "Other", so no phone-to-digital shift is claimed. The only reliable trend is app usage, which rose from 13.6% to about 19–22%.
Status and closing date disagree for 3,081 requests marked "Open" that have a closing date. The backlog counts a request as open only when both agree.
Duplicates (22,148 requests merged into earlier reports) were excluded from demand and speed analysis, because they close almost instantly and would make resolution times look faster.
6.6% of requests have no community, and 794 downtown requests have the service name "N/A".
Methodology notes
Resolution time is measured in whole days, since many timestamps record only the date.
Right-censoring: requests that are still open have no resolution time, which makes recent years look slightly faster. The slowdowns reported above are therefore conservative, and the Mobility improvement may be partly overstated.
Per-capita rates use 2021–2022 requests to align with the 2021 census, and include only communities with at least 1,000 residents. 99.9% of requests with a community matched a census community. Downtown Commercial Core ranks first per capita, but many of its requests come from workers and visitors rather than residents.
---
Repository structure
```
notebooks/
  calgary_311_part1_data_setup.ipynb          download, data-quality checks, cleaning
  calgary_311_part2_business_questions.ipynb  demand, workload, speed, channels, backlog
  calgary_311_part3_communities.ipynb         department-name fix, census join, per-capita analysis
sql/        every query as a standalone .sql file
results/    the output of every query as .csv
```
SQL techniques used: CTEs, window functions (`LAG`, `RANK`, `ROW_NUMBER`, running totals with `SUM() OVER`), `PERCENTILE_CONT`, `FILTER` for pivoting, `LEFT JOIN` match-rate analysis, `CORR`, and views.
How to run
Open the notebooks in Google Colab and run them in order. Part 1 downloads the data from the City's API and saves a DuckDB database to Google Drive, which Parts 2 and 3 reuse.
---
Contains information licensed under the Open Government Licence – City of Calgary.

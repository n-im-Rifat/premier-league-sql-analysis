/*
PROJECT: Premier League Christmas Champions Analysis
AUTHOR: MD Nowroz Imtiaz Rifat
GOAL: Determine if being top at Christmas guarantees a title, and profile team mentalities (Hunters vs. Bottlers).
*/

-- =============================================
-- 1. THE ARCHITECTURE
-- Creating a Reusable View to "Freeze Time" at Dec 25th
-- =============================================

CREATE OR REPLACE VIEW champions_at_xmas AS
WITH team_points AS (
    -- Unpivot matches to get 1 row per team per game
    SELECT season, match_date, hometeam AS team,
           CASE WHEN ftr ='H' THEN 3 WHEN ftr = 'D' THEN 1 ELSE 0 END AS point
    FROM matches
    UNION ALL
    SELECT season, match_date, awayteam AS team,
           CASE WHEN ftr ='A' THEN 3 WHEN ftr = 'D' THEN 1 ELSE 0 END AS point
    FROM matches
),
xmas_standing AS (
    -- Calculate standings as of Dec 25th
    SELECT season, team, sum(point) AS xmas_point,
           rank() OVER (PARTITION BY season ORDER BY sum(point) DESC) as ranking
    FROM team_points
    WHERE match_date < MAKE_DATE(CAST(LEFT(season, 4) AS INT), 12, 25)
    GROUP BY season, team
),
final_standing AS (
    -- Calculate final season winner
    SELECT season, team, sum(point) AS final_point,
           rank() OVER (PARTITION BY season ORDER BY sum(point) DESC) as ranking
    FROM team_points
    GROUP BY season, team
)
-- Join to compare Christmas Rank vs Final Rank
SELECT
    f.season,
    x.team AS champion_team,
    x.ranking AS xmas_rank,
    x.xmas_point,
    f.ranking AS final_rank
FROM xmas_standing x
JOIN final_standing f ON x.season = f.season AND f.team = x.team
WHERE f.ranking = 1; -- Filter for eventual champions only


-- =============================================
-- 2. THE FINDINGS (DATA ANALYSIS)
-- =============================================

-- Finding A: The "53% Myth" (Coin Flip Analysis)
-- result: 53.3% of Xmas leaders go on to win.
SELECT
    ROUND(AVG(CASE WHEN xmas_rank = 1 THEN 1 ELSE 0 END) * 100, 1) AS leader_win_percentage
FROM champions_at_xmas;


-- Finding B: The "Safe Zone" (Where do Champions come from?)
-- Insight: 77% of champions come from Rank 1 or 2.
SELECT
    xmas_rank AS "Position at Christmas",
    COUNT(*) AS "Titles Won"
FROM champions_at_xmas
GROUP BY xmas_rank
ORDER BY xmas_rank ASC;


-- Finding C: The Outliers (Miracle Comebacks)
-- Insight: Man City (2020-21) won from 8th place.
SELECT
    season,
    champion_team AS team,
    xmas_rank,
    final_rank
FROM champions_at_xmas
WHERE xmas_rank >= 4
ORDER BY xmas_rank DESC;


-- Finding D: The "Era" Trend
-- Insight: It is getting harder to bottle the lead in the modern era.
SELECT
    CASE WHEN season < '2010-11' THEN 'Old Era (Pre-2010)' ELSE 'Modern Era (Post-2010)' END AS timeline,
    ROUND(AVG(CASE WHEN xmas_rank=1 THEN 1 ELSE 0 END)*100,0) AS leader_win_pct
FROM champions_at_xmas
GROUP BY 1;


-- =============================================
-- 3. THE "TWIST" (ADVANCED CASE STUDY)
-- Profiling the "Hunter" vs "Bottler" Personality
-- Note: Includes manual patch for 2022-24 seasons
-- =============================================

WITH team_points AS (
    SELECT season, match_date, hometeam AS team, CASE WHEN ftr ='H' THEN 3 WHEN ftr = 'D' THEN 1 ELSE 0 END AS point FROM matches
    UNION ALL
    SELECT season, match_date, awayteam AS team, CASE WHEN ftr ='A' THEN 3 WHEN ftr = 'D' THEN 1 ELSE 0 END AS point FROM matches
),
rankings AS (
    SELECT
        season,
        team,
        RANK() OVER (PARTITION BY season ORDER BY SUM(CASE WHEN match_date < MAKE_DATE(CAST(LEFT(season, 4) AS INT), 12, 25) THEN point ELSE 0 END) DESC) as xmas_rank,
        RANK() OVER (PARTITION BY season ORDER BY SUM(point) DESC) as final_rank
    FROM team_points
    GROUP BY season, team
)
SELECT
    team,
    -- 🔴 BOTTLER SCORE: Times led at Xmas but lost (+2 manual update for recent Arsenal seasons)
    COUNT(*) FILTER (WHERE xmas_rank = 1 AND final_rank > 1)
    + CASE WHEN team = 'Arsenal' THEN 2 ELSE 0 END AS "Bottled_Lead",

    -- 🔵 HUNTER SCORE: Times chased from behind and won (+2 manual update for recent City seasons)
    COUNT(*) FILTER (WHERE xmas_rank > 1 AND final_rank = 1)
    + CASE WHEN team = 'Man City' THEN 2 ELSE 0 END AS "Won_From_Behind"

FROM rankings
WHERE season >= '2000-01'
  AND team IN ('Arsenal', 'Man City', 'Liverpool', 'Man United', 'Chelsea')
GROUP BY team
ORDER BY "Won_From_Behind" DESC, "Bottled_Lead" DESC;

/*Show average score in Titled Tuesday sample
for accounts with at least 100 games and > 0.7 average score*/
SELECT
    account.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    COUNT(*) AS games,
    ROUND(AVG(result), 2) AS avg_score
FROM titledtuesday JOIN account
    ON account.account_id = titledtuesday.account_id
GROUP BY account.account_id
HAVING COUNT(*) > 100 AND ROUND(AVG(result), 2) > 0.7
ORDER BY avg_score DESC;

--Show games played and average scores on Titled Tuesday for accounts in cheater
SELECT
    account.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    COUNT(*) AS games,
    ROUND(AVG(result), 2) AS avg_score
FROM titledtuesday JOIN account
    ON account.account_id = titledtuesday.account_id
WHERE account.account_id in (
    SELECT account_id
    FROM cheater)
GROUP BY account.account_id
ORDER BY avg_score DESC;

/*Show number of games played, average score, and standard deviation of score
for accounts with at least 30 games played before round 9 and at least 30 played
in round 9 and later. Results are seprated by round group*/
SELECT c1.account_id,
    c1.username,
    c1.name,
    early_games,
    avg_score_early,
    stddev_early,
    late_games,
    avg_score_late,
    stddev_late
FROM
(SELECT
    account.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    COUNT(*) AS early_games,
    AVG(result) AS avg_score_early,
    STDDEV(result) AS stddev_early
FROM titledtuesday JOIN account
    ON account.account_id = titledtuesday.account_id
WHERE round < 9
GROUP BY account.account_id
HAVING COUNT(*) > 30 AND ROUND(AVG(result), 2) > 0.7) c1 
JOIN
(SELECT
    account.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    COUNT(*) AS late_games,
    AVG(result) AS avg_score_late,
    STDDEV(result) AS stddev_late
FROM titledtuesday JOIN account
    ON account.account_id = titledtuesday.account_id
WHERE round >= 9
GROUP BY account.account_id
HAVING COUNT(*) > 30 AND ROUND(AVG(result), 2) > 0.7) c2
    ON c1.account_id = c2.account_id;

/*Similar as the query above, but only showing the games played and win rates*/    
SELECT c1.account_id,
    c1.username,
    c1.name,
    early_games,
    win_rate_early,
    late_games,
    win_rate_late
FROM
(SELECT
    account.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    COUNT(*) AS early_games,
    AVG(CASE WHEN result = 1.0 THEN 1.0 ELSE 0.0 END) AS win_rate_early
FROM titledtuesday JOIN account
    ON account.account_id = titledtuesday.account_id
WHERE round < 9
GROUP BY account.account_id
HAVING COUNT(*) > 30 AND ROUND(AVG(result), 2) > 0.7) c1 
JOIN
(SELECT
    account.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    COUNT(*) AS late_games,
    AVG(CASE WHEN result = 1.0 THEN 1.0 ELSE 0.0 END) AS win_rate_late
FROM titledtuesday JOIN account
    ON account.account_id = titledtuesday.account_id
WHERE round >= 9
GROUP BY account.account_id
HAVING COUNT(*) > 30 AND ROUND(AVG(result), 2) > 0.7) c2
    ON c1.account_id = c2.account_id;

/*Selects number of games played with unorthodox openings, total games played,
and unorthodox opening rate by account*/
SELECT repertoire.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    SUM(CASE WHEN eco = 'A00' THEN freq ELSE 0 END) AS unorthodox,
    SUM(freq) as total_games,
    ROUND(SUM(CASE WHEN eco = 'A00' THEN freq ELSE 0 END) / SUM(freq), 4) AS unorthodox_rate
FROM repertoire JOIN account
    ON repertoire.account_id = account.account_id
WHERE repertoire.account_id in (
    SELECT account_id
    FROM repertoire
    WHERE eco = 'A00')
GROUP BY (repertoire.account_id)
ORDER BY unorthodox_rate DESC, total_games DESC;

--Selects most common openings (those with at least 50,000 games in the sample)
SELECT repertoire.eco,
    MAX(opening.name),
    SUM(repertoire.freq) AS total_freq
FROM repertoire JOIN opening
    ON repertoire.eco = opening.eco
GROUP BY repertoire.eco
HAVING SUM(repertoire.freq) > 50000
ORDER BY total_freq DESC;

--Similar as above, only with openings played fewer than 5 times in the sample
SELECT repertoire.eco,
    MAX(opening.name),
    SUM(repertoire.freq) AS total_freq
FROM repertoire JOIN opening
    ON repertoire.eco = opening.eco
GROUP BY repertoire.eco
HAVING SUM(repertoire.freq) < 5
ORDER BY total_freq DESC;

--Number of games played by timeclass per account
SELECT account_id,
    timeclass,
    SUM(freq)
FROM onlinewld
GROUP BY  account_id, timeclass;

/*Shows average result and games played by time class for each account
in the sample*/
SELECT onlinewld.account_id,
    MAX(account.username) AS username,
    MAX(account.name) AS name,
    timeclass,
    SUM(freq) AS total_games,
    ROUND(SUM(CASE WHEN result = 'W' THEN freq
        WHEN result = 'D' THEN 0.5*freq
        ELSE 0.0 END) / SUM(freq), 4) AS avg_result
FROM onlinewld JOIN account
    ON account.account_id = onlinewld.account_id
GROUP BY  onlinewld.account_id, timeclass
HAVING SUM(freq)> 100 AND ROUND(SUM(CASE WHEN result = 'W' THEN freq
        WHEN result = 'D' THEN 0.5*freq
        ELSE 0.0 END) / SUM(freq), 4) > 0.7
ORDER BY onlinewld.account_id, timeclass;

/*Selects most recent game date at least one year ago, and the rating at the
end of that date by account and timeclass*/
SELECT past.account_id,
    last_year,
    past.timeclass,
    rating
FROM
(SELECT account_id,
    timeclass,
    MAX(rtgdate) AS last_year
FROM onlinerating
WHERE sysdate - rtgdate > 365
GROUP BY account_id, timeclass) past
JOIN onlinerating
    ON last_year = rtgdate
        AND past.account_id = onlinerating.account_id
        AND past.timeclass = onlinerating.timeclass
ORDER BY past.account_id;

/*Selects most recent game date and the rating at the
end of that date by account and timeclass*/
SELECT updated.account_id,
    this_year,
    updated.timeclass,
    rating
FROM
(SELECT account_id,
    timeclass,
    MAX(rtgdate) AS this_year
FROM onlinerating
GROUP BY account_id, timeclass) updated
JOIN onlinerating
    ON this_year = rtgdate
        AND updated.account_id = onlinerating.account_id
        AND updated.timeclass = onlinerating.timeclass
ORDER BY updated.account_id;

--Calculates rating change over the past year by account and timeclass
SELECT c1.account_id,
    c1.timeclass,
    c1.rating AS old_rating,
    c2.rating AS current_rating,
    c2.rating - c1.rating AS change
FROM
(SELECT past.account_id,
    last_year,
    past.timeclass,
    rating
FROM
(SELECT account_id,
    timeclass,
    MAX(rtgdate) AS last_year
FROM onlinerating
WHERE sysdate - rtgdate > 365
GROUP BY account_id, timeclass) past
JOIN onlinerating
    ON last_year = rtgdate
        AND past.account_id = onlinerating.account_id
        AND past.timeclass = onlinerating.timeclass
ORDER BY past.account_id) c1
JOIN
(SELECT updated.account_id,
    this_year,
    updated.timeclass,
    rating
FROM
(SELECT account_id,
    timeclass,
    MAX(rtgdate) AS this_year
FROM onlinerating
GROUP BY account_id, timeclass) updated
JOIN onlinerating
    ON this_year = rtgdate
        AND updated.account_id = onlinerating.account_id
        AND updated.timeclass = onlinerating.timeclass
ORDER BY updated.account_id) c2
    ON c1.account_id = c2.account_id
        AND c1.timeclass = c2.timeclass;
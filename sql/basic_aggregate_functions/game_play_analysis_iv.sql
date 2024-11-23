WITH FirstLogin AS (
    SELECT
        player_id,
        MIN(event_date) AS first_login_date
    FROM
        Activity
    GROUP BY
        player_id
),
NextDayLogins AS (
    SELECT
        a.player_id
    FROM
        Activity a
    JOIN
        FirstLogin fl
    ON
        a.player_id = fl.player_id AND a.event_date = DATE_ADD(fl.first_login_date, INTERVAL 1 DAY)
)
SELECT
    ROUND(COUNT(DISTINCT NextDayLogins.player_id) * 1.0 / COUNT(DISTINCT FirstLogin.player_id), 2) AS fraction
FROM
    FirstLogin
LEFT JOIN
    NextDayLogins
ON
    FirstLogin.player_id = NextDayLogins.player_id;

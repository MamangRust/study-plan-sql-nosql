WITH friends AS (
  SELECT requester_id, COUNT(*) AS num
  FROM (
    SELECT requester_id, accepter_id FROM RequestAccepted
    UNION
    SELECT accepter_Id, requester_id FROM RequestAccepted
  ) AS t
  GROUP BY 1
)

SELECT requester_id AS id, num
FROM friends
WHERE num = (
  SELECT MAX(num)
  FROM friends
);

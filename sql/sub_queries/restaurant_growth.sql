SELECT visited_on, amount, ROUND(amount / 7, 2) AS average_amount
FROM (
  SELECT visited_on, SUM(amount) OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) AS amount, DENSE_RANK() OVER(ORDER BY visited_on) AS rk
  FROM Customer
) AS avgs
WHERE rk >= 7
GROUP BY 1
ORDER BY 1;

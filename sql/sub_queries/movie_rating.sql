(
  SELECT name AS 'results'
  FROM Users
  LEFT JOIN MovieRating USING(user_id)
  GROUP BY 1
  ORDER BY COUNT(*) DESC, 1
  LIMIT 1
)
UNION ALL
(
  SELECT title AS 'results'
  FROM Movies
  LEFT JOIN MovieRating USING(movie_id)
  WHERE created_at BETWEEN '2020-02-01' AND '2020-02-29'
  GROUP BY 1
  ORDER BY AVG(rating) DESC, 1
  LIMIT 1
);

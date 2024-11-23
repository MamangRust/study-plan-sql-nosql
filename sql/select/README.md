# Select

-----

# 1757. Recyclable and Low Fat Products

## Sql


### Problem Statement

The task is to identify products that are both low-fat and recyclable from a given dataset. The input is structured as a table with three columns:

1. **`product_id`**: Unique identifier for each product.
2. **`low_fats`**: ENUM type indicating whether the product is low-fat (`'Y'` for yes, `'N'` for no).
3. **`recyclable`**: ENUM type indicating whether the product is recyclable (`'Y'` for yes, `'N'` for no).

### Constraints

- Return only the `product_id` for products that satisfy both conditions (`low_fats = 'Y'` and `recyclable = 'Y'`).
- The result order does not matter.

### Example Input

```table
| product_id | low_fats | recyclable |
|------------|----------|------------|
| 0          | Y        | N          |
| 1          | Y        | Y          |
| 2          | N        | Y          |
| 3          | Y        | Y          |
| 4          | N        | N          |

```

### Sql Query

```sql
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
```


## No Sql(MongoDB)

In MongoDB, the equivalent query uses the ``find`` method to filter documents based on the required conditions.

### Example Dataset

```json
[
  { "product_id": 0, "low_fats": "Y", "recyclable": "N" },
  { "product_id": 1, "low_fats": "Y", "recyclable": "Y" },
  { "product_id": 2, "low_fats": "N", "recyclable": "Y" },
  { "product_id": 3, "low_fats": "Y", "recyclable": "Y" },
  { "product_id": 4, "low_fats": "N", "recyclable": "N" }
]
```

### MongoDB Query

```js
db.Products.find(
  { low_fats: "Y", recyclable: "Y" },
  { _id: 0, product_id: 1 }
);
```

### Explanation
{ low_fats: "Y", recyclable: "Y" }: Filters documents where low_fats and recyclable are both 'Y'.
{ _id: 0, product_id: 1 }: Projects only the product_id field in the output, excluding the default _id.

-----

## 584. Find Customer Referee

## Sql

### Problem Statement

The task is to find the names of customers who are **not referred by the customer with `id = 2`**. The input consists of a table with the following structure:

1. **`id`**: The unique identifier for each customer.
2. **`name`**: The name of the customer.
3. **`referee_id`**: The ID of the customer who referred them, or `NULL` if no one referred them.

### Constraints

- Return only the `name` column for customers who are either:
  - Not referred by the customer with `id = 2`.
  - Not referred by anyone (`referee_id IS NULL`).
- The result order does not matter.

### Example Input

```table
| id | name | referee_id |
|----|------|------------|
| 1  | Will | NULL       |
| 2  | Jane | NULL       |
| 3  | Alex | 2          |
| 4  | Bill | NULL       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |

```

### Example Ouput

```table
| name    |
|---------|
| Will    |
| Jane    |
| Bill    |
```

### Explanation


Only ``Will``, ``Jane``, and ``Bill`` are not referred by anyone since their ```referee_id``` is ```NULL```.

### SQL Implementation

To solve this in SQL, use the ``SELECT`` statement with a ``WHERE`` clause to filter rows based on the condition that ``referee_id`` is not ``2`` or is ``NULL``.

```sql
select name
from customer
where referee_id != 2 or referee_id is NULL;

```

### Explnation

- ``referee_id != 2 `` : Selects customers who are not referred by the customer with id = 2.
- ``OR referee_id IS NULL``: Includes customers who are not referred by anyone (NULL value).
- ``SELECT name``: Retrieves only the name column for the filtered rows.


## NoSQL(MongoDB)

In MongoDB, use the find method with an ``$or`` operator to handle the condition that ``referee_id`` is not ``2`` or is ``null``.

### Example Dataset

```json
[
  { "id": 1, "name": "Will", "referee_id": null },
  { "id": 2, "name": "Jane", "referee_id": null },
  { "id": 3, "name": "Alex", "referee_id": 2 },
  { "id": 4, "name": "Bill", "referee_id": null },
  { "id": 5, "name": "Zack", "referee_id": 1 },
  { "id": 6, "name": "Mark", "referee_id": 2 }
]
```

### MongoDB Query

```js
db.customer.find(
  {
    $or: [
      { referee_id: { $ne: 2 } },
      { referee_id: null }
    ]
  },
  { _id: 0, name: 1 }
);

```

## Explanation
- ```{ referee_id: null }```: Filters documents where the referee_id field is null.
- ``{ _id: 0, name: 1 }``: Projects only the name field in the output, excluding the default _id.

-----


## 595. Big Countries

------

## Sql

-----

### Problem Statement

The task is to find the name, population, and area of **big countries**. A country is considered big if:

1. It has an area of at least **3 million km²** (i.e., `area >= 3000000`), OR
2. It has a population of at least **25 million** (i.e., `population >= 25000000`).

The input consists of a table with the following structure:

- **`name`**: The name of the country.
- **`continent`**: The continent to which the country belongs.
- **`area`**: The total area of the country in km².
- **`population`**: The total population of the country.
- **`gdp`**: The gross domestic product of the country.

### Constraints

- Return only the `name`, `population`, and `area` of the big countries.
- The result order does not matter.

---

### Example Input

```table
| name        | continent | area    | population | gdp          |
|-------------|-----------|---------|------------|--------------|
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |
```

### Example Output

```table
| name        | population | area    |
|-------------|------------|---------|
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |
```


### SQL Implementation

To solve this in SQL, use the SELECT statement with a WHERE clause to filter rows based on the conditions for big countries.

### SQL Query

```sql
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;
```

### Explanation
- ``area >= 3000000``: Filters countries with an area of at least 3 million km².
- ``population >= 25000000``: Filters countries with a population of at least 25 million.
- ``OR``: Ensures that either of the conditions is sufficient for a country to be included in the result.
- ``SELECT name, population, area``: Retrieves only the required columns for the output.

### NoSQL(MongoDB) Implementation

In MongoDB, use the find method with an $or operator to handle the two conditions for big countries.

### MongoDB Query

```javascript
db.world.find(
  {
    $or: [
      { area: { $gte: 3000000 } },
      { population: { $gte: 25000000 } }
    ]
  },
  { _id: 0, name: 1, population: 1, area: 1 }
);
```

### Explanation

1. ``$or``: Combines conditions to match documents where at least one condition is true.
  - ``{ area: { $gte: 3000000 } }``: Filters countries with an area of at least 3 million km².
  - ``{ population: { $gte: 25000000 } }``: Filters countries with a population of at least 25 million.
2. Projection:
- ``{ _id: 0, name: 1, population: 1, area: 1 }``: Includes only the name, population, and area fields in the result while excluding the default _id.

-----


## 1148. Article Views I




### Problem Statement

The task is to find all authors who have viewed at least one of their own articles. The input consists of a table that logs article views, with each row indicating when a viewer (represented by `viewer_id`) viewed an article (represented by `article_id`) written by an author (represented by `author_id`) on a specific date.

### Input Table Structure

The table contains the following columns:

- **`article_id`**: The unique identifier for the article.
- **`author_id`**: The unique identifier for the author of the article.
- **`viewer_id`**: The unique identifier for the viewer of the article.
- **`view_date`**: The date when the article was viewed.

### Constraints

- If the `author_id` and `viewer_id` are the same, it means the author has viewed their own article.
- The result should return the `author_id` of authors who have viewed at least one of their own articles.
- The results should be sorted by the `author_id` in ascending order.

### Example Input

```table
| article_id | author_id | viewer_id | view_date  |
|------------|-----------|-----------|------------|
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
```

### Example Output

```table
| id   |
|------|
| 4    |
| 7    |

```

### SQL Implementation

To solve this in SQL, we need to filter for rows where author_id is equal to viewer_id. This will give us the authors who have viewed their own articles.

### SQL Query

```sql

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;
```

### Explanation
- ``author_id`` = viewer_id: Filters rows where the author has viewed their own article.
- ``DISTINCT``: Ensures that each author is listed only once in the result.
- ``ORDER BY id``: Sorts the result by author_id in ascending order.


### NoSql(MongoDB) Implementation

In MongoDB, we can use the ``find`` method with a query that checks if the ``author_id`` equals ```viewer_id```. We also use projection to return only the ``author_id`` (referred to as id in the result).

### Mongodb Query

```javascript
db.views.aggregate([
  { $match: { $expr: { $eq: ["$author_id", "$viewer_id"] } } },
  { $group: { _id: "$author_id" } },
  { $sort: { _id: 1 } }
]);
```


### Explanation
- ``$match``: Filters documents where author_id is equal to viewer_id using the $expr operator for equality comparison.
- ``$group``: Groups the documents by author_id to ensure each author is listed once.
- ``$sort``: Sorts the result by author_id (represented as _id in the aggregation pipeline) in ascending order.

----

## 1683. Invalid Tweets



### Problem Statement

The task is to find the IDs of **invalid tweets**. A tweet is considered invalid if the length of its content exceeds **15 characters**. The input consists of a table containing all tweets in a social media app.

### Input Table Structure

The table contains the following columns:

- **`tweet_id`**: The unique identifier for the tweet.
- **`content`**: The text content of the tweet.

### Constraints

- A tweet is invalid if the **length of the content** is strictly greater than 15 characters.
- The result should return the `tweet_id` for all invalid tweets.
- The results should be in any order.

---

### Example Input

```table
| tweet_id | content                           |
|----------|-----------------------------------|
| 1        | Let us Code                       |
| 2        | More than fifteen chars are here! |
```

### Example Output

```table
| tweet_id |
|----------|
| 2        |
```


### SQL Implementation

To solve this in SQL, use the ``LENGTH`` function to get the length of the content and filter rows where the length is greater than 15.


```sql
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;
```

### Explanation
- ``LENGTH(content)`` > 15: Filters tweets where the length of the content exceeds 15 characters.
- ``SELECT tweet_id``: Retrieves the tweet_id of the invalid tweets.


### NoSQL (MongoDB) Implementation

In MongoDB, we can use the find method with the ``$where`` operator to filter documents based on the length of the ``content`` field.


### MongoDB Query

```js
db.tweets.find(
  { $where: "this.content.length > 15" },
  { _id: 0, tweet_id: 1 }
);
```

### Explanation
- ``$where``: The $where operator allows us to write JavaScript expressions. In this case, it checks if the length of the content field is greater than 15.
- ``Projection``: { _id: 0, tweet_id: 1 } ensures that only the tweet_id field is returned in the result, excluding the _id field.


------

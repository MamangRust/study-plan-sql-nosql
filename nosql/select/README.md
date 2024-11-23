# 1757. Recyclable and Low Fat Products

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

## 1148. Article Views I

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

## Basic Aggregate functions

## 1251. Average Selling Price

## Problem Statement

We are tasked with calculating the **average selling price** for each product based on data from two tables:

1. **Prices**: Contains the price of a product during specific time periods.
2. **UnitsSold**: Contains records of sales transactions for each product.

The **average selling price** is calculated as:

\[
\text{average\_price} = \frac{\text{Total Price of Sold Units}}{\text{Total Units Sold}}
\]

### Constraints
- If a product has no sales, the average price should be `0.00`.
- The result should be rounded to **2 decimal places**.

---

### Input Structure

#### Prices Table
```table
| Column       | Type  | Description                              |
|--------------|-------|------------------------------------------|
| product_id   | int   | Unique ID of the product.                |
| start_date   | date  | Start date of the price period.          |
| end_date     | date  | End date of the price period.            |
| price        | int   | Price of the product during the period.  |
```

#### UnitsSold Table

```table
| Column       | Type  | Description                              |
|--------------|-------|------------------------------------------|
| product_id   | int   | Unique ID of the product sold.           |
| purchase_date| date  | Date of the transaction.                 |
| units        | int   | Number of units sold on the transaction. |
```

### SQL Query

```sql
WITH PriceDetails AS (
    SELECT 
        u.product_id,
        u.units,
        p.price,
        u.units * p.price AS total_price
    FROM UnitsSold u
    JOIN Prices p
    ON u.product_id = p.product_id
       AND u.purchase_date BETWEEN p.start_date AND p.end_date
),
ProductTotals AS (
    SELECT 
        product_id,
        SUM(total_price) AS total_price_sum,
        SUM(units) AS total_units
    FROM PriceDetails
    GROUP BY product_id
)
SELECT 
    p.product_id,
    ROUND(COALESCE(t.total_price_sum / NULLIF(t.total_units, 0), 0), 2) AS average_price
FROM 
    (SELECT DISTINCT product_id FROM Prices) p
LEFT JOIN ProductTotals t
ON p.product_id = t.product_id;
```

### Explanation

#### Step 1: Match Sales Data with Prices
- Use a `JOIN` between `UnitsSold` and `Prices` to match each sale's `purchase_date` with the relevant price period (`start_date` to `end_date`).
- Calculate the `total_price` for each sale using the formula:

```mdx
total_price = units * price
```


#### Step 2: Aggregate Total Sales
- Group data by product_id and calculate:
- total_price_sum: The sum of all total_price values for each product.
- total_units: The total number of units sold for each product.


#### Step 3: Calculate Average Price
- Use a LEFT JOIN to include all products, even those without sales.
- Compute the average price using the formula:

```mdx
average_price = total_price_sum / total_units
```

- Handle edge cases:
    - Use COALESCE to set average_price to 0 if a product has no sales.
    - Prevent division by zero using NULLIF.

#### Step 4: Format Results

- Use ROUND to round the average_price to 2 decimal places for the final output.

-----------------------------------------------------


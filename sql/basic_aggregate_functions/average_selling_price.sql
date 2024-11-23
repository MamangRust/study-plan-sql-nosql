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

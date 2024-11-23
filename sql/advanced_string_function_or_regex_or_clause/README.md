# Advanced String Function OR Regex OR Clause

# 1517. Find Users With Valid E-Mails

## Problem Statement
We are tasked with removing duplicate rows from the `Person` table based on the `email` column, keeping only the row with the smallest `id` for each duplicate email. 

The final `Person` table should not contain any duplicate emails.

---

## Input Structure
- The `Person` table has two columns:
  1. `id`: A unique integer identifier for each row.
  2. `email`: A string representing an email address.

---

## SQL Query

```sql
DELETE p2
FROM
    person AS p1
    JOIN person AS p2 ON p1.email = p2.email
WHERE
    p1.id < p2.id;

```

## Explanation of the Query
1. Step 1: Identify Duplicate Emails
    -  Using a self-join (JOIN), the table is joined on the email column, such that for every pair of rows with the same email:
        - p1 represents the row with the smallest id (since p1.id < p2.id is used in the WHERE clause).
        - p2 represents the duplicate rows that need to be deleted.

2. Step 2: Delete Duplicates
    - The DELETE statement targets all rows represented by p2 in the self-join.
    - Only the row with the smallest id for each email is preserved because it does not satisfy the condition p1.id < p2.id.

--------------

## 1667. Fix Names in a Table

## Problem Statement

The `Users` table contains user IDs and names. Names need to be corrected such that:
- The **first character** is uppercase.
- The **remaining characters** are lowercase.

The result table must be sorted by `user_id`.

---

## Input Structure
- The `Users` table includes:
  - `user_id` (int): The unique identifier for the user.
  - `name` (varchar): The name of the user, which may contain a mix of uppercase and lowercase letters.

---

## SQL Query

```sql
SELECT
    user_id,
    CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM
    Users
ORDER BY
    user_id;

```

## Explanation of the Query
1. Step 1: Transform the name
    - Use string functions to format the name:
        - LEFT(name, 1): Extracts the first character of the name.
        - UPPER(LEFT(name, 1)): Converts the first character to uppercase.
        - SUBSTRING(name, 2): Extracts the substring starting from the second character onward.
        - LOWER(SUBSTRING(name, 2)): Converts the rest of the substring to lowercase.
        - CONCAT: Combines the transformed parts (uppercase first character + lowercase remaining characters).
2. Step 2: Return Results
    - The query retrieves user_id and the corrected name for each user.
3. Step 3: Sort by user_id
    - Ensures the result table is ordered by user_id.

-------------------------

## 1484. Group Sold Products By The Date

## Problem Statement
You need to find the number of distinct products sold and their names for each date in the `Activities` table. The product names for each date should:
1. Be listed lexicographically (sorted alphabetically).
2. Be separated by commas in the result.

The result should be ordered by `sell_date`.

---

## Input Structure
- **Table**: `Activities`
  - `sell_date` (date): The date when a product was sold.
  - `product` (varchar): The name of the product sold.
- The table may contain duplicates.

---

## SQL Query

```sql
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM
    Activities
GROUP BY
    sell_date
ORDER BY
    sell_date;
```

## Explanation of the Query
1. Step 1: Count Unique Products Per Date
    - COUNT(DISTINCT product):
    - Counts the unique products sold for each sell_date.
2. Step 2: Concatenate Product Names
    - GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ','):
    - Gathers all unique product names for a given sell_date.
    - Sorts the product names lexicographically (ORDER BY product).
    - Joins the sorted names into a single string separated by commas (SEPARATOR ',').
3. Step 3: Group By sell_date
    - GROUP BY sell_date:
        - Ensures the calculation of num_sold and products is done for each unique sell_date.
4. Step 4: Sort By Date
    - ORDER BY sell_date:
        - Orders the result table by sell_date.

----------------------------------------------

# 1327. List the Products Ordered in a Period


## Problem Statement
You need to identify products from the `Products` and `Orders` tables that have a total number of units ordered in **February 2020** equal to or greater than **100**. The result should include the product name and the total units ordered.

---

## Input Structure
1. **Table: `Products`**
   - `product_id` (int): Unique ID for each product.
   - `product_name` (varchar): Name of the product.
   - `product_category` (varchar): Category of the product.

2. **Table: `Orders`**
   - `product_id` (int): Foreign key referring to `Products.product_id`.
   - `order_date` (date): Date when the order was placed.
   - `unit` (int): Number of units ordered on `order_date`.

---

## SQL Query

```sql
SELECT
    p.product_name,
    SUM(o.unit) AS unit
FROM
    Products p
JOIN
    Orders o
ON
    p.product_id = o.product_id
WHERE
    o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY
    p.product_id, p.product_name
HAVING
    SUM(o.unit) >= 100;
```

## Explanation
1. Step 1: Join the Tables
    - Products JOIN Orders ON p.product_id = o.product_id`:
        - Links the product details (product_name) from the Products table with the order details (order_date and unit) from the Orders table.
2. Step 2: Filter Orders in February 2020
    - o.order_date BETWEEN '2020-02-01' AND '2020-02-29':
    - Selects only the orders placed during February 2020.

3. Step 3: Calculate Total Units per Product
SUM(o.unit):
    - Aggregates the total units ordered for each product in February 2020.

4. Step 4: Filter Products with at Least 100 Units
    - HAVING SUM(o.unit) >= 100:
        - Filters out products where the total units ordered are less than 100.
5. Step 5: Group Results by Product
    - GROUP BY p.product_id, p.product_name:
        - Groups the aggregated results by product_id and product_name.
-----------------------------------

# 1527. Patients With a Condition


## Problem Statement
The task is to identify patients from the `Patients` table who have a condition starting with the prefix **DIAB1**, indicating **Type I Diabetes**. The result should include the `patient_id`, `patient_name`, and `conditions`.

---

## Input Structure
1. **Table: `Patients`**
   - `patient_id` (int): Unique ID for each patient.
   - `patient_name` (varchar): Name of the patient.
   - `conditions` (varchar): A space-separated list of condition codes for the patient.

---

## SQL Query

```sql
SELECT
    patient_id,
    patient_name,
    conditions
FROM
    Patients
WHERE
    conditions LIKE 'DIAB1%'        
    OR conditions LIKE '% DIAB1%'  
    OR conditions LIKE '% DIAB1'  
    OR conditions = 'DIAB1';     
```

## Explanation
1. Step 1: Identify Relevant Rows
    - The conditions column may contain multiple condition codes separated by spaces. To check for conditions that begin with DIAB1:

    - Conditions at the Start of the String: Use conditions LIKE 'DIAB1%' to find rows where the string starts with DIAB1.
        - Conditions in the Middle of the String: Use conditions LIKE '% DIAB1%' to find rows where DIAB1 appears after a space in the middle of the string.
        - Conditions at the End of the String: Use conditions LIKE '% DIAB1' to find rows where DIAB1 appears at the end of the string.
        - Exact Match: Use conditions = 'DIAB1' to account for cases where DIAB1 is the only condition in the string.
2. Step 2: Select and Return
Select the patient_id, patient_name, and conditions columns for all rows that meet any of the above criteria.

-------------------------------------

# 176. Second Highest Salary

## Problem Statement
Find the second-highest distinct salary from the Employee table. If there is no second-highest salary (e.g., only one unique salary exists), the query should return null.

## Input Structure
- Table: Employee
    - id (int): Primary key (unique for each row).
    - salary (int): Salary of the employee.


## SQL Implementation

```sql
SELECT
    (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        LIMIT 1, 1
    ) AS SecondHighestSalary;
```

## Explanation:
1. Subquery to Retrieve Salaries:

    - The DISTINCT salary ensures only unique salaries are considered.
    - The salaries are sorted in descending order (ORDER BY salary DESC).
    - The LIMIT 1, 1 skips the first salary (highest) and retrieves the second.

2. Outer Query:

    - Wraps the subquery to return the result as SecondHighestSalary.
    - If there is no second salary, the subquery will return null.

--------------------------
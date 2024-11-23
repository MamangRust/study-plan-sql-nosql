# Advanced Select and joins

# 180. Consecutive Numbers

### Problem Statement
We need to identify all numbers in a `Logs` table that appear at least three times consecutively.

### Input Structure
- **`Logs` Table**
  - `id` (integer): Auto-incrementing primary key.
  - `num` (varchar): Represents the number in the log entry.

### Output Structure
- **Result Table**
  - `ConsecutiveNums` (varchar): Unique numbers that appear at least three times consecutively.

### Example

#### Input:
```table
Logs Table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
```

#### Output:

```table
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
```

### Sql Query

```sql
SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT num,
           LAG(num) OVER (ORDER BY id) AS prev_num,
           LEAD(num) OVER (ORDER BY id) AS next_num
    FROM Logs
) AS consecutive_numbers
WHERE num = prev_num AND num = next_num;
```

### Explanation
- Key Steps:
    - Subquery:
        - Use LAG and LEAD window functions to calculate the prev_num (previous value) and next_num (next value) for each row.
    - Filter Condition:
        - num = prev_num AND num = next_num ensures we only select numbers appearing consecutively.
    - Distinct Values:
        - DISTINCT ensures only unique numbers are returned in the final result.


-----------------------------------------


# 1907. Count Salary Categories

## Problem Statement
We need to categorize bank accounts based on their monthly income into the following categories:
1. **Low Salary**: Income strictly less than $20,000.
2. **Average Salary**: Income between $20,000 and $50,000 (inclusive).
3. **High Salary**: Income strictly greater than $50,000.

The task is to count the number of accounts in each category and ensure all three categories are present in the result, even if there are no accounts for a category (return `0` in that case).

---

## Input Structure
- **`Accounts` Table**
  - `account_id` (int): Primary key representing the unique ID of the account.
  - `income` (int): Monthly income of the account holder.

---

## Output Structure
- **Result Table**
  - `category` (varchar): The salary category (`Low Salary`, `Average Salary`, `High Salary`).
  - `accounts_count` (int): The number of accounts in the category.

---

## Example

### Input:
```plaintext
Accounts Table:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
```

### Explanation:
- Low Salary: Only Account 2 has an income less than $20,000.
- Average Salary: No accounts have an income between $20,000 and $50,000.
- High Salary: Accounts 3, 6, and 8 have incomes greater than $50,000.


### SQL Query

```sql
WITH
    S AS (
        SELECT 'Low Salary' AS category
        UNION
        SELECT 'Average Salary'
        UNION
        SELECT 'High Salary'
    ),
    T AS (
        SELECT
            CASE
                WHEN income < 20000 THEN 'Low Salary'
                WHEN income > 50000 THEN 'High Salary'
                ELSE 'Average Salary'
            END AS category,
            COUNT(1) AS accounts_count
        FROM Accounts
        GROUP BY 1
    )
SELECT category, IFNULL(accounts_count, 0) AS accounts_count
FROM
    S
    LEFT JOIN T USING (category);
```

### Explanation
- Step 1: Create Salary Categories
    - The WITH S clause generates a temporary table S containing the three salary categories: Low Salary, Average Salary, and High Salary.

- Step 2: Categorize and Count Accounts
    - The WITH T clause computes the count of accounts for each category:

    - Use a CASE statement to classify incomes into Low Salary, Average Salary, or High Salary.
    - Group by the category to count the accounts in each group.

- Step 3: Ensure All Categories Are Present
    - Perform a LEFT JOIN between the categories (S) and the computed counts (T). Use IFNULL to replace NULL with 0 for any missing category.

- Step 4: Return Results
    - The final result contains all three categories with their respective account counts.

---------------------------------------------

# 1204. Last Person to Fit in the Bus

### Problem Statement
We are tasked with finding the **name of the last person** who can board a bus without exceeding the total weight limit of **1000 kg**. The table includes:
1. **`turn`**: Determines the order in which people board the bus.
2. **`weight`**: Weight of the individual.
3. The bus stops allowing people to board as soon as the total weight 


---

## Input Structure
- **`Queue` Table**
  - `person_id` (int): Unique ID for each person.
  - `person_name` (varchar): Name of the person.
  - `weight` (int): Weight of the person in kilograms.
  - `turn` (int): Order in which they board the bus.

---

## Output Structure
- **Result Table**
  - `person_name` (varchar): Name of the last person who successfully boards the bus.

---

## Example

### Input:
```plaintext
Queue Table:
+-----------+-------------+--------+------+
| person_id | person_name | weight | turn |
+-----------+-------------+--------+------+
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |
+-----------+-------------+--------+------+
```

### Output:

```plaintext
+-------------+
| person_name |
+-------------+
| John Cena   |
+-------------+
```

## Explanation:
The boarding process is as follows:

1. Alice boards first, bringing the total weight to 250.
2. Alex boards next, bringing the total weight to 600.
3. John Cena boards, reaching the weight limit of 1000. He is the last person to fit.
4. Marie tries to board but exceeds the weight limit (1200 > 1000), so she cannot board.
5. Bob and Winston are not considered.


```sql
WITH OrderedQueue AS (
    SELECT person_name, weight, turn
    FROM Queue
    ORDER BY turn
),
CumulativeWeight AS (
    SELECT person_name, weight, turn,
           SUM(weight) OVER (ORDER BY turn) AS total_weight
    FROM OrderedQueue
)
SELECT person_name
FROM CumulativeWeight
WHERE total_weight <= 1000
ORDER BY turn DESC
LIMIT 1;
```


## Explanation of the Query
- Step 1: Order the Queue
    The OrderedQueue Common Table Expression (CTE) orders all rows based on the turn column.

- Step 2: Calculate Cumulative Weight
    In the CumulativeWeight CTE:
    - Use SUM(weight) OVER (ORDER BY turn) to calculate the cumulative weight as each person boards.

- Step 3: Identify the Last Valid Person
    - Filter rows where total_weight <= 1000 to keep only valid boarders.
    - Use ORDER BY turn DESC to find the most recent valid person.
    - Use LIMIT 1 to return only the last valid person.


---------------------


## 1789. Primary Department for Each Employee



### Problem Statement
We are tasked to find the **primary department** for each employee from the `Employee` table:
1. **Primary Department**:
   - Defined by the `primary_flag = 'Y'`.
   - If no `Y` exists for an employee, the department they belong to (the only one) is considered their primary.
2. For employees with multiple departments:
   - The department marked with `primary_flag = 'Y'` is selected.
3. For employees with only one department:
   - That department is returned, regardless of the `primary_flag`.

---

## Input Structure
- **`Employee` Table**
  - `employee_id` (int): Unique ID for each employee.
  - `department_id` (int): ID of the department an employee belongs to.
  - `primary_flag` (varchar): Indicates whether the department is the primary one ('Y') or not ('N').

---

## Output Structure
- **Result Table**
  - `employee_id` (int): Employee ID.
  - `department_id` (int): ID of the employee's primary department.

---

## Example

### Input:
```plaintext
Employee Table:
+-------------+---------------+--------------+
| employee_id | department_id | primary_flag |
+-------------+---------------+--------------+
| 1           | 1             | N            |
| 2           | 1             | Y            |
| 2           | 2             | N            |
| 3           | 3             | N            |
| 4           | 2             | N            |
| 4           | 3             | Y            |
| 4           | 4             | N            |
+-------------+---------------+--------------+
```

### Output

```plaintext
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 1             |
| 3           | 3             |
| 4           | 3             |
+-------------+---------------+
```

### Explanation:
- Employee 1 belongs to only one department (1), so it is the primary department.
- Employee 2 has two departments, but department 1 is marked with Y, so it is the primary department.
- Employee 3 belongs to only one department (3), so it is the primary department.
- Employee 4 has three departments, but department 3 is marked with Y, so it is the primary department.


### SQL Query

```sql
SELECT
    employee_id,
    department_id
FROM
    Employee
WHERE
    primary_flag = 'Y' 
    OR employee_id NOT IN (
        SELECT DISTINCT employee_id
        FROM Employee
        WHERE primary_flag = 'Y'
    );

```

### Explanation of the Query
1. Step 1: Identify Primary Departments
    - The condition primary_flag = 'Y' selects employees whose primary department is explicitly marked.

2. Step 2: Handle Employees Without a Marked Primary Department
    - The NOT IN subquery identifies employees who lack a department marked as Y.
    - For such employees, all their rows are checked, and their single department is selected.


---------------------

## 1164. Product Price at a Given Date

## Problem Statement
We are tasked with finding the prices of all products on a specific date (`2019-08-16`):
1. Each row in the `Products` table records a **price change** for a product at a particular date.
2. If no change is recorded for a product before `2019-08-16`, assume its price is the default of **10**.
3. The final result must show each product's price on the target date.

---

## Input Structure
- **`Products` Table**:
  - `product_id` (int): Unique ID of the product.
  - `new_price` (int): Updated price of the product.
  - `change_date` (date): Date when the price was updated.
  - `(product_id, change_date)` is a composite primary key.

---

## Output Structure
- **Result Table**:
  - `product_id` (int): ID of the product.
  - `price` (int): The price of the product on `2019-08-16`.

---

## Example

### Input:

```plaintext
Products Table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
```

### Output

```plaintext
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
```

## Explanation:
1. Product 1:

    - Changes: 20 on 2019-08-14, 30 on 2019-08-15, and 35 on 2019-08-16.
    - On 2019-08-16, the price is 35.

2. Product 2:
    - Changes: 50 on 2019-08-14, and 65 on 2019-08-17.
    - On 2019-08-16, the latest price before the target date is 50.

3. Product 3:
    - No changes before 2019-08-16.
    - Default price is 10.

## SQL Query

```sql
WITH
    T AS (
        SELECT DISTINCT product_id
        FROM Products
    ),
    P AS (
        SELECT
            product_id,
            new_price AS price
        FROM Products
        WHERE
            (product_id, change_date) IN (
                SELECT
                    product_id,
                    MAX(change_date) AS change_date
                FROM Products
                WHERE change_date <= '2019-08-16'
                GROUP BY product_id
            )
    )
SELECT
    T.product_id,
    COALESCE(P.price, 10) AS price
FROM
    T
    LEFT JOIN P USING (product_id);
```


### Explanation of the Query
1. Step 1: Distinct Product IDs
    - T selects all unique product_ids from the Products table.
2. Step 2: Latest Prices Before Target Date
    - P finds the latest price change for each product before or on 2019-08-16:
    - The MAX(change_date) ensures we get the most recent change date for each product_id.
    - The WHERE change_date <= '2019-08-16' restricts changes to those occurring on or before the target date.
3. Step 3: Combine Results with Default Prices
    - A LEFT JOIN between T and P ensures all products are included.
    - COALESCE(P.price, 10) assigns a default price of 10 to products with no recorded changes.
--------------------

## 610. Triangle Judgement

## Problem Statement
The task is to determine whether three line segments, represented by their lengths \(x\), \(y\), and \(z\), can form a triangle. 

To form a triangle, the following conditions must be met (Triangle Inequality Theorem):
1. \(x + y > z\)
2. \(x + z > y\)
3. \(y + z > x\)

### Input Structure
The `Triangle` table contains:
- `x`: Length of the first segment.
- `y`: Length of the second segment.
- `z`: Length of the third segment.

### Output Structure
The result table must include:
- `x`: Length of the first segment.
- `y`: Length of the second segment.
- `z`: Length of the third segment.
- `triangle`: A string indicating whether the segments can form a triangle. It should be "Yes" if the segments can form a triangle, and "No" otherwise.

---

## Example 1

### Input:
```plaintext
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
```

### Output:

```plaintext
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+
```

### SQL Query

```sql
SELECT
    x,
    y,
    z,
    CASE
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM
    Triangle;
```

## Explanation of the Query

### Step 1: Evaluate Triangle Conditions
- The `CASE` statement is used to evaluate whether three line segments \((x, y, z)\) can form a triangle.
- To satisfy the triangle condition, all of the following inequalities must be **true**:
  1. \(x + y > z\)
  2. \(x + z > y\)
  3. \(y + z > x\)
- If **all conditions are true**, the `triangle` column is set to **"Yes"**.
- If **any condition fails**, the `triangle` column is set to **"No"**.

### Step 2: Select and Return
- The query selects:
  - The original segment lengths: \(x\), \(y\), and \(z\).
  - The computed result, stored in the `triangle` column.
- The result is generated for each row in the `Triangle` table.

----------------------------------
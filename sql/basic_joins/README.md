## 1378. Replace Employee ID With The Unique Identifier


### Problem Statement

The task is to replace the employee ID with the **unique ID** for each employee. If an employee does not have a unique ID, then the result should show `null` for their unique ID. The task involves joining two tables: one containing employee details and another with employee IDs and their corresponding unique identifiers.

### Input Tables Structure

#### Employees Table

The `Employees` table contains the following columns:

- **`id`**: The unique identifier for the employee (Primary Key).
- **`name`**: The name of the employee.

#### EmployeeUNI Table

The `EmployeeUNI` table contains the following columns:

- **`id`**: The unique identifier for the employee (Primary Key).
- **`unique_id`**: The unique identifier assigned to the employee.

### Constraints

- If the employee has a corresponding unique ID in the `EmployeeUNI` table, it should be returned. Otherwise, return `null`.

---

### Example Input

#### Employees Table

```table
| id  | name     |
|-----|----------|
| 1   | Alice    |
| 7   | Bob      |
| 11  | Meir     |
| 90  | Winston  |
| 3   | Jonathan |
```


#### EmployeeUNI Table

```table
| id  | unique_id |
|-----|-----------|
| 3   | 1         |
| 11  | 2         |
| 90  | 3         |
```

#### Example Output

```table
| unique_id | name     |
|-----------|----------|
| null      | Alice    |
| null      | Bob      |
| 2         | Meir     |
| 3         | Winston  |
| 1         | Jonathan |
```

### SQL Implementation
To solve this problem in SQL, we can use a LEFT JOIN between the Employees and EmployeeUNI tables. This will allow us to include all employees from the Employees table, and for those that do not have a corresponding unique ID in the EmployeeUNI table, the result will show null.

### SQL Query

```sql
SELECT
    e.name,
    u.unique_id
FROM Employees e
LEFT JOIN EmployeeUNI u ON e.id = u.id;
```


### Explanation
- ``LEFT JOIN``N: This ensures that all rows from the Employees table are returned, even if there is no matching row in the EmployeeUNI table.
- ``e.id = u.id``: We join the tables on the id column.
- ``u.unique_id``: If a matching id is found in the EmployeeUNI table, the corresponding unique_id is returned. If no match is found, null is returned for unique_id.


### NoSQL(MongoDB) Implementation

In MongoDB, we can achieve this using a $lookup stage in the aggregation pipeline to join the Employees collection with the EmployeeUNI collection. The result will include the employee's unique_id, if available, otherwise null.

### MongoDB Query

```javascript
db.employees.aggregate([
  {
    $lookup: {
      from: "employeeuni",
      localField: "id",
      foreignField: "id",
      as: "unique_info"
    }
  },
  {
    $project: {
      name: 1,
      unique_id: { $ifNull: [{ $arrayElemAt: ["$unique_info.unique_id", 0] }, null] }
    }
  }
]);
```


### Explanation

1. ``$lookup``: This stage performs the join between the employees collection and the employeeuni collection based on the id field. The results of the join are stored in the unique_info array.
2. ``$project``: This stage reshapes the output, selecting the name field and extracting the unique_id from the unique_info array. If no unique ID is found (i.e., the array is empty), the $ifNull operator will return null instead.
3. ``$arrayElemAt``: This operator is used to retrieve the first element from the unique_info array (which contains the joined data). If no match is found, it returns null.

-----

## 1068. Product Sales Analysis I

### Problem Statement

The task is to report the **product name**, **year**, and **price** for each sale in the **Sales** table. Each sale record corresponds to a product sold in a specific year. The product names are stored in a separate **Product** table. Your goal is to join the **Sales** table with the **Product** table and return the desired details.

### Input Tables Structure

#### Sales Table

The `Sales` table contains the following columns:

- **`sale_id`**: The unique identifier for the sale (Primary Key).
- **`product_id`**: The identifier of the product sold (Foreign Key to `Product` table).
- **`year`**: The year in which the sale occurred.
- **`quantity`**: The quantity of the product sold.
- **`price`**: The price per unit of the product sold.

#### Product Table

The `Product` table contains the following columns:

- **`product_id`**: The unique identifier for the product (Primary Key).
- **`product_name`**: The name of the product.

### Constraints

- The `sale_id` and `year` combination in the `Sales` table is unique, meaning each sale record is unique.
- The `product_id` in the `Sales` table references a `product_id` in the `Product` table, establishing a relationship between products and their sales.

---

### Example Input

#### Sales Table

```table
| sale_id | product_id | year | quantity | price |
|---------|------------|------|----------|-------|
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
```

#### Product Table

```table
| product_id | product_name |
|------------|--------------|
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |

```

#### Example Output

```table
| product_name | year  | price |
|--------------|-------|-------|
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |
```

### SQL Implementation
To solve this problem in SQL, we will use a JOIN operation to combine the Sales and Product tables based on the product_id field. The query will then select the required columns: product_name, year, and price.


### SQL Query

```sql
SELECT p.product_name, s.year, s.price
FROM Sales s
JOIN Product p ON s.product_id = p.product_id;
```

### Explanation
- ``JOIN``: This operation joins the Sales table and the Product table on the product_id column. This allows us to access the product names from the Product table and match them with the sales in the Sales table.
- ``s.year and s.price``: These fields are selected from the Sales table, and they represent the year of the sale and the price of the product for that sale.

### NOSQL(MongoDB) Implementation

In MongoDB, we can use an aggregation pipeline to achieve the same result. We will use the $lookup stage to join the Sales collection with the Product collection, and then project the necessary fields.

### MongoDB Query

```javascript
db.sales.aggregate([
  {
    $lookup: {
      from: "product",
      localField: "product_id",
      foreignField: "product_id",
      as: "product_info"
    }
  },
  {
    $unwind: "$product_info"
  },
  {
    $project: {
      product_name: "$product_info.product_name",
      year: 1,
      price: 1
    }
  }
]);
```

### Explanation
1. ``$lookup``: This stage joins the sales collection with the product collection based on the product_id field. The result is stored in the product_info array.
2. ``$unwind``: Since $lookup returns an array, we use $unwind to flatten the array into individual documents.
3. ``$project``: This stage reshapes the output, selecting the product_name from the product_info array and the year and price fields from the sales collection.

---------------

## 1581. Customer Who Visited but Did Not Make Any Transactions

### Problem Statement

The goal of this problem is to find the customers who visited a mall but did not make any transactions, and to count how many times these customers visited without making any transactions. A customer can have multiple visits, and some of those visits may involve transactions, while others may not.

### Input Tables Structure

#### Visits Table

The `Visits` table contains the following columns:

- **`visit_id`**: The unique identifier for each visit (Primary Key).
- **`customer_id`**: The identifier of the customer who visited the mall.

#### Transactions Table

The `Transactions` table contains the following columns:

- **`transaction_id`**: The unique identifier for each transaction (Primary Key).
- **`visit_id`**: The identifier of the visit associated with the transaction (Foreign Key to `Visits` table).
- **`amount`**: The amount spent in the transaction.

### Problem Breakdown

- You need to find the customers who visited the mall but did not make any transactions.
- For each of those customers, you also need to count how many visits they made without transactions.

---

### Example Input

#### Visits Table

```table
| visit_id | customer_id |
|----------|-------------|
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |


```

#### Transactions Table

```table
| transaction_id | visit_id | amount |
|----------------|----------|--------|
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |
```

#### Example Output

```table
| customer_id | count_no_trans |
|-------------|----------------|
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
```

#### Explanation:
- Customer with ID = 23: Made one transaction during visit 1.
- Customer with ID = 9: Made one transaction during visit 2.
- Customer with ID = 30: Visited once without making a transaction.
- Customer with ID = 54: Visited three times. Two visits had no transactions, and one had multiple transactions.
- Customer with ID = 96: Visited once without making any transactions.


### SQL Implementation
In SQL, we can use a LEFT JOIN to find visits with no transactions, group by customer, and count the visits without transactions.

### SQL Query

```sql
SELECT v.customer_id, COUNT(v.visit_id) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;
```

### Explanation:
- ``LEFT JOIN``: We use a LEFT JOIN to include all visits, even those without a matching transaction. This ensures that visits without transactions will have NULL values in the Transactions table.
- ``WHERE t.transaction_id IS NULL``: This condition filters out the visits that have corresponding transactions, leaving only those without transactions.
- ``GROUP BY v.customer_id``: This groups the result by customer_id, counting how many visits each customer made without transactions.


### NoSQL (MongoDB) Implementation
In MongoDB, we can use the aggregation framework to achieve the same result. We can use $lookup to join the Visits collection with the Transactions collection, $match to filter visits without transactions, and $group to count them.

### MongoDB Query

```js
db.visits.aggregate([
  {
    $lookup: {
      from: "transactions",
      localField: "visit_id",
      foreignField: "visit_id",
      as: "transaction_info"
    }
  },
  {
    $match: {
      "transaction_info": { $size: 0 }
    }
  },
  {
    $group: {
      _id: "$customer_id",
      count_no_trans: { $sum: 1 }
    }
  },
  {
    $project: {
      customer_id: "$_id",
      count_no_trans: 1,
      _id: 0
    }
  }
]);
```

### Explanation:
- ``$lookup``: This stage joins the visits collection with the transactions collection based on the visit_id. It creates an array of transaction_info for each visit.
- ``$match``: This stage filters for visits where the transaction_info array is empty ($size: 0), meaning these visits had no transactions.
- ``$group``: This groups the result by customer_id and counts how many visits the customer made without transactions ($sum: 1).
- ``$project``: This reshapes the output to show only the customer_id and count_no_trans, removing the _id field.

-------------------


## 197. Rising Temperature


## Problem Statement

The goal of this problem is to find all the dates where the recorded temperature was higher than the previous day's temperature. You need to return the IDs of the rows corresponding to these dates.

### Input Table Structure

#### Weather Table

The `Weather` table contains the following columns:

- **`id`**: A unique identifier for each record (Primary Key).
- **`recordDate`**: The date of the temperature record.
- **`temperature`**: The temperature recorded on that date.

### Example Input

```table
| id | recordDate | temperature |
|----|------------|-------------|
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |

```

### Example Ouput

```table
| id |
|----|
| 2  |
| 4  |
```

### Explanation:
- On 2015-01-02, the temperature (25) was higher than the previous day (2015-01-01: 10).
- On 2015-01-04, the temperature (30) was higher than the previous day (2015-01-03: 20).
No other dates meet the criteria.


### SQL Implementation
In SQL, you can use self-join to compare the temperature of a date with the temperature of the previous day.


### SQL Query

```sql
SELECT w1.id
FROM Weather w1
JOIN Weather w2
ON DATE_ADD(w2.recordDate, INTERVAL 1 DAY) = w1.recordDate
WHERE w1.temperature > w2.temperature;
```


### Explanation:
- Self-Join (JOIN): Join the Weather table with itself. The condition ensures that w2.recordDate is one day before w1.recordDate.
- Comparison (WHERE): Filter records where the temperature on w1 is higher than the temperature on w2.
- Select: Return the IDs of the rows (w1.id) where the condition is met.

### NoSQL (MongoDB) Implementation
In MongoDB, you can use the aggregation framework to achieve the same result by sorting and grouping the data, then using $expr for comparisons.

### MongoDB Query

```js
db.weather.aggregate([
  {
    $sort: { recordDate: 1 }
  },
  {
    $lookup: {
      from: "weather",
      let: { currentDate: "$recordDate", currentTemp: "$temperature" },
      pipeline: [
        {
          $match: {
            $expr: {
              $eq: ["$recordDate", { $dateSubtract: { startDate: "$$currentDate", unit: "day", amount: 1 } }]
            }
          }
        }
      ],
      as: "previousDay"
    }
  },
  {
    $unwind: "$previousDay"
  },
  {
    $match: {
      $expr: {
        $gt: ["$temperature", "$previousDay.temperature"]
      }
    }
  },
  {
    $project: {
      id: 1,
      _id: 0
    }
  }
]);
```

### Explanation:
- ``$sort``: Sort the documents by recordDate in ascending order to ensure proper processing.
- ``$lookup``: Perform a self-join where each document looks for the record of the previous day by subtracting one day from its recordDate.
- ``$unwind``: Flatten the array resulting from the $lookup stage.
- ``$match``: Filter records where the current day's temperature is higher than the previous day's temperature.
- ``$project``: Output only the id field of the matched documents.

---------------------------


## 1661. Average Time of Process per Machine

### Problem Statement

The objective is to calculate the average time each machine takes to complete a process. Each process has a `start` and `end` timestamp, and the time to complete a process is the difference between the `end` and `start` timestamps. The average time for a machine is the total time for all its processes divided by the number of processes, rounded to 3 decimal places.

---

### Input Table Structure

#### Activity Table

| Column Name    | Type    | Description                                 |
|----------------|---------|---------------------------------------------|
| `machine_id`   | `int`   | Unique ID of the machine.                  |
| `process_id`   | `int`   | Unique ID of the process running on the machine. |
| `activity_type`| `enum`  | Can be `'start'` or `'end'`.               |
| `timestamp`    | `float` | Time in seconds for the activity.          |

- **Primary Key**: (`machine_id`, `process_id`, `activity_type`)
- Each (`machine_id`, `process_id`) pair always has a `'start'` and `'end'` activity.
- `'start'` timestamp will always precede `'end'`.

---

### Example Input and Output

#### Input Table

```table
| machine_id | process_id | activity_type | timestamp |
|------------|------------|---------------|-----------|
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |
```

#### Output Table

```table
| machine_id | processing_time |
|------------|-----------------|
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
```


### SQL Solution
The task can be solved by grouping the processes by machine_id and calculating the difference between the end and start timestamps for each process_id.

### SQL Query

```sql
WITH ProcessTime AS (
    SELECT
        machine_id,
        process_id,
        MAX(CASE WHEN activity_type = 'end' THEN timestamp END) -
        MAX(CASE WHEN activity_type = 'start' THEN timestamp END) AS process_time
    FROM Activity
    GROUP BY machine_id, process_id
)
SELECT
    machine_id,
    ROUND(AVG(process_time), 3) AS processing_time
FROM ProcessTime
GROUP BY machine_id;
```


### Explanation
1. WITH ProcessTime:
  - Calculate the process time for each machine_id and process_id.
  - Use conditional aggregation (CASE WHEN) to extract the end and start timestamps and compute their difference.


2. Final Selection:

  - Calculate the average process time for each machine_id using AVG and round the result to 3 decimal places using ROUND.


### MongoDB Solution
In MongoDB, we can use the aggregation framework to calculate the average processing time per machine.

### MongoDB Query

```javascript
db.activity.aggregate([
  {
    $group: {
      _id: { machine_id: "$machine_id", process_id: "$process_id" },
      start_time: { $max: { $cond: [{ $eq: ["$activity_type", "start"] }, "$timestamp", null] } },
      end_time: { $max: { $cond: [{ $eq: ["$activity_type", "end"] }, "$timestamp", null] } }
    }
  },
  {
    $project: {
      machine_id: "$_id.machine_id",
      process_time: { $subtract: ["$end_time", "$start_time"] }
    }
  },
  {
    $group: {
      _id: "$machine_id",
      avg_processing_time: { $avg: "$process_time" }
    }
  },
  {
    $project: {
      machine_id: "$_id",
      processing_time: { $round: ["$avg_processing_time", 3] }
    }
  }
]);
```


### Explanation
1. $group (First Stage):

  - Group by machine_id and process_id to compute the start_time and end_time for each process.

2. $project (Second Stage):

  - Calculate the process time (end_time - start_time) for each process.

3. $group (Third Stage):

  - Group by machine_id to calculate the average processing time across all processes for each machine.

4. $project (Final Stage):

  - Round the result to 3 decimal places using $round.

------------

## 577. Employee Bonus

### Problem Statement

The objective is to find the name and bonus amount of employees whose bonus is less than 1000. If an employee is not listed in the `Bonus` table, assume their bonus is `null`.

---

### Input Table Structure

#### Employee Table

| Column Name  | Type    | Description                                |
|--------------|---------|--------------------------------------------|
| `empId`      | `int`   | Unique ID for each employee.              |
| `name`       | `varchar` | Name of the employee.                  |
| `supervisor` | `int`   | ID of the employee's supervisor.           |
| `salary`     | `int`   | Salary of the employee.                   |

- **Primary Key**: `empId`.

#### Bonus Table

| Column Name | Type   | Description                     |
|-------------|--------|---------------------------------|
| `empId`     | `int`  | Unique ID of the employee.     |
| `bonus`     | `int`  | Bonus amount of the employee.  |

- **Primary Key**: `empId`.
- **Foreign Key**: `empId` in the `Bonus` table references `empId` in the `Employee` table.

---

### Example Input and Output

#### Input Tables

**Employee Table**

```table
| empId | name   | supervisor | salary |
|-------|--------|------------|--------|
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
```

#### Bonus Table

```table
| empId | bonus |
|-------|-------|
| 2     | 500   |
| 4     | 2000  |
```

#### Output Table

```table
| name   | bonus |
|--------|-------|
| Brad   | null  |
| John   | null  |
| Dan    | 500   |
```

### SQL Solution
The task can be solved using a LEFT JOIN between the Employee and Bonus tables to include all employees and their corresponding bonuses. Then, filter the results where the bonus is less than 1000 or is null.


### SQL Query

```sql
SELECT
    e.name,
    b.bonus
FROM
    Employee e
LEFT JOIN
    Bonus b
ON
    e.empId = b.empId
WHERE
    b.bonus < 1000 OR b.bonus IS NULL;
```

### Explanation
1. LEFT JOIN:

  - Retrieve all records from the Employee table.
  - Include matching records from the Bonus table, or null if there is no match.

2. Filter Condition:

  - Use WHERE b.bonus < 1000 OR b.bonus IS NULL to filter employees whose bonus is either:
    - Less than 1000, or
    - Not listed in the Bonus table (bonus is null).

### NoSQL(MongoDB)

In MongoDB, we can use the aggregation framework to join the two collections and filter the results based on the bonus condition.

### MongoDB Query

```javascript
db.employee.aggregate([
  {
    $lookup: {
      from: "bonus",
      localField: "empId",
      foreignField: "empId",
      as: "bonus_info"
    }
  },
  {
    $unwind: {
      path: "$bonus_info",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $project: {
      name: 1,
      bonus: { $ifNull: ["$bonus_info.bonus", null] }
    }
  },
  {
    $match: {
      $or: [{ bonus: { $lt: 1000 } }, { bonus: null }]
    }
  }
]);
```


### Explanation
1. $lookup:

  - Perform a join between the employee collection and the bonus collection using empId.
2. $unwind:

- Flatten the bonus_info array, and retain records with no bonus using preserveNullAndEmptyArrays: true.

3. $project:

- Include the name field and compute the bonus field, defaulting to null if no bonus exists.

4. $match:

- Filter employees whose bonus is either:
  - Less than 1000, or
  - null.

-----------

## 1280. Students and Examinations

### Problem Statement

The goal is to generate a report that displays the number of times each student attended each exam, including cases where a student did not attend a particular subject exam. The output should include all students and all subjects.

---

### Input Table Structure

#### Students Table

| Column Name   | Type     | Description                                |
|---------------|----------|--------------------------------------------|
| `student_id`  | `int`    | Unique ID for each student.               |
| `student_name`| `varchar`| Name of the student.                      |

- **Primary Key**: `student_id`.

#### Subjects Table

| Column Name   | Type     | Description                                |
|---------------|----------|--------------------------------------------|
| `subject_name`| `varchar`| Unique name of each subject.              |

- **Primary Key**: `subject_name`.

#### Examinations Table

| Column Name   | Type     | Description                                |
|---------------|----------|--------------------------------------------|
| `student_id`  | `int`    | ID of the student who attended the exam.  |
| `subject_name`| `varchar`| Name of the subject for the attended exam.|

- **No Primary Key**: Table may contain duplicates.

---

### Example Input and Output

#### Input Tables

#### Students Table

```table
| student_id | student_name |
|------------|--------------|
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
```

#### Subjects Table

```table
| subject_name |
|--------------|
| Math         |
| Physics      |
| Programming  |
```

#### Examinations Table

```table
| student_id | subject_name |
|------------|--------------|
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
```

#### Output Table

```table
| student_id | student_name | subject_name | attended_exams |
|------------|--------------|--------------|----------------|
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
```

### SQL Solution

To solve this problem in SQL, use a Cartesian Product to generate all possible combinations of students and subjects, then left join with the Examinations table to count attendance.

### SQL QUERY

```sql
WITH AllCombinations AS (
    SELECT
        s.student_id,
        s.student_name,
        sub.subject_name
    FROM
        Students s
    CROSS JOIN
        Subjects sub
)
SELECT
    ac.student_id,
    ac.student_name,
    ac.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM
    AllCombinations ac
LEFT JOIN
    Examinations e
ON
    ac.student_id = e.student_id AND ac.subject_name = e.subject_name
GROUP BY
    ac.student_id, ac.student_name, ac.subject_name
ORDER BY
    ac.student_id, ac.subject_name;
```


### Explanation
1. Generate All Combinations:

  - Use CROSS JOIN to create all combinations of students and subjects.

2. Join and Count:

  - Perform a LEFT JOIN with the Examinations table to include attendance records, if any.
  - Use COUNT() to calculate the number of exams attended per combination.

3. Group and Sort:

  - Group by student_id, student_name, and subject_name for accurate counts.
  - Order the results by student_id and subject_name to match the required format.


### MONGODB Impl

In MongoDB, use the aggregation framework to achieve the same result by combining all students and subjects, then computing attendance.


### MongoDB Query

```js

// Step 1: Generate all combinations of students and subjects
const students = db.students.find().toArray();
const subjects = db.subjects.find().toArray();

const combinations = [];
students.forEach(student => {
  subjects.forEach(subject => {
    combinations.push({
      student_id: student.student_id,
      student_name: student.student_name,
      subject_name: subject.subject_name
    });
  });
});

// Step 2: Compute attendance
db.examinations.aggregate([
  {
    $group: {
      _id: { student_id: "$student_id", subject_name: "$subject_name" },
      count: { $sum: 1 }
    }
  },
  {
    $lookup: {
      from: "students",
      localField: "_id.student_id",
      foreignField: "student_id",
      as: "student_info"
    }
  },
  {
    $unwind: "$student_info"
  },
  {
    $project: {
      student_id: "$_id.student_id",
      student_name: "$student_info.student_name",
      subject_name: "$_id.subject_name",
      attended_exams: "$count"
    }
  }
]);
```


## Explanation
1. Generate Combinations:

  - Use JavaScript to create all combinations of students and subjects.

2. Aggregate Attendance:

- Group records in the examinations collection by student_id and subject_name to calculate attendance.

3. Enrich Data:

- Use $lookup to fetch student names from the students collection.

4. Output:

- Format and output the required fields: student_id, student_name, subject_name, and attended_exams.

---------------------------------


## 570. Managers with at Least 5 Direct Reports


The task is to find managers with at least five direct reports based on the Employee table. The managerId column identifies the manager for each employee. If managerId is null, the employee does not have a manager. An employee can directly report to only one manager.

### SQL Solution

The SQL query should group employees by their managerId, count the number of direct reports, and filter managers with at least five direct reports.

#### SQL Query

```sql
SELECT
    e1.name
FROM
    Employee e1
JOIN
    Employee e2
ON
    e1.id = e2.managerId
GROUP BY
    e1.id, e1.name
HAVING
    COUNT(e2.id) >= 5;
```

### Explanation
1. Join Table:

  - Join the Employee table with itself (e1 and e2) on e1.id = e2.managerId to match managers with their direct reports.

2. Group by Manager:

  - Group by the manager's id and name to calculate the number of direct reports.

3. Filter Managers:

  - Use HAVING COUNT(e2.id) >= 5 to include only managers with at least 5 direct reports.

4. Select Name:

  - Retrieve the names of managers.

### MongoDB Solution
In MongoDB, use the aggregation framework to group by managerId and count the number of direct reports. Then filter for managers with at least five direct reports and fetch their names.

### MongoDB Query

```js
db.employees.aggregate([
  {
    $match: { managerId: { $ne: null } } // Ignore employees without managers
  },
  {
    $group: {
      _id: "$managerId",
      directReports: { $sum: 1 }
    }
  },
  {
    $match: { directReports: { $gte: 5 } } // Filter managers with at least 5 reports
  },
  {
    $lookup: {
      from: "employees",
      localField: "_id",
      foreignField: "id",
      as: "manager"
    }
  },
  {
    $unwind: "$manager"
  },
  {
    $project: {
      _id: 0,
      name: "$manager.name"
    }
  }
]);
```

### Explanation
1. Filter by Manager Presence:

- Exclude records where managerId is null.

2. Group by managerId:

- Use $group to count the number of direct reports for each manager.

3. Filter by Direct Reports:

- Use $match to include only managers with at least 5 direct reports.

4. Lookup Manager Details:

- Use $lookup to fetch the manager's details (like name) by matching id with managerId.

5. Format Output:

- Use $project to display only the manager's name.

----------------


## 1934. Confirmation Rate

### SQL Solution
To calculate the confirmation rate for each user, we need to compute the ratio of confirmed messages to total requested messages. For users who haven't requested any confirmation messages, the rate should be 0.


```sql
SELECT
    s.user_id,
    ROUND(COALESCE(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) / COUNT(c.action), 0), 2) AS confirmation_rate
FROM
    Signups s
LEFT JOIN
    Confirmations c
ON
    s.user_id = c.user_id
GROUP BY
    s.user_id;
```

### Explanation

1. Join Tables:

- Use a LEFT JOIN to include all users from the Signups table, even if they don't have entries in the Confirmations table.


2. Count Confirmed Messages:

- Use CASE WHEN to count the number of 'confirmed' actions.

3. Calculate Total Requests:

- Use COUNT(c.action) to find the total number of confirmation messages.

4. Handle Missing Data:

- Use COALESCE to handle cases where there are no confirmations (NULL values), setting the rate to 0.

5. Round the Result:

- Use ROUND to round the confirmation rate to 2 decimal places.

6. Group by User:

- Group by s.user_id to compute the metrics for each user.

### MongoDB

In MongoDB, the aggregation framework can be used to compute the confirmation rate for each user.

### MongoDB Query
```js
db.signups.aggregate([
  {
    $lookup: {
      from: "confirmations",
      localField: "user_id",
      foreignField: "user_id",
      as: "confirmations"
    }
  },
  {
    $addFields: {
      total_requests: { $size: "$confirmations" },
      confirmed_count: {
        $size: {
          $filter: {
            input: "$confirmations",
            as: "confirmation",
            cond: { $eq: ["$$confirmation.action", "confirmed"] }
          }
        }
      }
    }
  },
  {
    $addFields: {
      confirmation_rate: {
        $cond: [
          { $eq: ["$total_requests", 0] },
          0,
          { $round: [{ $divide: ["$confirmed_count", "$total_requests"] }, 2] }
        ]
      }
    }
  },
  {
    $project: {
      _id: 0,
      user_id: 1,
      confirmation_rate: 1
    }
  }
]);

```

### Explanation
1. Join Tables:

- Use $lookup to join Signups with Confirmations based on user_id.

2. Count Confirmations:

- Use $filter to count the number of 'confirmed' actions in the confirmations array.

3. Count Total Requests:

- Use $size to calculate the total number of requests (length of the confirmations array).

4. Calculate Confirmation Rate:

- Use $divide to calculate the confirmation rate.
- Handle cases where no requests exist using $cond.

5. Round the Result:

- Use $round to round the result to 2 decimal places.

6. Output Result:

- Use $project to include only user_id and confirmation_rate.


----------------------

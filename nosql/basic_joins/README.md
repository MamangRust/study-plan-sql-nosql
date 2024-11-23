## 1378. Replace Employee ID With The Unique Identifier


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

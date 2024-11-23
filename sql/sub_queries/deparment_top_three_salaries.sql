SELECT Department.name AS Department, e1.name AS Employee, e1.salary AS Salary
FROM Employee AS e1
JOIN Department ON Department.id = e1.departmentId
WHERE (
  SELECT COUNT(DISTINCT salary)
  FROM Employee AS e2
  WHERE e2.departmentId = e1.departmentId AND e2.salary > e1.salary
) < 3;

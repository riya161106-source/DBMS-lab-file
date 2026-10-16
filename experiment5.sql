--AIM:
--To create SQL views for department salary summary and employee hierarchy, test the updatability of views, and implement a recursive CTE to display reporting chains.

--SOURCE CODE:
--1. Create Department Table:
CREATE TABLE Department5 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(30)
);
--2. Insert Departments:
INSERT INTO Department5 VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');
--3. Create Employee Table:
CREATE TABLE Employee5 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(30),
    dept_id INT,
    manager_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES Department5(dept_id)
);
--4. Insert Employee Records:
INSERT INTO Employee5 VALUES
(1, 'Riya', 1, NULL, 75000),
(2, 'Aradhana', 1, 1, 65000),
(3, 'Shatakshi', 1, 1, 60000),
(4, 'Aman', 2, NULL, 55000),
(5, 'Priya', 2, 4, 50000),
(6, 'Rahul', 3, NULL, 70000),
(7, 'Neha', 3, 6, 60000);
--5. Create View For Department Salary Summary:
CREATE VIEW Department_Salary_Summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary
FROM Department5 d
LEFT JOIN Employee5 e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;
--6. Display Department Salary Summary:
SELECT * FROM Department_Salary_Summary;

--7. Create View For Employee Hierarchy:
CREATE VIEW Employee_Hierarchy AS
SELECT
    e.emp_id,
    e.emp_name,
    e.manager_id,
    m.emp_name AS manager_name,
    e.dept_id,
    e.salary
FROM Employee5 e
LEFT JOIN Employee5 m
ON e.manager_id = m.emp_id;
--8. Display Employee Hierarchy
SELECT * FROM Employee_Hierarchy;

--9. Test Updatability Of View:
The Employee_Hierarchy view is based mainly on a single employee table with a self-join. To demonstrate an update through the view, use the following query:
Query
UPDATE Employee_Hierarchy
SET salary = 68000
WHERE emp_id = 2;
Verify the Update:
SELECT * 
FROM Employee_Hierarchy
WHERE emp_id = 2;

--10. Test Department Salary View:
UPDATE Department_Salary_Summary
SET average_salary = 70000
WHERE dept_id = 1;
--Output:
ERROR 1288: The target table Department_Salary_Summary
of the UPDATE is not updatable
--Conclusion:
--Department_Salary_Summary is not updatable because it contains aggregate functions and GROUP BY.

--11. Recursive CTE – Display Reporting Chain:
WITH RECURSIVE ReportingChain AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level,
        CAST(emp_name AS CHAR(200)) AS reporting_chain
    FROM Employee5
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1,
        CONCAT(rc.reporting_chain, ' -> ', e.emp_name)
    FROM Employee5 e
    INNER JOIN ReportingChain rc
    ON e.manager_id = rc.emp_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level,
    reporting_chain
FROM ReportingChain
ORDER BY reporting_chain;

--12. Display Complete Reporting Hierarchy:
WITH RECURSIVE ReportingChain AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee5
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1
    FROM Employee5 e
    JOIN ReportingChain rc
    ON e.manager_id = rc.emp_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level
FROM ReportingChain
ORDER BY level, emp_id; 

--Result:
--Thus, SQL views for department salary summary and employee hierarchy were successfully created and tested. The updatability of the views was examined, and a recursive CTE was successfully implemented to display employee reporting chains.


--AIM:
--To write and execute SQL queries using the Employee schema with INNER JOIN, LEFT JOIN, SELF JOIN, 3-WAY JOIN, CORRELATED SUBQUERIES, EXISTS, simulated INTERSECT and EXCEPT, and to compare execution plans using EXPLAIN.

--1. INNER JOIN:
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id;

--2. LEFT JOIN:
SELECT 
    e.emp_id,
    e.emp_name,
    p.project_name
FROM Employee e
LEFT JOIN Project p
ON e.project_id = p.project_id;

--3. SELF JOIN:
SELECT 
    e1.emp_name AS Employee1,
    e2.emp_name AS Employee2,
    e1.dept_id
FROM Employee e1
INNER JOIN Employee e2
ON e1.dept_id = e2.dept_id
AND e1.emp_id < e2.emp_id;

--4. THREE-WAY JOIN:
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id
INNER JOIN Project p
ON e.project_id = p.project_id;

--5. CORRELATED SUBQUERY:
SELECT
    e.emp_id,
    e.emp_name,
    e.dept_id,
    e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);

--6. EXIST:
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT *
    FROM Employee e2
    WHERE e2.emp_id = e.emp_id
);

--7. SIMULATED INTERSECT:
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE e.dept_id = 1
AND EXISTS (
    SELECT 1
    FROM Employee e2
    WHERE e2.emp_id = e.emp_id
    AND e2.salary > 60000
);

--8. SIMULATED EXCEPT:
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE NOT EXISTS (
    SELECT 1
    FROM Employee e2
    WHERE e2.emp_id = e.emp_id
    AND e2.project_id = 101
);

--9. EXPLAIN – INNER JOIN:
EXPLAIN
SELECT
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id;

--10. EXPLAIN – CORRELATED SUBQUERY:
EXPLAIN
SELECT
    e.emp_name,
    e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);

--RESULT:
--All the required JOIN operations, subqueries, EXISTS, simulated INTERSECT, simulated EXCEPT, and execution-plan analysis using EXPLAIN were successfully performed.

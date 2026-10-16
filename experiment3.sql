--AIM:
--To create an Employee–Department–Project database schema, insert at least 30 employees across 5 departments and 8 projects, and perform SQL queries demonstrating Selection, Projection, Aggregate Functions, GROUP BY, HAVING, CASE expressions, and ORDER BY.
--SOURCE CODE:
--1. Create Database Tables:

-- Create Department table
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

-- Create Project table
CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(12,2)
);

-- Create Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT,
    project_id INT,
    joining_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

--2. Insert Data into Department Table:
INSERT INTO Department VALUES
(1, 'Computer Science', 'Chandigarh'),
(2, 'Artificial Intelligence', 'Delhi'),
(3, 'Human Resources', 'Mumbai'),
(4, 'Finance', 'Bangalore'),
(5, 'Marketing', 'Pune');

--3. Insert Data into Project Table:
INSERT INTO Project VALUES
(101, 'AI Chatbot', 1500000),
(102, 'E-Commerce Portal', 2200000),
(103, 'Banking System', 3000000),
(104, 'Healthcare App', 1800000),
(105, 'Cloud Migration', 2500000),
(106, 'Cyber Security', 2000000),
(107, 'Marketing Analytics', 1200000),
(108, 'Employee Management', 1000000);

--4. Insert 30 Employees:
INSERT INTO Employee VALUES
(1, 'Aarav Sharma', 65000, 1, 101, '2023-01-10'),
(2, 'Riya Verma', 72000, 1, 102, '2022-03-15'),
(3, 'Aditya Singh', 58000, 1, 103, '2023-06-20'),
(4, 'Ananya Gupta', 81000, 1, 104, '2021-08-12'),
(5, 'Karan Mehta', 69000, 1, 105, '2022-11-05'),
(6, 'Priya Sharma', 75000, 1, 106, '2023-02-18'),

(7, 'Arjun Kapoor', 85000, 2, 101, '2021-04-10'),
(8, 'Sneha Jain', 92000, 2, 102, '2022-05-14'),
(9, 'Rahul Malhotra', 78000, 2, 103, '2023-01-22'),
(10, 'Ishita Roy', 88000, 2, 104, '2022-09-17'),
(11, 'Varun Gupta', 95000, 2, 105, '2021-12-11'),
(12, 'Neha Kapoor', 83000, 2, 106, '2023-07-01'),

(13, 'Manish Kumar', 55000, 3, 108, '2022-02-10'),
(14, 'Kavya Singh', 62000, 3, 108, '2023-03-15'),
(15, 'Rohit Sharma', 58000, 3, 107, '2022-07-19'),
(16, 'Pooja Verma', 67000, 3, 108, '2021-10-05'),
(17, 'Nikhil Jain', 60000, 3, 107, '2023-05-21'),
(18, 'Simran Kaur', 64000, 3, 108, '2022-12-09'),

(19, 'Vikas Agarwal', 88000, 4, 103, '2021-06-11'),
(20, 'Megha Gupta', 76000, 4, 103, '2022-04-25'),
(21, 'Sahil Bansal', 91000, 4, 105, '2021-09-18'),
(22, 'Tanvi Shah', 72000, 4, 107, '2023-01-30'),
(23, 'Mohit Arora', 84000, 4, 103, '2022-08-14'),
(24, 'Divya Mehta', 79000, 4, 105, '2023-04-16'),

(25, 'Akash Yadav', 60000, 5, 107, '2022-01-12'),
(26, 'Shreya Kapoor', 68000, 5, 107, '2023-02-20'),
(27, 'Varun Sharma', 73000, 5, 102, '2021-11-08'),
(28, 'Aditi Singh', 65000, 5, 104, '2022-06-13'),
(29, 'Harsh Gupta', 71000, 5, 107, '2023-03-22'),
(30, 'Muskan Jain', 69000, 5, 102, '2022-10-10');

--5. SELECTION:
--Display employees whose salary is greater than ₹80,000.
SELECT *
FROM Employee
WHERE salary > 80000;

--6. PROJECTION:
--Display only employee names and their salaries.
SELECT emp_name, salary
FROM Employee;

--7. AGGREGATE FUNCTIONS:
Find the total, average, maximum and minimum salary.
SELECT
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MAX(salary) AS maximum_salary,
    MIN(salary) AS minimum_salary
FROM Employee;

--8. GROUP BY:
--Find the number of employees in each department.
SELECT
    dept_id,
    COUNT(*) AS total_employees
FROM Employee
GROUP BY dept_id;

--9. GROUP BY WITH JOIN:
--Display department name and average salary of each department.
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

--10. HAVING:
--Display departments having an average salary greater than ₹70,000.
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 70000;

--11. CASE EXPRESSION:
Categorize employees according to their salary.
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 85000 THEN 'High Salary'
        WHEN salary >= 70000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;

--12. ORDER BY:
--Display employees in descending order of salary.
SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
ORDER BY salary DESC;

--13. PROJECT-WISE EMPLOYEE COUNT:
--Find the number of employees working on each project.
SELECT
    p.project_name,
    COUNT(e.emp_id) AS total_employees
FROM Project p
LEFT JOIN Employee e
ON p.project_id = e.project_id
GROUP BY p.project_name
ORDER BY total_employees DESC;

--14. COMBINED QUERY:
--Display employee name, department, project and salary in descending order of salary.
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    e.salary
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
JOIN Project p
    ON e.project_id = p.project_id
ORDER BY e.salary DESC;

--RESULT:
--The Employee–Department–Project database schema was successfully created with 30 employees, 5 departments, and 8 projects. SQL queries demonstrating Selection, Projection, Aggregate Functions, GROUP BY, HAVING, CASE expressions, and ORDER BY were successfully executed and their outputs were obtained.




--Aim:
--To create a stored procedure transfer_employee(emp_id, new_dept_id) with validation and error handling, and to implement triggers for salary validation and audit logging. Also, to test different edge cases.
--SOURCE CODE:
--1. Create Department Table:
CREATE TABLE Department6 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(30)
);
--2. Insert Department Data:
INSERT INTO Department6 VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing');
--3. Create Employee Table:
CREATE TABLE Employee6 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(30),
    dept_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES Department6(dept_id)
);
--4. Insert Employee Data:
INSERT INTO Employee6 VALUES
(101, 'Riya', 1, 75000),
(102, 'Aradhana', 1, 65000),
(103, 'Shatakshi', 2, 60000),
(104, 'Aman', 2, 55000),
(105, 'Priya', 3, 70000);          
--5. Create Audit Table:
CREATE TABLE Employee_Audit6 (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_dept_id INT,
    new_dept_id INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



--6. Trigger for Salary Validation:
This trigger prevents an employee from having a salary less than or equal to zero.
CREATE TRIGGER validate_salary6
BEFORE INSERT ON Employee6
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END;
--7. Trigger for Salary Validation During UPDATE:

CREATE TRIGGER validate_salary_update6
BEFORE UPDATE ON Employee6
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END;
--8. Trigger for Audit Logging:
This trigger records the old and new department whenever an employee's department is changed.
CREATE TRIGGER employee_transfer_audit6
AFTER UPDATE ON Employee6
FOR EACH ROW
BEGIN
    IF OLD.dept_id <> NEW.dept_id THEN
        INSERT INTO Employee_Audit6
        (emp_id, old_dept_id, new_dept_id)
        VALUES
        (OLD.emp_id, OLD.dept_id, NEW.dept_id);
    END IF;
END;
--9. Create Stored Procedure transfer_employee:
The procedure checks whether the employee and new department exist before transferring the employee.
CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occurred while transferring employee';
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_count
    FROM Employee6
    WHERE emp_id = p_emp_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM Department6
    WHERE dept_id = p_new_dept_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    END IF;

    UPDATE Employee6
    SET dept_id = p_new_dept_id
    WHERE emp_id = p_emp_id;

    COMMIT;
END;

--10. Display Employee Data Before Transfer:
SELECT * FROM Employee6;

--11. Test Stored Procedure – Successful Transfer:
--Transfer employee 102 from IT to Finance.
CALL transfer_employee(102, 3);
--Output:
--Query OK
--Verify the Transfer:
SELECT * FROM Employee6
WHERE emp_id = 102;

--12. Check Audit Log:
SELECT * FROM Employee_Audit6;

--13. Test Invalid Employee ID:
CALL transfer_employee(999, 2);

--14. Test Invalid Department ID:
CALL transfer_employee(101, 99);

--15. Test Salary Validation Trigger:
--Try inserting an employee with an invalid salary.
INSERT INTO Employee6
VALUES (106, 'Karan', 1, -5000);
--Output:
--ERROR 1644 (45000): Salary must be greater than zero
--The invalid employee is not inserted. 

--16. Test Salary Update Validation:
UPDATE Employee6
SET salary = -1000
WHERE emp_id = 101;
--Output:
--ERROR 1644 (45000): Salary must be greater than zero
--The salary remains unchanged.
--17. Test Valid Salary Update:
UPDATE Employee6
SET salary = 80000
WHERE emp_id = 101;
--Output:
--1 row affected
--Verify:
SELECT * FROM Employee6
WHERE emp_id = 101;

--18. Test Another Employee Transfer:
CALL transfer_employee(105, 4);
--Output:
--Query OK
--Verify:
SELECT * FROM Employee6
WHERE emp_id = 105; 

--19. Final Audit Log:
SELECT
    audit_id,
    emp_id,
    old_dept_id,
    new_dept_id,
    changed_at
FROM Employee_Audit6;

--Result:
--Thus, the stored procedure transfer_employee(emp_id, new_dept_id) was successfully created with validation and error handling. Triggers were implemented for salary validation and employee transfer audit logging, and valid as well as invalid test cases were successfully executed.



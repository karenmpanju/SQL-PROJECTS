CREATE TABLE Employee (
    EmpId int,
    Employee_name VARCHAR (255),
    Dept_Name VARCHAR (255),
    Salary INT
);

CREATE TABLE Department (
    DeptId int,
    Dept_Name VARCHAR (255),
    location VARCHAR (255),
)

CREATE TABLE Employee_history(
    EmpId int,
    Employee_name VARCHAR (255),
    Dept_Name VARCHAR (255),
    Salary INT,
    [location] VARCHAR (255)
)

INSERT INTO Employee ( EmpId, Employee_name, Dept_Name, Salary)
VALUES (101, 'Mohan', 'Admin', 4000),
 (102, 'Raji', 'HR', 3000),
 ( 103, 'Akbar', 'IT', 4000),
 (104, 'Dorvin', 'Finance', 6500),
(105, ' Rohit', 'HR', 3000),
(106, 'Rojesh', 'Finance', 5000);

SELECT * FROM Employee;

INSERT INTO Department (DeptId, Dept_Name, [location]) 
VALUES (1, 'Admin', 'Banglore'),
            (2, 'HR', 'Banglore'),
            (3, 'IT', 'Mubai'),
            (4, 'Finance', 'Banglore'),
            (5, 'Marketing', 'Mubai'),
            (6, 'sales', 'Mubai');
SELECT * FROM Department

--DELETING DUPLICATES 

DELETE FROM Employee WHERE EmpId IN 
(
SELECT MAX(EmpId)
FROM Employee
GROUP BY EmpId, Employee_name, Dept_Name, Salary
HAVING count(*) > 1)

--SUBQUERIES---

--Find the employees who's salary is more than the AVG salary earned by all the employees

SELECT *
FROM Employee
WHERE salary > (SELECT avg(salary)
FROM Employee);

SELECT * FROM 
Employee e 
JOIN ( SELECT avg(salary) sal FROM Employee) avg_sal 
ON e.Salary > avg_sal. sal

--FIND THE EMPLOYEES WHO EARN THE HIGHEST SALARY IN EACH DEPT.

SELECT *
FROM
Employee WHERE (Dept_Name, Salary) IN (SELECT Dept_Name, MAX(Salary) FROM Employee 
                           GROUP BY Dept_Name)

--FIND DEPARTMENT WHO DO NOT HAVE ANY EMPLOYEES
Select *
FROM Department
WHERE Dept_Name NOT IN (SELECT DISTINCT Dept_Name FROM Employee)

--FIND THE EMPLOYEES IN EACH DEPT WHO EARN MORE THAN THE AVG SALARY IN THAT DEPT--
SELECT Dept_Name, AVG(Salary)
FROM Employee
GROUP BY Dept_Name

Select * FROM Employee e1
WHERE salary 
> (SELECT AVG(Salary)
FROM Employee e2 WHERE e1.Dept_Name = e2.Dept_Name)

--FIND THE DEPT WHO DON'T HAVE ANY EMPLOYEES

SELECT * FROM  
Department where Dept_Name NOT IN 
      (Select Dept_Name FROM Employee)

SELECT * FROM 
department d 
WHERE not Exists (Select 1 from Employee e WHERE e.dept_name = d.Dept_Name)

--FIND ALL EMPLOYEE DETAILS & ADD REMARKS TO THOSE EMPLOYEES WHO EARN MORE THAN THE AVG SALARY

SELECT *
, (CASE WHEN salary > (SELECT avg(salary) FROM Employee)
THEN 'Greater than average'
ELSE null
END) as remarks
FROM Employee;

--INSERT DATA TO EMPLOYEE HISTORY TABLE. NO DUPLICATE RECORDS--
INSERT INTO Employee_history
SELECT e.EmpId, e.Employee_name, d.Dept_Name, e.Salary, d.location
FROM Employee e 
JOIN Department d ON d.Dept_Name = e.Dept_Name
WHERE NOT EXISTS (SELECT 1 FROM Employee_history eh WHERE eh.EmpId = eh.EmpId)

ALTER TABLE Employee_history
DROP COLUMN DeptID


--DELETE ALL DEPTS WHO DO NOT HAVE ANY EMPLOYEES
DELETE FROM Department 
WHERE Dept_Name IN 
(SELECT * FROM 
Department d 
WHERE NOT EXISTS 
(SELECT 1 FROM Employee e WHERE e.Dept_Name = d.Dept_Name)
);
              
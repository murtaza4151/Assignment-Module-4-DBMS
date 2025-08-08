-- 1 Create a new database named school_db and a table called students with the
-- following columns: student_id, student_name, age, class, and address.
create database school_db;
use school_db;
create table students(
student_id int primary key auto_increment,
student_name varchar(50),
age int,
class varchar(50),
address varchar(50)
);
desc students;
-- 2 Insert five records into the students table and retrieve all records using the SELECT
-- statement.
insert into students values (1,"mohan",16,"5th std","parimal"),
(2,"rohan",18,"12th std","CG road"),
(3,"mohit",20,"12th std","SG Highway"),
(4,"ayan",21,"10th std","kalupur"),
(5,"yogesh",21,"12th std","parimal");

select *  from students;

-- 3 Write SQL queries to retrieve specific columns (student_name and age) from the
-- students table.

select student_name,age from students;

-- 4 Write SQL queries to retrieve all students whose age is greater than 10.

select * from students where age>20;

-- 5 Create a table teachers with the following columns: teacher_id (Primary Key),
-- teacher_name (NOT NULL), subject (NOT NULL), and email (UNIQUE).

-- 6 Implement a FOREIGN KEY constraint to relate the teacher_id from the
-- teachers table with the students table.
drop table teacher;
create table teacher (
teacher_id int primary key auto_increment,
teacher_name varchar(50) not null,
subject varchar(50),
email varchar(50) unique
);
desc teacher;

alter table students add column teacher_id int,add constraint foreign key students (teacher_id) references teacher(teacher_id);

-- 7 Create a table courses with columns: course_id, course_name, and
-- course_credits. Set the course_id as the primary key
-- 8 Use the CREATE command to create a database university_db.

create database university_db;
use university_db;

create table courses(
course_id int primary key,
course_name varchar(50),
course_credits varchar(50)
);
desc courses;

-- 9 Modify the courses table by adding a column course_duration using the ALTER
-- command.
-- 10 Drop the course_credits column from the courses table.

Alter table courses add column course_duration varchar(20);
Alter table courses drop column course_credits;
desc courses;

-- 11 Drop the teachers table from the school_db database.
-- 12 Drop the students table from the school_db database and verify that the table has
-- been removed.

drop table IF EXISTS teacher;
drop table IF EXISTS students;

-- 13 Insert three records into the courses table using the INSERT command.
-- 14 Update the course duration of a specific course using the UPDATE command.
-- 15 Delete a course with a specific course_id from the courses table using the DELETE
-- command.

use university_db;
insert into courses values(1,"MCA","6 Month"),
(2,"BCOM","2 Month"),
(3,"BBA","5 Month");

select * from courses;
update courses set course_duration="6 month" where course_id=3;
delete from courses where course_id=3;

-- 16 Retrieve all courses from the courses table using the SELECT statement.
-- 17 Sort the courses based on course_duration in descending order using ORDER BY.
-- 18 Limit the results of the SELECT query to show only the top two courses using LIMIT.

select * from courses;
select * from courses order by course_duration desc; 
select * from courses limit 2;

-- 19 Create two new users user1 and user2 and grant user1 permission to SELECT
-- from the courses table.
-- 20 Revoke the INSERT permission from user1 and give it to user2.

CREATE USER user1 IDENTIFIED BY 'password1';
CREATE USER user2 IDENTIFIED BY 'password2';
GRANT SELECT ON courses TO user1;
select * from courses;

REVOKE INSERT ON courses FROM user1;
GRANT INSERT ON courses TO user2;

-- 21 Insert a few rows into the courses table and use COMMIT to save the changes.
-- 22 Insert additional rows, then use ROLLBACK to undo the last insert operation.
-- 23 Create a SAVEPOINT before updating the courses table, and use it to roll back
-- specific changes.

START TRANSACTION;

INSERT INTO courses (course_id, course_name, course_duration)
VALUES
  (4, ' SQL', '4 weeks'),
  (5, 'Web Development', '6 weeks'),
  (6, 'Python', '8 weeks');

COMMIT;

START TRANSACTION;
INSERT INTO courses (course_id, course_name, course_duration)
VALUES
  (7, 'Advanced Java', '5 weeks'),
  (8, 'Machine Learning', '10 weeks');
ROLLBACK;

START TRANSACTION;

SELECT * FROM courses;

SAVEPOINT before_update;

SET SQL_SAFE_UPDATES = 0;

UPDATE courses
SET course_duration = '12 weeks'
WHERE course_name = 'Machine Learning';

UPDATE courses
SET course_duration = '7 weeks'
WHERE course_name = 'Web Development Basics';

ROLLBACK TO SAVEPOINT before_update;

COMMIT;

-- 24 Create two tables: departments and employees. Perform an INNER JOIN to
-- display employees along with their respective departments.
-- 25 Use a LEFT JOIN to show all departments, even those without employees.

create table departments(
dept_id int primary key,
dept_name varchar(20)
);
desc departments;

create table employees(
emp_id int primary key,
emp_name varchar(20),
dept_id int,
salary int,
FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
desc employees;

INSERT INTO departments VALUES
  (1, 'Human Resources'),
  (2, 'Finance'),
  (3, 'Marketing');

select * from departments;

INSERT INTO employees VALUES
  (101, 'Alice', 2,25000),
  (102, 'Bob', 1,15000),
  (103, 'Charlie', 3,50000);

select * from employees;

SELECT employees.emp_id,employees.emp_name,departments.dept_name FROM employees
INNER JOIN departments ON employees.dept_id = departments.dept_id;

SELECT d.dept_id,d.dept_name,e.emp_id,e.emp_name
FROM 
    departments d
LEFT JOIN 
    employees e 
ON 
    d.dept_id = e.dept_id;
    
-- 26 Group employees by department and count the number of employees in each
-- department using GROUP BY.
-- 27 Use the AVG aggregate function to find the average salary of employees in each
-- department.

SELECT d.dept_id,d.dept_name,COUNT(e.emp_id) AS employee_count 
FROM 
departments d
LEFT JOIN employees e 
ON d.dept_id = e.dept_id
GROUP BY 
d.dept_id,
d.dept_name;

SELECT d.dept_id,d.dept_name,
AVG(e.salary) AS average_salary
FROM departments d
LEFT JOIN 
employees e ON 
d.dept_id = e.dept_id
GROUP BY 
d.dept_id,
d.dept_name;

-- 28 Write a stored procedure to retrieve all employees from the employees table based
-- on department.
-- 29 Write a stored procedure that accepts course_id as input and returns the course
-- details.

DELIMITER $$

CREATE PROCEDURE GetEmployeesByDepartments(IN input_dept_id INT)
BEGIN
    SELECT 
        emp_id,
        emp_name,
        dept_id,
        salary
    FROM 
        employees
    WHERE 
        dept_id = input_dept_id;
END$$

DELIMITER ;

SHOW CREATE PROCEDURE GetEmployeesByDepartments;

DELIMITER $$

CREATE PROCEDURE GetCourseDetails (
    IN in_course_id INT
)
BEGIN
    SELECT 
        course_id,
        course_name,
        course_duration
    FROM 
        courses
    WHERE 
        course_id = in_course_id;
END $$

DELIMITER ;

CALL GetCourseDetails(101);

-- 30 Create a view to show all employees along with their department names.
-- 31 Modify the view to exclude employees whose salaries are below $50,000.

CREATE VIEW employee_department_view2
 AS
SELECT
    e.emp_id,
    e.emp_name,
    e.dept_id,
    d.dept_name
FROM
    employees e
LEFT JOIN
    departments d ON e.dept_id = d.dept_id;

CREATE OR REPLACE VIEW employee_department_view1 AS
SELECT
    e.emp_id,
    e.emp_name,
    e.dept_id,
    d.dept_name,
    e.salary
FROM
    employees e
LEFT JOIN
    departments d ON e.dept_id = d.dept_id
WHERE
    e.salary >= 50000;
    
    


select * from view2;

create view employee_department as 
select employees.emp_id,employees.emp_name,employees.salary,departments.dept_name
from employees left join departments on employees.dept_id = departments.dept_id;

select * from employee_department;

-- 32 Create a trigger to automatically log changes to the employees table when a new
-- employee is added.
-- 33 Create a trigger to update the last_modified timestamp whenever an employee
-- record is updated.

create table log_changes(
emp_id int primary key,
emp_name varchar(20),
dept_id int,
salary int
);
desc log_changes;

Delimiter $$
create trigger log
after insert on employees
for each row 
Begin
insert into log_changes(emp_id,emp_name,dept_id,salary) values
(new.emp_id,new.emp_name,new.dept_id,new.salary);
end$$
Delimiter ;

insert into employees values (104,"mohan",1,15000);
select * from employees;
select * from log_changes;

alter table employees add column last_modifier datetime default current_timestamp;

Delimiter $$
create trigger emp
before update on employees
for each row
Begin
set new.last_modifier=current_timestamp  ;
end$$
Delimiter  ;

update employees set emp_name="rohan" where emp_id=102;
select * from employees;

-- 34 Write a PL/SQL block to print the total number of employees from the employees
-- table.
-- 35 Create a PL/SQL block that calculates the total sales from an orders table.

DELIMITER $$
CREATE PROCEDURE get_total_employees()
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total FROM employees;
    SELECT CONCAT('Total number of employees: ', total) AS result;
END$$
DELIMITER ;
call get_total_employees();

CREATE TABLE orders (
    order_id int primary key,
    customer_id int,
    order_date datetime DEFAULT current_timestamp,
    order_total int
);
desc orders;

INSERT INTO orders (order_id,order_total)
VALUES (101, 250.00),
(102,100.00),
(103,150.00);
select * from orders;

delimiter //
create procedure cal_total_sale()
begin
declare total int;
select sum(order_total) into total from orders;
select concat("total sales",total);
end//
Delimiter ;

call cal_total_sale();

--  36 Write a PL/SQL block using an IF-THEN condition to check the department of an
-- employee.
-- 37 Use a FOR LOOP to iterate through employee records and display their names.
select * from departments;
Delimiter $$
create procedure dept(id int)
begin
declare department varchar(20);
if(id=1) then
select dept_name into department from departments where dept_id=1;
select concat('department name= ',department) As info;
elseif(id=2) then
select dept_name into department from departments where dept_id=2;
select concat('department name= ',department) As info;
else
select dept_name into department from departments where dept_id=3;
select concat('department name= ',department) As info;
end if;
end $$
Delimiter ;
drop procedure dept;
call dept(2);

Delimiter $$
create procedure employee()
Begin
declare done int default False;
declare employee_name varchar(20);
declare emp cursor for select emp_name from employees;
declare continue handler for not found set done=true;
open emp;
i:loop
fetch emp into employee_name;
if done then
leave i;
end if;
select concat("employee_name",employee_name);
end loop;
close emp;
end $$
Delimiter ;

call employee();

-- 38 Write a PL/SQL block using an explicit cursor to retrieve and display employee details.
-- 39 Create a cursor to retrieve all courses and display them one by one

Delimiter $$
create procedure cur()
begin
declare c_emp_id int;
declare c_emp_name varchar(20);
declare c_emp_sal int;
declare done int default false;

declare emp_cur cursor for
select emp_id,emp_name,salary from employees;
declare continue handler for not found set done=true;
open emp_cur;
read_loop:loop
fetch emp_cur into
c_emp_id,c_emp_name,c_emp_sal;
if done then
leave read_loop;
end if;
select concat("id=,",c_emp_id,"name=",c_emp_name,"salary=",c_emp_sal) as
emp_details;
end loop;
close emp_cur;
end $$
delimiter ;

call cur();

-- 40 Perform a transaction where you create a savepoint, insert records, then rollback to
-- the savepoint.
-- 41 Commit part of a transaction after using a savepoint and then rollback the remaining
-- changes.

BEGIN;
INSERT INTO employees (emp_id,emp_name,dept_id) VALUES (1, 'Alice');
SAVEPOINT before_more_inserts;
INSERT INTO employees (emp_id, emp_name,dept_id) VALUES
(3, 'Charlie');
ROLLBACK TO SAVEPOINT before_more_inserts;
INSERT INTO employees (emp_id, emp_name,dept_id) VALUES (4, 'Diana');
COMMIT;

CREATE TABLE sales(
    id INT PRIMARY KEY,
    item VARCHAR(100)
);
desc sales;
BEGIN;
INSERT INTO sales (id, item) VALUES (1, 'Laptop');

SAVEPOINT before_more_orders;

INSERT INTO sales (id, item) VALUES (2, 'Phone');
INSERT INTO sales (id, item) VALUES (3, 'Tablet');

ROLLBACK TO SAVEPOINT before_more_orders;

COMMIT;
select * from sales;







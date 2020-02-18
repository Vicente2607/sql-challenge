-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/8H5OjE
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

--Borramos las tablas si es que existen
DROP TABLE IF EXISTS departments cascade;
DROP TABLE IF EXISTS dept_emp cascade;
DROP TABLE IF EXISTS dept_manager cascade;
DROP TABLE IF EXISTS employees cascade;
DROP TABLE IF EXISTS salaries cascade;
DROP TABLE IF EXISTS titles cascade;

--Creamos las tablas y copiamos los datos desde cvs
CREATE TABLE "departments" (
    "dept_no" varchar(10)   NOT NULL,
    "dept_name" varchar(18)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"));

COPY departments
from 'C:\Program Files\PostgreSQL\12\Datos/departments.csv'
with (format csv, header);

CREATE TABLE "dept_emp" (
    "emp_no" integer   NOT NULL,
    "dept_no" varchar(10)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL);

COPY dept_emp
from 'C:\Program Files\PostgreSQL\12\Datos/dept_emp.csv'
with (format csv, header);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(10)   NOT NULL,
    "emp_no" integer   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL);

COPY dept_manager
from 'C:\Program Files\PostgreSQL\12\Datos/dept_manager.csv'
with (format csv, header);


CREATE TABLE "employees" (
    "emp_no" integer   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(32)   NOT NULL,
    "last_name" varchar(32)   NOT NULL,
    "gender" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"));

COPY employees
from 'C:\Program Files\PostgreSQL\12\Datos/employees.csv'
with (format csv, header);

CREATE TABLE "salaries" (
    "emp_no" integer   NOT NULL,
    "salary" integer   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL);

COPY salaries
from 'C:\Program Files\PostgreSQL\12\Datos/salaries.csv'
with (format csv, header);


CREATE TABLE "titles" (
    "emp_no" integer   NOT NULL,
    "title" varchar(18)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL);

COPY titles
from 'C:\Program Files\PostgreSQL\12\Datos/titles.csv'
with (format csv, header);

-- Generamos la relaciones entre las bases de datos
ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "salaries" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


-- 1) List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT employees.emp_no, employees.last_name,employees.first_name, employees.gender, salaries.salary
FROM employees
JOIN salaries 
  ON  employees.emp_no=salaries.emp_no;
  
--2) List employees who were hired in 1986.
select * from employees where (SELECT extract(YEAR FROM hire_date) )=1986;

-- 3) List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT dept_manager.dept_no,departments.dept_name, employees.emp_no, employees.last_name,employees.first_name, dept_manager.from_date, dept_manager.to_date
FROM dept_manager
JOIN employees
  ON  dept_manager.emp_no=employees.emp_no
join departments
  on departments.dept_no=dept_manager.dept_no;
  
-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT employees.emp_no,employees.last_name,employees.first_name,departments.dept_name
FROM employees
JOIN dept_emp
ON   employees.emp_no=dept_emp.emp_no
JOIN departments
ON   dept_emp.dept_no=departments.dept_no;

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
SELECT employees.emp_no,employees.last_name,employees.first_name
from employees
where employees.first_name='Hercules' and employees.last_name like 'B%'

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT employees.emp_no,employees.last_name,employees.first_name,departments.dept_name
FROM employees
JOIN dept_emp
ON   employees.emp_no=dept_emp.emp_no
JOIN departments
ON   dept_emp.dept_no=departments.dept_no
where departments.dept_name='Sales';

-- 7.List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no,employees.last_name,employees.first_name,departments.dept_name
FROM employees
JOIN dept_emp
ON   employees.emp_no=dept_emp.emp_no
JOIN departments
ON   dept_emp.dept_no=departments.dept_no
where departments.dept_name='Sales' or departments.dept_name='Development';

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(*) AS frecuencia
FROM employees
GROUP BY last_name
ORDER BY frecuencia DESC;

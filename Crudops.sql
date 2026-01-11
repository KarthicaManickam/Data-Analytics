create table employee(
    employee_id integer primary key,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department TEXT NOT NULL,
    Job_Title TEXT NOT NULL,
    salary REAL        
);
INSERT INTO employee(employee_id, first_name, last_name, department, Job_Title, salary) VALUES
(1, 'John', 'Doe', 'Sales', 'Sales Executive', 55000.00),
(2, 'Jane', 'Smith', 'Marketing', 'Marketing Manager', 65000.00),
(3, 'Mike', 'Brown', 'HR', 'HR Specialist', 50000.00),
(4, 'Emily', 'Davis', 'IT', 'Software Engineer', 72000.00),
(5, 'Chris', 'Wilson', 'Sales', 'Sales Manager', 75000.00);

select * from employee;
SELECT * FROM employee WHERE Department = 'Sales';
update employee set salary = salary*1.1 where department='HR';
delete from employee where employee_id=5;
update employee set last_name='KM';
--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select Department, Employee, Salary
from(
select Department.name as Department, Employee.name as Employee, Salary,
dense_rank() over (partition by department.name order by salary desc) as dr
from Employee  
join Department 
on Employee.departmentId = Department.id)
where dr <= 3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

SELECT member_name, status, SUM(amount*unit_price) AS costs 
FROM FamilyMembers f
JOIN Payments p
ON f.member_id=p.family_member
where year(date) = 2005
GROUP BY member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name 
from (
select name, count(*) as c
from passenger
group by name) a
where c > 1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count
from Student
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(classroom) as count
from Schedule
where date = '2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count
from Student
where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select round(avg(2022-year(birthday))) as age
from FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

with all_p AS(
select *
from goods g
join GoodTypes gt
on gt.good_type_id = g.type
join Payments p
on g.good_id = p.good)
select good_type_name, sum(amount*unit_price ) as costs
from all_p
where year(date) = '2005'
group by good_type_name 

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select round('2021'- year(my)) as year
from (
select max(birthday ) as my
from Student) a

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select ('2023' - max(year(birthday ))) as max_year
from Student
join Student_in_class
on Student.id = Student_in_class.student
JOIN 
Class
on Student_in_class.class = Class.id
where class.name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, (amount*unit_price) as costs
from GoodTypes
join Goods
on GoodTypes.good_type_id = Goods.type
join Payments
on goods.good_id = Payments.good
join FamilyMembers
on Payments.family_member= FamilyMembers.member_id 
where good_type_name = 'entertainment'

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55


--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom 
from(
select classroom, count(*),
dense_rank() over (order by count(*) desc) as dr
from Schedule
group by classroom) a
where dr = 1

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name
from teacher
join Schedule
on teacher.id = Schedule.teacher
join Subject
on Schedule.subject = Subject.id
where name = 'Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select concat(last_name, '.', substring(first_name from 1 for 1), '.', 
substring(middle_name from 1 for 1), '.') as name
from Student
order by name

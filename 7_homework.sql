--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: ������� �������� ������ � �� (sqlite3, project name: task1_7). 
-- � ������� table1 �������� 1000 ����� � ���������� ���������� (3 �������, ��� int) �� 0 �� 1000.
-- ����� ��������� ����������� ������������� ���� ���� �������



--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from (
    select email, count(*) as c
    from Person
    group by email  
)
where c >= 2

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select t1.name as Employee
from Employee t1
join Employee t2
on t2.id = t1.managerId
where t1.salary > t2.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score,
dense_rank() over (order by score desc) as rank
from Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select firstName, lastName, city, state
from Person
left join Address
on person.personId = address.personId

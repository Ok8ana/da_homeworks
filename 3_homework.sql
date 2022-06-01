--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������. 
--�������: ����� � ����� ����������� ��������.

select class, count(ship)
from outcomes
join ships 
on outcomes.ship = ships.name
where result = 'sunk' 
group by class
union
select class, count(ship)
from outcomes
join classes 
on outcomes.ship = classes.class
where result = 'sunk'
group by class

--task2
--�������: ��� ������� ������ ���������� ���, 
--����� ��� ������ �� ���� ������ ������� ����� ������. 
--���� ��� ������ �� ���� ��������� ������� ����������, 
--���������� ����������� ��� ������ �� ���� �������� ����� ������. 
--�������: �����, ���.

select class, min(launched)
from ships
group by class
union 
select classes.class, min(launched)
from classes
join ships
on classes.class = ships.name
group by classes.class


--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 ��������
--� ���� ������, ������� ��� ������ � ����� ����������� ��������.

select class, count(*)
from ships
join outcomes 
on ships.name = outcomes.ship
where ship in (select ship
				from outcomes
				where result = 'sunk')
and class in (select class
				from ships
				group by class
				having count(class) >= 3)
group by class
union
select class, count(*)
from classes
join outcomes 
on classes.class = outcomes.ship
where class in (select class
				from classes
				group by class
				having count(class) >= 3)
and ship in (select ship
				from outcomes
				where result = 'sunk')
group by class

--task4
	--�������: ������� �������� ��������, ������� ���������� ����� ������ ����� ���� ��������
	-- ������ �� ������������� (������ ������� �� ������� Outcomes).
-�� ���� ��� ������
with all_k as(
select name as name
from ships
union
select ship as name
from outcomes) 
select name
from all_k
where numguns > ALL (select numguns from classes)


--task5
--������������ �����: ������� �������������� ���������, ������� ���������� �� 
--� ���������� ������� RAM � � ����� ������� ����������� ����� ���� ��, 
-- ������� ���������� ����� RAM. �������: Maker
      
      select distinct maker
      from product 
      where type = 'Printer'
      and maker in (select maker 
      				from product 
      				join pc 
     			 	on product.model = pc.model
      				where ram = (select min(ram) from pc)
      				and speed = (select max(speed) from pc
      							where ram = (select min(ram) from pc)))
      

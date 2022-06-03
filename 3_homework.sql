--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������. 
--�������: ����� � ����� ����������� ��������.

select class,
case 
when result = 'sunk' then 1
else 0
end count_ship
from outcomes
join ships 
on outcomes.ship = ships.name
group by result, class
union all
select class,
case 
when result = 'sunk' then 1
else 0
end count_ship
from outcomes
join classes 
on outcomes.ship = classes.class
group by result, class

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

select class, count(ship)
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
union all
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

--�� ���� ��� ������ c ��������������

with all_k as(
select name as name
from ships
union
select ship as name
from outcomes) 
select name, numGuns, displacement
from all_k
join classes 
on all_k.name = classes.class
where numguns in (select max(numguns) from classes)


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
      

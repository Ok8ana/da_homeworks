
-- ������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, 
-- ������� ��������� � ��������. �������: maker, ������� ������ HD.
			
select maker, avg(hd)  
			from product 
			join pc 
			on product.model = pc.model 
			where maker in (select maker 
							from product
							where type ='Printer')
			group by maker				
			
-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
--
select name, class
from ships
where launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--
select name, class
from ships 
where launched > 1920 and launched < 1942

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
--
select count(*) as ����������, class
from ships 
group by class

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. 
--(������� classes)

select class, country
from classes
where bore >= 16

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� 
--(������� Outcomes, North Atlantic). �����: ship.
--
	select ship
	from outcomes
	where battle = 'North Atlantic' and result = 'sunk'

-- ������� 6: ������� �������� (ship) ���������� ������������ �������/
-- (�� ���� ��� ������)
	
	select ship, max(date)
	from outcomes
	join battles
	on outcomes.battle = battles.name
	where result  = 'sunk' 
	group by ship
	
	select ship 
	from outcomes
	join battles
	on outcomes.battle = battles.name
	where result  = 'sunk' and date = (select max(date) from battles)
	group by ship
	

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
-- 	
	select ship, class
	from outcomes 
	join ships 
	on outcomes.ship = ships.name
	where result  = 'sunk'
	
-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, 
-- � ������� ���������. �����: ship, class
	
--(������ ��������� ������)
	
	select ship, class
	from outcomes 
	join classes 
	on outcomes.ship = classes.class
	where result  = 'sunk' and bore >= 16
	

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--	
	select class
	from classes 
	where country = 'USA'


-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). 
-- �����: name, class
	
select name, ships.class
from classes
join ships
on classes.class = ships.class
where country = 'USA'

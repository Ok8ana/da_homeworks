-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
--
select name, class
from ships
where launched >= 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--
select name, class
from ships 
where launched >= 1920 and launched <= 1942

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

-- ������� 6: ������� �������� (ship) ���������� ������������ �������
--
	
	

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
--

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
--

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
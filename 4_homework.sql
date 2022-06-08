--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� 
--� ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

with all_products as 
(
select model
from pc 
union all
select model 
from printer 
union all
select model 
from laptop
)
select all_products.model, maker, type 
from all_products
join product
on all_products.model = product.model


--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer
--������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

select *,
case 
when price > (select avg(price) from printer) then 1
else 0
end flag
from printer

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

select name
from ships 
where class is null
--

with all_ships as
(
select name 
from ships 
union all
select ship
from outcomes)
select name
from all_ships
join classes
on all_ships.name = classes.class
where class is null 
union all
select all_ships.name
from all_ships
join ships
on all_ships.name = ships.class
where class is null 

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, 
--�� ����������� �� � ����� �� ����� ������ �������� �� ����.

select name
from battles 
where date_part('year', date) not in (select launched from ships)

--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.

select battle
from ships
join outcomes
on ships.name = outcomes.ship
where class = 'Kongo'
				
--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) 
--��� ���� ������� (pc, printer, laptop) � ������, 
--���� ��������� ������ > 300. �� view ��� �������: model, price, flag

create view all_products_flag_300 as
with all_products as 
(select model, price
from pc 
union all
select model, price 
from laptop 
union all
select model, price 
from printer)
select model, price, 
case 
when price > 300 then 1
else 0
end flag
from all_products

select *
from all_products_flag_300

--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) 
-- ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������.
-- �� view ��� �������: model, price, flag
 
create view all_products_flag_avg_price as
with all_products as 
(select model, price
from pc 
union all
select model, price 
from laptop 
union all
select model, price 
from printer)
select model, price, 
case 
when price > (select avg(price) from all_products) then 1
else 0
end flag
from all_products

select *
from all_products_flag_avg_price


--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� 
-- �� ��������� ������������� = 'D' � 'C'. ������� model

select product.model
from product 
join printer 
on product.model = printer.model
where maker = 'A'
and price > (select avg(price) 
				from printer
				join product 
				on product.model = printer.model
				where maker = 'D' or maker ='C')

--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ����������
-- ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with all_products as 
(select model, price
from pc 
union all
select model, price 
from laptop 
union all
select model, price 
from printer)
 select product.model
 from product 
 join all_products
 on product.model = all_products.model
 where maker = 'A'
 and price > (select avg(price)
 			 from printer
 			 join product 
 			 on printer.model=product.model
 			 where maker = 'D' or maker = 'C')

				
--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� 
-- ������������� = 'A' (printer & laptop & pc)
 			 
with all_products as 
(select distinct model, price
from pc 
union all
select distinct model, price 
from laptop 
union all
select distinct model, price 
from printer)
select avg(price)
from all_products
join product
on all_products.model = product.model
where maker = 'A'	

			 
--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) 
-- �� ������� �������������. �� view: maker, count.

create view count_products_by_makers as
with all_products as 
(select model, price
from pc 
union all
select model, price 
from laptop 
union all
select model, price 
from printer)
select maker, count(*)
from all_products
join product
on all_products.model = product.model
group by maker
order by maker

select *
from count_products_by_makers

--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)
 
https://colab.research.google.com/drive/1p8vs1CMLN3yVRuawIUJsnMhYFpmAfIx4#scrollTo=aukDzU10hSL5

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) 
-- � ������� �� ��� ��� �������� ������������� 'D'

create table printer_updated as
select *
from printer
where model in (select printer.model
				from printer
				join product 
				on printer.model = product.model
				where maker != 'D')
				
select *
from printer_updated 

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view 
-- � �������������� �������� ������������� (�������� printer_updated_with_makers)

create view printer_updated_with_makers as
select code, product.model, color, product.type, price, maker
from printer_updated
join product 
on printer_updated.model = product.model

select *
from printer_updated_with_makers

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� �������
-- (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

-- �� ���� ������
create view sunk_ships_by_classes as
select count(*), class,
case 
when class is null then '0'
else class
end class_s
from (select class, ship 
	  from outcomes 
	  join ships 
	  on outcomes.ship = ships.name
	  where result = 'sunk'
	  union all 
	  select class, ship
	  from outcomes 
	  join classes
	  on outcomes.ship = classes.class
	  where result = 'sunk') cl
	  group by class

--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

	  
--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � 
-- �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

create table classes_with_flag as
select *,
case 
when numguns >= 9 then 1
else 0
end flag
from classes 

select *
from classes_with_flag

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

select count(distinct class), country
from classes
group by country

https://colab.research.google.com/drive/1p8vs1CMLN3yVRuawIUJsnMhYFpmAfIx4#scrollTo=GC_cGwz9iAki

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

select count(*)
from (select name 
	  from ships
	  union all 
      select ship
      from outcomes) s
where (name like 'O%') or (name like 'M%')


--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

select count(*)
from (select name 
	  from ships
	  union all 
      select ship
      from outcomes) s
where (name like '% %')

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)

select launched, count(name)
from ships
group by launched
order by launched

https://colab.research.google.com/drive/1p8vs1CMLN3yVRuawIUJsnMhYFpmAfIx4#scrollTo=_KqCSA3ii2PZ


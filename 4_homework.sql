--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя 
--с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

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
--Компьютерная фирма: При выводе всех значений из таблицы printer
--дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case 
when price > (select avg(price) from printer) then 1
else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

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
--Корабли: Укажите сражения, которые произошли в годы, 
--не совпадающие ни с одним из годов спуска кораблей на воду.

select name
from battles 
where date_part('year', date) not in (select launched from ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle
from ships
join outcomes
on ships.name = outcomes.ship
where class = 'Kongo'
				
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) 
--для всех товаров (pc, printer, laptop) с флагом, 
--если стоимость больше > 300. Во view три колонки: model, price, flag

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
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) 
-- для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней.
-- Во view три колонки: model, price, flag
 
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
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней 
-- по принтерам производителя = 'D' и 'C'. Вывести model

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
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью
-- выше средней по принтерам производителя = 'D' и 'C'. Вывести model

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
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов 
-- производителя = 'A' (printer & laptop & pc)
 			 
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
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) 
-- по каждому производителю. Во view: maker, count.


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
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
 
https://colab.research.google.com/drive/1p8vs1CMLN3yVRuawIUJsnMhYFpmAfIx4#scrollTo=aukDzU10hSL5

request = """
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
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['maker'], y=df['count'], labels={'x':'maker', 'y':'count'})
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) 
-- и удалить из нее все принтеры производителя 'D'

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
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view 
-- с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code, product.model, color, product.type, price, maker
from printer_updated
join product 
on printer_updated.model = product.model

select *
from printer_updated_with_makers

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля
-- (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

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
--Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

	  
--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и 
-- добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

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
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select count(distinct class), country
from classes
group by country
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['country'], y=df['count'], labels={'x':'country', 'y':'count'})
fig.show()

https://colab.research.google.com/drive/1p8vs1CMLN3yVRuawIUJsnMhYFpmAfIx4#scrollTo=GC_cGwz9iAki

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(*)
from (select name 
	  from ships
	  union all 
      select ship
      from outcomes) s
where (name like 'O%') or (name like 'M%')


--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(*)
from (select name 
	  from ships
	  union all 
      select ship
      from outcomes) s
where (name like '% %')

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

request = """
select launched, count(name)
from ships
group by launched
order by launched
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['launched'], y=df['count'], labels={'x':'year', 'y':'count'})
fig.show()
https://colab.research.google.com/drive/1p8vs1CMLN3yVRuawIUJsnMhYFpmAfIx4#scrollTo=_KqCSA3ii2PZ


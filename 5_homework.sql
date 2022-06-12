--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), 
-- в которой будет постраничная разбивка всех продуктов 
-- (не более двух продуктов на одной странице). 
-- Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), 
--в рамках которого будет процентное соотношение всех товаров по типу устройства. 
--Вывод: производитель, тип, процент (%)

create view distribution_by_type as
select distinct maker, type, cnt_type, cnt_all, (cnt_type * 100)/cnt_all as pr
from (
select *,
count(*) over (partition by type) as cnt_type,
count(*) over () as cnt_all
from product) as t1
group by type, maker, cnt_type, cnt_all
order by type

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. 
-- Пример https://plotly.com/python/histograms/

https://colab.research.google.com/drive/1p8vs1CMLN3yVRuawIUJsnMhYFpmAfIx4#scrollTo=NERL_HmdpeHh

request = """
select type, pr
from distribution_by_type
"""
df = pd.read_sql_query(request, conn)
fig = px.pie(df, values='pr', names='type')
fig.show() 

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), 
-- но название корабля должно состоять из двух слов

create table ships_two_words as
select *
from ships
where name like ('% %')

--task5 (lesson5)
-- Корабли: Вывести список кораблей, 
-- у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select *
from(
select name, class
from ships
union all
select ship, result 
from outcomes) ships
where name like 'S%'
and class like (select classes.class 
				from classes 
				join ships 
				on classes.class = ships.class
				where classes.class is null)

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней
-- по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

select model
from (
select maker, printer.model, price,
row_number() over (partition by maker order by price desc) as rn
from printer 
join product 
on printer.model = product.model) t1
where (rn <= 3) or (maker = 'A' 
and price > (select avg(price) 
			 from printer 
			 join product 
			 on printer.model = product.model 
			 where maker = 'C'))

--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), 
--имеющего самую высокую цену.

select *
from
(with all_products as 
(select model, price
from pc
union all
select model, price 
from laptop 
union all
select model, price 
from printer)
select model,price,
rank() over (order by price desc) as rnk
from all_products)a
where rnk = 1 

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code
-- (union all) и сделать флаг (flag) по цене > максимальной по принтеру. 
-- Также добавить нумерацию (через оконные функции) по каждой категории продукта 
-- в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as
select *,
row_number() over (partition by model order by price asc) as price_index,
case 
when price > (select max(price) from printer) 
then 1
else 0
end flag
from (
select code, model, price
from pc 
union all
select code, model, price
from laptop 
union all
select code, model, price
from printer) as all_products;

create index price_index_idx3 on all_products_with_index_task5 (price_index);

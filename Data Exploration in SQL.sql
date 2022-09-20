--Show Car_detail table and order by latest_launch

select *
from [dbo].[Car_detail]
order by latest_launch

--Looking at number by model

select distinct(Manufacturer), count(model) over (partition by manufacturer) as number
from [dbo].[Car_detail]
order by number

--Join the car_price table to get price in thousands and year resale value

select d.Manufacturer, d.Model, Horsepower, Latest_launch, p.price_in_thousands, year_resale_value
from [dbo].[Car_detail] d
join [dbo].[Car_price] p on p.Model = d.Model and d.Manufacturer = p.Manufacturer

--Calculate the percentage of the year resale value from the price in thousands

select distinct(d.Manufacturer), d.Model,year_resale_value, price_in_thousands, 
      (((price_in_thousands)-(year_resale_value))/(price_in_thousands))*100 as Percent_resale,
	  Horsepower, Latest_launch
from [dbo].[Car_detail] d
join [dbo].[Car_price] p on p.Model = d.Model and d.Manufacturer = p.Manufacturer
where year_resale_value is not null and price_in_thousands is not null
order by latest_launch

--Calculate power(kilowatts) by converting horsepower

with prvsdecar (Manufacturer, Model,number,year_resale_value, price_in_thousands, Percent_resale, Horsepower,Power_kilowatts,Latest_launch)
as
(
select distinct(d.Manufacturer), d.Model,
		count(d.model) over (partition by d.manufacturer) as number,
		year_resale_value, price_in_thousands, 
		(((price_in_thousands)-(year_resale_value))/(price_in_thousands))*100 as Percent_resale, 	
		Horsepower, (Horsepower * 0.75) as Power_kilowatts,Latest_Launch
from [dbo].[Car_detail] d
join [dbo].[Car_price] p on p.Model = d.Model and d.Manufacturer = p.Manufacturer
where year_resale_value is not null and price_in_thousands is not null
)
select * from prvsdecar

--Create temp table

Drop table if exists #Car_price_detail 
Create table #Car_price_detail
(Manufacturer nvarchar(255), 
Model nvarchar(255),
number numeric,
year_resale_value numeric, 
price_in_thousands numeric, 
Percent_resale numeric, 
Horsepower numeric,
Power_kilowatts numeric
)
insert into #Car_price_detail
select distinct(d.Manufacturer), d.Model,
		count(d.model) over (partition by d.manufacturer) as number,
		year_resale_value, price_in_thousands, 
		(((price_in_thousands)-(year_resale_value))/(price_in_thousands))*100 as Percent_resale, 	
		Horsepower, (Horsepower * 0.75) as Power_kilowatts
from [dbo].[Car_detail] d
join [dbo].[Car_price] p on p.Model = d.Model and d.Manufacturer = p.Manufacturer
where year_resale_value is not null and price_in_thousands is not null
select *
from #Car_price_detail

--Creating View

Create view Car_price_detail as
select distinct(d.Manufacturer), d.Model,
		count(d.model) over (partition by d.manufacturer) as number,
		year_resale_value, price_in_thousands, 
		(((price_in_thousands)-(year_resale_value))/(price_in_thousands))*100 as Percent_resale, 	
		Horsepower, (Horsepower * 0.75) as Power_kilowatts,Latest_Launch
from [dbo].[Car_detail] d
join [dbo].[Car_price] p on p.Model = d.Model and d.Manufacturer = p.Manufacturer
where year_resale_value is not null and price_in_thousands is not null
select * from Car_price_detail

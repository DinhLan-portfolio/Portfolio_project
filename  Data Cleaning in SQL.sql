/*
--Clean data in SQL queries
*/

select *
from [dbo].[Sale]
-------------------------------------------------

 --Standardize Date Fomart

  select Datetimeconverted, convert(date,datetime)
 from [dbo].[Sale]
   
update sale
set datetime = convert(date,datetime)

alter table sale
add datetimeconverted date;

update sale
set datetimeconverted = convert(date,datetime)

------------------------------------------------

--Products data

select *
from [dbo].[Sale]
where products is null
order by products

select a.invoice_id, a.products, b.invoice_id, b.products, isnull(a.products,b.products)
from [dbo].[Sale] a
join [dbo].[Sale] b on a.invoice_id = b.invoice_id 
where a.products is null

update a
set products = isnull(a.products,b.products)
from [dbo].[Sale] a
join [dbo].[Sale] b on a.invoice_id = b.invoice_id 
where a.products is null

-----------------------------------------------

--Breaking out Products into individual columns(Product1, Product2)
 
select products,
parsename(replace(products,'and','.'),2),
parsename(replace(products,'and','.'),1) 
from [dbo].[Sale]

alter table sale
add splitproducts2 nvarchar(255);

update sale
set splitproducts2 = parsename(replace(products,'and','.'),2)
 
alter table sale
add splitproducts1 nvarchar(255);

update sale
set splitproducts1 = parsename(replace(products,'and','.'),1)

select *
from [dbo].[Sale]

-----------------------------------------------------------------

--Change Ewallet to Cash, Ewallet to Credit card, null to Cash in "Patment" field
select distinct(payment), count(payment)
from [dbo].[Sale]
group by payment
order by 2

select payment,
Case when payment = 'Ewallet' then 'Credit card'
	when payment = 'Credit card' then 'Ewallet'
	when payment is null then 'Cash'
	else payment
	end	
from [dbo].[Sale]

update sale
set payment = Case when payment = 'Ewallet' then 'Credit card'
	when payment = 'Credit card' then 'Ewallet'
	when payment is null then 'Cash'
	else payment
	end	

----------------------------------------------------

--Remove Duplicates

with RowNumCTE as(
select *, 
	row_number() over (
	partition by invoice_id,
				 datetime,
				 quantity,
				 branch
				 order by
					invoice_id
					) row_num
from [dbo].[Sale]
--order by branch
)
select *
--delete 
from RowNumCTE
where row_num >1
--order by datetime

---------------------------------------------------------------

--Delete Unused Columns
select *
from [dbo].[Sale]
 
alter table [dbo].[Sale]
drop column datetime,products,tax_5,unit_price

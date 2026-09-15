/* Return rate*/
with customer as
(
  select extract(year from OrderDate) as Year
  , CustomerKey
  , count(distinct SalesOrderNumber) as orders
from jda-k1.practice_data_pipeline.trfsales as fact
group by 1,2
)
select Year
  , count(distinct CustomerKey) as Total_buyers
  , count(case when orders >= 2 then CustomerKey end) as Return_buyers
  , round(count(case when orders >= 2 then CustomerKey end) * 100 / count(distinct CustomerKey)) as Return_rate
from customer
group by 1
order by 1 asc

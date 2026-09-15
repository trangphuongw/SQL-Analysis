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
  , round(count(case when orders >= 2 then CustomerKey end) * 100 / count(distinct CustomerKey), 2) as Return_rate
from customer
group by 1
order by 1 asc

/* Results
Year	Total_buyers	Return_buyers	Return_rate
2010	14	            0	            0
2011	2,216	        0	            0
2012	3,255	        14	            0.43
2013	17,429	        2665	        15.29
2014	834	            30	            3.6
*/

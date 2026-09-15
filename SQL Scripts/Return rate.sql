/* Return rate: return buyer is defined as having at least 1 order after the first purchase within 12 months */
with first_buy as (
  select min(OrderDate) as first_date
    , FirstPurchaseYear as Cohort_year
    , f.CustomerKey
  from jda-k1.practice_data_pipeline.trfsales as f
  left join jda-k1.practice_data_pipeline.trdcustomer as cus
  on f.CustomerKey = cus.CustomerKey
  group by 2,3
)
, returned as(
  select distinct f.CustomerKey
  from jda-k1.practice_data_pipeline.trfsales as f
  join first_buy as fb
  on f.CustomerKey = fb.CustomerKey
  where f.OrderDate > fb.first_date
    and f.OrderDate <= date_add(OrderDate, interval 12 month)
)
select fb.Cohort_year
  , count(distinct fb.CustomerKey) as Total_buyers
  , count(distinct r.CustomerKey) as Return_buyes
  , round(count(distinct r.CustomerKey) * 100 / count(distinct fb.CustomerKey), 2 ) as Return_rate
from first_buy as fb
left join returned as r
on fb.CustomerKey = r.CustomerKey
group by 1
order by 1 asc

/* Results
Cohort_year	Total_buyers	Return_buyes	Return_rate
2.010	    14	            13	92.86
2.011	    2,216	        1,955	88.22
2.012	    3,225	        2,955	91.63
2.013	    12,523	        1,930	15.41
2.014	    506	            7	1.38
*/

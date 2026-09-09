/* Order by countries based on revenue/ rev share each year */
with loc as 
(select extract(year from OrderDate) as Year
  , SalesTerritoryCountry as Location
  , sum(SalesAmount) as Revenue
from jda-k1.practice_data_pipeline.trfsales as fact
left join jda-k1.practice_data_pipeline.trdsalesterritory as reg
on fact.SalesTerritoryKey = reg.SalesTerritoryKey
group by 1,2
order by 1 asc
)
select *
  , round (Revenue * 100 / sum(Revenue) over(partition by Year), 2) as Rev_share
from loc
order by 1 asc, 4 desc

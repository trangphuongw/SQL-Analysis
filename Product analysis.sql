/* Top 10 products by revenue over time */
select ProductCategory
  ,ProductName
  ,sum(SalesAmount) as Revenue
from jda-k1.practice_data_pipeline.trfsales as fact
left join jda-k1.practice_data_pipeline.trdproduct as dpd
on fact.ProductKey = dpd.ProductKey
left join jda-k1.practice_data_pipeline.trdproductsubcategory as dcat
on dpd.ProductSubcategoryKey = dcat.ProductSubcategoryKey
group by 1,2
order by 3 desc
limit 10

 /* Revenue share by category */ 
with raw as
(select extract(year from OrderDate) as Year
  , ProductCategory
  , sum(SalesAmount) as Revenue
from jda-k1.practice_data_pipeline.trfsales as fact
left join jda-k1.practice_data_pipeline.trdproduct as dpd
on fact.ProductKey = dpd.ProductKey
left join jda-k1.practice_data_pipeline.trdproductsubcategory as dcat
on dpd.ProductSubcategoryKey = dcat.ProductSubcategoryKey
group by 1, 2
order by 1 asc
)
select Year 
  , ProductCategory
  , Revenue
  , round(Revenue * 100 / sum(Revenue) over(partition by Year), 2) as Rev_share
from raw

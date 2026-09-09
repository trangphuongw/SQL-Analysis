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
)
select Year 
  , ProductCategory
  , Revenue
  , round(Revenue * 100 / sum(Revenue) over(partition by Year), 2) as Rev_share
from raw
order by 1 asc, 3 desc

 /* Result 
Year	ProductCategory	Revenue	Rev_share
2010	Bikes	        43419	100
2011	Bikes	        7075088	100
2012	Bikes	        5839443	99.95
2012	Accessories	    2146	0.04
2012	Clothing	    642	  0.01
2013	Bikes	        1535832293.94
2013	Accessories	    667536	04.08
2013	Clothing	    323472	1.98
2014	Accessories	    30332	66.46
2014	Clothing	    15310	33.54
*/ 

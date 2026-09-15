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

/* Result
Category	ProductName	        Revenue
Bikes	Mountain-200 Black, 46	1,373,454
Bikes	Mountain-200 Black, 42	1,363,128
Bikes	Mountain-200 Silver, 38	1,339,394
Bikes	Mountain-200 Silver, 46	1,301,029
Bikes	Mountain-200 Black, 38	1,294,854
Bikes	Mountain-200 Silver, 42	1,257,368
Bikes	Road-150 Red, 48	    1,205,786
Bikes	Road-150 Red, 62	    1,202,208
Bikes	Road-150 Red, 52	    1,080,556
Bikes	Road-150 Red, 56	    1,055,510
*/

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
Year	ProductCategory	Revenue	      Rev_share
2010	Bikes	        43,419	      100
2011	Bikes	        7,075,088	  100
2012	Bikes	        5,839,443	  99.95
2012	Accessories	    2,146	      0.04
2012	Clothing	    642	          0.01
2013	Bikes	        15,358,322      93.94
2013	Accessories	    667,536	      04.08
2013	Clothing	    323,472	      1.98
2014	Accessories	    30,332	      66.46
2014	Clothing	    15,310	      33.54
*/ 

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

/*Result
Year	Location	        Revenue	  Rev_share
2010	Australia	        20909	    48.16
2010	United States	    14833	    34.16
2010	Canada	            3578	    8.24
2010	France	            3400	    7.83
2010	United Kingdom	    699	        1.61
2011	Australia	        2563589	    36.23
2011	United States	    2458122	    34.74
2011	Canada	            571533	  08.08
2011	United Kingdom	    550558	  7.78
2011	Germany	            520468	  7.36
2011	France	            410818	  5.81
2012	Australia	        2128322	  36.43
2012	United States	    1436953	  24.6
2012	United Kingdom	    712680	  12.2
2012	France	            648050	  11.09
2012	Germany	            608634	  10.42
2012	Canada	            307592	  5.26
2013	United States	    5461423	  33.4
2013	Australia	        4338824	  26.54
2013	United Kingdom	    2123708	  12.99
2013	Germany	            1761641	  10.78
2013	France	            1578292	  9.65
2013	Canada	            1085442	  6.64
2014	United States	    17526	    38.4
2014	Canada	            9453	    20.71
2014	Australia	        8493	    18.61
2014	United Kingdom	    3711	    8.13
2014	Germany	            3273	    7.17
2014	France	           3186	    6.98
*/

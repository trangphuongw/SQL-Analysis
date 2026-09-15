/* Gender */
select Gender
  , sum(SalesAmount) as Revenue
  , round(sum(SalesAmount) / sum(sum(SalesAmount)) over () , 4) as Rev_share
from jda-k1.practice_data_pipeline.trfsales as fact
left join jda-k1.practice_data_pipeline.trdcustomer as cus
on fact.CustomerKey = cus.CustomerKey
group by Gender

/* Result 
Gender	Revenue	       Rev_share
F	    14,812,104	 5.046
M	    14,543,606	 4.954
*/

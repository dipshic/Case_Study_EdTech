select d1,w1,count(distinct user_id) as c1,
case when w1 < 37 then 'before'
     else 'after'
end as challenge
from (
select t1.*,
To_char(activity_datetime,'IW') as w1,
to_char(activity_datetime, 'dd-mm') as d1
from day_wise_user_learning_activity t1
)
group by d1,w1
order by w1

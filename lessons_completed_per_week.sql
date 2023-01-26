
select count(distinct lesson_id) as c1,w1,max(d1),
case when w1 < 37 then 'before'
     else 'after'
end as challenge
from(
select lesson_id,
To_char(activity_datetime,'IW') as w1,
to_char(activity_datetime, 'dd-mm-yyyy') as d1
from day_wise_user_learning_activity
where overall_completion_percentage = 100
)t1
group by w1
order by challenge desc
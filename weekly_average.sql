select distinct w1, d2, round(avg(h1) over(partition by w1),2) as a1,challenge
from (
select distinct w1,user_id,sum(round(per_day_studies_minutes/60,2)) over(partition by w1,user_id) as h1,
max(d1) over(partition by w1) as d2,
case when w1 < 37 then 'before'
else 'after'
end as challenge
from (
select t1.*,t2.*,
To_char(activity_datetime,'IW') as w1,
to_char(activity_datetime, 'dd-mm-yyyy') as d1,
(t1.day_completion_percentage*t2.lesson_duration_in_mins)/100 as per_day_studies_minutes
from day_wise_user_learning_activity t1
left join lesson_details t2
on t1.lesson_id = t2.lesson_id
)
)
--group by w1
--order by w1 asc,user_id asc

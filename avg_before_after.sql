select distinct challenge, avg(h1) over(partition by challenge) as a1
from (
select distinct w1,sum(round(per_day_studies_minutes/60,2)) over(partition by w1) as h1,
case when w1 < 37 then 'before'
else 'after'
end as challenge
from (
select t1.*,t2.*,
To_char(activity_datetime,'IW') as w1,
to_char(activity_datetime, 'dd-mm') as d1,
(t1.day_completion_percentage*t2.lesson_duration_in_mins)/100 as per_day_studies_minutes
from day_wise_user_learning_activity t1
left join lesson_details t2
on t1.lesson_id = t2.lesson_id
)
)
--group by w1
--order by w1 asc

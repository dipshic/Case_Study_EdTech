select w1,max(d2),count(distinct case when weekly_goal_target = 'achieved' then user_id end) as achievers
from(
select t3.*,
case when s1 >= 3 and c1 >=5 then 'achieved'
     else 'failed'
end as weekly_goal_target
from (
select w1,max(d1) as d2,user_id,
sum(study_duration_hrs)as s1,
count(distinct case when overall_completion_percentage = 100 then lesson_id end) as c1
from(
select To_char(activity_datetime,'IW') as w1,
to_char(activity_datetime, 'dd-mm-yyyy') as d1,
round((t1.day_completion_percentage*t2.lesson_duration_in_mins)/6000,2) as study_duration_hrs,
t1.*,t2.lesson_duration_in_mins
from day_wise_user_learning_activity t1
left join lesson_details t2
on t1.lesson_id = t2.lesson_id
)
--where t1.lesson_id = 'lesson_0735'
--group by t1.user_id,To_char(activity_datetime,'IW')
--where w1= 35 and user_id = 'user_019'
group by w1,user_id
)t3
)t4
group by w1
order by w1

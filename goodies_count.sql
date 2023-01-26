select count(distinct user_id) as tot_goodies,goody,
listagg(user_id,'; ') as list_of_users
from(
select user_id, weekly_goals_completed,
case when weekly_goals_completed = 1 then 'water_bottle'
     when weekly_goals_completed = 2 then 't_shirt'
     when weekly_goals_completed = 3 then 'sweat_shirt'
     when weekly_goals_completed = 4 then 'back_pack'
     when weekly_goals_completed >= 5 then 'head_phone'
end as goody
from(
select user_id,
count(distinct case when weekly_goal_target = 'achieved' then w1 end) as weekly_goals_completed
from(
select t3.*,
case when s1 >= 3 and c1 >=5 then 'achieved'
     else 'failed'
end as weekly_goal_target
from (
select w1,user_id,
sum(study_duration_hrs)as s1,
count(distinct case when overall_completion_percentage = 100 then lesson_id end) as c1
from(
select To_char(activity_datetime,'IW') as w1,
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
group by user_id
)t5
)t6
group by goody
order by 1 desc
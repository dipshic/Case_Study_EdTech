select t4.*,
case when rnk=1 then 'Laptop'
     when rnk=2 then 'Tablet'
     when rnk=3 then 'Smart_Watch'
end as reward
from(
select t3.*,
case when s1 >= 20 and c1 >=5 then 'achieved'
     else 'failed'
end as challenge_targets,
dense_rank() over(order by s1 desc,c1 desc) as rnk
from (
select user_id,
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
where w1 >= 37
group by user_id
)t3
)t4
where t4.challenge_targets = 'achieved'
--order by challenge_targets,s1 desc

select w2,max(d2),challenge,batch_id,max(b_total),
count(distinct user_id) as c1,
round(100.00*count(distinct user_id)/max(b_total),2) as p1
from(
select t1.*,t2.*,
case when w2 < 37 then 'before'
     when w2 >= 37 then 'after'
else 'vacant'    
end as challenge
from (select user_id as try,
case when batch_week = '06-06-22' then 'batch_1'
     when batch_week = '13-06-22' then 'batch_2'
     when batch_week = '27-06-22' then 'batch_3'
end as batch_id,
count(user_id) over(partition by batch_week) as b_total
from user_basic_details
)t1
left join (select user_id,activity_datetime,lesson_id,
            day_completion_percentage,overall_completion_percentage,
            To_char(activity_datetime,'IW') as w2,
            to_char(activity_datetime, 'dd-mm-yyyy') as d2
            from day_wise_user_learning_activity 
--            where To_char(activity_datetime,'IW') >= 37
            )t2
on t1.try = t2.user_id
--where lesson_id is null
)
--where challenge = 'before'
group by w2,batch_id,challenge
order by w2,batch_id
--where t1.batch_week = '06-06-2022'
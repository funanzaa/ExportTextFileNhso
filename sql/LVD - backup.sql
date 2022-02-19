--LVD 19/01/65 v.1.2
select v.vn as "SEQLVD"
,v.an as "AN" 
,to_char(v.financial_discharge_date::date,'yyyymmdd') as "DATEOUT"
,replace(left(v.financial_discharge_time,5),':','') as "TIMEOUT"
,to_char(ad.admit_date::date,'yyyymmdd') as "DATEIN"
,replace(left(ad.admit_time,5),':','') as "TIMEIN"
--,DATE_PART('day', (doctor_discharge_ipd.discharge_date||' '||doctor_discharge_ipd.discharge_time)::timestamp - (v.visit_date||' '||v.visit_time)::timestamp) as QTYDAY --Count time
,DATE_PART('day',(v.financial_discharge_date::timestamp - ad.admit_date::timestamp)) as "QTYDAY"
from (
			with cte1 as 
				(
					select q.*
					,case when q.base_plan_group_code in ('Model5','UC') then 'UC' end as chk_plan 
					from (
						select v.*,base_plan_group.base_plan_group_code,plan.plan_code,plan.description 
						from visit v 
						left join visit_payment on v.visit_id = visit_payment.visit_id and visit_payment.priority = '1'
						left join base_plan_group on visit_payment.base_plan_group_id = base_plan_group.base_plan_group_id and base_plan_group.base_plan_group_code in ('Model5','UC','CHECKUP') 
						left join plan on visit_payment.plan_id = plan.plan_id 
					) q
					where q.base_plan_group_code is not null and q.description <> 'นัดรับยา(บัตรทอง)'
				)
				select * from cte1 where cte1.chk_plan is not null 
	) v 
inner join doctor_discharge_ipd on v.visit_id = doctor_discharge_ipd.visit_id 
left join admit ad on v.visit_id = ad.visit_id 
where v.visit_date::date >= {0}
and v.visit_date::date <= {1}
and v.financial_discharge = '1' 
and v.doctor_discharge = '1' 
and v.fix_visit_type_id = '1'
order by v.vn 
--and v.visit_id = '121090107433621501'

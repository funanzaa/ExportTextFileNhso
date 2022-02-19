--IRF 02/01/65 v.1.2
select v.an as "AN"
,regexp_replace(only_type0.description, '\D','','g') as "REFER"
, '1' as "REFERTYPE"
from (
			with cte1 as 
				(
					select q.*
					,case when q.base_plan_group_code in ('CHECKUP') and q.plan_code in ('PCP006') then 'UC' 
						  when q.base_plan_group_code in ('Model5','UC') then 'UC' end as chk_plan 
					from (
						select v.*,base_plan_group.base_plan_group_code,plan.plan_code 
						from visit v 
						left join visit_payment on v.visit_id = visit_payment.visit_id and visit_payment.priority = '1'
						left join base_plan_group on visit_payment.base_plan_group_id = base_plan_group.base_plan_group_id and base_plan_group.base_plan_group_code in ('Model5','UC','CHECKUP')
						left join plan on visit_payment.plan_id = plan.plan_id 
					) q
					where q.base_plan_group_code is not null 
				)
				select * from cte1 where cte1.chk_plan is not null 
	) v 
left join (
		select get_plan.*
		,case when LENGTH(regexp_replace(get_plan.description, '\D','','g')) = 5 and get_plan.description not ilike '%กัน%' then '0' else '' end as op_type  
		from (
		select visit_payment.visit_id, plan.description
		from visit_payment 
		inner join plan on visit_payment.plan_id  = plan.plan_id
		where priority = '1') get_plan 
		) only_type0 on v.visit_id = only_type0.visit_id 
--    where v.visit_date::date >= {0}
--    and v.visit_date::date <= {1}
where v.financial_discharge = '1' 
and v.doctor_discharge = '1' 
and v.fix_visit_type_id = '1' 
and only_type0.op_type = '0'
and v.vn in ('6501010031')

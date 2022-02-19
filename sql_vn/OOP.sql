--OOP 15/10/64 v.1.4
with cte1 as (
	select v.hn as "HN"
	,to_char(v.visit_date::date,'yyyymmdd') as "DATEOPD"
	,'00100' as "CLINIC" 
	,replace(icd9.icd9_code,'.','') as "OPER"
	,'' as "DROPID"
	,p.pid as "PERSON_ID"
	,v.vn as "SEQ"
	,'' as "SERVPRICE"
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
						left join base_plan_group on visit_payment.base_plan_group_id = base_plan_group.base_plan_group_id and base_plan_group.base_plan_group_code in ('Model5','UC','CHECKUP') -- สิทธิ์ UC
						left join plan on visit_payment.plan_id = plan.plan_id 
					) q
					where q.base_plan_group_code is not null 
				)
				select * from cte1 where cte1.chk_plan is not null 
	) v 
	left join diagnosis_icd9 icd9 on v.visit_id = icd9.visit_id 
	left join patient p on v.patient_id = p.patient_id 
    --where v.visit_date::date >= {0}
    --and v.visit_date::date <= {1}
	where v.financial_discharge = '1' 
	and v.doctor_discharge = '1'
	and v.fix_visit_type_id = '0' 
	--and icd9.fix_operation_type_id = '1'
	and v.vn in ('6501010031')
)
select  * 
from cte1
where cte1."OPER" is not null 
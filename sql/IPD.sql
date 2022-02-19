--IPD 19/01/65 v.1.2
--แฟ้มข้อมูลผู้ป่วยใน (IPD)
with cte1 as (
	select v.hn as "HN"
	,v.an as "AN"
	,to_char(ad.admit_date::date,'yyyymmdd') as "DATEADM"
	,to_char(ad.admit_time::time,'HH24MI') as "TIMEADM"
	,to_char(v.financial_discharge_date::date,'yyyymmdd') as "DATEDSC" 
	,to_char(v.financial_discharge_time::time,'HH24MI') as "TIMEDSC"
	,doctor_discharge_ipd.fix_ipd_discharge_status_id as "DISCHS" 
	,doctor_discharge_ipd.fix_ipd_discharge_type_id as "DISCHT" 
	, '' as "WARDDSC"
	,'' as "DEPT"
	,v_vital_sign_opd.weight as "ADM_W"
	,'1' as "UUC"
	,'I' as "SVCTYPE"
	from visit v 
	left join (
					select vital_sign_opd.*
					from vital_sign_opd
					inner join (
								select vital_sign_opd_id,ROW_NUMBER() OVER( PARTITION BY visit_id ORDER by vital_sign_opd_id desc) as chk_dup
								from vital_sign_opd
						 		) chk_vital_sign_opd on chk_vital_sign_opd.vital_sign_opd_id = vital_sign_opd.vital_sign_opd_id and chk_vital_sign_opd.chk_dup = 1
		                 ) v_vital_sign_opd on v.visit_id = v_vital_sign_opd.visit_id
	left join doctor_discharge_ipd on v.visit_id = doctor_discharge_ipd.visit_id 
	left join admit ad on v.visit_id = ad.visit_id 
    where v.visit_date::date >= {0}
    and v.visit_date::date <= {1}
	and v.financial_discharge = '1' 
	and v.doctor_discharge = '1' 
	and v.fix_visit_type_id = '1' 
) , cte2 as ( 
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
				select * from cte1 where cte1.chk_plan is not null and cte1.an <> ''
				and cte1.visit_date::date >= {0}
				and cte1.visit_date::date <= {1}
) --กรองสิทธิ์
select cte1.*
from cte1
inner join cte2 on cte1."AN" = cte2.an
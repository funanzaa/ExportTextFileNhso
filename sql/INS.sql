--INS 07/10/64 v.1.2
-- มาตรฐานแฟ้มข้อมูลผู้มีสิทธิการรักษาพยาบาล (INS)
-- Header upper
with cte1 as (
	select v.hn 
	,v.vn 
	,v.an 
	,base_plan_group.base_plan_group_code
	,plan.plan_code
	,plan.description 
	,case when LENGTH(regexp_replace(plan.description, '\D','','g')) = 5 then regexp_replace(plan.description, '\D','','g')  
	else base_site.base_site_id end as HOSPSUB --check รหัสหน่วยบริการปฐมภูมิ
	,visit_payment.card_id 
	,base_site.base_site_id as HOSPMAIN
	from visit v 
	left join visit_payment on v.visit_id = visit_payment.visit_id 
	left join base_plan_group on visit_payment.base_plan_group_id = base_plan_group.base_plan_group_id 
	left join plan on visit_payment.plan_id = plan.plan_id 
	,base_site
--	where v.visit_date::date >= {0}
--	and v.visit_date::date <= {1}
	where v.financial_discharge = '1' --จำหน่ายทางการเงินแล้ว
	and v.doctor_discharge = '1' --จำหน่ายทางการแพทย์แล้ว
	--and v.fix_visit_type_id = '0' --ประเภทการเข้ารับบริการ 0 ผู้ป่วยนอก,1 ผู้ป่วยใน
	and visit_payment.priority = '1' 
	and base_plan_group.base_plan_group_code in ('Model5','UC','CHECKUP') -- สิทธิ์ UC
	--and v.visit_id = '121090107433621501'
)
select * 
	from(
	select cte1.hn as "HN"
	,case when cte1.base_plan_group_code = 'UC' then 'UCS' 
	 when  cte1.base_plan_group_code = 'Model5' then 'UCS'
	 when  cte1.base_plan_group_code = 'CHECKUP' and cte1.plan_code = 'PCP006' then 'UCS'  -- check UC > CHECKUP and  PCP006
	 else '' end as "INSCL"
	 ,'' as "SUBTYPE"
	 ,'' as "CID"
	 , '' as "DATEIN"
	 ,'' as "DATEEXP"
	 , cte1.hospmain as "HOSPMAIN"
	 ,cte1.hospsub as "HOSPSUB"
	 , '' as "GOVCODE"
	 , '' as "GOVNAME"
	 , cte1.card_id as "PERMITNO"
	 ,'' as "DOCNO"
	 ,'' as "OWNRPID"
	 ,'' as "OWNNAME"
	 , cte1.an as "AN"
	 ,cte1.vn as "SEQ"
	 ,'' as "SUBINSCL"
	 ,'' as "RELINSCL"
	 ,'' as "HTYPE"
	from cte1
)q 
where q."INSCL" <> '' -- สิทธิ์ที่ไม่เข้าเงื่่อนไข
and q."SEQ" in ('6501010031')
order by q."SEQ"
--ORF 02/01/65 v.1.4
--มาตรฐานแฟ้มข้อมูลผู้ป่วยนอกที่ต้องส่งต่อ (ORF)
--1.1 ปรับ login type 0
--1.2 แก้ไขดึงเฉพาะสิทธิ์ ใน excel
--1.3 ดึงประเภทการเข้ารับบริการ 0 ผู้ป่วยนอก
--1.4 Header Upper
select v.hn as "HN"
,to_char(v.visit_date::date,'yyyymmdd') as "DATEOPD"
,'00100' as "CLINIC" -- default
,case when LENGTH(regexp_replace(only_type0.description, '\D','','g')) = 5 then regexp_replace(only_type0.description, '\D','','g')  
else '' end as "REFER" --check รหัสหน่วยบริการปฐมภูมิ
,'1' as "REFERTYPE" -- มีแค่เฉพาะรับเข้า
,v.vn as "SEQ"
,to_char(v.visit_date::date,'yyyymmdd') as "REFERDATE" -- REFERDATE วันเดียวกับ visit_date
from (						
		select get_plan.*
		,case when LENGTH(regexp_replace(get_plan.description, '\D','','g')) = 5 and get_plan.description not ilike '%กัน%' then '0' else '' end as op_type 
		from (
		select visit_payment.visit_id, plan.description
		from visit_payment 
		inner join plan on visit_payment.plan_id  = plan.plan_id
		where priority = '1'
		) get_plan	
		) only_type0 -- get only type0
left join (
			with cte1 as 
				(
					select q.*
					,case when q.base_plan_group_code in ('CHECKUP') and q.plan_code in ('PCP006') then 'UC'  -- check CHECKUP => PCP006 
						  when q.base_plan_group_code in ('Model5','UC') then 'UC' end as chk_plan -- check 'Model5','UC' => UC
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
	) v on only_type0.visit_id = v.visit_id  -- visit ที่เป็นสิทธิ์ UC ตาม Excel
--where v.visit_date::date >= {0}
--and v.visit_date::date <= {1}
where v.financial_discharge = '1' --จำหน่ายทางการเงินแล้ว
and v.doctor_discharge = '1' --จำหน่ายทางการแพทย์แล้ว
and v.fix_visit_type_id = '0' --ประเภทการเข้ารับบริการ 0 ผู้ป่วยนอก,1 ผู้ป่วยใน
and only_type0.op_type = '0'
and v.vn in ('6501010031')
order by v.vn 
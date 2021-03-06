	--AER 18/01/65 v.1.3
	select q.hn as "HN"
	,q.an as "AN"
	,q.dateopd as "DATEOPD"
	,q.authae as "AUTHAE"
	, '' as "AEDATE"
	,'' as "AETIME"
	,'' as "AETYPE"
	,case when q.an = ''  then 'TEMP:'||q.seq else '' end as "REFER_NO" 
	,case when q.optype = '0' or q.optype = '1' then 
		  (case when LENGTH(regexp_replace(q.description, '\D','','g')) = 5 and q.description not ilike '%กัน%' then regexp_replace(q.description, '\D','','g') else '' end) 
		  else ''  end as "REFMAINI" 
	,case when q.an = '' then '1100' else '1110' end as "IREFTYPE"
	, '' as "REFMAINO"
	, '' as "OREFTYPE"
	,'' as "UCAE"
	, '' as "EMTYPE"
	,q.seq as "SEQ"
	, '' as "AESTATUS"
	, '' as "DALERT"
	, '' as "TALERT"
	--	,q.visit_id
	--	,q.base_department_id
		from (
			select  v.hn as hn
		,v.vn  as SEQ
		,v.an as AN
		,to_char(v.visit_date::date,'yyyymmdd') as DATEOPD
		,visit_payment.card_id as AUTHAE
	   -- ,attending_physician.base_department_id
	    ,v.plan_code
	    ,v.description
	    ,v.visit_id
		,case
			    when TRIM(v.description) = 'นัดรับยา(บัตรทอง)' or TRIM(v.description) = 'ปฐมภูมิUC'  or TRIM(v.description) = 'UC บัตร ท. [ผู้มีรายได้น้อย]' or
			    TRIM(v.description) = 'UC บัตรผู้พิการ /ยกเว้นค่าธรรมเนียม 30 บาท' or TRIM(v.description) = 'UC บัตร ท. ภิกษุ/ผู้นำศาสนา /ยกเว้นค่าธรรมเนียม 30 บาท'  or TRIM(v.description) = 'UC บัตร ท. [ครอบครัวทหารผ่านศึก]' or
			    TRIM(v.description) = 'UC บัตรผู้นำชุมชน /ยกเว้นค่าธรรมเนียม 30 บาท' or TRIM(v.description) = 'UC บัตร ท. [บัตร อสม]'  or TRIM(v.description) = 'UC ท. สิทธิ์ว่าง' or
			    TRIM(v.description) = 'UC ในเครือข่าย /ยกเว้นค่าธรรมเนียม 30 บาท' or TRIM(v.description) = 'UC ฉุกเฉิน /ยกเว้นค่าธรรมเนียม 30 บาท (ต่างจังหวัด)'  or TRIM(v.description) = 'บัตรทอง ช่วงอายุ 12-59 ปี' or
			    TRIM(v.description) = 'บัตรทอง อายุมากกว่า 60 ปี' or TRIM(v.description) = 'บัตรทอง อายุไม่เกิน 12 ปีบริบูรณ์'  or TRIM(v.description) = 'นักศึกษา - บัตรทอง ช่วงอายุ 12-59 ปี' then '7'
			    when TRIM(v.description) = 'UC สิทธิอื่นใน กทม. (Model 5)' or TRIM(v.description) = 'UC นอกเครือข่าย /ยกเว้นค่าธรรมเนียม 30 บาท' then '3'
			    when TRIM(v.description) = 'UC ฉุกเฉินในเครือข่าย (model 5)' or TRIM(v.description) = 'UC ฉุกเฉิน /ยกเว้นค่าธรรมเนียม 30 บาท(กทม.)' then '2'
			    when LENGTH(regexp_replace(v.description, '\D','','g')) = 5 and v.description not ilike '%กัน%' then '0'
			    when TRIM(v.description) = 'UC บัตรผู้พิการ /ยกเว้นค่าธรรมเนียม 30 บาท ในกรุงเทพ' or TRIM(v.description) = 'UC บัตรผู้พิการ /ยกเว้นค่าธรรมเนียม 30 บาท ต่างจังหวัด' then '4'
			    else  '1' end as OPTYPE 
	--	,v.visit_id
		from (
					with cte1 as 
						(select q.*
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
						and cte1.plan_code like 'MD5%' or plan_code in ('UC0005','UC0019') --excel file
			) v 
			left join visit_payment on v.visit_id = visit_payment.visit_id and visit_payment.priority = '1' 
			 where v.visit_date::date >= {0}
			and v.visit_date::date <= {1}
			--where v.vn = '6501020047'
			and v.financial_discharge = '1' 
			and v.doctor_discharge = '1' 
			and v.financial_discharge <> '0' 
		) q
	--where q.base_department_id is not null

	
	



	


	
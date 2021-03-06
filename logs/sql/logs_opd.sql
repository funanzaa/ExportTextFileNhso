--Logs OPD v.2.5 19022565
--Header Upper
-- Add High Cost
with cte1 as (
select q.*
	from (
			select v.hn as "HN"
		,'' as "CLINIC"
		,to_char(visit_date::date,'yyyymmdd') as "DATEOPD"
		,replace(left(visit_time,5),':','') as "TIMEOPD"
		,v.vn as "SEQ"
		,'1' as "UUC"
		,case when char_length(trim(dup_vital_sign_extend.main_symptom)) > 255 then substring(regexp_replace(trim(dup_vital_sign_extend.main_symptom),'\s+','','g'),1,255)
			else regexp_replace(trim(dup_vital_sign_extend.main_symptom),'\s+','','g') end as "DETAIL"
		,v_vital_sign_opd.temperature as "BTEMP"
		,v_vital_sign_opd.pressure_max as "SBP" 
		,v_vital_sign_opd.pressure_min as "DBP"
		,v_vital_sign_opd.pulse as "PR"
		,v_vital_sign_opd.respiration as "RR"
		,case
		    when TRIM(get_plan.description) = 'นัดรับยา(บัตรทอง)' or TRIM(get_plan.description) = 'ปฐมภูมิUC'  or TRIM(get_plan.description) = 'UC บัตร ท. [ผู้มีรายได้น้อย]' or
		    TRIM(get_plan.description) = 'UC บัตรผู้พิการ /ยกเว้นค่าธรรมเนียม 30 บาท' or TRIM(get_plan.description) = 'UC บัตร ท. ภิกษุ/ผู้นำศาสนา /ยกเว้นค่าธรรมเนียม 30 บาท'  or TRIM(get_plan.description) = 'UC บัตร ท. [ครอบครัวทหารผ่านศึก]' or
		    TRIM(get_plan.description) = 'UC บัตรผู้นำชุมชน /ยกเว้นค่าธรรมเนียม 30 บาท' or TRIM(get_plan.description) = 'UC บัตร ท. [บัตร อสม]'  or TRIM(get_plan.description) = 'UC ท. สิทธิ์ว่าง' or
		    TRIM(get_plan.description) = 'UC ในเครือข่าย /ยกเว้นค่าธรรมเนียม 30 บาท' or TRIM(get_plan.description) = 'UC ฉุกเฉิน /ยกเว้นค่าธรรมเนียม 30 บาท (ต่างจังหวัด)'  or TRIM(get_plan.description) = 'บัตรทอง ช่วงอายุ 12-59 ปี' or
		    TRIM(get_plan.description) = 'บัตรทอง อายุมากกว่า 60 ปี' or TRIM(get_plan.description) = 'บัตรทอง อายุไม่เกิน 12 ปีบริบูรณ์'  or TRIM(get_plan.description) = 'นักศึกษา - บัตรทอง ช่วงอายุ 12-59 ปี' then '7'
		    when TRIM(get_plan.description) = 'UC สิทธิอื่นใน กทม. (Model 5)' or TRIM(get_plan.description) = 'UC นอกเครือข่าย /ยกเว้นค่าธรรมเนียม 30 บาท' then '3'
		    when TRIM(get_plan.description) = 'UC ฉุกเฉินในเครือข่าย (model 5)' or TRIM(get_plan.description) = 'UC ฉุกเฉิน /ยกเว้นค่าธรรมเนียม 30 บาท(กทม.)' then '2'
		    when LENGTH(regexp_replace(get_plan.description, '\D','','g')) = 5 and get_plan.description not ilike '%กัน%' then '0'
		    when TRIM(get_plan.description) = 'UC บัตรผู้พิการ /ยกเว้นค่าธรรมเนียม 30 บาท ในกรุงเทพ' or TRIM(get_plan.description) = 'UC บัตรผู้พิการ /ยกเว้นค่าธรรมเนียม 30 บาท ต่างจังหวัด' then '4'
		    else  '' end as "OPTYPE"
		,case when v.fix_coming_type is null then '0' else '1' end as "TYPEIN" 
		,case when doctor_discharge_opd.fix_opd_discharge_status_id = '51' then '1'
			when doctor_discharge_opd.fix_opd_discharge_status_id = '52' then '4'
			when doctor_discharge_opd.fix_opd_discharge_status_id = '53' then 'consult'
			when doctor_discharge_opd.fix_opd_discharge_status_id = '54' then '3'
			else '1' end as "TYPEOUT"
		from visit v 
		left join (select vital_sign_extend.visit_id,vital_sign_extend.main_symptom
						from vital_sign_extend
						inner join (
								SELECT vital_sign_extend_id,
						         ROW_NUMBER() OVER( PARTITION BY visit_id
						        ORDER BY  vital_sign_extend_id desc ) AS row_num
						        FROM vital_sign_extend
						        ) count_vital_sign_extend on count_vital_sign_extend.vital_sign_extend_id = vital_sign_extend.vital_sign_extend_id
						where count_vital_sign_extend.row_num = 1 ) dup_vital_sign_extend on v.visit_id = dup_vital_sign_extend.visit_id
		left join (
					select vital_sign_opd.*
					from vital_sign_opd
					inner join (
								select vital_sign_opd_id,ROW_NUMBER() OVER( PARTITION BY visit_id ORDER by vital_sign_opd_id desc) as chk_dup
								from vital_sign_opd
						 		) chk_vital_sign_opd on chk_vital_sign_opd.vital_sign_opd_id = vital_sign_opd.vital_sign_opd_id and chk_vital_sign_opd.chk_dup = 1
		                 ) v_vital_sign_opd on v.visit_id = v_vital_sign_opd.visit_id
		left join doctor_discharge_opd on v.visit_id = doctor_discharge_opd.visit_id
		left join (
			select visit_payment.visit_id, plan.description
			from visit_payment
			inner join plan on visit_payment.plan_id  = plan.plan_id
			where priority = '1'
		) get_plan on v.visit_id = get_plan.visit_id
      -- where  v.vn in ('6501030037','6501010039','6501010031')
		where v.visit_date::date >= {0}
		and v.visit_date::date <= {1}
		and v.financial_discharge = '1'
		and v.doctor_discharge = '1'
		and v.fix_visit_type_id = '0'
		and get_plan.description <> 'นัดรับยา(บัตรทอง)'
		order by v.vn
	) q
	where q."OPTYPE" <> ''
), cte2 as (	
		select q.vn,STRING_AGG (item_id, ',') item_id
		from ( 
			select v.visit_id,v.vn,order_item.item_id
			from order_item
			inner join visit v on v.visit_id = order_item.visit_id 
	       -- where  v.vn in ('6501030037','6501010039','6501010031')
		    where v.visit_date::date >= {0}
		    and v.visit_date::date <= {1}
		    and order_item.item_id in (select item_id from nhso_op_high_cost)
	    )q
	group by q.vn
) 
select count(*) as visit_all
	,sum(case when q."OPTYPE" = '0' then 1 else 0 end) as optype0
	,sum(case when q."OPTYPE" = '1' then 1 else 0 end) as optype1
	,sum(case when q."OPTYPE" = '2' then 1 else 0 end) as optype2
	,sum(case when q."OPTYPE" = '3' then 1 else 0 end) as optype3
	,sum(case when q."OPTYPE" = '4' then 1 else 0 end) as optype4
	,sum(case when q."OPTYPE" = '5' then 1 else 0 end) as optype5
	,sum(case when q."OPTYPE" = '6' then 1 else 0 end) as optype6
	,sum(case when q."OPTYPE" = '7' then 1 else 0 end) as optype7
from (
	select cte1."HN",cte1."CLINIC",cte1."DATEOPD",cte1."TIMEOPD",cte1."SEQ",cte1."UUC",cte1."DETAIL",cte1."BTEMP"
	,cte1."SBP",cte1."DBP",cte1."PR",cte1."RR"
	--,cte2.item_id as check_highcost
	--,cte1."OPTYPE" 
	,case when cte2.item_id is null then cte1."OPTYPE" 
	      when cte1."OPTYPE" = '7' and cte2.item_id is not null  then '5'  
	      else cte1."OPTYPE" end as "OPTYPE" 
	,cte1."TYPEIN",cte1."TYPEOUT" 
	from cte1
	left join cte2 on cte1."SEQ" = cte2.vn
)q



--LABFU 18/01/65 v.1.4
-- dup LAB v.1.3
with t1 as (
		select cte1.*
				from (
					select base_site.base_site_id as HCODE
					,v.hn as HN
					,patient.pid as PERSON_ID 
					,to_char(v.visit_date::date,'yyyymmdd') as DATE_SERV
					,v.vn as SEQ
					,v.an as AN 
					,case when order_item.item_id = 'labitems_3001' then '01' --Glucose
					      when order_item.item_id = 'labitems_52' then '03'  --Dexto
					      when order_item.item_id = 'labitems_48' then '05'  --HbA1C
					      when order_item.item_id = 'labitems_3006' then '06' -- Triglyceride
					      when order_item.item_id = 'labitems_3005' then '07' -- Cholesterol
					      when order_item.item_id = 'labitems_3007' then '08' -- HDL-Cholesterol
					      when order_item.item_id = 'labitems_596' then '09' --LDL - Chol
					      when order_item.item_id = 'labitems_173' then '10'  -- BUN
					      when order_item.item_id = 'labitems_3003' then '11' -- Creatinine
					      when order_item.item_id = 'tg000000064' then '12' -- Microalbuminuria
					      when order_item.item_id = '111092821040111901' then '15' -- Estimated GFR
					      when order_item.item_id = '110090409083922001' then '18' -- Potassium (Serum)
					      when order_item.item_id = '217090109082564001' then '20' -- PHOSPHORUS
					      when order_item.item_id = '201308211715001180' then '19' -- Electrolytes - Na, K, Cl, CO2
					      else 'NotMap' end as LABTEST
			    , order_item.item_id
			    ,order_item.order_item_id 
			    ,item.common_name 
				,lab_result.lab_result_id
				,ROW_NUMBER() OVER( PARTITION BY order_item.item_id order by lab_result.start_time desc ) AS row_num
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
									where q.base_plan_group_code is not null and q.description <> '????????????????????????(?????????????????????)'
									)
									select * from cte1 where cte1.chk_plan is not null 
						) v 
					left join patient on v.patient_id = patient.patient_id 
					inner join order_item on v.visit_id = order_item.visit_id 
					inner join item on order_item.item_id = item.item_id 
					inner join lab_result on order_item.order_item_id = lab_result.order_item_id 
		--	       inner join lab_test on lab_result.lab_result_id = lab_test.lab_result_id and lab_test.active = '1'
					,base_site
					where v.visit_date::date >= {0}
					and v.visit_date::date <= {1}
					and v.financial_discharge = '1' 
					and v.doctor_discharge = '1' 
					and order_item.fix_item_type_id = '1' 
					--and v.fix_visit_type_id = '1' --?????????????????????????????????????????????????????????????????? 0 ??????????????????????????????,1 ???????????????????????????
					--and v.visit_id = '121090107185617001'
					--and v.vn = '6409020024' -- 6409020024
					and order_item.fix_item_type_id = '1' -- lab
					--order by lab_result.start_time desc
				) cte1 
			where cte1.labtest <> 'NotMap'
			and cte1.row_num::int <= 1 -- dup lab
) -- get table map
select q.hcode as "HCODE"
,q.hn as "HN"
,q.person_id as "PERSON_ID"
,q.date_serv as "DATE_SERV"
,q.seq as "SEQ"
,q.labtest as "LABTEST"
,q.value as "LABRESULT"
from (
	select t1.*,lab_test.lab_result_id as bb ,lab_test."name",lab_test.value 
	,case when t1.common_name = lab_test."name" or lab_test."name" = 'Total CO2' then '1' else '0' end as checkresult
	from t1
left join lab_test on t1.lab_result_id = lab_test.lab_result_id and lab_test.active = '1' 
) q
where q.checkresult <> '0'
order by q.date_serv,q.seq


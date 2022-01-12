--IPD 08/10/64 v.1.1
--แฟ้มข้อมูลผู้ป่วยใน (IPD)
-- Header UPPER  02/01/65
select v.hn as "HN"
,v.an as "AN"
,to_char(v.visit_date::date,'yyyymmdd') as "DATEADM"
,to_char(v.visit_time::time,'HH24MI') as "TIMEADM"
,to_char(v.doctor_discharge_date::date,'yyyymmdd') as "DATEDSC" 
,to_char(v.doctor_discharge_time::time,'HH24MI') as "TIMEDSC"
,doctor_discharge_ipd.fix_ipd_discharge_status_id as "DISCHS" 
,doctor_discharge_ipd.fix_ipd_discharge_type_id as "DISCHT" 
, '' as "WARDDSC"
,'' as "DEPT"
,v_vital_sign_opd.weight as "ADM_W"
,'1' as "UUC"
,'1' as "SVCTYPE"
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
  --  where v.visit_date::date >= {0}
  --  and v.visit_date::date <= {1}
where v.financial_discharge = '1' 
and v.doctor_discharge = '1' 
and v.fix_visit_type_id = '1' 
and v.vn in ('6501010031')
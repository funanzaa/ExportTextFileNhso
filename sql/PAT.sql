--PAT 15/10/64 v.1.5
-- มาตรฐานแฟ้มข้อมูลผู้ป่วยกลาง (PAT) 
-- v.1.3 ตัด colum dup
-- v.1.4 ตัด fname,lname tab
--1.5 แก้ไขดึงเฉพาะสิทธิ์ ใน excel
with cte1 as 
(
	select base_site.base_site_id 
	,p.hn 
--	,'' as CHANGWAT
--	, '' as AMPHUR
	,to_char(p.birthdate::date,'ddmmyyyy') as DOB
	,gender.fix_gender_id as SEX
	,case when marriage.fix_marriage_id = '5' then '3' -- imed 5 = หม้าย , nhso 3 = หม้าย
	 	  when marriage.fix_marriage_id = '3' then '5' -- imed 3 = แยกกันอยู่ (ร้าง) , nhso 5 = แยกกันอยู
	 	  else marriage.fix_marriage_id end as MARRIAGE 
	 ,case when occupation.fix_occupation_id <> '' then occupation.fix_occupation_id  else '000'  end as OCCUPA
	 ,nationality.fix_nationality_id as NATION
	 ,p.pid as PERSON_ID
	 ,regexp_replace(p.firstname, '[^\w]+','','g')||' '||regexp_replace(p.lastname, '[^\w]+','','g')||','||p.prename as NAMEPAT --only text
	-- ,case when char_length(trim(p.firstname)||' '||trim(p.lastname)||','||trim(p.prename)) > 36 then substring(trim(p.firstname)||' '||trim(p.lastname)||','||trim(p.prename),1,36) else trim(p.firstname)||' '||trim(p.lastname)||','||trim(p.prename) end as NAMEPAT -- check over 36 
	 ,trim(p.prename) as TITLE
	,p.firstname as FNAME
	 ,p.lastname as LNAME
	,case when p.pid <> '' then '1' else '' end as IDTYPE
	 from (
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
	) v --เฉพาะ visit ที่เป็นสิทธิ์ UC ตาม Excel 
	left join patient p on v.patient_id = p.patient_id 
	left join fix_gender gender on p.fix_gender_id = gender.fix_gender_id -- sex
	left join fix_marriage marriage on p.fix_marriage_id = marriage.fix_marriage_id 
	left join fix_occupation occupation on p.fix_occupation_id = occupation.fix_occupation_id 
	left join fix_nationality nationality on p.fix_nationality_id = nationality.fix_nationality_id 
	,base_site
    --where v.visit_date::date >= {0}
    --and v.visit_date::date <= {1}
	where v.financial_discharge = '1' --จำหน่ายทางการเงินแล้ว
	and v.doctor_discharge = '1' --จำหน่ายทางการแพทย์แล้ว
	and v.vn in ('6501010031')
	order by v.vn 
--and v.visit_id = '121090107433621501'
)
select cte1.base_site_id as "HCODE"
,cte1.hn as "HN"
,'' as "CHANGWAT" 
,'' as "AMPHUR"
,cte1.dob as "DOB"
,cte1.sex as "SEX"
,cte1.marriage as "MARRIAGE"
,cte1.occupa as "OCCUPA"
,cte1.nation as "NATION"
,cte1.person_id as "PERSON_ID"
,cte1.namepat as "NAMEPAT"
,cte1.title as "TITLE"
,cte1.fname as "FNAME"
,cte1.lname as "LNAME"
,cte1.idtype as "IDTYPE"
from cte1
group by cte1.base_site_id
,cte1.hn
--,cte1.changwat
--,cte1.amphur
,cte1.dob
,cte1.sex
,cte1.marriage
,cte1.occupa
,cte1.nation
,cte1.person_id
,cte1.namepat
,cte1.title
,cte1.fname
,cte1.lname
,cte1.idtype

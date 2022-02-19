--ADP 02/01/65 v.1.3
--code free schedule table 
select q.hn as "HN"
,q.an as "AN"
,q.dateopd as "DATEOPD"
,q."type" as "TYPE"
,q.code as "CODE"
,q.qty as "QTY"
,q.rate as "RATE"
,q.seq as "SEQ"
,q.cagcode as "CAGCODE"
,'' as "DOSE"
,q.ca_type as "CA_TYPE"
,q.serialno as "SERIALNO"
,q.totcopay  as "TOTCOPAY"
,case when q."type" = '11' then  '1' else q."use_status" end as "USE_STATUS"
,q.total  as "TOTAL"
,q.qtyday as "QTYDAY"
,q.tmltcode as "TMLTCODE"
,q.status1 as "STATUS1"
,q.bi  as "BI"
,q.clinic as "CLINIC"
,q.itemsrc as "ITEMSRC"
,q.provider as "PROVIDER"
from(
select v.hn as hn
		,v.an as AN
		,to_char(v.visit_date::date,'yyyymmdd') as dateopd
		--,base_billing_group.map_chrgitem_opd
		--,base_billing_group.map_chrgitem_ipd
		--covert ADP Type
		,case when base_billing_group.map_chrgitem_opd = '11' then '10' 
			  when base_billing_group.map_chrgitem_opd = '21' then '2'  
			  when base_billing_group.map_chrgitem_opd = '51' then '11' 
			  when base_billing_group.map_chrgitem_opd = '61' then '14' 
			  when base_billing_group.map_chrgitem_opd = '71' then '15' 
		      when base_billing_group.map_chrgitem_opd = '81' then '16'
		      when base_billing_group.map_chrgitem_opd = '91' then '9' 
			  when base_billing_group.map_chrgitem_opd = 'A1' then '18' 
			  when base_billing_group.map_chrgitem_opd = 'B1' then '19' 
			  when base_billing_group.map_chrgitem_opd = 'C1' then '17' 
			  when base_billing_group.map_chrgitem_opd = 'D1' then '12' 
			  when base_billing_group.map_chrgitem_opd = 'E1' then '20' 
			  when base_billing_group.map_chrgitem_opd = 'F1' then '13' 
			  else '' end as "type"
		,order_item.pcp_item_code as code
		,order_item.quantity as qty 
		,order_item.unit_price_sale as rate 
		,v.vn  as SEQ
		,'' as CAGCODE 
		,order_item.quantity  || ' ' || order_item.base_unit_id  as DOSE 
		,'' as CA_TYPE
		,'' as SERIALNO
		, '' as TOTCOPAY 
		,order_item.take_home as USE_STATUS 
		,(order_item.unit_price_sale ::decimal * order_item.quantity::decimal)::decimal(7,2) as TOTAL 
		,'' as QTYDAY 
		,'' as TMLTCODE 
		, '' as STATUS1  
		,'' as BI 
		, '' as CLINIC 
		, '' as ITEMSRC 
		,'' as PROVIDER 
			from (
					with cte1 as 
						(select q.*
							,case when q.base_plan_group_code in ('CHECKUP') and q.plan_code in ('PCP006') then 'UC'  
								  when q.base_plan_group_code in ('Model5','UC') then 'UC' end as chk_plan 
							from (
								select v.*,base_plan_group.base_plan_group_code,plan.plan_code 
								from visit v 
								left join visit_payment on v.visit_id = visit_payment.visit_id and visit_payment.priority = '1'
								left join base_plan_group on visit_payment.base_plan_group_id = base_plan_group.base_plan_group_id and base_plan_group.base_plan_group_code in ('Model5','UC','CHECKUP') 
								left join plan on visit_payment.plan_id = plan.plan_id 
							) q
							where q.base_plan_group_code is not null )
						select * from cte1 where cte1.chk_plan is not null 
			) v 
		left join (
					with cte1 as (
								select order_item_id,visit_id,base_billing_group_id,unit_price_sale,quantity,base_unit_id ,item_id,take_home
								from order_item 
								where quantity not like '-%' and unit_price_sale <> '0'
							) --order 
					, cte2 as (
						select item.item_id,item.common_name ,pcp_item.pcp_item_rn,pcp_item.pcp_item_code 
						from item
						inner join pcp_item on item.pcp_item_rn = pcp_item.pcp_item_rn 
					)
					select * 
					from cte1
					inner join cte2 on cte2.item_id = cte1.item_id
			) order_item on v.visit_id = order_item.visit_id
		left join (
			select visit_payment.visit_id, plan.description
			from visit_payment
			inner join plan on visit_payment.plan_id  = plan.plan_id
			where priority = '1') get_plan on v.visit_id = get_plan.visit_id 
		left join base_billing_group on order_item.base_billing_group_id = base_billing_group.base_billing_group_id 
		left join patient p on v.patient_id = p.patient_id 
--  where v.visit_date::date >= {0}
--    and v.visit_date::date <= {1}
	where v.vn in ('6501010031')
and v.financial_discharge <> '0' --ค้างชำระ	
) q
where q."type" <> ''	
order by q.dateopd,q.seq

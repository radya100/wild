insert into odc(
log_id
,rid
,order_id
,employee_id
,dt
,chrt_id
,shk_id
,status_id
,sale_price_100
,finished_price_100
,src_office_id
,src_outfit_id
,wh_id
,site_country
,subject_id
,subject_id_one
)
select
log_id
,rid
,order_id
,employee_id
,dt
,chrt_id
,shk_id
,status_id
,sale_price_100
,finished_price_100
,src_office_id
,src_outfit_id
,wh_id
,site_country
,subject_id
,dictGetUInt64('Subject', 'subject_id_one', subject_id) as subject_id_one
from
(
select
log_id
,rid
,order_id
,employee_id
,dt
,chrt_id
,toUInt64(shk_id) as shk_id
,status_id
,sale_price_100
,finished_price_100
,src_office_id
,src_outfit_id
,wh_id
,site_country
,dictGetUInt64('Chrt', 'subject_id', chrt_id) as subject_id
from stage_odc
where shk_id > 0
)



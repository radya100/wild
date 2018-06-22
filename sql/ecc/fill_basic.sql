insert into ecc(
log_id
,employee_id
,place_cod
,wh_id
,brigade_id
,dt
,isdeleted
,coef_100
)
select
log_id
,employee_id
,place_cod
,dictGetUInt64('StoragePlace', 'wh_id', place_cod) as wh_id
,brigade_id
,dt
,isdeleted
,coef_100
from stage_ecc

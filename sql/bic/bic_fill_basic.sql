insert into bic(
log_id
,barcode
,place_cod
,box_id
,qty
,employee_id
,dt
,chrt_id
,place_type_id
,stage
,wh_id
)
select
log_id
,barcode
,place_cod
,box_id
,qty
,employee_id
,dt
,chrt_id
,place_type_id
,stage
,wh_id
from stage_bic

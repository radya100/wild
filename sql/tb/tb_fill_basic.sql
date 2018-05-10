insert into TransferBoxChange (
log_id
,transfer_box_id
,dt
,dt_date
,employee_id
,ttn_id
,place_cod
,src_office_id
,shipping_office_id
,dst_office_id
,is_deleted
,sm_id
,is_jewelry
,is_create
,is_close
,box_type
,box_weight_100
,box_lenght_100
,box_width_100
,box_height_100
,wh_id
,place_type_id
) select 
log_id
,transfer_box_id
,dt
,dt_date
,employee_id
,ttn_id
,place_cod
,src_office_id
,shipping_office_id
,dst_office_id
,is_deleted
,sm_id
,is_jewelry
,is_create
,is_close
,box_type
,box_weight_100
,box_lenght_100
,box_width_100
,box_height_100
,dictGetUInt64('StoragePlace','wh_id', place_cod)
,dictGetUInt64('StoragePlace', 'place_type_id', place_cod) 
from stage_TransferBoxChange

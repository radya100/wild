CREATE TABLE default.stage_TransferBoxChange (
log_id UInt64
,transfer_box_id UInt64
,dt DateTime
,dt_date Date
,employee_id UInt64
,ttn_id UInt64
,place_cod UInt64
,src_office_id UInt64
,shipping_office_id UInt64
,dst_office_id UInt64
,is_deleted UInt8
,sm_id UInt64
,is_jewelry UInt8
,is_create UInt8
,is_close UInt8
,box_type UInt32
,box_weight_100 UInt64
,box_lenght_100 UInt64
,box_width_100 UInt64
,box_height_100 UInt64
) ENGINE = Memory

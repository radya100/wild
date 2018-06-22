create table default.stage_epc (
log_id UInt64
,employee_id UInt64
,start_dt DateTime
,container_safe UInt64
,assigned_safe_dt DateTime
,container_shoes UInt64
,assigned_shoes_dt DateTime
,container_repack UInt64
,assigned_repack_dt DateTime
,tare_safe UInt64
,tare_shoes UInt64
,tare_repack UInt64
,return_box_id UInt64
,return_box_dt DateTime
,return_transfer_box_id UInt64
,tare_move_to_office UInt64
,assigned_move_to_office_dt DateTime
,return_photo_box_id String
,tare_move_shoes_to_office UInt64
,assigned_move_shoes_to_office_dt DateTime
,table_place_cod UInt64
) ENGINE = Memory

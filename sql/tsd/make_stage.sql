drop table if exists default.stage_tsd;
create table default.stage_tsd(
log_id UInt64
,tsd_id UInt32
,serial_id String
,employee_id UInt64
,pb DateTime
,pe DateTime
,lock_dt DateTime
,lock_employee_id UInt64
,unlock_dt DateTime
,unlock_employee_id UInt64
,lock_comment String
,model_no  String
,erp_version String
,part UInt64
,place_cod UInt64
,module_name String
,module_dt DateTime
,logout_comment String
,wifi_name String
) ENGINE = Memory

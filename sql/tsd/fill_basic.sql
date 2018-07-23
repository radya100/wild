insert into tsd
(
log_id
,tsd_id
,serial_id
,employee_id
,pb
,pe
,lock_dt
,lock_employee_id
,unlock_dt
,unlock_employee_id
,lock_comment
,model_no
,erp_version
,part
,place_cod
,module_name
,module_dt
,logout_comment
,wifi_name
,wh_id
,part_id
)
select
log_id
,tsd_id
,serial_id
,employee_id
,pb
,pe
,lock_dt
,lock_employee_id
,unlock_dt
,unlock_employee_id
,lock_comment
,model_no
,erp_version
,part
,place_cod
,module_name
,module_dt
,logout_comment
,wifi_name
,dictGetUInt64('StoragePlace','wh_id',place_cod) as wh_id
,multiIf
(
(tsd_id<10000),1
,(tsd_id>=10000 and tsd_id<20000),2
,(tsd_id>=20000 and tsd_id<30000),3
,(tsd_id>=30000 and tsd_id<40000),4
,(tsd_id>=40000 and tsd_id<50000),5
,(tsd_id>=50000 and tsd_id<60000),6
,(tsd_id>=60000 and tsd_id<70000),7
,(tsd_id>=70000 and tsd_id<80000),8
,(tsd_id>=80000 and tsd_id<90000),9
,(tsd_id>=90000 and tsd_id<100000),10
,(tsd_id>=100000 and tsd_id<110000),11
,12
) as part_id
from stage_tsd

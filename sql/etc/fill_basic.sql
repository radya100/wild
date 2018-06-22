insert into etc(
log_id
,place_cod
,assigned_employee_id
,camera_id
,dt
,employee_id
,wh_id
,server_ip
,camera_number_on_server
,camera_name
)
select
log_id
,place_cod
,assigned_employee_id
,camera_id
,dt
,employee_id
,dictGetUInt64('StoragePlace', 'wh_id', place_cod) as wh_id
,dictGetString('Camera', 'server_ip', camera_id) as server_ip
,dictGetUInt64('Camera', 'camera_number_on_server', camera_id) as camera_number_on_server
,dictGetString('Camera', 'camera_name', camera_id) as camera_name
from stage_etc

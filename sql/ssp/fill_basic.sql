insert into ssp(
id
,shk_id
,dt
,shift_number
,employee_id
,employee_time100
,state_id
,place_cod
,wh_id
,place_type_id
,stage
,is_assigned
,chrt_id
,nm_id
,subject_id
,subject_name
,subject_id_one
,subject_name_one
,ts_name
,is_virtual
)
select
id
,shk_id
,dt
,shift_number
,employee_id
,employee_time100
,state_id
,place_cod
,dictGetUInt64('StoragePlace', 'wh_id', place_cod) as wh_id
,dictGetUInt64('StoragePlace', 'place_type_id', place_cod) as place_type_id
,dictGetUInt64('StoragePlace', 'stage', place_cod) as stage
,is_assigned
,chrt_id
,dictGetUInt64('Chrt', 'nm_id', chrt_id) as nm_id
,dictGetUInt64('Chrt', 'subject_id', chrt_id) as subject_id
,dictGetString('Subject', 'subject_name', subject_id) as subject_name
,dictGetUInt64('Subject', 'subject_id_one', subject_id) as subject_id_one
,dictGetString('Subject', 'subject_name', subject_id_one) as subject_name_one
,dictGetString('Chrt', 'ts_name', chrt_id) as ts_name
,is_virtual
from stage_ssp
any left join
(
select
dt_date
,place_cod
,employee_id
,toUInt8(1) as is_assigned
from pia
where dt_date >= '_pb_' and dt_date <= '_pe_'
) a1 using dt_date, place_cod, employee_id
where shk_id > 0

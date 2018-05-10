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


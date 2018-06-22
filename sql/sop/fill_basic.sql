insert into sop (sop_chg_id, shk_id, dt, dt_date, employee_id, place_cod, wh_id, storage_id, stage, box_id, container_id, isdeleted)
select
sop_chg_id
,shk_id
,dt
,dt_date
,employee_id
,place_cod
,dictGetUInt64('StoragePlace', 'wh_id', place_cod) as wh_id
,dictGetUInt64('StoragePlace', 'storage_id', place_cod) as storage_id
,dictGetUInt64('StoragePlace', 'stage', place_cod) as stage
,toUInt64(box_id<0?0:box_id) as box_id
,toUInt64(container_id<0?0:container_id) as container_id
,isdeleted
from stage_sop

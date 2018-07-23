insert into dsop (log_id, docshk_id, dt, employee_id, place_cod, box_id, isdeleted, doc_num, doctype_id, wh_id, place_type_id)
select
log_id
,docshk_id
,dt
,employee_id
,place_cod
,box_id
,isdeleted
,doc_num
,doctype_id
,dictGetUInt64('StoragePlace', 'wh_id', place_cod) as wh_id
,dictGetUInt64('StoragePlace', 'place_type_id', place_cod) as place_type_id
from stage_dsop

CREATE TABLE default.stage_dsop(
log_id UInt64
,docshk_id UInt64
,dt DateTime
,employee_id UInt64
,place_cod UInt64
,box_id UInt64
,isdeleted Int8
,doc_num String
,doctype_id UInt16
) ENGINE = Memory

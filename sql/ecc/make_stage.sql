create table default.stage_ecc (
log_id UInt64
, employee_id UInt64
, place_cod UInt64
, brigade_id UInt64
, dt DateTime
, isdeleted UInt8
, coef_100 UInt64
) ENGINE = Memory

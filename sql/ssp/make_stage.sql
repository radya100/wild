CREATE TABLE default.stage_ssp (
id UInt64
, shk_id Int64
, dt DateTime
, shift_number UInt32
, employee_id UInt64
, employee_time100 UInt64
, state_id String
, place_cod UInt64
, dt_date Date MATERIALIZED toDate(dt)
, chrt_id UInt64
, is_virtual Int8
) ENGINE = Memory

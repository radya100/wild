CREATE TABLE default.stage_bic (
log_id UInt64
, barcode String
, place_cod UInt64
, box_id Int64
, qty UInt64
, employee_id UInt64
, dt DateTime
, chrt_id UInt64
, place_type_id UInt64
, stage UInt64
, wh_id UInt64
, dt_date Date MATERIALIZED toDate(dt)
) ENGINE = Memory

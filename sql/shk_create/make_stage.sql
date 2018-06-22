create table default.stage_shk_create (
log_id UInt64
, shk_id UInt64
, dt DateTime
, employee_id UInt64
, department_id UInt64
, barcod String
, isFullBarcod UInt8
, brand_id UInt64
, supplier_id UInt64
, box_id UInt64
, place_cod UInt64
, fake_shk UInt64
, invdet_id UInt64
, beg_row UInt64
, end_row UInt64
, cur_row UInt64
, price_100 UInt64
, container_id UInt64
, supplier_box_id UInt64
, accepted_box_id UInt64
, brigade_id UInt64
) ENGINE = Memory

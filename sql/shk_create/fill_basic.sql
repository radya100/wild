insert into shk_create(
log_id
, shk_id
, dt
, employee_id
, department_id
, barcod
, isFullBarcod
, brand_id
, supplier_id
, box_id
, place_cod
, wh_id
, fake_shk
, invdet_id
, beg_row
, end_row
, cur_row
, price_100
, container_id
, supplier_box_id
, accepted_box_id
, brigade_id
)
select
log_id
, shk_id
, dt
, employee_id
, department_id
, barcod
, isFullBarcod
, brand_id
, supplier_id
, box_id
, place_cod
, dictGetUInt64('StoragePlace', 'wh_id', place_cod) as wh_id
, fake_shk
, invdet_id
, beg_row
, end_row
, cur_row
, price_100
, container_id
, supplier_box_id
, accepted_box_id
, brigade_id
from stage_shk_create

CREATE TABLE default.stage_spc(
log_id Int64
,shk_id Int64
,dt DateTime
,dt_date Date
,employee_id UInt64
,price_100 Int64
,price_ru_100 Int64
,currency_id UInt64
,reason String
,person_id UInt64
,supplier_id UInt64
,suppliercontract_id UInt64
,is_deleted Int8
,place_cod UInt64
,is_manual Int8
,is_manual_price Int8
,old_shk_id Int64
,is_new_shk Int8
,outstaff_person_id UInt64
,is_updated Int8
) ENGINE = Memory

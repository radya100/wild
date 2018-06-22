create table stage_odc (
log_id UInt64,
rid UInt64,
order_id UInt64,
employee_id UInt64,
dt DateTime,
chrt_id UInt64,
shk_id Int64,
status_id UInt64,
sale_price_100 UInt64,
finished_price_100 UInt64,
src_office_id UInt64,
src_outfit_id UInt64,
wh_id UInt64,
site_country String
) ENGINE = Memory

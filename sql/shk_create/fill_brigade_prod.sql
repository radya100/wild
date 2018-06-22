insert into shk_create_income_brigade_productivity(
dt
,shk_id
,subject_id
,subject_id_one
,employee_id
,brigade_id
,coef_100
,place_cod
,wh_id
)
select
dt
,shk_id
,0
,0
,employee_id
,brigade_id
,coef_100
,place_cod
,wh_id
from
(
select 
dt
,shk_id
,employee_id
,brigade_id
,coef_100
,place_cod
,wh_id
from
(
select
dt
,shk_id
,brigade_id
,place_cod
,dictGetUInt64('StoragePlace', 'wh_id', place_cod) as wh_id
from stage_shk_create
)
all inner join
(
select
brigade_id
,employee_id
,coef_100
from ecc
where brigade_id >= _lb_ and brigade_id <= _le_
and isdeleted = 0
) using brigade_id
)
any left join
(
select
dt as dt_delete
, brigade_id
, employee_id
from ecc
where brigade_id >= _lb_ and brigade_id <= _le_
and isdeleted = 1
) using brigade_id, employee_id
where ((dt_delete > dt) or (dt_delete = '0000-00-00 00:00:00'))


set nocount on;
set quoted_identifier on;
set ansi_nulls on;
set ansi_padding on;

set transaction isolation level read uncommitted;

select top _rows_
shk_state_chg_id
, shk_id
, cast(dt as datetime2(0))  as dt
, cast(dt as date) as dt_date
, ssc.employee_id
, isnull(state_id, '') as state_id
, case when datepart(HH, dt) between 8 and 19 then 'DS'	else 'NS' end as smena
, ssc.isdeleted
from History.ShkStateChange ssc
where shk_state_chg_id >= _lb_
order by shk_state_chg_id

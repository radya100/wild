SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
select top (_rows_)
id
, shk_id
, cast(dt as datetime2(0)) as dt
, shift_number
, employee_id
, cast(employee_time*100 as int) as employee_time100
, state_id
, place_cod
from History.ShkState_Productivity2 ssp with(nolock)
where id > _lb_
order by id

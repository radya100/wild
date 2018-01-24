set nocount on;
set quoted_identifier on;
set ansi_nulls on;
set ansi_padding on;

set transaction isolation level read uncommitted;
select top _rows_
  sop_chg_id
, shk_id
, cast(dt as datetime2(0)) as dt
, cast(dt as date) as dt_date
, isnull (employee_id, -1) as employee_id
, isnull (place_cod, -1) as place_cod
, isnull(box_id, -1) as box_id
, isnull(container_id, -1) as container_id
, isnull(isdeleted, 0) as isdeleted
from NC.History.ShkOnPlaceChange sop
where sop_chg_id >= _lb_
order by sop_chg_id asc
option (recompile)


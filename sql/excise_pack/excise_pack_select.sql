SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
select
ep_id as log_id
,quantity as qty
,cast(dt as datetime2(0)) as dt
,subject_id as subject_id_one
from Warehouse.ExcisePack
where ep_id > _lb_
order by ep_id

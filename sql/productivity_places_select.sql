SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
select
place_cod
, wh_id
, productivity_id
, productivity_descr
from WarehouseReader.v_get_productivity_places

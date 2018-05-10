create table default.productivity_places (place_cod UInt64, wh_id Int16, productivity_id Int32, productivity_descr String)ENGINE=Join(All, INNER, place_cod)

ATTACH VIEW v_loader_hours
(
    employee_id UInt64, 
    employee_name String, 
    dt_hour DateTime, 
    wh_id UInt64, 
    wh_name String, 
    productivity_id Int32, 
    qty UInt64
) AS
SELECT 
    employee_id, 
    dictGetString('Employee', 'employee_name', employee_id) AS employee_name, 
    dt_hour, 
    wh_id, 
    dictGetString('Warehouse', 'wh_name', wh_id) AS wh_name, 
    productivity_id, 
    sum(qty) AS qty
FROM 
(
    SELECT 
        toUInt64(employee_id) AS employee_id, 
        dt_hour, 
        toUInt64(wh_id) AS wh_id, 
        productivity_id, 
        count(1) AS qty
    FROM 
    (
        SELECT 
            transfer_box_id, 
            productivity_id, 
            wh_id, 
            argMinMerge(employee_id) AS employee_id, 
            argMinMerge(dt_hour) AS dt_hour
        FROM mvTB_loaders 
        GROUP BY 
            transfer_box_id, 
            productivity_id, 
            wh_id, 
            dt_month
    ) AS a1 
    GROUP BY 
        employee_id, 
        dt_hour, 
        wh_id, 
        productivity_id
    UNION ALL
    SELECT 
        employee, 
        dt_hour, 
        wh_id, 
        productivity_id, 
        count() AS qty
    FROM 
    (
        SELECT 
            prep_employee_id AS employee, 
            toStartOfHour(prep_dt) AS dt_hour, 
            dictGetUInt64('StoragePlace', 'wh_id', toUInt64(place_cod)) AS wh_id, 
            productivity_id
        FROM default.ContainerChange 
        ALL INNER JOIN productivity_places USING (place_cod)
        WHERE (super_wave_id > 0) AND (productivity_id = 4)
        GROUP BY 
            prep_employee_id, 
            prep_dt, 
            productivity_id, 
            place_cod
        UNION ALL
        SELECT 
            lift_employee_id AS employee, 
            toStartOfHour(lift_dt) AS dt_hour, 
            dictGetUInt64('StoragePlace', 'wh_id', toUInt64(place_cod)) AS wh_id, 
            productivity_id
        FROM ContainerChange AS cc 
        ALL INNER JOIN productivity_places USING (place_cod)
        WHERE (super_wave_id > 0) AND (productivity_id = 5)
        GROUP BY 
            lift_employee_id, 
            lift_dt, 
            productivity_id, 
            place_cod
    ) 
    GROUP BY 
        employee, 
        dt_hour, 
        wh_id, 
        productivity_id
    UNION ALL
    SELECT 
        employee, 
        dt_hour, 
        wh_id, 
        productivity_id, 
        count() AS qty
    FROM 
    (
        SELECT 
            box_id, 
            productivity_id, 
            toUInt64(wh_id) AS wh_id, 
            argMinMerge(employee_id) AS employee, 
            argMinMerge(dt_hour) AS dt_hour
        FROM mvPC_loader_tables 
        GROUP BY 
            box_id, 
            productivity_id, 
            wh_id, 
            dt_month
        UNION ALL
        SELECT 
            box_id, 
            productivity_id, 
            toUInt64(wh_id) AS wh_id, 
            argMinMerge(employee_id) AS employee_id, 
            argMinMerge(dt_hour) AS dt_hour
        FROM mvPC_loader_buffers 
        GROUP BY 
            box_id, 
            productivity_id, 
            wh_id, 
            dt_month
    ) AS a2 
    GROUP BY 
        employee, 
        dt_hour, 
        wh_id, 
        productivity_id
) 
GROUP BY 
    employee_id, 
    dt_hour, 
    wh_id, 
    productivity_id

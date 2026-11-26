SELECT distinct ISNULL(K.table_name,'') + ',' + ISNULL(A.column_name,'')  + ',' + ISNULL(B.column_name,'')  + ',' + ISNULL(C.column_name,'') , K.table_name, A.column_name as company_name, B.column_name as plant_id, C.column_name as storage_id FROM
	(select distinct table_name from (SELECT t.Name As table_name,
	c.Name As column_name
	FROM sys.tables AS t
	INNER JOIN sys.columns as c
	on t.object_id = c.object_id

	where 
	t.Name <> 'TH_OC_CONV_MASTER' and
	(c.Name like '%company_Id%' 
	or c.Name like '%plant_id%'
	or c.Name like '%storage_id%')
	and 
	(t.Name not like 'buf_%'
	and t.Name not like 'his_%'
	and t.Name not like 'temp_%'
	and t.Name not like 'th_buf_%')
	)M) K
LEFT OUTER JOIN
	(SELECT t.Name As table_name,
	c.Name As column_name
	FROM sys.tables AS t
	INNER JOIN sys.columns as c
	on t.object_id = c.object_id
	where c.Name like '%company_Id%') A
ON K.table_name = A.table_name
LEFT OUTER JOIN
	(SELECT t.Name As table_name,
	c.Name As column_name
	FROM sys.tables AS t
	INNER JOIN sys.columns as c
	on t.object_id = c.object_id
	where c.Name like '%plant_id%') B
ON K.table_name = B.table_name
LEFT OUTER JOIN
	(SELECT t.Name As table_name,
	c.Name As column_name
	FROM sys.tables AS t
	INNER JOIN sys.columns as c
	on t.object_id = c.object_id
	where c.Name like '%storage_id%') C
ON K.table_name = c.table_name
order by table_name
SELECT 
		*
    FROM scm_sys_log_batch c
	WHERE 1=1
		--AND (@p_program_name is null or c.program_name like '%'+ @p_program_name + '%' )
		AND (@p_log_type IS NULL OR isnull(c.log_type,'') = @p_log_type )
		--AND (@p_log_message IS NULL OR isnull(c.log_message,'') = @p_log_message )
	--	AND (@p_description IS NULL OR isnull(c.description,'') = @p_description )
		AND (@p_created_by IS NULL OR isnull(c.CREATED_BY,'') = @p_created_by )
		--AND (@p_last_updated_by IS NULL OR isnull(c.LAST_UPDATED_BY,'') = @p_last_updated_by )
		AND  CREATION_DATE >= CONVERT(DATETIME, @p_CREATION_FROM, 112)
    AND  CREATION_DATE <= CONVERT(DATETIME, @p_CREATION_TO, 112)
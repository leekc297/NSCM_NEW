DECLARE @v_sql					NVARCHAR(MAX);
			SET @v_sql = 
			(
				SELECT
					Z.OK
				FROM
				(
					SELECT 
						A.STORAGE_SQL_ID AS OK
					FROM SY_SCM_ADM_EXCEL_COLUMNS A   WITH(NOLOCK)
					WHERE 1 = 1
					AND  A.PROGRAM_ID = @PROGRAM_ID
					AND  A.SHEET_NAME = @SHEET_NAME
				) Z
      )
      
      EXEC @v_sql '0', @USER_ID;
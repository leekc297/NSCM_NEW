SELECT COUNT(*) AS CNT
              FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
              WHERE  1 = 1
              AND    U.PROGRAM_ID = @p_program_id
              AND    U.SHEET_NAME = @p_sheet_name
              AND    U.USER_ID    = @p_user_id
              AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';
SELECT U.PROGRAM_ID
              , U.SHEET_NAME
              , U.COLUMN_NAME
              , C.COLUMN_LABEL_NAME
              , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
              , U.DATA_SORT_METHOD_CODE
              , C.SMALL_CLASS_LABEL_NAME
              , C.LARGE_CLASS_LABEL_NAME
              , '' AS DAY_CODE
              , C.FIXED_FLAG
              , C.COLUMN_WIDTH
              , C.CELL_CONTROL_OBJECT_TYPE_CODE
              , C.CELL_COMBO_DATA_TYPE
              , C.DATA_SCALE_NUMBER
              , C.DATA_MAX_LENGTH
              , C.HORIZONTAL_ALIGN_CODE
              , C.UPPERCASE_APPLY_FLAG
              , C.VISIBLE_FLAG
              , C.DEFAULT_FLAG
              , C.USER_SELECTABLE_FLAG
              , C.VALID_YN
              , C.ATTRIBUTE1
              , C.ATTRIBUTE2
              , C.ATTRIBUTE3
              , C.ATTRIBUTE4
              , C.ATTRIBUTE5
              , C.ATTRIBUTE6
              , C.ATTRIBUTE7
              , C.ATTRIBUTE8
              FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
              , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
              WHERE  1 = 1
              AND    U.PROGRAM_ID  = C.PROGRAM_ID
              AND    U.SHEET_NAME  = C.SHEET_NAME
              AND    U.COLUMN_NAME = C.COLUMN_NAME
              AND    C.VISIBLE_FLAG = 'Y'
              AND    C.VALID_YN     = 'Y'
              AND    U.PROGRAM_ID  = @p_program_id
              AND    U.SHEET_NAME  = @p_sheet_name
              AND    U.USER_ID     = @p_user_id
              AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
              UNION ALL
              SELECT C.PROGRAM_ID
              , C.SHEET_NAME
              , C.COLUMN_NAME
              , C.COLUMN_LABEL_NAME
              , C.SORT_ORDER_NO
              , C.DATA_SORT_METHOD_CODE
              , C.SMALL_CLASS_LABEL_NAME
              , C.LARGE_CLASS_LABEL_NAME
              , '' AS DAY_CODE
              , C.FIXED_FLAG
              , C.COLUMN_WIDTH
              , C.CELL_CONTROL_OBJECT_TYPE_CODE
              , C.CELL_COMBO_DATA_TYPE
              , C.DATA_SCALE_NUMBER
              , C.DATA_MAX_LENGTH
              , C.HORIZONTAL_ALIGN_CODE
              , C.UPPERCASE_APPLY_FLAG
              , C.VISIBLE_FLAG
              , C.DEFAULT_FLAG
              , C.USER_SELECTABLE_FLAG
              , C.VALID_YN
              , C.ATTRIBUTE1
              , C.ATTRIBUTE2
              , C.ATTRIBUTE3
              , C.ATTRIBUTE4
              , C.ATTRIBUTE5
              , C.ATTRIBUTE6
              , C.ATTRIBUTE7
              , C.ATTRIBUTE8
              FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
              WHERE  1 = 1
              AND    C.PROGRAM_ID  = @p_program_id
              AND    C.SHEET_NAME  = @p_sheet_name
              AND    (C.VISIBLE_FLAG = 'N' or
              (C.VISIBLE_FLAG = 'Y' and C.ATTRIBUTE6='N'))
              --AND     (C.DEFAULT_FLAG = '' or C.DEFAULT_FLAG is null or C.DEFAULT_FLAG = 'N')
              AND    C.VALID_YN     = 'Y'
              AND NOT EXISTS ( SELECT 1
              FROM SCM_MST_TITLESET_USER U
              WHERE U.PROGRAM_ID = C.PROGRAM_ID
              AND U.SHEET_NAME  = C.SHEET_NAME
              AND U.COLUMN_NAME = C.COLUMN_NAME
              AND U.USER_ID     = @p_user_id
              )
              ORDER BY SORT_ORDER_NO   ;
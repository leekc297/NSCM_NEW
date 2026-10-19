SELECT C.PROGRAM_ID
              , C.SHEET_NAME
              , C.COLUMN_NAME
              , C.COLUMN_LABEL_NAME
              , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
              AND    C.DEFAULT_FLAG = 'Y'
              AND    C.VISIBLE_FLAG = 'Y'
              AND    C.VALID_YN     = 'Y'

              UNION ALL

              SELECT C.PROGRAM_ID
              , C.SHEET_NAME
              , C.COLUMN_NAME
              , C.COLUMN_LABEL_NAME
              , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
              AND    C.VISIBLE_FLAG = 'N'
              AND    (C.DEFAULT_FLAG = '' or C.DEFAULT_FLAG is null or C.DEFAULT_FLAG = 'N')
              AND    C.VALID_YN     = 'Y'
              ORDER BY SORT_ORDER_NO   ;
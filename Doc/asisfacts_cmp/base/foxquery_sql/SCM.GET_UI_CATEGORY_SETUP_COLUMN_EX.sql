SELECT
              c.program_id
              ,c.sheet_name
              ,c.column_name
              ,c.column_label_name
              ,c.sort_order_no
              ,c.data_sort_method_code
              ,c.small_class_label_name
              ,c.large_class_label_name
              ,c.fixed_flag
              ,c.column_width
              ,c.cell_control_object_type_code
              ,c.CELL_COMBO_DATA_TYPE
              ,c.data_scale_number
              ,c.data_max_length
              ,c.horizontal_align_code
              ,c.uppercase_apply_flag
              ,c.visible_flag
              , case when default_flag= 'NLL' then 'NULL' else DEFAULT_FLAG end as default_flag
              , c.USER_SELECTABLE_FLAG
              , c.DIVISION_ID
              ,c.valid_yn
              ,c.created_by
              ,c.creation_date
              ,c.last_updated_by
              ,c.last_update_date
              ,c.ATTRIBUTE1
              ,c.ATTRIBUTE2
              ,c.ATTRIBUTE3
              ,c.ATTRIBUTE4
              ,c.ATTRIBUTE5
              ,c.ATTRIBUTE6
              ,c.ATTRIBUTE7
              ,c.ATTRIBUTE8
              ,c.ATTRIBUTE9
              FROM scm_mst_sheet_columns c
              WHERE 1=1
              AND (@p_program_id is null or c.program_id like '%'+ @p_program_id + '%' )
              AND (@p_sheet_name IS NULL OR c.sheet_name like '%'+ @p_sheet_name + '%' )
              AND (@p_column_name IS NULL OR c.column_name like '%'+ @p_column_name + '%' )
              AND (@p_colmum_lavel_name IS NULL OR c.column_label_name like '%'+ @p_colmum_lavel_name + '%' )
              --AND (C.DEFAULT_FLAG = @p_default_flag)
              AND (C.VALID_YN = @p_valid_yn)
              ORDER BY  c.program_id		,c.sheet_name		,c.sort_order_no
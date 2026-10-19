/****************************************************************************************************/
/* Program ID  : DMF0069_GET_SPREAD_TITLE                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/*  2023.11.22 kcw3408  [개발요청] 수요분석시스템_29_프로젝트별 고객수요분석 입력 여부 확인 가능한 현황판 및 알람 Init	*/
/* EXEC DMF0069_GET_SPREAD_TITLE '20230101', '20231231', 'chano0612', '81','DMF0069','Status List'  */
/****************************************************************************************************/


 
CREATE PROCEDURE [dbo].[DMF0069_GET_SPREAD_TITLE] 
	  @p_start_yyyymmdd NVARCHAR(8) 
	,@p_end_yyyymmdd    NVARCHAR(8)
	,@p_created_by	   NVARCHAR(50)
	,@p_division_id	   NVARCHAR(20)
	,@p_program_id	   NVARCHAR(MAX)
	,@p_sheet_name	   NVARCHAR(MAX)   
AS 

BEGIN 

    SET NOCOUNT ON;
    
	DECLARE @v_user_col_cnt   AS INT; 

	SET @v_user_col_cnt = 0;

	SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @p_program_id
    AND    U.SHEET_NAME = @p_sheet_name
    AND    U.USER_ID    = @p_created_by;


	IF @v_user_col_cnt > 0	   
	    BEGIN
		SELECT * FROM
		(
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
				, C.DIVISION_ID
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
				, [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = @p_program_id
		AND    U.SHEET_NAME  = @p_sheet_name
		AND    U.USER_ID     = @p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
		

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
				, C.DIVISION_ID
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG = ''
		AND    C.VALID_YN     = 'Y'
		AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
		) A ORDER BY A.SORT_ORDER_NO   
	      END;
	  ELSE
	      BEGIN		
			PRINT '2'
			SELECT * FROM (
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
					, C.DIVISION_ID
			FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
			WHERE  1 = 1    
			AND    C.PROGRAM_ID  = @p_program_id
			AND    C.SHEET_NAME  = @p_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가

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
					, C.DIVISION_ID
			FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
			WHERE  1 = 1    
			AND    C.PROGRAM_ID  = @p_program_id
			AND    C.SHEET_NAME  = @p_sheet_name
			AND    C.VISIBLE_FLAG = 'N'
			AND    C.DEFAULT_FLAG = ''			
			AND    C.VALID_YN     = 'Y'
			AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
			) A ORDER BY A.SORT_ORDER_NO   
		  END;
END


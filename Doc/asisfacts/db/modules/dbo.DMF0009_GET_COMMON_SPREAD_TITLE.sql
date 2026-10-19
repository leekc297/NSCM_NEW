

/*
 * Program ID   : DMF0009_GET_COMMON_SPREAD_TITLE
 * Description  : DMF0009_BizPlanPrice_Input(메탈 판가 기준등록 화면)의 스프레드 칼럼 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/24	ilovu1			Initial Release 사업계획 프로젝트
 */
CREATE PROCEDURE [dbo].[DMF0009_GET_COMMON_SPREAD_TITLE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50),
	@p_program_id	   NVARCHAR(MAX),
	@p_sheet_name	   NVARCHAR(MAX),
	@p_division_id		NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON;

	Declare @i_Count int=0;

	EXEC [dbo].[SCM0002_SET_DEFAULT_TITLESET_POPUP] @p_program_id , @p_sheet_name, 'C', @p_created_by

    SELECT  @i_Count = Count(*)
    FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
    WHERE  1 = 1
    AND    U.PROGRAM_ID  = @p_program_id
    AND    U.SHEET_NAME  = @p_sheet_name
    AND    U.USER_ID     = @p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';



	IF @i_Count = 0 
	BEGIN
			SELECT
			   C.PROGRAM_ID
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
			 , CASE C.VALID_YN	 WHEN 'Y' THEN -- 20180607 추가
					CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
				ELSE C.VALID_YN END VALID_YN
			 , C.DEFAULT_FLAG
			 , C.USER_SELECTABLE_FLAG
			 --, C.VALID_YN	
			 , 0 AS SEQ	 
			 FROM [SCM_MST_SHEET_COLUMNS] C  WITH(NOLOCK)
			 WHERE 1 = 1
				 AND    C.PROGRAM_ID  = @p_program_id
				 AND    C.SHEET_NAME  = @p_sheet_name	
				 AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
			ORDER BY SEQ, SORT_ORDER_NO;
	END
	ELSE --IF @i_Count <> 0 
	BEGIN
		SELECT C.PROGRAM_ID
			 , C.SHEET_NAME
			 , C.COLUMN_NAME
			 , C.COLUMN_LABEL_NAME
			 , C.SORT_ORDER_NO
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
			 --, C.VALID_YN
			 --, CASE C.VALID_YN	 
				--	WHEN 'Y' THEN
				--		CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) 
				--			WHEN 'Y' 
				--			THEN C.VISIBLE_FLAG 
				--			ELSE 'N' 
				--		END
				--	ELSE C.VALID_YN 
			 --  END VALID_YN
             , CASE
					WHEN C.VALID_YN = 'Y' AND dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) = 'Y' AND U.COLUMN_NAME IS NOT NULL 
					THEN 'Y'
					ELSE 'N'
			   END VALID_YN
			 , 1 AS SEQ
		FROM (SELECT * 
		        FROM [dbo].[SCM_MST_TITLESET_USER] WITH(NOLOCK) 
			   WHERE USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
			     AND USER_ID                       = @p_created_by
		     ) U
			 RIGHT JOIN [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
			         ON U.PROGRAM_ID  = C.PROGRAM_ID
                    AND U.SHEET_NAME  = C.SHEET_NAME
					AND U.COLUMN_NAME = C.COLUMN_NAME
		WHERE C.PROGRAM_ID   = @p_program_id
		  AND C.SHEET_NAME   = @p_sheet_name
		  AND C.VISIBLE_FLAG = 'Y'
		  AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가 
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
			 --, C.VALID_YN
			 , CASE C.VALID_YN	 WHEN 'Y' THEN -- 20180607 추가
					CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
				ELSE C.VALID_YN END VALID_YN
			 , 2 AS SEQ
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG = ''
		AND    C.VALID_YN     = 'Y'
		AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
		ORDER BY SORT_ORDER_NO;     
		
	END

END




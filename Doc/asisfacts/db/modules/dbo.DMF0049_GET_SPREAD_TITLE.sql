---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : DMF0049_GET_SPREAD_TITLE 
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/04/02	hwi1993		DMF0049_GET_SPREAD_TITLE
 * 2022/05/12	hwi1993		GM JV
 */
CREATE PROCEDURE [dbo].[DMF0049_GET_SPREAD_TITLE]
	@p_division_id			NVARCHAR(30),
	@p_created_by			NVARCHAR(50),
	@p_start_dt				NVARCHAR(8),
	@p_end_dt				NVARCHAR(8)

AS
BEGIN
	
    SET NOCOUNT ON;
    
	DECLARE @p_program_id	   NVARCHAR(50)
	DECLARE @p_sheet_name	   NVARCHAR(50)

	SET @p_program_id = 'DMF0049';
	SET @p_sheet_name = 'MDF Reports';

	SELECT C.PROGRAM_ID
		, C.SHEET_NAME
		, C.COLUMN_NAME
		, C.COLUMN_LABEL_NAME
		--, C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
		, CASE WHEN @P_DIVISION_ID = '40' THEN C.SORT_ORDER_NO
			   WHEN @P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE2
			   WHEN @P_DIVISION_ID = '82' THEN C.ATTRIBUTE3
			   END AS SORT_ORDER_NO
		, C.DATA_SORT_METHOD_CODE
		, C.SMALL_CLASS_LABEL_NAME
		, C.LARGE_CLASS_LABEL_NAME
		, '' AS DAY_CODE
		, C.FIXED_FLAG
		, CASE WHEN 
				CASE WHEN @P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
					 WHEN @P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE4
					 WHEN @P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
					 END = 'Y' 
					 THEN C.COLUMN_WIDTH
			ELSE 0 
			END AS COLUMN_WIDTH
		, C.CELL_CONTROL_OBJECT_TYPE_CODE
		, C.CELL_COMBO_DATA_TYPE
		, C.DATA_SCALE_NUMBER
		, C.DATA_MAX_LENGTH
		, C.HORIZONTAL_ALIGN_CODE
		, C.UPPERCASE_APPLY_FLAG
		, CASE  WHEN @P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
				WHEN @P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE4
				WHEN @P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
				END AS VISIBLE_FLAG
		, C.DEFAULT_FLAG
		, C.USER_SELECTABLE_FLAG
		, C.VALID_YN
		, C.DIVISION_ID
		, @p_division_id as ATTRIBUTE1		-- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
		, CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE C.ATTRIBUTE1 END AS ATTRIBUTE2
		, '' as ATTRIBUTE3
		, '' as ATTRIBUTE4
		, '' as ATTRIBUTE5
	FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
	WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		AND    C.VALID_YN     = 'Y'
		AND	   C.DIVISION_ID LIKE '%' + @P_DIVISION_ID + '%'
	UNION ALL

	SELECT 
		@p_program_id   AS PROGRAM_ID
		, @p_sheet_name AS SHEET_NAME
		, MA.COLUMN_NAME
		, MA.COLUMN_LABEL_NAME
		, MA.SORT_ORDER_NO
		, ''         AS DATA_SORT_METHOD_CODE
		, MA.SMALL_CLASS_LABEL_NAME
		, MA.LARGE_CLASS_LABEL_NAME
		, MA.DAY_CODE
		, ''         AS FIXED_FLAG
		, 120         AS COLUMN_WIDTH
		, MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		, ''         AS CELL_COMBO_DATA_TYPE
		--, '2'         AS DATA_SCALE_NUMBER
		, '3'         AS DATA_SCALE_NUMBER -- 20181029
		, '2'         AS DATA_MAX_LENGTH
		, 'R'        AS HORIZONTAL_ALIGN_CODE
		, ''        AS UPPERCASE_APPLY_FLAG
		, 'Y'        AS VISIBLE_FLAG
		, ''         AS DEFAULT_FLAG
		, ''         AS USER_SELECTABLE_FLAG
		, ''         AS VALID_YN
		, ''			AS DIVISION_ID
		, '' AS ATTRIBUTE1
		, '' AS ATTRIBUTE2
		, '' AS ATTRIBUTE3
		, '' AS ATTRIBUTE4
		, '' AS ATTRIBUTE5
	FROM  (
		SELECT 
			DISTINCT
			'M_' + BASIS_YYYYMM								AS COLUMN_NAME
			, MONTH_NAME										AS COLUMN_LABEL_NAME 
			, MONTH_NAME										AS SMALL_CLASS_LABEL_NAME
			, MONTH_NAME										AS LARGE_CLASS_LABEL_NAME
			, ''														AS DAY_CODE
			, BASIS_YYYYMM									AS SORT_ORDER_NO
			, 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
		FROM [dbo].[SCM_SYS_CALENDAR_M]
		WHERE  BASIS_YYYYMMDD >= @p_start_dt
			AND BASIS_YYYYMMDD <= @p_end_dt
	
	) MA

	ORDER BY SORT_ORDER_NO

END


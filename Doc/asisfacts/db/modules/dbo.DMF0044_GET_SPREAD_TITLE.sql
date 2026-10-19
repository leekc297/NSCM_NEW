
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*
 * Program ID   : DMF0044_GET_SPREAD_TITLE     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/05/15	JYE			DMF0044_GET_SPREAD_TITLE
 * 2020/10/06	hwi1993		C20201005-000291 Sales Report 대량변경. 소수점 자리수를 룩업에서 먼저 찾도록 함 ( 소형만 10자리 )
   2022.04.13   HWI1993     GM JV 작업
 */
CREATE PROCEDURE [dbo].[DMF0044_GET_SPREAD_TITLE]
	@p_division_id			NVARCHAR(30)='40',
	@p_created_by			NVARCHAR(50)='greenzun',
	@p_start_dt				NVARCHAR(8)='20190101',
	@p_end_dt				NVARCHAR(8)='20191231'

AS
BEGIN

	
    SET NOCOUNT ON;
    
	DECLARE @p_program_id	   NVARCHAR(50)
	DECLARE @p_sheet_name	   NVARCHAR(50)
	DECLARE @V_DATA_SCALE_NUMBER	NVARCHAR(2)

	SELECT @V_DATA_SCALE_NUMBER = SEGMENT3
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE = 'DMF0044_CONFIG'
		AND SEGMENT1 = @p_division_id
		AND SEGMENT2 = 'DIGIT_NUMBER'



	SET @p_program_id = 'DMF0044';
	SET @p_sheet_name = 'MDF Reports';

	SELECT C.PROGRAM_ID
		, C.SHEET_NAME
		, C.COLUMN_NAME
		, C.COLUMN_LABEL_NAME
		--, C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
		, CASE WHEN @P_DIVISION_ID = '40' THEN C.SORT_ORDER_NO
			   WHEN @P_DIVISION_ID like '81%' THEN C.ATTRIBUTE2
			   WHEN @P_DIVISION_ID = '82' THEN C.ATTRIBUTE3
			   END AS SORT_ORDER_NO
		, C.DATA_SORT_METHOD_CODE
		, C.SMALL_CLASS_LABEL_NAME
		, C.LARGE_CLASS_LABEL_NAME
		, '' AS DAY_CODE
		, C.FIXED_FLAG
		, CASE WHEN 
				CASE WHEN @P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
					 WHEN @P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
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
				WHEN @P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
				WHEN @P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
				END AS VISIBLE_FLAG
		, C.DEFAULT_FLAG
		, C.USER_SELECTABLE_FLAG
		, C.VALID_YN
		, C.DIVISION_ID
		, @p_division_id as ATTRIBUTE1		-- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
		, CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE C.ATTRIBUTE1 END AS ATTRIBUTE2
		, C.ATTRIBUTE3
		, C.ATTRIBUTE4
		, C.ATTRIBUTE5
	FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
	WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		AND    C.VALID_YN     = 'Y'
		--AND	   C.DIVISION_ID LIKE '%' + @P_DIVISION_ID + '%'
        AND	    @P_DIVISION_ID IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
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
		, CASE WHEN @V_DATA_SCALE_NUMBER IS NULL THEN 120 ELSE 200 END         AS COLUMN_WIDTH
		, MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		, ''         AS CELL_COMBO_DATA_TYPE
		--, '2'         AS DATA_SCALE_NUMBER
		, ISNULL(@V_DATA_SCALE_NUMBER, '3')         AS DATA_SCALE_NUMBER -- 20181029
		, '2'         AS DATA_MAX_LENGTH
		, 'R'        AS HORIZONTAL_ALIGN_CODE
		, ''        AS UPPERCASE_APPLY_FLAG
		, 'Y'        AS VISIBLE_FLAG
		, ''         AS DEFAULT_FLAG
		, ''     AS USER_SELECTABLE_FLAG
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

	/*
	
    SET NOCOUNT ON;
    
	DECLARE @p_program_id	   NVARCHAR(50)
	DECLARE @p_sheet_name	   NVARCHAR(50)

	SET @p_program_id = 'DMF0044';
	SET @p_sheet_name = 'MDF Reports';

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
		, C.ATTRIBUTE1
	FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
	WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		--AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
		--AND    C.COLUMN_NAME IN ('LAST_UPDATE_DATE', 'LAST_UPDATED_BY')
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
	*/

END





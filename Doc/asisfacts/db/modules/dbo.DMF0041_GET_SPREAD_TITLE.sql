
/****************************************************************************************************/
/* Program ID  : DMF0041_GET_SPREAD_TITLE                                                             */
/* Description :  MDF Simulator 칼럼 해더 데이터                                                             */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/02/14  JYE          MDF Simulator  */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0041_GET_SPREAD_TITLE]
	@p_division_id			NVARCHAR(20),
	@p_created_by			NVARCHAR(50),
	@p_start_dt				NVARCHAR(8),
	@p_end_dt				NVARCHAR(8)
AS
BEGIN
	
    SET NOCOUNT ON;
    
	DECLARE @p_program_id	   NVARCHAR(50)
	DECLARE @p_sheet_name	   NVARCHAR(50)

	SET @p_program_id = 'DMF0041';
	SET @p_sheet_name = 'MDFSimulator';

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


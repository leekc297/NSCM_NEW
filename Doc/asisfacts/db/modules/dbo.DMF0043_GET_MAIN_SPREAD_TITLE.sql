

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****************************************************************************************************/
/* Program ID  : [DMF0043_GET_SPREAD_TITLE]                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/06/20     JYE		기여율 해더                    */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0043_GET_MAIN_SPREAD_TITLE]
    @p_division_id		NVARCHAR(10),
	@p_yyyy				NVARCHAR(10),
	@p_created_by		NVARCHAR(50)
AS
BEGIN
	
    SET NOCOUNT ON;  

	DECLARE @v_program_id	   NVARCHAR(MAX) = 'DMF0043'
	DECLARE @v_sheet_name	   NVARCHAR(MAX) = 'ContributeMain'


	IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL 
		DROP TABLE #temp
	IF OBJECT_ID (N'tempdb..#temp2', N'U') IS NOT NULL 
		DROP TABLE #temp2

	DECLARE @CODEList NVARCHAR(1000)='';
	DECLARE @NAMEList NVARCHAR(1000)='';	
	DECLARE @nsql NVARCHAR(max)='';
	DECLARE @i INT = 0;
	DECLARE @v_user_col_cnt   AS INT = 0;

	-- ############### OS_CORP 반복 start ###############
	SELECT
		L.SEGMENT1  AS CODE
		, L.SEGMENT2  AS NAME
		, DISPLAY_SEQ AS DISPLAY_SEQ
	INTO #temp
	FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	WHERE  1 = 1
	AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
	AND    L.VALID_YN    = 'Y'
	AND    L.SEGMENT4 = 'N'
	ORDER BY DISPLAY_SEQ;	

	--INSERT #temp VALUES ('RBU_0099', N'구분', 99)

	SELECT -- 연도만
		@p_yyyy+ '  ' AS YYYYMM, 'Y' AS FLAG, CODE, NAME, DISPLAY_SEQ
	INTO #temp2
	FROM #temp
	--ORDER BY DISPLAY_SEQ;

	WHILE(@i < 12)	-- 연도 + 월
	BEGIN
		SET @i = @i + 1
		IF (LEN(@i) >= 2)
		BEGIN
			INSERT #temp2
			--SELECT @p_yyyy + '-' + CAST(@i AS VARCHAR) AS YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
			SELECT @p_yyyy + CAST(@i AS VARCHAR) AS YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
			FROM #temp
		END ELSE BEGIN
			INSERT #temp2
			SELECT @p_yyyy + '0' + CAST(@i AS VARCHAR) AS YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
			FROM #temp
		END;
	END;

	-- ############### OS_CORP 반복 end ###############

	SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @v_program_id
    AND    U.SHEET_NAME = @v_sheet_name
    AND    U.USER_ID    = @p_created_by;

	--select @v_user_col_cnt

	IF @v_user_col_cnt = 0	 
	BEGIN
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
				, C.DIVISION_ID
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @v_program_id
		AND    C.SHEET_NAME  = @v_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	

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
				, C.DIVISION_ID
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @v_program_id
		AND    C.SHEET_NAME  = @v_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG = ''			
		AND    C.VALID_YN     = 'Y'
		AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	

		UNION ALL

		SELECT @v_program_id   AS PROGRAM_ID
					, @v_sheet_name AS SHEET_NAME
					, T.FLAG + '#' + T.YYYYMM + '#' + CODE AS COLUMN_NAME
					, T.NAME AS COLUMN_LABEL_NAME
					, DISPLAY_SEQ AS SORT_ORDER_NO
					, '' AS DATA_SORT_METHOD_CODE
					--, T.YYYYMM AS SMALL_CLASS_LABEL_NAME
					, T.NAME AS SMALL_CLASS_LABEL_NAME
					, CASE WHEN LEN(T.YYYYMM) = 4 THEN T.YYYYMM ELSE 
						SUBSTRING(T.YYYYMM, 1, 4) + '-' + SUBSTRING(T.YYYYMM, 5, 2) END AS LARGE_CLASS_LABEL_NAME					
					--, @p_yyyy AS LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, ''         AS FIXED_FLAG
					, 80         AS COLUMN_WIDTH
					, '' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, '2'         AS DATA_SCALE_NUMBER
					, ''         AS DATA_MAX_LENGTH
					, 'R'        AS HORIZONTAL_ALIGN_CODE
					, 'Y'        AS UPPERCASE_APPLY_FLAG
					, 'Y'        AS VISIBLE_FLAG
					, ''         AS DEFAULT_FLAG
					, ''         AS USER_SELECTABLE_FLAG
					, ''         AS VALID_YN
					, ''			AS DIVISION_ID
			FROM  (
				SELECT 
					REPLACE(YYYYMM, ' ', '') AS YYYYMM, FLAG, CODE, NAME, 
					CAST(REPLACE(REPLACE(YYYYMM, ' ', ''), '-', '') AS VARCHAR) + CAST(DISPLAY_SEQ AS VARCHAR) AS DISPLAY_SEQ
				FROM #temp2
			) T
			ORDER BY SORT_ORDER_NO  ;
	END

	IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL 
		DROP TABLE #temp
	IF OBJECT_ID (N'tempdb..#temp2', N'U') IS NOT NULL 
		DROP TABLE #temp2

END




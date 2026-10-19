

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/****************************************************************************************************/
/* Program ID  : DMF0043_GET_SALES_LIST_SPREAD_TITLE                                                */
/* Description : 해외법인 기여매출 헤더                                                             */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/06/20     JSYOUN	[CSR ID:3948994] GSCM 해외법인기여율 화면 개발 요청의 건 - 기여매출 해더 */
/* 2019/12/12     HWI1993	합계컬럼 로직 추가 */
/* 2019/12/12     HWI1993	합계컬럼 로직 추가 */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0043_GET_SALES_LIST_SPREAD_TITLE]
    @p_division_id		NVARCHAR(10), 
	@p_created_by		NVARCHAR(50)
AS
BEGIN
	
    SET NOCOUNT ON;  

	DECLARE @v_program_id	   NVARCHAR(MAX) = 'DMF0043'
	DECLARE @v_sheet_name	   NVARCHAR(MAX) = 'ContributeSalesList'


	IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL 
		DROP TABLE #temp

	DECLARE @CODEList NVARCHAR(1000)='';
	DECLARE @NAMEList NVARCHAR(1000)='';	
	DECLARE @nsql NVARCHAR(max)='';
	DECLARE @i INT = 0;
	DECLARE @v_user_col_cnt   AS INT = 0;

	-- ############### OS_CORP 반복 start ###############
	/*
	SELECT
		  L.SEGMENT1 + '#' + M.SEGMENT1  AS CODE
		, L.SEGMENT2  AS NAME
		, L.SEGMENT2  AS LARGE_NAME
		, M.SEGMENT2  AS SMALL_NAME
		, 1000+L.DISPLAY_SEQ+M.DISPLAY_SEQ AS DISPLAY_SEQ
    INTO  #temp
	FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
        ,  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M  WITH(NOLOCK)
	WHERE  1 = 1
	AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
	AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
	AND    L.VALID_YN    = 'Y'
    AND    L.SEGMENT3    = 'Y'
    AND    M.VALID_YN    = 'Y'
	ORDER BY L.DISPLAY_SEQ, M.DISPLAY_SEQ
	;
	*/
	SELECT DISTINCT
		  L.SEGMENT1 + '#' + CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE
		, L.SEGMENT2  AS NAME
		, L.SEGMENT2  AS LARGE_NAME
		, CASE WHEN L.SEGMENT4 = 'Y' THEN L.SEGMENT1 ELSE M.SEGMENT2 END AS SMALL_NAME
		, 1000+L.DISPLAY_SEQ + CASE WHEN L.SEGMENT4 = 'Y' THEN '0' ELSE M.DISPLAY_SEQ END AS DISPLAY_SEQ
	INTO  #temp
	FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
        ,  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M  WITH(NOLOCK)
	WHERE  1 = 1
	AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
	AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
	AND    L.VALID_YN    = 'Y'
    AND    L.SEGMENT3    = 'Y'
    AND    M.VALID_YN    = 'Y'
	--AND	   L.SEGMENT4	 = 'N'
    ;

	-- ############### OS_CORP 반복 end ###############

	SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @v_program_id
    AND    U.SHEET_NAME = @v_sheet_name
    AND    U.USER_ID    = @p_created_by;

	--select @v_user_col_cnt

	IF @v_user_col_cnt > 0
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
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
				,[dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = @v_program_id
		AND    U.SHEET_NAME  = @v_sheet_name
		AND    U.USER_ID     = @p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
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
					, CODE AS COLUMN_NAME
					, T.NAME AS COLUMN_LABEL_NAME
					, DISPLAY_SEQ AS SORT_ORDER_NO
					, '' AS DATA_SORT_METHOD_CODE
					--, T.YYYYMM AS SMALL_CLASS_LABEL_NAME
					, T.SMALL_NAME AS SMALL_CLASS_LABEL_NAME
					, T.LARGE_NAME AS LARGE_CLASS_LABEL_NAME					
					--, @p_yyyy AS LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, ''         AS FIXED_FLAG
					, 80         AS COLUMN_WIDTH
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, ''         AS DATA_SCALE_NUMBER
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
					CODE, NAME, LARGE_NAME, SMALL_NAME, DISPLAY_SEQ
				FROM #temp
			) T
			ORDER BY SORT_ORDER_NO  ;
    END
    
    ELSE	 

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
					, CODE AS COLUMN_NAME
					, T.NAME AS COLUMN_LABEL_NAME
					, DISPLAY_SEQ AS SORT_ORDER_NO
					, '' AS DATA_SORT_METHOD_CODE
					--, T.YYYYMM AS SMALL_CLASS_LABEL_NAME
					, T.SMALL_NAME AS SMALL_CLASS_LABEL_NAME
					, T.LARGE_NAME AS LARGE_CLASS_LABEL_NAME					
					--, @p_yyyy AS LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, ''         AS FIXED_FLAG
					, 80         AS COLUMN_WIDTH
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, ''         AS DATA_SCALE_NUMBER
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
					CODE, NAME, LARGE_NAME, SMALL_NAME, DISPLAY_SEQ
				FROM #temp
			) T
			ORDER BY SORT_ORDER_NO  ;
	END

	IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL 
		DROP TABLE #temp

END





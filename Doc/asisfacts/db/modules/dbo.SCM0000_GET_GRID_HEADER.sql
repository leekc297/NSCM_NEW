
/****************************************************************************************************/
/* Program ID  : SCM0000_GET_GRID_HEADER                                                            */
/* Description : UI Grid Header를 가져오는 프로시저                                                 */
/* Usage       :								                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2025.02.20  park.choyi	Initial Release															*/
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/


CREATE PROCEDURE [dbo].[SCM0000_GET_GRID_HEADER]
	@p_program_id		NVARCHAR(20),
	@p_sheet_name		NVARCHAR(150),
	@p_user_id			NVARCHAR(150),
	@p_division_id		NVARCHAR(30),
    @p_start_yyyymmdd	NVARCHAR(8),
    @p_end_yyyymmdd		NVARCHAR(8)
AS
BEGIN
	
    SET NOCOUNT ON;
    
	DECLARE @v_user_col_cnt		AS INT;
	DECLARE @v_sheet_name		NVARCHAR(150)	= @p_sheet_name + IIF(ISNULL(@p_division_id, '') = '', '', '-' + @p_division_id);

	SET @v_user_col_cnt = 0;

	SELECT @v_user_col_cnt = COUNT(*)
    FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
         , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
    WHERE  1 = 1
    AND    U.PROGRAM_ID  = C.PROGRAM_ID
    AND    U.SHEET_NAME  = C.SHEET_NAME
    AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = @p_program_id
    AND    U.SHEET_NAME  = @p_sheet_name
    AND    U.USER_ID     = @p_user_id
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	AND    C.VALID_YN	 = 'Y'
	;

	IF (@v_user_col_cnt > 0	)
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO
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
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			 , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    C.VALID_YN     = 'Y'				
		AND   (
				(C.VISIBLE_FLAG = 'Y' AND C.DEFAULT_FLAG = 'Y')
				OR 
				(C.VISIBLE_FLAG = 'N' AND ISNULL(C.DEFAULT_FLAG, 'N') IN ('', 'N'))
		      )
		AND    U.PROGRAM_ID  = @p_program_id
		AND    U.SHEET_NAME  = @v_sheet_name
		AND    U.USER_ID     = @p_user_id
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'    

		
		UNION ALL

		SELECT @p_program_id   AS PROGRAM_ID
				, @v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, 50         AS COLUMN_WIDTH
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
				, ''         AS ATTRIBUTE1
				, ''         AS ATTRIBUTE2
				, ''         AS ATTRIBUTE3
				, ''         AS ATTRIBUTE4
				, ''         AS ATTRIBUTE5
		FROM  (
				SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
					, CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
					WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
					ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
					, A.DAYOFWEEK               AS DAY_CODE
					, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.basis_yyyymmdd <= @p_end_yyyymmdd
				UNION ALL
				SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
					, CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
					WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
					ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
				, CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
					WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
					ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
					, ''                   AS DAY_CODE
					, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK 
						, A.WEEK_NAME
						, PARTIAL_WEEK_NAME
						, A.MONTH_NAME        
						, A.BASIS_START_DATE
				UNION ALL
				SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
				FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME
			) T



		ORDER BY SORT_ORDER_NO

	  ELSE
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
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @v_sheet_name
		AND    C.VALID_YN     = 'Y'			
		AND   (
				(C.VISIBLE_FLAG = 'Y' AND C.DEFAULT_FLAG = 'Y')
				OR 
				(C.VISIBLE_FLAG = 'N' AND ISNULL(C.DEFAULT_FLAG, 'N') IN ('', 'N'))
		      )

		UNION ALL

		SELECT @p_program_id   AS PROGRAM_ID
				, @v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, 50         AS COLUMN_WIDTH
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
				, ''         AS ATTRIBUTE1
				, ''         AS ATTRIBUTE2
				, ''         AS ATTRIBUTE3
				, ''         AS ATTRIBUTE4
				, ''         AS ATTRIBUTE5
		FROM  (
				SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
					, CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
					WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
					ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
					, A.DAYOFWEEK               AS DAY_CODE
					, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.basis_yyyymmdd <= @p_end_yyyymmdd
				UNION ALL
				SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
					, CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
					WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
					ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
				, CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
					WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
					ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
					, ''                   AS DAY_CODE
					, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK 
						, A.WEEK_NAME
						, PARTIAL_WEEK_NAME
						, A.MONTH_NAME        
						, A.BASIS_START_DATE
				UNION ALL
				SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
				FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME
			) T


		ORDER BY SORT_ORDER_NO   
	

END



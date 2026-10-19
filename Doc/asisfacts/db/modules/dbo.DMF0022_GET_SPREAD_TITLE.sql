---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************/
/* Program ID  : DMF0022_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/02/05  pjs       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 20180618		JYE	 Div별로 연동                                                                */
/* 2018/10/26     JYE				스프레드 해더 칼럼 통합(일반 데이터 + 날짜데이터)                    */
/* 2021/11/15	rosia27		[PJ20209643] SALES PLAN WATERFALL 속도개선								*/
/* 2022.07.19	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 *
 */
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
CREATE PROCEDURE [dbo].[DMF0022_GET_SPREAD_TITLE]
    @p_start_yyyymmdd	NVARCHAR(8),
    @p_end_yyyymmdd		NVARCHAR(8),
	@p_created_by			NVARCHAR(50),
	@p_division_id			NVARCHAR(50),
	@p_bucket				NVARCHAR(20)
AS
BEGIN
	
    SET NOCOUNT ON;

	Declare @i_Count int=0;
	Declare @v_program_id	    NVARCHAR(50)='DMF0022'
	Declare @v_sheet_name		NVARCHAR(50)='Sales Plan Waterfall'

    SELECT  @i_Count = Count(*)
    FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
    --     , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
    WHERE  1 = 1
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID
    --AND    U.SHEET_NAME  = C.SHEET_NAME
    --AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = @v_program_id
    AND    U.SHEET_NAME  = @v_sheet_name
    AND    U.USER_ID     = @p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'

	

	IF @i_Count > 0	   
	    BEGIN
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
		AND    U.PROGRAM_ID  = @v_program_id
		AND    U.SHEET_NAME  = @v_sheet_name
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
		AND    C.PROGRAM_ID  = @v_program_id
		AND    C.SHEET_NAME  = @v_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG = ''
		AND    C.VALID_YN     = 'Y'
		AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가

		UNION ALL

		SELECT @v_program_id   AS PROGRAM_ID
				, @v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, CASE	WHEN @p_bucket = 'ONLY_WEEKLY' THEN 100 
						ELSE	50 END	AS COLUMN_WIDTH
				, T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				, ''         AS CELL_COMBO_DATA_TYPE
				, '3'         AS DATA_SCALE_NUMBER
				, ''         AS DATA_MAX_LENGTH
				, 'R'        AS HORIZONTAL_ALIGN_CODE
				, 'Y'        AS UPPERCASE_APPLY_FLAG
				, 'Y'        AS VISIBLE_FLAG
				, ''         AS DEFAULT_FLAG
				, ''         AS USER_SELECTABLE_FLAG
				, ''         AS VALID_YN
				, ''			AS DIVISION_ID
		FROM  (
				SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
					, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
					, A.DAYOFWEEK               AS DAY_CODE
					, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.basis_yyyymmdd <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				AND    1 = CASE WHEN @p_bucket = 'DAILY' THEN '1' ELSE '2' END
				/*UNION ALL
				SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
					, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
					, ''                        AS DAY_CODE
					, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 32) AS SORT_ORDER_NO
					, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)*/  
				UNION ALL
				SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
					, A.WEEK_NAME          AS COLUMN_LABEL_NAME   
					, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
					, ''                   AS DAY_CODE
					, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				AND    1 = CASE WHEN @p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK 
						, A.WEEK_NAME
						, A.MONTH_NAME        
						, A.BASIS_START_DATE
				/*UNION ALL
				SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
					, A.WEEK_NAME           AS COLUMN_LABEL_NAME   
					, A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME       AS LARGE_CLASS_LABEL_NAME 
					, ''                    AS DAY_CODE
					, A.BASIS_START_DATE + CONVERT(CHAR(2), 22) AS SORT_ORDER_NO
					, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK  
						, A.WEEK_NAME
						, A.MONTH_NAME        
						, A.BASIS_START_DATE*/
				UNION ALL
				SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
						, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				AND    1 = CASE WHEN @p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME		
				/*UNION ALL
				SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME           AS COLUMN_LABEL
						, A.MONTH_NAME           AS SMALL_LABEL_NAME
						, A.MONTH_NAME           AS LARGE_LABEL_NAME
						, ''                     AS DAY_CODE
						, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), 11) AS SORT_ORDER_NO
						, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME	 */
				--ORDER BY sort_order_no  
				-- 2022.07.19	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
				UNION ALL
				SELECT 'W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK
					, WEEK_NAME as COLUMN_LABEL_NAME
					, WEEK_NAME as SMALL_CLASS_LABEL_NAME
					, SUBSTRING(MIN(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MIN(BASIS_YYYYMMDD), 7, 2)
						+ ' ~ ' + SUBSTRING(MAX(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MAX(BASIS_YYYYMMDD), 7, 2)
						, ''                   AS DAY_CODE
					, MAX(BASIS_YYYYMMDD)+ CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd
				AND    1 = CASE WHEN @p_bucket = 'ONLY_WEEKLY' THEN '1' ELSE '2' END
				GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME

			) T
		  ORDER BY SORT_ORDER_NO   ;
		  print '-------------'+ @p_bucket;
	      END;
	  ELSE
	      BEGIN		
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
			AND    C.PROGRAM_ID  = @v_program_id
			AND    C.SHEET_NAME  = @v_sheet_name
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
			AND    C.PROGRAM_ID  = @v_program_id
			AND    C.SHEET_NAME  = @v_sheet_name
			AND    C.VISIBLE_FLAG = 'N'
			AND    C.DEFAULT_FLAG = ''			
			AND    C.VALID_YN     = 'Y'
			AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가

			UNION ALL

			SELECT @v_program_id   AS PROGRAM_ID
					, @v_sheet_name AS SHEET_NAME
					, T.COLUMN_NAME
					, T.COLUMN_LABEL_NAME
					, T.SORT_ORDER_NO
					, ''         AS DATA_SORT_METHOD_CODE
					, T.SMALL_CLASS_LABEL_NAME
					, T.LARGE_CLASS_LABEL_NAME
					, T.DAY_CODE
					, ''         AS FIXED_FLAG
					, CASE	WHEN @p_bucket = 'ONLY_WEEKLY' THEN 100 
							ELSE	50 END	AS COLUMN_WIDTH
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, '3'         AS DATA_SCALE_NUMBER
					, ''         AS DATA_MAX_LENGTH
					, 'R'        AS HORIZONTAL_ALIGN_CODE
					, 'Y'        AS UPPERCASE_APPLY_FLAG
					, 'Y'        AS VISIBLE_FLAG
					, ''         AS DEFAULT_FLAG
					, ''         AS USER_SELECTABLE_FLAG
					, ''         AS VALID_YN
					, ''			AS DIVISION_ID
			FROM  (
					SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
						, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
						, A.DAYOFWEEK               AS DAY_CODE
						, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
					FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
					WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
					AND    A.basis_yyyymmdd <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
					AND    1 = CASE WHEN @p_bucket = 'DAILY' THEN '1' ELSE '2' END
					/*UNION ALL
					SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
						, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
						, ''                        AS DAY_CODE
						, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 32) AS SORT_ORDER_NO
					FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
					WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
					AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)  */
					UNION ALL
					SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
						, A.WEEK_NAME          AS COLUMN_LABEL_NAME   
						, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
						, ''                   AS DAY_CODE
						, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
					FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
					WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
					AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
					AND    1 = CASE WHEN @p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK 
							, A.WEEK_NAME
							, A.MONTH_NAME        
							, A.BASIS_START_DATE
					/*UNION ALL
					SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
						, A.WEEK_NAME           AS COLUMN_LABEL_NAME   
						, A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME 
						, ''                    AS DAY_CODE
						, A.BASIS_START_DATE + CONVERT(CHAR(2), 22) AS SORT_ORDER_NO
					FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
					WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
					AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK  
							, A.WEEK_NAME
							, A.MONTH_NAME        
							, A.BASIS_START_DATE*/
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
					AND    1 = CASE WHEN @p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME		
					/*UNION ALL
					SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
							, A.MONTH_NAME           AS COLUMN_LABEL
							, A.MONTH_NAME           AS SMALL_LABEL_NAME
							, A.MONTH_NAME           AS LARGE_LABEL_NAME
							, ''                     AS DAY_CODE
							, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), 11) AS SORT_ORDER_NO
					FROM    [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
					WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
					AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME	 */
					--ORDER BY sort_order_no  
					-- 2022.07.19	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
					UNION ALL
					SELECT 'W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK
						, WEEK_NAME as COLUMN_LABEL_NAME
						, WEEK_NAME as SMALL_CLASS_LABEL_NAME
						, SUBSTRING(MIN(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MIN(BASIS_YYYYMMDD), 7, 2)
							+ ' ~ ' + SUBSTRING(MAX(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MAX(BASIS_YYYYMMDD), 7, 2)
							, ''                   AS DAY_CODE
						, MAX(BASIS_YYYYMMDD)+ CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
						-- , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
					WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd
					AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd
					AND    1 = CASE WHEN @p_bucket = 'ONLY_WEEKLY' THEN '1' ELSE '2' END
					GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
				) T
			  ORDER BY SORT_ORDER_NO   ;
		  END;

END

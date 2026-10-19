/****************************************************************************************************/
/* Program ID  : DMF0053_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2023/03/26  chano0612    Initial Release [] EDI 기준정보 정비 프로세스 구축 및 신규화면 개발 프로젝트 */

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

-- EXEC DMF0035_GET_SPREAD_TITLE '20230301', '20230801', 'chano0612', '40', 'MONTHLY'
-- EXEC DMF0053_GET_SPREAD_TITLE '20230301', '20230801', 'chano0612', '40', 'MONTHLY'

CREATE PROCEDURE [dbo].[DMF0053_GET_SPREAD_TITLE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50),
	@p_division_id	   NVARCHAR(20),
	@p_bucket		   NVARCHAR(20)
AS
BEGIN
	
    SET NOCOUNT ON;
    
	DECLARE @v_user_col_cnt   AS INT;
	DECLARE @p_program_id	   NVARCHAR(50)
	DECLARE @p_sheet_name	   NVARCHAR(50)

	SET @v_user_col_cnt = 0;
	SET @p_program_id = 'DMF0053';
	SET @p_sheet_name = 'CUST Fcst Waterfall';

	SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @p_program_id
    AND    U.SHEET_NAME = @p_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = @p_created_by;

	IF @v_user_col_cnt > 0	   
	    BEGIN
		SELECT * FROM (
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
					AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
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
					AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
					UNION ALL

					SELECT @p_program_id   AS PROGRAM_ID
						 , @p_sheet_name AS SHEET_NAME
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
						 , ''         AS DATA_SCALE_NUMBER
						 , ''         AS DATA_MAX_LENGTH
						 , 'R'        AS HORIZONTAL_ALIGN_CODE
						 , 'Y'        AS UPPERCASE_APPLY_FLAG
						 , 'Y'        AS VISIBLE_FLAG
						 , ''         AS DEFAULT_FLAG
						 , ''         AS USER_SELECTABLE_FLAG
						 , ''         AS VALID_YN
						 --, CASE WHEN CHARINDEX('81', @p_divisIon_id) > 0 OR CHARINDEX('82', @p_divisIon_id) > 0 THEN
						--	CASE WHEN CHARINDEX('40', @p_divisIon_id) > 0 THEN '40,81,82'
						--		 ELSE '81,82' END
					 --  ELSE 
						--	'40'
					 --  END AS DIVISION_ID
					 , @p_division_id		-- 20190201
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
						   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)
						   UNION ALL  
						   SELECT 'W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK AS  COLUMN_NAME
								 , WEEK_NAME AS COLUMN_LABEL_NAME  
								 , WEEK_NAME AS SMALL_CLASS_LABEL_NAME  
								 , SUBSTRING(MIN(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MIN(BASIS_YYYYMMDD), 7, 2)  
								 + ' ~ ' + SUBSTRING(MAX(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MAX(BASIS_YYYYMMDD), 7, 2)  AS LARGE_CLASS_LABEL_NAME
								 , ''                   AS DAY_CODE  
								 , MAX(BASIS_YYYYMMDD)+ CONVERT(CHAR(2), 21) AS SORT_ORDER_NO  
						   FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)   
						   WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd  
						   AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd  
						   AND    1 = CASE WHEN @p_bucket = 'ONLY_WEEKLY' THEN '1' ELSE '2' END  
						   GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME  	  
												) T
				) A
				WHERE @p_division_id IN (SELECT token FROM dbo.String_Split(A.DIVISION_ID ,','))
				ORDER BY SORT_ORDER_NO ;
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
			AND    C.PROGRAM_ID  = @p_program_id
			AND    C.SHEET_NAME  = @p_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
			UNION ALL
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
				AND    C.VISIBLE_FLAG = 'N'
				AND    C.DEFAULT_FLAG = ''			
				AND    C.VALID_YN     = 'Y'
				AND	 @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
				UNION ALL

				SELECT @p_program_id   AS PROGRAM_ID
					 , @p_sheet_name AS SHEET_NAME
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
					 , ''         AS DATA_SCALE_NUMBER
					 , ''         AS DATA_MAX_LENGTH
					 , 'R'        AS HORIZONTAL_ALIGN_CODE
					 , 'Y'        AS UPPERCASE_APPLY_FLAG
					 , 'Y'        AS VISIBLE_FLAG
					 , ''         AS DEFAULT_FLAG
					 , ''         AS USER_SELECTABLE_FLAG
					 , ''         AS VALID_YN
					 --, CASE WHEN CHARINDEX('81', @p_divisIon_id) > 0 OR CHARINDEX('82', @p_divisIon_id) > 0 THEN
						--	CASE WHEN CHARINDEX('40', @p_divisIon_id) > 0 THEN '40,81,82'
						--		 ELSE '81,82' END
					 --  ELSE 
						--	'40'
					 --  END AS DIVISION_ID
					 , @p_division_id		-- 20190201
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
					   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)	  
					   UNION ALL  
					   SELECT 'W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK  AS COLUMN_NAME
						    , WEEK_NAME AS COLUMN_LABEL_NAME  
						    , WEEK_NAME AS SMALL_CLASS_LABEL_NAME  
						    , SUBSTRING(MIN(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MIN(BASIS_YYYYMMDD), 7, 2)  
						     + ' ~ ' + SUBSTRING(MAX(BASIS_YYYYMMDD), 5, 2) + '.' + SUBSTRING(MAX(BASIS_YYYYMMDD), 7, 2)  AS LARGE_CLASS_LABEL_NAME
						     , ''                   AS DAY_CODE  
						    , MAX(BASIS_YYYYMMDD)+ CONVERT(CHAR(2), 21) AS SORT_ORDER_NO  
					    -- , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE  
					   FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)   
					   WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd  
					   AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd  
					   AND    1 = CASE WHEN @p_bucket = 'ONLY_WEEKLY' THEN '1' ELSE '2' END  
					   GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME    
					) T
				) A
				WHERE @p_division_id IN (SELECT token FROM dbo.String_Split(A.DIVISION_ID ,','))
			  ORDER BY SORT_ORDER_NO   ;
				  
        END;
END


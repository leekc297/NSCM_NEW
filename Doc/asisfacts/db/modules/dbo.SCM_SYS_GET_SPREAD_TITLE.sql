
/****************************************************************************************************/
/* Program ID  : SCM_SYS_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/05/21  hwwoon       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/06/18  hwwoon       유저컬럼 조회조건 수정													*/
/* 2024/11/06  jahn1502     화면 UI 컬럼 0처리로 인해 'SCP0104','SCP0105','SCP0106','SCP0107','SCP0108' 화면 별도 설정*/
/* 2024/11/26  jahn1502     PJ20239037 LGES CPS VOE 반영 및 고도화 AND COLUMN_WIDTH <> 0 조건 추가 */
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


CREATE PROCEDURE [dbo].[SCM_SYS_GET_SPREAD_TITLE]
	@p_program_id nvarchar(max),
	@p_user_id nvarchar(max),
	@p_sheet_name nvarchar(max)
AS
BEGIN
	
    SET NOCOUNT ON;
    
	DECLARE @v_user_col_cnt   AS INT;

	SET @v_user_col_cnt = 0;

	--IF OBJECT_ID('tempdb..#tblWidth_ColumnTable') IS NOT NULL
	--	DROP TABLE #tblWidth_ColumnTable;
	--IF OBJECT_ID('tempdb..#tblZero_ColumnTable') IS NOT NULL
	--	DROP TABLE #tblZero_ColumnTable;
	--IF OBJECT_ID('tempdb..#tblZero_ColumnTable05') IS NOT NULL
	--	DROP TABLE #tblZero_ColumnTable05;

	SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @p_program_id
    AND    U.SHEET_NAME = @p_sheet_name
    AND    U.USER_ID    = @p_user_id
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

	IF (@v_user_col_cnt > 0	 and @p_program_id not in ('SCP0104','SCP0105','SCP0106','SCP0107','SCP0108'))
	    BEGIN
		SELECT * 
		FROM (
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
			AND    C.VISIBLE_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'		
			AND    U.PROGRAM_ID  = @p_program_id
			AND    U.SHEET_NAME  = @p_sheet_name
			AND    U.USER_ID     = @p_user_id
			AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'    
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
				 , C.ATTRIBUTE1
				 , C.ATTRIBUTE2
				 , C.ATTRIBUTE3
				 , C.ATTRIBUTE4
				 , C.ATTRIBUTE5
			FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
			WHERE  1 = 1    
			AND    C.PROGRAM_ID  = @p_program_id
			AND    C.SHEET_NAME  = @p_sheet_name
			AND    (C.VISIBLE_FLAG = 'N' or 
					(C.VISIBLE_FLAG = 'Y' and C.ATTRIBUTE6='N'))
			--AND     (C.DEFAULT_FLAG = '' or C.DEFAULT_FLAG is null or C.DEFAULT_FLAG = 'N')
			AND    C.VALID_YN     = 'Y'		
			AND NOT EXISTS ( SELECT 1 
							   FROM SCM_MST_TITLESET_USER U
							  WHERE U.PROGRAM_ID = C.PROGRAM_ID
								AND U.SHEET_NAME  = C.SHEET_NAME
								AND U.COLUMN_NAME = C.COLUMN_NAME
								AND U.USER_ID     = @p_user_id
							)
			)A ORDER BY SORT_ORDER_NO ASC
		END;
	ELSE IF (@v_user_col_cnt > 0 and @p_program_id in ('SCP0104','SCP0105','SCP0106','SCP0107','SCP0108')) --jahn1502 추가
		BEGIN
		SELECT *
		--INTO #tblWidth_ColumnTable
		FROM (
			SELECT *
			FROM (
					SELECT U.PROGRAM_ID
							, U.SHEET_NAME
							, U.COLUMN_NAME
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
							, C.VALID_YN
							, C.ATTRIBUTE1
							, C.ATTRIBUTE2
							, CASE WHEN U.ATTRIBUTE3 = 'N' THEN 'N' ELSE 'Y' END AS ATTRIBUTE3
							, C.ATTRIBUTE4
							, C.ATTRIBUTE5
					FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
						 , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
					WHERE  1 = 1								
					AND    U.PROGRAM_ID  = C.PROGRAM_ID
					AND    U.SHEET_NAME  = C.SHEET_NAME
					AND    U.COLUMN_NAME = C.COLUMN_NAME
					AND    C.VISIBLE_FLAG = 'Y'
					AND    C.VALID_YN     = 'Y'		
					AND    U.PROGRAM_ID  = @p_program_id
					AND    U.SHEET_NAME  = @p_sheet_name
					AND    U.USER_ID     = @p_user_id
					AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
					) B WHERE B.ATTRIBUTE3 <> 'N'
					AND COLUMN_WIDTH <> 0
				UNION ALL
				SELECT B.PROGRAM_ID
					 , B.SHEET_NAME
					 , B.COLUMN_NAME
					 , B.COLUMN_LABEL_NAME
					 , B.SORT_ORDER_NO
					 , B.DATA_SORT_METHOD_CODE
					 , B.SMALL_CLASS_LABEL_NAME
					 , B.LARGE_CLASS_LABEL_NAME
					 , '' AS DAY_CODE
					 , B.FIXED_FLAG				 
					 , 0 AS COLUMN_WIDTH
					 , B.CELL_CONTROL_OBJECT_TYPE_CODE
					 , B.CELL_COMBO_DATA_TYPE
					 , B.DATA_SCALE_NUMBER
					 , B.DATA_MAX_LENGTH
					 , B.HORIZONTAL_ALIGN_CODE
					 , B.UPPERCASE_APPLY_FLAG
					 , B.VISIBLE_FLAG
					 , B.DEFAULT_FLAG
					 , B.USER_SELECTABLE_FLAG
					 , B.VALID_YN
					 , B.ATTRIBUTE1
					 , B.ATTRIBUTE2
					 , U.ATTRIBUTE3
					 , B.ATTRIBUTE4
					 , B.ATTRIBUTE5
  				 FROM SCM_MST_SHEET_COLUMNS B  WITH(NOLOCK) LEFT OUTER JOIN SCM_MST_TITLESET_USER U  WITH(NOLOCK) ON U.PROGRAM_ID = B.PROGRAM_ID AND U.SHEET_NAME = B.SHEET_NAME 
				  AND U.COLUMN_NAME = B.COLUMN_NAME AND U.USER_ID = @P_USER_ID
				WHERE   B.PROGRAM_ID             = @P_PROGRAM_ID
				  AND   B.SHEET_NAME             = @P_SHEET_NAME
				  AND   B.VALID_YN				 = 'Y'
				  AND   (U.ATTRIBUTE3 = 'N' OR COLUMN_WIDTH = 0)
				  --AND   B.COLUMN_NAME NOT IN (
						--						SELECT COLUMN_NAME
						--							FROM (
						--									SELECT U.COLUMN_NAME
						--									FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
						--											, [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
						--									WHERE  1 = 1								
						--									AND    U.PROGRAM_ID  = C.PROGRAM_ID
						--									AND    U.SHEET_NAME  = C.SHEET_NAME
						--									AND    U.COLUMN_NAME = C.COLUMN_NAME
						--									AND    C.VISIBLE_FLAG = 'Y'
						--									AND    C.VALID_YN     = 'Y'		
						--									AND    U.PROGRAM_ID  = @p_program_id
						--									AND    U.SHEET_NAME  = @p_sheet_name
						--									AND    U.USER_ID     = @p_user_id
						--									AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
						--									) B )
				  --AND   U.ATTRIBUTE3 = 'N'
				  --AND   B.COLUMN_WIDTH           <> 0
			) A ORDER BY SORT_ORDER_NO ASC

/*			IF (@p_program_id = 'SCP0104') --예외 DUMMY_YN 필수 컬럼이지만 0으로 설정되어 있음.
				BEGIN
				SELECT 1
				
					SELECT *
					INTO #tblZero_ColumnTable
					FROM #tblWidth_ColumnTable
					WHERE 1<>1

					INSERT INTO #tblZero_ColumnTable
					SELECT PROGRAM_ID
						 , SHEET_NAME
						 , COLUMN_NAME
						 , COLUMN_LABEL_NAME
						 , SORT_ORDER_NO
						 , DATA_SORT_METHOD_CODE
						 , SMALL_CLASS_LABEL_NAME
						 , LARGE_CLASS_LABEL_NAME
						 , '' AS DAY_CODE
						 , FIXED_FLAG				 
						 , 0 AS COLUMN_WIDTH
						 , CELL_CONTROL_OBJECT_TYPE_CODE
						 , CELL_COMBO_DATA_TYPE
						 , DATA_SCALE_NUMBER
						 , DATA_MAX_LENGTH
						 , HORIZONTAL_ALIGN_CODE
						 , UPPERCASE_APPLY_FLAG
						 , VISIBLE_FLAG
						 , DEFAULT_FLAG
						 , USER_SELECTABLE_FLAG
						 , VALID_YN
						 , ATTRIBUTE1
						 , ATTRIBUTE2
						 , ATTRIBUTE3
						 , ATTRIBUTE4
						 , ATTRIBUTE5
					  FROM SCM_MST_SHEET_COLUMNS 
					 WHERE 1=1
					   AND PROGRAM_ID             = @P_PROGRAM_ID
					   AND SHEET_NAME             = @P_SHEET_NAME
					   AND COLUMN_NAME            = 'DUMMY_YN'
		
					SELECT *
					FROM (
							SELECT *
							FROM #tblWidth_ColumnTable
							UNION ALL
							SELECT *
							FROM #tblZero_ColumnTable
						) A
						ORDER BY SORT_ORDER_NO

				END */
/*			 IF (@p_program_id = 'SCP0105') --예외 DUMMY_YN 필수 컬럼이지만 0으로 설정되어 있음.
				BEGIN

					SELECT *
					INTO #tblZero_ColumnTable05
					FROM #tblWidth_ColumnTable
					WHERE 1<>1

					INSERT INTO #tblZero_ColumnTable05
					SELECT PROGRAM_ID
						 , SHEET_NAME
						 , COLUMN_NAME
						 , COLUMN_LABEL_NAME
						 , SORT_ORDER_NO
						 , DATA_SORT_METHOD_CODE
						 , SMALL_CLASS_LABEL_NAME
						 , LARGE_CLASS_LABEL_NAME
						 , '' AS DAY_CODE
						 , FIXED_FLAG				 
						 , 0 AS COLUMN_WIDTH
						 , CELL_CONTROL_OBJECT_TYPE_CODE
						 , CELL_COMBO_DATA_TYPE
						 , DATA_SCALE_NUMBER
						 , DATA_MAX_LENGTH
						 , HORIZONTAL_ALIGN_CODE
						 , UPPERCASE_APPLY_FLAG
						 , VISIBLE_FLAG
						 , DEFAULT_FLAG
						 , USER_SELECTABLE_FLAG
						 , VALID_YN
						 , ATTRIBUTE1
						 , ATTRIBUTE2
						 , ATTRIBUTE3
						 , ATTRIBUTE4
						 , ATTRIBUTE5
					  FROM SCM_MST_SHEET_COLUMNS 
					 WHERE 1=1
					   AND PROGRAM_ID             = @P_PROGRAM_ID
					   AND SHEET_NAME             = @P_SHEET_NAME
					   AND COLUMN_NAME            = 'IDX'
		
					SELECT *
					FROM (
							SELECT *
							FROM #tblWidth_ColumnTable
							UNION ALL
							SELECT *
							FROM #tblZero_ColumnTable05
						) A
						ORDER BY SORT_ORDER_NO

				END
			ELSE
				BEGIN
					SELECT * FROM #tblWidth_ColumnTable ORDER BY SORT_ORDER_NO
				END
				*/
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
				 , C.ATTRIBUTE1
				 , C.ATTRIBUTE2
				 , C.ATTRIBUTE3
				 , C.ATTRIBUTE4
				 , C.ATTRIBUTE5
			FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
			WHERE  1 = 1    
			AND    C.PROGRAM_ID  = @p_program_id
			AND    C.SHEET_NAME  = @p_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VISIBLE_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'

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
				 , C.ATTRIBUTE1
				 , C.ATTRIBUTE2
				 , C.ATTRIBUTE3
				 , C.ATTRIBUTE4
				 , C.ATTRIBUTE5
			FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
			WHERE  1 = 1    
			AND    C.PROGRAM_ID  = @p_program_id
			AND    C.SHEET_NAME  = @p_sheet_name
			AND    C.VISIBLE_FLAG = 'N'
			AND    (C.DEFAULT_FLAG = '' or C.DEFAULT_FLAG is null or C.DEFAULT_FLAG = 'N')
			AND    C.VALID_YN     = 'Y'
		   ORDER BY SORT_ORDER_NO   ;
		  END;

END



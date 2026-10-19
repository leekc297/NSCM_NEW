/****************************************************************************************************/
/* Program ID  : DM0003_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
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


CREATE procedure [dbo].[DM0021_GET_SPREAD_TITLE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50)
AS
BEGIN
	
    SET NOCOUNT ON;  

	DECLARE @i_Count int=0;

	-- 1. 등록여부
    SELECT  @i_Count = Count(*)
    FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
    --     , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
    WHERE  1 = 1
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID
    --AND    U.SHEET_NAME  = C.SHEET_NAME
    --AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = 'DMF1007'
    AND    U.SHEET_NAME  = 'Sales Plan'    
    AND    U.USER_ID     = @p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'

	-- 2. 
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
         , C.DEFAULT_FLAG
         , C.USER_SELECTABLE_FLAG
         , C.VALID_YN
		 , 0 AS SEQ
		 --INTO #tmpTitleO
		 FROM [SCM_MST_SHEET_COLUMNS] C
		 --WHERE 1 = 1
		 --    AND    C.PROGRAM_ID  = 'DMF1007'
			-- AND    C.SHEET_NAME  = 'Sales Plan'    
		 WHERE 1 = 1
				AND    C.PROGRAM_ID  = 'DMF1007'
				AND    C.SHEET_NAME  = 'Sales Plan'  
				AND    ( C.DEFAULT_FLAG = 'Y' OR 
					(    C.VISIBLE_FLAG = 'N'
					AND    C.DEFAULT_FLAG = ''
					AND    C.VALID_YN     = 'Y'
					)
					)  
		ORDER BY SEQ, SORT_ORDER_NO 
	END
	ELSE --IF @i_Count <> 0 
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
			 , 1 AS SEQ
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			 , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = 'DMF1007'
		AND    U.SHEET_NAME  = 'Sales Plan'
		AND    U.USER_ID     = @p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'    
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
			 , 2 AS SEQ
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = 'DMF1007'
		AND    C.SHEET_NAME  = 'Sales Plan'
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG = ''
		AND    C.VALID_YN     = 'Y'
		ORDER BY SEQ, SORT_ORDER_NO   
	END

END




/****************************************************************************************************/
/* Program ID  : DM0000_GET_COMMON_SPREAD_TITLE                                               */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 20180607		JYE			소형 관련 수정                                                                              */
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
CREATE PROCEDURE [dbo].[DMF0000_GET_COMMON_SPREAD_TITLE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50),
	@p_program_id	   NVARCHAR(MAX),
	@p_sheet_name	   NVARCHAR(MAX),
	@p_division_id		NVARCHAR(MAX)	-- 20180607 추가
AS
BEGIN
	
    SET NOCOUNT ON;

	Declare @i_Count int=0;

    SELECT  @i_Count = Count(*)
    FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
    --     , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
    WHERE  1 = 1
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID
    --AND    U.SHEET_NAME  = C.SHEET_NAME
    --AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = @p_program_id
    AND    U.SHEET_NAME  = @p_sheet_name
    AND    U.USER_ID     = @p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'

	IF @i_Count = 0 
	BEGIN

		IF (@p_division_id = '') -- 20180607 분기 추가
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
			 --, C.VALID_YN
			 , CASE C.VALID_YN	 WHEN 'Y' THEN -- 20180620 추가
					CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
				ELSE C.VALID_YN END VALID_YN
			 , 0 AS SEQ	 
			 FROM [SCM_MST_SHEET_COLUMNS] C  WITH(NOLOCK)
			 WHERE 1 = 1
				 AND    C.PROGRAM_ID  = @p_program_id
				 AND    C.SHEET_NAME  = @p_sheet_name	
				 AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
			ORDER BY SEQ, SORT_ORDER_NO 
		END
		ELSE -- 20180607 ELSE 추가
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
			 , CASE C.VALID_YN	 WHEN 'Y' THEN -- 20180607 추가
					CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
				ELSE C.VALID_YN END VALID_YN
			 , C.DEFAULT_FLAG
			 , C.USER_SELECTABLE_FLAG
			 --, C.VALID_YN	
			 , 0 AS SEQ	 
			 FROM [SCM_MST_SHEET_COLUMNS] C  WITH(NOLOCK)
			 WHERE 1 = 1
				 AND    C.PROGRAM_ID  = @p_program_id
				 AND    C.SHEET_NAME  = @p_sheet_name	
				 AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
			ORDER BY SEQ, SORT_ORDER_NO 

		END

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
			 --, C.VALID_YN
			 , CASE C.VALID_YN	 WHEN 'Y' THEN -- 20180607 추가
					CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
				ELSE C.VALID_YN END VALID_YN
			 , 1 AS SEQ
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
		AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가 
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
			 --, C.VALID_YN
			 , CASE C.VALID_YN	 WHEN 'Y' THEN -- 20180607 추가
					CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
				ELSE C.VALID_YN END VALID_YN
			 , 2 AS SEQ
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG = ''
		AND    C.VALID_YN     = 'Y'
		AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )		-- 20180620 division 추가
		ORDER BY SEQ, SORT_ORDER_NO       
		
	END

END


-- USE [LGCE_SCMDEV]

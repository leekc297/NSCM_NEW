CREATE OR REPLACE PROCEDURE           "DMF0003_GET_SPREAD_TITLE_PSI_POPUP"
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2,
	O_RC1 OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_SPREAD_TITLE_PSI                                                        */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2023/05/27  chano0612	Init																	*/
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
/* 2026.06.08 ZIONEX [PJ202650304] NextSCM Migration : 결과셋 반환 복원(BULK COLLECT 로컬→O_RC1 OPEN FOR). 날짜행(D_/W_/M_)은 MSSQL 원본에서 주석처리(비활성)이므로 미포함, 정적 컬럼만 반환. dbo.String_Split→TABLE(fn_string_split) */
	v_program_id   VARCHAR2(100 CHAR) := 'DMF0003';
	v_sheet_name   VARCHAR2(150 CHAR) := 'Customer Demand Analysis';
	v_user_col_cnt INTEGER := 0;
BEGIN
	SELECT COUNT(*) INTO v_user_col_cnt
	  FROM SCM_MST_TITLESET_USER U
	 WHERE 1 = 1 AND U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.USER_ID = p_created_by;

	IF v_user_col_cnt > 0 THEN
		OPEN O_RC1 FOR
		SELECT * FROM (
			SELECT U.PROGRAM_ID, U.SHEET_NAME, U.COLUMN_NAME, C.COLUMN_LABEL_NAME, U.SORT_ORDER_NO
				 , U.DATA_SORT_METHOD_CODE, C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME, '' AS DAY_CODE, C.FIXED_FLAG
				 , C.COLUMN_WIDTH, C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE, C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH
				 , C.HORIZONTAL_ALIGN_CODE, C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG, C.USER_SELECTABLE_FLAG
				 , C.VALID_YN, C.DIVISION_ID
			  FROM SCM_MST_TITLESET_USER U, SCM_MST_SHEET_COLUMNS C
			 WHERE 1 = 1
			   AND U.PROGRAM_ID = C.PROGRAM_ID AND U.SHEET_NAME = C.SHEET_NAME AND U.COLUMN_NAME = C.COLUMN_NAME
			   AND U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.USER_ID = p_created_by
			   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
			   AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID, ',')))
			 UNION ALL
			SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME, C.SORT_ORDER_NO
				 , C.DATA_SORT_METHOD_CODE, C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME, '' AS DAY_CODE, C.FIXED_FLAG
				 , C.COLUMN_WIDTH, C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE, C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH
				 , C.HORIZONTAL_ALIGN_CODE, C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG, C.USER_SELECTABLE_FLAG
				 , C.VALID_YN, C.DIVISION_ID
			  FROM SCM_MST_SHEET_COLUMNS C
			 WHERE 1 = 1
			   AND C.PROGRAM_ID = v_program_id AND C.SHEET_NAME = v_sheet_name
			   AND C.VISIBLE_FLAG = 'N' AND C.DEFAULT_FLAG IS NULL
			   AND C.VALID_YN = 'Y'
			   AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID, ',')))
		) A ORDER BY A.SORT_ORDER_NO;
	ELSE
		OPEN O_RC1 FOR
		SELECT * FROM (
			SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME, C.SORT_ORDER_NO
				 , C.DATA_SORT_METHOD_CODE, C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME, '' AS DAY_CODE, C.FIXED_FLAG
				 , C.COLUMN_WIDTH, C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE, C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH
				 , C.HORIZONTAL_ALIGN_CODE, C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG, C.USER_SELECTABLE_FLAG
				 , C.VALID_YN, C.DIVISION_ID
			  FROM SCM_MST_SHEET_COLUMNS C
			 WHERE 1 = 1
			   AND C.PROGRAM_ID = v_program_id AND C.SHEET_NAME = v_sheet_name
			   AND C.DEFAULT_FLAG = 'Y'
			   AND C.VALID_YN = 'Y'
			   AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID, ',')))
			 UNION ALL
			SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME, C.SORT_ORDER_NO
				 , C.DATA_SORT_METHOD_CODE, C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME, '' AS DAY_CODE, C.FIXED_FLAG
				 , C.COLUMN_WIDTH, C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE, C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH
				 , C.HORIZONTAL_ALIGN_CODE, C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG, C.USER_SELECTABLE_FLAG
				 , C.VALID_YN, C.DIVISION_ID
			  FROM SCM_MST_SHEET_COLUMNS C
			 WHERE 1 = 1
			   AND C.PROGRAM_ID = v_program_id AND C.SHEET_NAME = v_sheet_name
			   AND C.VISIBLE_FLAG = 'N' AND C.DEFAULT_FLAG IS NULL
			   AND C.VALID_YN = 'Y'
			   AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID, ',')))
		) A ORDER BY A.SORT_ORDER_NO;
	END IF;
END;
/

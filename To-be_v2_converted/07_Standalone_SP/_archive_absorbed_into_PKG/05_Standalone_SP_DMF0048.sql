-- ============================================================================
-- ABSORBED: 다음 SP들은 PKG_DMF0048에 P_* prefix로 흡수됨 (2026-05-13)
-- 원본 파일은 컴파일 대상에서 제외. 이력 관리용 보관.
-- ============================================================================

/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0048.sql
 * Description  : Standalone Procedures — DMF0048 화면 (2개)
 *              : 향후 PKG_DMF0048로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0048_GET_SPREAD_TITLE
(
    p_start_yyyymmdd		VARCHAR2,
    p_end_yyyymmdd			VARCHAR2,
	p_created_by			VARCHAR2,
	p_division_id			VARCHAR2,		-- 20180604 division 추가
	p_bucket				VARCHAR2
)
AS

    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN




	v_program_id := 'DMF0048';
	v_sheet_name := 'Sales Monitoring';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;


	IF v_user_col_cnt > 0 THEN
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		UNION ALL
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

		UNION ALL

		SELECT v_program_id   AS PROGRAM_ID
				, v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, 50         AS COLUMN_WIDTH
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
				SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					, A.DAYOFWEEK               AS DAY_CODE
					, A.BASIS_YYYYMMDD  ||  TO_CHAR(31) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				AND		1 = CASE WHEN p_bucket = 'DAILY' THEN '1' ELSE '2' END
				--UNION ALL
				--SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
				--	, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
				--	, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
				--	, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
				--	, ''                        AS DAY_CODE
				--	, A.BASIS_YYYYMMDD + TO_CHAR(32) AS SORT_ORDER_NO
				--	, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM   SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				UNION ALL
				SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
					, A.WEEK_NAME          AS COLUMN_LABEL_NAME
					, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
					, ''                   AS DAY_CODE
					, A.BASIS_START_DATE  ||  TO_CHAR(21) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK
						, A.WEEK_NAME
						, A.MONTH_NAME
						, A.BASIS_START_DATE
				--UNION ALL
				--SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
				--	, A.WEEK_NAME           AS COLUMN_LABEL_NAME
				--	, A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
				--	, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
				--	, ''                    AS DAY_CODE
				--	, A.BASIS_START_DATE + TO_CHAR(22) AS SORT_ORDER_NO
				--	, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM   SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--GROUP BY A.BASIS_YYYYMM
				--		, A.ISO_WEEK
				--		, A.WEEK_NAME
				--		, A.MONTH_NAME
				--		, A.BASIS_START_DATE
				UNION ALL
				SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, MIN(A.BASIS_START_DATE)  ||  TO_CHAR('01') AS SORT_ORDER_NO
						, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME
				--UNION ALL
				--SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
				--		, A.MONTH_NAME           AS COLUMN_LABEL
				--		, A.MONTH_NAME           AS SMALL_LABEL_NAME
				--		, A.MONTH_NAME           AS LARGE_LABEL_NAME
				--		, ''                     AS DAY_CODE
				--		, MIN(A.BASIS_START_DATE) + TO_CHAR(11) AS SORT_ORDER_NO
				--		, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM    SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--GROUP BY A.BASIS_YYYYMM
				--		, A.MONTH_NAME
				--ORDER BY sort_order_no
			) T;
		  ORDER BY SORT_ORDER_NO   ;
	  ELSE
			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = ''
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT v_program_id   AS PROGRAM_ID
					, v_sheet_name AS SHEET_NAME
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
					SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
						, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
						, A.DAYOFWEEK               AS DAY_CODE
						, A.BASIS_YYYYMMDD  ||  TO_CHAR(31) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					AND		1 = CASE WHEN p_bucket = 'DAILY' THEN '1' ELSE '2' END
					--UNION ALL
					--SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
					--	, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					--	, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
					--	, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					--	, ''                        AS DAY_CODE
					--	, A.BASIS_YYYYMMDD + TO_CHAR(32) AS SORT_ORDER_NO
					--FROM   SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					UNION ALL
					SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
						, A.WEEK_NAME          AS COLUMN_LABEL_NAME
						, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
						, ''                   AS DAY_CODE
						, A.BASIS_START_DATE  ||  TO_CHAR(21) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK
							, A.WEEK_NAME
							, A.MONTH_NAME
							, A.BASIS_START_DATE
					--UNION ALL
					--SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
					--	, A.WEEK_NAME           AS COLUMN_LABEL_NAME
					--	, A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
					--	, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
					--	, ''                    AS DAY_CODE
					--	, A.BASIS_START_DATE + TO_CHAR(22) AS SORT_ORDER_NO
					--FROM   SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--GROUP BY A.BASIS_YYYYMM
					--		, A.ISO_WEEK
					--		, A.WEEK_NAME
					--		, A.MONTH_NAME
					--		, A.BASIS_START_DATE
					UNION ALL
					SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
							, A.MONTH_NAME          AS COLUMN_LABEL_NAME
							, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
							, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
							, ''                    AS DAY_CODE
							, MIN(A.BASIS_START_DATE)  ||  TO_CHAR('01') AS SORT_ORDER_NO
					FROM    SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME
					--UNION ALL
					--SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
					--		, A.MONTH_NAME           AS COLUMN_LABEL
					--		, A.MONTH_NAME           AS SMALL_LABEL_NAME
					--		, A.MONTH_NAME           AS LARGE_LABEL_NAME
					--		, ''                     AS DAY_CODE
					--		, MIN(A.BASIS_START_DATE) + TO_CHAR(11) AS SORT_ORDER_NO
					--FROM    SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--GROUP BY A.BASIS_YYYYMM
					--		, A.MONTH_NAME
					--ORDER BY sort_order_no
				) T;
			  ORDER BY SORT_ORDER_NO   ;
		  END IF;

END;
/
                                             
/

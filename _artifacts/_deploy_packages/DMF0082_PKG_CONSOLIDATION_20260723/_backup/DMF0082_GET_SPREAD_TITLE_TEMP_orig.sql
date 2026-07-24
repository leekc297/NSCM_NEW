CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_GET_SPREAD_TITLE_TEMP" 
(
    P_START_YYYYMMDD	IN VARCHAR2,
    P_END_YYYYMMDD     	IN VARCHAR2,
    P_CREATED_BY      	IN VARCHAR2,
    P_DIVISION_ID    	IN VARCHAR2,
    DATA           		OUT SYS_REFCURSOR
)
AS
    V_USER_COL_CNT     NUMBER        := 0;
    V_PROGRAM_ID       VARCHAR2(100) := 'DMF0082';
    V_SHEET_NAME       VARCHAR2(100) := 'FcstNPrice';
BEGIN
    -- 사용자 설정 컬럼 조회
    SELECT COUNT(*)
      INTO V_USER_COL_CNT
      FROM SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = V_PROGRAM_ID
       AND U.SHEET_NAME = V_SHEET_NAME
       AND U.USER_ID    = P_CREATED_BY;

    -- 사용자 설정 컬럼 있는 경우
	IF V_USER_COL_CNT > 0 THEN
	    OPEN DATA FOR
			SELECT * FROM (
				-- 1. 사용자 정의 컬럼 (User Selected)
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
		        	 , C.DIVISION_ID
		        FROM SCM_MST_TITLESET_USER U
		        	JOIN SCM_MST_SHEET_COLUMNS C
		        		ON U.PROGRAM_ID = C.PROGRAM_ID
		                AND U.SHEET_NAME = C.SHEET_NAME
		                AND U.COLUMN_NAME = C.COLUMN_NAME
		        WHERE U.PROGRAM_ID = V_PROGRAM_ID
		          AND U.SHEET_NAME = V_SHEET_NAME
		          AND U.USER_ID    = P_CREATED_BY
		          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		          AND (',' || C.DIVISION_ID || ',' LIKE '%,' || P_DIVISION_ID || ',%')

		        UNION ALL

		        -- 2. 비표시 컬럼
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
		        FROM SCM_MST_SHEET_COLUMNS C
		        WHERE C.PROGRAM_ID  = V_PROGRAM_ID
		          AND C.SHEET_NAME  = V_SHEET_NAME
		          AND C.VISIBLE_FLAG = 'N'
		          AND (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '')
		          AND C.VALID_YN     = 'Y'
		          AND (',' || C.DIVISION_ID || ',' LIKE '%,' || P_DIVISION_ID || ',%')

				UNION ALL

		        SELECT V_PROGRAM_ID
		        	 , V_SHEET_NAME
		        	 , T.COLUMN_NAME
		        	 , T.COLUMN_LABEL_NAME
		        	 , T.SORT_ORDER_NO
		        	 , '' AS DATA_SORT_METHOD_CODE
		        	 , T.SMALL_CLASS_LABEL_NAME
		        	 , T.LARGE_CLASS_LABEL_NAME
		        	 , T.DAY_CODE
		        	 , '' AS FIXED_FLAG
		        	 , 90 AS COLUMN_WIDTH
		        	 , T.CELL_CONTROL_OBJECT_TYPE_CODE
		        	 , '' AS CELL_COMBO_DATA_TYPE
		        	 , 3  AS DATA_SCALE_NUMBER
		        	 , NULL AS DATA_MAX_LENGTH
		        	 , 'R' AS HORIZONTAL_ALIGN_CODE
		        	 , 'Y' AS UPPERCASE_APPLY_FLAG
		        	 , 'Y' AS VISIBLE_FLAG
		        	 , '' AS DEFAULT_FLAG
		        	 , '' AS USER_SELECTABLE_FLAG
		        	 , '' AS VALID_YN
		        	 , '' AS DIVISION_ID
		        FROM (
		            SELECT 'D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
		                 , A.CALENDAR_DAY AS COLUMN_LABEL_NAME
		                 , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN A.WEEK_NAME || '+'
		                        WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || A.WEEK_NAME
		                        ELSE A.WEEK_NAME END AS SMALL_CLASS_LABEL_NAME
		                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
		                 , A.DAYOFWEEK AS DAY_CODE
		                 , TO_NUMBER(A.BASIS_YYYYMMDD || '31') AS SORT_ORDER_NO
		                 , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		            FROM SCM_SYS_CALENDAR_M A
		            WHERE A.BASIS_YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
		            UNION ALL
		            SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK
		            	 , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN A.WEEK_NAME || '+'
		                        WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || A.WEEK_NAME
		                        ELSE A.WEEK_NAME END
		                 , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN A.WEEK_NAME || '+'
		                        WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || A.WEEK_NAME
		                        ELSE A.WEEK_NAME END
		                 , A.MONTH_NAME
		                 , ''
		                 , TO_NUMBER(A.BASIS_START_DATE || '21')
		                 , 'FPNumber'
		            FROM SCM_SYS_CALENDAR_M A
		            WHERE A.BASIS_YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
		            GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, PARTIAL_WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
		            UNION ALL
		            SELECT 'M_' || A.BASIS_YYYYMM
		            	 , A.MONTH_NAME
		            	 , A.MONTH_NAME
		            	 , A.MONTH_NAME
		            	 , ''
		            	 , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01')
		            	 , 'FPNumber'
		            FROM SCM_SYS_CALENDAR_M A
		            WHERE A.BASIS_YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
		            GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
		        ) T
		    ) ORDER BY SORT_ORDER_NO;

	-- 사용자 설정 컬럼 없는 경우
	ELSE
        OPEN DATA FOR
			SELECT * FROM (
				-- 1. 표시 컬럼
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
		        FROM SCM_MST_SHEET_COLUMNS C
		        WHERE C.PROGRAM_ID   = V_PROGRAM_ID
		          AND C.SHEET_NAME   = V_SHEET_NAME
		          AND C.DEFAULT_FLAG = 'Y'
		          AND C.VALID_YN      = 'Y'
		          AND (',' || C.DIVISION_ID || ',' LIKE '%,' || P_DIVISION_ID || ',%')

		        UNION ALL

		        -- 2. 비표시 컬럼
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
		        FROM SCM_MST_SHEET_COLUMNS C
		        WHERE C.PROGRAM_ID   = V_PROGRAM_ID
		          AND C.SHEET_NAME   = V_SHEET_NAME
		          AND C.VISIBLE_FLAG = 'N'
		          AND (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '')
		          AND C.VALID_YN      = 'Y'
		          AND (',' || C.DIVISION_ID || ',' LIKE '%,' || P_DIVISION_ID || ',%')

				UNION ALL

				-- 3. 캘린더 기반 동적 컬럼
		        SELECT V_PROGRAM_ID
		        	 , V_SHEET_NAME
		        	 , T.COLUMN_NAME
		        	 , T.COLUMN_LABEL_NAME
		        	 , T.SORT_ORDER_NO
		        	 , '' AS DATA_SORT_METHOD_CODE
		        	 , T.SMALL_CLASS_LABEL_NAME
		        	 , T.LARGE_CLASS_LABEL_NAME
		        	 , T.DAY_CODE
		        	 , '' AS FIXED_FLAG
		        	 , 90 AS COLUMN_WIDTH
		        	 , T.CELL_CONTROL_OBJECT_TYPE_CODE
		        	 , '' AS CELL_COMBO_DATA_TYPE
		        	 , 3  AS DATA_SCALE_NUMBER
		        	 , NULL AS DATA_MAX_LENGTH
		        	 , 'R' AS HORIZONTAL_ALIGN_CODE
		        	 , 'Y' AS UPPERCASE_APPLY_FLAG
		        	 , 'Y' AS VISIBLE_FLAG
		        	 , '' AS DEFAULT_FLAG
		        	 , '' AS USER_SELECTABLE_FLAG
		        	 , '' AS VALID_YN
		        	 , '' AS DIVISION_ID
		        FROM (
		            SELECT 'D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
		                 , A.CALENDAR_DAY AS COLUMN_LABEL_NAME
		                 , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN A.WEEK_NAME || '+'
		                        WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || A.WEEK_NAME
		                        ELSE A.WEEK_NAME END AS SMALL_CLASS_LABEL_NAME
		                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
		                 , A.DAYOFWEEK AS DAY_CODE
		                 , TO_NUMBER(A.BASIS_YYYYMMDD || '31') AS SORT_ORDER_NO
		                 , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		            FROM SCM_SYS_CALENDAR_M A
		            WHERE A.BASIS_YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
		            UNION ALL
		            SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK
		            	 , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN A.WEEK_NAME || '+'
		                        WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || A.WEEK_NAME
		                        ELSE A.WEEK_NAME END
		                 , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN A.WEEK_NAME || '+'
		                        WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || A.WEEK_NAME
		                        ELSE A.WEEK_NAME END
		                 , A.MONTH_NAME
		                 , ''
		                 , TO_NUMBER(A.BASIS_START_DATE || '21')
		                 , 'FPNumber'
		            FROM SCM_SYS_CALENDAR_M A
		            WHERE A.BASIS_YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
		            GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, PARTIAL_WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
		            UNION ALL
		            SELECT 'M_' || A.BASIS_YYYYMM
		            	 , A.MONTH_NAME
		            	 , A.MONTH_NAME
		            	 , A.MONTH_NAME
		            	 , ''
		            	 , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01')
		            	 , 'FPNumber'
		            FROM SCM_SYS_CALENDAR_M A
		            WHERE A.BASIS_YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
		            GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
		        ) T
		    ) ORDER BY SORT_ORDER_NO;
    END IF;
END;
PROCEDURE           "SCM0000_GET_GRID_HEADER" (
    p_program_id      IN  VARCHAR2,
    p_sheet_name      IN  VARCHAR2,
    p_user_id         IN  VARCHAR2,
    p_division_id     IN  VARCHAR2,
    p_start_yyyymmdd  IN  VARCHAR2,
    p_end_yyyymmdd    IN  VARCHAR2,
    o_recordset       OUT SYS_REFCURSOR
) AS
    v_user_col_cnt NUMBER := 0;
    v_sheet_name   VARCHAR2(150);
BEGIN
    -- division 구분이 필요한 경우 sheet name 으로 구분
    v_sheet_name := p_sheet_name || CASE WHEN p_division_id IS NULL THEN '' ELSE '_' || p_division_id END;

    -- 사용자 설정 컬럼 수 확인 (COUNT(*) INTO 변수)
    SELECT COUNT(*)
      INTO v_user_col_cnt
    FROM SCM_MST_TITLESET_USER U
    JOIN SCM_MST_SHEET_COLUMNS C ON U.PROGRAM_ID = C.PROGRAM_ID
                                AND U.SHEET_NAME = C.SHEET_NAME
                                AND U.COLUMN_NAME = C.COLUMN_NAME
    WHERE U.PROGRAM_ID = p_program_id
      AND U.SHEET_NAME = v_sheet_name
      AND U.USER_ID = p_user_id
      AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
      AND C.VALID_YN = 'Y';

    IF v_user_col_cnt > 0 THEN
        OPEN o_recordset FOR
            SELECT U.PROGRAM_ID, U.SHEET_NAME, U.COLUMN_NAME, C.COLUMN_LABEL_NAME, U.SORT_ORDER_NO,
                   U.DATA_SORT_METHOD_CODE, C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME,
                   '' AS DAY_CODE, C.FIXED_FLAG, C.COLUMN_WIDTH, C.CELL_CONTROL_OBJECT_TYPE_CODE,
                   C.CELL_COMBO_DATA_TYPE, TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER, TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE,
                   C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG, C.USER_SELECTABLE_FLAG,
                   C.VALID_YN, C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5
            FROM SCM_MST_TITLESET_USER U
            JOIN SCM_MST_SHEET_COLUMNS C ON U.PROGRAM_ID = C.PROGRAM_ID
                                        AND U.SHEET_NAME = C.SHEET_NAME
                                        AND U.COLUMN_NAME = C.COLUMN_NAME
            WHERE C.VALID_YN = 'Y'
              AND ((C.VISIBLE_FLAG = 'Y' AND C.DEFAULT_FLAG = 'Y')
                   OR (C.VISIBLE_FLAG = 'N' AND NVL(C.DEFAULT_FLAG, 'N') IN (' ', 'N')))
              AND U.PROGRAM_ID = p_program_id
              AND U.SHEET_NAME = v_sheet_name
              AND U.USER_ID = p_user_id
              AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'

            UNION ALL

            SELECT p_program_id, v_sheet_name, T.COLUMN_NAME, T.COLUMN_LABEL_NAME, TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO,
                   '' AS DATA_SORT_METHOD_CODE, T.SMALL_CLASS_LABEL_NAME, T.LARGE_CLASS_LABEL_NAME,
                   T.DAY_CODE, '' AS FIXED_FLAG, 50 AS COLUMN_WIDTH, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE,
                   '' AS CELL_COMBO_DATA_TYPE, '' AS DATA_SCALE_NUMBER, '' AS DATA_MAX_LENGTH, 'R' AS HORIZONTAL_ALIGN_CODE,
                   'Y' AS UPPERCASE_APPLY_FLAG, 'Y' AS VISIBLE_FLAG, '' AS DEFAULT_FLAG, '' AS USER_SELECTABLE_FLAG,
                   '' AS VALID_YN, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, '' AS ATTRIBUTE5
            FROM (
                -- 일 단위
                SELECT 'D_' || BASIS_YYYYMMDD AS COLUMN_NAME
                     , CALENDAR_DAY           AS COLUMN_LABEL_NAME
                     , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN WEEK_NAME || '+'
                            WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || WEEK_NAME
                            ELSE WEEK_NAME END AS SMALL_CLASS_LABEL_NAME
                     , MONTH_NAME             AS LARGE_CLASS_LABEL_NAME
                     , TO_CHAR(DAYOFWEEK)     AS DAY_CODE
                     , BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
                UNION ALL
                -- 주 단위
                SELECT 'W_' || BASIS_YYYYMM || ISO_WEEK AS COLUMN_NAME,
                       CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN WEEK_NAME || '+'
                            WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || WEEK_NAME
                            ELSE WEEK_NAME END AS COLUMN_LABEL_NAME,
                       CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN WEEK_NAME || '+'
                            WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || WEEK_NAME
                            ELSE WEEK_NAME END AS SMALL_CLASS_LABEL_NAME,
                       MONTH_NAME, '' AS DAY_CODE, BASIS_START_DATE || '21' AS SORT_ORDER_NO
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
                GROUP BY BASIS_YYYYMM, ISO_WEEK, WEEK_NAME, PARTIAL_WEEK_NAME, MONTH_NAME, BASIS_START_DATE
                UNION ALL
                -- 월 단위
                SELECT 'M_' || BASIS_YYYYMM, MONTH_NAME, MONTH_NAME, MONTH_NAME, '' AS DAY_CODE,
                       MIN(BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
                GROUP BY BASIS_YYYYMM, MONTH_NAME
            ) T
            ORDER BY SORT_ORDER_NO;

    ELSE
        -- 사용자 설정이 없을 때 (Else 로직)
        OPEN o_recordset FOR
            SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME, C.SORT_ORDER_NO,
                   C.DATA_SORT_METHOD_CODE, C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME,
                   '' AS DAY_CODE, C.FIXED_FLAG, C.COLUMN_WIDTH, C.CELL_CONTROL_OBJECT_TYPE_CODE,
                   C.CELL_COMBO_DATA_TYPE, TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER, TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE,
                   C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG, C.USER_SELECTABLE_FLAG,
                   C.VALID_YN, C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5
            FROM SCM_MST_SHEET_COLUMNS C
            WHERE C.PROGRAM_ID = p_program_id
              AND C.SHEET_NAME = v_sheet_name
              AND C.VALID_YN = 'Y'
              AND ((C.VISIBLE_FLAG = 'Y' AND C.DEFAULT_FLAG = 'Y')
                   OR (C.VISIBLE_FLAG = 'N' AND NVL(C.DEFAULT_FLAG, 'N') IN (' ', 'N')))

            UNION ALL

            SELECT p_program_id, v_sheet_name, T.COLUMN_NAME, T.COLUMN_LABEL_NAME, TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO,
                   '' AS DATA_SORT_METHOD_CODE, T.SMALL_CLASS_LABEL_NAME, T.LARGE_CLASS_LABEL_NAME,
                   T.DAY_CODE, '' AS FIXED_FLAG, 50 AS COLUMN_WIDTH, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE,
                   '' AS CELL_COMBO_DATA_TYPE, '' AS DATA_SCALE_NUMBER, '' AS DATA_MAX_LENGTH, 'R' AS HORIZONTAL_ALIGN_CODE,
                   'Y' AS UPPERCASE_APPLY_FLAG, 'Y' AS VISIBLE_FLAG, '' AS DEFAULT_FLAG, '' AS USER_SELECTABLE_FLAG,
                   '' AS VALID_YN, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, '' AS ATTRIBUTE5
            FROM (
                -- 일 단위
                SELECT 'D_' || BASIS_YYYYMMDD AS COLUMN_NAME
                     , CALENDAR_DAY           AS COLUMN_LABEL_NAME
                     , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN WEEK_NAME || '+'
                            WHEN INSTR(PARTIAL_WEEK_NAME, 'B') > 0 THEN '+' || WEEK_NAME
                            ELSE WEEK_NAME END AS SMALL_CLASS_LABEL_NAME
                     , MONTH_NAME             AS LARGE_CLASS_LABEL_NAME
                     , TO_CHAR(DAYOFWEEK)     AS DAY_CODE
                     , BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
                UNION ALL
                SELECT 'W_' || BASIS_YYYYMM || ISO_WEEK,
                       CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN WEEK_NAME || '+' ELSE WEEK_NAME END,
                       CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') > 0 THEN WEEK_NAME || '+' ELSE WEEK_NAME END,
                       MONTH_NAME, '', BASIS_START_DATE || '21'
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
                GROUP BY BASIS_YYYYMM, ISO_WEEK, WEEK_NAME, PARTIAL_WEEK_NAME, MONTH_NAME, BASIS_START_DATE
                UNION ALL
                SELECT 'M_' || BASIS_YYYYMM, MONTH_NAME, MONTH_NAME, MONTH_NAME, '', MIN(BASIS_START_DATE) || '01'
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
                GROUP BY BASIS_YYYYMM, MONTH_NAME
            ) T
            ORDER BY SORT_ORDER_NO;
    END IF;

END SCM0000_GET_GRID_HEADER;
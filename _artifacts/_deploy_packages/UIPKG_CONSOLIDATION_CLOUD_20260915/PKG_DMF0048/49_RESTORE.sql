-- PKG_DMF0048 — standalone 복원 (DROP 직전 원문 = 생성 시점 DB 재조회본 · SCM_MGR 로 실행)
-- ⚠ STEP 1 백업이 아니라 현재 원문을 쓴다: STEP 2 에서 바뀐 standalone(예: DMF0043_GET_MAIN_SPREAD_TITLE → _CORE 호출)을 옛 본문으로 되돌리면 INVALID
SET DEFINE OFF
-- SOURCE-FRESH: SCM_MGR.DMF0048_GET_SPREAD_TITLE PROCEDURE LAST_DDL=2026-09-02 17:30:23 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0048_GET_SPREAD_TITLE" 
(
    p_start_yyyymmdd    VARCHAR2,
    p_end_yyyymmdd      VARCHAR2,
    p_created_by        VARCHAR2,
    p_division_id       VARCHAR2,       -- 20180604 division 추가
    p_bucket            VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
)
AS
/*
 * 2026.07.04 ZIONEX [PJ202650304] NextSCM Migration : 결과셋 반환 복원(O_RC1 OPEN FOR),
 * `) T;` 조기종결+고아 ORDER BY 수정, UNION 타입통일(SORT_ORDER_NO=TO_NUMBER,
 * DATA_SCALE_NUMBER=3, DATA_MAX_LENGTH=TO_NUMBER(NULL)) — DMF0003_GET_SPREAD_TITLE 표준 준용
 */
    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN

    v_program_id := 'DMF0048';
    v_sheet_name := 'Sales Monitoring';
    v_user_col_cnt := 0;

    SELECT COUNT(*)
      INTO v_user_col_cnt
      FROM SCM_MST_TITLESET_USER U
     WHERE 1 = 1
       AND U.PROGRAM_ID = v_program_id
       AND U.SHEET_NAME = v_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
       AND U.USER_ID    = p_created_by;

    IF v_user_col_cnt > 0 THEN
        OPEN O_RC1 FOR
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
        AND  p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )       -- 20180620 division 추가
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
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,' ') IN (' ','-','N') -- [PJ202650304] 2026-07-04 사내 메타 'N' 허용 (070 동일 보강)
        AND    C.VALID_YN     = 'Y'
        AND  p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )       -- 20180620 division 추가

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
                , 3          AS DATA_SCALE_NUMBER
                , TO_NUMBER(NULL) AS DATA_MAX_LENGTH
                , 'R'        AS HORIZONTAL_ALIGN_CODE
                , 'Y'        AS UPPERCASE_APPLY_FLAG
                , 'Y'        AS VISIBLE_FLAG
                , ''         AS DEFAULT_FLAG
                , ''         AS USER_SELECTABLE_FLAG
                , ''         AS VALID_YN
                , ''         AS DIVISION_ID
        FROM  (
                SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
                    , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                    , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                    , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                    , A.DAYOFWEEK               AS DAY_CODE
                    , TO_NUMBER(A.BASIS_YYYYMMDD || '31') AS SORT_ORDER_NO
                    , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
                AND        1 = CASE WHEN p_bucket = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME ... (AS-IS 주석 블록 유지)
                UNION ALL
                SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
                    , A.WEEK_NAME          AS COLUMN_LABEL_NAME
                    , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
                    , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
                    , ''                   AS DAY_CODE
                    , TO_NUMBER(A.BASIS_START_DATE || '21') AS SORT_ORDER_NO
                    , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
                AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
                GROUP BY A.BASIS_YYYYMM
                        , A.ISO_WEEK
                        , A.WEEK_NAME
                        , A.MONTH_NAME
                        , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK ... (AS-IS 주석 블록 유지)
                UNION ALL
                SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
                        , A.MONTH_NAME          AS COLUMN_LABEL_NAME
                        , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                        , ''                    AS DAY_CODE
                        , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01') AS SORT_ORDER_NO
                        , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM    SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
                AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
                GROUP BY A.BASIS_YYYYMM
                        , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' + A.BASIS_YYYYMM ... (AS-IS 주석 블록 유지)
            ) T
          ORDER BY SORT_ORDER_NO;
      ELSE
        OPEN O_RC1 FOR
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
        AND  p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )       -- 20180620 division 추가

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
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,' ') IN (' ','-','N') -- [PJ202650304] 2026-07-04 사내 메타 'N' 허용 (070 동일 보강)
        AND    C.VALID_YN     = 'Y'
        AND  p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )       -- 20180620 division 추가

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
                , 3          AS DATA_SCALE_NUMBER
                , TO_NUMBER(NULL) AS DATA_MAX_LENGTH
                , 'R'        AS HORIZONTAL_ALIGN_CODE
                , 'Y'        AS UPPERCASE_APPLY_FLAG
                , 'Y'        AS VISIBLE_FLAG
                , ''         AS DEFAULT_FLAG
                , ''         AS USER_SELECTABLE_FLAG
                , ''         AS VALID_YN
                , ''         AS DIVISION_ID
        FROM  (
                SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
                    , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                    , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                    , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                    , A.DAYOFWEEK               AS DAY_CODE
                    , TO_NUMBER(A.BASIS_YYYYMMDD || '31') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
                AND    A.basis_yyyymmdd <= p_end_yyyymmdd
                AND        1 = CASE WHEN p_bucket = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' + A.BASIS_YYYYMMDD ... (AS-IS 주석 블록 유지)
                UNION ALL
                SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
                    , A.WEEK_NAME          AS COLUMN_LABEL_NAME
                    , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
                    , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
                    , ''                   AS DAY_CODE
                    , TO_NUMBER(A.BASIS_START_DATE || '21') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
                AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
                GROUP BY A.BASIS_YYYYMM
                        , A.ISO_WEEK
                        , A.WEEK_NAME
                        , A.MONTH_NAME
                        , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK ... (AS-IS 주석 블록 유지)
                UNION ALL
                SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
                        , A.MONTH_NAME          AS COLUMN_LABEL_NAME
                        , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                        , ''                    AS DAY_CODE
                        , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01') AS SORT_ORDER_NO
                FROM    SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
                AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
                GROUP BY A.BASIS_YYYYMM
                        , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' + A.BASIS_YYYYMM ... (AS-IS 주석 블록 유지)
            ) T
          ORDER BY SORT_ORDER_NO;
      END IF;

END;
/
-- 권한 (SCM_MGR)
GRANT EXECUTE ON SCM_MGR.DMF0048_GET_SPREAD_TITLE TO SCMP_APP;
-- 시노님 (SCMP_APP 로 실행할 것)
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0048_GET_SPREAD_TITLE FOR SCM_MGR.DMF0048_GET_SPREAD_TITLE;
-- PROC_M (standalone PROC_NM · 멱등 MERGE)
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0048_GET_SPREAD_TITLE' PROC_NM, 'startYyyymmdd' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0048_GET_SPREAD_TITLE' PROC_NM, 'endYyyymmdd' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0048_GET_SPREAD_TITLE' PROC_NM, 'createdBy' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0048_GET_SPREAD_TITLE' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 4 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0048_GET_SPREAD_TITLE' PROC_NM, 'bucket' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 5 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0048_GET_SPREAD_TITLE' PROC_NM, 'o_rc1' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 6 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;

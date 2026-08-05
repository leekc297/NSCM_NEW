PROCEDURE           "DMF0043_GET_MAIN_SPREAD_TITLE"
(
    p_division_id  IN  VARCHAR2,
    p_yyyy         IN  VARCHAR2,
    p_created_by   IN  VARCHAR2,
    p_user_id      IN  VARCHAR2,
    p_menu_id      IN  VARCHAR2,
    O_RC1          OUT SYS_REFCURSOR,
    O_RC2          OUT SYS_REFCURSOR,
    O_RC3          OUT SYS_REFCURSOR
) AS
    v_pkg_rc1    SYS_REFCURSOR;
    v_pkg_rc2    SYS_REFCURSOR;
    v_pkg_rc3    SYS_REFCURSOR;
    v_pkg_result SYS_REFCURSOR;
    v_program_id VARCHAR2(100) := 'DMF0043';
    v_sheet_name VARCHAR2(100) := 'ContributeMain';
BEGIN
    -- ────────────────────────────────────────────────────────────────────
    -- STEP 0 : GT_GMST GTT 사전 정리 (PKG INSERT 누적 방지)
    --   PKG body 의 INSERT INTO GT_GMST_TEMP_2 / GT_GMST_TEMP2_2 는
    --   DELETE 없이 누적. 같은 session 안에서 wrapper 가 N번 호출되면 117 × N row.
    --   wrapper 가 자체 책임으로 정리 — caller 빌드 시 중복 alias (ORA-00918) 방지.
    -- ────────────────────────────────────────────────────────────────────
    BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP_2;  EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 1 : PKG.P_DMF0043_GET_MAIN_SPREAD_TITLE 호출
    --   → GT_GMST_TEMP_2 (9 row) + GT_GMST_TEMP2_2 (117 row) 적재 (매 호출 117 보장)
    -- ────────────────────────────────────────────────────────────────────
    PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE(
        P_DIVISION_ID   => p_division_id,
        P_YYYY          => p_yyyy,
        P_CREATED_BY    => p_created_by,
        P_USER_ID       => p_user_id,
        P_MENU_ID       => p_menu_id,
        O_RC1           => v_pkg_rc1,
        O_RC2           => v_pkg_rc2,
        O_RC3           => v_pkg_rc3,
        O_RESULT_CURSOR => v_pkg_result
    );

    -- PKG OUT cursor 4개 모두 close (wrapper 가 자체 cursor 사용)
    BEGIN CLOSE v_pkg_rc1;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_rc2;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_rc3;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_result; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 2 : caller fetch 용 22 컬럼 cursor 를 O_RC1 에 OPEN
    --   PKG SPREAD_TITLE 의 3 UNION SELECT 와 동일 구조 + EDIT_YN 컬럼 제거
    -- ────────────────────────────────────────────────────────────────────
    OPEN O_RC1 FOR
        -- 1st UNION : SCM_MST_SHEET_COLUMNS DEFAULT_FLAG='Y' + PR_SCM_EDIT_YN 권한 필터
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
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
          INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) TEI
             ON TEI.UNIT_ID = C.DIVISION_ID
         WHERE 1 = 1
           AND C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN    = 'Y'
           AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C.DIVISION_ID, ',')))

        UNION ALL

        -- 2nd UNION : VISIBLE_FLAG='N' hidden cols (PKG line 401 동일 — Oracle 'N' 사용)
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
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE 1 = 1
           AND C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.VISIBLE_FLAG = 'N'
           AND C.DEFAULT_FLAG IS NULL
           AND C.VALID_YN = 'Y'
           AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C.DIVISION_ID, ',')))

        UNION ALL

        -- 3rd UNION : dynamic 컬럼 (FLAG#YYYYMM#CODE) — GT_GMST_TEMP2_2 117 row
        SELECT v_program_id AS PROGRAM_ID
             , v_sheet_name AS SHEET_NAME
             , T.FLAG || '#' || T.YYYYMM || '#' || CODE AS COLUMN_NAME
             , T.NAME AS COLUMN_LABEL_NAME
             , TO_NUMBER(DISPLAY_SEQ) AS SORT_ORDER_NO
             , '' AS DATA_SORT_METHOD_CODE
             , T.NAME AS SMALL_CLASS_LABEL_NAME
             , CASE WHEN LENGTH(T.YYYYMM) = 4 THEN T.YYYYMM
                    ELSE SUBSTR(T.YYYYMM, 1, 4) || '-' || SUBSTR(T.YYYYMM, 5, 2) END AS LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , '' AS FIXED_FLAG
             , 80 AS COLUMN_WIDTH
             , '' AS CELL_CONTROL_OBJECT_TYPE_CODE
             , '' AS CELL_COMBO_DATA_TYPE
             , 2 AS DATA_SCALE_NUMBER
             , NULL AS DATA_MAX_LENGTH
             , 'R' AS HORIZONTAL_ALIGN_CODE
             , 'Y' AS UPPERCASE_APPLY_FLAG
             , 'Y' AS VISIBLE_FLAG
             , '' AS DEFAULT_FLAG
             , '' AS USER_SELECTABLE_FLAG
             , '' AS VALID_YN
             , '' AS DIVISION_ID
          FROM (SELECT REPLACE(YYYYMM, ' ', '') AS YYYYMM
                     , FLAG
                     , CODE
                     , NAME
                     , TO_CHAR(REPLACE(REPLACE(YYYYMM, ' ', ''), '-', '')) || TO_CHAR(DISPLAY_SEQ) AS DISPLAY_SEQ
                  FROM SCM_MGR.GT_GMST_TEMP2_2) T

        UNION ALL

        -- 4th UNION : EDIT_FLAG row 강제 포함 (caller v_ColumnData 빌드 logic 의 EDIT_FLAG SORT 기준점 보장)
        --   PKG 1st UNION 의 INNER JOIN PR_SCM_EDIT_YN 권한 / DEFAULT_FLAG 필터 등으로 EDIT_FLAG 제외 시
        --   caller WHERE SORT > EDIT_FLAG SORT NULL → 0 row → v_Query invalid → ORA-00936 사고 방지
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
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.COLUMN_NAME = 'EDIT_FLAG'
           -- 다른 필터 없음: DEFAULT_FLAG / VALID_YN / VISIBLE_FLAG 무관 — 강제 포함
           AND NOT EXISTS (
             -- 1st UNION 이 이미 EDIT_FLAG 반환했으면 중복 회피
             SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C2
              INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) TEI2
                 ON TEI2.UNIT_ID = C2.DIVISION_ID
              WHERE C2.PROGRAM_ID = v_program_id
                AND C2.SHEET_NAME = v_sheet_name
                AND C2.COLUMN_NAME = 'EDIT_FLAG'
                AND C2.DEFAULT_FLAG = 'Y'
                AND C2.VALID_YN = 'Y'
                AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C2.DIVISION_ID, ',')))
           )

        ORDER BY 5;  -- SORT_ORDER_NO

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 3 : O_RC2 / O_RC3 = empty cursor (caller close 안전)
    -- ────────────────────────────────────────────────────────────────────
    OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
    OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,
            '[DMF0043_GET_MAIN_SPREAD_TITLE wrapper] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM);
END;
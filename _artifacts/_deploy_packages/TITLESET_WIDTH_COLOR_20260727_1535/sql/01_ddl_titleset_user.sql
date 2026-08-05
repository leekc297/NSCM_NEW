-- ============================================================================
-- 01. SCM_MST_TITLESET_USER — COLUMN_WIDTH / CELL_COLOR / TEXT_COLOR 3종 추가
--     멱등: 이미 있으면 skip (ORA-01430 회피). NULL 허용 = 기존 행 무영향.
--     COLUMN_WIDTH 타입 = SCM_MST_SHEET_COLUMNS.COLUMN_WIDTH 와 동일 NUMBER
-- ============================================================================
DECLARE
    N PLS_INTEGER;
    PROCEDURE ADD_COL(P_COL VARCHAR2, P_TYPE VARCHAR2) IS
        C PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO C FROM ALL_TAB_COLUMNS
         WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = 'SCM_MST_TITLESET_USER' AND COLUMN_NAME = P_COL;
        IF C = 0 THEN
            EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.SCM_MST_TITLESET_USER ADD (' || P_COL || ' ' || P_TYPE || ')';
            DBMS_OUTPUT.PUT_LINE('[ADD] ' || P_COL);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[SKIP] ' || P_COL || ' 이미 존재');
        END IF;
    END;
BEGIN
    ADD_COL('COLUMN_WIDTH', 'NUMBER');
    ADD_COL('CELL_COLOR',   'VARCHAR2(30 CHAR)');
    ADD_COL('TEXT_COLOR',   'VARCHAR2(30 CHAR)');
END;
/

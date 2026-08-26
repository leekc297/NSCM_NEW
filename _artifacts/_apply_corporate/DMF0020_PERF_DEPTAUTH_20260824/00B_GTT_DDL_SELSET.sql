-- [E20260824-INJOIN] 조회 대상 선택집합 GTT (기존재 skip · 멱등)
DECLARE
    PROCEDURE mk(p_tab VARCHAR2, p_col VARCHAR2, p_len NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=p_tab;
        IF v = 0 THEN
            EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE SCM_MGR.'||p_tab||
                              ' ( '||p_col||' VARCHAR2('||p_len||' CHAR) ) ON COMMIT PRESERVE ROWS';
            EXECUTE IMMEDIATE 'CREATE INDEX SCM_MGR.'||p_tab||'_IDX ON SCM_MGR.'||p_tab||' ('||p_col||')';
            DBMS_OUTPUT.PUT_LINE('CREATED '||p_tab);
        ELSE
            DBMS_OUTPUT.PUT_LINE('SKIP(exists) '||p_tab);
        END IF;
    END;
BEGIN
    mk('GT_DMF0020_SEL_VERSION', 'VERSION_NO', 100);   -- 원천 SCM_MST_FUTURE_PRICE_C.VERSION_NO = VARCHAR2(50)
    mk('GT_DMF0020_SEL_MEASURE', 'MEASURE',    100);   -- 원천 SCM_MST_SHEET_MEASURE.COLUMN_NAME = VARCHAR2(200)
END;
/

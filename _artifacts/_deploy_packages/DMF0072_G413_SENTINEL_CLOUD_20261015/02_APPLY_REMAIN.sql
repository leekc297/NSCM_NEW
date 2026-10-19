-- =====================================================================================
-- 02_APPLY_REMAIN.sql  GAP413 잔여 2객체 적용 (01_APPLY 가 PR_DM_CUST_MODEL_MAPPING_IF 에서 ORA-20413 중단 → 뒤 2객체 미실행분)
-- 대상: PR_DM_DNM_EDI_CALLOFF_MKT_FCST / PR_DM_PLN_CUST_FCST_RECORD (클라우드 00_PRECHECK 에서 MATCH = EXPECT 확인됨)
-- 실행: 파일 전체 F5. 로직은 01_APPLY 와 동일 (원문 상이 시 ORA-20413 무변경 중단 / 이미 적용 시 SKIP / 컴파일 오류 시 자동 원복)
-- 참고: PR_DM_PLN_CUST_FCST_RECORD 는 클라우드에서 적용 전부터 INVALID(ERRORS 0) — 이번 재컴파일로 VALID 가 되는지 함께 확인
-- 마지막 SELECT 기대값(2행): MARKED_LINES = EXPECT_MARKED / STATUS = VALID / ERRORS = 0
-- =====================================================================================
-- SOURCE-FRESH: SCM_MGR.PR_DM_DNM_EDI_CALLOFF_MKT_FCST PROCEDURE LAST_DDL=2026-10-15 11:15:56 FETCHED=2026-10-15 11:17 DB=ZIOUI1
-- SOURCE-FRESH: SCM_MGR.PR_DM_PLN_CUST_FCST_RECORD PROCEDURE LAST_DDL=2026-10-15 11:15:57 FETCHED=2026-10-15 11:17 DB=ZIOUI1

DECLARE
    TYPE T_VC IS TABLE OF VARCHAR2(4000);
    PROCEDURE P_PATCH(P_NAME VARCHAR2, P_TYPE VARCHAR2, P_EXPECT NUMBER, P_TOTAL NUMBER,
                      P_PAT VARCHAR2, P_REP VARCHAR2, P_SCOPE T_VC, P_OCC T_VC) IS
        TYPE T_NUM IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        V_CNT    T_NUM;
        V_SRC    CLOB;
        V_ORIG   CLOB;
        V_LINE   VARCHAR2(4000);
        V_BODY   VARCHAR2(4000);
        V_CMP    VARCHAR2(4000);
        V_NL     VARCHAR2(1);
        V_HIT    BOOLEAN;
        V_HITS   NUMBER := 0;
        V_MATCH  NUMBER := 0;
        V_MARKED NUMBER;
        V_ERRS   NUMBER;
    BEGIN
        SELECT COUNT(*) INTO V_MARKED FROM ALL_SOURCE
         WHERE OWNER = 'SCM_MGR' AND NAME = P_NAME AND TYPE = P_TYPE AND INSTR(TEXT, 'GAP413') > 0;
        IF V_MARKED > 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP     ' || P_NAME || ' - already applied (GAP413 marked lines=' || V_MARKED || ')');
            RETURN;
        END IF;
        DBMS_LOB.CREATETEMPORARY(V_SRC, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_ORIG, TRUE);
        DBMS_LOB.APPEND(V_SRC, 'CREATE OR REPLACE ');
        DBMS_LOB.APPEND(V_ORIG, 'CREATE OR REPLACE ');
        FOR R IN (SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = P_NAME AND TYPE = P_TYPE ORDER BY LINE) LOOP
            DBMS_LOB.APPEND(V_ORIG, R.TEXT);
            V_LINE := R.TEXT;
            V_NL   := CASE WHEN SUBSTR(R.TEXT, -1) = CHR(10) THEN CHR(10) END;
            V_CMP  := REGEXP_REPLACE(R.TEXT, '[[:space:]]', '');
            V_HIT  := FALSE;
            FOR I IN 1 .. P_SCOPE.COUNT LOOP
                IF V_CMP = P_SCOPE(I) THEN
                    V_MATCH  := V_MATCH + 1;
                    V_CNT(I) := CASE WHEN V_CNT.EXISTS(I) THEN V_CNT(I) ELSE 0 END + 1;
                    V_HIT    := INSTR(P_OCC(I), ',' || V_CNT(I) || ',') > 0;
                    EXIT;
                END IF;
            END LOOP;
            IF V_HIT THEN
                V_BODY := RTRIM(R.TEXT, CHR(10));
                IF REGEXP_COUNT(V_BODY, P_PAT) = 0 THEN
                    RAISE_APPLICATION_ERROR(-20415, P_NAME || ' target line has no pattern: ' || SUBSTR(V_BODY, 1, 200));
                END IF;
                V_BODY := REGEXP_REPLACE(V_BODY, P_PAT, P_REP);
                IF INSTR(V_BODY, ' -- ') = 0 AND SUBSTR(RTRIM(V_BODY), -2) <> '*/' THEN
                    V_BODY := V_BODY || '  /* 2026.10.15 GAP413 센티널 통일 */';
                END IF;
                V_LINE := V_BODY || V_NL;
                V_HITS := V_HITS + 1;
            END IF;
            DBMS_LOB.APPEND(V_SRC, V_LINE);
        END LOOP;
        IF V_HITS <> P_EXPECT OR V_MATCH <> P_TOTAL THEN
            RAISE_APPLICATION_ERROR(-20413, P_NAME || ' target lines ' || V_HITS || '/' || P_EXPECT
                || ', same-shape lines ' || V_MATCH || '/' || P_TOTAL
                || ' - cloud source differs from corporate. NOT applied (source unchanged). Send 00_PRECHECK result.');
        END IF;
        BEGIN
            EXECUTE IMMEDIATE V_SRC;
        EXCEPTION WHEN OTHERS THEN NULL;  -- compile error (ORA-24344) is judged by ALL_ERRORS below
        END;
        SELECT COUNT(*) INTO V_ERRS FROM ALL_ERRORS WHERE OWNER = 'SCM_MGR' AND NAME = P_NAME AND TYPE = P_TYPE;
        IF V_ERRS > 0 THEN
            EXECUTE IMMEDIATE V_ORIG;  -- auto restore
            RAISE_APPLICATION_ERROR(-20414, P_NAME || ' compile errors ' || V_ERRS || ' - restored original source');
        END IF;
        DBMS_OUTPUT.PUT_LINE('APPLIED  ' || P_NAME || ' - lines ' || V_HITS);
    END P_PATCH;
BEGIN
    P_PATCH('PR_DM_DNM_EDI_CALLOFF_MKT_FCST', 'PROCEDURE', 11, 13,
      'NVL\(RTRIM\(LTRIM\(([A-Z0-9_.]+(\(\+\))?)\)\),[[:space:]]*''([ /])''\)',
      'NVL(NULLIF(NULLIF(NULLIF(RTRIM(LTRIM(\1)),''-''),''--''),''/''), ''\3'')',
      T_VC(
        ',NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'''');',
        ',NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'''')ASCUSTOMER_ITEM_ID',
        ',NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'''')ASCUSTOMER_PLANT',
        ',NVL(RTRIM(LTRIM(A.UNLOADING_POINT)),''''),NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'''')',
        ',NVL(RTRIM(LTRIM(A.UNLOADING_POINT)),'''')ASUNLOADING_POINT',
        'ANDNVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)),'''')=NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT)),'''')',
        'ANDNVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)),'''')=NVL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)),'''')',
        'ANDNVL(RTRIM(LTRIM(X.UNLOADING_POINT)),'''')=NVL(RTRIM(LTRIM(B.UNLOADING_POINT)),'''')'),
      T_VC(
        ',1,',
        ',1,',
        ',2,',
        ',1,',
        ',2,',
        ',1,2,',
        ',1,2,',
        ',1,2,'));
    P_PATCH('PR_DM_PLN_CUST_FCST_RECORD', 'PROCEDURE', 9, 9,
      'NVL\(RTRIM\(LTRIM\(([A-Z0-9_.]+(\(\+\))?)\)\),[[:space:]]*''([ /])''\)',
      'NVL(NULLIF(NULLIF(NULLIF(RTRIM(LTRIM(\1)),''-''),''--''),''/''), ''\3'')',
      T_VC(
        ',NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),''/'')',
        ',NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),''/'');',
        ',NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),''/'')',
        ',NVL(RTRIM(LTRIM(A.UNLOADING_POINT)),''/'')',
        'ANDNVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)),'''')=NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT)),'''')',
        'ANDNVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)),'''')=NVL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)),'''')',
        'ANDNVL(RTRIM(LTRIM(X.UNLOADING_POINT)),''/'')=NVL(RTRIM(LTRIM(B.UNLOADING_POINT)),''/'')'),
      T_VC(
        ',1,',
        ',1,',
        ',1,2,',
        ',1,2,',
        ',1,',
        ',1,',
        ',1,'));
END;
/

-- 적용 확인
SELECT 'PR_DM_DNM_EDI_CALLOFF_MKT_FCST' AS OBJ, 11 AS EXPECT_MARKED,
       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND S.NAME='PR_DM_DNM_EDI_CALLOFF_MKT_FCST' AND S.TYPE='PROCEDURE' AND INSTR(S.TEXT,'GAP413')>0) AS MARKED_LINES,
       (SELECT STATUS FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR' AND O.OBJECT_NAME='PR_DM_DNM_EDI_CALLOFF_MKT_FCST' AND O.OBJECT_TYPE='PROCEDURE') AS STATUS,
       (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER='SCM_MGR' AND E.NAME='PR_DM_DNM_EDI_CALLOFF_MKT_FCST' AND E.TYPE='PROCEDURE') AS ERRORS
  FROM DUAL
UNION ALL
SELECT 'PR_DM_PLN_CUST_FCST_RECORD' AS OBJ, 9 AS EXPECT_MARKED,
       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND S.NAME='PR_DM_PLN_CUST_FCST_RECORD' AND S.TYPE='PROCEDURE' AND INSTR(S.TEXT,'GAP413')>0) AS MARKED_LINES,
       (SELECT STATUS FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR' AND O.OBJECT_NAME='PR_DM_PLN_CUST_FCST_RECORD' AND O.OBJECT_TYPE='PROCEDURE') AS STATUS,
       (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER='SCM_MGR' AND E.NAME='PR_DM_PLN_CUST_FCST_RECORD' AND E.TYPE='PROCEDURE') AS ERRORS
  FROM DUAL;

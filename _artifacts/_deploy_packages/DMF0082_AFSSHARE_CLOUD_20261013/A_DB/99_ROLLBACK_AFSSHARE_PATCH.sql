-- 99 ROLLBACK — [E20261013-DMF0082AFSSHARE] 역치환 (이 DB 의 USER_SOURCE 를 읽어 끼워 넣은 2곳을 걷어낸 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 걷어낸 뒤 마커 0 이어야 실행. ⚠ 되돌리면 LOC 등 다른 메저 행의 AS From Site 가 다시 빈칸으로 나온다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_p1    PLS_INTEGER;
    v_p2    PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_nxt   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0082AFSSHARE';
    c_anc1  CONSTANT VARCHAR2(32767) :=   -- 앵커 1: P_DMF0082_GET_MAIN_DATA 의 AS From Site 빈값 정규화 문장 (GT_DMF0082_MF_SP)
        '    UPDATE SCM_MGR.GT_DMF0082_MF_SP' || CHR(10) ||
        '    SET    AS_FROM_SITE = '' ''' || CHR(10) ||
        '    WHERE  AS_FROM_SITE IS NULL;' || CHR(10);
    c_anc2  CONSTANT VARCHAR2(32767) :=   -- 앵커 2: P_DMF0082_GET_MAIN_DATA_CURRENT 의 같은 문장 (GTT_MF_SP)
        '    UPDATE SCM_MGR.GTT_MF_SP' || CHR(10) ||
        '    SET    AS_FROM_SITE = '' ''' || CHR(10) ||
        '    WHERE  AS_FROM_SITE IS NULL;' || CHR(10);
    c_blk1  CONSTANT VARCHAR2(32767) :=   -- 삽입 1
        '' || CHR(10) ||
        '    /* [E20261013-DMF0082AFSSHARE] MKT_FCST 의 AS From Site 를 같은 키의 다른 메저 행에도 표시 (사용자 요청 2026-10-13).' || CHR(10) ||
        '       AS From Site 는 수요 원장(ATTRIBUTE10)에만 저장된다. 판가 · 실적 · 계산 메저 행은 빈칸이라 같은 품목이어도' || CHR(10) ||
        '       MKT_FCST 행과 값이 달라 화면의 셀 병합이 끊겼다 (AS-IS 도 판가 행은 '''' 고정 — 의도적 변경).' || CHR(10) ||
        '       원천 = 이 조회 결과의 MKT_FCST 행 중 값이 있는 것(빈칸 · ''-'' · ''/'' 는 값 없음).' || CHR(10) ||
        '       대상 = 같은 키(그리드 행 식별 10컬럼)의 MKT_FCST 가 아닌 행 중 비어 있는 것 — 자기 값이 있는 행은 그대로 둔다.' || CHR(10) ||
        '       한 키의 MKT_FCST 에 값이 둘 이상이면 채우지 않는다. 결과 컬럼에 AS_FROM_SITE 가 없으면 건너뛴다.' || CHR(10) ||
        '       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 · 단가 검증 무변경. */' || CHR(10) ||
        '    IF INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '',AS_FROM_SITE,'') > 0 THEN' || CHR(10) ||
        '        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T' || CHR(10) ||
        '        USING ( SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID' || CHR(10) ||
        '                     , DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID' || CHR(10) ||
        '                     , MAX(AS_FROM_SITE) AS AS_FROM_SITE' || CHR(10) ||
        '                FROM   SCM_MGR.GT_DMF0082_MF_SP' || CHR(10) ||
        '                WHERE  MEASURE = ''MKT_FCST''' || CHR(10) ||
        '                AND    RTRIM(AS_FROM_SITE, '' -/'') IS NOT NULL' || CHR(10) ||
        '                GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID' || CHR(10) ||
        '                       , DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID' || CHR(10) ||
        '                HAVING COUNT(DISTINCT AS_FROM_SITE) = 1 ) S' || CHR(10) ||
        '        ON (    NVL(T.DIVISION_ID, ''/'') = NVL(S.DIVISION_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.PROJECT_CODE, ''/'') = NVL(S.PROJECT_CODE, ''/'')' || CHR(10) ||
        '        AND NVL(T.END_CUSTOMER, ''/'') = NVL(S.END_CUSTOMER, ''/'')' || CHR(10) ||
        '        AND NVL(T.SCM_SITE_ID, ''/'') = NVL(S.SCM_SITE_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.ITEM_ID, ''/'') = NVL(S.ITEM_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.DOM_EXP, ''/'') = NVL(S.DOM_EXP, ''/'')' || CHR(10) ||
        '        AND NVL(T.FCST_TYPE, ''/'') = NVL(S.FCST_TYPE, ''/'')' || CHR(10) ||
        '        AND NVL(T.INCOTERMS, ''/'') = NVL(S.INCOTERMS, ''/'')' || CHR(10) ||
        '        AND NVL(T.PLANT_SITE_ID, ''/'') = NVL(S.PLANT_SITE_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.CELL_PROD_SITE_ID, ''/'') = NVL(S.CELL_PROD_SITE_ID, ''/'') )' || CHR(10) ||
        '        WHEN MATCHED THEN' || CHR(10) ||
        '        UPDATE SET T.AS_FROM_SITE = S.AS_FROM_SITE' || CHR(10) ||
        '        WHERE  T.MEASURE <> ''MKT_FCST''' || CHR(10) ||
        '        AND    RTRIM(T.AS_FROM_SITE, '' -/'') IS NULL;' || CHR(10) ||
        '    END IF;' || CHR(10);
    c_blk2  CONSTANT VARCHAR2(32767) :=   -- 삽입 2
        '' || CHR(10) ||
        '    /* [E20261013-DMF0082AFSSHARE] MKT_FCST 의 AS From Site 를 같은 키의 다른 메저 행에도 표시 (사용자 요청 2026-10-13).' || CHR(10) ||
        '       AS From Site 는 수요 원장(ATTRIBUTE10)에만 저장된다. 판가 · 실적 · 계산 메저 행은 빈칸이라 같은 품목이어도' || CHR(10) ||
        '       MKT_FCST 행과 값이 달라 화면의 셀 병합이 끊겼다 (AS-IS 도 판가 행은 '''' 고정 — 의도적 변경).' || CHR(10) ||
        '       원천 = 이 조회 결과의 MKT_FCST 행 중 값이 있는 것(빈칸 · ''-'' · ''/'' 는 값 없음).' || CHR(10) ||
        '       대상 = 같은 키(그리드 행 식별 10컬럼)의 MKT_FCST 가 아닌 행 중 비어 있는 것 — 자기 값이 있는 행은 그대로 둔다.' || CHR(10) ||
        '       한 키의 MKT_FCST 에 값이 둘 이상이면 채우지 않는다. 결과 컬럼에 AS_FROM_SITE 가 없으면 건너뛴다.' || CHR(10) ||
        '       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 · 단가 검증 무변경. */' || CHR(10) ||
        '    IF INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '',AS_FROM_SITE,'') > 0 THEN' || CHR(10) ||
        '        MERGE INTO SCM_MGR.GTT_MF_SP T' || CHR(10) ||
        '        USING ( SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID' || CHR(10) ||
        '                     , DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID' || CHR(10) ||
        '                     , MAX(AS_FROM_SITE) AS AS_FROM_SITE' || CHR(10) ||
        '                FROM   SCM_MGR.GTT_MF_SP' || CHR(10) ||
        '                WHERE  MEASURE = ''MKT_FCST''' || CHR(10) ||
        '                AND    RTRIM(AS_FROM_SITE, '' -/'') IS NOT NULL' || CHR(10) ||
        '                GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID' || CHR(10) ||
        '                       , DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID' || CHR(10) ||
        '                HAVING COUNT(DISTINCT AS_FROM_SITE) = 1 ) S' || CHR(10) ||
        '        ON (    NVL(T.DIVISION_ID, ''/'') = NVL(S.DIVISION_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.PROJECT_CODE, ''/'') = NVL(S.PROJECT_CODE, ''/'')' || CHR(10) ||
        '        AND NVL(T.END_CUSTOMER, ''/'') = NVL(S.END_CUSTOMER, ''/'')' || CHR(10) ||
        '        AND NVL(T.SCM_SITE_ID, ''/'') = NVL(S.SCM_SITE_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.ITEM_ID, ''/'') = NVL(S.ITEM_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.DOM_EXP, ''/'') = NVL(S.DOM_EXP, ''/'')' || CHR(10) ||
        '        AND NVL(T.FCST_TYPE, ''/'') = NVL(S.FCST_TYPE, ''/'')' || CHR(10) ||
        '        AND NVL(T.INCOTERMS, ''/'') = NVL(S.INCOTERMS, ''/'')' || CHR(10) ||
        '        AND NVL(T.PLANT_SITE_ID, ''/'') = NVL(S.PLANT_SITE_ID, ''/'')' || CHR(10) ||
        '        AND NVL(T.CELL_PROD_SITE_ID, ''/'') = NVL(S.CELL_PROD_SITE_ID, ''/'') )' || CHR(10) ||
        '        WHEN MATCHED THEN' || CHR(10) ||
        '        UPDATE SET T.AS_FROM_SITE = S.AS_FROM_SITE' || CHR(10) ||
        '        WHERE  T.MEASURE <> ''MKT_FCST''' || CHR(10) ||
        '        AND    RTRIM(T.AS_FROM_SITE, '' -/'') IS NULL;' || CHR(10) ||
        '    END IF;' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc1 || c_blk1) <> 1 OR cnt(v_src, c_anc2 || c_blk2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_anc1 || c_blk1) || ' · ' || cnt(v_src, c_anc2 || c_blk2) || '건 (각 1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_anc1 || c_blk1, c_anc1);
    v_new := REPLACE(v_new, c_anc2 || c_blk2, c_anc2);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

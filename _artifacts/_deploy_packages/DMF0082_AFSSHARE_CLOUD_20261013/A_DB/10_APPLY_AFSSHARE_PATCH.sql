-- 10_APPLY — [E20261013-DMF0082AFSSHARE] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)이
--       MKT_FCST 행의 AS From Site 값을 같은 키의 다른 메저 행(LOC · KRW · 실적 · 계산 메저 등)에도 내려주도록 한다.
--       키 = Division · Project · End Customer · Sales Site · Model · Customs Handbook · Fcst Type · Incoterms · Plant Site · Cell Prod Site
--       대상 = AS From Site 가 비어 있는(빈칸 · '-' · '/') MKT_FCST 가 아닌 행. 자기 값이 있는 행 · MKT_FCST 행은 그대로.
--       한 키의 MKT_FCST 에 서로 다른 값이 둘 이상이면 채우지 않는다. 결과 컬럼에 AS From Site 가 없는 조회는 건너뛴다.
-- 배경: AS From Site 는 수요 원장에만 저장돼 LOC 등 다른 메저 행은 빈칸 → 같은 품목인데 화면의 셀 병합이 끊겼다 (사용자 요청 2026-10-13).
-- 범위: 조회용 임시 테이블의 표시값만 바꾼다. 원장 · 저장 · 단가 검증 무변경.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 AS From Site 빈값 정규화 문장 뒤 2곳에 MERGE 를 끼워 넣은 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 각 1건이 아니거나 위치가 두 조회 프로시저와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-13 18:21:26 (같은 삽입 · 모의 행 14케이스 + 전후 비교 16케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
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
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc1) <> 1 OR cnt(v_src, c_anc2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 빈값 정규화 앵커 매칭 ' || cnt(v_src, c_anc1) || ' · ' || cnt(v_src, c_anc2) || '건 (각 1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_p1  := DBMS_LOB.INSTR(v_src, c_anc1);
    v_p2  := DBMS_LOB.INSTR(v_src, c_anc2);
    v_cur := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_nxt := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_cur > 0 AND v_nxt > 0 AND v_p1 < v_cur AND v_cur < v_p2 AND v_p2 < v_nxt) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_p1 + LENGTH(c_anc1) - 1) || c_blk1
          || SUBSTR(v_src, v_p1 + LENGTH(c_anc1), v_p2 + LENGTH(c_anc2) - v_p1 - LENGTH(c_anc1))
          || c_blk2
          || SUBSTR(v_src, v_p2 + LENGTH(c_anc2));
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_anc1 || c_blk1) <> 1 OR cnt(v_new, c_anc2 || c_blk2) <> 1
       OR LENGTH(v_new) <> LENGTH(v_src) + LENGTH(c_blk1) + LENGTH(c_blk2) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

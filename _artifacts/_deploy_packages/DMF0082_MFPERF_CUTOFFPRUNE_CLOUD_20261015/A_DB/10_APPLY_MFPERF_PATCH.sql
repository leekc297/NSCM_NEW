-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 15:50:37 FETCHED=2026-10-15 15:52 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [MFPERF 2026-10-15] DMF0082 과거 버전 조회 속도 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0082_GET_MAIN_DATA 의 컷오프 최종수정자 적재 3문장(81 수요 DM_PLN_MKT_FCST_C · 40 수요 DM_PLN_CFM_MKT_DEMAND_PLAN_C ·
--       40 판가 DM_PLN_CFM_SELLING_PRICE_C)에 파티션 키 CUTOFF_YYYYMMDD_DATE 범위 조건(선택 버전 컷오프 범위)을 2줄씩 넣는다.
--       구: 파티션 키 조건이 없어 버전·사이트품목 조합마다 전 파티션을 탐색(PARTITION RANGE ALL) — 사내 40 MF 575초 · 81 MF 532초.
--       신: 해당 컷오프 파티션만 탐색 — 사내 40 MF 3.5초 · SF 3.5초 · SP 2.6초 · 81 MF 3.8초, 결과 행 동일.
--       버전당 컷오프 1개 · CUTOFF_YYYYMMDD_DATE = 버전일(사내 실측 불일치 0)이라 조건은 행을 거르지 않는다.
-- 범위: 조회 SP 3곳 조건 추가. 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 에서 각 원장의 GET_MAIN_DATA 첫 FROM 줄(컷오프 최종수정자 적재 문장)을 찾아
--       그 뒤 'A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd' 줄 다음에 2줄을 넣고 CREATE OR REPLACE.
-- 가드: 마커 존재 시 무동작 · 각 위치가 적재 문장 안이 아니면 중단(원문 무변경) · 마커 3곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_m0     PLS_INTEGER;
    v_m1     PLS_INTEGER;
    v_f      PLS_INTEGER;
    v_h      PLS_INTEGER;
    v_d      PLS_INTEGER;
    v_g      PLS_INTEGER;
    v_s      PLS_INTEGER;
    v_e      PLS_INTEGER;
    TYPE t_list IS TABLE OF VARCHAR2(100);
    c_tables CONSTANT t_list := t_list('DM_PLN_MKT_FCST_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'DM_PLN_CFM_SELLING_PRICE_C');
    c_mark   CONSTANT VARCHAR2(40)  := 'MFPERF 2026-10-15';
    c_ins    CONSTANT VARCHAR2(100) := 'INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_';
    c_date   CONSTANT VARCHAR2(200) := '    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd' || CHR(10) || '';
    c_pfx    CONSTANT VARCHAR2(300) := '    AND    A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM = ''00000000''';
    c_cut    CONSTANT VARCHAR2(2000) := '    AND    A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM = ''00000000'' THEN ''19000101'' ELSE V_CUTOFF_FROM END, ''YYYYMMDD'')' || CHR(10) || '                                  AND     TO_DATE(CASE WHEN V_CUTOFF_TO   = ''99999999'' THEN ''99991231'' ELSE V_CUTOFF_TO   END, ''YYYYMMDD'')  --[MFPERF 2026-10-15] 파티션 키 프루닝 (버전당 컷오프 1개·CUTOFF_YYYYMMDD_DATE=버전일 실측 → 행 무변화, PARTITION RANGE ALL 해소)' || CHR(10) || '';
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE locate IS
    BEGIN
        v_m0 := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
        v_m1 := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
        IF NOT (v_m0 > 0 AND v_m0 < v_m1) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — GET_MAIN_DATA 위치 확인 불가. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    FOR i IN 1 .. c_tables.COUNT LOOP
        locate;
        v_f := DBMS_LOB.INSTR(v_new, '    FROM   SCM_MGR.' || c_tables(i) || ' A' || CHR(10), v_m0);
        IF v_f = 0 OR v_f > v_m1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || c_tables(i) || ' FROM 줄 없음. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        -- 이 FROM 이 컷오프 최종수정자 적재 문장(INSERT INTO GT_DMF0082_T_LAST_DATA_SETUP_*) 안인지: 직전 800자 안에 INSERT 머리
        v_h := DBMS_LOB.INSTR(v_new, c_ins, GREATEST(v_f - 800, 1));
        v_d := DBMS_LOB.INSTR(v_new, c_date, v_f);
        v_g := DBMS_LOB.INSTR(v_new, '    GROUP BY', v_f);
        IF v_h = 0 OR v_h > v_f OR v_d = 0 OR v_g = 0 OR v_d > v_g THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || c_tables(i) || ' 적재 문장 형태 확인 불가. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        v_s := v_d + LENGTH(c_date);
        v_new := SUBSTR(v_new, 1, v_s - 1) || c_cut || SUBSTR(v_new, v_s);
    END LOOP;
    IF (DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark) <> 3
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + 3 * LENGTH(c_cut) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원 (2026-10-15 GAP452 리허설 사고 정정)
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 3곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

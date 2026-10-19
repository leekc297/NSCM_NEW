-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 13:18:04 FETCHED=2026-10-15 13:29 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP442 2026-10-15] GAP 442 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082(40) 저장 P_DMF0082_SAVE_MAIN_DATA 의 DM_PLN_CFM_MKT_DEMAND_PLAN 0 저장 처리를 AS-IS 와 같게 4줄 바꾼다.
--       구: 수량 0 저장 시 5종(MKT_AMT_KRW/LOC · MKT_FCST · VMI_In_Req · SCM_FCST) 원장 행을 삭제 → 누가 언제 0 으로 바꿨는지 남지 않음.
--       신: 삭제는 금액 2종(MKT_AMT_KRW/LOC)만. 수요 3종의 0 은 기존 행 QTY 0 수정(최종 변경자·일시 갱신). 없는 행에 0 은 추가하지 않음.
--       AS-IS 근거: DMF0082_SAVE_MAIN_DATA L1917~1945 MERGE (MATCHED+QTY0+MKT_AMT_* DELETE / MATCHED UPDATE / NOT MATCHED+QTY<>0 INSERT).
-- 범위: 저장 SP 4곳(D1·D2 Phase1 DELETE · M1 MERGE 소스 · M2 MERGE INSERT 조건). 81 경로 · 조회 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 SAVE_MAIN_DATA 구간의 ASCII 구 줄 4줄을 각각 신 블록으로 치환하고 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 구 줄 4개 중 하나라도 구간 안 1건이 아니면 중단(원문 무변경) · 조립 길이 불일치 시 중단
--       · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 13:18:04) — 40 EATON_01 2027-12-27 100 저장 → 0 저장: MKT_FCST 행 QTY 0 유지 · MKT_AMT_KRW/LOC 삭제 (AS-IS 동일).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_s0    PLS_INTEGER;
    v_s1    PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_e     PLS_INTEGER;
    v_end   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'GAP442 2026-10-15';
    c_old1 CONSTANT VARCHAR2(400) :=   -- D1 Phase1 DELETE 대상 구 줄 (ASCII)
        '    WHERE A.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'', ''MKT_FCST'', ''VMI_In_Req'', ''SCM_FCST'')' || CHR(10);
    c_new1 CONSTANT VARCHAR2(4000) :=   -- D1 Phase1 DELETE 대상 신 블록 (사내 적용본과 동일 문구)
        '    /* [GAP442 2026-10-15] 0 저장 시 원장 삭제 = 금액 2종(MKT_AMT_KRW/LOC)만 (AS-IS MERGE WHEN MATCHED AND QTY_PRICE=0 AND MEASURE IN(MKT_AMT_*) DELETE).' || CHR(10) ||
        '       구: 수요 3종(MKT_FCST/VMI_In_Req/SCM_FCST)까지 삭제 → 누가 언제 0 으로 바꿨는지 남지 않음. 수요 3종의 0 은 아래 MERGE 가 QTY 0 으로 수정. */' || CHR(10) ||
        '    WHERE A.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'')' || CHR(10);
    c_old2 CONSTANT VARCHAR2(400) :=   -- D2 Phase1 DELETE 내부 구 줄 (ASCII)
        '            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'', ''MKT_FCST'', ''VMI_In_Req'', ''SCM_FCST'')' || CHR(10);
    c_new2 CONSTANT VARCHAR2(4000) :=   -- D2 Phase1 DELETE 내부 신 블록 (사내 적용본과 동일 문구)
        '            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'')  --[GAP442 2026-10-15]' || CHR(10);
    c_old3 CONSTANT VARCHAR2(400) :=   -- M1 MERGE 소스 구 줄 (ASCII)
        '                 AND M.QTY_PRICE <> 0)' || CHR(10);
    c_new3 CONSTANT VARCHAR2(4000) :=   -- M1 MERGE 소스 신 블록 (사내 적용본과 동일 문구)
        '                 AND (M.QTY_PRICE <> 0 OR M.MEASURE IN (''MKT_FCST'', ''VMI_In_Req'', ''SCM_FCST'')))  --[GAP442 2026-10-15] AS-IS: 수요 3종 0 = 기존 행 QTY 0 수정' || CHR(10);
    c_old4 CONSTANT VARCHAR2(400) :=   -- M2 MERGE INSERT 조건 구 줄 (ASCII)
        '    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);' || CHR(10);
    c_new4 CONSTANT VARCHAR2(4000) :=   -- M2 MERGE INSERT 조건 신 블록 (사내 적용본과 동일 문구)
        '    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE)' || CHR(10) ||
        '    WHERE B.QTY_PRICE <> 0;  --[GAP442 2026-10-15] AS-IS: WHEN NOT MATCHED AND QTY_PRICE <> 0 (0 은 신규 행 만들지 않음)' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos > p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_s0  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA');
    IF NOT (v_s0 > 0 AND v_s0 < v_s1) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 저장 프로시저 위치 확인 불가 (SAVE_MAIN_DATA / GET_EXCEL_FORM_DATA). 원문 무변경');
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, CHR(10) || c_old1, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — D1 Phase1 DELETE 대상 구 줄이 SAVE_MAIN_DATA 구간에 ' || cnt(v_src, CHR(10) || c_old1, v_s0, v_s1) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    IF cnt(v_src, CHR(10) || c_old2, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — D2 Phase1 DELETE 내부 구 줄이 SAVE_MAIN_DATA 구간에 ' || cnt(v_src, CHR(10) || c_old2, v_s0, v_s1) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    IF cnt(v_src, CHR(10) || c_old3, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — M1 MERGE 소스 구 줄이 SAVE_MAIN_DATA 구간에 ' || cnt(v_src, CHR(10) || c_old3, v_s0, v_s1) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    IF cnt(v_src, CHR(10) || c_old4, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — M2 MERGE INSERT 조건 구 줄이 SAVE_MAIN_DATA 구간에 ' || cnt(v_src, CHR(10) || c_old4, v_s0, v_s1) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_new := v_src;
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_pos := DBMS_LOB.INSTR(v_new, CHR(10) || c_old1, v_s0) + 1;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_new1 || SUBSTR(v_new, v_pos + LENGTH(c_old1));
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_pos := DBMS_LOB.INSTR(v_new, CHR(10) || c_old2, v_s0) + 1;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_new2 || SUBSTR(v_new, v_pos + LENGTH(c_old2));
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_pos := DBMS_LOB.INSTR(v_new, CHR(10) || c_old3, v_s0) + 1;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_new3 || SUBSTR(v_new, v_pos + LENGTH(c_old3));
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_pos := DBMS_LOB.INSTR(v_new, CHR(10) || c_old4, v_s0) + 1;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_new4 || SUBSTR(v_new, v_pos + LENGTH(c_old4));
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 4
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + LENGTH(c_new1) - LENGTH(c_old1) + LENGTH(c_new2) - LENGTH(c_old2) + LENGTH(c_new3) - LENGTH(c_old3) + LENGTH(c_new4) - LENGTH(c_old4) THEN
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 4곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

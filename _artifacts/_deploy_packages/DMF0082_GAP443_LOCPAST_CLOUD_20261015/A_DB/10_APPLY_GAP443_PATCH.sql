-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 13:53:54 FETCHED=2026-10-15 13:58 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP443 2026-10-15] GAP 443 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 저장 P_DMF0082_SAVE_MAIN_DATA 파싱 직후에 블록 1개를 넣는다 — 화면·팝업 저장의 LOC 판가 중
--       이번 주 월요일 이전 일자를 버린다(KRW/USD·MKT_AMT 는 LOC 에서 확장되므로 함께 빠짐).
--       구: 월 칸 LOC 수정 시 당월 지난 주 일자(1일·지난 주 대표일)까지 저장 → 지난 주 판가·KRW·USD 환산이 바뀜.
--       AS-IS 근거: DMF0082_FcstNPrice_Mgmt.cs L7183~7199 (월 칸 LOC 분배가 이번 주 월요일 이전 일자 continue). FE 무변경.
-- 범위: 저장 SP 블록 1개 삽입. 행 삭제(ACTION='D') · Excel Upload 경로(SKIP_PARSE='Y') · 조회 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 SAVE_MAIN_DATA 구간의 ASCII 앵커(V_EDIT_CNT 집계 BEGIN 2줄) 바로 앞에 블록을 넣고
--       CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 구간 안 1건이 아니면 중단 · v_skip_parse 변수 부재 시 중단(원문 무변경)
--       · 조립 길이 불일치 시 중단 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 13:53:54) — 40 LOC 1.234 × 10/01·10/05·10/12·10/19·10/26 저장: 수정 전 5일 전부 → 수정 후 10/12 이후 3일만 (이번 주 월요일 10/12).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_s0     PLS_INTEGER;
    v_s1     PLS_INTEGER;
    v_pos    PLS_INTEGER;
    v_end    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)  := 'GAP443 2026-10-15';
    c_anchor CONSTANT VARCHAR2(200) := '    BEGIN' || CHR(10) || '        SELECT COUNT(1) INTO V_EDIT_CNT FROM SCM_MGR.GT_PRDM1_T_MAIN;' || CHR(10) || '';   -- ASCII 앵커 2줄 (SAVE_MAIN_DATA 구간 안 1건)
    c_block  CONSTANT VARCHAR2(4000) :=   -- 삽입 블록 (사내 적용본과 동일 문구)
        '    /* [GAP443 2026-10-15] 화면·팝업 저장의 LOC 판가 = 이번 주 월요일 이후 일자만 반영 (AS-IS DMF0082_FcstNPrice_Mgmt.cs L7183~7199' || CHR(10) ||
        '       월 칸 LOC 분배가 이번 주 월요일 이전 일자를 건너뜀 → 같은 규칙을 저장 SP 에 둔다, FE 무변경).' || CHR(10) ||
        '       구: 월 칸 LOC 수정 시 당월 지난 주 일자(1일·지난 주 대표일)까지 저장 → 지난 주 판가·KRW·USD 환산이 바뀜.' || CHR(10) ||
        '       KRW/USD·MKT_AMT 는 아래에서 LOC 로부터 확장되므로 LOC 만 빼면 함께 빠진다. 행 삭제(ACTION=''D'')·Excel Upload 경로는 종전 그대로. */' || CHR(10) ||
        '    IF v_skip_parse = ''N'' THEN' || CHR(10) ||
        '        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN' || CHR(10) ||
        '         WHERE MEASURE  = ''LOC''' || CHR(10) ||
        '           AND ACTION  <> ''D''' || CHR(10) ||
        '           AND YYYYMMDD < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, ''MON'') - 7, ''YYYYMMDD'');   -- 이번 주 월요일 (아래 v_plan_start_yyyymmdd 와 같은 식)' || CHR(10) ||
        '    END IF;' || CHR(10) ||
        '' || CHR(10);
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
    IF cnt(v_src, c_anchor, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커가 SAVE_MAIN_DATA 구간에 ' || cnt(v_src, c_anchor, v_s0, v_s1) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    IF cnt(v_src, 'v_skip_parse', v_s0, v_s1) = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — SAVE_MAIN_DATA 에 v_skip_parse 변수 없음 (구세대 BODY). 00_PRECHECK L3 회신. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, c_anchor, v_s0);   -- 앵커 첫 글자 = 삽입 위치
    v_new := SUBSTR(v_src, 1, v_pos - 1) || c_block || SUBSTR(v_src, v_pos);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 1
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + LENGTH(c_block) THEN
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

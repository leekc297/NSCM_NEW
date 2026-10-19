-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-14 16:34:07 FETCHED=2026-10-14 16:36 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [E20261014-DMF0082RLXPRE] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 에서 조회조건 Project / Owner / Team 지정 시, 판가·수요를 적재하기 전에
--       품목 마스터 GTT(GT_DMF0082_TEMP_SITE_ITEM)를 선택 조건과 같은 (사업부, Sales Site, 품목) 묶음으로 미리 줄인다.
--       기존 필터 DELETE(Project/Owner/Team)는 그대로 남아 최종 결과는 동일하고, 적재·삭제량만 줄어든다.
-- 배경: 클라우드 QA 실측(G01/G02 2026-10-14) — 81 Project 지정 시 판가 18만 행 적재(2.1s) 뒤 91% 삭제(1.4s).
--       45일 조회 중 81 Project 단독 중앙값 10s vs Project+SalesSite 2s.
-- 범위: 조회 SP 1곳에 블록 1개(36줄) 삽입. 원장 · 저장 · 메타 · FE · 권한 무변경. 조건 미지정 조회는 블록이 실행되지 않음.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 GET_MAIN_DATA 구간의 ASCII 앵커 줄
--         `    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;`
--       다음 줄(#TempSiteItem 만들기 종료 주석) 뒤에 블록을 넣고 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 구간 안 1건이 아니거나 기존 필터 DELETE 3종이 각 1건이 아니면 중단(원문 무변경)
--       · 조립 길이 불일치 시 중단 · 컴파일 오류 시 원문 자동 복원
-- ⚠ 99_ROLLBACK 은 이 파일과 같은 도구(같은 클라이언트)로 실행할 것 — 블록 안 한글 주석을 같은 방식으로 비교한다.
-- 사내 ZIOUI1 적용 완료 2026-10-14 16:34:07 (전후 비교 30케이스 29 PASS · 1건 = 측정 사이 원장 변경, 코드 미실행 경로).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_ins   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261014-DMF0082RLXPRE';
    c_anchor CONSTANT VARCHAR2(200) :=   -- ASCII 앵커 (GET_MAIN_DATA 구간 안 1건 · BODY 전체 2건)
        '    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;' || CHR(10);
    c_block CONSTANT VARCHAR2(32767) :=   -- 삽입 블록 (사내 적용본과 동일 문구)
        '' || CHR(10) ||
        '    /* [E20261014-DMF0082RLXPRE] 조회조건 Project / Owner / Team 완화 선행축소 (사용자 승인 2026-10-14 "A. 사내에 적용")' || CHR(10) ||
        '       필터는 아래 L3692(Project) · L3699(Owner) · L3724(Team) 에서 적재 뒤 DELETE 로만 걸려, 81 Project 지정 시' || CHR(10) ||
        '       판가 18만 행을 적재했다가 91% 를 지웠다(클라우드 QA INSERT 2.1s + DELETE 1.4s).' || CHR(10) ||
        '       선택 조건을 만족하는 행이 하나라도 있는 (DIV, SCM_SITE_ID, ITEM_ID) 는 프로젝트가 달라도 전부 남기고 나머지만 지운다.' || CHR(10) ||
        '       - 프로젝트 단위로 줄이지 않는 이유: CURRENCY 3차 MERGE(키 DIV+SITE+ITEM+DOM_EXP+FCST_TYPE)가 다른 프로젝트의' || CHR(10) ||
        '         LOC 통화를 참조한다. 필터 전 계산의 최대 범위가 (DIV, SITE, ITEM) 이므로 그 단위로 남기면 생존 행 값이 같다.' || CHR(10) ||
        '       - 판정식 = 기존 필터 DELETE 의 생존 조건 그대로(NVL(x,'' '') NOT IN 토큰 이 참이 아닌 행 = 토큰 일치 OR 토큰에 NULL).' || CHR(10) ||
        '         OWNER·DEPT_ID 는 적재 arm 이 C.OWNER·C.DEPT_ID 를 그대로 투영하므로 이 GTT 값으로 판정한다.' || CHR(10) ||
        '       - 아래 기존 필터 DELETE 는 그대로 둔다 → 최종 결과 동일, 적재·삭제량만 줄어든다. */' || CHR(10) ||
        '    IF (p_project_code IS NOT NULL AND p_project_code <> ''ALL'')' || CHR(10) ||
        '       OR (p_owner IS NOT NULL AND p_owner <> ''ALL'')' || CHR(10) ||
        '       OR (p_team_id IS NOT NULL AND p_team_id <> ''ALL'') THEN' || CHR(10) ||
        '        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '        WHERE  (C.DIVISION_ID, C.SCM_SITE_ID, C.ITEM_ID) NOT IN (' || CHR(10) ||
        '                   SELECT K.DIVISION_ID, K.SCM_SITE_ID, K.ITEM_ID' || CHR(10) ||
        '                   FROM   SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM K' || CHR(10) ||
        '                   WHERE  K.DIVISION_ID IS NOT NULL' || CHR(10) ||
        '                   AND    K.SCM_SITE_ID IS NOT NULL' || CHR(10) ||
        '                   AND    K.ITEM_ID     IS NOT NULL' || CHR(10) ||
        '                   AND    (   NOT (p_project_code IS NOT NULL AND p_project_code <> ''ALL'')' || CHR(10) ||
        '                           OR EXISTS (SELECT 1' || CHR(10) ||
        '                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T' || CHR(10) ||
        '                                      WHERE  T.PARAM_NM = ''p_project_code''' || CHR(10) ||
        '                                      AND    (T.TOKEN = NVL(K.PROJECT_CODE, '' '') OR T.TOKEN IS NULL)))' || CHR(10) ||
        '                   AND    (   NOT (p_owner IS NOT NULL AND p_owner <> ''ALL'')' || CHR(10) ||
        '                           OR EXISTS (SELECT 1' || CHR(10) ||
        '                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T' || CHR(10) ||
        '                                      WHERE  T.PARAM_NM = ''p_owner''' || CHR(10) ||
        '                                      AND    (T.TOKEN = NVL(K.OWNER, '' '') OR T.TOKEN IS NULL)))' || CHR(10) ||
        '                   AND    (   NOT (p_team_id IS NOT NULL AND p_team_id <> ''ALL'')' || CHR(10) ||
        '                           OR EXISTS (SELECT 1' || CHR(10) ||
        '                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T' || CHR(10) ||
        '                                      WHERE  T.PARAM_NM = ''p_team_id''' || CHR(10) ||
        '                                      AND    (T.TOKEN = NVL(K.DEPT_ID, '' '') OR T.TOKEN IS NULL))));' || CHR(10) ||
        '    END IF;' || CHR(10);
    c_flt1 CONSTANT VARCHAR2(100) := 'WHERE  NVL(PROJECT_CODE, '' '') NOT IN (';
    c_flt2 CONSTANT VARCHAR2(100) := 'WHERE  NVL(OWNER, '' '') NOT IN (';
    c_flt3 CONSTANT VARCHAR2(100) := 'WHERE  NVL(DEPT_ID, '' '') NOT IN (';
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
    v_src  := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_main := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_cur  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    IF NOT (v_main > 0 AND v_main < v_cur) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 위치 확인 불가 (GET_MAIN_DATA / _CURRENT). 원문 무변경');
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anchor, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커가 GET_MAIN_DATA 구간에 ' || cnt(v_src, c_anchor, v_main, v_cur) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    IF cnt(v_src, c_flt1, v_main, v_cur) <> 1 OR cnt(v_src, c_flt2, v_main, v_cur) <> 1 OR cnt(v_src, c_flt3, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — 기존 Project/Owner/Team 필터 DELETE 가 GET_MAIN_DATA 구간에 각 1건이 아님. 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, c_anchor, v_main);
    v_ins := DBMS_LOB.INSTR(v_src, CHR(10), v_pos + LENGTH(c_anchor));   -- 앵커 다음 줄(#TempSiteItem 만들기 종료) 끝
    IF v_ins = 0 OR v_ins > v_cur THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 삽입 위치 확인 불가. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_ins) || c_block || SUBSTR(v_src, v_ins + 1);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 1
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + LENGTH(c_block) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

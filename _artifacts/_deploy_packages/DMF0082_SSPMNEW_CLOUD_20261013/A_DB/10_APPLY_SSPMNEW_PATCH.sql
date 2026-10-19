-- 10_APPLY — [E20261013-DMF0082SSPMNEW] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0082_SAVE_MAIN_DATA 검증 #5(Site/Item Master) 바로 뒤에 5-1 신설 —
--       **신규 행(ACTION='I')** 은 Sales Site Project Model 마스터(SCM_MST_SITE_ITEM) 에 Division·Project·Sales Site·Model 4키가
--       유효(VALID_YN='Y')하게 등록돼 있어야 저장된다. 없으면 검증 실패 메시지로 저장 차단.
--       기존 행 수정·삭제는 종전대로(#5 = 3키). Project 빈값 표기('-'·'/'·공백)는 같은 값으로 본다.
-- 배경: 종전 #5·#17 은 AS-IS 와 같이 Project 를 보지 않아, 다른 Project 로만 등록된 Sales Site-Model 조합도 신규 입력됐다 (사용자 요청 2026-10-13).
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 #5 종료 표시 뒤에 블록만 삽입 후 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-13 00:20:48 (같은 블록 · 검증 9케이스 + 저장 SP 실호출 차단 확인). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0082SSPMNEW';
    c_old   CONSTANT VARCHAR2(32767) :=   -- 검증 #5 종료 표시 3줄 (원문)
        '    --==========================================================================================================================' || CHR(10) ||
        '    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)' || CHR(10) ||
        '    --==========================================================================================================================' || CHR(10);
    c_new   CONSTANT VARCHAR2(32767) :=   -- 원문 3줄 + 5-1 블록
        '    --==========================================================================================================================' || CHR(10) ||
        '    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)' || CHR(10) ||
        '    --==========================================================================================================================' || CHR(10) ||
        '' || CHR(10) ||
        '    --==========================================================================================================================' || CHR(10) ||
        '    -- 5-1. 신규 행(ACTION=''I'') : Sales Site Project Model(SSPM) 4키 등록 여부 확인 (START)   --[E20261013-DMF0082SSPMNEW]' || CHR(10) ||
        '    --   사용자 요청(2026-10-13): 신규 ROW 추가·저장 시 SSPM 기준으로 검증. 대상 = 신규 행만(사용자 확정).' || CHR(10) ||
        '    --   위 #5 는 AS-IS 와 같이 Division+Sales Site+Model 3키만 본다(Project 미검사) — 그래서 다른 Project 로만' || CHR(10) ||
        '    --   등록된 Sales Site-Model 조합도 신규 입력됐다. 신규 행은 마스터(SCM_MST_SITE_ITEM) PK 4키' || CHR(10) ||
        '    --   (Division·Project·Sales Site·Model)가 유효(VALID_YN=''Y'')하게 등록돼 있어야 한다.' || CHR(10) ||
        '    --   기존 행 수정(''M'')·삭제(''D'')는 종전대로 #5 만 적용 — AS-IS 대비 신규 행 한정 의도적 강화.' || CHR(10) ||
        '    --==========================================================================================================================' || CHR(10) ||
        '    DECLARE' || CHR(10) ||
        '        v_sspm_new VARCHAR2(1000 CHAR);' || CHR(10) ||
        '    BEGIN' || CHR(10) ||
        '        BEGIN' || CHR(10) ||
        '            SELECT ''Project : ''               || A.PROJECT_CODE' || CHR(10) ||
        '                || CHR(10) || ''Sales Site : '' || A.SCM_SITE_ID' || CHR(10) ||
        '                || CHR(10) || ''Model : ''      || A.ITEM_ID' || CHR(10) ||
        '            INTO   v_sspm_new' || CHR(10) ||
        '            FROM   SCM_MGR.GT_PRDM1_T_MAIN A' || CHR(10) ||
        '            WHERE  A.ACTION = ''I''' || CHR(10) ||
        '              AND  NOT EXISTS (SELECT 1' || CHR(10) ||
        '                               FROM   SCM_MGR.SCM_MST_SITE_ITEM Z' || CHR(10) ||
        '                               WHERE  Z.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '                                 AND  Z.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '                                 AND  Z.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '                                 AND  Z.VALID_YN     = ''Y''' || CHR(10) ||
        '                                 -- Project 빈값 표기는 같은 값으로 본다: 마스터는 ''-''(기존)·''/''(신규 기본값), 스테이징 기본값은 ''-''.' || CHR(10) ||
        '                                 --   표기만 다른 것을 미등록으로 막지 않기 위함 (실값끼리는 등호 그대로).' || CHR(10) ||
        '                                 AND  (   Z.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '                                       OR (    NVL(TRIM(Z.PROJECT_CODE), ''/'') IN (''-'', ''/'')' || CHR(10) ||
        '                                           AND NVL(TRIM(A.PROJECT_CODE), ''/'') IN (''-'', ''/''))))' || CHR(10) ||
        '            ORDER  BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '            FETCH  FIRST 1 ROWS ONLY;' || CHR(10) ||
        '        EXCEPTION WHEN NO_DATA_FOUND THEN v_sspm_new := NULL;' || CHR(10) ||
        '        END;' || CHR(10) ||
        '' || CHR(10) ||
        '        IF v_sspm_new IS NOT NULL THEN' || CHR(10) ||
        '            V_LOG_TYPE    := ''INVALID'';' || CHR(10) ||
        '            V_DESCRIPTION := v_sspm_new || CHR(10) || CHR(10)' || CHR(10) ||
        '                          || ''Sales Site Project Model 에 등록되지 않은 조합입니다.'' || CHR(10)' || CHR(10) ||
        '                          || ''Sales Site Project Model 에 등록 후 입력하시기 바랍니다.'';' || CHR(10) ||
        '            RAISE e_validation_error;' || CHR(10) ||
        '        END IF;' || CHR(10) ||
        '    END;' || CHR(10) ||
        '    --==========================================================================================================================' || CHR(10) ||
        '    -- 5-1. 신규 행(ACTION=''I'') : Sales Site Project Model(SSPM) 4키 등록 여부 확인 (END)' || CHR(10) ||
        '    --==========================================================================================================================' || CHR(10);
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
    IF cnt(v_src, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 검증 #5 종료 앵커 매칭 ' || cnt(v_src, c_old) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (1 기대)');
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

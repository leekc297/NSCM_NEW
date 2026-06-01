--==============================================================================
-- 54_DMF0043_GET_MAIN_SPREAD_TITLE_OpenRC1_RootFix.sql
--
-- 사고: DMF0043 조회 시 데이터 0건 (BE 로그 EXCEPTION=NULL, o_rc1=[]).
-- 원인: DMF0043_GET_MAIN_SPREAD_TITLE SP 의 default 분기 (v_user_col_cnt=0)
--       가 22-컬럼 default titleset 을 OPEN O_RC3 FOR 로 열고 있음.
--       그러나 caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) 는 v_rc1 (O_RC1) 만 FETCH.
--       → caller 가 빈 cursor 를 fetch → GT_DMF0043_TITLE 0건
--       → 동적 PIVOT 컬럼 0개 → 최종 결과 cursor empty.
--
-- 49/50/51 patch 는 fallback empty OPEN 만 추가 (root cause 미해결).
--
-- 본 patch:
--   line 96 의  OPEN O_RC3 FOR   →   OPEN O_RC1 FOR
--   (default 분기 22-컬럼 result set 을 O_RC1 에 OPEN — caller fetch 와 일치)
--
-- 작성: 2026-06-01 / minyonglee1 — 룰 21 §10.2 화면 0건 5단계 진단 적용 결과
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SP body 추출 + O_RC3 -> O_RC1 root fix ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_old VARCHAR2(100) := '	IF v_user_col_cnt = 0 THEN' || CHR(10) || '		OPEN O_RC3 FOR';
    v_new VARCHAR2(100) := '	IF v_user_col_cnt = 0 THEN' || CHR(10) || '		OPEN O_RC1 FOR';
    v_cnt_before PLS_INTEGER;
    v_cnt_after  PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- pre-check : v_old 패턴 1회 등장 확인
    v_cnt_before := REGEXP_COUNT(v_src, 'OPEN\s+O_RC3\s+FOR');
    DBMS_OUTPUT.PUT_LINE('OPEN O_RC3 FOR count BEFORE: ' || v_cnt_before);

    v_patched := REPLACE(v_src, v_old, v_new);

    v_cnt_after := REGEXP_COUNT(v_patched, 'OPEN\s+O_RC3\s+FOR');
    DBMS_OUTPUT.PUT_LINE('OPEN O_RC3 FOR count AFTER : ' || v_cnt_after);

    IF v_cnt_before = v_cnt_after THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Patch failed: pattern not matched. line 95-96 의 IF v_user_col_cnt = 0 THEN / OPEN O_RC3 FOR 들여쓰기 변경 가능성. 수동 확인 필요.');
    END IF;

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('DMF0043_GET_MAIN_SPREAD_TITLE patched: default branch now opens O_RC1');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : 컴파일 상태 + OPEN 위치 ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_MAIN_SPREAD_TITLE';
SELECT LINE, TEXT FROM USER_SOURCE
 WHERE NAME='DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE='PROCEDURE'
   AND REGEXP_LIKE(TEXT, 'OPEN\s+O_RC[123]\s+FOR', 'i')
 ORDER BY LINE;

PROMPT === BLOCK 3 : Caller 실행 검증 (GT_TITLE 적재 카운트) ===
DECLARE
  v_rc SYS_REFCURSOR;
  v_title_cnt NUMBER;
  v_temp_cnt  NUMBER;
  v_data_cnt  NUMBER;
BEGIN
  -- 세션 GTT clear (다른 세션 영향 회피)
  DELETE FROM GT_DMF0043_TITLE;
  DELETE FROM GT_DMF0043_TEMP;
  DELETE FROM GT_DMF0043_TEMP2;
  DELETE FROM GT_DMF0043_TEMP3;
  DELETE FROM GT_DMF0043_DATA_TABLE;

  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2023','8','ALL','N','minyonglee1','',v_rc);

  SELECT COUNT(*) INTO v_title_cnt FROM GT_DMF0043_TITLE;
  SELECT COUNT(*) INTO v_temp_cnt  FROM GT_DMF0043_TEMP;
  SELECT COUNT(*) INTO v_data_cnt  FROM GT_DMF0043_DATA_TABLE;

  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TITLE      = ' || v_title_cnt || ' rows (expect 14+)');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TEMP       = ' || v_temp_cnt  || ' rows (expect > 0)');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_DATA_TABLE = ' || v_data_cnt  || ' rows (expect > 0)');
  BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CALLER ERROR: ' || SQLERRM);
END;
/

COMMIT;
EXIT;

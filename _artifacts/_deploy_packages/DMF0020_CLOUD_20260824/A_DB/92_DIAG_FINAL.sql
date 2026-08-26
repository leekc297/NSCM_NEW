-- ============================================================================================
-- DMF0020 / 92_DIAG_FINAL.sql — 최종 결과 커서 단계 판정 (91 의 후속)
--
--   91 결과 (2026-08-24 클라우드 실측)
--     원천 마스터·GTT 단계는 **전부 정상**이었다. 오히려 사내보다 많다.
--       GT_FTPR_TMPOUTPUTALL   사내 419,687  ->  클라우드 452,925
--       SCM_MST_SITE_ITEM(82)  사내  39,538  ->  클라우드  39,572
--     => 데이터 이관 누락이 아니다. 남은 구간은 **최종 PIVOT 결과 커서** 하나뿐이다.
--
--   이 스크립트가 가르는 것
--     SP 를 직접 호출해 o_rc1 의 **실제 행수**를 센다.
--       ~10,500 행이면  -> SP 는 정상. 원인은 BE/FE·메타 (화면 960 은 다른 이유)
--          960 행이면  -> SP 최종 SELECT 안 (PIVOT 컬럼 목록 / titleSet / measure) 이 원인
--
--   ⚠ 91 과 같은 세션일 필요는 없다(SP 를 다시 실행한다).
--   ⚠ 조회 전용. 원장을 바꾸지 않는다.
--   ⚠ UI_USER 를 화면에서 조회한 계정으로 바꿀 것.
-- ============================================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
DEFINE UI_USER = 'minyonglee1'

PROMPT ############ 6. 최종 결과 커서 행수·컬럼수 ############
PROMPT   EXPECTED(사내) : 10,524행 / 102컬럼 (고정 28 + 피벗 74)

DECLARE
    v_rc1   SYS_REFCURSOR;
    v_rc2   SYS_REFCURSOR;
    v_cur   NUMBER;
    v_ncol  PLS_INTEGER;
    v_desc  DBMS_SQL.DESC_TAB;
    v_rows  PLS_INTEGER := 0;
    v_piv   PLS_INTEGER := 0;
BEGIN
    SCM_MGR.PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE(
        '82', 'ALL', 'ALL', 'ALL', 'ALL', 'ALL', 'ALL', 'ALL', 'ALL',
        '20260701', '20270630', 'ALL',
        '&UI_USER', '&UI_USER', 'ALL', 'N', 'N', 'CURRENT', v_rc1, v_rc2);

    v_cur := DBMS_SQL.TO_CURSOR_NUMBER(v_rc1);
    DBMS_SQL.DESCRIBE_COLUMNS(v_cur, v_ncol, v_desc);
    FOR i IN 1 .. v_ncol LOOP
        IF SUBSTR(v_desc(i).col_name, 1, 2) IN ('W_', 'M_', 'D_') THEN
            v_piv := v_piv + 1;
        END IF;
    END LOOP;
    WHILE DBMS_SQL.FETCH_ROWS(v_cur) > 0 LOOP
        v_rows := v_rows + 1;
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(v_cur);
    BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('o_rc1 행수   = ' || v_rows  || '        (사내 10524)');
    DBMS_OUTPUT.PUT_LINE('o_rc1 컬럼수 = ' || v_ncol  || '        (사내 102)');
    DBMS_OUTPUT.PUT_LINE('  피벗 컬럼  = ' || v_piv   || '        (사내 74)');
    DBMS_OUTPUT.PUT_LINE('  고정 컬럼  = ' || (v_ncol - v_piv) || '        (사내 28)');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
    IF v_rows BETWEEN 9000 AND 12000 THEN
        DBMS_OUTPUT.PUT_LINE('판정: SP 는 정상이다. 화면 960 의 원인은 BE/FE 또는 메타에 있다.');
        DBMS_OUTPUT.PUT_LINE('      -> 7 번 섹션(컬럼 메타)과 화면 개발자도구 Network 응답 건수를 확인할 것.');
    ELSIF v_rows < 2000 THEN
        DBMS_OUTPUT.PUT_LINE('판정: SP 최종 SELECT 가 원인이다.');
        DBMS_OUTPUT.PUT_LINE('      -> 8 번 섹션(PIVOT 원천)에서 어느 축이 빠졌는지 본다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('판정: 중간값이다. 8 번 섹션을 함께 확인할 것.');
    END IF;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SP 오류: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT
PROMPT ############ 7. 화면 컬럼 메타 (960 이 컬럼 문제일 가능성) ############
PROMPT   EXPECTED(사내) : SHEET_COLUMNS 77 / 그중 Sales Price 시트 · VISIBLE Y
SELECT SHEET_NAME, COUNT(*) AS CNT,
       SUM(CASE WHEN VISIBLE = 'Y' THEN 1 ELSE 0 END) AS VISIBLE_Y
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0020'
 GROUP BY SHEET_NAME ORDER BY 1;

PROMPT
PROMPT ############ 8. PIVOT 원천 축 (SP 실행 직후 같은 세션에서) ############
PROMPT   ⚠ 6 번 블록과 **같은 세션**이어야 값이 남아 있다
WITH exp (ORD, K, V) AS (
  SELECT 1, 'TMPOUTPUTALL 전체'              , 419687 FROM DUAL UNION ALL
  SELECT 2, 'TMPOUTPUTALL MEASURE=LOC'       , 139679 FROM DUAL UNION ALL
  SELECT 3, 'TMPOUTPUTALL DISTINCT YYYYMMDD' ,     62 FROM DUAL UNION ALL
  SELECT 4, 'TMPOUTPUTALL DISTINCT 키(LOC)'  ,   2538 FROM DUAL UNION ALL
  SELECT 5, 'TMPOUTPUTOMISSION DISTINCT YYYYMMDD', 62 FROM DUAL),
act (K, V) AS (
  SELECT 'TMPOUTPUTALL 전체'        , COUNT(*) FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL
  UNION ALL SELECT 'TMPOUTPUTALL MEASURE=LOC', COUNT(*) FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL WHERE MEASURE='LOC'
  UNION ALL SELECT 'TMPOUTPUTALL DISTINCT YYYYMMDD', COUNT(DISTINCT YYYYMMDD) FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL
  UNION ALL SELECT 'TMPOUTPUTALL DISTINCT 키(LOC)', COUNT(*) FROM
      (SELECT DISTINCT DIVISION_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, MEASURE
         FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL WHERE MEASURE='LOC')
  UNION ALL SELECT 'TMPOUTPUTOMISSION DISTINCT YYYYMMDD', COUNT(DISTINCT YYYYMMDD)
         FROM SCM_MGR.GT_FTPR_TMPOUTPUTOMISSION)
SELECT e.ORD, e.K AS 축, e.V AS EXPECTED_사내, a.V AS ACTUAL_클라우드,
       CASE WHEN a.V = 0 THEN '⛔ 비어있음'
            WHEN a.V < e.V * 0.5 THEN '⛔ 절반 미만'
            ELSE 'OK' END AS 판정
  FROM exp e JOIN act a ON a.K = e.K ORDER BY e.ORD;

PROMPT
PROMPT ############ 9. MEASURE 분포 (피벗 축) ############
PROMPT   EXPECTED(사내) : KRW=139679 LOC=139679 RTF_SYS_RP=650 USD=139679
SELECT MEASURE, COUNT(*) AS CNT
  FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL GROUP BY MEASURE ORDER BY 2 DESC;

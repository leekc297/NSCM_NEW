-- [E20261009-GRPBYFIX] 02_VERIFY — 적용 후 검증 (조회 + 세션 내 GET 실행, 커밋 없음 · 마지막 ROLLBACK) · 생성 2026-10-09 · SCM_MGR 접속 후 파일 전체 실행(F5)
--   V1 상태/오류 · V2 4줄 원문(SELECT 2줄 = GROUP BY 2줄 식 동일) · V3 재현 SQL(오류 0·행수 무관) · V4 GET 프로시저 실행(사용자 파라미터 그대로, Current 와 SP_ 2분기)
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- V1
SELECT 'V1 | ' || object_type || ' ' || object_name || ' | ' || status || ' | ddl=' || TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS line
  FROM all_objects WHERE owner='SCM_MGR' AND object_name='PKG_DMF0020' ORDER BY object_type;
SELECT 'V1 ERR | L' || line || ' | ' || SUBSTR(REPLACE(text,CHR(10),' '),1,200) AS line
  FROM all_errors WHERE owner='SCM_MGR' AND name='PKG_DMF0020' AND type='PACKAGE BODY' ORDER BY sequence;

-- V2: 마커 줄 2 + SELECT 쪽 2 = 4줄, 식이 모두 NVL(NULLIF(RTRIM(A.CURRENCY),''), '/') 이어야 함 · 'V2 MISMATCH' 0행
SELECT 'V2 | L' || line || ' | ' || SUBSTR(TRIM(REPLACE(text,CHR(10),'')),1,90) AS line
  FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0020' AND type='PACKAGE BODY'
   AND (text LIKE '%[E20261009-GRPBYFIX]%' OR text LIKE '%NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'') AS CURRENCY%') ORDER BY line;
SELECT 'V2 MISMATCH | L' || line || ' | ' || SUBSTR(TRIM(REPLACE(text,CHR(10),'')),1,90) AS line
  FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0020' AND type='PACKAGE BODY'
   AND REGEXP_LIKE(text, 'NVL\(\s*A\.CURRENCY\s*,\s*''-''\s*\)') ORDER BY line;

-- V3: 오류 문장 재현(SELECT/GROUP BY 식 동일) — 오류 없이 끝나면 통과(행수는 데이터 의존)
SELECT 'V3 | rows=' || COUNT(*) AS line FROM (
  SELECT NVL(NULLIF(RTRIM(A.CURRENCY),''), '/') AS CURRENCY, SUM(A.QTY) AS QTY
    FROM SCM_MGR.DM_PLN_SALES_PLAN A
   WHERE A.DIVISION_ID = '40' AND A.MEASURE = 'RTF_SYS_RP' AND A.YYYYMMDD BETWEEN '20261001' AND '20270331'
   GROUP BY NVL(NULLIF(RTRIM(A.CURRENCY),''), '/'));

-- V4: GET 프로시저 실행 (사용자 오류 파라미터 그대로). 결과: 'V4 <분기> | OK rc1_rows=N | rc2=<CODE>,<MESSAGE>' · 오류면 'V4 <분기> | ERR ...'
DECLARE
    PROCEDURE run_one(p_vt IN VARCHAR2) IS
        rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR;
        c   INTEGER; n INTEGER; cnt INTEGER := 0; ncol INTEGER;
        dt  DBMS_SQL.DESC_TAB; v VARCHAR2(4000); v_code VARCHAR2(4000); v_msg VARCHAR2(4000);
    BEGIN
        SCM_MGR.PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE(
            '40','ALL','ALL','ALL','ALL','ALL','ALL','ALL','ALL','20261001','20270331','ALL',
            'minyonglee1','minyonglee1','ALL','N','N', p_vt, rc1, rc2);
        c := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
        DBMS_SQL.DESCRIBE_COLUMNS(c, ncol, dt);
        FOR i IN 1 .. ncol LOOP DBMS_SQL.DEFINE_COLUMN(c, i, v, 4000); END LOOP;
        LOOP n := DBMS_SQL.FETCH_ROWS(c); EXIT WHEN n = 0; cnt := cnt + n; END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        c := DBMS_SQL.TO_CURSOR_NUMBER(rc2);
        DBMS_SQL.DESCRIBE_COLUMNS(c, ncol, dt);
        FOR i IN 1 .. ncol LOOP DBMS_SQL.DEFINE_COLUMN(c, i, v, 4000); END LOOP;
        IF DBMS_SQL.FETCH_ROWS(c) > 0 THEN
            DBMS_SQL.COLUMN_VALUE(c, 1, v_code);
            IF ncol >= 2 THEN DBMS_SQL.COLUMN_VALUE(c, 2, v_msg); END IF;
        END IF;
        DBMS_SQL.CLOSE_CURSOR(c);
        DBMS_OUTPUT.PUT_LINE('V4 ' || p_vt || ' | OK rc1_rows=' || cnt || ' | rc2=' || v_code || ',' || v_msg);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('V4 ' || p_vt || ' | ERR ' || SUBSTR(SQLERRM, 1, 600));
    END;
BEGIN
    run_one('Current');
    -- SP_ 분기(5173행): 그 환경의 DM_PLN_SALES_PLAN_C 최신 버전 1건으로 실행 (없으면 SKIP)
    DECLARE v_ver VARCHAR2(100);
    BEGIN
        SELECT MAX(version_no) INTO v_ver FROM SCM_MGR.DM_PLN_SALES_PLAN_C WHERE division_id = '40' AND measure = 'RTF_SYS_RP' AND version_no LIKE 'SP_%';
        IF v_ver IS NULL THEN DBMS_OUTPUT.PUT_LINE('V4 SP_ | SKIP (DM_PLN_SALES_PLAN_C 에 div 40 SP_ 버전 없음)'); ELSE run_one(v_ver); END IF;
    END;
    ROLLBACK;
END;
/

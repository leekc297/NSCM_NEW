-- V01_CLOUD_RP2ROW — DMF0082 조회 시 같은 키가 실적/계획 2줄로 나오는 원인 확인 (클라우드 · SCM_MGR · 조회 전용 · 전체 F5)
--
-- 증상(클라우드 2026-10-27): 81 · BMW_US_SPA · A18BW2003 · APBMW48CL-B1-360 · FCA · Mass · E · WA00-P · KRW · Current · MKT FCST[R+P] 가 2줄
--   사내 ZIOUI1 은 이 품목 MKT_FCST 데이터가 없어 재현 불가 (81 4개 사이트 × 2계정 스캔 중복 0)
--
-- ★ 수정할 곳은 아래 D2 블록 맨 위 c_user (화면에서 2줄을 본 계정) 1곳뿐. 나머지는 증상 키 그대로.
--
-- 결과 보는 법 (DBMS_OUTPUT — SQL Developer: 보기 > DBMS 출력 창에서 연결 선택 / SQLcl·SQL*Plus: 그대로 출력)
--   D0  : 접속 DB · PKG_DMF0082 상태 · 관련 보완 마커가 클라우드 BODY 에 있는지 (사내 대비 세대 확인)
--   D1  : 그 계정의 화면 컬럼(Column Set 'C' · 필수 컬럼)
--   D2-1: 조회 결과(O_RC1)의 묶음 컬럼 목록 = 실제로 줄을 가르는 컬럼 전부 (화면에 안 보이는 컬럼 포함)
--   D2-2: 증상 키에 해당하는 결과 줄 수, 그리고 그 줄들 사이에 **값이 다른 컬럼** ← 원인 컬럼
--   D2-3: 피벗 직전 임시 테이블에서 같은 키의 실적(R, 당주 월요일 이전)/계획(P) 행이 값이 갈리는 컬럼과 각 값
--         ([값] 은 대괄호로 감싸 공백 ' ' · '-' · '/' · NULL 을 구분)
--   D3  : 원장 실값 — 실적(DM_PLN_SALES_PLAN_RESULT) / 계획(DM_PLN_MKT_FCST) 의 PLANT · CELL_PROD · CURRENCY · ATTRIBUTE10(AS From Site) 표기
-- 조회 프로시저는 원장을 바꾸지 않는다 (사용자 Column Set 이 없을 때만 기본값을 넣음 — 이 계정은 이미 있음). 마지막에 ROLLBACK.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250 PAGESIZE 500
SET DEFINE OFF

-- D0 접속 · 패키지 상태 · 보완 마커
SELECT 'D0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'D0' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY 2;
SELECT 'D0 마커' CHK, M.TAG, (SELECT COUNT(*) FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%' || M.TAG || '%') N
  FROM ( SELECT 'E20260825-CURRNORM' TAG FROM DUAL UNION ALL SELECT 'E20260825-AFSBLANK' FROM DUAL UNION ALL SELECT 'E20260901-CURRKEEP' FROM DUAL
         UNION ALL SELECT 'E20260918-KEYCOLGRAIN' FROM DUAL UNION ALL SELECT 'E20260918-KEYCOLGRAIN2' FROM DUAL UNION ALL SELECT 'E20261012-DMF0082MANDCOL' FROM DUAL
         UNION ALL SELECT 'E20261013-DMF0082MANDRET' FROM DUAL UNION ALL SELECT 'E20261013-DMF0082AFSSHARE' FROM DUAL UNION ALL SELECT 'E20261014-DMF0082VMICURR' FROM DUAL
         UNION ALL SELECT 'E20261026-DMF0082-MKTAMTAUDIT' FROM DUAL UNION ALL SELECT 'E20261027-DMF0082LASTUPD' FROM DUAL ) M
 ORDER BY 2;

-- D1 ~ D2 (한 세션 안에서 조회 프로시저 호출 → 결과 · 임시 테이블 분석)
DECLARE
    c_user   CONSTANT VARCHAR2(100) := 'minyonglee1';   -- ★ 화면에서 2줄을 본 계정으로 바꾼다
    c_group  CONSTANT VARCHAR2(100) := 'ADMIN';         -- 사용자 그룹 (편집 가능 여부 EDIT_FLAG 에만 영향)
    c_div    CONSTANT VARCHAR2(10)  := '81';
    c_from   CONSTANT VARCHAR2(8)   := '20260101';      -- 조회 기간 (실적 · 계획 모두 걸치게)
    c_to     CONSTANT VARCHAR2(8)   := '20261231';
    c_site   CONSTANT VARCHAR2(100) := 'BMW_US_SPA';
    c_item   CONSTANT VARCHAR2(100) := 'APBMW48CL-B1-360';
    c_meas   CONSTANT VARCHAR2(100) := 'MKT_FCST';
    c_bound  CONSTANT VARCHAR2(8)   := TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD');   -- 실적/계획 경계 = 당주 월요일
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    v_cur    INTEGER;
    v_cnt    INTEGER;
    v_desc   DBMS_SQL.DESC_TAB2;
    v_val    VARCHAR2(4000);
    v_grain  VARCHAR2(32767);
    v_line   VARCHAR2(32767);
    v_rows   PLS_INTEGER := 0;
    v_hit    PLS_INTEGER := 0;
    v_n      PLS_INTEGER;
    v_list   VARCHAR2(4000);
    v_col    VARCHAR2(130);
    v_src    VARCHAR2(4000);
    TYPE t_row IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    TYPE t_rows IS TABLE OF t_row INDEX BY PLS_INTEGER;
    v_hits   t_rows;
    i_item   PLS_INTEGER;
    i_meas   PLS_INTEGER;
    FUNCTION is_meas(p VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN p = 'QTY' OR SUBSTR(p, 1, 2) IN ('D_', 'W_', 'M_');
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('== D1 화면 컬럼 (' || c_user || ')');
    v_line := NULL;
    FOR r IN (SELECT COLUMN_NAME FROM SCM_MST_TITLESET_USER
               WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' AND USER_ID = c_user AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               ORDER BY SORT_ORDER_NO) LOOP
        v_line := v_line || r.COLUMN_NAME || ', ';
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('   Column Set C : ' || NVL(v_line, '(없음)'));
    v_line := NULL;
    FOR r IN (SELECT COLUMN_NAME FROM SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' AND VALID_YN = 'Y' AND USER_SELECTABLE_FLAG = 'N' AND VISIBLE_FLAG = 'Y'
                 AND (DIVISION_ID IS NULL OR INSTR(',' || DIVISION_ID || ',', ',' || c_div || ',') > 0)
               ORDER BY SORT_ORDER_NO) LOOP
        v_line := v_line || r.COLUMN_NAME || ', ';
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('   필수 표시    : ' || NVL(v_line, '(없음)'));

    -- 조회 프로시저 호출 (FE 와 같은 16 인자 순서: 사업부, 팀, 고객, BizType, 시작, 종료, Sales Site, 품목, 버전, 수량0포함, 사용자, 그룹, Plant, Project, Owner, Sender)
    PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(c_div, 'ALL', 'ALL', 'ALL', c_from, c_to, c_site, c_item, 'Current', 'N',
                                         c_user, c_group, 'ALL', 'ALL', 'ALL', 'ALL',
                                         rc1, rc2, rc3, rc4, rc5, rcr);

    v_cur := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
    DBMS_SQL.DESCRIBE_COLUMNS2(v_cur, v_cnt, v_desc);
    FOR i IN 1 .. v_cnt LOOP
        IF NOT is_meas(v_desc(i).col_name) THEN
            DBMS_SQL.DEFINE_COLUMN(v_cur, i, v_val, 4000);
            v_grain := v_grain || v_desc(i).col_name || ', ';
            IF v_desc(i).col_name = 'ITEM_ID' THEN i_item := i; END IF;
            IF v_desc(i).col_name = 'MEASURE' THEN i_meas := i; END IF;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('== D2-1 결과 묶음 컬럼 (화면 숨김 포함 · 이 값이 하나라도 다르면 줄이 갈린다)');
    DBMS_OUTPUT.PUT_LINE('   ' || v_grain);

    WHILE DBMS_SQL.FETCH_ROWS(v_cur) > 0 LOOP
        v_rows := v_rows + 1;
        DBMS_SQL.COLUMN_VALUE(v_cur, i_item, v_val);
        IF v_val = c_item THEN
            DBMS_SQL.COLUMN_VALUE(v_cur, i_meas, v_val);
            IF v_val = c_meas THEN
                v_hit := v_hit + 1;
                FOR i IN 1 .. v_cnt LOOP
                    IF NOT is_meas(v_desc(i).col_name) THEN
                        DBMS_SQL.COLUMN_VALUE(v_cur, i, v_val);
                        v_hits(v_hit)(i) := CASE WHEN v_val IS NULL THEN '<NULL>' ELSE '[' || v_val || ']' END;
                    END IF;
                END LOOP;
            END IF;
        END IF;
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(v_cur);
    DBMS_OUTPUT.PUT_LINE('== D2-2 결과 전체 ' || v_rows || '줄 · 증상 키(' || c_item || ' / ' || c_meas || ') ' || v_hit || '줄');
    IF v_hit > 1 THEN
        FOR i IN 1 .. v_cnt LOOP
            IF NOT is_meas(v_desc(i).col_name) THEN
                v_line := NULL; v_n := 0;
                FOR h IN 1 .. v_hit LOOP
                    IF h > 1 AND v_hits(h)(i) <> v_hits(1)(i) THEN v_n := v_n + 1; END IF;
                    v_line := v_line || ' 줄' || h || '=' || v_hits(h)(i);
                END LOOP;
                IF v_n > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('   ★ 값이 다른 컬럼 ' || RPAD(v_desc(i).col_name, 26) || v_line);
                END IF;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('   (다른 컬럼이 없으면 = 묶음 컬럼 값은 같고 다른 이유로 2줄 → D2-3 회신)');
    END IF;

    -- 피벗 직전 임시 테이블: 같은 키의 실적/계획 행 사이에서 값이 갈리는 컬럼 (수량 0 행은 결과에서 빠지므로 제외)
    DBMS_OUTPUT.PUT_LINE('== D2-3 피벗 직전 임시 테이블 GT_DMF0082_MF_SP · 키 = ' || c_site || ' / ' || c_item || ' / ' || c_meas || ' · R=' || c_bound || ' 이전, P=이후');
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_MF_SP WHERE SCM_SITE_ID = :1 AND ITEM_ID = :2 AND MEASURE = :3 AND QTY <> 0'
        INTO v_n USING c_site, c_item, c_meas;
    DBMS_OUTPUT.PUT_LINE('   대상 행 ' || v_n);
    FOR c IN (SELECT COLUMN_NAME, DATA_TYPE FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'GT_DMF0082_MF_SP'
                AND COLUMN_NAME NOT IN ('QTY', 'BUCKET_KEY', 'BUCKET_TYPE', 'YYYYMM', 'YYYYMMWW', 'WEEK_END_YN', 'MONTH_END_YN')
              ORDER BY COLUMN_ID) LOOP
        v_col := c.COLUMN_NAME;
        v_src := CASE WHEN c.DATA_TYPE = 'DATE' THEN 'TO_CHAR(' || v_col || ', ''YYYY-MM-DD HH24:MI:SS'')' ELSE 'TO_CHAR(' || v_col || ')' END;
        EXECUTE IMMEDIATE
            'SELECT COUNT(DISTINCT NVL2(SRC, ''['' || SRC || '']'', ''<NULL>'')),
                    LISTAGG(RP || '':'' || NVL2(SRC, ''['' || SRC || '']'', ''<NULL>'') || ''('' || N || ''행)'', '' | '' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY RP DESC, SRC)
               FROM ( SELECT RP, SRC, COUNT(*) N
                        FROM ( SELECT CASE WHEN BUCKET_KEY < :b THEN ''R'' ELSE ''P'' END RP, ' || v_src || ' SRC
                                 FROM SCM_MGR.GT_DMF0082_MF_SP
                                WHERE SCM_SITE_ID = :s AND ITEM_ID = :i AND MEASURE = :m AND QTY <> 0 )
                       GROUP BY RP, SRC )'
            INTO v_n, v_list USING c_bound, c_site, c_item, c_meas;
        IF v_n > 1 THEN
            DBMS_OUTPUT.PUT_LINE('   ★ ' || RPAD(v_col, 26) || CASE WHEN INSTR(', ' || v_grain, ', ' || v_col || ',') > 0 THEN '[묶음 컬럼]  ' ELSE '[묶음 아님]  ' END || v_list);
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('   (묶음 아님 컬럼은 줄을 가르지 않는다. 별칭: TEAM_ID=DEPT_ID · TEAM_NAME_KO=DEPT_NAME_KO · FORECAST_INFO_CELL_MODEL=CELL_MODEL · LAST_UPDATE_DATE=CREATE_DATE · BUCKET=SUN~SAT)');
    ROLLBACK;
END;
/

-- D3 원장 실값 (DUMP 로 '-' / '/' / ' ' 표기 구분)
SELECT 'D3 실적' CHK, R.MEASURE, R.FCST_TYPE, R.INCOTERMS, R.PROJECT_CODE
     , DUMP(R.PLANT_SITE_ID) PLANT, DUMP(R.CELL_PROD_SITE_ID) CELL_PROD, DUMP(R.CURRENCY) CURR, DUMP(R.ATTRIBUTE10) AFS
     , MIN(R.YYYYMMDD) F, MAX(R.YYYYMMDD) T, COUNT(*) N
  FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT R
 WHERE R.SCM_SITE_ID = 'BMW_US_SPA' AND R.ITEM_ID = 'APBMW48CL-B1-360' AND R.YYYYMMDD BETWEEN '20260101' AND '20261231'
 GROUP BY R.MEASURE, R.FCST_TYPE, R.INCOTERMS, R.PROJECT_CODE, DUMP(R.PLANT_SITE_ID), DUMP(R.CELL_PROD_SITE_ID), DUMP(R.CURRENCY), DUMP(R.ATTRIBUTE10)
 ORDER BY 2, 3, 4;
SELECT 'D3 계획' CHK, P.MEASURE, P.FCST_TYPE, P.INCOTERMS, P.PROJECT_CODE
     , DUMP(P.PLANT_SITE_ID) PLANT, DUMP(P.ATTRIBUTE10) AFS
     , MIN(P.YYYYMMDD) F, MAX(P.YYYYMMDD) T, COUNT(*) N
  FROM SCM_MGR.DM_PLN_MKT_FCST P
 WHERE P.SCM_SITE_ID = 'BMW_US_SPA' AND P.ITEM_ID = 'APBMW48CL-B1-360' AND P.YYYYMMDD BETWEEN '20260101' AND '20261231'
 GROUP BY P.MEASURE, P.FCST_TYPE, P.INCOTERMS, P.PROJECT_CODE, DUMP(P.PLANT_SITE_ID), DUMP(P.ATTRIBUTE10)
 ORDER BY 2, 3, 4;

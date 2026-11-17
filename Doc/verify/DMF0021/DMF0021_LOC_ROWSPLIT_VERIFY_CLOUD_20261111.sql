/* =====================================================================================================
   DMF0021 Sales Plan — Unit Price(LOC) 메저가 2개 Row 로 분리되는 현상 검증 쿼리 (클라우드용 · 조회 전용)
   작성 2026-11-11 · 기준 원문 = 사내 ZIOUI1 PKG_DMF0021 BODY (LAST_DDL 2026-11-04 14:48)

   [증상]  jaehun_cho / Division 81 조회 시 LOC 가 2 Row · minyonglee1 은 정상(1 Row)
   [확인 포인트]
     A. 개인화 저장분(SCM_MST_TITLESET_USER) — 행을 나누는 키 컬럼이 계정마다 다르다.
        SP 는 사용자 'C'(컬럼) 개인화로 GROUP BY 키(v_ColList)를 만든다 (PKG BODY L1406~1497).
        → 같은 데이터라도 키 컬럼에 FROM_SITE_ID / CELL_PROD_SITE_ID / CURRENCY / TEXT 등이 있으면 행이 나뉜다.
     B. 계획구간 LOC 생성 (PKG BODY L1199~1242, 81 = SCM_MST_FUTURE_PRICE 분기)
        RAW_DATA 를 (… CURRENCY, COMPANY_ID, YYYYMMDD, CELL_PROD_SITE_ID) DISTINCT 로 뽑아 단가를 붙인다.
        → 같은 품목이라도 메저별 CELL_PROD_SITE_ID(예: MKT_FCST='-' / RTF_SYS_RP='NA00-A')나
          CURRENCY 가 다르면 LOC 가 값마다 1건씩 생긴다.
     C. 실적구간 LOC 생성 (L1046~1097) = RTF_SYS_RP ↔ SalesAmt_LOC (DM_PLN_SALES_PLAN_RESULT 기준)

   [사용법]  ★ 전체 실행(F5 / Execute Script) 기준 오류 0 — 조회만 한다(COMMIT 없음).
     1) 아래 '파라미터' 값(4곳: §2 의 v_users·v_from·v_now·v_to·v_bucket)을 화면 조회조건과 맞춘다.
        화면 조건 그대로 = 브라우저 개발자도구 Network 의 조회 요청 payload(fromYyyymmdd/nowYyyymmdd/toYyyymmdd/bucket) 값.
     2) DBMS_OUTPUT 을 켠다 (DBeaver: Output 탭 'Enable' / SQL Developer: View>Dbms Output / SQL*Plus: 자동).
     3) §1 결과 그리드 + §2 DBMS_OUTPUT + §3·§4 결과 그리드를 회신.
   [주의]  §2 는 SP 를 실제 호출한다. SP 는 해당 계정의 'M'(메저) 개인화가 0건일 때만
           SCM_MST_TITLESET_USER 에 기본 메저를 INSERT 한다(화면 조회와 동일 동작, L351). 두 계정 모두
           'M' 이 있으면 쓰기 없음 — §1-1 결과에서 TYPE='M' 건수로 먼저 확인할 것.
           §3·§4 는 §2 와 **같은 세션**에서 실행해야 한다(GTT = SYS$SESSION).
   ===================================================================================================== */

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

-- =====================================================================================================
-- §0. 접속 DB 확인
-- =====================================================================================================
SELECT SYS_CONTEXT('USERENV','SERVER_HOST')    AS SERVER_HOST
     , SYS_CONTEXT('USERENV','SERVICE_NAME')   AS SERVICE_NAME
     , SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS CUR_SCHEMA
     , (SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') FROM ALL_OBJECTS
         WHERE OBJECT_NAME = 'PKG_DMF0021' AND OBJECT_TYPE = 'PACKAGE BODY' AND ROWNUM = 1) AS PKG_BODY_DDL
     , SYSDATE AS RUN_AT
  FROM DUAL;

-- =====================================================================================================
-- §1-1. 개인화 저장분 비교 (컬럼 'C' · 메저 'M') — jaehun_cho vs minyonglee1
--        J/M 칸 = 저장 SORT_ORDER_NO (빈칸 = 그 계정에 없음) · KEY_RISK = LOC 행 분리를 일으킬 수 있는 컬럼
-- =====================================================================================================
SELECT NVL(J.USER_INQUIRY_COLUMN_TYPE_CODE, M.USER_INQUIRY_COLUMN_TYPE_CODE) AS TYPE
     , NVL(J.COLUMN_NAME, M.COLUMN_NAME)                                     AS COLUMN_NAME
     , J.SORT_ORDER_NO                                                       AS JAEHUN_CHO
     , M.SORT_ORDER_NO                                                       AS MINYONGLEE1
     , CASE WHEN NVL(J.COLUMN_NAME, M.COLUMN_NAME) IN ('FROM_SITE_ID','CELL_PROD_SITE_ID','CURRENCY','COMPANY_ID'
                                                     ,'TEXT','TEXT4082','PLANT_SITE_ID','VERSION_NO')
            THEN 'Y' END                                                     AS KEY_RISK
     , CASE WHEN J.COLUMN_NAME IS NULL OR M.COLUMN_NAME IS NULL THEN '차이' END AS DIFF
  FROM ( SELECT * FROM SCM_MST_TITLESET_USER
          WHERE PROGRAM_ID = 'DMF0021' AND SHEET_NAME = 'Sales Plan' AND USER_ID = 'jaehun_cho' ) J
  FULL OUTER JOIN
       ( SELECT * FROM SCM_MST_TITLESET_USER
          WHERE PROGRAM_ID = 'DMF0021' AND SHEET_NAME = 'Sales Plan' AND USER_ID = 'minyonglee1' ) M
    ON J.COLUMN_NAME = M.COLUMN_NAME
   AND J.USER_INQUIRY_COLUMN_TYPE_CODE = M.USER_INQUIRY_COLUMN_TYPE_CODE
 ORDER BY 1, NVL(J.SORT_ORDER_NO, M.SORT_ORDER_NO), 2;

-- =====================================================================================================
-- §1-2. 개인화 이상치 — 같은 계정·같은 컬럼/메저가 2행 이상(SORT 다름) 저장됐는지
--        (메저가 SORT_ORDER_NO 2개로 들어가면 GT_DMF0021_SELECT_MEASURE 에 2행 → 같은 LOC 가 SORT 별 2 Row)
-- =====================================================================================================
SELECT USER_ID, USER_INQUIRY_COLUMN_TYPE_CODE AS TYPE, COLUMN_NAME
     , COUNT(*) AS CNT
     , LISTAGG(TO_CHAR(SORT_ORDER_NO), ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO) AS SORTS
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0021' AND SHEET_NAME = 'Sales Plan'
   AND USER_ID IN ('jaehun_cho','minyonglee1')
 GROUP BY USER_ID, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
HAVING COUNT(*) > 1;

-- =====================================================================================================
-- §1-3. SP 가 실제로 쓰는 행 키(v_ColList) 재현 — PKG BODY L1406~1497 과 동일 규칙
--        'C' 개인화 있음 → 개인화 컬럼 + 숨김 컬럼(VISIBLE_FLAG='N' · DEFAULT_FLAG<>'Y' · VALID_YN='Y')
--        'C' 개인화 없음 → SHEET_COLUMNS 기본(DEFAULT_FLAG='Y' 또는 숨김 컬럼)
--        이후 NOTATION·MEASURE 강제 추가, VERSION_NO → VERSION_SORT,VERSION_NO
-- =====================================================================================================
WITH U AS ( SELECT 'jaehun_cho' AS USER_ID FROM DUAL UNION ALL SELECT 'minyonglee1' FROM DUAL )
, HAS_C AS (
    SELECT U.USER_ID
         , ( SELECT COUNT(*) FROM SCM_MST_TITLESET_USER T
              WHERE T.PROGRAM_ID = 'DMF0021' AND T.SHEET_NAME = 'Sales Plan'
                AND T.USER_ID = U.USER_ID AND T.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' ) AS C_CNT
      FROM U )
, COLS AS (
    -- 개인화 있음 분기
    SELECT H.USER_ID, X.SORT_ORDER_NO, C.COLUMN_NAME, 'PERSONAL' AS SRC
      FROM HAS_C H
      JOIN SCM_MST_TITLESET_USER X
        ON X.USER_ID = H.USER_ID AND X.PROGRAM_ID = 'DMF0021' AND X.SHEET_NAME = 'Sales Plan'
       AND X.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
      JOIN SCM_MST_SHEET_COLUMNS C
        ON C.PROGRAM_ID = X.PROGRAM_ID AND C.SHEET_NAME = X.SHEET_NAME AND C.COLUMN_NAME = X.COLUMN_NAME
     WHERE H.C_CNT > 0
    UNION ALL
    SELECT H.USER_ID
         , CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(X.SORT_ORDER_NO,85) - 0.5
                WHEN C.COLUMN_NAME = 'SALES_PLAN_ADJUST_YN' THEN NVL(C.SORT_ORDER_NO,400) + 110
                ELSE C.SORT_ORDER_NO END
         , C.COLUMN_NAME, 'HIDDEN'
      FROM HAS_C H
      JOIN SCM_MST_SHEET_COLUMNS C
        ON C.PROGRAM_ID = 'DMF0021' AND C.SHEET_NAME = 'Sales Plan'
       AND C.VISIBLE_FLAG = 'N' AND NVL(C.DEFAULT_FLAG,'N') <> 'Y' AND C.VALID_YN = 'Y'
      LEFT JOIN SCM_MST_TITLESET_USER X
        ON X.PROGRAM_ID = C.PROGRAM_ID AND X.SHEET_NAME = C.SHEET_NAME
       AND X.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' AND X.COLUMN_NAME IN ('ITEM_ID') AND X.USER_ID = H.USER_ID
     WHERE H.C_CNT > 0
    UNION ALL
    -- 개인화 없음 분기
    SELECT H.USER_ID, C.SORT_ORDER_NO, C.COLUMN_NAME, 'DEFAULT'
      FROM HAS_C H
      JOIN SCM_MST_SHEET_COLUMNS C
        ON C.PROGRAM_ID = 'DMF0021' AND C.SHEET_NAME = 'Sales Plan'
       AND ( C.DEFAULT_FLAG = 'Y' OR ( C.VISIBLE_FLAG = 'N' AND NVL(C.DEFAULT_FLAG,'N') <> 'Y' AND C.VALID_YN = 'Y' ) )
     WHERE H.C_CNT = 0 )
, DEDUP AS (
    SELECT COLS.*, ROW_NUMBER() OVER (PARTITION BY USER_ID, COLUMN_NAME ORDER BY SORT_ORDER_NO) AS RN FROM COLS )
SELECT USER_ID
     , LISTAGG(COLUMN_NAME || '(' || SRC || ')', ', ') WITHIN GROUP (ORDER BY SORT_ORDER_NO) AS ROW_KEY_COLUMNS
     , MAX(CASE WHEN COLUMN_NAME = 'FROM_SITE_ID'      THEN 'Y' END) AS HAS_FROM_SITE_ID
     , MAX(CASE WHEN COLUMN_NAME = 'CELL_PROD_SITE_ID' THEN 'Y' END) AS HAS_CELL_PROD_SITE_ID
     , MAX(CASE WHEN COLUMN_NAME = 'CURRENCY'          THEN 'Y' END) AS HAS_CURRENCY
     , MAX(CASE WHEN COLUMN_NAME = 'COMPANY_ID'        THEN 'Y' END) AS HAS_COMPANY_ID
     , MAX(CASE WHEN COLUMN_NAME IN ('TEXT','TEXT4082') THEN 'Y' END) AS HAS_TEXT
  FROM DEDUP
 WHERE RN = 1
 GROUP BY USER_ID;

-- =====================================================================================================
-- §1-4. Division 81 기준 SCM_MST_SHEET_MEASURE 의 LOC 정의 (사업부 스코프 중복 여부)
-- =====================================================================================================
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID, SORT_ORDER_NO, DEFAULT_FLAG, VALID_YN
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0021' AND SHEET_NAME = 'Sales Plan'
   AND COLUMN_NAME IN ('LOC','RTF_SYS_RP','SalesAmt_LOC','MKT_FCST_RP','MKT_FCST')
 ORDER BY COLUMN_NAME, DIVISION_ID;

-- =====================================================================================================
-- §2. SP 실호출 → 화면 결과셋(첫 번째 커서)에서 LOC 행 분리 판정 (DBMS_OUTPUT)
--     두 계정을 같은 조건으로 차례로 호출한다. 마지막 계정(jaehun_cho)의 GTT 가 §3·§4 에 남는다.
--     출력: 계정별 결과 행수 · LOC 행수 · 분리 그룹 수 · 그룹별 '값이 다른 컬럼'과 그 값
-- =====================================================================================================
DECLARE
    -- ▼▼▼ 파라미터 (화면 조회조건과 동일하게) ▼▼▼
    TYPE t_users IS TABLE OF VARCHAR2(50);
    v_users     t_users        := t_users('minyonglee1', 'jaehun_cho');   -- 마지막 계정의 GTT 가 §3·§4 대상
    v_division  VARCHAR2(10)   := '81';
    v_from      VARCHAR2(8)    := '20261101';   -- fromYyyymmdd
    v_now       VARCHAR2(8)    := '20261109';   -- nowYyyymmdd (금주 월요일, 조회기간 안으로 클램프)
    v_to        VARCHAR2(8)    := '20270430';   -- toYyyymmdd
    v_bucket    VARCHAR2(10)   := 'MONTHLY';    -- DAILY / WEEKLY / MONTHLY
    v_userinfo  VARCHAR2(50)   := 'ADMIN';      -- P_USERINFO (화면 = CMBO SalesPlanUserAuthGroup 값)
    v_max_print PLS_INTEGER    := 30;           -- 분리 그룹 상세 출력 최대 건수
    -- ▲▲▲ 파라미터 ▲▲▲
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR;
    cur        INTEGER;
    col_cnt    INTEGER;
    dtab       DBMS_SQL.DESC_TAB2;
    v_val      VARCHAR2(4000);
    TYPE t_row  IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    TYPE t_rows IS TABLE OF t_row INDEX BY PLS_INTEGER;
    TYPE t_grp  IS TABLE OF VARCHAR2(32767) INDEX BY VARCHAR2(4000);
    loc_rows   t_rows;
    grp        t_grp;
    v_row      t_row;
    n_all      PLS_INTEGER;
    n_loc      PLS_INTEGER;
    n_split    PLS_INTEGER;
    n_print    PLS_INTEGER;
    i_meas     PLS_INTEGER;
    v_ident    VARCHAR2(4000);
    v_key      VARCHAR2(4000);
    v_idx      VARCHAR2(32767);
    v_diff     VARCHAR2(4000);
    v_vals     VARCHAR2(4000);
    v_first    VARCHAR2(4000);
    v_same     BOOLEAN;
    TYPE t_idlist IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
    ids        t_idlist;
    k          PLS_INTEGER;
    FUNCTION is_ident(p_col VARCHAR2) RETURN BOOLEAN IS
    BEGIN   -- 품목 동일성 기준 (이 컬럼들이 같은데 LOC 가 2행 이상이면 '분리')
        RETURN p_col IN ('VERSION_NO','DIVISION_ID','PROJECT_CODE','SCM_SITE_ID','ITEM_ID','INCOTERMS','DOM_EXP','FCST_TYPE');
    END;
    FUNCTION is_bucket(p_col VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN SUBSTR(p_col,1,2) IN ('M_','W_','D_');
    END;
BEGIN
    FOR u IN 1 .. v_users.COUNT LOOP
        loc_rows.DELETE; grp.DELETE;
        n_all := 0; n_loc := 0; n_split := 0; n_print := 0; i_meas := NULL;

        PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX(
              v_division, 'ALL', 'ALL', 'ALL', '', '', 'ALL'
            , v_from, v_now, v_to, v_users(u)
            , 'ALL', 'ALL', '', 'N', v_userinfo, v_bucket, ''
            , rc1, rc2, rc3 );
        CLOSE rc2; CLOSE rc3;

        cur := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
        DBMS_SQL.DESCRIBE_COLUMNS2(cur, col_cnt, dtab);
        FOR c IN 1 .. col_cnt LOOP
            DBMS_SQL.DEFINE_COLUMN(cur, c, v_val, 4000);
            IF dtab(c).col_name = 'MEASURE' THEN i_meas := c; END IF;
        END LOOP;

        WHILE DBMS_SQL.FETCH_ROWS(cur) > 0 LOOP
            n_all := n_all + 1;
            DBMS_SQL.COLUMN_VALUE(cur, i_meas, v_val);
            IF v_val = 'LOC' THEN
                n_loc := n_loc + 1;
                v_row.DELETE;
                FOR c IN 1 .. col_cnt LOOP
                    DBMS_SQL.COLUMN_VALUE(cur, c, v_val);
                    v_row(c) := v_val;
                END LOOP;
                loc_rows(n_loc) := v_row;
                v_ident := NULL;
                FOR c IN 1 .. col_cnt LOOP
                    IF is_ident(dtab(c).col_name) THEN
                        v_ident := v_ident || dtab(c).col_name || '=' || v_row(c) || ' | ';
                    END IF;
                END LOOP;
                IF grp.EXISTS(v_ident) THEN grp(v_ident) := grp(v_ident) || ',' || n_loc;
                ELSE grp(v_ident) := TO_CHAR(n_loc); END IF;
            END IF;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(cur);

        DBMS_OUTPUT.PUT_LINE('=================================================================');
        DBMS_OUTPUT.PUT_LINE('USER=' || v_users(u) || ' DIV=' || v_division || ' ' || v_from || '~' || v_to
                             || ' NOW=' || v_now || ' ' || v_bucket);
        DBMS_OUTPUT.PUT_LINE('결과 행수=' || n_all || ' / LOC 행수=' || n_loc || ' / LOC 품목키 수=' || grp.COUNT);

        v_key := grp.FIRST;
        WHILE v_key IS NOT NULL LOOP
            IF INSTR(grp(v_key), ',') > 0 THEN
                n_split := n_split + 1;
                IF n_print < v_max_print THEN
                    n_print := n_print + 1;
                    -- 그룹 안 행 번호 분해
                    ids.DELETE; k := 0; v_idx := grp(v_key) || ',';
                    WHILE INSTR(v_idx, ',') > 0 LOOP
                        k := k + 1; ids(k) := TO_NUMBER(SUBSTR(v_idx, 1, INSTR(v_idx, ',') - 1));
                        v_idx := SUBSTR(v_idx, INSTR(v_idx, ',') + 1);
                    END LOOP;
                    -- 값이 다른 (비버킷) 컬럼 찾기
                    v_diff := NULL; v_vals := NULL;
                    FOR c IN 1 .. col_cnt LOOP
                        IF NOT is_bucket(dtab(c).col_name) THEN
                            v_first := loc_rows(ids(1))(c); v_same := TRUE;
                            FOR r IN 2 .. k LOOP
                                IF NOT ( (v_first IS NULL AND loc_rows(ids(r))(c) IS NULL) OR v_first = loc_rows(ids(r))(c) ) THEN
                                    v_same := FALSE;
                                END IF;
                            END LOOP;
                            IF NOT v_same THEN
                                v_diff := v_diff || dtab(c).col_name || ' ';
                                v_vals := v_vals || dtab(c).col_name || '[';
                                FOR r IN 1 .. k LOOP
                                    v_vals := v_vals || NVL(loc_rows(ids(r))(c), '<NULL>') || CASE WHEN r < k THEN ' / ' END;
                                END LOOP;
                                v_vals := v_vals || '] ';
                            END IF;
                        END IF;
                    END LOOP;
                    DBMS_OUTPUT.PUT_LINE('  [분리 ' || n_print || '] 행수=' || k || ' :: ' || v_key);
                    DBMS_OUTPUT.PUT_LINE('        다른 컬럼 = ' || NVL(v_diff, '(없음 = 키 컬럼 전부 동일 → SORT_ORDER_NO/메저 중복 의심, §3-1 확인)'));
                    DBMS_OUTPUT.PUT_LINE('        값        = ' || v_vals);
                END IF;
            END IF;
            v_key := grp.NEXT(v_key);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('LOC 분리 그룹 수=' || n_split || CASE WHEN n_split > v_max_print THEN ' (상세는 ' || v_max_print || '건만 출력)' END);
    END LOOP;
END;
/

-- =====================================================================================================
-- §3-1. (§2 와 같은 세션) 마지막 실행 계정의 선택 메저 GTT — LOC 가 2행(SORT 다름)이면 메저 중복이 원인
-- =====================================================================================================
SELECT MEASURE, SORT_ORDER_NO, SYSTEM_ADD, COUNT(*) OVER (PARTITION BY MEASURE) AS SAME_MEASURE_CNT
  FROM GT_DMF0021_SELECT_MEASURE
 ORDER BY SORT_ORDER_NO NULLS LAST, MEASURE;

-- =====================================================================================================
-- §3-2. (§2 와 같은 세션) LOC 원천행(GTT RAW_DATA) — 같은 품목키에서 값이 갈리는 칸 집계
--        CPS_CNT>1 = CELL_PROD_SITE_ID(→FROM_SITE_ID) 로 분리 · CUR_CNT>1 = CURRENCY · TEXT_CNT>1 = TEXT
-- =====================================================================================================
SELECT A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
     , COUNT(DISTINCT NVL(A.CELL_PROD_SITE_ID,'<NULL>'))   AS CPS_CNT
     , LISTAGG(DISTINCT NVL(A.CELL_PROD_SITE_ID,'<NULL>'), ',') WITHIN GROUP (ORDER BY NVL(A.CELL_PROD_SITE_ID,'<NULL>')) AS CPS_LIST
     , COUNT(DISTINCT NVL(A.CURRENCY,'<NULL>'))            AS CUR_CNT
     , LISTAGG(DISTINCT NVL(A.CURRENCY,'<NULL>'), ',') WITHIN GROUP (ORDER BY NVL(A.CURRENCY,'<NULL>')) AS CUR_LIST
     , COUNT(DISTINCT NVL(A.TEXT,'<NULL>'))                AS TEXT_CNT
     , COUNT(DISTINCT NVL(TRIM(A.COMPANY_ID),'/'))         AS COMPANY_CNT
     , COUNT(DISTINCT A.PLANT_SITE_ID)                     AS PLANT_CNT
     , LISTAGG(DISTINCT A.PLAN_RESULT, ',') WITHIN GROUP (ORDER BY A.PLAN_RESULT) AS PLAN_RESULT
     , COUNT(*)                                            AS LOC_DAY_ROWS
  FROM GT_DMF0021_RAW_DATA A
 WHERE A.MEASURE = 'LOC'
 GROUP BY A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
HAVING COUNT(DISTINCT NVL(A.CELL_PROD_SITE_ID,'<NULL>')) > 1
    OR COUNT(DISTINCT NVL(A.CURRENCY,'<NULL>'))          > 1
    OR COUNT(DISTINCT NVL(A.TEXT,'<NULL>'))              > 1
    OR COUNT(DISTINCT NVL(TRIM(A.COMPANY_ID),'/'))       > 1
    OR COUNT(DISTINCT A.PLANT_SITE_ID)                   > 1
 ORDER BY A.SCM_SITE_ID, A.ITEM_ID;

-- =====================================================================================================
-- §3-3. (§2 와 같은 세션) 분리 품목의 메저별 CELL_PROD_SITE_ID·CURRENCY 분포 (GTT)
--        계획구간 LOC 는 아래 메저들의 DISTINCT 키마다 1건씩 생성된다 (L1213~1218):
--        RTF_SYS_RP · MKT_FCST_RP · MKT_FCST · RTF_SCP · SalesAmt_LOC · SalesAmt_USD · SalesAmt_KRW · Catch_Up
--        ※ GTT 에는 SYSTEM_ADD='Y' 메저(시스템 추가분)는 L1252 에서 삭제된 뒤 상태 — 원장 기준은 §4
-- =====================================================================================================
WITH SPLIT AS (
    SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
      FROM GT_DMF0021_RAW_DATA
     WHERE MEASURE = 'LOC'
     GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
    HAVING COUNT(DISTINCT NVL(CELL_PROD_SITE_ID,'<NULL>')) > 1
        OR COUNT(DISTINCT NVL(CURRENCY,'<NULL>'))          > 1
        OR COUNT(DISTINCT NVL(TEXT,'<NULL>'))              > 1
        OR COUNT(DISTINCT PLANT_SITE_ID)                   > 1 )
SELECT A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.MEASURE, A.PLAN_RESULT
     , NVL(A.CELL_PROD_SITE_ID,'<NULL>') AS CELL_PROD_SITE_ID
     , CASE WHEN NVL(A.CELL_PROD_SITE_ID,'-') = '-' THEN 'N/A' ELSE A.CELL_PROD_SITE_ID END AS FROM_SITE_ID_SHOWN
     , NVL(A.CURRENCY,'<NULL>') AS CURRENCY, A.TEXT, A.PLANT_SITE_ID
     , MIN(A.YYYYMMDD) AS FROM_DAY, MAX(A.YYYYMMDD) AS TO_DAY, COUNT(*) AS DAY_ROWS, SUM(A.QTY) AS QTY_SUM
  FROM GT_DMF0021_RAW_DATA A
  JOIN SPLIT S
    ON S.PROJECT_CODE = A.PROJECT_CODE AND S.SCM_SITE_ID = A.SCM_SITE_ID AND S.ITEM_ID = A.ITEM_ID
   AND S.INCOTERMS = A.INCOTERMS AND S.DOM_EXP = A.DOM_EXP AND S.FCST_TYPE = A.FCST_TYPE
 GROUP BY A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.MEASURE, A.PLAN_RESULT, A.CELL_PROD_SITE_ID, A.CURRENCY, A.TEXT, A.PLANT_SITE_ID
 ORDER BY A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.CELL_PROD_SITE_ID, A.MEASURE;

-- =====================================================================================================
-- §4. 원장 대조 (세션 무관) — 계획구간 DM_PLN_SALES_PLAN 의 같은 품목 메저별 CELL_PROD_SITE_ID·CURRENCY
--      같은 품목키에서 메저마다 CELL_PROD_SITE_ID(NULL→'-') 또는 CURRENCY 가 다르면
--      계획구간 LOC 가 그 값 개수만큼 생성된다 (§2 파라미터와 같은 기간으로 맞출 것)
-- =====================================================================================================
WITH P AS ( SELECT '81' AS DIV, '20261109' AS NOW_D, '20270430' AS TO_D FROM DUAL )   -- ★ §2 의 v_division·v_now·v_to
, SRC AS (
    SELECT A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE
         , NVL(NULLIF(RTRIM(A.CELL_PROD_SITE_ID),''), '-') AS CPS      -- SP L484 와 동일 정규화
         , A.CURRENCY, NVL(TRIM(A.ATTRIBUTE9),'/') AS TEXT, A.YYYYMMDD, A.QTY
      FROM DM_PLN_SALES_PLAN A, P
     WHERE A.DIVISION_ID = P.DIV
       AND A.YYYYMMDD >= P.NOW_D AND A.YYYYMMDD <= P.TO_D
       AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','Catch_Up')
       AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR A.MEASURE = 'RTF_SYS_RP') )
, K AS (
    SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
      FROM SRC
     GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
    HAVING COUNT(DISTINCT CPS) > 1 OR COUNT(DISTINCT NVL(CURRENCY,'<NULL>')) > 1 OR COUNT(DISTINCT TEXT) > 1 )
SELECT S.SCM_SITE_ID, S.ITEM_ID, S.FCST_TYPE, S.MEASURE, S.CPS AS CELL_PROD_SITE_ID
     , NVL(S.CURRENCY,'<NULL>') AS CURRENCY, S.TEXT
     , MIN(S.YYYYMMDD) AS FROM_DAY, MAX(S.YYYYMMDD) AS TO_DAY, COUNT(*) AS DAY_ROWS, SUM(S.QTY) AS QTY_SUM
  FROM SRC S
  JOIN K
    ON K.PROJECT_CODE = S.PROJECT_CODE AND K.SCM_SITE_ID = S.SCM_SITE_ID AND K.ITEM_ID = S.ITEM_ID
   AND K.INCOTERMS = S.INCOTERMS AND K.DOM_EXP = S.DOM_EXP AND K.FCST_TYPE = S.FCST_TYPE
 GROUP BY S.SCM_SITE_ID, S.ITEM_ID, S.FCST_TYPE, S.MEASURE, S.CPS, S.CURRENCY, S.TEXT
 ORDER BY S.SCM_SITE_ID, S.ITEM_ID, S.FCST_TYPE, S.CPS, S.MEASURE;

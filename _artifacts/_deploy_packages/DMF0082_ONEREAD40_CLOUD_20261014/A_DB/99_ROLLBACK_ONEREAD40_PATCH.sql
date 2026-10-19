-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-14 17:53:02 FETCHED=2026-10-14 17:54 DB=ZIOUI1 (사내 적용본 구간 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99 ROLLBACK — [E20261014-DMF0082ONEREAD40] 4구간을 구 원문으로 되돌린다 (이 DB 의 USER_SOURCE 를 읽어 교체 → CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 새 구간 4개의 위치·길이가 적용본과 같을 때만 실행. 10_APPLY 와 같은 도구로 실행할 것.
-- ⚠ 되돌리면 40 조회가 다시 원장 2회 읽기로 돌아간다. 결과 값은 같다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    s1 PLS_INTEGER; e1 PLS_INTEGER; s2 PLS_INTEGER; e2 PLS_INTEGER;
    s3 PLS_INTEGER; e3 PLS_INTEGER; s4 PLS_INTEGER; e4 PLS_INTEGER; p4 PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261014-DMF0082ONEREAD40';
    c_a1  CONSTANT VARCHAR2(200) := CHR(10) || '    ELSE' || CHR(10) || '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' || CHR(10);
    c_a2  CONSTANT VARCHAR2(200) := CHR(10) || '    ELSE' || CHR(10) || '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE' || CHR(10);
    c_a3  CONSTANT VARCHAR2(200) := CHR(10) || '        ELSE' || CHR(10) || '        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE' || CHR(10);
    c_a4p CONSTANT VARCHAR2(200) := ') WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;';
    c_n1  CONSTANT VARCHAR2(200) := '    NULL;  --[E20261014-DMF0082ONEREAD40] 40 T_LAST_DATA_SETUP_FCST';
    c_n2  CONSTANT VARCHAR2(200) := '    NULL;  --[E20261014-DMF0082ONEREAD40] 40 T_LAST_DATA_SETUP_PRICE';
    c_n3  CONSTANT VARCHAR2(200) := CHR(10) || '        ELSE' || CHR(10) || '        /* [E20261014-DMF0082ONEREAD40] 40 ';
    c_e4  CONSTANT VARCHAR2(60)  := CHR(10) || '    END IF;  --[DIV81]';
    c_e8  CONSTANT VARCHAR2(60)  := CHR(10) || '        END IF;  --[DIV81]' || CHR(10);
    c_else4 CONSTANT PLS_INTEGER := 10;
    c_else8 CONSTANT PLS_INTEGER := 14;
    c_old1 CONSTANT VARCHAR2(32767) :=   -- 구 구간 1 (1033자)
        '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' || CHR(10) ||
        '        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)' || CHR(10) ||
        '    SELECT /*+ LEADING(A) USE_HASH(C) */ /*[E20260930-DMF0082CLOUDPERF] L1265 형제문장 동일 — TEMP_SITE_ITEM 1행 추정 NL 방지 (클라우드 9.4s) */ A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE' || CHR(10) ||
        '         , MAX(A.CREATION_DATE) AS CREATE_DATE' || CHR(10) ||
        '         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY' || CHR(10) ||
        '    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A' || CHR(10) ||
        '    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '        ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '        AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '        AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '        AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '    WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd' || CHR(10) ||
        '    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;' || CHR(10);
    c_new1 CONSTANT VARCHAR2(32767) :=   -- 새 구간 1 (1177자)
        '    NULL;  --[E20261014-DMF0082ONEREAD40] 40 T_LAST_DATA_SETUP_FCST 별도 적재 제거 — Current 40 수요 arm 의 INSERT ALL 이 같은 원장 1회 읽기로 적재(실적 arm 이 계속 읽음)' || CHR(10) ||
        '--  INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' || CHR(10) ||
        '--      (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)' || CHR(10) ||
        '--  SELECT /*+ LEADING(A) USE_HASH(C) */ /*[E20260930-DMF0082CLOUDPERF] L1265 형제문장 동일 — TEMP_SITE_ITEM 1행 추정 NL 방지 (클라우드 9.4s) */ A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '--       , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE' || CHR(10) ||
        '--       , MAX(A.CREATION_DATE) AS CREATE_DATE' || CHR(10) ||
        '--       , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY' || CHR(10) ||
        '--  FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A' || CHR(10) ||
        '--  INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '--      ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '--      AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '--      AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '--      AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '--  WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '--  AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd' || CHR(10) ||
        '--  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '--         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;' || CHR(10);
    c_old2 CONSTANT VARCHAR2(32767) :=   -- 구 구간 2 (1320자)
        '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE' || CHR(10) ||
        '        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)' || CHR(10) ||
        '    SELECT /*+ LEADING(A) USE_HASH(C) */ -- ④ [E20260815-PERF2] 계획 고정 (hook #129 ④)' || CHR(10) ||
        '               -- GTT C(TEMP_SITE_ITEM) 는 세션 데이터라 통계가 없어 추정 1행으로 굳는다(실제 14,879).' || CHR(10) ||
        '               -- 그 결과 NESTED LOOPS 로 대형표 A(div40 103만행)를 **행별 인덱스 조회** 했다' || CHR(10) ||
        '               -- (실측: ASH 14s/45.2% · buffer_gets 19,989,169 · PLAN LINE 7 INDEX RANGE SCAN).' || CHR(10) ||
        '               -- ①함수/스칼라서브쿼리 없음 ②이미 SARGable ③PK 존재(인덱스 부재 아님) ⇒ ④ 적용.' || CHR(10) ||
        '           A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE' || CHR(10) ||
        '         , MAX(A.CREATION_DATE) AS CREATE_DATE' || CHR(10) ||
        '         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY' || CHR(10) ||
        '    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A' || CHR(10) ||
        '    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '        ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '        AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '        AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '        AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '    WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd' || CHR(10) ||
        '    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;' || CHR(10);
    c_new2 CONSTANT VARCHAR2(32767) :=   -- 새 구간 2 (1434자)
        '    NULL;  --[E20261014-DMF0082ONEREAD40] 40 T_LAST_DATA_SETUP_PRICE 적재 제거 — 소비처(40 판가 arm)가 원장 1회 읽기 윈도 MAX 로 대체' || CHR(10) ||
        '--  INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE' || CHR(10) ||
        '--      (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)' || CHR(10) ||
        '--  SELECT /*+ LEADING(A) USE_HASH(C) */ -- ④ [E20260815-PERF2] 계획 고정 (hook #129 ④)' || CHR(10) ||
        '--             -- GTT C(TEMP_SITE_ITEM) 는 세션 데이터라 통계가 없어 추정 1행으로 굳는다(실제 14,879).' || CHR(10) ||
        '--             -- 그 결과 NESTED LOOPS 로 대형표 A(div40 103만행)를 **행별 인덱스 조회** 했다' || CHR(10) ||
        '--             -- (실측: ASH 14s/45.2% · buffer_gets 19,989,169 · PLAN LINE 7 INDEX RANGE SCAN).' || CHR(10) ||
        '--             -- ①함수/스칼라서브쿼리 없음 ②이미 SARGable ③PK 존재(인덱스 부재 아님) ⇒ ④ 적용.' || CHR(10) ||
        '--         A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '--       , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE' || CHR(10) ||
        '--       , MAX(A.CREATION_DATE) AS CREATE_DATE' || CHR(10) ||
        '--       , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY' || CHR(10) ||
        '--  FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A' || CHR(10) ||
        '--  INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '--      ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '--      AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '--      AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '--      AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '--  WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '--  AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd' || CHR(10) ||
        '--  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '--         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;' || CHR(10);
    c_old3 CONSTANT VARCHAR2(32767) :=   -- 구 구간 3 (5251자)
        '        ELSE' || CHR(10) ||
        '        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE' || CHR(10) ||
        '        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS' || CHR(10) ||
        '        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP' || CHR(10) ||
        '        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO' || CHR(10) ||
        '        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE' || CHR(10) ||
        '        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN' || CHR(10) ||
        '        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY' || CHR(10) ||
        '        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC' || CHR(10) ||
        '        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE' || CHR(10) ||
        '        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE' || CHR(10) ||
        '        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT' || CHR(10) ||
        '        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)' || CHR(10) ||
        '        SELECT A.DIVISION_ID' || CHR(10) ||
        '             , A.PROJECT_CODE' || CHR(10) ||
        '             , A.END_CUSTOMER' || CHR(10) ||
        '             , A.SCM_SITE_ID' || CHR(10) ||
        '             , A.ITEM_ID' || CHR(10) ||
        '             , A.DOM_EXP' || CHR(10) ||
        '             , A.FCST_TYPE' || CHR(10) ||
        '             , A.INCOTERMS' || CHR(10) ||
        '             , CASE WHEN UPPER(A.MEASURE) = ''CUSTOMER FCST'' THEN CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot'' THEN ''Cust.FCST_RPA[P+P]'' ELSE ''Cust.FCST_EXCEL[P+P]'' END ELSE A.MEASURE END  /*[E20260930-DMF0082CUSTEXCEL] AS-IS DMF0003 Block 1-C [E20241126-000426] 1:1 — ''Customer FCST'' 원장 행은 수정자 robot 여부로 RPA/EXCEL 표기 (콤보 ''Measure'' 가 '' └ EXCEL'' 로 표시). UPPER = MSSQL 대소문자 무시 등가*/' || CHR(10) ||
        '             , A.PLANT_SITE_ID' || CHR(10) ||
        '             , A.CELL_PROD_SITE_ID' || CHR(10) ||
        '             , A.YYYYMMDD' || CHR(10) ||
        '             , A.QTY' || CHR(10) ||
        '             , B.MEASURE_GROUP' || CHR(10) ||
        '             , C.CELL_MODEL' || CHR(10) ||
        '             , C.NICK_NAME' || CHR(10) ||
        '             , C.DMS_SALES' || CHR(10) ||
        '             , C.DMS_CUSTOMER' || CHR(10) ||
        '             , C.OWNER' || CHR(10) ||
        '             , C.DEPT_ID' || CHR(10) ||
        '             , C.DEPT_NAME_KO' || CHR(10) ||
        '             , C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '             , C.ITEM_TYPE' || CHR(10) ||
        '             , C.PROJECT_NAME' || CHR(10) ||
        '             , C.PROJECT_OWNER' || CHR(10) ||
        '             , C.BIZ_TYPE' || CHR(10) ||
        '             , C.SOLDTO_CUSTOMER' || CHR(10) ||
        '             , C.COUNTRY_NAME' || CHR(10) ||
        '             , C.CITY_NAME' || CHR(10) ||
        '             , C.PROJECT_STATUS' || CHR(10) ||
        '             , C.ITEM_NAME' || CHR(10) ||
        '             , C.VMI_YN' || CHR(10) ||
        '             , C.CUST_GROUP' || CHR(10) ||
        '             , C.CUST_GROUP_DTL' || CHR(10) ||
        '             , C.APPLICATION' || CHR(10) ||
        '             , C.ROUTE' || CHR(10) ||
        '             , C.MDM_PROJECT_NAME' || CHR(10) ||
        '             , C.MIN_CAPACITY' || CHR(10) ||
        '             , C.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '             , C.CELL_TYPE' || CHR(10) ||
        '             , C.FORECAST_INFO_ALL' || CHR(10) ||
        '             , C.FORECAST_INFO_SPEC' || CHR(10) ||
        '             , C.FORECAST_INFOR_VERSION' || CHR(10) ||
        '             , C.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '             , C.CELL_PER_CAR' || CHR(10) ||
        '             , C.CELL_PER_MODULE' || CHR(10) ||
        '             , C.MODULE_PER_CAR' || CHR(10) ||
        '             , B.SORT_ORDER_NO' || CHR(10) ||
        '             , C.ENERGE' || CHR(10) ||
        '             , C.CELL_QUANTITY' || CHR(10) ||
        '             , NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10) ||
        '             , LD.CREATE_DATE' || CHR(10) ||
        '             , CASE WHEN UPPER(A.MEASURE) = ''CUSTOMER FCST'' THEN CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot'' THEN A.LAST_UPDATED_BY || ''_RPA'' ELSE A.LAST_UPDATED_BY || ''_EXCEL'' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY  /*[E20260930-DMF0082CUSTEXCEL] AS-IS 동일 — 수정자 접미사*/' || CHR(10) ||
        '             , '''' AS SENDER_CODE' || CHR(10) ||
        '             , '''' AS SENDER_NAME' || CHR(10) ||
        '             , C.PROJECT_S_OP_REPORT' || CHR(10) ||
        '             , '''' AS CURRENCY' || CHR(10) ||
        '             , ''Current'' AS VERSION_NO' || CHR(10) ||
        '             , NULL AS CUTOFF_YYYYMMDD' || CHR(10) ||
        '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10) ||
        '        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10) ||
        '            ON  B.MEASURE = A.MEASURE' || CHR(10) ||
        '        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.' || CHR(10) ||
        '                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10) ||
        '                     , MAX(CREATE_DATE) AS CREATE_DATE' || CHR(10) ||
        '                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY' || CHR(10) ||
        '                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' || CHR(10) ||
        '                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10) ||
        '            ) LD' || CHR(10) ||
        '                ON  LD.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '                AND LD.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '                AND LD.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '                AND LD.DOM_EXP      = A.DOM_EXP' || CHR(10) ||
        '                AND LD.FCST_TYPE    = A.FCST_TYPE' || CHR(10) ||
        '                AND LD.INCOTERMS    = A.INCOTERMS' || CHR(10) ||
        '                AND LD.MEASURE      = A.MEASURE' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '            ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '            AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '            AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '            AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '            AND C.ITEM_VALID_YN = ''Y''' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D' || CHR(10) ||
        '            ON  D.FCST_TYPE = A.FCST_TYPE' || CHR(10) ||
        '        WHERE  1 = 1' || CHR(10) ||
        '        AND    A.DIVISION_ID = p_division_id' || CHR(10) ||
        '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10) ||
        '        AND    A.QTY <> 0;' || CHR(10) ||
        '        END IF;  --[DIV81]' || CHR(10);
    c_new3 CONSTANT VARCHAR2(32767) :=   -- 새 구간 3 (9074자)
        '        ELSE' || CHR(10) ||
        '        /* [E20261014-DMF0082ONEREAD40] 40 수요 원장 1회 읽기 — 구 L1275 T_LAST_DATA_SETUP_FCST 적재(같은 원장 PK 범위 스캔)를 이 문장이 대신한다.' || CHR(10) ||
        '           다중 테이블 INSERT ALL: 원장 × TEMP_SITE_ITEM(유효여부 무관) 을 한 번 읽어' || CHR(10) ||
        '             ① T_LAST_DATA_SETUP_FCST — 키 8개당 1행 (p_from~p_to 구간 MAX(CREATION_DATE)·MAX(LAST_UPDATED_BY)) = 구 GROUP BY 적재와 동일' || CHR(10) ||
        '                (실적 arm 이 이 GTT 를 계속 읽는다)' || CHR(10) ||
        '             ② TEMP_FCST_N_PRICE — 구 수요 arm 행 (B 메저·D FCST_TYPE 일치 · ITEM_VALID_YN=''Y'' · V_FROM~V_TO · QTY<>0)' || CHR(10) ||
        '           키 8개는 원장 NOT NULL(PK) 실측 → PARTITION BY = 구 등호 조인 묶음. 힌트 = 구 GTT 적재 문장의 것 그대로. */' || CHR(10) ||
        '        INSERT ALL' || CHR(10) ||
        '        WHEN X_LD_EMIT = 1 THEN' || CHR(10) ||
        '            INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' || CHR(10) ||
        '                (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)' || CHR(10) ||
        '            VALUES (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, X_MEASURE_RAW, X_LD_CD, X_LD_LU)' || CHR(10) ||
        '        WHEN X_OUT = 1 THEN' || CHR(10) ||
        '            INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE' || CHR(10) ||
        '            ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS' || CHR(10) ||
        '            , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP' || CHR(10) ||
        '            , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO' || CHR(10) ||
        '            , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE' || CHR(10) ||
        '            , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN' || CHR(10) ||
        '            , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY' || CHR(10) ||
        '            , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC' || CHR(10) ||
        '            , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE' || CHR(10) ||
        '            , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE' || CHR(10) ||
        '            , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT' || CHR(10) ||
        '            , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)' || CHR(10) ||
        '            VALUES (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS' || CHR(10) ||
        '                 , X_MEASURE_OUT, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, B_MEASURE_GROUP' || CHR(10) ||
        '                 , C_CELL_MODEL' || CHR(10) ||
        '                 , C_NICK_NAME' || CHR(10) ||
        '                 , C_DMS_SALES' || CHR(10) ||
        '                 , C_DMS_CUSTOMER' || CHR(10) ||
        '                 , C_OWNER' || CHR(10) ||
        '                 , C_DEPT_ID' || CHR(10) ||
        '                 , C_DEPT_NAME_KO' || CHR(10) ||
        '                 , C_FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                 , C_ITEM_TYPE' || CHR(10) ||
        '                 , C_PROJECT_NAME' || CHR(10) ||
        '                 , C_PROJECT_OWNER' || CHR(10) ||
        '                 , C_BIZ_TYPE' || CHR(10) ||
        '                 , C_SOLDTO_CUSTOMER' || CHR(10) ||
        '                 , C_COUNTRY_NAME' || CHR(10) ||
        '                 , C_CITY_NAME' || CHR(10) ||
        '                 , C_PROJECT_STATUS' || CHR(10) ||
        '                 , C_ITEM_NAME' || CHR(10) ||
        '                 , C_VMI_YN' || CHR(10) ||
        '                 , C_CUST_GROUP' || CHR(10) ||
        '                 , C_CUST_GROUP_DTL' || CHR(10) ||
        '                 , C_APPLICATION' || CHR(10) ||
        '                 , C_ROUTE' || CHR(10) ||
        '                 , C_MDM_PROJECT_NAME' || CHR(10) ||
        '                 , C_MIN_CAPACITY' || CHR(10) ||
        '                 , C_FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '                 , C_CELL_TYPE' || CHR(10) ||
        '                 , C_FORECAST_INFO_ALL' || CHR(10) ||
        '                 , C_FORECAST_INFO_SPEC' || CHR(10) ||
        '                 , C_FORECAST_INFOR_VERSION' || CHR(10) ||
        '                 , C_CELL_MODEL_NICK_NAME' || CHR(10) ||
        '                 , C_CELL_PER_CAR' || CHR(10) ||
        '                 , C_CELL_PER_MODULE' || CHR(10) ||
        '                 , C_MODULE_PER_CAR' || CHR(10) ||
        '                 , B_SORT_ORDER_NO, C_ENERGE, C_CELL_QUANTITY, X_AS_FROM_SITE' || CHR(10) ||
        '                 , X_LD_CD, X_LU_OUT, '''', '''', C_PROJECT_S_OP_REPORT' || CHR(10) ||
        '                 , '''', ''Current'', NULL, X_NOTATION)' || CHR(10) ||
        '        SELECT S.*' || CHR(10) ||
        '             , CASE WHEN S.X_IN_P = 1 AND S.X_RN = 1 THEN 1 ELSE 0 END AS X_LD_EMIT' || CHR(10) ||
        '             , CASE WHEN S.B_HIT = 1 AND S.D_HIT = 1 AND S.C_ITEM_VALID_YN = ''Y''' || CHR(10) ||
        '                     AND S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10) ||
        '                     AND S.QTY <> 0 THEN 1 ELSE 0 END AS X_OUT' || CHR(10) ||
        '             , CASE WHEN UPPER(S.X_MEASURE_RAW) = ''CUSTOMER FCST'' THEN CASE WHEN S.X_ROW_LU LIKE ''%robot'' THEN S.X_ROW_LU || ''_RPA'' ELSE S.X_ROW_LU || ''_EXCEL'' END ELSE S.X_LD_LU END AS X_LU_OUT  /*[E20260930-DMF0082CUSTEXCEL] AS-IS 동일 — 수정자 접미사*/' || CHR(10) ||
        '        FROM (' || CHR(10) ||
        '            SELECT /*+ LEADING(A) USE_HASH(C) */' || CHR(10) ||
        '                   A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS' || CHR(10) ||
        '                 , A.MEASURE AS X_MEASURE_RAW' || CHR(10) ||
        '                 , CASE WHEN UPPER(A.MEASURE) = ''CUSTOMER FCST'' THEN CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot'' THEN ''Cust.FCST_RPA[P+P]'' ELSE ''Cust.FCST_EXCEL[P+P]'' END ELSE A.MEASURE END AS X_MEASURE_OUT  /*[E20260930-DMF0082CUSTEXCEL] AS-IS DMF0003 Block 1-C [E20241126-000426] 1:1*/' || CHR(10) ||
        '                 , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY' || CHR(10) ||
        '                 , A.LAST_UPDATED_BY AS X_ROW_LU' || CHR(10) ||
        '                 , NVL(A.ATTRIBUTE10, '' '') AS X_AS_FROM_SITE' || CHR(10) ||
        '                 , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS X_NOTATION' || CHR(10) ||
        '                 , B.MEASURE_GROUP AS B_MEASURE_GROUP, B.SORT_ORDER_NO AS B_SORT_ORDER_NO' || CHR(10) ||
        '                 , CASE WHEN B.MEASURE IS NOT NULL THEN 1 ELSE 0 END AS B_HIT' || CHR(10) ||
        '                 , CASE WHEN D.FCST_TYPE IS NOT NULL THEN 1 ELSE 0 END AS D_HIT' || CHR(10) ||
        '                 , C.ITEM_VALID_YN AS C_ITEM_VALID_YN' || CHR(10) ||
        '                     , C.CELL_MODEL AS C_CELL_MODEL' || CHR(10) ||
        '                     , C.NICK_NAME AS C_NICK_NAME' || CHR(10) ||
        '                     , C.DMS_SALES AS C_DMS_SALES' || CHR(10) ||
        '                     , C.DMS_CUSTOMER AS C_DMS_CUSTOMER' || CHR(10) ||
        '                     , C.OWNER AS C_OWNER' || CHR(10) ||
        '                     , C.DEPT_ID AS C_DEPT_ID' || CHR(10) ||
        '                     , C.DEPT_NAME_KO AS C_DEPT_NAME_KO' || CHR(10) ||
        '                     , C.FORECAST_INFO_CELL_PACK_COUNT AS C_FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                     , C.ITEM_TYPE AS C_ITEM_TYPE' || CHR(10) ||
        '                     , C.PROJECT_NAME AS C_PROJECT_NAME' || CHR(10) ||
        '                     , C.PROJECT_OWNER AS C_PROJECT_OWNER' || CHR(10) ||
        '                     , C.BIZ_TYPE AS C_BIZ_TYPE' || CHR(10) ||
        '                     , C.SOLDTO_CUSTOMER AS C_SOLDTO_CUSTOMER' || CHR(10) ||
        '                     , C.COUNTRY_NAME AS C_COUNTRY_NAME' || CHR(10) ||
        '                     , C.CITY_NAME AS C_CITY_NAME' || CHR(10) ||
        '                     , C.PROJECT_STATUS AS C_PROJECT_STATUS' || CHR(10) ||
        '                     , C.ITEM_NAME AS C_ITEM_NAME' || CHR(10) ||
        '                     , C.VMI_YN AS C_VMI_YN' || CHR(10) ||
        '                     , C.CUST_GROUP AS C_CUST_GROUP' || CHR(10) ||
        '                     , C.CUST_GROUP_DTL AS C_CUST_GROUP_DTL' || CHR(10) ||
        '                     , C.APPLICATION AS C_APPLICATION' || CHR(10) ||
        '                     , C.ROUTE AS C_ROUTE' || CHR(10) ||
        '                     , C.MDM_PROJECT_NAME AS C_MDM_PROJECT_NAME' || CHR(10) ||
        '                     , C.MIN_CAPACITY AS C_MIN_CAPACITY' || CHR(10) ||
        '                     , C.FORECAST_INFO_BIZ_TYPE AS C_FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '                     , C.CELL_TYPE AS C_CELL_TYPE' || CHR(10) ||
        '                     , C.FORECAST_INFO_ALL AS C_FORECAST_INFO_ALL' || CHR(10) ||
        '                     , C.FORECAST_INFO_SPEC AS C_FORECAST_INFO_SPEC' || CHR(10) ||
        '                     , C.FORECAST_INFOR_VERSION AS C_FORECAST_INFOR_VERSION' || CHR(10) ||
        '                     , C.CELL_MODEL_NICK_NAME AS C_CELL_MODEL_NICK_NAME' || CHR(10) ||
        '                     , C.CELL_PER_CAR AS C_CELL_PER_CAR' || CHR(10) ||
        '                     , C.CELL_PER_MODULE AS C_CELL_PER_MODULE' || CHR(10) ||
        '                     , C.MODULE_PER_CAR AS C_MODULE_PER_CAR' || CHR(10) ||
        '                     , C.ENERGE AS C_ENERGE, C.CELL_QUANTITY AS C_CELL_QUANTITY, C.PROJECT_S_OP_REPORT AS C_PROJECT_S_OP_REPORT' || CHR(10) ||
        '                 , CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN 1 ELSE 0 END AS X_IN_P' || CHR(10) ||
        '                 , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END)' || CHR(10) ||
        '                       OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS X_LD_CD' || CHR(10) ||
        '                 , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END)' || CHR(10) ||
        '                       OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS X_LD_LU' || CHR(10) ||
        '                 , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE' || CHR(10) ||
        '                                      ORDER BY CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN 0 ELSE 1 END) AS X_RN' || CHR(10) ||
        '            FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A' || CHR(10) ||
        '            INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C            -- 유효여부 무관 (구 GTT 적재와 같은 읽기 집합)' || CHR(10) ||
        '                ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '                AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '                AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '                AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '            LEFT JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B         -- 수요 행 조건은 WHEN X_OUT 에서 (구 INNER JOIN 과 같은 행 배수)' || CHR(10) ||
        '                ON  B.MEASURE = A.MEASURE' || CHR(10) ||
        '            LEFT JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D' || CHR(10) ||
        '                ON  D.FCST_TYPE = A.FCST_TYPE' || CHR(10) ||
        '            WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '            AND    A.YYYYMMDD BETWEEN LEAST(p_from_yyyymmdd, V_FROM_YYYYMMDD) AND GREATEST(p_to_yyyymmdd, V_TO_YYYYMMDD)' || CHR(10) ||
        '        ) S;' || CHR(10) ||
        '        END IF;  --[DIV81]' || CHR(10);
    c_old4 CONSTANT VARCHAR2(32767) :=   -- 구 구간 4 (5418자)
        '        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE' || CHR(10) ||
        '        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS' || CHR(10) ||
        '        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP' || CHR(10) ||
        '        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO' || CHR(10) ||
        '        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE' || CHR(10) ||
        '        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN' || CHR(10) ||
        '        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY' || CHR(10) ||
        '        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC' || CHR(10) ||
        '        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE' || CHR(10) ||
        '        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE' || CHR(10) ||
        '        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT' || CHR(10) ||
        '        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)' || CHR(10) ||
        '        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ -- ④ [E20260815-PERF] 계획 고정.' || CHR(10) ||
        '                   -- GTT 는 세션 데이터라 통계가 없어 추정 카디널리티가 1 로 굳는다. 그 결과' || CHR(10) ||
        '                   -- GTT 3개를 MERGE JOIN CARTESIAN 으로 묶어 대형 테이블을 행별 NL 조회했다' || CHR(10) ||
        '                   -- (실측: buffer_gets 5,364만 / 결과 0행 / LINE18 인덱스스캔이 170초 점유).' || CHR(10) ||
        '                   -- A 를 DIVISION_ID+YYYYMMDD 로 먼저 좁히고 GTT 를 해시로 붙인다.' || CHR(10) ||
        '               A.DIVISION_ID' || CHR(10) ||
        '             , A.PROJECT_CODE' || CHR(10) ||
        '             , A.END_CUSTOMER' || CHR(10) ||
        '             , A.SCM_SITE_ID' || CHR(10) ||
        '             , A.ITEM_ID' || CHR(10) ||
        '             , A.DOM_EXP' || CHR(10) ||
        '             , A.FCST_TYPE' || CHR(10) ||
        '             , A.INCOTERMS' || CHR(10) ||
        '             , A.MEASURE' || CHR(10) ||
        '             , A.PLANT_SITE_ID' || CHR(10) ||
        '             , A.CELL_PROD_SITE_ID' || CHR(10) ||
        '             , A.YYYYMMDD' || CHR(10) ||
        '             , NVL(A.PRICE, 0)' || CHR(10) ||
        '             , B.MEASURE_GROUP' || CHR(10) ||
        '             , C.CELL_MODEL' || CHR(10) ||
        '             , C.NICK_NAME' || CHR(10) ||
        '             , C.DMS_SALES' || CHR(10) ||
        '             , C.DMS_CUSTOMER' || CHR(10) ||
        '             , C.OWNER' || CHR(10) ||
        '             , C.DEPT_ID' || CHR(10) ||
        '             , C.DEPT_NAME_KO' || CHR(10) ||
        '             , C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '             , C.ITEM_TYPE' || CHR(10) ||
        '             , C.PROJECT_NAME' || CHR(10) ||
        '             , C.PROJECT_OWNER' || CHR(10) ||
        '             , C.BIZ_TYPE' || CHR(10) ||
        '             , C.SOLDTO_CUSTOMER' || CHR(10) ||
        '             , C.COUNTRY_NAME' || CHR(10) ||
        '             , C.CITY_NAME' || CHR(10) ||
        '             , C.PROJECT_STATUS' || CHR(10) ||
        '             , C.ITEM_NAME' || CHR(10) ||
        '             , C.VMI_YN' || CHR(10) ||
        '             , C.CUST_GROUP' || CHR(10) ||
        '             , C.CUST_GROUP_DTL' || CHR(10) ||
        '             , C.APPLICATION' || CHR(10) ||
        '             , C.ROUTE' || CHR(10) ||
        '             , C.MDM_PROJECT_NAME' || CHR(10) ||
        '             , C.MIN_CAPACITY' || CHR(10) ||
        '             , C.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '             , C.CELL_TYPE' || CHR(10) ||
        '             , C.FORECAST_INFO_ALL' || CHR(10) ||
        '             , C.FORECAST_INFO_SPEC' || CHR(10) ||
        '             , C.FORECAST_INFOR_VERSION' || CHR(10) ||
        '             , C.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '             , C.CELL_PER_CAR' || CHR(10) ||
        '             , C.CELL_PER_MODULE' || CHR(10) ||
        '             , C.MODULE_PER_CAR' || CHR(10) ||
        '             , B.SORT_ORDER_NO' || CHR(10) ||
        '             , C.ENERGE' || CHR(10) ||
        '             , C.CELL_QUANTITY' || CHR(10) ||
        '             , '' '' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 ''-'' 표기 폐지(사용자 지시)' || CHR(10) ||
        '             , LD.CREATE_DATE' || CHR(10) ||
        '             , LD.LAST_UPDATED_BY' || CHR(10) ||
        '             , '''' AS SENDER_CODE' || CHR(10) ||
        '             , '''' AS SENDER_NAME' || CHR(10) ||
        '             , C.PROJECT_S_OP_REPORT' || CHR(10) ||
        '             , A.CURRENCY' || CHR(10) ||
        '             , ''Current'' AS VERSION_NO' || CHR(10) ||
        '             , NULL AS CUTOFF_YYYYMMDD' || CHR(10) ||
        '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10) ||
        '        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10) ||
        '            ON  B.MEASURE = A.MEASURE' || CHR(10) ||
        '        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.' || CHR(10) ||
        '                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10) ||
        '                     , MAX(CREATE_DATE) AS CREATE_DATE' || CHR(10) ||
        '                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY' || CHR(10) ||
        '                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE' || CHR(10) ||
        '                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10) ||
        '            ) LD' || CHR(10) ||
        '                ON  LD.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '                AND LD.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '                AND LD.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '                AND LD.DOM_EXP      = A.DOM_EXP' || CHR(10) ||
        '                AND LD.FCST_TYPE    = A.FCST_TYPE' || CHR(10) ||
        '                AND LD.INCOTERMS    = A.INCOTERMS' || CHR(10) ||
        '                AND LD.MEASURE      = A.MEASURE' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '            ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '            AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '            AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '            AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '            AND C.ITEM_VALID_YN = ''Y''' || CHR(10) ||
        '        WHERE  1 = 1' || CHR(10) ||
        '        /* ② [E20260815-PERF] 곱집합 배수 제거 — D 는 FCST_TYPE 등가 1개뿐이라 조인이 아니라 필터다.' || CHR(10) ||
        '           GT_DMF0082_T_WS_FCST 적재가 `SELECT DISTINCT SEGMENT1` 이라 FCST_TYPE 이 유일하므로' || CHR(10) ||
        '           EXISTS 로 바꿔도 **행수가 변하지 않는다**(의미 동일 — 적재문 실측 확인).' || CHR(10) ||
        '           조인으로 두면 드라이빙 곱집합에 14배로 곱해져 NL 반복을 그만큼 늘린다. */' || CHR(10) ||
        '        AND    EXISTS (SELECT 1' || CHR(10) ||
        '                       FROM   SCM_MGR.GT_DMF0082_T_WS_FCST D' || CHR(10) ||
        '                       WHERE  D.FCST_TYPE = A.FCST_TYPE)' || CHR(10) ||
        '        AND    A.DIVISION_ID = p_division_id' || CHR(10) ||
        '        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413)' || CHR(10) ||
        '        END IF;  --[DIV81]' || CHR(10);
    c_new4 CONSTANT VARCHAR2(32767) :=   -- 새 구간 4 (5877자)
        '        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE' || CHR(10) ||
        '        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS' || CHR(10) ||
        '        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP' || CHR(10) ||
        '        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO' || CHR(10) ||
        '        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE' || CHR(10) ||
        '        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN' || CHR(10) ||
        '        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY' || CHR(10) ||
        '        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC' || CHR(10) ||
        '        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE' || CHR(10) ||
        '        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE' || CHR(10) ||
        '        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT' || CHR(10) ||
        '        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)' || CHR(10) ||
        '        /*[E20261014-DMF0082ONEREAD40] 40 판가 원장 1회 읽기 — 구 T_LAST_DATA_SETUP_PRICE 적재(같은 원장 IDX07 범위 스캔) 제거분의' || CHR(10) ||
        '           최신 수정일자·수정자를 키 8개 PARTITION 윈도 MAX 로 여기서 계산 (81 [E20260930-DMF0082ONEREAD] 와 같은 형태 · 구 LD 조인과 등가).' || CHR(10) ||
        '           출력 범위는 바깥 WHERE (구 조건 그대로) · 힌트 = 구 문장 그대로 */' || CHR(10) ||
        '        SELECT C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, C26, C27, C28, C29, C30, C31, C32, C33, C34, C35, C36, C37, C38, C39, C40, C41, C42, C43, C44, C45, C46, C47, C48, C49, C50, C51, C52, C53, C54, C55, C56, C57, C58, C59, C60' || CHR(10) ||
        '        FROM (' || CHR(10) ||
        '        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ -- ④ [E20260815-PERF] 계획 고정.' || CHR(10) ||
        '                   -- GTT 는 세션 데이터라 통계가 없어 추정 카디널리티가 1 로 굳는다. 그 결과' || CHR(10) ||
        '                   -- GTT 3개를 MERGE JOIN CARTESIAN 으로 묶어 대형 테이블을 행별 NL 조회했다' || CHR(10) ||
        '                   -- (실측: buffer_gets 5,364만 / 결과 0행 / LINE18 인덱스스캔이 170초 점유).' || CHR(10) ||
        '                   -- A 를 DIVISION_ID+YYYYMMDD 로 먼저 좁히고 GTT 를 해시로 붙인다.' || CHR(10) ||
        '               A.DIVISION_ID AS C01' || CHR(10) ||
        '             , A.PROJECT_CODE AS C02' || CHR(10) ||
        '             , A.END_CUSTOMER AS C03' || CHR(10) ||
        '             , A.SCM_SITE_ID AS C04' || CHR(10) ||
        '             , A.ITEM_ID AS C05' || CHR(10) ||
        '             , A.DOM_EXP AS C06' || CHR(10) ||
        '             , A.FCST_TYPE AS C07' || CHR(10) ||
        '             , A.INCOTERMS AS C08' || CHR(10) ||
        '             , A.MEASURE AS C09' || CHR(10) ||
        '             , A.PLANT_SITE_ID AS C10' || CHR(10) ||
        '             , A.CELL_PROD_SITE_ID AS C11' || CHR(10) ||
        '             , A.YYYYMMDD AS C12' || CHR(10) ||
        '             , NVL(A.PRICE, 0) AS C13' || CHR(10) ||
        '             , B.MEASURE_GROUP AS C14' || CHR(10) ||
        '             , C.CELL_MODEL AS C15' || CHR(10) ||
        '             , C.NICK_NAME AS C16' || CHR(10) ||
        '             , C.DMS_SALES AS C17' || CHR(10) ||
        '             , C.DMS_CUSTOMER AS C18' || CHR(10) ||
        '             , C.OWNER AS C19' || CHR(10) ||
        '             , C.DEPT_ID AS C20' || CHR(10) ||
        '             , C.DEPT_NAME_KO AS C21' || CHR(10) ||
        '             , C.FORECAST_INFO_CELL_PACK_COUNT AS C22' || CHR(10) ||
        '             , C.ITEM_TYPE AS C23' || CHR(10) ||
        '             , C.PROJECT_NAME AS C24' || CHR(10) ||
        '             , C.PROJECT_OWNER AS C25' || CHR(10) ||
        '             , C.BIZ_TYPE AS C26' || CHR(10) ||
        '             , C.SOLDTO_CUSTOMER AS C27' || CHR(10) ||
        '             , C.COUNTRY_NAME AS C28' || CHR(10) ||
        '             , C.CITY_NAME AS C29' || CHR(10) ||
        '             , C.PROJECT_STATUS AS C30' || CHR(10) ||
        '             , C.ITEM_NAME AS C31' || CHR(10) ||
        '             , C.VMI_YN AS C32' || CHR(10) ||
        '             , C.CUST_GROUP AS C33' || CHR(10) ||
        '             , C.CUST_GROUP_DTL AS C34' || CHR(10) ||
        '             , C.APPLICATION AS C35' || CHR(10) ||
        '             , C.ROUTE AS C36' || CHR(10) ||
        '             , C.MDM_PROJECT_NAME AS C37' || CHR(10) ||
        '             , C.MIN_CAPACITY AS C38' || CHR(10) ||
        '             , C.FORECAST_INFO_BIZ_TYPE AS C39' || CHR(10) ||
        '             , C.CELL_TYPE AS C40' || CHR(10) ||
        '             , C.FORECAST_INFO_ALL AS C41' || CHR(10) ||
        '             , C.FORECAST_INFO_SPEC AS C42' || CHR(10) ||
        '             , C.FORECAST_INFOR_VERSION AS C43' || CHR(10) ||
        '             , C.CELL_MODEL_NICK_NAME AS C44' || CHR(10) ||
        '             , C.CELL_PER_CAR AS C45' || CHR(10) ||
        '             , C.CELL_PER_MODULE AS C46' || CHR(10) ||
        '             , C.MODULE_PER_CAR AS C47' || CHR(10) ||
        '             , B.SORT_ORDER_NO AS C48' || CHR(10) ||
        '             , C.ENERGE AS C49' || CHR(10) ||
        '             , C.CELL_QUANTITY AS C50' || CHR(10) ||
        '             , '' '' AS C51' || CHR(10) ||
        '             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS C52' || CHR(10) ||
        '             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS C53' || CHR(10) ||
        '             , '''' AS C54' || CHR(10) ||
        '             , '''' AS C55' || CHR(10) ||
        '             , C.PROJECT_S_OP_REPORT AS C56' || CHR(10) ||
        '             , A.CURRENCY AS C57' || CHR(10) ||
        '             , ''Current'' AS C58' || CHR(10) ||
        '             , NULL AS C59' || CHR(10) ||
        '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS C60' || CHR(10) ||
        '             , A.YYYYMMDD AS X_ONEREAD_YMD' || CHR(10) ||
        '        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10) ||
        '            ON  B.MEASURE = A.MEASURE' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10) ||
        '            ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '            AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '            AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '            AND C.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '            AND C.ITEM_VALID_YN = ''Y''' || CHR(10) ||
        '        WHERE  1 = 1' || CHR(10) ||
        '        /* ② [E20260815-PERF] 곱집합 배수 제거 — D 는 FCST_TYPE 등가 1개뿐이라 조인이 아니라 필터다.' || CHR(10) ||
        '           GT_DMF0082_T_WS_FCST 적재가 `SELECT DISTINCT SEGMENT1` 이라 FCST_TYPE 이 유일하므로' || CHR(10) ||
        '           EXISTS 로 바꿔도 **행수가 변하지 않는다**(의미 동일 — 적재문 실측 확인).' || CHR(10) ||
        '           조인으로 두면 드라이빙 곱집합에 14배로 곱해져 NL 반복을 그만큼 늘린다. */' || CHR(10) ||
        '        AND    EXISTS (SELECT 1' || CHR(10) ||
        '                       FROM   SCM_MGR.GT_DMF0082_T_WS_FCST D' || CHR(10) ||
        '                       WHERE  D.FCST_TYPE = A.FCST_TYPE)' || CHR(10) ||
        '        AND    A.DIVISION_ID = p_division_id' || CHR(10) ||
        '        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)' || CHR(10) ||
        '        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413) — 구 조건 그대로' || CHR(10) ||
        '        END IF;  --[DIV81]' || CHR(10);
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
    FUNCTION req(p_pos PLS_INTEGER, p_what VARCHAR2) RETURN PLS_INTEGER IS
    BEGIN
        IF p_pos IS NULL OR p_pos = 0 OR p_pos < v_main OR p_pos > v_cur THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_what || ' 위치 확인 불가(GET_MAIN_DATA 구간 밖 또는 없음). 원문 무변경');
        END IF;
        RETURN p_pos;
    END;
    PROCEDURE chk_len(p_i PLS_INTEGER, p_s PLS_INTEGER, p_e PLS_INTEGER, p_expect PLS_INTEGER, p_kind VARCHAR2) IS
    BEGIN
        IF p_e - p_s <> p_expect THEN
            RAISE_APPLICATION_ERROR(-20003, '중단 — ' || p_kind || ' 구간 ' || p_i || ' 길이 ' || (p_e - p_s) || '자 (' || p_expect || '자 기대) — 원문이 다름. 00_PRECHECK L1 회신. 원문 무변경');
        END IF;
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
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    s1 := req(DBMS_LOB.INSTR(v_src, c_n1, v_main), 'R1 시작');            e1 := req(DBMS_LOB.INSTR(v_src, c_e4, s1), 'R1 끝') + 1;
    s2 := req(DBMS_LOB.INSTR(v_src, c_n2, e1), 'R2 시작');                e2 := req(DBMS_LOB.INSTR(v_src, c_e4, s2), 'R2 끝') + 1;
    s3 := req(DBMS_LOB.INSTR(v_src, c_n3, e2), 'R3 시작') + 1;            e3 := req(DBMS_LOB.INSTR(v_src, c_e8, s3), 'R3 끝') + LENGTH(c_e8);
    p4 := req(DBMS_LOB.INSTR(v_src, c_a4p, e3), 'R4 기준(81 ONEREAD 끝)');
    s4 := req(DBMS_LOB.INSTR(v_src, c_a3, p4), 'R4 시작') + c_else8;     e4 := req(DBMS_LOB.INSTR(v_src, c_e8, s4), 'R4 끝') + LENGTH(c_e8);
    chk_len(1, s1, e1, 1177, '새');
    chk_len(2, s2, e2, 1434, '새');
    chk_len(3, s3, e3, 9074, '새');
    chk_len(4, s4, e4, 5877, '새');
    v_new := SUBSTR(v_src, 1, s1 - 1) || c_old1 || SUBSTR(v_src, e1, s2 - e1) || c_old2 || SUBSTR(v_src, e2, s3 - e2)
          || c_old3 || SUBSTR(v_src, e3, s4 - e3) || c_old4 || SUBSTR(v_src, e4);
    IF cnt(v_new, c_mark) <> 0 OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) - 4540 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 되돌린 결과 불일치. 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

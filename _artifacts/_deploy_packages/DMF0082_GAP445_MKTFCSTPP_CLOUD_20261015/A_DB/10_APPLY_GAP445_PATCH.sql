-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 14:12:14 FETCHED=2026-10-15 14:21 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP445 2026-10-15] GAP 445 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 Current · MF 분기 '계획구간 수요' 블록 바로 뒤에
--       MKT_FCST → MKT_FCST_PP 복사 적재 블록을 각 1개 넣는다 (같은 SP 의 SF 분기 블록과 같은 형태 · 81/82 · 40 테이블 분기 포함).
--       구: SF 분기에만 있어 Current·MF 조회 시 MKT FCST[P+P] 계획 수량이 거의 표시되지 않음(40 Current 29행 ↔ MKT_FCST 304행).
--       AS-IS 근거: DMF0082_GET_MAIN_DATA Current L1798~1895 · MF L3008~3108 (실행 문장 — 중첩주석 판정).
-- 범위: 조회 SP 블록 2개 삽입. 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 표지(Current/MF 분기 시작 줄 → 그 뒤 첫 'END IF;  --[DIV81]') 직후에 블록을 넣고
--       CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 분기 위치/삽입 위치 이상 시 중단 · 삽입 위치 앞 구간에 계획구간 원장이 없으면 중단(원문 무변경)
--       · 조립 길이 불일치 시 중단 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 14:12:14) — 40 Current 20260901~20270228: MKT_FCST_PP 29 → 309행 · 계획구간 값 MKT_FCST 와 키 302건·전 칸 일치.
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_m0     PLS_INTEGER;
    v_m1     PLS_INTEGER;
    v_cb     PLS_INTEGER;
    v_mb     PLS_INTEGER;
    v_sb     PLS_INTEGER;
    v_pos    PLS_INTEGER;
    v_end    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)  := 'GAP445 2026-10-15';
    c_enddiv CONSTANT VARCHAR2(100) := CHR(10) || '        END IF;  --[DIV81]' || CHR(10) || '';
    c_br_cur CONSTANT VARCHAR2(200) := CHR(10) || '    IF p_version_type LIKE ''%Current%'' OR p_version_type LIKE ''%current%'' THEN' || CHR(10) || '';
    c_br_mf  CONSTANT VARCHAR2(200) := CHR(10) || '    IF p_version_type LIKE ''%MF%'' THEN' || CHR(10) || '';
    c_br_sf  CONSTANT VARCHAR2(200) := CHR(10) || '    IF p_version_type LIKE ''%SF%'' THEN' || CHR(10) || '';
    c_cur    CONSTANT VARCHAR2(32767) :=   -- Current 삽입분 (빈 줄 + 블록, 사내 적용본과 동일 문구)
        '' || CHR(10) ||
        '        /* [GAP445 2026-10-15] MKT_FCST [P+P] Current 계획구간 — MKT_FCST 를 MKT_FCST_PP 로 복사 적재 (AS-IS DMF0082_GET_MAIN_DATA L1798~1895 실행 문장).' || CHR(10) ||
        '           구: SF 분기에만 있어 Current 조회 시 MKT_FCST_PP 가 실적 일부 조합만 표시(40 Current 29행 ↔ MKT_FCST 304행). 아래 SF 블록과 같은 형태. */' || CHR(10) ||
        '        IF (p_division_id LIKE ''81%'' OR p_division_id = ''82'') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)' || CHR(10) ||
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
        '        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE /*[DIV81] END_CUSTOMER=PROJECT_CODE*/, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS' || CHR(10) ||
        '             , ''MKT_FCST_PP'' AS MEASURE' || CHR(10) ||
        '             , A.PLANT_SITE_ID, ''-'' /*[DIV81]*/, A.YYYYMMDD, A.QTY' || CHR(10) ||
        '             , B.MEASURE_GROUP' || CHR(10) ||
        '             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER' || CHR(10) ||
        '             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE' || CHR(10) ||
        '             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS' || CHR(10) ||
        '             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL' || CHR(10) ||
        '             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY' || CHR(10) ||
        '             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL' || CHR(10) ||
        '             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO' || CHR(10) ||
        '             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10) ||
        '             , LD.CREATE_DATE, LD.LAST_UPDATED_BY' || CHR(10) ||
        '             , '''' AS SENDER_CODE, '''' AS SENDER_NAME, C.PROJECT_S_OP_REPORT' || CHR(10) ||
        '             , '''' AS CURRENCY, ''Current'' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD' || CHR(10) ||
        '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10) ||
        '        FROM   SCM_MGR.DM_PLN_MKT_FCST A' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10) ||
        '            ON  A.MEASURE = ''MKT_FCST'' AND B.MEASURE = ''MKT_FCST_PP''' || CHR(10) ||
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
        '            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE' || CHR(10) ||
        '            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN=''Y''' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE' || CHR(10) ||
        '        WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10) ||
        '        AND    A.QTY <> 0;' || CHR(10) ||
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
        '        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS' || CHR(10) ||
        '             , ''MKT_FCST_PP'' AS MEASURE' || CHR(10) ||
        '             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY' || CHR(10) ||
        '             , B.MEASURE_GROUP' || CHR(10) ||
        '             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER' || CHR(10) ||
        '             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE' || CHR(10) ||
        '             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS' || CHR(10) ||
        '             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL' || CHR(10) ||
        '             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY' || CHR(10) ||
        '             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL' || CHR(10) ||
        '             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO' || CHR(10) ||
        '             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10) ||
        '             , LD.CREATE_DATE, LD.LAST_UPDATED_BY' || CHR(10) ||
        '             , '''' AS SENDER_CODE, '''' AS SENDER_NAME, C.PROJECT_S_OP_REPORT' || CHR(10) ||
        '             , '''' AS CURRENCY, ''Current'' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD' || CHR(10) ||
        '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10) ||
        '        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10) ||
        '            ON  A.MEASURE = ''MKT_FCST'' AND B.MEASURE = ''MKT_FCST_PP''' || CHR(10) ||
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
        '            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE' || CHR(10) ||
        '            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN=''Y''' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE' || CHR(10) ||
        '        WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10) ||
        '        AND    A.QTY <> 0;' || CHR(10) ||
        '        END IF;  --[DIV81]' || CHR(10);
    c_mf     CONSTANT VARCHAR2(32767) :=   -- MF 삽입분 (빈 줄 + 블록, 사내 적용본과 동일 문구)
        '' || CHR(10) ||
        '        /* [GAP445 2026-10-15] MKT_FCST [P+P] MF 계획구간 — MKT_FCST 를 MKT_FCST_PP 로 복사 적재 (AS-IS DMF0082_GET_MAIN_DATA L3008~3108 실행 문장).' || CHR(10) ||
        '           구: SF 분기에만 있어 MF 버전 조회 시 MKT_FCST_PP 계획구간 미표시. 아래 SF 블록과 같은 형태. */' || CHR(10) ||
        '        IF (p_division_id LIKE ''81%'' OR p_division_id = ''82'') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)' || CHR(10) ||
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
        '        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE /*[DIV81] END_CUSTOMER=PROJECT_CODE*/, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS' || CHR(10) ||
        '             , ''MKT_FCST_PP'' AS MEASURE' || CHR(10) ||
        '             , A.PLANT_SITE_ID, ''-'' /*[DIV81]*/, A.YYYYMMDD, A.QTY' || CHR(10) ||
        '             , B.MEASURE_GROUP' || CHR(10) ||
        '             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER' || CHR(10) ||
        '             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE' || CHR(10) ||
        '             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS' || CHR(10) ||
        '             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL' || CHR(10) ||
        '             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY' || CHR(10) ||
        '             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL' || CHR(10) ||
        '             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO' || CHR(10) ||
        '             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10) ||
        '             , LD.CREATE_DATE, LD.LAST_UPDATED_BY' || CHR(10) ||
        '             , '''' AS SENDER_CODE, '''' AS SENDER_NAME, C.PROJECT_S_OP_REPORT' || CHR(10) ||
        '             , '''' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD' || CHR(10) ||
        '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10) ||
        '        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10) ||
        '            ON  A.MEASURE = ''MKT_FCST'' AND B.MEASURE = ''MKT_FCST_PP''' || CHR(10) ||
        '        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.' || CHR(10) ||
        '                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10) ||
        '                     , MAX(CREATE_DATE) AS CREATE_DATE' || CHR(10) ||
        '                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY' || CHR(10) ||
        '                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C' || CHR(10) ||
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
        '            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE' || CHR(10) ||
        '            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN=''Y''' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE ''MF%''' || CHR(10) ||
        '        WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10) ||
        '        AND    A.QTY <> 0;' || CHR(10) ||
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
        '        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10) ||
        '             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS' || CHR(10) ||
        '             , ''MKT_FCST_PP'' AS MEASURE' || CHR(10) ||
        '             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY' || CHR(10) ||
        '             , B.MEASURE_GROUP' || CHR(10) ||
        '             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER' || CHR(10) ||
        '             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE' || CHR(10) ||
        '             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS' || CHR(10) ||
        '             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL' || CHR(10) ||
        '             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY' || CHR(10) ||
        '             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL' || CHR(10) ||
        '             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO' || CHR(10) ||
        '             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10) ||
        '             , LD.CREATE_DATE, LD.LAST_UPDATED_BY' || CHR(10) ||
        '             , '''' AS SENDER_CODE, '''' AS SENDER_NAME, C.PROJECT_S_OP_REPORT' || CHR(10) ||
        '             , '''' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD' || CHR(10) ||
        '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10) ||
        '        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10) ||
        '            ON  A.MEASURE = ''MKT_FCST'' AND B.MEASURE = ''MKT_FCST_PP''' || CHR(10) ||
        '        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.' || CHR(10) ||
        '                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10) ||
        '                     , MAX(CREATE_DATE) AS CREATE_DATE' || CHR(10) ||
        '                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY' || CHR(10) ||
        '                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C' || CHR(10) ||
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
        '            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE' || CHR(10) ||
        '            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN=''Y''' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE' || CHR(10) ||
        '        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE ''MF%''' || CHR(10) ||
        '        WHERE  A.DIVISION_ID = p_division_id' || CHR(10) ||
        '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10) ||
        '        AND    A.QTY <> 0;' || CHR(10) ||
        '        END IF;  --[DIV81]' || CHR(10);
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
    PROCEDURE locate(p_src CLOB) IS
    BEGIN
        v_m0 := DBMS_LOB.INSTR(p_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
        v_m1 := DBMS_LOB.INSTR(p_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
        v_cb := DBMS_LOB.INSTR(p_src, c_br_cur, v_m0);
        v_mb := DBMS_LOB.INSTR(p_src, c_br_mf, v_m0);
        v_sb := DBMS_LOB.INSTR(p_src, c_br_sf, v_m0);
        IF NOT (v_m0 > 0 AND v_m0 < v_cb AND v_cb < v_mb AND v_mb < v_sb AND v_sb < v_m1) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — GET_MAIN_DATA 의 Current/MF/SF 분기 위치 확인 불가. 00_PRECHECK L1 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    locate(v_src);
    -- Current: 분기 시작 뒤 첫 END IF --[DIV81] 직후 (그 사이에 Current 계획구간 원장 적재가 있어야 함)
    v_end := DBMS_LOB.INSTR(v_src, c_enddiv, v_cb);
    IF v_end = 0 OR v_end > v_mb
       OR cnt(v_src, 'SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A', v_cb, v_end) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — Current 계획구간 수요 블록 끝 확인 불가. 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := v_end + LENGTH(c_enddiv);   -- 삽입 위치 (END IF 줄 다음 줄 첫 글자)
    v_new := SUBSTR(v_src, 1, v_pos - 1) || c_cur || SUBSTR(v_src, v_pos);
    -- MF: 같은 방식 (조립본에서 다시 위치 계산)
    locate(v_new);
    v_end := DBMS_LOB.INSTR(v_new, c_enddiv, v_mb);
    IF v_end = 0 OR v_end > v_sb
       OR cnt(v_new, 'SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A', v_mb, v_end) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — MF 계획구간 수요 블록 끝 확인 불가. 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := v_end + LENGTH(c_enddiv);
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_mf || SUBSTR(v_new, v_pos);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 2
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + LENGTH(c_cur) + LENGTH(c_mf) THEN
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 2곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 15:14:53 FETCHED=2026-10-15 15:16 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP446 2026-10-15] GAP 446 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 과거 버전(SF/MF/SP) 조회를 AS-IS DMF0082_GET_MAIN_DATA 실행 문장과 같게 5종 고친다.
--   C1 버전 기준일 NOW_YYYYMMDD = 버전일이 속한 주 월요일 (AS-IS L256 / 구: 버전일 - 7)
--   C2 MF 계획(81·40) 에 '버전 주 월요일 이후' 조건 (AS-IS L2775)        C3 MF 판가(81·40) 에 같은 조건 (AS-IS L3415)
--   C4 SF 계획 = 확정 수요 컷오프(40 DM_PLN_CFM_MKT_DEMAND_PLAN_C / 81·82 DM_PLN_MKT_FCST_C) + 같은 조건 (AS-IS L4262~4369)
--      — 구: AS-IS 에서 주석 처리된 실적 테이블(DM_PLN_MKT_FCST_RESULT_C)을 읽어 계획구간 MKT FCST·SCM FCST·RTF 가 빠짐
--   C5 SP 버전 Unit Price 계산 뒤 실적 3종(MKT_AMT_KRW/LOC · RTF_SYS_RP) 삭제 (AS-IS L4235~4238 / 구: RTF[R+P] 행이 화면에 남음)
-- 범위: 조회 SP 만. 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 토큰으로 위치를 찾고 연산 7개를 순서대로 적용 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 연산마다 대상 건수가 기대와 다르면 중단(원문 무변경) · 마커 9곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 15:14:53) — 측정은 00_README.md 참조.
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_blk    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)  := 'GAP446 2026-10-15';
    c_enddiv CONSTANT VARCHAR2(100) := '        END IF;  --[DIV81]' || CHR(10) || '';
    c_br_mf  CONSTANT VARCHAR2(100) := '    IF p_version_type LIKE ''%MF%'' THEN' || CHR(10) || '';
    c_br_sf  CONSTANT VARCHAR2(100) := '    IF p_version_type LIKE ''%SF%'' THEN' || CHR(10) || '';
    c_pp     CONSTANT VARCHAR2(100) := '        -- MKT_FCST_PP SF ';
    c1_old   CONSTANT VARCHAR2(300) := '             , TO_CHAR(TO_DATE(B.YYYYMMDD, ''YYYYMMDD'') - 7, ''YYYYMMDD'') AS NOW_YYYYMMDD';
    c1_pfx   CONSTANT VARCHAR2(300) := '             , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(B.YYYYMMDD, ''YYYYMMDD''), ''MON'') - 7, ''YYYYMMDD'') AS NOW_YYYYMMDD  --[GAP446 2026-10-15]';
    c1_line  CONSTANT VARCHAR2(1000) := '             , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(B.YYYYMMDD, ''YYYYMMDD''), ''MON'') - 7, ''YYYYMMDD'') AS NOW_YYYYMMDD  --[GAP446 2026-10-15] AS-IS L256 = 버전일이 속한 주 월요일 (구: 버전일 - 7)' || CHR(10) || '';
    c2_tok   CONSTANT VARCHAR2(300) := '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10) || '        AND    A.QTY <> 0;' || CHR(10) || '';
    c2_pfx   CONSTANT VARCHAR2(300) := '        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD  --[GAP446 2026-10-15]';
    c2_line  CONSTANT VARCHAR2(1000) := '        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD  --[GAP446 2026-10-15] AS-IS L2775/L4362 (버전 주 월요일 이후 계획만)' || CHR(10) || '';
    c3_tok   CONSTANT VARCHAR2(300) := '        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12]';
    c3_tok2  CONSTANT VARCHAR2(300) := '        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD  -- [DATE ROOT FIX 2026-07-12]';
    c3_pfx   CONSTANT VARCHAR2(300) := '        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;  --[GAP446 2026-10-15]';
    c3_line  CONSTANT VARCHAR2(1000) := '        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;  --[GAP446 2026-10-15] AS-IS L3415 (버전 주 월요일 이후 판가만)' || CHR(10) || '';
    c5_tok   CONSTANT VARCHAR2(300) := '            END) IS NOT NULL;' || CHR(10) || '' || CHR(10) || '    END IF;' || CHR(10) || '';
    c5_start CONSTANT VARCHAR2(100) := '' || CHR(10) || '    /* [GAP446 2026-10-15] SP';
    c5_end   CONSTANT VARCHAR2(300) := '     WHERE A.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'', ''RTF_SYS_RP'');' || CHR(10) || '';
    c5_del   CONSTANT VARCHAR2(2000) := '' || CHR(10) || '    /* [GAP446 2026-10-15] SP 버전 — Unit Price 계산에 쓴 실적 3종 삭제 (AS-IS L4235~4238, 삭제하지 않으면 화면에 보임). */' || CHR(10) || '    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A' || CHR(10) || '     WHERE A.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'', ''RTF_SYS_RP'');' || CHR(10) || '';
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    -- 범위: p_lo_tok NULL = GET_MAIN_DATA 전체 / 아니면 GET_MAIN_DATA 시작 뒤 p_lo_tok ~ 그 뒤 p_hi_tok
    PROCEDURE rng(p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, o_lo OUT PLS_INTEGER, o_hi OUT PLS_INTEGER) IS
        m0 PLS_INTEGER; m1 PLS_INTEGER;
    BEGIN
        m0 := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
        m1 := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
        IF NOT (m0 > 0 AND m0 < m1) THEN RAISE_APPLICATION_ERROR(-20002, '중단 — GET_MAIN_DATA 위치 확인 불가. 원문 무변경'); END IF;
        IF p_lo_tok IS NULL THEN o_lo := m0; o_hi := m1; RETURN; END IF;
        o_lo := DBMS_LOB.INSTR(v_new, p_lo_tok, m0);
        o_hi := CASE WHEN o_lo > 0 THEN DBMS_LOB.INSTR(v_new, p_hi_tok, o_lo + LENGTH(p_lo_tok)) ELSE 0 END;
        IF NOT (o_lo > m0 AND o_hi > o_lo AND o_hi < m1) THEN RAISE_APPLICATION_ERROR(-20002, '중단 — 분기 범위 확인 불가. 00_PRECHECK 회신. 원문 무변경'); END IF;
    END;
    PROCEDURE op_tok(p_name VARCHAR2, p_tok VARCHAR2, p_new CLOB, p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER;
    BEGIN
        rng(p_lo_tok, p_hi_tok, lo, hi);
        IF cnt(v_new, p_tok, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_tok, lo, hi) || '건 (' || p_n || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
        FOR i IN 1 .. p_n LOOP
            rng(p_lo_tok, p_hi_tok, lo, hi);
            pos := DBMS_LOB.INSTR(v_new, p_tok, lo);
            v_new := SUBSTR(v_new, 1, pos - 1) || p_new || SUBSTR(v_new, pos + LENGTH(p_tok));
        END LOOP;
    END;
    PROCEDURE op_line(p_name VARCHAR2, p_prefix VARCHAR2, p_new CLOB, p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(p_lo_tok, p_hi_tok, lo, hi);
        IF cnt(v_new, CHR(10) || p_prefix, lo - 1, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 줄 ' || cnt(v_new, CHR(10) || p_prefix, lo - 1, hi) || '건 (' || p_n || ' 기대). 원문 무변경');
        END IF;
        FOR i IN 1 .. p_n LOOP
            rng(p_lo_tok, p_hi_tok, lo, hi);
            pos := DBMS_LOB.INSTR(v_new, CHR(10) || p_prefix, lo - 1) + 1;
            e   := DBMS_LOB.INSTR(v_new, CHR(10), pos) + 1;
            v_new := SUBSTR(v_new, 1, pos - 1) || p_new || SUBSTR(v_new, e);
        END LOOP;
    END;
    PROCEDURE op_after_line(p_name VARCHAR2, p_tok VARCHAR2, p_ins VARCHAR2, p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER; e PLS_INTEGER; st PLS_INTEGER;
    BEGIN
        rng(p_lo_tok, p_hi_tok, lo, hi);
        IF cnt(v_new, p_tok, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_tok, lo, hi) || '건 (' || p_n || ' 기대). 원문 무변경');
        END IF;
        st := lo;
        FOR i IN 1 .. p_n LOOP
            pos := DBMS_LOB.INSTR(v_new, p_tok, st);
            e   := DBMS_LOB.INSTR(v_new, CHR(10), pos) + 1;
            v_new := SUBSTR(v_new, 1, e - 1) || p_ins || SUBSTR(v_new, e);
            st := e + LENGTH(p_ins);
        END LOOP;
    END;
    PROCEDURE op_span(p_name VARCHAR2, p_start VARCHAR2, p_end VARCHAR2, p_new CLOB, p_guard VARCHAR2) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(NULL, NULL, lo, hi);
        IF cnt(v_new, p_start, lo, hi) <> 1 THEN RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 시작 위치 1건 아님. 원문 무변경'); END IF;
        s := DBMS_LOB.INSTR(v_new, p_start, lo) + LENGTH(p_start);
        e := DBMS_LOB.INSTR(v_new, p_end, s);
        IF e = 0 OR e > hi OR cnt(v_new, p_guard, s, e) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 구간 확인 불가(표지 없음). 00_PRECHECK 회신. 원문 무변경');
        END IF;
        v_new := SUBSTR(v_new, 1, s - 1) || p_new || SUBSTR(v_new, e);
    END;
    PROCEDURE op_cut(p_name VARCHAR2, p_start VARCHAR2, p_end VARCHAR2) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(NULL, NULL, lo, hi);
        IF cnt(v_new, p_start, lo, hi) <> 1 THEN RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 블록 1건 아님. 원문 무변경'); END IF;
        s := DBMS_LOB.INSTR(v_new, p_start, lo);
        e := DBMS_LOB.INSTR(v_new, p_end, s);
        IF e = 0 OR e - s > 2000 THEN RAISE_APPLICATION_ERROR(-20002, '중단 — ' || p_name || ' 블록 끝 위치 이상. 원문 무변경'); END IF;
        v_new := SUBSTR(v_new, 1, s - 1) || SUBSTR(v_new, e + LENGTH(p_end));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_blk, TRUE);
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '' || CHR(10)
            || '        /* [GAP446 2026-10-15] SF 계획구간 수요 = 확정 수요 컷오프(40 DM_PLN_CFM_MKT_DEMAND_PLAN_C / 81·82 DM_PLN_MKT_FCST_C) — AS-IS L4262~4369 실행 문장.' || CHR(10)
            || '           구: AS-IS 에서 주석 처리된 실적 구간 DM_PLN_MKT_FCST_RESULT_C 를 읽어 계획구간 MKT FCST·SCM FCST·RTF 행이 빠짐.' || CHR(10)
            || '           위 MF 계획 블록과 같은 형태(버전 ''SF%'' · 버전 주 월요일 이후). */' || CHR(10)
            || '        -- 계획구간 수요 (SF Cutoff)' || CHR(10)
            || '        IF (p_division_id LIKE ''81%'' OR p_division_id = ''82'') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)' || CHR(10)
            || '        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE' || CHR(10)
            || '        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS' || CHR(10)
            || '        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP' || CHR(10)
            || '        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO' || CHR(10)
            || '        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE' || CHR(10)
            || '        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN' || CHR(10)
            || '        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY' || CHR(10)
            || '        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC' || CHR(10)
            || '        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE' || CHR(10)
            || '        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE' || CHR(10)
            || '        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT' || CHR(10)
            || '        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)' || CHR(10)
            || '        SELECT A.DIVISION_ID' || CHR(10)
            || '             , A.PROJECT_CODE' || CHR(10)
            || '             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE' || CHR(10)
            || '             , A.SCM_SITE_ID' || CHR(10)
            || '             , A.ITEM_ID' || CHR(10)
            || '             , A.DOM_EXP' || CHR(10)
            || '             , A.FCST_TYPE' || CHR(10)
            || '             , A.INCOTERMS' || CHR(10)
            || '             , A.MEASURE' || CHR(10)
            || '             , A.PLANT_SITE_ID' || CHR(10)
            || '             , ''-'' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재    -- MS 원본이 ''-''    --  2026.10.12 AJS' || CHR(10)
            || '             , A.YYYYMMDD' || CHR(10)
            || '             , A.QTY' || CHR(10)
            || '             , B.MEASURE_GROUP' || CHR(10)
            || '             , C.CELL_MODEL' || CHR(10)
            || '             , C.NICK_NAME' || CHR(10)
            || '             , C.DMS_SALES' || CHR(10)
            || '             , C.DMS_CUSTOMER' || CHR(10)
            || '             , C.OWNER' || CHR(10)
            || '             , C.DEPT_ID' || CHR(10)
            || '             , C.DEPT_NAME_KO' || CHR(10)
            || '             , C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10)));
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '             , C.ITEM_TYPE' || CHR(10)
            || '             , C.PROJECT_NAME' || CHR(10)
            || '             , C.PROJECT_OWNER' || CHR(10)
            || '             , C.BIZ_TYPE' || CHR(10)
            || '             , C.SOLDTO_CUSTOMER' || CHR(10)
            || '             , C.COUNTRY_NAME' || CHR(10)
            || '             , C.CITY_NAME' || CHR(10)
            || '             , C.PROJECT_STATUS' || CHR(10)
            || '             , C.ITEM_NAME' || CHR(10)
            || '             , C.VMI_YN' || CHR(10)
            || '             , C.CUST_GROUP' || CHR(10)
            || '             , C.CUST_GROUP_DTL' || CHR(10)
            || '             , C.APPLICATION' || CHR(10)
            || '             , C.ROUTE' || CHR(10)
            || '             , C.MDM_PROJECT_NAME' || CHR(10)
            || '             , C.MIN_CAPACITY' || CHR(10)
            || '             , C.FORECAST_INFO_BIZ_TYPE' || CHR(10)
            || '             , C.CELL_TYPE' || CHR(10)
            || '             , C.FORECAST_INFO_ALL' || CHR(10)
            || '             , C.FORECAST_INFO_SPEC' || CHR(10)
            || '             , C.FORECAST_INFOR_VERSION' || CHR(10)
            || '             , C.CELL_MODEL_NICK_NAME' || CHR(10)
            || '             , C.CELL_PER_CAR' || CHR(10)
            || '             , C.CELL_PER_MODULE' || CHR(10)
            || '             , C.MODULE_PER_CAR' || CHR(10)
            || '             , B.SORT_ORDER_NO' || CHR(10)
            || '             , C.ENERGE' || CHR(10)
            || '             , C.CELL_QUANTITY' || CHR(10)
            || '             , NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10)
            || '             , LD.CREATE_DATE' || CHR(10)
            || '             , LD.LAST_UPDATED_BY' || CHR(10)
            || '             , '''' AS SENDER_CODE' || CHR(10)
            || '             , '''' AS SENDER_NAME' || CHR(10)
            || '             , C.PROJECT_S_OP_REPORT' || CHR(10)
            || '             , '''' AS CURRENCY' || CHR(10)
            || '             , F.VERSION_NO' || CHR(10)
            || '             , A.CUTOFF_YYYYMMDD' || CHR(10)
            || '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10)
            || '        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10)));
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '            ON  B.MEASURE = A.MEASURE' || CHR(10)
            || '        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.' || CHR(10)
            || '                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10)
            || '                     , MAX(CREATE_DATE) AS CREATE_DATE' || CHR(10)
            || '                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY' || CHR(10)
            || '                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C' || CHR(10)
            || '                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10)
            || '            ) LD' || CHR(10)
            || '                ON  LD.DIVISION_ID  = A.DIVISION_ID' || CHR(10)
            || '                AND LD.PROJECT_CODE = A.PROJECT_CODE' || CHR(10)
            || '                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10)
            || '                AND LD.ITEM_ID      = A.ITEM_ID' || CHR(10)
            || '                AND LD.DOM_EXP      = A.DOM_EXP' || CHR(10)
            || '                AND LD.FCST_TYPE    = A.FCST_TYPE' || CHR(10)
            || '                AND LD.INCOTERMS    = A.INCOTERMS' || CHR(10)
            || '                AND LD.MEASURE      = A.MEASURE' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10)
            || '            ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10)
            || '            AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10)
            || '            AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10)
            || '            AND C.ITEM_ID      = A.ITEM_ID' || CHR(10)
            || '            AND C.ITEM_VALID_YN = ''Y''' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D' || CHR(10)
            || '            ON  D.FCST_TYPE = A.FCST_TYPE' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F' || CHR(10)
            || '            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE ''SF%''' || CHR(10)
            || '        WHERE  1 = 1' || CHR(10)
            || '        AND    A.DIVISION_ID = p_division_id' || CHR(10)
            || '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10)
            || '        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD  --[GAP446 2026-10-15] AS-IS L2775/L4362 (버전 주 월요일 이후 계획만)' || CHR(10)
            || '        AND    A.QTY <> 0;' || CHR(10)
            || '        ELSE' || CHR(10)
            || '        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE' || CHR(10)
            || '        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS' || CHR(10)
            || '        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP' || CHR(10)
            || '        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO' || CHR(10)
            || '        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE' || CHR(10)
            || '        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN' || CHR(10)
            || '        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY' || CHR(10)
            || '        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC' || CHR(10)));
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE' || CHR(10)
            || '        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE' || CHR(10)
            || '        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT' || CHR(10)
            || '        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)' || CHR(10)
            || '        SELECT A.DIVISION_ID' || CHR(10)
            || '             , A.PROJECT_CODE' || CHR(10)
            || '             , A.END_CUSTOMER' || CHR(10)
            || '             , A.SCM_SITE_ID' || CHR(10)
            || '             , A.ITEM_ID' || CHR(10)
            || '             , A.DOM_EXP' || CHR(10)
            || '             , A.FCST_TYPE' || CHR(10)
            || '             , A.INCOTERMS' || CHR(10)
            || '             , A.MEASURE' || CHR(10)
            || '             , A.PLANT_SITE_ID' || CHR(10)
            || '             , A.CELL_PROD_SITE_ID' || CHR(10)
            || '             , A.YYYYMMDD' || CHR(10)
            || '             , A.QTY' || CHR(10)
            || '             , B.MEASURE_GROUP' || CHR(10)
            || '             , C.CELL_MODEL' || CHR(10)
            || '             , C.NICK_NAME' || CHR(10)
            || '             , C.DMS_SALES' || CHR(10)
            || '             , C.DMS_CUSTOMER' || CHR(10)
            || '             , C.OWNER' || CHR(10)
            || '             , C.DEPT_ID' || CHR(10)
            || '             , C.DEPT_NAME_KO' || CHR(10)
            || '             , C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10)
            || '             , C.ITEM_TYPE' || CHR(10)
            || '             , C.PROJECT_NAME' || CHR(10)
            || '             , C.PROJECT_OWNER' || CHR(10)
            || '             , C.BIZ_TYPE' || CHR(10)
            || '             , C.SOLDTO_CUSTOMER' || CHR(10)
            || '             , C.COUNTRY_NAME' || CHR(10)
            || '             , C.CITY_NAME' || CHR(10)
            || '             , C.PROJECT_STATUS' || CHR(10)
            || '             , C.ITEM_NAME' || CHR(10)
            || '             , C.VMI_YN' || CHR(10)
            || '             , C.CUST_GROUP' || CHR(10)
            || '             , C.CUST_GROUP_DTL' || CHR(10)
            || '             , C.APPLICATION' || CHR(10)
            || '             , C.ROUTE' || CHR(10)));
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '             , C.MDM_PROJECT_NAME' || CHR(10)
            || '             , C.MIN_CAPACITY' || CHR(10)
            || '             , C.FORECAST_INFO_BIZ_TYPE' || CHR(10)
            || '             , C.CELL_TYPE' || CHR(10)
            || '             , C.FORECAST_INFO_ALL' || CHR(10)
            || '             , C.FORECAST_INFO_SPEC' || CHR(10)
            || '             , C.FORECAST_INFOR_VERSION' || CHR(10)
            || '             , C.CELL_MODEL_NICK_NAME' || CHR(10)
            || '             , C.CELL_PER_CAR' || CHR(10)
            || '             , C.CELL_PER_MODULE' || CHR(10)
            || '             , C.MODULE_PER_CAR' || CHR(10)
            || '             , B.SORT_ORDER_NO' || CHR(10)
            || '             , C.ENERGE' || CHR(10)
            || '             , C.CELL_QUANTITY' || CHR(10)
            || '             , NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10)
            || '             , LD.CREATE_DATE' || CHR(10)
            || '             , LD.LAST_UPDATED_BY' || CHR(10)
            || '             , '''' AS SENDER_CODE' || CHR(10)
            || '             , '''' AS SENDER_NAME' || CHR(10)
            || '             , C.PROJECT_S_OP_REPORT' || CHR(10)
            || '             , '''' AS CURRENCY' || CHR(10)
            || '             , F.VERSION_NO' || CHR(10)
            || '             , A.CUTOFF_YYYYMMDD' || CHR(10)
            || '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10)
            || '        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B' || CHR(10)
            || '            ON  B.MEASURE = A.MEASURE' || CHR(10)
            || '        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.' || CHR(10)
            || '                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10)
            || '                     , MAX(CREATE_DATE) AS CREATE_DATE' || CHR(10)
            || '                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY' || CHR(10)
            || '                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C' || CHR(10)
            || '                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10)
            || '            ) LD' || CHR(10)
            || '                ON  LD.DIVISION_ID  = A.DIVISION_ID' || CHR(10)
            || '                AND LD.PROJECT_CODE = A.PROJECT_CODE' || CHR(10)
            || '                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10)
            || '                AND LD.ITEM_ID      = A.ITEM_ID' || CHR(10)
            || '                AND LD.DOM_EXP      = A.DOM_EXP' || CHR(10)
            || '                AND LD.FCST_TYPE    = A.FCST_TYPE' || CHR(10)));
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '                AND LD.INCOTERMS    = A.INCOTERMS' || CHR(10)
            || '                AND LD.MEASURE      = A.MEASURE' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10)
            || '            ON  C.DIVISION_ID  = A.DIVISION_ID' || CHR(10)
            || '            AND C.PROJECT_CODE = A.PROJECT_CODE' || CHR(10)
            || '            AND C.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10)
            || '            AND C.ITEM_ID      = A.ITEM_ID' || CHR(10)
            || '            AND C.ITEM_VALID_YN = ''Y''' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D' || CHR(10)
            || '            ON  D.FCST_TYPE = A.FCST_TYPE' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F' || CHR(10)
            || '            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE ''SF%''' || CHR(10)
            || '        WHERE  1 = 1' || CHR(10)
            || '        AND    A.DIVISION_ID = p_division_id' || CHR(10)
            || '        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD' || CHR(10)
            || '        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD  --[GAP446 2026-10-15] AS-IS L2775/L4362 (버전 주 월요일 이후 계획만)' || CHR(10)
            || '        AND    A.QTY <> 0;' || CHR(10)
            || '        END IF;  --[DIV81]' || CHR(10)
            || '' || CHR(10)
            || ''));
    -- C1
    op_line('C1 NOW 산식', c1_old, c1_line, NULL, NULL, 1);
    -- C2 MF 계획 (MF 분기 시작 ~ 첫 END IF --[DIV81])
    op_tok('C2 MF 계획', c2_tok, REPLACE(c2_tok, '        AND    A.QTY <> 0;' || CHR(10), c2_line || '        AND    A.QTY <> 0;' || CHR(10)), c_br_mf, c_enddiv, 2);
    -- C3 MF 판가 (MF 분기 ~ SF 분기): 세미콜론을 다음 줄로 옮기고 NOW 줄 삽입
    op_tok('C3 MF 판가', c3_tok, c3_tok2, c_br_mf, c_br_sf, 2);
    op_after_line('C3 MF 판가 NOW', c3_tok2, c3_line, c_br_mf, c_br_sf, 2);
    -- C4 SF 계획 블록 교체 (SF 분기 시작 줄 ~ MKT_FCST_PP SF 블록 앞)
    op_span('C4 SF 계획', c_br_sf, c_pp, v_blk, 'SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A');
    -- C5 SP 실적 3종 삭제
    op_tok('C5 SP 삭제', c5_tok, '            END) IS NOT NULL;' || CHR(10) || c5_del || CHR(10) || '    END IF;' || CHR(10), NULL, NULL, 1);
    IF (DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark) <> 9 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 수 불일치(9 기대). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 9곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

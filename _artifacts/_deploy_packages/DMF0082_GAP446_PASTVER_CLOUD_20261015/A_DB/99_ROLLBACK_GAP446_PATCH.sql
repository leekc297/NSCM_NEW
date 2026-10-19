-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 15:14:53 FETCHED=2026-10-15 15:16 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [GAP446 2026-10-15] GAP 446 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 의 연산을 역순으로 되돌린다 — 위치는 ASCII 마커·토큰으로만 찾는다(한글 비교 없음).
--       C4 는 수정 전 SF 블록 원문(사내 기준본)을 그대로 되넣는다.
-- 가드: 마커 없음 → 무동작 · 대상 건수 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
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
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_blk, TRUE);
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '' || CHR(10)
            || '        -- 계획구간 수요 (SF Cutoff)' || CHR(10)
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
            || '        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID' || CHR(10)
            || '             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID' || CHR(10)
            || '             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, B.MEASURE_GROUP' || CHR(10)
            || '             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER' || CHR(10)
            || '             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10)
            || '             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE' || CHR(10)
            || '             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS' || CHR(10)
            || '             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL' || CHR(10)
            || '             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY' || CHR(10)
            || '             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL' || CHR(10)
            || '             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME' || CHR(10)
            || '             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO' || CHR(10)
            || '             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, '' '') AS AS_FROM_SITE' || CHR(10)
            || '             , LD.CREATE_DATE, LD.LAST_UPDATED_BY' || CHR(10)
            || '             , '''' AS SENDER_CODE, '''' AS SENDER_NAME, C.PROJECT_S_OP_REPORT' || CHR(10)
            || '             , '''' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD' || CHR(10)
            || '             , CASE WHEN A.MEASURE IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS NOTATION' || CHR(10)
            || '        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE' || CHR(10)
            || '        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.' || CHR(10)
            || '                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10)
            || '                     , MAX(CREATE_DATE) AS CREATE_DATE' || CHR(10)
            || '                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY' || CHR(10)
            || '                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C' || CHR(10)
            || '                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE' || CHR(10)
            || '            ) LD' || CHR(10)));
    DBMS_LOB.APPEND(v_blk, TO_CLOB(
            '                ON  LD.DIVISION_ID  = A.DIVISION_ID' || CHR(10)
            || '                AND LD.PROJECT_CODE = A.PROJECT_CODE' || CHR(10)
            || '                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10)
            || '                AND LD.ITEM_ID      = A.ITEM_ID' || CHR(10)
            || '                AND LD.DOM_EXP      = A.DOM_EXP' || CHR(10)
            || '                AND LD.FCST_TYPE    = A.FCST_TYPE' || CHR(10)
            || '                AND LD.INCOTERMS    = A.INCOTERMS' || CHR(10)
            || '                AND LD.MEASURE      = A.MEASURE' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C' || CHR(10)
            || '            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE' || CHR(10)
            || '            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN=''Y''' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE' || CHR(10)
            || '        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE ''SF%''' || CHR(10)
            || '        WHERE  A.DIVISION_ID = p_division_id' || CHR(10)
            || '        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT' || CHR(10)
            || '        AND    A.QTY <> 0;' || CHR(10)
            || '' || CHR(10)
            || ''));
    op_cut('C5 SP 삭제', c5_start, c5_end);
    op_span('C4 SF 계획', c_br_sf, c_pp, v_blk, '[' || c_mark || '] SF');
    op_line('C3 MF 판가 NOW', c3_pfx, '', c_br_mf, c_br_sf, 2);
    op_tok('C3 MF 판가', c3_tok2, c3_tok, c_br_mf, c_br_sf, 2);
    op_line('C2 MF 계획', c2_pfx, '', c_br_mf, c_enddiv, 2);
    op_line('C1 NOW 산식', c1_pfx, c1_old || CHR(10), NULL, NULL, 1);
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

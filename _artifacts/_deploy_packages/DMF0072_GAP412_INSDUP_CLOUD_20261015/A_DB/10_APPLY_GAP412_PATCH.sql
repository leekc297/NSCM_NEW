-- SOURCE-FRESH: SCM_MGR.PKG_DMF0072 PACKAGE BODY LAST_DDL=2026-10-15 11:17:46 FETCHED=2026-10-15 20:59 DB=ZIOUI1 (사내 수정 전 원문 기준 문구 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP412 2026-10-15] GAP 412 PKG_DMF0072 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: N N Master Mapping 저장 P_DMF0072_SAVE_NNMASTER_MAPPING — 신규(I) 행의 키(PK 15컬럼)가 기존 행과 같으면 오류 → 저장 전체 ROLLBACK.
--   종전: 오류 없이 기존 행의 Valid From/To · Active · Mapping Item 을 덮어씀. AS-IS: PK 위반으로 저장 실패.
--   수정(M) 행 처리 · 저장 대상 커서(ACT_TYPE IN ('M','I')) · 다른 프로시저 무변경. 원장 · 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 저장 SP 구간 안 ASCII 문구 1곳 앞에 확인 블록 삽입 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 줄 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_seg    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_a      PLS_INTEGER;
    v_b      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := 'GAP412 2026-10-15';
    c_pa     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'PROCEDURE P_DMF0072_SAVE_NNMASTER_MAPPING' || CHR(10) || '';
    c_pb     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'END P_DMF0072_SAVE_NNMASTER_MAPPING;';
    c_old    CONSTANT VARCHAR2(4000) := '        IF V_EXISTS_CNT > 0 THEN' || CHR(10) || '';
    c_new    CONSTANT VARCHAR2(4000) := '        -- [GAP412 2026-10-15] AS-IS parity: new(I) row with the same PK as an existing row -> save fails' || CHR(10) || '        --   (AS-IS MERGE inserts every I row -> PK violation -> nothing saved). No overwrite of the existing row.' || CHR(10) || '        IF REC.ACT_TYPE = ''I'' THEN' || CHR(10) || '            DECLARE' || CHR(10) || '                L_DUP_CNT  PLS_INTEGER := 0;' || CHR(10) || '            BEGIN' || CHR(10) || '                SELECT COUNT(1)' || CHR(10) || '                INTO   L_DUP_CNT' || CHR(10) || '                FROM   SCM_MGR.DM_CUST_MODEL_MAPPING_M A' || CHR(10) || '                WHERE  A.DATA_TYPE_CODE  = REC.DATA_TYPE_CODE' || CHR(10) || '                  AND  A.DIVISION_ID     = P_DIVISION_ID' || CHR(10) || '                  AND  A.COMPANY_ID      = REC.COMPANY_ID' || CHR(10) || '                  AND  A.SOLDTO_CODE     = REC.SOLDTO_CODE' || CHR(10) || '                  AND  A.SHIPTO_CODE     = REC.SHIPTO_CODE' || CHR(10) || '                  AND  NVL(NULLIF(NULLIF(NULLIF(TRIM(A.UNLOADING_POINT),''-''),''--''),''/''), ''@#@#@#'') = NVL(NULLIF(NULLIF(NULLIF(TRIM(REC.UNLOADING_POINT),''-''),''--''),''/''), ''@#@#@#'')' || CHR(10) || '                  AND  NVL(NULLIF(NULLIF(NULLIF(TRIM(A.CUSTOMER_PLANT),''-''),''--''),''/''), ''@#@#@#'') = NVL(NULLIF(NULLIF(NULLIF(TRIM(REC.CUSTOMER_PLANT),''-''),''--''),''/''), ''@#@#@#'')' || CHR(10) || '                  AND  NVL(NULLIF(NULLIF(NULLIF(TRIM(A.CUSTOMER_ITEM_ID),''-''),''--''),''/''), ''@#@#@#'') = NVL(NULLIF(NULLIF(NULLIF(TRIM(REC.CUSTOMER_ITEM_ID),''-''),''--''),''/''), ''@#@#@#'')' || CHR(10) || '                  AND  A.SCM_SITE_ID     = REC.SCM_SITE_ID' || CHR(10) || '                  AND  A.PROJECT_CODE    = REC.PROJECT_CODE' || CHR(10) || '                  AND  A.FCST_TYPE       = REC.FCST_TYPE' || CHR(10) || '                  AND  A.INCOTERMS       = REC.INCOTERMS' || CHR(10) || '                  AND  A.DOM_EXP         = REC.DOM_EXP' || CHR(10) || '                  AND  A.ITEM_ID         = REC.ITEM_ID' || CHR(10) || '                  AND  A.MAPPING_ITEM_ID = REC.MAPPING_ITEM_ID;' || CHR(10) || '                IF L_DUP_CNT > 0 THEN' || CHR(10) || '                    RAISE_APPLICATION_ERROR(-20072,' || CHR(10) || '                        ''Duplicate key: the same mapping already exists. Nothing was saved. (''' || CHR(10) || '                        || ''Data Type='' || REC.DATA_TYPE_CODE || '', Company='' || REC.COMPANY_ID' || CHR(10) || '                        || '', Sold To='' || REC.SOLDTO_CODE || '', Ship To='' || REC.SHIPTO_CODE' || CHR(10) || '                        || '', Sales Site='' || REC.SCM_SITE_ID || '', Project='' || REC.PROJECT_CODE' || CHR(10) || '                        || '', Customer Item='' || REC.CUSTOMER_ITEM_ID || '', Item='' || REC.ITEM_ID' || CHR(10) || '                        || '', Mapping Item='' || REC.MAPPING_ITEM_ID || '')'');' || CHR(10) || '                END IF;' || CHR(10) || '            END;' || CHR(10) || '        END IF;' || CHR(10) || '' || CHR(10) || '        IF V_EXISTS_CNT > 0 THEN' || CHR(10) || '';
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
    PROCEDURE split_seg IS
    BEGIN
        v_a := DBMS_LOB.INSTR(v_new, c_pa);
        v_b := CASE WHEN v_a > 0 THEN DBMS_LOB.INSTR(v_new, c_pb, v_a) ELSE 0 END;
        IF NOT (v_a > 0 AND v_b > v_a) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — P_DMF0072_SAVE_NNMASTER_MAPPING 위치 확인 불가. 원문 무변경');
        END IF;
        v_seg := SUBSTR(v_new, v_a, v_b - v_a);
    END;
    PROCEDURE join_seg IS
    BEGIN
        v_new := SUBSTR(v_new, 1, v_a - 1) || v_seg || SUBSTR(v_new, v_b);
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' ' || p_got || '건 (' || p_exp || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0072' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    split_seg;
    expect('저장 SP 루프 IF V_EXISTS_CNT 줄', cnt(v_seg, c_old), 1);
    v_seg := REPLACE(v_seg, c_old, c_new);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 1);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0072' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0072' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0072' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0072 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0072' ORDER BY OBJECT_TYPE;

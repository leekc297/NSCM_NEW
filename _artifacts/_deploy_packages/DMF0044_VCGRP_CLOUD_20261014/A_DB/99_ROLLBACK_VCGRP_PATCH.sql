-- 99 ROLLBACK — [E20261014-DMF0044VCGRP] 역치환 v2 (Version Copy 프로시저의 GROUP BY 줄을 적용 전으로 되돌린다). 전체 F5, 멱등
-- 마커 없으면 무동작. ⚠ 되돌리면 Version Copy 저장이 다시 ORA-00979 로 실패한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_s IS TABLE OF VARCHAR2(2000);
    TYPE t_n IS TABLE OF PLS_INTEGER;
    v_src   CLOB;
    v_reg   CLOB;
    v_out   CLOB;
    v_regc  CLOB;
    v_bad   VARCHAR2(4000);
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_a     PLS_INTEGER;
    v_b     PLS_INTEGER;
    c_nl    CONSTANT VARCHAR2(1)    := CHR(10);
    c_mark  CONSTANT VARCHAR2(40)   := 'E20261014-DMF0044VCGRP';
    c_ps    CONSTANT VARCHAR2(200)  := CHR(10) || 'PROCEDURE P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY';
    c_note  CONSTANT VARCHAR2(1000) := '--[E20261014-DMF0044VCGRP] 이 프로시저의 GROUP BY 절 17곳을 SELECT 와 같은 식으로 맞춤 — NVL(X,''/'') 와 NVL(NULLIF(RTRIM(X),''''),''/'') 가 달라 ORA-00979 (실행 시점 오류)';
    -- 대상 줄 16개 (원문 순서). 줄 열쇠 = 줄 끝 주석을 떼고 공백 · 탭을 모두 뺀 코드 — 들여쓰기 · 주석이 달라도 같은 줄로 본다
    t_ko t_s := t_s(   -- 적용 전 줄의 열쇠
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID',
        ',NVL(B.SALES_COMPANY,''/'')',
        ',NVL(A.ITEM_USE,''/''),NVL(A.END_CUSTOMER,''/''),A.CELL_PROD_SITE;',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.MEASURE,A.YYYYMM,A.CURRENCY,NVL(A.COMPANY_ID,''/''),A.COUNTRY_KR_NAME,A.CELL_PROD_SITE;');
    t_kn t_s := t_s(   -- 적용 후 줄의 열쇠
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(A.CURRENCY,''/''),NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID',
        ',NVL(NULLIF(RTRIM(B.SALES_COMPANY),''''),''/'')',
        ',NVL(NULLIF(RTRIM(A.ITEM_USE),''''),''/''),NVL(NULLIF(RTRIM(A.END_CUSTOMER),''''),''/''),A.CELL_PROD_SITE;',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),M.O_MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.FCST_TYPE,A.INCOTERMS,NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/''),A.PLANT_SITE_ID,A.YYYYMMDD,A.COMPANY_ID,B.ATTRIBUTE1',
        ',A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.MEASURE,A.YYYYMM,A.CURRENCY,NVL(NULLIF(RTRIM(A.COMPANY_ID),''''),''/''),A.COUNTRY_KR_NAME,A.CELL_PROD_SITE;');
    -- 줄 안에서 바꾸는 토큰 (t_li = 위 목록의 몇 번째 줄인가)
    t_li  t_n := t_n(1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 11, 12, 13, 14, 15, 16);
    t_fre t_s := t_s(   -- 적용: 찾는 식 (공백 무관 · 빈값 표기 '-' '/' 모두)
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*B\.SALES_COMPANY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.ITEM_USE\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.END_CUSTOMER\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))',
        '(NVL\s*\(\s*A\.COMPANY_ID\s*,\s*''[-/]''\s*\))');
    t_frp t_s := t_s(   -- 적용: 바꿀 말 (\1 = 원래 토큰 그대로)
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        '\1, NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(B.SALES_COMPANY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.ITEM_USE),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.END_CUSTOMER),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''), ''/'')',
        'NVL(NULLIF(RTRIM(A.COMPANY_ID),''''), ''/'')');
    t_bre t_s := t_s(   -- 원복: 찾는 식
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        '(NVL\s*\(\s*A\.CURRENCY\s*,\s*''[-/]''\s*\))\s*,\s*NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*B\.SALES_COMPANY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.ITEM_USE\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.END_CUSTOMER\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.CURRENCY\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)',
        'NVL\s*\(\s*NULLIF\s*\(\s*RTRIM\s*\(\s*A\.COMPANY_ID\s*\)\s*,\s*''''\s*\)\s*,\s*''/''\s*\)');
    t_brp t_s := t_s(   -- 원복: 바꿀 말
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        '\1',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(B.SALES_COMPANY, ''/'')',
        'NVL(A.ITEM_USE, ''/'')',
        'NVL(A.END_CUSTOMER, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.CURRENCY, ''/'')',
        'NVL(A.COMPANY_ID, ''/'')');
    -- SELECT 쪽 확인용: 이 프로시저 안에 SELECT 의 식(공백 뺀 꼴)이 사내 적용 전과 같은 횟수만큼 있어야 한다
    --   (GROUP BY 를 이 식으로 맞추는 것이므로, SELECT 쪽이 사내와 다르면 적용하지 않는다)
    t_sx t_s := t_s(
        'NVL(NULLIF(RTRIM(A.COMPANY_ID),''''),''/'')',
        'NVL(NULLIF(RTRIM(A.CURRENCY),''''),''/'')',
        'NVL(NULLIF(RTRIM(A.END_CUSTOMER),''''),''/'')',
        'NVL(NULLIF(RTRIM(A.ITEM_USE),''''),''/'')',
        'NVL(NULLIF(RTRIM(B.SALES_COMPANY),''''),''/'')');
    t_sc t_n := t_n(12, 28, 1, 1, 1);
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
    FUNCTION lkey(p VARCHAR2) RETURN VARCHAR2 IS
        i PLS_INTEGER := INSTR(p, '--');
    BEGIN
        -- 빈값 표기 '-' · '/' 는 같은 줄로 본다 (GROUP BY 의 NVL(X,'-') 도 대상)
        RETURN REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(CASE WHEN i > 0 THEN SUBSTR(p, 1, i - 1) ELSE p END, CHR(9)), ' '), CHR(13))
                            , 'NVL\(([AB]\.[A-Z_]+),''-''\)', 'NVL(\1,''/'')');
    END;
    -- v_reg 의 줄을 위에서부터 읽어 v_out 을 만든다. p_fwd = TRUE 적용 / FALSE 원복
    PROCEDURE walk(p_fwd BOOLEAN) IS
        v_keys t_s;
        v_pos  PLS_INTEGER := 1;
        v_end  PLS_INTEGER;
        v_len  PLS_INTEGER := DBMS_LOB.GETLENGTH(v_reg);
        v_ln   VARCHAR2(32767);
        v_ln2  VARCHAR2(32767);
        v_ck   VARCHAR2(32767);
        v_k    PLS_INTEGER := 1;
        v_no   PLS_INTEGER := 0;
        v_last BOOLEAN;
        PROCEDURE put(p VARCHAR2, p_nl BOOLEAN) IS
        BEGIN
            IF p IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v_out, LENGTH(p), p); END IF;
            IF p_nl THEN DBMS_LOB.WRITEAPPEND(v_out, 1, c_nl); END IF;
        END;
    BEGIN
        IF p_fwd THEN v_keys := t_ko; ELSE v_keys := t_kn; END IF;
        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        WHILE v_pos <= v_len + 1 LOOP
            v_end  := DBMS_LOB.INSTR(v_reg, c_nl, v_pos);
            v_last := NVL(v_end, 0) = 0;
            IF v_last THEN v_end := v_len + 1; END IF;
            v_ln  := CASE WHEN v_end > v_pos THEN DBMS_LOB.SUBSTR(v_reg, v_end - v_pos, v_pos) END;
            v_no  := v_no + 1;
            v_pos := v_end + 1;
            IF NOT p_fwd AND INSTR(v_ln, c_mark) > 0 THEN
                NULL;                                               -- 원복: 설명 주석 줄은 버린다
            ELSE
                v_ck := lkey(v_ln);
                IF v_k <= v_keys.COUNT AND v_ck = v_keys(v_k) THEN
                    FOR j IN 1 .. t_li.COUNT LOOP
                        IF t_li(j) = v_k THEN
                            IF p_fwd THEN v_ln2 := REGEXP_REPLACE(v_ln, t_fre(j), t_frp(j), 1, 1);
                            ELSE          v_ln2 := REGEXP_REPLACE(v_ln, t_bre(j), t_brp(j), 1, 1);
                            END IF;
                            IF v_ln2 = v_ln THEN
                                RAISE_APPLICATION_ERROR(-20003, '중단 — 대상 ' || v_k || '번째 줄(프로시저 ' || v_no || '행)에서 토큰을 찾지 못함. 원문 무변경');
                            END IF;
                            v_ln := v_ln2;
                        END IF;
                    END LOOP;
                    IF p_fwd AND v_k = 1 THEN
                        put(REGEXP_SUBSTR(v_ln, '^[ ' || CHR(9) || ']*') || c_note, TRUE);   -- 첫 대상 줄 바로 위에 설명 주석 1줄 (같은 들여쓰기)
                    END IF;
                    v_k := v_k + 1;
                ELSIF v_ck IS NOT NULL THEN
                    FOR j IN 1 .. v_keys.COUNT LOOP
                        IF v_ck = v_keys(j) THEN
                            RAISE_APPLICATION_ERROR(-20001, '중단 — 대상 줄이 예상 순서 밖에 있음: 프로시저 ' || v_no || '행 (다음 기대 ' || v_k || '번째). 원문이 사내와 다름 → 00_PRECHECK L2 회신. 원문 무변경');
                        END IF;
                    END LOOP;
                END IF;
                put(v_ln, NOT v_last);
            END IF;
        END LOOP;
        IF v_k <> v_keys.COUNT + 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — 대상 줄 ' || v_keys.COUNT || '개 중 ' || (v_k - 1) || '개만 찾음 (다음 기대 ' || v_k || '번째). 원문이 사내와 다름 → 00_PRECHECK L2 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화
    v_a := DBMS_LOB.INSTR(v_src, c_ps);
    IF NVL(v_a, 0) = 0 OR cnt(v_src, c_ps) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — Version Copy 프로시저 시작 줄을 찾지 못함. 원문 무변경');
    END IF;
    v_b := LEAST(NVL(NULLIF(DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE ', v_a + 10), 0), 2147483647)
               , NVL(NULLIF(DBMS_LOB.INSTR(v_src, CHR(10) || 'FUNCTION ',  v_a + 10), 0), 2147483647)
               , NVL(NULLIF(DBMS_LOB.INSTR(v_src, CHR(10) || 'END PKG_DMF0044', v_a + 10), 0), 2147483647));
    IF v_b = 2147483647 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — Version Copy 프로시저의 끝을 찾지 못함. 원문 무변경');
    END IF;
    v_reg := SUBSTR(v_src, v_a, v_b - v_a);   -- Version Copy 프로시저 본문만
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    walk(FALSE);
    v_new := SUBSTR(v_src, 1, v_a - 1) || v_out || SUBSTR(v_src, v_b);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0044' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0044 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;

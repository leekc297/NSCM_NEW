-- SOURCE-FRESH: SCM_MGR.PKG_DMF0020 PACKAGE LAST_DDL=2026-10-21 22:47:13 / PACKAGE BODY LAST_DDL=2026-10-21 22:47:13 FETCHED=2026-10-21 22:47 DB=ZIOUI1 (사내 수정 전 원문으로 앵커·지문 산출 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [E20261021-DMF0020SAVECLOB] 원복 (전체 F5, 값 입력 없음, 멱등) — ORIG 주석에서 원문 구간 복원 + IN CLOB→VARCHAR2 + PROC_M VARCHAR 복귀 + 의존 재컴파일
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_arr IS TABLE OF VARCHAR2(400) INDEX BY PLS_INTEGER;
    v_spec    CLOB;  v_body    CLOB;      -- 원문
    v_spec_n  CLOB;  v_body_n  CLOB;      -- 결과
    v_seg     CLOB;  v_a PLS_INTEGER;  v_b PLS_INTEGER;
    v_st      VARCHAR2(30);  v_err PLS_INTEGER;  v_n PLS_INTEGER;
    v_fail    VARCHAR2(4000);
    c_mark    CONSTANT VARCHAR2(40) := '[E20261021-DMF0020SAVECLOB]';
    ha_o t_arr; ha_n t_arr; hp_o t_arr; hp_n t_arr; sa_o t_arr; sa_n t_arr; sp_o t_arr; sp_n t_arr;
    v_a2 VARCHAR2(32767); v_a3 VARCHAR2(32767); v_a4 VARCHAR2(32767);
    v_p2 VARCHAR2(32767); v_p2b VARCHAR2(32767); v_p3 VARCHAR2(32767); v_p4 VARCHAR2(32767);
    v_a5 VARCHAR2(32767); v_a6 VARCHAR2(32767); v_a7 VARCHAR2(32767); v_a8 VARCHAR2(32767);
    c_a5_s CONSTANT VARCHAR2(200) := '    UPDATE SCM_MGR.GT_FCSV_RESULTS_MST A' || CHR(10) ||
        '       SET A.V_CURRENCY = ( SELECT MAX(B.V_CURRENCY)' || CHR(10) ||
        '';
    c_a5_e CONSTANT VARCHAR2(200) := 'A.V_CURRENCY) <> A.V_CURRENCY;' || CHR(10) ||
        '';
    c_a6_s CONSTANT VARCHAR2(200) := '    UPDATE SCM_MGR.GT_FCSV_RESULTS_MST A' || CHR(10) ||
        '       SET A.V_ACTIVE_FLAG = ( SELECT MAX(B.V_ACTIVE_FLAG)' || CHR(10) ||
        '';
    c_a6_e CONSTANT VARCHAR2(200) := 'A.V_ACTIVE_FLAG) <> A.V_ACTIVE_FLAG;' || CHR(10) ||
        '';
    c_a7_s CONSTANT VARCHAR2(300) := '           AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K' || CHR(10) ||
        '                             WHERE K.V_MEASURE = ''KRW''' || CHR(10) ||
        '';
    c_a8_s CONSTANT VARCHAR2(300) := '           AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K' || CHR(10) ||
        '                             WHERE K.V_MEASURE = ''USD''' || CHR(10) ||
        '';
    c_a78_e CONSTANT VARCHAR2(200) := '                                AND DECODE(K.V_INCOTERMS, L.V_INCOTERMS, 1, 0) = 1 );' || CHR(10) ||
        '';
    c_a2_anchor CONSTANT VARCHAR2(200) := '    N_DFLAG_CHK       NUMBER(10) := 0;' || CHR(10) ||
        'BEGIN' || CHR(10) ||
        '';
    c_a3_s CONSTANT VARCHAR2(200) := '    INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST' || CHR(10) ||
        '    (' || CHR(10) ||
        '         V_ACTIVE_FLAG' || CHR(10) ||
        '';
    c_a3_e CONSTANT VARCHAR2(200) := '    FROM   SPLIT_DATA;' || CHR(10) ||
        '';
    c_a4_s CONSTANT VARCHAR2(200) := '        V_PROC_INPUT  := JSON_OBJECT(' || CHR(10) ||
        '            ''P_ACTIVE_FLAG''     VALUE P_ACTIVE_FLAG,' || CHR(10) ||
        '';
    c_a4_e CONSTANT VARCHAR2(200) := '            ''P_ROWNUM''          VALUE P_ROWNUM' || CHR(10) ||
        '        );' || CHR(10) ||
        '';
    c_p2_s CONSTANT VARCHAR2(200) := '    l_active_flag        VARCHAR2(32767);' || CHR(10) ||
        '';
    c_p2_e CONSTANT VARCHAR2(200) := '    l_LAST_UPDATED_BY    VARCHAR2(32767);' || CHR(10) ||
        '';
    c_p2b_anchor CONSTANT VARCHAR2(200) := '    e_invalid_data EXCEPTION;' || CHR(10) ||
        '';
    c_p3_s CONSTANT VARCHAR2(200) := '' || CHR(9) || 'l_active_flag      := RTRIM(p_active_flag     ) || ''^'';' || CHR(10) ||
        '';
    c_p3_e CONSTANT VARCHAR2(200) := '' || CHR(9) || 'l_LAST_UPDATED_BY  := RTRIM(p_LAST_UPDATED_BY ) || ''^'';' || CHR(10) ||
        '';
    c_p4_s CONSTANT VARCHAR2(200) := 'WHILE LENGTH(l_DIVISION_ID) > 0' || CHR(10) ||
        'LOOP' || CHR(10) ||
        '';
    c_p4_e CONSTANT VARCHAR2(200) := '    END IF;' || CHR(10) ||
        'END LOOP;' || CHR(10) ||
        '';
    c_p4_x CONSTANT VARCHAR2(400) := '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'l_LAST_UPDATED_BY := SUBSTR(l_LAST_UPDATED_BY, LENGTH(v_LAST_UPDATED_BY || ''^'') + 1, LENGTH(l_LAST_UPDATED_BY));' || CHR(10) ||
        '';
    c_p4_else CONSTANT VARCHAR2(200) := '' || CHR(10) ||
        '    ELSE' || CHR(10) ||
        '';
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        IF p_src IS NULL OR p_tok IS NULL THEN RETURN 0; END IF;
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, 'ABORT - ' || p_name || ' ' || p_got || ' (expected ' || p_exp || '). source unchanged. send 00_PRECHECK output');
        END IF;
    END;
    FUNCTION load(p_type VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0020' AND TYPE = p_type ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN REPLACE(v, CHR(13) || CHR(10), CHR(10));
    END;
    -- 세그먼트 분리/결합 (p_end 가 ');' 처럼 짧으면 시작 이후 첫 출현)
    PROCEDURE split_seg(p_src CLOB, p_s VARCHAR2, p_e VARCHAR2) IS
    BEGIN
        expect('segment start ' || p_s, cnt(p_src, p_s), 1);
        v_a := DBMS_LOB.INSTR(p_src, p_s);
        v_b := DBMS_LOB.INSTR(p_src, p_e, v_a);
        IF v_b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - segment end not found ' || p_s); END IF;
        v_b := v_b + LENGTH(p_e);
        v_seg := SUBSTR(p_src, v_a, v_b - v_a);
    END;
    FUNCTION join_seg(p_src CLOB) RETURN CLOB IS
    BEGIN
        RETURN SUBSTR(p_src, 1, v_a - 1) || v_seg || SUBSTR(p_src, v_b);
    END;
    PROCEDURE rep1(p_old VARCHAR2, p_new VARCHAR2) IS   -- 세그먼트 안 정확 1회 치환
    BEGIN
        expect('anchor ' || SUBSTR(REPLACE(p_old, CHR(10), '\n'), 1, 60), cnt(v_seg, p_old), 1);
        v_seg := REPLACE(v_seg, p_old, p_new);
    END;
    FUNCTION orig_wrap(p_key VARCHAR2, p_orig CLOB, p_ind VARCHAR2) RETURN CLOB IS
    BEGIN
        RETURN p_ind || '/*' || c_mark || ' BEGIN-ORIG ' || p_key || CHR(10) || p_orig || p_ind || c_mark || ' END-ORIG ' || p_key || ' */' || CHR(10);
    END;
    -- 구간 치환: [시작앵커 .. 끝앵커] 를 새 텍스트 + ORIG 주석으로 (지문 검사 포함)
    PROCEDURE region_apply(p_key VARCHAR2, p_s VARCHAR2, p_e VARCHAR2, p_new CLOB, p_ind VARCHAR2, p_fp_tok VARCHAR2 DEFAULT NULL, p_fp_len PLS_INTEGER DEFAULT NULL, p_fp_cnt PLS_INTEGER DEFAULT NULL, p_fp_len2 PLS_INTEGER DEFAULT NULL, p_fp_cnt2 PLS_INTEGER DEFAULT NULL) IS
        a PLS_INTEGER; b PLS_INTEGER; r CLOB;
    BEGIN
        expect(p_key || ' start anchor', cnt(v_seg, p_s), 1);
        a := DBMS_LOB.INSTR(v_seg, p_s);
        b := DBMS_LOB.INSTR(v_seg, p_e, a);
        IF b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - ' || p_key || ' end anchor not found. source unchanged'); END IF;
        b := b + LENGTH(p_e);
        r := SUBSTR(v_seg, a, b - a);
        IF p_fp_tok IS NOT NULL THEN
            IF NOT ((LENGTH(r) = p_fp_len AND cnt(r, p_fp_tok) = p_fp_cnt) OR (LENGTH(r) = NVL(p_fp_len2, -1) AND cnt(r, p_fp_tok) = p_fp_cnt2)) THEN
                RAISE_APPLICATION_ERROR(-20003, 'ABORT - ' || p_key || ' fingerprint mismatch: len=' || LENGTH(r) || ' tok=' || cnt(r, p_fp_tok) || ' (expected ' || p_fp_len || '/' || p_fp_cnt || ' or ' || p_fp_len2 || '/' || p_fp_cnt2 || '). this DB source differs - send 00_PRECHECK output. source unchanged');
            END IF;
        END IF;
        IF DBMS_LOB.INSTR(r, '/*') > 0 OR DBMS_LOB.INSTR(r, '*/') > 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'ABORT - ' || p_key || ' region contains block comment. source unchanged');
        END IF;
        v_seg := SUBSTR(v_seg, 1, a - 1) || p_new || orig_wrap(p_key, r, p_ind) || SUBSTR(v_seg, b);
    END;
    -- 구간 원복: [NEW 첫 줄 .. END-ORIG 줄] 을 ORIG 본문으로
    PROCEDURE region_rollback(p_key VARCHAR2, p_ind VARCHAR2, p_new_first VARCHAR2) IS
        s PLS_INTEGER; a PLS_INTEGER; b PLS_INTEGER; o1 VARCHAR2(200); o2 VARCHAR2(200);
    BEGIN
        expect(p_key || ' NEW marker', cnt(v_seg, p_new_first), 1);
        s := DBMS_LOB.INSTR(v_seg, p_new_first);
        o1 := p_ind || '/*' || c_mark || ' BEGIN-ORIG ' || p_key || CHR(10);
        o2 := p_ind || c_mark || ' END-ORIG ' || p_key || ' */' || CHR(10);
        a := DBMS_LOB.INSTR(v_seg, o1, s);
        b := DBMS_LOB.INSTR(v_seg, o2, s);
        IF a = 0 OR b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - ' || p_key || ' ORIG markers not found. source unchanged'); END IF;
        a := a + LENGTH(o1);
        v_seg := SUBSTR(v_seg, 1, s - 1) || SUBSTR(v_seg, a, b - a) || SUBSTR(v_seg, b + LENGTH(o2));
    END;
    PROCEDURE remove_block(p_key VARCHAR2, p_first VARCHAR2, p_last VARCHAR2) IS   -- 삽입 전용 구간 제거 (A2/P2B)
        a PLS_INTEGER; b PLS_INTEGER;
    BEGIN
        expect(p_key || ' NEW marker', cnt(v_seg, p_first), 1);
        a := DBMS_LOB.INSTR(v_seg, p_first);
        b := DBMS_LOB.INSTR(v_seg, p_last, a);
        IF b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - ' || p_key || ' END marker not found'); END IF;
        v_seg := SUBSTR(v_seg, 1, a - 1) || SUBSTR(v_seg, b + LENGTH(p_last));
    END;
    PROCEDURE compile_obj(p_src CLOB, p_type VARCHAR2) IS
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_src;
        EXCEPTION WHEN OTHERS THEN
            NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정 (2026-10-15 GAP452 리허설 정정)
        END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0020' AND OBJECT_TYPE = p_type;
        SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0020' AND TYPE = p_type AND ATTRIBUTE = 'ERROR';
        IF v_st <> 'VALID' OR v_err > 0 THEN
            FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0020' AND TYPE = p_type AND ATTRIBUTE = 'ERROR' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
                DBMS_OUTPUT.PUT_LINE('  ERR ' || p_type || ' L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
            END LOOP;
            v_fail := p_type || ' ' || v_st || ' errors=' || v_err;
        END IF;
    END;
    PROCEDURE recompile_dependents IS
    BEGIN
        FOR r IN (SELECT DISTINCT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = 'PKG_DMF0020' AND REFERENCED_TYPE = 'PACKAGE' AND NAME <> 'PKG_DMF0020') LOOP
            BEGIN
                IF r.TYPE = 'PACKAGE BODY' THEN EXECUTE IMMEDIATE 'ALTER PACKAGE ' || r.NAME || ' COMPILE BODY';
                ELSIF r.TYPE = 'PACKAGE' THEN EXECUTE IMMEDIATE 'ALTER PACKAGE ' || r.NAME || ' COMPILE';
                ELSE EXECUTE IMMEDIATE 'ALTER ' || r.TYPE || ' ' || r.NAME || ' COMPILE';
                END IF;
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
            SELECT MAX(STATUS) INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = r.NAME AND OBJECT_TYPE = r.TYPE;
            DBMS_OUTPUT.PUT_LINE('  dependent ' || RPAD(r.TYPE, 13) || ' ' || RPAD(r.NAME, 45) || ' -> ' || v_st);
        END LOOP;
    END;
BEGIN
    IF USER <> 'SCM_MGR' THEN RAISE_APPLICATION_ERROR(-20000, 'ABORT - run as SCM_MGR (current ' || USER || ')'); END IF;
    ha_O(1) := '    P_ACTIVE_FLAG       IN  VARCHAR2,';
    ha_N(1) := '    P_ACTIVE_FLAG       IN  CLOB,';
    ha_O(2) := '    P_DIVISION_ID       IN  VARCHAR2,';
    ha_N(2) := '    P_DIVISION_ID       IN  CLOB,';
    ha_O(3) := '    P_PROJECT_CODE      IN  VARCHAR2,';
    ha_N(3) := '    P_PROJECT_CODE      IN  CLOB,';
    ha_O(4) := '    P_SCM_SITE_ID       IN  VARCHAR2,';
    ha_N(4) := '    P_SCM_SITE_ID       IN  CLOB,';
    ha_O(5) := '    P_PLANT_SITE_ID     IN  VARCHAR2,';
    ha_N(5) := '    P_PLANT_SITE_ID     IN  CLOB,';
    ha_O(6) := '    P_ITEM_ID           IN  VARCHAR2,';
    ha_N(6) := '    P_ITEM_ID           IN  CLOB,';
    ha_O(7) := '    P_YYYYMMDD          IN  VARCHAR2,';
    ha_N(7) := '    P_YYYYMMDD          IN  CLOB,';
    ha_O(8) := '    P_CURRENCY          IN  VARCHAR2,';
    ha_N(8) := '    P_CURRENCY          IN  CLOB,';
    ha_O(9) := '    P_MEASURE           IN  VARCHAR2,';
    ha_N(9) := '    P_MEASURE           IN  CLOB,';
    ha_O(10) := '    P_DOM_EXP           IN  VARCHAR2,';
    ha_N(10) := '    P_DOM_EXP           IN  CLOB,';
    ha_O(11) := '    P_FCST_TYPE         IN  VARCHAR2,';
    ha_N(11) := '    P_FCST_TYPE         IN  CLOB,';
    ha_O(12) := '    P_INCOTERMS         IN  VARCHAR2,';
    ha_N(12) := '    P_INCOTERMS         IN  CLOB,';
    ha_O(13) := '    P_PRICE             IN  VARCHAR2,';
    ha_N(13) := '    P_PRICE             IN  CLOB,';
    ha_O(14) := '    P_CREATED_BY        IN  VARCHAR2,';
    ha_N(14) := '    P_CREATED_BY        IN  CLOB,';
    ha_O(15) := '    P_CREATION_DATE     IN  VARCHAR2,';
    ha_N(15) := '    P_CREATION_DATE     IN  CLOB,';
    ha_O(16) := '    P_LAST_UPDATED_BY   IN  VARCHAR2,';
    ha_N(16) := '    P_LAST_UPDATED_BY   IN  CLOB,';
    ha_O(17) := '    P_ROWNUM            IN  VARCHAR2,';
    ha_N(17) := '    P_ROWNUM            IN  CLOB,';
    hp_O(1) := '    p_active_flag             IN  VARCHAR2,';
    hp_N(1) := '    p_active_flag             IN  CLOB,';
    hp_O(2) := '    p_DIVISION_ID             IN  VARCHAR2,';
    hp_N(2) := '    p_DIVISION_ID             IN  CLOB,';
    hp_O(3) := '    p_PROJECT_CODE            IN  VARCHAR2,';
    hp_N(3) := '    p_PROJECT_CODE            IN  CLOB,';
    hp_O(4) := '    p_SCM_SITE_ID             IN  VARCHAR2,';
    hp_N(4) := '    p_SCM_SITE_ID             IN  CLOB,';
    hp_O(5) := '    p_PLANT_SITE_ID           IN  VARCHAR2,';
    hp_N(5) := '    p_PLANT_SITE_ID           IN  CLOB,';
    hp_O(6) := '    p_ITEM_ID                 IN  VARCHAR2,';
    hp_N(6) := '    p_ITEM_ID                 IN  CLOB,';
    hp_O(7) := '    p_YYYYMMDD                IN  VARCHAR2,';
    hp_N(7) := '    p_YYYYMMDD                IN  CLOB,';
    hp_O(8) := '    p_CURRENCY                IN  VARCHAR2,';
    hp_N(8) := '    p_CURRENCY                IN  CLOB,';
    hp_O(9) := '    p_MEASURE                 IN  VARCHAR2,';
    hp_N(9) := '    p_MEASURE                 IN  CLOB,';
    hp_O(10) := '    p_DOM_EXP                 IN  VARCHAR2,';
    hp_N(10) := '    p_DOM_EXP                 IN  CLOB,';
    hp_O(11) := '    p_FCST_TYPE               IN  VARCHAR2,';
    hp_N(11) := '    p_FCST_TYPE               IN  CLOB,';
    hp_O(12) := '    p_INCOTERMS               IN  VARCHAR2,';
    hp_N(12) := '    p_INCOTERMS               IN  CLOB,';
    hp_O(13) := '    p_PRICE                   IN  VARCHAR2,';
    hp_N(13) := '    p_PRICE                   IN  CLOB,';
    hp_O(14) := '    p_CREATED_BY              IN  VARCHAR2,';
    hp_N(14) := '    p_CREATED_BY              IN  CLOB,';
    hp_O(15) := '    p_CREATION_DATE           IN  VARCHAR2,';
    hp_N(15) := '    p_CREATION_DATE           IN  CLOB,';
    hp_O(16) := '    p_LAST_UPDATED_BY         IN  VARCHAR2,';
    hp_N(16) := '    p_LAST_UPDATED_BY         IN  CLOB,';
    sa_O(1) := '    P_ACTIVE_FLAG       IN  VARCHAR2,';
    sa_N(1) := '    P_ACTIVE_FLAG       IN  CLOB,';
    sa_O(2) := '    P_DIVISION_ID       IN  VARCHAR2,';
    sa_N(2) := '    P_DIVISION_ID       IN  CLOB,';
    sa_O(3) := '    P_PROJECT_CODE      IN  VARCHAR2,';
    sa_N(3) := '    P_PROJECT_CODE      IN  CLOB,';
    sa_O(4) := '    P_SCM_SITE_ID       IN  VARCHAR2,';
    sa_N(4) := '    P_SCM_SITE_ID       IN  CLOB,';
    sa_O(5) := '    P_PLANT_SITE_ID     IN  VARCHAR2,';
    sa_N(5) := '    P_PLANT_SITE_ID     IN  CLOB,';
    sa_O(6) := '    P_ITEM_ID           IN  VARCHAR2,';
    sa_N(6) := '    P_ITEM_ID           IN  CLOB,';
    sa_O(7) := '    P_YYYYMMDD          IN  VARCHAR2,';
    sa_N(7) := '    P_YYYYMMDD          IN  CLOB,';
    sa_O(8) := '    P_CURRENCY          IN  VARCHAR2,';
    sa_N(8) := '    P_CURRENCY          IN  CLOB,';
    sa_O(9) := '    P_MEASURE           IN  VARCHAR2,';
    sa_N(9) := '    P_MEASURE           IN  CLOB,';
    sa_O(10) := '    P_DOM_EXP           IN  VARCHAR2,';
    sa_N(10) := '    P_DOM_EXP           IN  CLOB,';
    sa_O(11) := '    P_FCST_TYPE         IN  VARCHAR2,';
    sa_N(11) := '    P_FCST_TYPE         IN  CLOB,';
    sa_O(12) := '    P_INCOTERMS         IN  VARCHAR2,';
    sa_N(12) := '    P_INCOTERMS         IN  CLOB,';
    sa_O(13) := '    P_PRICE             IN  VARCHAR2,';
    sa_N(13) := '    P_PRICE             IN  CLOB,';
    sa_O(14) := '    P_CREATED_BY        IN  VARCHAR2,';
    sa_N(14) := '    P_CREATED_BY        IN  CLOB,';
    sa_O(15) := '    P_CREATION_DATE     IN  VARCHAR2,';
    sa_N(15) := '    P_CREATION_DATE     IN  CLOB,';
    sa_O(16) := '    P_LAST_UPDATED_BY   IN  VARCHAR2,';
    sa_N(16) := '    P_LAST_UPDATED_BY   IN  CLOB,';
    sa_O(17) := '    P_ROWNUM            IN  VARCHAR2,';
    sa_N(17) := '    P_ROWNUM            IN  CLOB,';
    sp_O(1) := '    p_active_flag             IN  VARCHAR2,';
    sp_N(1) := '    p_active_flag             IN  CLOB,';
    sp_O(2) := '    p_DIVISION_ID             IN  VARCHAR2,';
    sp_N(2) := '    p_DIVISION_ID             IN  CLOB,';
    sp_O(3) := '    p_PROJECT_CODE            IN  VARCHAR2,';
    sp_N(3) := '    p_PROJECT_CODE            IN  CLOB,';
    sp_O(4) := '    p_SCM_SITE_ID             IN  VARCHAR2,';
    sp_N(4) := '    p_SCM_SITE_ID             IN  CLOB,';
    sp_O(5) := '    p_PLANT_SITE_ID           IN  VARCHAR2,';
    sp_N(5) := '    p_PLANT_SITE_ID           IN  CLOB,';
    sp_O(6) := '    p_ITEM_ID                 IN  VARCHAR2,';
    sp_N(6) := '    p_ITEM_ID                 IN  CLOB,';
    sp_O(7) := '    p_YYYYMMDD                IN  VARCHAR2,';
    sp_N(7) := '    p_YYYYMMDD                IN  CLOB,';
    sp_O(8) := '    p_CURRENCY                IN  VARCHAR2,';
    sp_N(8) := '    p_CURRENCY                IN  CLOB,';
    sp_O(9) := '    p_MEASURE                 IN  VARCHAR2,';
    sp_N(9) := '    p_MEASURE                 IN  CLOB,';
    sp_O(10) := '    p_DOM_EXP                 IN  VARCHAR2,';
    sp_N(10) := '    p_DOM_EXP                 IN  CLOB,';
    sp_O(11) := '    p_FCST_TYPE               IN  VARCHAR2,';
    sp_N(11) := '    p_FCST_TYPE               IN  CLOB,';
    sp_O(12) := '    p_INCOTERMS               IN  VARCHAR2,';
    sp_N(12) := '    p_INCOTERMS               IN  CLOB,';
    sp_O(13) := '    p_PRICE                   IN  VARCHAR2,';
    sp_N(13) := '    p_PRICE                   IN  CLOB,';
    sp_O(14) := '    p_CREATED_BY              IN  VARCHAR2,';
    sp_N(14) := '    p_CREATED_BY              IN  CLOB,';
    sp_O(15) := '    p_CREATION_DATE           IN  VARCHAR2,';
    sp_N(15) := '    p_CREATION_DATE           IN  CLOB,';
    sp_O(16) := '    p_LAST_UPDATED_BY         IN  VARCHAR2,';
    sp_N(16) := '    p_LAST_UPDATED_BY         IN  CLOB,';
    v_a2 := '    --[E20261021-DMF0020SAVECLOB] BEGIN-NEW A2 : ''^'' 페이로드 선형 분할용 컬렉션·함수 (IN CLOB 수신 · 32,767B 한도 해제 · O(N^2) 분할 제거)' || CHR(10) ||
        '    TYPE T_TOK IS TABLE OF VARCHAR2(4000);' || CHR(10) ||
        '    T_ACTIVE_FLAG       T_TOK;' || CHR(10) ||
        '    T_DIVISION_ID       T_TOK;' || CHR(10) ||
        '    T_PROJECT_CODE      T_TOK;' || CHR(10) ||
        '    T_SCM_SITE_ID       T_TOK;' || CHR(10) ||
        '    T_PLANT_SITE_ID     T_TOK;' || CHR(10) ||
        '    T_ITEM_ID           T_TOK;' || CHR(10) ||
        '    T_YYYYMMDD          T_TOK;' || CHR(10) ||
        '    T_CURRENCY          T_TOK;' || CHR(10) ||
        '    T_MEASURE           T_TOK;' || CHR(10) ||
        '    T_DOM_EXP           T_TOK;' || CHR(10) ||
        '    T_FCST_TYPE         T_TOK;' || CHR(10) ||
        '    T_INCOTERMS         T_TOK;' || CHR(10) ||
        '    T_PRICE             T_TOK;' || CHR(10) ||
        '    T_CREATED_BY        T_TOK;' || CHR(10) ||
        '    T_LAST_UPDATED_BY   T_TOK;' || CHR(10) ||
        '    T_ROWNUM            T_TOK;' || CHR(10) ||
        '    V_ROW_CNT         PLS_INTEGER := 0;' || CHR(10) ||
        '    FUNCTION F_SPLIT_CARET(P_SRC IN CLOB) RETURN T_TOK IS' || CHR(10) ||
        '        --[E20261021-DMF0020SAVECLOB] CLOB ''^'' 선형 분할: 7,000자 조각(UTF-8 최대 28,000B)을 VARCHAR2 버퍼로 읽어 바이트 위치 이동(INSTRB/SUBSTRB)으로 토큰화.' || CHR(10) ||
        '        --  ''^''(0x5E)는 UTF-8 다바이트 문자 안에 나타나지 않고 조각은 문자 단위로 잘라 분절이 없다. 토큰 수 = ''^'' 수 + 1 (빈값 보존), NULL → 1개(NULL).' || CHR(10) ||
        '        --  사내 실측 2026-10-21: 200,000 토큰(1.4MB) 0.1초 (문자 단위 INSTR 는 UTF-8 오프셋 재계산으로 24초).' || CHR(10) ||
        '        V_OUT   T_TOK := T_TOK();' || CHR(10) ||
        '        V_LEN   PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_SRC), 0);' || CHR(10) ||
        '        V_POS   PLS_INTEGER := 1;' || CHR(10) ||
        '        V_BUF   VARCHAR2(32767);' || CHR(10) ||
        '        V_P     PLS_INTEGER;' || CHR(10) ||
        '        V_I     PLS_INTEGER;' || CHR(10) ||
        '        V_CARRY VARCHAR2(32767);' || CHR(10) ||
        '        C_CHUNK CONSTANT PLS_INTEGER := 7000;' || CHR(10) ||
        '    BEGIN' || CHR(10) ||
        '        WHILE V_POS <= V_LEN LOOP' || CHR(10) ||
        '            V_BUF := V_CARRY || DBMS_LOB.SUBSTR(P_SRC, C_CHUNK, V_POS);' || CHR(10) ||
        '            V_POS := V_POS + C_CHUNK;' || CHR(10) ||
        '            V_P := 1;' || CHR(10) ||
        '            LOOP' || CHR(10) ||
        '                V_I := INSTRB(V_BUF, ''^'', V_P);' || CHR(10) ||
        '                EXIT WHEN V_I = 0;' || CHR(10) ||
        '                V_OUT.EXTEND;' || CHR(10) ||
        '                V_OUT(V_OUT.COUNT) := SUBSTRB(V_BUF, V_P, V_I - V_P);' || CHR(10) ||
        '                V_P := V_I + 1;' || CHR(10) ||
        '            END LOOP;' || CHR(10) ||
        '            V_CARRY := SUBSTRB(V_BUF, V_P);' || CHR(10) ||
        '        END LOOP;' || CHR(10) ||
        '        V_OUT.EXTEND;' || CHR(10) ||
        '        V_OUT(V_OUT.COUNT) := V_CARRY;' || CHR(10) ||
        '        RETURN V_OUT;' || CHR(10) ||
        '    END F_SPLIT_CARET;' || CHR(10) ||
        '    PROCEDURE PAD_TOKENS(P_T IN OUT NOCOPY T_TOK, P_N IN PLS_INTEGER) IS' || CHR(10) ||
        '    BEGIN' || CHR(10) ||
        '        WHILE P_T.COUNT < P_N LOOP P_T.EXTEND; END LOOP;   --[E20261021-DMF0020SAVECLOB] 토큰이 모자란 컬럼은 NULL (원문: LEVEL 초과 = NULL / INSTR = 0 → NULL)' || CHR(10) ||
        '    END PAD_TOKENS;' || CHR(10) ||
        '    --[E20261021-DMF0020SAVECLOB] END-NEW A2' || CHR(10) ||
        '';
    v_a3 := '    --[E20261021-DMF0020SAVECLOB] BEGIN-NEW A3 : ''^'' 페이로드 선형 분할 + FORALL 적재 (원문 REGEXP_SUBSTR … CONNECT BY LEVEL 블록은 아래 ORIG 주석에 보존)' || CHR(10) ||
        '    --  사유: 원문은 LEVEL 마다 문자열 처음부터 재스캔(O(N^2)) + IN VARCHAR2 32,767B 한도 — 사내 실측 300행 13초 · 1,700행 10분 초과(PGA 폭주) · 3,000행 바인드 오류.' || CHR(10) ||
        '    --  동치: 토큰 수 = ''^'' 수 + 1(빈값 보존) · 각 토큰 TRIM · 짧은 컬럼 NULL 패딩(원문 LEVEL 초과 = NULL) · P_DIVISION_ID NULL = 0행(원문 REGEXP_COUNT(NULL) = NULL) · 식은 원문 SELECT 그대로.' || CHR(10) ||
        '    T_ACTIVE_FLAG       := F_SPLIT_CARET(P_ACTIVE_FLAG);' || CHR(10) ||
        '    T_DIVISION_ID       := F_SPLIT_CARET(P_DIVISION_ID);' || CHR(10) ||
        '    T_PROJECT_CODE      := F_SPLIT_CARET(P_PROJECT_CODE);' || CHR(10) ||
        '    T_SCM_SITE_ID       := F_SPLIT_CARET(P_SCM_SITE_ID);' || CHR(10) ||
        '    T_PLANT_SITE_ID     := F_SPLIT_CARET(P_PLANT_SITE_ID);' || CHR(10) ||
        '    T_ITEM_ID           := F_SPLIT_CARET(P_ITEM_ID);' || CHR(10) ||
        '    T_YYYYMMDD          := F_SPLIT_CARET(P_YYYYMMDD);' || CHR(10) ||
        '    T_CURRENCY          := F_SPLIT_CARET(P_CURRENCY);' || CHR(10) ||
        '    T_MEASURE           := F_SPLIT_CARET(P_MEASURE);' || CHR(10) ||
        '    T_DOM_EXP           := F_SPLIT_CARET(P_DOM_EXP);' || CHR(10) ||
        '    T_FCST_TYPE         := F_SPLIT_CARET(P_FCST_TYPE);' || CHR(10) ||
        '    T_INCOTERMS         := F_SPLIT_CARET(P_INCOTERMS);' || CHR(10) ||
        '    T_PRICE             := F_SPLIT_CARET(P_PRICE);' || CHR(10) ||
        '    T_CREATED_BY        := F_SPLIT_CARET(P_CREATED_BY);' || CHR(10) ||
        '    T_LAST_UPDATED_BY   := F_SPLIT_CARET(P_LAST_UPDATED_BY);' || CHR(10) ||
        '    T_ROWNUM            := F_SPLIT_CARET(P_ROWNUM);' || CHR(10) ||
        '    V_ROW_CNT := CASE WHEN P_DIVISION_ID IS NULL THEN 0 ELSE T_DIVISION_ID.COUNT END;' || CHR(10) ||
        '    PAD_TOKENS(T_ACTIVE_FLAG, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_PROJECT_CODE, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_SCM_SITE_ID, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_PLANT_SITE_ID, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_ITEM_ID, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_YYYYMMDD, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_CURRENCY, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_MEASURE, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_DOM_EXP, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_FCST_TYPE, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_INCOTERMS, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_PRICE, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_CREATED_BY, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_LAST_UPDATED_BY, V_ROW_CNT);' || CHR(10) ||
        '    PAD_TOKENS(T_ROWNUM, V_ROW_CNT);' || CHR(10) ||
        '    IF V_ROW_CNT > 0 THEN' || CHR(10) ||
        '        FORALL I IN 1 .. V_ROW_CNT' || CHR(10) ||
        '            INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST' || CHR(10) ||
        '            (' || CHR(10) ||
        '                 V_ACTIVE_FLAG' || CHR(10) ||
        '                ,V_DIVISION_ID' || CHR(10) ||
        '                ,V_PROJECT_CODE' || CHR(10) ||
        '                ,V_SCM_SITE_ID' || CHR(10) ||
        '                ,V_PLANT_SITE_ID' || CHR(10) ||
        '                ,V_ITEM_ID' || CHR(10) ||
        '                ,V_YYYYMMDD' || CHR(10) ||
        '                ,V_CURRENCY' || CHR(10) ||
        '                ,V_MEASURE' || CHR(10) ||
        '                ,V_DOM_EXP' || CHR(10) ||
        '                ,V_FCST_TYPE' || CHR(10) ||
        '                ,V_INCOTERMS' || CHR(10) ||
        '                ,V_PRICE' || CHR(10) ||
        '                ,V_CREATED_BY' || CHR(10) ||
        '                ,V_CREATION_DATE' || CHR(10) ||
        '                ,V_LAST_UPDATED_BY' || CHR(10) ||
        '                ,V_ROWNUM' || CHR(10) ||
        '            )' || CHR(10) ||
        '            VALUES' || CHR(10) ||
        '            (' || CHR(10) ||
        '                 TRIM(T_ACTIVE_FLAG(I))' || CHR(10) ||
        '                ,NVL(TRIM(T_DIVISION_ID(I)), ''/'')   -- 2026.10.13 POJ 빈값 대체값 ''/'' (원문 동일)' || CHR(10) ||
        '                ,NVL(TRIM(T_PROJECT_CODE(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_SCM_SITE_ID(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_PLANT_SITE_ID(I)), ''/'')' || CHR(10) ||
        '                -- [E20250522-001188] ITEM 제어문자(CR/LF/TAB/공백) 제거 (원문 동일)' || CHR(10) ||
        '                ,NVL(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(T_ITEM_ID(I)), CHR(13), ''''), CHR(10), ''''), CHR(9), ''''), '' '', ''''), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_YYYYMMDD(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_CURRENCY(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_MEASURE(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_DOM_EXP(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_FCST_TYPE(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TRIM(T_INCOTERMS(I)), ''/'')' || CHR(10) ||
        '                ,NVL(TO_NUMBER(TRIM(T_PRICE(I)) DEFAULT 0 ON CONVERSION ERROR), 0)   --*[2026-09-07] POJ 빈 값은 0 (원문 동일)' || CHR(10) ||
        '                ,TRIM(T_CREATED_BY(I))' || CHR(10) ||
        '                ,SYSDATE                                                          -- @v_CREATION_DATE 대신 GETDATE() (원문 동일)' || CHR(10) ||
        '                ,TRIM(T_LAST_UPDATED_BY(I))' || CHR(10) ||
        '                ,NVL(TO_NUMBER(TRIM(T_ROWNUM(I)) DEFAULT 0 ON CONVERSION ERROR), 0)   --[PJ20200138] RowNum (원문 동일)' || CHR(10) ||
        '            );' || CHR(10) ||
        '    END IF;' || CHR(10) ||
        '    --[E20261021-DMF0020SAVECLOB] END-NEW A3' || CHR(10) ||
        '';
    v_a4 := '        --[E20261021-DMF0020SAVECLOB] BEGIN-NEW A4 : IN CLOB 진단 JSON = SQL 컨텍스트 RETURNING CLOB (PL/SQL 대입 JSON_OBJECT 는 VARCHAR2(4000) 반환이라 대량 시 ORA-40478 로 원래 오류가 가려짐) + 로그 VARCHAR2 한도 4000 절단 (hook #106 §3)' || CHR(10) ||
        '        BEGIN' || CHR(10) ||
        '            SELECT JSON_OBJECT(' || CHR(10) ||
        '                ''P_ACTIVE_FLAG''      VALUE P_ACTIVE_FLAG,' || CHR(10) ||
        '                ''P_DIVISION_ID''      VALUE P_DIVISION_ID,' || CHR(10) ||
        '                ''P_PROJECT_CODE''     VALUE P_PROJECT_CODE,' || CHR(10) ||
        '                ''P_SCM_SITE_ID''      VALUE P_SCM_SITE_ID,' || CHR(10) ||
        '                ''P_PLANT_SITE_ID''    VALUE P_PLANT_SITE_ID,' || CHR(10) ||
        '                ''P_ITEM_ID''          VALUE P_ITEM_ID,' || CHR(10) ||
        '                ''P_YYYYMMDD''         VALUE P_YYYYMMDD,' || CHR(10) ||
        '                ''P_CURRENCY''         VALUE P_CURRENCY,' || CHR(10) ||
        '                ''P_MEASURE''          VALUE P_MEASURE,' || CHR(10) ||
        '                ''P_DOM_EXP''          VALUE P_DOM_EXP,' || CHR(10) ||
        '                ''P_FCST_TYPE''        VALUE P_FCST_TYPE,' || CHR(10) ||
        '                ''P_INCOTERMS''        VALUE P_INCOTERMS,' || CHR(10) ||
        '                ''P_PRICE''            VALUE P_PRICE,' || CHR(10) ||
        '                ''P_CREATED_BY''       VALUE P_CREATED_BY,' || CHR(10) ||
        '                ''P_CREATION_DATE''    VALUE P_CREATION_DATE,' || CHR(10) ||
        '                ''P_LAST_UPDATED_BY''  VALUE P_LAST_UPDATED_BY,' || CHR(10) ||
        '                ''P_ROWNUM''           VALUE P_ROWNUM' || CHR(10) ||
        '                RETURNING CLOB)' || CHR(10) ||
        '              INTO V_PROC_INPUT' || CHR(10) ||
        '              FROM DUAL;' || CHR(10) ||
        '            V_PROC_INPUT := DBMS_LOB.SUBSTR(V_PROC_INPUT, 4000, 1);' || CHR(10) ||
        '        EXCEPTION' || CHR(10) ||
        '            WHEN OTHERS THEN' || CHR(10) ||
        '                V_PROC_INPUT := ''{"PARAMS":"(unavailable) '' || REPLACE(SUBSTR(SQLERRM, 1, 200), ''"'', '''''''') || ''"}'';' || CHR(10) ||
        '        END;' || CHR(10) ||
        '        --[E20261021-DMF0020SAVECLOB] END-NEW A4' || CHR(10) ||
        '';
    v_a5 := '    --[E20261021-DMF0020SAVECLOB] BEGIN-NEW A5 : LOC 통화 맞추기(F-03) - 상관 UPDATE(행마다 GTT 전체 2회 스캔, 인덱스 없음 → O(N^2)) → LOC 기준 집계 1회 + MERGE.' || CHR(10) ||
        '    --  동치: 같은 키 LOC 행이 없거나 MAX 가 NULL/같으면 갱신 안 함(원문 NVL(MAX, 자기값) <> 자기값) · 키 비교 등호(NULL 불일치) 동일 · 사내 무작위 300/2,000/5,000행 상태 전수 일치.' || CHR(10) ||
        '    MERGE INTO SCM_MGR.GT_FCSV_RESULTS_MST A' || CHR(10) ||
        '    USING ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, MAX(V_CURRENCY) AS MAX_VAL' || CHR(10) ||
        '              FROM SCM_MGR.GT_FCSV_RESULTS_MST' || CHR(10) ||
        '             WHERE V_MEASURE = ''LOC''' || CHR(10) ||
        '             GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS ) B' || CHR(10) ||
        '       ON ( B.V_DIVISION_ID = A.V_DIVISION_ID' || CHR(10) ||
        '          AND B.V_PROJECT_CODE = A.V_PROJECT_CODE' || CHR(10) ||
        '          AND B.V_SCM_SITE_ID = A.V_SCM_SITE_ID' || CHR(10) ||
        '          AND B.V_PLANT_SITE_ID = A.V_PLANT_SITE_ID' || CHR(10) ||
        '          AND B.V_ITEM_ID = A.V_ITEM_ID' || CHR(10) ||
        '          AND B.V_YYYYMMDD = A.V_YYYYMMDD' || CHR(10) ||
        '          AND B.V_DOM_EXP = A.V_DOM_EXP' || CHR(10) ||
        '          AND B.V_FCST_TYPE = A.V_FCST_TYPE' || CHR(10) ||
        '          AND B.V_INCOTERMS = A.V_INCOTERMS' || CHR(10) ||
        '          AND A.V_MEASURE <> ''LOC'' )' || CHR(10) ||
        '     WHEN MATCHED THEN UPDATE SET A.V_CURRENCY = B.MAX_VAL' || CHR(10) ||
        '      WHERE B.MAX_VAL <> A.V_CURRENCY;' || CHR(10) ||
        '    --[E20261021-DMF0020SAVECLOB] END-NEW A5' || CHR(10) ||
        '';
    v_a6 := '    --[E20261021-DMF0020SAVECLOB] BEGIN-NEW A6 : LOC 기준 ACTIVE_FLAG 맞추기(F-02) - 상관 UPDATE(행마다 GTT 전체 2회 스캔, 인덱스 없음 → O(N^2)) → LOC 기준 집계 1회 + MERGE.' || CHR(10) ||
        '    --  동치: 같은 키 LOC 행이 없거나 MAX 가 NULL/같으면 갱신 안 함(원문 NVL(MAX, 자기값) <> 자기값) · 키 비교 등호(NULL 불일치) 동일 · 사내 무작위 300/2,000/5,000행 상태 전수 일치.' || CHR(10) ||
        '    MERGE INTO SCM_MGR.GT_FCSV_RESULTS_MST A' || CHR(10) ||
        '    USING ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_CURRENCY, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, MAX(V_ACTIVE_FLAG) AS MAX_VAL' || CHR(10) ||
        '              FROM SCM_MGR.GT_FCSV_RESULTS_MST' || CHR(10) ||
        '             WHERE V_MEASURE = ''LOC''' || CHR(10) ||
        '             GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_CURRENCY, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS ) B' || CHR(10) ||
        '       ON ( B.V_DIVISION_ID = A.V_DIVISION_ID' || CHR(10) ||
        '          AND B.V_PROJECT_CODE = A.V_PROJECT_CODE' || CHR(10) ||
        '          AND B.V_SCM_SITE_ID = A.V_SCM_SITE_ID' || CHR(10) ||
        '          AND B.V_PLANT_SITE_ID = A.V_PLANT_SITE_ID' || CHR(10) ||
        '          AND B.V_ITEM_ID = A.V_ITEM_ID' || CHR(10) ||
        '          AND B.V_YYYYMMDD = A.V_YYYYMMDD' || CHR(10) ||
        '          AND B.V_CURRENCY = A.V_CURRENCY' || CHR(10) ||
        '          AND B.V_DOM_EXP = A.V_DOM_EXP' || CHR(10) ||
        '          AND B.V_FCST_TYPE = A.V_FCST_TYPE' || CHR(10) ||
        '          AND B.V_INCOTERMS = A.V_INCOTERMS' || CHR(10) ||
        '          AND A.V_MEASURE <> ''LOC'' )' || CHR(10) ||
        '     WHEN MATCHED THEN UPDATE SET A.V_ACTIVE_FLAG = B.MAX_VAL' || CHR(10) ||
        '      WHERE B.MAX_VAL <> A.V_ACTIVE_FLAG;' || CHR(10) ||
        '    --[E20261021-DMF0020SAVECLOB] END-NEW A6' || CHR(10) ||
        '';
    v_a7 := '           --[E20261021-DMF0020SAVECLOB] BEGIN-NEW A7 : 보충 대상 판정 NOT EXISTS 의 키 비교 DECODE(x,y,1,0)=1(해시 불가 → O(N^2)) → NVL(x,CHR(0)) 등호(해시 안티조인).' || CHR(10) ||
        '           --  동치: 두 식 모두 NULL=NULL 을 같다고 본다 · 사내 무작위 300/2,000/5,000행 상태 전수 일치.' || CHR(10) ||
        '           AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K' || CHR(10) ||
        '                             WHERE K.V_MEASURE = ''KRW''' || CHR(10) ||
        '                                AND NVL(K.V_DIVISION_ID, CHR(0)) = NVL(L.V_DIVISION_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_PROJECT_CODE, CHR(0)) = NVL(L.V_PROJECT_CODE, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_SCM_SITE_ID, CHR(0)) = NVL(L.V_SCM_SITE_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_PLANT_SITE_ID, CHR(0)) = NVL(L.V_PLANT_SITE_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_ITEM_ID, CHR(0)) = NVL(L.V_ITEM_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_YYYYMMDD, CHR(0)) = NVL(L.V_YYYYMMDD, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_CURRENCY, CHR(0)) = NVL(L.V_CURRENCY, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_DOM_EXP, CHR(0)) = NVL(L.V_DOM_EXP, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_FCST_TYPE, CHR(0)) = NVL(L.V_FCST_TYPE, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_INCOTERMS, CHR(0)) = NVL(L.V_INCOTERMS, CHR(0)) );' || CHR(10) ||
        '           --[E20261021-DMF0020SAVECLOB] END-NEW A7' || CHR(10) ||
        '';
    v_a8 := '           --[E20261021-DMF0020SAVECLOB] BEGIN-NEW A8 : 보충 대상 판정 NOT EXISTS 의 키 비교 DECODE(x,y,1,0)=1(해시 불가 → O(N^2)) → NVL(x,CHR(0)) 등호(해시 안티조인).' || CHR(10) ||
        '           --  동치: 두 식 모두 NULL=NULL 을 같다고 본다 · 사내 무작위 300/2,000/5,000행 상태 전수 일치.' || CHR(10) ||
        '           AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K' || CHR(10) ||
        '                             WHERE K.V_MEASURE = ''USD''' || CHR(10) ||
        '                                AND NVL(K.V_DIVISION_ID, CHR(0)) = NVL(L.V_DIVISION_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_PROJECT_CODE, CHR(0)) = NVL(L.V_PROJECT_CODE, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_SCM_SITE_ID, CHR(0)) = NVL(L.V_SCM_SITE_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_PLANT_SITE_ID, CHR(0)) = NVL(L.V_PLANT_SITE_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_ITEM_ID, CHR(0)) = NVL(L.V_ITEM_ID, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_YYYYMMDD, CHR(0)) = NVL(L.V_YYYYMMDD, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_CURRENCY, CHR(0)) = NVL(L.V_CURRENCY, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_DOM_EXP, CHR(0)) = NVL(L.V_DOM_EXP, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_FCST_TYPE, CHR(0)) = NVL(L.V_FCST_TYPE, CHR(0))' || CHR(10) ||
        '                                AND NVL(K.V_INCOTERMS, CHR(0)) = NVL(L.V_INCOTERMS, CHR(0)) );' || CHR(10) ||
        '           --[E20261021-DMF0020SAVECLOB] END-NEW A8' || CHR(10) ||
        '';
    v_p2 := '    --[E20261021-DMF0020SAVECLOB] BEGIN-NEW P2 : ''^'' 페이로드 홀더 VARCHAR2(32767) 15종 → 선형 분할 토큰 컬렉션 (IN CLOB 수신 · 32,767B 한도 해제)' || CHR(10) ||
        '    TYPE t_tok IS TABLE OF VARCHAR2(4000);' || CHR(10) ||
        '    t_active_flag        t_tok;' || CHR(10) ||
        '    t_DIVISION_ID        t_tok;' || CHR(10) ||
        '    t_PROJECT_CODE       t_tok;' || CHR(10) ||
        '    t_SCM_SITE_ID        t_tok;' || CHR(10) ||
        '    t_PLANT_SITE_ID      t_tok;' || CHR(10) ||
        '    t_ITEM_ID            t_tok;' || CHR(10) ||
        '    t_YYYYMMDD           t_tok;' || CHR(10) ||
        '    t_CURRENCY           t_tok;' || CHR(10) ||
        '    t_MEASURE            t_tok;' || CHR(10) ||
        '    t_DOM_EXP            t_tok;' || CHR(10) ||
        '    t_FCST_TYPE          t_tok;' || CHR(10) ||
        '    t_INCOTERMS          t_tok;' || CHR(10) ||
        '    t_PRICE              t_tok;' || CHR(10) ||
        '    t_CREATED_BY         t_tok;' || CHR(10) ||
        '    t_LAST_UPDATED_BY    t_tok;' || CHR(10) ||
        '    v_row_cnt            PLS_INTEGER := 0;' || CHR(10) ||
        '    --[E20261021-DMF0020SAVECLOB] END-NEW P2' || CHR(10) ||
        '';
    v_p2b := '    --[E20261021-DMF0020SAVECLOB] BEGIN-NEW P2B : CLOB ''^'' 선형 분할 함수 (지역 서브프로그램은 선언부 끝)' || CHR(10) ||
        '    FUNCTION f_split_caret(P_SRC IN CLOB) RETURN t_tok IS' || CHR(10) ||
        '        --[E20261021-DMF0020SAVECLOB] CLOB ''^'' 선형 분할: 7,000자 조각(UTF-8 최대 28,000B)을 VARCHAR2 버퍼로 읽어 바이트 위치 이동(INSTRB/SUBSTRB)으로 토큰화.' || CHR(10) ||
        '        --  ''^''(0x5E)는 UTF-8 다바이트 문자 안에 나타나지 않고 조각은 문자 단위로 잘라 분절이 없다. 토큰 수 = ''^'' 수 + 1 (빈값 보존), NULL → 1개(NULL).' || CHR(10) ||
        '        --  사내 실측 2026-10-21: 200,000 토큰(1.4MB) 0.1초 (문자 단위 INSTR 는 UTF-8 오프셋 재계산으로 24초).' || CHR(10) ||
        '        V_OUT   t_tok := t_tok();' || CHR(10) ||
        '        V_LEN   PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_SRC), 0);' || CHR(10) ||
        '        V_POS   PLS_INTEGER := 1;' || CHR(10) ||
        '        V_BUF   VARCHAR2(32767);' || CHR(10) ||
        '        V_P     PLS_INTEGER;' || CHR(10) ||
        '        V_I     PLS_INTEGER;' || CHR(10) ||
        '        V_CARRY VARCHAR2(32767);' || CHR(10) ||
        '        C_CHUNK CONSTANT PLS_INTEGER := 7000;' || CHR(10) ||
        '    BEGIN' || CHR(10) ||
        '        WHILE V_POS <= V_LEN LOOP' || CHR(10) ||
        '            V_BUF := V_CARRY || DBMS_LOB.SUBSTR(P_SRC, C_CHUNK, V_POS);' || CHR(10) ||
        '            V_POS := V_POS + C_CHUNK;' || CHR(10) ||
        '            V_P := 1;' || CHR(10) ||
        '            LOOP' || CHR(10) ||
        '                V_I := INSTRB(V_BUF, ''^'', V_P);' || CHR(10) ||
        '                EXIT WHEN V_I = 0;' || CHR(10) ||
        '                V_OUT.EXTEND;' || CHR(10) ||
        '                V_OUT(V_OUT.COUNT) := SUBSTRB(V_BUF, V_P, V_I - V_P);' || CHR(10) ||
        '                V_P := V_I + 1;' || CHR(10) ||
        '            END LOOP;' || CHR(10) ||
        '            V_CARRY := SUBSTRB(V_BUF, V_P);' || CHR(10) ||
        '        END LOOP;' || CHR(10) ||
        '        V_OUT.EXTEND;' || CHR(10) ||
        '        V_OUT(V_OUT.COUNT) := V_CARRY;' || CHR(10) ||
        '        RETURN V_OUT;' || CHR(10) ||
        '    END f_split_caret;' || CHR(10) ||
        '    PROCEDURE pad_tokens(P_T IN OUT NOCOPY t_tok, P_N IN PLS_INTEGER) IS' || CHR(10) ||
        '    BEGIN' || CHR(10) ||
        '        WHILE P_T.COUNT < P_N LOOP P_T.EXTEND; END LOOP;   --[E20261021-DMF0020SAVECLOB] 토큰이 모자란 컬럼은 NULL (원문: LEVEL 초과 = NULL / INSTR = 0 → NULL)' || CHR(10) ||
        '    END pad_tokens;' || CHR(10) ||
        '    --[E20261021-DMF0020SAVECLOB] END-NEW P2B' || CHR(10) ||
        '';
    v_p3 := '' || CHR(9) || '--[E20261021-DMF0020SAVECLOB] BEGIN-NEW P3 : 홀더 복사(RTRIM(p_X) || ''^'') → 선형 분할. 행 수 = p_DIVISION_ID 토큰 수(''^'' 수 + 1 · NULL 도 1행 — 원문 동일) · 짧은 컬럼 NULL 패딩(원문 INSTR = 0 → NULL 동일) · 공백은 아래 rtrim(ltrim()) 원문이 제거' || CHR(10) ||
        '' || CHR(9) || 't_active_flag        := f_split_caret(p_active_flag);' || CHR(10) ||
        '' || CHR(9) || 't_DIVISION_ID        := f_split_caret(p_DIVISION_ID);' || CHR(10) ||
        '' || CHR(9) || 't_PROJECT_CODE       := f_split_caret(p_PROJECT_CODE);' || CHR(10) ||
        '' || CHR(9) || 't_SCM_SITE_ID        := f_split_caret(p_SCM_SITE_ID);' || CHR(10) ||
        '' || CHR(9) || 't_PLANT_SITE_ID      := f_split_caret(p_PLANT_SITE_ID);' || CHR(10) ||
        '' || CHR(9) || 't_ITEM_ID            := f_split_caret(p_ITEM_ID);' || CHR(10) ||
        '' || CHR(9) || 't_YYYYMMDD           := f_split_caret(p_YYYYMMDD);' || CHR(10) ||
        '' || CHR(9) || 't_CURRENCY           := f_split_caret(p_CURRENCY);' || CHR(10) ||
        '' || CHR(9) || 't_MEASURE            := f_split_caret(p_MEASURE);' || CHR(10) ||
        '' || CHR(9) || 't_DOM_EXP            := f_split_caret(p_DOM_EXP);' || CHR(10) ||
        '' || CHR(9) || 't_FCST_TYPE          := f_split_caret(p_FCST_TYPE);' || CHR(10) ||
        '' || CHR(9) || 't_INCOTERMS          := f_split_caret(p_INCOTERMS);' || CHR(10) ||
        '' || CHR(9) || 't_PRICE              := f_split_caret(p_PRICE);' || CHR(10) ||
        '' || CHR(9) || 't_CREATED_BY         := f_split_caret(p_CREATED_BY);' || CHR(10) ||
        '' || CHR(9) || 't_LAST_UPDATED_BY    := f_split_caret(p_LAST_UPDATED_BY);' || CHR(10) ||
        '' || CHR(9) || 'v_row_cnt := t_DIVISION_ID.COUNT;' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_active_flag, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_PROJECT_CODE, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_SCM_SITE_ID, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_PLANT_SITE_ID, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_ITEM_ID, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_YYYYMMDD, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_CURRENCY, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_MEASURE, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_DOM_EXP, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_FCST_TYPE, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_INCOTERMS, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_PRICE, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_CREATED_BY, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || 'pad_tokens(t_LAST_UPDATED_BY, v_row_cnt);' || CHR(10) ||
        '' || CHR(9) || '--[E20261021-DMF0020SAVECLOB] END-NEW P3' || CHR(10) ||
        '';
    v_p4 := '--[E20261021-DMF0020SAVECLOB] BEGIN-NEW P4 : WHILE/INSTR/SUBSTR 토큰 소비 루프(홀더 재할당 O(N^2)) → 컬렉션 인덱스 루프. 추출 뒤 공백제거·INSERT 는 원문 그대로.' || CHR(10) ||
        '--  원문 ELSE 분기(마지막 토큰 전용)는 도달 불가(홀더 끝에 ''^'' 를 붙여 루프 안에서 INSTR 가 항상 > 0)라 제거 — 아래 ORIG 주석에 보존.' || CHR(10) ||
        'FOR v_i IN 1 .. v_row_cnt LOOP' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_active_flag      := t_active_flag(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_DIVISION_ID      := t_DIVISION_ID(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_PROJECT_CODE     := t_PROJECT_CODE(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_SCM_SITE_ID      := t_SCM_SITE_ID(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_PLANT_SITE_ID    := t_PLANT_SITE_ID(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_ITEM_ID          := t_ITEM_ID(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_YYYYMMDD         := t_YYYYMMDD(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_CURRENCY         := t_CURRENCY(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_MEASURE          := t_MEASURE(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_DOM_EXP          := t_DOM_EXP(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_FCST_TYPE        := t_FCST_TYPE(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_INCOTERMS        := t_INCOTERMS(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_PRICE            := t_PRICE(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_CREATED_BY       := t_CREATED_BY(v_i);' || CHR(10) ||
        '' || CHR(9) || '' || CHR(9) || '' || CHR(9) || 'v_LAST_UPDATED_BY  := t_LAST_UPDATED_BY(v_i);' || CHR(10) ||
        '';

    v_spec := load('PACKAGE'); v_body := load('PACKAGE BODY');
    IF DBMS_LOB.INSTR(v_spec, c_mark) = 0 AND DBMS_LOB.INSTR(v_body, c_mark) = 0 THEN
        UPDATE SCM_MGR.SCM_ADM_PROC_M SET DATA_TP_CD = 'VARCHAR', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE PROC_NM IN ('PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL', 'PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP') AND COL_TP_CD = 'IN' AND DATA_TP_CD = 'CLOB' AND COL_NM IN ('activeFlag', 'divisionId', 'projectCode', 'scmSiteId', 'plantSiteId', 'itemId', 'yyyymmdd', 'currency', 'measure', 'domExp', 'fcstType', 'incoterms', 'price', 'createdByList', 'creationDate', 'lastUpdatedByList', 'rownumKey');
        v_n := SQL%ROWCOUNT; COMMIT;
        DBMS_OUTPUT.PUT_LINE('SKIP - marker absent (not applied). source unchanged. PROC_M VARCHAR restored rows=' || v_n);
        RETURN;
    END IF;
    v_spec_n := v_spec; v_body_n := v_body;
    split_seg(v_spec_n, 'PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL', ');');
    FOR i IN 1 .. 17 LOOP rep1(sa_n(i), sa_o(i)); END LOOP;
    v_spec_n := join_seg(v_spec_n);
    split_seg(v_spec_n, 'PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP', ');');
    FOR i IN 1 .. 16 LOOP rep1(sp_n(i), sp_o(i)); END LOOP;
    v_spec_n := join_seg(v_spec_n);
    split_seg(v_body_n, 'PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL', 'END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL;');
    FOR i IN 1 .. 17 LOOP rep1(ha_n(i), ha_o(i)); END LOOP;
    remove_block('A2', '    --' || c_mark || ' BEGIN-NEW A2', '    --' || c_mark || ' END-NEW A2' || CHR(10));
    region_rollback('A3', '    ', '    --' || c_mark || ' BEGIN-NEW A3');
    region_rollback('A4', '        ', '        --' || c_mark || ' BEGIN-NEW A4');
    region_rollback('A5', '    ', '    --' || c_mark || ' BEGIN-NEW A5 ');
    region_rollback('A6', '    ', '    --' || c_mark || ' BEGIN-NEW A6 ');
    region_rollback('A7', '           ', '           --' || c_mark || ' BEGIN-NEW A7 ');
    region_rollback('A8', '           ', '           --' || c_mark || ' BEGIN-NEW A8 ');
    v_body_n := join_seg(v_body_n);
    split_seg(v_body_n, 'PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP', 'END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP;');
    FOR i IN 1 .. 16 LOOP rep1(hp_n(i), hp_o(i)); END LOOP;
    region_rollback('P2', '    ', '    --' || c_mark || ' BEGIN-NEW P2 ');
    remove_block('P2B', '    --' || c_mark || ' BEGIN-NEW P2B', '    --' || c_mark || ' END-NEW P2B' || CHR(10));
    region_rollback('P3', CHR(9), CHR(9) || '--' || c_mark || ' BEGIN-NEW P3');
    region_rollback('P4', '', '--' || c_mark || ' BEGIN-NEW P4');
    v_body_n := join_seg(v_body_n);

    expect('marker remaining', cnt(v_spec_n, c_mark) + cnt(v_body_n, c_mark), 0);
    -- 컴파일: SPEC → BODY · 실패 시 적용본으로 되돌림
    compile_obj(v_spec_n, 'PACKAGE');
    IF v_fail IS NULL THEN compile_obj(v_body_n, 'PACKAGE BODY'); END IF;
    IF v_fail IS NOT NULL THEN
        compile_obj(v_body, 'PACKAGE BODY'); compile_obj(v_spec, 'PACKAGE'); compile_obj(v_body, 'PACKAGE BODY');
        recompile_dependents;
        RAISE_APPLICATION_ERROR(-20005, 'ROLLBACK COMPILE FAILED (' || v_fail || ') -> applied SPEC/BODY restored. check 90_VERIFY');
    END IF;
    recompile_dependents;
    UPDATE SCM_MGR.SCM_ADM_PROC_M SET DATA_TP_CD = 'VARCHAR', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE PROC_NM IN ('PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL', 'PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP') AND COL_TP_CD = 'IN' AND DATA_TP_CD = 'CLOB' AND COL_NM IN ('activeFlag', 'divisionId', 'projectCode', 'scmSiteId', 'plantSiteId', 'itemId', 'yyyymmdd', 'currency', 'measure', 'domExp', 'fcstType', 'incoterms', 'price', 'createdByList', 'creationDate', 'lastUpdatedByList', 'rownumKey');
    v_n := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK - PKG_DMF0020 SPEC/BODY VALID · markers 0 · PROC_M VARCHAR restored ' || v_n || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0020' ORDER BY OBJECT_TYPE;

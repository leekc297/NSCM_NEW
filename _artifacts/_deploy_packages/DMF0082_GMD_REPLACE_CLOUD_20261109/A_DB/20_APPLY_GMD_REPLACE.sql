/* =====================================================================================================
 * DMF0082 GET_MAIN_DATA 교체 · 20_APPLY_GMD_REPLACE — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA ← PKG_DMF0082_1104 구간 (컴파일 실패 시 백업 원문 자동 복원)
 * 마커 [E20261104-DMF0082ONEQUERY] · 생성 2026-11-09 14:03:13 (사내 ZIOUI1) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 교체 = PKG_DMF0082 의 P_DMF0082_GET_MAIN_DATA 구간 ← PKG_DMF0082_1104 의 같은 구간 (이 DB 의 USER_SOURCE 끼리 · 나머지 프로시저 무변경)
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 반복 실행 안전: 이미 교체됐으면 SKIP. 10 백업이 없으면 중단(원문 무변경).
-- 컴파일 오류(ORA-24344)면 오류 목록을 출력하고 백업 원문으로 즉시 복원한다. 그 밖의 오류(예: 실행 중 세션 잠금 ORA-04021)는 생성 자체가 안 된 것이므로 원문 그대로 중단.
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- 리허설용(TRUE = 조립·판정만 · 변경 없음)
    t1 PLS_INTEGER; t2 PLS_INTEGER; s1 PLS_INTEGER; s2 PLS_INTEGER;
    n  PLS_INTEGER;
    v  CLOB;
    bk CLOB;
    v_code NUMBER;
    v_st   VARCHAR2(30);
    an NUMBER; al NUMBER; ah NUMBER; bn NUMBER; bl NUMBER; bh NUMBER;
    FUNCTION anc(p_name VARCHAR2, p_re VARCHAR2) RETURN PLS_INTEGER IS
        r PLS_INTEGER; k PLS_INTEGER;
    BEGIN
        SELECT MIN(LINE), COUNT(*) INTO r, k FROM USER_SOURCE WHERE NAME = p_name AND TYPE = 'PACKAGE BODY' AND REGEXP_LIKE(TEXT, p_re);
        IF k <> 1 THEN
            RAISE_APPLICATION_ERROR(-20031, '중단 — ' || p_name || ' 구간 경계 ' || k || '건(1건이어야 함) · 원문 무변경 · 회신: ' || p_re);
        END IF;
        RETURN r;
    END;
    PROCEDURE app(p_name VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) IS
    BEGIN
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_name AND TYPE = 'PACKAGE BODY' AND LINE >= p_from AND LINE <= p_to ORDER BY LINE) LOOP
            IF r.TEXT IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT); END IF;
        END LOOP;
    END;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_GMD_BAK';
    IF n = 0 THEN RAISE_APPLICATION_ERROR(-20030, '중단 — 백업표 ZB_DMF0082_GMD_BAK 없음 · 10_BACKUP 먼저 실행 · 원문 무변경'); END IF;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_DMF0082_GMD_BAK WHERE OBJ_TYPE = ''PACKAGE BODY''' INTO n;
    IF n <> 1 THEN RAISE_APPLICATION_ERROR(-20030, '중단 — 백업표에 BODY 원문 없음 · 원문 무변경'); END IF;
    t1 := anc('PKG_DMF0082', '^\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)'); t2 := anc('PKG_DMF0082', '^\s*PROCEDURE\s+P_DMF0082_POPUP_GET_FUTUREPRICE_INFO(\s|\(|$)');
    s1 := anc('PKG_DMF0082_1104', '^\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)'); s2 := anc('PKG_DMF0082_1104', '^\s*PROCEDURE\s+P_DMF0082_POPUP_GET_FUTUREPRICE_INFO(\s|\(|$)');
    -- 이미 교체됐는지: PKG_DMF0082 구간 지문 = PKG_DMF0082_1104 구간 지문
    SELECT COUNT(*), NVL(SUM(LENGTH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0), NVL(SUM(ORA_HASH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0) INTO an, al, ah FROM USER_SOURCE
     WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND LINE >= t1 AND LINE < t2 AND RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)) IS NOT NULL;
    SELECT COUNT(*), NVL(SUM(LENGTH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0), NVL(SUM(ORA_HASH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0) INTO bn, bl, bh FROM USER_SOURCE
     WHERE NAME = 'PKG_DMF0082_1104' AND TYPE = 'PACKAGE BODY' AND LINE >= s1 AND LINE < s2 AND RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)) IS NOT NULL;
    IF an = bn AND al = bl AND ah = bh THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 교체됨 (PKG_DMF0082 GET_MAIN_DATA = PKG_DMF0082_1104 구간 · ' || an || '줄)');
        RETURN;
    END IF;
    IF bn <> 16294 OR bl <> 922025 THEN
        RAISE_APPLICATION_ERROR(-20033, '중단 — PKG_DMF0082_1104 구간이 사내 검증본과 다름(줄 ' || bn || ' · 길이 ' || bl || ' / 기대 16294 · 922025) · 원문 무변경');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    app('PKG_DMF0082', 1, t1 - 1);
    app('PKG_DMF0082_1104', s1, s2 - 1);
    app('PKG_DMF0082', t2, 999999999);
    DBMS_OUTPUT.PUT_LINE('조립 — PKG_DMF0082 1~' || (t1 - 1) || ' + PKG_DMF0082_1104 ' || s1 || '~' || (s2 - 1) || ' + PKG_DMF0082 ' || t2 || '~끝 = ' || DBMS_LOB.GETLENGTH(v) || '자');
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('DRY     변경 없음');
        RETURN;
    END IF;
    v_code := 0;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20034, '중단 — 생성 미실행 SQLCODE ' || v_code || ' (실행 중 세션 잠금 등) · 원문 그대로 · 세션 확인 후 재실행');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    IF v_st = 'VALID' THEN
        DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY VALID · GET_MAIN_DATA 교체 완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('컴파일 오류 — 아래 오류를 회신해 주세요 (원문으로 자동 복원합니다)');
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND ROWNUM <= 30 ORDER BY SEQUENCE) LOOP
            DBMS_OUTPUT.PUT_LINE('  L' || e.LINE || ':' || e.POSITION || ' ' || SUBSTR(e.TEXT, 1, 300));
        END LOOP;
        EXECUTE IMMEDIATE 'SELECT SRC FROM ZB_DMF0082_GMD_BAK WHERE OBJ_TYPE = ''PACKAGE BODY''' INTO bk;
        v_code := 0;
        BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || bk; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
        DBMS_OUTPUT.PUT_LINE('RESTORED — 백업 원문으로 복원 · ' || v_st || ' (SQLCODE ' || v_code || ')');
        RAISE_APPLICATION_ERROR(-20035, '교체 실패 · 원문 복원 ' || v_st || ' — 위 오류 회신');
    END IF;
END;
/
SELECT 'A1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT 'A2' CHK, TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' ORDER BY TYPE, SEQUENCE;

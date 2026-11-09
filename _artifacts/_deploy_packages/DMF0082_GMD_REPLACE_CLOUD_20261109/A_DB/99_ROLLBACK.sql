/* =====================================================================================================
 * DMF0082 GET_MAIN_DATA 교체 · 99_ROLLBACK — PKG_DMF0082 BODY 를 10 백업 원문으로 되돌림
 * 마커 [E20261104-DMF0082ONEQUERY] · 생성 2026-11-09 14:03:13 (사내 ZIOUI1) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 교체 = PKG_DMF0082 의 P_DMF0082_GET_MAIN_DATA 구간 ← PKG_DMF0082_1104 의 같은 구간 (이 DB 의 USER_SOURCE 끼리 · 나머지 프로시저 무변경)
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 반복 실행 안전: 이미 백업 원문과 같으면 SKIP. SPEC 은 이 패키지가 바꾸지 않으므로 BODY 만 되돌린다.
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- 리허설용(TRUE = 판정만)
    n  PLS_INTEGER;
    bk CLOB;
    v_code NUMBER;
    v_st   VARCHAR2(30);
    xn NUMBER; xl NUMBER; xh NUMBER;
    gn NUMBER; gl NUMBER; gh NUMBER;
    t1 PLS_INTEGER; t2 PLS_INTEGER;
    FUNCTION anc(p_name VARCHAR2, p_re VARCHAR2) RETURN PLS_INTEGER IS
        r PLS_INTEGER; k PLS_INTEGER;
    BEGIN
        SELECT MIN(LINE), COUNT(*) INTO r, k FROM USER_SOURCE WHERE NAME = p_name AND TYPE = 'PACKAGE BODY' AND REGEXP_LIKE(TEXT, p_re);
        IF k <> 1 THEN
            RAISE_APPLICATION_ERROR(-20031, '중단 — ' || p_name || ' 구간 경계 ' || k || '건(1건이어야 함) · 원문 무변경 · 회신: ' || p_re);
        END IF;
        RETURN r;
    END;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_GMD_BAK';
    IF n = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 백업표 ZB_DMF0082_GMD_BAK 없음 (교체 전이거나 98 로 정리됨)');
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'SELECT N, L, H FROM ZB_DMF0082_GMD_FP WHERE KIND = ''GMD_OLD''' INTO gn, gl, gh;
    t1 := anc('PKG_DMF0082', '^\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)'); t2 := anc('PKG_DMF0082', '^\s*PROCEDURE\s+P_DMF0082_POPUP_GET_FUTUREPRICE_INFO(\s|\(|$)');
    SELECT COUNT(*), NVL(SUM(LENGTH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0), NVL(SUM(ORA_HASH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0) INTO xn, xl, xh FROM USER_SOURCE
     WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND LINE >= t1 AND LINE < t2 AND RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)) IS NOT NULL;
    IF xn = gn AND xl = gl AND xh = gh THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — PKG_DMF0082 GET_MAIN_DATA 가 이미 백업 원문과 같음');
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'SELECT SRC FROM ZB_DMF0082_GMD_BAK WHERE OBJ_TYPE = ''PACKAGE BODY''' INTO bk;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('DRY     백업 BODY ' || DBMS_LOB.GETLENGTH(bk) || '자로 되돌릴 예정');
        RETURN;
    END IF;
    v_code := 0;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || bk; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20036, '중단 — 원복 생성 미실행 SQLCODE ' || v_code || ' · 실행 중 세션 확인 후 재실행');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY 백업 원문 · ' || v_st);
END;
/
SELECT 'R1' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY 1;
-- R2 GET_MAIN_DATA 구간이 백업 원문과 같은지 (백업표가 없으면 안내만 출력)
DECLARE
    n PLS_INTEGER;
    xn NUMBER; xl NUMBER; xh NUMBER; gn NUMBER; gl NUMBER; gh NUMBER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_GMD_FP';
    IF n = 0 THEN DBMS_OUTPUT.PUT_LINE('R2 백업표 없음 — 비교 생략'); RETURN; END IF;
    SELECT N, L, H INTO xn, xl, xh FROM (WITH R AS (SELECT (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '^\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)')) L1,
                  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '^\s*PROCEDURE\s+P_DMF0082_POPUP_GET_FUTUREPRICE_INFO(\s|\(|$)')) L2 FROM DUAL)
SELECT COUNT(*) N, NVL(SUM(LENGTH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0) L, NVL(SUM(ORA_HASH(RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)))), 0) H FROM USER_SOURCE S, R
 WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND S.LINE >= R.L1 AND S.LINE < R.L2 AND RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13)) IS NOT NULL);
    EXECUTE IMMEDIATE 'SELECT N, L, H FROM ZB_DMF0082_GMD_FP WHERE KIND = ''GMD_OLD''' INTO gn, gl, gh;
    DBMS_OUTPUT.PUT_LINE('R2 GET_MAIN_DATA 구간 ' || xn || '줄 · 백업 ' || gn || '줄 → '
        || CASE WHEN xn = gn AND xl = gl AND xh = gh THEN 'PASS — 백업 원문과 같음' ELSE '백업 원문과 다름(교체 상태)' END);
END;
/

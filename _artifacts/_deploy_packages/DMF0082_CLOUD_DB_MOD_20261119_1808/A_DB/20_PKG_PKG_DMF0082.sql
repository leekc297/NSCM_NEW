-- SOURCE-FRESH: SCM_MGR 화면 DMF0082 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-19 18:08:07
/* 20_PKG PKG_DMF0082 — 수정분만 적용(클라우드 원문이 사내와 다른 SPEC/BODY 만 CREATE OR REPLACE · 같으면 SKIP)
 * 패키지 DMF0082_CLOUD_DB_MOD_20261119_1808 · 생성 tools/CloudPkg/cloud_pkg.py 1.4.1 · 2026-11-19 18:08
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * 결과 = DBMS_OUTPUT(DBeaver Output 창) 의 SKIP(같음·미적용) / APPLY(교체) / ERROR 줄로 확인
 * 되돌리기 = 05_BACKUP 을 먼저 실행해 두면 99_ROLLBACK 이 이 객체를 실행 전 원문으로 복원
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

/* PACKAGE PKG_DMF0082 — 수정분만 패치 · 기준본 = 사내 적용 백업 _artifacts\_apply_corporate\DMF0082_GMD_REPLACE_20261109\00_BACKUP_PKG_DMF0082_SPEC_20261109.sql
 * 변경 1개 구간: 기준본 L80~86 → 사내 L80~85 (삭제 1줄 · 추가 0줄)
 * 가드: 이미 사내와 같으면 SKIP · 구간 기준 문구가 1건이 아니면 중단(원문 무변경) · 조립 결과 ≠ 사내 원문이면 중단 · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_cnt   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    FUNCTION hv(c CLOB) RETURN NUMBER IS
        n NUMBER := 0; p INTEGER := 1; i INTEGER := 0; l INTEGER := NVL(DBMS_LOB.GETLENGTH(c), 0);
    BEGIN
        WHILE p <= l LOOP
            i := i + 1;
            n := n + DBMS_UTILITY.GET_HASH_VALUE(i || '~' || DBMS_LOB.SUBSTR(c, 1000, p), 1, 1073741824);
            p := p + 1000;
        END LOOP;
        RETURN n;
    END;
    FUNCTION cnt(c CLOB, t CLOB) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; p PLS_INTEGER := 1;
    BEGIN
        LOOP
            p := DBMS_LOB.INSTR(c, t, p);
            EXIT WHEN NVL(p, 0) = 0;
            n := n + 1; p := p + DBMS_LOB.GETLENGTH(t);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE hunk(k PLS_INTEGER) IS
    BEGIN
        v_cnt := cnt(v_new, v_o);
        IF v_cnt <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 — PACKAGE PKG_DMF0082 변경 ' || k || ' 기준 문구 ' || v_cnt || '건(1 기대) · 클라우드 원문이 기준본과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, v_o);
        v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE PKG_DMF0082 없음 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF hv(v_src) = 3594957581 AND DBMS_LOB.GETLENGTH(v_src) = 7691 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE PKG_DMF0082 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L80~86 → 사내 L80~85 (삭제 1줄 · 추가 0줄)
    v_o := NULL;
    v_o := v_o || q'~);


    -- [2026.08.15 AJS 신뢰도검사 발견1] MSSQL DMF0082_POPUP_GET_SPREAD_TITLE_DATE 미이관분 이관
    PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_DATE
    (
        p_start_yyyymmdd  IN  VARCHAR2
~';
    v_n := NULL;
    v_n := v_n || q'~);


    PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_DATE
    (
        p_start_yyyymmdd  IN  VARCHAR2
~';
    hunk(1);
    IF hv(v_new) <> 3594957581 OR DBMS_LOB.GETLENGTH(v_new) <> 7691 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — PACKAGE PKG_DMF0082 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE PKG_DMF0082 — 패치 1개 구간 적용 가능(조립 결과 = 사내 원문)');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, 'PACKAGE PKG_DMF0082 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE PKG_DMF0082 — 패치 1개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

/* PACKAGE BODY PKG_DMF0082 — 수정분만 패치 · 기준본 = 사내 적용 백업 _artifacts\_apply_corporate\DMF0082_ROWGOAL_20261119\00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
 * 변경 7개 구간: 기준본 L24072~24077 → 사내 L24072~24078 (삭제 0줄 · 추가 1줄) / 기준본 L24887~24893 → 사내 L24888~24894 (삭제 1줄 · 추가 1줄) / 기준본 L24901~24907 → 사내 L24902~24908 (삭제 1줄 · 추가 1줄) / 기준본 L25703~25709 → 사내 L25704~25710 (삭제 1줄 · 추가 1줄) / 기준본 L25754~25760 → 사내 L25755~25761 (삭제 1줄 · 추가 1줄) / 기준본 L25775~25781 → 사내 L25776~25782 (삭제 1줄 · 추가 1줄) / 기준본 L25821~25827 → 사내 L25822~25828 (삭제 1줄 · 추가 1줄)
 * 가드: 이미 사내와 같으면 SKIP · 구간 기준 문구가 1건이 아니면 중단(원문 무변경) · 조립 결과 ≠ 사내 원문이면 중단 · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_cnt   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    FUNCTION hv(c CLOB) RETURN NUMBER IS
        n NUMBER := 0; p INTEGER := 1; i INTEGER := 0; l INTEGER := NVL(DBMS_LOB.GETLENGTH(c), 0);
    BEGIN
        WHILE p <= l LOOP
            i := i + 1;
            n := n + DBMS_UTILITY.GET_HASH_VALUE(i || '~' || DBMS_LOB.SUBSTR(c, 1000, p), 1, 1073741824);
            p := p + 1000;
        END LOOP;
        RETURN n;
    END;
    FUNCTION cnt(c CLOB, t CLOB) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; p PLS_INTEGER := 1;
    BEGIN
        LOOP
            p := DBMS_LOB.INSTR(c, t, p);
            EXIT WHEN NVL(p, 0) = 0;
            n := n + 1; p := p + DBMS_LOB.GETLENGTH(t);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE hunk(k PLS_INTEGER) IS
    BEGIN
        v_cnt := cnt(v_new, v_o);
        IF v_cnt <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 — PACKAGE BODY PKG_DMF0082 변경 ' || k || ' 기준 문구 ' || v_cnt || '건(1 기대) · 클라우드 원문이 기준본과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, v_o);
        v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY PKG_DMF0082 없음 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF hv(v_src) = 842252417451 AND DBMS_LOB.GETLENGTH(v_src) = 1575441 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE BODY PKG_DMF0082 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L24072~24077 → 사내 L24072~24078 (삭제 0줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~ * 2026.09.29	admin		[E20260929-DMF0082SAVEPERF] '^' 파싱 루프 선형화(위치 이동 f_next_token) + 행별 A00E 로그 → 요약 1행
 *                          (32,240행 파싱 GTT 벤치 189s → 8s, 적재 결과 동일).
 * 2026.11.03	POJ		Biz Type 미입력 저장 차단 문구 변경 : 'MDM에서 Biz Type을 입력하시기 바랍니다.' 한 줄로
 *============================================================================================================================*/
IS
    --=================================================================================================================================
~';
    v_n := NULL;
    v_n := v_n || q'~ * 2026.09.29	admin		[E20260929-DMF0082SAVEPERF] '^' 파싱 루프 선형화(위치 이동 f_next_token) + 행별 A00E 로그 → 요약 1행
 *                          (32,240행 파싱 GTT 벤치 189s → 8s, 적재 결과 동일).
 * 2026.11.03	POJ		Biz Type 미입력 저장 차단 문구 변경 : 'MDM에서 Biz Type을 입력하시기 바랍니다.' 한 줄로
 * 2026.11.19	admin		[E20261119-DMF0082ROWGOAL] 대량 저장 검증 3문장(#5 Site/Item, #18 판가 삭제 40·81) FETCH FIRST 1 → MIN() 집계 (1행 목표 계획이 행마다 전체 조인 반복 → 운영 45,495행 827초+)
 *============================================================================================================================*/
IS
    --=================================================================================================================================
~';
    hunk(1);
    -- 변경 2: 기준본 L24887~24893 → 사내 L24888~24894 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~    BEGIN
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE NOT EXISTS (
                SELECT ITEM.DIVISION_ID
~';
    v_n := NULL;
    v_n := v_n || q'~    BEGIN
        v_valid_item_id := NULL;
        BEGIN
            SELECT MIN(A.ITEM_ID) INTO v_valid_item_id  --[E20261119-DMF0082ROWGOAL] 종전 SELECT A.ITEM_ID ... FETCH FIRST 1 ROWS ONLY
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE NOT EXISTS (
                SELECT ITEM.DIVISION_ID
~';
    hunk(2);
    -- 변경 3: 기준본 L24901~24907 → 사내 L24902~24908 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                  AND SN.ACTIVE_FLAG   = 'Y'
                  AND ITEM.VALID_YN    = 'Y'
            )
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

~';
    v_n := NULL;
    v_n := v_n || q'~                  AND SN.ACTIVE_FLAG   = 'Y'
                  AND ITEM.VALID_YN    = 'Y'
            )
            ;  --[E20261119-DMF0082ROWGOAL] FETCH FIRST 1 ROWS ONLY 제거 (위반 0건이면 MIN = NULL = 종전 NO_DATA_FOUND 와 같은 결과)
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

~';
    hunk(3);
    -- 변경 4: 기준본 L25703~25709 → 사내 L25704~25710 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
~';
    v_n := NULL;
    v_n := v_n || q'~        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT MIN('● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID)  --[E20261119-DMF0082ROWGOAL]
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
~';
    hunk(4);
    -- 변경 5: 기준본 L25754~25760 → 사내 L25755~25761 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                           AND Z.YYYYMMDD          = F.YYYYMMDD
                           AND Z.CELL_PROD_SITE_ID = F.CELL_PROD_SITE_ID
                           AND NVL(Z.QTY_PRICE, 0) = 0)
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

~';
    v_n := NULL;
    v_n := v_n || q'~                           AND Z.YYYYMMDD          = F.YYYYMMDD
                           AND Z.CELL_PROD_SITE_ID = F.CELL_PROD_SITE_ID
                           AND NVL(Z.QTY_PRICE, 0) = 0)
                ;  --[E20261119-DMF0082ROWGOAL] FETCH FIRST 1 ROWS ONLY 제거
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

~';
    hunk(5);
    -- 변경 6: 기준본 L25775~25781 → 사내 L25776~25782 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
~';
    v_n := NULL;
    v_n := v_n || q'~        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT MIN('● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID)  --[E20261119-DMF0082ROWGOAL]
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
~';
    hunk(6);
    -- 변경 7: 기준본 L25821~25827 → 사내 L25822~25828 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                           AND Z.MEASURE           = F.MEASURE
                           AND Z.YYYYMMDD          = F.YYYYMMDD
                           AND NVL(Z.QTY_PRICE, 0) = 0)
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

~';
    v_n := NULL;
    v_n := v_n || q'~                           AND Z.MEASURE           = F.MEASURE
                           AND Z.YYYYMMDD          = F.YYYYMMDD
                           AND NVL(Z.QTY_PRICE, 0) = 0)
                ;  --[E20261119-DMF0082ROWGOAL] FETCH FIRST 1 ROWS ONLY 제거
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

~';
    hunk(7);
    IF hv(v_new) <> 842252417451 OR DBMS_LOB.GETLENGTH(v_new) <> 1575441 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — PACKAGE BODY PKG_DMF0082 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE BODY PKG_DMF0082 — 패치 7개 구간 적용 가능(조립 결과 = 사내 원문)');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, 'PACKAGE BODY PKG_DMF0082 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE BODY PKG_DMF0082 — 패치 7개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

/* 확인 — VALID, 오류 0 */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' ORDER BY TYPE, SEQUENCE;

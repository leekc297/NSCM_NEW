-- SOURCE-FRESH: SCM_MGR 화면 DMF0045 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-25 14:28:56
/* 20_PKG PKG_DMF0045 — 수정분만 적용(클라우드 원문이 사내와 다른 SPEC/BODY 만 CREATE OR REPLACE · 같으면 SKIP)
 * 패키지 DMF0045_CLOUD_DB_MOD_20261125_1429 · 생성 tools/CloudPkg/cloud_pkg.py 1.4.1 · 2026-11-25 14:28
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * 결과 = DBMS_OUTPUT(DBeaver Output 창) 의 SKIP(같음·미적용) / APPLY(교체) / ERROR 줄로 확인
 * 되돌리기 = 05_BACKUP 을 먼저 실행해 두면 99_ROLLBACK 이 이 객체를 실행 전 원문으로 복원
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

/* PACKAGE PKG_DMF0045 — 변경 없음(기준본 = LAST_DDL 2026-11-17 17:17:12 < 기준 시각 2026-11-25 00:00:00 — 이번 수정분 아님) · 적용하지 않고 클라우드 원문이 사내와 같은지만 확인 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_src   CLOB;
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
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));
    IF hv(v_src) = 2592986663 AND NVL(DBMS_LOB.GETLENGTH(v_src), 0) = 2605 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE PKG_DMF0045 — 변경 없음 · 클라우드 원문 = 사내');
    ELSE
        DBMS_OUTPUT.PUT_LINE('> WARN  PACKAGE PKG_DMF0045 — 변경 없음이지만 클라우드 원문이 사내와 다름(적용 안 함 · 필요하면 전체 메뉴 패키지)');
    END IF;
END;
/

/* PACKAGE BODY PKG_DMF0045 — 수정분만 패치 · 기준본 = 사내 적용 백업 _artifacts\_apply_corporate\DMF0045_BOH_PERF_20261125\PKG_DMF0045_BODY.ASIS.sql
 * 변경 1개 구간: 기준본 L1318~1340 → 사내 L1318~1341 (삭제 15줄 · 추가 16줄)
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
            RAISE_APPLICATION_ERROR(-20011, '중단 — PACKAGE BODY PKG_DMF0045 변경 ' || k || ' 기준 문구 ' || v_cnt || '건(1 기대) · 클라우드 원문이 기준본과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, v_o);
        v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY PKG_DMF0045 없음 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF hv(v_src) = 63266168087 AND DBMS_LOB.GETLENGTH(v_src) = 123392 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE BODY PKG_DMF0045 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L1318~1340 → 사내 L1318~1341 (삭제 15줄 · 추가 16줄)
    v_o := NULL;
    v_o := v_o || q'~                 , A.SCM_SITE_ID                                            AS FROM_SITE
                 , V_FROM_YYYYMMDD                                          AS YYYYMMDD
                 , A.SSP_QTY                                                AS QTY      /* SSP용 */
              FROM SSP_DNM_ESS_PACKER_STOCK_V A
                 , SCM_MST_SITE B
                 , SCP_MST_FINAL_ITEM C
                 , (SELECT DIVISION_ID
                         , SITE_ID
                         , MAX(CUTOFF_DATE)                                 AS MAX_CUTOFF_DATE
                      FROM SSP_DNM_ESS_PACKER_STOCK_V
                     WHERE DIVISION_ID  = V_DIVISION_ID
                       AND CUTOFF_DATE  > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')     /* 현재일 - 3 */
                       AND CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')      /* 변수 : 현재일 */
                     GROUP BY DIVISION_ID
                            , SITE_ID
                   ) XA
             WHERE A.DIVISION_ID      = XA.DIVISION_ID
               AND A.SITE_ID          = XA.SITE_ID
               AND A.CUTOFF_DATE      = XA.MAX_CUTOFF_DATE
               AND A.CUTOFF_DATE      > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')
               AND A.DIVISION_ID      = B.DIVISION_ID
               AND A.SCM_SITE_ID      = B.SCM_SITE_ID
               AND B.DIVISION_ID      = V_DIVISION_ID
~';
    v_n := NULL;
    v_n := v_n || q'~                 , A.SCM_SITE_ID                                            AS FROM_SITE
                 , V_FROM_YYYYMMDD                                          AS YYYYMMDD
                 , A.SSP_QTY                                                AS QTY      /* SSP용 */
              /* [E20261125-BOHONCE] 재고 뷰를 1번만 읽고 사이트별 최근 재고 일자는 같은 읽기에서 구함 */
              /* (종전 : 같은 뷰를 2번 읽어 클라우드 1회 960초)                                         */
              FROM (SELECT V.DIVISION_ID
                         , V.SITE_ID
                         , V.SCM_SITE_ID
                         , V.ITEM_ID
                         , V.SSP_QTY
                         , V.CUTOFF_DATE
                         , MAX(V.CUTOFF_DATE) OVER (PARTITION BY V.DIVISION_ID, V.SITE_ID) AS MAX_CUTOFF_DATE
                      FROM SSP_DNM_ESS_PACKER_STOCK_V V
                     WHERE V.DIVISION_ID  = V_DIVISION_ID
                       AND V.CUTOFF_DATE  > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')     /* 현재일 - 3 */
                       AND V.CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')      /* 변수 : 현재일 */
                       AND V_DIVISION_ID  = '82'
                   ) A
                 , SCM_MST_SITE B
                 , SCP_MST_FINAL_ITEM C
             WHERE A.CUTOFF_DATE      = A.MAX_CUTOFF_DATE
               AND A.DIVISION_ID      = B.DIVISION_ID
               AND A.SCM_SITE_ID      = B.SCM_SITE_ID
               AND B.DIVISION_ID      = V_DIVISION_ID
~';
    hunk(1);
    IF hv(v_new) <> 63266168087 OR DBMS_LOB.GETLENGTH(v_new) <> 123392 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — PACKAGE BODY PKG_DMF0045 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE BODY PKG_DMF0045 — 패치 1개 구간 적용 가능(조립 결과 = 사내 원문)');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0045' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, 'PACKAGE BODY PKG_DMF0045 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE BODY PKG_DMF0045 — 패치 1개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

/* 확인 — VALID, 오류 0 */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0045' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045' ORDER BY TYPE, SEQUENCE;

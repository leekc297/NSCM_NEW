-- SOURCE-FRESH: SCM_MGR 화면 DMF0082 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-26 13:32:31
/* 20_PKG PKG_DMF0082 — 수정분만 적용(클라우드 원문이 사내와 다른 SPEC/BODY 만 CREATE OR REPLACE · 같으면 SKIP)
 * 패키지 DMF0082_CLOUD_DB_MOD_20261126_1333 · 생성 tools/CloudPkg/cloud_pkg.py 1.4.1 · 2026-11-26 13:32
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

/* PACKAGE BODY PKG_DMF0082 — 수정분만 패치 · 기준본 = 사내 적용 백업 _artifacts\_apply_corporate\DMF0082_MONTH_EDIT_DIV_20261124\04_BACKUP_PKG_DMF0082_BODY_TEMP.ASIS.sql
 * 변경 3개 구간: 기준본 L16160~16169 → 사내 L16160~16176 (삭제 1줄 · 추가 8줄) / 기준본 L16205~16211 → 사내 L16212~16219 (삭제 1줄 · 추가 2줄) / 기준본 L16254~16263 → 사내 L16262~16270 (삭제 4줄 · 추가 3줄)
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
    IF hv(v_src) = 851358718572 AND DBMS_LOB.GETLENGTH(v_src) = 1579984 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE BODY PKG_DMF0082 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L16160~16169 → 사내 L16160~16176 (삭제 1줄 · 추가 8줄)
    v_o := NULL;
    v_o := v_o || q'~                    v_ksel := v_ksel || ', MAX(X.CREATE_DATE) AS CREATE_DATE';
                END IF;
            END IF;
            V_Q := V_Q || CHR(10) || ', KEYS AS (SELECT ROWNUM AS KID_, K.* FROM (SELECT ' || v_ksel
                || ' FROM SRCA X WHERE ' || V_QF || ' GROUP BY ' || REPLACE(v_jk, ',', ', ') || ') K)'
                || CHR(10) || ', DISPK AS (SELECT K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ', SUM(X.QTY) AS QTY, COUNT(*) AS CNT_'
                || ' FROM SRCA X JOIN KEYS K ON ' || V_KJOIN || ' WHERE ' || V_QF
                || ' GROUP BY K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ')';
        END;

~';
    v_n := NULL;
    v_n := v_n || q'~                    v_ksel := v_ksel || ', MAX(X.CREATE_DATE) AS CREATE_DATE';
                END IF;
            END IF;
            -- [E20261126-DMF0082PRICEAVGQTY] 단가(KRW·USD·LOC) 월 SUM 칸 평균 = 같은 품목 키(10키)에 수량 메저가 있는 주(YYYYMMWW)의 단가만 (사용자 요청 2026-11-26 13:22)
            --   QW_ = 수량 메저(MKT_FCST,MKT_FCST_PP,MKT_FCST_RP_CAR,MKT_FCST_RP_CELL,SCM_FCST,RTF_SYS_RP,RTF_SYS_RP_CAR,RTF_SYS_RP_CELL,RTF_SCP,TMM_FCST) QTY<>0 인 10키×주 목록. DISPK 단가 행에 QTYQ_(그 주 단가 합)·CNTQ_(그 주 단가 건수)를 싣는다.
            --   종전 DISPK = SUM(X.QTY) AS QTY, COUNT(*) AS CNT_ 만 (D_·W_ 칸과 수량 메저 칸은 종전 값 그대로)
            V_Q := V_Q || CHR(10) || ', KEYS AS (SELECT ROWNUM AS KID_, K.* FROM (SELECT ' || v_ksel
                || ' FROM SRCA X WHERE ' || V_QF || ' GROUP BY ' || REPLACE(v_jk, ',', ', ') || ') K)'
                || CHR(10) || ', QW_ AS (SELECT ' || V_K10A || ', X.YYYYMMWW FROM SRCA X WHERE X.MEASURE IN (''MKT_FCST'',''MKT_FCST_PP'',''MKT_FCST_RP_CAR'',''MKT_FCST_RP_CELL'',''SCM_FCST'',''RTF_SYS_RP'',''RTF_SYS_RP_CAR'',''RTF_SYS_RP_CELL'',''RTF_SCP'',''TMM_FCST'') AND X.QTY <> 0 GROUP BY ' || V_K10 || ', X.YYYYMMWW)'
                || CHR(10) || ', DISPK AS (SELECT K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ', SUM(X.QTY) AS QTY, COUNT(*) AS CNT_'
                || ', SUM(CASE WHEN R.YYYYMMWW IS NOT NULL THEN X.QTY END) AS QTYQ_, COUNT(R.YYYYMMWW) AS CNTQ_'
                || ' FROM SRCA X JOIN KEYS K ON ' || V_KJOIN
                || ' LEFT JOIN QW_ R ON X.MEASURE IN (''KRW'',''USD'',''LOC'') AND R.YYYYMMWW = X.YYYYMMWW AND ' || V_K10J
                || ' WHERE ' || V_QF
                || ' GROUP BY K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ')';
        END;

~';
    hunk(1);
    -- 변경 2: 기준본 L16205~16211 → 사내 L16212~16219 (삭제 1줄 · 추가 2줄)
    v_o := NULL;
    v_o := v_o || q'~
        UNION ALL

        SELECT KID_, 'M_' || YYYYMM AS PIVOT_BUCKET, SUM(QTY) / SUM(CNT_) AS QTY
        FROM DISPK
        WHERE MEASURE IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMM
~';
    v_n := NULL;
    v_n := v_n || q'~
        UNION ALL

        SELECT KID_, 'M_' || YYYYMM AS PIVOT_BUCKET
             , CASE WHEN SUM(CNTQ_) > 0 THEN SUM(QTYQ_) / SUM(CNTQ_) ELSE SUM(QTY) / SUM(CNT_) END AS QTY  /* [E20261126-DMF0082PRICEAVGQTY] 수량 있는 주 단가 평균 · 그 달 수량 없으면 종전 전 일자 평균 (종전 = SUM(QTY) / SUM(CNT_)) */
        FROM DISPK
        WHERE MEASURE IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMM
~';
    hunk(2);
    -- 변경 3: 기준본 L16254~16263 → 사내 L16262~16270 (삭제 4줄 · 추가 3줄)
    v_o := NULL;
    v_o := v_o || q'~                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */
--           , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
             , CASE WHEN p_division_id LIKE '81%'                                    -- 2026.11.24 [E20261124-DMF0082DIVCUTOFF] 81, 81 JV(81_HD, 81_HG, 81_HM, 81_ST, 81_UC) = 당월부터 입력 (START)
                    THEN TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD')                    /* [E20261124-DMF0082DIVCUTOFF-TEMP] 임시 조치: 경계 = 당월 → Monthly 익월부터 입력 (사용자 지시 2026-11-24, UI 버그 수정 전까지) */
                    -- [E20261124-DMF0082DIVCUTOFF-TEMP] 표준 = 81 계열 당월부터 입력. UI 버그 수정 뒤 표준으로 되돌림. 복원 방법 = 바로 위 THEN 줄을 아래 줄로 교체
                    --        THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* 경계 = 지난달 → Monthly 당월부터 입력 */
                    --   표준판 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/01_PKG_DMF0082_BODY_DIV_CUTOFF.sql (LAST_DDL 2026-11-24 11:36:44)
                    -- [E20261124-DMF0082DIVCUTOFF] 사용자 요청 2026-11-24: 40 = 당월 + 3개월까지 잠금, 81 계열 = 당월부터 입력. 82 는 요청 범위 밖이라 종전(+3개월) 유지
                    --   근거 = AS-IS 81 사업부 입력 화면 DMF0003 Monthly 는 당주 월요일이 속한 월부터 편집, +3개월 규정 없음 (DMF0003_MktFcst.cs:2957~2971)
                    --   종전(LAST_DDL 2026-11-24 10:25:27 판) = CASE WHEN p_division_id = '81_UC' (81_UC 만 당월부터). 원문 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
~';
    v_n := NULL;
    v_n := v_n || q'~                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */
--           , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
             , CASE WHEN p_division_id LIKE '81%'                                    -- 2026.11.24 [E20261124-DMF0082DIVCUTOFF] 81, 81 JV(81_HD, 81_HG, 81_HM, 81_ST, 81_UC) = 당월부터 입력 (START)
                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [E20261124-DMF0082DIVCUTOFF-CURMON] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 지시 2026-11-24 13:35) */
                    -- [E20261124-DMF0082DIVCUTOFF-CURMON] 종전(LAST_DDL 2026-11-24 11:40:00, 임시 조치) = THEN TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD') (경계 = 당월 → 익월부터 입력)
                    --   임시판 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/04_BACKUP_PKG_DMF0082_BODY_TEMP.ASIS.sql
                    -- [E20261124-DMF0082DIVCUTOFF] 사용자 요청 2026-11-24: 40 = 당월 + 3개월까지 잠금, 81 계열 = 당월부터 입력. 82 는 요청 범위 밖이라 종전(+3개월) 유지
                    --   근거 = AS-IS 81 사업부 입력 화면 DMF0003 Monthly 는 당주 월요일이 속한 월부터 편집, +3개월 규정 없음 (DMF0003_MktFcst.cs:2957~2971)
                    --   종전(LAST_DDL 2026-11-24 10:25:27 판) = CASE WHEN p_division_id = '81_UC' (81_UC 만 당월부터). 원문 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
~';
    hunk(3);
    IF hv(v_new) <> 851358718572 OR DBMS_LOB.GETLENGTH(v_new) <> 1579984 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — PACKAGE BODY PKG_DMF0082 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE BODY PKG_DMF0082 — 패치 3개 구간 적용 가능(조립 결과 = 사내 원문)');
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
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE BODY PKG_DMF0082 — 패치 3개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

/* 확인 — VALID, 오류 0 */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' ORDER BY TYPE, SEQUENCE;

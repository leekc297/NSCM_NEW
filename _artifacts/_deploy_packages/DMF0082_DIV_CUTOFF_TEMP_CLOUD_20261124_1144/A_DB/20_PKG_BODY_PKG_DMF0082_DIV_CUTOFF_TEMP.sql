-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-11-24 11:40:00 FETCHED=2026-11-24 11:44 DB=ZIOUI1
/* 20_PKG PKG_DMF0082 PACKAGE BODY — Monthly 입력 경계월 사업부별 분리 (E20261124-DMF0082DIVCUTOFF-TEMP)
 * 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC = 당월(임시 조치: 익월부터 입력, UI 버그 수정 뒤 당월부터로 정정 예정) · 40, 82 = 오늘 월 + 3개월(종전)
 * 범위 = P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE 구간 1곳. 그 외 원문 무변경
 * 클라우드 원문 A(M+3 한 줄) · B(POJ 판, 81_UC NULL) · C(81_UC 지난달) · D(81 계열 지난달) 중 하나를 찾아 치환 · 넷 다 아니면 중단(원문 무변경) · 이미 있으면 SKIP
 * DMF0082_UC_CUTOFF_CLOUD_20261124_1037, DMF0082_DIV_CUTOFF_CLOUD_20261124_1139 는 이 패키지로 대체함(먼저 실행할 필요 없음)
 * 컴파일 오류면 원문 자동 복원 · 실행 계정 SCM_MGR · 전체 F5 · 반복 실행 안전
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- TRUE = 조립·검사만(원문 무변경)
    v_raw   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_case  VARCHAR2(10);
    v_pos   PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
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
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY PKG_DMF0082 없음. 원문 무변경');
    END IF;
    v_new := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF cnt(v_new, 'E20261124-DMF0082DIVCUTOFF-TEMP') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE BODY PKG_DMF0082 — 사업부별 경계월 변경 이미 있음 · 원문 무변경');
        RETURN;
    END IF;
    v_n := q'[                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */
--           , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
             , CASE WHEN p_division_id LIKE '81%'                                    -- 2026.11.24 [E20261124-DMF0082DIVCUTOFF] 81, 81 JV(81_HD, 81_HG, 81_HM, 81_ST, 81_UC) = 당월부터 입력 (START)
                    THEN TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD')                    /* [E20261124-DMF0082DIVCUTOFF-TEMP] 임시 조치: 경계 = 당월 → Monthly 익월부터 입력 (사용자 지시 2026-11-24, UI 버그 수정 전까지) */
                    -- [E20261124-DMF0082DIVCUTOFF-TEMP] 표준 = 81 계열 당월부터 입력. UI 버그 수정 뒤 표준으로 되돌림. 복원 방법 = 바로 위 THEN 줄을 아래 줄로 교체
                    --        THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* 경계 = 지난달 → Monthly 당월부터 입력 */
                    --   표준판 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/01_PKG_DMF0082_BODY_DIV_CUTOFF.sql (LAST_DDL 2026-11-24 11:36:44)
                    -- [E20261124-DMF0082DIVCUTOFF] 사용자 요청 2026-11-24: 40 = 당월 + 3개월까지 잠금, 81 계열 = 당월부터 입력. 82 는 요청 범위 밖이라 종전(+3개월) 유지
                    --   근거 = AS-IS 81 사업부 입력 화면 DMF0003 Monthly 는 당주 월요일이 속한 월부터 편집, +3개월 규정 없음 (DMF0003_MktFcst.cs:2957~2971)
                    --   종전(LAST_DDL 2026-11-24 10:25:27 판) = CASE WHEN p_division_id = '81_UC' (81_UC 만 당월부터). 원문 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
                    --   POJ 판(81_UC = 경계 미전달) 백업 = _artifacts/_apply_corporate/DMF0082_UC_CUTOFF_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
                    ELSE TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD')
               END AS M3_CUTOFF_DATE                                                 -- 2026.11.24 POJ (END)
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
]';
    v_o := q'[                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */
             , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
]';
    IF cnt(v_new, v_o) = 1 THEN
        v_case := 'A(M+3)';
    ELSE
        v_o := q'[                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */
--           , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
             , CASE WHEN p_division_id = '81_UC'                                     -- 2026.11.24 POJ 사업부 81_UC 는 M+4 입력 제한 해제 (START)
                    THEN CAST(NULL AS VARCHAR2(8))   /* 경계 미전달 = 월 단위 입력 제한 없음 */
                    ELSE TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD')
               END AS M3_CUTOFF_DATE                                                 -- 2026.11.24 POJ (END)
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
]';
        IF cnt(v_new, v_o) = 1 THEN
            v_case := 'B(POJ)';
        ELSE
            v_o := q'[                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */
--           , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
             , CASE WHEN p_division_id = '81_UC'                                     -- 2026.11.24 POJ 사업부 81_UC 는 M+4 입력 제한 해제 (START)
                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [E20261124-DMF0082UCCUTOFF] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 요청 2026-11-24) */
                    -- [E20261124-DMF0082UCCUTOFF-RESTORE] 임시 작업(2026-11-24). 복원 방법:
                    --   ① POJ 판(2026-11-24 10:14:35)으로 되돌림 = 바로 위 THEN 줄을 아래 줄로 교체
                    --        THEN CAST(NULL AS VARCHAR2(8))   /* 경계 미전달 = 월 단위 입력 제한 없음 */
                    --   ② 전 사업부 M+3 경계로 되돌림 = CASE WHEN p_division_id = '81_UC' 줄부터 END AS M3_CUTOFF_DATE 줄까지 지우고 위 '--' 로 막힌 TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), ...) 줄 주석을 푼다
                    --   원문 백업 = _artifacts/_apply_corporate/DMF0082_UC_CUTOFF_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql (POJ 판)
                    ELSE TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD')
               END AS M3_CUTOFF_DATE                                                 -- 2026.11.24 POJ (END)
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
]';
            IF cnt(v_new, v_o) = 1 THEN
                v_case := 'C(81_UC)';
            ELSE
                v_o := q'[                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */
--           , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
             , CASE WHEN p_division_id LIKE '81%'                                    -- 2026.11.24 [E20261124-DMF0082DIVCUTOFF] 81, 81 JV(81_HD, 81_HG, 81_HM, 81_ST, 81_UC) = 당월부터 입력 (START)
                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [E20261124-DMF0082UCCUTOFF] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 요청 2026-11-24) */
                    -- [E20261124-DMF0082DIVCUTOFF] 사용자 요청 2026-11-24: 40 = 당월 + 3개월까지 잠금, 81 계열 = 당월부터 입력. 82 는 요청 범위 밖이라 종전(+3개월) 유지
                    --   근거 = AS-IS 81 사업부 입력 화면 DMF0003 Monthly 는 당주 월요일이 속한 월부터 편집, +3개월 규정 없음 (DMF0003_MktFcst.cs:2957~2971)
                    --   종전(LAST_DDL 2026-11-24 10:25:27 판) = CASE WHEN p_division_id = '81_UC' (81_UC 만 당월부터). 원문 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
                    --   POJ 판(81_UC = 경계 미전달) 백업 = _artifacts/_apply_corporate/DMF0082_UC_CUTOFF_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
                    ELSE TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD')
               END AS M3_CUTOFF_DATE                                                 -- 2026.11.24 POJ (END)
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
]';
                IF cnt(v_new, v_o) = 1 THEN
                    v_case := 'D(81ALL)';
                ELSE
                    RAISE_APPLICATION_ERROR(-20011, '중단 — M3_CUTOFF_DATE 구간이 예상 원문(A: M+3 한 줄 / B: POJ 판 / C: 81_UC 지난달 / D: 81 계열 지난달)과 다름. 원문 무변경 · 구간 원문을 전달 바람');
                END IF;
            END IF;
        END IF;
    END IF;
    v_pos := DBMS_LOB.INSTR(v_new, v_o);
    v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    IF cnt(v_new, 'E20261124-DMF0082DIVCUTOFF-TEMP') <> 2 OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(REPLACE(v_raw, CHR(13) || CHR(10), CHR(10))) - DBMS_LOB.GETLENGTH(v_o) + DBMS_LOB.GETLENGTH(v_n) THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — 조립 결과 검사 실패. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE BODY PKG_DMF0082 — 기준 ' || v_case || ' · 패치 1개 구간 적용 가능');
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
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE BODY PKG_DMF0082 — 기준 ' || v_case || ' · 81 계열 경계월 = 당월(임시, 익월부터 입력), 40·82 = +3개월 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' ORDER BY TYPE, SEQUENCE;

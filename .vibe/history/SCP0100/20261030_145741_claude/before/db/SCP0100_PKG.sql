-- PKG_SCP0100 — 생성: tools/Harness/gen-pkg.js 2026-10-20 · 화면 SCP0100→SCP0100 Global_PSI_Report · As-is SP 3개
-- 이식 규칙: Doc/_dev_rules(DB 변환 규칙) · To-be_v2_converted/06_Packages 선례 · ISNULL→NVL, GETDATE→SYSDATE, TOP n→FETCH FIRST n ROWS ONLY, +(문자열)→||, CONVERT→TO_CHAR/TO_DATE, 임시테이블→GTT/WITH, @@ROWCOUNT→SQL%ROWCOUNT · ⭐ 널 센티널 = '/' (ISNULL(x,'')→NVL(x,'/') · 원래 '-' 데이터 유지 · 과도기 빈값 IN ('-','/') — 사용자 2026-10-15, check-pkg P39/P40, port_pkg.md §센티널)
-- 배포 후: SCP0100_registration.sql 재실행(PROC_M 이 ALL_ARGUMENTS 로 확정) → FE pnpm gen:procedures
-- ⚠️ 배포 금지(단독 CREATE OR REPLACE): 사내 ZIOUI1 PKG_SCP0100 현행본(SPEC 2026-10-09 13:38:32 · BODY 2026-10-16 09:42:30 VALID)에는
--    P_SCP0100_GET_GLOBAL_PSI_REPORT / _WW_DATAONLY / _MM_DATAONLY + 내부 PR_SET_FINAL_COLS 가 있다. 이 파일은 As-is SP 3개 이식본이라
--    그대로 실행하면 위 프로시저가 사라진다. 반영은 사내 현행본 위에 프로시저 단위로 병합할 것(SCP0100_PKG_NOTES.md §배포).
-- O_RC 수: As-is 는 IF 갈래마다 SELECT 1개만 반환 → 프로시저당 O_RC1 1개(사내 현행 시그니처 · PROC_M 5+4+5 행과 동일)
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCP0100
AS
    PROCEDURE P_SCP0100_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_SITE (
        P_SITE_TPYE      IN  VARCHAR2,  -- As-is @p_site_tpye nvarchar(-1)
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_PLAN_DATE (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        P_PROGRAM_ID     IN  VARCHAR2,  -- As-is @p_program_id nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
END PKG_SCP0100;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0100
AS
/*
 * Program ID   : P_SCP0100_GET_SHEET_CALENDAR_3SPAN
 * Description  : SCP0100 Global_PSI_Report — As-is SCP0100_GET_SHEET_CALENDAR_3SPAN 이식 (GET, 시트 'calendar' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.20   harness        [TobeGen] 골격 생성
 * 2026.10.20   harness        As-is 본문 이식 — 주석 구간(DEFAULT·1차·2차·3차 적용)은 미이식, 실행 문장(주 W_ + 월 M_ UNION ALL)만
 */
PROCEDURE P_SCP0100_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사 없음: As-is 는 기간 파라미터가 비어도 오류 없이 0행을 반환한다

    -- As-is: 주 = SUBSTRING(ISO_YYYYWW,1,4)+SUBSTRING(PARTIAL_WEEK_NAME,2,3) 그룹 / 월 = BASIS_YYYYMM 그룹, ORDER BY sort_order_no
    --        MAX(SUBSTRING(PARTIAL_WEEK_NAME,4,1)) != '' → Oracle SUBSTR 은 범위 밖이면 NULL 이므로 IS NOT NULL 로 동치
    OPEN O_RC1 FOR
        SELECT COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SMALL_CLASS_LABEL_NAME
             , LARGE_CLASS_LABEL_NAME
             , DAY_CODE
             , SORT_ORDER_NO
          FROM ( SELECT 'W_' || WW.WEEK_KEY                                              AS COLUMN_NAME
                      , WW.WEEK_KEY                                                      AS COLUMN_LABEL_NAME
                      , CASE WHEN MAX(SUBSTR(WW.PARTIAL_WEEK_NAME, 4, 1)) IS NOT NULL
                             THEN MAX(SUBSTR(WW.PARTIAL_WEEK_NAME, 1, 3) || '_' || SUBSTR(WW.PARTIAL_WEEK_NAME, 4, 1))
                             ELSE MAX(WW.PARTIAL_WEEK_NAME)
                        END                                                              AS SMALL_CLASS_LABEL_NAME
                      , MAX(WW.MONTH_NAME)                                               AS LARGE_CLASS_LABEL_NAME
                      , MIN(WW.BASIS_START_DATE)                                         AS DAY_CODE
                      , MIN(WW.BASIS_START_DATE) || '21'                                 AS SORT_ORDER_NO
                   FROM ( SELECT SUBSTR(A.ISO_YYYYWW, 1, 4) || SUBSTR(A.PARTIAL_WEEK_NAME, 2, 3) AS WEEK_KEY
                               , A.PARTIAL_WEEK_NAME
                               , A.MONTH_NAME
                               , A.BASIS_START_DATE
                            FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                             AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                        ) WW
                  GROUP BY WW.WEEK_KEY
                 UNION ALL
                 SELECT 'M_' || A.BASIS_YYYYMM                                           AS COLUMN_NAME
                      , A.MONTH_NAME                                                     AS COLUMN_LABEL_NAME
                      , A.MONTH_NAME                                                     AS SMALL_CLASS_LABEL_NAME
                      , A.MONTH_NAME                                                     AS LARGE_CLASS_LABEL_NAME
                      , MIN(A.BASIS_START_DATE)                                          AS DAY_CODE
                      , MIN(A.BASIS_START_DATE) || '02'                                  AS SORT_ORDER_NO
                   FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                  WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                    AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                  GROUP BY A.BASIS_YYYYMM
                         , A.MONTH_NAME
               ) T
         ORDER BY SORT_ORDER_NO;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0100_GET_SHEET_CALENDAR_3SPAN] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_START_YYYYMMDD='||P_START_YYYYMMDD||','||'P_END_YYYYMMDD='||P_END_YYYYMMDD);
END P_SCP0100_GET_SHEET_CALENDAR_3SPAN;

/*
 * Program ID   : P_SCP0100_GET_SITE
 * Description  : SCP0100 Global_PSI_Report — As-is SCP0100_GET_SITE 이식 (GET, 시트 'REPORT' / 버튼 SITE)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.20   harness        [TobeGen] 골격 생성
 * 2026.10.20   harness        As-is 본문 이식 — SITE_TYPE(FROM_SITE/TO_SITE) × BUCKET(MONTHLY/WEEKLY) 4갈래, O_RC1 1개
 */
PROCEDURE P_SCP0100_GET_SITE (
        P_SITE_TPYE      IN  VARCHAR2,  -- As-is @p_site_tpye nvarchar(-1)
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사 없음: As-is 는 갈래에 안 맞는 값(NULL 포함)이면 오류 없이 결과 없음

    -- As-is 비교는 CI 콜레이션 → UPPER 비교 · (@p_division_id IS NULL OR = '') → TRIM(x) IS NULL (MSSQL '' 비교는 후행 공백 무시)
    -- ORDER BY 는 As-is CI 콜레이션 정렬 대응 — 사내 현행 정렬식(UPPER(TRANSLATE(x,'_-','/')), x · NULL 선두) 계승
    IF UPPER(P_SITE_TPYE) = 'FROM_SITE' AND UPPER(P_BUCKET) = 'MONTHLY' THEN
        OPEN O_RC1 FOR
            SELECT A.FROM_SITE AS CODE
                 , A.FROM_SITE AS NAME
              FROM SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_MM A
             WHERE 1 = 1
               AND ( TRIM(P_DIVISION_ID) IS NULL
                     OR A.DIVISION_ID IN ( SELECT S.VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_DIVISION_ID, ',')) S ) )   -- 고도화
               AND A.DIVISION_ID LIKE '81%'                                                                              -- 고도화
             GROUP BY A.FROM_SITE
             ORDER BY UPPER(TRANSLATE(A.FROM_SITE, '_-', '/')) NULLS FIRST, A.FROM_SITE NULLS FIRST;
    ELSIF UPPER(P_SITE_TPYE) = 'FROM_SITE' AND UPPER(P_BUCKET) = 'WEEKLY' THEN
        OPEN O_RC1 FOR
            SELECT A.FROM_SITE AS CODE
                 , A.FROM_SITE AS NAME
              FROM SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_WW A
             WHERE 1 = 1
               AND ( TRIM(P_DIVISION_ID) IS NULL
                     OR A.DIVISION_ID IN ( SELECT S.VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_DIVISION_ID, ',')) S ) )   -- 고도화
               AND A.DIVISION_ID LIKE '81%'                                                                              -- 고도화
             GROUP BY A.FROM_SITE
             ORDER BY UPPER(TRANSLATE(A.FROM_SITE, '_-', '/')) NULLS FIRST, A.FROM_SITE NULLS FIRST;
    ELSIF UPPER(P_SITE_TPYE) = 'TO_SITE' AND UPPER(P_BUCKET) = 'MONTHLY' THEN
        OPEN O_RC1 FOR
            SELECT A.TO_SITE AS CODE
                 , A.TO_SITE AS NAME
              FROM SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_MM A
             WHERE 1 = 1
               AND ( TRIM(P_DIVISION_ID) IS NULL
                     OR A.DIVISION_ID IN ( SELECT S.VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_DIVISION_ID, ',')) S ) )   -- 고도화
               AND A.DIVISION_ID LIKE '81%'                                                                              -- 고도화
             GROUP BY A.TO_SITE
             ORDER BY UPPER(TRANSLATE(A.TO_SITE, '_-', '/')) NULLS FIRST, A.TO_SITE NULLS FIRST;
    ELSIF UPPER(P_SITE_TPYE) = 'TO_SITE' AND UPPER(P_BUCKET) = 'WEEKLY' THEN
        OPEN O_RC1 FOR
            SELECT A.TO_SITE AS CODE
                 , A.TO_SITE AS NAME
              FROM SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_WW A
             WHERE 1 = 1
               AND ( TRIM(P_DIVISION_ID) IS NULL
                     OR A.DIVISION_ID IN ( SELECT S.VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_DIVISION_ID, ',')) S ) )   -- 고도화
               AND A.DIVISION_ID LIKE '81%'                                                                              -- 고도화
             GROUP BY A.TO_SITE
             ORDER BY UPPER(TRANSLATE(A.TO_SITE, '_-', '/')) NULLS FIRST, A.TO_SITE NULLS FIRST;
    ELSE
        -- As-is 는 결과셋 없음 — 미개설 커서를 BE 가 읽으면 ORA-01001 이므로 같은 컬럼의 0행 커서로 닫는다(NOTES §차이)
        OPEN O_RC1 FOR
            SELECT CAST(NULL AS VARCHAR2(30)) AS CODE
                 , CAST(NULL AS VARCHAR2(30)) AS NAME
              FROM DUAL
             WHERE 1 = 2;
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0100_GET_SITE] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_SITE_TPYE='||P_SITE_TPYE||','||'P_DIVISION_ID='||P_DIVISION_ID||','||'P_BUCKET='||P_BUCKET);
END P_SCP0100_GET_SITE;

/*
 * Program ID   : P_SCP0100_GET_PLAN_DATE
 * Description  : SCP0100 Global_PSI_Report — As-is SCP0100_GET_PLAN_DATE 이식 (GET, 시트 'REPORT' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.20   harness        [TobeGen] 골격 생성
 * 2026.10.20   harness        As-is 본문 이식 — #TMP_PLAN → WITH 절(버킷 갈래에서 1회 참조), O_RC1 1개
 */
PROCEDURE P_SCP0100_GET_PLAN_DATE (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        P_PROGRAM_ID     IN  VARCHAR2,  -- As-is @p_program_id nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사 없음: As-is 는 division 공란이면 전체(81% 한정) 조회 — NOT NULL 파라미터 아님

    -- As-is: CONVERT(char(10), FN_CHAR_TO_DATE(x), 121) → TO_CHAR(.., 'YYYY-MM-DD')
    --        A INNER JOIN B · LEFT JOIN C 후 WHERE FP_TARGET_YN = 'Y'(결과적으로 내부조인) — 원문 그대로 유지
    --        A.division_id = @p_division_id 는 분할 없이 단일 비교(원문) · CI 콜레이션 → UPPER
    IF UPPER(P_PROGRAM_ID) = 'SCP0100' AND UPPER(P_BUCKET) IN ('MONTHLY', 'WEEKLY') THEN
        OPEN O_RC1 FOR
            WITH TMP_PLAN AS (
                SELECT A.PLAN_START_YYYYMMDD AS CODE
                     , CASE WHEN C.FP_TARGET_YN = 'Y'
                            THEN TO_CHAR(SCM_MGR.FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD), 'YYYY-MM-DD') || ' (' || B.WEEK_NAME || ')'
                            ELSE TO_CHAR(SCM_MGR.FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD), 'YYYY-MM-DD') || ' (' || B.WEEK_NAME || ')' || ' (No Plan)'
                       END AS NAME
                  FROM SCM_MGR.SCP_PLAN_VERSION_V A
                 INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
                    ON A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
                  LEFT JOIN ( SELECT I.DIVISION_ID
                                   , I.PLAN_START_YYYYMMDD
                                   , I.FP_TARGET_YN
                                   , I.MRP_TARGET_YN
                                   , I.DM_RTF_YN
                                FROM SCM_MGR.SCP_PLN_INTERFACE_YN I
                               WHERE 1 = 1
                                 AND ( TRIM(P_DIVISION_ID) IS NULL
                                       OR UPPER(I.DIVISION_ID) IN ( SELECT UPPER(S.VALUE) FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_DIVISION_ID, ',')) S ) )   -- 고도화
                                 AND I.DIVISION_ID LIKE '81%'                                                                                             -- 고도화
                            ) C
                    ON A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD
                 WHERE 1 = 1
                   AND ( TRIM(P_DIVISION_ID) IS NULL OR UPPER(A.DIVISION_ID) = UPPER(P_DIVISION_ID) )
                   AND C.FP_TARGET_YN = 'Y'
                 GROUP BY A.PLAN_START_YYYYMMDD, B.WEEK_NAME, C.FP_TARGET_YN
            )
            SELECT T.CODE
                 , T.NAME
              FROM TMP_PLAN T
             WHERE ( UPPER(P_BUCKET) = 'MONTHLY'
                     AND T.CODE IN ( SELECT DISTINCT M.PLAN_START_YYYYMMDD FROM SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_MM M ) )
                OR ( UPPER(P_BUCKET) = 'WEEKLY'
                     AND T.CODE IN ( SELECT DISTINCT W.PLAN_START_YYYYMMDD FROM SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_WW W ) )
             ORDER BY T.CODE DESC;
    ELSE
        -- As-is 는 결과셋 없음(PROGRAM_ID≠SCP0100 또는 BUCKET 미일치) — 미개설 커서 대신 같은 컬럼의 0행 커서(NOTES §차이)
        OPEN O_RC1 FOR
            SELECT CAST(NULL AS VARCHAR2(400)) AS CODE
                 , CAST(NULL AS VARCHAR2(400)) AS NAME
              FROM DUAL
             WHERE 1 = 2;
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0100_GET_PLAN_DATE] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_DIVISION_ID='||P_DIVISION_ID||','||'P_BUCKET='||P_BUCKET||','||'P_PROGRAM_ID='||P_PROGRAM_ID);
END P_SCP0100_GET_PLAN_DATE;

END PKG_SCP0100;
/
-- 컴파일 확인: SELECT NAME, TYPE, LINE, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0100' ORDER BY TYPE, SEQUENCE;

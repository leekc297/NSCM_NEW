PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA (
    p_division_id               IN  VARCHAR2
  , p_dept_id                   IN  VARCHAR2
  , p_end_customer              IN  VARCHAR2
  , p_biz_type                  IN  VARCHAR2
  , p_from_yyyymmdd             IN  VARCHAR2
  , p_to_yyyymmdd               IN  VARCHAR2
  , p_sales_site                IN  VARCHAR2
  , p_item_id                   IN  VARCHAR2
  , p_version_type              IN  VARCHAR2
  , p_qty_yn                    IN  VARCHAR2
  , p_ses_user_id               IN  VARCHAR2
  , p_user_group                IN  VARCHAR2
  , p_plant_site_id             IN  VARCHAR2 DEFAULT 'ALL'
  , p_project_code              IN  VARCHAR2 DEFAULT 'ALL'
  , p_owner                     IN  VARCHAR2 DEFAULT 'ALL'
  , p_sender_code               IN  VARCHAR2 DEFAULT 'ALL'
  , o_rc1                       OUT SYS_REFCURSOR
  , o_result_cursor             OUT SYS_REFCURSOR
)
AS
/* ============================================================================================
 * [E20260921-XLSFORMASIS] Excel Form = **AS-IS DMF0020 파리티 전면 이식** (사용자 지시 2026-09-21)
 *
 *   지시 : "EXCEL FORM, UPLOAD 을 AS-IS DMF0020 의 EXCEL FORM, UPLOAD 와 동일하게 기능 구현"
 *          "EXCEL FORM COLUMN - Div / Team / End Customer / Project Code / Currency / Model / M0 ~ M12"
 *          "to-be 도 m0 - m12 까지는 빈칸"
 *
 *   원천 = AS-IS `DMF0020_SalesPriceTemplatePopup` 이 호출하는
 *          `DM.DMF0020_GET_SALES_PRICE_TEMPLATE` (TO-BE 변환본 = PKG_DMF0020.P_DMF0020_GET_SALES_PRICE_TEMPLATE,
 *          사내 live VALID 실측 2026-09-21). 본문 SQL 을 그 원문 그대로 옮겼다.
 *
 *   ⭐ 구 구현과의 차이 (의도된 교체 — 사용자 확정):
 *     (1) 행 원천 : SCM_MST_FUTURE_PRICE(단가 원장 키) -> **DM_PLN_SALES_PLAN_C ∪ DM_PLN_SALES_PLAN_RESULT_C**
 *                   (MEASURE='RTF_SYS_RP', QTY<>0, DIV 최신 SP_W 버전, 52주 창) = AS-IS 원문
 *     (2) 출력 축 : 23컬럼(Sales Site/Plant Site/Incoterms/FCST Type/Customs Handbook/Measure/
 *                   Project/Project Owner/FORM_WARN 포함) -> **AS-IS 19컬럼 + EDIT_YN**
 *     (3) M0~M12  : 구 구현은 LOC 원장 월별 대표단가를 프리필했다(사용자 지적 "조회 시 값 보임").
 *                   AS-IS 는 `'' AS M0 … '' AS M12` -> **전부 빈 문자열**로 환원. LP 프리필 조인 제거.
 *     (4) 선택 필터: AS-IS 양식은 division 단위 전량이라 조회조건 필터가 없다.
 *                   p_sales_site/p_item_id/p_end_customer/p_plant_site_id/p_project_code 는
 *                   **AS-IS 파리티를 위해 미적용**(시그니처는 PROC_M 배선 보존 목적으로 그대로 둔다).
 *
 *   ⚠ [NLSFIX 2026-09-21] AS-IS 변환 원본(PKG_DMF0020.P_DMF0020_GET_SALES_PRICE_TEMPLATE)은
 *      `FN_NEXT_DAY(T_VER.YYYYMMDD,'MON')` 로 **VARCHAR2 를 DATE 파라미터에 암묵 전달**한다.
 *      FN_NEXT_DAY 는 (P_DATEVAL DATE, P_WEEK VARCHAR2) 이므로 세션 NLS_DATE_FORMAT 에 의존하며,
 *      기본값 'DD-MON-RR' 세션(=BE 기본)에서 **ORA-01861** 로 실패한다(2026-09-21 실측 — 원본도 동일 재현).
 *      이식본은 `TO_DATE(T_VER.YYYYMMDD,'YYYYMMDD')` 로 명시 변환한다 (hook #109 NLS 암묵 형변환).
 *      ⇒ 원본 PKG_DMF0020 쪽은 본 회차 범위 밖이라 미수정 — 별건으로 보고.
 *   시그니처 : 17 IN + 2 OUT **무변경** — SCM_ADM_PROC_M(DMF0082/FcstNPrice/FORM_DATA) 재배선 불필요.
 *   AS-IS MNU 파라미터 대응 : P_USER_ID <- p_ses_user_id / P_MNU_ID <- 'DMF0082' (EDIT_YN 권한 뷰 조회용).
 *   division 가드 : AS-IS 도 81 사업부 전용(DMF0020_SalesFuturePrice.cs L203/L2579
 *                   `clbDivisions.ControlValues.Substring(0,2)=="81"` 일 때만 버튼 노출) — 기존 가드 유지.
 *   결과커서 MONTH_LIST : FE 계약 보존용으로 유지(양식 라벨은 FE 가 M{n} -> YYYYMM 로 환산).
 * ============================================================================================ */
    V_MONTH_LIST                VARCHAR2(400 CHAR);
    n_key_cnt                   PLS_INTEGER := 0;

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    /* [E20260819-XLS81LOC] Excel Form = Division 81 계열 전용 (AS-IS 동일 — .cs L203 실측).
       비대상 division 은 처리 없이 결과커서 CODE '1' + MSG01014. FE 는 81 외 버튼 비노출(서버 권위 방어). */
    IF p_division_id IS NULL OR p_division_id NOT LIKE '81%' THEN
        OPEN o_rc1 FOR SELECT CAST(NULL AS VARCHAR2(10)) AS DIVISION_ID FROM DUAL WHERE 1 = 0;
        OPEN o_result_cursor FOR
            SELECT '1' AS RESULT_CODE, 'MSG01014' AS RESULT_MSG, '0' AS EVENT
                 , CAST(NULL AS VARCHAR2(400)) AS MONTH_LIST FROM DUAL;
        RETURN;
    END IF;

    /* [E20260921-XLSFORMASIS] 월 목록 CSV(YYYYMM 13개) — 값이 아니라 **라벨 축** 전달용.
       M0=당월 … M12=당월+12 (업로드 저장이 M{n} -> ADD_MONTHS(SYSDATE,n) 로 해석하는 축과 동일). */
    SELECT LISTAGG(TO_CHAR(ADD_MONTHS(SYSDATE, LV - 1), 'YYYYMM'), ',') WITHIN GROUP (ORDER BY LV)
      INTO V_MONTH_LIST
      FROM (SELECT LEVEL AS LV FROM DUAL CONNECT BY LEVEL <= 13);

    -- ================================================================
    -- 메인 조회 — AS-IS DMF0020_GET_SALES_PRICE_TEMPLATE 원문 1:1
    -- ================================================================
    OPEN o_rc1 FOR
    WITH TEMP_VERSION_NO AS (
        --DIV별 최신 버전(2024.10.04)---------------------
        SELECT /*+ MATERIALIZE */
               A.DIVISION_ID, A.VERSION_NO, A.YYYYMMDD, B.BASIS_YYYYMM AS YYYYMM
        FROM
        (
            SELECT DIVISION_ID, MAX(VERSION_NO) AS VERSION_NO, MAX(YYYYMMDD) AS YYYYMMDD
            FROM DM_MST_VERSION
            WHERE DIVISION_ID = p_division_id
            AND VERSION_TYPE = 'SP_W'
            GROUP BY DIVISION_ID
        ) A
        INNER JOIN SCM_SYS_CALENDAR_M B
                ON B.BASIS_YYYYMMDD = A.YYYYMMDD
    )
    SELECT DISTINCT
        A.DIVISION_ID
        , A.DEPT_NAME_KO AS DEPT_NAME
        , A.END_CUSTOMER
        , A.PROJECT_CODE
        , MAX(A.CURRENCY) AS CURRENCY -- Model별로 하나의 CURRENCY만 있어야 하므로 MAX값 취함
        , A.ITEM_ID
        /* [E20260921-XLSFORMASIS] 양식 = 사용자 입력칸. AS-IS 원문과 동일하게 전부 빈칸. */
        , '' AS M0
        , '' AS M1
        , '' AS M2
        , '' AS M3
        , '' AS M4
        , '' AS M5
        , '' AS M6
        , '' AS M7
        , '' AS M8
        , '' AS M9
        , '' AS M10
        , '' AS M11
        , '' AS M12
        , EDIT_YN
    FROM
    (
        SELECT
        SP.DIVISION_ID
        , TEAM.DEPT_ID
        , TEAM.DEPT_NAME_KO
        , MS.END_CUSTOMER
        , SP.PROJECT_CODE
        , MP.PROJECT_NAME
        , SP.ITEM_ID
        , SP.SCM_SITE_ID
        , CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY--CURRENCY가 없을 경우 SSPM의 값을 가져옴
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN

        FROM DM_PLN_SALES_PLAN_C SP

            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = p_ses_user_id
                AND MNU_ID = 'DMF0082'
                AND UNIT_TP_CD = 'D') T2
            ON SP.DIVISION_ID = T2.UNIT_ID

        INNER JOIN SCM_MST_SITE MS
            ON MS.DIVISION_ID = SP.DIVISION_ID
            AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
            AND MS.VALID_YN = 'Y'
        -- 2026-09-07 hook#150: site 대표부서 = (DIVISION_ID, SCM_SITE_ID) 기준 MAX(DEPT_ID) 1건.
        --   AS-IS 는 IM 을 DIV+SITE 단독 INNER JOIN 하여 SITE_ITEM 행수만큼 증식한다(실측: 키당 최대 3,506행).
        INNER JOIN (SELECT SA.DIVISION_ID, SA.SCM_SITE_ID, MAX(SA.DEPT_ID) AS DEPT_ID
                      FROM SCM_MST_SITE_ITEM SA
                     INNER JOIN SCM_MST_SSO_DEPT_INFO SD
                        ON SD.DEPT_ID  = SA.DEPT_ID
                       AND SD.VALID_YN = 'Y'
                     WHERE SA.DEPT_ID IS NOT NULL
                     GROUP BY SA.DIVISION_ID, SA.SCM_SITE_ID) IM
            ON MS.DIVISION_ID = IM.DIVISION_ID
            AND MS.SCM_SITE_ID = IM.SCM_SITE_ID

        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            ON DI.DEPT_ID = IM.DEPT_ID
            AND DI.VALID_YN = 'Y'

        INNER JOIN SCM_MST_PROJECT MP
            ON MP.DIVISION_ID = SP.DIVISION_ID
            AND MP.PROJECT_CODE = SP.PROJECT_CODE --2026-07-03 perf: AS-IS 원문 활성 조인 복원

        INNER JOIN SCM_MST_SITE_ITEM SI
            ON SI.DIVISION_ID = SP.DIVISION_ID
            AND SI.PROJECT_CODE = SP.PROJECT_CODE
            AND SI.SCM_SITE_ID = SP.SCM_SITE_ID
            AND SI.ITEM_ID = SP.ITEM_ID
            AND SI.VALID_YN = 'Y'
        INNER JOIN TEMP_VERSION_NO T_VER--DIV별 최신버전(2024.10.04)
            ON SP.DIVISION_ID = T_VER.DIVISION_ID
            AND SP.VERSION_NO = T_VER.VERSION_NO
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (OWNER 경유 폐기)
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            ON TEAM.DEPT_ID = SI.DEPT_ID
        WHERE SP.DIVISION_ID = p_division_id
        AND SP.QTY <> 0
        AND SP.MEASURE = 'RTF_SYS_RP'
        --버전의 날짜로 처리(2024.10.04)
        AND SP.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(TO_DATE(T_VER.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
        AND SP.YYYYMMDD <= TO_CHAR(TO_DATE(TO_CHAR(FN_NEXT_DAY(TO_DATE(T_VER.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD'), 'YYYYMMDD') + (52 * 7) - 1, 'YYYYMMDD')
        UNION ALL

        SELECT
        SP.DIVISION_ID
        , TEAM.DEPT_ID
        , TEAM.DEPT_NAME_KO
        , MS.END_CUSTOMER
        , SP.PROJECT_CODE
        , MP.PROJECT_NAME
        , SP.ITEM_ID
        , SP.SCM_SITE_ID
        , CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY--CURRENCY가 없을 경우 SSPM의 값을 가져옴
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM DM_PLN_SALES_PLAN_RESULT_C SP

        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = p_ses_user_id
                AND MNU_ID = 'DMF0082'
                AND UNIT_TP_CD = 'D') T2
            ON SP.DIVISION_ID = T2.UNIT_ID

        INNER JOIN SCM_MST_SITE MS
            ON MS.DIVISION_ID = SP.DIVISION_ID
            AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
            AND MS.VALID_YN = 'Y'

        INNER JOIN (SELECT SA.DIVISION_ID, SA.SCM_SITE_ID, MAX(SA.DEPT_ID) AS DEPT_ID
                      FROM SCM_MST_SITE_ITEM SA
                     INNER JOIN SCM_MST_SSO_DEPT_INFO SD
                        ON SD.DEPT_ID  = SA.DEPT_ID
                       AND SD.VALID_YN = 'Y'
                     WHERE SA.DEPT_ID IS NOT NULL
                     GROUP BY SA.DIVISION_ID, SA.SCM_SITE_ID) IM
            ON MS.DIVISION_ID = IM.DIVISION_ID
            AND MS.SCM_SITE_ID = IM.SCM_SITE_ID

        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            ON DI.DEPT_ID = IM.DEPT_ID
            AND DI.VALID_YN = 'Y'

        INNER JOIN SCM_MST_PROJECT MP
            ON MP.DIVISION_ID = SP.DIVISION_ID
            AND MP.PROJECT_CODE = SP.PROJECT_CODE
        INNER JOIN SCM_MST_SITE_ITEM SI
            ON SI.DIVISION_ID = SP.DIVISION_ID
            AND SI.PROJECT_CODE = SP.PROJECT_CODE
            AND SI.SCM_SITE_ID = SP.SCM_SITE_ID
            AND SI.ITEM_ID = SP.ITEM_ID
            AND SI.VALID_YN = 'Y'
        INNER JOIN TEMP_VERSION_NO T_VER--DIV별 최신버전(2024.10.04)
            ON SP.DIVISION_ID = T_VER.DIVISION_ID
            AND SP.VERSION_NO = T_VER.VERSION_NO
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            ON TEAM.DEPT_ID = SI.DEPT_ID
        WHERE SP.DIVISION_ID = p_division_id
        AND SP.QTY <> 0
        AND SP.MEASURE = 'RTF_SYS_RP'
        AND SP.YYYYMMDD >= T_VER.YYYYMM || '01'
        AND SP.YYYYMMDD < TO_CHAR(FN_NEXT_DAY(TO_DATE(T_VER.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
    ) A
    GROUP BY
    A.DIVISION_ID
    , A.DEPT_ID
    , A.DEPT_NAME_KO
    , A.END_CUSTOMER
    , A.PROJECT_CODE
    , A.PROJECT_NAME
    , A.ITEM_ID
    , A.SCM_SITE_ID
    , A.EDIT_YN
    ;

    OPEN o_result_cursor FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(n_key_cnt) AS EVENT
             , V_MONTH_LIST AS MONTH_LIST
        FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'p_division_id'    VALUE SUBSTR(p_division_id, 1, 50)
          , 'p_ses_user_id'    VALUE SUBSTR(p_ses_user_id, 1, 50)
          , 'p_from_yyyymmdd'  VALUE SUBSTR(p_from_yyyymmdd, 1, 50)
          , 'p_to_yyyymmdd'    VALUE SUBSTR(p_to_yyyymmdd, 1, 50));
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0082_GET_EXCEL_FORM_DATA;

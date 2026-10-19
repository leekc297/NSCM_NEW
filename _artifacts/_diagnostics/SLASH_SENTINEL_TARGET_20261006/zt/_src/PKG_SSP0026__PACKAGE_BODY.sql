PACKAGE BODY PKG_SSP0026
IS
/*
 * Program ID   : PKG_SSP0026
 * Description  : SSP0026 Shipment Request Pack (외주 Packer 출하 지시)
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          조회 속도 개선 — 지시 상세 담당자 이름 조인화·변경요청 범위 제한, 엑셀 내리기 운송경로 뷰 해시 조인 고정
 * 2026.10.07   AJS          화면검증 — 본표 조회 두 건(Pack · Cell) 시트 이름 정규화(pack→Pack Biz · cell→Cell Biz) · 조회조건 ALL 을 조건 없음으로
 *
 * 전환 기준
 *   1. AS-IS 가 문자열로 조립하던 조회문은 조건 분기를 담은 정적 SQL 로 바꾼다.
 *   2. 정렬은 AS-IS 순서를 내는 공용 함수 FN_ASIS_SORT_KEY 를 쓴다.
 *   3. 원본 MSSQL 주석은 형태 그대로 둔다.
 *   4. AS-IS 는 대소문자를 가리지 않고 견주므로, 소문자가 섞인 칸은 양쪽을 UPPER 로 맞춘다.
 *   5. AS-IS 는 뒤 공백을 무시하고 견주므로, 뒤 공백이 있는 열쇠 칸은 RTRIM 으로 맞춘다.
 *      (실측 : 출하지시 Ship to 32건 · 사이트고객 Ship to 4건 · 출하실적 Ship to 2건 ·
 *       출하실적 품목 1건 · 사이트 최종고객 2건)
 *      (실측 : 실적 상세 To Site 7,737 건 · 지시 상세 MKT 담당 388 건 · 지시 상세 Sold to 6 건 ·
 *       품목 팝업 프로젝트 4 건 · 품목 팝업 품목 2 건 이 대소문자만 달라 AS-IS 에서는 붙고 그대로 옮기면 빠진다.)
 */

    /*******************************************************************************
     * P_SSP0026_GET_BOD_ITEM
     *   AS-IS SSP0026_GET_BOD_ITEM
     *   운송경로에 실려 있는 품목 목록
     *
     * ★기간 조건 : AS-IS 는 문자 칸(FROM_YYYYMMDD · TO_YYYYMMDD)을 GETDATE() 와 견준다.
     *   MSSQL 이 문자를 날짜로 바꿔 견주므로 종료일이 오늘인 행은 0 시 0 분으로 읽혀 빠진다.
     *   문자끼리 견주면 오늘도 들어와 결과가 달라지므로 날짜로 바꿔 견준다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_BOD_ITEM
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_FROM_SITE_ID          IN  VARCHAR2
      , P_TO_SITE_ID            IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT B.DIVISION_ID
                 , B.BOD_ID
                 , A.ITEM_ID
                 , B.INCOTERMS
                 , B.PRIORITY
                 , B.TRANSPORT_MODE
              FROM ( SELECT DISTINCT DIVISION_ID
                          , BOD_ID
                          , FROM_SITE
                          , TO_SITE
                          /* 20201223 INCOTERMS 변경 MODIFY KIMYONGHO */
                          , SSP_INCOTERMS                       AS INCOTERMS
                          , TRANSPORT_MODE
                          , PRIORITY
                       FROM SCP_MST_BOD_N_V
                      WHERE DIVISION_ID      = UPPER(P_DIVISION_ID)
                        AND FROM_SITE        = UPPER(P_FROM_SITE_ID)
                        AND UPPER(TO_SITE)   = UPPER(P_TO_SITE_ID)
                        AND BOD_VALID_YN     = 'Y'
                        AND TO_DATE(FROM_YYYYMMDD, 'YYYYMMDD') <= SYSDATE
                        AND TO_DATE(TO_YYYYMMDD,   'YYYYMMDD') >= SYSDATE
                   )  B
                 , ( SELECT DISTINCT DIVISION_ID
                          , ITEM_ID
                          , BOD_ID
                       FROM SCP_MST_BOD_ITEM
                      WHERE DIVISION_ID = UPPER(P_DIVISION_ID)
                        AND ( TRIM(P_ITEM_ID) IS NULL
                              OR ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   )  A
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.BOD_ID      = B.BOD_ID
             ORDER BY B.PRIORITY;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_BOD_ITEM;

    /*******************************************************************************
     * P_SSP0026_GET_ITEM_BY_DIVISION_POPUP
     *   AS-IS SSP0026_GET_ITEM_BY_DIVISION_POPUP
     *   품목 찾기 팝업
     *
     * ★품목 접미 치환 : AS-IS 는 STUFF(품목, 12, 1, 접미) 를 쓴다.
     *   MSSQL STUFF 는 시작 자리가 문자열 길이보다 크면 NULL 을 낸다.
     *   그 경우 바깥 ISNULL 이 원래 품목을 내주므로 12 자 미만 품목은 치환되지 않는다
     *   (실측 : 사이트 품목 118,135 행 가운데 12 자 미만 38,040 행).
     *   잘라 붙이기로만 옮기면 없던 값이 생겨 결과가 달라진다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_ITEM_BY_DIVISION_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT DIVISION_ID
                 , DIVISION_NAME
                 , PROJECT_CODE
                 , PROJECT_NAME
                 , SCM_SITE_ID
                 , SITE_DESCRIPTION
                 , ITEM_ID
                 , ITEM_NAME
                 , ITEM_TYPE
                 , NICK_NAME
                 , ITEM_CLASS_NAME
              FROM ( SELECT DISTINCT
                            B.DIVISION_ID
                          , B.DIVISION_NAME
                          , NVL(E.PROJECT_CODE, '-')             AS PROJECT_CODE
                          , NVL(E.PROJECT_NAME, '-')             AS PROJECT_NAME
                          , C.SCM_SITE_ID
                          , C.SITE_DESCRIPTION
                          /* , A.ITEM_ID */
                          , CASE WHEN TRIM(C.PACKER_ITEM_ID_SUFFIX) IS NULL THEN A.ITEM_ID
                                 ELSE NVL( CASE WHEN LENGTH(A.ITEM_ID) < 12 THEN NULL
                                                ELSE SUBSTR(A.ITEM_ID, 1, 11) || C.PACKER_ITEM_ID_SUFFIX || SUBSTR(A.ITEM_ID, 13)
                                           END
                                         , A.ITEM_ID)
                            END                                  AS ITEM_ID
                          , D.ITEM_NAME
                          , D.ITEM_TYPE
                          , D.NICK_NAME
                          , D.ITEM_CLASS_NAME
                       FROM SCM_MST_SITE_ITEM   A
                          , SCM_MST_DIVISION    B
                          , SCM_MST_SITE        C
                          , SCM_MST_ITEM_SN     D
                          , SCM_MST_PROJECT     E
                      WHERE A.DIVISION_ID       = B.DIVISION_ID
                        AND A.DIVISION_ID       = C.DIVISION_ID
                        AND A.SCM_SITE_ID       = C.SCM_SITE_ID
                        AND A.DIVISION_ID       = D.DIVISION_ID
                        AND UPPER(A.ITEM_ID)    = D.ITEM_ID                         /* 품목 대소문자 무시 비교 2건 */
                        AND A.DIVISION_ID       = E.DIVISION_ID(+)
                        AND UPPER(A.PROJECT_CODE) = E.PROJECT_CODE(+)               /* 프로젝트 대소문자 무시 비교 4건 */
                        AND 1 = 1
                        AND CASE WHEN UPPER(P_DIVISION_ID) = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END
                              IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ',')))
                        AND CASE WHEN UPPER(P_SCM_SITE_ID) = 'ALL' THEN 'ALL' ELSE UPPER(A.SCM_SITE_ID) END
                              IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ',')))
                        AND UPPER(A.PROJECT_CODE) LIKE '%' || UPPER(P_PROJECT_CODE) || '%'
                        AND (    UPPER( CASE WHEN TRIM(C.PACKER_ITEM_ID_SUFFIX) IS NULL THEN A.ITEM_ID
                                             ELSE NVL( CASE WHEN LENGTH(A.ITEM_ID) < 12 THEN NULL
                                                            ELSE SUBSTR(A.ITEM_ID, 1, 11) || C.PACKER_ITEM_ID_SUFFIX || SUBSTR(A.ITEM_ID, 13)
                                                       END
                                                     , A.ITEM_ID)
                                        END ) LIKE '%' || UPPER(P_ITEM_ID) || '%'
                              OR UPPER(D.ITEM_NAME) LIKE '%' || UPPER(P_ITEM_ID) || '%'
                              OR D.NICK_NAME        LIKE '%' || UPPER(P_ITEM_ID) || '%'
                            )
                   )  IA
             ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID)      NULLS FIRST
                    , FN_ASIS_SORT_KEY(SCM_SITE_ID)      NULLS FIRST
                    , FN_ASIS_SORT_KEY(SITE_DESCRIPTION) NULLS FIRST
                    , FN_ASIS_SORT_KEY(ITEM_NAME)        NULLS FIRST;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_ITEM_BY_DIVISION_POPUP;

    /*******************************************************************************
     * P_SSP0026_GET_SPREAD_TITLE
     *   AS-IS SSP0026_GET_SPREAD_TITLE
     *   화면 칸 설정 + 기간의 일 · 주 · 월 칸을 합친 머리글
     *
     * ★합칠 때 자료형 : 칸 설정의 정렬값 · 칸폭 · 소수자리 · 최대길이는 숫자 칸이고
     *   날짜 칸 쪽은 문자로 조립되어 있다. MSSQL 은 첫 조회 기준으로 알아서 바꾸지만
     *   Oracle 은 바꾸지 않으므로 형을 맞춰 적는다.
     * ★DAY_CODE 는 칸 설정 테이블에 없는 칸이므로 첫 조회에서는 빈값이다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_SPREAD_TITLE
    (
        P_START_DT              IN  VARCHAR2
      , P_END_DT                IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_ID    CONSTANT VARCHAR2(50 CHAR) := 'SSP0026';
        V_ERR_MSG       VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT PROGRAM_ID
                 , SHEET_NAME
                 , COLUMN_NAME
                 , COLUMN_LABEL_NAME
                 , SORT_ORDER_NO
                 , DATA_SORT_METHOD_CODE
                 , SMALL_CLASS_LABEL_NAME
                 , LARGE_CLASS_LABEL_NAME
                 , DAY_CODE
                 , FIXED_FLAG
                 , COLUMN_WIDTH
                 , CELL_CONTROL_OBJECT_TYPE_CODE
                 , CELL_COMBO_DATA_TYPE
                 , DATA_SCALE_NUMBER
                 , DATA_MAX_LENGTH
                 , HORIZONTAL_ALIGN_CODE
                 , UPPERCASE_APPLY_FLAG
                 , VISIBLE_FLAG
                 , DEFAULT_FLAG
                 , USER_SELECTABLE_FLAG
                 , VALID_YN
                 , DIVISION_ID
              FROM ( SELECT PROGRAM_ID
                          , SHEET_NAME
                          , COLUMN_NAME
                          , COLUMN_LABEL_NAME
                          , SORT_ORDER_NO
                          , DATA_SORT_METHOD_CODE
                          , SMALL_CLASS_LABEL_NAME
                          , LARGE_CLASS_LABEL_NAME
                          , CAST(NULL AS VARCHAR2(40 CHAR))      AS DAY_CODE
                          , FIXED_FLAG
                          , COLUMN_WIDTH
                          , CELL_CONTROL_OBJECT_TYPE_CODE
                          , CELL_COMBO_DATA_TYPE
                          , DATA_SCALE_NUMBER
                          , DATA_MAX_LENGTH
                          , HORIZONTAL_ALIGN_CODE
                          , UPPERCASE_APPLY_FLAG
                          , VISIBLE_FLAG
                          , DEFAULT_FLAG
                          , USER_SELECTABLE_FLAG
                          , VALID_YN
                          , DIVISION_ID
                       FROM SCM_MST_SHEET_COLUMNS
                      WHERE 1 = 1
                        AND PROGRAM_ID = C_PROGRAM_ID
                        AND SHEET_NAME = P_SHEET_NAME
                        AND VALID_YN   = 'Y'
                        AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(DIVISION_ID, ',')))
                      UNION ALL
                     SELECT C_PROGRAM_ID                         AS PROGRAM_ID
                          , P_SHEET_NAME                         AS SHEET_NAME
                          , COLUMN_NAME
                          , COLUMN_LABEL_NAME
                          , TO_NUMBER(SORT_ORDER_NO)             AS SORT_ORDER_NO
                          , CAST(NULL AS VARCHAR2(40 CHAR))      AS DATA_SORT_METHOD_CODE
                          , SMALL_CLASS_LABEL_NAME
                          , LARGE_CLASS_LABEL_NAME
                          , DAY_CODE
                          , CAST(NULL AS VARCHAR2(1 CHAR))       AS FIXED_FLAG
                          , 70                                   AS COLUMN_WIDTH
                          , 'FPNumber'                           AS CELL_CONTROL_OBJECT_TYPE_CODE
                          , CAST(NULL AS VARCHAR2(200 CHAR))     AS CELL_COMBO_DATA_TYPE
                          , 0                                    AS DATA_SCALE_NUMBER
                          , 10                                   AS DATA_MAX_LENGTH
                          , 'R'                                  AS HORIZONTAL_ALIGN_CODE
                          , CAST(NULL AS VARCHAR2(1 CHAR))       AS UPPERCASE_APPLY_FLAG
                          , 'Y'                                  AS VISIBLE_FLAG
                          , CAST(NULL AS VARCHAR2(1 CHAR))       AS DEFAULT_FLAG
                          , CAST(NULL AS VARCHAR2(1 CHAR))       AS USER_SELECTABLE_FLAG
                          , CAST(NULL AS VARCHAR2(4 CHAR))       AS VALID_YN
                          , CAST(NULL AS VARCHAR2(200 CHAR))     AS DIVISION_ID
                       FROM ( SELECT 'D_' || BASIS_YYYYMMDD      AS COLUMN_NAME
                                   , CALENDAR_DAY                AS COLUMN_LABEL_NAME
                                   , WEEK_NAME                   AS SMALL_CLASS_LABEL_NAME
                                   , MONTH_NAME                  AS LARGE_CLASS_LABEL_NAME
                                   , DAYOFWEEK                   AS DAY_CODE
                                   , BASIS_YYYYMMDD || '31'      AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M
                               WHERE BASIS_YYYYMMDD >= P_START_DT
                                 AND BASIS_YYYYMMDD <= P_END_DT
                               UNION ALL
                              SELECT 'W_' || BASIS_YYYYMM || ISO_WEEK   AS COLUMN_NAME
                                   , WEEK_NAME                   AS COLUMN_LABEL_NAME
                                   , WEEK_NAME                   AS SMALL_CLASS_LABEL_NAME
                                   , MONTH_NAME                  AS LARGE_CLASS_LABEL_NAME
                                   , CAST(NULL AS VARCHAR2(40 CHAR)) AS DAY_CODE
                                   , BASIS_START_DATE || '21'     AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M
                               WHERE BASIS_YYYYMMDD >= P_START_DT
                                 AND BASIS_YYYYMMDD <= P_END_DT
                               GROUP BY BASIS_YYYYMM
                                      , ISO_WEEK
                                      , WEEK_NAME
                                      , MONTH_NAME
                                      , BASIS_START_DATE
                               UNION ALL
                              SELECT 'M_' || BASIS_YYYYMM         AS COLUMN_NAME
                                   , MONTH_NAME                   AS COLUMN_LABEL_NAME
                                   , MONTH_NAME                   AS SMALL_CLASS_LABEL_NAME
                                   , MONTH_NAME                   AS LARGE_CLASS_LABEL_NAME
                                   , CAST(NULL AS VARCHAR2(40 CHAR)) AS DAY_CODE
                                   , MIN(BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M
                               WHERE BASIS_YYYYMMDD >= P_START_DT
                                 AND BASIS_YYYYMMDD <= P_END_DT
                               GROUP BY BASIS_YYYYMM
                                      , MONTH_NAME
                            )  XA
                   )  IA
             ORDER BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS PROGRAM_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_SPREAD_TITLE;

    /*******************************************************************************
     * P_SSP0026_GET_RESULT_DETAIL
     *   AS-IS SSP0026_GET_RESULT_DETAIL
     *   Packer 출하 실적 상세
     *
     * ★AS-IS 가 선언만 하고 쓰지 않는 변수(계획 시작일 · 종료일 · 마감일)는 옮기지 않는다.
     *   그 값을 쓰는 조건문이 주석으로 막혀 있어 결과에 영향이 없다.
     * ★Ship to Name 은 AS-IS 가 사업부를 '40' 으로 고정해 읽는다. 원문대로 둔다
     *   (다른 사업부에서는 Ship to Name 이 항상 빈값 — AS-IS 결함).
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_RESULT_DETAIL
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID                                   AS DIVISION_ID
                 , A.ITEM_ID                                       AS MODEL_ID
                 , B.NICK_NAME                                     AS NICK_NAME
                 , A.SCM_SITE_ID                                   AS FROM_SITE
                 , D.SITE_DESCRIPTION
                 , A.TO_SITE
                 , TO_CHAR(TO_DATE(A.SHIP_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')  AS YYYYMMDD
                 , A.SHIP_QTY                                      AS QTY
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN TRIM(E.USERNAME) IS NOT NULL THEN E.USERNAME || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN TRIM(E.USER_NM) IS NOT NULL THEN E.USER_NM || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                        ELSE NVL(A.LAST_UPDATED_BY, '-')
                   END                                             AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE                              AS LAST_UPDATED_DATE
                 , A.ATTRIBUTE4                                    AS SHIP_TO
                 , IA.SHIPTO_DESCRIPTION
              FROM SCM_DNM_SCS_SHIP_RESULT  A
                 , SCP_MST_FINAL_ITEM       B
                 , SCM_MST_SITE             C
                 , SCM_MST_SITE             D
                 /* 2026.09.30 AJS 수정 (START) */
--                 , TB_FX_USER               E
                 , SCM_ADM_USER_M           E
                 /* 2026.09.30 AJS 수정 (END) */
                 , ( SELECT DIVISION_ID
                          , SHIPTO_CODE
                          /* AS-IS 는 대소문자를 가리지 않고 최대값을 고르므로 같은 기준으로 고른다(실측 3건 차이) */
                          , MAX(SHIPTO_DESCRIPTION) KEEP (DENSE_RANK LAST ORDER BY NLSSORT(SHIPTO_DESCRIPTION, 'NLS_SORT=BINARY_CI'))
                              AS SHIPTO_DESCRIPTION
                       FROM SCM_MST_CUSTOMER
                      WHERE DIVISION_ID = '40'
                      GROUP BY DIVISION_ID
                             , SHIPTO_CODE
                   )  IA
             WHERE A.DIVISION_ID          = B.DIVISION_ID
               AND RTRIM(A.ITEM_ID)       = B.ITEM_ID                          /* 출하실적 품목 뒤 공백 1건 */
               AND A.DIVISION_ID          = C.DIVISION_ID(+)
               AND UPPER(A.TO_SITE)       = UPPER(C.SCM_SITE_ID(+))          /* To Site 대소문자 무시 비교 7,737건 */
               AND C.VALID_YN(+)          = 'Y'
               AND A.DIVISION_ID          = D.DIVISION_ID(+)
               AND A.SCM_SITE_ID          = D.SCM_SITE_ID(+)
               AND D.VALID_YN(+)          = 'Y'
               /* 2026.09.30 AJS 수정 (START) */
--               AND A.LAST_UPDATED_BY      = E.USERID(+)
               AND A.LAST_UPDATED_BY      = E.USER_ID(+)
               /* 2026.09.30 AJS 수정 (END) */
               AND A.DIVISION_ID          = IA.DIVISION_ID(+)
               AND RTRIM(A.ATTRIBUTE4)    = IA.SHIPTO_CODE(+)                  /* 출하실적 Ship to 뒤 공백 2건 */
               AND A.DIVISION_ID          = UPPER(P_DIVISION_ID)
               AND A.SHIP_DATE           >= P_FROM_YYYYMMDD
               AND A.SHIP_DATE           <= P_TO_YYYYMMDD
               /* 2020-10-13   KIMYONGHO    Plant Site, Salse Site 다중 선택 조회 가능 하도록 변경 */
               AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                     OR A.SCM_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )
               AND ( TRIM(P_SCM_SITE_ID) IS NULL
                     OR UPPER(A.TO_SITE) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
               AND ( TRIM(P_ITEM_ID) IS NULL
                     OR RTRIM(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
               AND ( TRIM(P_CUSTOMER) IS NULL
                     OR UPPER(RTRIM(C.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) )
               /* AS-IS 는 값을 쉼표로 나누지 않고 한 덩어리로 견준다 — 원문 그대로 둔다 */
               AND ( TRIM(P_NICK_NAME) IS NULL
                     OR B.NICK_NAME = UPPER(P_NICK_NAME) )
             /* 20211110	SHINMYUNGSU	SHIP_DATE로 정렬 */
             ORDER BY A.SHIP_DATE
                    , FN_ASIS_SORT_KEY(A.SCM_SITE_ID) NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.ITEM_ID)     NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.TO_SITE)     NULLS FIRST;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_RESULT_DETAIL;

    /*******************************************************************************
     * P_SSP0026_GET_REQUEST_DETAIL_PACK
     *   AS-IS SSP0026_GET_REQUEST_DETAIL_PACK
     *   Packer 출하 지시 상세
     *
     * ★수정 가능 판정(EDIT_FLAG) : AS-IS 는 'YYYYMMDD' 와 'YYYY-MM-DD' 를 문자로 견준다.
     *   MSSQL 정렬 규칙이 하이픈을 무시하므로 결과적으로 날짜끼리 견주는 것과 같다.
     *   Oracle 은 하이픈을 무시하지 않아 그대로 옮기면 항상 'N' 이 되므로
     *   같은 형식(YYYYMMDD)끼리 견주도록 맞춘다.
     * ★MKT 담당 이름(MKT_OWMER)은 사이트 품목의 프로젝트 코드와 사이트의 최종고객을 견주어 붙는다.
     *   두 칸에 소문자가 섞여 있어 그대로 옮기면 388 건이 빠진다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_REQUEST_DETAIL_PACK
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID                                   AS DIVISION_ID
                 , CASE WHEN A.CONFIRM_ID IS NULL THEN 'Plan' ELSE 'Confirm' END  AS STATUS
                 , NVL(A.REQUEST_ID, A.CONFIRM_ID)                 AS REQUEST_ID
                 , A.BOD_ID
                 , A.ITEM_ID                                       AS MODEL_ID
                 , B.NICK_NAME                                     AS NICK_NAME
                 , C.FROM_SITE
                 , F.SITE_DESCRIPTION
                 , C.TO_SITE
                 , D.SOLDTO_CODE
                 , A.SHIPTO_CODE
                 , IA.SHIPTO_DESCRIPTION                           AS SHIPTO_NAME
                 , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD')  AS YYYYMMDD
                 , A.QTY                                           AS QTY
                 /* 20201223 incoterms 변경 작업 modify KIMYONGHO */
                 , C.SSP_INCOTERMS                                 AS INCOTERMS
                 , C.TRANSPORT_MODE                                AS TR_MODE
                 , A.FCST_TYPE                                     AS FCST_TYPE
                 , A.ORDER_TYPE_DETAIL
                 , A.REMARK
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN TRIM(H.USERNAME) IS NOT NULL THEN H.USERNAME || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN TRIM(H.USER_NM) IS NOT NULL THEN H.USER_NM || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                        ELSE NVL(A.LAST_UPDATED_BY, '-')
                   END                                             AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE                              AS LAST_UPDATED_DATE
                 , CASE WHEN A.CONFIRM_ID IS NULL
                        THEN CASE WHEN TO_CHAR(SYSDATE + F.SHIP_FROZEN, 'YYYYMMDD') < A.YYYYMMDD THEN 'Y' ELSE 'N' END
                        ELSE 'N'
                   END                                             AS EDIT_FLAG
                 , G.SOLDTO_CUSTOMER                               AS END_CUSTOMER
                 -- 2026.10.06 AJS 담당자 이름 함수 대체 (START)
--               , FN_GET_SSP_MKT_OWNER_NAME(IB.OWNER, ',', 'KO')  AS MKT_OWMER
                 /* 담당자 이름 — 함수가 아이디마다 사용자 정보 전체를 읽던 것을 같은 규칙의 조인으로 (함수 결과 전수 대조 일치) */
                 , CASE WHEN TRIM(IB.OWNER) IS NOT NULL
                        THEN (SELECT TO_CLOB(CASE WHEN COUNT(*) >= 3
                                                  THEN LTRIM(LISTAGG(CASE WHEN XB.USER_ID IS NOT NULL
                                                                          THEN XB.USER_NAME || '(' || XB.USER_ID || ')'
                                                                          ELSE '(' || XA.TOKEN || ')'
                                                                     END, ',') WITHIN GROUP (ORDER BY XA.LV))
                                                  ELSE LISTAGG(CASE WHEN XB.USER_ID IS NOT NULL
                                                                    THEN XB.USER_NAME || '(' || XB.USER_ID || ')'
                                                                    ELSE '(' || XA.TOKEN || ')'
                                                               END, ',') WITHIN GROUP (ORDER BY XA.LV)
                                             END)
                                FROM (SELECT LEVEL                                   AS LV
                                           , TRIM(SUBSTR(IB.OWNER
                                                       , CASE WHEN LEVEL = 1 THEN 1 ELSE INSTR(IB.OWNER, ',', 1, LEVEL - 1) + 1 END
                                                       , CASE WHEN INSTR(IB.OWNER, ',', 1, LEVEL) = 0 THEN LENGTH(IB.OWNER) + 1 ELSE INSTR(IB.OWNER, ',', 1, LEVEL) END
                                                       - CASE WHEN LEVEL = 1 THEN 1 ELSE INSTR(IB.OWNER, ',', 1, LEVEL - 1) + 1 END)) AS TOKEN
                                        FROM DUAL
                                     CONNECT BY LEVEL <= REGEXP_COUNT(IB.OWNER, ',') + 1) XA
                                   , SCM_MST_SSO_USER_INFO XB
                               WHERE UPPER(XB.USER_ID(+)) = UPPER(XA.TOKEN))
                   END                                             AS MKT_OWMER
                 -- 2026.10.06 AJS 담당자 이름 함수 대체 (END)
                 , TO_CHAR(TO_DATE(FN_GET_SSP_ETD_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')  AS ETD_DATE
                 , TO_CHAR(TO_DATE(FN_GET_SSP_ETA_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')  AS ETA_DATE
                 , TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')  AS EXPECTED_SHIP_DATE
                 , C.LT_TOTAL_SSP                                  AS LT_TOTAL
                 , IC.CHANGE_REQ_NO                                AS CHANGE_REQ_NO
                 /* AS-IS 는 언어 분기가 상수 참이라 한글 이름만 쓰인다.
                    MSSQL 문자 결합은 한쪽이 빈값이면 전체가 빈값이므로 같게 맞춘다. */
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN J.USERNAME IS NOT NULL AND I.USER_ID IS NOT NULL
--                        THEN J.USERNAME || '(' || I.USER_ID || ')'
                 , CASE WHEN J.USER_NM IS NOT NULL AND I.USER_ID IS NOT NULL
                        THEN J.USER_NM || '(' || I.USER_ID || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END                                             AS MODEL_USER
                 , NVL(A.ATTRIBUTE3, '-')                          AS ATTRIBUTE3
                 , NVL(A.ATTRIBUTE4, '-')                          AS ATTRIBUTE4
                 , NVL(A.ATTRIBUTE5, '-')                          AS ATTRIBUTE5
                 , NVL(A.ATTRIBUTE6, '-')                          AS ATTRIBUTE6
              FROM SSP_ANL_SHIP_REQ_P        A
                 , SCP_MST_FINAL_ITEM        B
                 , SCP_MST_BOD_N_V           C
                 , SCM_MST_SITE_CUSTOMER     D
                 , SCM_MST_SITE              F
                 , SCM_MST_SITE              G
                 /* 2026.09.30 AJS 수정 (START) */
--                 , TB_FX_USER                H
                 , SCM_ADM_USER_M            H
                 /* 2026.09.30 AJS 수정 (END) */
                 , SSP_MST_MODEL_USER        I
                 /* 2026.09.30 AJS 수정 (START) */
--                 , TB_FX_USER                J
                 , SCM_ADM_USER_M            J
                 /* 2026.09.30 AJS 수정 (END) */
                 /* 현재 소형 외주 Packer 출하 지시의 경우 SOLDTO_CODE는 관리하지 않아 JOIN시 SOLDTO_CODE가 분할될수있어 제외 변경 처리 Modify by KIMYONGHO */
                 , ( SELECT DISTINCT DIVISION_ID
                          , SHIPTO_CODE
                          , SHIPTO_DESCRIPTION
                          , VALID_YN
                       FROM SCM_MST_CUSTOMER
                   )  IA
                 , ( SELECT DIVISION_ID
                          , SCM_SITE_ID
                          , ITEM_ID
                          , OWNER
                          , MAX(PROJECT_CODE)                      AS PROJECT_CODE
                       FROM SCM_MST_SITE_ITEM
                      GROUP BY DIVISION_ID
                             , SCM_SITE_ID
                             , ITEM_ID
                             , OWNER
                   )  IB
                 , ( SELECT CONFIRM_ID
                          , CHANGE_REQ_NO
                       FROM ( SELECT CONFIRM_ID
                                   , CHANGE_REQ_NO
                                   , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM
                                FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                               WHERE VALID_YN = 'Y'
                                 -- 2026.10.06 AJS 변경요청 최신번호 범위 제한 (START)
                                 /* 조회 기간 지시의 확정번호만 읽는다 — 확정번호별 순번이라 결과가 같다 */
                                 AND CONFIRM_ID IN (SELECT XB.CONFIRM_ID
                                                      FROM SSP_ANL_SHIP_REQ_P XB
                                                     WHERE XB.DIVISION_ID = UPPER(P_DIVISION_ID)
                                                       AND XB.YYYYMMDD   >= P_FROM_YYYYMMDD
                                                       AND XB.YYYYMMDD   <= P_TO_YYYYMMDD
                                                       AND XB.CONFIRM_ID IS NOT NULL)
                                 -- 2026.10.06 AJS 변경요청 최신번호 범위 제한 (END)
                            )  XA
                      WHERE NUM = 1
                   )  IC
             WHERE A.DIVISION_ID          = B.DIVISION_ID
               AND A.ITEM_ID              = B.ITEM_ID
               AND A.DIVISION_ID          = C.DIVISION_ID
               AND A.BOD_ID               = C.BOD_ID
               AND A.DIVISION_ID          = D.DIVISION_ID(+)
               AND UPPER(C.TO_SITE)       = UPPER(D.SCM_SITE_ID(+))          /* Sold to 대소문자 무시 비교 6건 */
               AND RTRIM(A.SHIPTO_CODE)   = RTRIM(D.SHIPTO_CODE(+))           /* Ship to 뒤 공백 32건 · 4건 */
               AND D.REP_YN(+)            = 'Y'
               AND D.VALID_YN(+)          = 'Y'
               AND A.DIVISION_ID          = IA.DIVISION_ID(+)
               AND RTRIM(A.SHIPTO_CODE)   = IA.SHIPTO_CODE(+)                 /* Ship to 뒤 공백 32건 */
               AND IA.VALID_YN(+)         = 'Y'
               AND A.DIVISION_ID          = F.DIVISION_ID(+)
               AND C.FROM_SITE            = F.SCM_SITE_ID(+)
               AND F.VALID_YN(+)          = 'Y'
               AND A.DIVISION_ID          = G.DIVISION_ID(+)
               AND UPPER(C.TO_SITE)       = UPPER(G.SCM_SITE_ID(+))
               AND G.VALID_YN(+)          = 'Y'
               /* 2026.09.30 AJS 수정 (START) */
--               AND A.LAST_UPDATED_BY      = H.USERID(+)
               AND A.LAST_UPDATED_BY      = H.USER_ID(+)
               /* 2026.09.30 AJS 수정 (END) */
               AND A.DIVISION_ID          = IB.DIVISION_ID(+)
               AND UPPER(C.TO_SITE)       = UPPER(IB.SCM_SITE_ID(+))
               AND A.ITEM_ID              = IB.ITEM_ID(+)
               AND UPPER(RTRIM(G.SOLDTO_CUSTOMER)) = UPPER(IB.PROJECT_CODE(+))   /* MKT 담당 대소문자 무시 388건 · 최종고객 뒤 공백 2건 */
               AND A.CONFIRM_ID           = IC.CONFIRM_ID(+)
               AND A.DIVISION_ID          = I.DIVISION_ID(+)
               AND C.FROM_SITE            = I.FROM_SITE(+)
               AND A.ITEM_ID              = I.ITEM_ID(+)
               AND I.VALID_YN(+)          = 'Y'
               /* 2026.09.30 AJS 수정 (START) */
--               AND I.USER_ID              = J.USERID(+)
--               AND J.USEYN(+)             = 'Y'
               AND I.USER_ID              = J.USER_ID(+)
               AND J.USE_YN(+)            = 'Y'
               /* 2026.09.30 AJS 수정 (END) */
               AND C.BOD_VALID_YN         = 'Y'
               AND A.DIVISION_ID          = UPPER(P_DIVISION_ID)
               AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD            <= P_TO_YYYYMMDD
               AND A.QTY                  > 0
               /* 2020-10-13   KIMYONGHO    Plant Site, Salse Site 다중 선택 조회 가능 하도록 변경 */
               AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                     OR C.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )
               AND ( TRIM(P_SCM_SITE_ID) IS NULL
                     OR UPPER(C.TO_SITE) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
               AND ( TRIM(P_ITEM_ID) IS NULL
                     OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
               AND ( TRIM(P_CUSTOMER) IS NULL
                     OR UPPER(RTRIM(G.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) )
               /* AS-IS 는 값을 쉼표로 나누지 않고 한 덩어리로 견준다 — 원문 그대로 둔다 */
               AND ( TRIM(P_NICK_NAME) IS NULL
                     OR B.NICK_NAME = UPPER(P_NICK_NAME) )
               AND ( TRIM(P_REQUESTOR_ID) IS NULL
                     /* 2026.09.30 AJS 수정 (START) */
--                     OR UPPER(A.LAST_UPDATED_BY) IN ( SELECT UPPER(USERID)
--                                                        FROM TB_FX_USER
                     OR UPPER(A.LAST_UPDATED_BY) IN ( SELECT UPPER(USER_ID)
                                                        FROM SCM_ADM_USER_M
                     /* 2026.09.30 AJS 수정 (END) */
                                                       WHERE 1 = 1
                                                         /* 2026.09.30 AJS 수정 (START) */
--                                                         AND ( UPPER(USERNAME) = UPPER(P_REQUESTOR_ID)
--                                                               OR UPPER(USERID) = UPPER(P_REQUESTOR_ID) ) ) )
                                                         AND ( UPPER(USER_NM) = UPPER(P_REQUESTOR_ID)
                                                               OR UPPER(USER_ID) = UPPER(P_REQUESTOR_ID) ) ) )
                                                         /* 2026.09.30 AJS 수정 (END) */
             /* 2021/11/01   SMS   Shipment Date로 정렬 */
             ORDER BY A.YYYYMMDD
                    , FN_ASIS_SORT_KEY(C.FROM_SITE)   NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.ITEM_ID)     NULLS FIRST
                    , FN_ASIS_SORT_KEY(C.TO_SITE)     NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.SHIPTO_CODE) NULLS FIRST;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_REQUEST_DETAIL_PACK;

    /*******************************************************************************
     * P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN
     *   AS-IS SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN
     *   Packer 출하 지시 엑셀 내리기
     *
     * ★AS-IS 안쪽 조회는 출하 달력과 출하 지시 사이에 잇는 조건이 없다(상수 조건만).
     *   두 테이블의 모든 짝이 만들어진 뒤 GROUP BY 로 묶이는 구조이므로 원문 그대로 옮긴다.
     * ★AS-IS 가 바깥 외부조인 안에 다시 넣은 사이트 · 품목 조건은
     *   안쪽 조회에서 이미 걸러진 값과 같아 결과에 영향이 없다(항상 참) — 옮기지 않는다.
     * ★수정 가능 판정은 지시 상세와 같은 이유로 같은 형식(YYYYMMDD)끼리 견준다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_LOT_ID                IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        /* NERP 매핑코드 */
        V_C100      VARCHAR2(10 CHAR);
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN

        V_C100 := FN_GET_LOOKUP_VALUE('SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN', 'ESOC');   /* C100 */

        OPEN O_RC1 FOR
            SELECT DIVISION_ID
                 , FROM_SITE
                 , TO_SITE
                 , SHIPTO_CODE
                 , ITEM_ID
                 , YYYYMMDD
                 , QTY
                 , TRANSPORT_MODE
                 , INCOTERMS
                 , BOD_ID
                 , FCST_TYPE
                 , EDIT_FLAG
              FROM ( SELECT IA.DIVISION_ID                         AS DIVISION_ID
                          , IA.FROM_SITE                           AS FROM_SITE
                          , IA.TO_SITE                             AS TO_SITE
                          , IA.SHIPTO_CODE                         AS SHIPTO_CODE
                          , IA.ITEM_ID                             AS ITEM_ID
                          , IA.YYYYMMDD                            AS YYYYMMDD
                          , NVL(IA.QTY, 0)                         AS QTY
                          , IA.TRANSPORT_MODE                      AS TRANSPORT_MODE
                          /* 20201223 incoterms 변경 작업 modify KIMYONGHO */
                          , IA.SSP_INCOTERMS                       AS INCOTERMS
                          , IA.BOD_ID_C                            AS BOD_ID
                          , IA.FCST_TYPE                           AS FCST_TYPE
                          /*  , IA.ORDER_TYPE_DETAIL   AS ORDER_TYPE_DETAIL */
                          , CASE WHEN TO_CHAR(SYSDATE + F.SHIP_FROZEN, 'YYYYMMDD') < IA.YYYYMMDD THEN 'Y' ELSE 'N' END  AS EDIT_FLAG
--                     FROM ( SELECT XA.DIVISION_ID  --  2026.10.06 AJS
                       FROM ( SELECT /*+ NO_PUSH_PRED(E) USE_HASH(E) */ XA.DIVISION_ID  --  2026.10.06 AJS
                                   , XA.FROM_SITE
                                   , XA.TO_SITE
                                   , XA.BOD_ID
                                   , XA.SHIPTO_CODE
                                   , XA.ITEM_ID
                                   , XA.YYYYMMDD
                                   , D.QTY
                                   , D.FCST_TYPE
                                   , E.TRANSPORT_MODE
                                   , E.SSP_INCOTERMS
                                   , E.BOD_ID                      AS BOD_ID_C
                                   , E.FROM_SITE                   AS FROM_SITE_C
                                FROM ( SELECT B.DIVISION_ID
                                            , C.FROM_SITE
                                            , C.TO_SITE
                                            , C.BOD_ID
                                            , B.SHIPTO_CODE
                                            , B.ITEM_ID
                                            , A.YYYYMMDD
                                         FROM SSP_MST_SHIP_CALENDAR  A
                                            , SSP_ANL_SHIP_REQ_P     B
                                            , SCP_MST_BOD_N_V        C
                                        WHERE C.DIVISION_ID   = B.DIVISION_ID
                                          AND C.BOD_ID        = B.BOD_ID
                                          AND 1 = 1
                                          AND A.DIVISION_ID   = UPPER(P_DIVISION_ID)
                                          AND A.COMPANY_ID    = V_C100                 /* 'C100' */
                                          AND B.DIVISION_ID   = UPPER(P_DIVISION_ID)
                                          AND C.DIVISION_ID   = UPPER(P_DIVISION_ID)
                                          AND C.BOD_TYPE      = 'SALES'
                                          AND A.YYYYMMDD     >= P_FROM_YYYYMMDD
                                          AND A.YYYYMMDD     <= P_TO_YYYYMMDD
                                          AND ( TRIM(P_ITEM_ID) IS NULL
                                                OR B.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                                          AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                                                OR C.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )
                                          AND ( TRIM(P_SCM_SITE_ID) IS NULL
                                                OR UPPER(C.TO_SITE) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                                        GROUP BY B.DIVISION_ID
                                               , C.FROM_SITE
                                               , C.TO_SITE
                                               , C.BOD_ID
                                               , B.SHIPTO_CODE
                                               , B.ITEM_ID
                                               , A.YYYYMMDD
                                     )  XA
                                   , SSP_ANL_SHIP_REQ_P  D
                                   , SCP_MST_BOD_N_V     E
                               WHERE XA.DIVISION_ID   = D.DIVISION_ID(+)
                                 AND XA.SHIPTO_CODE   = D.SHIPTO_CODE(+)
                                 AND XA.ITEM_ID       = D.ITEM_ID(+)
                                 AND XA.YYYYMMDD      = D.YYYYMMDD(+)
                                 AND UPPER(P_DIVISION_ID) = D.DIVISION_ID(+)
                                 AND XA.DIVISION_ID   = E.DIVISION_ID(+)
                                 AND XA.BOD_ID        = E.BOD_ID(+)
                                 AND XA.FROM_SITE     = E.FROM_SITE(+)
                                 AND XA.TO_SITE       = E.TO_SITE(+)
                            )  IA
                          , SCM_MST_SITE  F
                      WHERE IA.DIVISION_ID   = F.DIVISION_ID(+)
                        AND IA.FROM_SITE_C   = F.SCM_SITE_ID(+)
                        AND 1 = 1
                   )  T
             WHERE T.EDIT_FLAG <> 'N'
               AND T.QTY        > 0
             ORDER BY FN_ASIS_SORT_KEY(T.ITEM_ID)     NULLS FIRST
                    , FN_ASIS_SORT_KEY(T.FROM_SITE)   NULLS FIRST
                    , FN_ASIS_SORT_KEY(T.TO_SITE)     NULLS FIRST
                    , FN_ASIS_SORT_KEY(T.SHIPTO_CODE) NULLS FIRST
                    , T.YYYYMMDD;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN;

    /*******************************************************************************
     * P_SSP0026_GET_SHIPMENT_REQUEST_PACK
     *   AS-IS SSP0026_GET_SHIPMENT_REQUEST_PACK
     *   Packer 출하 지시 본표 (측정값 8 종 × 일 · 주 · 월 피벗)
     *
     * 측정값
     *   1 SCP_SHIP_PLAN  SCP 출하계획      2 SHIP_REQ  출하지시      3 SHIP_PLAN 출하실적
     *   4 PACK_FP        Pack 생산계획     5 TOTAL_PLAN 실적합계     6 TOTAL_REQ 지시합계
     *   7 WH_BOH_PLAN    창고 기초재고(계획)  8 WH_BOH_REQ 창고 기초재고(지시)
     *
     * ★수정자 대표행 정렬 : AS-IS 는 수정일시를 문자 칸에 담아 문자로 견준다.
     *   MSSQL 이 날짜를 'Mon DD YYYY  H:MIAM' 형태로 바꿔 담으므로 월 이름 알파벳 순으로 정렬된다.
     *   날짜 순으로 옮기면 대표행이 달라지므로 AS-IS 와 같은 문자 형태로 견준다.
     * ★피벗 칸 수가 조회 기간에 따라 달라지므로 이 조회만 동적 SQL 을 쓴다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_SHIPMENT_REQUEST_PACK
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_ID                CONSTANT VARCHAR2(50 CHAR) := 'SSP0026';
        V_DIVISION_ID               VARCHAR2(30 CHAR)  := UPPER(P_DIVISION_ID);
        V_FROM_YYYYMMDD             VARCHAR2(8 CHAR)   := P_FROM_YYYYMMDD;
        V_TO_YYYYMMDD               VARCHAR2(8 CHAR)   := P_TO_YYYYMMDD;
        V_YESTERDAY                 VARCHAR2(8 CHAR)   := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
        V_TODAY                     VARCHAR2(8 CHAR)   := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_CNT_USR_MEASURE           PLS_INTEGER        := 0;
        V_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR);
        V_SCP_PLAN_START_YYYYMMDD   VARCHAR2(32 CHAR);
        V_SCP_PLAN_TYPE             VARCHAR2(30 CHAR);
        V_SCP_SEQ                   NUMBER;
        V_PIVOT                     CLOB;
        V_SQL                       CLOB;
        V_ERR_MSG                   VARCHAR2(4000 CHAR);
        /* 2026.10.07 AJS 화면검증 (START) : 화면 전달값 정규화 — 시트 이름은 버튼 등록 시트(pack · cell)를 지표 시트 이름으로, 조회조건 ALL 은 조건 없음 */
        V_SHEET_NAME                VARCHAR2(100 CHAR)   := CASE LOWER(TRIM(P_SHEET_NAME)) WHEN 'pack' THEN 'Pack Biz' WHEN 'cell' THEN 'Cell Biz' ELSE P_SHEET_NAME END;
        V_TEAM_ID                   VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_TEAM_ID)) = 'ALL' THEN NULL ELSE P_TEAM_ID END;
        V_CUSTOMER                  VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_CUSTOMER)) = 'ALL' THEN NULL ELSE P_CUSTOMER END;
        V_SCM_SITE_ID               VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_SCM_SITE_ID)) = 'ALL' THEN NULL ELSE P_SCM_SITE_ID END;
        V_PLANT_SITE_ID             VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_PLANT_SITE_ID)) = 'ALL' THEN NULL ELSE P_PLANT_SITE_ID END;
        /* 2026.10.07 AJS 화면검증 (END) */
    BEGIN

        /* 임시 테이블 초기화 (TRUNCATE 는 암묵 커밋이라 쓰지 않음) */
        DELETE FROM GT_0026_ROWDATA;
        DELETE FROM GT_0026_RESULT;
        DELETE FROM GT_0026_REQUESTOR;
        DELETE FROM GT_0026_PIVOT_TEMP;
        DELETE FROM GT_0026_PIVOT;

        /* 사용자가 직접 고른 측정값이 있는지 */
        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = C_PROGRAM_ID
--         AND SHEET_NAME = P_SHEET_NAME  /* AJS 20261007 화면검증 */
           AND SHEET_NAME = V_SHEET_NAME  /* AJS 20261007 화면검증 */
           AND USER_ID    = P_CREATED_BY;

        /* 출하계획 기준일 (룩업의 기준일 + 1 일) */
        BEGIN
            SELECT TO_CHAR(TO_DATE(ATTRIBUTE1, 'YYYYMMDD') + 1, 'YYYYMMDD')
              INTO V_PLAN_START_YYYYMMDD
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE = 'SSP_ANL_SHIP_PLAN_P'
               AND ROWNUM <= 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_PLAN_START_YYYYMMDD := NULL;
        END;

        /* SCP 최종 계획 버전 */
        BEGIN
            SELECT PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , PLAN_SEQ
              INTO V_SCP_PLAN_START_YYYYMMDD
                 , V_SCP_PLAN_TYPE
                 , V_SCP_SEQ
              FROM ( SELECT PLAN_START_YYYYMMDD
                          , PLAN_TYPE
                          , PLAN_SEQ
                       FROM SCP_PLAN_VERSION_V
                      WHERE 1 = 1
                        AND DIVISION_ID = V_DIVISION_ID
                        AND PLAN_CYCLE  = 'WEEKLY'
                        AND PLAN_TYPE   = 'FN'
                      ORDER BY PLAN_START_YYYYMMDD DESC
                             , PLAN_TYPE_ORDER      DESC
                             , PLAN_SEQ             DESC
                   )  IA
             WHERE ROWNUM <= 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_SCP_PLAN_START_YYYYMMDD := NULL;
                V_SCP_PLAN_TYPE           := NULL;
                V_SCP_SEQ                 := NULL;
        END;

        /*SCP_SHIP_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT /*+ NO_MERGE(IA) NO_PUSH_PRED(IA) */
               IA.DIVISION_ID
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , 'SCP_SHIP_PLAN'                  AS MEASURE
             , IA.YYYYMMDD
             , IA.BOD_ID
             , IA.QTY
             , F.SSP_INCOTERMS                  AS INCOTERMS
             , F.TRANSPORT_MODE
             /*, ISNULL(A.FCST_TYPE,'') AS FCST_TYPE*/
             , '-'                              AS FCST_TYPE
             , 1                                AS SEQ
             , IA.LAST_UPDATED_BY
             , IA.LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM ( SELECT DIVISION_ID
                      , PLAN_START_YYYYMMDD
                      , PLAN_TYPE
                      , SEQ
                      , MAX(OPERATION_GROUP)    AS BIZ_TYPE
                      , '-'                     AS FCST_TYPE /*FCST_TYPE*/
                      , ITEM_ID
                      , TO_SITE
                      /* , INCOTERMS */
                      , FROM_SITE
                      , BOD_ID
                      , TRANSPORT_MODE
                      , MEASURE
                      , YYYYMMDD
                      , SUM(QTY)                AS QTY
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                   FROM ( SELECT /*+ LEADING(A D B C E) USE_HASH(D) USE_NL(B) USE_NL(C) USE_NL(E) */
                                 A.DIVISION_ID
                               , A.PLAN_START_YYYYMMDD
                               , A.PLAN_TYPE
                               , A.SEQ
                               , A.OPERATION_GROUP
                               , '-'                        AS FCST_TYPE /*D.FCST_TYPE*/
                               , A.ITEM_ID
                               , A.TO_SITE
                               , A.FROM_SITE
                               , A.BOD_ID
                               , A.TRANSPORT_MODE
                               , A.MEASURE
                               , A.YYYYMMDD
                               , D.ALLOCATION_QTY           AS QTY
                               , REPLACE(A.LAST_UPDATED_BY, 'scp_batch', 'System') AS LAST_UPDATED_BY
                               , A.LAST_UPDATE_DATE
                            FROM SCP_PLN_SHIPMENT_PLAN           A
                               , SCP_PLN_SHIPMENT_PLAN_PEGGING   D
                               , SCM_MST_SITE                    B
                               , SCM_MST_SITE                    C
                               , SCP_MST_BOD_N_V                 E
                           WHERE A.MASTER_ID             = D.MASTER_ID
                             AND A.PLAN_ID               = D.PLAN_ID
                             AND A.OUT_VERSION_ID        = D.OUT_VERSION_ID
                             AND A.DIVISION_ID           = D.DIVISION_ID
                             AND A.PLAN_START_YYYYMMDD   = D.PLAN_START_YYYYMMDD
                             AND A.PLAN_TYPE             = D.PLAN_TYPE
                             AND A.SEQ                   = D.SEQ
                             AND A.ORDER_ID              = D.ORDER_ID
                             AND A.DIVISION_ID           = B.DIVISION_ID
                             AND A.FROM_SITE             = B.SCM_SITE_ID
                             AND A.DIVISION_ID           = C.DIVISION_ID
                             AND A.TO_SITE               = C.SCM_SITE_ID
                             AND E.DIVISION_ID           = A.DIVISION_ID
                             AND E.BOD_ID                = A.BOD_ID
                             AND 1 = 1
                             AND B.SITE_TYPE             = 'PLANT'
                             AND B.VALID_YN              = 'Y'
                             AND B.OSP_YN                = 'Y'
                             AND B.OPERATION_GROUP       = 'P'
                             AND C.SITE_TYPE             = 'SALES'
                             AND C.VALID_YN              = 'Y'
                             AND A.MEASURE               = 'SHIP_PLAN'
                             AND A.DIVISION_ID           = V_DIVISION_ID
                             AND A.PLAN_START_YYYYMMDD   = V_SCP_PLAN_START_YYYYMMDD
                             AND A.PLAN_TYPE             = V_SCP_PLAN_TYPE
                             AND A.SEQ                   = V_SCP_SEQ
                             AND A.YYYYMMDD             >= V_FROM_YYYYMMDD
                             AND A.YYYYMMDD             <= V_TO_YYYYMMDD
                             AND ( TRIM(P_ITEM_ID) IS NULL
                                   OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--                           AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                             AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                 OR A.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                                   OR A.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--                           AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                             AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                 OR A.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                                   OR A.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--                           AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
                             AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--                                 OR UPPER(RTRIM(C.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
                                   OR UPPER(RTRIM(C.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
                        )  XA
                  GROUP BY DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , SEQ
                        /* , FCST_TYPE */
                         , ITEM_ID
                         , TO_SITE
                        /* , INCOTERMS */
                         , FROM_SITE
                         , TRANSPORT_MODE
                         , BOD_ID
                         , MEASURE
                         , YYYYMMDD
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
               )  IA
             , SCP_MST_BOD_N_V  F
         WHERE F.DIVISION_ID(+) = IA.DIVISION_ID
           AND F.BOD_ID(+)      = IA.BOD_ID
           AND F.DIVISION_ID(+) = V_DIVISION_ID
           AND F.BOD_TYPE(+)    = 'SALES'
           AND IA.DIVISION_ID   = V_DIVISION_ID
           AND IA.MEASURE       = 'SHIP_PLAN';

        /*SHIP_REQ Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT A.DIVISION_ID
             , A.ITEM_ID                        AS ITEM_ID
             , C.FROM_SITE                      AS FROM_SITE
             , C.TO_SITE                        AS TO_SITE
             , 'SHIP_REQ'                       AS MEASURE
             , A.YYYYMMDD
             , A.BOD_ID
             , A.QTY
             , C.INCOTERMS
             , C.TRANSPORT_MODE
             , A.FCST_TYPE
             , 2                                AS SEQ
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_REQ_P   A
             , SCP_MST_BOD_N_V      C
             , SCM_MST_SITE         B
         WHERE C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.BOD_ID(+)      = A.BOD_ID
           AND C.DIVISION_ID(+) = V_DIVISION_ID
           AND C.BOD_TYPE(+)    = 'SALES'
           AND A.DIVISION_ID    = B.DIVISION_ID
           AND C.TO_SITE        = B.SCM_SITE_ID
           AND 1 = 1
           AND B.SITE_TYPE      = 'SALES'
           AND B.VALID_YN       = 'Y'
           AND A.DIVISION_ID    = V_DIVISION_ID
           AND A.YYYYMMDD      >= V_FROM_YYYYMMDD
           AND A.YYYYMMDD      <= V_TO_YYYYMMDD
           AND A.QTY            > 0
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--         AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR C.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR C.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR C.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR C.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(RTRIM(B.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) );  /* AJS 20261007 화면검증 */
                 OR UPPER(RTRIM(B.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) );  /* AJS 20261007 화면검증 */

        /*SHIP_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID
             , A.TO_SITE
             , 'SHIP_PLAN'                      AS MEASURE
             , A.SHIP_DATE                      AS YYYYMMDD
             , B.BOD_ID                         AS BOD_ID
             , A.SHIP_QTY
             , NVL(C.INCOTERMS, B.INCOTERMS)            AS INCOTERMS
             , NVL(C.TRANSPORT_MODE, B.TRANSPORT_MODE)  AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 3                                AS SEQ
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SCM_DNM_SCS_SHIP_RESULT  A
             /* 임시로 Confirm ID만 존재하는 실적 대상
                SCS I/F INCOTERS, TRANS MODE, FCST TYPE 추가 되면 JOIN 해제 */
             , SSP_ANL_SHIP_CONFIRM     C
             , SCP_MST_BOD_N_V          B
         WHERE A.ATTRIBUTE5        = C.CONFIRM_ID(+)
           AND A.SCM_SITE_ID       = B.FROM_SITE(+)
           AND UPPER(A.TO_SITE)    = UPPER(B.TO_SITE(+))
           AND UPPER(A.ATTRIBUTE8) = UPPER(B.TRANSPORT_MODE(+))
           AND A.ATTRIBUTE9        = B.INCOTERMS(+)
           AND A.DIVISION_ID       = V_DIVISION_ID
           AND A.SHIP_DATE        >= V_FROM_YYYYMMDD
           AND A.SHIP_DATE        <= V_TO_YYYYMMDD
           AND A.SHIP_QTY          > 0;
           /*AND  A.ATTRIBUTE8 IS NOT NULL
             AND  A.ATTRIBUTE9 IS NOT NULL*/

        /*PACK_FP Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT /*+ NO_MERGE(IA) NO_PUSH_PRED(IA) */
               A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID                    AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'PACK_FP'                        AS MEASURE
             , A.PROD_DATE                      AS YYYYMMDD
             , '-'                              AS BOD_ID
             , SUM(NVL(A.PROD_QTY, 0))          AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 4                                AS SEQ
             , '-'                              AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SCM_DNM_SCS_PROD_PLAN  A
             , ( SELECT DIVISION_ID
                      , MAX(CUTOFF_DATE)        AS CUTOFF_DATE
                      , PACK_MODEL_CODE
                      , SCM_SITE_ID
                   FROM SCM_DNM_SCS_PROD_PLAN
                  GROUP BY DIVISION_ID
                         , PACK_MODEL_CODE
                         , SCM_SITE_ID
               )  IA
             , SCM_MST_SITE           C
         WHERE A.DIVISION_ID     = IA.DIVISION_ID
           AND A.CUTOFF_DATE     = IA.CUTOFF_DATE
           AND A.PACK_MODEL_CODE = IA.PACK_MODEL_CODE
           AND A.SCM_SITE_ID     = IA.SCM_SITE_ID
           AND C.DIVISION_ID     = A.DIVISION_ID
           AND C.SCM_SITE_ID     = A.SCM_SITE_ID
           AND C.SITE_TYPE       = 'PLANT'
           AND C.VALID_YN        = 'Y'
           AND C.OSP_YN          = 'Y'
           AND C.OPERATION_GROUP = 'P'
           AND A.DIVISION_ID     = V_DIVISION_ID
           /*AND  A.CUTOFF_DATE = CONVERT(CHAR(8), GETDATE(), 112)*/
           AND A.PROD_DATE      >= V_FROM_YYYYMMDD
           AND A.PROD_DATE      <= V_TO_YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.PROD_DATE;

        /*TOTAL_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT /*+ NO_MERGE(IA) NO_PUSH_PRED(IA) */
               A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID                    AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'TOTAL_PLAN'                     AS MEASURE
             , A.SHIP_DATE                      AS YYYYMMDD
             , '-'                              AS BOD_ID
             , SUM(NVL(A.SHIP_QTY, 0))          AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 5                                AS SEQ
             , '-'                              AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SCM_DNM_SCS_SHIP_RESULT  A
             , ( SELECT A.SCM_SITE_ID
                      , B.SOLDTO_CODE
                      , B.SHIPTO_CODE
                   FROM SCM_MST_SITE           A
                      , SCM_MST_SITE_CUSTOMER  B
                  WHERE B.DIVISION_ID = A.DIVISION_ID
                    AND B.SCM_SITE_ID = A.SCM_SITE_ID
                    AND 1 = 1
                    AND B.DIVISION_ID = V_DIVISION_ID
                    AND B.VALID_YN    = 'Y'
                    AND B.REP_YN      = 'Y'
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.SITE_TYPE   = 'SALES'
                    AND A.VALID_YN    = 'Y'
               )  IA
             , SSP_ANL_SHIP_CONFIRM     D
         WHERE UPPER(A.TO_SITE) = UPPER(IA.SCM_SITE_ID)
           AND A.ATTRIBUTE5     = D.CONFIRM_ID
           AND A.DIVISION_ID    = V_DIVISION_ID
           AND A.SHIP_DATE     >= V_FROM_YYYYMMDD
           AND A.SHIP_DATE     <= V_TO_YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.SHIP_DATE;

        /*TOTAL_REQ Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT A.DIVISION_ID
             , A.ITEM_ID                        AS ITEM_ID
             , C.FROM_SITE                      AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'TOTAL_REQ'                      AS MEASURE
             , A.YYYYMMDD
             , '-'                              AS BOD_ID
             , SUM(A.QTY)                       AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 6                                AS SEQ
             , '-'                              AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_REQ_P   A
             , SCP_MST_BOD_N_V      C
             , SCM_MST_SITE         B
         WHERE C.DIVISION_ID    = A.DIVISION_ID
           AND C.BOD_ID         = A.BOD_ID
           AND A.DIVISION_ID    = B.DIVISION_ID
           AND C.TO_SITE        = B.SCM_SITE_ID
           AND 1 = 1
           AND C.DIVISION_ID    = V_DIVISION_ID
           AND C.BOD_TYPE       = 'SALES'
           AND B.SITE_TYPE      = 'SALES'
           AND B.VALID_YN       = 'Y'
           AND A.DIVISION_ID    = V_DIVISION_ID
           AND A.YYYYMMDD      >= V_FROM_YYYYMMDD
           AND A.YYYYMMDD      <= V_TO_YYYYMMDD
           AND A.QTY            > 0
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--         AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR C.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR C.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR C.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR C.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(RTRIM(B.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
                 OR UPPER(RTRIM(B.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
         GROUP BY A.DIVISION_ID
                , A.ITEM_ID
                , C.FROM_SITE
                , A.YYYYMMDD
                , A.BOD_ID;

        /*WH_BOH_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT /*+ NO_MERGE(IA) NO_MERGE(IB) NO_MERGE(IC) NO_PUSH_PRED(IA) NO_PUSH_PRED(IB) NO_PUSH_PRED(IC) */
               IA.DIVISION_ID
             , IA.ITEM_ID                       AS ITEM_ID
             , IA.FROM_SITE                     AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'WH_BOH_PLAN'                    AS MEASURE
             , IA.YYYYMMDD                      AS YYYYMMDD
             , '-'                              AS BOD_ID
             , SUM(CASE WHEN IC.MEASURE = 'TOTAL_PLAN'  AND IC.YYYYMMDD = V_YESTERDAY THEN 0  /* @p_from_yyyymmdd */
                        WHEN IC.MEASURE = 'TOTAL_PLAN'  AND IC.YYYYMMDD >= V_TODAY THEN -1 * NVL(IC.QTY, 0)  /* @p_from_yyyymmdd */
                        WHEN IC.MEASURE <> 'TOTAL_PLAN' AND IC.YYYYMMDD = V_YESTERDAY THEN 0
                        WHEN IC.MEASURE <> 'TOTAL_PLAN' AND IC.YYYYMMDD >= V_TODAY AND IC.YYYYMMDD < IA.YYYYMMDD THEN NVL(IC.QTY, 0)
                   ELSE 0 END) + NVL(IB.STOCK_QTY, 0)   AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 7                                AS SEQ
             , '-'                              AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM ( SELECT XB.DIVISION_ID
                      , XB.ITEM_ID
                      , XB.FROM_SITE
                      , XA.BASIS_YYYYMMDD       AS YYYYMMDD
                   FROM SCM_SYS_CALENDAR_M  XA
                      , ( SELECT DIVISION_ID
                               , ITEM_ID
                               , FROM_SITE
                            FROM GT_0026_ROWDATA
                           WHERE 1 = 1
                             AND DIVISION_ID = V_DIVISION_ID
                             AND YYYYMMDD   >= V_YESTERDAY /*@v_plan_start_date*/
                             AND YYYYMMDD   <= P_TO_YYYYMMDD
                             AND MEASURE     IN ('TOTAL_PLAN', 'PACK_FP')
                           GROUP BY DIVISION_ID
                                  , ITEM_ID
                                  , FROM_SITE
                        )  XB
                  WHERE 1 = 1
                    AND XA.BASIS_YYYYMMDD >= V_YESTERDAY /*@v_plan_start_date*/
                    AND XA.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
               )  IA
             , ( SELECT DIVISION_ID
                      , SCM_SITE_ID             AS FROM_SITE
                      , ITEM_ID                 AS ITEM_ID
                      , STOCK_DATE              AS YYYYMMDD
                      , SUM(NVL(STOCK_QTY, 0))  AS STOCK_QTY
                   FROM SCM_DNM_SCS_STOCK
                  WHERE 1 = 1
                    AND DIVISION_ID = V_DIVISION_ID
                    AND CUTOFF_DATE = V_YESTERDAY
                    /*AND    STOCK_DATE >= @v_plan_start_date
                      AND    STOCK_DATE <= @v_plan_end_date*/
                    AND CELL_PACK   = 'P'
                  GROUP BY DIVISION_ID
                         , SCM_SITE_ID
                         , ITEM_ID
                         , STOCK_DATE
               )  IB
             , ( SELECT DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                      , YYYYMMDD
                      , MEASURE
                      , QTY
                   FROM GT_0026_ROWDATA
                  WHERE 1 = 1
                    AND DIVISION_ID = V_DIVISION_ID
                    AND YYYYMMDD   >= V_PLAN_START_YYYYMMDD
                    AND YYYYMMDD   <= P_TO_YYYYMMDD
                    AND MEASURE     IN ('TOTAL_PLAN', 'PACK_FP')
               )  IC
         WHERE IA.DIVISION_ID = IB.DIVISION_ID(+)
           AND UPPER(RTRIM(IA.ITEM_ID)) = UPPER(RTRIM(IB.ITEM_ID(+)))   /* 재고 품목 뒤 공백 833건 · 소문자 1건 */
           AND IA.FROM_SITE   = IB.FROM_SITE(+)
           AND IC.DIVISION_ID(+) = IA.DIVISION_ID
           AND IC.ITEM_ID(+)     = IA.ITEM_ID
           AND IC.YYYYMMDD(+)   <= IA.YYYYMMDD
           AND IC.FROM_SITE(+)   = IA.FROM_SITE
           AND 1 = 1
         GROUP BY IA.DIVISION_ID
                , IA.ITEM_ID
                , IA.FROM_SITE
                , IA.YYYYMMDD
                , IB.STOCK_QTY;

        /*WH_BOH_REQ Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT /*+ NO_MERGE(IA) NO_MERGE(IB) NO_MERGE(IC) NO_PUSH_PRED(IA) NO_PUSH_PRED(IB) NO_PUSH_PRED(IC) */
               IA.DIVISION_ID
             , IA.ITEM_ID                       AS ITEM_ID
             , IA.FROM_SITE                     AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'WH_BOH_REQ'                     AS MEASURE
             , IA.YYYYMMDD                      AS YYYYMMDD
             , '-'                              AS BOD_ID
             , SUM(CASE WHEN IC.MEASURE = 'TOTAL_REQ'  AND IC.YYYYMMDD = V_YESTERDAY THEN 0  /* @p_from_yyyymmdd */
                        WHEN IC.MEASURE = 'TOTAL_REQ'  AND IC.YYYYMMDD >= V_TODAY THEN -1 * NVL(IC.QTY, 0)  /* @p_from_yyyymmdd */
                        WHEN IC.MEASURE <> 'TOTAL_REQ' AND IC.YYYYMMDD = V_YESTERDAY THEN 0
                        WHEN IC.MEASURE <> 'TOTAL_REQ' AND IC.YYYYMMDD >= V_TODAY AND IC.YYYYMMDD < IA.YYYYMMDD THEN NVL(IC.QTY, 0)
                   ELSE 0 END) + NVL(IB.STOCK_QTY, 0)   AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 8                                AS SEQ
             , '-'                              AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM ( SELECT XB.DIVISION_ID
                      , XB.ITEM_ID
                      , XB.FROM_SITE
                      , XA.BASIS_YYYYMMDD       AS YYYYMMDD
                   FROM SCM_SYS_CALENDAR_M  XA
                      , ( SELECT DIVISION_ID
                               , ITEM_ID
                               , FROM_SITE
                            FROM GT_0026_ROWDATA
                           WHERE 1 = 1
                             AND DIVISION_ID = V_DIVISION_ID
                             AND YYYYMMDD   >= V_YESTERDAY /*@v_plan_start_date*/
                             AND YYYYMMDD   <= P_TO_YYYYMMDD
                             AND MEASURE     IN ('TOTAL_REQ', 'PACK_FP')
                           GROUP BY DIVISION_ID
                                  , ITEM_ID
                                  , FROM_SITE
                        )  XB
                  WHERE 1 = 1
                    AND XA.BASIS_YYYYMMDD >= V_YESTERDAY /*@v_plan_start_date*/
                    AND XA.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
               )  IA
             , ( SELECT DIVISION_ID
                      , SCM_SITE_ID             AS FROM_SITE
                      , ITEM_ID                 AS ITEM_ID
                      , STOCK_DATE              AS YYYYMMDD
                      , SUM(NVL(STOCK_QTY, 0))  AS STOCK_QTY
                   FROM SCM_DNM_SCS_STOCK
                  WHERE 1 = 1
                    AND DIVISION_ID = V_DIVISION_ID
                    AND CUTOFF_DATE = V_YESTERDAY
                    AND CELL_PACK   = 'P'
                  GROUP BY DIVISION_ID
                         , SCM_SITE_ID
                         , ITEM_ID
                         , STOCK_DATE
               )  IB
             , ( SELECT DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                      , YYYYMMDD
                      , MEASURE
                      , QTY
                   FROM GT_0026_ROWDATA
                  WHERE 1 = 1
                    AND DIVISION_ID = V_DIVISION_ID
                    AND YYYYMMDD   >= V_YESTERDAY /*@v_plan_start_date*/
                    AND YYYYMMDD   <= P_TO_YYYYMMDD
                    AND MEASURE     IN ('TOTAL_REQ', 'PACK_FP')
               )  IC
         WHERE IA.DIVISION_ID = IB.DIVISION_ID(+)
           AND UPPER(RTRIM(IA.ITEM_ID)) = UPPER(RTRIM(IB.ITEM_ID(+)))   /* 재고 품목 뒤 공백 833건 · 소문자 1건 */
           AND IA.FROM_SITE   = IB.FROM_SITE(+)
           AND IC.DIVISION_ID(+) = IA.DIVISION_ID
           AND IC.ITEM_ID(+)     = IA.ITEM_ID
           AND IC.YYYYMMDD(+)   <= IA.YYYYMMDD
           AND IC.FROM_SITE(+)   = IA.FROM_SITE
           AND 1 = 1
         GROUP BY IA.DIVISION_ID
                , IA.ITEM_ID
                , IA.FROM_SITE
                , IA.YYYYMMDD
                , IB.STOCK_QTY;

        /* Requestor
           ★AS-IS 는 수정일시를 문자 칸에 담아 문자로 견주므로 같은 문자 형태로 정렬한다. */
        INSERT INTO GT_0026_REQUESTOR
             ( DIVISION_ID, FROM_SITE, TO_SITE, ITEM_ID, MEASURE, BOD_ID, LAST_UPDATED_BY )
        SELECT DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , ITEM_ID
             , MEASURE
             , BOD_ID
             , LAST_UPDATED_BY
          FROM ( SELECT DIVISION_ID
                      , FROM_SITE
                      , TO_SITE
                      , ITEM_ID
                      , MEASURE
                      , BOD_ID
                      , LAST_UPDATED_BY
                      , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, FROM_SITE, TO_SITE, ITEM_ID, MEASURE, BOD_ID
                                               ORDER BY RN DESC) AS RN2
                   FROM ( SELECT DIVISION_ID
                               , ITEM_ID
                               , FROM_SITE
                               , TO_SITE
                               , MEASURE
                               , YYYYMMDD
                               , BOD_ID
                               , QTY
                               , INCOTERMS
                               , TRANSPORT_MODE
                               , FCST_TYPE
                               , LAST_UPDATED_BY
                               , RANK() OVER (PARTITION BY DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, BOD_ID
                                                  ORDER BY ITEM_ID DESC
                                                         , TO_CHAR(LAST_UPDATE_DATE, 'Mon', 'NLS_DATE_LANGUAGE=ENGLISH')
                                                           || ' ' || LPAD(TO_CHAR(LAST_UPDATE_DATE, 'FMDD'), 2)
                                                           || ' ' || TO_CHAR(LAST_UPDATE_DATE, 'YYYY')
                                                           || ' ' || LPAD(TO_CHAR(LAST_UPDATE_DATE, 'FMHH') || ':'
                                                                          || TO_CHAR(LAST_UPDATE_DATE, 'MI')
                                                                          || TO_CHAR(LAST_UPDATE_DATE, 'AM', 'NLS_DATE_LANGUAGE=ENGLISH'), 7)
                                             ) AS RN
                            FROM GT_0026_ROWDATA
                           GROUP BY DIVISION_ID
                                  , ITEM_ID
                                  , FROM_SITE
                                  , TO_SITE
                                  , MEASURE
                                  , YYYYMMDD
                                  , BOD_ID
                                  , QTY
                                  , INCOTERMS
                                  , TRANSPORT_MODE
                                  , FCST_TYPE
                                  , LAST_UPDATED_BY
                                  , LAST_UPDATE_DATE
                        )  XA
                )  IA
         WHERE RN2 = 1
           AND MEASURE NOT IN ('WH_BOH_PLAN', 'WH_BOH_REQ', 'TOTAL_PLAN', 'TOTAL_REQ', 'PACK_FP');

        /* 측정값 × 날짜 판 만들기 */
        INSERT INTO GT_0026_RESULT
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ )
        SELECT /*+ NO_MERGE(IA) NO_PUSH_PRED(IA) */ DISTINCT
               IA.DIVISION_ID
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE                       AS TO_SITE
             , IA.MEASURE
             , IA.YYYYMMDD
             , '-'                              AS BOD_ID
             , NVL(R.QTY, 0)                    AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , IA.SEQ
          FROM ( SELECT DISTINCT T.DIVISION_ID
                      , T.ITEM_ID                       AS ITEM_ID
                      , '-'                             AS FROM_SITE
                      , '-'                             AS TO_SITE
                      , T.BOD_ID
                      , T.QTY
                      , T.INCOTERMS
                      , T.TRANSPORT_MODE
                      , T.FCST_TYPE
                      , TT1.COLUMN_NAME                 AS MEASURE
                      , TT1.COLUMN_LABEL_NAME           AS MEASURE_NAME
                      , TT1.ATTRIBUTE3                  AS BACK_COLOR
                      , TT1.SORT_ORDER_NO               AS SEQ
                      , T.YYYYMMDD
                   FROM GT_0026_ROWDATA         T
                      , SCM_MST_SHEET_MEASURE   TT1
                  WHERE TT1.PROGRAM_ID = C_PROGRAM_ID
--                  AND TT1.SHEET_NAME = P_SHEET_NAME  /* AJS 20261007 화면검증 */
                    AND TT1.SHEET_NAME = V_SHEET_NAME  /* AJS 20261007 화면검증 */
               )  IA
             , GT_0026_ROWDATA  R
         WHERE R.DIVISION_ID(+) = IA.DIVISION_ID
           AND R.ITEM_ID(+)     = IA.ITEM_ID
           AND R.MEASURE(+)     = IA.MEASURE
           AND R.YYYYMMDD(+)    = IA.YYYYMMDD
           AND IA.TO_SITE       = '-'
           AND IA.MEASURE       IN ('WH_BOH_PLAN', 'WH_BOH_REQ', 'TOTAL_PLAN', 'TOTAL_REQ', 'PACK_FP')
         UNION ALL
        SELECT /*+ NO_MERGE(IB) NO_PUSH_PRED(IB) */ DISTINCT
               IB.DIVISION_ID
             , IB.ITEM_ID
             , IB.FROM_SITE
             , IB.TO_SITE
             , IB.MEASURE
             , IB.YYYYMMDD
             , NVL(IB.BOD_ID, '-')              AS BOD_ID
             , NVL(S.QTY, 0)                    AS QTY
             , NVL(IB.INCOTERMS, '-')           AS INCOTERMS
             , NVL(IB.TRANSPORT_MODE, '-')      AS TRANSPORT_MODE
             , NVL(IB.FCST_TYPE, '-')           AS FCST_TYPE
             , IB.SEQ
          FROM ( SELECT DISTINCT T.DIVISION_ID
                      , T.ITEM_ID
                      , NVL(T.FROM_SITE, '-')           AS FROM_SITE
                      , NVL(T.TO_SITE, '-')             AS TO_SITE
                      , T.BOD_ID
                      , T.QTY
                      , T.INCOTERMS
                      , T.TRANSPORT_MODE
                      , T.FCST_TYPE
                      , TT1.COLUMN_NAME                 AS MEASURE
                      , TT1.COLUMN_LABEL_NAME           AS MEASURE_NAME
                      , TT1.ATTRIBUTE3                  AS BACK_COLOR
                      , TT1.SORT_ORDER_NO               AS SEQ
                      , T.YYYYMMDD
                   FROM GT_0026_ROWDATA         T
                      , SCM_MST_SHEET_MEASURE   TT1
                  WHERE TT1.PROGRAM_ID = C_PROGRAM_ID
--                  AND TT1.SHEET_NAME = P_SHEET_NAME  /* AJS 20261007 화면검증 */
                    AND TT1.SHEET_NAME = V_SHEET_NAME  /* AJS 20261007 화면검증 */
               )  IB
             , GT_0026_ROWDATA  S
         WHERE S.DIVISION_ID(+) = IB.DIVISION_ID
           AND S.ITEM_ID(+)     = IB.ITEM_ID
           AND S.MEASURE(+)     = IB.MEASURE
           AND S.YYYYMMDD(+)    = IB.YYYYMMDD
           AND S.FROM_SITE(+)   = IB.FROM_SITE
           AND S.TO_SITE(+)     = IB.TO_SITE
           AND S.BOD_ID(+)      = IB.BOD_ID
           /*AND S.FCST_TYPE(+) = IB.FCST_TYPE*/
           AND IB.TO_SITE      <> '-'
           AND IB.MEASURE       IN ('SCP_SHIP_PLAN', 'SHIP_REQ', 'SHIP_PLAN');

        /* 피벗 앞 단계 */
        INSERT INTO GT_0026_PIVOT_TEMP
             ( DIVISION_ID, ITEM_ID, DEPT_NAME_KO, DEPT_ID, FROM_SITE, TO_SITE, SOLDTO_CUSTOMER
             , MEASURE, BOD_ID, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, INCOTERMS, TRANSPORT_MODE
             , FCST_TYPE, SEQ, ROW_NUM )
        SELECT /*+ NO_MERGE(C) NO_MERGE(E) NO_PUSH_PRED(C) NO_PUSH_PRED(E) */ DISTINCT
               A.DIVISION_ID
             , A.ITEM_ID
             , E.DEPT_NAME_KO
             , E.DEPT_ID
             , A.FROM_SITE
             , A.TO_SITE
             , D.SOLDTO_CUSTOMER
             , A.MEASURE
             , A.BOD_ID
             , 'D_' || A.YYYYMMDD                               AS YYYYMMDD
             , B.BASIS_YYYYMM                                   AS YYYYMM
             , SUBSTR(B.BASIS_YYYYMM, 3, 4) || B.ISO_WEEK       AS ISO_WEEK
             , A.QTY
             , A.INCOTERMS
             , A.TRANSPORT_MODE
             /*, A.FCST_TYPE*/
             , '-'                                              AS FCST_TYPE
             , A.SEQ
             , RANK() OVER (PARTITION BY A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, A.MEASURE, A.BOD_ID
                                ORDER BY A.MEASURE
                                       , CASE WHEN A.YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END DESC) AS ROW_NUM
          FROM GT_0026_RESULT      A
             , SCM_SYS_CALENDAR_M  B
             , ( SELECT MAX(PROJECT_CODE)   AS PROJECT_CODE
                      , ITEM_ID
                      , SCM_SITE_ID
                      , DIVISION_ID
                      , MAX(OWNER)          AS OWNER
                      /* AS-IS 는 담당자 목록의 첫 토큰만 쓴다(TOP 1). 첫 토큰을 칸으로 뽑아 둔다. */
                      , SUBSTR(MAX(OWNER), 1, CASE WHEN INSTR(MAX(OWNER), ',') > 0
                                                   THEN INSTR(MAX(OWNER), ',') - 1
                                                   ELSE LENGTH(MAX(OWNER)) END)   AS FIRST_OWNER
                   FROM SCM_MST_SITE_ITEM
                  WHERE VALID_YN = 'Y'
                  GROUP BY ITEM_ID
                         , SCM_SITE_ID
                         , DIVISION_ID
               )  C
             , SCM_MST_SITE        D
             , ( SELECT B.USER_ID
                      , B.USER_NAME
                      , B.USER_NAME_EN
                      , B.DEPT_ID
                      , C.DEPT_NAME_KO
                   FROM SCM_MST_SSO_USER_INFO  B
                      , SCM_MST_SSO_DEPT_INFO  C
                  WHERE B.DEPT_ID = C.DEPT_ID
               )  E
         WHERE A.YYYYMMDD         = B.BASIS_YYYYMMDD(+)
           AND C.DIVISION_ID(+)   = A.DIVISION_ID
           AND UPPER(C.SCM_SITE_ID(+)) = UPPER(A.TO_SITE)
           AND UPPER(C.ITEM_ID(+)) = RTRIM(A.ITEM_ID)                    /* 사이트품목 품목 소문자 258건 · 생산계획 품목 뒤 공백 5,815건 */
           AND A.DIVISION_ID      = D.DIVISION_ID(+)
           AND UPPER(A.TO_SITE)   = UPPER(D.SCM_SITE_ID(+))
           AND D.VALID_YN(+)      = 'Y'
           AND UPPER(E.USER_ID(+)) = UPPER(C.FIRST_OWNER)                /* 담당자 아이디는 양쪽 모두 소문자가 섞여 있다 */
           AND 1 = 1;

        /* 조회조건으로 품목을 좁힌다 */
        INSERT INTO GT_0026_PIVOT
             ( DIVISION_ID, ITEM_ID, DEPT_NAME_KO, DEPT_ID, FROM_SITE, TO_SITE, SOLDTO_CUSTOMER
             , MEASURE, BOD_ID, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, INCOTERMS, TRANSPORT_MODE
             , FCST_TYPE, SEQ, SHIP_FROZEN, ROW_NUM )
        SELECT DIVISION_ID, ITEM_ID, DEPT_NAME_KO, DEPT_ID, FROM_SITE, TO_SITE, SOLDTO_CUSTOMER
             , MEASURE, BOD_ID, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, INCOTERMS, TRANSPORT_MODE
             , FCST_TYPE, SEQ, SHIP_FROZEN, ROW_NUM
          FROM GT_0026_PIVOT_TEMP
         WHERE ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                              FROM GT_0026_PIVOT_TEMP
                             WHERE 1 = 1
--                             AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                               AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                   OR FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                                     OR FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--                             AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                               AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                   OR UPPER(TO_SITE) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                                     OR UPPER(TO_SITE) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--                             AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
                               AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--                                   OR UPPER(RTRIM(SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
                                     OR UPPER(RTRIM(SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
--                             AND ( TRIM(P_TEAM_ID) IS NULL  /* AJS 20261007 화면검증 */
                               AND ( TRIM(V_TEAM_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                   OR DEPT_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TEAM_ID, ','))) )  /* AJS 20261007 화면검증 */
                                     OR DEPT_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_TEAM_ID, ','))) )  /* AJS 20261007 화면검증 */
                               AND ( TRIM(P_ITEM_ID) IS NULL
                                     OR ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                          );

        /* 피벗 대상 날짜 칸 만들기 — 칸 수가 기간에 따라 달라지므로 이 부분만 동적 SQL */
        DBMS_LOB.CREATETEMPORARY(V_PIVOT, TRUE);
        FOR C IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'W_' || BASIS_YYYYMM || ISO_WEEK       AS YYYYMMDD
                                 , BASIS_START_DATE || '21'               AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMM
                                    , ISO_WEEK
                                    , BASIS_START_DATE
                             UNION ALL
                            SELECT 'M_' || BASIS_YYYYMM                   AS YYYYMMDD
                                 , MIN(BASIS_START_DATE) || '01'          AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMM
                                    , MONTH_NAME
                             UNION ALL
                            SELECT 'D_' || BASIS_YYYYMMDD                 AS YYYYMMDD
                                 , BASIS_YYYYMMDD || '31'                 AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMMDD
                          )  IA
                    ORDER BY SORT_ORDER_NO )
        LOOP
            IF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_PIVOT, ', CEIL(SUM(CASE WHEN T0.YYYYMM = ''' || SUBSTR(C.YYYYMMDD, -6)
                                || ''' THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_PIVOT, ', CEIL(SUM(CASE WHEN T0.ISO_WEEK = ''' || SUBSTR(C.YYYYMMDD, -6)
                                || ''' THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSE
                DBMS_LOB.APPEND(V_PIVOT, ', CEIL(SUM(CASE WHEN T0.YYYYMMDD = ''' || SUBSTR(C.YYYYMMDD, -10)
                                || ''' THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            END IF;
        END LOOP;

        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);
        DBMS_LOB.APPEND(V_SQL, 'SELECT DISTINCT TTT.* FROM (' || CHR(10)
          || '    SELECT T0.DIVISION_ID' || CHR(10)
          || '         , T0.ITEM_ID AS MODEL_ID' || CHR(10)
          || '         , NVL(IT.NICK_NAME, ''-'') AS NICK_NAME' || CHR(10)
          /* 20220221 SMS 수정 */
          || '         , TO_CHAR(SYSDATE + CASE WHEN (T4.SHIP_FROZEN - 1) > 0 THEN (T4.SHIP_FROZEN - 1) ELSE 0 END, ''YYYYMMDD'') AS CONFIRM_DAY' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.DEPT_NAME_KO, ''-'') ELSE ''-'' END AS TEAM_NAME_KO' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.DEPT_ID, ''-'') ELSE ''-'' END AS DEPT_ID' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.FROM_SITE, ''-'') ELSE ''-'' END AS FROM_SITE' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T4.SITE_DESCRIPTION, ''-'') ELSE ''-'' END AS SITE_DESCRIPTION' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.TO_SITE, ''-'') ELSE ''-'' END AS TO_SITE' || CHR(10)
          || '         , T0.MEASURE' || CHR(10)
          || '         , T2.SORT_ORDER_NO AS SORT_ORDER_NO' || CHR(10)
          || '         , ''-'' AS BOD_ID' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.INCOTERMS, ''-'') ELSE ''-'' END AS INCOTERMS' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.TRANSPORT_MODE, ''-'') ELSE ''-'' END AS TR_MODE' || CHR(10)
          || '         , ''-'' AS FCST_TYPE' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.SOLDTO_CUSTOMER, ''-'') ELSE ''-'' END AS END_CUSTOMER' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '         , CASE WHEN TRIM(C.USERNAME) IS NOT NULL THEN C.USERNAME || ''('' || R.LAST_UPDATED_BY || '')'' ELSE NVL(R.LAST_UPDATED_BY, ''-'') END AS LAST_UPDATED_BY' || CHR(10));
          || '         , CASE WHEN TRIM(C.USER_NM) IS NOT NULL THEN C.USER_NM || ''('' || R.LAST_UPDATED_BY || '')'' ELSE NVL(R.LAST_UPDATED_BY, ''-'') END AS LAST_UPDATED_BY' || CHR(10));
          /* 2026.09.30 AJS 수정 (END) */
        DBMS_LOB.APPEND(V_SQL, V_PIVOT);
        DBMS_LOB.APPEND(V_SQL,
             '      FROM GT_0026_PIVOT           T0' || CHR(10)
          || '         , SCM_MST_SHEET_MEASURE   T2' || CHR(10)
          || '         , SCM_MST_SITE            T4' || CHR(10)
          || '         , ( SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME' || CHR(10)
          || '               FROM SCM_MST_ITEM_SN' || CHR(10)
          || '              WHERE DIVISION_ID = :B_DIV' || CHR(10)
          || '                AND ACTIVE_FLAG = ''Y''' || CHR(10)
          || '                AND SCP_OPERATION_GROUP = ''P'' ) IT' || CHR(10)   /* CELL/PACK 구분 */
          || '         , GT_0026_REQUESTOR       R' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '         , TB_FX_USER              C' || CHR(10)
          || '         , SCM_ADM_USER_M          C' || CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '     WHERE T0.MEASURE            = T2.COLUMN_NAME' || CHR(10)
          || '       AND T2.PROGRAM_ID         = :B_PGM' || CHR(10)
          || '       AND T2.SHEET_NAME         = :B_SHT' || CHR(10)
          || '       AND T0.DIVISION_ID        = T4.DIVISION_ID(+)' || CHR(10)
          || '       AND T0.FROM_SITE          = T4.SCM_SITE_ID(+)' || CHR(10)
          || '       AND T4.VALID_YN(+)        = ''Y''' || CHR(10)
          || '       AND T0.DIVISION_ID        = IT.DIVISION_ID' || CHR(10)
          || '       AND IT.ITEM_ID            = RTRIM(T0.ITEM_ID)' || CHR(10)
          || '       AND R.DIVISION_ID(+)      = T0.DIVISION_ID' || CHR(10)
          || '       AND R.ITEM_ID(+)          = T0.ITEM_ID' || CHR(10)
          || '       AND R.FROM_SITE(+)        = T0.FROM_SITE' || CHR(10)
          || '       AND R.TO_SITE(+)          = T0.TO_SITE' || CHR(10)
          || '       AND R.BOD_ID(+)           = T0.BOD_ID' || CHR(10)
          || '       AND R.MEASURE(+)          = T0.MEASURE' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '       AND R.LAST_UPDATED_BY     = C.USERID(+)' || CHR(10)
          || '       AND R.LAST_UPDATED_BY     = C.USER_ID(+)' || CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '       AND 1 = 1' || CHR(10)
          || '       AND T2.VALID_YN           = ''Y''' || CHR(10)
          || '       AND T0.ROW_NUM            = 1' || CHR(10)
          || '       AND ( :B_CNT1 = 0' || CHR(10)
          || '             OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER' || CHR(10)
          || '                         WHERE PROGRAM_ID = :B_PGM2 AND SHEET_NAME = :B_SHT2 AND USER_ID = :B_USR' || CHR(10)
          || '                           AND COLUMN_NAME = T2.COLUMN_NAME) )' || CHR(10)
          || '       AND ( ( :B_CNT2 = 0 AND T2.DEFAULT_FLAG = ''Y'' )' || CHR(10)
          || '             OR ( :B_CNT3 <> 0 ) )' || CHR(10)
          || '       AND T2.COLUMN_NAME        = T0.MEASURE' || CHR(10)
          || '     GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.DEPT_NAME_KO, T0.DEPT_ID' || CHR(10)
          || '            , T0.FROM_SITE, T4.SITE_DESCRIPTION, T4.SHIP_FROZEN, T0.TO_SITE, T0.MEASURE' || CHR(10)
          || '            , T0.BOD_ID, T0.INCOTERMS, T0.TRANSPORT_MODE, T0.SOLDTO_CUSTOMER' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '            , R.LAST_UPDATED_BY, C.USERNAME, T2.SORT_ORDER_NO' || CHR(10)
          || '            , R.LAST_UPDATED_BY, C.USER_NM, T2.SORT_ORDER_NO' || CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || ') TTT' || CHR(10)
          || ' ORDER BY FN_ASIS_SORT_KEY(TTT.DIVISION_ID) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.MODEL_ID) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.FROM_SITE) DESC NULLS LAST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.TO_SITE) DESC NULLS LAST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.INCOTERMS) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.TR_MODE) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.FCST_TYPE) NULLS FIRST' || CHR(10)
          || '        , TTT.SORT_ORDER_NO' || CHR(10));

        OPEN O_RC1 FOR V_SQL
--        USING V_DIVISION_ID, C_PROGRAM_ID, P_SHEET_NAME  /* AJS 20261007 화면검증 */
          USING V_DIVISION_ID, C_PROGRAM_ID, V_SHEET_NAME  /* AJS 20261007 화면검증 */
--            , V_CNT_USR_MEASURE, C_PROGRAM_ID, P_SHEET_NAME, P_CREATED_BY  /* AJS 20261007 화면검증 */
              , V_CNT_USR_MEASURE, C_PROGRAM_ID, V_SHEET_NAME, P_CREATED_BY  /* AJS 20261007 화면검증 */
              , V_CNT_USR_MEASURE, V_CNT_USR_MEASURE;

        DBMS_LOB.FREETEMPORARY(V_PIVOT);
        DBMS_LOB.FREETEMPORARY(V_SQL);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_SHIPMENT_REQUEST_PACK;

    /*******************************************************************************
     * P_SSP0026_GET_SHIPMENT_REQUEST_CELL
     *   AS-IS SSP0026_GET_SHIPMENT_REQUEST_CELL
     *   Cell 출하 지시 본표 (측정값 10 종 × 일 · 주 · 월 피벗)
     *
     * 측정값
     *   1 SCP_SHIP_PLAN  SCP 출하계획   2 SHIP_REQ  출하지시      3 SHIP_PLAN  출하계획
     *   4 POSTP_PLAN     후공정 계획    5 SITE_MOVE 사이트 이동   6 WH_IN      창고 입고
     *   7 TOTAL_PLAN     계획 합계      8 TOTAL_REQ 지시 합계
     *   9 WH_BOH_PLAN    창고 기초재고(계획)   10 WH_BOH_REQ 창고 기초재고(지시)
     *
     * ★Pack 판과 달리 AS-IS 가 수정일시를 날짜 칸으로 잡으므로 날짜 순으로 견준다.
     * ★측정값이 10 개 미만인 품목 · 사이트는 화면에 내지 않는다(AS-IS 주석 그대로).
     * ★피벗 칸 수가 조회 기간에 따라 달라지므로 이 조회만 동적 SQL 을 쓴다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_GET_SHIPMENT_REQUEST_CELL
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_ID                CONSTANT VARCHAR2(50 CHAR) := 'SSP0026';
        V_DIVISION_ID               VARCHAR2(30 CHAR)  := UPPER(P_DIVISION_ID);
        V_FROM_YYYYMMDD             VARCHAR2(8 CHAR)   := P_FROM_YYYYMMDD;
        V_TO_YYYYMMDD               VARCHAR2(8 CHAR)   := P_TO_YYYYMMDD;
        V_YESTERDAY                 VARCHAR2(8 CHAR)   := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
        V_TODAY                     VARCHAR2(8 CHAR)   := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_CNT_USR_MEASURE           PLS_INTEGER        := 0;
        V_SCP_PLAN_START_YYYYMMDD   VARCHAR2(32 CHAR);
        V_SCP_PLAN_TYPE             VARCHAR2(30 CHAR);
        V_SCP_SEQ                   NUMBER;
        V_LAST_PLAN_START_YYYYMMDD  VARCHAR2(32 CHAR)  := '';
        V_LAST_PLAN_TYPE            VARCHAR2(30 CHAR)  := 'SP';
        V_LAST_SEQ                  NUMBER             := 0;
        V_PIVOT                     CLOB;
        V_SQL                       CLOB;
        V_ERR_MSG                   VARCHAR2(4000 CHAR);
        /* 2026.10.07 AJS 화면검증 (START) : 화면 전달값 정규화 — 시트 이름은 버튼 등록 시트(pack · cell)를 지표 시트 이름으로, 조회조건 ALL 은 조건 없음 */
        V_SHEET_NAME                VARCHAR2(100 CHAR)   := CASE LOWER(TRIM(P_SHEET_NAME)) WHEN 'pack' THEN 'Pack Biz' WHEN 'cell' THEN 'Cell Biz' ELSE P_SHEET_NAME END;
        V_TEAM_ID                   VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_TEAM_ID)) = 'ALL' THEN NULL ELSE P_TEAM_ID END;
        V_CUSTOMER                  VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_CUSTOMER)) = 'ALL' THEN NULL ELSE P_CUSTOMER END;
        V_SCM_SITE_ID               VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_SCM_SITE_ID)) = 'ALL' THEN NULL ELSE P_SCM_SITE_ID END;
        V_PLANT_SITE_ID             VARCHAR2(32767 CHAR) := CASE WHEN UPPER(TRIM(P_PLANT_SITE_ID)) = 'ALL' THEN NULL ELSE P_PLANT_SITE_ID END;
        /* 2026.10.07 AJS 화면검증 (END) */
    BEGIN

        /* 임시 테이블 초기화 (TRUNCATE 는 암묵 커밋이라 쓰지 않음) */
        DELETE FROM GT_0026_ROWDATA;
        DELETE FROM GT_0026_RESULT;
        DELETE FROM GT_0026_REQUESTOR;
        DELETE FROM GT_0026_PIVOT_TEMP;
        DELETE FROM GT_0026_PIVOT;
        DELETE FROM GT_0026C_STD40;
        DELETE FROM GT_0026C_Z;
        DELETE FROM GT_0026C_QTY;
        DELETE FROM GT_0026C_BOH;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = C_PROGRAM_ID
--         AND SHEET_NAME = P_SHEET_NAME  /* AJS 20261007 화면검증 */
           AND SHEET_NAME = V_SHEET_NAME  /* AJS 20261007 화면검증 */
           AND USER_ID    = P_CREATED_BY;

        /* SCP 최종 계획 버전 */
        BEGIN
            SELECT PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , PLAN_SEQ
              INTO V_SCP_PLAN_START_YYYYMMDD
                 , V_SCP_PLAN_TYPE
                 , V_SCP_SEQ
              FROM ( SELECT PLAN_START_YYYYMMDD
                          , PLAN_TYPE
                          , PLAN_SEQ
                       FROM SCP_PLAN_VERSION_V
                      WHERE 1 = 1
                        AND DIVISION_ID = V_DIVISION_ID
                        AND PLAN_CYCLE  = 'WEEKLY'
                        AND PLAN_TYPE   = 'FN'
                      ORDER BY PLAN_START_YYYYMMDD DESC
                             , PLAN_TYPE_ORDER      DESC
                             , PLAN_SEQ             DESC
                   )  IA
             WHERE ROWNUM <= 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_SCP_PLAN_START_YYYYMMDD := NULL;
                V_SCP_PLAN_TYPE           := NULL;
                V_SCP_SEQ                 := NULL;
        END;

        /*가장 최근 출하계획 버전 확인*/
        SELECT MAX(PLAN_START_YYYYMMDD)
             , MAX(PLAN_SEQ)
             , MAX(PLAN_TYPE)
          INTO V_LAST_PLAN_START_YYYYMMDD
             , V_LAST_SEQ
             , V_LAST_PLAN_TYPE
          FROM SSP_PLAN_VERSION_V
         WHERE PLAN_TYPE    = 'SP'
           AND DIVISION_ID  = V_DIVISION_ID
           AND CONFIRM_FLAG = 'Y';

        /* SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다. */
        INSERT INTO GT_0026C_STD40
             ( DIVISION_ID, FROM_SITE, PLAN_START_YYYYMMDD )
        SELECT DISTINCT
               DIVISION_ID
             , FROM_SITE
             , PLAN_START_YYYYMMDD
          FROM ( SELECT SP.DIVISION_ID
                      , SP.FROM_SITE
                      , SP.PLAN_START_YYYYMMDD
                      , RANK() OVER (PARTITION BY SP.FROM_SITE ORDER BY SP.PLAN_START_YYYYMMDD DESC) AS RNK
                   FROM SSP_ANL_SHIP_PLAN_40 SP
                  WHERE SP.DIVISION_ID          = V_DIVISION_ID
                    AND SP.PLAN_START_YYYYMMDD >= V_YESTERDAY     /* 전일 */
                    AND SP.PLAN_START_YYYYMMDD <= V_TODAY         /* 당일 */
                    AND SP.QTY                  > 0
               )  IA
         WHERE RNK = 1;

        /*SCP_SHIP_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT /*+ NO_MERGE(IA) NO_PUSH_PRED(IA) */
               IA.DIVISION_ID
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , 'SCP_SHIP_PLAN'                  AS MEASURE
             , IA.YYYYMMDD
             , IA.BOD_ID
             , IA.QTY
             /* 20201223 incoterms 변경 작업 modify KIMYONGHO */
             , F.SSP_INCOTERMS                  AS INCOTERMS
             , F.TRANSPORT_MODE
             , IA.FCST_TYPE
             , 1                                AS SEQ
             , IA.LAST_UPDATED_BY
             , IA.LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM ( SELECT DIVISION_ID
                      , PLAN_START_YYYYMMDD
                      , PLAN_TYPE
                      , SEQ
                      , MAX(OPERATION_GROUP)    AS BIZ_TYPE
                      , FCST_TYPE
                      , ITEM_ID
                      , TO_SITE
                      /* , INCOTERMS */
                      , FROM_SITE
                      , BOD_ID
                      , TRANSPORT_MODE
                      , MEASURE
                      , YYYYMMDD
                      , SUM(QTY)                AS QTY
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                   FROM ( SELECT /*+ LEADING(B A C) USE_HASH(A) USE_NL(C) */
                                 B.DIVISION_ID
                               , B.PLAN_START_YYYYMMDD
                               , B.PLAN_TYPE
                               , B.SEQ
                               , B.OPERATION_GROUP
                               , A.FCST_TYPE
                               , B.ITEM_ID
                               , B.TO_SITE
                               , B.FROM_SITE
                               , B.BOD_ID
                               , B.TRANSPORT_MODE
                               , B.MEASURE
                               , B.YYYYMMDD
                               , A.ALLOCATION_QTY           AS QTY
                               , REPLACE(B.LAST_UPDATED_BY, 'scp_batch', 'System') AS LAST_UPDATED_BY
                               , B.LAST_UPDATE_DATE
                            FROM SCP_PLN_SHIPMENT_PLAN           B
                               , SCP_PLN_SHIPMENT_PLAN_PEGGING   A
                               , SCM_MST_SITE                    C
                           WHERE A.MASTER_ID             = B.MASTER_ID
                             AND A.PLAN_ID               = B.PLAN_ID
                             AND A.OUT_VERSION_ID        = B.OUT_VERSION_ID
                             AND A.DIVISION_ID           = B.DIVISION_ID
                             AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD
                             AND A.PLAN_TYPE             = B.PLAN_TYPE
                             AND A.SEQ                   = B.SEQ
                             AND A.ORDER_ID              = B.ORDER_ID
                             AND B.DIVISION_ID           = C.DIVISION_ID
                             AND B.TO_SITE               = C.SCM_SITE_ID
                             AND C.VALID_YN              = 'Y'
                             AND C.OPERATION_GROUP       IS NULL
                             AND 1 = 1
                             AND B.MEASURE               = 'SHIP_PLAN'
                             AND B.SEMI_YN               = 'N'
                             AND B.OPERATION_GROUP       = 'A'
                             AND B.DIVISION_ID           = V_DIVISION_ID
                             AND B.PLAN_START_YYYYMMDD   = V_SCP_PLAN_START_YYYYMMDD
                             AND B.PLAN_TYPE             = V_SCP_PLAN_TYPE
                             AND B.SEQ                   = V_SCP_SEQ
                             AND B.YYYYMMDD             >= V_FROM_YYYYMMDD
                             AND B.YYYYMMDD             <= V_TO_YYYYMMDD
                             AND ( TRIM(P_ITEM_ID) IS NULL
                                   OR B.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--                           AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                             AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                 OR B.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                                   OR B.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--                           AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                             AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                 OR B.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                                   OR B.TO_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--                           AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
                             AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--                                 OR UPPER(RTRIM(C.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
                                   OR UPPER(RTRIM(C.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
                        )  XA
                  GROUP BY DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , SEQ
                         , FCST_TYPE
                         , ITEM_ID
                         , TO_SITE
                        /* , INCOTERMS */
                         , FROM_SITE
                         , TRANSPORT_MODE
                         , BOD_ID
                         , MEASURE
                         , YYYYMMDD
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
               )  IA
             , SCP_MST_BOD_N_V  F
         WHERE F.DIVISION_ID(+) = IA.DIVISION_ID
           AND F.BOD_ID(+)      = IA.BOD_ID
           AND F.DIVISION_ID(+) = V_DIVISION_ID
           AND F.BOD_TYPE(+)    = 'SALES'
           AND IA.DIVISION_ID   = V_DIVISION_ID
           AND IA.MEASURE       = 'SHIP_PLAN';

        /*SHIP_REQ Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.PLANT_SITE_ID                  AS FROM_SITE
             , A.SCM_SITE_ID                    AS TO_SITE
             , 'SHIP_REQ'                       AS MEASURE
             , A.YYYYMMDD
             , A.BOD_ID
             , A.QTY
             , A.INCOTERMS
             , A.TRANSPORT_MODE
             , A.FCST_TYPE
             , 2                                AS SEQ
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM DM_PLN_SHIPMENT_REQ  A
             , SCP_MST_BOD_N_V      C
             , SCM_MST_SITE         T4
         WHERE C.DIVISION_ID(+)  = A.DIVISION_ID
           AND C.BOD_ID(+)       = A.BOD_ID
           AND C.DIVISION_ID(+)  = V_DIVISION_ID
           AND C.BOD_TYPE(+)     = 'SALES'
           AND A.DIVISION_ID     = T4.DIVISION_ID(+)
           AND A.SCM_SITE_ID     = T4.SCM_SITE_ID(+)
           AND T4.VALID_YN(+)    = 'Y'
           AND 1 = 1
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND A.MEASURE         = 'SHIP_REQ'
           AND A.YYYYMMDD       >= V_FROM_YYYYMMDD
           AND A.YYYYMMDD       <= V_TO_YYYYMMDD
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--         AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR A.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR A.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(A.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR UPPER(A.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(RTRIM(T4.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) );  /* AJS 20261007 화면검증 */
                 OR UPPER(RTRIM(T4.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) );  /* AJS 20261007 화면검증 */

        /*SHIP_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT SSP.DIVISION_ID
             , SSP.ITEM_ID
             , SSP.FROM_SITE
             , SSP.TO_SITE
             , 'SHIP_PLAN'                      AS MEASURE
             , SSP.YYYYMMDD
             , BOD.BOD_ID
             , SSP.QTY
             /* 20201223 incoterms 변경 작업 modify KIMYONGHO */
             , BOD.SSP_INCOTERMS                AS INCOTERMS
             , BOD.TRANSPORT_MODE                AS TR_MODE
             , SSP.FCST_TYPE
             , 3                                AS SEQ
             , '-'                              AS LAST_UPDATED_BY
             , SSP.LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_CONFIRM  SSP
             , ( SELECT DISTINCT DIVISION_ID
                      , ITEM_ID
                      , SCP_OPERATION_GROUP
                   FROM SCM_MST_ITEM_SN
                  WHERE DIVISION_ID         = V_DIVISION_ID
                    AND SCP_OPERATION_GROUP = 'A'      /* CELL/PACK 구분 */
                    AND ACTIVE_FLAG         = 'Y'
               )  IT
             , SCM_MST_SITE         TS
             , SCP_MST_BOD_N_V      BOD
         WHERE SSP.DIVISION_ID = IT.DIVISION_ID
           AND SSP.ITEM_ID     = IT.ITEM_ID
           AND SSP.DIVISION_ID = TS.DIVISION_ID
           AND SSP.TO_SITE     = TS.SCM_SITE_ID
           AND SSP.DIVISION_ID = BOD.DIVISION_ID
           AND SSP.BOD_ID      = BOD.BOD_ID
           AND TS.VALID_YN     = 'Y'
           AND TS.SITE_TYPE    = 'SALES'
           AND SSP.DIVISION_ID = V_DIVISION_ID       /* 변수 */
           AND SSP.QTY         > 0
           AND SSP.YYYYMMDD   >= V_FROM_YYYYMMDD
           AND SSP.YYYYMMDD   <= V_TO_YYYYMMDD
           AND SSP.CHANGE_TYPE = 'C'
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR SSP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--         AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR SSP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR SSP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(SSP.TO_SITE) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR UPPER(SSP.TO_SITE) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(RTRIM(TS.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
                 OR UPPER(RTRIM(TS.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) )  /* AJS 20261007 화면검증 */
         UNION ALL
        SELECT P.DIVISION_ID
             , P.ITEM_ID
             , P.PLANT_SITE_ID                  AS FROM_SITE
             , P.SCM_SITE_ID                    AS TO_SITE
             , 'SHIP_PLAN'                      AS MEASURE
             , P.YYYYMMDD
             , P.BOD_ID
             , P.QTY
             , P.INCOTERMS
             , P.TRANSPORT_MODE
             , P.FCST_TYPE
             , 3                                AS SEQ
             , '-'                              AS LAST_UPDATED_BY
             , P.LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM DM_PLN_SHIPMENT_REQ  P
             , SCM_MST_SITE         FZ
             , SCM_MST_SITE         T4
         WHERE P.DIVISION_ID    = FZ.DIVISION_ID(+)
           AND P.PLANT_SITE_ID  = FZ.SCM_SITE_ID(+)
           AND FZ.VALID_YN(+)   = 'Y'
           AND P.DIVISION_ID    = T4.DIVISION_ID(+)
           AND P.SCM_SITE_ID    = T4.SCM_SITE_ID(+)
           AND T4.VALID_YN(+)   = 'Y'
           AND T4.SITE_TYPE(+)  = 'SALES'
           AND P.DIVISION_ID    = V_DIVISION_ID
           /* 확정구간의 다음날짜가 나오므로 >= 로 처리함 */
           AND P.YYYYMMDD      >= TO_CHAR(SYSDATE + NVL(FZ.SHIP_FROZEN, 0), 'YYYYMMDD')
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR P.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--         AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR P.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR P.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(P.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR UPPER(P.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
--         AND ( TRIM(P_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_CUSTOMER) IS NULL  /* AJS 20261007 화면검증 */
--               OR UPPER(RTRIM(T4.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_CUSTOMER, ','))) );  /* AJS 20261007 화면검증 */
                 OR UPPER(RTRIM(T4.SOLDTO_CUSTOMER)) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_CUSTOMER, ','))) );  /* AJS 20261007 화면검증 */

        /*POSTP_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT DIVISION_ID                      AS DIVISION_ID
             , CELL_ITEM_ID                     AS ITEM_ID
             , SCM_SITE_ID                      AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'POSTP_PLAN'                     AS MEASURE
             , PLAN_DATE                        AS YYYYMMDD
             , '-'                              AS BOD_ID
             , SUM(PLAN_QTY)                    AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 4                                AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_DNM_FORMATION_POST_CELL
         WHERE DIVISION_ID = V_DIVISION_ID
           AND PLAN_DATE  >= V_FROM_YYYYMMDD
           AND PLAN_DATE   < V_TO_YYYYMMDD
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR CELL_ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
         GROUP BY DIVISION_ID
                , CELL_ITEM_ID
                , SCM_SITE_ID
                , PLAN_DATE;

        /*SITE_MOVE Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT SSP.DIVISION_ID
             , SSP.ITEM_ID
             , SSP.FROM_SITE                    AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'SITE_MOVE'                      AS MEASURE
             , SSP.YYYYMMDD
             , NULL                             AS BOD_ID
             , SSP.QTY
             , NULL                             AS INCOTERMS
             , NULL                             AS TRANSPORT_MODE
             , NULL                             AS FCST_TYPE
             , 5                                AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_CONFIRM  SSP
             , SCM_MST_SITE          TS
             , SCM_MST_SITE          FS
         WHERE SSP.DIVISION_ID = TS.DIVISION_ID
           AND SSP.TO_SITE     = TS.SCM_SITE_ID
           AND SSP.DIVISION_ID = FS.DIVISION_ID
           AND SSP.FROM_SITE   = FS.SCM_SITE_ID
           AND TS.SITE_TYPE    = 'PLANT'
           AND TS.VALID_YN     = 'Y'
           AND FS.VALID_YN     = 'Y'
           AND 1 = 1
           AND TS.PLANT_ID    <> FS.PLANT_ID
           AND SSP.DIVISION_ID = V_DIVISION_ID
           AND SSP.QTY         > 0
           AND SSP.YYYYMMDD   >= V_FROM_YYYYMMDD
           AND SSP.YYYYMMDD   <= V_TO_YYYYMMDD
           AND SSP.BIZ_TYPE    = 'A'
           AND SSP.CHANGE_TYPE = 'C'
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR SSP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
         UNION ALL
        SELECT R.DIVISION_ID
             , R.ITEM_ID
             , R.PLANT_SITE_ID                  AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'SITE_MOVE'                      AS MEASURE
             , R.YYYYMMDD
             , NULL                             AS BOD_ID
             , R.QTY
             , NULL                             AS INCOTERMS
             , NULL                             AS TRANSPORT_MODE
             , NULL                             AS FCST_TYPE
             , 5                                AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM DM_PLN_SHIPMENT_REQ  R
             , SCM_MST_SITE         FS
             , SCM_MST_SITE         TS
         WHERE FS.DIVISION_ID = R.DIVISION_ID
           AND FS.SCM_SITE_ID = R.PLANT_SITE_ID
           AND TS.DIVISION_ID = R.DIVISION_ID
           AND TS.SCM_SITE_ID = R.SCM_SITE_ID
           AND FS.SITE_TYPE       = 'PLANT'
           AND FS.OPERATION_GROUP = 'A'
           AND FS.OSP_YN          = 'N'
           AND FS.VALID_YN        = 'Y'
           AND TS.SITE_TYPE       = 'PLANT'
           AND TS.VALID_YN        = 'Y'
           AND 1 = 1
           AND TS.PLANT_ID   <> FS.PLANT_ID
           AND R.DIVISION_ID  = V_DIVISION_ID
           AND R.MEASURE      = 'SHIP_REQ'
           AND R.YYYYMMDD    >= V_FROM_YYYYMMDD
           AND R.YYYYMMDD    <= V_TO_YYYYMMDD
           AND R.QTY          > 0
           AND R.YYYYMMDD    >= TO_CHAR(SYSDATE + NVL(FS.SHIP_FROZEN, 0), 'YYYYMMDD')
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR R.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );

        /*WH_IN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT T.DIVISION_ID
             , T.ITEM_ID
             , T.FROM_SITE
             , T.TO_SITE
             , 'WH_IN'                          AS MEASURE
             , T.YYYYMMDD
             , T.BOD_ID
             , T.QTY
             , T.INCOTERMS
             , T.TRANSPORT_MODE
             , T.FCST_TYPE
             , 6                                AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_PLAN_40  T
             , GT_0026C_STD40        ST
         WHERE ST.DIVISION_ID         = T.DIVISION_ID
           AND ST.FROM_SITE           = T.FROM_SITE
           AND ST.PLAN_START_YYYYMMDD = T.PLAN_START_YYYYMMDD
           AND T.DIVISION_ID          = V_DIVISION_ID
           AND T.MEASURE              = 'WH_IN'
           AND T.YYYYMMDD            >= V_FROM_YYYYMMDD
           AND T.YYYYMMDD            <= V_TO_YYYYMMDD
           AND T.BIZ_TYPE             = 'A'
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR T.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--         AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR T.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) );  /* AJS 20261007 화면검증 */
                 OR T.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) );  /* AJS 20261007 화면검증 */

        /*TOTAL_PLAN Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE                        AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'TOTAL_PLAN'                     AS MEASURE
             , YYYYMMDD
             , NULL                             AS BOD_ID
             , SUM(QTY)                         AS QTY
             , NULL                             AS INCOTERMS
             , NULL                             AS TRANSPORT_MODE
             , NULL                             AS FCST_TYPE
             , 7                                AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM ( SELECT SSP.DIVISION_ID
                      , SSP.FROM_SITE
                      , SSP.ITEM_ID
                      , SSP.YYYYMMDD
                      , SSP.QTY
                   FROM SSP_ANL_SHIP_CONFIRM  SSP
                      , ( SELECT DISTINCT DIVISION_ID
                               , ITEM_ID
                               , SCP_OPERATION_GROUP
                            FROM SCM_MST_ITEM_SN
                           WHERE DIVISION_ID         = V_DIVISION_ID
                             AND SCP_OPERATION_GROUP = 'A'    /* CELL/PACK 구분 */
                             AND ACTIVE_FLAG         = 'Y'
                        )  IT
                  WHERE SSP.DIVISION_ID = IT.DIVISION_ID
                    AND SSP.ITEM_ID     = IT.ITEM_ID
                    AND SSP.DIVISION_ID = V_DIVISION_ID
                    AND SSP.YYYYMMDD   >= V_FROM_YYYYMMDD
                    AND SSP.YYYYMMDD   <= V_TO_YYYYMMDD
                    AND SSP.CHANGE_TYPE = 'C'
                    AND SSP.QTY         > 0
                    AND ( TRIM(P_ITEM_ID) IS NULL
                          OR SSP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--                  AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                    AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                        OR SSP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                          OR SSP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                  UNION ALL
                 SELECT P.DIVISION_ID
                      , P.PLANT_SITE_ID         AS FROM_SITE
                      , P.ITEM_ID
                      , P.YYYYMMDD
                      , P.QTY
                   FROM DM_PLN_SHIPMENT_REQ  P
                      , SCM_MST_SITE         FZ
                  WHERE P.DIVISION_ID   = FZ.DIVISION_ID(+)
                    AND P.PLANT_SITE_ID = FZ.SCM_SITE_ID(+)
                    AND FZ.VALID_YN(+)  = 'Y'
                    AND P.DIVISION_ID   = V_DIVISION_ID
                    /* 확정구간의 다음날짜가 나오므로 >= 로 처리함 */
                    AND P.YYYYMMDD     >= TO_CHAR(SYSDATE + NVL(FZ.SHIP_FROZEN, 0), 'YYYYMMDD')
                    AND ( TRIM(P_ITEM_ID) IS NULL
                          OR P.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--                  AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                    AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                        OR P.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                          OR P.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
               )  IA
         GROUP BY DIVISION_ID
                , ITEM_ID
                , YYYYMMDD
                , FROM_SITE;

        /*TOTAL_REQ Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE                        AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'TOTAL_REQ'                      AS MEASURE
             , YYYYMMDD
             , NULL                             AS BOD_ID
             , SUM(QTY)                         AS QTY
             , NULL                             AS INCOTERMS
             , NULL                             AS TRANSPORT_MODE
             , NULL                             AS FCST_TYPE
             , 8                                AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM ( SELECT P.DIVISION_ID
                      , P.PLANT_SITE_ID         AS FROM_SITE
                      , P.ITEM_ID
                      , P.YYYYMMDD
                      , P.QTY
                   FROM DM_PLN_SHIPMENT_REQ  P
                  /* AS-IS 는 판매사이트 원장을 외부조인하면서 그 조건에 출하지시 원장의 칸을 함께 걸어 두었다.
                     조인한 결과를 쓰지 않으므로 결과에 영향이 없어 옮기지 않는다. */
                  WHERE P.DIVISION_ID = V_DIVISION_ID
                    AND P.YYYYMMDD   >= V_LAST_PLAN_START_YYYYMMDD
                    AND P.YYYYMMDD   <= V_TO_YYYYMMDD
                    AND ( TRIM(P_ITEM_ID) IS NULL
                          OR P.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--                  AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                    AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                        OR P.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                          OR P.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
               )  IA
         GROUP BY DIVISION_ID
                , ITEM_ID
                , YYYYMMDD
                , FROM_SITE;

        /* BOH 계산 : 날짜 판(Z) · 증감(QTY) · 기초재고(BOH) */
        INSERT INTO GT_0026C_Z
             ( DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD )
        SELECT /*+ NO_MERGE(R) NO_PUSH_PRED(R) */ DISTINCT
               R.DIVISION_ID
             , R.ITEM_ID
             , R.FROM_SITE
             , O.BASIS_YYYYMMDD                 AS YYYYMMDD
          FROM SCM_SYS_CALENDAR_M  O
             , ( SELECT DISTINCT DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                   FROM GT_0026_ROWDATA
               )  R
         WHERE O.BASIS_YYYYMMDD >= V_LAST_PLAN_START_YYYYMMDD
           AND O.BASIS_YYYYMMDD <= V_TO_YYYYMMDD;

        INSERT INTO GT_0026C_QTY
             ( DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD, PLAN_QTY, REQ_QTY )
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE
             , YYYYMMDD
             , NVL(SUM(CASE WHEN MEASURE = 'TOTAL_PLAN' THEN -1 * NVL(QTY, 0)
                            WHEN MEASURE = 'WH_IN'      THEN NVL(QTY, 0)
                            ELSE 0.0
                       END), 0)                 AS PLAN_QTY
             , NVL(SUM(CASE WHEN MEASURE = 'TOTAL_REQ' THEN -1 * NVL(QTY, 0)
                            WHEN MEASURE = 'WH_IN'     THEN NVL(QTY, 0)
                            ELSE 0.0
                       END), 0)                 AS REQ_QTY
          FROM GT_0026_ROWDATA
         WHERE 1 = 1
           AND MEASURE  IN ('TOTAL_PLAN', 'TOTAL_REQ', 'WH_IN')
           AND YYYYMMDD >= V_LAST_PLAN_START_YYYYMMDD
         GROUP BY DIVISION_ID
                , ITEM_ID
                , FROM_SITE
                , YYYYMMDD;

        /*BOH 계산시 사용할 재고 생성*/
        INSERT INTO GT_0026C_BOH
             ( DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD, QTY )
        SELECT /*+ NO_MERGE(IA) NO_PUSH_PRED(IA) */
               DIVISION_ID
             , ITEM_ID
             , FROM_SITE
             , YYYYMMDD
             , SUM(QTY)                         AS QTY
          FROM ( SELECT A.DIVISION_ID
                      , A.ITEM_ID
                      , A.FROM_SITE             AS FROM_SITE
                      , V_LAST_PLAN_START_YYYYMMDD AS YYYYMMDD
                      , SUM(NVL(A.QTY, 0))      AS QTY
                   FROM SSP_ANL_SHIP_PLAN_40  A
                      , GT_0026C_STD40         ST
                  WHERE ST.DIVISION_ID         = A.DIVISION_ID
                    AND ST.FROM_SITE           = A.FROM_SITE
                    AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                    AND 1 = 1
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.BIZ_TYPE    = 'A'
                    AND A.MEASURE     = 'WH_STOCK'
                    AND A.YYYYMMDD    = V_LAST_PLAN_START_YYYYMMDD
                    AND ( TRIM(P_ITEM_ID) IS NULL
                          OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--                  AND ( TRIM(P_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
                    AND ( TRIM(V_PLANT_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--                        OR A.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                          OR A.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                  GROUP BY A.DIVISION_ID
                         , A.FROM_SITE
                         , A.ITEM_ID
                         , A.YYYYMMDD
               )  IA
         WHERE 1 = 1
           AND DIVISION_ID = V_DIVISION_ID
--         AND ( TRIM(P_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
           AND ( TRIM(V_SCM_SITE_ID) IS NULL  /* AJS 20261007 화면검증 */
--               OR FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
                 OR FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))) )  /* AJS 20261007 화면검증 */
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
         GROUP BY DIVISION_ID
                , ITEM_ID
                , FROM_SITE
                , YYYYMMDD;

        /*WH_BOH_PLAN · WH_BOH_REQ Meausre 생성*/
        INSERT INTO GT_0026_ROWDATA
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK )
        SELECT Z.DIVISION_ID
             , Z.ITEM_ID                        AS ITEM_ID
             , Z.FROM_SITE                      AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'WH_BOH_PLAN'                    AS MEASURE
             , Z.YYYYMMDD                       AS YYYYMMDD
             , NULL                             AS BOD_ID
             , ( SELECT NVL(SUM(PLAN_QTY), 0)
                   FROM GT_0026C_QTY  X
                  WHERE 1 = 1
                    AND X.DIVISION_ID = Z.DIVISION_ID
                    AND X.ITEM_ID     = Z.ITEM_ID
                    AND X.FROM_SITE   = Z.FROM_SITE
                    AND X.YYYYMMDD    < Z.YYYYMMDD
               ) + NVL(BOH.QTY, 0)              AS QTY
             , NULL                             AS INCOTERMS
             , NULL                             AS TRANSPORT_MODE
             , NULL                             AS FCST_TYPE
             , 10                               AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM GT_0026C_Z    Z
             , GT_0026C_BOH  BOH
         WHERE Z.DIVISION_ID = BOH.DIVISION_ID(+)
           AND Z.ITEM_ID     = BOH.ITEM_ID(+)
           AND Z.FROM_SITE   = BOH.FROM_SITE(+)
         UNION ALL
        SELECT Z.DIVISION_ID
             , Z.ITEM_ID                        AS ITEM_ID
             , Z.FROM_SITE                      AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'WH_BOH_REQ'                     AS MEASURE
             , Z.YYYYMMDD                       AS YYYYMMDD
             , NULL                             AS BOD_ID
             , ( SELECT NVL(SUM(REQ_QTY), 0)
                   FROM GT_0026C_QTY  X
                  WHERE 1 = 1
                    AND X.DIVISION_ID = Z.DIVISION_ID
                    AND X.ITEM_ID     = Z.ITEM_ID
                    AND X.FROM_SITE   = Z.FROM_SITE
                    AND X.YYYYMMDD    < Z.YYYYMMDD
               ) + NVL(BOH.QTY, 0)              AS QTY
             , NULL                             AS INCOTERMS
             , NULL                             AS TRANSPORT_MODE
             , NULL                             AS FCST_TYPE
             , 10                               AS SEQ
             , NULL                             AS LAST_UPDATED_BY
             , NULL                             AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM GT_0026C_Z    Z
             , GT_0026C_BOH  BOH
         WHERE Z.DIVISION_ID = BOH.DIVISION_ID(+)
           AND Z.ITEM_ID     = BOH.ITEM_ID(+)
           AND Z.FROM_SITE   = BOH.FROM_SITE(+);

        /* Requestor */
        INSERT INTO GT_0026_REQUESTOR
             ( DIVISION_ID, FROM_SITE, TO_SITE, ITEM_ID, MEASURE, BOD_ID, LAST_UPDATED_BY, REMARK, FCST_TYPE )
        SELECT DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , ITEM_ID
             , MEASURE
             , BOD_ID
             , LAST_UPDATED_BY
             , REMARK
             , FCST_TYPE
          FROM ( SELECT DIVISION_ID
                      , FROM_SITE
                      , TO_SITE
                      , ITEM_ID
                      , MEASURE
                      , BOD_ID
                      , LAST_UPDATED_BY
                      , REMARK
                      , FCST_TYPE
                      , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, FROM_SITE, TO_SITE, ITEM_ID, MEASURE, BOD_ID, FCST_TYPE
                                               ORDER BY RN DESC) AS RN2
                   FROM ( SELECT DIVISION_ID
                               , ITEM_ID
                               , FROM_SITE
                               , TO_SITE
                               , MEASURE
                               , YYYYMMDD
                               , BOD_ID
                               , QTY
                               , INCOTERMS
                               , TRANSPORT_MODE
                               , FCST_TYPE
                               , LAST_UPDATED_BY
                               , REMARK
                               , RANK() OVER (PARTITION BY DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, BOD_ID, FCST_TYPE
                                                  ORDER BY ITEM_ID DESC
                                                         , LAST_UPDATE_DATE) AS RN
                            FROM GT_0026_ROWDATA
                           WHERE DIVISION_ID = V_DIVISION_ID
                             AND YYYYMMDD   >= V_FROM_YYYYMMDD
                             AND YYYYMMDD   <= V_TO_YYYYMMDD
                        )  XA
                )  IA
         WHERE RN2 = 1
           AND MEASURE NOT IN ('WH_BOH_PLAN', 'WH_BOH_REQ', 'TOTAL_PLAN', 'TOTAL_REQ', 'SITE_MOVE', 'POSTP_PLAN', 'WH_IN');

        /* 측정값 × 날짜 판 만들기 */
        INSERT INTO GT_0026_RESULT
             ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
             , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ )
        SELECT /*+ NO_MERGE(IA) NO_PUSH_PRED(IA) */ DISTINCT
               IA.DIVISION_ID
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE                       AS TO_SITE
             , IA.MEASURE
             , IA.YYYYMMDD
             , '-'                              AS BOD_ID
             , NVL(R.QTY, 0)                    AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , IA.SEQ
          FROM ( SELECT DISTINCT T.DIVISION_ID
                      , T.ITEM_ID
                      , NVL(T.FROM_SITE, '-')           AS FROM_SITE
                      , NVL(T.TO_SITE, '-')             AS TO_SITE
                      , T.BOD_ID
                      , T.QTY
                      , T.INCOTERMS
                      , T.TRANSPORT_MODE
                      , T.FCST_TYPE
                      , TT1.COLUMN_NAME                 AS MEASURE
                      , TT1.COLUMN_LABEL_NAME           AS MEASURE_NAME
                      , TT1.ATTRIBUTE3                  AS BACK_COLOR
                      , TT1.SORT_ORDER_NO               AS SEQ
                      , T.YYYYMMDD
                   FROM GT_0026_ROWDATA         T
                      , SCM_MST_SHEET_MEASURE   TT1
                  WHERE TT1.PROGRAM_ID = C_PROGRAM_ID
--                  AND TT1.SHEET_NAME = P_SHEET_NAME  /* AJS 20261007 화면검증 */
                    AND TT1.SHEET_NAME = V_SHEET_NAME  /* AJS 20261007 화면검증 */
                    AND 1 = 1
               )  IA
             , GT_0026_ROWDATA  R
         WHERE R.DIVISION_ID(+) = IA.DIVISION_ID
           AND R.ITEM_ID(+)     = IA.ITEM_ID
           AND R.MEASURE(+)     = IA.MEASURE
           AND R.YYYYMMDD(+)    = IA.YYYYMMDD
           AND R.FROM_SITE(+)   = IA.FROM_SITE
           AND R.TO_SITE(+)     = IA.TO_SITE
           AND IA.TO_SITE       = '-'
           AND IA.MEASURE       IN ('WH_BOH_PLAN', 'WH_BOH_REQ', 'TOTAL_PLAN', 'TOTAL_REQ', 'POSTP_PLAN', 'SITE_MOVE', 'WH_IN')
         UNION ALL
        SELECT /*+ NO_MERGE(IB) NO_PUSH_PRED(IB) */ DISTINCT
               IB.DIVISION_ID
             , IB.ITEM_ID
             , IB.FROM_SITE
             , IB.TO_SITE
             , IB.MEASURE
             , IB.YYYYMMDD
             , NVL(IB.BOD_ID, '-')              AS BOD_ID
             , NVL(S.QTY, 0)                    AS QTY
             , NVL(IB.INCOTERMS, '-')           AS INCOTERMS
             , NVL(IB.TRANSPORT_MODE, '-')      AS TRANSPORT_MODE
             , NVL(IB.FCST_TYPE, '-')           AS FCST_TYPE
             , IB.SEQ
          FROM ( SELECT DISTINCT T.DIVISION_ID
                      , T.ITEM_ID
                      , NVL(T.FROM_SITE, '-')           AS FROM_SITE
                      , NVL(T.TO_SITE, '-')             AS TO_SITE
                      , T.BOD_ID
                      , T.QTY
                      , T.INCOTERMS
                      , T.TRANSPORT_MODE
                      , T.FCST_TYPE
                      , TT1.COLUMN_NAME                 AS MEASURE
                      , TT1.COLUMN_LABEL_NAME           AS MEASURE_NAME
                      , TT1.ATTRIBUTE3                  AS BACK_COLOR
                      , TT1.SORT_ORDER_NO               AS SEQ
                      , T.YYYYMMDD
                   FROM GT_0026_ROWDATA         T
                      , SCM_MST_SITE            TS
                      , SCM_MST_SHEET_MEASURE   TT1
                  WHERE T.DIVISION_ID   = TS.DIVISION_ID
                    AND T.TO_SITE       = TS.SCM_SITE_ID
                    AND TS.VALID_YN     = 'Y'
                    AND TS.SITE_TYPE    = 'SALES'
                    AND TT1.PROGRAM_ID(+) = C_PROGRAM_ID
--                  AND TT1.SHEET_NAME(+) = P_SHEET_NAME  /* AJS 20261007 화면검증 */
                    AND TT1.SHEET_NAME(+) = V_SHEET_NAME  /* AJS 20261007 화면검증 */
               )  IB
             , GT_0026_ROWDATA  S
         WHERE S.DIVISION_ID(+) = IB.DIVISION_ID
           AND S.ITEM_ID(+)     = IB.ITEM_ID
           AND S.MEASURE(+)     = IB.MEASURE
           AND S.YYYYMMDD(+)    = IB.YYYYMMDD
           AND S.FROM_SITE(+)   = IB.FROM_SITE
           AND S.TO_SITE(+)     = IB.TO_SITE
           AND S.BOD_ID(+)      = IB.BOD_ID
           AND S.FCST_TYPE(+)   = IB.FCST_TYPE
           AND IB.TO_SITE      <> '-'
           AND IB.MEASURE       IN ('SCP_SHIP_PLAN', 'SHIP_REQ', 'SHIP_PLAN');

        /* 피벗 앞 단계 — 측정값이 10 개 미만인 품목 · 사이트는 화면에 내지 않는다 */
        INSERT INTO GT_0026_PIVOT_TEMP
             ( DIVISION_ID, ITEM_ID, DEPT_NAME_KO, DEPT_ID, FROM_SITE, TO_SITE, SOLDTO_CUSTOMER
             , MEASURE, BOD_ID, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, INCOTERMS, TRANSPORT_MODE
             , FCST_TYPE, SEQ, SHIP_FROZEN, ROW_NUM )
        SELECT /*+ NO_MERGE(MC) NO_MERGE(E) NO_PUSH_PRED(MC) NO_PUSH_PRED(E) */ DISTINCT
               A.DIVISION_ID
             , A.ITEM_ID
             , E.DEPT_NAME_KO
             , E.DEPT_ID
             , A.FROM_SITE
             , A.TO_SITE
             , T4.SOLDTO_CUSTOMER
             , A.MEASURE
             , A.BOD_ID
             , 'D_' || A.YYYYMMDD                               AS YYYYMMDD
             , T1.BASIS_YYYYMM                                  AS YYYYMM
             , SUBSTR(T1.BASIS_YYYYMM, 3, 4) || T1.ISO_WEEK     AS ISO_WEEK
             , A.QTY
             , A.INCOTERMS
             , A.TRANSPORT_MODE
             , A.FCST_TYPE
             , A.SEQ
             , T5.SHIP_FROZEN
             , RANK() OVER (PARTITION BY A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, A.MEASURE, A.BOD_ID
                                ORDER BY A.MEASURE
                                       , CASE WHEN A.YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END DESC) AS ROW_NUM
          FROM GT_0026_RESULT      A
             , ( SELECT ITEM_ID
                      , FROM_SITE
                      , COUNT(*)                AS CNT
                   FROM ( SELECT DISTINCT DIVISION_ID
                               , ITEM_ID
                               , FROM_SITE
                               , MEASURE
                            FROM GT_0026_RESULT
                        )  XA
                  GROUP BY ITEM_ID
                         , FROM_SITE
                 HAVING COUNT(*) >= 10
               )  MC
             , SCM_MST_SITE        T4
             , SCM_MST_SITE        T5
             /* 해당 ITEM_ID MCCE121501A2  SCM_MST_SITE_ITEM PROJECT_CODE 두개 확인! */
             , SCM_MST_SITE_ITEM   T6
             , SCM_SYS_CALENDAR_M  T1
             , ( SELECT B.USER_ID
                      , B.USER_NAME
                      , B.USER_NAME_EN
                      , B.DEPT_ID
                      , C.DEPT_NAME_KO
                   FROM SCM_MST_SSO_USER_INFO  B
                      , SCM_MST_SSO_DEPT_INFO  C
                  WHERE B.DEPT_ID = C.DEPT_ID
               )  E
         WHERE A.ITEM_ID        = MC.ITEM_ID
           AND A.FROM_SITE      = MC.FROM_SITE
           AND A.DIVISION_ID    = T4.DIVISION_ID(+)
           AND A.TO_SITE        = T4.SCM_SITE_ID(+)
           AND T4.VALID_YN(+)   = 'Y'
           AND A.DIVISION_ID    = T5.DIVISION_ID(+)
           AND A.FROM_SITE      = T5.SCM_SITE_ID(+)
           AND T5.VALID_YN(+)   = 'Y'
           AND T6.DIVISION_ID(+) = A.DIVISION_ID
           AND T6.SCM_SITE_ID(+) = A.TO_SITE
           AND T6.ITEM_ID(+)     = A.ITEM_ID
           AND A.YYYYMMDD       = T1.BASIS_YYYYMMDD(+)
           AND UPPER(E.USER_ID(+)) = UPPER(SUBSTR(T6.OWNER, 1, CASE WHEN INSTR(T6.OWNER, ',') > 0
                                                                    THEN INSTR(T6.OWNER, ',') - 1
                                                                    ELSE LENGTH(T6.OWNER) END))
           AND 1 = 1;

        /* 조회조건(팀)으로 품목을 좁힌다 */
        INSERT INTO GT_0026_PIVOT
             ( DIVISION_ID, ITEM_ID, DEPT_NAME_KO, DEPT_ID, FROM_SITE, TO_SITE, SOLDTO_CUSTOMER
             , MEASURE, BOD_ID, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, INCOTERMS, TRANSPORT_MODE
             , FCST_TYPE, SEQ, SHIP_FROZEN, ROW_NUM )
        SELECT DIVISION_ID, ITEM_ID, DEPT_NAME_KO, DEPT_ID, FROM_SITE, TO_SITE, SOLDTO_CUSTOMER
             , MEASURE, BOD_ID, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, INCOTERMS, TRANSPORT_MODE
             , FCST_TYPE, SEQ, SHIP_FROZEN, ROW_NUM
          FROM GT_0026_PIVOT_TEMP
         WHERE ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                              FROM GT_0026_PIVOT_TEMP
                             WHERE 1 = 1  /*A.DEPT_ID = '58260040'*/
--                             AND ( TRIM(P_TEAM_ID) IS NULL  /* AJS 20261007 화면검증 */
                               AND ( TRIM(V_TEAM_ID) IS NULL  /* AJS 20261007 화면검증 */
--                                   OR DEPT_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TEAM_ID, ','))) )  /* AJS 20261007 화면검증 */
                                     OR DEPT_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_TEAM_ID, ','))) )  /* AJS 20261007 화면검증 */
                          );

        /* 피벗 대상 날짜 칸 만들기 — 칸 수가 기간에 따라 달라지므로 이 부분만 동적 SQL */
        DBMS_LOB.CREATETEMPORARY(V_PIVOT, TRUE);
        FOR C IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'W_' || BASIS_YYYYMM || ISO_WEEK       AS YYYYMMDD
                                 , BASIS_START_DATE || '21'               AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMM
                                    , ISO_WEEK
                                    , BASIS_START_DATE
                             UNION ALL
                            SELECT 'M_' || BASIS_YYYYMM                   AS YYYYMMDD
                                 , MIN(BASIS_START_DATE) || '01'          AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMM
                                    , MONTH_NAME
                             UNION ALL
                            SELECT 'D_' || BASIS_YYYYMMDD                 AS YYYYMMDD
                                 , BASIS_YYYYMMDD || '31'                 AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMMDD
                          )  IA
                    ORDER BY SORT_ORDER_NO )
        LOOP
            IF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_PIVOT, ', CEIL(SUM(CASE WHEN T0.YYYYMM = ''' || SUBSTR(C.YYYYMMDD, -6)
                                || ''' THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_PIVOT, ', CEIL(SUM(CASE WHEN T0.ISO_WEEK = ''' || SUBSTR(C.YYYYMMDD, -6)
                                || ''' THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSE
                DBMS_LOB.APPEND(V_PIVOT, ', CEIL(SUM(CASE WHEN T0.YYYYMMDD = ''' || SUBSTR(C.YYYYMMDD, -10)
                                || ''' THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            END IF;
        END LOOP;

        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);
        DBMS_LOB.APPEND(V_SQL, 'SELECT DISTINCT TTT.* FROM (' || CHR(10)
          || '    SELECT T0.DIVISION_ID' || CHR(10)
          || '         , T0.ITEM_ID AS MODEL_ID' || CHR(10)
          || '         , FN_GET_ITEM_NICKNAME(T0.DIVISION_ID, T0.ITEM_ID) AS NICK_NAME' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.DEPT_NAME_KO, ''-'') ELSE ''-'' END AS TEAM_NAME_KO' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.DEPT_ID, ''-'') ELSE ''-'' END AS DEPT_ID' || CHR(10)
          || '         , T0.FROM_SITE AS FROM_SITE' || CHR(10)
          || '         , T0.TO_SITE AS TO_SITE' || CHR(10)
          || '         , T0.MEASURE' || CHR(10)
          || '         , T2.SORT_ORDER_NO AS SORT_ORDER_NO' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.BOD_ID, ''-'') ELSE ''-'' END AS BOD_ID' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.INCOTERMS, ''-'') ELSE ''-'' END AS INCOTERMS' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.TRANSPORT_MODE, ''-'') ELSE ''-'' END AS TR_MODE' || CHR(10)
          || '         , NVL(T0.FCST_TYPE, ''-'') AS FCST_TYPE' || CHR(10)
          || '         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3) THEN NVL(T0.SOLDTO_CUSTOMER, ''-'') ELSE ''-'' END AS END_CUSTOMER' || CHR(10)
          || '         , NVL(R.REMARK, ''-'') AS REMARK' || CHR(10)
          || '         , TO_CHAR(TO_DATE(:B_LAST, ''YYYYMMDD'') + NVL(T0.SHIP_FROZEN, 0) - 1, ''YYYYMMDD'') AS SHIP_FROZEN' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '         , CASE WHEN TRIM(C.USERNAME) IS NOT NULL THEN C.USERNAME || ''('' || R.LAST_UPDATED_BY || '')'' ELSE NVL(R.LAST_UPDATED_BY, ''-'') END AS LAST_UPDATED_BY' || CHR(10));
          || '         , CASE WHEN TRIM(C.USER_NM) IS NOT NULL THEN C.USER_NM || ''('' || R.LAST_UPDATED_BY || '')'' ELSE NVL(R.LAST_UPDATED_BY, ''-'') END AS LAST_UPDATED_BY' || CHR(10));
          /* 2026.09.30 AJS 수정 (END) */
        DBMS_LOB.APPEND(V_SQL, V_PIVOT);
        DBMS_LOB.APPEND(V_SQL,
             '      FROM GT_0026_PIVOT           T0' || CHR(10)
          || '         , SCM_MST_SHEET_MEASURE   T2' || CHR(10)
          || '         , GT_0026_REQUESTOR       R' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '         , TB_FX_USER              C' || CHR(10)
          || '         , SCM_ADM_USER_M          C' || CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '     WHERE T0.MEASURE            = T2.COLUMN_NAME' || CHR(10)
          || '       AND T2.PROGRAM_ID         = :B_PGM' || CHR(10)
          || '       AND T2.SHEET_NAME         = :B_SHT' || CHR(10)
          || '       AND R.DIVISION_ID(+)      = T0.DIVISION_ID' || CHR(10)
          || '       AND R.ITEM_ID(+)          = T0.ITEM_ID' || CHR(10)
          || '       AND R.FROM_SITE(+)        = T0.FROM_SITE' || CHR(10)
          || '       AND R.TO_SITE(+)          = T0.TO_SITE' || CHR(10)
          || '       AND R.BOD_ID(+)           = T0.BOD_ID' || CHR(10)
          || '       AND R.FCST_TYPE(+)        = T0.FCST_TYPE' || CHR(10)
          || '       AND R.MEASURE(+)          = T0.MEASURE' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '       AND R.LAST_UPDATED_BY     = C.USERID(+)' || CHR(10)
          || '       AND R.LAST_UPDATED_BY     = C.USER_ID(+)' || CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '       AND 1 = 1' || CHR(10)
          || '       AND T0.ROW_NUM            = 1' || CHR(10)
          || '       AND ( :B_CNT1 = 0' || CHR(10)
          || '             OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER' || CHR(10)
          || '                         WHERE PROGRAM_ID = :B_PGM2 AND SHEET_NAME = :B_SHT2 AND USER_ID = :B_USR' || CHR(10)
          || '                           AND COLUMN_NAME = T2.COLUMN_NAME) )' || CHR(10)
          || '       AND ( ( :B_CNT2 = 0 AND T2.DEFAULT_FLAG = ''Y'' )' || CHR(10)
          || '             OR ( :B_CNT3 <> 0 ) )' || CHR(10)
          || '       AND T2.COLUMN_NAME        = T0.MEASURE' || CHR(10)
          || '     GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.DEPT_NAME_KO, T0.DEPT_ID, T0.FROM_SITE' || CHR(10)
          || '            , T0.TO_SITE, T0.MEASURE, T0.SHIP_FROZEN, T0.BOD_ID, T0.INCOTERMS' || CHR(10)
          || '            , T0.TRANSPORT_MODE, T0.FCST_TYPE, T0.SOLDTO_CUSTOMER, R.REMARK' || CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '            , R.LAST_UPDATED_BY, C.USERNAME, T2.SORT_ORDER_NO' || CHR(10)
          || '            , R.LAST_UPDATED_BY, C.USER_NM, T2.SORT_ORDER_NO' || CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || ') TTT' || CHR(10)
          || ' ORDER BY FN_ASIS_SORT_KEY(TTT.DIVISION_ID) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.MODEL_ID) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.FROM_SITE) DESC NULLS LAST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.TO_SITE) DESC NULLS LAST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.FCST_TYPE) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.DEPT_ID) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.INCOTERMS) NULLS FIRST' || CHR(10)
          || '        , FN_ASIS_SORT_KEY(TTT.TR_MODE) NULLS FIRST' || CHR(10)
          || '        , TTT.SORT_ORDER_NO' || CHR(10));

        OPEN O_RC1 FOR V_SQL
--        USING V_LAST_PLAN_START_YYYYMMDD, C_PROGRAM_ID, P_SHEET_NAME  /* AJS 20261007 화면검증 */
          USING V_LAST_PLAN_START_YYYYMMDD, C_PROGRAM_ID, V_SHEET_NAME  /* AJS 20261007 화면검증 */
--            , V_CNT_USR_MEASURE, C_PROGRAM_ID, P_SHEET_NAME, P_CREATED_BY  /* AJS 20261007 화면검증 */
              , V_CNT_USR_MEASURE, C_PROGRAM_ID, V_SHEET_NAME, P_CREATED_BY  /* AJS 20261007 화면검증 */
              , V_CNT_USR_MEASURE, V_CNT_USR_MEASURE;

        DBMS_LOB.FREETEMPORARY(V_PIVOT);
        DBMS_LOB.FREETEMPORARY(V_SQL);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0026_GET_SHIPMENT_REQUEST_CELL;

    /*******************************************************************************
     * P_SSP0026_SAVE_SHIP_REQ_CELL
     *   AS-IS SSP0026_SAVE_SHIP_REQ_CELL
     *   Cell 출하 지시 저장 (DM_PLN_SHIPMENT_REQ · 이력)
     *
     * AS-IS 절차
     *   1. 화면이 보낸 값을 `^` 로 나누어 한 줄씩 임시 테이블에 넣는다.
     *   2. 줄마다 운송경로(SCP_MST_BOD_N_V)에서 우선순위가 가장 앞선 한 건을 찾는다.
     *      찾은 값 가운데 하나라도 비어 있으면 결과코드 'X' 를 내고 아무것도 저장하지 않는다.
     *   3. 이미 있는 행은 수량을 고치고, 없는 행은 새로 넣는다. 둘 다 이력을 함께 남긴다.
     *
     * ★되돌리기를 커서 OPEN 앞에 둔다(ROLLBACK 이 뒤에 오면 커서가 닫힌다).
     * ★이력 테이블의 순번 칸은 기준 데이터베이스에서 자동 증가 칸이라 넣지 않는다(AS-IS 와 같음).
     *******************************************************************************/
    PROCEDURE P_SSP0026_SAVE_SHIP_REQ_CELL
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_FCST_TYPE             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_MEASURE               IN  VARCHAR2
      , P_YYYYMMDD              IN  VARCHAR2
      , P_QTY                   IN  VARCHAR2
      , P_REMARK                IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        C_DELIMITER             CONSTANT VARCHAR2(1 CHAR)  := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0026_SAVE_SHIP_REQ_CELL';
        V_TABLE_ID              VARCHAR2(150 CHAR) := 'DM_PLN_SHIPMENT_REQ';   /* 테이블 필수 */
        V_BATCH_USER            VARCHAR2(150 CHAR) := 'System';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_CNT                   PLS_INTEGER := 0;

        V_ACTIVE_FLAG           VARCHAR2(1 CHAR);
        V_DIVISION_ID           VARCHAR2(30 CHAR);
        V_ITEM_ID               VARCHAR2(50 CHAR);
        V_FROM_SITE             VARCHAR2(50 CHAR);
        V_TO_SITE               VARCHAR2(30 CHAR);
        V_SHIPTO_CODE           VARCHAR2(30 CHAR);
        V_INCOTERMS             VARCHAR2(10 CHAR);
        V_FCST_TYPE             VARCHAR2(10 CHAR);
        V_TRANSPORT_MODE        VARCHAR2(10 CHAR);
        V_YYYYMMDD              VARCHAR2(8 CHAR);
        V_QTY                   VARCHAR2(30 CHAR);
        V_REMARK                VARCHAR2(4000 CHAR);

        V_DIVISION_ID_TEMP          VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000 CHAR);
        V_FROM_SITE_TEMP            VARCHAR2(4000 CHAR);
        V_TO_SITE_TEMP              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000 CHAR);

        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0026_SAVE_CELL;

        DELETE FROM GT_0026_SAVE;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'DM_PLN_SHIPMENT_REQ INSERT LOGIC';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ITEM_ID, C_DELIMITER));

        /*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
        WHILE LENGTH(P_DIVISION_ID) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG     := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,    C_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID     := SCM_ARR_SPL_VAL(P_DIVISION_ID,    C_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID         := SCM_ARR_SPL_VAL(P_ITEM_ID,        C_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE       := SCM_ARR_SPL_VAL(P_FROM_SITE,      C_DELIMITER, V_MST_LOOP_CNT);
            V_TO_SITE         := SCM_ARR_SPL_VAL(P_TO_SITE,        C_DELIMITER, V_MST_LOOP_CNT);
            /*V_PROJECT_CODE  := SCM_ARR_SPL_VAL(P_PROJECT_CODE,   C_DELIMITER, V_MST_LOOP_CNT);*/
            V_INCOTERMS       := SCM_ARR_SPL_VAL(P_INCOTERMS,      C_DELIMITER, V_MST_LOOP_CNT);
            V_FCST_TYPE       := SCM_ARR_SPL_VAL(P_FCST_TYPE,      C_DELIMITER, V_MST_LOOP_CNT);
            V_TRANSPORT_MODE  := SCM_ARR_SPL_VAL(P_TRANSPORT_MODE, C_DELIMITER, V_MST_LOOP_CNT);
            /*V_BOD_ID        := SCM_ARR_SPL_VAL(P_BOD_ID,         C_DELIMITER, V_MST_LOOP_CNT);*/
            /*V_MEASURE       := SCM_ARR_SPL_VAL(P_MEASURE,        C_DELIMITER, V_MST_LOOP_CNT);*/
            V_YYYYMMDD        := SCM_ARR_SPL_VAL(P_YYYYMMDD,       C_DELIMITER, V_MST_LOOP_CNT);
            V_REMARK          := SCM_ARR_SPL_VAL(P_REMARK,         C_DELIMITER, V_MST_LOOP_CNT);
            V_QTY             := SCM_ARR_SPL_VAL(P_QTY,            C_DELIMITER, V_MST_LOOP_CNT);

            /* 운송경로에서 우선순위가 가장 앞선 한 건 */
            V_DIVISION_ID_TEMP        := NULL;
            V_NEW_BOD_ID_TEMP         := NULL;
            V_FROM_SITE_TEMP          := NULL;
            V_TO_SITE_TEMP            := NULL;
            V_NEW_INCOTERMS_TEMP      := NULL;
            V_NEW_TRANSPORT_MODE_TEMP := NULL;
            V_NEW_ROUTE_ID_TEMP       := NULL;
            V_NEW_D_CONTRY_TEMP       := NULL;
            V_NEW_D_PORT_CODE_TEMP    := NULL;
            V_NEW_A_COUNTRY_TEMP      := NULL;
            V_NEW_A_PORT_CODE_TEMP    := NULL;
            V_NEW_CUSTOMER_LT_TEMP    := NULL;
            V_NEW_TO_COUNTRY_TEMP     := NULL;
            V_NEW_TO_CITY_TEMP        := NULL;

            BEGIN
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SSP_INCOTERMS
                     , TRANSPORT_MODE
                     , ROUTE_ID
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , LT_TOTAL
                     , TO_COUNTRY
                     , TO_CITY
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM ( SELECT B.DIVISION_ID
                              , B.BOD_ID
                              , B.FROM_SITE
                              , B.TO_SITE
                              , B.SSP_INCOTERMS
                              , B.TRANSPORT_MODE
                              , B.ROUTE_ID
                              , B.D_COUNTRY
                              , B.D_PORT_CODE
                              , B.A_COUNTRY
                              , B.A_PORT_CODE
                              , B.LT_TOTAL
                              , B.TO_COUNTRY
                              , B.TO_CITY
                              , B.PRIORITY
                           FROM ( SELECT DISTINCT B.DIVISION_ID
                                       , B.BOD_ID
                                       , B.FROM_SITE
                                       , B.TO_SITE
                                       , B.SSP_INCOTERMS
                                       , B.TRANSPORT_MODE
                                       , B.ROUTE_ID
                                       , B.D_COUNTRY
                                       , B.D_PORT_CODE
                                       , B.A_COUNTRY
                                       , B.A_PORT_CODE
                                       , B.LT_TOTAL
                                       , B.LT_TOTAL_ORIGIN
                                       , B.TO_COUNTRY
                                       , B.TO_CITY
                                       , B.PRIORITY
                                       , B.BOD_VALID_YN
                                    FROM SCP_MST_BOD_N_V  B
                                   WHERE B.DIVISION_ID      = V_DIVISION_ID
                                     AND B.FROM_SITE        = V_FROM_SITE
                                     AND UPPER(B.TO_SITE)   = UPPER(V_TO_SITE)
                                     AND B.TRANSPORT_MODE   = V_TRANSPORT_MODE
                                     AND B.SSP_INCOTERMS    = V_INCOTERMS
                                     AND B.BOD_VALID_YN     = 'Y'
                                     AND B.FROM_YYYYMMDD   <= V_YYYYMMDD
                                     AND B.TO_YYYYMMDD     >= V_YYYYMMDD
                                )  B
                              , ( SELECT DISTINCT DIVISION_ID
                                       , ITEM_ID
                                       , BOD_ID
                                    FROM SCP_MST_BOD_ITEM
                                   WHERE DIVISION_ID = V_DIVISION_ID
                                     AND ITEM_ID     = V_ITEM_ID
                                )  A
                          WHERE A.DIVISION_ID = B.DIVISION_ID
                            AND A.BOD_ID      = B.BOD_ID
                            AND 1 = 1
                          ORDER BY B.PRIORITY
                       )  IA
                 WHERE ROWNUM <= 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            IF (    TRIM(V_DIVISION_ID_TEMP)        IS NULL
                 OR TRIM(V_NEW_BOD_ID_TEMP)         IS NULL
                 OR TRIM(V_FROM_SITE_TEMP)          IS NULL
                 OR TRIM(V_TO_SITE_TEMP)            IS NULL
                 OR TRIM(V_NEW_INCOTERMS_TEMP)      IS NULL
                 OR TRIM(V_NEW_TRANSPORT_MODE_TEMP) IS NULL
                 OR TRIM(V_NEW_ROUTE_ID_TEMP)       IS NULL
                 OR TRIM(V_NEW_D_CONTRY_TEMP)       IS NULL
                 OR TRIM(V_NEW_D_PORT_CODE_TEMP)    IS NULL
                 OR TRIM(V_NEW_A_COUNTRY_TEMP)      IS NULL
                 OR TRIM(V_NEW_A_PORT_CODE_TEMP)    IS NULL
                 OR TRIM(V_NEW_CUSTOMER_LT_TEMP)    IS NULL
                 OR TRIM(V_NEW_TO_COUNTRY_TEMP)     IS NULL
                 OR TRIM(V_NEW_TO_CITY_TEMP)        IS NULL
               ) THEN

                ROLLBACK TO SP_SSP0026_SAVE_CELL;

                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '';
                D_EVENT_DATE  := SYSDATE;
                PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                OPEN O_RC1 FOR
                    SELECT 'X' AS RESULT_CODE, CAST(NULL AS VARCHAR2(30 CHAR)) AS REQUEST_NO FROM DUAL;
                OPEN O_RC2 FOR
                    SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;
                RETURN;

            END IF;

            INSERT INTO GT_0026_SAVE
                 ( ACTIVE_FLAG, DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, SHIPTO_CODE
                 , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, BOD_ID, YYYYMMDD, QTY, REMARK )
            SELECT V_ACTIVE_FLAG                AS ACTIVE_FLAG
                 , V_DIVISION_ID                AS DIVISION_ID
                 , V_ITEM_ID                    AS ITEM_ID
                 , V_FROM_SITE                  AS FROM_SITE
                 , V_TO_SITE                    AS TO_SITE
                 , V_SHIPTO_CODE                AS SHIPTO_CODE
                 , V_NEW_INCOTERMS_TEMP         AS INCOTERMS
                 , V_NEW_TRANSPORT_MODE_TEMP    AS TRANSPORT_MODE
                 , V_FCST_TYPE                  AS FCST_TYPE
                 , V_NEW_BOD_ID_TEMP            AS BOD_ID
                 , V_YYYYMMDD                   AS YYYYMMDD
                 , V_QTY                        AS QTY
                 , V_REMARK                     AS REMARK
              FROM DUAL;

        END LOOP;

        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0026_SAVE;

        IF V_CNT > 0 THEN

            D_EVENT_DATE := SYSDATE;
            /* 수정
               삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행 */

            /*DETAIL UPDATE*/
            UPDATE DM_PLN_SHIPMENT_REQ  A
               SET ( QTY, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1 )
                 = ( SELECT TO_NUMBER(B.QTY)
                          , P_CREATED_BY
                          , D_EVENT_DATE
                          , 'Y'
                       FROM GT_0026_SAVE  B
                      WHERE A.DIVISION_ID     = B.DIVISION_ID
                        AND A.PLANT_SITE_ID   = B.FROM_SITE
                        AND A.SCM_SITE_ID     = B.TO_SITE
                        AND A.ITEM_ID         = B.ITEM_ID
                        AND A.INCOTERMS       = B.INCOTERMS
                        AND A.FCST_TYPE       = B.FCST_TYPE
                        AND A.BOD_ID          = B.BOD_ID
                        AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                        AND A.YYYYMMDD        = B.YYYYMMDD
                        AND ROWNUM           <= 1 )
             WHERE EXISTS ( SELECT 1
                              FROM GT_0026_SAVE  B
                             WHERE A.DIVISION_ID     = B.DIVISION_ID
                               AND A.PLANT_SITE_ID   = B.FROM_SITE
                               AND A.SCM_SITE_ID     = B.TO_SITE
                               AND A.ITEM_ID         = B.ITEM_ID
                               AND A.INCOTERMS       = B.INCOTERMS
                               AND A.FCST_TYPE       = B.FCST_TYPE
                               AND A.BOD_ID          = B.BOD_ID
                               AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                               AND A.YYYYMMDD        = B.YYYYMMDD );

            /*History*/
            INSERT INTO DM_PLN_SHIPMENT_REQ_H
                 ( DIVISION_ID,   PROJECT_CODE,       SCM_SITE_ID,        ITEM_ID,            FCST_TYPE
                 , INCOTERMS,     TRANSPORT_MODE,     MEASURE,            PLANT_SITE_ID,      YYYYMMDD,           QTY
                 , BOD_ID,        SITE_TYPE,          CREATED_BY,         CREATION_DATE,      LAST_UPDATED_BY,    LAST_UPDATE_DATE
                 , ATTRIBUTE1 )
            SELECT B.DIVISION_ID
                 , '-'                          /*B.PROJECT_CODE*/
                 , B.TO_SITE
                 , B.ITEM_ID
                 , B.FCST_TYPE
                 , B.INCOTERMS
                 , B.TRANSPORT_MODE
                 , 'SHIP_REQ'
                 , B.FROM_SITE
                 , B.YYYYMMDD
                 , TO_NUMBER(B.QTY)
                 , B.BOD_ID
                 , 'SALES'
                 , P_CREATED_BY
                 , D_EVENT_DATE
                 , P_CREATED_BY
                 , D_EVENT_DATE
                 , 'Y'
              FROM DM_PLN_SHIPMENT_REQ  A
                 , GT_0026_SAVE         B
             WHERE A.DIVISION_ID     = B.DIVISION_ID
               AND A.PLANT_SITE_ID   = B.FROM_SITE
               AND A.SCM_SITE_ID     = B.TO_SITE
               AND A.ITEM_ID         = B.ITEM_ID
               AND A.INCOTERMS       = B.INCOTERMS
               AND A.FCST_TYPE       = B.FCST_TYPE
               AND A.BOD_ID          = B.BOD_ID
               AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
               AND A.YYYYMMDD        = B.YYYYMMDD
               AND 1 = 1;

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;
        /* UPDATE END */

        /* INSERT START */
        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0026_SAVE  B
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM DM_PLN_SHIPMENT_REQ  A
                             WHERE 1 = 1
                               AND A.DIVISION_ID   = B.DIVISION_ID
                               AND A.PLANT_SITE_ID = B.FROM_SITE
                               AND A.SCM_SITE_ID   = B.TO_SITE
                               AND A.ITEM_ID       = B.ITEM_ID
                               AND A.YYYYMMDD      = B.YYYYMMDD
                               AND A.BOD_ID        = B.BOD_ID
                               AND A.FCST_TYPE     = B.FCST_TYPE );

        IF V_CNT > 0 THEN

            /* INSERT 대상 건 ACTIVE FLAG 변경 */
            UPDATE GT_0026_SAVE  A
               SET A.ACTIVE_FLAG = 'I'
             WHERE NOT EXISTS ( SELECT 1
                                  FROM DM_PLN_SHIPMENT_REQ  B
                                 WHERE 1 = 1
                                   AND A.DIVISION_ID   = B.DIVISION_ID
                                   AND A.FROM_SITE     = B.PLANT_SITE_ID
                                   AND A.TO_SITE       = B.SCM_SITE_ID
                                   AND A.ITEM_ID       = B.ITEM_ID
                                   AND A.YYYYMMDD      = B.YYYYMMDD
                                   AND A.BOD_ID        = B.BOD_ID
                                   AND A.FCST_TYPE     = B.FCST_TYPE );

            /* 신규 REQEUST INSERT
               DETAIL INSERT */
            INSERT INTO DM_PLN_SHIPMENT_REQ
                 ( DIVISION_ID
                 , ITEM_ID
                 , PLANT_SITE_ID
                 , SCM_SITE_ID
                 , SITE_TYPE
                 , MEASURE
                 , YYYYMMDD
                 , BOD_ID
                 , QTY
                 , INCOTERMS
                 , TRANSPORT_MODE
                 , PROJECT_CODE
                 , FCST_TYPE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , ATTRIBUTE1 )
            SELECT B.DIVISION_ID
                 , B.ITEM_ID
                 , B.FROM_SITE
                 , B.TO_SITE
                 , 'SALES'
                 , 'SHIP_REQ'
                 , B.YYYYMMDD
                 , B.BOD_ID
                 , TO_NUMBER(B.QTY)
                 , B.INCOTERMS
                 , B.TRANSPORT_MODE
                 , '-'
                 , B.FCST_TYPE
                 , P_CREATED_BY                 AS CREATED_BY
                 , D_EVENT_DATE                 AS CREATION_DATE
                 , P_CREATED_BY                 AS LAST_UPDATED_BY
                 , D_EVENT_DATE                 AS LAST_UPDATE_DATE
                 , 'Y'
              FROM GT_0026_SAVE  B
             WHERE 1 = 1
               AND B.ACTIVE_FLAG = 'I'
               AND NOT EXISTS ( SELECT 1
                                  FROM DM_PLN_SHIPMENT_REQ  A
                                 WHERE 1 = 1
                                   AND A.DIVISION_ID   = B.DIVISION_ID
                                   AND A.PLANT_SITE_ID = B.FROM_SITE
                                   AND A.SCM_SITE_ID   = B.TO_SITE
                                   AND A.ITEM_ID       = B.ITEM_ID
                                   AND A.YYYYMMDD      = B.YYYYMMDD
                                   AND A.BOD_ID        = B.BOD_ID
                                   AND A.FCST_TYPE     = B.FCST_TYPE );

            /*History*/
            INSERT INTO DM_PLN_SHIPMENT_REQ_H
                 ( DIVISION_ID,   PROJECT_CODE,       SCM_SITE_ID,        ITEM_ID,            FCST_TYPE
                 , INCOTERMS,     TRANSPORT_MODE,     MEASURE,            PLANT_SITE_ID,      YYYYMMDD,           QTY
                 , BOD_ID,        SITE_TYPE,          CREATED_BY,         CREATION_DATE,      LAST_UPDATED_BY,    LAST_UPDATE_DATE
                 , ATTRIBUTE1 )
            SELECT B.DIVISION_ID
                 , '-'                          /*B.PROJECT_CODE*/
                 , B.TO_SITE
                 , B.ITEM_ID
                 , B.FCST_TYPE
                 , B.INCOTERMS
                 , B.TRANSPORT_MODE
                 , 'SHIP_REQ'
                 , B.FROM_SITE
                 , B.YYYYMMDD
                 , TO_NUMBER(B.QTY)
                 , B.BOD_ID
                 , 'SALES'
                 , P_CREATED_BY
                 , D_EVENT_DATE
                 , P_CREATED_BY
                 , D_EVENT_DATE
                 , 'Y'
              FROM DM_PLN_SHIPMENT_REQ  A
                 , GT_0026_SAVE         B
             WHERE A.DIVISION_ID     = B.DIVISION_ID
               AND A.PLANT_SITE_ID   = B.FROM_SITE
               AND A.SCM_SITE_ID     = B.TO_SITE
               AND A.ITEM_ID         = B.ITEM_ID
               AND A.INCOTERMS       = B.INCOTERMS
               AND A.BOD_ID          = B.BOD_ID
               AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
               AND A.YYYYMMDD        = B.YYYYMMDD
               AND 1 = 1;

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';          /* 로그타입 */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        -----------------------------------------------------------
        -- END LOG
        -----------------------------------------------------------
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE, CAST(NULL AS VARCHAR2(4000 CHAR)) AS MSG FROM DUAL;
        OPEN O_RC2 FOR
            SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0026_SAVE_CELL;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, error 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE, V_ERR_MESSAGE AS MSG FROM DUAL;
            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0026_SAVE_SHIP_REQ_CELL;

    /*******************************************************************************
     * P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK
     *   AS-IS SSP0026_SAVE_SHIP_REQ_DETAIL_PACK
     *   Packer 출하 지시 상세 저장 (SSP_ANL_SHIP_REQ_P · 이력 · SCS 송신표)
     *
     * AS-IS 절차
     *   1. 화면이 보낸 값을 `^` 로 나누어 한 줄씩 임시 테이블에 넣는다. 지시번호를 함께 만든다.
     *   2. 운송경로에서 우선순위가 가장 앞선 한 건을 찾는다. 찾은 값 가운데 하나라도 비면 결과코드 'X'.
     *   3. 출하 마감일보다 앞선 날짜가 있으면 결과코드 'Y' 와 그 마감일.
     *   4. 이미 있는 행은 고치고 없는 행은 새로 넣는다. 둘 다 이력과 SCS 송신표를 함께 남긴다.
     *
     * ★AS-IS 는 2·3 번 갈래를 THROW 60001 · 60002 로 빠져나와 CATCH 에서 결과코드를 낸다.
     *   오류를 밖으로 내보내지 않고 결과코드로만 쓰므로, TO-BE 는 오류를 만들지 않고 바로 결과코드를 낸다.
     * ★되돌리기를 커서 OPEN 앞에 둔다(ROLLBACK 이 뒤에 오면 커서가 닫힌다).
     * ★결과 칸 이름이 갈래마다 다르다(X 는 REQUEST_NO · Y 는 CONFIRM_DAY · S 는 MSG). AS-IS 와 같게 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_SHIPTO_CODE           IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_FCST_TYPE             IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_YYYYMMDD              IN  VARCHAR2
      , P_QTY                   IN  VARCHAR2
      , P_REMARK                IN  VARCHAR2
      , P_ORDER_TYPE_DETAIL     IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        C_DELIMITER             CONSTANT VARCHAR2(1 CHAR)  := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0026_SAVE_SHIP_REQ_DETAIL_PACK';
        V_TABLE_ID              VARCHAR2(150 CHAR) := 'SSP_ANL_SHIP_REQ_P';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)   := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_IF_GROUP_NO           VARCHAR2(50 CHAR)  := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_CNT                   PLS_INTEGER := 0;
        V_CONFIRM_DAY           VARCHAR2(8 CHAR);

        V_ACTIVE_FLAG           VARCHAR2(1 CHAR);
        V_DIVISION_ID           VARCHAR2(30 CHAR);
        V_ITEM_ID               VARCHAR2(50 CHAR);
        V_FROM_SITE             VARCHAR2(50 CHAR);
        V_TO_SITE               VARCHAR2(30 CHAR);
        V_SHIPTO_CODE           VARCHAR2(30 CHAR);
        V_INCOTERMS             VARCHAR2(10 CHAR);
        V_FCST_TYPE             VARCHAR2(10 CHAR);
        V_TRANSPORT_MODE        VARCHAR2(10 CHAR);
        V_YYYYMMDD              VARCHAR2(8 CHAR);
        V_QTY                   VARCHAR2(30 CHAR);
        V_REMARK                VARCHAR2(4000 CHAR);
        V_ORDER_TYPE_DETAIL     VARCHAR2(60 CHAR);

        V_DIVISION_ID_TEMP          VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000 CHAR);
        V_FROM_SITE_TEMP            VARCHAR2(4000 CHAR);
        V_TO_SITE_TEMP              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000 CHAR);

        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0026_SAVE_DETAIL;

        DELETE FROM GT_0026_SAVE;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'SSP_ANL_SHIP_REQ_P INSERT LOGIC';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ITEM_ID, C_DELIMITER));

        /*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
        WHILE LENGTH(P_DIVISION_ID) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG        := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,       C_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID        := SCM_ARR_SPL_VAL(P_DIVISION_ID,       C_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID            := SCM_ARR_SPL_VAL(P_ITEM_ID,           C_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE          := SCM_ARR_SPL_VAL(P_FROM_SITE,         C_DELIMITER, V_MST_LOOP_CNT);
            V_TO_SITE            := SCM_ARR_SPL_VAL(P_TO_SITE,           C_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPTO_CODE        := SCM_ARR_SPL_VAL(P_SHIPTO_CODE,       C_DELIMITER, V_MST_LOOP_CNT);
            V_INCOTERMS          := SCM_ARR_SPL_VAL(P_INCOTERMS,         C_DELIMITER, V_MST_LOOP_CNT);
            V_FCST_TYPE          := SCM_ARR_SPL_VAL(P_FCST_TYPE,         C_DELIMITER, V_MST_LOOP_CNT);
            V_TRANSPORT_MODE     := SCM_ARR_SPL_VAL(P_TRANSPORT_MODE,    C_DELIMITER, V_MST_LOOP_CNT);
            /*V_BOD_ID           := SCM_ARR_SPL_VAL(P_BOD_ID,            C_DELIMITER, V_MST_LOOP_CNT);*/
            V_YYYYMMDD           := SCM_ARR_SPL_VAL(P_YYYYMMDD,          C_DELIMITER, V_MST_LOOP_CNT);
            V_REMARK             := SCM_ARR_SPL_VAL(P_REMARK,            C_DELIMITER, V_MST_LOOP_CNT);
            V_QTY                := SCM_ARR_SPL_VAL(P_QTY,               C_DELIMITER, V_MST_LOOP_CNT);
            V_ORDER_TYPE_DETAIL  := SCM_ARR_SPL_VAL(P_ORDER_TYPE_DETAIL, C_DELIMITER, V_MST_LOOP_CNT);

            V_DIVISION_ID_TEMP        := NULL;
            V_NEW_BOD_ID_TEMP         := NULL;
            V_FROM_SITE_TEMP          := NULL;
            V_TO_SITE_TEMP            := NULL;
            V_NEW_INCOTERMS_TEMP      := NULL;
            V_NEW_TRANSPORT_MODE_TEMP := NULL;
            V_NEW_ROUTE_ID_TEMP       := NULL;
            V_NEW_D_CONTRY_TEMP       := NULL;
            V_NEW_D_PORT_CODE_TEMP    := NULL;
            V_NEW_A_COUNTRY_TEMP      := NULL;
            V_NEW_A_PORT_CODE_TEMP    := NULL;
            V_NEW_CUSTOMER_LT_TEMP    := NULL;
            V_NEW_TO_COUNTRY_TEMP     := NULL;
            V_NEW_TO_CITY_TEMP        := NULL;

            BEGIN
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SSP_INCOTERMS
                     , TRANSPORT_MODE
                     , ROUTE_ID
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , LT_TOTAL
                     , TO_COUNTRY
                     , TO_CITY
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM ( SELECT B.DIVISION_ID
                              , B.BOD_ID
                              , B.FROM_SITE
                              , B.TO_SITE
                              , B.SSP_INCOTERMS
                              , B.TRANSPORT_MODE
                              , B.ROUTE_ID
                              , B.D_COUNTRY
                              , B.D_PORT_CODE
                              , B.A_COUNTRY
                              , B.A_PORT_CODE
                              , B.LT_TOTAL
                              , B.TO_COUNTRY
                              , B.TO_CITY
                              , B.PRIORITY
                           FROM ( SELECT DISTINCT B.DIVISION_ID
                                       , B.BOD_ID
                                       , B.FROM_SITE
                                       , B.TO_SITE
                                       , B.SSP_INCOTERMS
                                       , B.TRANSPORT_MODE
                                       , B.ROUTE_ID
                                       , B.D_COUNTRY
                                       , B.D_PORT_CODE
                                       , B.A_COUNTRY
                                       , B.A_PORT_CODE
                                       , B.LT_TOTAL
                                       , B.LT_TOTAL_ORIGIN
                                       , B.TO_COUNTRY
                                       , B.TO_CITY
                                       , B.PRIORITY
                                       , B.BOD_VALID_YN
                                    FROM SCP_MST_BOD_N_V  B
                                   WHERE B.DIVISION_ID      = V_DIVISION_ID
                                     AND B.FROM_SITE        = V_FROM_SITE
                                     AND UPPER(B.TO_SITE)   = UPPER(V_TO_SITE)
                                     AND B.TRANSPORT_MODE   = V_TRANSPORT_MODE
                                     AND B.SSP_INCOTERMS    = V_INCOTERMS
                                     AND B.BOD_VALID_YN     = 'Y'
                                     AND B.FROM_YYYYMMDD   <= V_YYYYMMDD
                                     AND B.TO_YYYYMMDD     >= V_YYYYMMDD
                                )  B
                                /* 2022/01/04 KIMYONGHO ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
                                   ★AS-IS STUFF 는 시작 자리가 문자열 길이보다 크면 빈값을 내고
                                     바깥 ISNULL 이 원래 품목을 돌려준다. 길이 검사를 함께 옮긴다. */
                              , ( SELECT DISTINCT A.DIVISION_ID
                                       , V.FROM_SITE
                                       , CASE WHEN TRIM(C.PACKER_ITEM_ID_SUFFIX) IS NULL THEN A.ITEM_ID
                                              ELSE NVL( CASE WHEN LENGTH(A.ITEM_ID) < 12 THEN NULL
                                                             ELSE SUBSTR(A.ITEM_ID, 1, 11) || C.PACKER_ITEM_ID_SUFFIX || SUBSTR(A.ITEM_ID, 13)
                                                        END
                                                      , A.ITEM_ID)
                                         END                        AS ITEM_ID
                                       , A.BOD_ID
                                    FROM SCP_MST_BOD_ITEM  A
                                       , SCP_MST_BOD_N_V   V
                                       , SCM_MST_SITE      C
                                   WHERE A.DIVISION_ID = V.DIVISION_ID
                                     AND A.BOD_ID      = V.BOD_ID
                                     AND C.DIVISION_ID = V.DIVISION_ID
                                     AND C.SCM_SITE_ID = V.FROM_SITE
                                     AND A.DIVISION_ID = V_DIVISION_ID
                                     AND C.OSP_YN      = 'Y'
                                     AND CASE WHEN TRIM(C.PACKER_ITEM_ID_SUFFIX) IS NULL THEN A.ITEM_ID
                                              ELSE NVL( CASE WHEN LENGTH(A.ITEM_ID) < 12 THEN NULL
                                                             ELSE SUBSTR(A.ITEM_ID, 1, 11) || C.PACKER_ITEM_ID_SUFFIX || SUBSTR(A.ITEM_ID, 13)
                                                        END
                                                      , A.ITEM_ID)
                                         END = V_ITEM_ID
                                )  A
                          WHERE A.DIVISION_ID = B.DIVISION_ID
                            AND A.BOD_ID      = B.BOD_ID
                            AND 1 = 1
                          ORDER BY B.PRIORITY
                       )  IA
                 WHERE ROWNUM <= 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            IF (    TRIM(V_DIVISION_ID_TEMP)        IS NULL
                 OR TRIM(V_NEW_BOD_ID_TEMP)         IS NULL
                 OR TRIM(V_FROM_SITE_TEMP)          IS NULL
                 OR TRIM(V_TO_SITE_TEMP)            IS NULL
                 OR TRIM(V_NEW_INCOTERMS_TEMP)      IS NULL
                 OR TRIM(V_NEW_TRANSPORT_MODE_TEMP) IS NULL
                 OR TRIM(V_NEW_ROUTE_ID_TEMP)       IS NULL
                 OR TRIM(V_NEW_D_CONTRY_TEMP)       IS NULL
                 OR TRIM(V_NEW_D_PORT_CODE_TEMP)    IS NULL
                 OR TRIM(V_NEW_A_COUNTRY_TEMP)      IS NULL
                 OR TRIM(V_NEW_A_PORT_CODE_TEMP)    IS NULL
                 OR TRIM(V_NEW_CUSTOMER_LT_TEMP)    IS NULL
                 OR TRIM(V_NEW_TO_COUNTRY_TEMP)     IS NULL
                 OR TRIM(V_NEW_TO_CITY_TEMP)        IS NULL
               ) THEN

                /* AS-IS THROW 60001 'Unauthorized' 갈래 */
                ROLLBACK TO SP_SSP0026_SAVE_DETAIL;

                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '';
                D_EVENT_DATE  := SYSDATE;
                PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                OPEN O_RC1 FOR
                    SELECT 'X' AS RESULT_CODE, CAST(NULL AS VARCHAR2(30 CHAR)) AS REQUEST_NO FROM DUAL;
                OPEN O_RC2 FOR
                    SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;
                RETURN;

            END IF;

            INSERT INTO GT_0026_SAVE
                 ( ACTIVE_FLAG, DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, SHIPTO_CODE
                 , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, BOD_ID, YYYYMMDD, QTY, REMARK
                 , ORDER_TYPE_DETAIL, REQUEST_ID )
            SELECT V_ACTIVE_FLAG                AS ACTIVE_FLAG
                 , V_DIVISION_ID                AS DIVISION_ID
                 , V_ITEM_ID                    AS ITEM_ID
                 , V_FROM_SITE                  AS FROM_SITE
                 , V_TO_SITE                    AS TO_SITE
                 , V_SHIPTO_CODE                AS SHIPTO_CODE
                 , V_NEW_INCOTERMS_TEMP         AS INCOTERMS
                 , V_NEW_TRANSPORT_MODE_TEMP    AS TRANSPORT_MODE
                 , V_FCST_TYPE                  AS FCST_TYPE
                 , V_NEW_BOD_ID_TEMP            AS BOD_ID
                 , V_YYYYMMDD                   AS YYYYMMDD
                 , V_QTY                        AS QTY
                 , V_REMARK                     AS REMARK
                 , V_ORDER_TYPE_DETAIL          AS ORDER_TYPE_DETAIL
                   /* AS-IS 는 오른쪽 6 자리만 남기므로 여섯 자리를 넘으면 앞자리가 잘린다 */
                 , 'R' || TO_CHAR(SYSDATE, 'YYYYMMDD')
                       || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID.NEXTVAL), -6)  AS REQUEST_ID
              FROM DUAL;

        END LOOP;

        /* 출하 마감일보다 앞선 날짜가 있는지
           ★AS-IS 는 여러 행이 나오면 마지막 한 건을 담는다(순서 보장 없음). 가장 큰 값으로 고정한다. */
        SELECT MAX(TO_CHAR(SYSDATE + NVL(B.SHIP_FROZEN, 0), 'YYYYMMDD'))
          INTO V_CONFIRM_DAY
          FROM GT_0026_SAVE  A
             , SCM_MST_SITE  B
         WHERE A.DIVISION_ID = B.DIVISION_ID(+)
           AND A.FROM_SITE   = B.SCM_SITE_ID(+)
           AND 1 = 1
           AND A.YYYYMMDD    < TO_CHAR(SYSDATE + NVL(B.SHIP_FROZEN, 0), 'YYYYMMDD');

        IF V_CONFIRM_DAY IS NOT NULL THEN

            /* AS-IS THROW 60002 'ConfirmDayCheck' 갈래 */
            ROLLBACK TO SP_SSP0026_SAVE_DETAIL;

            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            OPEN O_RC1 FOR
                SELECT 'Y' AS RESULT_CODE
                     , TO_CHAR(TO_DATE(V_CONFIRM_DAY, 'YYYYMMDD'), 'YYYY-MM-DD') AS CONFIRM_DAY
                  FROM DUAL;
            OPEN O_RC2 FOR
                SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;
            RETURN;

        END IF;

        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0026_SAVE;

        IF V_CNT > 0 THEN

            D_EVENT_DATE := SYSDATE;
            /* 수정
               삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행 */

            /*DETAIL UPDATE*/
            UPDATE SSP_ANL_SHIP_REQ_P  A
               SET ( QTY, BOD_ID, PROJECT_CODE, FCST_TYPE, ORDER_TYPE_DETAIL, REQUEST_ID
                   , REMARK, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                 = ( SELECT TO_NUMBER(B.QTY)
                          , B.BOD_ID
                          , EC.SOLDTO_CUSTOMER
                          , B.FCST_TYPE
                          , B.ORDER_TYPE_DETAIL
                          , CASE WHEN A.REQUEST_ID IS NULL THEN B.REQUEST_ID ELSE A.REQUEST_ID END
                          , B.REMARK
                          , P_CREATED_BY
                          , D_EVENT_DATE
                       FROM GT_0026_SAVE  B
                          , SCM_MST_SITE  EC
                      WHERE A.DIVISION_ID   = B.DIVISION_ID
                        AND A.SHIPTO_CODE   = B.SHIPTO_CODE
                        AND A.BOD_ID        = B.BOD_ID
                        AND A.ITEM_ID       = B.ITEM_ID
                        AND A.YYYYMMDD      = B.YYYYMMDD
                        AND EC.DIVISION_ID(+) = A.DIVISION_ID
                        AND EC.SCM_SITE_ID(+) = B.TO_SITE
                        AND EC.VALID_YN(+)    = 'Y'
                        AND ROWNUM         <= 1 )
             WHERE EXISTS ( SELECT 1
                              FROM GT_0026_SAVE  B
                             WHERE A.DIVISION_ID = B.DIVISION_ID
                               AND A.SHIPTO_CODE = B.SHIPTO_CODE
                               AND A.BOD_ID      = B.BOD_ID
                               AND A.ITEM_ID     = B.ITEM_ID
                               AND A.YYYYMMDD    = B.YYYYMMDD );

            /* 2020.09.21 KIM BOK KI HISTORY 추가
               2021.11.03 SHIN MYUNG SU 수정 ( SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경) */
            INSERT INTO SSP_ANL_SHIP_REQ_P_H
                 ( HISTORY_SEQ, DIVISION_ID, SHIPTO_CODE, YYYYMMDD, BOD_ID, QTY, REQUEST_ID, CONFIRM_ID
                 , ORDER_TYPE_DETAIL, REMARK, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ITEM_ID )
            SELECT SEQ1_SSP_ANL_SHIP_PACKER_REQ_H.NEXTVAL   AS HISTORY_SEQ
                 , A.DIVISION_ID
                 , A.SHIPTO_CODE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , A.QTY
                 , A.REQUEST_ID
                 , A.CONFIRM_ID
                 , A.ORDER_TYPE_DETAIL
                 , A.REMARK
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , A.LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
                 , A.ATTRIBUTE1
                 , A.ATTRIBUTE2
                 , A.ATTRIBUTE3
                 , A.ATTRIBUTE4
                 , A.ATTRIBUTE5
                 , A.ATTRIBUTE6
                 , A.ATTRIBUTE7
                 , A.ATTRIBUTE8
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ITEM_ID
              FROM SSP_ANL_SHIP_REQ_P  A
                 , GT_0026_SAVE        B
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.SHIPTO_CODE = B.SHIPTO_CODE
               AND A.ITEM_ID     = B.ITEM_ID
               AND A.BOD_ID      = B.BOD_ID
               AND A.YYYYMMDD    = B.YYYYMMDD
               AND 1 = 1;

            /* SCS I/F 정보 생성 — I/F 주체는 SCS 에서 함 */
            INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
                 ( IF_SEQ, IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, PACKER_CODE, DIVISION_ID
                 , PLAN_VERSION, PACK_MODEL_CODE, NICK_NAME, TARGET_ORDER, SSP_CNFM, SALES_SITE
                 , SHIP_TO, SHIP_TO_NAME, TRANSPORT_MODE, INCOTERMS, SHIP_PLAN_DATE, SHIP_PLAN_QTY
                 , "COMMENT", ATTR_01, ATTR_02, ATTR_03, ATTR_04, ATTR_05, ATTR_06, ATTR_07
                 , ATTR_08, ATTR_09, ATTR_10, ORDER_TYPE_DETAIL )
            SELECT 'OSCM' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10)  AS IF_SEQ
                 , 'I'                                  AS IF_TYPE
                 , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'       AS IF_ID
                 , SYSDATE                              AS IF_INS_DATE
                 , 'N'                                  AS IF_FLAG
                 , NVL(IB.NEW_VALUE1, IA.PACKER_CODE)   AS PACKER_CODE
                 , IA.DIVISION_ID
                 , V_PLAN_START_YYYYMMDD                AS PLAN_VERSION
                 , IA.PACK_MODEL_CODE
                 , IA.NICK_NAME
                 , 'O'                                  AS TARGET_ORDER
                 , IA.SSP_CNFM
                 , IA.SALES_SITE
                 , IA.SHIP_TO
                 , IA.SHIP_TO_NAME
                 , IA.TRANSPORT_MODE
                 , IA.INCOTERMS
                 , IA.SHIP_PLAN_DATE
                 , IA.SHIP_PLAN_QTY
                 , IA.COMMENT_TEXT
                 , IA.ATTR_01
                 , NULL                                 AS ATTR_02
                 , IA.ATTR_03                           /*Model PIC*/
                 , IA.ATTR_04                           /*MTK_OWNER*/
                 , NULL                                 AS ATTR_05
                 , NULL                                 AS ATTR_06
                 , NULL                                 AS ATTR_07
                 , NULL                                 AS ATTR_08
                 , NULL                                 AS ATTR_09
                 , NULL                                 AS ATTR_10
                 , IA.ORDER_TYPE_DETAIL
              FROM ( SELECT B.FROM_SITE                 AS PACKER_CODE
                          , B.DIVISION_ID               AS DIVISION_ID
                          , B.ITEM_ID                   AS PACK_MODEL_CODE
                          , FN_GET_ITEM_NICKNAME(B.DIVISION_ID, B.ITEM_ID)    AS NICK_NAME
                          , A.REQUEST_ID                AS SSP_CNFM
                          , B.TO_SITE                   AS SALES_SITE
                          , B.SHIPTO_CODE               AS SHIP_TO
                          , FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_DESCRIPTION')  AS SHIP_TO_NAME
                          , B.TRANSPORT_MODE
                          , B.INCOTERMS
                          , B.YYYYMMDD                  AS SHIP_PLAN_DATE
                          , TO_NUMBER(B.QTY)            AS SHIP_PLAN_QTY
                          /* 20211102  SHINMYUNGSU  수정 */
                          , B.REMARK                    AS COMMENT_TEXT
                          , B.DIVISION_ID || '_' || V_PLAN_START_YYYYMMDD || '_' || V_IF_GROUP_NO  AS ATTR_01
                          /* MSSQL 문자 결합은 한쪽이 빈값이면 전체가 빈값이므로 같게 맞춘다 */
                          /* 2026.09.30 AJS 수정 (START) */
--                          , CASE WHEN U2.USERNAME IS NOT NULL AND MU.USER_ID IS NOT NULL
--                                 THEN U2.USERNAME || '(' || MU.USER_ID || ')'
                          , CASE WHEN U2.USER_NM IS NOT NULL AND MU.USER_ID IS NOT NULL
                                 THEN U2.USER_NM || '(' || MU.USER_ID || ')'
                          /* 2026.09.30 AJS 수정 (END) */
                            END                         AS ATTR_03      /*Model PIC*/
                          , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, '', 'KO')     AS ATTR_04      /*MTK_OWNER*/
                          , NVL(LK.SEGMENT2, A.FCST_TYPE)                     AS ORDER_TYPE_DETAIL
                       FROM SSP_ANL_SHIP_REQ_P    A
                          , GT_0026_SAVE          B
                          , ( SELECT DIVISION_ID
                                   , PROJECT_CODE
                                   , SCM_SITE_ID
                                   , ITEM_ID
                                FROM ( SELECT DIVISION_ID
                                            , PROJECT_CODE
                                            , SCM_SITE_ID
                                            , ITEM_ID
                                            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                                                     ORDER BY PROJECT_CODE) NUM
                                         FROM SCM_MST_SITE_ITEM
                                     )  XA
                               WHERE NUM = 1
                            )  G
                          , SCM_MST_SITE_ITEM     SI
                          , SSP_MST_MODEL_USER    MU
                          /* 2026.09.30 AJS 수정 (START) */
--                          , TB_FX_USER            U2
                          , SCM_ADM_USER_M        U2
                          /* 2026.09.30 AJS 수정 (END) */
                          , SCM_ADM_LOOKUP_MASTER_DETAIL  LK
                      WHERE A.DIVISION_ID   = B.DIVISION_ID
                        AND A.SHIPTO_CODE   = B.SHIPTO_CODE
                        AND A.ITEM_ID       = B.ITEM_ID
                        AND A.BOD_ID        = B.BOD_ID
                        AND A.YYYYMMDD      = B.YYYYMMDD
                        /* 20211102  SHINMYUNGSU  추가 */
                        AND G.DIVISION_ID(+) = B.DIVISION_ID
                        AND G.SCM_SITE_ID(+) = B.TO_SITE
                        AND G.ITEM_ID(+)     = B.ITEM_ID
                        AND SI.DIVISION_ID(+)  = B.DIVISION_ID
                        AND SI.SCM_SITE_ID(+)  = B.TO_SITE
                        AND SI.ITEM_ID(+)      = B.ITEM_ID
                        AND SI.PROJECT_CODE(+) = G.PROJECT_CODE
                        AND MU.DIVISION_ID(+)  = B.DIVISION_ID
                        AND MU.FROM_SITE(+)    = B.FROM_SITE
                        AND MU.ITEM_ID(+)      = B.ITEM_ID
                        AND MU.VALID_YN(+)     = 'Y'
                        /* 2026.09.30 AJS 수정 (START) */
--                        AND MU.USER_ID         = U2.USERID(+)
--                        AND U2.USEYN(+)        = 'Y'
                        AND MU.USER_ID         = U2.USER_ID(+)
                        AND U2.USE_YN(+)       = 'Y'
                        /* 2026.09.30 AJS 수정 (END) */
                        AND LK.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                        AND LK.VALID_YN(+)     = 'Y'
                        AND B.FCST_TYPE        = LK.SEGMENT1(+)
                   )  IA
                 , NERP_CONV_MASTER  IB
             WHERE IB.CODETYPE(+)   = 'SCP_SITE_ID'
               AND IA.PACKER_CODE   = IB.OLD_VALUE1(+);

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;
        /* UPDATE END */

        /* INSERT START */
        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0026_SAVE  B
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM SSP_ANL_SHIP_REQ_P  A
                             WHERE 1 = 1
                               AND A.DIVISION_ID = B.DIVISION_ID
                               AND A.SHIPTO_CODE = B.SHIPTO_CODE
                               AND A.ITEM_ID     = B.ITEM_ID
                               AND A.YYYYMMDD    = B.YYYYMMDD
                               AND A.BOD_ID      = B.BOD_ID );

        IF V_CNT > 0 THEN

            /* INSERT 대상 건 ACTIVE FLAG 변경 */
            UPDATE GT_0026_SAVE  A
               SET A.ACTIVE_FLAG = 'I'
             WHERE NOT EXISTS ( SELECT 1
                                  FROM SSP_ANL_SHIP_REQ_P  B
                                 WHERE 1 = 1
                                   AND A.DIVISION_ID = B.DIVISION_ID
                                   AND A.SHIPTO_CODE = B.SHIPTO_CODE
                                   AND A.ITEM_ID     = B.ITEM_ID
                                   AND A.YYYYMMDD    = B.YYYYMMDD
                                   AND A.BOD_ID      = B.BOD_ID );

            /* 신규 REQEUST INSERT — DETAIL INSERT */
            INSERT INTO SSP_ANL_SHIP_REQ_P
                 ( DIVISION_ID, ITEM_ID, SHIPTO_CODE, BOD_ID, YYYYMMDD, QTY, REQUEST_ID
                 , FCST_TYPE, PROJECT_CODE, ORDER_TYPE_DETAIL, REMARK
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            SELECT B.DIVISION_ID
                 , B.ITEM_ID
                 , B.SHIPTO_CODE
                 , B.BOD_ID
                 , B.YYYYMMDD
                 , TO_NUMBER(B.QTY)
                 , B.REQUEST_ID
                 , B.FCST_TYPE
                 , C.SOLDTO_CUSTOMER
                 , B.ORDER_TYPE_DETAIL
                 , B.REMARK
                 , P_CREATED_BY                 AS CREATED_BY
                 , D_EVENT_DATE                 AS CREATION_DATE
                 , P_CREATED_BY                 AS LAST_UPDATED_BY
                 , D_EVENT_DATE                 AS LAST_UPDATE_DATE
              FROM GT_0026_SAVE   B
                 , SCM_MST_SITE   C
             WHERE B.DIVISION_ID = C.DIVISION_ID
               AND B.TO_SITE     = C.SCM_SITE_ID
               AND C.VALID_YN    = 'Y'
               AND 1 = 1
               AND B.ACTIVE_FLAG = 'I'
               AND NOT EXISTS ( SELECT 1
                                  FROM SSP_ANL_SHIP_REQ_P  A
                                 WHERE 1 = 1
                                   AND A.DIVISION_ID = B.DIVISION_ID
                                   AND A.SHIPTO_CODE = B.SHIPTO_CODE
                                   AND A.ITEM_ID     = B.ITEM_ID
                                   AND A.YYYYMMDD    = B.YYYYMMDD
                                   AND A.BOD_ID      = B.BOD_ID );

            /* 2020.09.21 KIM BOK KI HISTORY 추가 */
            INSERT INTO SSP_ANL_SHIP_REQ_P_H
                 ( HISTORY_SEQ, DIVISION_ID, SHIPTO_CODE, YYYYMMDD, BOD_ID, QTY, REQUEST_ID, CONFIRM_ID
                 , FCST_TYPE, PROJECT_CODE, ORDER_TYPE_DETAIL, REMARK
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ITEM_ID )
            SELECT SEQ1_SSP_ANL_SHIP_PACKER_REQ_H.NEXTVAL   AS HISTORY_SEQ
                 , A.DIVISION_ID
                 , A.SHIPTO_CODE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , A.QTY
                 , A.REQUEST_ID
                 , A.CONFIRM_ID
                 , A.FCST_TYPE
                 , C.SOLDTO_CUSTOMER
                 , A.ORDER_TYPE_DETAIL
                 , A.REMARK
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , A.LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
                 , A.ATTRIBUTE1
                 , A.ATTRIBUTE2
                 , A.ATTRIBUTE3
                 , A.ATTRIBUTE4
                 , A.ATTRIBUTE5
                 , A.ATTRIBUTE6
                 , A.ATTRIBUTE7
                 , A.ATTRIBUTE8
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ITEM_ID
              FROM SSP_ANL_SHIP_REQ_P  A
                 , SCP_MST_BOD_N_V     V
                 , SCM_MST_SITE        C
                 , GT_0026_SAVE        B
             WHERE A.DIVISION_ID = V.DIVISION_ID
               AND A.BOD_ID      = V.BOD_ID
               AND A.DIVISION_ID = C.DIVISION_ID
               AND V.TO_SITE     = C.SCM_SITE_ID
               AND C.VALID_YN    = 'Y'
               AND A.DIVISION_ID = B.DIVISION_ID
               AND A.SHIPTO_CODE = B.SHIPTO_CODE
               AND A.ITEM_ID     = B.ITEM_ID
               AND A.BOD_ID      = B.BOD_ID
               AND A.YYYYMMDD    = B.YYYYMMDD
               AND 1 = 1;

            /* SCS I/F 정보 생성 — I/F 주체는 SCS 에서 함 */
            INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
                 ( IF_SEQ, IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, PACKER_CODE, DIVISION_ID
                 , PLAN_VERSION, PACK_MODEL_CODE, NICK_NAME, TARGET_ORDER, SSP_CNFM, SALES_SITE
                 , SHIP_TO, SHIP_TO_NAME, TRANSPORT_MODE, INCOTERMS, SHIP_PLAN_DATE, SHIP_PLAN_QTY
                 , "COMMENT", ATTR_01, ATTR_02, ATTR_03, ATTR_04, ATTR_05, ATTR_06, ATTR_07
                 , ATTR_08, ATTR_09, ATTR_10, ORDER_TYPE_DETAIL )
            SELECT 'OSCM' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10)  AS IF_SEQ
                 , 'I'                                  AS IF_TYPE
                 , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'       AS IF_ID
                 , SYSDATE                              AS IF_INS_DATE
                 , 'N'                                  AS IF_FLAG
                 , NVL(IB.NEW_VALUE1, IA.PACKER_CODE)   AS PACKER_CODE
                 , IA.DIVISION_ID
                 , V_PLAN_START_YYYYMMDD                AS PLAN_VERSION
                 , IA.PACK_MODEL_CODE
                 , IA.NICK_NAME
                 , 'O'                                  AS TARGET_ORDER
                 , IA.SSP_CNFM
                 , IA.SALES_SITE
                 , IA.SHIP_TO
                 , IA.SHIP_TO_NAME
                 , IA.TRANSPORT_MODE
                 , IA.INCOTERMS
                 , IA.SHIP_PLAN_DATE
                 , IA.SHIP_PLAN_QTY
                 , IA.COMMENT_TEXT
                 , IA.ATTR_01
                 , NULL                                 AS ATTR_02
                 , IA.ATTR_03                           /*Model PIC*/
                 , IA.ATTR_04                           /*MTK_OWNER*/
                 , NULL                                 AS ATTR_05
                 , NULL                                 AS ATTR_06
                 , NULL                                 AS ATTR_07
                 , NULL                                 AS ATTR_08
                 , NULL                                 AS ATTR_09
                 , NULL                                 AS ATTR_10
                 , IA.ORDER_TYPE_DETAIL
              FROM ( SELECT B.FROM_SITE                 AS PACKER_CODE
                          , B.DIVISION_ID               AS DIVISION_ID
                          , B.ITEM_ID                   AS PACK_MODEL_CODE
                          , FN_GET_ITEM_NICKNAME(B.DIVISION_ID, B.ITEM_ID)    AS NICK_NAME
                          , B.REQUEST_ID                AS SSP_CNFM
                          , B.TO_SITE                   AS SALES_SITE
                          , B.SHIPTO_CODE               AS SHIP_TO
                          , FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_DESCRIPTION')  AS SHIP_TO_NAME
                          , B.TRANSPORT_MODE
                          , B.INCOTERMS
                          , B.YYYYMMDD                  AS SHIP_PLAN_DATE
                          , TO_NUMBER(B.QTY)            AS SHIP_PLAN_QTY
                          , B.REMARK                    AS COMMENT_TEXT
                          , B.DIVISION_ID || '_' || V_PLAN_START_YYYYMMDD || '_' || V_IF_GROUP_NO  AS ATTR_01
                          /* 2026.09.30 AJS 수정 (START) */
--                          , CASE WHEN U2.USERNAME IS NOT NULL AND MU.USER_ID IS NOT NULL
--                                 THEN U2.USERNAME || '(' || MU.USER_ID || ')'
                          , CASE WHEN U2.USER_NM IS NOT NULL AND MU.USER_ID IS NOT NULL
                                 THEN U2.USER_NM || '(' || MU.USER_ID || ')'
                          /* 2026.09.30 AJS 수정 (END) */
                            END                         AS ATTR_03      /*Model PIC*/
                          , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, '', 'KO')     AS ATTR_04      /*MTK_OWNER*/
                          , NVL(LK.SEGMENT2, B.FCST_TYPE)                     AS ORDER_TYPE_DETAIL
                       FROM GT_0026_SAVE          B
                          , ( SELECT DIVISION_ID
                                   , PROJECT_CODE
                                   , SCM_SITE_ID
                                   , ITEM_ID
                                FROM ( SELECT DIVISION_ID
                                            , PROJECT_CODE
                                            , SCM_SITE_ID
                                            , ITEM_ID
                                            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                                                     ORDER BY PROJECT_CODE) NUM
                                         FROM SCM_MST_SITE_ITEM
                                     )  XA
                               WHERE NUM = 1
                            )  G
                          , SCM_MST_SITE_ITEM     SI
                          , SSP_MST_MODEL_USER    MU
                          /* 2026.09.30 AJS 수정 (START) */
--                          , TB_FX_USER            U2
                          , SCM_ADM_USER_M        U2
                          /* 2026.09.30 AJS 수정 (END) */
                          , SCM_ADM_LOOKUP_MASTER_DETAIL  LK
                      WHERE G.DIVISION_ID(+) = B.DIVISION_ID
                        AND G.SCM_SITE_ID(+) = B.TO_SITE
                        AND G.ITEM_ID(+)     = B.ITEM_ID
                        AND SI.DIVISION_ID(+)  = B.DIVISION_ID
                        AND SI.SCM_SITE_ID(+)  = B.TO_SITE
                        AND SI.ITEM_ID(+)      = B.ITEM_ID
                        AND SI.PROJECT_CODE(+) = G.PROJECT_CODE
                        AND MU.DIVISION_ID(+)  = B.DIVISION_ID
                        AND MU.FROM_SITE(+)    = B.FROM_SITE
                        AND MU.ITEM_ID(+)      = B.ITEM_ID
                        AND MU.VALID_YN(+)     = 'Y'
                        /* 2026.09.30 AJS 수정 (START) */
--                        AND MU.USER_ID         = U2.USERID(+)
--                        AND U2.USEYN(+)        = 'Y'
                        AND MU.USER_ID         = U2.USER_ID(+)
                        AND U2.USE_YN(+)       = 'Y'
                        /* 2026.09.30 AJS 수정 (END) */
                        AND LK.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                        AND LK.VALID_YN(+)     = 'Y'
                        AND B.FCST_TYPE        = LK.SEGMENT1(+)
                        AND 1 = 1
                        AND B.ACTIVE_FLAG      = 'I'
                   )  IA
                 , NERP_CONV_MASTER  IB
             WHERE IB.CODETYPE(+)   = 'SCP_SITE_ID'
               AND IA.PACKER_CODE   = IB.OLD_VALUE1(+);

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        -----------------------------------------------------------
        -- END LOG
        -----------------------------------------------------------
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE, CAST(NULL AS VARCHAR2(4000 CHAR)) AS MSG FROM DUAL;
        OPEN O_RC2 FOR
            SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0026_SAVE_DETAIL;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, error 메시지 반환
               ★AS-IS 는 이 갈래에서 결과셋을 내지 않고 -1 만 돌려준다.
                 화면이 결과코드를 읽도록 'F' 와 메시지를 함께 낸다. */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE, V_ERR_MESSAGE AS MSG FROM DUAL;
            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK;

    /*******************************************************************************
     * P_SSP0026_SAVE_SHIP_REQ_PACK
     *   AS-IS SSP0026_SAVE_SHIP_REQ_PACK
     *   Packer 출하 지시 본표 저장 (SSP_ANL_SHIP_PLAN_PACK_REQ · 이력 · SCS 송신표)
     *
     * ★AS-IS 결함 조치 : SCS 송신 문장이 임시 테이블에 없는 칸(ITEM_ID)을 참조해
     *   실행 중 오류(Invalid column name 'ITEM_ID')로 끊긴다. 되돌리기와 오류 로그가 모두
     *   주석으로 막혀 있어 원장 · 이력은 남고 SCS 송신만 만들어지지 않으며 화면에도 알림이 없다.
     *   (실측 : 사업부 40 · 품목 MPPLGEU40P1N 로 원문 실행 — 오류 207, 이력 1행 생성, 송신 0행)
     *   임시 테이블의 품목 칸 이름은 MODEL_ID 이므로 그 이름으로 고쳐 송신이 만들어지게 한다.
     *
     * ★되돌리기를 커서 OPEN 앞에 둔다(ROLLBACK 이 뒤에 오면 커서가 닫힌다).
     *******************************************************************************/
    PROCEDURE P_SSP0026_SAVE_SHIP_REQ_PACK
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_FCST_TYPE             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_MEASURE               IN  VARCHAR2
      , P_YYYYMMDD              IN  VARCHAR2
      , P_QTY                   IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        C_DELIMITER             CONSTANT VARCHAR2(1 CHAR)  := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0026_SAVE_SHIP_REQ_PACK';
        V_TABLE_ID              VARCHAR2(150 CHAR) := 'SSP_ANL_SHIP_PLAN_PACK_REQ';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)   := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_IF_GROUP_NO           VARCHAR2(50 CHAR)  := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_CNT                   PLS_INTEGER := 0;

        V_ACTIVE_FLAG           VARCHAR2(1 CHAR);
        V_DIVISION_ID           VARCHAR2(30 CHAR);
        V_ITEM_ID               VARCHAR2(50 CHAR);
        V_FROM_SITE             VARCHAR2(50 CHAR);
        V_TO_SITE               VARCHAR2(30 CHAR);
        V_PROJECT_CODE          VARCHAR2(30 CHAR);
        V_INCOTERMS             VARCHAR2(10 CHAR);
        V_FCST_TYPE             VARCHAR2(10 CHAR);
        V_TRANSPORT_MODE        VARCHAR2(10 CHAR);
        V_MEASURE               VARCHAR2(50 CHAR);
        V_YYYYMMDD              VARCHAR2(8 CHAR);
        V_QTY                   VARCHAR2(30 CHAR);

        V_DIVISION_ID_TEMP          VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000 CHAR);
        V_FROM_SITE_TEMP            VARCHAR2(4000 CHAR);
        V_TO_SITE_TEMP              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000 CHAR);

        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0026_SAVE_PACK;

        DELETE FROM GT_0026_SAVE;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'SHIP_PLAN INSERT LOGIC';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ITEM_ID, C_DELIMITER));

        /*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
        WHILE LENGTH(P_DIVISION_ID) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG     := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,    C_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID     := SCM_ARR_SPL_VAL(P_DIVISION_ID,    C_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID         := SCM_ARR_SPL_VAL(P_ITEM_ID,        C_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE       := SCM_ARR_SPL_VAL(P_FROM_SITE,      C_DELIMITER, V_MST_LOOP_CNT);
            V_TO_SITE         := SCM_ARR_SPL_VAL(P_TO_SITE,        C_DELIMITER, V_MST_LOOP_CNT);
            V_PROJECT_CODE    := SCM_ARR_SPL_VAL(P_PROJECT_CODE,   C_DELIMITER, V_MST_LOOP_CNT);
            V_INCOTERMS       := SCM_ARR_SPL_VAL(P_INCOTERMS,      C_DELIMITER, V_MST_LOOP_CNT);
            V_FCST_TYPE       := SCM_ARR_SPL_VAL(P_FCST_TYPE,      C_DELIMITER, V_MST_LOOP_CNT);
            V_TRANSPORT_MODE  := SCM_ARR_SPL_VAL(P_TRANSPORT_MODE, C_DELIMITER, V_MST_LOOP_CNT);
            /*V_BOD_ID        := SCM_ARR_SPL_VAL(P_BOD_ID,         C_DELIMITER, V_MST_LOOP_CNT);*/
            V_MEASURE         := SCM_ARR_SPL_VAL(P_MEASURE,        C_DELIMITER, V_MST_LOOP_CNT);
            V_YYYYMMDD        := SCM_ARR_SPL_VAL(P_YYYYMMDD,       C_DELIMITER, V_MST_LOOP_CNT);
            V_QTY             := SCM_ARR_SPL_VAL(P_QTY,            C_DELIMITER, V_MST_LOOP_CNT);

            V_DIVISION_ID_TEMP        := NULL;
            V_NEW_BOD_ID_TEMP         := NULL;
            V_FROM_SITE_TEMP          := NULL;
            V_TO_SITE_TEMP            := NULL;
            V_NEW_INCOTERMS_TEMP      := NULL;
            V_NEW_TRANSPORT_MODE_TEMP := NULL;
            V_NEW_ROUTE_ID_TEMP       := NULL;
            V_NEW_D_CONTRY_TEMP       := NULL;
            V_NEW_D_PORT_CODE_TEMP    := NULL;
            V_NEW_A_COUNTRY_TEMP      := NULL;
            V_NEW_A_PORT_CODE_TEMP    := NULL;
            V_NEW_CUSTOMER_LT_TEMP    := NULL;
            V_NEW_TO_COUNTRY_TEMP     := NULL;
            V_NEW_TO_CITY_TEMP        := NULL;

            BEGIN
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SSP_INCOTERMS
                     , TRANSPORT_MODE
                     , ROUTE_ID
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , LT_TOTAL
                     , TO_COUNTRY
                     , TO_CITY
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM ( SELECT B.DIVISION_ID
                              , B.BOD_ID
                              , B.FROM_SITE
                              , B.TO_SITE
                              , B.SSP_INCOTERMS
                              , B.TRANSPORT_MODE
                              , B.ROUTE_ID
                              , B.D_COUNTRY
                              , B.D_PORT_CODE
                              , B.A_COUNTRY
                              , B.A_PORT_CODE
                              , B.LT_TOTAL
                              , B.TO_COUNTRY
                              , B.TO_CITY
                              , B.PRIORITY
                           FROM ( SELECT DISTINCT B.DIVISION_ID
                                       , B.BOD_ID
                                       , B.FROM_SITE
                                       , B.TO_SITE
                                       , B.SSP_INCOTERMS
                                       , B.TRANSPORT_MODE
                                       , B.ROUTE_ID
                                       , B.D_COUNTRY
                                       , B.D_PORT_CODE
                                       , B.A_COUNTRY
                                       , B.A_PORT_CODE
                                       , B.LT_TOTAL
                                       , B.LT_TOTAL_ORIGIN
                                       , B.TO_COUNTRY
                                       , B.TO_CITY
                                       , B.PRIORITY
                                       , B.BOD_VALID_YN
                                    FROM SCP_MST_BOD_N_V  B
                                   WHERE B.DIVISION_ID      = V_DIVISION_ID
                                     AND B.FROM_SITE        = V_FROM_SITE
                                     AND UPPER(B.TO_SITE)   = UPPER(V_TO_SITE)
                                     AND B.TRANSPORT_MODE   = V_TRANSPORT_MODE
                                     AND B.SSP_INCOTERMS    = V_INCOTERMS
                                     AND B.BOD_VALID_YN     = 'Y'
                                     AND B.FROM_YYYYMMDD   <= V_YYYYMMDD
                                     AND B.TO_YYYYMMDD     >= V_YYYYMMDD
                                )  B
                              , ( SELECT DISTINCT DIVISION_ID
                                       , ITEM_ID
                                       , BOD_ID
                                    FROM SCP_MST_BOD_ITEM
                                   WHERE DIVISION_ID = V_DIVISION_ID
                                     AND ITEM_ID     = V_ITEM_ID
                                )  A
                          WHERE A.DIVISION_ID = B.DIVISION_ID
                            AND A.BOD_ID      = B.BOD_ID
                            AND 1 = 1
                          ORDER BY B.PRIORITY
                       )  IA
                 WHERE ROWNUM <= 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            IF (    TRIM(V_DIVISION_ID_TEMP)        IS NULL
                 OR TRIM(V_NEW_BOD_ID_TEMP)         IS NULL
                 OR TRIM(V_FROM_SITE_TEMP)          IS NULL
                 OR TRIM(V_TO_SITE_TEMP)            IS NULL
                 OR TRIM(V_NEW_INCOTERMS_TEMP)      IS NULL
                 OR TRIM(V_NEW_TRANSPORT_MODE_TEMP) IS NULL
                 OR TRIM(V_NEW_ROUTE_ID_TEMP)       IS NULL
                 OR TRIM(V_NEW_D_CONTRY_TEMP)       IS NULL
                 OR TRIM(V_NEW_D_PORT_CODE_TEMP)    IS NULL
                 OR TRIM(V_NEW_A_COUNTRY_TEMP)      IS NULL
                 OR TRIM(V_NEW_A_PORT_CODE_TEMP)    IS NULL
                 OR TRIM(V_NEW_CUSTOMER_LT_TEMP)    IS NULL
                 OR TRIM(V_NEW_TO_COUNTRY_TEMP)     IS NULL
                 OR TRIM(V_NEW_TO_CITY_TEMP)        IS NULL
               ) THEN

                ROLLBACK TO SP_SSP0026_SAVE_PACK;

                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '';
                D_EVENT_DATE  := SYSDATE;
                PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                OPEN O_RC1 FOR
                    SELECT 'X' AS RESULT_CODE, CAST(NULL AS VARCHAR2(30 CHAR)) AS REQUEST_NO FROM DUAL;
                OPEN O_RC2 FOR
                    SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;
                RETURN;

            END IF;

            INSERT INTO GT_0026_SAVE
                 ( ACTIVE_FLAG, DIVISION_ID, MODEL_ID, FROM_SITE, TO_SITE, PROJECT_CODE
                 , INCOTERMS, FCST_TYPE, TRANSPORT_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, REQUEST_ID )
            SELECT V_ACTIVE_FLAG                AS ACTIVE_FLAG
                 , V_DIVISION_ID                AS DIVISION_ID
                 , V_ITEM_ID                    AS MODEL_ID
                 , V_FROM_SITE                  AS FROM_SITE
                 , V_TO_SITE                    AS TO_SITE
                 , V_PROJECT_CODE               AS PROJECT_CODE
                 , V_NEW_INCOTERMS_TEMP         AS INCOTERMS
                 , V_FCST_TYPE                  AS FCST_TYPE
                 , V_NEW_TRANSPORT_MODE_TEMP    AS TRANSPORT_MODE
                 , V_NEW_BOD_ID_TEMP            AS BOD_ID
                 , V_MEASURE                    AS MEASURE
                 , V_YYYYMMDD                   AS YYYYMMDD
                 , V_QTY                        AS QTY
                 , 'R' || TO_CHAR(SYSDATE, 'YYYYMMDD')
                       || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID.NEXTVAL), -6)  AS REQUEST_ID
              FROM DUAL;

        END LOOP;

        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0026_SAVE;

        IF V_CNT > 0 THEN

            D_EVENT_DATE := SYSDATE;
            /* 수정
               삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행 */
            UPDATE SSP_ANL_SHIP_PLAN_PACK_REQ  A
               SET ( QTY, REQUEST_ID, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                 = ( SELECT TO_NUMBER(B.QTY)
                          , CASE WHEN A.REQUEST_ID IS NULL THEN B.REQUEST_ID ELSE A.REQUEST_ID END
                          , P_CREATED_BY
                          , D_EVENT_DATE
                       FROM GT_0026_SAVE  B
                      WHERE A.DIVISION_ID     = B.DIVISION_ID
                        AND A.FROM_SITE       = B.FROM_SITE
                        AND A.TO_SITE         = B.TO_SITE
                        AND A.MODEL_ID        = B.MODEL_ID
                        AND A.INCOTERMS       = B.INCOTERMS
                        AND A.BOD_ID          = B.BOD_ID
                        AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                        AND A.YYYYMMDD        = B.YYYYMMDD
                        AND A.SHIPTO_CODE     = ( SELECT SHIPTO_CODE
                                                    FROM SCM_MST_SITE_CUSTOMER
                                                   WHERE DIVISION_ID = B.DIVISION_ID
                                                     AND SCM_SITE_ID = B.TO_SITE
                                                     AND VALID_YN    = 'Y'
                                                     AND REP_YN      = 'Y' )
                        AND ROWNUM           <= 1 )
             WHERE EXISTS ( SELECT 1
                              FROM GT_0026_SAVE  B
                             WHERE A.DIVISION_ID     = B.DIVISION_ID
                               AND A.FROM_SITE       = B.FROM_SITE
                               AND A.TO_SITE         = B.TO_SITE
                               AND A.MODEL_ID        = B.MODEL_ID
                               AND A.INCOTERMS       = B.INCOTERMS
                               AND A.BOD_ID          = B.BOD_ID
                               AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                               AND A.YYYYMMDD        = B.YYYYMMDD
                               AND A.SHIPTO_CODE     = ( SELECT SHIPTO_CODE
                                                           FROM SCM_MST_SITE_CUSTOMER
                                                          WHERE DIVISION_ID = B.DIVISION_ID
                                                            AND SCM_SITE_ID = B.TO_SITE
                                                            AND VALID_YN    = 'Y'
                                                            AND REP_YN      = 'Y' ) );

            /* 2020.09.21 KIM BOK KI HISTORY 추가
               2021.11.03 SHIN MYUNG SU 수정 ( SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경) */
            INSERT INTO SSP_ANL_SHIP_REQ_P_H
                 ( HISTORY_SEQ, DIVISION_ID, SHIPTO_CODE, YYYYMMDD, BOD_ID, QTY, REQUEST_ID, CONFIRM_ID
                 , ORDER_TYPE_DETAIL, REMARK, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ITEM_ID )
            SELECT SEQ1_SSP_ANL_SHIP_PACKER_REQ_H.NEXTVAL   AS HISTORY_SEQ
                 , A.DIVISION_ID
                 , A.SHIPTO_CODE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , A.QTY
                 , A.REQUEST_ID
                 , A.CONFIRM_ID
                 , A.ORDER_TYPE_DETAIL
                 , A.REMARK
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , A.LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
                 , A.ATTRIBUTE1
                 , A.ATTRIBUTE2
                 , A.ATTRIBUTE3
                 , A.ATTRIBUTE4
                 , A.ATTRIBUTE5
                 , A.ATTRIBUTE6
                 , A.ATTRIBUTE7
                 , A.ATTRIBUTE8
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , B.MODEL_ID
              FROM SSP_ANL_SHIP_PLAN_PACK_REQ  A
                 , GT_0026_SAVE                B
             WHERE A.DIVISION_ID     = B.DIVISION_ID
               AND A.FROM_SITE       = B.FROM_SITE
               AND A.TO_SITE         = B.TO_SITE
               AND A.SHIPTO_CODE     = FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_CODE')
               AND A.MODEL_ID        = B.MODEL_ID
               AND A.INCOTERMS       = B.INCOTERMS
               AND A.BOD_ID          = B.BOD_ID
               AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
               AND A.YYYYMMDD        = B.YYYYMMDD
               AND 1 = 1;

            /* SCS I/F 정보 생성 — I/F 주체는 SCS 에서 함 */
            INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
                 ( IF_SEQ, IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, PACKER_CODE, DIVISION_ID
                 , PLAN_VERSION, PACK_MODEL_CODE, NICK_NAME, TARGET_ORDER, SSP_CNFM, SALES_SITE
                 , SHIP_TO, SHIP_TO_NAME, TRANSPORT_MODE, INCOTERMS, SHIP_PLAN_DATE, SHIP_PLAN_QTY
                 , "COMMENT", ATTR_01, ATTR_02, ATTR_03, ATTR_04, ATTR_05, ATTR_06, ATTR_07
                 , ATTR_08, ATTR_09, ATTR_10, ORDER_TYPE_DETAIL )
            SELECT 'OSCM' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10)  AS IF_SEQ
                 , 'I'                                  AS IF_TYPE
                 , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'       AS IF_ID
                 , SYSDATE                              AS IF_INS_DATE
                 , 'N'                                  AS IF_FLAG
                 , NVL(IB.NEW_VALUE1, IA.PACKER_CODE)   AS PACKER_CODE
                 , IA.DIVISION_ID
                 , V_PLAN_START_YYYYMMDD                AS PLAN_VERSION
                 , IA.PACK_MODEL_CODE
                 , IA.NICK_NAME
                 , 'O'                                  AS TARGET_ORDER
                 , '-'                                  AS SSP_CNFM
                 , IA.SALES_SITE
                 , IA.SHIP_TO
                 , IA.SHIP_TO_NAME
                 , IA.TRANSPORT_MODE
                 , IA.INCOTERMS
                 , IA.SHIP_PLAN_DATE
                 , IA.SHIP_PLAN_QTY
                 , NULL                                 AS "COMMENT"
                 , IA.ATTR_01
                 , NULL                                 AS ATTR_02
                 , IA.ATTR_03                           /*Model PIC*/
                 , IA.ATTR_04                           /*MTK_OWNER*/
                 , NULL                                 AS ATTR_05
                 , NULL                                 AS ATTR_06
                 , NULL                                 AS ATTR_07
                 , NULL                                 AS ATTR_08
                 , NULL                                 AS ATTR_09
                 , IA.ATTR_10
                 , IA.ORDER_TYPE_DETAIL
              FROM ( SELECT A.FROM_SITE                 AS PACKER_CODE
                          , A.DIVISION_ID               AS DIVISION_ID
                          , A.MODEL_ID                  AS PACK_MODEL_CODE
                          , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.MODEL_ID)   AS NICK_NAME
                          , A.TO_SITE                   AS SALES_SITE
                          , FN_GET_SITE_CUSTOMER_INFO(A.DIVISION_ID, A.TO_SITE, 'SHIPTO_CODE')         AS SHIP_TO
                          , FN_GET_SITE_CUSTOMER_INFO(A.DIVISION_ID, A.TO_SITE, 'SHIPTO_DESCRIPTION')  AS SHIP_TO_NAME
                          , A.TRANSPORT_MODE
                          , A.INCOTERMS
                          , A.YYYYMMDD                  AS SHIP_PLAN_DATE
                          , TO_NUMBER(B.QTY)            AS SHIP_PLAN_QTY
                          , A.DIVISION_ID || '_' || V_PLAN_START_YYYYMMDD || '_' || V_IF_GROUP_NO  AS ATTR_01
                          /* MSSQL 문자 결합은 한쪽이 빈값이면 전체가 빈값이므로 같게 맞춘다 */
                          /* 2026.09.30 AJS 수정 (START) */
--                          , CASE WHEN U2.USERNAME IS NOT NULL AND MU.USER_ID IS NOT NULL
--                                 THEN U2.USERNAME || '(' || MU.USER_ID || ')'
                          , CASE WHEN U2.USER_NM IS NOT NULL AND MU.USER_ID IS NOT NULL
                                 THEN U2.USER_NM || '(' || MU.USER_ID || ')'
                          /* 2026.09.30 AJS 수정 (END) */
                            END                         AS ATTR_03      /*Model PIC*/
                          , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, '', 'KO')     AS ATTR_04      /*MTK_OWNER*/
                          , B.REQUEST_ID                AS ATTR_10
                          , NVL(LK.SEGMENT2, A.FCST_TYPE)                     AS ORDER_TYPE_DETAIL
                       FROM SSP_ANL_SHIP_PLAN_PACK_REQ  A
                          , GT_0026_SAVE                B
                          , ( SELECT DIVISION_ID
                                   , PROJECT_CODE
                                   , SCM_SITE_ID
                                   , ITEM_ID
                                FROM ( SELECT DIVISION_ID
                                            , PROJECT_CODE
                                            , SCM_SITE_ID
                                            , ITEM_ID
                                            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                                                     ORDER BY PROJECT_CODE) NUM
                                         FROM SCM_MST_SITE_ITEM
                                     )  XA
                               WHERE NUM = 1
                            )  G
                          , SCM_MST_SITE_ITEM     SI
                          , SSP_MST_MODEL_USER    MU
                          /* 2026.09.30 AJS 수정 (START) */
--                          , TB_FX_USER            U2
                          , SCM_ADM_USER_M        U2
                          /* 2026.09.30 AJS 수정 (END) */
                          , SCM_ADM_LOOKUP_MASTER_DETAIL  LK
                      WHERE A.DIVISION_ID     = B.DIVISION_ID
                        AND A.FROM_SITE       = B.FROM_SITE
                        AND A.TO_SITE         = B.TO_SITE
                        AND A.MODEL_ID        = B.MODEL_ID
                        AND A.INCOTERMS       = B.INCOTERMS
                        AND A.BOD_ID          = B.BOD_ID
                        AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                        AND A.YYYYMMDD        = B.YYYYMMDD
                        AND A.SHIPTO_CODE     = ( SELECT SHIPTO_CODE
                                                    FROM SCM_MST_SITE_CUSTOMER
                                                   WHERE DIVISION_ID = B.DIVISION_ID
                                                     AND SCM_SITE_ID = B.TO_SITE
                                                     AND VALID_YN    = 'Y'
                                                     AND REP_YN      = 'Y' )
                        /* 20211102  SHINMYUNGSU  추가
                           ★AS-IS 는 여기서 B.ITEM_ID 를 쓰는데 임시 테이블에는 그 칸이 없어 실행이 끊긴다.
                             임시 테이블의 품목 칸 이름(MODEL_ID)으로 고쳤다. */
                        AND G.DIVISION_ID(+)   = B.DIVISION_ID
                        AND G.SCM_SITE_ID(+)   = B.TO_SITE
                        AND G.ITEM_ID(+)       = B.MODEL_ID
                        AND SI.DIVISION_ID(+)  = B.DIVISION_ID
                        AND SI.SCM_SITE_ID(+)  = B.TO_SITE
                        AND SI.ITEM_ID(+)      = B.MODEL_ID
                        AND SI.PROJECT_CODE(+) = G.PROJECT_CODE
                        AND MU.DIVISION_ID(+)  = B.DIVISION_ID
                        AND MU.FROM_SITE(+)    = B.FROM_SITE
                        AND MU.ITEM_ID(+)      = B.MODEL_ID
                        AND MU.VALID_YN(+)     = 'Y'
                        /* 2026.09.30 AJS 수정 (START) */
--                        AND MU.USER_ID         = U2.USERID(+)
--                        AND U2.USEYN(+)        = 'Y'
                        AND MU.USER_ID         = U2.USER_ID(+)
                        AND U2.USE_YN(+)       = 'Y'
                        /* 2026.09.30 AJS 수정 (END) */
                        AND LK.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                        AND LK.VALID_YN(+)     = 'Y'
                        AND B.FCST_TYPE        = LK.SEGMENT1(+)
                   )  IA
                 , NERP_CONV_MASTER  IB
             WHERE IB.CODETYPE(+)   = 'SCP_SITE_ID'
               AND IA.PACKER_CODE   = IB.OLD_VALUE1(+);

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;
        /* UPDATE END */

        /* INSERT START */
        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0026_SAVE  B
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM SSP_ANL_SHIP_PLAN_PACK_REQ  A
                             WHERE 1 = 1
                               AND A.DIVISION_ID = B.DIVISION_ID
                               AND A.FROM_SITE   = B.FROM_SITE
                               AND A.TO_SITE     = B.TO_SITE
                               AND A.MODEL_ID    = B.MODEL_ID
                               AND A.YYYYMMDD    = B.YYYYMMDD
                               AND A.BOD_ID      = B.BOD_ID );

        IF V_CNT > 0 THEN

            /* INSERT 대상 건 ACTIVE FLAG 변경 */
            UPDATE GT_0026_SAVE  A
               SET A.ACTIVE_FLAG = 'I'
             WHERE NOT EXISTS ( SELECT 1
                                  FROM SSP_ANL_SHIP_PLAN_PACK_REQ  B
                                 WHERE 1 = 1
                                   AND A.DIVISION_ID = B.DIVISION_ID
                                   AND A.FROM_SITE   = B.FROM_SITE
                                   AND A.TO_SITE     = B.TO_SITE
                                   AND A.MODEL_ID    = B.MODEL_ID
                                   AND A.YYYYMMDD    = B.YYYYMMDD
                                   AND A.BOD_ID      = B.BOD_ID );

            /* 신규 REQEUST INSERT — DETAIL INSERT */
            INSERT INTO SSP_ANL_SHIP_PLAN_PACK_REQ
                 ( DIVISION_ID, MODEL_TYPE, FROM_SITE, TO_SITE, MODEL_ID, SHIPTO_CODE, BOD_ID
                 , YYYYMMDD, QTY, REQUEST_ID, INCOTERMS, TRANSPORT_MODE, ORDER_TYPE_DETAIL, REMARK
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            SELECT B.DIVISION_ID
                 , '-'
                 , B.FROM_SITE
                 , B.TO_SITE
                 , B.MODEL_ID
                 , FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_CODE')   AS SHIP_TO
                 , B.BOD_ID
                 , B.YYYYMMDD
                 , TO_NUMBER(B.QTY)
                 , B.REQUEST_ID
                 , B.INCOTERMS
                 , B.TRANSPORT_MODE
                 , '-'                          AS ORDER_TYPE_DETAIL
                 , '-'                          AS REMARK
                 , P_CREATED_BY                 AS CREATED_BY
                 , D_EVENT_DATE                 AS CREATION_DATE
                 , P_CREATED_BY                 AS LAST_UPDATED_BY
                 , D_EVENT_DATE                 AS LAST_UPDATE_DATE
              FROM GT_0026_SAVE  B
             WHERE 1 = 1
               AND NOT EXISTS ( SELECT 1
                                  FROM SSP_ANL_SHIP_PLAN_PACK_REQ  A
                                 WHERE 1 = 1
                                   AND A.DIVISION_ID = B.DIVISION_ID
                                   AND A.FROM_SITE   = B.FROM_SITE
                                   AND A.TO_SITE     = B.TO_SITE
                                   AND A.SHIPTO_CODE = FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_CODE')
                                   AND A.MODEL_ID    = B.MODEL_ID
                                   AND A.YYYYMMDD    = B.YYYYMMDD
                                   AND A.BOD_ID      = B.BOD_ID );

            /* 2020.09.21 KIM BOK KI HISTORY 추가 */
            INSERT INTO SSP_ANL_SHIP_REQ_P_H
                 ( HISTORY_SEQ, DIVISION_ID, SHIPTO_CODE, YYYYMMDD, BOD_ID, QTY, REQUEST_ID, CONFIRM_ID
                 , ORDER_TYPE_DETAIL, REMARK, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ITEM_ID )
            SELECT SEQ1_SSP_ANL_SHIP_PACKER_REQ_H.NEXTVAL   AS HISTORY_SEQ
                 , A.DIVISION_ID
                 , A.SHIPTO_CODE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , A.QTY
                 , A.REQUEST_ID
                 , A.CONFIRM_ID
                 , A.ORDER_TYPE_DETAIL
                 , A.REMARK
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , A.LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
                 , A.ATTRIBUTE1
                 , A.ATTRIBUTE2
                 , A.ATTRIBUTE3
                 , A.ATTRIBUTE4
                 , A.ATTRIBUTE5
                 , A.ATTRIBUTE6
                 , A.ATTRIBUTE7
                 , A.ATTRIBUTE8
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , B.MODEL_ID
              FROM SSP_ANL_SHIP_PLAN_PACK_REQ  A
                 , GT_0026_SAVE                B
             WHERE A.DIVISION_ID     = B.DIVISION_ID
               AND A.FROM_SITE       = B.FROM_SITE
               AND A.TO_SITE         = B.TO_SITE
               AND A.SHIPTO_CODE     = FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_CODE')
               AND A.MODEL_ID        = B.MODEL_ID
               AND A.INCOTERMS       = B.INCOTERMS
               AND A.BOD_ID          = B.BOD_ID
               AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
               AND A.YYYYMMDD        = B.YYYYMMDD
               AND 1 = 1;

            /* SCS I/F 정보 생성 — I/F 주체는 SCS 에서 함 */
            INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
                 ( IF_SEQ, IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, PACKER_CODE, DIVISION_ID
                 , PLAN_VERSION, PACK_MODEL_CODE, NICK_NAME, TARGET_ORDER, SSP_CNFM, SALES_SITE
                 , SHIP_TO, SHIP_TO_NAME, TRANSPORT_MODE, INCOTERMS, SHIP_PLAN_DATE, SHIP_PLAN_QTY
                 , "COMMENT", ATTR_01, ATTR_02, ATTR_03, ATTR_04, ATTR_05, ATTR_06, ATTR_07
                 , ATTR_08, ATTR_09, ATTR_10, ORDER_TYPE_DETAIL )
            SELECT 'OSCM' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10)  AS IF_SEQ
                 , 'I'                                  AS IF_TYPE
                 , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'       AS IF_ID
                 , SYSDATE                              AS IF_INS_DATE
                 , 'N'                                  AS IF_FLAG
                 , NVL(IB.NEW_VALUE1, IA.PACKER_CODE)   AS PACKER_CODE
                 , IA.DIVISION_ID
                 , V_PLAN_START_YYYYMMDD                AS PLAN_VERSION
                 , IA.PACK_MODEL_CODE
                 , IA.NICK_NAME
                 , 'O'                                  AS TARGET_ORDER
                 , '-'                                  AS SSP_CNFM
                 , IA.SALES_SITE
                 , IA.SHIP_TO
                 , IA.SHIP_TO_NAME
                 , IA.TRANSPORT_MODE
                 , IA.INCOTERMS
                 , IA.SHIP_PLAN_DATE
                 , IA.SHIP_PLAN_QTY
                 , NULL                                 AS "COMMENT"
                 , IA.ATTR_01
                 , NULL                                 AS ATTR_02
                 , IA.ATTR_03                           /*Model PIC*/
                 , IA.ATTR_04                           /*MTK_OWNER*/
                 , NULL                                 AS ATTR_05
                 , NULL                                 AS ATTR_06
                 , NULL                                 AS ATTR_07
                 , NULL                                 AS ATTR_08
                 , NULL                                 AS ATTR_09
                 , IA.ATTR_10
                 , IA.ORDER_TYPE_DETAIL
              FROM ( SELECT B.FROM_SITE                 AS PACKER_CODE
                          , B.DIVISION_ID               AS DIVISION_ID
                          , B.MODEL_ID                  AS PACK_MODEL_CODE
                          , FN_GET_ITEM_NICKNAME(B.DIVISION_ID, B.MODEL_ID)   AS NICK_NAME
                          , B.TO_SITE                   AS SALES_SITE
                          , FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_CODE')         AS SHIP_TO
                          , FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_DESCRIPTION')  AS SHIP_TO_NAME
                          , B.TRANSPORT_MODE
                          , B.INCOTERMS
                          , B.YYYYMMDD                  AS SHIP_PLAN_DATE
                          , TO_NUMBER(B.QTY)            AS SHIP_PLAN_QTY
                          , B.DIVISION_ID || '_' || V_PLAN_START_YYYYMMDD || '_' || V_IF_GROUP_NO  AS ATTR_01
                          /* 2026.09.30 AJS 수정 (START) */
--                          , CASE WHEN U2.USERNAME IS NOT NULL AND MU.USER_ID IS NOT NULL
--                                 THEN U2.USERNAME || '(' || MU.USER_ID || ')'
                          , CASE WHEN U2.USER_NM IS NOT NULL AND MU.USER_ID IS NOT NULL
                                 THEN U2.USER_NM || '(' || MU.USER_ID || ')'
                          /* 2026.09.30 AJS 수정 (END) */
                            END                         AS ATTR_03      /*Model PIC*/
                          , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, '', 'KO')     AS ATTR_04      /*MTK_OWNER*/
                          , B.REQUEST_ID                AS ATTR_10
                          , NVL(LK.SEGMENT2, B.FCST_TYPE)                     AS ORDER_TYPE_DETAIL
                       FROM GT_0026_SAVE          B
                          , ( SELECT DIVISION_ID
                                   , PROJECT_CODE
                                   , SCM_SITE_ID
                                   , ITEM_ID
                                FROM ( SELECT DIVISION_ID
                                            , PROJECT_CODE
                                            , SCM_SITE_ID
                                            , ITEM_ID
                                            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                                                     ORDER BY PROJECT_CODE) NUM
                                         FROM SCM_MST_SITE_ITEM
                                     )  XA
                               WHERE NUM = 1
                            )  G
                          , SCM_MST_SITE_ITEM     SI
                          , SSP_MST_MODEL_USER    MU
                          /* 2026.09.30 AJS 수정 (START) */
--                          , TB_FX_USER            U2
                          , SCM_ADM_USER_M        U2
                          /* 2026.09.30 AJS 수정 (END) */
                          , SCM_ADM_LOOKUP_MASTER_DETAIL  LK
                      WHERE G.DIVISION_ID(+)   = B.DIVISION_ID
                        AND G.SCM_SITE_ID(+)   = B.TO_SITE
                        AND G.ITEM_ID(+)       = B.MODEL_ID
                        AND SI.DIVISION_ID(+)  = B.DIVISION_ID
                        AND SI.SCM_SITE_ID(+)  = B.TO_SITE
                        AND SI.ITEM_ID(+)      = B.MODEL_ID
                        AND SI.PROJECT_CODE(+) = G.PROJECT_CODE
                        AND MU.DIVISION_ID(+)  = B.DIVISION_ID
                        AND MU.FROM_SITE(+)    = B.FROM_SITE
                        AND MU.ITEM_ID(+)      = B.MODEL_ID
                        AND MU.VALID_YN(+)     = 'Y'
                        /* 2026.09.30 AJS 수정 (START) */
--                        AND MU.USER_ID         = U2.USERID(+)
--                        AND U2.USEYN(+)        = 'Y'
                        AND MU.USER_ID         = U2.USER_ID(+)
                        AND U2.USE_YN(+)       = 'Y'
                        /* 2026.09.30 AJS 수정 (END) */
                        AND LK.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                        AND LK.VALID_YN(+)     = 'Y'
                        AND B.FCST_TYPE        = LK.SEGMENT1(+)
                        AND 1 = 1
                        AND B.ACTIVE_FLAG      = 'I'
                   )  IA
                 , NERP_CONV_MASTER  IB
             WHERE IB.CODETYPE(+)   = 'SCP_SITE_ID'
               AND IA.PACKER_CODE   = IB.OLD_VALUE1(+);

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        -----------------------------------------------------------
        -- END LOG
        -----------------------------------------------------------
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE, CAST(NULL AS VARCHAR2(4000 CHAR)) AS MSG FROM DUAL;
        OPEN O_RC2 FOR
            SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0026_SAVE_PACK;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE, V_ERR_MESSAGE AS MSG FROM DUAL;
            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0026_SAVE_SHIP_REQ_PACK;

    /*******************************************************************************
     * P_SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD
     *   AS-IS SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD
     *   Packer 출하 지시 엑셀 업로드 (검사 + 반영)
     *
     * AS-IS 절차
     *   P_MODE = 0 : 올린 줄을 검사해 상태(UPLOAD · SKIP · @TITLE · ERROR · SUCCESS)와 메시지를 남긴다.
     *   P_MODE > 0 : ERROR 가 한 줄도 없으면 SUCCESS 줄을 지시 원장 · 이력 · SCS 송신표에 반영한다.
     *
     * ★올린 줄을 고르는 열쇠는 「화면 · 시트 · 올린 사람 · 올린 시각의 최대값」이다.
     *   AS-IS 는 그 시각을 문자로 바꿔 견주지만 같은 값끼리의 비교이므로 시각 그대로 견준다.
     * ★올린 자료가 없으면 AS-IS 는 로그만 남기고 그대로 이어간다(되돌아가지 않는다). 그대로 옮긴다.
     * ★결과 칸은 AS-IS 에 없다(화면이 업로드 표를 다시 읽는다). 서버 규약에 맞춰 결과코드만 낸다.
     * ★되돌리기를 커서 OPEN 앞에 둔다(ROLLBACK 이 뒤에 오면 커서가 닫힌다).
     *******************************************************************************/
    PROCEDURE P_SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD
    (
        P_MODE                  IN  NUMBER
      , P_CREATED_BY            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_ID            CONSTANT VARCHAR2(40 CHAR) := 'SSP0026';
        C_SHEET_NAME            CONSTANT VARCHAR2(40 CHAR) := 'Shipment Request(IT & Mobile)';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        V_CREATION_DATE         TIMESTAMP;
        V_COUNT                 PLS_INTEGER := 0;
        V_CNT                   PLS_INTEGER := 0;
        V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)   := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_IF_GROUP_NO           VARCHAR2(50 CHAR)  := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0026_SAVE_EXCEL;

        DELETE FROM GT_0026_SAVE;

        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        SELECT MAX(CREATION_DATE)
          INTO V_CREATION_DATE
          FROM SCM_ADM_EXCEL_UPLOAD
         WHERE PROGRAM_ID = C_PROGRAM_ID
           AND SHEET_NAME = C_SHEET_NAME
           AND CREATED_BY = P_CREATED_BY;

        IF V_CREATION_DATE IS NULL THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Data Not Found []';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;

        /* @p_mode = 0 이면 Validation */
        IF NVL(P_MODE, 0) = 0 THEN

            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'UPLOAD'
                 , MESSAGE_TEXT       = NULL
             WHERE PROGRAM_ID    = C_PROGRAM_ID
               AND SHEET_NAME    = C_SHEET_NAME
               AND CREATED_BY    = P_CREATED_BY
               AND CREATION_DATE = V_CREATION_DATE
               AND NVL(UPLOAD_STATUS_CODE, 'X') <> 'UPLOAD';

            V_LOG_TYPE    := '1';
            V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* ///////////////////////////// VALIDATION CHECK /////////////////////////
               DIVISION_ID 없을 경우 SKIP 처리 ( ATTRIBUTE1 ) */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'SKIP'
             WHERE PROGRAM_ID    = C_PROGRAM_ID
               AND SHEET_NAME    = C_SHEET_NAME
               AND CREATED_BY    = P_CREATED_BY
               AND CREATION_DATE = V_CREATION_DATE
               AND TRIM(ATTRIBUTE1) IS NULL;

            V_LOG_TYPE    := '2';
            V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* TITLE 처리 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = '@TITLE'
             WHERE PROGRAM_ID    = C_PROGRAM_ID
               AND SHEET_NAME    = C_SHEET_NAME
               AND CREATED_BY    = P_CREATED_BY
               AND CREATION_DATE = V_CREATION_DATE
               AND ( UPPER(ATTRIBUTE1) = 'DIV*' OR UPPER(ATTRIBUTE1) = 'DIV' OR UPPER(ATTRIBUTE1) = 'DIVISION' );

            V_LOG_TYPE    := '3';
            V_LOG_MESSAGE := '########## TITLE Header Line ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* 필수 값 NULL 값 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Column Data.'
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND (   TRIM(ATTRIBUTE1) IS NULL OR TRIM(ATTRIBUTE2) IS NULL OR TRIM(ATTRIBUTE3) IS NULL
                    OR TRIM(ATTRIBUTE4) IS NULL OR TRIM(ATTRIBUTE5) IS NULL OR TRIM(ATTRIBUTE6) IS NULL
                    OR TRIM(ATTRIBUTE7) IS NULL OR TRIM(ATTRIBUTE8) IS NULL OR TRIM(ATTRIBUTE9) IS NULL
                   );

            V_LOG_TYPE    := '4';
            V_LOG_MESSAGE := '########## ERROR Invalid Column Data ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* DIVISION 값 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Division.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCM_MST_DIVISION  D
                                 WHERE D.VALID_YN    = 'Y'
                                   AND D.DIVISION_ID = T.ATTRIBUTE1
                                 UNION
                                SELECT 1
                                  FROM SCM_MST_DIVISION  D
                                 WHERE D.VALID_YN      = 'Y'
                                   AND D.DIVISION_NAME = T.ATTRIBUTE1 );

            V_LOG_TYPE    := '5';
            V_LOG_MESSAGE := '########## Invalid Division ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* from site 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid From Site.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCM_MST_SITE  S
                                 WHERE 1 = 1
                                   AND S.SITE_TYPE   = 'PLANT'
                                   AND S.DIVISION_ID = ( SELECT DIVISION_ID
                                                           FROM SCM_MST_SITE
                                                          WHERE DIVISION_ID = T.ATTRIBUTE1    /* DIVISION_ID */
                                                            AND SCM_SITE_ID = T.ATTRIBUTE2    /* FROM SITE */
                                                            AND VALID_YN    = 'Y'
                                                            AND SITE_TYPE   = 'PLANT' )
                                   AND S.SCM_SITE_ID = T.ATTRIBUTE2 );                        /* FROM SITE */

            V_LOG_TYPE    := '7';
            V_LOG_MESSAGE := '########## Invalid From site ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* to site 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid To Site.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCM_MST_SITE  S
                                 WHERE 1 = 1
                                   AND S.SITE_TYPE   = 'SALES'
                                   AND S.DIVISION_ID = ( SELECT DIVISION_ID
                                                           FROM SCM_MST_SITE
                                                          WHERE DIVISION_ID = T.ATTRIBUTE1    /* DIVISION_ID */
                                                            AND SCM_SITE_ID = T.ATTRIBUTE3    /* TO SITE */
                                                            AND VALID_YN    = 'Y'
                                                            AND SITE_TYPE   = 'SALES' )
                                   AND S.SCM_SITE_ID = T.ATTRIBUTE3 );                        /* TO SITE */

            V_LOG_TYPE    := '8';
            V_LOG_MESSAGE := '########## Invalid To site ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* Shipto Code 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid ShipTo Code.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCM_MST_SITE_CUSTOMER  S
                                 WHERE 1 = 1
                                   AND S.DIVISION_ID = ( SELECT DIVISION_ID
                                                           FROM SCM_MST_SITE
                                                          WHERE DIVISION_ID = T.ATTRIBUTE1
                                                            AND SCM_SITE_ID = T.ATTRIBUTE3
                                                            AND VALID_YN    = 'Y'
                                                            AND SITE_TYPE   = 'SALES' )
                                   AND S.SCM_SITE_ID = T.ATTRIBUTE3
                                   AND S.SHIPTO_CODE = T.ATTRIBUTE4 );

            V_LOG_TYPE    := '8';
            V_LOG_MESSAGE := '########## Invalid ShipTo Code. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* 날짜(YYYYMMDD) 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Date.'
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ( TRIM(ATTRIBUTE6) IS NULL
                     OR LENGTH(SUBSTR(REPLACE(REPLACE(NVL(ATTRIBUTE6, ' '), ' ', ''), '-', ''), 1, 8)) <> 8 );   /* YYYYMMDD */

            /* 날짜 변환 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET ATTRIBUTE11 = SUBSTR(REPLACE(REPLACE(NVL(ATTRIBUTE6, ' '), ' ', ''), '-', ''), 1, 8)
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD';

            V_LOG_TYPE    := '12';
            V_LOG_MESSAGE := '########## Invalid Date ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* Trans Mode 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Trans Mode.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCP_MST_BOD_N_V  S
                                 WHERE 1 = 1
                                   AND S.DIVISION_ID = ( SELECT DIVISION_ID
                                                           FROM SCM_MST_SITE
                                                          WHERE DIVISION_ID = T.ATTRIBUTE1
                                                            AND SCM_SITE_ID = T.ATTRIBUTE2
                                                            AND VALID_YN    = 'Y'
                                                            AND SITE_TYPE   = 'PLANT' )
                                   AND S.FROM_SITE      = T.ATTRIBUTE2
                                   AND S.TO_SITE        = T.ATTRIBUTE3
                                   AND S.TRANSPORT_MODE = T.ATTRIBUTE8
                                   AND S.SSP_INCOTERMS  = T.ATTRIBUTE9
                                   AND S.FROM_YYYYMMDD <= T.ATTRIBUTE11
                                   AND S.TO_YYYYMMDD   >= T.ATTRIBUTE11 );

            V_LOG_TYPE    := '10';
            V_LOG_MESSAGE := '########## Invalid Trans Mode ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* Incoterms 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Incoterms.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCP_MST_BOD_N_V  S
                                 WHERE 1 = 1
                                   AND S.DIVISION_ID = ( SELECT DIVISION_ID
                                                           FROM SCM_MST_SITE
                                                          WHERE DIVISION_ID = T.ATTRIBUTE1
                                                            AND SCM_SITE_ID = T.ATTRIBUTE2
                                                            AND VALID_YN    = 'Y'
                                                            AND SITE_TYPE   = 'PLANT' )
                                   AND S.FROM_SITE      = T.ATTRIBUTE2
                                   AND S.TO_SITE        = T.ATTRIBUTE3
                                   /* 2020.09.21 KIMYONGHO SSP INCOTERMS 변경작업 */
                                   AND S.TRANSPORT_MODE = T.ATTRIBUTE8
                                   AND S.SSP_INCOTERMS  = T.ATTRIBUTE9
                                   AND S.FROM_YYYYMMDD <= T.ATTRIBUTE11
                                   AND S.TO_YYYYMMDD   >= T.ATTRIBUTE11 );

            V_LOG_TYPE    := '11';
            V_LOG_MESSAGE := '########## Invalid Incoterms ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* fcst_Type 값 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Fcst Type.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL  D
                                 WHERE D.VALID_YN    = 'Y'
                                   AND D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                   AND D.SEGMENT1    = T.ATTRIBUTE10
                                 UNION
                                SELECT 1
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL  D
                                 WHERE D.VALID_YN    = 'Y'
                                   AND D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                   AND D.SEGMENT2    = T.ATTRIBUTE10 );

            V_LOG_TYPE    := '12';
            V_LOG_MESSAGE := '########## Invalid Division ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* 중복 값 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Duplication Data.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND EXISTS ( SELECT 1
                              FROM ( SELECT PROGRAM_ID
                                          , SHEET_NAME
                                          , CREATION_DATE
                                          , ATTRIBUTE1      AS DIVISION_ID
                                          , ATTRIBUTE2      AS FROM_SITE
                                          , ATTRIBUTE3      AS TO_SITE
                                          , ATTRIBUTE4      AS SHIPTO_CODE
                                          , ATTRIBUTE5      AS ITEM_ID
                                          , ATTRIBUTE11     AS YYYYMMDD
                                          , ATTRIBUTE8      AS TRANSPORT_MODE
                                          , ATTRIBUTE9      AS INCOTERMS
                                       FROM SCM_ADM_EXCEL_UPLOAD  X
                                      WHERE X.PROGRAM_ID         = C_PROGRAM_ID
                                        AND X.SHEET_NAME         = C_SHEET_NAME
                                        AND X.CREATED_BY         = P_CREATED_BY
                                        AND X.CREATION_DATE      = V_CREATION_DATE
                                        AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                      GROUP BY PROGRAM_ID
                                             , SHEET_NAME
                                             , CREATION_DATE
                                             , ATTRIBUTE1
                                             , ATTRIBUTE2
                                             , ATTRIBUTE3
                                             , ATTRIBUTE4
                                             , ATTRIBUTE5
                                             , ATTRIBUTE11
                                             , ATTRIBUTE8
                                             , ATTRIBUTE9
                                     HAVING COUNT(1) > 1
                                   )  IA
                             WHERE 1 = 1
                               AND IA.DIVISION_ID    = T.ATTRIBUTE1
                               AND IA.FROM_SITE      = T.ATTRIBUTE2
                               AND IA.TO_SITE        = T.ATTRIBUTE3
                               AND IA.SHIPTO_CODE    = T.ATTRIBUTE4
                               AND IA.ITEM_ID        = T.ATTRIBUTE5
                               AND IA.YYYYMMDD       = T.ATTRIBUTE11
                               AND IA.TRANSPORT_MODE = T.ATTRIBUTE8
                               AND IA.INCOTERMS      = T.ATTRIBUTE9 );

            V_LOG_TYPE    := '14';
            V_LOG_MESSAGE := '########## Duplication Data. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* QTY 값 체크
               ★AS-IS 도 숫자가 아닌 값이면 문장이 오류로 끊긴다. 사용자 입력 칸이라 그대로 둔다. */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Qty.'
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ( INSTR(ATTRIBUTE7, '.') > 0 OR TO_NUMBER(ATTRIBUTE7) < 0 );

            V_LOG_TYPE    := '15';
            V_LOG_MESSAGE := '########## Invalid Qty. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* BOD_ID  체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET ATTRIBUTE12 = ( SELECT BOD_ID
                                     FROM SCP_MST_BOD_N_V
                                    WHERE FROM_SITE       = T.ATTRIBUTE2
                                      AND TO_SITE         = T.ATTRIBUTE3
                                      /* 2020.09.21 KIMYONGHO SSP INCOTERMS 변경작업 */
                                      AND SSP_INCOTERMS   = T.ATTRIBUTE9
                                      AND TRANSPORT_MODE  = T.ATTRIBUTE8
                                      AND FROM_YYYYMMDD  <= T.ATTRIBUTE11
                                      AND TO_YYYYMMDD    >= T.ATTRIBUTE11 )
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD';

            V_LOG_TYPE    := '18';
            V_LOG_MESSAGE := '########## Invalid BOD_ID ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* BOD_ID_ITEM 체크
               2022/01/04 KIMYONGHO ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
               ★AS-IS STUFF 는 시작 자리가 문자열 길이보다 크면 빈값을 내고 바깥 ISNULL 이 원래 품목을 돌려준다. */
            UPDATE SCM_ADM_EXCEL_UPLOAD  T
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Bod item Data.'
             WHERE T.PROGRAM_ID         = C_PROGRAM_ID
               AND T.SHEET_NAME         = C_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS ( SELECT 1
                                  FROM SCP_MST_BOD_ITEM  X
                                     , SCP_MST_BOD_N_V   V
                                     , SCM_MST_SITE      B
                                 WHERE V.DIVISION_ID = X.DIVISION_ID
                                   AND V.BOD_ID      = X.BOD_ID
                                   AND B.DIVISION_ID = V.DIVISION_ID
                                   AND B.SCM_SITE_ID = V.FROM_SITE
                                   AND X.DIVISION_ID = ( SELECT DIVISION_ID
                                                           FROM SCM_MST_SITE
                                                          WHERE DIVISION_ID = T.ATTRIBUTE1
                                                            AND SCM_SITE_ID = T.ATTRIBUTE2
                                                            AND VALID_YN    = 'Y'
                                                            AND SITE_TYPE   = 'PLANT' )
                                   AND X.VALID_YN    = 'Y'
                                   AND X.BOD_ID      = T.ATTRIBUTE12
                                   AND CASE WHEN TRIM(B.PACKER_ITEM_ID_SUFFIX) IS NULL THEN X.ITEM_ID
                                            ELSE NVL( CASE WHEN LENGTH(X.ITEM_ID) < 12 THEN NULL
                                                           ELSE SUBSTR(X.ITEM_ID, 1, 11) || B.PACKER_ITEM_ID_SUFFIX || SUBSTR(X.ITEM_ID, 13)
                                                      END
                                                    , X.ITEM_ID)
                                       END = T.ATTRIBUTE5 );

            V_LOG_TYPE    := '19';
            V_LOG_MESSAGE := '########## ERROR Invalid Bod item Data ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* Confirm Day 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET ATTRIBUTE13 = TO_CHAR(SYSDATE + 7, 'YYYYMMDD')
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD';

            V_LOG_TYPE    := '20';
            V_LOG_MESSAGE := '########## SUCCESS. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* YYYYMMDD 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid yyyyMMdd.'
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ATTRIBUTE11        < ATTRIBUTE13;

            V_LOG_TYPE    := '13';
            V_LOG_MESSAGE := '########## Invalid yyyyMMdd. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* 정상(SUCCESS) 처리 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'SUCCESS'
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD';

            V_LOG_TYPE    := '21';
            V_LOG_MESSAGE := '########## SUCCESS ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        END IF;

        V_LOG_TYPE    := '22';
        V_LOG_MESSAGE := '########## INSERT DATA START ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE);
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        SELECT COUNT(1)
          INTO V_COUNT
          FROM SCM_ADM_EXCEL_UPLOAD  T
         WHERE T.PROGRAM_ID         = C_PROGRAM_ID
           AND T.SHEET_NAME         = C_SHEET_NAME
           AND T.CREATED_BY         = P_CREATED_BY
           AND T.CREATION_DATE      = V_CREATION_DATE
           AND T.UPLOAD_STATUS_CODE = 'ERROR';

        IF P_MODE > 0 AND V_COUNT = 0 THEN

            V_LOG_TYPE    := '23';
            V_LOG_MESSAGE := '########## INSERT/UPDATE SSP0026 SHIPMENT REQUEST DATA START ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            V_LOG_TYPE    := '23-1';
            V_LOG_MESSAGE := '########## MERGE SSP0026 SHIPMENT REQUEST DATA START ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* 변경, 추가 대상 건 TEMP 생성 */
            INSERT INTO GT_0026_SAVE
                 ( ACTIVE_FLAG, DIVISION_ID, FROM_SITE, TO_SITE, SHIPTO_CODE, ITEM_ID
                 , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, BOD_ID, YYYYMMDD, QTY, REQUEST_ID )
            SELECT 'M'                          AS ACTIVE_FLAG
                 , T.ATTRIBUTE1                 AS DIVISION_ID
                 , T.ATTRIBUTE2                 AS FROM_SITE
                 , T.ATTRIBUTE3                 AS TO_SITE
                 , T.ATTRIBUTE4                 AS SHIPTO_CODE
                 , T.ATTRIBUTE5                 AS ITEM_ID
                 , T.ATTRIBUTE9                 AS INCOTERMS
                 , T.ATTRIBUTE8                 AS TRANSPORT_MODE
                 , D.SEGMENT1                   AS FCST_TYPE
                 , T.ATTRIBUTE12                AS BOD_ID
                 , T.ATTRIBUTE11                AS YYYYMMDD
                 , TO_CHAR(CEIL(TO_NUMBER(T.ATTRIBUTE7)))   AS QTY
                 , 'R' || TO_CHAR(SYSDATE, 'YYYYMMDD')
                       || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID.NEXTVAL), -6)  AS REQUEST_ID
              FROM SCM_ADM_EXCEL_UPLOAD            T
                 , SCM_ADM_LOOKUP_MASTER_DETAIL    D
             WHERE D.LOOKUP_TYPE(+) = 'SALES_TYPE_CODE'
               AND ( D.SEGMENT1(+) = T.ATTRIBUTE10 OR D.SEGMENT2(+) = T.ATTRIBUTE10 )
               AND T.PROGRAM_ID    = C_PROGRAM_ID
               AND T.SHEET_NAME    = C_SHEET_NAME
               AND T.CREATED_BY    = P_CREATED_BY
               AND T.CREATION_DATE = V_CREATION_DATE
               AND NVL(T.UPLOAD_STATUS_CODE, 'X') = 'SUCCESS';

            SELECT COUNT(*)
              INTO V_CNT
              FROM GT_0026_SAVE;

            IF V_CNT > 0 THEN

                D_EVENT_DATE := SYSDATE;

                /*DETAIL UPDATE*/
                UPDATE SSP_ANL_SHIP_REQ_P  A
                   SET ( QTY, BOD_ID, PROJECT_CODE, FCST_TYPE, REQUEST_ID
                       , LAST_UPDATED_BY, LAST_UPDATE_DATE )
                     = ( SELECT TO_NUMBER(B.QTY)
                              , B.BOD_ID
                              , EC.SOLDTO_CUSTOMER
                              , B.FCST_TYPE
                              , CASE WHEN A.REQUEST_ID IS NULL THEN B.REQUEST_ID ELSE A.REQUEST_ID END
                              , P_CREATED_BY
                              , D_EVENT_DATE
                           FROM GT_0026_SAVE  B
                              , SCM_MST_SITE  EC
                          WHERE A.DIVISION_ID   = B.DIVISION_ID
                            AND A.SHIPTO_CODE   = B.SHIPTO_CODE
                            AND A.BOD_ID        = B.BOD_ID
                            AND A.ITEM_ID       = B.ITEM_ID
                            AND A.YYYYMMDD      = B.YYYYMMDD
                            AND EC.DIVISION_ID(+) = A.DIVISION_ID
                            AND EC.SCM_SITE_ID(+) = B.TO_SITE
                            AND EC.VALID_YN(+)    = 'Y'
                            AND ROWNUM         <= 1 )
                 WHERE EXISTS ( SELECT 1
                                  FROM GT_0026_SAVE  B
                                 WHERE A.DIVISION_ID = B.DIVISION_ID
                                   AND A.SHIPTO_CODE = B.SHIPTO_CODE
                                   AND A.BOD_ID      = B.BOD_ID
                                   AND A.ITEM_ID     = B.ITEM_ID
                                   AND A.YYYYMMDD    = B.YYYYMMDD );

                /*History*/
                INSERT INTO SSP_ANL_SHIP_REQ_P_H
                     ( HISTORY_SEQ, DIVISION_ID, SHIPTO_CODE, YYYYMMDD, BOD_ID, QTY, REQUEST_ID, CONFIRM_ID
                     , FCST_TYPE, ORDER_TYPE_DETAIL, REMARK, CREATED_BY, CREATION_DATE
                     , LAST_UPDATED_BY, LAST_UPDATE_DATE
                     , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                     , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ITEM_ID )
                SELECT SEQ1_SSP_ANL_SHIP_PACKER_REQ_H.NEXTVAL   AS HISTORY_SEQ
                     , A.DIVISION_ID
                     , A.SHIPTO_CODE
                     , A.YYYYMMDD
                     , A.BOD_ID
                     , A.QTY
                     , A.REQUEST_ID
                     , A.CONFIRM_ID
                     , A.FCST_TYPE
                     , A.ORDER_TYPE_DETAIL
                     , A.REMARK
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , A.ATTRIBUTE1
                     , A.ATTRIBUTE2
                     , A.ATTRIBUTE3
                     , A.ATTRIBUTE4
                     , A.ATTRIBUTE5
                     , A.ATTRIBUTE6
                     , A.ATTRIBUTE7
                     , A.ATTRIBUTE8
                     , A.ATTRIBUTE9
                     , A.ATTRIBUTE10
                     , A.ITEM_ID
                  FROM SSP_ANL_SHIP_REQ_P  A
                     , GT_0026_SAVE        B
                 WHERE A.DIVISION_ID = B.DIVISION_ID
                   AND A.SHIPTO_CODE = B.SHIPTO_CODE
                   AND A.ITEM_ID     = B.ITEM_ID
                   AND A.BOD_ID      = B.BOD_ID
                   AND A.YYYYMMDD    = B.YYYYMMDD
                   AND 1 = 1;

                /* SCS I/F 정보 생성 — I/F 주체는 SCS 에서 함 */
                INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
                     ( IF_SEQ, IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, PACKER_CODE, DIVISION_ID
                     , PLAN_VERSION, PACK_MODEL_CODE, NICK_NAME, TARGET_ORDER, SSP_CNFM, SALES_SITE
                     , SHIP_TO, SHIP_TO_NAME, TRANSPORT_MODE, INCOTERMS, SHIP_PLAN_DATE, SHIP_PLAN_QTY
                     , "COMMENT", ATTR_01, ATTR_02, ATTR_03, ATTR_04, ATTR_05, ATTR_06, ATTR_07
                     , ATTR_08, ATTR_09, ATTR_10, ORDER_TYPE_DETAIL )
                SELECT 'OSCM' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10)  AS IF_SEQ
                     , 'I'                                  AS IF_TYPE
                     , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'       AS IF_ID
                     , SYSDATE                              AS IF_INS_DATE
                     , 'N'                                  AS IF_FLAG
                     , NVL(IB.NEW_VALUE1, IA.PACKER_CODE)   AS PACKER_CODE
                     , IA.DIVISION_ID
                     , V_PLAN_START_YYYYMMDD                AS PLAN_VERSION
                     , IA.PACK_MODEL_CODE
                     , IA.NICK_NAME
                     , 'O'                                  AS TARGET_ORDER
                     , IA.SSP_CNFM
                     , IA.SALES_SITE
                     , IA.SHIP_TO
                     , IA.SHIP_TO_NAME
                     , IA.TRANSPORT_MODE
                     , IA.INCOTERMS
                     , IA.SHIP_PLAN_DATE
                     , IA.SHIP_PLAN_QTY
                     , NULL                                 AS "COMMENT"
                     , IA.ATTR_01
                     , NULL                                 AS ATTR_02
                     , IA.ATTR_03                           /*Model PIC*/
                     , IA.ATTR_04                           /*MTK_OWNER*/
                     , NULL                                 AS ATTR_05
                     , NULL                                 AS ATTR_06
                     , NULL                                 AS ATTR_07
                     , NULL                                 AS ATTR_08
                     , NULL                                 AS ATTR_09
                     , NULL                                 AS ATTR_10
                     , IA.ORDER_TYPE_DETAIL
                  FROM ( SELECT B.FROM_SITE                 AS PACKER_CODE
                              , B.DIVISION_ID               AS DIVISION_ID
                              , B.ITEM_ID                   AS PACK_MODEL_CODE
                              , FN_GET_ITEM_NICKNAME(B.DIVISION_ID, B.ITEM_ID)    AS NICK_NAME
                              , A.REQUEST_ID                AS SSP_CNFM
                              , B.TO_SITE                   AS SALES_SITE
                              , B.SHIPTO_CODE               AS SHIP_TO
                              , FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_DESCRIPTION')  AS SHIP_TO_NAME
                              , B.TRANSPORT_MODE
                              , B.INCOTERMS
                              , B.YYYYMMDD                  AS SHIP_PLAN_DATE
                              , TO_NUMBER(B.QTY)            AS SHIP_PLAN_QTY
                              , B.DIVISION_ID || '_' || V_PLAN_START_YYYYMMDD || '_' || V_IF_GROUP_NO  AS ATTR_01
                              /* 2026.09.30 AJS 수정 (START) */
--                              , CASE WHEN U2.USERNAME IS NOT NULL AND MU.USER_ID IS NOT NULL
--                                     THEN U2.USERNAME || '(' || MU.USER_ID || ')'
                              , CASE WHEN U2.USER_NM IS NOT NULL AND MU.USER_ID IS NOT NULL
                                     THEN U2.USER_NM || '(' || MU.USER_ID || ')'
                              /* 2026.09.30 AJS 수정 (END) */
                                END                         AS ATTR_03      /*Model PIC*/
                              , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, '', 'KO')     AS ATTR_04      /*MTK_OWNER*/
                              , NVL(LK.SEGMENT2, A.FCST_TYPE)                     AS ORDER_TYPE_DETAIL
                           FROM SSP_ANL_SHIP_REQ_P    A
                              , GT_0026_SAVE          B
                              , ( SELECT DIVISION_ID
                                       , PROJECT_CODE
                                       , SCM_SITE_ID
                                       , ITEM_ID
                                    FROM ( SELECT DIVISION_ID
                                                , PROJECT_CODE
                                                , SCM_SITE_ID
                                                , ITEM_ID
                                                , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                                                         ORDER BY PROJECT_CODE) NUM
                                             FROM SCM_MST_SITE_ITEM
                                         )  XA
                                   WHERE NUM = 1
                                )  G
                              , SCM_MST_SITE_ITEM     SI
                              , SSP_MST_MODEL_USER    MU
                              /* 2026.09.30 AJS 수정 (START) */
--                              , TB_FX_USER            U2
                              , SCM_ADM_USER_M        U2
                              /* 2026.09.30 AJS 수정 (END) */
                              , SCM_ADM_LOOKUP_MASTER_DETAIL  LK
                          WHERE A.DIVISION_ID   = B.DIVISION_ID
                            AND A.SHIPTO_CODE   = B.SHIPTO_CODE
                            AND A.ITEM_ID       = B.ITEM_ID
                            AND A.BOD_ID        = B.BOD_ID
                            AND A.YYYYMMDD      = B.YYYYMMDD
                            AND G.DIVISION_ID(+) = B.DIVISION_ID
                            AND G.SCM_SITE_ID(+) = B.TO_SITE
                            AND G.ITEM_ID(+)     = B.ITEM_ID
                            AND SI.DIVISION_ID(+)  = B.DIVISION_ID
                            AND SI.SCM_SITE_ID(+)  = B.TO_SITE
                            AND SI.ITEM_ID(+)      = B.ITEM_ID
                            AND SI.PROJECT_CODE(+) = G.PROJECT_CODE
                            AND MU.DIVISION_ID(+)  = B.DIVISION_ID
                            AND MU.FROM_SITE(+)    = B.FROM_SITE
                            AND MU.ITEM_ID(+)      = B.ITEM_ID
                            AND MU.VALID_YN(+)     = 'Y'
                            /* 2026.09.30 AJS 수정 (START) */
--                            AND MU.USER_ID         = U2.USERID(+)
--                            AND U2.USEYN(+)        = 'Y'
                            AND MU.USER_ID         = U2.USER_ID(+)
                            AND U2.USE_YN(+)       = 'Y'
                            /* 2026.09.30 AJS 수정 (END) */
                            AND LK.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                            AND LK.VALID_YN(+)     = 'Y'
                            AND B.FCST_TYPE        = LK.SEGMENT1(+)
                       )  IA
                     , NERP_CONV_MASTER  IB
                 WHERE IB.CODETYPE(+)   = 'SCP_SITE_ID'
                   AND IA.PACKER_CODE   = IB.OLD_VALUE1(+);

                V_CNT := 0;

            END IF;
            /* UPDATE END */

            /* INSERT START */
            SELECT COUNT(*)
              INTO V_CNT
              FROM GT_0026_SAVE  B
             WHERE 1 = 1
               AND NOT EXISTS ( SELECT 1
                                  FROM SSP_ANL_SHIP_REQ_P  A
                                 WHERE 1 = 1
                                   AND A.DIVISION_ID = B.DIVISION_ID
                                   AND A.SHIPTO_CODE = B.SHIPTO_CODE
                                   AND A.ITEM_ID     = B.ITEM_ID
                                   AND A.YYYYMMDD    = B.YYYYMMDD
                                   AND A.BOD_ID      = B.BOD_ID );

            IF V_CNT > 0 THEN

                /* INSERT 대상 건 ACTIVE FLAG 변경 */
                UPDATE GT_0026_SAVE  A
                   SET A.ACTIVE_FLAG = 'I'
                 WHERE NOT EXISTS ( SELECT 1
                                      FROM SSP_ANL_SHIP_REQ_P  B
                                     WHERE 1 = 1
                                       AND A.DIVISION_ID = B.DIVISION_ID
                                       AND A.SHIPTO_CODE = B.SHIPTO_CODE
                                       AND A.ITEM_ID     = B.ITEM_ID
                                       AND A.YYYYMMDD    = B.YYYYMMDD
                                       AND A.BOD_ID      = B.BOD_ID );

                /* 신규 REQEUST INSERT — DETAIL INSERT */
                INSERT INTO SSP_ANL_SHIP_REQ_P
                     ( DIVISION_ID, ITEM_ID, SHIPTO_CODE, BOD_ID, YYYYMMDD, QTY, REQUEST_ID
                     , FCST_TYPE, PROJECT_CODE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT B.DIVISION_ID
                     , B.ITEM_ID
                     , B.SHIPTO_CODE
                     , B.BOD_ID
                     , B.YYYYMMDD
                     , TO_NUMBER(B.QTY)
                     , B.REQUEST_ID
                     , B.FCST_TYPE
                     , C.SOLDTO_CUSTOMER
                     , P_CREATED_BY                 AS CREATED_BY
                     , D_EVENT_DATE                 AS CREATION_DATE
                     , P_CREATED_BY                 AS LAST_UPDATED_BY
                     , D_EVENT_DATE                 AS LAST_UPDATE_DATE
                  FROM GT_0026_SAVE   B
                     , SCM_MST_SITE   C
                 WHERE B.DIVISION_ID = C.DIVISION_ID
                   AND B.TO_SITE     = C.SCM_SITE_ID
                   AND C.VALID_YN    = 'Y'
                   AND 1 = 1
                   AND B.ACTIVE_FLAG = 'I'
                   AND NOT EXISTS ( SELECT 1
                                      FROM SSP_ANL_SHIP_REQ_P  A
                                     WHERE 1 = 1
                                       AND A.DIVISION_ID = B.DIVISION_ID
                                       AND A.SHIPTO_CODE = B.SHIPTO_CODE
                                       AND A.ITEM_ID     = B.ITEM_ID
                                       AND A.YYYYMMDD    = B.YYYYMMDD
                                       AND A.BOD_ID      = B.BOD_ID );

                /*History*/
                INSERT INTO SSP_ANL_SHIP_REQ_P_H
                     ( HISTORY_SEQ, DIVISION_ID, SHIPTO_CODE, YYYYMMDD, BOD_ID, QTY, REQUEST_ID, CONFIRM_ID
                     , FCST_TYPE, PROJECT_CODE, ORDER_TYPE_DETAIL, REMARK
                     , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                     , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                     , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ITEM_ID )
                SELECT SEQ1_SSP_ANL_SHIP_PACKER_REQ_H.NEXTVAL   AS HISTORY_SEQ
                     , A.DIVISION_ID
                     , A.SHIPTO_CODE
                     , A.YYYYMMDD
                     , A.BOD_ID
                     , A.QTY
                     , A.REQUEST_ID
                     , A.CONFIRM_ID
                     , A.FCST_TYPE
                     , C.SOLDTO_CUSTOMER
                     , A.ORDER_TYPE_DETAIL
                     , A.REMARK
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , A.ATTRIBUTE1
                     , A.ATTRIBUTE2
                     , A.ATTRIBUTE3
                     , A.ATTRIBUTE4
                     , A.ATTRIBUTE5
                     , A.ATTRIBUTE6
                     , A.ATTRIBUTE7
                     , A.ATTRIBUTE8
                     , A.ATTRIBUTE9
                     , A.ATTRIBUTE10
                     , A.ITEM_ID
                  FROM SSP_ANL_SHIP_REQ_P  A
                     , SCP_MST_BOD_N_V     V
                     , SCM_MST_SITE        C
                     , GT_0026_SAVE        B
                 WHERE A.DIVISION_ID = V.DIVISION_ID
                   AND A.BOD_ID      = V.BOD_ID
                   AND A.DIVISION_ID = C.DIVISION_ID
                   AND V.TO_SITE     = C.SCM_SITE_ID
                   AND C.VALID_YN    = 'Y'
                   AND A.DIVISION_ID = B.DIVISION_ID
                   AND A.SHIPTO_CODE = B.SHIPTO_CODE
                   AND A.ITEM_ID     = B.ITEM_ID
                   AND A.BOD_ID      = B.BOD_ID
                   AND A.YYYYMMDD    = B.YYYYMMDD
                   AND 1 = 1;

                /* SCS I/F 정보 생성 */
                INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
                     ( IF_SEQ, IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, PACKER_CODE, DIVISION_ID
                     , PLAN_VERSION, PACK_MODEL_CODE, NICK_NAME, TARGET_ORDER, SSP_CNFM, SALES_SITE
                     , SHIP_TO, SHIP_TO_NAME, TRANSPORT_MODE, INCOTERMS, SHIP_PLAN_DATE, SHIP_PLAN_QTY
                     , "COMMENT", ATTR_01, ATTR_02, ATTR_03, ATTR_04, ATTR_05, ATTR_06, ATTR_07
                     , ATTR_08, ATTR_09, ATTR_10, ORDER_TYPE_DETAIL )
                SELECT 'OSCM' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10)  AS IF_SEQ
                     , 'I'                                  AS IF_TYPE
                     , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'       AS IF_ID
                     , SYSDATE                              AS IF_INS_DATE
                     , 'N'                                  AS IF_FLAG
                     , NVL(IB.NEW_VALUE1, IA.PACKER_CODE)   AS PACKER_CODE
                     , IA.DIVISION_ID
                     , V_PLAN_START_YYYYMMDD                AS PLAN_VERSION
                     , IA.PACK_MODEL_CODE
                     , IA.NICK_NAME
                     , 'O'                                  AS TARGET_ORDER
                     , IA.SSP_CNFM
                     , IA.SALES_SITE
                     , IA.SHIP_TO
                     , IA.SHIP_TO_NAME
                     , IA.TRANSPORT_MODE
                     , IA.INCOTERMS
                     , IA.SHIP_PLAN_DATE
                     , IA.SHIP_PLAN_QTY
                     , NULL                                 AS "COMMENT"
                     , IA.ATTR_01
                     , NULL                                 AS ATTR_02
                     , IA.ATTR_03
                     , IA.ATTR_04
                     , NULL                                 AS ATTR_05
                     , NULL                                 AS ATTR_06
                     , NULL                                 AS ATTR_07
                     , NULL                                 AS ATTR_08
                     , NULL                                 AS ATTR_09
                     , NULL                                 AS ATTR_10
                     , IA.ORDER_TYPE_DETAIL
                  FROM ( SELECT B.FROM_SITE                 AS PACKER_CODE
                              , B.DIVISION_ID               AS DIVISION_ID
                              , B.ITEM_ID                   AS PACK_MODEL_CODE
                              , FN_GET_ITEM_NICKNAME(B.DIVISION_ID, B.ITEM_ID)    AS NICK_NAME
                              , B.REQUEST_ID                AS SSP_CNFM
                              , B.TO_SITE                   AS SALES_SITE
                              , B.SHIPTO_CODE               AS SHIP_TO
                              , FN_GET_SITE_CUSTOMER_INFO(B.DIVISION_ID, B.TO_SITE, 'SHIPTO_DESCRIPTION')  AS SHIP_TO_NAME
                              , B.TRANSPORT_MODE
                              , B.INCOTERMS
                              , B.YYYYMMDD                  AS SHIP_PLAN_DATE
                              , TO_NUMBER(B.QTY)            AS SHIP_PLAN_QTY
                              , B.DIVISION_ID || '_' || V_PLAN_START_YYYYMMDD || '_' || V_IF_GROUP_NO  AS ATTR_01
                              /* 2026.09.30 AJS 수정 (START) */
--                              , CASE WHEN U2.USERNAME IS NOT NULL AND MU.USER_ID IS NOT NULL
--                                     THEN U2.USERNAME || '(' || MU.USER_ID || ')'
                              , CASE WHEN U2.USER_NM IS NOT NULL AND MU.USER_ID IS NOT NULL
                                     THEN U2.USER_NM || '(' || MU.USER_ID || ')'
                              /* 2026.09.30 AJS 수정 (END) */
                                END                         AS ATTR_03
                              , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, '', 'KO')     AS ATTR_04
                              , NVL(LK.SEGMENT2, B.FCST_TYPE)                     AS ORDER_TYPE_DETAIL
                           FROM GT_0026_SAVE          B
                              , ( SELECT DIVISION_ID
                                       , PROJECT_CODE
                                       , SCM_SITE_ID
                                       , ITEM_ID
                                    FROM ( SELECT DIVISION_ID
                                                , PROJECT_CODE
                                                , SCM_SITE_ID
                                                , ITEM_ID
                                                , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                                                         ORDER BY PROJECT_CODE) NUM
                                             FROM SCM_MST_SITE_ITEM
                                         )  XA
                                   WHERE NUM = 1
                                )  G
                              , SCM_MST_SITE_ITEM     SI
                              , SSP_MST_MODEL_USER    MU
                              /* 2026.09.30 AJS 수정 (START) */
--                              , TB_FX_USER            U2
                              , SCM_ADM_USER_M        U2
                              /* 2026.09.30 AJS 수정 (END) */
                              , SCM_ADM_LOOKUP_MASTER_DETAIL  LK
                          WHERE G.DIVISION_ID(+)   = B.DIVISION_ID
                            AND G.SCM_SITE_ID(+)   = B.TO_SITE
                            AND G.ITEM_ID(+)       = B.ITEM_ID
                            AND SI.DIVISION_ID(+)  = B.DIVISION_ID
                            AND SI.SCM_SITE_ID(+)  = B.TO_SITE
                            AND SI.ITEM_ID(+)      = B.ITEM_ID
                            AND SI.PROJECT_CODE(+) = G.PROJECT_CODE
                            AND MU.DIVISION_ID(+)  = B.DIVISION_ID
                            AND MU.FROM_SITE(+)    = B.FROM_SITE
                            AND MU.ITEM_ID(+)      = B.ITEM_ID
                            AND MU.VALID_YN(+)     = 'Y'
                            /* 2026.09.30 AJS 수정 (START) */
--                            AND MU.USER_ID         = U2.USERID(+)
--                            AND U2.USEYN(+)        = 'Y'
                            AND MU.USER_ID         = U2.USER_ID(+)
                            AND U2.USE_YN(+)       = 'Y'
                            /* 2026.09.30 AJS 수정 (END) */
                            AND LK.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                            AND LK.VALID_YN(+)     = 'Y'
                            AND B.FCST_TYPE        = LK.SEGMENT1(+)
                            AND 1 = 1
                            AND B.ACTIVE_FLAG      = 'I'
                       )  IA
                     , NERP_CONV_MASTER  IB
                 WHERE IB.CODETYPE(+)   = 'SCP_SITE_ID'
                   AND IA.PACKER_CODE   = IB.OLD_VALUE1(+);

                V_CNT := 0;

            END IF;

            V_LOG_TYPE    := '23-1';
            V_LOG_MESSAGE := '########## MERGE SSP0026 SHIPMENT REQUEST DATA END ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            V_LOG_TYPE    := '24';
            V_LOG_MESSAGE := '########## INSERT/UPDATE SP0022 SHIPMENT PLAN DATA END ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        END IF;

        V_LOG_TYPE    := '25';
        V_LOG_MESSAGE := '########## INSERT DATA END ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE);
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 2020.10.21 KIMYONGHO LOG 이력 START - END 짝이 안맞아서 표준 변경 작업 */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE, CAST(NULL AS VARCHAR2(4000 CHAR)) AS MSG FROM DUAL;
        OPEN O_RC2 FOR
            SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0026_SAVE_EXCEL;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE, V_ERR_MESSAGE AS MSG FROM DUAL;
            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD;

END PKG_SSP0026;

/* 반영 후 확인 : SELECT NAME, TYPE, LINE, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SSP0026' ORDER BY SEQUENCE */
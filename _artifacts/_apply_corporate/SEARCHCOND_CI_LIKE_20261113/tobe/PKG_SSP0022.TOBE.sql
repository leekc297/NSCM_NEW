-- SOURCE-FRESH: SCM_MGR.PKG_SSP0022 PACKAGE BODY LAST_DDL=2026-11-10 15:46:07 FETCHED=2026-11-13 10:46:20 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY         PKG_SSP0022
IS
/*
 * Program ID   : PKG_SSP0022
 * Description  : SSP0022 Shipment Request(Electrode)
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          조회 속도 개선 — 확정구간·ETA 함수 캐시, PSI 결과 적재 운송경로 뷰 해시 조인 고정, 재고 누적 합 하위질의를 일자별 합 조인으로
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.07   AJS          [속도2차] 품목 기준 뷰(SSP_MST_SITE_ITEM_EE_V)를 조회 대상 품목(GT_0022_PLAN_ITEM_CUTOFF)으로 한정 10곳 · 출하계획 원장 2곳 한 번 읽기(해시 조인)
 * 2026.10.20   AJS          엑셀 업로드 인자를 서버 공통 업로드 호출 형태에 맞춤(화면 ID · 시트 이름 추가, 결과 커서 1개)
 */

    /*******************************************************************************
     * P_SSP0022_GET_SHEET_CALENDAR_3SPAN
     *   AS-IS SSP0022_GET_SHEET_CALENDAR_3SPAN
     *
     * 전환 기준
     *   1. AS-IS 원문이 SSP0023 과 머리 주석만 다르므로 그 화면 전환본을 그대로 옮긴다.
     *   2. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
      , P_END_YYYYMMDD          IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/****************************************************************************************************
* Program ID  : SSP0022_GET_SHEET_CALENDAR_3SPAN
* Description : SSP 칼렌더 생성위한 프로시저
* Usage       : exec SSP0022_GET_SHEET_CALENDAR_3SPAN
* Parameter   : @p_start_yyyymmdd='2017-12-25'
*               @p_end_yyyymmdd='20180130'
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description
*--------------------------------------------------------------------------------------------------
* 2020/04/30  KIMYONGHO   Initial Release
* 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
****************************************************************************************************/

        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        OPEN O_RC1 FOR
            SELECT 'Z_D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
                 , A.CALENDAR_DAY AS COLUMN_LABEL_NAME
                 , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , A.DAYOFWEEK AS DAY_CODE
                 , 'Z_' || A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
            UNION ALL
            SELECT 'Z_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
                 , A.WEEK_NAME AS COLUMN_LABEL_NAME
                 , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , NULL AS DAY_CODE
                 , 'Z_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY A.BASIS_YYYYMM
                    , A.ISO_WEEK
                    , A.WEEK_NAME
                    , A.MONTH_NAME
                    , A.BASIS_START_DATE
            UNION ALL
            SELECT 'Z_M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                 , A.MONTH_NAME AS COLUMN_LABEL_NAME
                 , A.MONTH_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , NULL AS DAY_CODE
                 , 'Z_' || MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY A.BASIS_YYYYMM
                    , A.MONTH_NAME
            UNION ALL
            SELECT 'X_D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
                 , A.CALENDAR_DAY AS COLUMN_LABEL_NAME
                 , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , A.DAYOFWEEK AS DAY_CODE
                 , 'X_' || A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
            UNION ALL
            SELECT 'X_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
                 , A.WEEK_NAME AS COLUMN_LABEL_NAME
                 , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , NULL AS DAY_CODE
                 , 'X_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY A.BASIS_YYYYMM
                    , A.ISO_WEEK
                    , A.WEEK_NAME
                    , A.MONTH_NAME
                    , A.BASIS_START_DATE
            UNION ALL
            SELECT 'X_M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                 , A.MONTH_NAME AS COLUMN_LABEL_NAME
                 , A.MONTH_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , NULL AS DAY_CODE
                 , 'X_' || MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY A.BASIS_YYYYMM
                    , A.MONTH_NAME
            UNION ALL
            SELECT 'Y_D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
                 , A.CALENDAR_DAY AS COLUMN_LABEL_NAME
                 , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , A.DAYOFWEEK AS DAY_CODE
                 , 'Y_' || A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
            UNION ALL
            SELECT 'Y_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
                 , A.WEEK_NAME AS COLUMN_LABEL_NAME
                 , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , NULL AS DAY_CODE
                 , 'Y_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY A.BASIS_YYYYMM
                    , A.ISO_WEEK
                    , A.WEEK_NAME
                    , A.MONTH_NAME
                    , A.BASIS_START_DATE
            UNION ALL
            SELECT 'Y_M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                 , A.MONTH_NAME AS COLUMN_LABEL_NAME
                 , A.MONTH_NAME AS SMALL_CLASS_LABEL_NAME
                 , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                 , NULL AS DAY_CODE
                 , 'Y_' || MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY A.BASIS_YYYYMM
                    , A.MONTH_NAME
             ORDER BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;

            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS COLUMN_NAME FROM DUAL WHERE 1 = 0;
            END IF;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0022_GET_SHEET_CALENDAR_3SPAN;

    /*******************************************************************************
     * P_SSP0022_GET_BOD_ITEM_VALID_CHECK
     *   AS-IS SSP0022_GET_BOD_ITEM_VALID_CHECK
     *
     * 전환 기준
     *   1. AS-IS 는 두 테이블을 붙여 `SELECT *` 로 돌려주는데 겹치는 칸이 6개다.
     *      화면은 행 수만 보므로 운송경로 품목 칸만 돌려준다(행 수는 같다).
     *   2. 운송경로 코드가 '-' 이면 조건을 걸지 않는 원문 분기를 그대로 둔다.
     *   3. 조회조건 네 칸에 ALL 을 「조건 없음」으로 받는다.
     *   4. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_GET_BOD_ITEM_VALID_CHECK
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0022_GET_BOD_ITEM_VALID_CHECK
 * Description  : BOD ITEM 유효성 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *  2020-04-16  KIMYONGHO      BOD ITEM 유효성 체크
 * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

        V_BOD_ID                VARCHAR2(4000);
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        V_BOD_ID := P_BOD_ID;

        /* IF @p_bod_id = '-' SET @p_bod_id = ''; */
        IF V_BOD_ID = '-' THEN
            V_BOD_ID := NULL;
        END IF;

        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.BOD_ID
             , A.ITEM_ID
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , A.PRIORITY
             , A.SAFETY_STOCK
             , A.VALID_YN
          FROM SCP_MST_BOD_ITEM A
             , SCP_MST_BOD_N_V B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.BOD_ID = A.BOD_ID
           AND ( UPPER(P_DIVISION_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
              OR A.DIVISION_ID = P_DIVISION_ID )
           AND A.VALID_YN = 'Y'
           AND A.BOD_ID IN ( SELECT IA.BOD_ID
                               FROM SCP_MST_BOD_N_V IA
                              WHERE ( UPPER(P_DIVISION_ID) = 'ALL'
                                   OR IA.DIVISION_ID = P_DIVISION_ID )
                                AND A.VALID_YN = 'Y'                /* ★AS-IS 는 이 자리에 이름만 쓴 VALID_YN 을 두었다.
                                                                           운송경로 뷰에는 그 칸이 없어 바깥 운송경로 품목의
                                                                           같은 이름 칸으로 묶인다(바깥 조건과 겹치는 조건이다). */
                                AND IA.FROM_SITE IN ( SELECT SA.SEGMENT3
                                                        FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                                       WHERE SA.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
                                                         AND ( UPPER(P_DIVISION_ID) = 'ALL'
                                                            OR SA.SEGMENT2 = P_DIVISION_ID )
                                                         AND ( UPPER(P_TO_SITE) = 'ALL'
                                                            OR SA.ATTRIBUTE1 = P_TO_SITE ) )
                                AND IA.TO_SITE IN ( SELECT SA.ATTRIBUTE1
                                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                                     WHERE SA.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
                                                       AND ( UPPER(P_DIVISION_ID) = 'ALL'
                                                          OR SA.SEGMENT2 = P_DIVISION_ID )
                                                       AND ( UPPER(P_TO_SITE) = 'ALL'
                                                          OR SA.ATTRIBUTE1 = P_TO_SITE ) )
                                AND ( UPPER(V_BOD_ID) = 'ALL'
                                   OR IA.BOD_ID LIKE '%' || V_BOD_ID || '%' ) )
           AND ( UPPER(P_ITEM_ID) = 'ALL'
              OR A.ITEM_ID LIKE '%' || P_ITEM_ID || '%' );

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

    END P_SSP0022_GET_BOD_ITEM_VALID_CHECK;

    /*******************************************************************************
     * P_SSP0022_GET_ITEM_POPUP
     *   AS-IS SSP0022_GET_ITEM_POPUP
     *
     * 전환 기준
     *   1. AS-IS 는 운송경로 뷰를 요일 칸 일곱 개로 풀어(UNPIVOT) 한 행만 고른다.
     *      고르는 차례에 요일이 들어 있지 않아 AS-IS 가 어느 요일을 잡는지 보장되지 않는다.
     *      실측 결과 AS-IS 는 푸는 차례 첫 칸(월요일)을 잡으므로 그 차례로 고정한다.
     *   2. ★조건은 뷰의 INCOTERMS 칸으로 걸고 결과는 SSP_INCOTERMS 칸을 돌려준다.
     *      두 칸은 서로 다른 칸이며 값이 다른 행이 187 건 있다 — 원문 그대로 둔다.
     *   3. 출발 사이트로 사업부를 다시 정하는 원문 분기를 그대로 둔다(없으면 넘겨받은 값).
     *   4. 조회조건에 ALL 을 「조건 없음」으로 받는다.
     *   5. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_GET_ITEM_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_FROM_SITE_ID          IN  VARCHAR2
      , P_TO_SITE_ID            IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/****************************************************************************************************/
/* Program ID  : SSP0022_GET_ITEM_POPUP                                                             */
/* Description :                                                                                    */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/04/20  KIMYONGHO    신규추가                                                                */
/* 2020/09/21  KIMYONGHO    SSP_INCOTERMS 변경 작업                                                 */
/* 2026.09.27  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */
/****************************************************************************************************/

        V_DIVISION_ID           VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        /* SELECT  @p_division_id =  DIVISION_ID FROM SCM_MST_SITE WHERE SCM_SITE_ID = @p_from_site_id */
        BEGIN
            SELECT DIVISION_ID
              INTO V_DIVISION_ID
              FROM SCM_MST_SITE
             WHERE SCM_SITE_ID = P_FROM_SITE_ID
               AND VALID_YN = 'Y'
               AND SITE_TYPE = 'PLANT';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_DIVISION_ID := P_DIVISION_ID;             /* 없으면 넘겨받은 값을 그대로 쓴다 */
        END;

        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.BOD_ID
             , C.MODEL_ID                               AS MODEL_ID
             , B.ITEM_ID
             , A.INCOTERMS
             , A.PRIORITY
             , A.TRANSPORT_MODE
             , CASE WHEN NVL(C.ELECTRODE_POST_OPER_LT, 0) > NVL(D.SHIP_FROZEN, 0)
                    THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD') + (0 + NVL(C.ELECTRODE_POST_OPER_LT, 0)), 'YYYYMMDD')
                    ELSE TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD') + (0 + NVL(D.SHIP_FROZEN, 0)), 'YYYYMMDD')
               END                                      AS CONFIRM_DAY
          FROM (SELECT IA.DIVISION_ID
                     , IA.BOD_ID
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.INCOTERMS
                     , IA.TRANSPORT_MODE
                     , IA.PRIORITY
                     , MIN(TO_CHAR(TO_DATE(IB.BASIS_YYYYMMDD, 'YYYYMMDD') + (IA.LT_TOTAL - IA.SHIP_LT_TOTAL), 'YYYYMMDD')) AS ETA_DATE
                  FROM (SELECT XA.DIVISION_ID
                             , XA.BOD_ID
                             , XA.FROM_SITE
                             , XA.TO_SITE
                             , XA.INCOTERMS
                             , XA.TRANSPORT_MODE
                             , XA.LT_TOTAL
                             , XA.SHIP_LT_TOTAL
                             , XA.PRIORITY
                             , XA.DAYOFWEEK
                             , XA.EXIST_YN
                          FROM (SELECT XB.DIVISION_ID
                                     , XB.BOD_ID
                                     , XB.FROM_SITE
                                     , XB.TO_SITE
                                     , XB.SSP_INCOTERMS                 AS INCOTERMS
                                     , XB.TRANSPORT_MODE
                                     , XB.LT_TOTAL_ORIGIN               AS LT_TOTAL
                                     , XB.SHIP_LT_TOTAL_ORIGIN          AS SHIP_LT_TOTAL
                                     , XB.PRIORITY
                                     , CASE WHEN XB.DAY_COL = 'DAYS_MON' THEN 'MON'
                                            WHEN XB.DAY_COL = 'DAYS_TUE' THEN 'TUE'
                                            WHEN XB.DAY_COL = 'DAYS_WED' THEN 'WED'
                                            WHEN XB.DAY_COL = 'DAYS_THU' THEN 'THU'
                                            WHEN XB.DAY_COL = 'DAYS_FRI' THEN 'FRI'
                                            WHEN XB.DAY_COL = 'DAYS_SAT' THEN 'SAT'
                                            WHEN XB.DAY_COL = 'DAYS_SUN' THEN 'SUN'
                                            ELSE '' END                 AS DAYOFWEEK
                                     , XB.EXIST_YN
                                     , ROW_NUMBER() OVER (ORDER BY XB.PRIORITY
                                                                 , XB.TO_YYYYMMDD
                                                                 , XB.DAY_ORDER) AS RN   /* AS-IS 는 TOP 1 에 요일 차례가 없다 — 푸는 차례 첫 칸(월요일)으로 고정 */
                                  FROM (SELECT SA.DIVISION_ID
                                             , SA.BOD_ID
                                             , SA.FROM_SITE
                                             , SA.TO_SITE
                                             , SA.SSP_INCOTERMS
                                             , SA.TRANSPORT_MODE
                                             , SA.LT_TOTAL_ORIGIN
                                             , SA.SHIP_LT_TOTAL_ORIGIN
                                             , SA.PRIORITY
                                             , SA.TO_YYYYMMDD
                                             , SB.DAY_COL
                                             , SB.DAY_ORDER
                                             , CASE SB.DAY_COL
                                                    WHEN 'DAYS_MON' THEN SA.DAYS_MON
                                                    WHEN 'DAYS_TUE' THEN SA.DAYS_TUE
                                                    WHEN 'DAYS_WED' THEN SA.DAYS_WED
                                                    WHEN 'DAYS_THU' THEN SA.DAYS_THU
                                                    WHEN 'DAYS_FRI' THEN SA.DAYS_FRI
                                                    WHEN 'DAYS_SAT' THEN SA.DAYS_SAT
                                                    WHEN 'DAYS_SUN' THEN SA.DAYS_SUN
                                               END                      AS EXIST_YN
                                          FROM SCP_MST_BOD_N_V SA
                                             , (SELECT 'DAYS_MON' AS DAY_COL, 1 AS DAY_ORDER FROM DUAL
                                                UNION ALL SELECT 'DAYS_TUE', 2 FROM DUAL
                                                UNION ALL SELECT 'DAYS_WED', 3 FROM DUAL
                                                UNION ALL SELECT 'DAYS_THU', 4 FROM DUAL
                                                UNION ALL SELECT 'DAYS_FRI', 5 FROM DUAL
                                                UNION ALL SELECT 'DAYS_SAT', 6 FROM DUAL
                                                UNION ALL SELECT 'DAYS_SUN', 7 FROM DUAL) SB
                                         WHERE SA.DIVISION_ID = V_DIVISION_ID
                                           AND SA.FROM_SITE = P_FROM_SITE_ID
                                           AND SA.TO_SITE = P_TO_SITE_ID
                                           AND ( UPPER(P_TRANSPORT_MODE) = 'ALL'        /* 조회조건 ALL 은 조건 없음 */
                                              OR SA.TRANSPORT_MODE = P_TRANSPORT_MODE )
                                           AND ( UPPER(P_INCOTERMS) = 'ALL'
                                              OR SA.INCOTERMS = P_INCOTERMS )           /* ★조건은 INCOTERMS · 결과는 SSP_INCOTERMS */
                                           AND SA.FROM_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                           AND SA.TO_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                           AND SA.BOD_VALID_YN = 'Y') XB
                                 WHERE XB.EXIST_YN IS NOT NULL         /* 요일 칸을 푸는 자리에서 값 없음은 빠진다 */
                               ) XA
                         WHERE XA.RN = 1) IA
                     , SCM_SYS_CALENDAR_M IB
                 WHERE IB.DAYOFWEEK = IA.DAYOFWEEK
                   AND IB.BASIS_YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + IA.SHIP_LT_TOTAL, 'YYYYMMDD')      /* YYYYMMDD + SHIP_LT_TOTAL */
                   AND IB.BASIS_YYYYMMDD <= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + IA.SHIP_LT_TOTAL + 6, 'YYYYMMDD')  /* YYYYMMDD + SHIP_LT_TOTAL + 7 */
                   AND IA.EXIST_YN = 'Y'
                 GROUP BY IA.DIVISION_ID
                        , IA.BOD_ID
                        , IA.FROM_SITE
                        , IA.TO_SITE
                        , IA.INCOTERMS
                        , IA.TRANSPORT_MODE
                        , IA.PRIORITY) A
             , (SELECT DISTINCT SA.DIVISION_ID
                     , SA.ITEM_ID
                     , SA.BOD_ID
                  FROM SCP_MST_BOD_ITEM SA
                 WHERE SA.DIVISION_ID = V_DIVISION_ID
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'                                       /* 조회조건 ALL 은 조건 없음 */
                      OR UPPER(SA.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)                       /* AS-IS 는 대소문자를 가리지 않는다 */   /* 2026.11.13 조회조건 대소문자 무시 */
                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )) B
             , SCM_ADM_LOOKUP_MASTER_DETAIL E
             , SCM_MST_SITE D
             , SSP_MST_SITE_ITEM_EE_V C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.BOD_ID = A.BOD_ID
           AND E.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
           AND E.SEGMENT2 = A.DIVISION_ID
           AND E.SEGMENT3 = A.FROM_SITE
           AND E.ATTRIBUTE1 = A.TO_SITE
           AND D.DIVISION_ID = A.DIVISION_ID
           AND D.SCM_SITE_ID = A.FROM_SITE
           AND C.DIVISION_ID(+) = V_DIVISION_ID
           AND C.SCM_SITE_ID(+) = P_FROM_SITE_ID
           AND C.ITEM_ID(+) = B.ITEM_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.FROM_SITE = P_FROM_SITE_ID
           AND A.TO_SITE = P_TO_SITE_ID
         ORDER BY A.PRIORITY
                , FN_ASIS_SORT_KEY(B.ITEM_ID) NULLS FIRST;      /* AS-IS 는 우선순위만 정렬하나 품목 차례로 나온다(실측) */

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

    END P_SSP0022_GET_ITEM_POPUP;

    /*******************************************************************************
     * P_SSP0022_GET_REQUEST_DETAIL
     *   AS-IS SSP0022_GET_REQUEST_DETAIL
     *
     * 전환 기준
     *   1. AS-IS 는 문자열로 조회문을 조립한다. 조건 분기가 있는 정적 SQL 로 바꾼다.
     *   2. ★AS-IS 는 조회조건 목록을 따옴표 하나로 감싸 넣는다 —
     *      두 개 이상 고르면 IN ('P,C') 가 되어 한 건도 나오지 않는다(실측).
     *      같은 화면 엑셀 내리기는 쪼개어 넣으므로 쪼개는 쪽이 원래 뜻이다. 쪼개어 넣는다.
     *   3. 모델담당 조인은 「내 모델만」 조건이 꺼져 있으면 붙지 않는다.
     *      열쇠에 사용자가 들어 있어 여러 행이 붙을 수 있으므로 조인으로 두고
     *      조건이 꺼졌을 때는 짝이 없도록 조인 열쇠를 값 없음으로 막는다.
     *   4. 확정일과 편집가능여부는 같은 식이므로 한 번만 셈하고 밖에서 견준다.
     *   5. 조회조건에 ALL 을 「조건 없음」으로 받는다.
     *   6. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_GET_REQUEST_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_LOT_ID                IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_REAL_FLAG             IN  VARCHAR2
      , P_NON_CHK               IN  VARCHAR2
      , P_MY_MODEL_CHK          IN  VARCHAR2
      , P_DELEGATE_CHK          IN  VARCHAR2
      , P_PART_LEADER_CHK       IN  VARCHAR2
      , P_TEAM_LEADER_CHK       IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0022_GET_REQUEST_DETAIL
 * DESCRIPTION  : 전극 SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2020-05-14   KIMYONGHO      신규추가
 * 2020-09-21   KIMYONGHO      SSP INCOTERMS 변경 작업
 * 2021/09/02   KIMYONGHO      -> SCP_MST_BOD_N_V 변경
 * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

        V_MMU_ON                VARCHAR2(1 CHAR);
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        /* IF @P_NON_CHK != 'Y' — 값 없음이면 MSSQL 에서 판정이 서지 않아 조인을 붙이지 않는다 */
        IF P_NON_CHK IS NOT NULL AND P_NON_CHK <> 'Y' THEN
            V_MMU_ON := 'Y';
        ELSE
            V_MMU_ON := 'N';
        END IF;

        OPEN O_RC1 FOR
        SELECT IA.DIVISION_ID
             , IA.ORIGIN_DIVISION_ID
             , IA.BOD_ID
             , IA.MODEL_ID
             , IA.ITEM_ID
             , IA.NICK_NAME
             , IA.PLANT_ID
             , IA.SCM_SITE_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.ETD_DATE
             , IA.SHIPMENT_DATE
             , IA.SHIPMENT_QTY
             , IA.INCOTERMS
             , IA.TRANSPORT_MODE
             , IA.CONFIRM_DAY
             , CASE WHEN IA.CONFIRM_DAY <= IA.SHIPMENT_DATE THEN 'Y' ELSE 'N' END AS EDIT_FLAG
             , IA.REQUESTOR
             , IA.REQUEST_DATE
          FROM (SELECT A.TO_DIVISION_ID                   AS DIVISION_ID
                     , A.FROM_DIVISION_ID                 AS ORIGIN_DIVISION_ID
                     , A.BOD_ID
                     , A.MODEL_ID
                     , A.ITEM_ID
                     , B.ITEM_ID_NICK_NAME                AS NICK_NAME
                     , A.TO_PLANT_ID                      AS PLANT_ID
                     , A.TO_SITE                          AS SCM_SITE_ID
                     , A.FROM_SITE
                     , A.TO_SITE
                     , A.ETD_DATE
                     , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS SHIPMENT_DATE
                     , A.QTY                              AS SHIPMENT_QTY
                     /*  2020-09-21   KIMYONGHO      SSP INCOTERMS 변경 작업 */
                     , C.SSP_INCOTERMS                    AS INCOTERMS
                     , C.TRANSPORT_MODE
                     /* 확정구간 과 Oper LT 중 큰 일수 + bod LT 기간 이후 부터 입력 가능하게 적용 */
                     , CASE WHEN NVL(B.ELECTRODE_POST_OPER_LT, 0) > NVL(D.SHIP_FROZEN, 0)
                            THEN TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                       -- 2026.10.06 AJS 확정일 ETA 함수 캐시 (START)
--                                     + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(A.FROM_DIVISION_ID, A.BOD_ID,
--                                                   TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                                         + (NVL(B.ELECTRODE_POST_OPER_LT, 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
--                                         - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 0), 'YYYY-MM-DD')
--                          ELSE TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                     + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(A.FROM_DIVISION_ID, A.BOD_ID,
--                                                   TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                                         + (NVL(D.SHIP_FROZEN, 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                                       + NVL(TO_DATE((SELECT FN_GET_SSP_ETA_DATE(A.FROM_DIVISION_ID, A.BOD_ID,
                                                     TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                           + (NVL(B.ELECTRODE_POST_OPER_LT, 0) + 0), 'YYYYMMDD')) FROM DUAL), 'YYYYMMDD')
                                           - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 0), 'YYYY-MM-DD')
                            ELSE TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                       + NVL(TO_DATE((SELECT FN_GET_SSP_ETA_DATE(A.FROM_DIVISION_ID, A.BOD_ID,
                                                     TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                           + (NVL(D.SHIP_FROZEN, 0) + 0), 'YYYYMMDD')) FROM DUAL), 'YYYYMMDD')
                                       -- 2026.10.06 AJS 확정일 ETA 함수 캐시 (END)
                                           - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 0), 'YYYY-MM-DD')
                       END                                AS CONFIRM_DAY
/* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN TRIM(E.USERNAME) IS NOT NULL
--                            THEN E.USERNAME || '(' || A.LAST_UPDATED_BY || ')'
                     , CASE WHEN TRIM(E.USER_NM) IS NOT NULL
                            THEN E.USER_NM || '(' || A.LAST_UPDATED_BY || ')'
/* 2026.09.30 AJS 수정 (END) */
                            ELSE NVL(A.LAST_UPDATED_BY, '-') END AS REQUESTOR
                     , A.LAST_UPDATE_DATE                 AS REQUEST_DATE
                  FROM SSP_ANL_SHIP_REQ_EE A
                     , SSP_MST_SITE_ITEM_EE_V B
                     , SCP_MST_BOD_N_V C
                     , SCM_MST_SITE D
/* 2026.09.30 AJS 수정 (START) */
--                     , TB_FX_USER E
                     , SCM_ADM_USER_M E
/* 2026.09.30 AJS 수정 (END) */
                     , (SELECT SA.DIVISION_ID
                             , SA.TO_SITE
                             , SA.ITEM_ID
                          FROM SSP_MST_MODEL_USER_EE SA
                         WHERE SA.VALID_YN = 'Y'
                           AND ( SA.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                                  FROM DUAL
                                                UNION
                                                SELECT CASE WHEN P_DELEGATE_CHK = 'Y' THEN SB.USER_ID ELSE 'X' END
                                                  FROM SSP_MST_DELEGATE SB
                                                 WHERE SB.VALID_YN = 'Y'
                                                   AND SB.DELEGATEE_ID = P_USER_ID
                                                 GROUP BY SB.USER_ID)
                              OR SA.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                              OR SA.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END )) F
                 WHERE B.DIVISION_ID(+) = A.FROM_DIVISION_ID
                   AND B.SCM_SITE_ID(+) = A.FROM_SITE
                   AND B.ITEM_ID(+) = A.ITEM_ID
                   AND C.DIVISION_ID = A.FROM_DIVISION_ID
                   AND C.BOD_ID = A.BOD_ID
                   AND C.FROM_SITE = A.FROM_SITE
                   AND C.TO_SITE = A.TO_SITE
                   AND D.DIVISION_ID(+) = A.FROM_DIVISION_ID
                   AND D.SCM_SITE_ID(+) = C.FROM_SITE
/* 2026.09.30 AJS 수정 (START) */
--                   AND E.USERID(+) = A.LAST_UPDATED_BY
                   AND E.USER_ID(+) = A.LAST_UPDATED_BY
/* 2026.09.30 AJS 수정 (END) */
                   AND F.DIVISION_ID(+) = CASE WHEN V_MMU_ON = 'Y' THEN A.TO_DIVISION_ID END   /* 조건이 꺼지면 짝이 없다 */
                   AND F.TO_SITE(+) = A.TO_SITE
                   AND F.ITEM_ID(+) = A.ITEM_ID
                   AND ( V_MMU_ON = 'N' OR F.ITEM_ID IS NOT NULL )
                   AND A.TO_DIVISION_ID = P_DIVISION_ID
                   AND A.TO_COMPANY_ID = P_COMPANY_ID
                   AND A.ETA_DATE >= P_FROM_YYYYMMDD
                   AND A.ETA_DATE <= P_TO_YYYYMMDD
                   AND C.BOD_VALID_YN = 'Y'
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'                                      /* 조회조건 ALL 은 조건 없음 */
                      OR A.TO_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)                    /* ★AS-IS 는 따옴표 하나로 감싸 두 개 이상이면 0행 */
                                             FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
                      OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                          FROM SCP_MST_FINAL_ITEM XY
                                         WHERE EXISTS (SELECT 1
                                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                       WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                         AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR B.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR B.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   /* ★Lot 조건은 걸 수 없다 — 전극 출하 지시 원장에 LOT_ID 칸이 없다(전극 재고 원장에만 있다).
                      AS-IS 도 Lot 값을 넣으면 오류 207 Invalid column name 'LOT_ID' 로 조회가 끊긴다(실측).
                      화면은 이 갈래에 Lot 을 빈 값으로 고정해 보내고 있어 실제로는 걸리지 않는다. */
                   AND ( TRIM(P_REQUESTOR_ID) IS NULL
                      OR UPPER(P_REQUESTOR_ID) = 'ALL'
/* 2026.09.30 AJS 수정 (START) */
--                      OR A.LAST_UPDATED_BY IN (SELECT DISTINCT SA.USERID
--                                                 FROM TB_FX_USER SA
--                                                WHERE SA.USERNAME IN (SELECT COLUMN_VALUE
                      OR A.LAST_UPDATED_BY IN (SELECT DISTINCT SA.USER_ID
                                                 FROM SCM_ADM_USER_M SA
                                                WHERE UPPER(SA.USER_NM) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
/* 2026.09.30 AJS 수정 (END) */
                                                                        FROM TABLE(STRING_SPLIT(P_REQUESTOR_ID, ',')))
/* 2026.09.30 AJS 수정 (START) */
--                                                   OR SA.USERID IN (SELECT COLUMN_VALUE
                                                   OR UPPER(SA.USER_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
/* 2026.09.30 AJS 수정 (END) */
                                                                      FROM TABLE(STRING_SPLIT(P_REQUESTOR_ID, ',')))) )
               ) IA
         ORDER BY FN_ASIS_SORT_KEY(IA.FROM_SITE) NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.MODEL_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.TO_SITE) NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.ITEM_ID) NULLS FIRST
                , IA.SHIPMENT_DATE NULLS FIRST;

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

    END P_SSP0022_GET_REQUEST_DETAIL;

    /*******************************************************************************
     * P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN
     *   AS-IS SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN
     *
     * 전환 기준
     *   1. ★AS-IS 바깥 조인 조건에 한 값 등호(B.TO_PLANT_ID = @P_PLANT_ID)가 쪼개는 조건과
     *      함께 걸려 있다. 공장을 비우거나 둘 이상 고르면 등호가 깨져 짝이 붙지 않고
     *      수량이 전부 0 으로 내려온다(실측 — 조건 없음 19,907행 수량 합 0).
     *      바로 아래 쪼개는 조건이 같은 일을 하므로 그 한 값 등호만 뺀다.
     *   2. AS-IS 의 LIKE '%' 는 값 없음을 걸러 내는 뜻이 있어 그대로 둔다.
     *   3. 확정일과 편집가능여부는 같은 식이므로 한 번만 셈하고 밖에서 견준다.
     *   4. 조회조건에 ALL 을 「조건 없음」으로 받는다.
     *   5. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_LOT_ID                IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_REAL_FLAG             IN  VARCHAR2
      , P_NON_CHK               IN  VARCHAR2
      , P_MY_MODEL_CHK          IN  VARCHAR2
      , P_DELEGATE_CHK          IN  VARCHAR2
      , P_PART_LEADER_CHK       IN  VARCHAR2
      , P_TEAM_LEADER_CHK       IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN
 * Description  : DELEGATEE_LOAD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/28   KIMYONGHO      신규추가
 * 2020/09/21   KIMYONGHO      SSP INCOTERMS 변경 작업
 * 2021/09/02   KIMYONGHO      -> SCP_MST_BOD_N_V 변경
 * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        OPEN O_RC1 FOR
        SELECT IA.DIVISION_ID
             , IA.COMPANY_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.ITEM_ID
             , IA.YYYYMMDD
             , IA.QTY
             , IA.TRANSPORT_MODE
             , IA.INCOTERMS
             , IA.EDIT_FLAG
          FROM (SELECT A.TO_DIVISION_ID                   AS DIVISION_ID
                     , A.TO_COMPANY_ID                    AS COMPANY_ID
                     , A.FROM_SITE                        AS FROM_SITE
                     , A.TO_SITE                          AS TO_SITE
                     , A.ITEM_ID                          AS ITEM_ID
                     , A.YYYYMMDD                         AS YYYYMMDD
                     , NVL(B.QTY, 0)                      AS QTY
                     , C.TRANSPORT_MODE                   AS TRANSPORT_MODE
                     /*  2020/09/21   KIMYONGHO      SSP INCOTERMS 변경 작업 */
                     , C.SSP_INCOTERMS                    AS INCOTERMS
                     , CASE WHEN CASE WHEN NVL(D.ELECTRODE_POST_OPER_LT, 0) > NVL(E.SHIP_FROZEN, 0)
                                      THEN TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                 + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(A.FROM_DIVISION_ID, B.BOD_ID,
                                                               TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                                     + (NVL(D.ELECTRODE_POST_OPER_LT, 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                                                     - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 0), 'YYYY-MM-DD')
                                      ELSE TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                 + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(A.FROM_DIVISION_ID, B.BOD_ID,
                                                               TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                                     + (NVL(E.SHIP_FROZEN, 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                                                     - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 0), 'YYYY-MM-DD')
                                 END <= TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD')
                            THEN 'Y' ELSE 'N' END         AS EDIT_FLAG
                  FROM (SELECT XB.FROM_COMPANY_ID
                             , XB.FROM_DIVISION_ID
                             , XB.FROM_PLANT_ID
                             , XB.FROM_SITE
                             , XB.TO_COMPANY_ID
                             , XB.TO_DIVISION_ID
                             , XB.TO_PLANT_ID
                             , XB.TO_SITE
                             , XB.MODEL_ID
                             , XB.ITEM_ID
                             , XA.YYYYMMDD
                          FROM SSP_MST_SHIP_CALENDAR XA
                             , SSP_ANL_SHIP_REQ_EE XB
                         WHERE XB.TO_COMPANY_ID = P_COMPANY_ID
                           AND XB.TO_DIVISION_ID = P_DIVISION_ID
                           AND ( TRIM(P_PLANT_ID) IS NULL
                              OR UPPER(P_PLANT_ID) = 'ALL'                          /* 조회조건 ALL 은 조건 없음 */
                              OR XB.TO_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                           AND XB.TO_SITE LIKE '%'
                           AND XB.MODEL_ID LIKE '%'
                           AND ( TRIM(P_ITEM_ID) IS NULL
                              OR UPPER(P_ITEM_ID) = 'ALL'
                              OR UPPER(XB.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                           AND XB.TO_COMPANY_ID = XA.COMPANY_ID
                           AND XB.TO_DIVISION_ID = XA.DIVISION_ID
                           AND XA.DIVISION_ID = P_DIVISION_ID
                           AND XA.COMPANY_ID = P_COMPANY_ID
                           AND XA.YYYYMMDD >= P_FROM_YYYYMMDD
                           AND XA.YYYYMMDD <= P_TO_YYYYMMDD
                         GROUP BY XB.FROM_COMPANY_ID
                                , XB.FROM_DIVISION_ID
                                , XB.FROM_PLANT_ID
                                , XB.FROM_SITE
                                , XB.TO_COMPANY_ID
                                , XB.TO_DIVISION_ID
                                , XB.TO_PLANT_ID
                                , XB.TO_SITE
                                , XB.MODEL_ID
                                , XB.ITEM_ID
                                , XA.YYYYMMDD) A
                     , (SELECT SA.FROM_COMPANY_ID          /* AS-IS 가 바깥 조인 조건에 두었던 걸림조건은
                                                                 인라인 뷰 안에 둔다 — 바깥 조인이 내부조인으로 바뀌지 않게 */
                             , SA.FROM_DIVISION_ID
                             , SA.FROM_PLANT_ID
                             , SA.FROM_SITE
                             , SA.TO_COMPANY_ID
                             , SA.TO_DIVISION_ID
                             , SA.TO_PLANT_ID
                             , SA.TO_SITE
                             , SA.MODEL_ID
                             , SA.ITEM_ID
                             , SA.BOD_ID
                             , SA.ETA_DATE
                             , SA.QTY
                          FROM SSP_ANL_SHIP_REQ_EE SA
                         WHERE SA.TO_COMPANY_ID = P_COMPANY_ID
                           AND SA.TO_DIVISION_ID = P_DIVISION_ID
                           /* ★AS-IS 의 SA.TO_PLANT_ID = @P_PLANT_ID 한 값 등호는 뺀다 — 아래 쪼개는 조건이 같은 일을 한다 */
                           AND ( TRIM(P_PLANT_ID) IS NULL
                              OR UPPER(P_PLANT_ID) = 'ALL'
                              OR SA.TO_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                           AND SA.TO_SITE LIKE '%'
                           AND SA.MODEL_ID LIKE '%'
                           AND ( TRIM(P_ITEM_ID) IS NULL
                              OR UPPER(P_ITEM_ID) = 'ALL'
                              OR UPPER(SA.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )) B
                     , SCP_MST_BOD_N_V C
                     , SSP_MST_SITE_ITEM_EE_V D
                     , SCM_MST_SITE E
                 WHERE B.FROM_COMPANY_ID(+) = A.FROM_COMPANY_ID
                   AND B.FROM_DIVISION_ID(+) = A.FROM_DIVISION_ID
                   AND B.FROM_PLANT_ID(+) = A.FROM_PLANT_ID
                   AND B.FROM_SITE(+) = A.FROM_SITE
                   AND B.TO_COMPANY_ID(+) = A.TO_COMPANY_ID
                   AND B.TO_DIVISION_ID(+) = A.TO_DIVISION_ID
                   AND B.TO_PLANT_ID(+) = A.TO_PLANT_ID
                   AND B.TO_SITE(+) = A.TO_SITE
                   AND B.MODEL_ID(+) = A.MODEL_ID
                   AND B.ITEM_ID(+) = A.ITEM_ID
                   AND B.ETA_DATE(+) = A.YYYYMMDD
                   AND C.DIVISION_ID(+) = B.FROM_DIVISION_ID
                   AND C.BOD_ID(+) = B.BOD_ID
                   AND C.FROM_SITE(+) = B.FROM_SITE
                   AND C.TO_SITE(+) = B.TO_SITE
                   AND D.DIVISION_ID(+) = A.FROM_DIVISION_ID
                   AND D.SCM_SITE_ID(+) = A.FROM_SITE
                   AND D.ITEM_ID(+) = A.ITEM_ID
                   AND E.DIVISION_ID(+) = A.FROM_DIVISION_ID
                   AND E.SCM_SITE_ID(+) = C.FROM_SITE) IA
         WHERE IA.EDIT_FLAG <> 'N'
         ORDER BY FN_ASIS_SORT_KEY(IA.ITEM_ID) NULLS FIRST
                , IA.YYYYMMDD NULLS FIRST;

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

    END P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN;

    /*******************************************************************************
     * P_SSP0022_GET_STOCK_DETAIL
     *   AS-IS SSP0022_GET_STOCK_DETAIL
     *
     * 전환 기준
     *   1. AS-IS 는 문자열로 조회문을 조립한다. 조건 분기가 있는 정적 SQL 로 바꾼다.
     *   2. ★AS-IS 는 조회조건 목록을 따옴표 하나로 감싸 넣어 두 개 이상 고르면 0행이 된다.
     *      원문 맨 아래에 쪼개어 넣는 형태가 주석으로 남아 있어 그것이 원래 뜻이다. 쪼개어 넣는다.
     *   3. 모델담당 조인은 「내 모델만」 조건이 꺼져 있으면 붙지 않는다.
     *      열쇠에 사용자가 들어 있어 여러 행이 붙을 수 있으므로 조인으로 두고
     *      조건이 꺼졌을 때는 짝이 없도록 조인 열쇠를 값 없음으로 막는다.
     *   4. 조회조건에 ALL 을 「조건 없음」으로 받는다.
     *   5. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_GET_STOCK_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_LOT_ID                IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_REAL_FLAG             IN  VARCHAR2
      , P_NON_CHK               IN  VARCHAR2
      , P_MY_MODEL_CHK          IN  VARCHAR2
      , P_DELEGATE_CHK          IN  VARCHAR2
      , P_PART_LEADER_CHK       IN  VARCHAR2
      , P_TEAM_LEADER_CHK       IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0022_GET_STOCK_DETAIL
 * DESCRIPTION  : 전극 SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2020-05-14   KIMYONGHO      신규추가
 * 2020-07-21   juhlee         Pallet id 추가
 * 2020-07-21   KIMYONGHO      'ELECTRODE_SHIP_STORAGE'  재고 집계 제외 대상 추가
 * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

        V_MMU_ON                VARCHAR2(1 CHAR);
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        /* IF @P_NON_CHK != 'Y' — 값 없음이면 MSSQL 에서 판정이 서지 않아 조인을 붙이지 않는다 */
        IF P_NON_CHK IS NOT NULL AND P_NON_CHK <> 'Y' THEN
            V_MMU_ON := 'Y';
        ELSE
            V_MMU_ON := 'N';
        END IF;

        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , NVL(B.CELL_TYPE, '-')                     AS CELL_TYPE
             , B.MODEL_ID
             , A.ITEM_ID
             , B.ITEM_ID_NICK_NAME                       AS NICK_NAME
             , A.VERSION                                 AS VERSION
             , CAST(B.LANE AS NUMBER(5, 2))              AS LANE
             , A.LOT_ID
             , A.PALLET_ID
             , A.STORAGE_ID                              AS STORAGE_ID
             , A.OPERATION_ID                            AS OPERATION_ID
             , D.SEGMENT2                                AS CHANGE_STATUS
             /* FLOOR - > CEILING 으로 변경 KIMYONGHO 2020-09-03 */
             , CEIL(A.IWMS_QTY)                          AS IWMS_QTY_UOM
             , CEIL(A.IWMS_QTY * NVL(B.CONVERT_TO_PCM, 1))  AS IWMS_QTY_PCM
             , CEIL(A.GMES_QTY)                          AS GMES_QTY_UOM
             , CEIL(A.GMES_QTY * NVL(B.CONVERT_TO_PCM, 1))  AS GMES_QTY_PCM
             , CEIL(A.OWMS_QTY)                          AS OWMS_QTY_UOM
             , CEIL(A.OWMS_QTY * NVL(B.CONVERT_TO_PCM, 1))  AS OWMS_QTY_PCM
             , CEIL(A.TOT_QTY)                           AS TOTAL_QTY_UOM
             , CEIL(A.TOT_QTY * NVL(B.CONVERT_TO_PCM, 1))   AS TOTAL_QTY_PCM
             , A.AVAILABLE_YN
             , A.IWMS_HOLD_YN
             , A.GMES_HOLD_YN                            AS MES_HOLD_YN
             , A.QMS_HOLD_YN
             , A.OWMS_HOLD_YN
             , A.EXPIRATION_DATE
             , A.PACKAGE_TYPE                            AS PACKAGE_TYPE_CODE
          FROM SSP_ANL_STOCK_EE_C A
             , SSP_MST_SITE_ITEM_EE_V B
             , SCM_MST_SLOC C
             , SCM_ADM_LOOKUP_MASTER_DETAIL D
             , (SELECT SA.DIVISION_ID
                     , SA.TO_SITE
                     , SA.ITEM_ID
                  FROM SSP_MST_MODEL_USER_EE SA
                 WHERE SA.VALID_YN = 'Y'
                   AND ( SA.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          FROM DUAL
                                        UNION
                                        SELECT CASE WHEN P_DELEGATE_CHK = 'Y' THEN SB.USER_ID ELSE 'X' END
                                          FROM SSP_MST_DELEGATE SB
                                         WHERE SB.VALID_YN = 'Y'
                                           AND SB.DELEGATEE_ID = P_USER_ID
                                         GROUP BY SB.USER_ID)
                      OR SA.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                      OR SA.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END )) E
         WHERE B.ASSY_DIVISION_ID(+) = A.DIVISION_ID
           AND B.ASSY_SCM_SITE_ID(+) = A.FROM_SITE
           AND B.ITEM_ID(+) = A.ITEM_ID
           AND C.PLANT_ID(+) = A.PLANT_ID
           AND C.STORAGE_ID(+) = A.STORAGE_ID
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND D.LOOKUP_TYPE = 'MES_CHANGE_STATUS'
           AND D.VALID_YN = 'Y'
           AND D.SEGMENT1 = A.CHANGE_STATUS
           AND E.DIVISION_ID(+) = CASE WHEN V_MMU_ON = 'Y' THEN A.DIVISION_ID END   /* 조건이 꺼지면 짝이 없다 */
           AND E.TO_SITE(+) = A.FROM_SITE
           AND E.ITEM_ID(+) = A.ITEM_ID
           AND ( V_MMU_ON = 'N' OR E.ITEM_ID IS NOT NULL )
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.TYPE = 'A'
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.COMPANY_ID = P_COMPANY_ID
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'                                      /* 조회조건 ALL 은 조건 없음 */
              OR SUBSTR(A.FROM_SITE, 1, 4) IN (SELECT UPPER(COLUMN_VALUE)        /* ★AS-IS 는 따옴표 하나로 감싸 두 개 이상이면 0행 */
                                                 FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR B.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND ( UPPER(B.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%'
                               OR UPPER(B.MODEL_ID_NICK_NAME) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%' )) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_NICK_NAME) IS NULL
              OR UPPER(P_NICK_NAME) = 'ALL'
              OR B.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
           AND ( TRIM(P_CELL_TYPE) IS NULL
              OR UPPER(P_CELL_TYPE) = 'ALL'
              OR B.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
           AND ( TRIM(P_LOT_ID) IS NULL
              OR UPPER(P_LOT_ID) = 'ALL'
              OR UPPER(A.LOT_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                FROM TABLE(STRING_SPLIT(P_LOT_ID, ','))) )
         ORDER BY FN_ASIS_SORT_KEY(A.PLANT_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(B.MODEL_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.LOT_ID) NULLS FIRST;

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

    END P_SSP0022_GET_STOCK_DETAIL;

    /*******************************************************************************
     * P_SSP0022_PSI_PRE  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 앞부분 — 두 갈래가 함께 쓰는 기준 자료를 담는다
     *     · GT_0022_PLAN_ITEM_CUTOFF : AS-IS #TMP_PLAN_ITEM_CUTOFF
     *     · GT_0022_BOH_CUTOFF       : AS-IS #TMP_BOH_CUTOFF_EE
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_PRE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_NON_CHK               IN  VARCHAR2
      , P_MY_MODEL_CHK          IN  VARCHAR2
      , P_DELEGATE_CHK          IN  VARCHAR2
      , P_PART_LEADER_CHK       IN  VARCHAR2
      , P_TEAM_LEADER_CHK       IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_PLAN_ITEM_CUTOFF;
        DELETE FROM GT_0022_BOH_CUTOFF;

        /* 조회 기준 데이터 */
        INSERT INTO GT_0022_PLAN_ITEM_CUTOFF
             ( COMPANY_ID, DIVISION_ID, PLANT_ID, SCM_SITE_ID, MODEL_ID, ITEM_ID )
        SELECT DISTINCT A.COMPANY_ID
             , A.DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.MODEL_ID
             , A.ITEM_ID
          FROM SSP_ANL_SHIP_PLAN_EE A
             , SSP_MST_MODEL_USER_EE B
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.TO_SITE(+) = A.SCM_SITE_ID
           AND B.ITEM_ID(+) = A.ITEM_ID
           AND B.VALID_YN(+) = 'Y'
           AND A.MEASURE_TYPE = 'R'
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.COMPANY_ID = P_COMPANY_ID
           AND ( ( P_NON_CHK = 'Y' AND 1 = 1 )
              OR B.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                 FROM DUAL
                               UNION
                               SELECT CASE WHEN P_DELEGATE_CHK = 'Y' THEN SA.USER_ID ELSE 'X' END
                                 FROM SSP_MST_DELEGATE SA
                                WHERE SA.VALID_YN = 'Y'
                                  AND SA.DELEGATEE_ID = P_USER_ID
                                GROUP BY SA.USER_ID)
              OR B.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
              OR B.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END );

        /* 마감 기초재고 */
        INSERT INTO GT_0022_BOH_CUTOFF
             ( COMPANY_ID, DIVISION_ID, PLANT_ID, SCM_SITE_ID, MODEL_ID, ITEM_ID
             , TOT_BOH_QTY, JR_BOH_QTY, PC_BOH_QTY
             , TOT_BOH_QTY_PCM, JR_BOH_QTY_PCM, PC_BOH_QTY_PCM
             , TOT_BOH_QTY_CELL, JR_BOH_QTY_CELL, PC_BOH_QTY_CELL
             , CUTOFF_DATE, MEASURE_TYPE )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.MODEL_ID
             , A.ITEM_ID
             /* START E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 가능 */
             , NVL(A.TOT_BOH_QTY, 0.000)                AS TOT_BOH_QTY
             , NVL(A.JR_BOH_QTY, 0.000)                 AS JR_BOH_QTY
             , NVL(A.PC_BOH_QTY, 0.000)                 AS PC_BOH_QTY
             , NVL(A.TOT_BOH_QTY_TO_PCM, 0.000)         AS TOT_BOH_QTY_PCM
             , NVL(A.JR_BOH_QTY_TO_PCM, 0.000)          AS JR_BOH_QTY_PCM
             , NVL(A.PC_BOH_QTY_TO_PCM, 0.000)          AS PC_BOH_QTY_PCM
             , NVL(A.TOT_BOH_QTY_TO_CELL, 0.000)        AS TOT_BOH_QTY_CELL
             , NVL(A.JR_BOH_QTY_TO_CELL, 0.000)         AS JR_BOH_QTY_CELL
             , NVL(A.PC_BOH_QTY_TO_CELL, 0.000)         AS PC_BOH_QTY_CELL
             /* END E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 가능 */
             , A.CUTOFF_DATE
             , A.MEASURE_TYPE
          FROM SSP_ANL_BOH_CUTOFF_EE A
         WHERE A.CUTOFF_DATE = P_PLAN_START_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.COMPANY_ID IN (SELECT COLUMN_VALUE
                                  FROM TABLE(STRING_SPLIT(P_COMPANY_ID, ',')))
           AND A.MEASURE_TYPE = 'R'
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'                                       /* 조회조건 ALL 은 조건 없음 */
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) );
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
              OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                  FROM SCP_MST_FINAL_ITEM XY
                                 WHERE EXISTS (SELECT 1
                                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                               WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                 AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) );
/* 2026.10.07 AJS Model/Nickname 검색 (END) */

    END P_SSP0022_PSI_PRE;

    /*******************************************************************************
     * P_SSP0022_PSI_ETD  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 R_SHIP_PLAN_ETD 측정값 만들기
     *     · GT_0022_SHIP_PLAN_ETD : AS-IS #TMP_SHIP_PLAN_ETD
     *   세 묶음을 이어 붙인다 — ① 출하 실적(실적구간) ② 확정구간 ③ 확정구간 이후 출하 지시
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_ETD
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_END_YYYYMMDD     IN  VARCHAR2
      , P_RESULT_START_YYYYMMDD IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_SHIP_PLAN_ETD;

        /* R_SHIP_PLAN_ETD 메져 생성 */
        /* START E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
        INSERT INTO GT_0022_SHIP_PLAN_ETD
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        /* 출하 실적(OWMS) : 실적구간 */
        SELECT A.DIVISION_ID
             , B.LOGISTIC_PLANT_ID                      AS PLANT_ID
             , B.COMPANY_ID                             AS COMPANY_ID
             , C.ATTRIBUTE1                             AS SCM_SITE_ID
             , NVL(D.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , D.CELL_TYPE                              AS CELL_TYPE
             , D.MODEL_ID                               AS MODEL_ID
             , A.ITEM_ID                                AS ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_SHIP_PLAN_ETD'                        AS MEASURE
             , A.YYYYMMDD                               AS YYYYMMDD
             , CAST(A.QTY AS NUMBER(30, 3))             AS QTY
             , A.QTY * NVL(D.CONVERT_TO_PCM, 1)         AS QTY_TO_PCM
             , A.QTY * NVL(D.CONVERT_TO_CELL, 1)        AS QTY_TO_CELL
             , '-'                                      AS LAST_UPDATED_BY
             , NULL                                     AS LAST_UPDATE_DATE
          FROM SSP_DNM_SHIP_RESULT_OWMS_V A
             , SCM_MST_SITE B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
/*           , SSP_MST_SITE_ITEM_EE_V D */
             , (SELECT XA.* /* AJS 20261007 속도 */
                   FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                  WHERE (XA.DIVISION_ID, XA.ITEM_ID) IN (SELECT XB.DIVISION_ID /* AJS 20261007 속도 */
                                                             , XB.ITEM_ID /* AJS 20261007 속도 */
                                                          FROM GT_0022_PLAN_ITEM_CUTOFF XB)) D /* AJS 20261007 속도 */
             , GT_0022_PLAN_ITEM_CUTOFF E
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.SCM_SITE_ID(+) = A.FROM_SITE
           AND C.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING'
           AND C.VALID_YN = 'Y'
           AND C.SEGMENT1 = P_DIVISION_ID
           AND C.SEGMENT1 = A.DIVISION_ID
           AND C.SEGMENT4 = B.PLANT_ID
           AND C.ATTRIBUTE2 = A.FROM_SITE
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SCM_SITE_ID(+) = A.FROM_SITE
           AND D.ITEM_ID(+) = A.ITEM_ID
           AND E.DIVISION_ID = A.DIVISION_ID
           AND E.SCM_SITE_ID = C.ATTRIBUTE1
           AND E.ITEM_ID = A.ITEM_ID
           AND B.DIVISION_ID = P_DIVISION_ID
           AND B.COMPANY_ID = P_COMPANY_ID
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'                                      /* 조회조건 ALL 은 조건 없음 */
              OR B.LOGISTIC_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR D.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND ( UPPER(D.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%'
                               OR UPPER(D.MODEL_ID_NICK_NAME) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%' )) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_CELL_TYPE) IS NULL
              OR UPPER(P_CELL_TYPE) = 'ALL'
              OR D.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
           AND ( TRIM(P_NICK_NAME) IS NULL
              OR UPPER(P_NICK_NAME) = 'ALL'
              OR D.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
           AND B.SITE_TYPE = 'PLANT'
           AND B.OPERATION_GROUP = 'E'
           AND A.YYYYMMDD >= P_RESULT_START_YYYYMMDD
           AND A.YYYYMMDD < P_PLAN_START_YYYYMMDD
        UNION ALL
        /* R_SHIP_PLAN_ETD Measure 추가
           확정구간
        */
        SELECT A.DIVISION_ID                            AS DIVISION_ID
             , C.SEGMENT2                               AS PLANT_ID
             , A.FROM_SITE_COMPANY_ID                   AS COMPANY_ID
             , C.ATTRIBUTE1                             AS SCM_SITE_ID
             , NVL(D.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , D.CELL_TYPE                              AS CELL_TYPE
             , D.MODEL_ID                               AS MODEL_ID
             , A.ITEM_ID                                AS ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_SHIP_PLAN_ETD'                        AS MEASURE
             , A.YYYYMMDD                               AS YYYYMMDD
             , CAST(A.QTY AS NUMBER(30, 3))             AS QTY
             , A.QTY * NVL(D.CONVERT_TO_PCM, 1)         AS QTY_TO_PCM
             , A.QTY * NVL(D.CONVERT_TO_CELL, 1)        AS QTY_TO_CELL
             , '-'                                      AS LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_CONFIRM A
             , SCM_MST_SITE B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
/*           , SSP_MST_SITE_ITEM_EE_V D */
             , (SELECT XA.* /* AJS 20261007 속도 */
                   FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                  WHERE (XA.DIVISION_ID, XA.ITEM_ID) IN (SELECT XB.DIVISION_ID /* AJS 20261007 속도 */
                                                             , XB.ITEM_ID /* AJS 20261007 속도 */
                                                          FROM GT_0022_PLAN_ITEM_CUTOFF XB)) D /* AJS 20261007 속도 */
             , GT_0022_PLAN_ITEM_CUTOFF E
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.SCM_SITE_ID(+) = A.FROM_SITE
           AND C.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING'
           AND C.VALID_YN = 'Y'
           AND C.SEGMENT1 = P_DIVISION_ID
           AND A.DIVISION_ID = C.SEGMENT1
           AND B.PLANT_ID = C.SEGMENT4
           AND A.FROM_SITE = C.ATTRIBUTE2
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SCM_SITE_ID(+) = A.FROM_SITE
           AND D.ITEM_ID(+) = A.ITEM_ID
           AND E.DIVISION_ID = A.DIVISION_ID
           AND E.SCM_SITE_ID = C.ATTRIBUTE1
           AND E.ITEM_ID = A.ITEM_ID
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.FROM_SITE_COMPANY_ID = P_COMPANY_ID
           AND A.CHANGE_TYPE = 'C'
           AND A.BIZ_TYPE = 'E'
           AND A.QTY > 0
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR B.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR D.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND ( UPPER(D.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%'
                               OR UPPER(D.MODEL_ID_NICK_NAME) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%' )) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_CELL_TYPE) IS NULL
              OR UPPER(P_CELL_TYPE) = 'ALL'
              OR D.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
           AND ( TRIM(P_NICK_NAME) IS NULL
              OR UPPER(P_NICK_NAME) = 'ALL'
              OR D.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
           AND A.YYYYMMDD >= P_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD <= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                 + FN_GET_SSP_ANL_SHIP_FROZEN(A.ORIGIN_FROM_DIVISION_ID, A.FROM_SITE), 'YYYYMMDD')  --  2026.10.06 AJS
                                   + (SELECT FN_GET_SSP_ANL_SHIP_FROZEN(A.ORIGIN_FROM_DIVISION_ID, A.FROM_SITE) FROM DUAL), 'YYYYMMDD')  --  2026.10.06 AJS
        UNION ALL
        /* R_SHIP_PLAN_ETD Measure 추가
           확정구간 이후 Ship Req 수량 합 ETD기준
        */
        SELECT IA.DIVISION_ID
             , IA.SEGMENT2                              AS PLANT_ID
             , IA.COMPANY_ID                            AS COMPANY_ID
             , IA.ATTRIBUTE1                            AS SCM_SITE_ID
             , IA.ELECTRODE_TYPE                        AS ELECTRODE_TYPE
             , IA.CELL_TYPE                             AS CELL_TYPE
             , IA.MODEL_ID
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.BOD_ID                                AS BOD_ID
             , IA.MEASURE                               AS MEASURE
             , IA.YYYYMMDD                              AS YYYYMMDD
             , CAST(IA.QTY AS NUMBER(30, 3))            AS QTY
             , IA.QTY_TO_PCM                            AS QTY_TO_PCM
             , IA.QTY_TO_CELL                           AS QTY_TO_CELL
             , IA.LAST_UPDATED_BY
             , IA.LAST_UPDATE_DATE
          FROM (SELECT A.FROM_DIVISION_ID               AS DIVISION_ID
                     , A.FROM_PLANT_ID                  AS PLANT_ID
                     , A.FROM_COMPANY_ID                AS COMPANY_ID
                     , A.FROM_SITE                      AS SCM_SITE_ID
                     , NVL(D.ELECTRODE_TYPE, '-')       AS ELECTRODE_TYPE
                     , D.CELL_TYPE                      AS CELL_TYPE
                     , A.MODEL_ID
                     , A.ITEM_ID
                     , '-'                              AS FROM_SITE
                     , '-'                              AS TO_SITE
                     , '-'                              AS BOD_ID
                     , 'R_SHIP_PLAN_ETD'                AS MEASURE
                     , A.ETD_DATE                       AS YYYYMMDD
                     , CAST(A.QTY AS NUMBER(30, 3))     AS QTY
                     , A.QTY_TO_PCM                     AS QTY_TO_PCM
                     , A.QTY_TO_CELL                    AS QTY_TO_CELL
                     , '-'                              AS LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , C.ATTRIBUTE2
                     , C.SEGMENT4
                     , C.SEGMENT1
                     , C.ATTRIBUTE1
                     , C.SEGMENT2
                  FROM SSP_ANL_SHIP_REQ_EE A
                     , SCM_ADM_LOOKUP_MASTER_DETAIL C
                     , SCM_MST_SITE B
/*                   , SSP_MST_SITE_ITEM_EE_V D */
                     , (SELECT XA.* /* AJS 20261007 속도 */
                           FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                          WHERE (XA.DIVISION_ID, XA.ITEM_ID) IN (SELECT XB.DIVISION_ID /* AJS 20261007 속도 */
                                                                     , XB.ITEM_ID /* AJS 20261007 속도 */
                                                                  FROM GT_0022_PLAN_ITEM_CUTOFF XB)) D /* AJS 20261007 속도 */
                     , GT_0022_PLAN_ITEM_CUTOFF E
                 WHERE C.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING'
                   AND C.VALID_YN = 'Y'
                   AND C.SEGMENT1 = P_DIVISION_ID
                   AND A.FROM_DIVISION_ID = C.SEGMENT1
                   AND A.FROM_PLANT_ID = C.SEGMENT4
                   AND A.FROM_SITE = C.ATTRIBUTE2
                   AND B.DIVISION_ID(+) = C.SEGMENT3
                   AND B.SCM_SITE_ID(+) = C.ATTRIBUTE2
                   AND B.SITE_TYPE(+) = 'PLANT'
                   AND B.OPERATION_GROUP(+) = 'E'
                   AND B.VALID_YN(+) = 'Y'
                   AND D.DIVISION_ID(+) = A.FROM_DIVISION_ID
                   AND D.SCM_SITE_ID(+) = A.FROM_SITE
                   AND D.ITEM_ID(+) = A.ITEM_ID
                   AND E.DIVISION_ID = A.FROM_DIVISION_ID
                   AND E.SCM_SITE_ID = C.ATTRIBUTE1
                   AND E.ITEM_ID = A.ITEM_ID
                   AND A.FROM_DIVISION_ID = P_DIVISION_ID
                   AND A.FROM_COMPANY_ID = P_COMPANY_ID
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'
                      OR B.LOGISTIC_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR D.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND ( UPPER(D.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%'
                                       OR UPPER(D.MODEL_ID_NICK_NAME) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%' )) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR D.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR D.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
                   /* 확정 구간 이후 */
                   AND A.ETD_DATE >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                         + FN_GET_SSP_ANL_SHIP_FROZEN(A.FROM_DIVISION_ID, A.FROM_SITE), 'YYYYMMDD')  --  2026.10.06 AJS
                                           + (SELECT FN_GET_SSP_ANL_SHIP_FROZEN(A.FROM_DIVISION_ID, A.FROM_SITE) FROM DUAL), 'YYYYMMDD')  --  2026.10.06 AJS
                   AND A.ETD_DATE < P_PLAN_END_YYYYMMDD) IA;

    END P_SSP0022_PSI_ETD;

    /*******************************************************************************
     * P_SSP0022_PSI_INTRANSIT  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 R_INTRANSIT_ETA 측정값 만들기
     *     · GT_0022_INTRANSIT_ETA : AS-IS #TMP_INTRANSIT_ETA
     *   네 묶음을 이어 붙인다
     *     ① 재공(FP 재공 원장) ② 확정구간 ③ 확정구간 이후 출하 지시
     *     ④ 특정 매핑(사업부 40 · 출발 HQ06-E → 도착 NJ01-P)만 출하계획 시뮬레이션 값으로
     *   ★AS-IS 는 ③④ 를 안쪽 UNION 으로 한 번 더 감싸 이름만 바꿔 넘긴다.
     *     바꾸는 것이 없어 네 묶음을 한 단계로 펼쳤다(칸 자리는 그대로).
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_INTRANSIT
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_END_YYYYMMDD     IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
    )
    IS

        /* NERP 매핑코드 */
        V_C100                  VARCHAR2(10 CHAR) := FN_GET_LOOKUP_VALUE('SSP0022_GET_SHIPMENT_PSI', 'ESOC');   /* C100 */
        V_G180                  VARCHAR2(10 CHAR) := FN_GET_LOOKUP_VALUE('SSP0022_GET_SHIPMENT_PSI', 'ESNJ');   /* G180 */
        V_A011E                 VARCHAR2(10 CHAR) := FN_GET_LOOKUP_VALUE('SSP0022_GET_SHIPMENT_PSI', 'A011E');  /* A011-E */
        V_G182A                 VARCHAR2(10 CHAR) := FN_GET_LOOKUP_VALUE('SSP0022_GET_SHIPMENT_PSI', 'G182A');  /* G182-A */

    BEGIN

        DELETE FROM GT_0022_INTRANSIT_ETA;

        /* R_INTRANSIT_ETA 메져 생성 */
        INSERT INTO GT_0022_INTRANSIT_ETA
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        /* ① 재공 */
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.COMPANY_ID
             , C.SCM_SITE_ID
             , NVL(D.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , D.CELL_TYPE                              AS CELL_TYPE
             , B.CELL_ITEM_ID                           AS MODEL_ID
             , A.ITEM_ID                                AS ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_INTRANSIT_ETA'                        AS MEASURE
             , CASE WHEN TO_CHAR(A.ETA_DATE, 'YYYYMMDD') < P_PLAN_START_YYYYMMDD
                    THEN P_PLAN_START_YYYYMMDD
                    ELSE TO_CHAR(A.ETA_DATE, 'YYYYMMDD') END  AS YYYYMMDD
             , SUM(A.INTRANSIT_QTY)                     AS QTY
             , SUM(A.INTRANSIT_QTY * NVL(D.CONVERT_TO_PCM, 1))  AS QTY_TO_PCM
             , SUM(A.INTRANSIT_QTY * NVL(D.CONVERT_TO_CELL, 1)) AS QTY_TO_CELL
             , '-'                                      AS LAST_UPDATED_BY
             , NULL                                     AS LAST_UPDATE_DATE
          FROM SSP_DNM_FP_MRP_INTRANSIT_SN A
             , SCP_MST_FINAL_ITEM B
             , SCM_MST_SITE C
/*           , SSP_MST_SITE_ITEM_EE_V D */
             , (SELECT XA.* /* AJS 20261007 속도 */
                   FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                  WHERE (XA.DIVISION_ID, XA.ITEM_ID) IN (SELECT XB.DIVISION_ID /* AJS 20261007 속도 */
                                                             , XB.ITEM_ID /* AJS 20261007 속도 */
                                                          FROM GT_0022_PLAN_ITEM_CUTOFF XB)) D /* AJS 20261007 속도 */
             , GT_0022_PLAN_ITEM_CUTOFF E
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND B.OPERATION_GROUP = 'E'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.PLANT_ID = A.PLANT_ID
           AND C.OPERATION_GROUP = 'A'
           AND D.DIVISION_ID = A.DIVISION_ID
           AND D.COMPANY_ID = A.VENDOR_CODE                 /* 전극은 VENDOR_CODE 기준으로 임시 */
           AND D.ITEM_ID = A.ITEM_ID
           AND E.DIVISION_ID = A.DIVISION_ID
           AND E.SCM_SITE_ID = C.SCM_SITE_ID
           AND E.ITEM_ID = A.ITEM_ID
           AND A.INTRANSIT_QTY > 0
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.COMPANY_ID = P_COMPANY_ID
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'                                      /* 조회조건 ALL 은 조건 없음 */
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR B.CELL_ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND UPPER(B.CELL_ITEM_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
              OR B.CELL_ITEM_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                      FROM SCP_MST_FINAL_ITEM XY
                                     WHERE EXISTS (SELECT 1
                                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                   WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                     AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_CELL_TYPE) IS NULL
              OR UPPER(P_CELL_TYPE) = 'ALL'
              OR D.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
           AND ( TRIM(P_NICK_NAME) IS NULL
              OR UPPER(P_NICK_NAME) = 'ALL'
              OR D.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
         GROUP BY A.COMPANY_ID
                , A.DIVISION_ID
                , A.PLANT_ID
                , C.SCM_SITE_ID
                , D.ELECTRODE_TYPE
                , D.CELL_TYPE
                , A.ITEM_ID
                , B.CELL_ITEM_ID
                , A.ETA_DATE
        UNION ALL
        /* ② R_INTRANSIT_ETA Measure 추가 — 확정구간 수량 합 ETA기준 */
        SELECT C.DIVISION_ID                            AS DIVISION_ID
             , C.PLANT_ID                               AS PLANT_ID
             , C.COMPANY_ID                             AS COMPANY_ID
             , A.TO_SITE                                AS SCM_SITE_ID
             , NVL(D.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , D.CELL_TYPE                              AS CELL_TYPE
             , D.MODEL_ID                               AS MODEL_ID
             , A.ITEM_ID                                AS ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_INTRANSIT_ETA'                        AS MEASURE
             , A.ETA_DATE                               AS YYYYMMDD
             , A.QTY                                    AS QTY
             , A.QTY * NVL(D.CONVERT_TO_PCM, 1)         AS QTY_TO_PCM
             , A.QTY * NVL(D.CONVERT_TO_CELL, 1)        AS QTY_TO_CELL
             , '-'                                      AS LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_CONFIRM A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
/*           , SSP_MST_SITE_ITEM_EE_V D */
             , (SELECT XA.* /* AJS 20261007 속도 */
                   FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                  WHERE (XA.DIVISION_ID, XA.ITEM_ID) IN (SELECT XB.DIVISION_ID /* AJS 20261007 속도 */
                                                             , XB.ITEM_ID /* AJS 20261007 속도 */
                                                          FROM GT_0022_PLAN_ITEM_CUTOFF XB)) D /* AJS 20261007 속도 */
             , GT_0022_PLAN_ITEM_CUTOFF E
         WHERE A.ORIGIN_FROM_DIVISION_ID = B.DIVISION_ID
           AND A.FROM_SITE = B.SCM_SITE_ID
           AND A.ORIGIN_TO_DIVISION_ID = C.DIVISION_ID
           AND A.TO_SITE = C.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SCM_SITE_ID(+) = A.FROM_SITE
           AND D.ITEM_ID(+) = A.ITEM_ID
           AND E.DIVISION_ID = A.DIVISION_ID
           AND E.SCM_SITE_ID = A.TO_SITE
           AND E.ITEM_ID = A.ITEM_ID
           AND A.ORIGIN_TO_DIVISION_ID = P_DIVISION_ID
           AND A.TO_SITE_COMPANY_ID = P_COMPANY_ID
           AND A.CHANGE_TYPE = 'C'
           AND A.BIZ_TYPE = 'E'
           AND A.QTY > 0
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.TO_SITE_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                          FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR D.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND ( UPPER(D.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%'
                               OR UPPER(D.MODEL_ID_NICK_NAME) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%' )) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_CELL_TYPE) IS NULL
              OR UPPER(P_CELL_TYPE) = 'ALL'
              OR D.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
           AND ( TRIM(P_NICK_NAME) IS NULL
              OR UPPER(P_NICK_NAME) = 'ALL'
              OR D.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
           AND A.ETA_DATE >= P_PLAN_START_YYYYMMDD
           AND A.ETA_DATE < P_PLAN_END_YYYYMMDD
        UNION ALL
        /* ③ R_INTRANSIT_ETA Measure 추가 — 확정구간 이후 Ship Req 수량 합 ETA기준
             2020-07-17   kimbk  Receipt(Intransit)+Shipment Plan(In)의 Plan in 값을
                                 Shipment Plan의 Simulation값으로 표시
                                 Division = '40' and From Site = 'A011-E' and To Site = '' 인 정보만 적용
                                 기존 REQ 정보에서 위 정보는 제외 처리 함 */
        SELECT C.DIVISION_ID                            AS DIVISION_ID
             , C.PLANT_ID                               AS PLANT_ID
             , C.COMPANY_ID                             AS COMPANY_ID
             , A.TO_SITE                                AS SCM_SITE_ID
             , NVL(D.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , D.CELL_TYPE                              AS CELL_TYPE
             , A.MODEL_ID
             , A.ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_INTRANSIT_ETA'                        AS MEASURE
             , A.ETA_DATE                               AS YYYYMMDD
             , A.QTY                                    AS QTY
             , A.QTY_TO_PCM                             AS QTY_TO_PCM
             , A.QTY_TO_CELL                            AS QTY_TO_CELL
             , '-'                                      AS LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_REQ_EE A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
/*           , SSP_MST_SITE_ITEM_EE_V D */
             , (SELECT XA.* /* AJS 20261007 속도 */
                   FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                  WHERE XA.ITEM_ID IN (SELECT XB.ITEM_ID /* AJS 20261007 속도 */
                                         FROM GT_0022_PLAN_ITEM_CUTOFF XB)) D /* AJS 20261007 속도 */
             , GT_0022_PLAN_ITEM_CUTOFF E
         WHERE A.FROM_DIVISION_ID = B.DIVISION_ID
           AND A.FROM_SITE = B.SCM_SITE_ID
           AND A.TO_DIVISION_ID = C.DIVISION_ID
           AND A.TO_SITE = C.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.FROM_DIVISION_ID
           AND D.SCM_SITE_ID(+) = A.FROM_SITE
           AND D.ITEM_ID(+) = A.ITEM_ID
           AND E.DIVISION_ID = A.TO_DIVISION_ID
           AND E.SCM_SITE_ID = A.TO_SITE
           AND E.ITEM_ID = A.ITEM_ID
           AND A.TO_DIVISION_ID = P_DIVISION_ID
           AND A.TO_COMPANY_ID = P_COMPANY_ID
           AND A.CONFIRM_FLAG <> 'Y'                        /* CONFIRM된 REQUEST 제외 */
           AND NOT EXISTS ( SELECT 1
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                             WHERE SA.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
                               AND SA.VALID_YN = 'Y'
                               AND SA.SEGMENT2 = '40'
                               AND SA.SEGMENT1 = V_C100
                               AND SA.SEGMENT3 = V_A011E
                               AND SA.SEGMENT5 = '40'
                               AND SA.SEGMENT4 = V_G180
                               AND SA.ATTRIBUTE1 = V_G182A
                               AND A.FROM_DIVISION_ID = SA.SEGMENT2
                               AND A.FROM_COMPANY_ID = SA.SEGMENT1
                               AND A.FROM_SITE = SA.SEGMENT3
                               AND A.TO_DIVISION_ID = SA.SEGMENT5
                               AND A.TO_COMPANY_ID = SA.SEGMENT4
                               AND A.TO_SITE = SA.ATTRIBUTE1 )
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.TO_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
              OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                  FROM SCP_MST_FINAL_ITEM XY
                                 WHERE EXISTS (SELECT 1
                                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                               WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                 AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_CELL_TYPE) IS NULL
              OR UPPER(P_CELL_TYPE) = 'ALL'
              OR D.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
           AND ( TRIM(P_NICK_NAME) IS NULL
              OR UPPER(P_NICK_NAME) = 'ALL'
              OR D.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
           /* 확정 구간 이후 */
           AND A.ETA_DATE >= P_PLAN_START_YYYYMMDD
           AND A.ETA_DATE < P_PLAN_END_YYYYMMDD
        UNION ALL
        /* ④ 2020-07-17 kimbk — 사업부 40 · 출발 A011-E → 도착 G182-A 매핑만
             출하계획 시뮬레이션 값으로 표시 */
        SELECT B.SEGMENT5                               AS DIVISION_ID
             , FN_GET_SSP_SITE_INFO(B.SEGMENT5, B.ATTRIBUTE1, 'PLANT_ID')  AS PLANT_ID
             , B.SEGMENT4                               AS COMPANY_ID
             , B.ATTRIBUTE1                             AS SCM_SITE_ID
             , NVL(D.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , D.CELL_TYPE                              AS CELL_TYPE
             , D.MODEL_ID                               AS MODEL_ID
             , A.ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_INTRANSIT_ETA'                        AS MEASURE
             , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD')
--                   + FN_GET_SSP_ANL_SHIP_FROZEN(B.SEGMENT2, B.SEGMENT3), 'YYYYMMDD') AS YYYYMMDD  --  2026.10.06 AJS
                     + (SELECT FN_GET_SSP_ANL_SHIP_FROZEN(B.SEGMENT2, B.SEGMENT3) FROM DUAL), 'YYYYMMDD') AS YYYYMMDD  --  2026.10.06 AJS
             , CAST(A.QTY AS NUMBER(30, 3))             AS QTY
             , A.QTY * NVL(D.CONVERT_TO_PCM, 1)         AS QTY_TO_PCM
             , A.QTY * NVL(D.CONVERT_TO_CELL, 1)        AS QTY_TO_CELL
             , '-'                                      AS LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_PLAN_EE A
             , SCM_ADM_LOOKUP_MASTER_DETAIL B
             , SSP_MST_SITE_ITEM_EE_V D
         WHERE B.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
           AND B.VALID_YN = 'Y'
           AND B.SEGMENT2 = '40'
           AND B.SEGMENT1 = V_C100
           AND B.SEGMENT3 = V_A011E
           AND B.SEGMENT5 = '40'
           AND B.SEGMENT4 = V_G180
           AND B.ATTRIBUTE1 = V_G182A
           AND B.SEGMENT5 = P_DIVISION_ID
           AND B.SEGMENT4 = P_COMPANY_ID
           AND A.DIVISION_ID = B.SEGMENT2
           AND A.COMPANY_ID = B.SEGMENT1
           AND A.SCM_SITE_ID = B.SEGMENT3
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.ITEM_ID(+) = A.ITEM_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.MEASURE = 'P_SHIP_PLAN_SIMU_ETD'
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
              OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR D.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                          WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                            AND ( UPPER(D.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%'
                               OR UPPER(D.MODEL_ID_NICK_NAME) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%' )) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_CELL_TYPE) IS NULL
              OR UPPER(P_CELL_TYPE) = 'ALL'
              OR D.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
           AND ( TRIM(P_NICK_NAME) IS NULL
              OR UPPER(P_NICK_NAME) = 'ALL'
              OR D.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
           AND A.YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                 + FN_GET_SSP_ANL_SHIP_FROZEN(B.SEGMENT2, B.SEGMENT3), 'YYYYMMDD')  --  2026.10.06 AJS
                                   + (SELECT FN_GET_SSP_ANL_SHIP_FROZEN(B.SEGMENT2, B.SEGMENT3) FROM DUAL), 'YYYYMMDD')  --  2026.10.06 AJS
           AND A.YYYYMMDD <= P_PLAN_END_YYYYMMDD;

    END P_SSP0022_PSI_INTRANSIT;

    /*******************************************************************************
     * P_SSP0022_PSI_ROWDATA  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 측정값 원자료 만들기
     *     · GT_0022_ROWDATA : AS-IS #TMP_ROWDATA
     *   여섯 묶음을 이어 붙여 묶고(SUM) 대표 행 순위(RANK)를 붙인다
     *     ① 출하 지시 ETA ② 그 밖의 측정값 ③ 계획 도착 ④ 코터 후공정
     *     ⑤ 앞서 담은 출하계획 ETD ⑥ 앞서 담은 재공 도착
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_ROWDATA
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_ROWDATA;

        INSERT INTO GT_0022_ROWDATA
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL, LAST_UPDATED_BY, RN )
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.COMPANY_ID
             , IA.SCM_SITE_ID
             , IA.ELECTRODE_TYPE
             , IA.CELL_TYPE                              AS CELL_TYPE
             , IA.MODEL_ID
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.BOD_ID
             , IA.MEASURE
             , IA.YYYYMMDD
             , SUM(IA.QTY)                               AS QTY
             , SUM(IA.QTY_TO_PCM)                        AS QTY_TO_PCM
             , SUM(IA.QTY_TO_CELL)                       AS QTY_TO_CELL
             , IA.LAST_UPDATED_BY
             , RANK() OVER (PARTITION BY IA.DIVISION_ID, IA.PLANT_ID, IA.COMPANY_ID, IA.SCM_SITE_ID
                                       , IA.MODEL_ID, IA.ITEM_ID, IA.MEASURE, IA.FROM_SITE
                                       , IA.TO_SITE, IA.BOD_ID
                                ORDER BY IA.ITEM_ID DESC
                                       , IA.LAST_UPDATE_DATE) AS RN
          FROM (/* R_SHIP_REQ_ETA Measure 추가 */
                SELECT A.TO_DIVISION_ID                  AS DIVISION_ID
                     , A.TO_PLANT_ID                     AS PLANT_ID
                     , A.TO_COMPANY_ID                   AS COMPANY_ID
                     , A.TO_SITE                         AS SCM_SITE_ID
                     , NVL(B.ELECTRODE_TYPE, '-')        AS ELECTRODE_TYPE
                     , B.CELL_TYPE                       AS CELL_TYPE
                     , A.MODEL_ID
                     , A.ITEM_ID
                     , A.FROM_SITE
                     , A.TO_SITE                         AS TO_SITE
                     , A.BOD_ID
                     , 'R_SHIP_REQ_ETA'                  AS MEASURE
                     , A.ETA_DATE                        AS YYYYMMDD
                     , CAST(A.QTY AS NUMBER(30, 3))      AS QTY
                     , A.QTY_TO_PCM                      AS QTY_TO_PCM
                     , A.QTY_TO_CELL                     AS QTY_TO_CELL
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                  FROM SSP_ANL_SHIP_REQ_EE A
/*                   , SSP_MST_SITE_ITEM_EE_V B */
                     , (SELECT XA.* /* AJS 20261007 속도 */
                           FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                          WHERE XA.ITEM_ID IN (SELECT XB.ITEM_ID /* AJS 20261007 속도 */
                                                 FROM GT_0022_PLAN_ITEM_CUTOFF XB)) B /* AJS 20261007 속도 */
                     , GT_0022_PLAN_ITEM_CUTOFF C
                 WHERE A.FROM_DIVISION_ID = B.DIVISION_ID(+)
                   AND A.FROM_SITE = B.SCM_SITE_ID(+)
                   AND A.ITEM_ID = B.ITEM_ID(+)
                   AND A.TO_DIVISION_ID = C.DIVISION_ID
                   AND A.TO_SITE = C.SCM_SITE_ID
                   AND A.ITEM_ID = C.ITEM_ID
                   AND A.TO_DIVISION_ID = P_DIVISION_ID
                   AND A.TO_COMPANY_ID = P_COMPANY_ID
                   AND A.ETA_DATE >= P_FROM_YYYYMMDD
                   AND A.ETA_DATE <= P_TO_YYYYMMDD
                   AND A.QTY > 0
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'                               /* 조회조건 ALL 은 조건 없음 */
                      OR A.TO_PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                             FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
                      OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                          FROM SCP_MST_FINAL_ITEM XY
                                         WHERE EXISTS (SELECT 1
                                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                       WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                         AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR B.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR B.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
                UNION ALL
                /* 그 밖의 측정값 */
/*              SELECT A.DIVISION_ID */
                SELECT /*+ LEADING(A) USE_HASH(B D) */ A.DIVISION_ID    /* AJS 20261007 속도 */
                     , A.PLANT_ID                        AS PLANT_ID
                     , A.COMPANY_ID                      AS COMPANY_ID
                     , A.SCM_SITE_ID                     AS SCM_SITE_ID
                     , NVL(A.ELECTRODE_TYPE, '-')        AS ELECTRODE_TYPE
                     , C.CELL_TYPE                       AS CELL_TYPE
                     , A.MODEL_ID                        AS MODEL_ID
                     , A.ITEM_ID                         AS ITEM_ID
                     , NVL(A.FROM_SITE, '-')             AS FROM_SITE
                     , NVL(A.TO_SITE, '-')               AS TO_SITE
                     , NVL(A.BOD_ID, '-')                AS BOD_ID
                     , A.MEASURE                         AS MEASURE
                     , A.YYYYMMDD                        AS YYYYMMDD
                     , CAST(A.QTY AS NUMBER(30, 3))      AS QTY
                     , A.QTY_TO_PCM                      AS QTY_TO_PCM
                     , A.QTY_TO_CELL                     AS QTY_TO_CELL
                     , '-'                               AS LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                  FROM SSP_ANL_SHIP_PLAN_EE A
                     , SCM_ADM_LOOKUP_MASTER_DETAIL B
/*                   , SSP_MST_SITE_ITEM_EE_V C */
                     , (SELECT XA.* /* AJS 20261007 속도 */
                           FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                          WHERE (XA.DIVISION_ID, XA.ITEM_ID) IN (SELECT XB.DIVISION_ID /* AJS 20261007 속도 */
                                                                     , XB.ITEM_ID /* AJS 20261007 속도 */
                                                                  FROM GT_0022_PLAN_ITEM_CUTOFF XB)) C /* AJS 20261007 속도 */
                     , GT_0022_PLAN_ITEM_CUTOFF D
                 WHERE B.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
                   AND B.SEGMENT5 = A.DIVISION_ID
                   AND B.ATTRIBUTE1 = A.SCM_SITE_ID
                   AND A.DIVISION_ID = C.DIVISION_ID(+)
                   AND A.ITEM_ID = C.ITEM_ID(+)
                   AND B.SEGMENT3 = C.SCM_SITE_ID(+)
                   AND A.DIVISION_ID = D.DIVISION_ID
                   AND A.SCM_SITE_ID = D.SCM_SITE_ID
                   AND A.ITEM_ID = D.ITEM_ID
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.COMPANY_ID = P_COMPANY_ID
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.MEASURE NOT IN ('R_SHIP_REQ_ETA', 'R_SHIP_PLAN_ETD', 'R_SCP_SHIP_PLAN_ETA'
                                       , 'R_INV_SHIP_REQ', 'R_INV_SHIP_PLAN', 'R_INTRANSIT_ETA'
                                       , 'R_FP_COATER_POST_PLAN')
                   AND A.MEASURE_TYPE = 'R'
                   AND ( A.FROM_SITE = '-' AND A.TO_SITE = '-' )
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'
                      OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                          FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
                      OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                          FROM SCP_MST_FINAL_ITEM XY
                                         WHERE EXISTS (SELECT 1
                                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                       WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                         AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR C.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR C.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
                UNION ALL
                /* R_SCP_SHIP_PLAN_ETA */
                SELECT A.DIVISION_ID
                     , A.PLANT_ID                        AS PLANT_ID
                     , A.COMPANY_ID                      AS COMPANY_ID
                     , A.SCM_SITE_ID                     AS SCM_SITE_ID
                     , NVL(A.ELECTRODE_TYPE, '-')        AS ELECTRODE_TYPE
                     , B.CELL_TYPE                       AS CELL_TYPE
                     , A.MODEL_ID                        AS MODEL_ID
                     , A.ITEM_ID                         AS ITEM_ID
                     , NVL(A.FROM_SITE, '-')             AS FROM_SITE
                     , NVL(A.TO_SITE, '-')               AS TO_SITE
                     , NVL(A.BOD_ID, '-')                AS BOD_ID
                     , A.MEASURE                         AS MEASURE
                     , A.YYYYMMDD                        AS YYYYMMDD
                     , CAST(A.QTY AS NUMBER(30, 3))      AS QTY
                     , A.QTY_TO_PCM                      AS QTY_TO_PCM
                     , A.QTY_TO_CELL                     AS QTY_TO_CELL
                     , '-'                               AS LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                  FROM SSP_ANL_SHIP_PLAN_EE A
/*                   , SSP_MST_SITE_ITEM_EE_V B */
                     , (SELECT XA.* /* AJS 20261007 속도 */
                           FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                          WHERE XA.ITEM_ID IN (SELECT XB.ITEM_ID /* AJS 20261007 속도 */
                                                 FROM GT_0022_PLAN_ITEM_CUTOFF XB)) B /* AJS 20261007 속도 */
                     , GT_0022_PLAN_ITEM_CUTOFF C
                 WHERE A.FROM_DIVISION_ID = B.DIVISION_ID(+)
                   AND A.ITEM_ID = B.ITEM_ID(+)
                   AND A.FROM_SITE = B.SCM_SITE_ID(+)
                   AND A.DIVISION_ID = C.DIVISION_ID
                   AND A.SCM_SITE_ID = C.SCM_SITE_ID
                   AND A.ITEM_ID = C.ITEM_ID
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.COMPANY_ID = P_COMPANY_ID
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.MEASURE IN ('R_SCP_SHIP_PLAN_ETA')
                   AND A.MEASURE_TYPE = 'R'
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'
                      OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                          FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
                      OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                          FROM SCP_MST_FINAL_ITEM XY
                                         WHERE EXISTS (SELECT 1
                                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                       WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                         AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR B.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR B.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
                UNION ALL
                /* R_FP_COATER_POST_PLAN Measure 추가
                   ETD 기준
                */
/*              SELECT A.DIVISION_ID */
                SELECT /*+ LEADING(A) USE_HASH(B D) */ A.DIVISION_ID    /* AJS 20261007 속도 */
                     , A.PLANT_ID                        AS PLANT_ID
                     , A.COMPANY_ID                      AS COMPANY_ID
                     , A.SCM_SITE_ID                     AS SCM_SITE_ID
                     , NVL(A.ELECTRODE_TYPE, '-')        AS ELECTRODE_TYPE
                     , C.CELL_TYPE                       AS CELL_TYPE
                     , A.MODEL_ID                        AS MODEL_ID
                     , A.ITEM_ID                         AS ITEM_ID
                     , NVL(A.FROM_SITE, '-')             AS FROM_SITE
                     , NVL(A.TO_SITE, '-')               AS TO_SITE
                     , NVL(A.BOD_ID, '-')                AS BOD_ID
                     , A.MEASURE                         AS MEASURE
                     , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD')
                             + NVL(TO_NUMBER(C.ELECTRODE_POST_OPER_LT), 0), 'YYYYMMDD') AS YYYYMMDD
                     , CAST(A.QTY AS NUMBER(30, 3))      AS QTY
                     , A.QTY_TO_PCM                      AS QTY_TO_PCM
                     , A.QTY_TO_CELL                     AS QTY_TO_CELL
                     , '-'                               AS LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                  FROM SSP_ANL_SHIP_PLAN_EE A
                     , SCM_ADM_LOOKUP_MASTER_DETAIL B
/*                   , SSP_MST_SITE_ITEM_EE_V C */
                     , (SELECT XA.* /* AJS 20261007 속도 */
                           FROM SSP_MST_SITE_ITEM_EE_V XA /* AJS 20261007 속도 */
                          WHERE (XA.DIVISION_ID, XA.ITEM_ID) IN (SELECT XB.DIVISION_ID /* AJS 20261007 속도 */
                                                                     , XB.ITEM_ID /* AJS 20261007 속도 */
                                                                  FROM GT_0022_PLAN_ITEM_CUTOFF XB)) C /* AJS 20261007 속도 */
                     , GT_0022_PLAN_ITEM_CUTOFF D
                 WHERE B.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
                   AND B.SEGMENT5 = A.DIVISION_ID
                   AND B.ATTRIBUTE1 = A.SCM_SITE_ID
                   AND A.DIVISION_ID = C.DIVISION_ID(+)
                   AND A.ITEM_ID = C.ITEM_ID(+)
                   AND B.SEGMENT3 = C.SCM_SITE_ID(+)
                   AND A.DIVISION_ID = D.DIVISION_ID
                   AND A.SCM_SITE_ID = D.SCM_SITE_ID
                   AND A.ITEM_ID = D.ITEM_ID
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.COMPANY_ID = P_COMPANY_ID
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.MEASURE IN ('R_FP_COATER_POST_PLAN')
                   AND A.MEASURE_TYPE = 'R'
                   AND ( A.FROM_SITE = '-' AND A.TO_SITE = '-' )
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'
                      OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                          FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
                      OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                          FROM SCP_MST_FINAL_ITEM XY
                                         WHERE EXISTS (SELECT 1
                                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                       WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                         AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR C.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR C.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
                UNION ALL
                /* R_SHIP_PLAN_ETD Measure 추가
                   ETD 기준
                */
                SELECT DIVISION_ID
                     , PLANT_ID
                     , COMPANY_ID
                     , SCM_SITE_ID
                     , ELECTRODE_TYPE
                     , CELL_TYPE
                     , MODEL_ID
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , BOD_ID
                     , MEASURE
                     , YYYYMMDD
                     , CAST(QTY AS NUMBER(30, 3))        AS QTY
                     , QTY_TO_PCM
                     , QTY_TO_CELL
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                  FROM GT_0022_SHIP_PLAN_ETD
                UNION ALL
                /* R_INTRANSIT_ETA Measure 추가
                   ETA 기준
                */
                SELECT DIVISION_ID
                     , PLANT_ID
                     , COMPANY_ID
                     , SCM_SITE_ID
                     , ELECTRODE_TYPE
                     , CELL_TYPE
                     , MODEL_ID
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , BOD_ID
                     , MEASURE
                     , YYYYMMDD
                     , CAST(QTY AS NUMBER(30, 3))        AS QTY
                     , QTY_TO_PCM
                     , QTY_TO_CELL
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                  FROM GT_0022_INTRANSIT_ETA) IA
         GROUP BY IA.DIVISION_ID
                , IA.PLANT_ID
                , IA.COMPANY_ID
                , IA.SCM_SITE_ID
                , IA.ELECTRODE_TYPE
                , IA.CELL_TYPE
                , IA.MODEL_ID
                , IA.ITEM_ID
                , IA.FROM_SITE
                , IA.TO_SITE
                , IA.BOD_ID
                , IA.MEASURE
                , IA.YYYYMMDD
                , IA.LAST_UPDATED_BY
                , IA.LAST_UPDATE_DATE;

    END P_SSP0022_PSI_ROWDATA;

    /*******************************************************************************
     * P_SSP0022_PSI_INV_REQ  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 [R_INV_SHIP_REQ] Inventory(Ship Req) 계산
     *     · GT_0022_INV_REQ 에 네 측정값만 담고, 셈한 결과를 GT_0022_ROWDATA 에 더한다
     *
     * R_INV_SHIP_REQ(당일) = BOH - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일)
     * R_INV_SHIP_REQ(익일) = R_INV_SHIP_REQ(전일) + C_FP_COATER_PLAN(전일)
     *                        - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일)
     *
     * 전환 기준
     *   1. AS-IS 의 WITH 두 개(R_INV_SHIP_REQ · Z)는 각각 한 번만 읽으므로 인라인 뷰로 옮긴다.
     *   2. ★AS-IS 의 누적 합 서브질의는 **품목만으로** 짝을 맞춘다 —
     *      회사·사업부·공장·사이트·모델 조건이 원문에 모두 주석 처리되어 있다. 원문 그대로 둔다.
     *   3. Z 는 원자료의 열쇠와 계획구간 달력을 곱해 만든다(원문의 조건 없는 바깥 조인).
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_INV_REQ
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_END_YYYYMMDD     IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_INV_REQ;

        INSERT INTO GT_0022_INV_REQ
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL, LAST_UPDATED_BY, RN )
        SELECT DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL, LAST_UPDATED_BY, RN
          FROM GT_0022_ROWDATA
         WHERE MEASURE IN ('R_FP_COATER_PLAN', 'R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA');

        INSERT INTO GT_0022_ROWDATA
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.COMPANY_ID
             , A.SCM_SITE_ID
             , A.ELECTRODE_TYPE
             , A.CELL_TYPE
             , A.MODEL_ID
             , A.ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_INV_SHIP_REQ'                         AS MEASURE
             , A.YYYYMMDD
             -- 2026.10.06 AJS INV_REQ — 누적 합 하위질의를 일자별 합 조인으로 (선택 목록) (START)
--           /* R_INV_SHIP_REQ(전일) */
--           , NVL(B.QTY, 0)
--           /* + C_FP_COATER_PLAN(전일) */
--           + ( SELECT CAST(NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY, 0.000)
--                                        ELSE 0.000 END), 0.000) AS NUMBER(30, 3))
--                 FROM GT_0022_INV_REQ SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_COATER_PLAN')
--                  AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD < A.YYYYMMDD )
--           /* C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) */
--           + ( SELECT CAST(NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0.000) * -1.00
--                                        WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY, 0.000) * -1.00
--                                        WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY, 0.000)
--                                        ELSE 0.0 END), 0.00) AS NUMBER(30, 3))
--                 FROM GT_0022_INV_REQ SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA')
--                  AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD <= A.YYYYMMDD )      AS QTY
--           , NVL(B.QTY_TO_PCM, 0.000)
--           + ( SELECT CAST(NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_PCM, 0.000)
--                                        ELSE 0.0 END), 0.000) AS NUMBER(30, 3))
--                 FROM GT_0022_INV_REQ SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_COATER_PLAN')
--                  AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD < A.YYYYMMDD )
--           + ( SELECT CAST(NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) * -1.00
--                                        WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_PCM, 0) * -1.00
--                                        WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY_TO_PCM, 0)
--                                        ELSE 0.0 END), 0) AS NUMBER(30, 3))
--                 FROM GT_0022_INV_REQ SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA')
--                  AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD <= A.YYYYMMDD )      AS QTY_TO_PCM
--           , NVL(B.QTY_TO_CELL, 0)
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_CELL, 0)
--                                   ELSE 0.0 END), 0)
--                 FROM GT_0022_INV_REQ SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_COATER_PLAN')
--                  AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD < A.YYYYMMDD )
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1
--                                   WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_CELL, 0) * -1
--                                   WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY_TO_CELL, 0)
--                                   ELSE 0.0 END), 0)
--                 FROM GT_0022_INV_REQ SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA')
--                  AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD <= A.YYYYMMDD )      AS QTY_TO_CELL
             /* R_INV_SHIP_REQ(전일) */
             , NVL(B.QTY, 0)
             /* 전일까지 누적 · 당일까지 누적 — 일자별로 미리 합친 XS 에서 한 번에 더한다 */
             + CAST(NVL(SUM(CASE WHEN XS.YYYYMMDD >= P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD < A.YYYYMMDD THEN XS.C_QTY END), 0.000) AS NUMBER(30, 3))
             + CAST(NVL(SUM(CASE WHEN XS.YYYYMMDD > P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD <= A.YYYYMMDD THEN XS.D_QTY END), 0.00) AS NUMBER(30, 3))      AS QTY
             , NVL(B.QTY_TO_PCM, 0.000)
             + CAST(NVL(SUM(CASE WHEN XS.YYYYMMDD >= P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD < A.YYYYMMDD THEN XS.C_PCM END), 0.000) AS NUMBER(30, 3))
             + CAST(NVL(SUM(CASE WHEN XS.YYYYMMDD > P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD <= A.YYYYMMDD THEN XS.D_PCM END), 0) AS NUMBER(30, 3))      AS QTY_TO_PCM
             , NVL(B.QTY_TO_CELL, 0)
             + NVL(SUM(CASE WHEN XS.YYYYMMDD >= P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD < A.YYYYMMDD THEN XS.C_CELL END), 0)
             + NVL(SUM(CASE WHEN XS.YYYYMMDD > P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD <= A.YYYYMMDD THEN XS.D_CELL END), 0)      AS QTY_TO_CELL
             -- 2026.10.06 AJS INV_REQ — 누적 합 하위질의를 일자별 합 조인으로 (선택 목록) (END)
          FROM (SELECT DISTINCT IA.COMPANY_ID
                     , IA.DIVISION_ID
                     , IA.PLANT_ID
                     , IA.SCM_SITE_ID
                     , IA.ELECTRODE_TYPE
                     , IA.CELL_TYPE
                     , IA.MODEL_ID
                     , IA.ITEM_ID
                     , IB.YYYYMMDD
                  FROM GT_0022_ROWDATA IA
                     , (SELECT SB.BASIS_YYYYMMDD AS YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M SB
                         WHERE SB.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                           AND SB.BASIS_YYYYMMDD < P_PLAN_END_YYYYMMDD) IB
                 WHERE IB.YYYYMMDD(+) >= P_PLAN_START_YYYYMMDD
                   AND IB.YYYYMMDD(+) < P_PLAN_END_YYYYMMDD
                   AND IA.COMPANY_ID = P_COMPANY_ID
                   AND IA.YYYYMMDD >= P_PLAN_START_YYYYMMDD) A
             , (SELECT IC.COMPANY_ID
                     , IC.DIVISION_ID
                     , IC.PLANT_ID
                     , IC.SCM_SITE_ID
                     , IC.MODEL_ID
                     , IC.ITEM_ID
                     , CAST(SUM(IC.QTY) AS NUMBER(30, 3))   AS QTY
                     , SUM(IC.QTY_TO_PCM)                   AS QTY_TO_PCM
                     , SUM(IC.QTY_TO_CELL)                  AS QTY_TO_CELL
                  FROM (/* BOH */
                        SELECT SA.COMPANY_ID
                             , SA.DIVISION_ID
                             , SA.PLANT_ID
                             , SA.SCM_SITE_ID
                             , SA.MODEL_ID
                             , SA.ITEM_ID
                             , CAST(SA.TOT_BOH_QTY AS NUMBER(30, 3))    AS QTY
                             , SA.TOT_BOH_QTY_PCM                       AS QTY_TO_PCM
                             , SA.TOT_BOH_QTY_CELL                      AS QTY_TO_CELL
                          FROM GT_0022_BOH_CUTOFF SA
                         WHERE SA.CUTOFF_DATE = P_PLAN_START_YYYYMMDD
                           AND SA.COMPANY_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_COMPANY_ID, ',')))
                        UNION ALL
                        /* - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) */
                        SELECT SA.COMPANY_ID
                             , SA.DIVISION_ID
                             , SA.PLANT_ID
                             , SA.SCM_SITE_ID
                             , SA.MODEL_ID
                             , SA.ITEM_ID
                             , CAST(NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0.00) * -1.00
                                                 WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY, 0.00) * -1.00
                                                 WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY, 0.00)
                                                 ELSE 0.00 END), 0.00) AS NUMBER(30, 3))  AS QTY
                             , NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_PCM, 0) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY_TO_PCM, 0)
                                            ELSE 0 END), 0)                               AS QTY_TO_PCM
                             , NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1.00
                                            WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_CELL, 0) * -1.00
                                            WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY_TO_CELL, 0)
                                            ELSE 0 END), 0)                               AS QTY_TO_CELL
                          FROM GT_0022_INV_REQ SA
                         WHERE SA.YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND SA.MEASURE IN ('R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA')
                           AND SA.COMPANY_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_COMPANY_ID, ',')))
                         GROUP BY SA.COMPANY_ID
                                , SA.DIVISION_ID
                                , SA.PLANT_ID
                                , SA.SCM_SITE_ID
                                , SA.MODEL_ID
                                , SA.ITEM_ID) IC
                 GROUP BY IC.COMPANY_ID
                        , IC.DIVISION_ID
                        , IC.PLANT_ID
                        , IC.SCM_SITE_ID
                        , IC.MODEL_ID
                        -- 2026.10.06 AJS INV_REQ — 일자별 합 인라인 뷰 추가 (START)
--                      , IC.ITEM_ID) B
                        , IC.ITEM_ID) B
             , (SELECT SA.ITEM_ID
                     , SA.YYYYMMDD
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY, 0) ELSE 0 END)          AS C_QTY
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) ELSE 0 END)   AS C_PCM
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) ELSE 0 END)  AS C_CELL
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD' THEN NVL(SA.QTY, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_REQ_ETA' THEN NVL(SA.QTY, 0) ELSE 0 END)  AS D_QTY
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD' THEN NVL(SA.QTY_TO_PCM, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_REQ_ETA' THEN NVL(SA.QTY_TO_PCM, 0) ELSE 0 END)  AS D_PCM
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD' THEN NVL(SA.QTY_TO_CELL, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_REQ_ETA' THEN NVL(SA.QTY_TO_CELL, 0) ELSE 0 END)  AS D_CELL
                  FROM GT_0022_INV_REQ SA
                 WHERE SA.MEASURE IN ('R_FP_COATER_PLAN', 'R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA')
                 GROUP BY SA.ITEM_ID
                        , SA.YYYYMMDD) XS
                        -- 2026.10.06 AJS INV_REQ — 일자별 합 인라인 뷰 추가 (END)
         WHERE B.COMPANY_ID(+) = A.COMPANY_ID
           AND B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.PLANT_ID(+) = A.PLANT_ID
           AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND B.ITEM_ID(+) = A.ITEM_ID
           -- 2026.10.06 AJS INV_REQ — 일자별 합 조인 · 묶음 (START)
--         AND B.MODEL_ID(+) = A.MODEL_ID;
           AND B.MODEL_ID(+) = A.MODEL_ID
           AND XS.ITEM_ID(+) = A.ITEM_ID
           AND XS.YYYYMMDD(+) >= P_PLAN_START_YYYYMMDD
           AND XS.YYYYMMDD(+) <= A.YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.PLANT_ID
                , A.COMPANY_ID
                , A.SCM_SITE_ID
                , A.ELECTRODE_TYPE
                , A.CELL_TYPE
                , A.MODEL_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , B.QTY
                , B.QTY_TO_PCM
                , B.QTY_TO_CELL;
           -- 2026.10.06 AJS INV_REQ — 일자별 합 조인 · 묶음 (END)

    END P_SSP0022_PSI_INV_REQ;

    /*******************************************************************************
     * P_SSP0022_PSI_INV_PLAN  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 [R_INV_SHIP_PLAN] Inventory(Ship Plan) 계산
     *
     * R_INV_SHIP_PLAN(당일) = BOH + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일)
     *                        - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일)
     * R_INV_SHIP_PLAN(익일) = R_INV_SHIP_PLAN(전일) + C_FP_COATER_PLAN(전일)
     *                        + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일)
     *
     * 전환 기준 — 지시 기준(P_SSP0022_PSI_INV_REQ)과 갈리는 곳
     *   1. 담는 측정값에 재공 도착(`R_INTRANSIT_ETA`)이 더 들어간다(다섯 가지).
     *   2. 마감 기초재고를 읽을 때 `MEASURE_TYPE = 'R'` 조건이 더 걸린다.
     *   3. ★날짜 묶음(Z)이 **원자료의 날짜**를 쓴다(지시 기준은 달력 날짜를 쓴다).
     *   4. 누적 합에 출하 지시 도착(`R_SHIP_REQ_ETA`)이 들어가지 않는다.
     *   5. ★★AS-IS 의 당일 항에서 재공 도착만 **환산 전 수량(QTY)**을 더한다 —
     *      PCM·CELL 환산 재고에 원단위 수량이 섞인다. 원문 그대로 두고 보고서에 올린다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_INV_PLAN
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_END_YYYYMMDD     IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_PLAN_INV;

        /* START E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
        INSERT INTO GT_0022_PLAN_INV
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL )
        SELECT DIVISION_ID
             , PLANT_ID
             , COMPANY_ID
             , SCM_SITE_ID
             , ELECTRODE_TYPE
             , CELL_TYPE
             , MODEL_ID
             , ITEM_ID
             , FROM_SITE
             , TO_SITE
             , BOD_ID
             , MEASURE
             , YYYYMMDD
             , CAST(QTY AS NUMBER(30, 3))                AS QTY
             , QTY_TO_PCM
             , QTY_TO_CELL
          FROM GT_0022_ROWDATA
         WHERE MEASURE IN ('R_FP_COATER_PLAN', 'R_FP_NPC_ASSY_PLAN', 'R_INTRANSIT_ETA'
                         , 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA');
        /* END E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */

        INSERT INTO GT_0022_ROWDATA
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.COMPANY_ID
             , A.SCM_SITE_ID
             , A.ELECTRODE_TYPE
             , A.CELL_TYPE
             , A.MODEL_ID
             , A.ITEM_ID
             , '-'                                      AS FROM_SITE
             , '-'                                      AS TO_SITE
             , '-'                                      AS BOD_ID
             , 'R_INV_SHIP_PLAN'                        AS MEASURE
             , A.YYYYMMDD
             -- 2026.10.06 AJS INV_PLAN — 누적 합 하위질의를 일자별 합 조인으로 (선택 목록) (START)
--           /* R_INV_SHIP_PLAN(전일) */
--           , NVL(B.QTY, 0.00)
--           /* + C_FP_COATER_PLAN(전일) */
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY, 0.00)
--                                   ELSE 0.00 END), 0.00)
--                 FROM GT_0022_PLAN_INV SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_COATER_PLAN')
--                  AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD < A.YYYYMMDD )
--           /* + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) */
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA'    THEN NVL(SA.QTY, 0.00)
--                                   WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0.00) * -1
--                                   WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY, 0.00) * -1
--                                   ELSE 0.0 END), 0.00)
--                 FROM GT_0022_PLAN_INV SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_INTRANSIT_ETA', 'R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD')
--                  AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD <= A.YYYYMMDD )      AS QTY
--           , NVL(B.QTY_TO_PCM, 0)
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_PCM, 0)
--                                   ELSE 0.0 END), 0)
--                 FROM GT_0022_PLAN_INV SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_COATER_PLAN')
--                  AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD < A.YYYYMMDD )
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA'    THEN NVL(SA.QTY_TO_PCM, 0)
--                                   WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) * -1
--                                   WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_PCM, 0) * -1
--                                   ELSE 0.0 END), 0)
--                 FROM GT_0022_PLAN_INV SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_INTRANSIT_ETA', 'R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD')
--                  AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD <= A.YYYYMMDD )      AS QTY_TO_PCM
--           , NVL(B.QTY_TO_CELL, 0)
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_CELL, 0)
--                                   ELSE 0.0 END), 0)
--                 FROM GT_0022_PLAN_INV SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_FP_COATER_PLAN')
--                  AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD < A.YYYYMMDD )
--           + ( SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA'    THEN NVL(SA.QTY_TO_CELL, 0)
--                                   WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1
--                                   WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_CELL, 0) * -1
--                                   ELSE 0.0 END), 0)
--                 FROM GT_0022_PLAN_INV SA
--                WHERE SA.ITEM_ID = A.ITEM_ID
--                  AND SA.MEASURE IN ('R_INTRANSIT_ETA', 'R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD')
--                  AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
--                  AND SA.YYYYMMDD <= A.YYYYMMDD )      AS QTY_TO_CELL
             /* R_INV_SHIP_PLAN(전일) */
             , NVL(B.QTY, 0.00)
             /* 전일까지 누적 · 당일까지 누적 — 일자별로 미리 합친 XS 에서 한 번에 더한다 */
             + NVL(SUM(CASE WHEN XS.YYYYMMDD >= P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD < A.YYYYMMDD THEN XS.C_QTY END), 0.00)
             + NVL(SUM(CASE WHEN XS.YYYYMMDD > P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD <= A.YYYYMMDD THEN XS.D_QTY END), 0.00)      AS QTY
             , NVL(B.QTY_TO_PCM, 0)
             + NVL(SUM(CASE WHEN XS.YYYYMMDD >= P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD < A.YYYYMMDD THEN XS.C_PCM END), 0)
             + NVL(SUM(CASE WHEN XS.YYYYMMDD > P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD <= A.YYYYMMDD THEN XS.D_PCM END), 0)      AS QTY_TO_PCM
             , NVL(B.QTY_TO_CELL, 0)
             + NVL(SUM(CASE WHEN XS.YYYYMMDD >= P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD < A.YYYYMMDD THEN XS.C_CELL END), 0)
             + NVL(SUM(CASE WHEN XS.YYYYMMDD > P_PLAN_START_YYYYMMDD AND XS.YYYYMMDD <= A.YYYYMMDD THEN XS.D_CELL END), 0)      AS QTY_TO_CELL
             -- 2026.10.06 AJS INV_PLAN — 누적 합 하위질의를 일자별 합 조인으로 (선택 목록) (END)
          FROM (SELECT DISTINCT IA.COMPANY_ID
                     , IA.DIVISION_ID
                     , IA.PLANT_ID
                     , IA.SCM_SITE_ID
                     , IA.ELECTRODE_TYPE
                     , IA.CELL_TYPE
                     , IA.MODEL_ID
                     , IA.ITEM_ID
                     , IA.YYYYMMDD                      /* ★지시 기준과 달리 원자료의 날짜를 쓴다 */
                  FROM GT_0022_ROWDATA IA
                     , (SELECT SB.BASIS_YYYYMMDD AS YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M SB
                         WHERE SB.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                           AND SB.BASIS_YYYYMMDD < P_PLAN_END_YYYYMMDD) IB
                 WHERE IB.YYYYMMDD(+) >= P_PLAN_START_YYYYMMDD
                   AND IB.YYYYMMDD(+) < P_PLAN_END_YYYYMMDD
                   AND IA.COMPANY_ID = P_COMPANY_ID
                   AND IA.YYYYMMDD >= P_PLAN_START_YYYYMMDD) A
             , (SELECT IC.COMPANY_ID
                     , IC.DIVISION_ID
                     , IC.PLANT_ID
                     , IC.SCM_SITE_ID
                     , IC.MODEL_ID
                     , IC.ITEM_ID
                     , SUM(IC.QTY)                          AS QTY
                     , SUM(IC.QTY_TO_PCM)                   AS QTY_TO_PCM
                     , SUM(IC.QTY_TO_CELL)                  AS QTY_TO_CELL
                  FROM (/* BOH */
                        SELECT SA.COMPANY_ID
                             , SA.DIVISION_ID
                             , SA.PLANT_ID
                             , SA.SCM_SITE_ID
                             , SA.MODEL_ID
                             , SA.ITEM_ID
                             , SA.TOT_BOH_QTY                           AS QTY
                             , SA.TOT_BOH_QTY_PCM                       AS QTY_TO_PCM
                             , SA.TOT_BOH_QTY_CELL                      AS QTY_TO_CELL
                          FROM GT_0022_BOH_CUTOFF SA
                         WHERE SA.MEASURE_TYPE = 'R'
                           AND SA.CUTOFF_DATE = P_PLAN_START_YYYYMMDD
                           AND SA.COMPANY_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_COMPANY_ID, ',')))
                        UNION ALL
                        /* + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) */
                        SELECT SA.COMPANY_ID
                             , SA.DIVISION_ID
                             , SA.PLANT_ID
                             , SA.SCM_SITE_ID
                             , SA.MODEL_ID
                             , SA.ITEM_ID
                             , NVL(SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA'    THEN NVL(SA.QTY, 0.00)
                                            WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0.00) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY, 0.00) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY, 0.00)
                                            ELSE 0.00 END), 0.00)                     AS QTY
                             /* ★AS-IS 는 재공 도착만 환산 전 수량(QTY)을 더한다 — 원문 그대로 둔다 */
                             , NVL(SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA'    THEN NVL(SA.QTY, 0.00)
                                            WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0.00) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_PCM, 0.00) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY_TO_PCM, 0.00)
                                            ELSE 0.00 END), 0)                        AS QTY_TO_PCM
                             /* ★같은 자리 — 환산 전 수량(QTY) */
                             , NVL(SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA'    THEN NVL(SA.QTY, 0)
                                            WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD'    THEN NVL(SA.QTY_TO_CELL, 0) * -1
                                            WHEN SA.MEASURE = 'R_SHIP_REQ_ETA'     THEN NVL(SA.QTY_TO_CELL, 0)
                                            ELSE 0 END), 0)                           AS QTY_TO_CELL
                          FROM GT_0022_PLAN_INV SA
                         WHERE SA.YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND SA.MEASURE IN ('R_INTRANSIT_ETA', 'R_FP_NPC_ASSY_PLAN'
                                            , 'R_SHIP_PLAN_ETD', 'R_SHIP_REQ_ETA')
                           AND SA.COMPANY_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_COMPANY_ID, ',')))
                         GROUP BY SA.COMPANY_ID
                                , SA.DIVISION_ID
                                , SA.PLANT_ID
                                , SA.SCM_SITE_ID
                                , SA.MODEL_ID
                                , SA.ITEM_ID) IC
                 GROUP BY IC.COMPANY_ID
                        , IC.DIVISION_ID
                        , IC.PLANT_ID
                        , IC.SCM_SITE_ID
                        , IC.MODEL_ID
                        -- 2026.10.06 AJS INV_PLAN — 일자별 합 인라인 뷰 추가 (START)
--                      , IC.ITEM_ID) B
                        , IC.ITEM_ID) B
             , (SELECT SA.ITEM_ID
                     , SA.YYYYMMDD
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY, 0) ELSE 0 END)          AS C_QTY
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) ELSE 0 END)   AS C_PCM
                     , SUM(CASE WHEN SA.MEASURE = 'R_FP_COATER_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) ELSE 0 END)  AS C_CELL
                     , SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA' THEN NVL(SA.QTY, 0) WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD' THEN NVL(SA.QTY, 0) * -1 ELSE 0 END)  AS D_QTY
                     , SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA' THEN NVL(SA.QTY_TO_PCM, 0) WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD' THEN NVL(SA.QTY_TO_PCM, 0) * -1 ELSE 0 END)  AS D_PCM
                     , SUM(CASE WHEN SA.MEASURE = 'R_INTRANSIT_ETA' THEN NVL(SA.QTY_TO_CELL, 0) WHEN SA.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1 WHEN SA.MEASURE = 'R_SHIP_PLAN_ETD' THEN NVL(SA.QTY_TO_CELL, 0) * -1 ELSE 0 END)  AS D_CELL
                  FROM GT_0022_PLAN_INV SA
                 WHERE SA.MEASURE IN ('R_FP_COATER_PLAN', 'R_INTRANSIT_ETA', 'R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD')
                 GROUP BY SA.ITEM_ID
                        , SA.YYYYMMDD) XS
                        -- 2026.10.06 AJS INV_PLAN — 일자별 합 인라인 뷰 추가 (END)
         WHERE B.COMPANY_ID(+) = A.COMPANY_ID
           AND B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.PLANT_ID(+) = A.PLANT_ID
           AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND B.MODEL_ID(+) = A.MODEL_ID
           -- 2026.10.06 AJS INV_PLAN — 일자별 합 조인 · 묶음 (START)
--         AND B.ITEM_ID(+) = A.ITEM_ID;
           AND B.ITEM_ID(+) = A.ITEM_ID
           AND XS.ITEM_ID(+) = A.ITEM_ID
           AND XS.YYYYMMDD(+) >= P_PLAN_START_YYYYMMDD
           AND XS.YYYYMMDD(+) <= A.YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.PLANT_ID
                , A.COMPANY_ID
                , A.SCM_SITE_ID
                , A.ELECTRODE_TYPE
                , A.CELL_TYPE
                , A.MODEL_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , B.QTY
                , B.QTY_TO_PCM
                , B.QTY_TO_CELL;
           -- 2026.10.06 AJS INV_PLAN — 일자별 합 조인 · 묶음 (END)

    END P_SSP0022_PSI_INV_PLAN;

    /*******************************************************************************
     * P_SSP0022_PSI_RESULT  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 결과·요청자·피벗 입력 만들기
     *     · GT_0022_RESULT    : AS-IS #TMP_RESULT_TABLE
     *     · GT_0022_REQUESTOR : AS-IS #TblDynamic_REQUESTOR
     *     · GT_0022_PIVOT     : AS-IS #TMP_RESULT_PIVOT_TABLE
     *
     * 전환 기준
     *   1. 측정값 목록(화면 칸)과 원자료를 곱해 빈 칸까지 자리를 만든 뒤 값을 붙인다.
     *   2. 확정일은 순번 3 인 측정값만 셈하고 나머지는 0 이다.
     *   3. 기초재고는 순번 1·2·3 인 측정값에서 값 없음으로 둔다.
     *   4. ★AS-IS 가 개인별 머리글에 바깥 조인을 걸어 두었으나 그 칸을 하나도 쓰지 않는다
     *      (DISTINCT 로 다시 접혀 결과가 달라지지 않는다). 원문 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_RESULT
    (
        P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_RESULT;
        DELETE FROM GT_0022_REQUESTOR;
        DELETE FROM GT_0022_PIVOT;

        INSERT INTO GT_0022_RESULT
             ( DIVISION_ID, ORIGIN_DIVISION_ID, PLANT_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, BOD_LT, OP_LT
             , TRANSPORT_MODE, INCOTERMS, MEASURE, SEQ, YYYYMMDD, CONFIRM_DAY
             , QTY, QTY_TO_PCM, QTY_TO_CELL
             , TOT_BOH_QTY, JR_BOH_QTY, PC_BOH_QTY
             , TOT_BOH_QTY_PCM, JR_BOH_QTY_PCM, PC_BOH_QTY_PCM
             , TOT_BOH_QTY_CELL, JR_BOH_QTY_CELL, PC_BOH_QTY_CELL )
        SELECT A.DIVISION_ID
             , A.ORIGIN_DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.ELECTRODE_TYPE
             , A.CELL_TYPE
             , A.MODEL_ID
             , A.ITEM_ID
             , A.FROM_SITE                              AS FROM_SITE
             , A.TO_SITE                                AS TO_SITE
             , A.BOD_ID
             , CASE WHEN (A.SEQ = 2 OR A.SEQ = 3) THEN TO_CHAR(A.LT_TOTAL_ORIGIN)
                    ELSE '-' END                        AS BOD_LT
             , NVL(A.OP_LT, '-')                        AS OP_LT
             , A.TRANSPORT_MODE                         AS TRANSPORT_MODE
             , A.INCOTERMS                              AS INCOTERMS
             , A.MEASURE
             , A.SEQ
             , A.YYYYMMDD
             /* 확정구간 과 Oper LT 중 큰 일수 + bod LT 기간 이후 부터 입력 가능하게 적용
                bod LT 는 FN_GET_SSP_ETA_DATE 함수 사용 */
             , CASE WHEN (A.SEQ = 3)
                    THEN CASE WHEN NVL(TO_NUMBER(A.OP_LT), 0) >= NVL(A.SHIP_FROZEN, 0)
                              -- 2026.10.06 AJS ETA 일자 함수 캐시 (START)
--                            THEN TO_DATE(FN_GET_SSP_ETA_DATE(A.ORIGIN_DIVISION_ID, A.BOD_ID,
--                                         TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                               + (NVL(TO_NUMBER(A.OP_LT), 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
--                               - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                            ELSE TO_DATE(FN_GET_SSP_ETA_DATE(A.ORIGIN_DIVISION_ID, A.BOD_ID,
--                                         TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                               + (NVL(A.SHIP_FROZEN, 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                              THEN TO_DATE((SELECT FN_GET_SSP_ETA_DATE(A.ORIGIN_DIVISION_ID, A.BOD_ID,
                                                   TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                         + (NVL(TO_NUMBER(A.OP_LT), 0) + 0), 'YYYYMMDD'))
                                              FROM DUAL), 'YYYYMMDD')
                                 - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                              ELSE TO_DATE((SELECT FN_GET_SSP_ETA_DATE(A.ORIGIN_DIVISION_ID, A.BOD_ID,
                                                   TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                         + (NVL(A.SHIP_FROZEN, 0) + 0), 'YYYYMMDD'))
                                              FROM DUAL), 'YYYYMMDD')
                              -- 2026.10.06 AJS ETA 일자 함수 캐시 (END)
                                 - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                          END
                    ELSE 0 END                          AS CONFIRM_DAY
             , NVL(A.QTY, 0.00)                         AS QTY
             , NVL(A.QTY_TO_PCM, 0)                     AS QTY_TO_PCM
             , NVL(A.QTY_TO_CELL, 0)                    AS QTY_TO_CELL
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.TOT_BOH_QTY, 0) END      AS TOT_BOH_QTY
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.JR_BOH_QTY, 0) END       AS JR_BOH_QTY
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.PC_BOH_QTY, 0) END       AS PC_BOH_QTY
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.TOT_BOH_QTY_PCM, 0) END  AS TOT_BOH_QTY_PCM
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.JR_BOH_QTY_PCM, 0) END   AS JR_BOH_QTY_PCM
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.PC_BOH_QTY_PCM, 0) END   AS PC_BOH_QTY_PCM
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.TOT_BOH_QTY_CELL, 0) END AS TOT_BOH_QTY_CELL
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.JR_BOH_QTY_CELL, 0) END  AS JR_BOH_QTY_CELL
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.PC_BOH_QTY_CELL, 0) END  AS PC_BOH_QTY_CELL
--        FROM (SELECT DISTINCT IA.DIVISION_ID  --  2026.10.06 AJS
          FROM (SELECT /*+ NO_PUSH_PRED(IG) USE_HASH(IG) */ DISTINCT IA.DIVISION_ID  --  2026.10.06 AJS
                     , IG.DIVISION_ID                   AS ORIGIN_DIVISION_ID
                     , IA.PLANT_ID
                     , IA.SCM_SITE_ID
                     , IA.ELECTRODE_TYPE
                     , IA.CELL_TYPE
                     , IA.MODEL_ID
                     , IA.ITEM_ID
                     , IB.FROM_SITE
                     , IB.TO_SITE
                     , IB.BOD_ID
                     , IA.MEASURE
                     , IA.SEQ
                     , IB.YYYYMMDD
                     , IB.QTY
                     , IB.QTY_TO_PCM
                     , IB.QTY_TO_CELL
                     , IH.TOT_BOH_QTY
                     , IH.JR_BOH_QTY
                     , IH.PC_BOH_QTY
                     , IH.TOT_BOH_QTY_PCM
                     , IH.JR_BOH_QTY_PCM
                     , IH.PC_BOH_QTY_PCM
                     , IH.TOT_BOH_QTY_CELL
                     , IH.JR_BOH_QTY_CELL
                     , IH.PC_BOH_QTY_CELL
                     , IG.LT_TOTAL_ORIGIN
                     , IJ.SEGMENT5                      AS OP_LT
                     , IG.TRANSPORT_MODE
                     , IG.SSP_INCOTERMS                 AS INCOTERMS
                     , IC.SHIP_FROZEN
                  FROM (SELECT DISTINCT XA.DIVISION_ID
                             , XA.PLANT_ID
                             , XA.SCM_SITE_ID
                             , XA.ELECTRODE_TYPE
                             , XA.CELL_TYPE
                             , XA.MODEL_ID
                             , XA.ITEM_ID
                             , XB.COLUMN_NAME           AS MEASURE
                             , XB.COLUMN_LABEL_NAME     AS MEASURE_NAME
                             , XB.ATTRIBUTE3            AS BACK_COLOR
                             , XB.SORT_ORDER_NO         AS SEQ
                             , XA.YYYYMMDD
                          FROM GT_0022_ROWDATA XA
                             , SCM_MST_SHEET_MEASURE XB
                             , SCM_MST_TITLESET_USER XC   /* ★칸을 쓰지 않는 바깥 조인 — 원문 그대로 */
                         WHERE XB.PROGRAM_ID = P_PROGRAM_ID
                           AND XB.SHEET_NAME = P_SHEET_NAME
                           AND XC.PROGRAM_ID(+) = XB.PROGRAM_ID
                           AND XC.SHEET_NAME(+) = XB.SHEET_NAME
                           AND XC.COLUMN_NAME(+) = XB.COLUMN_NAME
                           AND XC.USER_ID(+) = P_USER_ID) IA
                     , GT_0022_ROWDATA IB
                     , SCM_MST_SITE IC
                     , SCM_ADM_LOOKUP_MASTER_DETAIL ID
                     , SSP_MST_SHIP_MASTER_EE IE
                     , SCM_ADM_LOOKUP_MASTER_DETAIL IJ
                     , SCP_MST_BOD_N_V IG
                     , GT_0022_BOH_CUTOFF IH
                 WHERE IB.DIVISION_ID(+) = IA.DIVISION_ID
                   AND IB.PLANT_ID(+) = IA.PLANT_ID
                   AND IB.SCM_SITE_ID(+) = IA.SCM_SITE_ID
                   AND IB.MODEL_ID(+) = IA.MODEL_ID
                   AND IB.ITEM_ID(+) = IA.ITEM_ID
                   AND IB.MEASURE(+) = IA.MEASURE
                   AND IB.YYYYMMDD(+) = IA.YYYYMMDD
                   AND IB.FROM_SITE = IC.SCM_SITE_ID(+)
                   AND IC.SITE_TYPE(+) = 'PLANT'
                   AND IC.OPERATION_GROUP(+) = 'E'
                   AND ID.LOOKUP_TYPE(+) = 'ELECTRODE_ASSY_PLANT_MAPPING'
                   AND ID.SEGMENT1(+) = IA.DIVISION_ID
                   AND ID.SEGMENT2(+) = IA.PLANT_ID
                   AND ID.SEGMENT3 = IE.DIVISION_ID(+)
                   AND IA.ITEM_ID = IE.ITEM_ID(+)
                   AND ID.ATTRIBUTE2 = IE.SCM_SITE_ID(+)
                   AND IJ.LOOKUP_TYPE(+) = 'ELECTRODE_POST_OPER_CODE'
                   AND ID.SEGMENT3 = IJ.SEGMENT1(+)
                   AND IE.ELECTRODE_POST_OPER_CODE = IJ.SEGMENT2(+)
                   AND IJ.VALID_YN(+) = 'Y'
                   AND ID.SEGMENT3 = IG.DIVISION_ID(+)
                   AND IB.BOD_ID = IG.BOD_ID(+)
                   AND IA.DIVISION_ID = IH.DIVISION_ID(+)
                   AND IA.ITEM_ID = IH.ITEM_ID(+)
                   AND IH.MEASURE_TYPE(+) = 'R') A;

        /* 10. Requestor */
        INSERT INTO GT_0022_REQUESTOR
             ( DIVISION_ID, PLANT_ID, SCM_SITE_ID, MODEL_ID, ITEM_ID, MEASURE
             , FROM_SITE, BOD_ID, TO_SITE, LAST_UPDATED_BY )
        SELECT DIVISION_ID, PLANT_ID, SCM_SITE_ID, MODEL_ID, ITEM_ID, MEASURE
             , FROM_SITE, BOD_ID, TO_SITE, LAST_UPDATED_BY
          FROM (SELECT IA.DIVISION_ID
                     , IA.PLANT_ID
                     , IA.SCM_SITE_ID
                     , IA.MODEL_ID
                     , IA.ITEM_ID
                     , IA.MEASURE
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.LAST_UPDATED_BY
                     , IA.BOD_ID
                     , ROW_NUMBER() OVER (PARTITION BY IA.DIVISION_ID, IA.PLANT_ID, IA.SCM_SITE_ID
                                                     , IA.MODEL_ID, IA.ITEM_ID, IA.MEASURE
                                                     , IA.FROM_SITE, IA.TO_SITE, IA.BOD_ID
                                              ORDER BY IA.RN DESC) AS RN2
                  FROM GT_0022_ROWDATA IA) IB
         WHERE IB.RN2 = 1;

        /* 5. PIVOT */
        INSERT INTO GT_0022_PIVOT
             ( DIVISION_ID, ORIGIN_DIVISION_ID, PLANT_ID, SCM_SITE_ID, MODEL_ID, ITEM_ID
             , FROM_SITE, TO_SITE, BOD_ID, BOD_LT, OP_LT, TRANSPORT_MODE, INCOTERMS
             , ELECTRODE_TYPE, CELL_TYPE, MEASURE, SEQ, CONFIRM_DAY, YYYYMMDD, YYYYMM, ISO_WEEK
             , QTY, QTY_TO_PCM, QTY_TO_CELL
             , TOT_BOH_QTY, JR_BOH_QTY, PC_BOH_QTY
             , TOT_BOH_QTY_PCM, JR_BOH_QTY_PCM, PC_BOH_QTY_PCM
             , TOT_BOH_QTY_CELL, JR_BOH_QTY_CELL, PC_BOH_QTY_CELL, ROW_NUM )
        SELECT A.DIVISION_ID
             , A.ORIGIN_DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.MODEL_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.BOD_ID
             , A.BOD_LT
             , NVL(A.OP_LT, '-')                        AS OP_LT
             , NVL(A.TRANSPORT_MODE, '-')               AS TRANSPORT_MODE
             , NVL(A.INCOTERMS, '-')                    AS INCOTERMS
             , NVL(A.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , A.CELL_TYPE
             , A.MEASURE
             , A.SEQ
             , A.CONFIRM_DAY
             , CASE WHEN A.YYYYMMDD IS NULL THEN NULL          /* ★MSSQL 은 이어붙이기에 값 없음이 섞이면 전체가 값 없음이다 */
                    ELSE 'D_' || A.YYYYMMDD END          AS YYYYMMDD
             , B.BASIS_YYYYMM                           AS YYYYMM
             , SUBSTR(B.BASIS_YYYYMM, -4) || B.ISO_WEEK AS ISO_WEEK
             , A.QTY                                    AS QTY
             , A.QTY_TO_PCM                             AS QTY_TO_PCM
             , A.QTY_TO_CELL                            AS QTY_TO_CELL
             , A.TOT_BOH_QTY                            AS TOT_BOH_QTY
             , A.JR_BOH_QTY                             AS JR_BOH_QTY
             , A.PC_BOH_QTY                             AS PC_BOH_QTY
             , A.TOT_BOH_QTY_PCM                        AS TOT_BOH_QTY_PCM
             , A.JR_BOH_QTY_PCM                         AS JR_BOH_QTY_PCM
             , A.PC_BOH_QTY_PCM                         AS PC_BOH_QTY_PCM
             , A.TOT_BOH_QTY_CELL                       AS TOT_BOH_QTY_CELL
             , A.JR_BOH_QTY_CELL                        AS JR_BOH_QTY_CELL
             , A.PC_BOH_QTY_CELL                        AS PC_BOH_QTY_CELL
             , RANK() OVER (PARTITION BY A.DIVISION_ID, A.PLANT_ID, A.SCM_SITE_ID
                                       , A.MODEL_ID, A.ITEM_ID, A.MEASURE
                                ORDER BY A.MEASURE
                                       , CASE WHEN A.YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END DESC) AS ROW_NUM
          FROM GT_0022_RESULT A
             , SCM_SYS_CALENDAR_M B
         WHERE A.YYYYMMDD = B.BASIS_YYYYMMDD(+);

    END P_SSP0022_PSI_RESULT;

    /*******************************************************************************
     * P_SSP0022_PSI_ROWDATA_OLD  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 과거 기준(P_REAL_FLAG = 'N') 원자료 만들기
     *     · GT_0022_ROWDATA_OLD : AS-IS #TMP_ROWDATA_OLD
     *   과거 기준은 마감 원장(SSP_ANL_SHIP_PLAN_EE) 한 곳만 읽는다 —
     *   현재 기준처럼 출하요청·재공·계획 원장을 이어 붙이지 않는다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_ROWDATA_OLD
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_ROWDATA_OLD;

        INSERT INTO GT_0022_ROWDATA_OLD
             ( DIVISION_ID, PLANT_ID, COMPANY_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, MEASURE, YYYYMMDD
             , QTY, QTY_TO_PCM, QTY_TO_CELL )
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.COMPANY_ID
             , IA.SCM_SITE_ID
             , IA.ELECTRODE_TYPE
             , IA.CELL_TYPE
             , IA.MODEL_ID
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.BOD_ID
             , IA.MEASURE
             , IA.YYYYMMDD
             , SUM(NVL(IA.QTY, 0.00))                    AS QTY----- E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
             , SUM(NVL(IA.QTY_TO_PCM, 0))                AS QTY_TO_PCM
             , SUM(NVL(IA.QTY_TO_CELL, 0))               AS QTY_TO_CELL
          FROM (SELECT A.DIVISION_ID
                     , A.PLANT_ID                        AS PLANT_ID
                     , A.COMPANY_ID                      AS COMPANY_ID
                     , A.SCM_SITE_ID                     AS SCM_SITE_ID
                     , A.ELECTRODE_TYPE                  AS ELECTRODE_TYPE
                     , C.CELL_TYPE                       AS CELL_TYPE
                     , A.MODEL_ID                        AS MODEL_ID
                     , A.ITEM_ID                         AS ITEM_ID
                     , A.FROM_SITE                       AS FROM_SITE
                     , A.TO_SITE                         AS TO_SITE
                     , A.BOD_ID                          AS BOD_ID
                     , A.MEASURE                         AS MEASURE
                     , A.YYYYMMDD                        AS YYYYMMDD
                     , A.QTY                             AS QTY
                     , A.QTY_TO_PCM                      AS QTY_TO_PCM
                     , A.QTY_TO_CELL                     AS QTY_TO_CELL
                  FROM SSP_ANL_SHIP_PLAN_EE A
                     , SCM_ADM_LOOKUP_MASTER_DETAIL B
                     , SSP_MST_SITE_ITEM_EE_V C
                     , GT_0022_PLAN_ITEM_CUTOFF D
                 WHERE B.LOOKUP_TYPE(+) = 'ELECTRODE_ASSY_PLANT_MAPPING'
                   AND B.SEGMENT1(+) = A.DIVISION_ID
                   AND B.SEGMENT2(+) = A.PLANT_ID
                   AND A.FROM_DIVISION_ID = C.DIVISION_ID(+)
                   AND A.ITEM_ID = C.ITEM_ID(+)
                   AND B.ATTRIBUTE2 = C.SCM_SITE_ID(+)
                   AND A.DIVISION_ID = D.DIVISION_ID
                   AND A.SCM_SITE_ID = D.SCM_SITE_ID
                   AND A.ITEM_ID = D.ITEM_ID
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.COMPANY_ID = P_COMPANY_ID
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.MEASURE NOT IN ('R_SHIP_REQ_ETA', 'R_SHIP_PLAN_ETD', 'R_SCP_SHIP_PLAN_ETA')
                   AND A.MEASURE_TYPE = 'R'
                   AND (A.FROM_SITE = '-' AND A.TO_SITE = '-')
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'                               /* 조회조건 ALL 은 조건 없음 */
                      OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                          FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
                      OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                          FROM SCP_MST_FINAL_ITEM XY
                                         WHERE EXISTS (SELECT 1
                                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                       WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                         AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR C.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR C.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )
                UNION ALL
                SELECT A.DIVISION_ID
                     , A.PLANT_ID                        AS PLANT_ID
                     , A.COMPANY_ID                      AS COMPANY_ID
                     , A.SCM_SITE_ID                     AS SCM_SITE_ID
                     , A.ELECTRODE_TYPE                  AS ELECTRODE_TYPE
                     , C.CELL_TYPE                       AS CELL_TYPE
                     , A.MODEL_ID                        AS MODEL_ID
                     , A.ITEM_ID                         AS ITEM_ID
                     , CASE WHEN A.MEASURE = 'R_SHIP_PLAN_ETD' THEN '-' ELSE A.FROM_SITE END AS FROM_SITE
                     , CASE WHEN A.MEASURE = 'R_SHIP_PLAN_ETD' THEN '-' ELSE A.TO_SITE END   AS TO_SITE
                     , CASE WHEN A.MEASURE = 'R_SHIP_PLAN_ETD' THEN '-' ELSE A.BOD_ID END    AS BOD_ID
                     , A.MEASURE                         AS MEASURE
                     , A.YYYYMMDD                        AS YYYYMMDD
                     , A.QTY                             AS QTY
                     , A.QTY_TO_PCM                      AS QTY_TO_PCM
                     , A.QTY_TO_CELL                     AS QTY_TO_CELL
                  FROM SSP_ANL_SHIP_PLAN_EE A
                     , SCM_ADM_LOOKUP_MASTER_DETAIL B
                     , SSP_MST_SITE_ITEM_EE_V C
                     , GT_0022_PLAN_ITEM_CUTOFF D
                 WHERE B.LOOKUP_TYPE(+) = 'ELECTRODE_ASSY_PLANT_MAPPING'
                   AND B.SEGMENT1(+) = A.DIVISION_ID
                   AND B.SEGMENT2(+) = A.PLANT_ID
                   AND A.FROM_DIVISION_ID = C.DIVISION_ID(+)
                   AND A.ITEM_ID = C.ITEM_ID(+)
                   AND B.ATTRIBUTE2 = C.SCM_SITE_ID(+)
                   AND A.DIVISION_ID = D.DIVISION_ID
                   AND A.SCM_SITE_ID = D.SCM_SITE_ID
                   AND A.ITEM_ID = D.ITEM_ID
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.COMPANY_ID = P_COMPANY_ID
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.MEASURE IN ('R_SHIP_REQ_ETA', 'R_SCP_SHIP_PLAN_ETA', 'R_SHIP_PLAN_ETD')
                   AND A.MEASURE_TYPE = 'R'
                   AND ( TRIM(P_PLANT_ID) IS NULL
                      OR UPPER(P_PLANT_ID) = 'ALL'
                      OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                          FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
                   AND ( TRIM(P_ITEM_ID) IS NULL
                      OR UPPER(P_ITEM_ID) = 'ALL'
                      OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                         FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
                   AND ( TRIM(P_MODEL_ID) IS NULL
                      OR UPPER(P_MODEL_ID) = 'ALL'
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                    OR A.MODEL_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) )
                      OR EXISTS (SELECT 1
                                   FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SZ
                                  WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                                    AND UPPER(A.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%')
                      OR A.MODEL_ID IN (SELECT XY.ITEM_ID                                   /* 닉네임 부분일치 모델 */
                                          FROM SCP_MST_FINAL_ITEM XY
                                         WHERE EXISTS (SELECT 1
                                                        FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) XZ
                                                       WHERE TRIM(XZ.COLUMN_VALUE) IS NOT NULL
                                                         AND UPPER(XY.NICK_NAME) LIKE '%' || UPPER(TRIM(XZ.COLUMN_VALUE)) || '%')) )
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND ( TRIM(P_CELL_TYPE) IS NULL
                      OR UPPER(P_CELL_TYPE) = 'ALL'
                      OR C.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(P_CELL_TYPE, ','))) )
                   AND ( TRIM(P_NICK_NAME) IS NULL
                      OR UPPER(P_NICK_NAME) = 'ALL'
                      OR C.ITEM_ID_NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))) )) IA
         GROUP BY IA.DIVISION_ID
                , IA.PLANT_ID
                , IA.COMPANY_ID
                , IA.SCM_SITE_ID
                , IA.ELECTRODE_TYPE
                , IA.CELL_TYPE
                , IA.MODEL_ID
                , IA.ITEM_ID
                , IA.FROM_SITE
                , IA.TO_SITE
                , IA.BOD_ID
                , IA.MEASURE
                , IA.YYYYMMDD;

    END P_SSP0022_PSI_ROWDATA_OLD;

    /*******************************************************************************
     * P_SSP0022_PSI_RESULT_OLD  (패키지 안에서만 쓰는 준비 프로시저)
     *   AS-IS SSP0022_GET_SHIPMENT_PSI 의 과거 기준 결과·피벗 담기
     *     · GT_0022_RESULT_OLD : AS-IS #TMP_RESULT_TABLE_0LD
     *     · GT_0022_PIVOT_OLD  : AS-IS #TMP_RESULT_PIVOT_TABLE_OLD
     *   현재 기준과 갈리는 곳 — 확정일 계산이 「Oper LT > 출하확정일수」와 「+1 일」이다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_PSI_RESULT_OLD
    (
        P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0022_RESULT_OLD;
        DELETE FROM GT_0022_PIVOT_OLD;

        INSERT INTO GT_0022_RESULT_OLD
             ( DIVISION_ID, PLANT_ID, SCM_SITE_ID, ELECTRODE_TYPE, CELL_TYPE
             , MODEL_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID, BOD_LT, OP_LT
             , TRANSPORT_MODE, INCOTERMS, MEASURE, SEQ, YYYYMMDD, CONFIRM_DAY
             , QTY, QTY_TO_PCM, QTY_TO_CELL
             , TOT_BOH_QTY, JR_BOH_QTY, PC_BOH_QTY
             , TOT_BOH_QTY_PCM, JR_BOH_QTY_PCM, PC_BOH_QTY_PCM
             , TOT_BOH_QTY_CELL, JR_BOH_QTY_CELL, PC_BOH_QTY_CELL )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.ELECTRODE_TYPE
             , A.CELL_TYPE                              AS CELL_TYPE
             , A.MODEL_ID
             , A.ITEM_ID
             , A.FROM_SITE                              AS FROM_SITE
             , A.TO_SITE                                AS TO_SITE
             , A.BOD_ID
             , CASE WHEN (A.SEQ = 2 OR A.SEQ = 3) THEN TO_CHAR(A.LT_TOTAL_ORIGIN)
                    ELSE '-' END                        AS BOD_LT
             , NVL(A.OP_LT, '-')                        AS OP_LT
             , A.TRANSPORT_MODE                         AS TRANSPORT_MODE
             , A.INCOTERMS                              AS INCOTERMS
             , A.MEASURE
             , A.SEQ
             , A.YYYYMMDD
             /* 확정구간 과 Oper LT 중 큰 일수 + bod LT   기간 이후 부터 입력 가능하게 적용
                bod LT 는 FN_GET_SSP_ETA_DATE 함수 사용 */
             , CASE WHEN (A.SEQ = 3)
                    THEN CASE WHEN NVL(TO_NUMBER(A.OP_LT), 0) > NVL(A.SHIP_FROZEN, 0)
                              THEN TO_DATE(FN_GET_SSP_ETA_DATE(A.ORIGIN_DIVISION_ID, A.BOD_ID,
                                           TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                 + (NVL(TO_NUMBER(A.OP_LT), 0) + 1), 'YYYYMMDD')), 'YYYYMMDD')
                                 - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                              ELSE TO_DATE(FN_GET_SSP_ETA_DATE(A.ORIGIN_DIVISION_ID, A.BOD_ID,
                                           TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                 + (NVL(A.SHIP_FROZEN, 0) + 1), 'YYYYMMDD')), 'YYYYMMDD')
                                 - TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                          END
                    ELSE 0 END                          AS CONFIRM_DAY
             , NVL(A.QTY, 0.00)                         AS QTY--- E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
             , NVL(A.QTY_TO_PCM, 0)                     AS QTY_TO_PCM
             , NVL(A.QTY_TO_CELL, 0)                    AS QTY_TO_CELL
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.TOT_BOH_QTY, 0) END      AS TOT_BOH_QTY
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.JR_BOH_QTY, 0) END       AS JR_BOH_QTY
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.PC_BOH_QTY, 0) END       AS PC_BOH_QTY
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.TOT_BOH_QTY_PCM, 0) END  AS TOT_BOH_QTY_PCM
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.JR_BOH_QTY_PCM, 0) END   AS JR_BOH_QTY_PCM
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.PC_BOH_QTY_PCM, 0) END   AS PC_BOH_QTY_PCM
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.TOT_BOH_QTY_CELL, 0) END AS TOT_BOH_QTY_CELL
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.JR_BOH_QTY_CELL, 0) END  AS JR_BOH_QTY_CELL
             , CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN NULL ELSE NVL(A.PC_BOH_QTY_CELL, 0) END  AS PC_BOH_QTY_CELL
          FROM (SELECT DISTINCT IA.DIVISION_ID
                     , IG.DIVISION_ID                   AS ORIGIN_DIVISION_ID
                     , IA.PLANT_ID
                     , IA.SCM_SITE_ID
                     , IA.ELECTRODE_TYPE
                     , IA.CELL_TYPE
                     , IA.MODEL_ID
                     , IA.ITEM_ID
                     , IB.FROM_SITE
                     , IB.TO_SITE
                     , IB.BOD_ID
                     , IA.MEASURE
                     , IA.SEQ
                     , IB.YYYYMMDD
                     , IB.QTY
                     , IB.QTY_TO_PCM
                     , IB.QTY_TO_CELL
                     , IH.TOT_BOH_QTY
                     , IH.JR_BOH_QTY
                     , IH.PC_BOH_QTY
                     , IH.TOT_BOH_QTY_PCM
                     , IH.JR_BOH_QTY_PCM
                     , IH.PC_BOH_QTY_PCM
                     , IH.TOT_BOH_QTY_CELL
                     , IH.JR_BOH_QTY_CELL
                     , IH.PC_BOH_QTY_CELL
                     , IG.LT_TOTAL_ORIGIN
                     , IJ.SEGMENT5                      AS OP_LT
                     , IG.TRANSPORT_MODE
                     , IG.SSP_INCOTERMS                 AS INCOTERMS
                     , IC.SHIP_FROZEN
                  FROM (SELECT DISTINCT XA.DIVISION_ID
                             , XA.PLANT_ID
                             , XA.SCM_SITE_ID
                             , XA.ELECTRODE_TYPE
                             , XA.CELL_TYPE
                             , XA.MODEL_ID
                             , XA.ITEM_ID
                             , XB.COLUMN_NAME           AS MEASURE
                             , XB.COLUMN_LABEL_NAME     AS MEASURE_NAME
                             , XB.ATTRIBUTE3            AS BACK_COLOR
                             , XB.SORT_ORDER_NO         AS SEQ
                             , XA.YYYYMMDD
                          FROM GT_0022_ROWDATA_OLD XA
                             , SCM_MST_SHEET_MEASURE XB
                             , SCM_MST_TITLESET_USER XC   /* ★칸을 쓰지 않는 바깥 조인 — 원문 그대로 */
                         WHERE XB.PROGRAM_ID = P_PROGRAM_ID
                           AND XB.SHEET_NAME = P_SHEET_NAME
                           AND XC.PROGRAM_ID(+) = XB.PROGRAM_ID
                           AND XC.SHEET_NAME(+) = XB.SHEET_NAME
                           AND XC.COLUMN_NAME(+) = XB.COLUMN_NAME
                           AND XC.USER_ID(+) = P_USER_ID) IA
                     , GT_0022_ROWDATA_OLD IB
                     , SCM_MST_SITE IC
                     , SCM_ADM_LOOKUP_MASTER_DETAIL ID
                     , SSP_MST_SHIP_MASTER_EE IE
                     , SCM_ADM_LOOKUP_MASTER_DETAIL IJ
                     , SCP_MST_BOD_N_V IG
                     , GT_0022_BOH_CUTOFF IH
                 WHERE IB.DIVISION_ID(+) = IA.DIVISION_ID
                   AND IB.PLANT_ID(+) = IA.PLANT_ID
                   AND IB.SCM_SITE_ID(+) = IA.SCM_SITE_ID
                   AND IB.MODEL_ID(+) = IA.MODEL_ID
                   AND IB.ITEM_ID(+) = IA.ITEM_ID
                   AND IB.MEASURE(+) = IA.MEASURE
                   AND IB.YYYYMMDD(+) = IA.YYYYMMDD
                   AND IB.FROM_SITE = IC.SCM_SITE_ID(+)
                   AND IC.SITE_TYPE(+) = 'PLANT'
                   AND IC.OPERATION_GROUP(+) = 'E'
                   AND ID.LOOKUP_TYPE(+) = 'ELECTRODE_ASSY_PLANT_MAPPING'
                   AND ID.SEGMENT1(+) = IA.DIVISION_ID
                   AND ID.SEGMENT2(+) = IA.PLANT_ID
                   AND ID.SEGMENT3 = IE.DIVISION_ID(+)
                   AND IA.ITEM_ID = IE.ITEM_ID(+)
                   AND ID.ATTRIBUTE2 = IE.SCM_SITE_ID(+)
                   AND IJ.LOOKUP_TYPE(+) = 'ELECTRODE_POST_OPER_CODE'
                   AND ID.SEGMENT3 = IJ.SEGMENT1(+)
                   AND IE.ELECTRODE_POST_OPER_CODE = IJ.SEGMENT2(+)
                   AND IJ.VALID_YN(+) = 'Y'
                   AND ID.SEGMENT3 = IG.DIVISION_ID(+)
                   AND IB.BOD_ID = IG.BOD_ID(+)
                   AND IA.DIVISION_ID = IH.DIVISION_ID(+)
                   AND IA.ITEM_ID = IH.ITEM_ID(+)
                   AND IH.MEASURE_TYPE(+) = 'R') A;

        /* 5. PIVOT */
        INSERT INTO GT_0022_PIVOT_OLD
             ( DIVISION_ID, PLANT_ID, SCM_SITE_ID, MODEL_ID, ITEM_ID
             , FROM_SITE, TO_SITE, BOD_ID, BOD_LT, OP_LT, TRANSPORT_MODE, INCOTERMS
             , ELECTRODE_TYPE, CELL_TYPE, MEASURE, SEQ, CONFIRM_DAY, YYYYMMDD, YYYYMM, ISO_WEEK
             , QTY, QTY_TO_PCM, QTY_TO_CELL
             , TOT_BOH_QTY, JR_BOH_QTY, PC_BOH_QTY
             , TOT_BOH_QTY_PCM, JR_BOH_QTY_PCM, PC_BOH_QTY_PCM
             , TOT_BOH_QTY_CELL, JR_BOH_QTY_CELL, PC_BOH_QTY_CELL, ROW_NUM )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.MODEL_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.BOD_ID
             , A.BOD_LT
             , NVL(A.OP_LT, '-')                        AS OP_LT
             , NVL(A.TRANSPORT_MODE, '-')               AS TRANSPORT_MODE
             , NVL(A.INCOTERMS, '-')                    AS INCOTERMS
             , NVL(A.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
             , A.CELL_TYPE                              AS CELL_TYPE
             , A.MEASURE
             , A.SEQ
             , A.CONFIRM_DAY
             , CASE WHEN A.YYYYMMDD IS NULL THEN NULL          /* ★MSSQL 은 이어붙이기에 값 없음이 섞이면 전체가 값 없음이다 */
                    ELSE 'D_' || A.YYYYMMDD END          AS YYYYMMDD
             , B.BASIS_YYYYMM                           AS YYYYMM
             , SUBSTR(B.BASIS_YYYYMM, -4) || B.ISO_WEEK AS ISO_WEEK
             , NVL(A.QTY, 0.00)                         AS QTY--- E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
             , NVL(A.QTY_TO_PCM, 0)                     AS QTY_TO_PCM
             , NVL(A.QTY_TO_CELL, 0)                    AS QTY_TO_CELL
             , A.TOT_BOH_QTY                            AS TOT_BOH_QTY
             , A.JR_BOH_QTY                             AS JR_BOH_QTY
             , A.PC_BOH_QTY                             AS PC_BOH_QTY
             , A.TOT_BOH_QTY_PCM                        AS TOT_BOH_QTY_PCM
             , A.JR_BOH_QTY_PCM                         AS JR_BOH_QTY_PCM
             , A.PC_BOH_QTY_PCM                         AS PC_BOH_QTY_PCM
             , A.TOT_BOH_QTY_CELL                       AS TOT_BOH_QTY_CELL
             , A.JR_BOH_QTY_CELL                        AS JR_BOH_QTY_CELL
             , A.PC_BOH_QTY_CELL                        AS PC_BOH_QTY_CELL
             , RANK() OVER (PARTITION BY A.DIVISION_ID, A.PLANT_ID, A.SCM_SITE_ID
                                       , A.MODEL_ID, A.ITEM_ID, A.MEASURE
                                ORDER BY A.MEASURE
                                       , CASE WHEN A.YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END DESC) AS ROW_NUM
          FROM GT_0022_RESULT_OLD A
             , SCM_SYS_CALENDAR_M B
         WHERE A.YYYYMMDD = B.BASIS_YYYYMMDD(+);

    END P_SSP0022_PSI_RESULT_OLD;

    /*******************************************************************************
     * P_SSP0022_GET_SHIPMENT_PSI
     *   AS-IS SSP0022_GET_SHIPMENT_PSI — 화면 본표
     *
     * 전환 기준
     *   1. AS-IS 는 한 프로시저 2,380 줄이다. 담는 구간을 준비 프로시저로 나누고
     *      이 프로시저는 기준값 셈하기 · 준비 호출 · 마지막 조회만 맡는다.
     *   2. 마지막 조회는 기간에 따라 칸 수가 달라지므로 동적 SQL 로 둔다(원문도 그렇다).
     *      날짜 칸 이름은 달력에서 만들고 값은 리터럴로 박는다 — 바인드할 자리가 아니다.
     *   3. 기초재고 칸은 AS-IS 가 천 단위로 올림해 자릿점을 찍은 문자로 돌려준다.
     *      값이 0 이면 순번 1·2·3 은 빈 칸, 그 밖은 '0' 이다. 원문 그대로 옮긴다.
     *   4. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_GET_SHIPMENT_PSI
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_CELL_TYPE             IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_REAL_FLAG             IN  VARCHAR2
      , P_NON_CHK               IN  VARCHAR2
      , P_MY_MODEL_CHK          IN  VARCHAR2
      , P_DELEGATE_CHK          IN  VARCHAR2
      , P_PART_LEADER_CHK       IN  VARCHAR2
      , P_TEAM_LEADER_CHK       IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0022_GET_SHIPMENT_PSI
 * DESCRIPTION  : 전극 SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2020-04-10   KIMYONGHO      신규추가
 * 2020-07-17   kimbk          Receipt(Intransit)+Shipment Plan(In)의 Plan in 값을 Shipment Plan의 Simulation값으로 표시
 *                             Division = '40' and From Site = 'A011-E' and To Site = '' 인 정보만 적용
 *                             기존 REQ 정보에서 위 정보는 제외 처리 함
 * 2024-10-29   KHJ            NERP_SSP
 * 2025-12-11   chkim.68       E20250922-000093 출하 시 소수점 이하 3자리
 * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

        V_PLAN_END_YYYYMMDD     VARCHAR2(8 CHAR);
        V_RESULT_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
        V_ERR_MSG               VARCHAR2(4000);

        /* 기초재고 칸 한 개를 만드는 틀 — 천 단위 올림 · 자릿점 · 0 이면 빈 칸 또는 '0' */
        FUNCTION FN_BOH (P_COL IN VARCHAR2, P_NAME IN VARCHAR2) RETURN VARCHAR2
        IS
        BEGIN
            RETURN '         , CASE WHEN NVL(CEIL(A.' || P_COL || '), 0) / 1000 = 0'
                || ' THEN CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3) THEN '' '' ELSE ''0'' END'
                || ' ELSE RTRIM(TO_CHAR(NVL(CEIL(A.' || P_COL || ' / 1000) * 1000, 0), ''FM999,999,999,990.999''), ''.'')'
                || ' END AS ' || P_NAME || CHR(10);
        END FN_BOH;

    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_QRY_SUM, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID = P_USER_ID;

        /* 계획 구간 Start End 일자 (plan_start_yyyymmdd-1 ~ 8주) */
        V_PLAN_END_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD');

        /* 실적구간 Start 일자 — plan_start_yyyymmdd-1 의 전주월요일 */
        BEGIN
            SELECT A.BASIS_YYYYMMDD
              INTO V_RESULT_START_YYYYMMDD
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.ISO_YYYYWW = ( SELECT MIN(B.ISO_YYYYWW)
                                      FROM SCM_SYS_CALENDAR_M B
                                     WHERE B.BASIS_YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD')
                                       AND B.BASIS_YYYYMMDD <= P_PLAN_START_YYYYMMDD )
               AND A.DAYOFWEEK = 'MON';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_RESULT_START_YYYYMMDD := NULL;
        END;

        P_SSP0022_PSI_PRE(P_DIVISION_ID, P_COMPANY_ID, P_PLAN_START_YYYYMMDD
                        , P_ITEM_ID, P_MODEL_ID, P_USER_ID, P_NON_CHK
                        , P_MY_MODEL_CHK, P_DELEGATE_CHK, P_PART_LEADER_CHK, P_TEAM_LEADER_CHK);

        IF P_REAL_FLAG = 'Y' THEN                       /* 현재 기준 조회 */

            P_SSP0022_PSI_ETD(P_DIVISION_ID, P_COMPANY_ID, P_PLANT_ID, P_CELL_TYPE
                            , P_PLAN_START_YYYYMMDD, V_PLAN_END_YYYYMMDD, V_RESULT_START_YYYYMMDD
                            , P_MODEL_ID, P_ITEM_ID, P_NICK_NAME);

            P_SSP0022_PSI_INTRANSIT(P_DIVISION_ID, P_COMPANY_ID, P_PLANT_ID, P_CELL_TYPE
                                  , P_PLAN_START_YYYYMMDD, V_PLAN_END_YYYYMMDD
                                  , P_MODEL_ID, P_ITEM_ID, P_NICK_NAME);

            P_SSP0022_PSI_ROWDATA(P_DIVISION_ID, P_COMPANY_ID, P_PLANT_ID, P_CELL_TYPE
                                , P_PLAN_START_YYYYMMDD, P_FROM_YYYYMMDD, P_TO_YYYYMMDD
                                , P_MODEL_ID, P_ITEM_ID, P_NICK_NAME);

            P_SSP0022_PSI_INV_REQ(P_DIVISION_ID, P_COMPANY_ID, P_PLAN_START_YYYYMMDD, V_PLAN_END_YYYYMMDD);

            P_SSP0022_PSI_INV_PLAN(P_DIVISION_ID, P_COMPANY_ID, P_PLAN_START_YYYYMMDD, V_PLAN_END_YYYYMMDD);

            P_SSP0022_PSI_RESULT(P_PROGRAM_ID, P_SHEET_NAME, P_USER_ID, P_PLAN_START_YYYYMMDD);

            /* PIVOIT 대상 날짜문자열 생성 */
            FOR C IN ( SELECT IA.COL_NAME
                            , IA.KIND
                            , IA.VAL
                         FROM ( SELECT 'X_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COL_NAME
                                     , 'W' AS KIND, SUBSTR(A.BASIS_YYYYMM, -4) || A.ISO_WEEK AS VAL
                                     , 'X_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                                UNION ALL
                                SELECT 'X_M_' || A.BASIS_YYYYMM, 'M', A.BASIS_YYYYMM
                                     , 'X_' || MIN(A.BASIS_START_DATE) || '01'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                SELECT 'X_D_' || A.BASIS_YYYYMMDD, 'D', 'D_' || A.BASIS_YYYYMMDD
                                     , 'X_' || A.BASIS_YYYYMMDD || '31'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMMDD
                                UNION ALL
                                SELECT 'Y_W_' || A.BASIS_YYYYMM || A.ISO_WEEK, 'W', SUBSTR(A.BASIS_YYYYMM, -4) || A.ISO_WEEK
                                     , 'Y_' || A.BASIS_START_DATE || '21'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                                UNION ALL
                                SELECT 'Y_M_' || A.BASIS_YYYYMM, 'M', A.BASIS_YYYYMM
                                     , 'Y_' || MIN(A.BASIS_START_DATE) || '01'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                SELECT 'Y_D_' || A.BASIS_YYYYMMDD, 'D', 'D_' || A.BASIS_YYYYMMDD
                                     , 'Y_' || A.BASIS_YYYYMMDD || '31'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMMDD
                                UNION ALL
                                SELECT 'Z_W_' || A.BASIS_YYYYMM || A.ISO_WEEK, 'W', SUBSTR(A.BASIS_YYYYMM, -4) || A.ISO_WEEK
                                     , 'Z_' || A.BASIS_START_DATE || '21'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                                UNION ALL
                                SELECT 'Z_M_' || A.BASIS_YYYYMM, 'M', A.BASIS_YYYYMM
                                     , 'Z_' || MIN(A.BASIS_START_DATE) || '01'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                SELECT 'Z_D_' || A.BASIS_YYYYMMDD, 'D', 'D_' || A.BASIS_YYYYMMDD
                                     , 'Z_' || A.BASIS_YYYYMMDD || '31'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMMDD ) IA
                        ORDER BY IA.SORT_ORDER_NO )
            LOOP
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
                    ',CAST(SUM(CASE WHEN A.'
                 || CASE C.KIND WHEN 'M' THEN 'YYYYMM' WHEN 'W' THEN 'ISO_WEEK' ELSE 'YYYYMMDD' END
                 || ' = ''' || C.VAL || ''' THEN CAST(NVL(A.'
                 || CASE SUBSTR(C.COL_NAME, 1, 1) WHEN 'X' THEN 'QTY'
                                                  WHEN 'Y' THEN 'QTY_TO_CELL'
                                                  ELSE 'QTY_TO_PCM' END
                 || ', 0.00) AS NUMBER(30,3)) ELSE 0.00 END) AS NUMBER(30,3)) AS '
                 || C.COL_NAME || CHR(10)));
            END LOOP;

            /* 6. RESULT */
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT A.DIVISION_ID' || CHR(10)
             || '     , A.PLANT_ID' || CHR(10)
             || '     , NVL(A.SCM_SITE_ID, ''-'') AS SCM_SITE_ID' || CHR(10)
             || '     , A.MODEL_ID' || CHR(10)
             || '     , A.ITEM_ID' || CHR(10)
             || '     , NVL(A.FROM_SITE, ''-'') AS FROM_SITE' || CHR(10)
             || '     , NVL(A.TO_SITE, ''-'') AS TO_SITE' || CHR(10)
             || '     , NVL(A.BOD_ID, ''-'') AS BOD_ID' || CHR(10)
             || '     , NVL(A.BOD_LT, ''-'') AS BOD_LT' || CHR(10)
             || '     , A.TRANSPORT_MODE AS TRANSPORT_MODE' || CHR(10)
             || '     , A.INCOTERMS AS INCOTERMS' || CHR(10)
             || '     , A.OP_LT AS OPERATION_LT' || CHR(10)
             || '     , CASE WHEN A.ORIGIN_DIVISION_ID IS NULL THEN A.DIVISION_ID'
             || '            ELSE A.ORIGIN_DIVISION_ID END AS TEMPCOLUMN' || CHR(10)
             || '     , NVL(A.ELECTRODE_TYPE, ''-'') AS ELECTRODE_TYPE' || CHR(10)
             || '     , NVL(A.CELL_TYPE, ''-'') AS CELL_TYPE' || CHR(10)
             || '     , CASE A.MEASURE WHEN ''R_SCP_PROD_PLAN'' THEN ''S''' || CHR(10)
             || '                      WHEN ''R_SCP_SHIP_PLAN_ETA'' THEN ''S''' || CHR(10)
             || '                      WHEN ''R_SHIP_REQ_ETA'' THEN ''S''' || CHR(10)
             || '                      WHEN ''R_FP_NPC_ASSY_PLAN'' THEN ''P''' || CHR(10)
             || '                      WHEN ''R_FP_COATER_PLAN'' THEN ''P''' || CHR(10)
             || '                      WHEN ''R_FP_COATER_POST_PLAN'' THEN ''P''' || CHR(10)
             || '                      WHEN ''R_SHIP_PLAN_ETD'' THEN ''I''' || CHR(10)
             || '                      WHEN ''R_INTRANSIT_ETA'' THEN ''I''' || CHR(10)
             || '                      WHEN ''R_INV_SHIP_REQ'' THEN ''I''' || CHR(10)
             || '                      WHEN ''R_INV_SHIP_PLAN'' THEN ''I'' END AS PSI_NAME' || CHR(10)));

            /* ★AS-IS 는 전체 기초재고 칸(TOT_BOH_QTY)을 돌려주지 않는다 —
               그 칸을 만드는 줄이 바로 앞 주석에 묻혀 주석 처리되어 있다.
               화면 칸 설정에는 그 칸(제목 BOH · 순서 17)이 있어 늘 빈 칸으로 보인다.
               원문 그대로 두고 보고서에 올린다. */
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                FN_BOH('JR_BOH_QTY', 'JR_BOH_QTY')
             || FN_BOH('PC_BOH_QTY', 'PC_BOH_QTY')
             || FN_BOH('TOT_BOH_QTY_PCM', 'TOT_BOH_QTY_PCM')
             || FN_BOH('JR_BOH_QTY_PCM', 'JR_BOH_QTY_PCM')
             || FN_BOH('PC_BOH_QTY_PCM', 'PC_BOH_QTY_PCM')
             || FN_BOH('TOT_BOH_QTY_CELL', 'TOT_BOH_QTY_CELL')
             || FN_BOH('JR_BOH_QTY_CELL', 'JR_BOH_QTY_CELL')
             || FN_BOH('PC_BOH_QTY_CELL', 'PC_BOH_QTY_CELL')));

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                '     , NVL((SELECT NVL(SA.NICK_NAME, ''-'') FROM SCM_MST_ITEM_SN SA'
             || '             WHERE SA.ITEM_ID = A.ITEM_ID AND ROWNUM <= 1), ''-'') AS NICK_NAME' || CHR(10)
             || '     , A.MEASURE' || CHR(10)
             || '     , B.COLUMN_LABEL_NAME AS MEASURE_NAME' || CHR(10)
             || '     , A.SEQ' || CHR(10)
             || '     , TO_CHAR(TO_DATE(''' || P_PLAN_START_YYYYMMDD || ''', ''YYYYMMDD'')'
             || '             + (NVL(A.CONFIRM_DAY, 0) - 1), ''YYYYMMDD'') AS CONFIRM_DAY' || CHR(10)
/* 2026.09.30 AJS 수정 (START) */
--             || '     , CASE WHEN TRIM(E.USERNAME) IS NOT NULL'
--             || '            THEN E.USERNAME || ''('' || D.LAST_UPDATED_BY || '')'''
             || '     , CASE WHEN TRIM(E.USER_NM) IS NOT NULL'
             || '            THEN E.USER_NM || ''('' || D.LAST_UPDATED_BY || '')'''
/* 2026.09.30 AJS 수정 (END) */
             || '            ELSE NVL(D.LAST_UPDATED_BY, ''-'') END AS LAST_UPDATED_BY' || CHR(10)
             || '     , B.ATTRIBUTE3 AS BACK_COLOR' || CHR(10)));

            DBMS_LOB.APPEND(V_SQL, V_QRY_SUM);

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                '  FROM GT_0022_PIVOT A' || CHR(10)
             || '     , SCM_MST_SHEET_MEASURE B' || CHR(10)
             || '     , SCM_MST_TITLESET_USER C' || CHR(10)
             || '     , GT_0022_REQUESTOR D' || CHR(10)
/* 2026.09.30 AJS 수정 (START) */
--             || '     , TB_FX_USER E' || CHR(10)
             || '     , SCM_ADM_USER_M E' || CHR(10)
/* 2026.09.30 AJS 수정 (END) */
             || ' WHERE A.MEASURE = B.COLUMN_NAME' || CHR(10)
             || '   AND B.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
             || '   AND B.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
             || '   AND C.PROGRAM_ID(+) = B.PROGRAM_ID' || CHR(10)
             || '   AND C.SHEET_NAME(+) = B.SHEET_NAME' || CHR(10)
             || '   AND C.COLUMN_NAME(+) = B.COLUMN_NAME' || CHR(10)
             || '   AND C.USER_ID(+) = ''' || P_USER_ID || '''' || CHR(10)
             || '   AND D.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
             || '   AND D.ITEM_ID(+) = A.ITEM_ID' || CHR(10)
             || '   AND D.MODEL_ID(+) = A.MODEL_ID' || CHR(10)
             || '   AND D.FROM_SITE(+) = A.FROM_SITE' || CHR(10)
             || '   AND D.TO_SITE(+) = A.TO_SITE' || CHR(10)
             || '   AND D.BOD_ID(+) = A.BOD_ID' || CHR(10)
             || '   AND D.MEASURE(+) = A.MEASURE' || CHR(10)
/* 2026.09.30 AJS 수정 (START) */
--             || '   AND E.USERID(+) = D.LAST_UPDATED_BY' || CHR(10)
             || '   AND E.USER_ID(+) = D.LAST_UPDATED_BY' || CHR(10)
/* 2026.09.30 AJS 수정 (END) */
             || '   AND B.VALID_YN = ''Y''' || CHR(10)
             || '   AND A.ROW_NUM = 1' || CHR(10)
             || '   AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
             || '     OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SA' || CHR(10)
             || '                 WHERE SA.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
             || '                   AND SA.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
             || '                   AND SA.USER_ID = ''' || P_USER_ID || '''' || CHR(10)
             || '                   AND SA.COLUMN_NAME = B.COLUMN_NAME))' || CHR(10)
             || '   AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND B.DEFAULT_FLAG = ''Y'')' || CHR(10)
             || '     OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
             || '   AND B.COLUMN_NAME = A.MEASURE' || CHR(10)
             || '   AND NVL(A.ELECTRODE_TYPE, ''-'') <> ''-''' || CHR(10)
             || ' GROUP BY A.DIVISION_ID, A.ORIGIN_DIVISION_ID, A.PLANT_ID, A.SCM_SITE_ID, A.MODEL_ID'
             || '        , A.ITEM_ID, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.BOD_LT, A.OP_LT'
             || '        , A.TRANSPORT_MODE, A.INCOTERMS, A.ELECTRODE_TYPE, A.CELL_TYPE'
             || '        , A.TOT_BOH_QTY, A.PC_BOH_QTY, A.JR_BOH_QTY'
             || '        , A.TOT_BOH_QTY_PCM, A.PC_BOH_QTY_PCM, A.JR_BOH_QTY_PCM'
             || '        , A.TOT_BOH_QTY_CELL, A.PC_BOH_QTY_CELL, A.JR_BOH_QTY_CELL'
             || '        , A.MEASURE, B.COLUMN_LABEL_NAME, A.SEQ, A.CONFIRM_DAY'
/* 2026.09.30 AJS 수정 (START) */
--             || '        , D.LAST_UPDATED_BY, E.USERNAME, B.ATTRIBUTE3' || CHR(10)
             || '        , D.LAST_UPDATED_BY, E.USER_NM, B.ATTRIBUTE3' || CHR(10)
/* 2026.09.30 AJS 수정 (END) */
             || ' ORDER BY A.DIVISION_ID, A.PLANT_ID, A.MODEL_ID, A.ITEM_ID, A.SEQ'
             || '        , A.FROM_SITE DESC, A.TRANSPORT_MODE' || CHR(10)));

            OPEN O_RC1 FOR V_SQL;

        ELSE                                            /* 과거 기준 조회 */

            P_SSP0022_PSI_ROWDATA_OLD(P_DIVISION_ID, P_COMPANY_ID, P_PLANT_ID, P_CELL_TYPE
                                    , P_PLAN_START_YYYYMMDD, P_FROM_YYYYMMDD, P_TO_YYYYMMDD
                                    , P_MODEL_ID, P_ITEM_ID, P_NICK_NAME);

            P_SSP0022_PSI_RESULT_OLD(P_PROGRAM_ID, P_SHEET_NAME, P_USER_ID, P_PLAN_START_YYYYMMDD);

            /* PIVOIT 대상 날짜문자열 생성 — 과거 기준은 천 단위 올림(CEIL)으로 돌려준다 */
            FOR C IN ( SELECT IA.COL_NAME
                            , IA.KIND
                            , IA.VAL
                         FROM ( SELECT 'X_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COL_NAME
                                     , 'W' AS KIND, SUBSTR(A.BASIS_YYYYMM, -4) || A.ISO_WEEK AS VAL
                                     , 'X_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                                UNION ALL
                                SELECT 'X_M_' || A.BASIS_YYYYMM, 'M', A.BASIS_YYYYMM
                                     , 'X_' || MIN(A.BASIS_START_DATE) || '01'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                SELECT 'X_D_' || A.BASIS_YYYYMMDD, 'D', 'D_' || A.BASIS_YYYYMMDD
                                     , 'X_' || A.BASIS_YYYYMMDD || '31'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMMDD
                                UNION ALL
                                SELECT 'Y_W_' || A.BASIS_YYYYMM || A.ISO_WEEK, 'W', SUBSTR(A.BASIS_YYYYMM, -4) || A.ISO_WEEK
                                     , 'Y_' || A.BASIS_START_DATE || '21'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                                UNION ALL
                                SELECT 'Y_M_' || A.BASIS_YYYYMM, 'M', A.BASIS_YYYYMM
                                     , 'Y_' || MIN(A.BASIS_START_DATE) || '01'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                SELECT 'Y_D_' || A.BASIS_YYYYMMDD, 'D', 'D_' || A.BASIS_YYYYMMDD
                                     , 'Y_' || A.BASIS_YYYYMMDD || '31'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMMDD
                                UNION ALL
                                SELECT 'Z_W_' || A.BASIS_YYYYMM || A.ISO_WEEK, 'W', SUBSTR(A.BASIS_YYYYMM, -4) || A.ISO_WEEK
                                     , 'Z_' || A.BASIS_START_DATE || '21'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                                UNION ALL
                                SELECT 'Z_M_' || A.BASIS_YYYYMM, 'M', A.BASIS_YYYYMM
                                     , 'Z_' || MIN(A.BASIS_START_DATE) || '01'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                SELECT 'Z_D_' || A.BASIS_YYYYMMDD, 'D', 'D_' || A.BASIS_YYYYMMDD
                                     , 'Z_' || A.BASIS_YYYYMMDD || '31'
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                                 GROUP BY A.BASIS_YYYYMMDD ) IA
                        ORDER BY IA.SORT_ORDER_NO )
            LOOP
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
                    ',CEIL(SUM(CASE WHEN A.'
                 || CASE C.KIND WHEN 'M' THEN 'YYYYMM' WHEN 'W' THEN 'ISO_WEEK' ELSE 'YYYYMMDD' END
                 || ' = ''' || C.VAL || ''' THEN CAST(NVL(A.'
                 || CASE SUBSTR(C.COL_NAME, 1, 1) WHEN 'X' THEN 'QTY'
                                                  WHEN 'Y' THEN 'QTY_TO_CELL'
                                                  ELSE 'QTY_TO_PCM' END
                 || ', 0.00) AS NUMBER(30,3)) ELSE 0 END)) AS '
                 || C.COL_NAME || CHR(10)));
            END LOOP;

            /* 6. RESULT */
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT A.DIVISION_ID' || CHR(10)
             || '     , A.PLANT_ID' || CHR(10)
             || '     , NVL(A.SCM_SITE_ID, ''-'') AS SCM_SITE_ID' || CHR(10)
             || '     , A.MODEL_ID' || CHR(10)
             || '     , A.ITEM_ID' || CHR(10)
             || '     , NVL(A.FROM_SITE, ''-'') AS FROM_SITE' || CHR(10)
             || '     , NVL(A.TO_SITE, ''-'') AS TO_SITE' || CHR(10)
             || '     , NVL(A.BOD_ID, ''-'') AS BOD_ID' || CHR(10)
             || '     , NVL(A.BOD_LT, ''-'') AS BOD_LT' || CHR(10)
             || '     , A.TRANSPORT_MODE AS TRANSPORT_MODE' || CHR(10)
             || '     , A.INCOTERMS AS INCOTERMS' || CHR(10)
             || '     , A.OP_LT AS OPERATION_LT' || CHR(10)
             || '     , ''-'' AS TEMPCOLUMN' || CHR(10)
             || '     , NVL(A.ELECTRODE_TYPE, ''-'') AS ELECTRODE_TYPE' || CHR(10)
             || '     , NVL(A.CELL_TYPE, ''-'') AS CELL_TYPE' || CHR(10)
             || '     , CASE A.MEASURE WHEN ''R_SCP_PROD_PLAN'' THEN ''S''' || CHR(10)
             || '                      WHEN ''R_SCP_SHIP_PLAN_ETA'' THEN ''S''' || CHR(10)
             || '                      WHEN ''R_SHIP_REQ_ETA'' THEN ''S''' || CHR(10)
             || '                      WHEN ''R_FP_NPC_ASSY_PLAN'' THEN ''P''' || CHR(10)
             || '                      WHEN ''R_FP_COATER_PLAN'' THEN ''P''' || CHR(10)
             || '                      WHEN ''R_FP_COATER_POST_PLAN'' THEN ''P''' || CHR(10)
             || '                      WHEN ''R_SHIP_PLAN_ETD'' THEN ''I''' || CHR(10)
             || '                      WHEN ''R_INTRANSIT_ETA'' THEN ''I''' || CHR(10)
             || '                      WHEN ''R_INV_SHIP_REQ'' THEN ''I''' || CHR(10)
             || '                      WHEN ''R_INV_SHIP_PLAN'' THEN ''I'' END AS PSI_NAME' || CHR(10)));

            /* ★현재 기준과 같이 전체 기초재고 칸(TOT_BOH_QTY)을 만드는 줄이 주석에 묻혀 있다 —
               원문 그대로 두고 보고서에 올린다. */
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                FN_BOH('JR_BOH_QTY', 'JR_BOH_QTY')
             || FN_BOH('PC_BOH_QTY', 'PC_BOH_QTY')
             || FN_BOH('TOT_BOH_QTY_PCM', 'TOT_BOH_QTY_PCM')
             || FN_BOH('JR_BOH_QTY_PCM', 'JR_BOH_QTY_PCM')
             || FN_BOH('PC_BOH_QTY_PCM', 'PC_BOH_QTY_PCM')
             || FN_BOH('TOT_BOH_QTY_CELL', 'TOT_BOH_QTY_CELL')
             || FN_BOH('JR_BOH_QTY_CELL', 'JR_BOH_QTY_CELL')
             || FN_BOH('PC_BOH_QTY_CELL', 'PC_BOH_QTY_CELL')));

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                '     , NVL((SELECT NVL(SA.NICK_NAME, ''-'') FROM SCM_MST_ITEM_SN SA'
             || '             WHERE SA.ITEM_ID = A.ITEM_ID AND ROWNUM <= 1), ''-'') AS NICK_NAME' || CHR(10)
             || '     , A.MEASURE' || CHR(10)
             || '     , B.COLUMN_LABEL_NAME AS MEASURE_NAME' || CHR(10)
             || '     , A.SEQ' || CHR(10)
             || '     , TO_CHAR(TO_DATE(''' || P_PLAN_START_YYYYMMDD || ''', ''YYYYMMDD'')'
             || '             + (NVL(A.CONFIRM_DAY, 0) - 1), ''YYYYMMDD'') AS CONFIRM_DAY' || CHR(10)
             || '     , B.ATTRIBUTE3 AS BACK_COLOR' || CHR(10)));

            DBMS_LOB.APPEND(V_SQL, V_QRY_SUM);

            /* ★AS-IS 는 여기서 요청자 임시 테이블과 사용자 테이블을 바깥 조인으로 건다.
               그런데 그 임시 테이블은 현재 기준 갈래에서만 만들어져 과거 기준 조회는
               「Invalid object name '#TblDynamic_REQUESTOR'」(오류 208)로 늘 끊긴다.
               두 조인에서 가져오는 칸이 하나도 없고 묶음 조건이 겹침을 걷어내므로
               조인을 빼도 결과가 같다 — 빼서 조회가 되게 한다. */
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                '  FROM GT_0022_PIVOT_OLD A' || CHR(10)
             || '     , SCM_MST_SHEET_MEASURE B' || CHR(10)
             || '     , SCM_MST_TITLESET_USER C' || CHR(10)
             || ' WHERE A.MEASURE = B.COLUMN_NAME' || CHR(10)
             || '   AND B.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
             || '   AND B.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
             || '   AND C.PROGRAM_ID(+) = B.PROGRAM_ID' || CHR(10)
             || '   AND C.SHEET_NAME(+) = B.SHEET_NAME' || CHR(10)
             || '   AND C.COLUMN_NAME(+) = B.COLUMN_NAME' || CHR(10)
             || '   AND C.USER_ID(+) = ''' || P_USER_ID || '''' || CHR(10)
             || '   AND B.VALID_YN = ''Y''' || CHR(10)
             || '   AND A.ROW_NUM = 1' || CHR(10)
             || '   AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
             || '     OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SA' || CHR(10)
             || '                 WHERE SA.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
             || '                   AND SA.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
             || '                   AND SA.USER_ID = ''' || P_USER_ID || '''' || CHR(10)
             || '                   AND SA.COLUMN_NAME = B.COLUMN_NAME))' || CHR(10)
             || '   AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND B.DEFAULT_FLAG = ''Y'')' || CHR(10)
             || '     OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
             || '   AND B.COLUMN_NAME = A.MEASURE' || CHR(10)
             || '   AND NVL(A.ELECTRODE_TYPE, ''-'') <> ''-''' || CHR(10)
             || ' GROUP BY A.DIVISION_ID, A.PLANT_ID, A.SCM_SITE_ID, A.ELECTRODE_TYPE, A.CELL_TYPE'
             || '        , A.MODEL_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.BOD_LT, A.OP_LT'
             || '        , A.TRANSPORT_MODE, A.INCOTERMS'
             || '        , A.TOT_BOH_QTY, A.PC_BOH_QTY, A.JR_BOH_QTY'
             || '        , A.TOT_BOH_QTY_PCM, A.PC_BOH_QTY_PCM, A.JR_BOH_QTY_PCM'
             || '        , A.TOT_BOH_QTY_CELL, A.PC_BOH_QTY_CELL, A.JR_BOH_QTY_CELL'
             || '        , A.MEASURE, B.COLUMN_LABEL_NAME, A.SEQ, A.CONFIRM_DAY, B.ATTRIBUTE3' || CHR(10)
             || ' ORDER BY A.DIVISION_ID, A.PLANT_ID, A.MODEL_ID, A.ITEM_ID, A.SEQ'
             || '        , A.FROM_SITE DESC' || CHR(10)));

            OPEN O_RC1 FOR V_SQL;

        END IF;

        DBMS_LOB.FREETEMPORARY(V_QRY_SUM);
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

    END P_SSP0022_GET_SHIPMENT_PSI;

    /*******************************************************************************
     * P_SSP0022_SAVE_SHIPMENT_REQUEST
     *   AS-IS SSP0022_SAVE_SHIPMENT_REQUEST — Shipment Request 입력
     *
     * AS-IS 절차
     *   1. 화면이 보낸 값을 `^` 로 나누어 한 줄씩 읽는다. 줄 수는 품목 인자의 토막 수로 센다.
     *   2. 운송경로에서 우선순위가 가장 앞선 한 건을 찾고, 그 경로가 품목에 등록되어 있어야 한다.
     *      찾은 값 가운데 하나라도 비면 결과코드 'X' 로 끝낸다(저장하지 않음).
     *   3. 찾은 경로로 저장 대상 한 줄을 임시 테이블에 넣는다. 수량은 소수 셋째 자리로 올린다.
     *   4. 이미 있는 행은 수량만 고치고, 없는 행은 지시번호를 만들어 새로 넣는다.
     *   5. 고친 뒤·넣은 뒤의 원장 값을 이력에 남긴다.
     *
     * ★되돌리기를 커서 OPEN 앞에 둔다(ROLLBACK 이 뒤에 오면 커서가 닫힌다).
     * ★AS-IS 는 경로를 담는 변수를 줄마다 비우지 않아, 경로를 못 찾은 줄이
     *   앞 줄의 경로로 저장된다. 결과코드 'X' 를 내려는 바로 다음 조건이 무력해진다.
     *   줄마다 비우도록 고쳤다 — SSP0026 저장 갈래도 같은 틀이어서 같게 두었다.
     * ★원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_SAVE_SHIPMENT_REQUEST
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_COMPANY_ID            IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_ETA_DATE              IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_QTY                   IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        C_DELIMITER             CONSTANT VARCHAR2(1 CHAR) := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0022_SAVE_SHIPMENT_REQUEST';
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
        V_COMPANY_ID            VARCHAR2(30 CHAR);
        V_PLANT_ID              VARCHAR2(30 CHAR);
        V_SCM_SITE_ID           VARCHAR2(30 CHAR);
        V_MODEL_ID              VARCHAR2(50 CHAR);
        V_ITEM_ID               VARCHAR2(50 CHAR);
        V_BOD_ID                VARCHAR2(50 CHAR);
        V_INCOTERMS             VARCHAR2(50 CHAR);
        V_TRANSPORT_MODE        VARCHAR2(50 CHAR);
        V_FROM_SITE             VARCHAR2(50 CHAR);
        V_TO_SITE               VARCHAR2(30 CHAR);
        V_ETA_DATE              VARCHAR2(8 CHAR);
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

        SAVEPOINT SP_SSP0022_SAVE_REQ;

        DELETE FROM GT_0022_SAVE_REQ;
        DELETE FROM GT_0022_SAVE_REQ_H;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ITEM_ID, C_DELIMITER));

        /*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
        WHILE LENGTH(P_DIVISION_ID) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            /* @mst_loop_cnt 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG     := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,    C_DELIMITER, V_MST_LOOP_CNT);
            V_COMPANY_ID      := SCM_ARR_SPL_VAL(P_COMPANY_ID,     C_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID     := SCM_ARR_SPL_VAL(P_DIVISION_ID,    C_DELIMITER, V_MST_LOOP_CNT);
            V_PLANT_ID        := SCM_ARR_SPL_VAL(P_PLANT_ID,       C_DELIMITER, V_MST_LOOP_CNT);
            V_SCM_SITE_ID     := SCM_ARR_SPL_VAL(P_SCM_SITE_ID,    C_DELIMITER, V_MST_LOOP_CNT);
            V_MODEL_ID        := SCM_ARR_SPL_VAL(P_MODEL_ID,       C_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID         := SCM_ARR_SPL_VAL(P_ITEM_ID,        C_DELIMITER, V_MST_LOOP_CNT);
            V_BOD_ID          := SCM_ARR_SPL_VAL(P_BOD_ID,         C_DELIMITER, V_MST_LOOP_CNT);
            V_INCOTERMS       := SCM_ARR_SPL_VAL(P_INCOTERMS,      C_DELIMITER, V_MST_LOOP_CNT);
            V_TRANSPORT_MODE  := SCM_ARR_SPL_VAL(P_TRANSPORT_MODE, C_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE       := SCM_ARR_SPL_VAL(P_FROM_SITE,      C_DELIMITER, V_MST_LOOP_CNT);
            V_TO_SITE         := SCM_ARR_SPL_VAL(P_TO_SITE,        C_DELIMITER, V_MST_LOOP_CNT);
            V_ETA_DATE        := SCM_ARR_SPL_VAL(P_ETA_DATE,       C_DELIMITER, V_MST_LOOP_CNT);
            V_QTY             := SCM_ARR_SPL_VAL(P_QTY,            C_DELIMITER, V_MST_LOOP_CNT);

            /* ★줄마다 비운다 — 경로를 못 찾은 줄이 앞 줄 값으로 저장되지 않게 */
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

            /* 운송경로에서 우선순위가 가장 앞선 한 건 */
            BEGIN
                SELECT IA.DIVISION_ID
                     , IA.BOD_ID
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.SSP_INCOTERMS
                     , IA.TRANSPORT_MODE
                     , IA.ROUTE_ID
                     , IA.D_COUNTRY
                     , IA.D_PORT_CODE
                     , IA.A_COUNTRY
                     , IA.A_PORT_CODE
                     , IA.LT_TOTAL
                     , IA.TO_COUNTRY
                     , IA.TO_CITY
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
                  FROM (SELECT XA.DIVISION_ID
                             , XA.BOD_ID
                             , XA.FROM_SITE
                             , XA.TO_SITE
                             , XA.SSP_INCOTERMS
                             , XA.TRANSPORT_MODE
                             , XA.ROUTE_ID
                             , XA.D_COUNTRY
                             , XA.D_PORT_CODE
                             , XA.A_COUNTRY
                             , XA.A_PORT_CODE
                             , XA.LT_TOTAL
                             , XA.TO_COUNTRY
                             , XA.TO_CITY
                             , ROW_NUMBER() OVER (ORDER BY XA.PRIORITY) AS RN
                          FROM (SELECT DISTINCT SA.DIVISION_ID
                                     , SA.BOD_ID
                                     , SA.FROM_SITE
                                     , SA.TO_SITE
                                     , SA.SSP_INCOTERMS
                                     , SA.TRANSPORT_MODE
                                     , SA.ROUTE_ID
                                     , SA.D_COUNTRY
                                     , SA.D_PORT_CODE
                                     , SA.A_COUNTRY
                                     , SA.A_PORT_CODE
                                     , SA.LT_TOTAL
                                     , SA.LT_TOTAL_ORIGIN
                                     , SA.TO_COUNTRY
                                     , SA.TO_CITY
                                     , SA.PRIORITY
                                     , SA.BOD_VALID_YN
                                  FROM (SELECT XB.DIVISION_ID
                                             , XB.BOD_ID
                                             , XB.FROM_SITE
                                             , XB.TO_SITE
                                             , XB.SSP_INCOTERMS
                                             , XB.TRANSPORT_MODE
                                             , XB.ROUTE_ID
                                             , XB.D_COUNTRY
                                             , XB.D_PORT_CODE
                                             , XB.A_COUNTRY
                                             , XB.A_PORT_CODE
                                             , XB.LT_TOTAL
                                             , XB.LT_TOTAL_ORIGIN
                                             , XB.TO_COUNTRY
                                             , XB.TO_CITY
                                             , XB.PRIORITY
                                             , XB.BOD_VALID_YN
                                          FROM (SELECT DIVISION_ID
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
                                                     , LT_TOTAL_ORIGIN
                                                     , TO_COUNTRY
                                                     , TO_CITY
                                                     , PRIORITY
                                                     , BOD_VALID_YN
                                                  FROM SCP_MST_BOD_N_V
                                                 WHERE DIVISION_ID = V_DIVISION_ID
                                                   AND FROM_SITE = V_FROM_SITE
                                                   AND TO_SITE = V_TO_SITE
                                                   AND TRANSPORT_MODE = V_TRANSPORT_MODE
                                                   AND SSP_INCOTERMS = V_INCOTERMS
                                                   AND BOD_VALID_YN = 'Y'
                                                   AND FROM_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                                   AND TO_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                                 ORDER BY PRIORITY ASC) XB
                                         WHERE ROWNUM <= 1) SA) XA
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , BOD_ID
                                  FROM SCP_MST_BOD_ITEM
                                 WHERE DIVISION_ID = V_DIVISION_ID
                                   AND ITEM_ID = V_ITEM_ID) XC
                         WHERE XC.DIVISION_ID = XA.DIVISION_ID
                           AND XC.BOD_ID = XA.BOD_ID
                           AND XA.DIVISION_ID = V_DIVISION_ID
                           AND XA.FROM_SITE = V_FROM_SITE
                           AND XA.TO_SITE = V_TO_SITE
                           AND XA.TRANSPORT_MODE = V_TRANSPORT_MODE
                           AND XA.SSP_INCOTERMS = V_INCOTERMS
                           AND XA.BOD_VALID_YN = 'Y') IA
                 WHERE IA.RN = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            IF ( ( TRIM(V_DIVISION_ID_TEMP) IS NULL )
              OR ( TRIM(V_NEW_BOD_ID_TEMP) IS NULL )
              OR ( TRIM(V_FROM_SITE_TEMP) IS NULL )
              OR ( TRIM(V_TO_SITE_TEMP) IS NULL )
              OR ( TRIM(V_NEW_INCOTERMS_TEMP) IS NULL )
              OR ( TRIM(V_NEW_TRANSPORT_MODE_TEMP) IS NULL )
              OR ( TRIM(V_NEW_ROUTE_ID_TEMP) IS NULL )
              OR ( TRIM(V_NEW_D_CONTRY_TEMP) IS NULL )
              OR ( TRIM(V_NEW_D_PORT_CODE_TEMP) IS NULL )
              OR ( TRIM(V_NEW_A_COUNTRY_TEMP) IS NULL )
              OR ( TRIM(V_NEW_A_PORT_CODE_TEMP) IS NULL )
              OR ( TRIM(V_NEW_CUSTOMER_LT_TEMP) IS NULL )
              OR ( TRIM(V_NEW_TO_COUNTRY_TEMP) IS NULL )
              OR ( TRIM(V_NEW_TO_CITY_TEMP) IS NULL ) )
            THEN

                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '';
                D_EVENT_DATE  := SYSDATE;
                PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                ROLLBACK TO SP_SSP0022_SAVE_REQ;

                OPEN O_RC1 FOR
                    SELECT 'X' AS RESULT_CODE, CAST(NULL AS VARCHAR2(30 CHAR)) AS REQUEST_NO FROM DUAL;
                OPEN O_RC2 FOR
                    SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;
                RETURN;

            END IF;

            /* 변경, 추가 대상 건 TEMP 생성 */
            INSERT INTO GT_0022_SAVE_REQ
                 ( ACTIVE_FLAG, FROM_COMPANY_ID, FROM_DIVISION_ID, FROM_PLANT_ID, FROM_SITE
                 , TO_COMPANY_ID, TO_DIVISION_ID, TO_PLANT_ID, TO_SITE, MODEL_ID, ITEM_ID
                 , BOD_ID, INCOTERMS, TRANSPORT_MODE, ETA_DATE, ETD_DATE
                 , QTY, QTY_TO_PCM, QTY_TO_CELL )
            SELECT A.ACTIVE_FLAG
                 , C.COMPANY_ID                         AS FROM_COMPANY_ID
                 , B.SEGMENT2                           AS FROM_DIVISION_ID
                 , C.PLANT_ID                           AS FROM_PLANT_ID
                 , A.FROM_SITE
                 , A.COMPANY_ID                         AS TO_COMPANY_ID
                 , A.TO_DIVISION_ID
                 , A.PLANT_ID                           AS TO_PLANT_ID
                 , A.TO_SITE
                 , A.MODEL_ID
                 , A.ITEM_ID
                 , A.BOD_ID
                 , A.INCOTERMS
                 , A.TRANSPORT_MODE
                 , A.ETA_DATE
                 , A.ETD_DATE
                 /* Start E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                 , CEIL(A.QTY * 1000) / 1000                                    AS QTY
                 , CEIL((A.QTY * NVL(D.CONVERT_TO_PCM, 1)) * 1000) / 1000       AS QTY_TO_PCM
                 , CEIL((A.QTY * NVL(D.CONVERT_TO_CELL, 1)) * 1000) / 1000      AS QTY_TO_CELL
                 /* End E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
              FROM (SELECT V_ACTIVE_FLAG                AS ACTIVE_FLAG
                         , V_COMPANY_ID                 AS COMPANY_ID
                         , V_DIVISION_ID                AS DIVISION_ID
                         , V_PLANT_ID                   AS PLANT_ID
                         , V_SCM_SITE_ID                AS SCM_SITE_ID
                         , (SELECT SA.DIVISION_ID
                              FROM SCM_MST_SITE SA
                             WHERE SA.SCM_SITE_ID = V_FROM_SITE)  AS FROM_DIVISION_ID
                         , V_FROM_SITE                  AS FROM_SITE
                         , (SELECT SB.DIVISION_ID
                              FROM SCM_MST_SITE SB
                             WHERE SB.SCM_SITE_ID = V_TO_SITE)    AS TO_DIVISION_ID
                         , V_TO_SITE                    AS TO_SITE
                         , V_MODEL_ID                   AS MODEL_ID
                         , V_ITEM_ID                    AS ITEM_ID
                         , V_ETA_DATE                   AS ETA_DATE
                         , FN_GET_SSP_ETD_DATE(V_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_ETA_DATE) AS ETD_DATE
                         , V_NEW_BOD_ID_TEMP            AS BOD_ID
                         , V_NEW_INCOTERMS_TEMP         AS INCOTERMS
                         , V_NEW_TRANSPORT_MODE_TEMP    AS TRANSPORT_MODE
                         , TO_NUMBER(V_QTY)             AS QTY/* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                      FROM DUAL) A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , SCM_MST_SITE C
                 , SSP_MST_SITE_ITEM_EE_V D
             WHERE B.LOOKUP_TYPE(+) = 'ELECTRODE_SHIP_FROM_TO'
               AND B.SEGMENT5(+) = A.TO_DIVISION_ID
               AND B.SEGMENT3(+) = A.FROM_SITE
               AND B.ATTRIBUTE1(+) = A.TO_SITE
               AND B.SEGMENT2 = C.DIVISION_ID(+)
               AND A.FROM_SITE = C.SCM_SITE_ID(+)
               AND B.SEGMENT2 = D.DIVISION_ID
               AND A.FROM_SITE = D.SCM_SITE_ID
               AND A.ITEM_ID = D.ITEM_ID;

        END LOOP;

        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0022_SAVE_REQ;

        /* 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행 */

        IF V_CNT > 0 THEN

            D_EVENT_DATE := SYSDATE;

            /* 수정 */
            UPDATE SSP_ANL_SHIP_REQ_EE A
               SET (A.QTY, A.QTY_TO_PCM, A.QTY_TO_CELL) =
                   (SELECT B.QTY
                         , B.QTY_TO_PCM
                         , B.QTY_TO_CELL
                      FROM GT_0022_SAVE_REQ B
                     WHERE B.FROM_DIVISION_ID = A.FROM_DIVISION_ID
                       AND B.FROM_SITE = A.FROM_SITE
                       AND B.FROM_PLANT_ID = A.FROM_PLANT_ID
                       AND B.TO_SITE = A.TO_SITE
                       AND B.MODEL_ID = A.MODEL_ID
                       AND B.ITEM_ID = A.ITEM_ID
                       AND B.ETA_DATE = A.ETA_DATE
                       AND B.BOD_ID = A.BOD_ID)
                 , A.LAST_UPDATED_BY = P_CREATED_BY
                 , A.LAST_UPDATE_DATE = D_EVENT_DATE
             WHERE EXISTS (SELECT 1
                             FROM GT_0022_SAVE_REQ B
                            WHERE B.FROM_DIVISION_ID = A.FROM_DIVISION_ID
                              AND B.FROM_SITE = A.FROM_SITE
                              AND B.FROM_PLANT_ID = A.FROM_PLANT_ID
                              AND B.TO_SITE = A.TO_SITE
                              AND B.MODEL_ID = A.MODEL_ID
                              AND B.ITEM_ID = A.ITEM_ID
                              AND B.ETA_DATE = A.ETA_DATE
                              AND B.BOD_ID = A.BOD_ID);

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;
        /* UPDATE END */

        /* INSERT START */
        SELECT COUNT(*)
          INTO V_CNT
          FROM GT_0022_SAVE_REQ B
         WHERE NOT EXISTS (SELECT 1
                             FROM SSP_ANL_SHIP_REQ_EE A
                            WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                              AND A.FROM_SITE = B.FROM_SITE
                              AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                              AND A.TO_SITE = B.TO_SITE
                              AND A.MODEL_ID = B.MODEL_ID
                              AND A.ITEM_ID = B.ITEM_ID
                              AND A.ETA_DATE = B.ETA_DATE
                              AND A.BOD_ID = B.BOD_ID);

        IF V_CNT > 0 THEN

            /* INSERT 대상 건 ACTIVE FLAG 변경 */
            UPDATE GT_0022_SAVE_REQ A
               SET A.ACTIVE_FLAG = 'I'
             WHERE NOT EXISTS (SELECT 1
                                 FROM SSP_ANL_SHIP_REQ_EE B
                                WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                                  AND A.FROM_SITE = B.FROM_SITE
                                  AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                                  AND A.TO_SITE = B.TO_SITE
                                  AND A.MODEL_ID = B.MODEL_ID
                                  AND A.ITEM_ID = B.ITEM_ID
                                  AND A.ETA_DATE = B.ETA_DATE
                                  AND A.BOD_ID = B.BOD_ID);

            /* 신규 REQEUST INSERT */
            INSERT INTO SSP_ANL_SHIP_REQ_EE
                 ( FROM_COMPANY_ID
                 , FROM_DIVISION_ID
                 , FROM_PLANT_ID
                 , FROM_SITE
                 , TO_COMPANY_ID
                 , TO_DIVISION_ID
                 , TO_PLANT_ID
                 , TO_SITE
                 , MODEL_ID
                 , ITEM_ID
                 , BOD_ID
                 , ETD_DATE
                 , ETA_DATE
                 , QTY
                 , QTY_TO_PCM
                 , QTY_TO_CELL
                 , SCP_PLAN_START_YYYYMMDD
                 , SCP_PLAN_TYPE
                 , SCP_PLAN_SEQ
                 , REQUEST_ID
                 , CONFIRM_ID
                 , CONFIRM_FLAG
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT B.FROM_COMPANY_ID
                 , B.FROM_DIVISION_ID
                 , B.FROM_PLANT_ID
                 , B.FROM_SITE
                 , B.TO_COMPANY_ID
                 , B.TO_DIVISION_ID
                 , B.TO_PLANT_ID
                 , B.TO_SITE
                 , B.MODEL_ID
                 , B.ITEM_ID
                 , B.BOD_ID
                 , FN_GET_SSP_ETD_DATE(B.TO_DIVISION_ID, B.BOD_ID, B.ETA_DATE) AS ETD_DATE
                 , B.ETA_DATE
                 , B.QTY                     AS QTY
                 , B.QTY_TO_PCM              AS QTY_TO_PCM
                 , B.QTY_TO_CELL             AS QTY_TO_CELL
                 , NULL                                 AS SCP_PLAN_START_YYYYMMDD
                 , NULL                                 AS SCP_PLAN_TYPE
                 , NULL                                 AS SCP_PLAN_SEQ
                 , ('R' || TO_CHAR(SYSDATE, 'YYYYMMDD')
                        || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_REQ_EE_ID.NEXTVAL), -6)) AS REQUEST_ID
                 , NULL                                 AS CONFIRM_ID
                 , 'N'                                  AS CONFIRM_FLAG
                 , P_CREATED_BY                         AS CREATED_BY
                 , D_EVENT_DATE                         AS CREATION_DATE
                 , P_CREATED_BY                         AS LAST_UPDATED_BY
                 , D_EVENT_DATE                         AS LAST_UPDATE_DATE
              FROM GT_0022_SAVE_REQ B
             WHERE NOT EXISTS (SELECT 1
                                 FROM SSP_ANL_SHIP_REQ_EE A
                                WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                                  AND A.FROM_SITE = B.FROM_SITE
                                  AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                                  AND A.TO_SITE = B.TO_SITE
                                  AND A.MODEL_ID = B.MODEL_ID
                                  AND A.ITEM_ID = B.ITEM_ID
                                  AND A.ETA_DATE = B.ETA_DATE
                                  AND A.BOD_ID = B.BOD_ID);

            V_CNT := 0;   /* 저장 후 초기화 */

        END IF;

        /* HISTORY 대상 건 TEMP 생성 */
        INSERT INTO GT_0022_SAVE_REQ_H
             ( HISTORY_SEQ, ACTIVE_FLAG, FROM_COMPANY_ID, FROM_DIVISION_ID, FROM_PLANT_ID
             , FROM_SITE, TO_COMPANY_ID, TO_DIVISION_ID, TO_PLANT_ID, TO_SITE
             , MODEL_ID, ITEM_ID, BOD_ID, ETD_DATE, ETA_DATE
             , QTY, QTY_TO_PCM, QTY_TO_CELL
             , SCP_PLAN_START_YYYYMMDD, SCP_PLAN_TYPE, SCP_PLAN_SEQ
             , REQUEST_ID, CONFIRM_ID, CONFIRM_FLAG
             , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE )
        SELECT SEQ1_SSP_ANL_SHIP_REQ_EE_H.NEXTVAL       AS HISTORY_SEQ
             , A.ACTIVE_FLAG
             , A.FROM_COMPANY_ID
             , A.FROM_DIVISION_ID
             , A.FROM_PLANT_ID
             , A.FROM_SITE
             , A.TO_COMPANY_ID
             , A.TO_DIVISION_ID
             , A.TO_PLANT_ID
             , A.TO_SITE
             , A.MODEL_ID
             , A.ITEM_ID
             , A.BOD_ID
             , A.ETD_DATE
             , A.ETA_DATE
             , A.QTY
             , A.QTY_TO_PCM
             , A.QTY_TO_CELL
             , A.SCP_PLAN_START_YYYYMMDD
             , A.SCP_PLAN_TYPE
             , A.SCP_PLAN_SEQ
             , A.REQUEST_ID
             , A.CONFIRM_ID
             , A.CONFIRM_FLAG
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , A.HISTORY_CREATION_DATE
          FROM (SELECT B.ACTIVE_FLAG
                     , A.FROM_COMPANY_ID
                     , A.FROM_DIVISION_ID
                     , A.FROM_PLANT_ID
                     , A.FROM_SITE
                     , A.TO_COMPANY_ID
                     , A.TO_DIVISION_ID
                     , A.TO_PLANT_ID
                     , A.TO_SITE
                     , A.MODEL_ID
                     , A.ITEM_ID
                     , A.BOD_ID
                     , A.ETD_DATE
                     , A.ETA_DATE
                     , A.QTY
                     , A.QTY_TO_PCM
                     , A.QTY_TO_CELL
                     , A.SCP_PLAN_START_YYYYMMDD
                     , A.SCP_PLAN_TYPE
                     , A.SCP_PLAN_SEQ
                     , A.REQUEST_ID
                     , A.CONFIRM_ID
                     , A.CONFIRM_FLAG
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , SYSDATE                          AS HISTORY_CREATION_DATE
                  FROM SSP_ANL_SHIP_REQ_EE A
                     , GT_0022_SAVE_REQ B
                 WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                   AND A.FROM_SITE = B.FROM_SITE
                   AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                   AND A.TO_SITE = B.TO_SITE
                   AND A.MODEL_ID = B.MODEL_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.ETA_DATE = B.ETA_DATE
                   AND A.BOD_ID = B.BOD_ID) A;

        /* HISTORY 입력 */
        INSERT INTO SSP_ANL_SHIP_REQ_EE_H
             ( HISTORY_SEQ
             , TRANS_TYPE
             , FROM_COMPANY_ID
             , FROM_DIVISION_ID
             , FROM_PLANT_ID
             , FROM_SITE
             , TO_COMPANY_ID
             , TO_DIVISION_ID
             , TO_PLANT_ID
             , TO_SITE
             , MODEL_ID
             , ITEM_ID
             , BOD_ID
             , ETD_DATE
             , ETA_DATE
             , QTY
             , QTY_TO_PCM
             , QTY_TO_CELL
             , SCP_PLAN_START_YYYYMMDD
             , SCP_PLAN_TYPE
             , SCP_PLAN_SEQ
             , REQUEST_ID
             , CONFIRM_ID
             , CONFIRM_FLAG
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE )
        SELECT HISTORY_SEQ
             , ACTIVE_FLAG
             , FROM_COMPANY_ID
             , FROM_DIVISION_ID
             , FROM_PLANT_ID
             , FROM_SITE
             , TO_COMPANY_ID
             , TO_DIVISION_ID
             , TO_PLANT_ID
             , TO_SITE
             , MODEL_ID
             , ITEM_ID
             , BOD_ID
             , ETD_DATE
             , ETA_DATE
             /* Start E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
             , ROUND(QTY, 3)                            AS QTY
             , ROUND(QTY_TO_PCM, 3)                     AS QTY_TO_PCM
             , ROUND(QTY_TO_CELL, 3)                    AS QTY_TO_CELL
             /* End E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
             , SCP_PLAN_START_YYYYMMDD
             , SCP_PLAN_TYPE
             , SCP_PLAN_SEQ
             , REQUEST_ID
             , CONFIRM_ID
             , CONFIRM_FLAG
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
          FROM GT_0022_SAVE_REQ_H;

        /* END LOG */
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

            ROLLBACK TO SP_SSP0022_SAVE_REQ;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE, V_ERR_MESSAGE AS MSG FROM DUAL;
            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0022_SAVE_SHIPMENT_REQUEST;

    /*******************************************************************************
     * P_SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD
     *   AS-IS SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD — 엑셀 올리기 검사와 저장
     *
     * AS-IS 절차
     *   1. 전달값 0 이면 검사만 한다. 올린 줄마다 상태를 UPLOAD 로 되돌린 뒤
     *      열일곱 가지를 차례로 보고 어긋난 줄에 ERROR 와 문구를 적는다.
     *      빈 줄은 SKIP, 머리글 줄은 @TITLE 로 적고 남은 줄은 SUCCESS 로 적는다.
     *   2. 전달값이 0 보다 크고 ERROR 가 한 줄도 없으면 SUCCESS 줄을 원장에 저장한다.
     *      이미 있는 행은 수량만 고치고 없는 행은 지시번호를 만들어 넣은 뒤 이력을 남긴다.
     *
     * ★검사 중 쓰는 여유 칸 — ATTRIBUTE10 날짜 여덟 자리 · ATTRIBUTE11 계획 기준일
     *   ATTRIBUTE12 운송경로 · ATTRIBUTE13 확정일. AS-IS 와 같은 자리를 쓴다.
     * ★AS-IS 는 저장 구간만 트랜잭션으로 묶고 검사 구간은 묶지 않는다.
     *   검사 중 형 변환이 어긋나면 AS-IS 는 오류를 그대로 화면에 올린다 —
     *   TO-BE 는 결과코드 'F' 와 메시지로 돌려준다.
     * ★수량 칸은 소수점이 있으면 어긋난 줄로 본다(화면 입력은 소수 셋째 자리까지 받는다).
     *   원문 그대로 두고 보고서에 올린다.
     * ★원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD
    (
        P_MODE                  IN  NUMBER
      , P_CREATED_BY            IN  VARCHAR2
      -- 2026.10.20 AJS 서버 공통 업로드 호출 형태(모드 · 작성자 · 화면 ID · 시트 이름 · 결과 커서 1개)에 맞춤 (START)
      -- , O_RC1                   OUT SYS_REFCURSOR
      -- , O_RC2                   OUT SYS_REFCURSOR
      , P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SSP0022'
      , P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Shipment Request(Electrode)'
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
      -- 2026.10.20 AJS 서버 공통 업로드 호출 형태(모드 · 작성자 · 화면 ID · 시트 이름 · 결과 커서 1개)에 맞춤 (END)
    )
    IS
        -- 2026.10.20 AJS 넘겨받은 화면 ID · 시트 이름 사용, 빈 값이면 기존 고정값 (START)
        -- C_PROGRAM_ID            CONSTANT VARCHAR2(40 CHAR) := 'SSP0022';
        -- C_SHEET_NAME            CONSTANT VARCHAR2(40 CHAR) := 'Shipment Request(Electrode)';
        C_PROGRAM_ID            CONSTANT VARCHAR2(40 CHAR) := NVL(P_PROGRAM_ID, 'SSP0022');
        C_SHEET_NAME            CONSTANT VARCHAR2(40 CHAR) := NVL(P_SHEET_NAME, 'Shipment Request(Electrode)');
        -- 2026.10.20 AJS 넘겨받은 화면 ID · 시트 이름 사용, 빈 값이면 기존 고정값 (END)
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        V_CREATION_DATE         TIMESTAMP;
        V_COUNT                 PLS_INTEGER := 0;
        V_CNT                   PLS_INTEGER := 0;
        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0022_EXCEL;

        DELETE FROM GT_0022_SAVE_REQ;
        DELETE FROM GT_0022_SAVE_REQ_H;

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
                    OR TRIM(ATTRIBUTE7) IS NULL OR TRIM(ATTRIBUTE8) IS NULL OR TRIM(ATTRIBUTE9) IS NULL );

            V_LOG_TYPE    := '4';
            V_LOG_MESSAGE := '########## ERROR Invalid Column Data ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* DIVISION 값 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Division.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_DIVISION SA
                                WHERE SA.VALID_YN = 'Y'
                                  AND SA.DIVISION_ID = A.ATTRIBUTE1
                               UNION
                               SELECT 1
                                 FROM SCM_MST_DIVISION SB
                                WHERE SB.VALID_YN = 'Y'
                                  AND SB.DIVISION_NAME = A.ATTRIBUTE1);

            V_LOG_TYPE    := '5';
            V_LOG_MESSAGE := '########## Invalid Division ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* company 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Company.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_SITE SA
                                    , SCM_ADM_LOOKUP_MASTER_DETAIL SB
                                WHERE SA.COMPANY_ID = SB.SEGMENT1
                                  AND SB.LOOKUP_TYPE = 'COMPANY_DESC'
                                  AND SA.SITE_TYPE = 'PLANT'
                                  AND SA.OPERATION_GROUP = 'E'
                                  AND SA.DIVISION_ID = (SELECT SC.DIVISION_ID
                                                          FROM SCM_MST_SITE SC
                                                         WHERE SC.SCM_SITE_ID = A.ATTRIBUTE3   /* FROM SITE */
                                                           AND SC.VALID_YN = 'Y'
                                                           AND SC.SITE_TYPE = 'PLANT'));       /* DIVISION */

            V_LOG_TYPE    := '6';
            V_LOG_MESSAGE := '########## Invalid Company ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* from site 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid From Site.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_SITE SA
                                WHERE SA.SITE_TYPE = 'PLANT'
                                  AND SA.OPERATION_GROUP = 'E'
                                  AND SA.DIVISION_ID = (SELECT SC.DIVISION_ID
                                                          FROM SCM_MST_SITE SC
                                                         WHERE SC.SCM_SITE_ID = A.ATTRIBUTE3   /* FROM SITE */
                                                           AND SC.VALID_YN = 'Y'
                                                           AND SC.SITE_TYPE = 'PLANT')
                                  AND SA.SCM_SITE_ID = A.ATTRIBUTE3);                          /* FROM SITE */

            V_LOG_TYPE    := '7';
            V_LOG_MESSAGE := '########## Invalid From site ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* to site 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid To Site.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_SITE SA
                                WHERE SA.SITE_TYPE = 'PLANT'
                                  AND SA.OPERATION_GROUP = 'A'
                                  AND SA.DIVISION_ID = (SELECT SC.DIVISION_ID
                                                          FROM SCM_MST_SITE SC
                                                         WHERE SC.SCM_SITE_ID = A.ATTRIBUTE4   /* TO SITE */
                                                           AND SC.VALID_YN = 'Y'
                                                           AND SC.SITE_TYPE = 'PLANT')
                                  AND SA.SCM_SITE_ID = A.ATTRIBUTE4);                          /* TO SITE */

            V_LOG_TYPE    := '8';
            V_LOG_MESSAGE := '########## Invalid To site ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* ELECTRODE_SHIP_FROM_TO 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Please Check ELECTRODE_SHIP_FROM_TO Site, Div and Company Code.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                WHERE SA.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
                                  AND SA.SEGMENT5 = (SELECT SC.DIVISION_ID
                                                       FROM SCM_MST_SITE SC
                                                      WHERE SC.SCM_SITE_ID = A.ATTRIBUTE4      /* TO SITE */
                                                        AND SC.VALID_YN = 'Y'
                                                        AND SC.SITE_TYPE = 'PLANT')
                                  AND SA.SEGMENT4 = A.ATTRIBUTE2                               /* COMPANY */
                                  AND SA.SEGMENT3 = A.ATTRIBUTE3
                                  AND SA.ATTRIBUTE1 = A.ATTRIBUTE4);

            V_LOG_TYPE    := '9';
            V_LOG_MESSAGE := '########## Please Check ELECTRODE_SHIP_FROM_TO Site, Div and Company Code. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* Trans Mode 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Trans Mode.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCP_MST_BOD_N_V SA
                                WHERE SA.DIVISION_ID = (SELECT SC.DIVISION_ID
                                                          FROM SCM_MST_SITE SC
                                                         WHERE SC.SCM_SITE_ID = A.ATTRIBUTE3   /* FROM SITE */
                                                           AND SC.VALID_YN = 'Y'
                                                           AND SC.SITE_TYPE = 'PLANT')
                                  AND SA.FROM_SITE = A.ATTRIBUTE3                              /* FROM SITE */
                                  AND SA.TO_SITE = A.ATTRIBUTE4                                /* TO SITE */
                                  AND SA.TRANSPORT_MODE = A.ATTRIBUTE8                         /* TRANS MODE */
                                  AND SA.SSP_INCOTERMS = A.ATTRIBUTE9                          /* INCOTERMS */
                                  AND SA.FROM_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                  AND SA.TO_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD'));

            V_LOG_TYPE    := '10';
            V_LOG_MESSAGE := '########## Invalid Trans Mode ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* Incoterms 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Incoterms.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCP_MST_BOD_N_V SA
                                WHERE SA.DIVISION_ID = (SELECT SC.DIVISION_ID
                                                          FROM SCM_MST_SITE SC
                                                         WHERE SC.SCM_SITE_ID = A.ATTRIBUTE3   /* FROM SITE */
                                                           AND SC.VALID_YN = 'Y'
                                                           AND SC.SITE_TYPE = 'PLANT')
                                  AND SA.FROM_SITE = A.ATTRIBUTE3                              /* FROM SITE */
                                  AND SA.TO_SITE = A.ATTRIBUTE4                                /* TO SITE */
                                  /* 2020.09.21   KIMYONGHO      SSP INCOTERMS 변경 작업 */
                                  AND SA.TRANSPORT_MODE = A.ATTRIBUTE8                         /* TRANS MODE */
                                  AND SA.SSP_INCOTERMS = A.ATTRIBUTE9                          /* INCOTERMS */
                                  AND SA.FROM_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                  AND SA.TO_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD'));

            V_LOG_TYPE    := '11';
            V_LOG_MESSAGE := '########## Invalid Incoterms ##########';
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
                  OR NVL(LENGTH(SUBSTR(REPLACE(REPLACE(ATTRIBUTE6, ' '), '-'), 1, 8)), 0) != 8 );   /* YYYYMMDD */

            /* 날짜 변환 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET ATTRIBUTE10 = SUBSTR(REPLACE(REPLACE(ATTRIBUTE6, ' '), '-'), 1, 8)
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

            /* YYYYMMDD 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid yyyyMMdd.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ( A.ATTRIBUTE10 > (SELECT MAX(TO_CHAR(TO_DATE(SA.PLAN_START_YYYYMMDD, 'YYYYMMDD') + 55, 'YYYYMMDD'))
                                        FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE SA
                                       WHERE SA.PLAN_CUTOFF_CREATE_YN = 'N'
                                         AND SA.CURRENT_PLAN_DATE_YN = 'Y'
                                         AND SA.COMPANY_ID = A.ATTRIBUTE2)                      /* COMPANY */
                  OR A.ATTRIBUTE10 < (SELECT MAX(SB.PLAN_START_YYYYMMDD)
                                        FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE SB
                                       WHERE SB.PLAN_CUTOFF_CREATE_YN = 'N'
                                         AND SB.CURRENT_PLAN_DATE_YN = 'Y'
                                         AND SB.COMPANY_ID = A.ATTRIBUTE2) );                   /* COMPANY */

            V_LOG_TYPE    := '13';
            V_LOG_MESSAGE := '########## Invalid yyyyMMdd. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* 중복 값 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Duplication Data.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND EXISTS (SELECT 1
                             FROM (SELECT SA.ATTRIBUTE1  AS DIVISION_ID
                                        , SA.ATTRIBUTE2  AS COMPANY_ID
                                        , SA.ATTRIBUTE3  AS FROM_SITE
                                        , SA.ATTRIBUTE4  AS TO_SITE
                                        , SA.ATTRIBUTE5  AS ITEM_ID
                                        , SA.ATTRIBUTE10 AS YYYYMMDD
                                        , SA.ATTRIBUTE8  AS TRANSPORT_MODE
                                        , SA.ATTRIBUTE9  AS INCOTERMS
                                     FROM SCM_ADM_EXCEL_UPLOAD SA
                                    WHERE SA.PROGRAM_ID = C_PROGRAM_ID
                                      AND SA.SHEET_NAME = C_SHEET_NAME
                                      AND SA.CREATED_BY = P_CREATED_BY
                                      AND SA.CREATION_DATE = V_CREATION_DATE
                                      AND SA.UPLOAD_STATUS_CODE = 'UPLOAD'
                                    GROUP BY SA.PROGRAM_ID
                                           , SA.SHEET_NAME
                                           , SA.CREATION_DATE
                                           , SA.ATTRIBUTE1
                                           , SA.ATTRIBUTE2
                                           , SA.ATTRIBUTE3
                                           , SA.ATTRIBUTE4
                                           , SA.ATTRIBUTE5
                                           , SA.ATTRIBUTE10
                                           , SA.ATTRIBUTE8
                                           , SA.ATTRIBUTE9
                                   HAVING COUNT(1) > 1) IA
                            WHERE IA.DIVISION_ID = A.ATTRIBUTE1
                              AND IA.COMPANY_ID = A.ATTRIBUTE2
                              AND IA.FROM_SITE = A.ATTRIBUTE3
                              AND IA.TO_SITE = A.ATTRIBUTE4
                              AND IA.ITEM_ID = A.ATTRIBUTE5
                              AND IA.YYYYMMDD = A.ATTRIBUTE10
                              AND IA.TRANSPORT_MODE = A.ATTRIBUTE8
                              AND IA.INCOTERMS = A.ATTRIBUTE9);

            V_LOG_TYPE    := '14';
            V_LOG_MESSAGE := '########## Duplication Data. ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* QTY 값 체크 */
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

            /* ITEM 유무 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid item Data.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SSP_MST_SITE_ITEM_EE_V SA
                                WHERE SA.DIVISION_ID IN (SELECT SC.DIVISION_ID
                                                           FROM SCM_MST_SITE SC
                                                          WHERE SC.SCM_SITE_ID = A.ATTRIBUTE3  /* FROM SITE */
                                                            AND SC.VALID_YN = 'Y'
                                                            AND SC.SITE_TYPE = 'PLANT')
                                  AND A.ATTRIBUTE3 = SA.SCM_SITE_ID
                                  AND A.ATTRIBUTE5 = SA.ITEM_ID);

            V_LOG_TYPE    := '16';
            V_LOG_MESSAGE := '########## ERROR Invalid item Data ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* PLAN DATE (YYYYMMDD) 체크 */
            /* 날짜 변환 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.ATTRIBUTE11 = (SELECT MAX(SA.PLAN_START_YYYYMMDD)
                                      FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE SA
                                     WHERE SA.PLAN_CUTOFF_CREATE_YN = 'N'
                                       AND SA.CURRENT_PLAN_DATE_YN = 'Y'
                                       AND SA.COMPANY_ID = A.ATTRIBUTE2)                        /* COMPANY */
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD';

            V_LOG_TYPE    := '17';
            V_LOG_MESSAGE := '########## Invalid PLAN DATE ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* BOD_ID  체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.ATTRIBUTE12 = (SELECT IA.BOD_ID
                                      FROM (SELECT SA.BOD_ID
                                              FROM SCP_MST_BOD_N_V SA
                                             WHERE SA.FROM_SITE = A.ATTRIBUTE3
                                               AND SA.TO_SITE = A.ATTRIBUTE4
                                               /* 2020.09.21   KIMYONGHO      SSP INCOTERMS 변경 작업 */
                                               AND SA.TRANSPORT_MODE = A.ATTRIBUTE8             /* TRANS MODE */
                                               AND SA.SSP_INCOTERMS = A.ATTRIBUTE9              /* INCOTERMS */
                                               AND SA.FROM_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                               AND SA.TO_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                             ORDER BY SA.PRIORITY, SA.TO_YYYYMMDD) IA
                                     WHERE ROWNUM <= 1)
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD';

            V_LOG_TYPE    := '18';
            V_LOG_MESSAGE := '########## Invalid BOD_ID ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* BOD_ID_ITEM 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Bod item Data.'
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCP_MST_BOD_ITEM SA
                                    , SCP_MST_BOD_N_V SB
                                WHERE SB.DIVISION_ID = SA.DIVISION_ID
                                  AND SB.BOD_ID = SA.BOD_ID
                                  AND SA.DIVISION_ID = (SELECT SC.DIVISION_ID
                                                          FROM SCM_MST_SITE SC
                                                         WHERE SC.SCM_SITE_ID = A.ATTRIBUTE3   /* FROM SITE */
                                                           AND SC.VALID_YN = 'Y'
                                                           AND SC.SITE_TYPE = 'PLANT')
                                  AND SA.VALID_YN = 'Y'
                                  AND SA.BOD_ID = A.ATTRIBUTE12
                                  AND SA.ITEM_ID = A.ATTRIBUTE5);

            V_LOG_TYPE    := '19';
            V_LOG_MESSAGE := '########## ERROR Invalid Bod item Data ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* Confirm Day 체크 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.ATTRIBUTE13 = (SELECT /* 확정구간 과 Oper LT 중 큰 일수 + bod LT   기간 이후 부터 입력 가능하게 적용
                                              bod LT 는 FN_GET_SSP_ETA_DATE 함수 사용 */
                                           CASE WHEN NVL(TO_NUMBER(SC.SEGMENT5), 0) > NVL(SD.SHIP_FROZEN, 0)
                                                THEN TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                           + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(SA.DIVISION_ID, SA.BOD_ID,
                                                                  TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                                        + (NVL(TO_NUMBER(SC.SEGMENT5), 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                                                                - TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD'), 0), 'YYYYMMDD')
                                                ELSE TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                           + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(SA.DIVISION_ID, SA.BOD_ID,
                                                                  TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                                        + (NVL(SD.SHIP_FROZEN, 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                                                                - TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD'), 0), 'YYYYMMDD')
                                            END
                                      FROM SCP_MST_BOD_ITEM SA
                                         , SSP_MST_SHIP_MASTER_EE SB
                                         , SCM_ADM_LOOKUP_MASTER_DETAIL SC
                                         , SCM_MST_SITE SD
                                     WHERE SA.DIVISION_ID = SB.DIVISION_ID(+)
                                       AND SB.SCM_SITE_ID(+) = A.ATTRIBUTE3
                                       AND SA.ITEM_ID = SB.ITEM_ID(+)
                                       AND SB.DIVISION_ID = SC.SEGMENT1(+)
                                       AND SB.ELECTRODE_POST_OPER_CODE = SC.SEGMENT2(+)
                                       AND SC.LOOKUP_TYPE(+) = 'ELECTRODE_POST_OPER_CODE'
                                       AND SC.VALID_YN(+) = 'Y'
                                       AND SA.DIVISION_ID = SD.DIVISION_ID(+)
                                       AND SD.SCM_SITE_ID(+) = A.ATTRIBUTE3
                                       AND SA.VALID_YN = 'Y'
                                       AND SA.ITEM_ID = A.ATTRIBUTE5
                                       AND SA.BOD_ID = A.ATTRIBUTE12
                                       AND SA.FROM_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                       AND SA.TO_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                       AND A.ATTRIBUTE10 >=
                                           CASE WHEN NVL(TO_NUMBER(SC.SEGMENT5), 0) > NVL(SD.SHIP_FROZEN, 0)
                                                THEN TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                           + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(SA.DIVISION_ID, SA.BOD_ID,
                                                                  TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                                        + (NVL(TO_NUMBER(SC.SEGMENT5), 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                                                                - TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD'), 0), 'YYYYMMDD')
                                                ELSE TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                           + NVL(TO_DATE(FN_GET_SSP_ETA_DATE(SA.DIVISION_ID, SA.BOD_ID,
                                                                  TO_CHAR(TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD')
                                                                        + (NVL(SD.SHIP_FROZEN, 0) + 0), 'YYYYMMDD')), 'YYYYMMDD')
                                                                - TO_DATE(A.ATTRIBUTE11, 'YYYYMMDD'), 0), 'YYYYMMDD')
                                            END)
             WHERE A.PROGRAM_ID         = C_PROGRAM_ID
               AND A.SHEET_NAME         = C_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD';

            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Confirm Day.'
             WHERE PROGRAM_ID         = C_PROGRAM_ID
               AND SHEET_NAME         = C_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ATTRIBUTE13 IS NULL;

            V_LOG_TYPE    := '20';
            V_LOG_MESSAGE := '########## SUCCESS. ##########';
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
          FROM SCM_ADM_EXCEL_UPLOAD
         WHERE PROGRAM_ID         = C_PROGRAM_ID
           AND SHEET_NAME         = C_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND CREATION_DATE      = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'ERROR';

        IF P_MODE > 0 AND V_COUNT = 0 THEN

            V_LOG_TYPE    := '23';
            V_LOG_MESSAGE := '########## INSERT/UPDATE SSP0022 SHIPMENT REQUEST DATA START ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            V_LOG_TYPE    := '23-1';
            V_LOG_MESSAGE := '########## MERGE SSP0022 SHIPMENT REQUEST DATA START ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* 변경, 추가 대상 건 TEMP 생성 */
            INSERT INTO GT_0022_SAVE_REQ
                 ( ACTIVE_FLAG, FROM_COMPANY_ID, FROM_DIVISION_ID, FROM_PLANT_ID, FROM_SITE
                 , TO_COMPANY_ID, TO_DIVISION_ID, TO_PLANT_ID, TO_SITE, MODEL_ID, ITEM_ID
                 , BOD_ID, ETA_DATE, ETD_DATE, QTY, QTY_TO_PCM, QTY_TO_CELL )
            SELECT A.ACTIVE_FLAG
                 , C.COMPANY_ID                         AS FROM_COMPANY_ID
                 , B.SEGMENT2                           AS FROM_DIVISION_ID
                 , C.PLANT_ID                           AS FROM_PLANT_ID
                 , A.FROM_SITE
                 , A.COMPANY_ID                         AS TO_COMPANY_ID
                 , A.TO_DIVISION_ID
                 , A.PLANT_ID                           AS TO_PLANT_ID
                 , A.TO_SITE
                 , D.MODEL_ID
                 , A.ITEM_ID
                 , A.BOD_ID
                 , A.ETA_DATE
                 , A.ETD_DATE
                 , CEIL(A.QTY * 1)                                      AS QTY
                 , CEIL(A.QTY * NVL(D.CONVERT_TO_PCM, 1))               AS QTY_TO_PCM
                 , CEIL(A.QTY * NVL(D.CONVERT_TO_CELL, 1))              AS QTY_TO_CELL
              FROM (SELECT 'I'                          AS ACTIVE_FLAG
                         , IA.ATTRIBUTE2                AS COMPANY_ID
                         , IA.ATTRIBUTE1                AS DIVISION_ID
                         , SUBSTR(IA.ATTRIBUTE4, 1, 4)  AS PLANT_ID
                         , IA.ATTRIBUTE4                AS SCM_SITE_ID
                         , IA.ATTRIBUTE1                AS FROM_DIVISION_ID
                         , IA.ATTRIBUTE3                AS FROM_SITE
                         , IA.ATTRIBUTE1                AS TO_DIVISION_ID
                         , IA.ATTRIBUTE4                AS TO_SITE
                         , IB.MODEL_ID                  AS MODEL_ID
                         , IA.ATTRIBUTE5                AS ITEM_ID
                         , IA.ATTRIBUTE10               AS ETA_DATE
                         , FN_GET_SSP_ETD_DATE(IA.ATTRIBUTE1, IA.ATTRIBUTE12, IA.ATTRIBUTE10) AS ETD_DATE
                         , IA.ATTRIBUTE12               AS BOD_ID
                         , CEIL(TO_NUMBER(IA.ATTRIBUTE7)) AS QTY
                      FROM SCM_ADM_EXCEL_UPLOAD IA
                         , SSP_MST_SITE_ITEM_EE_V IB
                     WHERE IB.DIVISION_ID = (SELECT SC.DIVISION_ID
                                               FROM SCM_MST_SITE SC
                                              WHERE SC.SCM_SITE_ID = IA.ATTRIBUTE3   /* FROM SITE */
                                                AND SC.VALID_YN = 'Y'
                                                AND SC.SITE_TYPE = 'PLANT')
                       AND IB.SCM_SITE_ID = IA.ATTRIBUTE3
                       AND IB.ITEM_ID = IA.ATTRIBUTE5
                       AND IA.PROGRAM_ID = C_PROGRAM_ID
                       AND IA.SHEET_NAME = C_SHEET_NAME
                       AND IA.CREATED_BY = P_CREATED_BY
                       AND IA.CREATION_DATE = V_CREATION_DATE
                       AND NVL(IA.UPLOAD_STATUS_CODE, 'X') = 'SUCCESS') A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , SCM_MST_SITE C
                 , SSP_MST_SITE_ITEM_EE_V D
             WHERE B.LOOKUP_TYPE(+) = 'ELECTRODE_SHIP_FROM_TO'
               AND B.SEGMENT5(+) = A.DIVISION_ID
               AND B.SEGMENT3(+) = A.FROM_SITE
               AND B.ATTRIBUTE1(+) = A.TO_SITE
               AND B.SEGMENT2 = C.DIVISION_ID(+)
               AND A.FROM_SITE = C.SCM_SITE_ID(+)
               AND B.SEGMENT2 = D.DIVISION_ID
               AND A.FROM_SITE = D.SCM_SITE_ID
               AND A.ITEM_ID = D.ITEM_ID;

            SELECT COUNT(*)
              INTO V_CNT
              FROM GT_0022_SAVE_REQ;

            /* 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행 */

            IF V_CNT > 0 THEN

                D_EVENT_DATE := SYSDATE;

                /* 수정 */
                UPDATE SSP_ANL_SHIP_REQ_EE A
                   SET (A.QTY, A.QTY_TO_PCM, A.QTY_TO_CELL) =
                       (SELECT B.QTY
                             , B.QTY_TO_PCM
                             , B.QTY_TO_CELL
                          FROM GT_0022_SAVE_REQ B
                         WHERE B.FROM_DIVISION_ID = A.FROM_DIVISION_ID
                           AND B.FROM_SITE = A.FROM_SITE
                           AND B.FROM_PLANT_ID = A.FROM_PLANT_ID
                           AND B.TO_SITE = A.TO_SITE
                           AND B.MODEL_ID = A.MODEL_ID
                           AND B.ITEM_ID = A.ITEM_ID
                           AND B.ETA_DATE = A.ETA_DATE
                           AND B.BOD_ID = A.BOD_ID)
                     , A.LAST_UPDATED_BY = P_CREATED_BY
                     , A.LAST_UPDATE_DATE = D_EVENT_DATE
                 WHERE EXISTS (SELECT 1
                                 FROM GT_0022_SAVE_REQ B
                                WHERE B.FROM_DIVISION_ID = A.FROM_DIVISION_ID
                                  AND B.FROM_SITE = A.FROM_SITE
                                  AND B.FROM_PLANT_ID = A.FROM_PLANT_ID
                                  AND B.TO_SITE = A.TO_SITE
                                  AND B.MODEL_ID = A.MODEL_ID
                                  AND B.ITEM_ID = A.ITEM_ID
                                  AND B.ETA_DATE = A.ETA_DATE
                                  AND B.BOD_ID = A.BOD_ID);

                V_CNT := 0;   /* 저장 후 초기화 */

            END IF;
            /* UPDATE END */

            /* INSERT START */
            SELECT COUNT(*)
              INTO V_CNT
              FROM GT_0022_SAVE_REQ B
             WHERE NOT EXISTS (SELECT 1
                                 FROM SSP_ANL_SHIP_REQ_EE A
                                WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                                  AND A.FROM_SITE = B.FROM_SITE
                                  AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                                  AND A.TO_SITE = B.TO_SITE
                                  AND A.MODEL_ID = B.MODEL_ID
                                  AND A.ITEM_ID = B.ITEM_ID
                                  AND A.ETA_DATE = B.ETA_DATE
                                  AND A.BOD_ID = B.BOD_ID);

            IF V_CNT > 0 THEN

                /* INSERT 대상 건 ACTIVE FLAG 변경 */
                UPDATE GT_0022_SAVE_REQ A
                   SET A.ACTIVE_FLAG = 'I'
                 WHERE NOT EXISTS (SELECT 1
                                     FROM SSP_ANL_SHIP_REQ_EE B
                                    WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                                      AND A.FROM_SITE = B.FROM_SITE
                                      AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                                      AND A.TO_SITE = B.TO_SITE
                                      AND A.MODEL_ID = B.MODEL_ID
                                      AND A.ITEM_ID = B.ITEM_ID
                                      AND A.ETA_DATE = B.ETA_DATE
                                      AND A.BOD_ID = B.BOD_ID);

                /* 신규 REQEUST INSERT */
                INSERT INTO SSP_ANL_SHIP_REQ_EE
                     ( FROM_COMPANY_ID
                     , FROM_DIVISION_ID
                     , FROM_PLANT_ID
                     , FROM_SITE
                     , TO_COMPANY_ID
                     , TO_DIVISION_ID
                     , TO_PLANT_ID
                     , TO_SITE
                     , MODEL_ID
                     , ITEM_ID
                     , BOD_ID
                     , ETD_DATE
                     , ETA_DATE
                     , QTY
                     , QTY_TO_PCM
                     , QTY_TO_CELL
                     , SCP_PLAN_START_YYYYMMDD
                     , SCP_PLAN_TYPE
                     , SCP_PLAN_SEQ
                     , REQUEST_ID
                     , CONFIRM_ID
                     , CONFIRM_FLAG
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE )
                SELECT B.FROM_COMPANY_ID
                     , B.FROM_DIVISION_ID
                     , B.FROM_PLANT_ID
                     , B.FROM_SITE
                     , B.TO_COMPANY_ID
                     , B.TO_DIVISION_ID
                     , B.TO_PLANT_ID
                     , B.TO_SITE
                     , B.MODEL_ID
                     , B.ITEM_ID
                     , B.BOD_ID
                     , FN_GET_SSP_ETD_DATE(B.TO_DIVISION_ID, B.BOD_ID, B.ETA_DATE) AS ETD_DATE
                     , B.ETA_DATE
                     , B.QTY
                     , B.QTY_TO_PCM                     AS QTY_TO_PCM
                     , B.QTY_TO_CELL                    AS QTY_TO_CELL
                     , NULL                             AS SCP_PLAN_START_YYYYMMDD
                     , NULL                             AS SCP_PLAN_TYPE
                     , NULL                             AS SCP_PLAN_SEQ
                     , ('R' || TO_CHAR(SYSDATE, 'YYYYMMDD')
                            || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_REQ_EE_ID.NEXTVAL), -6)) AS REQUEST_ID
                     , NULL                             AS CONFIRM_ID
                     , 'N'                              AS CONFIRM_FLAG
                     , P_CREATED_BY                     AS CREATED_BY
                     , D_EVENT_DATE                     AS CREATION_DATE
                     , P_CREATED_BY                     AS LAST_UPDATED_BY
                     , D_EVENT_DATE                     AS LAST_UPDATE_DATE
                  FROM GT_0022_SAVE_REQ B
                 WHERE NOT EXISTS (SELECT 1
                                     FROM SSP_ANL_SHIP_REQ_EE A
                                    WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                                      AND A.FROM_SITE = B.FROM_SITE
                                      AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                                      AND A.TO_SITE = B.TO_SITE
                                      AND A.MODEL_ID = B.MODEL_ID
                                      AND A.ITEM_ID = B.ITEM_ID
                                      AND A.ETA_DATE = B.ETA_DATE
                                      AND A.BOD_ID = B.BOD_ID);

                V_CNT := 0;   /* 저장 후 초기화 */

            END IF;

            /* HISTORY 대상 건 TEMP 생성 */
            INSERT INTO GT_0022_SAVE_REQ_H
                 ( HISTORY_SEQ, ACTIVE_FLAG, FROM_COMPANY_ID, FROM_DIVISION_ID, FROM_PLANT_ID
                 , FROM_SITE, TO_COMPANY_ID, TO_DIVISION_ID, TO_PLANT_ID, TO_SITE
                 , MODEL_ID, ITEM_ID, BOD_ID, ETD_DATE, ETA_DATE
                 , QTY, QTY_TO_PCM, QTY_TO_CELL
                 , SCP_PLAN_START_YYYYMMDD, SCP_PLAN_TYPE, SCP_PLAN_SEQ
                 , REQUEST_ID, CONFIRM_ID, CONFIRM_FLAG
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , HISTORY_CREATION_DATE )
            SELECT SEQ1_SSP_ANL_SHIP_REQ_EE_H.NEXTVAL   AS HISTORY_SEQ
                 , A.ACTIVE_FLAG
                 , A.FROM_COMPANY_ID
                 , A.FROM_DIVISION_ID
                 , A.FROM_PLANT_ID
                 , A.FROM_SITE
                 , A.TO_COMPANY_ID
                 , A.TO_DIVISION_ID
                 , A.TO_PLANT_ID
                 , A.TO_SITE
                 , A.MODEL_ID
                 , A.ITEM_ID
                 , A.BOD_ID
                 , A.ETD_DATE
                 , A.ETA_DATE
                 , A.QTY
                 , A.QTY_TO_PCM
                 , A.QTY_TO_CELL
                 , A.SCP_PLAN_START_YYYYMMDD
                 , A.SCP_PLAN_TYPE
                 , A.SCP_PLAN_SEQ
                 , A.REQUEST_ID
                 , A.CONFIRM_ID
                 , A.CONFIRM_FLAG
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , A.LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
                 , A.HISTORY_CREATION_DATE
              FROM (SELECT B.ACTIVE_FLAG
                         , A.FROM_COMPANY_ID
                         , A.FROM_DIVISION_ID
                         , A.FROM_PLANT_ID
                         , A.FROM_SITE
                         , A.TO_COMPANY_ID
                         , A.TO_DIVISION_ID
                         , A.TO_PLANT_ID
                         , A.TO_SITE
                         , A.MODEL_ID
                         , A.ITEM_ID
                         , A.BOD_ID
                         , A.ETD_DATE
                         , A.ETA_DATE
                         , A.QTY
                         , A.QTY_TO_PCM
                         , A.QTY_TO_CELL
                         , A.SCP_PLAN_START_YYYYMMDD
                         , A.SCP_PLAN_TYPE
                         , A.SCP_PLAN_SEQ
                         , A.REQUEST_ID
                         , A.CONFIRM_ID
                         , A.CONFIRM_FLAG
                         , A.CREATED_BY
                         , A.CREATION_DATE
                         , A.LAST_UPDATED_BY
                         , A.LAST_UPDATE_DATE
                         , SYSDATE                      AS HISTORY_CREATION_DATE
                      FROM SSP_ANL_SHIP_REQ_EE A
                         , GT_0022_SAVE_REQ B
                     WHERE A.FROM_DIVISION_ID = B.FROM_DIVISION_ID
                       AND A.FROM_SITE = B.FROM_SITE
                       AND A.FROM_PLANT_ID = B.FROM_PLANT_ID
                       AND A.TO_SITE = B.TO_SITE
                       AND A.MODEL_ID = B.MODEL_ID
                       AND A.ITEM_ID = B.ITEM_ID
                       AND A.ETA_DATE = B.ETA_DATE
                       AND A.BOD_ID = B.BOD_ID) A;

            /* HISTORY 입력 */
            INSERT INTO SSP_ANL_SHIP_REQ_EE_H
                 ( HISTORY_SEQ
                 , TRANS_TYPE
                 , FROM_COMPANY_ID
                 , FROM_DIVISION_ID
                 , FROM_PLANT_ID
                 , FROM_SITE
                 , TO_COMPANY_ID
                 , TO_DIVISION_ID
                 , TO_PLANT_ID
                 , TO_SITE
                 , MODEL_ID
                 , ITEM_ID
                 , BOD_ID
                 , ETD_DATE
                 , ETA_DATE
                 , QTY
                 , QTY_TO_PCM
                 , QTY_TO_CELL
                 , SCP_PLAN_START_YYYYMMDD
                 , SCP_PLAN_TYPE
                 , SCP_PLAN_SEQ
                 , REQUEST_ID
                 , CONFIRM_ID
                 , CONFIRM_FLAG
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , HISTORY_CREATION_DATE )
            SELECT HISTORY_SEQ
                 , ACTIVE_FLAG
                 , FROM_COMPANY_ID
                 , FROM_DIVISION_ID
                 , FROM_PLANT_ID
                 , FROM_SITE
                 , TO_COMPANY_ID
                 , TO_DIVISION_ID
                 , TO_PLANT_ID
                 , TO_SITE
                 , MODEL_ID
                 , ITEM_ID
                 , BOD_ID
                 , ETD_DATE
                 , ETA_DATE
                 , ROUND(QTY, 0)                        AS QTY
                 , ROUND(QTY_TO_PCM, 0)                 AS QTY_TO_PCM
                 , ROUND(QTY_TO_CELL, 0)                AS QTY_TO_CELL
                 , SCP_PLAN_START_YYYYMMDD
                 , SCP_PLAN_TYPE
                 , SCP_PLAN_SEQ
                 , REQUEST_ID
                 , CONFIRM_ID
                 , CONFIRM_FLAG
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , HISTORY_CREATION_DATE
              FROM GT_0022_SAVE_REQ_H;

            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            V_LOG_TYPE    := '23-1';
            V_LOG_MESSAGE := '########## MERGE SSP0022 SHIPMENT REQUEST DATA END ##########';
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

        /* 2020.10.21  KIMYONGHO           LOG 이력 START - END 짝이 안맞아서 표준 변경 작업 */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드 반환 */
        -- 2026.10.20 AJS 결과 커서 두 개를 하나로 (START)
        -- OPEN O_RC1 FOR
        --     SELECT 'S' AS RESULT_CODE, CAST(NULL AS VARCHAR2(4000 CHAR)) AS MSG FROM DUAL;
        -- OPEN O_RC2 FOR
        --     SELECT CAST(NULL AS VARCHAR2(4000 CHAR)) AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'                                AS RESULT_CODE
                 , CAST(NULL AS VARCHAR2(4000 CHAR))  AS MSG
                 , CAST(NULL AS VARCHAR2(4000 CHAR))  AS ERR_MESSAGE
              FROM DUAL;
        -- 2026.10.20 AJS 결과 커서 두 개를 하나로 (END)

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0022_EXCEL;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, errror 메시지 반환 */
            -- 2026.10.20 AJS 결과 커서 두 개를 하나로 (START)
            -- OPEN O_RC1 FOR
            --     SELECT 'F' AS RESULT_CODE, V_ERR_MESSAGE AS MSG FROM DUAL;
            -- OPEN O_RC2 FOR
            --     SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                                AS RESULT_CODE
                     , V_ERR_MESSAGE                                      AS MSG
                     , '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL;
            -- 2026.10.20 AJS 결과 커서 두 개를 하나로 (END)

    END P_SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD;

END PKG_SSP0022;
/

PACKAGE BODY PKG_SSP0023_CHK
IS
/*
 * Program ID   : PKG_SSP0023_CHK
 * Description  : SSP0023 Shipment Plan(Electrode) 화면 프로시저 패키지
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

    PROCEDURE P_SSP0023_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
       ,P_END_YYYYMMDD          IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/****************************************************************************************************
* Program ID  : SSP0023_GET_SHEET_CALENDAR_3SPAN
* Description : SSP 칼렌더 생성위한 프로시저
* Usage       : exec SSP0023_GET_SHEET_CALENDAR_3SPAN
* Parameter   : @p_start_yyyymmdd='2017-12-25'
*               @p_end_yyyymmdd='20180130'
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description
*--------------------------------------------------------------------------------------------------
* 2020/05/20  khj79       [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
* 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
****************************************************************************************************/
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

    END P_SSP0023_GET_SHEET_CALENDAR_3SPAN;

    PROCEDURE P_SSP0023_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_CONFIRM_ID            IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
       ,O_RC3                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0023_GET_SHIPMENT_STATUS
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/05/20   kh79           [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
  ex) EXEC SSP0023_GET_SHIPMENT_STATUS @p_division_id='40^40^40^40', @p_confirm_id='C20181001068349^C20181005074232^C20181001068367^C20181008076327'
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
    BEGIN

        OPEN O_RC1 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, '^')))
               AND CONFIRM_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(P_CONFIRM_ID, '^')))
               AND SHIPMENT_STATUS <> 'C';

        OPEN O_RC2 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, '^')))
               AND CONFIRM_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(P_CONFIRM_ID, '^')))
               AND QTY = 0;

        OPEN O_RC3 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, '^')))
               AND CONFIRM_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(P_CONFIRM_ID, '^')))
               AND ERP_STATUS = 'C';

    END P_SSP0023_GET_SHIPMENT_STATUS;

    PROCEDURE P_SSP0023_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_ERP_SO_NO             IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0023_GET_ERP_SO_NO_CNT
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/05/20   kh79           [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
 * 2024/06/04   jilee          UI 수량 표기 안되는 정보에 대한 제외 처리
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
    BEGIN

        OPEN O_RC1 FOR
            SELECT COUNT(*) AS CNT
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID = P_DIVISION_ID
               AND ERP_SO_NO = P_ERP_SO_NO
               AND QTY <> 0;

    END P_SSP0023_GET_ERP_SO_NO_CNT;

    PROCEDURE P_SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Plan Change 작성중 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/05/20   kh79           [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_LAST_UPDATE_DATE  DATE;
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150) := 'PKG_SSP0023_CHK.P_SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING';
        V_LOG_TYPE          VARCHAR2(30);                                       /* START/END/ERROR/... */
        N_LOG_COUNT         NUMBER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000);
        V_DESCRIPTION       VARCHAR2(500);
        D_EVENT_DATE        DATE;
        V_ERR_MSG           VARCHAR2(4000);
        V_ERR_CODE          NUMBER;
    BEGIN

        V_LAST_UPDATE_DATE := SYSDATE;

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := V_LAST_UPDATE_DATE;                                     /* [dbo].[FN_MULTY_TIME](@p_time_zone); */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
           SET VALID_YN = 'N'
             , LAST_UPDATED_BY = P_USER_ID
             , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;

        UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
           SET VALID_YN = 'N'
             , LAST_UPDATED_BY = P_USER_ID
             , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE
              FROM DUAL;

        OPEN O_RC2 FOR
            SELECT NULL AS ERROR_MESSAGE
              FROM DUAL
             WHERE 1 = 2;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_MSG := SQLERRM;
            V_ERR_CODE := SQLCODE;

            INSERT INTO SCM_SYS_LOG_BATCH
            (
                PROGRAM_NAME
              , LOG_TYPE
              , LOG_COUNT
              , LOG_MESSAGE
              , DESCRIPTION
              , EVENT_DATE
              , CREATION_DATE
              , CREATED_BY
              , LAST_UPDATE_DATE
              , LAST_UPDATED_BY
            )
            VALUES
            (
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MSG
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE
                  FROM DUAL;

            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MSG AS ERROR_MESSAGE
                  FROM DUAL;

    END P_SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING;

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode)
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-04-28   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2024/05/10   hsbang          확정구간 조회 일수(CONFIRM_DAY)를 펑션 FN_GET_ANL_SHIP_FROZEN_DAY_CNT] 에서 가져오도록 반영
 * 2025/12/11   chkim.68        E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_FROM_YYYYMMDD         VARCHAR2(8);
        V_TO_YYYYMMDD           VARCHAR2(8);
        V_CNT_USR_MEASURE       NUMBER := 0;
        V_APP_TYPE              VARCHAR2(8) := 'SSP';
        V_FROZEN_YYYYMMDD       VARCHAR2(8);
        V_PLAN_END_YYYYMMDD     VARCHAR2(8);
        V_RESULT_START_YYYYMMDD VARCHAR2(8);
        V_RESULT_END_YYYYMMDD   VARCHAR2(8);
        V_QRY_SUM               CLOB;
        V_EXEC                  CLOB;
    BEGIN

        V_FROM_YYYYMMDD := P_FROM_YYYYMMDD;
        V_TO_YYYYMMDD := P_TO_YYYYMMDD;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID = P_USER_ID;

        /* Cutoff 용 이전 version */
        V_FROZEN_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

        /* 계획 구간 Start End 일자 (plan_start_yyyymmdd-1 ~ 8주) */
        V_PLAN_END_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD');

        /* 실적구간 Start End 일자 (plan_start_yyyymmdd-1의 전주월요일  ~ 계획구간 start일자-1) */
        /* 원문은 여러 행이 나오면 마지막 값을 대입하므로 MAX 로 옮긴다(달력 한 주의 월요일은 1건) */
        SELECT MAX(A.BASIS_YYYYMMDD)
          INTO V_RESULT_START_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.ISO_YYYYWW = (SELECT MIN(ISO_YYYYWW)
                                 FROM SCM_SYS_CALENDAR_M
                                WHERE BASIS_YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD')
                                  AND BASIS_YYYYMMDD <= P_PLAN_START_YYYYMMDD)
           AND A.DAYOFWEEK = 'MON';

        V_RESULT_END_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

        /********************************************************************************
        * 임시테이블만들기
        ********************************************************************************/
        DELETE FROM GT_0023_TITLESET;
        DELETE FROM GT_0023_BOH_CUTOFF;
        DELETE FROM GT_0023_PLAN_ITEM;
        DELETE FROM GT_0023_ROWDATA;
        DELETE FROM GT_0023_SIM;
        DELETE FROM GT_0023_CONFIRM;
        DELETE FROM GT_0023_RESULT;
        DELETE FROM GT_0023_PIVOT;

        /* 사용자 MEASURE 설정 정보 */
        INSERT INTO GT_0023_TITLESET
        (
            COLUMN_NAME
        )
        SELECT COLUMN_NAME
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID = P_USER_ID;

        /* CUTOFF DATA */
        INSERT INTO GT_0023_BOH_CUTOFF
        (
            COMPANY_ID
          , DIVISION_ID
          , PLANT_ID
          , SCM_SITE_ID
          , MODEL_ID
          , ITEM_ID
          , TOT_BOH_QTY
          , JR_BOH_QTY
          , PC_BOH_QTY
          , TOT_BOH_QTY_PCM
          , JR_BOH_QTY_PCM
          , PC_BOH_QTY_PCM
          , TOT_BOH_QTY_CELL
          , JR_BOH_QTY_CELL
          , PC_BOH_QTY_CELL
          , CUTOFF_DATE
        )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.MODEL_ID
             , A.ITEM_ID
             , NVL(A.TOT_BOH_QTY, 0) AS TOT_BOH_QTY
             , NVL(A.JR_BOH_QTY, 0) AS JR_BOH_QTY
             , NVL(A.PC_BOH_QTY, 0) AS PC_BOH_QTY
             , NVL(A.TOT_BOH_QTY_TO_PCM, 0) AS TOT_BOH_QTY_PCM
             , NVL(A.JR_BOH_QTY_TO_PCM, 0) AS JR_BOH_QTY_PCM
             , NVL(A.PC_BOH_QTY_TO_PCM, 0) AS PC_BOH_QTY_PCM
             , NVL(A.TOT_BOH_QTY_TO_CELL, 0) AS TOT_BOH_QTY_CELL
             , NVL(A.JR_BOH_QTY_TO_CELL, 0) AS JR_BOH_QTY_CELL
             , NVL(A.PC_BOH_QTY_TO_CELL, 0) AS PC_BOH_QTY_CELL
             , A.CUTOFF_DATE
          FROM SSP_ANL_BOH_CUTOFF_EE A
         WHERE A.MEASURE_TYPE = 'P'
           AND A.CUTOFF_DATE = P_PLAN_START_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.COMPANY_ID = P_COMPANY_ID
           AND (TRIM(P_ITEM_ID) IS NULL
            OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                               FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
           AND (TRIM(P_MODEL_ID) IS NULL
            OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))));

        /* 조회 기준 데이터 */
        INSERT INTO GT_0023_PLAN_ITEM
        (
            COMPANY_ID
          , DIVISION_ID
          , PLANT_ID
          , SCM_SITE_ID
          , MODEL_ID
          , ITEM_ID
        )
        SELECT DISTINCT A.COMPANY_ID
             , A.DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.MODEL_ID
             , A.ITEM_ID
          FROM SSP_ANL_SHIP_PLAN_EE A
             , SSP_MST_MODEL_USER B
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.FROM_SITE(+) = A.SCM_SITE_ID
           AND B.ITEM_ID(+) = A.ITEM_ID
           AND B.VALID_YN(+) = 'Y'
           AND A.MEASURE_TYPE = 'P'
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.COMPANY_ID = P_COMPANY_ID
           AND (P_NON_CHK = 'Y'
            OR B.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                               FROM DUAL
                             UNION
                             SELECT CASE WHEN P_DELEGATEE_CHK = 'Y' THEN SA.USER_ID ELSE 'X' END
                               FROM SSP_MST_DELEGATE SA
                              WHERE SA.VALID_YN = 'Y'
                                AND SA.DELEGATEE_ID = P_USER_ID
                              GROUP BY SA.USER_ID)
            OR B.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
            OR B.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END);

        IF P_REAL_FLAG = 'Y' THEN                                               /* 현재 기준 조회 */

            /*--////////////////////////////////////////////////////////////////////////////////--*/
            /*--//2. DATA ROW DATA															//--*/
            /*--////////////////////////////////////////////////////////////////////////////////--*/
            INSERT INTO GT_0023_ROWDATA
            (
                DIVISION_ID
              , PLANT_ID
              , COMPANY_ID
              , SCM_SITE_ID
              , ELECTRODE_POST_OPER_LT
              , ELECTRODE_TYPE
              , MODEL_ID
              , ITEM_ID
              , FROM_SITE
              , BOD_ID
              , MEASURE
              , YYYYMMDD
              , SEQ
              , QTY
              , QTY_TO_PCM
              , QTY_TO_CELL
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
            )
            SELECT XA.DIVISION_ID
                 , XA.PLANT_ID
                 , XA.COMPANY_ID
                 , XA.SCM_SITE_ID
                 , XA.ELECTRODE_POST_OPER_LT
                 , XA.ELECTRODE_TYPE
                 , XA.MODEL_ID
                 , XA.ITEM_ID
                 , XA.FROM_SITE
                 , XA.BOD_ID
                 , XA.MEASURE
                 , XA.YYYYMMDD
                 , XA.SEQ
                 , SUM(CAST(XA.QTY AS NUMBER(30, 3))) AS QTY                    /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                 , SUM(XA.QTY_TO_PCM) AS QTY_TO_PCM
                 , SUM(XA.QTY_TO_CELL) AS QTY_TO_CELL
                 , XA.LAST_UPDATED_BY
                 , XA.LAST_UPDATE_DATE
              FROM (/* P_SHIP_REQ_ETD Measure 추가 */
                    SELECT A.DIVISION_ID AS DIVISION_ID
                         , A.PLANT_ID AS PLANT_ID
                         , A.COMPANY_ID AS COMPANY_ID
                         , A.SCM_SITE_ID AS SCM_SITE_ID
                         , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                         , NVL(C.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                         , A.MODEL_ID AS MODEL_ID
                         , B.ITEM_ID AS ITEM_ID
                         , NVL(A.SCM_SITE_ID, '-') AS FROM_SITE
                         , NVL(B.BOD_ID, '-') AS BOD_ID
                         , 'P_SHIP_REQ_ETD' AS MEASURE
                         , B.ETD_DATE AS YYYYMMDD
                         , 3 AS SEQ
                         , NVL(B.QTY, 0) AS QTY
                         , NVL(B.QTY_TO_PCM, 0) AS QTY_TO_PCM
                         , NVL(B.QTY_TO_CELL, 0) AS QTY_TO_CELL
                         , B.LAST_UPDATED_BY AS LAST_UPDATED_BY
                         , B.LAST_UPDATE_DATE AS LAST_UPDATE_DATE
                      FROM GT_0023_PLAN_ITEM A
                         , SSP_ANL_SHIP_REQ_EE B
                         , SSP_MST_SITE_ITEM_EE_V C
                     WHERE B.FROM_DIVISION_ID = A.DIVISION_ID
                       AND B.FROM_SITE = A.SCM_SITE_ID
                       AND B.ITEM_ID = A.ITEM_ID
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND C.SCM_SITE_ID = A.SCM_SITE_ID
                       AND C.ITEM_ID = A.ITEM_ID
                       AND C.DIVISION_ID = P_DIVISION_ID
                       AND C.COMPANY_ID = P_COMPANY_ID
                       AND B.ETD_DATE >= P_FROM_YYYYMMDD
                       AND B.ETD_DATE <= P_TO_YYYYMMDD
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                       AND (TRIM(P_MODEL_ID) IS NULL
                        OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                       AND (TRIM(P_NICK_NAME) IS NULL
                        OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                     FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                    UNION ALL
                    /* C_SCP_PROD_PLAN,P_SCP_SHIP_PLAN_ETD,P_SHIP_PLAN_SIMU_ETD',C_FP_NPC_ASSY_PLAN,C_FP_COATER_PLAN Measure 추가 */
                    SELECT B.DIVISION_ID
                         , B.PLANT_ID AS PLANT_ID
                         , B.COMPANY_ID AS COMPANY_ID
                         , B.SCM_SITE_ID AS SCM_SITE_ID
                         , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                         , NVL(B.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                         , B.MODEL_ID AS MODEL_ID
                         , B.ITEM_ID AS ITEM_ID
                         , NVL(B.SCM_SITE_ID, '-') AS FROM_SITE
                         , NVL(B.BOD_ID, '-') AS BOD_ID
                         , B.MEASURE AS MEASURE
                         , B.YYYYMMDD AS YYYYMMDD
                         , CASE WHEN B.MEASURE = 'P_SCP_PROD_PLAN' THEN 1
                                WHEN B.MEASURE = 'P_SCP_SHIP_PLAN_ETD' THEN 2
                                WHEN B.MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN 4
                                WHEN B.MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN 6
                                WHEN B.MEASURE = 'P_FP_COATER_PLAN' THEN 7
                           END AS SEQ
                         , NVL(B.QTY, 0) AS QTY
                         , NVL(B.QTY_TO_PCM, 0) AS QTY_TO_PCM
                         , NVL(B.QTY_TO_CELL, 0) AS QTY_TO_CELL
                         , '-' AS LAST_UPDATED_BY
                         , B.LAST_UPDATE_DATE AS LAST_UPDATE_DATE
                      FROM GT_0023_PLAN_ITEM A
                         , SSP_ANL_SHIP_PLAN_EE B
                         , SSP_MST_SITE_ITEM_EE_V C
                     WHERE B.DIVISION_ID = A.DIVISION_ID
                       AND B.ITEM_ID = A.ITEM_ID
                       AND B.SCM_SITE_ID = A.SCM_SITE_ID
                       AND B.COMPANY_ID = A.COMPANY_ID
                       AND C.DIVISION_ID = B.DIVISION_ID
                       AND C.ITEM_ID = B.ITEM_ID
                       AND C.SCM_SITE_ID = B.SCM_SITE_ID
                       AND B.MEASURE_TYPE = 'P'
                       AND B.DIVISION_ID = P_DIVISION_ID
                       AND B.COMPANY_ID = P_COMPANY_ID
                       AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND B.YYYYMMDD >= P_FROM_YYYYMMDD
                       AND B.YYYYMMDD <= P_TO_YYYYMMDD
                       AND B.MEASURE IN ('P_SCP_PROD_PLAN', 'P_SCP_SHIP_PLAN_ETD', 'P_SHIP_PLAN_SIMU_ETD', 'P_FP_NPC_ASSY_PLAN', 'P_FP_COATER_PLAN')
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR B.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR B.ITEM_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                       AND (TRIM(P_MODEL_ID) IS NULL
                        OR B.MODEL_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                       AND (TRIM(P_NICK_NAME) IS NULL
                        OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                     FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                    UNION ALL
                    /* C_FP_COATER_POST_PLAN Measure 추가 */
                    /* ELECTRODE_POST_OPER_LT 더한 날짜가 조회 된다. */
                    SELECT B.DIVISION_ID
                         , B.PLANT_ID AS PLANT_ID
                         , B.COMPANY_ID AS COMPANY_ID
                         , B.SCM_SITE_ID AS SCM_SITE_ID
                         , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                         , NVL(B.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                         , B.MODEL_ID AS MODEL_ID
                         , B.ITEM_ID AS ITEM_ID
                         , NVL(B.SCM_SITE_ID, '-') AS FROM_SITE
                         , NVL(B.BOD_ID, '-') AS BOD_ID
                         , B.MEASURE AS MEASURE
                         , TO_CHAR(TO_DATE(B.YYYYMMDD, 'YYYYMMDD') + TRUNC(TO_NUMBER(NVL(C.ELECTRODE_POST_OPER_LT, '0'))), 'YYYYMMDD') AS YYYYMMDD
                         , 8 AS SEQ
                         , NVL(B.QTY, 0) AS QTY
                         , NVL(B.QTY_TO_PCM, 0) AS QTY_TO_PCM
                         , NVL(B.QTY_TO_CELL, 0) AS QTY_TO_CELL
                         , '-' AS LAST_UPDATED_BY
                         , B.LAST_UPDATE_DATE AS LAST_UPDATE_DATE
                      FROM GT_0023_PLAN_ITEM A
                         , SSP_ANL_SHIP_PLAN_EE B
                         , SSP_MST_SITE_ITEM_EE_V C
                     WHERE B.DIVISION_ID = A.DIVISION_ID
                       AND B.ITEM_ID = A.ITEM_ID
                       AND B.SCM_SITE_ID = A.SCM_SITE_ID
                       AND B.COMPANY_ID = A.COMPANY_ID
                       AND C.DIVISION_ID = B.DIVISION_ID
                       AND C.ITEM_ID = B.ITEM_ID
                       AND C.SCM_SITE_ID = B.SCM_SITE_ID
                       AND B.MEASURE_TYPE = 'P'
                       AND B.DIVISION_ID = P_DIVISION_ID
                       AND B.COMPANY_ID = P_COMPANY_ID
                       AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND B.YYYYMMDD >= P_FROM_YYYYMMDD
                       AND B.YYYYMMDD <= P_TO_YYYYMMDD
                       AND B.MEASURE = 'P_FP_COATER_POST_PLAN'
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR B.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR B.ITEM_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                       AND (TRIM(P_MODEL_ID) IS NULL
                        OR B.MODEL_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                       AND (TRIM(P_NICK_NAME) IS NULL
                        OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                     FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                    UNION ALL
                    /* P_INTRANSIT_ETA Measure 추가 */
                    SELECT IA.DIVISION_ID AS DIVISION_ID
                         , IA.PLANT_ID AS PLANT_ID
                         , IA.COMPANY_ID AS COMPANY_ID
                         , IA.SCM_SITE_ID AS SCM_SITE_ID
                         , IA.ELECTRODE_POST_OPER_LT AS ELECTRODE_POST_OPER_LT
                         , IA.ELECTRODE_TYPE AS ELECTRODE_TYPE
                         , IA.MODEL_ID AS MODEL_ID
                         , IA.ITEM_ID AS ITEM_ID
                         , IA.FROM_SITE AS FROM_SITE
                         , IA.BOD_ID AS BOD_ID
                         , 'P_INTRANSIT_ETA' AS MEASURE
                         , IA.YYYYMMDD AS YYYYMMDD
                         , 9 AS SEQ
                         , SUM(CAST(IA.QTY AS NUMBER(30, 3))) AS QTY            /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                         , SUM(IA.QTY_TO_PCM) AS QTY_TO_PCM
                         , SUM(IA.QTY_TO_CELL) AS QTY_TO_CELL
                         , '-'
                         , NULL
                      FROM (SELECT A.DIVISION_ID AS DIVISION_ID
                                 , A.PLANT_ID AS PLANT_ID
                                 , A.COMPANY_ID AS COMPANY_ID
                                 , A.SCM_SITE_ID AS SCM_SITE_ID
                                 , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                                 , NVL(C.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                                 , A.MODEL_ID AS MODEL_ID
                                 , A.ITEM_ID AS ITEM_ID
                                 , NVL(A.SCM_SITE_ID, '-') AS FROM_SITE
                                 , '-' AS BOD_ID
                                 , B.YYYYMMDD AS YYYYMMDD
                                 , B.QTY AS QTY
                                 , B.QTY * NVL(C.CONVERT_TO_PCM, 1) AS QTY_TO_PCM
                                 , B.QTY * NVL(C.CONVERT_TO_CELL, 1) AS QTY_TO_CELL
                                 , '-' AS LAST_UPDATED_BY
                                 , NULL AS LAST_UPDATE_DATE
                                 , '-' AS ETD_DATE
                                 , '-' AS ETA_DATE
                              FROM GT_0023_PLAN_ITEM A
                                 , (SELECT SA.DIVISION_ID
                                         , SA.COMPANY_ID
                                         , SA.PLANT_ID
                                         , SA.SCM_SITE_ID
                                         , XB.ITEM_ID
                                         , XB.INTRANSIT_QTY AS QTY
                                         , CASE WHEN TO_CHAR(XB.ETA_DATE, 'YYYYMMDD') < P_PLAN_START_YYYYMMDD THEN P_PLAN_START_YYYYMMDD
                                                ELSE TO_CHAR(XB.ETA_DATE, 'YYYYMMDD')
                                           END AS YYYYMMDD
                                      FROM GT_0023_INTRANSIT_CHK XB
                                         , SCP_MST_FINAL_ITEM XC
                                         , SCM_ADM_LOOKUP_MASTER_DETAIL XD      /* SEGMENT3:E_DIVISION_ID ,SEGMENT4 : E_PLANT_ID , ATTRIBUTE4 : E SCM_SITE_ID */
                                         , SCM_MST_SITE SA
                                     WHERE XC.DIVISION_ID = XB.DIVISION_ID
                                       AND XC.ITEM_ID = XB.ITEM_ID
                                       AND XC.OPERATION_GROUP = 'E'
                                       AND XD.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING'
                                       AND XD.SEGMENT1 = XB.DIVISION_ID         /* 조립 DIVISION */
                                       AND XD.SEGMENT2 = XB.PLANT_ID            /* 조립 PLANT_ID */
                                       AND SA.DIVISION_ID = XD.SEGMENT3
                                       AND SA.PLANT_ID = XD.SEGMENT4
                                       AND SA.OPERATION_GROUP = 'E') B
                                 , SSP_MST_SITE_ITEM_EE_V C
                             WHERE B.DIVISION_ID = A.DIVISION_ID
                               AND B.SCM_SITE_ID = A.SCM_SITE_ID
                               AND B.ITEM_ID = A.ITEM_ID
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND C.SCM_SITE_ID = A.SCM_SITE_ID
                               AND C.ITEM_ID = A.ITEM_ID
                               AND A.DIVISION_ID = P_DIVISION_ID
                               AND A.COMPANY_ID = P_COMPANY_ID
                               AND B.YYYYMMDD >= V_RESULT_START_YYYYMMDD
                               AND B.YYYYMMDD <= V_RESULT_END_YYYYMMDD
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                               AND (TRIM(P_MODEL_ID) IS NULL
                                OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                               AND (TRIM(P_NICK_NAME) IS NULL
                                OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                             FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                            UNION ALL
                            /* 출하 확정( @v_cutoff_plan_start_yyyymmdd ~ 전체 ) */
                            SELECT A.DIVISION_ID AS DIVISION_ID
                                 , A.PLANT_ID AS PLANT_ID
                                 , A.COMPANY_ID AS COMPANY_ID
                                 , A.SCM_SITE_ID AS SCM_SITE_ID
                                 , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                                 , NVL(C.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                                 , A.MODEL_ID AS MODEL_ID
                                 , A.ITEM_ID AS ITEM_ID
                                 , NVL(A.SCM_SITE_ID, '-') AS FROM_SITE
                                 , '-' AS BOD_ID
                                 , B.YYYYMMDD AS YYYYMMDD
                                 , B.QTY AS QTY
                                 , B.QTY * NVL(C.CONVERT_TO_PCM, 1) AS QTY_TO_PCM
                                 , B.QTY * NVL(C.CONVERT_TO_CELL, 1) AS QTY_TO_CELL
                                 , '-' AS LAST_UPDATED_BY
                                 , NULL AS LAST_UPDATE_DATE
                                 , B.ETD_DATE AS ETD_DATE
                                 , B.ETA_DATE AS ETA_DATE
                              FROM GT_0023_PLAN_ITEM A
                                 , (SELECT SA.DIVISION_ID
                                         , SA.COMPANY_ID
                                         , SA.PLANT_ID
                                         , SA.SCM_SITE_ID
                                         , XB.ITEM_ID
                                         , XB.QTY AS QTY
                                         , XB.ETA_DATE AS YYYYMMDD
                                         , XB.ETA_DATE
                                         , XB.ETD_DATE
                                      FROM SSP_ANL_SHIP_CONFIRM XB
                                         , SCM_ADM_LOOKUP_MASTER_DETAIL XD      /* SEGMENT3:E_DIVISION_ID ,SEGMENT4 : E_PLANT_ID , ATTRIBUTE4 : E SCM_SITE_ID */
                                         , SCM_MST_SITE SA
                                     WHERE XD.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING'
                                       AND XD.SEGMENT1 = XB.DIVISION_ID         /* 조립 DIVISION */
                                       AND XD.ATTRIBUTE1 = XB.TO_SITE
                                       AND SA.DIVISION_ID = XD.SEGMENT3
                                       AND SA.PLANT_ID = XD.SEGMENT4
                                       AND SA.OPERATION_GROUP = 'E'
                                       AND XB.CHANGE_TYPE = 'C'
                                       AND XB.ETA_DATE >= P_PLAN_START_YYYYMMDD
                                       AND XB.ETA_DATE <= V_PLAN_END_YYYYMMDD) B
                                 , SSP_MST_SITE_ITEM_EE_V C
                             WHERE B.DIVISION_ID = A.DIVISION_ID
                               AND B.SCM_SITE_ID = A.SCM_SITE_ID
                               AND B.ITEM_ID = A.ITEM_ID
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND C.SCM_SITE_ID = A.SCM_SITE_ID
                               AND C.ITEM_ID = A.ITEM_ID
                               AND A.DIVISION_ID = P_DIVISION_ID
                               AND A.COMPANY_ID = P_COMPANY_ID
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                               AND (TRIM(P_MODEL_ID) IS NULL
                                OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                               AND (TRIM(P_NICK_NAME) IS NULL
                                OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                             FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                            UNION ALL
                            /* 출하요청 ( 확정구간 이후 ~ ) */
                            SELECT A.DIVISION_ID AS DIVISION_ID
                                 , A.PLANT_ID AS PLANT_ID
                                 , A.COMPANY_ID AS COMPANY_ID
                                 , A.SCM_SITE_ID AS SCM_SITE_ID
                                 , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                                 , NVL(C.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                                 , A.MODEL_ID AS MODEL_ID
                                 , A.ITEM_ID AS ITEM_ID
                                 , NVL(A.SCM_SITE_ID, '-') AS FROM_SITE
                                 , '-' AS BOD_ID
                                 , B.ETD_DATE AS YYYYMMDD
                                 , B.QTY AS QTY
                                 , B.QTY * NVL(C.CONVERT_TO_PCM, 1) AS QTY_TO_PCM
                                 , B.QTY * NVL(C.CONVERT_TO_CELL, 1) AS QTY_TO_CELL
                                 , '-' AS LAST_UPDATED_BY
                                 , NULL AS LAST_UPDATE_DATE
                                 , B.ETD_DATE AS ETD_DATE
                                 , B.ETA_DATE AS ETA_DATE
                              FROM GT_0023_PLAN_ITEM A
                                 , (SELECT SA.DIVISION_ID
                                         , SA.COMPANY_ID
                                         , SA.PLANT_ID
                                         , SA.SCM_SITE_ID
                                         , XB.ITEM_ID
                                         , XB.QTY AS QTY
                                         , XB.ETA_DATE AS YYYYMMDD
                                         , XB.FROM_SITE
                                         , XB.ETA_DATE
                                         , XB.ETD_DATE
                                      FROM SSP_ANL_SHIP_REQ_EE XB
                                         , SCM_ADM_LOOKUP_MASTER_DETAIL XD      /* SEGMENT3:E_DIVISION_ID ,SEGMENT4 : E_PLANT_ID , ATTRIBUTE4 : E SCM_SITE_ID */
                                         , SCM_MST_SITE SA
                                     WHERE XD.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING'
                                       AND XD.SEGMENT1 = XB.TO_DIVISION_ID      /* 조립 DIVISION */
                                       AND XD.SEGMENT2 = XB.TO_PLANT_ID         /* 조립 PLANT_ID */
                                       AND XD.ATTRIBUTE1 = XB.TO_SITE
                                       AND SA.DIVISION_ID = XD.SEGMENT3
                                       AND SA.PLANT_ID = XD.SEGMENT4
                                       AND SA.OPERATION_GROUP = 'E'
                                       AND XB.ETA_DATE >= P_PLAN_START_YYYYMMDD  /* 시작일 부터 데이터를 조회(데이터 건수 줄이기 위해) */
                                       AND XB.ETA_DATE < V_PLAN_END_YYYYMMDD
                                       AND XB.CONFIRM_FLAG <> 'Y') B
                                 , SSP_MST_SITE_ITEM_EE_V C
                             WHERE B.DIVISION_ID = A.DIVISION_ID
                               AND B.SCM_SITE_ID = A.SCM_SITE_ID
                               AND B.ITEM_ID = A.ITEM_ID
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND C.SCM_SITE_ID = A.SCM_SITE_ID
                               AND C.ITEM_ID = A.ITEM_ID
                               AND A.DIVISION_ID = P_DIVISION_ID
                               AND A.COMPANY_ID = P_COMPANY_ID
                               /*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
                               AND B.ETA_DATE >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, A.DIVISION_ID, A.SCM_SITE_ID, P_PLAN_START_YYYYMMDD), 'YYYYMMDD')     /* cut off 시작 일부터 조회 */
                               AND B.ETA_DATE < V_PLAN_END_YYYYMMDD
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                               AND (TRIM(P_MODEL_ID) IS NULL
                                OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                               AND (TRIM(P_NICK_NAME) IS NULL
                                OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                             FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))) IA
                     GROUP BY IA.COMPANY_ID
                            , IA.DIVISION_ID
                            , IA.PLANT_ID
                            , IA.SCM_SITE_ID
                            , IA.MODEL_ID
                            , IA.ITEM_ID
                            , IA.YYYYMMDD
                            , IA.FROM_SITE
                            , IA.BOD_ID
                            , IA.ETD_DATE
                            , IA.ETA_DATE
                            , IA.ELECTRODE_TYPE
                            , IA.ELECTRODE_POST_OPER_LT
                    UNION ALL
                    /* P_SHIP_CONFIRM_ETD Measure 추가 */
                    SELECT IA.DIVISION_ID AS DIVISION_ID
                         , IA.PLANT_ID AS PLANT_ID
                         , IA.COMPANY_ID AS COMPANY_ID
                         , IA.SCM_SITE_ID AS SCM_SITE_ID
                         , IA.ELECTRODE_POST_OPER_LT AS ELECTRODE_POST_OPER_LT
                         , IA.ELECTRODE_TYPE AS ELECTRODE_TYPE
                         , IA.MODEL_ID AS MODEL_ID
                         , IA.ITEM_ID AS ITEM_ID
                         , IA.FROM_SITE AS FROM_SITE
                         , IA.BOD_ID AS BOD_ID
                         , 'P_SHIP_CONFIRM_ETD' AS MEASURE
                         , IA.YYYYMMDD AS YYYYMMDD
                         , 5 AS SEQ
                         , SUM(CAST(IA.QTY AS NUMBER(30, 3))) AS QTY            /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                         , SUM(IA.QTY_TO_PCM) AS QTY_TO_PCM
                         , SUM(IA.QTY_TO_CELL) AS QTY_TO_CELL
                         , '-'
                         , NULL
                      FROM (SELECT A.DIVISION_ID AS DIVISION_ID
                                 , A.PLANT_ID AS PLANT_ID
                                 , A.COMPANY_ID AS COMPANY_ID
                                 , A.SCM_SITE_ID AS SCM_SITE_ID
                                 , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                                 , NVL(C.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                                 , A.MODEL_ID AS MODEL_ID
                                 , A.ITEM_ID AS ITEM_ID
                                 , NVL(A.SCM_SITE_ID, '-') AS FROM_SITE
                                 , '-' AS BOD_ID
                                 , B.YYYYMMDD AS YYYYMMDD
                                 , B.QTY AS QTY
                                 , B.QTY * NVL(C.CONVERT_TO_PCM, 1) AS QTY_TO_PCM
                                 , B.QTY * NVL(C.CONVERT_TO_CELL, 1) AS QTY_TO_CELL
                                 , '-' AS LAST_UPDATED_BY
                                 , NULL AS LAST_UPDATE_DATE
                                 , '-' AS ETD_DATE
                                 , '-' AS ETA_DATE
                              FROM GT_0023_PLAN_ITEM A
                                 , SSP_DNM_SHIP_RESULT_OWMS_V B
                                 , SSP_MST_SITE_ITEM_EE_V C
                             WHERE B.DIVISION_ID = A.DIVISION_ID
                               AND B.FROM_SITE = A.SCM_SITE_ID
                               AND B.ITEM_ID = A.ITEM_ID
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND C.SCM_SITE_ID = A.SCM_SITE_ID
                               AND C.ITEM_ID = A.ITEM_ID
                               AND A.DIVISION_ID = P_DIVISION_ID
                               AND A.COMPANY_ID = P_COMPANY_ID
                               AND B.YYYYMMDD >= V_RESULT_START_YYYYMMDD
                               AND B.YYYYMMDD <= V_RESULT_END_YYYYMMDD
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                               AND (TRIM(P_MODEL_ID) IS NULL
                                OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                               AND (TRIM(P_NICK_NAME) IS NULL
                                OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                             FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                            UNION ALL
                            /* 출하 확정( @v_plan_start_yyyymmdd ~ 전체 ) */
                            SELECT A.DIVISION_ID AS DIVISION_ID
                                 , A.PLANT_ID AS PLANT_ID
                                 , A.COMPANY_ID AS COMPANY_ID
                                 , A.SCM_SITE_ID AS SCM_SITE_ID
                                 , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                                 , NVL(C.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                                 , A.MODEL_ID AS MODEL_ID
                                 , A.ITEM_ID AS ITEM_ID
                                 , NVL(A.SCM_SITE_ID, '-') AS FROM_SITE
                                 , '-' AS BOD_ID
                                 , B.YYYYMMDD AS YYYYMMDD
                                 , B.QTY AS QTY
                                 , B.QTY * NVL(C.CONVERT_TO_PCM, 1) AS QTY_TO_PCM
                                 , B.QTY * NVL(C.CONVERT_TO_CELL, 1) AS QTY_TO_CELL
                                 , '-' AS LAST_UPDATED_BY
                                 , NULL AS LAST_UPDATE_DATE
                                 , B.ETD_DATE AS ETD_DATE
                                 , B.ETA_DATE AS ETA_DATE
                              FROM GT_0023_PLAN_ITEM A
                                 , SSP_ANL_SHIP_CONFIRM B
                                 , SSP_MST_SITE_ITEM_EE_V C
                             WHERE B.DIVISION_ID = A.DIVISION_ID
                               AND B.FROM_SITE = A.SCM_SITE_ID
                               AND B.ITEM_ID = A.ITEM_ID
                               AND B.CHANGE_TYPE = 'C'
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND C.SCM_SITE_ID = A.SCM_SITE_ID
                               AND C.ITEM_ID = A.ITEM_ID
                               AND A.DIVISION_ID = P_DIVISION_ID
                               AND A.COMPANY_ID = P_COMPANY_ID
                               AND B.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                               AND B.YYYYMMDD <= V_PLAN_END_YYYYMMDD
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                               AND (TRIM(P_MODEL_ID) IS NULL
                                OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                               AND (TRIM(P_NICK_NAME) IS NULL
                                OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                             FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                            UNION ALL
                            /* 출하요청 ( 확정구간 이후 ~ ) */
                            SELECT A.DIVISION_ID AS DIVISION_ID
                                 , A.PLANT_ID AS PLANT_ID
                                 , A.COMPANY_ID AS COMPANY_ID
                                 , A.SCM_SITE_ID AS SCM_SITE_ID
                                 , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                                 , NVL(C.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                                 , A.MODEL_ID AS MODEL_ID
                                 , A.ITEM_ID AS ITEM_ID
                                 , NVL(B.FROM_SITE, '-') AS FROM_SITE
                                 , '-' AS BOD_ID
                                 , B.ETD_DATE AS YYYYMMDD
                                 , B.QTY AS QTY
                                 , B.QTY * NVL(C.CONVERT_TO_PCM, 1) AS QTY_TO_PCM
                                 , B.QTY * NVL(C.CONVERT_TO_CELL, 1) AS QTY_TO_CELL
                                 , '-' AS LAST_UPDATED_BY
                                 , NULL AS LAST_UPDATE_DATE
                                 , B.ETD_DATE AS ETD_DATE
                                 , B.ETA_DATE AS ETA_DATE
                              FROM GT_0023_PLAN_ITEM A
                                 , SSP_ANL_SHIP_REQ_EE B
                                 , SSP_MST_SITE_ITEM_EE_V C
                             WHERE B.FROM_DIVISION_ID = A.DIVISION_ID
                               AND B.FROM_SITE = A.SCM_SITE_ID
                               AND B.ITEM_ID = A.ITEM_ID
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND C.SCM_SITE_ID = A.SCM_SITE_ID
                               AND C.ITEM_ID = A.ITEM_ID
                               AND A.DIVISION_ID = P_DIVISION_ID
                               AND A.COMPANY_ID = P_COMPANY_ID
                               /*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
                               AND B.ETD_DATE >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, A.DIVISION_ID, A.SCM_SITE_ID, P_PLAN_START_YYYYMMDD), 'YYYYMMDD')
                               AND B.ETD_DATE < V_PLAN_END_YYYYMMDD
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR B.FROM_SITE IN (SELECT COLUMN_VALUE
                                                     FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                               AND (TRIM(P_MODEL_ID) IS NULL
                                OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                               AND (TRIM(P_NICK_NAME) IS NULL
                                OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                             FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))) IA
                     GROUP BY IA.COMPANY_ID
                            , IA.DIVISION_ID
                            , IA.PLANT_ID
                            , IA.SCM_SITE_ID
                            , IA.MODEL_ID
                            , IA.ITEM_ID
                            , IA.YYYYMMDD
                            , IA.FROM_SITE
                            , IA.BOD_ID
                            , IA.ETD_DATE
                            , IA.ETA_DATE
                            , IA.ELECTRODE_TYPE
                            , IA.ELECTRODE_POST_OPER_LT) XA
             GROUP BY XA.DIVISION_ID
                    , XA.PLANT_ID
                    , XA.COMPANY_ID
                    , XA.SCM_SITE_ID
                    , XA.ELECTRODE_POST_OPER_LT
                    , XA.ELECTRODE_TYPE
                    , XA.MODEL_ID
                    , XA.ITEM_ID
                    , XA.FROM_SITE
                    , XA.BOD_ID
                    , XA.MEASURE
                    , XA.SEQ
                    , XA.YYYYMMDD
                    , XA.LAST_UPDATED_BY
                    , XA.LAST_UPDATE_DATE;

            /*-------------------------------------------------------------------------------------------------------------
            --[R_INV_SHIP_REQ] Inventory(Ship Req) 계산
            -- R_INV_SHIP_REQ(당일) = BOH - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_ETD(당일) + P_SHIP_REQ_ETA(당일)
            -- R_INV_SHIP_REQ(익일) = P_INV_SHIP_REQ(당일) + P_FP_COATER_PLAN(당일) - P_FP_NPC_ASSY_PLAN(익일) - P_SHIP_PLAN_ETD(익일) + P_SHIP_REQ_ETA(익일)
            -------------------------------------------------------------------------------------------------------------*/
            INSERT INTO GT_0023_SIM
            (
                COMPANY_ID
              , DIVISION_ID
              , PLANT_ID
              , SCM_SITE_ID
              , MODEL_ID
              , ITEM_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , QTY_TO_PCM
              , QTY_TO_CELL
            )
            SELECT COMPANY_ID
                 , DIVISION_ID
                 , PLANT_ID
                 , SCM_SITE_ID
                 , MODEL_ID
                 , ITEM_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , QTY_TO_PCM
                 , QTY_TO_CELL
              FROM GT_0023_ROWDATA
             WHERE MEASURE IN ('P_INTRANSIT_ETA', 'P_FP_NPC_ASSY_PLAN', 'P_SHIP_PLAN_SIMU_ETD', 'P_FP_COATER_PLAN');

            /* P_INV_SIM(익일) = P_INV_SIM(전일) +  P_FP_COATER_PLAN(전일) +  P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일) */
            INSERT INTO GT_0023_ROWDATA
            (
                DIVISION_ID
              , PLANT_ID
              , COMPANY_ID
              , SCM_SITE_ID
              , ELECTRODE_POST_OPER_LT
              , ELECTRODE_TYPE
              , MODEL_ID
              , ITEM_ID
              , FROM_SITE
              , BOD_ID
              , MEASURE
              , YYYYMMDD
              , SEQ
              , QTY
              , QTY_TO_PCM
              , QTY_TO_CELL
            )
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.COMPANY_ID
                 , A.SCM_SITE_ID
                 , A.ELECTRODE_POST_OPER_LT
                 , A.ELECTRODE_TYPE
                 , A.MODEL_ID
                 , A.ITEM_ID
                 , A.SCM_SITE_ID AS FROM_SITE
                 , '-' AS BOD_ID
                 , 'P_INV_SIM' AS MEASURE
                 , A.YYYYMMDD
                 , 10
                 /* P_INV_SIM(전일) */
                 , NVL(B.QTY, 0)
                 /* + C_FP_COATER_PLAN(전일) */
                 + (SELECT NVL(SUM(SA.QTY), 0)
                      FROM GT_0023_SIM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE = 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD < A.YYYYMMDD)
                 /* C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일) */
                 + (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'P_INTRANSIT_ETA' THEN NVL(SA.QTY, 0)
                                        WHEN SA.MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0) * -1
                                        WHEN SA.MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN NVL(SA.QTY, 0) * -1
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0023_SIM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE <> 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD <= A.YYYYMMDD)
                 /* P_INV_SIM(전일) */
                 , NVL(B.QTY_TO_PCM, 0)
                 /* + C_FP_COATER_PLAN(전일) */
                 + (SELECT NVL(SUM(SA.QTY_TO_PCM), 0)
                      FROM GT_0023_SIM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE = 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD < A.YYYYMMDD)
                 /* P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일) */
                 + (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'P_INTRANSIT_ETA' THEN NVL(SA.QTY_TO_PCM, 0)
                                        WHEN SA.MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) * -1
                                        WHEN SA.MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN NVL(SA.QTY_TO_PCM, 0) * -1
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0023_SIM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE <> 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD <= A.YYYYMMDD)
                 /* P_INV_SIM(전일) */
                 , NVL(B.QTY_TO_CELL, 0)
                 /* + C_FP_COATER_PLAN(전일) */
                 + (SELECT NVL(SUM(SA.QTY_TO_CELL), 0)
                      FROM GT_0023_SIM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE = 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD < A.YYYYMMDD)
                 /* C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일) */
                 + (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'P_INTRANSIT_ETA' THEN NVL(SA.QTY_TO_CELL, 0)
                                        WHEN SA.MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1
                                        WHEN SA.MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN NVL(SA.QTY_TO_CELL, 0) * -1
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0023_SIM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE <> 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD <= A.YYYYMMDD)
              FROM (SELECT DISTINCT XA.COMPANY_ID
                         , XA.DIVISION_ID
                         , XA.PLANT_ID
                         , XA.SCM_SITE_ID
                         , XA.ELECTRODE_POST_OPER_LT
                         , XA.ELECTRODE_TYPE
                         , XA.MODEL_ID
                         , XA.ITEM_ID
                         , XB.YYYYMMDD
                      FROM GT_0023_ROWDATA XA
                         , (SELECT BASIS_YYYYMMDD AS YYYYMMDD
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                               AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD) XB
                     WHERE XA.COMPANY_ID = P_COMPANY_ID
                       AND XB.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND XB.YYYYMMDD < P_TO_YYYYMMDD) A
                 , (SELECT XA.COMPANY_ID
                         , XA.DIVISION_ID
                         , XA.PLANT_ID
                         , XA.SCM_SITE_ID
                         , XA.MODEL_ID
                         , XA.ITEM_ID
                         , SUM(CAST(XA.QTY AS NUMBER(30, 3))) AS QTY            /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                         , SUM(XA.QTY_TO_PCM) AS QTY_TO_PCM
                         , SUM(XA.QTY_TO_CELL) AS QTY_TO_CELL
                      FROM (/* BOH */
                            SELECT COMPANY_ID
                                 , DIVISION_ID
                                 , PLANT_ID
                                 , SCM_SITE_ID
                                 , MODEL_ID
                                 , ITEM_ID
                                 , TOT_BOH_QTY AS QTY
                                 , TOT_BOH_QTY_PCM AS QTY_TO_PCM
                                 , TOT_BOH_QTY_CELL AS QTY_TO_CELL
                              FROM GT_0023_BOH_CUTOFF
                             WHERE CUTOFF_DATE = P_PLAN_START_YYYYMMDD
                               AND COMPANY_ID = P_COMPANY_ID
                            UNION ALL
                            /* + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일) */
                            SELECT COMPANY_ID
                                 , DIVISION_ID
                                 , PLANT_ID
                                 , SCM_SITE_ID
                                 , MODEL_ID
                                 , ITEM_ID
                                 , NVL(SUM(CASE WHEN MEASURE = 'P_INTRANSIT_ETA' THEN NVL(QTY, 0)
                                                WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(QTY, 0) * -1
                                                WHEN MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN NVL(QTY, 0) * -1
                                                ELSE 0
                                           END), 0) AS QTY
                                 , NVL(SUM(CASE WHEN MEASURE = 'P_INTRANSIT_ETA' THEN NVL(QTY_TO_PCM, 0)
                                                WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(QTY_TO_PCM, 0) * -1
                                                WHEN MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN NVL(QTY_TO_PCM, 0) * -1
                                                ELSE 0
                                           END), 0) AS QTY_TO_PCM
                                 , NVL(SUM(CASE WHEN MEASURE = 'P_INTRANSIT_ETA' THEN NVL(QTY_TO_CELL, 0)
                                                WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(QTY_TO_CELL, 0) * -1
                                                WHEN MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN NVL(QTY_TO_CELL, 0) * -1
                                                ELSE 0
                                           END), 0) AS QTY_TO_CELL
                              FROM GT_0023_SIM
                             WHERE YYYYMMDD = P_PLAN_START_YYYYMMDD
                               AND MEASURE <> 'P_FP_COATER_PLAN'
                               AND COMPANY_ID = P_COMPANY_ID
                             GROUP BY COMPANY_ID
                                    , DIVISION_ID
                                    , PLANT_ID
                                    , SCM_SITE_ID
                                    , MODEL_ID
                                    , ITEM_ID) XA
                     GROUP BY XA.COMPANY_ID
                            , XA.DIVISION_ID
                            , XA.PLANT_ID
                            , XA.SCM_SITE_ID
                            , XA.MODEL_ID
                            , XA.ITEM_ID) B
             WHERE A.COMPANY_ID = B.COMPANY_ID(+)
               AND A.DIVISION_ID = B.DIVISION_ID(+)
               AND A.PLANT_ID = B.PLANT_ID(+)
               AND A.SCM_SITE_ID = B.SCM_SITE_ID(+)
               AND A.MODEL_ID = B.MODEL_ID(+)
               AND A.ITEM_ID = B.ITEM_ID(+);

            INSERT INTO GT_0023_CONFIRM
            (
                COMPANY_ID
              , DIVISION_ID
              , PLANT_ID
              , SCM_SITE_ID
              , MODEL_ID
              , ITEM_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , QTY_TO_PCM
              , QTY_TO_CELL
            )
            SELECT COMPANY_ID
                 , DIVISION_ID
                 , PLANT_ID
                 , SCM_SITE_ID
                 , MODEL_ID
                 , ITEM_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , QTY_TO_PCM
                 , QTY_TO_CELL
              FROM GT_0023_ROWDATA
             WHERE MEASURE IN ('P_INTRANSIT_ETA', 'P_FP_NPC_ASSY_PLAN', 'P_SHIP_CONFIRM_ETD', 'P_FP_COATER_PLAN');

            /* P_INV_CONFIRM(익일) = P_INV_CONFIRM(전일) + P_FP_COATER_PLAN(전일) + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일) */
            INSERT INTO GT_0023_ROWDATA
            (
                DIVISION_ID
              , PLANT_ID
              , COMPANY_ID
              , SCM_SITE_ID
              , ELECTRODE_POST_OPER_LT
              , ELECTRODE_TYPE
              , MODEL_ID
              , ITEM_ID
              , FROM_SITE
              , BOD_ID
              , MEASURE
              , YYYYMMDD
              , SEQ
              , QTY
              , QTY_TO_PCM
              , QTY_TO_CELL
            )
            /* FROM_SITE 는 SCM_SITE_ID 동일하다 */
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.COMPANY_ID
                 , A.SCM_SITE_ID
                 , A.ELECTRODE_POST_OPER_LT
                 , A.ELECTRODE_TYPE
                 , A.MODEL_ID
                 , A.ITEM_ID
                 , A.SCM_SITE_ID AS FROM_SITE
                 , '-' AS BOD_ID
                 , 'P_INV_CONFIRM' AS MEASURE
                 , A.YYYYMMDD
                 , 11
                 /* P_INV_CONFIRM(전일) */
                 , NVL(B.QTY, 0)
                 /* + C_FP_COATER_PLAN(전일) */
                 + (SELECT NVL(SUM(SA.QTY), 0)
                      FROM GT_0023_CONFIRM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE = 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD < A.YYYYMMDD)
                 /* C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일) */
                 + (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'P_INTRANSIT_ETA' THEN NVL(SA.QTY, 0)
                                        WHEN SA.MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY, 0) * -1
                                        WHEN SA.MEASURE = 'P_SHIP_CONFIRM_ETD' THEN NVL(SA.QTY, 0) * -1
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0023_CONFIRM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE <> 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD <= A.YYYYMMDD)
                 /* P_INV_CONFIRM(전일) */
                 , NVL(B.QTY_TO_PCM, 0)
                 /* + C_FP_COATER_PLAN(전일) */
                 + (SELECT NVL(SUM(SA.QTY_TO_PCM), 0)
                      FROM GT_0023_CONFIRM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE = 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD < A.YYYYMMDD)
                 /* C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일) */
                 + (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'P_INTRANSIT_ETA' THEN NVL(SA.QTY_TO_PCM, 0)
                                        WHEN SA.MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_PCM, 0) * -1
                                        WHEN SA.MEASURE = 'P_SHIP_CONFIRM_ETD' THEN NVL(SA.QTY_TO_PCM, 0) * -1
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0023_CONFIRM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE <> 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD <= A.YYYYMMDD)
                 /* P_INV_CONFIRM(전일) */
                 , NVL(B.QTY_TO_CELL, 0)
                 /* + C_FP_COATER_PLAN(전일) */
                 + (SELECT NVL(SUM(SA.QTY_TO_CELL), 0)
                      FROM GT_0023_CONFIRM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE = 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD < A.YYYYMMDD)
                 /* P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일) */
                 + (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'P_INTRANSIT_ETA' THEN NVL(SA.QTY_TO_CELL, 0)
                                        WHEN SA.MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(SA.QTY_TO_CELL, 0) * -1
                                        WHEN SA.MEASURE = 'P_SHIP_CONFIRM_ETD' THEN NVL(SA.QTY_TO_CELL, 0) * -1
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0023_CONFIRM SA
                     WHERE SA.COMPANY_ID = A.COMPANY_ID
                       AND SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.PLANT_ID = A.PLANT_ID
                       AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                       AND SA.MODEL_ID = A.MODEL_ID
                       AND SA.ITEM_ID = A.ITEM_ID
                       AND SA.MEASURE <> 'P_FP_COATER_PLAN'
                       AND SA.YYYYMMDD > P_PLAN_START_YYYYMMDD
                       AND SA.YYYYMMDD <= A.YYYYMMDD)
              FROM (SELECT DISTINCT XA.COMPANY_ID
                         , XA.DIVISION_ID
                         , XA.PLANT_ID
                         , XA.SCM_SITE_ID
                         , XA.ELECTRODE_POST_OPER_LT
                         , XA.ELECTRODE_TYPE
                         , XA.MODEL_ID
                         , XA.ITEM_ID
                         , XB.YYYYMMDD
                      FROM GT_0023_ROWDATA XA
                         , (SELECT BASIS_YYYYMMDD AS YYYYMMDD
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                               AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD) XB
                     WHERE XA.COMPANY_ID = P_COMPANY_ID
                       AND XB.YYYYMMDD >= P_PLAN_START_YYYYMMDD
                       AND XB.YYYYMMDD <= P_TO_YYYYMMDD) A
                 , (SELECT XA.COMPANY_ID
                         , XA.DIVISION_ID
                         , XA.PLANT_ID
                         , XA.SCM_SITE_ID
                         , XA.MODEL_ID
                         , XA.ITEM_ID
                         , SUM(CAST(XA.QTY AS NUMBER(30, 3))) AS QTY            /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                         , SUM(XA.QTY_TO_PCM) AS QTY_TO_PCM
                         , SUM(XA.QTY_TO_CELL) AS QTY_TO_CELL
                      FROM (/* BOH */
                            SELECT COMPANY_ID
                                 , DIVISION_ID
                                 , PLANT_ID
                                 , SCM_SITE_ID
                                 , MODEL_ID
                                 , ITEM_ID
                                 , TOT_BOH_QTY AS QTY
                                 , TOT_BOH_QTY_PCM AS QTY_TO_PCM
                                 , TOT_BOH_QTY_CELL AS QTY_TO_CELL
                              FROM GT_0023_BOH_CUTOFF
                             WHERE CUTOFF_DATE = P_PLAN_START_YYYYMMDD
                               AND COMPANY_ID = P_COMPANY_ID
                            UNION ALL
                            /* + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일) */
                            SELECT COMPANY_ID
                                 , DIVISION_ID
                                 , PLANT_ID
                                 , SCM_SITE_ID
                                 , MODEL_ID
                                 , ITEM_ID
                                 , NVL(SUM(CASE WHEN MEASURE = 'P_INTRANSIT_ETA' THEN NVL(QTY, 0)
                                                WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(QTY, 0) * -1
                                                WHEN MEASURE = 'P_SHIP_CONFIRM_ETD' THEN NVL(QTY, 0) * -1
                                                ELSE 0
                                           END), 0) AS QTY
                                 , NVL(SUM(CASE WHEN MEASURE = 'P_INTRANSIT_ETA' THEN NVL(QTY_TO_PCM, 0)
                                                WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(QTY_TO_PCM, 0) * -1
                                                WHEN MEASURE = 'P_SHIP_CONFIRM_ETD' THEN NVL(QTY_TO_PCM, 0) * -1
                                                ELSE 0
                                           END), 0) AS QTY_TO_PCM
                                 , NVL(SUM(CASE WHEN MEASURE = 'P_INTRANSIT_ETA' THEN NVL(QTY_TO_CELL, 0)
                                                WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN' THEN NVL(QTY_TO_CELL, 0) * -1
                                                WHEN MEASURE = 'P_SHIP_CONFIRM_ETD' THEN NVL(QTY_TO_CELL, 0) * -1
                                                ELSE 0
                                           END), 0) AS QTY_TO_CELL
                              FROM GT_0023_CONFIRM
                             WHERE YYYYMMDD = P_PLAN_START_YYYYMMDD
                               AND MEASURE <> 'P_FP_COATER_PLAN'
                               AND COMPANY_ID = P_COMPANY_ID
                             GROUP BY COMPANY_ID
                                    , DIVISION_ID
                                    , PLANT_ID
                                    , SCM_SITE_ID
                                    , MODEL_ID
                                    , ITEM_ID) XA
                     GROUP BY XA.COMPANY_ID
                            , XA.DIVISION_ID
                            , XA.PLANT_ID
                            , XA.SCM_SITE_ID
                            , XA.MODEL_ID
                            , XA.ITEM_ID) B
             WHERE A.COMPANY_ID = B.COMPANY_ID(+)
               AND A.DIVISION_ID = B.DIVISION_ID(+)
               AND A.PLANT_ID = B.PLANT_ID(+)
               AND A.SCM_SITE_ID = B.SCM_SITE_ID(+)
               AND A.MODEL_ID = B.MODEL_ID(+)
               AND A.ITEM_ID = B.ITEM_ID(+);

        ELSE

            /* 과거 기준 조회 */
            INSERT INTO GT_0023_ROWDATA
            (
                DIVISION_ID
              , PLANT_ID
              , COMPANY_ID
              , SCM_SITE_ID
              , ELECTRODE_POST_OPER_LT
              , ELECTRODE_TYPE
              , MODEL_ID
              , ITEM_ID
              , FROM_SITE
              , MEASURE
              , YYYYMMDD
              , SEQ
              , QTY
              , QTY_TO_PCM
              , QTY_TO_CELL
            )
            SELECT XA.DIVISION_ID
                 , XA.PLANT_ID
                 , XA.COMPANY_ID
                 , XA.SCM_SITE_ID
                 , XA.ELECTRODE_POST_OPER_LT
                 , XA.ELECTRODE_TYPE
                 , XA.MODEL_ID
                 , XA.ITEM_ID
                 , XA.FROM_SITE
                 , XA.MEASURE
                 , XA.YYYYMMDD
                 , XA.SEQ
                 , SUM(XA.QTY) AS QTY
                 , SUM(XA.QTY_TO_PCM) AS QTY_TO_PCM
                 , SUM(XA.QTY_TO_CELL) AS QTY_TO_CELL
              FROM (SELECT A.DIVISION_ID AS DIVISION_ID
                         , A.PLANT_ID AS PLANT_ID
                         , A.COMPANY_ID AS COMPANY_ID
                         , A.SCM_SITE_ID AS SCM_SITE_ID
                         , NVL(C.ELECTRODE_POST_OPER_LT, '-') AS ELECTRODE_POST_OPER_LT
                         , NVL(B.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                         , A.MODEL_ID AS MODEL_ID
                         , A.ITEM_ID AS ITEM_ID
                         , A.SCM_SITE_ID AS FROM_SITE
                         , B.MEASURE AS MEASURE
                         , B.YYYYMMDD AS YYYYMMDD
                         , 1 AS SEQ
                         , NVL(B.QTY, 0) AS QTY
                         , NVL(B.QTY_TO_PCM, 0) AS QTY_TO_PCM
                         , NVL(B.QTY_TO_CELL, 0) AS QTY_TO_CELL
                      FROM GT_0023_PLAN_ITEM A
                         , SSP_ANL_SHIP_PLAN_EE B
                         , SSP_MST_SITE_ITEM_EE_V C
                     WHERE A.COMPANY_ID = B.COMPANY_ID
                       AND A.DIVISION_ID = B.DIVISION_ID
                       AND A.PLANT_ID = B.PLANT_ID
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
                       AND A.MODEL_ID = B.MODEL_ID
                       AND A.ITEM_ID = B.ITEM_ID
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND C.ITEM_ID = A.ITEM_ID
                       AND C.SCM_SITE_ID = A.SCM_SITE_ID
                       AND B.MEASURE_TYPE = 'P'
                       AND B.DIVISION_ID = P_DIVISION_ID
                       AND B.COMPANY_ID = P_COMPANY_ID
                       AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND B.YYYYMMDD >= P_FROM_YYYYMMDD
                       AND B.YYYYMMDD <= P_TO_YYYYMMDD
                       AND B.MEASURE IN ('P_SCP_PROD_PLAN', 'P_SCP_SHIP_PLAN_ETD', 'P_SHIP_REQ_ETD', 'P_SHIP_PLAN_SIMU_ETD'
                                       , 'P_SHIP_CONFIRM_ETD', 'P_FP_NPC_ASSY_PLAN', 'P_FP_COATER_PLAN', 'P_FP_COATER_POST_PLAN', 'P_INTRANSIT_ETA'
                                       , 'P_INV_SIM', 'P_INV_CONFIRM')
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                       AND (TRIM(P_MODEL_ID) IS NULL
                        OR A.MODEL_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                       AND (TRIM(P_NICK_NAME) IS NULL
                        OR C.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                     FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))) XA
             GROUP BY XA.DIVISION_ID
                    , XA.PLANT_ID
                    , XA.COMPANY_ID
                    , XA.SCM_SITE_ID
                    , XA.ELECTRODE_POST_OPER_LT
                    , XA.ELECTRODE_TYPE
                    , XA.MODEL_ID
                    , XA.ITEM_ID
                    , XA.FROM_SITE
                    , XA.MEASURE
                    , XA.SEQ
                    , XA.YYYYMMDD;

        END IF;

        /*--////////////////////////////////////////////////////////////////////////////////--*/
        /*--//3. 해당 ITEM별 MEASURE 및 날짜 생성											//--*/
        /*--////////////////////////////////////////////////////////////////////////////////--*/
        /* 현재기준과 과거기준은 원자료 조인 키가 다르다(과거기준에는 MODEL_ID 조인이 없다) */
        IF P_REAL_FLAG = 'Y' THEN

        INSERT INTO GT_0023_RESULT
        (
            DIVISION_ID
          , PLANT_ID
          , SCM_SITE_ID
          , ELECTRODE_POST_OPER_LT
          , ELECTRODE_TYPE
          , MODEL_ID
          , ITEM_ID
          , FROM_SITE
          , MEASURE
          , SEQ
          , YYYYMMDD
          , QTY
          , QTY_TO_PCM
          , QTY_TO_CELL
          , TOT_BOH_QTY
          , JR_BOH_QTY
          , PC_BOH_QTY
          , TOT_BOH_QTY_PCM
          , JR_BOH_QTY_PCM
          , PC_BOH_QTY_PCM
          , TOT_BOH_QTY_CELL
          , JR_BOH_QTY_CELL
          , PC_BOH_QTY_CELL
        )
        SELECT XA.DIVISION_ID
             , XA.PLANT_ID
             , XA.SCM_SITE_ID
             , XA.ELECTRODE_POST_OPER_LT
             , XA.ELECTRODE_TYPE
             , XA.MODEL_ID
             , XA.ITEM_ID
             , XA.FROM_SITE
             , XA.MEASURE
             , XA.SEQ
             , XA.YYYYMMDD
             , NVL(XA.QTY, 0) AS QTY
             , NVL(XA.QTY_TO_PCM, 0) AS QTY_TO_PCM
             , NVL(XA.QTY_TO_CELL, 0) AS QTY_TO_CELL
             , NVL(XA.TOT_BOH_QTY, 0) AS TOT_BOH_QTY
             , NVL(XA.JR_BOH_QTY, 0) AS JR_BOH_QTY
             , NVL(XA.PC_BOH_QTY, 0) AS PC_BOH_QTY
             , NVL(XA.TOT_BOH_QTY_PCM, 0) AS TOT_BOH_QTY_PCM
             , NVL(XA.JR_BOH_QTY_PCM, 0) AS JR_BOH_QTY_PCM
             , NVL(XA.PC_BOH_QTY_PCM, 0) AS PC_BOH_QTY_PCM
             , NVL(XA.TOT_BOH_QTY_CELL, 0) AS TOT_BOH_QTY_CELL
             , NVL(XA.JR_BOH_QTY_CELL, 0) AS JR_BOH_QTY_CELL
             , NVL(XA.PC_BOH_QTY_CELL, 0) AS PC_BOH_QTY_CELL
          FROM (SELECT DISTINCT IA.DIVISION_ID
                     , IA.PLANT_ID
                     , IA.SCM_SITE_ID
                     , IA.ELECTRODE_POST_OPER_LT
                     , IA.ELECTRODE_TYPE
                     , IA.MODEL_ID
                     , IA.ITEM_ID
                     , B.FROM_SITE
                     , IA.MEASURE
                     , IA.SEQ
                     , B.YYYYMMDD
                     , B.QTY
                     , B.QTY_TO_PCM
                     , B.QTY_TO_CELL
                     , C.TOT_BOH_QTY
                     , C.JR_BOH_QTY
                     , C.PC_BOH_QTY
                     , C.TOT_BOH_QTY_PCM
                     , C.JR_BOH_QTY_PCM
                     , C.PC_BOH_QTY_PCM
                     , C.TOT_BOH_QTY_CELL
                     , C.JR_BOH_QTY_CELL
                     , C.PC_BOH_QTY_CELL
                  FROM (SELECT DISTINCT A.DIVISION_ID
                             , A.PLANT_ID
                             , A.SCM_SITE_ID
                             , A.ELECTRODE_POST_OPER_LT
                             , A.ELECTRODE_TYPE
                             , A.MODEL_ID
                             , A.ITEM_ID
                             , SA.COLUMN_NAME AS MEASURE
                             , SA.SORT_ORDER_NO AS SEQ
                             , A.YYYYMMDD
                          FROM GT_0023_ROWDATA A
                             , SCM_MST_SHEET_MEASURE SA
                         WHERE SA.PROGRAM_ID(+) = P_PROGRAM_ID
                           AND SA.SHEET_NAME(+) = P_SHEET_NAME) IA
                     , GT_0023_ROWDATA B
                     , GT_0023_BOH_CUTOFF C
                 WHERE B.DIVISION_ID(+) = IA.DIVISION_ID
                   AND B.PLANT_ID(+) = IA.PLANT_ID
                   AND B.SCM_SITE_ID(+) = IA.SCM_SITE_ID
                   AND B.ELECTRODE_TYPE(+) = IA.ELECTRODE_TYPE
                   AND B.MODEL_ID(+) = IA.MODEL_ID
                   AND B.ITEM_ID(+) = IA.ITEM_ID
                   AND B.MEASURE(+) = IA.MEASURE
                   AND B.YYYYMMDD(+) = IA.YYYYMMDD
                   AND C.DIVISION_ID(+) = IA.DIVISION_ID
                   AND C.ITEM_ID(+) = IA.ITEM_ID) XA;

        ELSE

        INSERT INTO GT_0023_RESULT
        (
            DIVISION_ID
          , PLANT_ID
          , SCM_SITE_ID
          , ELECTRODE_POST_OPER_LT
          , ELECTRODE_TYPE
          , MODEL_ID
          , ITEM_ID
          , FROM_SITE
          , MEASURE
          , SEQ
          , YYYYMMDD
          , QTY
          , QTY_TO_PCM
          , QTY_TO_CELL
          , TOT_BOH_QTY
          , JR_BOH_QTY
          , PC_BOH_QTY
          , TOT_BOH_QTY_PCM
          , JR_BOH_QTY_PCM
          , PC_BOH_QTY_PCM
          , TOT_BOH_QTY_CELL
          , JR_BOH_QTY_CELL
          , PC_BOH_QTY_CELL
        )
        SELECT XA.DIVISION_ID
             , XA.PLANT_ID
             , XA.SCM_SITE_ID
             , XA.ELECTRODE_POST_OPER_LT
             , XA.ELECTRODE_TYPE
             , XA.MODEL_ID
             , XA.ITEM_ID
             , XA.FROM_SITE
             , XA.MEASURE
             , XA.SEQ
             , XA.YYYYMMDD
             , NVL(XA.QTY, 0) AS QTY
             , NVL(XA.QTY_TO_PCM, 0) AS QTY_TO_PCM
             , NVL(XA.QTY_TO_CELL, 0) AS QTY_TO_CELL
             , NVL(XA.TOT_BOH_QTY, 0) AS TOT_BOH_QTY
             , NVL(XA.JR_BOH_QTY, 0) AS JR_BOH_QTY
             , NVL(XA.PC_BOH_QTY, 0) AS PC_BOH_QTY
             , NVL(XA.TOT_BOH_QTY_PCM, 0) AS TOT_BOH_QTY_PCM
             , NVL(XA.JR_BOH_QTY_PCM, 0) AS JR_BOH_QTY_PCM
             , NVL(XA.PC_BOH_QTY_PCM, 0) AS PC_BOH_QTY_PCM
             , NVL(XA.TOT_BOH_QTY_CELL, 0) AS TOT_BOH_QTY_CELL
             , NVL(XA.JR_BOH_QTY_CELL, 0) AS JR_BOH_QTY_CELL
             , NVL(XA.PC_BOH_QTY_CELL, 0) AS PC_BOH_QTY_CELL
          FROM (SELECT DISTINCT IA.DIVISION_ID
                     , IA.PLANT_ID
                     , IA.SCM_SITE_ID
                     , IA.ELECTRODE_POST_OPER_LT
                     , IA.ELECTRODE_TYPE
                     , IA.MODEL_ID
                     , IA.ITEM_ID
                     , B.FROM_SITE
                     , IA.MEASURE
                     , IA.SEQ
                     , B.YYYYMMDD
                     , B.QTY
                     , B.QTY_TO_PCM
                     , B.QTY_TO_CELL
                     , C.TOT_BOH_QTY
                     , C.JR_BOH_QTY
                     , C.PC_BOH_QTY
                     , C.TOT_BOH_QTY_PCM
                     , C.JR_BOH_QTY_PCM
                     , C.PC_BOH_QTY_PCM
                     , C.TOT_BOH_QTY_CELL
                     , C.JR_BOH_QTY_CELL
                     , C.PC_BOH_QTY_CELL
                  FROM (SELECT DISTINCT A.DIVISION_ID
                             , A.PLANT_ID
                             , A.SCM_SITE_ID
                             , A.ELECTRODE_POST_OPER_LT
                             , A.ELECTRODE_TYPE
                             , A.MODEL_ID
                             , A.ITEM_ID
                             , SA.COLUMN_NAME AS MEASURE
                             , SA.SORT_ORDER_NO AS SEQ
                             , A.YYYYMMDD
                          FROM GT_0023_ROWDATA A
                             , SCM_MST_SHEET_MEASURE SA
                         WHERE SA.PROGRAM_ID(+) = P_PROGRAM_ID
                           AND SA.SHEET_NAME(+) = P_SHEET_NAME) IA
                     , GT_0023_ROWDATA B
                     , GT_0023_BOH_CUTOFF C
                 WHERE B.DIVISION_ID(+) = IA.DIVISION_ID
                   AND B.PLANT_ID(+) = IA.PLANT_ID
                   AND B.SCM_SITE_ID(+) = IA.SCM_SITE_ID
                   AND B.ELECTRODE_TYPE(+) = IA.ELECTRODE_TYPE
                   AND B.ITEM_ID(+) = IA.ITEM_ID
                   AND B.MEASURE(+) = IA.MEASURE
                   AND B.YYYYMMDD(+) = IA.YYYYMMDD
                   AND C.DIVISION_ID(+) = IA.DIVISION_ID
                   AND C.ITEM_ID(+) = IA.ITEM_ID) XA;

        END IF;

        /*--////////////////////////////////////////////////////////////////////////////////--*/
        /*--//5. PIVOT				 													//--*/
        /*--////////////////////////////////////////////////////////////////////////////////--*/
        INSERT INTO GT_0023_PIVOT
        (
            DIVISION_ID
          , PLANT_ID
          , SCM_SITE_ID
          , ELECTRODE_POST_OPER_LT
          , ELECTRODE_TYPE
          , MODEL_ID
          , ITEM_ID
          , FROM_SITE
          , MEASURE
          , SEQ
          , YYYYMMDD
          , YYYYMM
          , ISO_WEEK
          , QTY
          , QTY_TO_PCM
          , QTY_TO_CELL
          , TOT_BOH_QTY
          , JR_BOH_QTY
          , PC_BOH_QTY
          , TOT_BOH_QTY_PCM
          , JR_BOH_QTY_PCM
          , PC_BOH_QTY_PCM
          , TOT_BOH_QTY_CELL
          , JR_BOH_QTY_CELL
          , PC_BOH_QTY_CELL
        )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.SCM_SITE_ID
             , A.ELECTRODE_POST_OPER_LT
             , A.ELECTRODE_TYPE
             , A.MODEL_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.MEASURE
             , A.SEQ
             , 'D_' || A.YYYYMMDD AS YYYYMMDD
             , B.BASIS_YYYYMM AS YYYYMM
             , SUBSTR(B.BASIS_YYYYMM, -4) || B.ISO_WEEK AS ISO_WEEK
             , A.QTY AS QTY
             , A.QTY_TO_PCM AS QTY_TO_PCM
             , A.QTY_TO_CELL AS QTY_TO_CELL
             , A.TOT_BOH_QTY AS TOT_BOH_QTY
             , A.JR_BOH_QTY AS JR_BOH_QTY
             , A.PC_BOH_QTY AS PC_BOH_QTY
             , A.TOT_BOH_QTY_PCM AS TOT_BOH_QTY_PCM
             , A.JR_BOH_QTY_PCM AS JR_BOH_QTY_PCM
             , A.PC_BOH_QTY_PCM AS PC_BOH_QTY_PCM
             , A.TOT_BOH_QTY_CELL AS TOT_BOH_QTY_CELL
             , A.JR_BOH_QTY_CELL AS JR_BOH_QTY_CELL
             , A.PC_BOH_QTY_CELL AS PC_BOH_QTY_CELL
          FROM GT_0023_RESULT A
             , SCM_SYS_CALENDAR_M B
         WHERE A.YYYYMMDD = B.BASIS_YYYYMMDD(+);

        /*PIVOIT처리*******************************************************************************/
        /* PIVOIT 대상 날짜문자열 생성 */
        V_QRY_SUM := '';

        FOR R IN (SELECT IA.YYYYMMDD
                    FROM (SELECT 'X_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                               , 'X_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                          UNION ALL
                          SELECT 'X_M_' || A.BASIS_YYYYMM AS YYYYMMDD
                               , 'X_' || MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                          UNION ALL
                          SELECT 'X_D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                               , 'X_' || A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMMDD
                          UNION ALL
                          SELECT 'Y_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                               , 'Y_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                          UNION ALL
                          SELECT 'Y_M_' || A.BASIS_YYYYMM AS YYYYMMDD
                               , 'Y_' || MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                          UNION ALL
                          SELECT 'Y_D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                               , 'Y_' || A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMMDD
                          UNION ALL
                          SELECT 'Z_W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                               , 'Z_' || A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                          UNION ALL
                          SELECT 'Z_M_' || A.BASIS_YYYYMM AS YYYYMMDD
                               , 'Z_' || MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                          UNION ALL
                          SELECT 'Z_D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                               , 'Z_' || A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMMDD) IA
                   ORDER BY IA.SORT_ORDER_NO) LOOP

            /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
            IF INSTR(R.YYYYMMDD, 'X_M_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.YYYYMM = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'X_W_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.ISO_WEEK = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'X_D_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.YYYYMMDD = ''' || SUBSTR(R.YYYYMMDD, -10) || ''' THEN CAST(NVL(A.QTY, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'Y_M_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.YYYYMM = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY_TO_CELL, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'Y_W_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.ISO_WEEK = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY_TO_CELL, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'Y_D_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.YYYYMMDD = ''' || SUBSTR(R.YYYYMMDD, -10) || ''' THEN CAST(NVL(A.QTY_TO_CELL, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'Z_M_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.YYYYMM = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY_TO_PCM, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'Z_W_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.ISO_WEEK = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY_TO_PCM, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            ELSIF INSTR(R.YYYYMMDD, 'Z_D_') = 1 THEN
                V_QRY_SUM := V_QRY_SUM || ', CAST(SUM(CASE WHEN A.YYYYMMDD = ''' || SUBSTR(R.YYYYMMDD, -10) || ''' THEN CAST(NVL(A.QTY_TO_PCM, 0) AS NUMBER(30, 3)) ELSE 0 END) AS NUMBER(30, 3)) AS ' || R.YYYYMMDD || CHR(10);
            END IF;

        END LOOP;
        /*--//END PIVOT//--*/

        /*--////////////////////////////////////////////////////////////////////////////////--*/
        /*--//6. RESULT				 													//--*/
        /*--////////////////////////////////////////////////////////////////////////////////--*/
        /* 측정값 칸은 화면 설정에 따라 개수가 달라져 정적 SQL 로 쓸 수 없다(피벗 전용 동적 SQL) */
        V_EXEC := 'SELECT A.DIVISION_ID' || CHR(10)
               || ', A.PLANT_ID' || CHR(10)
               || ', NVL(A.SCM_SITE_ID, ''-'') AS SCM_SITE_ID' || CHR(10)
               || ', A.ELECTRODE_POST_OPER_LT' || CHR(10)
               || ', A.ELECTRODE_TYPE' || CHR(10)
               || ', A.MODEL_ID' || CHR(10)
               || ', A.ITEM_ID' || CHR(10)
               || ', NVL(B.SCM_SITE_ID, ''-'') AS FROM_SITE' || CHR(10)
               || ', RANK() OVER(PARTITION BY A.DIVISION_ID, B.SCM_SITE_ID ORDER BY A.DIVISION_ID, A.MODEL_ID, A.ITEM_ID, B.SCM_SITE_ID, A.ELECTRODE_TYPE) AS GUBUN_NUM' || CHR(10)
               || ', ''-'' AS TEMPCOLUMN' || CHR(10)
               || ', CASE A.MEASURE WHEN ''P_SCP_PROD_PLAN'' THEN ''S''' || CHR(10)
               || '                 WHEN ''P_SCP_SHIP_PLAN_ETD'' THEN ''S''' || CHR(10)
               || '                 WHEN ''P_SHIP_REQ_ETD'' THEN ''S''' || CHR(10)
               || '                 WHEN ''P_SHIP_PLAN_SIMU_ETD'' THEN ''S''' || CHR(10)
               || '                 WHEN ''P_SHIP_CONFIRM_ETD'' THEN ''S''' || CHR(10)
               || '                 WHEN ''P_FP_NPC_ASSY_PLAN'' THEN ''P''' || CHR(10)
               || '                 WHEN ''P_FP_COATER_PLAN'' THEN ''P''' || CHR(10)
               || '                 WHEN ''P_FP_COATER_POST_PLAN'' THEN ''P''' || CHR(10)
               || '                 WHEN ''P_INTRANSIT_ETA'' THEN ''I''' || CHR(10)
               || '                 WHEN ''P_INV_SIM'' THEN ''I''' || CHR(10)
               || '                 WHEN ''P_INV_CONFIRM'' THEN ''I'' END AS PSI_NAME' || CHR(10)
               /* AS-IS 는 ISNULL(CONVERT(NVARCHAR(50),CEILING(x)),'0'*1000)/1000 로 괄호가 어긋나 문자/정수 나눗셈이 된다 -- 2026.09.23 AJS */
               || ', CEIL(NVL(A.TOT_BOH_QTY, 0) * 1000) / 1000 AS TOT_BOH_QTY' || CHR(10)
               || ', CEIL(NVL(A.JR_BOH_QTY, 0) * 1000) / 1000 AS JR_BOH_QTY' || CHR(10)
               || ', CEIL(NVL(A.PC_BOH_QTY, 0) * 1000) / 1000 AS PC_BOH_QTY' || CHR(10)
               || ', CEIL(NVL(A.TOT_BOH_QTY_PCM, 0) * 1000) / 1000 AS TOT_BOH_QTY_PCM' || CHR(10)
               || ', CEIL(NVL(A.JR_BOH_QTY_PCM, 0) * 1000) / 1000 AS JR_BOH_QTY_PCM' || CHR(10)
               || ', CEIL(NVL(A.PC_BOH_QTY_PCM, 0) * 1000) / 1000 AS PC_BOH_QTY_PCM' || CHR(10)
               || ', CEIL(NVL(A.TOT_BOH_QTY_CELL, 0) * 1000) / 1000 AS TOT_BOH_QTY_CELL' || CHR(10)
               || ', CEIL(NVL(A.JR_BOH_QTY_CELL, 0) * 1000) / 1000 AS JR_BOH_QTY_CELL' || CHR(10)
               || ', CEIL(NVL(A.PC_BOH_QTY_CELL, 0) * 1000) / 1000 AS PC_BOH_QTY_CELL' || CHR(10)
               || ', (SELECT NVL(SA.NICK_NAME, ''-'') FROM SCM_MST_ITEM_SN SA WHERE SA.ITEM_ID = A.ITEM_ID AND ROWNUM = 1) AS NICK_NAME';

        /* 과거기준 조회에만 ELECTRODE_TYPE 칸이 한 번 더 있다(AS-IS 동일) */
        IF P_REAL_FLAG <> 'Y' THEN
            V_EXEC := V_EXEC || CHR(10) || ', NVL(A.ELECTRODE_TYPE, ''-'') AS ELECTRODE_TYPE';
        END IF;

        V_EXEC := V_EXEC || CHR(10)
               || ', A.MEASURE' || CHR(10)
               || ', C.COLUMN_LABEL_NAME AS MEASURE_NAME' || CHR(10)
               || ', A.SEQ' || CHR(10)
               || ', TO_CHAR(TO_DATE(:B_FROZEN_YYYYMMDD, ''YYYYMMDD'') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(:B_APP_TYPE, A.DIVISION_ID, A.SCM_SITE_ID, :B_PLAN_START1), ''YYYYMMDD'') AS CONFIRM_DAY' || CHR(10)
               || ', C.ATTRIBUTE3 AS BACK_COLOR' || CHR(10)
               || V_QRY_SUM
               || '  FROM GT_0023_PIVOT A' || CHR(10)
               || '     , GT_0023_PLAN_ITEM B' || CHR(10)
               || '     , SCM_MST_SHEET_MEASURE C' || CHR(10)
               || '     , SCM_MST_TITLESET_USER D' || CHR(10)
               || ' WHERE B.DIVISION_ID = A.DIVISION_ID' || CHR(10)
               || '   AND B.PLANT_ID = A.PLANT_ID' || CHR(10)
               || '   AND B.SCM_SITE_ID = A.SCM_SITE_ID' || CHR(10)
               || '   AND B.MODEL_ID = A.MODEL_ID' || CHR(10)
               || '   AND B.ITEM_ID = A.ITEM_ID' || CHR(10)
               || '   AND A.MEASURE = C.COLUMN_NAME' || CHR(10)
               || '   AND C.PROGRAM_ID = :B_PROGRAM_ID1' || CHR(10)
               || '   AND C.SHEET_NAME = :B_SHEET_NAME1' || CHR(10)
               || '   AND D.PROGRAM_ID(+) = C.PROGRAM_ID' || CHR(10)
               || '   AND D.SHEET_NAME(+) = C.SHEET_NAME' || CHR(10)
               || '   AND D.COLUMN_NAME(+) = C.COLUMN_NAME' || CHR(10)
               || '   AND D.USER_ID(+) = :B_USER_ID1' || CHR(10)
               || '   AND C.VALID_YN = ''Y''' || CHR(10)
               || '   AND (:B_CNT1 = 0' || CHR(10)
               || '    OR EXISTS (SELECT 1' || CHR(10)
               || '                 FROM GT_0023_TITLESET SA' || CHR(10)
               || '                WHERE SA.COLUMN_NAME = C.COLUMN_NAME))' || CHR(10)
               || '   AND ((:B_CNT2 = 0 AND C.DEFAULT_FLAG = ''Y'')' || CHR(10)
               || '    OR (:B_CNT3 <> 0))' || CHR(10)
               || ' GROUP BY A.DIVISION_ID, A.PLANT_ID, A.SCM_SITE_ID, A.ELECTRODE_POST_OPER_LT, A.ELECTRODE_TYPE, A.MODEL_ID, A.ITEM_ID, B.SCM_SITE_ID' || CHR(10)
               || '        , A.TOT_BOH_QTY, A.PC_BOH_QTY, A.JR_BOH_QTY, A.TOT_BOH_QTY_PCM, A.PC_BOH_QTY_PCM, A.JR_BOH_QTY_PCM' || CHR(10)
               || '        , A.TOT_BOH_QTY_CELL, A.PC_BOH_QTY_CELL, A.JR_BOH_QTY_CELL, A.MEASURE, C.COLUMN_LABEL_NAME, A.SEQ, C.ATTRIBUTE3' || CHR(10)
               || ' ORDER BY A.DIVISION_ID, A.PLANT_ID, A.MODEL_ID, A.ITEM_ID, A.SEQ, B.SCM_SITE_ID ASC';

        OPEN O_RC1 FOR V_EXEC USING V_FROZEN_YYYYMMDD, V_APP_TYPE, P_PLAN_START_YYYYMMDD, P_PROGRAM_ID, P_SHEET_NAME, P_USER_ID, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE;

    END P_SSP0023_GET_SHIPMENT_PLAN;

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_REQUESTOR             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN_DETAIL
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) DETAIL
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-05-08   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2020-09-21   KIMYONGHO		SSP INCOTERMS 변경 작업
 * 2021/09/02   KIMYONGHO      SCP_MST_BOD_N_V -> SCP_MST_BOD_N_V 변경
 * 2024/05/10   hsbang          확정구간 조회 일수(CONFIRM_DAY)를 펑션 FN_GET_ANL_SHIP_FROZEN_DAY_CNT] 에서 가져오도록 반영
 * 2025/12/11   chkim.68        E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_APP_TYPE              VARCHAR2(8) := 'SSP';
    BEGIN

        IF P_REAL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
                SELECT A.DIVISION_ID
                     , A.ERP_SO_NO
                     , A.SHIPMENT_STATUS
                     , A.ITEM_ID
                     , A.ITEM_ID_NICK_NAME
                     , A.MODEL_ID
                     , A.MODEL_ID_NICK_NAME
                     , (SELECT SA.DAYOFWEEK_NAME
                          FROM SCM_SYS_CALENDAR_M SA
                         WHERE SA.BASIS_YYYYMMDD = A.YYYYMMDD) AS DAYOFWEEK_NAME
                     /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                     , CAST(A.SHIPPING_PLAN_QTY AS NUMBER(30, 3)) AS SHIPPING_PLAN_QTY
                     , CAST(NVL(A.QTY, 0) AS NUMBER(30, 3)) AS SHIPMENT_CONFIRM_QTY
                     , CAST((A.SHIPPING_PLAN_QTY - NVL(A.QTY, 0)) AS NUMBER(30, 3)) AS GAP
                     , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS SHIPMENT_DATE
                     , ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.ERP_SO_NO, A.SHIPMENT_STATUS, A.CELL_TYPE, A.YYYYMMDD, A.ITEM_ID, A.MODEL_ID, A.FROM_SITE, A.TO_SITE
                                             ORDER BY A.DIVISION_ID, A.SHIPMENT_STATUS, A.ERP_SO_NO DESC, A.CELL_TYPE, A.YYYYMMDD, A.ITEM_ID, A.FROM_SITE, A.TO_SITE) AS MERGE_NUM
                     , A.DOM_EXP_TYPE AS DOM_EXP
                     , A.FACTORY_ID AS FACTORY_ID
                     , A.FACTORY_ID AS FACTORY_NAME
                     , A.CONFIRM_QTY_PANCAKE
                     , A.CONFIRM_QTY_JR
                     , A.CONFIRM_QTY_CELL
                     , A.CONFIRM_QTY_ROLL_LENGTH
                     , A.PACKAGE_TYPE_CODE AS PACKAGE_TYPE
                     /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                     , CEIL(CASE WHEN A.PACKAGE_TYPE_CODE = 'BX' THEN A.CONFIRM_QTY_ROLL_LENGTH * NVL(A.BOX_PER_CUT, 1)
                                 WHEN A.PACKAGE_TYPE_CODE = 'SC' THEN A.CONFIRM_QTY_ROLL_LENGTH * NVL(A.STEELCRATE_PER_CUT, 1)
                                 WHEN A.PACKAGE_TYPE_CODE = 'SR' THEN A.CONFIRM_QTY_ROLL_LENGTH * NVL(A.STEELRACK_PER_CUT, 1)
                            ELSE NVL(A.QTY, 0) END * 1000) / 1000 AS PACKAGE_QTY
                     , A.ELECTRODE_POST_OPER AS ELECTRODE_POST_OPER
                     , A.FROM_SITE AS FROM_SITE
                     , A.TO_SITE AS TO_SITE
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-') AS TO_SITE_DESCRIPTION
/* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN P_LANGUAGE = 'KO' THEN F.USERNAME ELSE F.USERNAME_E END || '(' || A.REQUESTOR || ')' AS REQUESTOR
                     , CASE WHEN P_LANGUAGE = 'KO' THEN F.USER_NM ELSE F.USER_ENG_NM END || '(' || A.REQUESTOR || ')' AS REQUESTOR
/* 2026.09.30 AJS 수정 (END) */
                     , B.TRANSPORT_MODE
                     , A.REMARKS2
                     , A.REMARKS
                     , '-' AS CHANGE_REASON_CODE
                     , NULL AS CHANGE_REASON_DETAIL
                     , A.REMARKS3
                     , FN_GET_SITE_CUSTOMER_INFO((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                     , FN_GET_SITE_CUSTOMER_INFO((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                     /* 2020-09-21   KIMYONGHO		SSP INCOTERMS 변경 작업 */
                     , B.SSP_INCOTERMS AS INCOTERMS
                     , B.LT_TOTAL AS LT_DAY
                     , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                     , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                     , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-'
                            ELSE TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')
                       END AS EXPECTED_SHIPPING_DATE
/* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN P_LANGUAGE = 'KO' THEN C.USERNAME ELSE C.USERNAME_E END || '(' || A.LAST_UPDATED_BY || ')' AS UPDATED_BY
--                     , CASE WHEN C.USERNAME IS NOT NULL THEN A.LAST_UPDATE_DATE ELSE NULL END AS UPDATED_DATE
                     , CASE WHEN P_LANGUAGE = 'KO' THEN C.USER_NM ELSE C.USER_ENG_NM END || '(' || A.LAST_UPDATED_BY || ')' AS UPDATED_BY
                     , CASE WHEN C.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE ELSE NULL END AS UPDATED_DATE
/* 2026.09.30 AJS 수정 (END) */
                     , D.CHANGE_REQ_NO
/* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN P_LANGUAGE = 'KO' THEN G.USERNAME ELSE G.USERNAME_E END || '(' || E.USER_ID || ')' AS MODEL_USER
                     , CASE WHEN P_LANGUAGE = 'KO' THEN G.USER_NM ELSE G.USER_ENG_NM END || '(' || E.USER_ID || ')' AS MODEL_USER
/* 2026.09.30 AJS 수정 (END) */
                     , A.CONFIRM_ID
                     , B.LT_TOTAL AS NEW_LT_DAY
                     , B.TRANSPORT_MODE AS NEW_TRANSPORT_MODE
                     , A.ERP_STATUS
                     , A.CHANGE_TYPE
                     , A.NEW_ROUTE_ID
                     , A.NEW_BOD_ID
                     , A.NEW_INCOTERMS
                     , A.NEW_D_COUNTRY
                     , A.NEW_D_PORT_CODE
                     , A.NEW_A_COUNTRY
                     , A.NEW_A_PORT_CODE
                     , A.NEW_CUSTOMER_LT
                     , A.NEW_TO_COUNTRY
                     , A.NEW_TO_CITY
                     , A.NEW_ETA
                     , A.NEW_ETD
                     , A.NEW_SHIPMENT_DATE
                     , A.EDIT_REMARKS
                     , A.EDIT_MAIN
                     , A.CHECK_NEED_YN
                     , A.ELECTRODE_YN
                     , A.ELECTRODE_TYPE
                     , A.CELL_TYPE
                     , A.ATTRIBUTE10
                  FROM (SELECT DISTINCT XA.DIVISION_ID
                             , XA.ERP_SO_NO
                             , XA.SHIPMENT_STATUS
                             , XA.ITEM_ID
                             , XA.ORIGIN_FROM_DIVISION_ID
                             , XA.ORIGIN_TO_DIVISION_ID
                             , XA.FROM_SITE
                             , XA.TO_SITE
                             , XA.REQUESTOR
                             , XA.QTY
                             , XB.ITEM_ID_NICK_NAME
                             , XB.MODEL_ID
                             , XB.MODEL_ID_NICK_NAME
                             , NVL(XA.ELECTRODE_TYPE, XB.ELECTRODE_TYPE) AS ELECTRODE_TYPE
                             , NVL(XA.DOM_EXP, XB.DOM_EXP_TYPE) AS DOM_EXP_TYPE
                             /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                             , CAST(XA.QTY * NVL(XB.CONVERT_TO_PCM, 1) AS NUMBER(30, 3)) AS CONFIRM_QTY_PANCAKE
                             , CAST(XA.QTY * NVL(XB.CONVERT_TO_JRM, 1) AS NUMBER(30, 3)) AS CONFIRM_QTY_JR
                             , CAST(XA.QTY * NVL(XB.CONVERT_TO_CELL, 1) AS NUMBER(30, 3)) AS CONFIRM_QTY_CELL
                             , CEIL(XA.QTY * 1000) / 1000 * NVL(XB.CONVERT_TO_PC_ROLL_LENGTH, 1) AS CONFIRM_QTY_ROLL_LENGTH
                             , NVL(XA.PACKAGE_TYPE_CODE, XB.PACKAGE_TYPE_CODE) AS PACKAGE_TYPE_CODE
                             , XB.BOX_PER_CUT
                             , XB.STEELCRATE_PER_CUT
                             , XB.STEELRACK_PER_CUT
                             , XB.ELECTRODE_POST_OPER
                             , XB.CELL_TYPE
                             , XA.YYYYMMDD
                             , XA.BOD_ID
                             , XA.REMARKS2
                             , XA.REMARKS
                             , XA.CHANGE_REQ_NO
                             , XA.REMARKS3
                             , XA.ETD_DATE
                             , XA.ETA_DATE
                             , XA.LAST_UPDATED_BY
                             , XA.LAST_UPDATE_DATE
                             , XA.CONFIRM_ID
                             , XA.ERP_STATUS
                             , XA.CHANGE_TYPE
                             , TO_CHAR(XA.ROUTE_ID) AS NEW_ROUTE_ID
                             , XA.BOD_ID AS NEW_BOD_ID
                             , XA.INCOTERMS AS NEW_INCOTERMS
                             , XA.D_COUNTRY AS NEW_D_COUNTRY
                             , XA.D_PORT_CODE AS NEW_D_PORT_CODE
                             , XA.A_COUNTRY AS NEW_A_COUNTRY
                             , XA.A_PORT_CODE AS NEW_A_PORT_CODE
                             , TO_CHAR(XA.CUSTOMER_LT) AS NEW_CUSTOMER_LT
                             , XA.TO_COUNTRY AS NEW_TO_COUNTRY
                             , XA.TO_CITY AS NEW_TO_CITY
                             , TO_CHAR(TO_DATE(XA.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                             , TO_CHAR(TO_DATE(XA.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                             , TO_CHAR(TO_DATE(XA.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_SHIPMENT_DATE
                             , 'N' AS EDIT_REMARKS
                             , 'N' AS EDIT_MAIN
                             , NVL(XA.CHECK_NEED_YN, 'N') AS CHECK_NEED_YN
                             , XA.ELECTRODE_YN
                             , NVL(XA.FACTORY_ID, XB.FACTORY_ID) AS FACTORY_ID
                             , NVL(XC.QTY, 0) AS SHIPPING_PLAN_QTY
                             , XA.ATTRIBUTE10
                          FROM SSP_ANL_SHIP_CONFIRM XA
                             , SSP_MST_SITE_ITEM_EE_V XB
                             , SSP_ANL_SHIP_PLAN_EE XC
                         WHERE XB.DIVISION_ID = XA.DIVISION_ID
                           AND XB.SCM_SITE_ID = XA.FROM_SITE
                           AND XB.ITEM_ID = XA.ITEM_ID
                           AND XC.MEASURE(+) = 'P_SHIP_PLAN_SIMU_ETD'
                           AND XC.PLAN_START_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
                           AND XC.DIVISION_ID(+) = XB.DIVISION_ID
                           AND XC.SCM_SITE_ID(+) = XB.SCM_SITE_ID
                           AND XC.ITEM_ID(+) = XB.ITEM_ID
                           AND XC.YYYYMMDD(+) = XA.YYYYMMDD
                           AND XA.CHANGE_TYPE = 'C'
                           AND XA.DIVISION_ID = P_DIVISION_ID
                           AND XA.FROM_SITE_COMPANY_ID = P_COMPANY_ID
                           AND (P_NON_CHK = 'Y'
                            OR EXISTS (SELECT 1
                                         FROM SSP_MST_MODEL_USER SA
                                        WHERE SA.DIVISION_ID = XA.DIVISION_ID
                                          AND SA.FROM_SITE = XA.FROM_SITE
                                          AND SA.ITEM_ID = XA.ITEM_ID
                                          AND SA.VALID_YN = 'Y'
                                          AND (SA.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                                                FROM DUAL
                                                              UNION
                                                              SELECT CASE WHEN P_DELEGATEE_CHK = 'Y' THEN SB.USER_ID ELSE 'X' END
                                                                FROM SSP_MST_DELEGATE SB
                                                               WHERE SB.VALID_YN = 'Y'
                                                                 AND SB.DELEGATEE_ID = P_USER_ID
                                                               GROUP BY SB.USER_ID)
                                           OR SA.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                           OR SA.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END)))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                           AND (TRIM(P_MODEL_ID) IS NULL
                            OR XB.MODEL_ID IN (SELECT COLUMN_VALUE
                                                 FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                           AND (TRIM(P_NICK_NAME) IS NULL
                            OR XB.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                          FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                           AND ((P_DBL_FLAG = 'Y'
                            AND XA.YYYYMMDD = P_FROM_YYYYMMDD)
                            OR (P_DBL_FLAG <> 'Y'
                            AND XA.YYYYMMDD >= P_FROM_YYYYMMDD
                            AND XA.YYYYMMDD <= P_TO_YYYYMMDD
                            AND (TRIM(P_REQUESTOR) IS NULL
/* 2026.09.30 AJS 수정 (START) */
--                             OR XA.REQUESTOR IN (SELECT DISTINCT SA.USERID
--                                                   FROM TB_FX_USER SA
--                                                  WHERE SA.USERNAME IN (SELECT COLUMN_VALUE
                             OR XA.REQUESTOR IN (SELECT DISTINCT SA.USER_ID
                                                   FROM SCM_ADM_USER_M SA
                                                  WHERE SA.USER_NM IN (SELECT COLUMN_VALUE
/* 2026.09.30 AJS 수정 (END) */
                                                                          FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))
                                                 UNION ALL
/* 2026.09.30 AJS 수정 (START) */
--                                                 SELECT DISTINCT SA.USERID
--                                                   FROM TB_FX_USER SA
--                                                  WHERE SA.USERID IN (SELECT COLUMN_VALUE
                                                 SELECT DISTINCT SA.USER_ID
                                                   FROM SCM_ADM_USER_M SA
                                                  WHERE SA.USER_ID IN (SELECT COLUMN_VALUE
/* 2026.09.30 AJS 수정 (END) */
                                                                        FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))))))
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                        UNION ALL
                        SELECT IA.DIVISION_ID
                             , IA.ERP_SO_NO
                             , IA.SHIPMENT_STATUS
                             , IA.ITEM_ID
                             , IA.ORIGIN_FROM_DIVISION_ID
                             , IA.ORIGIN_TO_DIVISION_ID
                             , IA.FROM_SITE
                             , IA.TO_SITE
                             , IA.REQUESTOR
                             , IA.QTY
                             , IA.ITEM_ID_NICK_NAME
                             , IA.MODEL_ID
                             , IA.MODEL_ID_NICK_NAME
                             , IA.ELECTRODE_TYPE
                             , IA.DOM_EXP_TYPE
                             , IA.CONFIRM_QTY_PANCAKE
                             , IA.CONFIRM_QTY_JR
                             , IA.CONFIRM_QTY_CELL
                             , IA.CONFIRM_QTY_ROLL_LENGTH
                             , IA.PACKAGE_TYPE_CODE
                             , IA.BOX_PER_CUT
                             , IA.STEELCRATE_PER_CUT
                             , IA.STEELRACK_PER_CUT
                             , IA.ELECTRODE_POST_OPER
                             , IA.CELL_TYPE
                             , IA.YYYYMMDD
                             , IA.BOD_ID
                             , IA.REMARKS2
                             , IA.REMARKS
                             , IA.CHANGE_REQ_NO
                             , IA.REMARKS3
                             , IA.ETD_DATE
                             , IA.ETA_DATE
                             , IA.LAST_UPDATED_BY
                             , IA.LAST_UPDATE_DATE
                             , IA.CONFIRM_ID
                             , '-' AS ERP_STATUS
                             , '-' AS CHANGE_TYPE
                             , '-' AS NEW_ROUTE_ID
                             , '-' AS NEW_BOD_ID
                             , '-' AS NEW_INCOTERMS
                             , '-' AS NEW_D_COUNTRY
                             , '-' AS NEW_D_PORT_CODE
                             , '-' AS NEW_A_COUNTRY
                             , '-' AS NEW_A_PORT_CODE
                             , '-' AS NEW_CUSTOMER_LT
                             , '-' AS NEW_TO_COUNTRY
                             , '-' AS NEW_TO_CITY
                             , '-' AS NEW_ETA
                             , '-' AS NEW_ETD
                             , '-' AS NEW_SHIPMENT_DATE
                             , '-' AS EDIT_REMARKS
                             , '-' AS EDIT_MAIN
                             , '-' AS CHECK_NEED_YN
                             , '-' AS ELECTRODE_YN
                             , IA.FACTORY_ID
                             , IA.SHIPPING_PLAN_QTY
                             , NULL AS ATTRIBUTE10
                          FROM (SELECT XA.FROM_DIVISION_ID AS DIVISION_ID
                                     , '-' AS ERP_SO_NO
                                     , 'P' AS SHIPMENT_STATUS
                                     , XA.ITEM_ID
                                     , XA.FROM_DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
                                     , XA.TO_DIVISION_ID AS ORIGIN_TO_DIVISION_ID
                                     , XA.FROM_SITE AS FROM_SITE
                                     , XA.TO_SITE AS TO_SITE
                                     , XA.LAST_UPDATED_BY AS REQUESTOR
                                     , XA.QTY
                                     , XA.ETD_DATE AS YYYYMMDD
                                     , XA.BOD_ID
                                     , '-' AS REMARKS2
                                     , '-' AS REMARKS
                                     , '-' AS CHANGE_REQ_NO
                                     , '-' AS REMARKS3
                                     , XA.ETD_DATE AS ETD_DATE
                                     , XA.ETA_DATE AS ETA_DATE
                                     , XA.LAST_UPDATED_BY
                                     , XA.LAST_UPDATE_DATE
                                     , '-' AS CONFIRM_ID
                                     , TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, XA.FROM_DIVISION_ID, XA.FROM_SITE, P_PLAN_START_YYYYMMDD), 'YYYYMMDD') AS FROZEN_YYYYMMDD
                                     , XC.FACTORY_ID
                                     , XC.ITEM_ID_NICK_NAME
                                     , XC.MODEL_ID
                                     , XC.MODEL_ID_NICK_NAME
                                     , XC.ELECTRODE_TYPE
                                     , XC.DOM_EXP_TYPE
                                     , TRUNC(XA.QTY * NVL(XC.CONVERT_TO_PCM, 1)) AS CONFIRM_QTY_PANCAKE
                                     , TRUNC(XA.QTY * NVL(XC.CONVERT_TO_JRM, 1)) AS CONFIRM_QTY_JR
                                     , TRUNC(XA.QTY * NVL(XC.CONVERT_TO_CELL, 1)) AS CONFIRM_QTY_CELL
                                     , CEIL(XA.QTY * NVL(XC.CONVERT_TO_PC_ROLL_LENGTH, 1)) AS CONFIRM_QTY_ROLL_LENGTH
                                     , XC.PACKAGE_TYPE_CODE AS PACKAGE_TYPE_CODE
                                     , XC.BOX_PER_CUT
                                     , XC.STEELCRATE_PER_CUT
                                     , XC.STEELRACK_PER_CUT
                                     , XC.ELECTRODE_POST_OPER
                                     , XC.CELL_TYPE
                                     , NVL(XD.QTY, 0) AS SHIPPING_PLAN_QTY
                                  FROM SSP_ANL_SHIP_REQ_EE XA
                                     , SCP_MST_BOD_N_V XB
                                     , SSP_MST_SITE_ITEM_EE_V XC
                                     , SSP_ANL_SHIP_PLAN_EE XD
                                 WHERE XA.FROM_DIVISION_ID = XB.DIVISION_ID
                                   AND XA.BOD_ID = XB.BOD_ID
                                   AND XC.DIVISION_ID = XA.FROM_DIVISION_ID
                                   AND XC.SCM_SITE_ID = XA.FROM_SITE
                                   AND XC.ITEM_ID = XA.ITEM_ID
                                   AND XD.MEASURE(+) = 'P_SHIP_PLAN_SIMU_ETD'
                                   AND XD.PLAN_START_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
                                   AND XD.DIVISION_ID(+) = XC.DIVISION_ID
                                   AND XD.SCM_SITE_ID(+) = XC.SCM_SITE_ID
                                   AND XD.ITEM_ID(+) = XC.ITEM_ID
                                   AND XD.YYYYMMDD(+) = XA.ETD_DATE
                                   AND XA.FROM_DIVISION_ID = P_DIVISION_ID
                                   AND XA.FROM_COMPANY_ID = P_COMPANY_ID
                                   AND (P_NON_CHK = 'Y'
                                    OR EXISTS (SELECT 1
                                                 FROM SSP_MST_MODEL_USER SA
                                                WHERE SA.DIVISION_ID = XA.FROM_DIVISION_ID
                                                  AND SA.FROM_SITE = XA.FROM_SITE
                                                  AND SA.ITEM_ID = XA.ITEM_ID
                                                  AND SA.VALID_YN = 'Y'
                                                  AND (SA.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                                                        FROM DUAL
                                                                      UNION
                                                                      SELECT CASE WHEN P_DELEGATEE_CHK = 'Y' THEN SB.USER_ID ELSE 'X' END
                                                                        FROM SSP_MST_DELEGATE SB
                                                                       WHERE SB.VALID_YN = 'Y'
                                                                         AND SB.DELEGATEE_ID = P_USER_ID
                                                                       GROUP BY SB.USER_ID)
                                                   OR SA.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                                   OR SA.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END)))
                                   AND (TRIM(P_ITEM_ID) IS NULL
                                    OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
                                                        FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                                   AND (TRIM(P_MODEL_ID) IS NULL
                                    OR XA.MODEL_ID IN (SELECT COLUMN_VALUE
                                                         FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                                   AND (TRIM(P_NICK_NAME) IS NULL
                                    OR XC.ITEM_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                                  FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                                   AND ((P_DBL_FLAG = 'Y'
                                    AND XA.ETD_DATE = P_FROM_YYYYMMDD)
                                    OR (P_DBL_FLAG <> 'Y'
                                    AND XA.ETD_DATE >= P_FROM_YYYYMMDD
                                    AND XA.ETD_DATE <= P_TO_YYYYMMDD))
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                          FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))) IA
                         WHERE IA.YYYYMMDD >= IA.FROZEN_YYYYMMDD) A
                     , SCP_MST_BOD_N_V B
/* 2026.09.30 AJS 수정 (START) */
--                     , TB_FX_USER C
                     , SCM_ADM_USER_M C
/* 2026.09.30 AJS 수정 (END) */
                     , (SELECT IA.CONFIRM_ID
                             , IA.CHANGE_REQ_NO
                          FROM (SELECT SA.CONFIRM_ID
                                     , SA.CHANGE_REQ_NO
                                     , ROW_NUMBER() OVER(PARTITION BY SA.CONFIRM_ID ORDER BY SA.CHANGE_REQ_NO DESC) AS NUM
                                  FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE SA
                                 WHERE SA.VALID_YN = 'Y') IA
                         WHERE IA.NUM = 1) D
                     , SSP_MST_MODEL_USER E
/* 2026.09.30 AJS 수정 (START) */
--                     , TB_FX_USER G
--                     , TB_FX_USER F
                     , SCM_ADM_USER_M G
                     , SCM_ADM_USER_M F
/* 2026.09.30 AJS 수정 (END) */
                     , SSP_ANL_SHIP_CONFIRM_CHG_REQ H
                 WHERE (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END) = B.DIVISION_ID
                   AND A.BOD_ID = B.BOD_ID
/* 2026.09.30 AJS 수정 (START) */
--                   AND A.LAST_UPDATED_BY = C.USERID(+)
--                   AND C.USEYN(+) = 'Y'
                   AND A.LAST_UPDATED_BY = C.USER_ID(+)
                   AND C.USE_YN(+) = 'Y'
/* 2026.09.30 AJS 수정 (END) */
                   AND D.CONFIRM_ID(+) = A.CONFIRM_ID
                   AND E.DIVISION_ID(+) = A.ORIGIN_FROM_DIVISION_ID
                   AND E.FROM_SITE(+) = A.FROM_SITE
                   AND E.ITEM_ID(+) = A.ITEM_ID
                   AND E.VALID_YN(+) = 'Y'
/* 2026.09.30 AJS 수정 (START) */
--                   AND E.USER_ID = G.USERID(+)
--                   AND G.USEYN(+) = 'Y'
--                   AND A.REQUESTOR = F.USERID(+)
--                   AND F.USEYN(+) = 'Y'
                   AND E.USER_ID = G.USER_ID(+)
                   AND G.USE_YN(+) = 'Y'
                   AND A.REQUESTOR = F.USER_ID(+)
                   AND F.USE_YN(+) = 'Y'
/* 2026.09.30 AJS 수정 (END) */
                   AND D.CHANGE_REQ_NO = H.CHANGE_REQ_NO(+)
                   AND A.SHIPMENT_STATUS IS NOT NULL
                   AND A.QTY > 0
                 ORDER BY A.DIVISION_ID, A.YYYYMMDD, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, A.ERP_SO_NO DESC;

        ELSE

            /* 과거기준 조회 */
            /* AS-IS 는 권한 조인에 존재하지 않는 별칭(C)을 써 NON_CHK <> 'Y' 경로가 SQL 오류로 끝난다 -- 2026.09.23 AJS */
            /* AS-IS 는 PLAN_START_YYYYMMDD · YYYYMMDD 조건에 따옴표가 빠져 숫자 비교가 된다 -- 2026.09.23 AJS */
            OPEN O_RC1 FOR
                SELECT A.DIVISION_ID
                     , A.ERP_SO_NO
                     , A.SHIPMENT_STATUS
                     , A.PROJECT_CODE
                     , A.PROJECT_NAME
                     , A.FCST_TYPE
                     , A.ITEM_ID
                     , A.NICK_NAME
                     , A.MODEL_ID
                     , A.MODEL_ID_NICK_NAME AS ITEM_ID_NICK_NAME
                     , A.SHIPMENT_DATE
                     , A.SHIPPING_PLAN_QTY
                     , A.SHIPMENT_CONFIRM_QTY
                     , A.REMARKS
                     , A.REMARKS2
                     , A.REMARKS3
                     , A.FROM_SITE
                     , A.FROM_SITE_DESCRIPTION
                     , A.TO_SITE
                     , A.TO_SITE_DESCRIPTION
                     , A.TO_SITE_SOLDTO_CODE
                     , A.TO_SITE_SHIPTO_CODE
                     , A.SOLDTO_DESCRIPTION
                     , A.SHIPTO_DESCRIPTION
                     , A.BOD_ID
                     , A.INCOTERMS
                     , A.TRANSPORT_MODE
                     , A.LT_DAY
                     , A.ETD
                     , A.ETA
                     , A.EXPECTED_SHIPPING_DATE
                     , A.CONFIRM_ID
                     , A.UPDATED_BY
                     , A.UPDATED_DATE
                     , '-' AS ERP_STATUS
                     , '-' AS CHANGE_TYPE
                     , '-' AS NEW_ROUTE_ID
                     , '-' AS NEW_BOD_ID
                     , '-' AS NEW_INCOTERMS
                     , '-' AS NEW_D_COUNTRY
                     , '-' AS NEW_D_PORT_CODE
                     , '-' AS NEW_A_COUNTRY
                     , '-' AS NEW_A_PORT_CODE
                     , '-' AS NEW_CUSTOMER_LT
                     , '-' AS NEW_TO_COUNTRY
                     , '-' AS NEW_TO_CITY
                     , '-' AS NEW_ETA
                     , '-' AS NEW_ETD
                     , '-' AS NEW_LT_DAY
                     , '-' AS NEW_TRANSPORT_MODE
                     , '-' AS NEW_SHIPMENT_DATE
                     , '-' AS EDIT_REMARKS
                     , '-' AS EDIT_MAIN
                     , '-' AS CHECK_NEED_YN
                     , A.END_CUSTOMER AS END_CUSTOMER
                     , '-' AS ELECTRODE_YN
                     , '-' AS ELECTRODE_TYPE
                     , '-' AS ORIGIN_FROM_DIVISION_ID
                     , '-' AS ORIGIN_TO_DIVISION_ID
                     , A.CHANGE_REQ_NO AS CHANGE_REQ_NO
                     , A.MODEL_USER AS MODEL_USER
                     , A.MTK_OWNER AS MTK_OWNER
                     , A.REQUESTOR AS REQUESTOR
                     , A.CHANGE_REASON_CODE
                     , A.CHANGE_REASON_DETAIL
                     , A.DOM_EXP AS DOM_EXP
                     , A.DAYOFWEEK_NAME AS DAYOFWEEK_NAME
                     , A.GAP AS GAP
                     , A.CONFIRM_QTY_ROLL_LENGTH
                     , A.PACKAGE_TYPE
                     , A.PACKAGE_QTY
                     , A.ELECTRODE_POST_OPER
                     , A.CONFIRM_QTY_PANCAKE
                     , A.CONFIRM_QTY_JR
                     , A.CONFIRM_QTY_CELL
                     , A.CELL_TYPE
                     , A.FACTORY_ID
                     , ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.ERP_SO_NO, A.SHIPMENT_STATUS, A.CELL_TYPE, A.SHIPMENT_DATE, A.ITEM_ID, A.MODEL_ID, A.FROM_SITE, A.TO_SITE
                                             ORDER BY A.DIVISION_ID, A.SHIPMENT_STATUS, A.ERP_SO_NO DESC, A.CELL_TYPE, A.SHIPMENT_DATE, A.ITEM_ID, A.FROM_SITE, A.TO_SITE) AS MERGE_NUM
                  FROM (SELECT XA.DIVISION_ID
                             , XA.ERP_SO_NO
                             , XA.SHIPMENT_STATUS
                             , XA.ITEM_ID
                             , XA.NICK_NAME
                             , XA.MODEL_ID
                             , XA.MODEL_ID_NICK_NAME
                             , XA.ORIGIN_FROM_DIVISION_ID
                             , XA.ORIGIN_TO_DIVISION_ID
                             , XA.FROM_SITE
                             , XA.FROM_SITE_DESCRIPTION
                             , XA.TO_SITE
                             , XA.TO_SITE_DESCRIPTION
                             , XA.PROJECT_CODE
                             , XA.PROJECT_NAME
                             , XA.REQUESTOR
                             , XA.SHIPMENT_CONFIRM_QTY
                             , XA.SHIPPING_PLAN_QTY
                             , TRUNC(XA.SHIPPING_PLAN_QTY - NVL(XA.SHIPMENT_CONFIRM_QTY, 0)) AS GAP
                             , TO_CHAR(TO_DATE(XA.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS SHIPMENT_DATE
                             , XA.BOD_ID
                             , XA.INCOTERMS
                             , XA.TRANSPORT_MODE
                             , XA.TO_SITE_SOLDTO_CODE
                             , XA.TO_SITE_SHIPTO_CODE
                             , XA.SOLDTO_DESCRIPTION
                             , XA.SHIPTO_DESCRIPTION
                             , XA.REMARKS2
                             , XA.REMARKS
                             , XA.CHANGE_REQ_NO
                             , XA.REMARKS3
                             , TO_CHAR(TO_DATE(XA.ETD, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                             , TO_CHAR(TO_DATE(XA.ETA, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                             , XA.EXPECTED_SHIPPING_DATE
                             , XA.LT_DAY AS LT_DAY
                             , XA.UPDATED_BY AS UPDATED_BY
                             , XA.UPDATED_DATE AS UPDATED_DATE
                             , XA.CONFIRM_ID AS CONFIRM_ID
                             , XA.FCST_TYPE
                             , XA.END_CUSTOMER
                             , XA.MTK_OWNER
                             , XA.MODEL_USER
                             , XA.DOM_EXP
                             , XA.DAYOFWEEK_NAME
                             , XA.CONFIRM_QTY_ROLL_LENGTH
                             , XA.PACKAGE_TYPE
                             , XA.PACKAGE_QTY
                             , XA.ELECTRODE_POST_OPER
                             , XA.CONFIRM_QTY_PANCAKE
                             , XA.CONFIRM_QTY_JR
                             , XA.CONFIRM_QTY_CELL
                             , XA.CELL_TYPE
                             , XA.CHANGE_REASON_CODE
                             , XA.CHANGE_REASON_DETAIL
                             , XA.FACTORY_ID
                          FROM SSP_ANL_SHIP_PLAN_ALL XA
                         WHERE XA.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND XA.DIVISION_ID = P_DIVISION_ID
                           AND XA.COMPANY_ID = P_COMPANY_ID
                           AND XA.SHIPMENT_CONFIRM_QTY > 0
                           AND XA.OPERATION_GROUP = 'E'
                           AND XA.YYYYMMDD >= P_FROM_YYYYMMDD
                           AND XA.YYYYMMDD <= P_TO_YYYYMMDD
                           AND (P_NON_CHK = 'Y'
                            OR EXISTS (SELECT 1
                                         FROM SSP_MST_MODEL_USER SA
                                        WHERE SA.DIVISION_ID = XA.DIVISION_ID
                                          AND SA.FROM_SITE = XA.FROM_SITE
                                          AND SA.ITEM_ID = XA.ITEM_ID
                                          AND SA.VALID_YN = 'Y'
                                          AND (SA.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                                                FROM DUAL
                                                              UNION
                                                              SELECT CASE WHEN P_DELEGATEE_CHK = 'Y' THEN SB.USER_ID ELSE 'X' END
                                                                FROM SSP_MST_DELEGATE SB
                                                               WHERE SB.VALID_YN = 'Y'
                                                                 AND SB.DELEGATEE_ID = P_USER_ID
                                                               GROUP BY SB.USER_ID)
                                           OR SA.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                           OR SA.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END)))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           AND (TRIM(P_MODEL_ID) IS NULL
                            OR XA.MODEL_ID IN (SELECT COLUMN_VALUE
                                                 FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))))
                           AND (TRIM(P_NICK_NAME) IS NULL
                            OR XA.MODEL_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                                           FROM TABLE(STRING_SPLIT(P_NICK_NAME, ','))))
                           AND ((P_DBL_FLAG = 'Y'
                            AND XA.YYYYMMDD = P_FROM_YYYYMMDD)
                            OR (P_DBL_FLAG <> 'Y'
                            AND XA.YYYYMMDD >= P_FROM_YYYYMMDD
                            AND XA.YYYYMMDD <= P_TO_YYYYMMDD
                            AND (TRIM(P_REQUESTOR) IS NULL
/* 2026.09.30 AJS 수정 (START) */
--                             OR XA.REQUESTOR IN (SELECT DISTINCT SA.USERID
--                                                   FROM TB_FX_USER SA
--                                                  WHERE SA.USERNAME IN (SELECT COLUMN_VALUE
                             OR XA.REQUESTOR IN (SELECT DISTINCT SA.USER_ID
                                                   FROM SCM_ADM_USER_M SA
                                                  WHERE SA.USER_NM IN (SELECT COLUMN_VALUE
/* 2026.09.30 AJS 수정 (END) */
                                                                          FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))
                                                 UNION ALL
/* 2026.09.30 AJS 수정 (START) */
--                                                 SELECT DISTINCT SA.USERID
--                                                   FROM TB_FX_USER SA
--                                                  WHERE SA.USERID IN (SELECT COLUMN_VALUE
                                                 SELECT DISTINCT SA.USER_ID
                                                   FROM SCM_ADM_USER_M SA
                                                  WHERE SA.USER_ID IN (SELECT COLUMN_VALUE
/* 2026.09.30 AJS 수정 (END) */
                                                                        FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))))))) A
                 ORDER BY A.DIVISION_ID, A.SHIPMENT_STATUS, A.SHIPMENT_DATE, A.ITEM_ID, A.ERP_SO_NO DESC, A.FROM_SITE, A.TO_SITE, A.PROJECT_CODE, A.FCST_TYPE;

        END IF;

    END P_SSP0023_GET_SHIPMENT_PLAN_DETAIL;

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_REQUESTOR             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) DETAIL
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-07-29   KIMYONGHO		신규추가
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.COMPANY_ID AS COMPANY_ID
                 , A.DIVISION_ID AS DIVISION_ID
                 , A.SCM_SITE_ID AS FROM_SITE
                 , A.ITEM_ID AS ITEM_ID
                 , A.YYYYMMDD AS YYYYMMDD
                 , NVL(B.QTY, 0) AS QTY
                 , NULL AS "Comment"                                            /* 예약어라 이름을 그대로 유지한다 */
              FROM (SELECT XB.COMPANY_ID
                         , XB.DIVISION_ID
                         , XB.PLANT_ID
                         , XB.SCM_SITE_ID
                         , XB.MODEL_ID
                         , XB.ITEM_ID
                         , XA.YYYYMMDD
                      FROM SSP_MST_SHIP_CALENDAR XA
                         , SSP_ANL_SHIP_PLAN_EE XB
                     WHERE XB.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND XB.COMPANY_ID = P_COMPANY_ID
                       AND XB.DIVISION_ID = P_DIVISION_ID
                       AND XB.SCM_SITE_ID IS NOT NULL                           /* AS-IS 의 LIKE '%' 조건 */
                       AND XB.MODEL_ID IS NOT NULL                              /* AS-IS 의 LIKE '%' 조건 */
                       AND XB.MEASURE = 'P_SHIP_PLAN_SIMU_ETD'
                       AND XB.COMPANY_ID = XA.COMPANY_ID
                       AND XB.DIVISION_ID = XA.DIVISION_ID
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR XB.ITEM_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                       AND XA.DIVISION_ID = P_DIVISION_ID
                       AND XA.COMPANY_ID = P_COMPANY_ID
                       AND XA.YYYYMMDD >= P_FROM_YYYYMMDD
                       AND XA.YYYYMMDD <= P_TO_YYYYMMDD
                     GROUP BY XB.COMPANY_ID
                            , XB.DIVISION_ID
                            , XB.PLANT_ID
                            , XB.SCM_SITE_ID
                            , XB.MODEL_ID
                            , XB.ITEM_ID
                            , XA.YYYYMMDD) A
                 , SSP_ANL_SHIP_PLAN_EE B
             WHERE B.PLAN_START_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
               AND B.COMPANY_ID(+) = P_COMPANY_ID
               AND B.DIVISION_ID(+) = P_DIVISION_ID
               AND B.MEASURE(+) = 'P_SHIP_PLAN_SIMU_ETD'
               AND B.QTY(+) > 0
               AND A.COMPANY_ID = B.COMPANY_ID(+)
               AND A.DIVISION_ID = B.DIVISION_ID(+)
               AND A.PLANT_ID = B.PLANT_ID(+)
               AND A.SCM_SITE_ID = B.SCM_SITE_ID(+)
               AND A.MODEL_ID = B.MODEL_ID(+)
               AND A.ITEM_ID = B.ITEM_ID(+)
               AND A.YYYYMMDD = B.YYYYMMDD(+)
             ORDER BY A.ITEM_ID, A.YYYYMMDD;

    END P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL;

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_RESULT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_TYPE                  IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_MYMODELCHK            IN  VARCHAR2
       ,P_PARTLEADERCHK         IN  VARCHAR2
       ,P_TEAMLEADERCHK         IN  VARCHAR2
       ,P_DELEGATEECHK          IN  VARCHAR2
       ,P_NONCHK                IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN_RESULT
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode)
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-06-05   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2020.09.18	KIMYONGHO		ERP_ORDER_TYPE 주석 처리 Request by 김광희 책임
 * 2021.02.17	KIMYONGHO		실적 조회시 TRNSPORT_MODE, INCOTERMS, ERP_SO_NO, ETA_DATE, ETD_DATE ERP 실적 기준으로 조회 Request by 김광희 책임
 * 2021.04.05   KIMYONGHO       [C20210330-000402] Shipment Plan화면의 실적 조회시 Sales site Mapping 안되는건에 대해서도 전수 표시 요청
 * 2021.05.03   SSP Pjt.        SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE LOOKUP적용
 * 2021.11.15   KIMYONGHO       Confirm Data Plan Date 기준 조회 처리
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID AS COMPANY_ID
                 , C.SEGMENT2 AS TYPE
                 , A.ERP_SO_NO
                 , A.CONFIRM_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                 , E.MODEL_ID
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), A.FROM_SITE) AS FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), A.TO_SITE) AS TO_SITE
                 , A.END_CUSTOMER
                 , A.QTY
                 , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS YYYYMMDD
                 , A.TRANSPORT_MODE
                 , A.INCOTERMS
                 , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD_DATE
                 , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA_DATE
                 , A.SHIP_TYPE
              FROM (/* CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 */
                    SELECT IA.DIVISION_ID AS DIVISION_ID
                         , 'E' AS TYPE
                         , IA.ERP_SO_NO AS ERP_SO_NO
                         , IA.CONFIRM_ID AS CONFIRM_ID
                         , IA.ITEM_ID AS ITEM_ID
                         , IA.FROM_SITE AS FROM_SITE
                         , IA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , SUM(IA.RESULT_QTY) AS QTY
                         , IA.YYYYMMDD AS YYYYMMDD
                         , IA.TRANSPORT_MODE AS TRANSPORT_MODE
                         , IA.INCOTERMS AS INCOTERMS
                         , IA.ETD_DATE AS ETD_DATE
                         , IA.ETA_DATE AS ETA_DATE
                         , NULL AS SHIP_TYPE
                      FROM (/* ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 */
                            SELECT XA.DIVISION_ID AS DIVISION_ID
                                 , XA.CONFIRM_ID AS CONFIRM_ID
                                 , XA.ORDER_NO AS ERP_SO_NO
                                 , XA.EXFACTORY_DATE AS YYYYMMDD
                                 , XA.TRANSPORT_MODE AS TRANSPORT_MODE
                                 , XA.INCOTERMS AS INCOTERMS
                                 , XA.ETA_DATE AS ETA_DATE
                                 , XA.ETD_DATE AS ETD_DATE
                                 , XA.FROM_SCM_SITE_ID AS FROM_SITE
                                 , XA.TO_SCM_SITE_ID AS TO_SITE
                                 , XA.ITEM_ID AS ITEM_ID
                                 , SUM(XA.EXFACTORY_QTY) AS RESULT_QTY
                              FROM SCM_DNM_EXFACTORY_RESULT XA
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL XB
                             WHERE XB.LOOKUP_TYPE = 'ERP_SSP_TYPE'              /* LOOKUP에 등록된 공정만 */
                               AND XB.VALID_YN = 'Y'
                               AND XB.SEGMENT1 = XA.SSP_TYPE
                               AND NVL(XA.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')    /* D90: DO삭제 , D10:DO생성 */
                               AND XA.CONFIRM_ID LIKE 'C%'
                               AND XA.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY XA.DIVISION_ID
                                    , XA.CONFIRM_ID
                                    , XA.ORDER_NO
                                    , XA.EXFACTORY_DATE
                                    , XA.TRANSPORT_MODE
                                    , XA.INCOTERMS
                                    , XA.ETA_DATE
                                    , XA.ETD_DATE
                                    , XA.FROM_SCM_SITE_ID
                                    , XA.TO_SCM_SITE_ID
                                    , XA.ITEM_ID) IA
                     GROUP BY IA.DIVISION_ID
                            , IA.ERP_SO_NO
                            , IA.FROM_SITE
                            , IA.TO_SITE
                            , IA.ITEM_ID
                            , IA.TRANSPORT_MODE
                            , IA.INCOTERMS
                            , IA.ETD_DATE
                            , IA.ETA_DATE
                            , IA.YYYYMMDD
                            , IA.CONFIRM_ID
                    UNION ALL
                    /* CONFIRM_ID 없는 실적 */
                    SELECT IA.DIVISION_ID AS DIVISION_ID
                         , 'E' AS TYPE
                         , IA.ERP_SO_NO AS ERP_SO_NO
                         , NULL AS CONFIRM_ID
                         , IA.ITEM_ID AS ITEM_ID
                         , IA.FROM_SITE AS FROM_SITE
                         , IA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , IA.QTY AS QTY
                         , IA.YYYYMMDD AS YYYYMMDD
                         , IA.TRANSPORT_MODE AS TRANSPORT_MODE
                         , IA.INCOTERMS AS INCOTERMS
                         , IA.ETD_DATE AS ETD_DATE
                         , IA.ETA_DATE AS ETA_DATE
                         , NULL AS SHIP_TYPE
                      FROM (/* ERP 출하실적에서 CONFIRM_ID 없는 실적 */
                            SELECT XA.DIVISION_ID AS DIVISION_ID
                                 , '-' AS CONFIRM_ID
                                 , XA.ORDER_NO AS ERP_SO_NO
                                 , XA.FROM_SCM_SITE_ID AS FROM_SITE
                                 , NVL(XE.SEGMENT4, XA.TO_SCM_SITE_ID) AS TO_SITE
                                 , XA.ITEM_ID AS ITEM_ID
                                 , XA.EXFACTORY_DATE AS YYYYMMDD
                                 , XA.TRANSPORT_MODE AS TRANSPORT_MODE
                                 , XA.INCOTERMS AS INCOTERMS
                                 , XA.ETA_DATE AS ETA_DATE
                                 , XA.ETD_DATE AS ETD_DATE
                                 , SUM(XA.EXFACTORY_QTY) AS QTY
                              FROM SCM_DNM_EXFACTORY_RESULT XA
                                 , SCP_MST_FINAL_ITEM XB                        /* SCP 대상 ITEM만 */
                                 , SCM_MST_SITE XC
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL XE
                             WHERE XB.ITEM_ID = XA.ITEM_ID
                               AND XB.DIVISION_ID = XA.DIVISION_ID
                               AND XC.SCM_SITE_ID = XA.FROM_SCM_SITE_ID
                               AND XC.DIVISION_ID = XA.DIVISION_ID
                               /* 2020.09.18 김광희 책임 요청으로 주석처리 */
                               /* 2021.04.15 김광희 책임 요청으로 주석해제 */
                               AND XD.LOOKUP_TYPE = 'ERP_ORDER_TYPE'            /* LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 */
                               AND XD.VALID_YN = 'Y'
                               AND XD.SEGMENT1 = XA.ORDER_TYPE_CODE
                               AND XE.LOOKUP_TYPE(+) = 'SHIP_RESULT_TO_SITE_MAPPING'    /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
                               AND XE.SEGMENT1(+) = XA.DIVISION_ID
                               AND XE.SEGMENT2(+) = XA.SOLDTO_CODE
                               AND XE.SEGMENT3(+) = XA.SHIPTO_CODE
                               AND NVL(XA.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')    /* D90: DO삭제 , D10:DO생성 */
                               AND NVL(XA.CONFIRM_ID, '-') NOT LIKE 'C%'
                               AND XA.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND XA.STORAGE_ID NOT IN ('6000', '799A')        /* 상품창고제외 */
                               /* [C20200403-000062] 사외 창고 제외 LOOKUP 관리 */
                               AND NOT EXISTS (SELECT 1
                                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                                WHERE SA.SEGMENT1 = XA.STORAGE_ID
                                                  AND SA.LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                                                  AND SA.VALID_YN = 'Y')
                             GROUP BY XA.DIVISION_ID
                                    , XA.ORDER_NO
                                    , XA.FROM_SCM_SITE_ID
                                    , NVL(XE.SEGMENT4, XA.TO_SCM_SITE_ID)
                                    , XA.ITEM_ID
                                    , XA.EXFACTORY_DATE
                                    , XA.TRANSPORT_MODE
                                    , XA.INCOTERMS
                                    , XA.ETA_DATE
                                    , XA.ETD_DATE) IA
                    UNION ALL
                    SELECT IA.DIVISION_ID AS DIVISION_ID
                         , 'P' AS TYPE
                         , IA.ERP_SO_NO AS ERP_SO_NO
                         , IA.CONFIRM_ID AS CONFIRM_ID
                         , IA.ITEM_ID AS ITEM_ID
                         , IA.FROM_SITE AS FROM_SITE
                         , IA.TO_SITE AS TO_SITE
                         , IA.END_CUSTOMER AS END_CUSTOMER
                         , IA.QTY AS QTY
                         , IA.YYYYMMDD AS YYYYMMDD
                         , IA.TRANSPORT_MODE AS TRANSPORT_MODE
                         , IA.INCOTERMS AS INCOTERMS
                         , IA.ETD_DATE AS ETD_DATE
                         , IA.ETA_DATE AS ETA_DATE
                         , NULL AS SHIP_TYPE
                      FROM (/* SSP출하계획 ( confirm된 계획) - Current Version */
                            SELECT XA.DIVISION_ID AS DIVISION_ID
                                 , XA.ERP_SO_NO AS ERP_SO_NO
                                 , XA.CONFIRM_ID AS CONFIRM_ID
                                 , XA.ITEM_ID AS ITEM_ID
                                 , XA.FROM_SITE AS FROM_SITE
                                 , XA.TO_SITE AS TO_SITE
                                 , CASE WHEN XA.DIVISION_ID = '4O' THEN NVL(XB.PROJECT_CODE, '-')
                                        ELSE NVL(XC.END_CUSTOMER, '-')
                                   END AS END_CUSTOMER
                                 , XA.QTY AS QTY
                                 , XA.YYYYMMDD AS YYYYMMDD
                                 , XA.TRANSPORT_MODE AS TRANSPORT_MODE
                                 , XA.INCOTERMS AS INCOTERMS
                                 , XA.ETD_DATE AS ETD_DATE
                                 , XA.ETA_DATE AS ETA_DATE
                                 , NULL AS SHIP_TYPE
                              FROM SSP_ANL_SHIP_CONFIRM XA
                                 , SCM_MST_SITE_ITEM XB
                                 , SCM_MST_SITE XC
                             WHERE XB.DIVISION_ID(+) = XA.DIVISION_ID
                               AND XB.ITEM_ID(+) = XA.ITEM_ID
                               AND XB.SCM_SITE_ID(+) = XA.TO_SITE
                               AND XB.PROJECT_CODE(+) = XA.PROJECT_CODE
                               AND XC.DIVISION_ID(+) = XA.DIVISION_ID
                               AND XC.SCM_SITE_ID(+) = XA.TO_SITE
                               AND XA.CHANGE_TYPE = 'C'
                               AND XA.QTY > 0
                               AND XA.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD) IA
                    UNION ALL
                    /* OWMS 실적 */
                    SELECT IA.DIVISION_ID AS DIVISION_ID
                         , 'O' AS TYPE
                         , NULL AS ERP_SO_NO
                         , NULL AS CONFIRM_ID
                         , IA.ITEM_ID AS ITEM_ID
                         , IA.FROM_SITE AS FROM_SITE
                         , IA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , IA.QTY AS QTY
                         , IA.YYYYMMDD AS YYYYMMDD
                         , NULL AS TRANSPORT_MODE
                         , NULL AS INCOTERMS
                         , NULL AS ETD_DATE
                         , NULL AS ETA_DATE
                         , IA.SHIP_TYPE AS SHIP_TYPE
                      FROM (/* owms 출하실적 */
                            SELECT DIVISION_ID AS DIVISION_ID
                                 , ITEM_ID AS ITEM_ID
                                 , FROM_SITE AS FROM_SITE
                                 , CASE WHEN TO_SITE = '-' THEN CUSTOMER_CODE ELSE TO_SITE END AS TO_SITE
                                 , SUM(LOT_QTY) AS QTY
                                 , PLANT_ISSUE_DATE AS YYYYMMDD
                                 , SHIP_TYPE AS SHIP_TYPE
                              FROM SSP_DNM_SHIP_RESULT_OWMS
                             WHERE PLANT_ISSUE_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY DIVISION_ID
                                    , ITEM_ID
                                    , FROM_SITE
                                    , CASE WHEN TO_SITE = '-' THEN CUSTOMER_CODE ELSE TO_SITE END
                                    , PLANT_ISSUE_DATE
                                    , SHIP_TYPE) IA
                    UNION ALL
                    /* OWMS 반품실적 */
                    SELECT IA.DIVISION_ID AS DIVISION_ID
                         , 'R' AS TYPE
                         , NULL AS ERP_SO_NO
                         , NULL AS CONFIRM_ID
                         , IA.ITEM_ID AS ITEM_ID
                         , IA.FROM_SITE AS FROM_SITE
                         , IA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , IA.QTY AS QTY
                         , IA.YYYYMMDD AS YYYYMMDD
                         , NULL AS TRANSPORT_MODE
                         , NULL AS INCOTERMS
                         , NULL AS ETD_DATE
                         , NULL AS ETA_DATE
                         , IA.SHIP_TYPE AS SHIP_TYPE
                      FROM (/* owms 출하 반품 */
                            SELECT DIVISION_ID AS DIVISION_ID
                                 , ITEM_ID AS ITEM_ID
                                 , FROM_SITE AS FROM_SITE
                                 , '*' AS TO_SITE
                                 , SUM(RECIEPT_QTY) AS QTY
                                 , RECIEPT_DATE AS YYYYMMDD
                                 , NULL AS SHIP_TYPE
                              FROM SSP_DNM_SHIP_RETURN_OWMS
                             WHERE RECIEPT_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY DIVISION_ID
                                    , ITEM_ID
                                    , FROM_SITE
                                    , RECIEPT_DATE) IA) A
                 , SCM_MST_SITE B
                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
                 , SSP_MST_MODEL_USER D
                 , SSP_MST_SITE_ITEM_EE_V E
             WHERE B.DIVISION_ID = A.DIVISION_ID
               AND B.SCM_SITE_ID = A.FROM_SITE
               AND B.OPERATION_GROUP = 'E'
               AND C.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE'                   /* LOOKUP에 등록된 공정만 */
               AND C.SEGMENT1 = A.TYPE
               AND C.VALID_YN = 'Y'
               AND D.DIVISION_ID(+) = A.DIVISION_ID
               AND D.FROM_SITE(+) = A.FROM_SITE
               AND D.ITEM_ID(+) = A.ITEM_ID
               AND D.VALID_YN(+) = 'Y'
               AND E.DIVISION_ID = A.DIVISION_ID
               AND E.SCM_SITE_ID = A.FROM_SITE
               AND E.ITEM_ID = A.ITEM_ID
               AND A.DIVISION_ID = P_DIVISION_ID
               AND (TRIM(P_COMPANY_ID) IS NULL
                OR B.COMPANY_ID = P_COMPANY_ID)
               AND (TRIM(P_FROM_SITE) IS NULL
                OR A.FROM_SITE IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
               AND (TRIM(P_ITEM_ID) IS NULL
                OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
               AND (TRIM(P_TYPE) IS NULL
                OR A.TYPE IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(P_TYPE, ','))))
               /* 체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태) */
               AND (P_NONCHK = 'Y'
                OR D.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                   FROM DUAL
                                 UNION
                                 SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN SA.USER_ID ELSE 'X' END
                                   FROM SSP_MST_DELEGATE SA
                                  WHERE SA.VALID_YN = 'Y'
                                    AND SA.DELEGATEE_ID = P_USER_ID
                                  GROUP BY SA.USER_ID)
                OR D.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                OR D.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
               /* 체크박스 체크 여부 조회 끝 */
             ORDER BY A.DIVISION_ID, A.FROM_SITE, A.YYYYMMDD, A.ITEM_ID, A.TO_SITE, C.DISPLAY_SEQ, A.CONFIRM_ID;

    END P_SSP0023_GET_SHIPMENT_PLAN_RESULT;

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_LOT_ID                IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) STOCK DETAIL
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-06-03   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2020-06-30   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - operation_id ,iWMS Qty, IWMS Hold YN 추가 ,
								storage_id 변경 (변경 전 : SL.STORAGE_DESCRIPTION + ''('' + SC.STORAGE_ID+'')''	AS STORAGE_ID	)
 * 2020-07-09   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - NICK_NAME 조회 조건 추가
 * 2020-07-21   juhlee   		Pallet id 추가
 * 2020-07-21   KIMYONGHO   		'ELECTRODE_SHIP_STORAGE'  재고 집계 제외 대상 추가
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , B.MODEL_ID
                 , A.ITEM_ID
                 , B.ITEM_ID_NICK_NAME AS NICK_NAME
                 , A.VERSION
                 , CAST(B.LANE AS NUMBER(5, 2)) AS LANE
                 , A.LOT_ID
                 , A.PALLET_ID
                 , A.STORAGE_ID AS STORAGE_ID
                 , A.OPERATION_ID AS OPERATION_ID
                 , D.SEGMENT2 AS CHANGE_STATUS
                 , A.FROM_SITE
                 /* FLOOR - > CEILING 으로 변경 KIMYONGHO 2020-09-03 */
                 , CEIL(A.IWMS_QTY) AS IWMS_QTY_UOM
                 , CEIL(A.IWMS_QTY * NVL(B.CONVERT_TO_PCM, 1)) AS IWMS_QTY_PCM
                 , CEIL(A.GMES_QTY) AS GMES_QTY_UOM
                 , CEIL(A.GMES_QTY * NVL(B.CONVERT_TO_PCM, 1)) AS GMES_QTY_PCM
                 , CEIL(A.OWMS_QTY) AS OWMS_QTY_UOM
                 , CEIL(A.OWMS_QTY * NVL(B.CONVERT_TO_PCM, 1)) AS OWMS_QTY_PCM
                 , CEIL(A.TOT_QTY) AS TOTAL_QTY_UOM
                 , CEIL(A.TOT_QTY * NVL(B.CONVERT_TO_PCM, 1)) AS TOTAL_QTY_PCM
                 , A.AVAILABLE_YN
                 , A.IWMS_HOLD_YN
                 , A.QMS_HOLD_YN
                 , A.GMES_HOLD_YN AS MES_HOLD_YN
                 , A.OWMS_HOLD_YN
                 , A.EXPIRATION_DATE
                 , A.PACKAGE_TYPE AS PACKAGE_TYPE_CODE
              FROM SSP_ANL_STOCK_EE_C A
                 , SSP_MST_SITE_ITEM_EE_V B
                 , SCM_MST_SLOC C
                 , SCM_ADM_LOOKUP_MASTER_DETAIL D
             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.FROM_SITE
               AND B.ITEM_ID(+) = A.ITEM_ID
               AND C.PLANT_ID(+) = A.PLANT_ID
               AND C.STORAGE_ID(+) = A.STORAGE_ID
               AND C.DIVISION_ID(+) = A.DIVISION_ID
               AND D.LOOKUP_TYPE = 'MES_CHANGE_STATUS'
               AND D.VALID_YN = 'Y'
               AND D.SEGMENT1 = A.CHANGE_STATUS
               AND A.TYPE = 'E'
               AND (P_NON_CHK = 'Y'
                OR EXISTS (SELECT 1
                             FROM SSP_MST_MODEL_USER SA
                            WHERE SA.DIVISION_ID = A.DIVISION_ID
                              AND SA.FROM_SITE = A.FROM_SITE
                              AND SA.ITEM_ID = A.ITEM_ID
                              AND SA.VALID_YN = 'Y'
                              AND (SA.USER_ID IN (SELECT CASE WHEN P_MY_MODEL_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                                    FROM DUAL
                                                  UNION
                                                  SELECT CASE WHEN P_DELEGATEE_CHK = 'Y' THEN SB.USER_ID ELSE 'X' END
                                                    FROM SSP_MST_DELEGATE SB
                                                   WHERE SB.VALID_YN = 'Y'
                                                     AND SB.DELEGATEE_ID = P_USER_ID
                                                   GROUP BY SB.USER_ID)
                               OR SA.PART_LEADER = CASE WHEN P_PART_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END
                               OR SA.TEAM_LEADER = CASE WHEN P_TEAM_LEADER_CHK = 'Y' THEN P_USER_ID ELSE 'X' END)))
               AND (TRIM(P_PLAN_START_YYYYMMDD) IS NULL
                OR A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD)
               AND (TRIM(P_DIVISION_ID) IS NULL
                OR A.DIVISION_ID = P_DIVISION_ID)
               AND (TRIM(P_COMPANY_ID) IS NULL
                OR A.COMPANY_ID = P_COMPANY_ID)
               AND (TRIM(P_FROM_SITE) IS NULL
                OR A.FROM_SITE = P_FROM_SITE)
               AND (TRIM(P_ITEM_ID) IS NULL
                OR A.ITEM_ID = P_ITEM_ID)
               AND (TRIM(P_NICK_NAME) IS NULL
                OR B.ITEM_ID_NICK_NAME = P_NICK_NAME)
               AND (TRIM(P_LOT_ID) IS NULL
                OR A.LOT_ID = P_LOT_ID)
             ORDER BY A.PLANT_ID, B.MODEL_ID, A.ITEM_ID, A.LOT_ID;

    END P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL;

    PROCEDURE P_SSP0023_SAVE_SHIPMENT_PLAN_SIMU
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
       ,P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_PLANT_ID              IN  VARCHAR2
       ,P_SCM_SITE_ID           IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_NPC_ITEM_ID           IN  VARCHAR2
       ,P_YYYYMMDD              IN  VARCHAR2
       ,P_QTY                   IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_MEASURE               IN  VARCHAR2
       ,P_LAST_UPDATED_BY       IN  VARCHAR2
       ,P_ELECTRODE_TYPE        IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    )
    IS
/*
 * PROGRAM ID   : SSP0023_SAVE_SHIPMENT_PLAN_SIMU
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) - SIMULATION 저장
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-04-28   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2020-06-29   khj79			SSP_ANL_SHIP_PLAN_SIMU_EE 저장 시 사용자 입력 값 저장 되도록 수정
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_ACTIVE_FLAG           VARCHAR2(4000);
        V_DIVISION_ID           VARCHAR2(4000);
        V_COMPANY_ID            VARCHAR2(4000);
        V_PLANT_ID              VARCHAR2(4000);
        V_SCM_SITE_ID           VARCHAR2(4000);
        V_MODEL_ID              VARCHAR2(4000);
        V_ITEM_ID               VARCHAR2(4000);
        V_NPC_ITEM_ID           VARCHAR2(4000);
        V_YYYYMMDD              VARCHAR2(4000);
        V_QTY                   VARCHAR2(4000);
        V_PLAN_START_YYYYMMDD   VARCHAR2(4000);
        V_MEASURE               VARCHAR2(4000);
        V_LAST_UPDATED_BY       VARCHAR2(4000);
        V_ELECTRODE_TYPE        VARCHAR2(4000);
        V_DELIMITER             VARCHAR2(1) := '^';
        MAX_LOOP_CNT            NUMBER := 0;
        MST_LOOP_CNT            NUMBER := 0;
        /* SIMULATION 저장 용 변수 설정 */
        N_SIMU_SEQ              NUMBER;
        /* QTY_TO_PCM, QTY_TO_CELL 용 변수 설정 */
        V_QTY_TO_PCM            NUMBER;
        V_QTY_TO_CELL           NUMBER;
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150) := 'PKG_SSP0023_CHK.P_SSP0023_SAVE_SHIPMENT_PLAN_SIMU';
        V_LOG_TYPE              VARCHAR2(30);                                   /* START/END/ERROR/... */
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000);
        V_DESCRIPTION           VARCHAR2(500);
        D_EVENT_DATE            DATE;
        /* 예외처리 변수 설정 */
        V_ERR_MSG               VARCHAR2(4000);
        V_ERR_CODE              NUMBER;
    BEGIN

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 로그 프로시저가 자체 COMMIT 을 하므로 되돌림 지점은 그 뒤에 잡는다 */
        SAVEPOINT SP_SAVE_SIMU;

        /* 프로시저 LOOP 길이를 판단 */
        MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        MST_LOOP_CNT := 0;

        WHILE LENGTH(RTRIM(P_ACTIVE_FLAG)) > 0 AND MST_LOOP_CNT < MAX_LOOP_CNT LOOP

            /* MST_LOOP_CNT 1증가 */
            MST_LOOP_CNT := MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_DIVISION_ID := SCM_ARR_SPL_VAL(P_DIVISION_ID, V_DELIMITER, MST_LOOP_CNT);
            V_COMPANY_ID := SCM_ARR_SPL_VAL(P_COMPANY_ID, V_DELIMITER, MST_LOOP_CNT);
            V_PLANT_ID := SCM_ARR_SPL_VAL(P_PLANT_ID, V_DELIMITER, MST_LOOP_CNT);
            V_SCM_SITE_ID := SCM_ARR_SPL_VAL(P_SCM_SITE_ID, V_DELIMITER, MST_LOOP_CNT);
            V_MODEL_ID := SCM_ARR_SPL_VAL(P_MODEL_ID, V_DELIMITER, MST_LOOP_CNT);
            V_ITEM_ID := SCM_ARR_SPL_VAL(P_ITEM_ID, V_DELIMITER, MST_LOOP_CNT);
            V_YYYYMMDD := SCM_ARR_SPL_VAL(P_YYYYMMDD, V_DELIMITER, MST_LOOP_CNT);
            V_QTY := SCM_ARR_SPL_VAL(P_QTY, V_DELIMITER, MST_LOOP_CNT);
            V_PLAN_START_YYYYMMDD := SCM_ARR_SPL_VAL(P_PLAN_START_YYYYMMDD, V_DELIMITER, MST_LOOP_CNT);
            V_MEASURE := SCM_ARR_SPL_VAL(P_MEASURE, V_DELIMITER, MST_LOOP_CNT);
            V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER, MST_LOOP_CNT);
            V_ELECTRODE_TYPE := SCM_ARR_SPL_VAL(P_ELECTRODE_TYPE, V_DELIMITER, MST_LOOP_CNT);

            /*// QTY_TO_PCM , QTY_TO_CELL 구하기 */
            /* AS-IS 는 대상 행이 없으면 앞 행에서 구한 값이 그대로 남는다 */
            BEGIN
                SELECT NVL(TO_NUMBER(V_QTY) * NVL(A.CONVERT_TO_PCM, 1), 0)
                     , NVL(TO_NUMBER(V_QTY) * NVL(A.CONVERT_TO_CELL, 1), 0)
                  INTO V_QTY_TO_PCM
                     , V_QTY_TO_CELL
                  FROM SSP_MST_SITE_ITEM_EE_V A
                 WHERE A.DIVISION_ID = V_DIVISION_ID
                   AND A.SCM_SITE_ID = V_SCM_SITE_ID
                   AND A.ITEM_ID = V_ITEM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            /* 데이터 저장 */
            IF MST_LOOP_CNT > 0 THEN

                /*// SIMULATION 저장 */
                N_SIMU_SEQ := SEQ1_SSP_ANL_SHIP_PLAN_SIMU_EE.NEXTVAL;

                INSERT INTO SSP_ANL_SHIP_PLAN_SIMU_EE
                (
                    SEQ
                  , COMPANY_ID
                  , DIVISION_ID
                  , PLANT_ID
                  , SCM_SITE_ID
                  , MODEL_ID
                  , ITEM_ID
                  , NPC_ITEM_ID
                  , YYYYMMDD
                  , QTY
                  , QTY_TO_CELL
                  , PLAN_START_YYYYMMDD
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                )
                SELECT N_SIMU_SEQ
                     , COMPANY_ID
                     , DIVISION_ID
                     , PLANT_ID
                     , SCM_SITE_ID
                     , MODEL_ID
                     , ITEM_ID
                     , NPC_ITEM_ID
                     , YYYYMMDD
                     , TO_NUMBER(V_QTY)
                     , V_QTY_TO_CELL
                     , PLAN_START_YYYYMMDD
                     , V_LAST_UPDATED_BY
                     , SYSDATE
                     , V_LAST_UPDATED_BY
                     , SYSDATE
                  FROM SSP_ANL_SHIP_PLAN_EE
                 WHERE PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND COMPANY_ID = V_COMPANY_ID
                   AND DIVISION_ID = V_DIVISION_ID
                   AND PLANT_ID = V_PLANT_ID
                   AND SCM_SITE_ID = V_SCM_SITE_ID
                   AND MODEL_ID = V_MODEL_ID
                   AND ITEM_ID = V_ITEM_ID
                   AND MEASURE = V_MEASURE
                   AND YYYYMMDD = V_YYYYMMDD;

                /* 원문 MERGE 는 온라인 SQL 금지라 UPDATE 후 건수로 INSERT 를 가른다 */
                UPDATE SSP_ANL_SHIP_PLAN_EE
                   SET QTY = TO_NUMBER(V_QTY)
                     , QTY_TO_PCM = V_QTY_TO_PCM
                     , QTY_TO_CELL = V_QTY_TO_CELL
                     , LAST_UPDATED_BY = V_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE = SYSDATE
                 WHERE PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND COMPANY_ID = V_COMPANY_ID
                   AND DIVISION_ID = V_DIVISION_ID
                   AND PLANT_ID = V_PLANT_ID
                   AND SCM_SITE_ID = V_SCM_SITE_ID
                   AND MODEL_ID = V_MODEL_ID
                   AND ITEM_ID = V_ITEM_ID
                   AND MEASURE = V_MEASURE
                   AND YYYYMMDD = V_YYYYMMDD;

                IF SQL%ROWCOUNT = 0 THEN

                    INSERT INTO SSP_ANL_SHIP_PLAN_EE
                    (
                        PLAN_START_YYYYMMDD
                      , COMPANY_ID
                      , DIVISION_ID
                      , PLANT_ID
                      , SCM_SITE_ID
                      , MODEL_ID
                      , ITEM_ID
                      , NPC_ITEM_ID
                      , MEASURE_TYPE
                      , MEASURE
                      , YYYYMMDD
                      , QTY
                      , QTY_TO_PCM
                      , QTY_TO_CELL
                      , FROM_DIVISION_ID
                      , FROM_SITE
                      , TO_DIVISION_ID
                      , TO_SITE
                      , BOD_ID
                      , ELECTRODE_TYPE
                      , ETD_DATE
                      , ETA_DATE
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                    )
                    VALUES
                    (
                        V_PLAN_START_YYYYMMDD
                      , V_COMPANY_ID
                      , V_DIVISION_ID
                      , V_PLANT_ID
                      , V_SCM_SITE_ID
                      , V_MODEL_ID
                      , V_ITEM_ID
                      , NULL
                      , 'P'
                      , V_MEASURE
                      , V_YYYYMMDD
                      , TO_NUMBER(V_QTY)
                      , V_QTY_TO_PCM
                      , V_QTY_TO_CELL
                      , '-'
                      , '-'
                      , '-'
                      , '-'
                      , '-'
                      , V_ELECTRODE_TYPE
                      , '-'
                      , '-'
                      , V_LAST_UPDATED_BY
                      , SYSDATE
                      , V_LAST_UPDATED_BY
                      , SYSDATE
                    );

                END IF;

            END IF;                                                             /* END OF STMT. IF( @mst_loop_cnt > 0 ) */

        END LOOP;                                                               /* END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt */

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE
                 , MAX_LOOP_CNT AS RESULT_CNT
              FROM DUAL;

        OPEN O_RC2 FOR
            SELECT NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 2;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_MSG := SQLERRM;
            V_ERR_CODE := SQLCODE;

            /* 입력 데이타 롤백 처리 — 커서를 열기 전에 되돌린다 */
            ROLLBACK TO SP_SAVE_SIMU;

            INSERT INTO SCM_SYS_LOG_BATCH
            (
                PROGRAM_NAME
              , LOG_TYPE
              , LOG_COUNT
              , LOG_MESSAGE
              , DESCRIPTION
              , EVENT_DATE
              , CREATION_DATE
              , CREATED_BY
              , LAST_UPDATE_DATE
              , LAST_UPDATED_BY
            )
            VALUES
            (
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MSG
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE
                     , NULL AS RESULT_CNT
                  FROM DUAL;

            OPEN O_RC2 FOR
                SELECT TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MSG AS ERR_MESSAGE
                  FROM DUAL;

    END P_SSP0023_SAVE_SHIPMENT_PLAN_SIMU;

END PKG_SSP0023_CHK;
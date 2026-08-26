-- [BACKUP 2026-08-24] SCM_MGR.DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP (PROCEDURE, VALID)
-- 원본 LAST_DDL = 2026-07-21 16:38:57

CREATE OR REPLACE PROCEDURE           "DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP"
(
    P_DIVISION_ID     IN VARCHAR2,
    P_FROM_YYYYMMDD   IN VARCHAR2,
    P_TO_YYYYMMDD     IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP]                                           */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2021.05.13	P.C.I		 [PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))*/
/* 2022.10.24	ROSIA27				[C20221024-000510]DM UI 소스 정리 요청							*/
/* 2026.03.20  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/
AS
  -- DM0020_GET_SCM_MST_FUTURE_PRICE '', '', '', '', '', ''

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    -- CASE WHEN 'ALL' 패턴 → UNION ALL 분기 (Case 17)
    OPEN O_RC1 FOR
    SELECT DIVISION_ID
         , CURRENCY
         , UNIT_CURRENCY
         , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   DM_MST_EXCHANGE_RATE T1

        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
    AND    YYYYMMDD <= P_TO_YYYYMMDD
    AND    P_DIVISION_ID = 'ALL'
    --[PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
    AND    UNIT_CURRENCY IN (
               SELECT SEGMENT1
               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A
               WHERE  LOOKUP_TYPE = 'DMF0020_CURRENCY'
               AND    VALID_YN    = 'Y'
           )
    AND    CURRENCY = 'KRW'
    GROUP BY DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN

    UNION ALL

    SELECT DIVISION_ID
         , CURRENCY
         , UNIT_CURRENCY
         , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN

    FROM   DM_MST_EXCHANGE_RATE T1

        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
    AND    YYYYMMDD <= P_TO_YYYYMMDD
    AND    P_DIVISION_ID <> 'ALL'
    AND    DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    --[PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
    AND    UNIT_CURRENCY IN (
               SELECT SEGMENT1
               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A
               WHERE  LOOKUP_TYPE = 'DMF0020_CURRENCY'
               AND    VALID_YN    = 'Y'
           )
    AND    CURRENCY = 'KRW'
    GROUP BY DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN
    ORDER BY 1, 2, 3;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_DIVISION_ID'   VALUE P_DIVISION_ID,
                'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
                'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
                'P_CREATED_BY'    VALUE P_CREATED_BY
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP;
/

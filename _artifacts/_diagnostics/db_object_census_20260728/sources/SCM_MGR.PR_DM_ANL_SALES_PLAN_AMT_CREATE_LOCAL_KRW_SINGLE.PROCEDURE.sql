PROCEDURE         PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE

/*
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE
 * Description  : Sales Plan AMT Create ( Local/KRW )
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 05. 10    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 수행시 PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 를 호출하여
 * sales price 화면에서 Batch Job 누른 것과 같은 로직을 수행하도록함
 * 20180824 KHSONG 사용자정보 변수값 사용으로 적용 / [SCM_MST_FUTURE_PRICE] JOIN 조건 보완
 * 20191114 KHSONG 컬럼값 미지정에서 지정으로 보완
 * 20200213 HWI1993 자동차사업부 SALES AMT 메저를 RTF_SCP 기준으로 생성
 * 20200309 KHSONG TMM_FCST ADD
 * 20200507 KHSONG C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020/08/06		hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020/12/08		P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2024/11/15		KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선		
 * 2025/01/21		KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025/01/21		JSSBAE		[E20250121-000405]_Sales Plan에서 Catch-up 메저 삭제되는 현상 조정
 * 2025.02.11		KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 SCM_FCST MEASURE 추가
 * 2025.04.03		KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요.
 * 2025.04.08		KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.28		KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 CELL_PROD_SITE_ID 추가
 * 2026.03.26       jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 * ---------------------------------------------------------------------------------------------------
 */
AS
    V_DIVISION_ID    VARCHAR2(4000 CHAR);
    V_CREATED_BY     VARCHAR2(4000 CHAR);

    V_PROGRAM_NAME          VARCHAR2(200 CHAR);
    V_LOG_TYPE       VARCHAR2(30 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    D_EVENT_DATE     DATE;
    V_THIS_WEEK_MON  VARCHAR2(8 CHAR);

    -- EXCEPTION 블록 필수 변수
    N_DELETE_COUNT      PLS_INTEGER := 0;
    N_INSERT_COUNT      PLS_INTEGER := 0;
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- GTT 초기화 (프로시저 시작 시 일반 테이블 DML 이전이므로 TRUNCATE 사용 가능)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_SALES_PLAN_TEMP_SINGLE';

    -- V_this_week_mon := TO_CHAR(NEXT_DAY(TRUNC(SYSDATE), 'MONDAY') - 7, 'YYYYMMDD');
    V_THIS_WEEK_MON := TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD');

    SELECT MAX(V_CREATED_BY)
      INTO V_CREATED_BY
      FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE;

    SELECT MAX(V_DIVISION_ID)
      INTO V_DIVISION_ID
      FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE;

    -- 시작 LOG  (START)
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    SAVEPOINT SALES_PLAN_LOCAL_KRW_SINGLE;

    --------------------------------------------------------------------------------------------
    BEGIN
    --------------------------------------------------------------------------------------------

        /*----------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/

        BEGIN

            -- 사용자정보값 변수에 저장 20180824 KHSONG
            SELECT MAX(V_CREATED_BY)
              INTO V_CREATED_BY
              FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE;

            -- 기존 정보 삭제
            DELETE
              FROM SCM_MGR.DM_PLN_SALES_PLAN D
             WHERE D.YYYYMMDD >= V_THIS_WEEK_MON
               ----------------------------------------------------------- 20180510 skh add start
               AND EXISTS (
                    SELECT 1
                      FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE R -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
                     WHERE D.DIVISION_ID      = R.V_DIVISION_ID
                       AND D.PROJECT_CODE     = R.V_PROJECT_CODE
                       AND D.SCM_SITE_ID      = R.V_SCM_SITE_ID
                       AND D.ITEM_ID          = R.V_ITEM_ID
                       AND D.DOM_EXP          = R.V_DOM_EXP
                       AND D.FCST_TYPE        = R.V_FCST_TYPE
                       AND D.INCOTERMS        = R.V_INCOTERMS
                       AND D.PLANT_SITE_ID    = R.V_PLANT_SITE_ID
               )
               ----------------------------------------------------------- 20180510 skh add end

               -- MKT/금형비처럼 사람이 넣은것 삭제.
               AND EXISTS (
                    SELECT 1
                      FROM SCM_MGR.SCM_MST_ITEM_SN S
                     WHERE S.ITEM_ID = D.ITEM_ID
               )
               -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
               AND NOT EXISTS (
                    SELECT 1
                      FROM SCM_MGR.SCM_MST_SITE_ITEM A
                      JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                        ON A.ITEM_ID       = B.ITEM_ID
                       AND A.DIVISION_ID   = B.DIVISION_ID
                       AND A.PROJECT_CODE  = B.PROJECT_CODE
                       AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                     WHERE A.SALES_PLAN_ADJUST_YN = 'N'
                       AND B.LAST_UPDATED_BY NOT IN ('SYSTEM', 'CUTOFF')
                       AND B.YYYYMMDD >= V_THIS_WEEK_MON
                       AND A.DIVISION_ID   = D.DIVISION_ID
                       AND A.PROJECT_CODE  = D.PROJECT_CODE
                       AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                       AND A.ITEM_ID       = D.ITEM_ID
               )
               --[E20250121-000405]_Sales Plan에서 Catch-up 메저 삭제되는 현상 조정
               AND D.MEASURE NOT IN ('CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up'); --Catch Up 메저 삭제 금지

            --DBMS_OUTPUT.PUT_LINE('AA');

            -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
            DELETE
              FROM SCM_MGR.DM_PLN_SALES_PLAN D
             WHERE D.YYYYMMDD >= V_THIS_WEEK_MON
               ----------------------------------------------------------- 20180510 skh add start
               AND EXISTS (
                    SELECT 1
                      FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE R -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
                     WHERE D.DIVISION_ID      = R.V_DIVISION_ID
                       AND D.PROJECT_CODE     = R.V_PROJECT_CODE
                       AND D.SCM_SITE_ID      = R.V_SCM_SITE_ID
                       AND D.ITEM_ID          = R.V_ITEM_ID
                       AND D.DOM_EXP          = R.V_DOM_EXP
                       AND D.FCST_TYPE        = R.V_FCST_TYPE
                       AND D.INCOTERMS        = R.V_INCOTERMS
                       AND D.PLANT_SITE_ID    = R.V_PLANT_SITE_ID
               )
               ----------------------------------------------------------- 20180510 skh add end
               -- MKT/금형비처럼 사람이 넣은것 삭제.
               AND EXISTS (
                    SELECT 1
                      FROM SCM_MGR.SCM_MST_ITEM_SN S
                     WHERE S.ITEM_ID = D.ITEM_ID
               )
               AND D.MEASURE IN ('MKT_FCST', 'CUST_FCST', 'RTF', 'RTF_SYS_RP', 'TMM_FCST', 'SCM_FCST');  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD--[PJ2025-50017] SCM_FCST 추가

            -- 임시테이블 생성
            -- 20191114 KHSONG 컬럼값 미지정에서 지정으로 보완
            INSERT INTO SCM_MGR.GT_PRDM_SALES_PLAN_TEMP_SINGLE
            (
                DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
                CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
            )
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
                   CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                   ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
              FROM SCM_MGR.DM_PLN_SALES_PLAN
             WHERE 1 = 0;

            --DBMS_OUTPUT.PUT_LINE('BB');

            -- Temp 테이블에 저장
            INSERT INTO SCM_MGR.GT_PRDM_SALES_PLAN_TEMP
            (
                 DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
                ,CELL_PROD_SITE_ID
                ,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
            )
            WITH W_MKT AS
            (
                SELECT /*+ MATERIALIZE */
                       W.DIVISION_ID
                     , W.PROJECT_CODE
                     , W.SCM_SITE_ID
                     , W.ITEM_ID
                     , W.DOM_EXP
                     , W.FCST_TYPE
                     , W.INCOTERMS
                     , W.MEASURE
                     , W.PLANT_SITE_ID
                     , W.YYYYMMDD
                     , W.QTY
                     , W.CREATED_BY
                     , W.CREATION_DATE
                     , C.BASIS_START_DATE
                  FROM SCM_MGR.DM_PLN_MKT_FCST W
                  JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
                    ON C.BASIS_YYYYMMDD = W.YYYYMMDD
                 WHERE W.YYYYMMDD >= V_THIS_WEEK_MON
                   AND EXISTS (
                        SELECT 1
                          FROM SCM_MGR.GT_PRDM_RESULTS R
                         WHERE W.DIVISION_ID      = R.V_DIVISION_ID
                           AND W.PROJECT_CODE     = R.V_PROJECT_CODE
                           AND W.SCM_SITE_ID      = R.V_SCM_SITE_ID
                           AND W.ITEM_ID          = R.V_ITEM_ID
                           AND W.DOM_EXP          = R.V_DOM_EXP
                           AND W.FCST_TYPE        = R.V_FCST_TYPE
                           AND W.INCOTERMS        = R.V_INCOTERMS
                           AND W.PLANT_SITE_ID    = R.V_PLANT_SITE_ID
                   )
                   AND EXISTS (
                        SELECT 1
                          FROM SCM_MGR.SCM_MST_ITEM_SN S
                         WHERE S.ITEM_ID = W.ITEM_ID
                   )
            )
            -- MKT FCST 값을 update 함.
            SELECT
                 W.DIVISION_ID
                ,W.PROJECT_CODE
                ,W.SCM_SITE_ID
                ,W.ITEM_ID
                ,W.DOM_EXP
                ,W.FCST_TYPE
                ,W.INCOTERMS
                ,W.MEASURE
                ,W.PLANT_SITE_ID
                ,'-' AS CELL_PROD_SITE_ID
                ,W.YYYYMMDD
                ,SI.CURRENCY
                ,W.QTY
                ,NVL(W.CREATED_BY,'SYSTEM')
                ,W.CREATION_DATE
                ,V_CREATED_BY
                ,SYSDATE
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
            FROM W_MKT W
            LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE SI
              ON W.DIVISION_ID       = SI.DIVISION_ID
             AND W.PROJECT_CODE      = SI.PROJECT_CODE
             AND W.SCM_SITE_ID       = SI.SCM_SITE_ID
             AND W.ITEM_ID           = SI.ITEM_ID
             AND W.DOM_EXP           = SI.DOM_EXP
             AND W.FCST_TYPE         = SI.FCST_TYPE
             AND W.INCOTERMS         = SI.INCOTERMS
             AND W.PLANT_SITE_ID     = SI.PLANT_SITE_ID
             AND W.BASIS_START_DATE  = SI.YYYYMMDD
            WHERE W.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD --[PJ2025-50017] SCM_FCST 추가

            UNION ALL

            -- KRW 값을 계산
            SELECT
                 W.DIVISION_ID
                ,W.PROJECT_CODE
                ,W.SCM_SITE_ID
                ,W.ITEM_ID
                ,W.DOM_EXP
                ,W.FCST_TYPE
                ,W.INCOTERMS
                ,'MKT_AMT_KRW' MEASURE
                ,W.PLANT_SITE_ID
                ,'-' AS CELL_PROD_SITE_ID
                ,W.YYYYMMDD
                ,FP.CURRENCY
                ,ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                ,V_CREATED_BY
                ,SYSDATE
                ,'SYSTEM'
                ,SYSDATE
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
            FROM W_MKT W
            LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
              ON FP.DIVISION_ID      = W.DIVISION_ID
             AND FP.PROJECT_CODE     = W.PROJECT_CODE
             AND FP.SCM_SITE_ID      = W.SCM_SITE_ID
             AND FP.ITEM_ID          = W.ITEM_ID
             AND FP.DOM_EXP          = W.DOM_EXP
             AND FP.FCST_TYPE        = W.FCST_TYPE
             AND FP.INCOTERMS        = W.INCOTERMS
             AND FP.PLANT_SITE_ID    = W.PLANT_SITE_ID
             AND FP.YYYYMMDD         = W.BASIS_START_DATE
             AND FP.MEASURE          = 'KRW'
            WHERE W.MEASURE = 'MKT_FCST'
              AND W.DIVISION_ID = '40'

            UNION ALL

            -- LOC 값을 계산
            SELECT
                 W.DIVISION_ID
                ,W.PROJECT_CODE
                ,W.SCM_SITE_ID
                ,W.ITEM_ID
                ,W.DOM_EXP
                ,W.FCST_TYPE
                ,W.INCOTERMS
                ,'MKT_AMT_LOC' MEASURE
                ,W.PLANT_SITE_ID
                ,'-' AS CELL_PROD_SITE_ID
                ,W.YYYYMMDD
                ,FP.CURRENCY
                ,ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                ,V_CREATED_BY
                ,SYSDATE
                ,'SYSTEM'
                ,SYSDATE
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
            FROM W_MKT W
            LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
              ON FP.DIVISION_ID      = W.DIVISION_ID
             AND FP.PROJECT_CODE     = W.PROJECT_CODE
             AND FP.SCM_SITE_ID      = W.SCM_SITE_ID
             AND FP.ITEM_ID          = W.ITEM_ID
             AND FP.DOM_EXP          = W.DOM_EXP
             AND FP.FCST_TYPE        = W.FCST_TYPE
             AND FP.INCOTERMS        = W.INCOTERMS
             AND FP.PLANT_SITE_ID    = W.PLANT_SITE_ID
             AND FP.YYYYMMDD         = W.BASIS_START_DATE
             AND FP.MEASURE          = 'LOC'
            WHERE W.MEASURE = 'MKT_FCST'
              AND W.DIVISION_ID = '40';

            --[PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. Start
            --DBMS_OUTPUT.PUT_LINE('CC');

            INSERT INTO SCM_MGR.GT_PRDM_SALES_PLAN_TEMP
            (
                 DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
                ,PLANT_SITE_ID
                ,CELL_PROD_SITE_ID
                ,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
            )
            WITH W_RTF AS
            (
                SELECT /*+ MATERIALIZE */
                       W.DIVISION_ID
                     , W.PROJECT_CODE
                     , W.SCM_SITE_ID
                     , W.ITEM_ID
                     , W.DOM_EXP
                     , W.FCST_TYPE
                     , W.INCOTERMS
                     , W.MEASURE
                     , W.PLANT_SITE_ID
                     , W.CELL_PROD_SITE_ID
                     , W.YYYYMMDD
                     , W.QTY
                     , W.CREATED_BY
                     , W.CREATION_DATE
                     , C.BASIS_START_DATE
                  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN W
                  JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
                    ON C.BASIS_YYYYMMDD = W.YYYYMMDD
                 WHERE W.YYYYMMDD >= V_THIS_WEEK_MON
                   AND EXISTS (
                        SELECT 1
                          FROM SCM_MGR.GT_PRDM_RESULTS R -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
                         WHERE W.DIVISION_ID      = R.V_DIVISION_ID
                           AND W.PROJECT_CODE     = R.V_PROJECT_CODE
                           AND W.SCM_SITE_ID      = R.V_SCM_SITE_ID
                           AND W.ITEM_ID          = R.V_ITEM_ID
                           AND W.DOM_EXP          = R.V_DOM_EXP
                           AND W.FCST_TYPE        = R.V_FCST_TYPE
                           AND W.INCOTERMS        = R.V_INCOTERMS
                           AND W.PLANT_SITE_ID    = R.V_PLANT_SITE_ID
                   )
                   AND EXISTS (
                        SELECT 1
                          FROM SCM_MGR.SCM_MST_ITEM_SN S
                         WHERE S.ITEM_ID = W.ITEM_ID
                   )
            )
            -- RTF 값을 update 함.
            SELECT
                 W.DIVISION_ID
                ,W.PROJECT_CODE
                ,W.SCM_SITE_ID
                ,W.ITEM_ID
                ,W.DOM_EXP
                ,W.FCST_TYPE
                ,W.INCOTERMS
                ,W.MEASURE
                ,W.PLANT_SITE_ID
                ,W.CELL_PROD_SITE_ID
                ,W.YYYYMMDD
                ,SI.CURRENCY
                ,W.QTY
                ,NVL(W.CREATED_BY,'SYSTEM')
                ,W.CREATION_DATE
                ,V_CREATED_BY
                ,SYSDATE
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
            FROM W_RTF W
            LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE SI
              ON W.DIVISION_ID      = SI.DIVISION_ID
             AND W.PROJECT_CODE     = SI.PROJECT_CODE
             AND W.SCM_SITE_ID      = SI.SCM_SITE_ID
             AND W.ITEM_ID          = SI.ITEM_ID
             AND W.DOM_EXP          = SI.DOM_EXP
             AND W.FCST_TYPE        = SI.FCST_TYPE
             AND W.INCOTERMS        = SI.INCOTERMS
             AND W.PLANT_SITE_ID    = SI.PLANT_SITE_ID
             AND W.BASIS_START_DATE = SI.YYYYMMDD
            WHERE W.MEASURE IN ('RTF','RTF_SYS_RP')

            UNION ALL

            -- KRW 값을 계산
            SELECT
                 W.DIVISION_ID
                ,W.PROJECT_CODE
                ,W.SCM_SITE_ID
                ,W.ITEM_ID
                ,W.DOM_EXP
                ,W.FCST_TYPE
                ,W.INCOTERMS
                ,'SalesAmt_KRW' MEASURE
                ,W.PLANT_SITE_ID
                ,W.CELL_PROD_SITE_ID
                ,W.YYYYMMDD
                ,FP.CURRENCY
                ,ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                ,V_CREATED_BY
                ,SYSDATE
                ,'SYSTEM'
                ,SYSDATE
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
            FROM W_RTF W
            LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
              ON FP.DIVISION_ID      = W.DIVISION_ID
             AND FP.PROJECT_CODE     = W.PROJECT_CODE
             AND FP.SCM_SITE_ID      = W.SCM_SITE_ID
             AND FP.ITEM_ID          = W.ITEM_ID
             AND FP.DOM_EXP          = W.DOM_EXP
             AND FP.FCST_TYPE        = W.FCST_TYPE
             AND FP.INCOTERMS        = W.INCOTERMS
             AND FP.PLANT_SITE_ID    = W.PLANT_SITE_ID
             AND FP.YYYYMMDD         = W.BASIS_START_DATE
             AND FP.MEASURE          = 'KRW'
            WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
              -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
              AND NOT EXISTS (
                    SELECT 1
                      FROM SCM_MGR.SCM_MST_SITE_ITEM A
                      JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                        ON A.ITEM_ID      = B.ITEM_ID
                       AND A.DIVISION_ID  = B.DIVISION_ID
                       AND A.PROJECT_CODE = B.PROJECT_CODE
                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                     WHERE A.SALES_PLAN_ADJUST_YN = 'N'
                       AND B.LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')
                       AND B.YYYYMMDD >= V_THIS_WEEK_MON
                       AND A.DIVISION_ID = W.DIVISION_ID
                       AND A.PROJECT_CODE = W.PROJECT_CODE
                       AND A.SCM_SITE_ID = W.SCM_SITE_ID
                       AND A.ITEM_ID = W.ITEM_ID
              )

            UNION ALL

            -- LOC 값을 계산
            SELECT
                 W.DIVISION_ID
                ,W.PROJECT_CODE
                ,W.SCM_SITE_ID
                ,W.ITEM_ID
                ,W.DOM_EXP
                ,W.FCST_TYPE
                ,W.INCOTERMS
                ,'SalesAmt_LOC' MEASURE
                ,W.PLANT_SITE_ID
                ,W.CELL_PROD_SITE_ID
                ,W.YYYYMMDD
                ,FP.CURRENCY
                ,ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                ,V_CREATED_BY
                ,SYSDATE
                ,'SYSTEM'
                ,SYSDATE
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
            FROM W_RTF W
            LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
              ON FP.DIVISION_ID      = W.DIVISION_ID
             AND FP.PROJECT_CODE     = W.PROJECT_CODE
             AND FP.SCM_SITE_ID      = W.SCM_SITE_ID
             AND FP.ITEM_ID          = W.ITEM_ID
             AND FP.DOM_EXP          = W.DOM_EXP
             AND FP.FCST_TYPE        = W.FCST_TYPE
             AND FP.INCOTERMS        = W.INCOTERMS
             AND FP.PLANT_SITE_ID    = W.PLANT_SITE_ID
             AND FP.YYYYMMDD         = W.BASIS_START_DATE
             AND FP.MEASURE          = 'LOC'
            WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
              -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
              AND NOT EXISTS (
                    SELECT 1
                      FROM SCM_MGR.SCM_MST_SITE_ITEM A
                      JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                        ON A.ITEM_ID      = B.ITEM_ID
                       AND A.DIVISION_ID  = B.DIVISION_ID
                       AND A.PROJECT_CODE = B.PROJECT_CODE
                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                     WHERE A.SALES_PLAN_ADJUST_YN = 'N'
                       AND B.LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')
                       AND B.YYYYMMDD >= V_THIS_WEEK_MON
                       AND A.DIVISION_ID = W.DIVISION_ID
                       AND A.PROJECT_CODE = W.PROJECT_CODE
                       AND A.SCM_SITE_ID = W.SCM_SITE_ID
                       AND A.ITEM_ID = W.ITEM_ID
              )

            UNION ALL

            -- USD 값을 계산
            SELECT
                 W.DIVISION_ID
                ,W.PROJECT_CODE
                ,W.SCM_SITE_ID
                ,W.ITEM_ID
                ,W.DOM_EXP
                ,W.FCST_TYPE
                ,W.INCOTERMS
                ,'SalesAmt_USD' MEASURE
                ,W.PLANT_SITE_ID
                ,W.CELL_PROD_SITE_ID
                ,W.YYYYMMDD
                ,FP.CURRENCY
                ,ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                ,V_CREATED_BY
                ,SYSDATE
                ,'SYSTEM'
                ,SYSDATE
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
            FROM W_RTF W
            LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
              ON FP.DIVISION_ID      = W.DIVISION_ID
             AND FP.PROJECT_CODE     = W.PROJECT_CODE
             AND FP.SCM_SITE_ID      = W.SCM_SITE_ID
             AND FP.ITEM_ID          = W.ITEM_ID
             AND FP.DOM_EXP          = W.DOM_EXP
             AND FP.FCST_TYPE        = W.FCST_TYPE
             AND FP.INCOTERMS        = W.INCOTERMS
             AND FP.PLANT_SITE_ID    = W.PLANT_SITE_ID
             AND FP.YYYYMMDD         = W.BASIS_START_DATE
             AND FP.MEASURE          = 'USD'
            WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
              -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
              AND NOT EXISTS (
                    SELECT 1
                      FROM SCM_MGR.SCM_MST_SITE_ITEM A
                      JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                        ON A.ITEM_ID      = B.ITEM_ID
                       AND A.DIVISION_ID  = B.DIVISION_ID
                       AND A.PROJECT_CODE = B.PROJECT_CODE
                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                     WHERE A.SALES_PLAN_ADJUST_YN = 'N'
                       AND B.LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')
                       AND B.YYYYMMDD >= V_THIS_WEEK_MON
                       AND A.DIVISION_ID = W.DIVISION_ID
                       AND A.PROJECT_CODE = W.PROJECT_CODE
                       AND A.SCM_SITE_ID = W.SCM_SITE_ID
                       AND A.ITEM_ID = W.ITEM_ID
              );

            --[PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. End
            --DBMS_OUTPUT.PUT_LINE('DD');

            -- select * from #SALES_PLAN_TEMP;
            -- 테이블의 중복제거
            BEGIN
                DELETE
                  FROM SCM_MGR.DM_PLN_SALES_PLAN D
                 WHERE EXISTS (
                        SELECT 1
                          FROM SCM_MGR.GT_PRDM_SALES_PLAN_TEMP_SINGLE B
                         WHERE D.DIVISION_ID      = B.DIVISION_ID
                           AND D.PROJECT_CODE     = B.PROJECT_CODE
                           AND D.SCM_SITE_ID      = B.SCM_SITE_ID
                           AND D.ITEM_ID          = B.ITEM_ID
                           AND D.DOM_EXP          = B.DOM_EXP
                           AND D.FCST_TYPE        = B.FCST_TYPE
                           AND D.INCOTERMS        = B.INCOTERMS
                           AND D.MEASURE          = B.MEASURE
                           AND D.PLANT_SITE_ID    = B.PLANT_SITE_ID
                           AND D.YYYYMMDD         = B.YYYYMMDD
                    );
            END;

            -- GTT 통계 수집 (GT_PRDM_SALES_PLAN_TEMP_SINGLE: JOIN 후 DM_PLN_SALES_PLAN INSERT에 사용)
            DBMS_STATS.GATHER_TABLE_STATS(
                OWNNAME          => 'SCM_MGR',
                TABNAME          => 'GT_PRDM_SALES_PLAN_TEMP_SINGLE',
                ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1',
                NO_INVALIDATE    => FALSE
            );

            -- 20191114 KHSONG 컬럼값 미지정에서 지정으로 보완
            INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN
            (
                DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
                ,PLANT_SITE_ID
                ,CELL_PROD_SITE_ID
                ,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
            )
            SELECT
                DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
                ,PLANT_SITE_ID
                ,CELL_PROD_SITE_ID
                ,YYYYMMDD,CURRENCY,QTY
                ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATE AS LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
            FROM (
                SELECT T.*,
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
                                        MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
                           ORDER BY CREATION_DATE DESC NULLS LAST
                       ) AS RN
                  FROM SCM_MGR.GT_PRDM_SALES_PLAN_TEMP_SINGLE T
            )
            WHERE RN = 1;

        END;

        --DBMS_OUTPUT.PUT_LINE('EE');

        -- [PJ2024-50611] 소형 매출 프로세스 개선 START
        SELECT MAX(V_DIVISION_ID)
          INTO V_DIVISION_ID
          FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE;

        --[PJ2025-50017] 소형 매출계획 동기화 개선 End

        --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 START
        DELETE
          FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN D
         WHERE D.DIVISION_ID = V_DIVISION_ID
           AND D.YYYYMMDD >= V_THIS_WEEK_MON
           AND D.MEASURE IN ('SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up') --Catch_Up 관련 메저만 삭제
           AND EXISTS (
                SELECT 1
                  FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE R -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
                 WHERE D.DIVISION_ID      = R.V_DIVISION_ID
                   AND D.PROJECT_CODE     = R.V_PROJECT_CODE
                   AND D.SCM_SITE_ID      = R.V_SCM_SITE_ID
                   AND D.ITEM_ID          = R.V_ITEM_ID
                   AND D.DOM_EXP          = R.V_DOM_EXP
                   AND D.FCST_TYPE        = R.V_FCST_TYPE
                   AND D.INCOTERMS        = R.V_INCOTERMS
                   AND D.PLANT_SITE_ID    = R.V_PLANT_SITE_ID -- PLANT_SITE_ID 고려하지 않고 모두 삭제 후 신규 생성
           );

        INSERT INTO SCM_MGR.DM_PLN_SALES_ETC_PLAN
        (
            DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
            ,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CURRENCY,CREATED_BY,CREATION_DATE
            ,LAST_UPDATED_BY,LAST_UPDATE_DATE,REMARK_TEXT
        )
        SELECT
             A.DIVISION_ID
            ,A.PROJECT_CODE
            ,A.SCM_SITE_ID
            ,A.ITEM_ID
            ,A.DOM_EXP
            ,A.FCST_TYPE
            ,A.INCOTERMS
            ,CASE
                WHEN B.MEASURE = 'KRW' THEN 'SalesAmt_KRW_Catch_Up'
                WHEN B.MEASURE = 'LOC' THEN 'SalesAmt_LOC_Catch_Up'
                WHEN B.MEASURE = 'USD' THEN 'SalesAmt_USD_Catch_Up'
                ELSE B.MEASURE
             END AS MEASURE
            ,A.PLANT_SITE_ID
            ,A.YYYYMMDD
            ,CASE
                WHEN B.MEASURE = 'KRW' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                WHEN B.MEASURE = 'LOC' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                WHEN B.MEASURE = 'USD' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
             END AS QTY
            ,B.CURRENCY
            ,A.CREATED_BY
            ,A.CREATION_DATE
            ,A.LAST_UPDATED_BY
            ,A.LAST_UPDATE_DATE
            ,A.REMARK_TEXT
        FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN A
        JOIN SCM_MGR.SCM_MST_FUTURE_PRICE B
          ON A.DIVISION_ID   = B.DIVISION_ID
         AND A.PROJECT_CODE  = B.PROJECT_CODE
         AND A.SCM_SITE_ID   = B.SCM_SITE_ID
         AND A.ITEM_ID       = B.ITEM_ID
         AND A.DOM_EXP       = B.DOM_EXP
         AND A.FCST_TYPE     = B.FCST_TYPE
         AND A.INCOTERMS     = B.INCOTERMS
         AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
         AND B.YYYYMMDD = (
                SELECT C.BASIS_START_DATE
                  FROM SCM_MGR.SCM_SYS_CALENDAR_M C
                 WHERE C.BASIS_YYYYMMDD = A.YYYYMMDD
             )
        WHERE A.MEASURE = 'Catch_Up'
          AND A.DIVISION_ID = V_DIVISION_ID
          AND B.YYYYMMDD >= V_THIS_WEEK_MON
          AND B.MEASURE IN ('KRW', 'LOC', 'USD')
          AND EXISTS (
                SELECT 1
                  FROM SCM_MGR.GT_PRDM_RESULTS_SINGLE R -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
                 WHERE A.DIVISION_ID      = R.V_DIVISION_ID
                   AND A.PROJECT_CODE     = R.V_PROJECT_CODE
                   AND A.SCM_SITE_ID      = R.V_SCM_SITE_ID
                   AND A.ITEM_ID          = R.V_ITEM_ID
                   AND A.DOM_EXP          = R.V_DOM_EXP
                   AND A.FCST_TYPE        = R.V_FCST_TYPE
                   AND A.INCOTERMS        = R.V_INCOTERMS
                   AND A.PLANT_SITE_ID    = R.V_PLANT_SITE_ID
          );

        --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 END
        /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/
        -- DBMS_OUTPUT.PUT_LINE('FF:V_DIVISION_ID:'||V_DIVISION_ID||', V_this_week_mon: '|| V_this_week_mon );

        N_INSERT_COUNT := SQL%ROWCOUNT;

        -- COMMIT은 프로시저 종료 직전에 1회만 수행
        COMMIT;

        N_LOG_COUNT := N_INSERT_COUNT;

        -- DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' completed successfully. DM_PLN_SALES_ETC_PLAN ' || N_LOG_COUNT || ' inserted.');

    --------------------------------------------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
    --------------------------------------------------------------------------------------------
        ROLLBACK TO SALES_PLAN_LOCAL_KRW_SINGLE;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        -- 파리미터 없을 때
        V_PROC_INPUT  := JSON_OBJECT(
            'NO_PARAM' VALUE 'N/A'
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

    END;

    -- 수행결과 성공여부 DISPLAY
    /*
    IF V_log_message IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('success');
    END IF;
    */

    -- 종료 LOG
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

END;
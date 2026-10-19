-- SOURCE-FRESH: SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE PROCEDURE LAST_DDL=2026-09-02 17:30:25 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE" 
/*=====================================================================================================================================================
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE
 * Description  : Sales Plan AMT Create ( Local/KRW )
 * Program History
 *=====================================================================================================================================================
 *   Date		In Charge	Description
 *=====================================================================================================================================================
 * 2018.05.10	KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 수행시 PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 를 호출하여
 * sales price 화면에서 Batch Job 누른 것과 같은 로직을 수행하도록함
 * ---------------------------------------------------------------------------------------------------
 * 2018.08.24	KHSONG		사용자정보 변수값 사용으로 적용 / [SCM_MST_FUTURE_PRICE] JOIN 조건 보완
 * 2019.11.14	KHSONG		컬럼값 미지정에서 지정으로 보완
 * 2020.02.13	HWI1993		자동차사업부 SALES AMT 메저를 RTF_SCP 기준으로 생성
 * 2020.03.09	KHSONG		TMM_FCST ADD
 * 2020.05.07	KHSONG		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.08.06	hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020.12.08	P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2024.11.15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선
 * 2025.01.21	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.01.21	JSSBAE		[E20250121-000405]_Sales Plan에서 Catch-up 메저 삭제되는 현상 조정
 * 2025.02.11	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 SCM_FCST MEASURE 추가
 * 2025.04.03	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요.
 * 2025.04.08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.28	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 CELL_PROD_SITE_ID 추가
 * 2026.03.09	JSSBAE		[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 *===================================================================================================*/
IS

    /* 원본 MSSQL 지역변수 (NVARCHAR(MAX) -> 호출부 실값이 짧은 코드/사용자ID 이므로 VARCHAR2, SOP H-14) */
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_CREATED_BY        VARCHAR2(4000 CHAR);

    /* LOG 용 변수 설정 (START) */
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE          VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    /* LOG 용 변수 설정 (END) */


    V_SQL_ERR_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERR_MSG       VARCHAR2(1000 CHAR);
    V_SQL_BACKTRACE     VARCHAR2(4000 CHAR);

    /* 주차 기준일 = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) */
    V_THIS_WEEK_MON     VARCHAR2(8 CHAR);

BEGIN

    /* 원본 SET NOCOUNT ON / SET TRANSACTION ISOLATION LEVEL READ COMMITTED / SET XACT_ABORT ON */

    V_THIS_WEEK_MON := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

    /* 원본 #SALES_PLAN_TEMP 는 매 실행 시 DROP 후 SELECT TOP 0 으로 재생성(=빈 상태 보장).
     * GTT 는 재생성 대신 DELETE 로 초기화(TRUNCATE 는 DDL 이라 암시 COMMIT 발생 -> 호출자 트랜잭션 파괴). */
    DELETE FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE;

    /* 시작 LOG (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;   /* 변수 재사용을 위하여 초기화해야함 */
    /* 시작 LOG (END) */

    /* 트랜잭션 (START)
     * 원본 BEGIN TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE; */
    BEGIN

        /*----------------------------- MULTI & SINGLE ROW START -----------------------------*/

        /* 사용자정보값 변수에 저장 20180824 KHSONG
         * 원본 SET @v_created_by = (SELECT TOP 1 v_CREATED_BY FROM #results) */
        BEGIN
            SELECT A.V_CREATED_BY
              INTO V_CREATED_BY
              FROM GT_DMF0020_RESULTS A
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_CREATED_BY := NULL;
        END;

        /* 기존 정보 삭제 */
        DELETE
          FROM DM_PLN_SALES_PLAN A
         WHERE EXISTS ( SELECT 1                                   /* 20180510 skh add : DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS B
                         WHERE B.V_DIVISION_ID   = A.DIVISION_ID
                           AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND B.V_ITEM_ID       = A.ITEM_ID
                           AND B.V_DOM_EXP       = A.DOM_EXP
                           AND B.V_FCST_TYPE     = A.FCST_TYPE
                           AND B.V_INCOTERMS     = A.INCOTERMS
                           AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT C.ITEM_ID                     /* MKT/금형비처럼 사람이 넣은것 삭제. */
                                FROM SCM_MST_ITEM_SN C
                               GROUP BY C.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM D
                                 , DM_PLN_SALES_PLAN E
                             WHERE D.ITEM_ID              = E.ITEM_ID
                               AND D.DIVISION_ID          = E.DIVISION_ID
                               AND D.PROJECT_CODE         = E.PROJECT_CODE
                               AND D.SCM_SITE_ID          = E.SCM_SITE_ID
                               AND D.DIVISION_ID          = A.DIVISION_ID
                               AND D.PROJECT_CODE         = A.PROJECT_CODE
                               AND D.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND D.ITEM_ID              = A.ITEM_ID
                               AND D.SALES_PLAN_ADJUST_YN = 'N'
                               AND E.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND E.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE NOT IN ( 'CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up' )   /* [E20250121-000405] Catch Up 메저 삭제 금지 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON;

        /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산. */
        DELETE
          FROM DM_PLN_SALES_PLAN A
         WHERE EXISTS ( SELECT 1                                   /* 20180510 skh add : DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS B
                         WHERE B.V_DIVISION_ID   = A.DIVISION_ID
                           AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND B.V_ITEM_ID       = A.ITEM_ID
                           AND B.V_DOM_EXP       = A.DOM_EXP
                           AND B.V_FCST_TYPE     = A.FCST_TYPE
                           AND B.V_INCOTERMS     = A.INCOTERMS
                           AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT C.ITEM_ID                     /* MKT/금형비처럼 사람이 넣은것 삭제. */
                                FROM SCM_MST_ITEM_SN C
                               GROUP BY C.ITEM_ID )
           AND A.MEASURE IN ( 'MKT_FCST', 'CUST_FCST', 'RTF', 'RTF_SYS_RP', 'TMM_FCST', 'SCM_FCST' )   /* 20180417 modify skh / 20200309 KHSONG TMM_FCST ADD / [PJ2025-50017] SCM_FCST 추가 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON;

        /* 임시테이블 확인후 삭제 / 임시테이블 생성
         * 원본 IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL DROP TABLE #SALES_PLAN_TEMP
         *      SELECT TOP 0 ... INTO #SALES_PLAN_TEMP FROM DM_PLN_SALES_PLAN
         * -> GTT 는 사전 생성 객체이므로 본문 상단의 DELETE 초기화로 대체(20191114 KHSONG 컬럼값 미지정에서 지정으로 보완). */

        /* 신규 정보 추가 / Temp 테이블에 저장 */
        INSERT
          INTO GT_PRDM_SALES_PLAN_TEMP_SINGLE
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID   /* [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가 */
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT DISTINCT                                            /* MKT FCST 값을 update 함. */
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-'                                                 /* CELL_PROD_SITE_ID [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , A.QTY
             , NVL(A.CREATED_BY, 'SYSTEM')
             , A.CREATION_DATE
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , IA.CREATED_BY
                      , IA.CREATION_DATE
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_MKT_FCST IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE IN ( 'MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'SCM_FCST' )   /* 20180417 modify skh / 20200309 KHSONG TMM_FCST ADD / [PJ2025-50017] SCM_FCST 추가 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        /* 2020/08/06 hwi1993 [C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건 */
        UNION ALL
        SELECT A.DIVISION_ID                                       /* KRW 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_AMT_KRW'                                       /* MEASURE */
             , A.PLANT_SITE_ID
             , '-'                                                 /* CELL_PROD_SITE_ID [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 원본 CAST(STR(x, 20, 5) AS NUMERIC(30,10)) = 소수 5자리 반올림, 20180404 SongKH */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_MKT_FCST IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'KRW'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE     = 'MKT_FCST'
           AND A.DIVISION_ID = '40'
           AND A.YYYYMMDD   >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID                                       /* LOC 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_AMT_LOC'                                       /* MEASURE */
             , A.PLANT_SITE_ID
             , '-'                                                 /* CELL_PROD_SITE_ID [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_MKT_FCST IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'LOC'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE     = 'MKT_FCST'
           AND A.DIVISION_ID = '40'
           AND A.YYYYMMDD   >= V_THIS_WEEK_MON;

        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. (Start) */
        INSERT
          INTO GT_PRDM_SALES_PLAN_TEMP_SINGLE
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID   /* [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가 */
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT DISTINCT                                            /* RTF 값을 update 함. */
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , A.QTY
             , NVL(A.CREATED_BY, 'SYSTEM')
             , A.CREATION_DATE
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , IA.CREATED_BY
                      , IA.CREATION_DATE
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE IN ( 'RTF', 'RTF_SYS_RP' )
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID                                       /* KRW 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_KRW'                                      /* MEASURE */
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'KRW'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM E
                                 , DM_PLN_SALES_PLAN F
                             WHERE E.ITEM_ID              = F.ITEM_ID
                               AND E.DIVISION_ID          = F.DIVISION_ID
                               AND E.PROJECT_CODE         = F.PROJECT_CODE
                               AND E.SCM_SITE_ID          = F.SCM_SITE_ID
                               AND E.DIVISION_ID          = A.DIVISION_ID
                               AND E.PROJECT_CODE         = A.PROJECT_CODE
                               AND E.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND E.ITEM_ID              = A.ITEM_ID
                               AND E.SALES_PLAN_ADJUST_YN = 'N'
                               AND F.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND F.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE   = 'RTF_SYS_RP'                          /* [C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID                                       /* LOC 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_LOC'                                      /* MEASURE */
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'LOC'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM E
                                 , DM_PLN_SALES_PLAN F
                             WHERE E.ITEM_ID              = F.ITEM_ID
                               AND E.DIVISION_ID          = F.DIVISION_ID
                               AND E.PROJECT_CODE         = F.PROJECT_CODE
                               AND E.SCM_SITE_ID          = F.SCM_SITE_ID
                               AND E.DIVISION_ID          = A.DIVISION_ID
                               AND E.PROJECT_CODE         = A.PROJECT_CODE
                               AND E.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND E.ITEM_ID              = A.ITEM_ID
                               AND E.SALES_PLAN_ADJUST_YN = 'N'
                               AND F.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND F.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE   = 'RTF_SYS_RP'                          /* [C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_USD'                                      /* MEASURE */
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'USD'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM E
                                 , DM_PLN_SALES_PLAN F
                             WHERE E.ITEM_ID              = F.ITEM_ID
                               AND E.DIVISION_ID          = F.DIVISION_ID
                               AND E.PROJECT_CODE         = F.PROJECT_CODE
                               AND E.SCM_SITE_ID          = F.SCM_SITE_ID
                               AND E.DIVISION_ID          = A.DIVISION_ID
                               AND E.PROJECT_CODE         = A.PROJECT_CODE
                               AND E.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND E.ITEM_ID              = A.ITEM_ID
                               AND E.SALES_PLAN_ADJUST_YN = 'N'
                               AND F.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND F.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE   = 'RTF_SYS_RP'                          /* [C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. (End) */

        /* 테이블의 중복제거 */
        BEGIN
            DELETE
              FROM DM_PLN_SALES_PLAN A
             WHERE EXISTS ( SELECT 1
                              FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE B
                             WHERE B.DIVISION_ID   = A.DIVISION_ID
                               AND B.PROJECT_CODE  = A.PROJECT_CODE
                               AND B.SCM_SITE_ID   = A.SCM_SITE_ID
                               AND B.ITEM_ID       = A.ITEM_ID
                               AND B.DOM_EXP       = A.DOM_EXP
                               AND B.FCST_TYPE     = A.FCST_TYPE
                               AND B.INCOTERMS     = A.INCOTERMS
                               AND B.MEASURE       = A.MEASURE
                               AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
                               AND B.YYYYMMDD      = A.YYYYMMDD );
        END;

        /* 20191114 KHSONG 컬럼값 미지정에서 지정으로 보완 */
        INSERT
          INTO DM_PLN_SALES_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID   /* [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가 */
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , A.CURRENCY
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , SYSDATE
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
          FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE A;

        /* [PJ2024-50611] 소형 매출 프로세스 개선 (Start)
         * 원본 SET @v_division_id = ( SELECT TOP 1 v_DIVISION_ID FROM #results ) */
        BEGIN
            SELECT A.V_DIVISION_ID
              INTO V_DIVISION_ID
              FROM GT_DMF0020_RESULTS A
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_DIVISION_ID := NULL;
        END;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 (End) */

        /* [PJ2024-50611] 기타매출, Catch Up 테이블 분리 (Start) */
        DELETE
          FROM DM_PLN_SALES_ETC_PLAN A
         WHERE EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS B
                         WHERE B.V_DIVISION_ID   = A.DIVISION_ID
                           AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND B.V_ITEM_ID       = A.ITEM_ID
                           AND B.V_DOM_EXP       = A.DOM_EXP
                           AND B.V_FCST_TYPE     = A.FCST_TYPE
                           AND B.V_INCOTERMS     = A.INCOTERMS
                           AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID )   /* PLANT_SITE_ID 고려하지 않고 모두 삭제 후 신규 생성 */
           AND A.MEASURE IN ( 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up' )   /* Catch_Up 관련 메저만 삭제 */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.YYYYMMDD   >= V_THIS_WEEK_MON;

        INSERT
          INTO DM_PLN_SALES_ETC_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY
             , CURRENCY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , REMARK_TEXT )
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN B.MEASURE = 'KRW' THEN 'SalesAmt_KRW_Catch_Up'
                    WHEN B.MEASURE = 'LOC' THEN 'SalesAmt_LOC_Catch_Up'
                    WHEN B.MEASURE = 'USD' THEN 'SalesAmt_USD_Catch_Up'
                    ELSE B.MEASURE
               END                                                 /* MEASURE */
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , CASE WHEN B.MEASURE = 'KRW' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                    WHEN B.MEASURE = 'LOC' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                    WHEN B.MEASURE = 'USD' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
               END                                                 /* QTY */
             , B.CURRENCY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , A.REMARK_TEXT
          FROM DM_PLN_SALES_ETC_PLAN A
             , SCM_MST_FUTURE_PRICE B
         WHERE A.DIVISION_ID   = B.DIVISION_ID
           AND A.PROJECT_CODE  = B.PROJECT_CODE
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND A.ITEM_ID       = B.ITEM_ID
           AND A.DOM_EXP       = B.DOM_EXP
           AND A.FCST_TYPE     = B.FCST_TYPE
           AND A.INCOTERMS     = B.INCOTERMS
           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
           AND B.YYYYMMDD      = ( SELECT SA.BASIS_START_DATE
                                     FROM SCM_SYS_CALENDAR_M SA
                                    WHERE SA.BASIS_YYYYMMDD = A.YYYYMMDD )
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.MEASURE = 'Catch_Up'
           AND B.MEASURE IN ( 'KRW', 'LOC', 'USD' )
           AND A.DIVISION_ID = V_DIVISION_ID
           AND B.YYYYMMDD   >= V_THIS_WEEK_MON;
        /* [PJ2024-50611] 기타매출, Catch Up 테이블 분리 (End) */

        /*----------------------------- MULTI & SINGLE ROW END -----------------------------*/

        /* 트랜잭션 (COMMIT)
         * 원본 --COMMIT WORK;
         *      COMMIT TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE;
         * -> 호출자(DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL / _POPUP)가 BEGIN TRANSACTION 후 호출하므로
         *    MSSQL 에서 이 COMMIT 은 중첩 카운트 감소일 뿐 실제 확정이 아니다. Oracle 에는 중첩 트랜잭션이 없어
         *    여기서 COMMIT 하면 호출자 작업까지 조기 확정되어 원자성이 깨지므로 제거한다(SOP H-7).
         *    전수확인: 호출자 2곳 모두 자기 COMMIT 보유 / 앱 등록표(SCM_ADM_PROC_M) 미등록 / NSCM BE 직접호출 0건 */

    EXCEPTION
        WHEN OTHERS THEN
        /* 트랜잭션 (END)
         * [E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (START)
         *   --ROLLBACK TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE;
         *   ROLLBACK        <- 무명 ROLLBACK(전체 롤백)으로 개정됨
         * [E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (END) */
            ROLLBACK;

            /* ERROR LOG VALUE SAVE */
            V_LOG_TYPE      := 'ERROR';
            V_SQL_ERR_CODE  := TO_CHAR(SQLCODE);
            V_SQL_ERR_MSG   := SQLERRM;
            V_SQL_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            V_LOG_MESSAGE   := SUBSTR(V_SQL_ERR_MSG, 1, 1000);
            /* [E20260309-000271]_오류가 발생하는 경우 사용자의 ID까지 찍히도록 수정 (START)
             *   --SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()); -- [E20260309-000271]_원소스주석처리
             * ERROR_LINE() 대응 구문이 없어 FORMAT_ERROR_BACKTRACE 로 대체(행번호 포함). */
            V_DESCRIPTION   := SUBSTR('@v_created_by: ' || V_CREATED_BY || '/ ERROR_LINE : ' || V_SQL_BACKTRACE, 1, 500);
            /* [E20260309-000271]_오류가 발생하는 경우 사용자의 ID까지 찍히도록 수정 (END) */
            D_EVENT_DATE    := SYSDATE;

            /* 원본 SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  --에러메시지 DISPLAY */

            PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                                , NULL
                                , V_SQL_ERR_CODE, V_SQL_ERR_MSG, V_SQL_BACKTRACE );


            RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_ERR_CODE
                                         || ' / SQLERRM=' || V_SQL_ERR_MSG
                                         || ' / BACKTRACE=' || V_SQL_BACKTRACE);
    END;

    /* 수행결과 성공여부 DISPLAY
     *   IF @v_log_message IS NULL
     *    SELECT 'success' */

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;
/

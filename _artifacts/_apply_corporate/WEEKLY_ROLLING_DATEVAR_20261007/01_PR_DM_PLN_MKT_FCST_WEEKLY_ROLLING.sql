CREATE OR REPLACE PROCEDURE         "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING" 
(
      P_DIVISION_ID        IN VARCHAR2
    , P_VER_DESCRIPTION    IN VARCHAR2
    , P_VER_TYPE           IN VARCHAR2
    , P_ROLLING_TYPE       IN VARCHAR2
    , P_CREATED_BY         IN VARCHAR2
)
/*=====================================================================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING
 * Description  : CustomerPR_DM_PLN_MKT_FCST_WEEKLY_ROLLING
 * Program History
 *=====================================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================================
 * 2017.12		DWOK/DWPARK		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28	KHSONG			DW I/F 테이블 생성 Procedure 호출 추가(개발기만 적용/운영 반영시 주석처리함) 20180703 임시 주석처리함
 * 2018.06.07	KHSONG			MKT_FCST MEASURE로 RTF생성하는부분 주석처리함
 * 2018.07.06	KHSONG			BALANCE MAKE PROCEDURE 호출추가
 * 2018.07.26	KHSONG			주석처리 PR_DM_PLN_SALES_PLAN_CUTOFF 내에서 호출되도록 변경함
 * 2018.08.06	KHSONG			주석처리 DMS_RCCP_CONV_AUTO
 * 2019.06.10	KHSONG			[CSR ID:4011692] DM 주간 Cut off 수행 기능 추가
 * 2020.07.13	P.C.I			[PJ202001380] 82사업부는 화요일 Sales Plan Weekly Cutoff 제외
 * 2020.07.22	P.C.I			[PJ202001380] Sales Plan Weekly Cutoff 제외
 * 2023.04.10	heesan91		[E20230403-000148] Active가 N으로 변경된 대상은 MKT FCST Waterfall 컷오프 될 때도 제외되게 변경 요청
 * 2024.10.30	JSSAE			[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
 * 2024.11.15	KANG.H.J		[PJ2024-50611] 소형 매출 프로세스 개선
 * 2024.12.02	KANG.H.J		[PJ2024-50611] FROM_SITE_ID가 추가된 'DM_PLN_RTF_ALLOCATION_C' 테이블 MKT Fcst Cutoff(전 사업부대상)
 * 2025.01.07	JSSBAE			[PJ20228272]_KPI 완료 후 생성에서 NET DEMAND 생성 후로 위치 변경
 * 2025.02.05	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025.04.08	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.24	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 조건절 보완
 * 2025.05.07	KANG.H.J		[PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성)
 * 2025.05.13	KANG.H.J		[PJ2025-50188] 기준수요 - MF_W/SF_W 모든 상황에서 NET_DEMAND 생성됨.
 * 2025.05.20	KANG.H.J		[PJ2025-50188] 기준수요 - DM_PLN_MKT_FCST에 SCM_FCST MEASURE 동기화 로직 추가.
 * 2025.05.29	JSSBAE			[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 * 2025.06.13	JSSBAE			[E20250612-001460]_KPI 배치 중단 요청
 * 2025.06.23	KANG.H.J		[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.25	KANG.H.J		[PJ2025-50188] WEEKLY CUTOFF시 PRICE 부문 / EXCHANGE 부문도 CUTOFF 처리
 * 2025.08.25	JSSBAE			[E20250805-000632]_MKT FCST Cutoff 프로시저 모니터링용 SMS 발송
 * 2026.01.21	JSSBAE			[E20260107-001651]_BPS 전송 데이터 From_Site_ID 생성 로직 개선
 * 2026.07.06	ZIONEX	[PJ202650304]	NextSCM Migration
 * 2026.09.02	AJS			[PJ2025-50188] 81 계열 사업부도 MF_W 시 SCM_FCST 생성하도록 ELSIF 추가
 *====================================================================================================================================================================*/
IS
    /*================================================================================================================
      000 : VARIABLE DECLARATION
      ================================================================================================================*/
    RECV_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
    V_DIVISION_ID        VARCHAR2(4000 CHAR);
    V_VER_DESCRIPTION    VARCHAR2(4000 CHAR);
    V_VER_TYPE           VARCHAR2(4000 CHAR);
    V_ROLLING_TYPE       VARCHAR2(4000 CHAR);
    V_CREATED_BY         VARCHAR2(4000 CHAR);
    V_VER_RETURN_NO      VARCHAR2(100 CHAR);   /* cut off Generated Number */
    N_HISTORY_SEQ        PLS_INTEGER;
    V_PLAN_WEEK          VARCHAR2(4000 CHAR);
    V_OK_DESCRIPTION     VARCHAR2(1200 CHAR);  /* cut off Generated Number */
    V_DELIMITER          VARCHAR2(1 CHAR);
    MAX_LOOP_CNT         PLS_INTEGER := 0;
    MST_LOOP_CNT         PLS_INTEGER := 0;

    /*================================================================================================================
      LOG 용 변수 설정
      ================================================================================================================*/
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING';
    V_LOG_TYPE           VARCHAR2(30 CHAR);    /* START/END/ERROR/... */
    N_LOG_COUNT          PLS_INTEGER := 0;
    V_LOG_MESSAGE        VARCHAR2(1000 CHAR);
    V_DESCRIPTION        VARCHAR2(500 CHAR);
    D_EVENT_DATE         DATE;

    /* [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 */
    V_CATEGORY_NAME      VARCHAR2(150 CHAR) := 'MKT FCST WEEKLY CUTOFF';

    /* 20190610 KHSONG [CSR ID:4011692] WEEKLY_CUTOFF_YN LOOKUP 조회용 (원본은 IF 조건 내 스칼라 서브쿼리 → Oracle SELECT INTO) */
    V_WEEKLY_CUTOFF_YN   VARCHAR2(10 CHAR);

    /* PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 의 필수 OUT SYS_REFCURSOR(3번째 인자, 호출측 미사용 → 즉시 CLOSE). all_arguments 로 확인 */
    V_DUMMY_CUR          SYS_REFCURSOR;

    /* [E20261007-DATEVAR] 날짜 경계를 시작 때 1회 계산해 바인드로 쓴다 — 술어 안 FN_NEXT_DAY(SYSDATE) 는 옵티마이저가 선택도를 못 보아
       (추정 2,618행 vs 실제 423,068행, 클라우드 AWR 2026-10-05) 인덱스 ROWID 경로를 고르고, 81/82 로 파싱된 계획을 40 이 공유했다. 결과 행 동일 */
    V_FROM_1W            VARCHAR2(8 CHAR);   /* 당주 월요일 = FN_NEXT_DAY(SYSDATE,'MON') - 7 */
    V_FROM_54W           VARCHAR2(8 CHAR);   /* 54주 전 월요일 (최근 1년치) */
BEGIN
    /* MSSQL 세션설정 SET NOCOUNT ON / SET TRANSACTION ISOLATION LEVEL READ COMMITTED / SET XACT_ABORT ON
       — Oracle 은 READ COMMITTED 가 기본 격리수준이며 NOCOUNT/XACT_ABORT 대응 개념이 불필요하여 제거함 */
    V_DIVISION_ID     := NULL;
    V_VER_DESCRIPTION := NULL;
    V_VER_TYPE        := NULL;
    V_ROLLING_TYPE    := NULL;
    V_CREATED_BY      := NULL;
    V_DELIMITER       := '^';
    V_FROM_1W         := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7,    'YYYYMMDD');  /* [E20261007-DATEVAR] */
    V_FROM_54W        := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7*54, 'YYYYMMDD');  /* [E20261007-DATEVAR] */

    /*================================================================================================================
      100 : START LOG
      ================================================================================================================*/
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := 'Div: ' || P_DIVISION_ID || ' / ' || P_VER_TYPE;
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;      /* <- 변수 재사용을 위하여 초기화해야함 */

    /*--------------------------------------------------------------------------------------------------------------------
      [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (START)
      --------------------------------------------------------------------------------------------------------------------*/
    IF P_VER_TYPE != 'MF_D' THEN
        PR_DM_SMS_LOG_BATCH(V_CATEGORY_NAME, V_LOG_TYPE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;
    /*--------------------------------------------------------------------------------------------------------------------
      [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (END)
      --------------------------------------------------------------------------------------------------------------------*/

    SAVEPOINT SP_MAIN;   /* MSSQL BEGIN TRAN */
    /*================================================================================================================
      200 : MAIN LOGIC
      ================================================================================================================*/
    BEGIN   /* MSSQL BEGIN TRY */
        /*--------------------------------------------------------------------------------------------------------------
          20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (START)
          --------------------------------------------------------------------------------------------------------------*/
        IF ( P_VER_TYPE = 'MF_W' OR P_VER_TYPE = 'SF_W' ) THEN /* [PJ2025-50188] SF_W도 추가됨. */
            BEGIN
                SELECT SEGMENT2
                  INTO V_WEEKLY_CUTOFF_YN
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'WEEKLY_CUTOFF_YN'
                   AND SEGMENT1    = P_DIVISION_ID
                   AND VALID_YN    = 'Y';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_WEEKLY_CUTOFF_YN := NULL;
            END;

            /* 원본: (SELECT SEGMENT2 ...) <> 'Y'. Oracle 은 IF 조건 내 스칼라 서브쿼리 불가 → SELECT INTO.
               원본 MSSQL 은 조회행 없음/NULL 이면 (NULL<>'Y')=UNKNOWN 으로 분기 미진입(계속 진행)이므로
               NVL 로 'N' 강제하지 않고 V_WEEKLY_CUTOFF_YN <> 'Y' 그대로 두어 NULL 시 미진입을 유지함(1:1 충실). */
            IF V_WEEKLY_CUTOFF_YN <> 'Y' THEN
                V_LOG_TYPE := 'INVALID';
                DBMS_OUTPUT.PUT_LINE('LOOKUP 테이블에 WEEKLY_CUTOFF_YN 값의 설정이 실행불가로 설정되어 있습니다!');
                V_DESCRIPTION := 'Div: ' || P_DIVISION_ID || ' / ' || 'LOOKUP 테이블에 WEEKLY_CUTOFF_YN 값의 설정이 실행불가로 설정되어 있습니다!';
                GOTO ERR_RTN;
            END IF;
        END IF;
        /*--------------------------------------------------------------------------------------------------------------
          20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (END)
          --------------------------------------------------------------------------------------------------------------*/
        BEGIN
            V_DIVISION_ID := P_DIVISION_ID;
            DBMS_OUTPUT.PUT_LINE(V_DIVISION_ID);

            BEGIN
                SELECT A.ISO_YYYYWW
                  INTO V_PLAN_WEEK
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_PLAN_WEEK := NULL;
            END;
            DBMS_OUTPUT.PUT_LINE(V_PLAN_WEEK);

            V_VER_DESCRIPTION := P_VER_DESCRIPTION;
            DBMS_OUTPUT.PUT_LINE(V_VER_DESCRIPTION);

            V_VER_TYPE := P_VER_TYPE;
            DBMS_OUTPUT.PUT_LINE(V_VER_TYPE);

            V_ROLLING_TYPE := P_ROLLING_TYPE;
            DBMS_OUTPUT.PUT_LINE(V_ROLLING_TYPE);

            V_CREATED_BY := P_CREATED_BY;
            DBMS_OUTPUT.PUT_LINE(V_CREATED_BY);
        END;

        BEGIN
            PR_DM_PLN_VERSION_CREATE(V_DIVISION_ID, V_VER_DESCRIPTION, V_VER_TYPE, V_CREATED_BY, V_VER_RETURN_NO, V_OK_DESCRIPTION);

            DBMS_OUTPUT.PUT_LINE(V_VER_RETURN_NO); /* Output */
            DBMS_OUTPUT.PUT_LINE(V_OK_DESCRIPTION);

        /* [2018-03-29][PROCEDURE로 분리] BEGIN ~ END (원본 주석처리 코드 보존)
           select '2'
           SELECT RIGHT(@v_ver_type,1);
           IF RIGHT(@v_ver_type,1) = 'W'   WEEKLY로 인입되었을때 [QTY] = 0 값들을 삭제처리
           BEGIN
               DELETE FROM [dbo].[DM_PLN_MKT_FCST]
               WHERE  [DIVISION_ID] = @v_division_id
                  AND [YYYYMMDD] >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                  AND [QTY] = 0 ;
               전주차의 'MKT_FCST','CUST_FCST','MKT_FCST_LATEST','CUST_FCST_LATEST' 값을 실적 table로 옮김
               DELETE FROM [dbo].[DM_PLN_MKT_FCST_RESULT]
               WHERE  [DIVISION_ID] = @v_division_id
                  AND [MEASURE] IN ( 'MKT_FCST', 'CUST_FCST' )   [2018-03-28][수정]
                  AND [YYYYMMDD] <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                  AND [YYYYMMDD] >= CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) ;
               INSERT INTO [dbo].[DM_PLN_MKT_FCST_RESULT]
                   ( [DIVISION_ID],[PROJECT_CODE],[SCM_SITE_ID],[ITEM_ID],[DOM_EXP],[FCST_TYPE],[INCOTERMS],[MEASURE],[PLANT_SITE_ID],[YYYYMMDD],[QTY]
                    ,[CREATED_BY],[CREATION_DATE],[LAST_UPDATED_BY],[LAST_UPDATE_DATE]
                    ,[ATTRIBUTE1]~[ATTRIBUTE10] )
               SELECT ... FROM [dbo].[DM_PLN_MKT_FCST]
                   WHERE [DIVISION_ID] = @v_division_id
                   AND [MEASURE] IN ( 'MKT_FCST','CUST_FCST','MKT_FCST_LATEST','CUST_FCST_LATEST' )
                   AND [YYYYMMDD] <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                   AND [YYYYMMDD] >= CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
           END
           [2018-03-29][PROCEDURE로 분리] END */

        /*  20180607 KHSONG MKT_FCST MEASURE로 RTF생성하는부분 주석처리함
            [20180402 SONGKEEHO ADDED] SCP Open(2018.06월)전까지는 Sales Plan계산을 위하여 MKT FCST와 RTF를 맞춰주는 작업필요하여 RTF INSERT  (START)
            BEGIN
              INSERT 전 삭제
              DELETE  FROM [dbo].[DM_PLN_MKT_FCST]
                        WHERE [DIVISION_ID] = @v_division_id
                            AND [YYYYMMDD] >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                            AND MEASURE = 'RTF'
              INSERT 수행
              INSERT   [dbo].[DM_PLN_MKT_FCST]
                        ( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                        ,MEASURE
                        ,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        ,ATTRIBUTE1~ATTRIBUTE10 )
                 SELECT
                         DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                        ,'RTF'  AS  MEASURE
                        ,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        ,ATTRIBUTE1~ATTRIBUTE10
                    FROM [dbo].[DM_PLN_MKT_FCST] WITH(NOLOCK)
                      WHERE [DIVISION_ID] = @v_division_id
                             AND [YYYYMMDD] >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                             AND MEASURE = 'MKT_FCST'
            END
            [20180402 SONGKEEHO ADDED] ... RTF INSERT  (END)
        */

            DBMS_OUTPUT.PUT_LINE('0');
            /*----------------------------------------------------------------------------------------------------------
              [PJ2025-50188] 기준수요 기반 CUTOFF 기능 추가 (START)
              ----------------------------------------------------------------------------------------------------------*/
            BEGIN
                /*------------------------------------------------------------------------------------
                  화.00시(MKT_FCST) 일 때는 SCM_FCST Delete ==> Insert 처리
                  화.14시(SCM_FCST) 일 때는 SCM_FCST CUTOFF 처리
                  ------------------------------------------------------------------------------------*/
                IF ( V_DIVISION_ID = '40' AND P_VER_TYPE = 'MF_W' ) THEN  /* [PJ2025-50188] SF_W CUTOFF 시점에 DM_PLN_CFM_MKT_DEMAND_PLAN (MKT_FCST ==> SCM_FCST 동기화) */
                    /*------------------------------------------------------------------------------------
                      [PJ2025-50188] DM_PLN_MKT_FCST (MKT_FCST ==> SCM_FCST) 동기화
                      [PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN (MKT_FCST ==> SCM_FCST) 동기화
                      ------------------------------------------------------------------------------------*/
                    DELETE
                      FROM DM_PLN_MKT_FCST
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND YYYYMMDD >= V_FROM_1W /* [E20261007-DATEVAR] */
                       AND MEASURE = 'SCM_FCST';

                    INSERT INTO DM_PLN_MKT_FCST
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
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.DOM_EXP
                         , A.FCST_TYPE
                         , A.INCOTERMS
                         , 'SCM_FCST'
                         , A.PLANT_SITE_ID
                         , A.YYYYMMDD
                         , A.QTY
                         , A.CREATED_BY
                         , A.CREATION_DATE
                         , A.LAST_UPDATED_BY
--                         , A.LAST_UPDATE_DATE
                         , SYSDATE
                      FROM DM_PLN_MKT_FCST A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.MEASURE     = 'MKT_FCST'
                       AND A.YYYYMMDD   >= V_FROM_1W /* [E20261007-DATEVAR] */;

                    DELETE
                      FROM DM_PLN_CFM_MKT_DEMAND_PLAN
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND YYYYMMDD >= V_FROM_1W /* [E20261007-DATEVAR] */
                       AND MEASURE = 'SCM_FCST';

                    INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
                         ( DIVISION_ID
                         , PROJECT_CODE
                         , END_CUSTOMER
                         , SCM_SITE_ID
                         , ITEM_ID
                         , DOM_EXP
                         , FCST_TYPE
                         , INCOTERMS
                         , MEASURE
                         , PLANT_SITE_ID
                         , CELL_PROD_SITE_ID
                         , YYYYMMDD
                         , QTY
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.END_CUSTOMER
                         , A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.DOM_EXP
                         , A.FCST_TYPE
                         , A.INCOTERMS
                         , 'SCM_FCST'
                         , A.PLANT_SITE_ID
                         , A.CELL_PROD_SITE_ID
                         , A.YYYYMMDD
                         , A.QTY
                         , A.CREATED_BY
                         , A.CREATION_DATE
                         , A.LAST_UPDATED_BY
                         --, A.LAST_UPDATE_DATE
                         , SYSDATE
                      FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.MEASURE     = 'MKT_FCST'
                       AND A.YYYYMMDD   >= V_FROM_1W /* [E20261007-DATEVAR] */;
                    -- AJS 20260902
                ELSIF ( SUBSTR(V_DIVISION_ID, 1, 2) = '81' AND P_VER_TYPE = 'MF_W' ) THEN  
                    DELETE  
                      FROM DM_PLN_MKT_FCST  
                     WHERE DIVISION_ID = V_DIVISION_ID  
                       AND YYYYMMDD >= V_FROM_1W /* [E20261007-DATEVAR] */  
                       AND MEASURE = 'SCM_FCST';  
                    INSERT INTO DM_PLN_MKT_FCST  
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
                         , CREATED_BY  
                         , CREATION_DATE  
                         , LAST_UPDATED_BY  
                         , LAST_UPDATE_DATE )  
                    SELECT A.DIVISION_ID  
                         , A.PROJECT_CODE  
                         , A.SCM_SITE_ID  
                         , A.ITEM_ID  
                         , A.DOM_EXP  
                         , A.FCST_TYPE  
                         , A.INCOTERMS  
                         , 'SCM_FCST'  
                         , A.PLANT_SITE_ID  
                         , A.YYYYMMDD  
                         , A.QTY  
                         , A.CREATED_BY  
                         , A.CREATION_DATE  
                         , A.LAST_UPDATED_BY  
                         --, A.LAST_UPDATE_DATE
                         , SYSDATE  
                      FROM DM_PLN_MKT_FCST A  
                     WHERE A.DIVISION_ID = V_DIVISION_ID  
                       AND A.MEASURE     = 'MKT_FCST'  
                       AND A.YYYYMMDD   >= V_FROM_1W /* [E20261007-DATEVAR] */;  
                END IF;
            END;
            DBMS_OUTPUT.PUT_LINE('1');
            BEGIN
                INSERT INTO DM_PLN_MKT_FCST_C
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
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
                SELECT V_DIVISION_ID
                     , V_VER_RETURN_NO
                     , V_VER_TYPE
                     , TO_CHAR(SYSDATE, 'YYYYMMDD')
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , A.QTY
                     , V_CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     --, A.LAST_UPDATE_DATE
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
                  FROM ( SELECT F.DIVISION_ID
                              , F.PROJECT_CODE
                              , F.SCM_SITE_ID
                              , F.ITEM_ID
                              , F.DOM_EXP
                              , F.FCST_TYPE
                              , F.INCOTERMS
                              , F.MEASURE
                              , F.PLANT_SITE_ID
                              , F.YYYYMMDD
                              , F.QTY
                              , F.CREATED_BY
                              , F.CREATION_DATE
                              , F.LAST_UPDATED_BY
                              , F.LAST_UPDATE_DATE
                              , F.ATTRIBUTE1
                              , F.ATTRIBUTE2
                              , F.ATTRIBUTE3
                              , F.ATTRIBUTE4
                              , F.ATTRIBUTE5
                              , F.ATTRIBUTE6
                              , F.ATTRIBUTE7
                              , F.ATTRIBUTE8
                              , F.ATTRIBUTE9
                              , F.ATTRIBUTE10
                           FROM DM_PLN_MKT_FCST     F
                              , SCM_MST_SITE_ITEM   T2   /* 20230410 JHS [E20230403-000148] */
                          WHERE F.DIVISION_ID  = T2.DIVISION_ID
                            AND F.PROJECT_CODE = T2.PROJECT_CODE
                            AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                            AND F.ITEM_ID      = T2.ITEM_ID
                            AND T2.VALID_YN    = 'Y'
                            AND F.DIVISION_ID  = V_DIVISION_ID
                            AND F.YYYYMMDD    >= V_FROM_1W /* [E20261007-DATEVAR] */
                            AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                         UNION ALL
                         SELECT F.DIVISION_ID
                              , F.PROJECT_CODE
                              , F.SCM_SITE_ID
                              , F.ITEM_ID
                              , F.DOM_EXP
                              , F.FCST_TYPE
                              , F.INCOTERMS
                              , F.MEASURE
                              , F.PLANT_SITE_ID
                              , F.YYYYMMDD
                              , F.QTY
                              , F.CREATED_BY
                              , F.CREATION_DATE
                              , F.LAST_UPDATED_BY
                              , F.LAST_UPDATE_DATE
                              , F.ATTRIBUTE1
                              , F.ATTRIBUTE2
                              , F.ATTRIBUTE3
                              , F.ATTRIBUTE4
                              , F.ATTRIBUTE5
                              , F.ATTRIBUTE6
                              , F.ATTRIBUTE7
                              , F.ATTRIBUTE8
                              , F.ATTRIBUTE9
                              , F.ATTRIBUTE10
                           FROM DM_PLN_MKT_FCST     F
                              , SCM_MST_SITE_ITEM   T2   /* 20230410 JHS [E20230403-000148] */
                          WHERE F.DIVISION_ID  = T2.DIVISION_ID
                            AND F.PROJECT_CODE = T2.PROJECT_CODE
                            AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                            AND F.ITEM_ID      = T2.ITEM_ID
                            AND T2.VALID_YN    = 'Y'
                            AND F.DIVISION_ID  = V_DIVISION_ID
                            AND F.YYYYMMDD    >= V_FROM_54W /* [E20261007-DATEVAR] */ /* 최근 1년치 */
                            AND F.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                       ) A;
            END;
            DBMS_OUTPUT.PUT_LINE('3');
            BEGIN
                INSERT INTO DM_PLN_MKT_FCST_RESULT_C
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
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
                     , ATTRIBUTE10
                     , CELL_PROD_SITE_ID )   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                SELECT V_DIVISION_ID
                     , V_VER_RETURN_NO
                     , V_VER_TYPE
                     , TO_CHAR(SYSDATE, 'YYYYMMDD')
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , A.QTY
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                    -- , A.LAST_UPDATE_DATE
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
                     , A.CELL_PROD_SITE_ID   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                  FROM ( SELECT DIVISION_ID
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
                              , ATTRIBUTE10
                              , CELL_PROD_SITE_ID   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                           FROM DM_PLN_MKT_FCST_RESULT
                          WHERE DIVISION_ID = V_DIVISION_ID
                            AND YYYYMMDD  <  V_FROM_1W /* [E20261007-DATEVAR] */    /* [2018-03-28][추가][금주 월요일 이전] */
                            AND YYYYMMDD  >= V_FROM_54W /* [E20261007-DATEVAR] */ /* 최근 1년치 */
                       ) A;
            END;

        END;

        BEGIN
            /*----------------------------------------------------------------------------------------------------------
              [PJ2025-50188]  DM_PLN_CFM_MKT_DEMAND_PLAN CUTOFF  (START)
              ----------------------------------------------------------------------------------------------------------*/
            DELETE
              FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
             WHERE DIVISION_ID     = V_DIVISION_ID
               AND VERSION_NO      = V_VER_RETURN_NO
               AND CUTOFF_TYPE     = V_VER_TYPE
               AND CUTOFF_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

            INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , END_CUSTOMER
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , YYYYMMDD
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , ATTRIBUTE1        /* [E20260107-001651]_ATTRIBUTE 영역 추가 */
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10 )
            SELECT A.DIVISION_ID
                 , V_VER_RETURN_NO
                 , V_VER_TYPE
                 , TO_CHAR(SYSDATE, 'YYYYMMDD')
                 , A.PROJECT_CODE
                 , A.END_CUSTOMER
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.DOM_EXP
                 , A.FCST_TYPE
                 , A.INCOTERMS
                 , A.MEASURE
                 , A.PLANT_SITE_ID
                 , A.CELL_PROD_SITE_ID
                 , A.YYYYMMDD
                 , A.QTY
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , A.LAST_UPDATED_BY
             --    , A.LAST_UPDATE_DATE
                 , SYSDATE
                 , A.ATTRIBUTE1        /* [E20260107-001651]_ATTRIBUTE 영역 추가 */
                 , A.ATTRIBUTE2
                 , A.ATTRIBUTE3
                 , A.ATTRIBUTE4
                 , A.ATTRIBUTE5
                 , A.ATTRIBUTE6
                 , A.ATTRIBUTE7
                 , A.ATTRIBUTE8
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
              FROM DM_PLN_CFM_MKT_DEMAND_PLAN   A
                 , SCM_MST_SITE_ITEM            B
             WHERE A.DIVISION_ID  = B.DIVISION_ID
               AND A.PROJECT_CODE = B.PROJECT_CODE
               /* 원본: A.END_CUSTOMER = CASE WHEN A.DIVISION_ID='40' THEN B.PROJECT_CODE ELSE '' END (중요: PROJECT_CODE와 END_CUSTOMER)
                  Oracle 은 ''=NULL 이므로 ELSE '' 를 그대로 두면 비40 매칭이 소실됨 → §3.4/H-4 로 END_CUSTOMER 공백은 RTRIM IS NULL 로 변환 */
               AND ( ( A.DIVISION_ID = '40' AND A.END_CUSTOMER = B.PROJECT_CODE )
                  OR ( A.DIVISION_ID <> '40' AND RTRIM(A.END_CUSTOMER) IS NULL ) )
               AND A.SCM_SITE_ID  = B.SCM_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND B.VALID_YN     = 'Y'
               AND A.DIVISION_ID  = V_DIVISION_ID
               AND A.YYYYMMDD    >= V_FROM_1W /* [E20261007-DATEVAR] */;
            /*----------------------------------------------------------------------------------------------------------
              [PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN CUTOFF (END)
              ----------------------------------------------------------------------------------------------------------*/
        END;

        /*--------------------------------------------------------------------------------------------------------------
          [PJ2025-50188] 기준수요 기반 CUTOFF 기능 추가 END
          --------------------------------------------------------------------------------------------------------------
          20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
          EXEC [dbo].PR_DM_TO_XIF_DM_PLN_MKT_FCST_C @p_division_id, @v_ver_return_no
          --------------------------------------------------------------------------------------------------------------*/
        COMMIT;   /* MSSQL COMMIT TRAN */
    /*================================================================================================================
      300 : ERROR TRAP
      ================================================================================================================*/
    EXCEPTION   /* MSSQL BEGIN CATCH */
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR1');
            /*--------------------------------------------------------------------------------------------------------------
              ERROR 발생시 ROLLBACK 후 ERROR 로그 생성
              --------------------------------------------------------------------------------------------------------------*/
            ROLLBACK TO SP_MAIN;   /* MSSQL ROLLBACK TRAN */

            V_LOG_TYPE := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            /* MSSQL ERROR_LINE() 은 Oracle 직접 대응이 없어 SQLCODE 로 대체(배치 로그 설명용) */
            V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(SQLCODE);
            D_EVENT_DATE := SYSDATE;

            DBMS_OUTPUT.PUT_LINE('ERROR2');
            DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SQLCODE) || ']_O' || SQLERRM);  /* 에러메시지 DISPLAY */

            DBMS_OUTPUT.PUT_LINE('ERROR3');
            /* 원본 SELECT @@TRANCOUNT AS trancnt2; SELECT @@error;  → Oracle 은 트랜잭션/에러 상태가 자동관리되어 대응 개념 없음(디버그 출력만) */
            DBMS_OUTPUT.PUT_LINE('trancnt2');
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE));

            DBMS_OUTPUT.PUT_LINE('ERROR4');
            IF NVL(V_OK_DESCRIPTION, 'OK') <> 'OK' THEN
                V_LOG_MESSAGE := SUBSTR(V_OK_DESCRIPTION, 1, 1000);
            END IF;

            /* 원본 SELECT XACT_STATE() → Oracle 대응 개념 없음(디버그 출력만) */
            DBMS_OUTPUT.PUT_LINE('XACT_STATE');
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    /* SET NOCOUNT OFF; 는 Oracle 미지원, 제거 */

    /*================================================================================================================
      400 : SUB PROCEDURE CALL
      ================================================================================================================
      [PJ2025-50188] WEEKLY CUTOFF시 PRICE 부문 / EXCHANGE 부문도 CUTOFF 처리 (40사업부에 한정) (START)
      ================================================================================================================*/
    /* 2026.09.30   AJS   81 계열 MKT FCST 확정 시 판가 확정 대상 편입 (START) */
    -- IF ((V_DIVISION_ID = '40') AND (V_VER_TYPE = 'MF_D' OR V_VER_TYPE = 'MF_W' OR V_VER_TYPE = 'SF_W')) THEN
    IF ((V_DIVISION_ID = '40' OR SUBSTR(V_DIVISION_ID, 1, 2) = '81') AND (V_VER_TYPE = 'MF_D' OR V_VER_TYPE = 'MF_W' OR V_VER_TYPE = 'SF_W')) THEN
    /* 2026.09.30   AJS   81 계열 MKT FCST 확정 시 판가 확정 대상 편입 (END) */
        PR_SCM_MST_FUTURE_PRICE_CUTOFF(V_DIVISION_ID, P_VER_TYPE, P_CREATED_BY, V_VER_RETURN_NO);
    END IF;
    /*------------------------------------------------------------------------------------------------------------------
      [PJ2025-50188] WEEKLY CUTOFF시 PRICE 부문 / EXCHANGE 부문도 CUTOFF 처리 (40사업부에 한정) (END)
      ------------------------------------------------------------------------------------------------------------------
      UI 에서 수행한 수동 CutOff 인경우는 별도 다른 Procedure 를 호출하지 않음
      ------------------------------------------------------------------------------------------------------------------*/
    IF P_VER_TYPE <> 'MF_M' THEN
        /*--------------------------------------------------------------------------------------------------------------
          수행결과 성공여부 DISPLAY
          Weekly Rolling 시에 [dbo].[DM_PLN_MKT_FCST] 에 당주 이후 MKT_FCST_LATEST 값을 다 Delete 하고
          MKT_FCST 값을 그대로 select 해다가 Measure 값 MKT_FCST_LATEST로 Insert 하는 Procedure
          EXEC [dbo].[PR_DM_PLN_MKT_FCST_LASTEST_MEASURE] @v_division_id
          --------------------------------------------------------------------------------------------------------------
          RTF 값에 Sales Price가 곱해져서 KRW, LOC, USD Measure를 정상적으로 생성하는 프로시저 -> Sales Plan 데이터 생성
          --------------------------------------------------------------------------------------------------------------*/
        PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(V_DIVISION_ID, '');

        /*  20180726 KHSONG 주석처리 PR_DM_PLN_SALES_PLAN_CUTOFF 내에서 호출되도록 변경함
            [2018-02-12][추가][Sales Price의 SCM_MST_FUTURE_PRICE_C 테이블 INSERT]
            EXEC [dbo].[PR_SCM_MST_FUTURE_PRICE_CUTOFF]   @v_division_id
            [2018-02-12][추가][Sales Price의 SCM_MST_FUTURE_PRICE_C 테이블 INSERT] */
        IF (V_VER_TYPE = 'MF_W' OR V_VER_TYPE = 'SF_W') THEN /* [PJ2025-50188] SF_W 추가 */
            /*----------------------------------------------------------------------------------------------------------
              전주 MKT FCST 데이터를 생성함 => MKT_FCST_LATEST
              ----------------------------------------------------------------------------------------------------------*/
            PR_DM_PLN_MKT_FCST_LASTEST_MEASURE(V_DIVISION_ID);

            /* IF (( @v_division_id = '40' AND @v_ver_type = 'SF_W' ) OR ( @v_division_id != '40' )) [PJ2025-50188] 40사업부는 SCM_FCST 기반으로만 생성. 그외는 MKT_FCST 기반으로만 생성 ==> 수정 (모든 상황에서 net_demand 생성됨.) */
            BEGIN
                /*----------------------------------------------------------------------------------------------------------
                  전사업부 모든 버젼에서 DM_PLN_NET_DEMAND 생성함.
                  [2018-03-29][SONGKEEHO추가][DM_PLN_MKT_FCST_C 데이터로 -> DM_PLN_NET_DEMAND 데이터 생성]
                  ----------------------------------------------------------------------------------------------------------*/
                PR_DM_PLN_MKT_FCST_TO_NET_DEMAND(V_DIVISION_ID);
                /* [PJ20228272]_KPI 완료 후 생성에서 NET DEMAND 생성 후로 위치 변경
                   [2018-04-27][추가][PEGGING PROCEDURE] */
                PR_DM_PLN_DEMANDID_PEGGING(V_DIVISION_ID);
            END;

            /*----------------------------------------------------------------------------------------------------------
              [E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
              24.10.30 확인 당시에는 SP_D를 보여주는 화면이 존재하지 않고,
              해당 작업은 SALES CUTOFF시 SALES PLAN RESULT에 데이터를 반영하기 위함으로 확인됨
              현재 SALES PLAN CUTOFF 시간이 변경되면 MKT FCST CUTOFF와 RTF DIFF가 발생함에 따라,
              해당 작업을 MKT FCST CUTOFF시 진행하는 부분으로 변경하여, MKT FCST CUTOFF와의 DIFF를 없애는 방법 진행
              하여 MF_W에 진행하는 부분으로 수정함
              ----------------------------------------------------------------------------------------------------------*/
            IF (V_VER_TYPE = 'MF_W') THEN  /* [PJ2025-50188] MF_W 기준에서만 DALIY_CUTOFF 수행. SF_W에서도 수행할 경우 V002가 생성되지 많도록 처리 */
                PR_DM_PLN_SALES_PLAN_CUTOFF(
                  V_DIVISION_ID
                , 'DM_PLN_SALES_PLAN DAILY CUTOFF' /* @v_ver_description  DAILY 배치작업과 수동작업을 구분함 */
                , 'SP_D'                           /* @p_ver_type */
                , P_CREATED_BY);
            END IF;

            /* [PJ202001380] 화요일 Sales Plan Weekly Cutoff 제외
               IF @v_division_id <> '82'
               BEGIN
                   EXEC [dbo].[PR_DM_PLN_SALES_PLAN_CUTOFF] @v_division_id
                               ,'DM_PLN_SALES_PLAN WEEKLY CUTOFF'  @v_ver_description  DAILY 배치작업과 수동작업을 구분함
                               ,'SP_W'   @p_ver_type
                               ,@p_created_by
               END */

            /* [2018-04-09][추가][자동차 사업부 MKT FCST데이터를 DMS_RCCP_DP_VIEW 테이블 INSERT]
               EXEC [dbo].[DMS_RCCP_CONV_AUTO]  20180806 KHSONG 주석처리 */

            /* [2018-04-20][추가][KPI PROCEDURE]
               [E20250612-001460]_KPI 배치 중지 현재 사용하는 부분이 없는 것으로 확인되어 배치를 중단한다. START
               KPI 두 배치 중지 이유: (1) 사용하지 않는 메져 (2) 해당 프로시져 수행시간이 오래걸려 프로시져로 인하여 타시스템도 영향감
               PR_DM_PLN_MKT_FCST_KPI 생성하는 메져는: 'OVER_FCST', 'LESS_FCST', 'CFA', 'SFA'
               해당 메져를 사용하는 화면: MKT_FCST, MKT_FCST_WATERALL / 사업부: 전사업부
               UI CATEGORY에서도 메져는 VALID_YN N처리 진행
               EXEC [dbo].[PR_DM_PLN_MKT_FCST_KPI]		21, @v_division_id
               PR_DM_PLN_MKT_FCST_KPI_CFCR 생성하는 메져는: 'CFCR'
               해당 메져를 사용하는 화면: MKT_FCST, MKT_FCST_WATERALL / 사업부: 전사업부
               UI CATEGORY에서도 메져는 VALID_YN N처리 진행
               EXEC [dbo].[PR_DM_PLN_MKT_FCST_KPI_CFCR]	@v_division_id
               [E20250612-001460]_KPI 배치 중지 현재 사용하는 부분이 없는 것으로 확인되어 배치를 중단한다. END */

            /*-----------------------------------------------------------------------------------------------------------------------------------
              [E20250529-001289]_MKT FCST CUTOFF가 완료되고나면 메일을 발송한다.
              -----------------------------------------------------------------------------------------------------------------------------------*/
            PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND(P_DIVISION_ID, V_VER_RETURN_NO);

        ELSE
            /*----------------------------------------------------------------------------------------------------------
              [E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
              24.10.30 확인 당시에는 SP_D를 보여주는 화면이 존재하지 않고,
              해당 작업은 SALES CUTOFF시 SALES PLAN RESULT에 데이터를 반영하기 위함으로 확인됨
              현재 SALES PLAN CUTOFF 시간이 변경되면 MKT FCST CUTOFF와 RTF DIFF가 발생함에 따라,
              해당 작업을 MKT FCST CUTOFF시 진행하는 부분으로 변경하여, MKT FCST CUTOFF와의 DIFF를 없애는 방법 진행
              하여 해당 작업은 주석처리하고, MF_W에 진행하는 부분으로 수정함
              EXEC [dbo].[PR_DM_PLN_SALES_PLAN_CUTOFF] @v_division_id
                          ,'DM_PLN_SALES_PLAN DAILY CUTOFF'  @v_ver_description  DAILY 배치작업과 수동작업을 구분함
                          ,'SP_D'   @p_ver_type
                          ,@p_created_by
              ----------------------------------------------------------------------------------------------------------
              20180706 KHSONG BALANCE MAKE PROCEDURE 호출추가
              ----------------------------------------------------------------------------------------------------------*/
            BEGIN
                PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(
                     V_DIVISION_ID    /* DIVISION ID */
                   , NULL             /* plan_id */
                   , V_DUMMY_CUR      /* O_RESULT_CURSOR (Oracle 필수 OUT, 호출측 미사용 → 닫음) */
                );
                IF V_DUMMY_CUR%ISOPEN THEN
                    CLOSE V_DUMMY_CUR;
                END IF;
            END;
        END IF;

        /* [2018-03-29][SONGKEEHO추가][DM_PLN_MKT_FCST_C 데이터로 -> DM_PLN_NET_DEMAND 데이터 생성]
           EXEC [dbo].[PR_DM_PLN_MKT_FCST_TO_NET_DEMAND] @v_division_id
           [2018-03-28][추가]
           IF @v_ver_type = 'MF_D'
           BEGIN
               [2018-03-28][추가][DM_PLN_MKT_FCST_C][Daily Batch에 CUTOFF PROCEDURE 추가]
               EXEC [dbo].[PR_DM_PLN_MKT_FCST_CUTOFF]	@v_division_id
               [2018-03-28][추가][DM_PLN_MKT_FCST_RESULT_C][Daily Batch에 CUTOFF PROCEDURE 추가]
               EXEC [dbo].[PR_DM_PLN_MKT_FCST_RESULT_CUTOFF]	@v_division_id
           END */
    END IF;

    /*================================================================================================================
      500 : END LOG
      ================================================================================================================*/
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'Div: ' || P_DIVISION_ID || ' / ' || P_VER_TYPE;
    D_EVENT_DATE := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /*--------------------------------------------------------------------------------------------------------------------
      [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (START)
      --------------------------------------------------------------------------------------------------------------------*/
    IF P_VER_TYPE != 'MF_D' THEN
        PR_DM_SMS_LOG_BATCH(V_CATEGORY_NAME, V_LOG_TYPE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;
    /*--------------------------------------------------------------------------------------------------------------------
      [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (END)
      ================================================================================================================
      트랜잭션 (END)
      ================================================================================================================
      20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (START)
      ================================================================================================================*/
    <<ERR_RTN>>
    IF V_LOG_TYPE = 'INVALID' THEN
        ROLLBACK TO SP_MAIN;

        V_LOG_MESSAGE := '########## END of procedure ##########';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;
    /*================================================================================================================
      20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (END)
      ================================================================================================================*/
END PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING;
/

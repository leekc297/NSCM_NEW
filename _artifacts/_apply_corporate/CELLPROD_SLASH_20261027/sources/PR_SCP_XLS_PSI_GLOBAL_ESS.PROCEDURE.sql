PROCEDURE PR_SCP_XLS_PSI_GLOBAL_ESS
( P_PLAN_CYCLE           IN VARCHAR2
, P_PLAN_START_YYYYMMDD  IN VARCHAR2
, P_PLAN_ID              IN VARCHAR2
, P_MODELING_ID          IN VARCHAR2
, P_SEQ                  IN VARCHAR2
, P_PLAN_TYPE            IN VARCHAR2
, P_MASTER_ID            IN VARCHAR2
, P_DIVISION_ID          IN VARCHAR2
, P_ENGINE_PLAN_ID       IN VARCHAR2
, P_USER_ID              IN VARCHAR2 DEFAULT 'SCP_batch'
, P_IS_DEBUG             IN VARCHAR2 DEFAULT '0'  /* 0 : RELEASE, 1 : DEBUG  (KSK, 250417) */
, O_RETURN               OUT NUMBER               /* AS-IS RETURN 값 → OUT 인자 */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_ESS
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'

      EXEC PR_SCP_XLS_PSI_GLOBAL_ESS
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20250217'
             , @p_plan_id             = '1379'
             , @p_modeling_id         = '3'
             , @p_seq                 = '2'
             , @p_plan_type           = 'FN'
             , @p_master_id           = '82::WEEKLY'
             , @p_division_id         = '82'
             , @p_engine_plan_id      = '1379::FN::2'
             , @p_user_id             = 'KSK'
             , @p_is_debug            =  1

    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_ESS' order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.06.27   KTH         Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.07.16   KTH         ATTRIBUTE2에 LT(일) 추가 주별/일별 LT를 보여주기 위해서
 * 2019.08.28   KTH         SHIP_REQ_PACK_TOTAL,SHIP_REQ_CELL_TOTAL, SHIP_REQ, SEMI_SHIP_REQ 추가
 * 2019.08.29   KTH         PROJECT_CODE 추가('-' --> PROJECT_CODE)
 * 2019.08.30   KTH         SEMI_PACK_PROD_CELL FROM_SITE 수정('-' --> FROM_SITE표기)
 * 2019.12.04   KTH         CELL_PROD, CELL_PROD_LOAD에서 PROD_LINE이 '-'인 데이터 삭제 로직 추가
 * 2020.01.07   KTH         #Rn 테이블 변경
 * 2020.01.16   KTH         PROJECT NAME 반영 ATTRIBUTE8 반영
 * 2020.02.06   KTH         ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2020.02.19   KTH         YIELD 로직 변경 (CASE WHEN Y.SSP_MODIFY_YIELD > 0.0 THEN Y.SSP_MODIFY_YIELD ELSE Y.FORMATION_TOTAL_YIELD END)
 * 2020.02.19   KTH         PACK/CELL 분리 작업 반영  XLSPSI04 -> XLSPSI14
 * 2020.02.26   KTH         CELL_TACT_TIME, CELL_WORKING_TIME 로직 추가
 * 2020.02.28   KTH         PACK_WORKING_TIME, CELL_WORKING_TIME 수정
 * 2020.03.03   KTH         PACK_BOH 로직 수정(SCP_ANL_PSI_GLOBAL.QTY --> SCP_ANL_PSI_GLOBAL.FROM_BOH_QTY)
 * 2020.06.26   KTH         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
 * 2020.07.02   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 기준/최소 Gap Measure 추가
 * 2020.07.13   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련 - 기준/최소 쿼리에서 YYYYMM -> YYYYQ 으로 변경
 * 2020.07.14   KSW         생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완
 * 2020.08.20   KSW         생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가
 * 2020.09.01   KSW         생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가 ==> Operation id 에서 '_P' 를 삭제 (Pack Load Ratio 정렬오류)
 * 2021.05.25   KSW         NICK_NAME 누락방지
 * 2021.06.03   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (+26주 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
                            - 실제로는 364 + 364 플랜 DATA 가 생성됨
 * 2021.08.23   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.11.12   KSW         튜닝개선 - 0값 제거 및 쿼리재조정
 * 2021.12.22   KSW         DC link. Pack Semi 계획에 관련 measure 생성로직 추가
 * 2022.05.12   KSW         복수 BOD 수립관련건 적용
 * 2024.07.01   KSK         PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 * 2022.11.14   KJH         SEMI_SHIP_PLAN이 없을 경우 SEMI_WHIN 안나옴 ==> SEMI_INTRANSIT_ETA가 있을 경우  SEMI_WHIN를 추가함.
 * 2025.01.16   KSK         이력테이블 생성(3주차 까지)
 * 2025.04.17   KSK         디버그 파라미터 추가
 * 2025.04.18   KSK         셀제품의 셀특성화 정보 누락방지
 * 2025.08.11   KSK         디버그용 파라미터(@p_is_debug ) 추가,[E20250805-000724] ess 사업부 시뮬레이터 특정 모델 저장 안되는 이슈
 * 2025.09.02   kimcd       속도 개선 HASH 추가
 * 2026.05.22   ymh         E20260331-000738 82사업부 MA Plan 수행 시 속도지연
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
AS
    /* AS-IS 인자 선언 길이 재현 : NVARCHAR(0150) · NVARCHAR(0008) · NVARCHAR(4000) · NVARCHAR(0030) */
    V_PLAN_CYCLE             VARCHAR2(150 CHAR)  := SUBSTR(P_PLAN_CYCLE, 1, 150);
    V_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_PLAN_ID                VARCHAR2(4000)      := SUBSTR(P_PLAN_ID, 1, 4000);
    V_MODELING_ID            VARCHAR2(4000)      := SUBSTR(P_MODELING_ID, 1, 4000);
    V_SEQ                    VARCHAR2(4000)      := SUBSTR(P_SEQ, 1, 4000);
    V_PLAN_TYPE              VARCHAR2(4000)      := SUBSTR(P_PLAN_TYPE, 1, 4000);
    V_MASTER_ID              VARCHAR2(4000)      := SUBSTR(P_MASTER_ID, 1, 4000);
    V_DIVISION_ID            VARCHAR2(30 CHAR)   := SUBSTR(P_DIVISION_ID, 1, 30);
    V_ENGINE_PLAN_ID         VARCHAR2(4000)      := SUBSTR(P_ENGINE_PLAN_ID, 1, 4000);
    V_USER_ID                VARCHAR2(150 CHAR)  := SUBSTR(P_USER_ID, 1, 150);
    N_SEQ                    NUMBER;             /* NUMBER 칸 = NVARCHAR 인자 비교 → 인자를 숫자로 변환 */

    /* LOG 용 변수 설정 */
    V_BATCH_USER             VARCHAR2(150 CHAR)  := 'SCP_batch';
    V_PROGRAM_NAME           VARCHAR2(150 CHAR)  := 'PR_SCP_XLS_PSI_GLOBAL_ESS';
    V_LOG_TYPE               VARCHAR2(30 CHAR);  /* START/END/ERROR/... */
    N_LOG_COUNT              PLS_INTEGER         := 0;
    V_LOG_MESSAGE            VARCHAR2(1000 CHAR);
    V_DESCRIPTION            VARCHAR2(500 CHAR);
    V_TABLE_ID               VARCHAR2(150 CHAR)  := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE             DATE;

    /* 실행시간 확인용 */
    D_START_TIME             DATE;
    V_EXEC_TIME              VARCHAR2(10 CHAR)   := '';  /* '00:00' */
    N_EXEC_SEC               NUMBER;

    V_PROGRAM_ID             VARCHAR2(30 CHAR)   := 'XLSPSI14';
    V_TO_YYYYMMDD            VARCHAR2(8 CHAR)    := '';  /* CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112) -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응 */
    V_CUTOFF_DATE            VARCHAR2(8 CHAR);

    V_HIST_DATE              VARCHAR2(8 CHAR);
    N_EXISTS                 PLS_INTEGER         := 0;
    N_ROWS                   NUMBER;             /* DECLARE @rows INT */
    V_CREATE_FROM_YYYYMMDD   VARCHAR2(8 CHAR);
    V_CREATE_TO_YYYYMMDD     VARCHAR2(8 CHAR);

    /* Plan End Date */
    V_PET_DATE               VARCHAR2(12 CHAR)   := '';
    V_BP_FLAG                VARCHAR2(8 CHAR)    := '';
    N_BP_DAYS                PLS_INTEGER         := 0;
    V_BP_PLAN_END_YYYYMMDD   VARCHAR2(8 CHAR)    := '';
BEGIN
    O_RETURN := 0;  /* 반환값 초기화 */

    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; */
    /* --SET ANSI_WARNINGS OFF; SET ANSI_WARNINGS ON; SET ANSI_NULLS ON; (Oracle 기본 동작) */

    /* LOG 용 변수 설정 */
    V_BATCH_USER := V_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;

    /* 실행시간 확인용 */
    D_START_TIME  := SYSDATE;
    V_CUTOFF_DATE := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

    BEGIN  /* BEGIN TRY */
        N_SEQ := TO_NUMBER(V_SEQ);

        /* ----------------------------------------------------------------------------------------------------------- */
        /* PLAN 기간설정 - 2021.11.19 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* AS-IS : PLAN_ID(NVARCHAR) < 9999(INT) 는 숫자 비교, MAX(PLAN_ID) 는 문자 최대값 */
        BEGIN
            SELECT A.HORIZON_END_DATE
              INTO V_TO_YYYYMMDD
              FROM SCM_MST_PLAN A
             WHERE A.PLAN_ID     = (SELECT MAX(B.PLAN_ID)
                                      FROM SCM_MST_PLAN B
                                     WHERE B.DIVISION_ID          = V_DIVISION_ID
                                       AND TO_NUMBER(B.PLAN_ID)   < 9999)
               AND A.PLAN_CYCLE  = 'WEEKLY'
               AND A.DIVISION_ID = V_DIVISION_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;  /* AS-IS : 행이 없으면 @p_to_yyyymmdd 값 유지 */
        END;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 정보 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#MEASURE') IS NOT NULL DROP TABLE #MEASURE */
        DELETE FROM GT_XESS_MEASURE;

        /* MEASURE 세팅값 추출 */
        INSERT
          INTO GT_XESS_MEASURE
             ( COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , DIV
             , GUBUN
             )
        SELECT COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , (CASE WHEN ATTRIBUTE1 = 'PACK' THEN 'P'
                     WHEN ATTRIBUTE1 = 'CELL' THEN 'A'
                     ELSE 'C'
                END)                AS DIV
             , ATTRIBUTE2           AS GUBUN
          FROM SCM_MST_SHEET_MEASURE
         WHERE VALID_YN   = 'Y'
           AND PROGRAM_ID = V_PROGRAM_ID;

        /* 하위 PR_SCP_XLS_PSI_GLOBAL_ESS_S 가 읽는 #MEASURE 공유분 */
        DELETE FROM GT_SCXL_MEASURE;

        INSERT
          INTO GT_SCXL_MEASURE
             ( GUBUN
             , COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             )
        SELECT GUBUN
             , COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
          FROM GT_XESS_MEASURE;

        /* IF @P_IS_DEBUG = 1 SELECT '#MEASURE' #MEASURE,  * FROM #MEASURE  (디버그 결과셋 - Oracle 결과셋 반환 없음) */

        /* ----------------------------------------------------------------------------------------------------------- */
        /*  데이터 이관 ('MKT_FCST','SHIP_PLAN','PRODUCTION') */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#PSI_GLOBAL') IS NOT NULL DROP TABLE #PSI_GLOBAL; CREATE TABLE #PSI_GLOBAL (...) */
        DELETE FROM GT_XESS_PSI_GLOBAL;

/*
---- 단위처리시간 추출 --
--print N'position_1 measure 임시정보 및 #PSI_GLOBAL temp 생성'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* SHIP_PLAN (FG) (팩,셀 공통) - MKT_FCST, SHIP_PLAN */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 기존로직 주석처리 시작 */
/*
            INSERT INTO #PSI_GLOBAL
                SELECT A.DIVISION_ID
                        , A.BIZ_TYPE
                        , '' AS CELL_ITEM_ID
                        , A.ITEM_ID
                        , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE
                  , A.PROJECT_CODE
                        , 0 AS TO_BOH_QTY
                        , 0 AS FROM_BOH_QTY
                        , A.INCOTERMS
                        , A.FROM_SITE
                  -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                  ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C WITH(NOLOCK) where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE    ),'-') AS TRANSPORT_MODE
                  , '-'              AS PROD_LINE
                        , A.MEASURE                                             -- SHIP_PLAN FG
                        , A.YYYYMMDD        AS YYYYMMDD
                  , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
                        , M.SORT_ORDER_NO
                        , M.COLUMN_LABEL_NAME
                        , A.BOD_ID
                  , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
                        , A.ATTRIBUTE9
                   FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
                 INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK)
                    ON A.YYYYMMDD           = C.BASIS_YYYYMMDD
                INNER JOIN #MEASURE M WITH(NOLOCK)
                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')
                    AND A.MEASURE             = M.COLUMN_NAME
                 WHERE A.DIVISION_ID                =  @p_division_id
                        AND A.PLAN_START_YYYYMMDD   =  @p_plan_start_yyyymmdd
                        AND A.PLAN_TYPE                 =  @p_plan_type
                        AND A.SEQ                       =  @p_seq
                        AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
                        AND A.YYYYMMDD            <   @p_to_yyyymmdd
                        --AND A.YYYYMMDD            <=   @p_to_yyyymmdd  --말일포함(KSK, 20240814, 운영배포보류)
                    AND A.MEASURE             IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')
*/
        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 기존로직 주석처리 끝 */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 시작 */
        /* #BOD_TRANSPORT : MIN(B.TRANSPORT_MODE) AS TRANSPORT_MODE   -- TOP 1과 동일 효과 */
        /*   CREATE CLUSTERED INDEX CX_BOD_TRANSPORT ON #BOD_TRANSPORT (DIVISION_ID, BOD_ID, FROM_SITE); → 1회 참조라 인라인 뷰(IA)로 전환 */
        /* Step 2: #MEASURE 필터링 (SHIP_PLAN, MKT_FCST, SHIP_REQ만 미리 필터) */
        /*   CREATE CLUSTERED INDEX CX_MEASURE_FILTERED ON #MEASURE_FILTERED (COLUMN_NAME); → 1회 참조라 인라인 뷰(XA)로 전환 */
        INSERT
          INTO GT_XESS_PSI_GLOBAL
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT A.DIVISION_ID
             , A.BIZ_TYPE
             , NULL                          AS CELL_ITEM_ID
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')           AS TO_SITE         /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
             , A.PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
               /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL(IA.TRANSPORT_MODE, '-')   AS TRANSPORT_MODE
             , '-'                           AS PROD_LINE
             , A.MEASURE                                        /* SHIP_PLAN FG */
             , A.YYYYMMDD                    AS YYYYMMDD
             , NVL(A.QTY, 0)                 AS QTY             /* 기존 INTRANSIT 무시하고 모두 0 */
             , XA.SORT_ORDER_NO
             , XA.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'    AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
             , SCM_SYS_CALENDAR_M       B
             , (SELECT C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO
                  FROM GT_XESS_MEASURE C
                 WHERE C.COLUMN_NAME IN ('SHIP_PLAN', 'MKT_FCST', 'SHIP_REQ')) XA      /* #MEASURE_FILTERED */
             , (SELECT D.DIVISION_ID
                     , D.BOD_ID
                     , D.FROM_SITE
                     , MIN(D.TRANSPORT_MODE) AS TRANSPORT_MODE                         /* TOP 1과 동일 효과 */
                  FROM SCP_MST_BOD_N_V D
                 WHERE D.DIVISION_ID = V_DIVISION_ID
                 GROUP BY D.DIVISION_ID
                        , D.BOD_ID
                        , D.FROM_SITE) IA                                              /* #BOD_TRANSPORT */
         WHERE A.YYYYMMDD            = B.BASIS_YYYYMMDD
           AND A.MEASURE             = XA.COLUMN_NAME
           AND A.DIVISION_ID         = IA.DIVISION_ID(+)
           AND A.BOD_ID              = IA.BOD_ID(+)
           AND A.FROM_SITE           = IA.FROM_SITE(+)
           AND XA.COLUMN_NAME       IN ('SHIP_PLAN', 'MKT_FCST', 'SHIP_REQ')
           AND A.MEASURE            IN ('SHIP_PLAN', 'MKT_FCST', 'SHIP_REQ')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
           AND A.YYYYMMDD           >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD            < V_TO_YYYYMMDD;
        /* OPTION ( LOOP JOIN                -- Hash Match 금지 → 메모리 그랜트 제거 */
        /*        ,MAXDOP 1                  -- 병렬처리 금지 → MEMORY_ALLOCATION_EXT 대기 제거 */
        /*        ,OPTIMIZE FOR UNKNOWN      -- 파라미터 스니핑 방지 (상수 하드코딩 불필요) */
        /*                                   -- 옵티마이저가 통계 기반 평균값으로 실행계획 수립 */
        /*                                   -- → 특정 파라미터값에 종속된 실행계획 고착 방지 */
        /*        );  (MSSQL 쿼리 힌트 - Oracle 미대응) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 끝 */

        /* IF @P_IS_DEBUG = 1 SELECT '233' AS "#PSI_GLOBAL", * FROM #PSI_GLOBAL WHERE  @p_plan_start_yyyymmdd = YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE SHIP_PLAN / MKT_FCST / SHIP_REQ ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_2 #PSI_GLOBAL temp에 SHIP_PLAN data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 복수 BOD 수립관련건 적용 :: 2022.04.18 */
        /* ----------------------------------------------------------------------------------------------------------- start */
        /* IF OBJECT_ID('tempdb..#BOD_OTHER_SHIP_PLAN') IS NOT NULL DROP TABLE #BOD_OTHER_SHIP_PLAN; CREATE TABLE #BOD_OTHER_SHIP_PLAN (...) */
        DELETE FROM GT_XESS_BOD_OTHER_SHIP_PLAN;

        /* AS-IS : (A LEFT OUTER JOIN SCP_MST_BOD_N_V B ON ... AND NOT EXISTS(...)) 뒤 WHERE X.TRANSPORT_MODE IS NOT NULL */
        /*         → B 가 맞은 행만 남으므로(B.TRANSPORT_MODE <> 'AIR' 조건으로 NULL 없음) 내부조인과 결과 동일 */
        INSERT
          INTO GT_XESS_BOD_OTHER_SHIP_PLAN
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT IA.DIVISION_ID
             , IA.OPERATION_GROUP            AS BIZ_TYPE
             , NULL                          AS CELL_ITEM_ID
             , IA.ITEM_ID
             , NVL(IA.TO_SITE, '-')          AS TO_SITE         /* ISNULL(NULLIF(X.TO_SITE, '') , '-') */
             , IA.PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE
             , '-'                           AS PROD_LINE
             , 'SHIP_PLAN'                   AS MEASURE         /* SHIP_PLAN FG */
             , V_PLAN_START_YYYYMMDD         AS YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , IA.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'    AS ATTRIBUTE1
             , IA.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       XA.DIVISION_ID
                     , XA.OPERATION_GROUP
                     , XA.ITEM_ID
                     , XA.FROM_SITE
                     , XA.TO_SITE
                     , XA.ATTRIBUTE9
                     , C.TRANSPORT_MODE
                     , C.INCOTERMS
                     , C.BOD_ID
                     , XA.PROJECT_CODE
                  FROM (SELECT DISTINCT
                               D.DIVISION_ID
                             , D.ITEM_ID
                             , D.FROM_SITE
                             , D.OPERATION_GROUP
                             , D.TO_SITE
                             , D.INCOTERMS
                             , D.TRANSPORT_MODE
                             , D.ATTRIBUTE9
                             , D.PROJECT_CODE
                          FROM SCP_XLS_PSI_GLOBAL_ESS D
                         WHERE D.ITEM_ID IN (SELECT DISTINCT E.ITEM_ID                  /* 2022.05.24 :: 복수 bod 생성오류수정 */
                                               FROM SCM_MST_FINAL_ITEM_V E
                                              WHERE E.OPERATION_GROUP_ID = 'P'
                                                AND E.DC_YN              = 'Y'
                                                AND E.DIVISION_ID        = V_DIVISION_ID)
                           AND D.MEASURE         = 'SHIP_PLAN'
                           AND D.OPERATION_GROUP = 'P') XA
                     , SCP_MST_BOD_N_V C
                 WHERE XA.DIVISION_ID   = C.DIVISION_ID
                   AND XA.FROM_SITE     = C.FROM_SITE
                   AND XA.TO_SITE       = C.TO_SITE
                   AND XA.INCOTERMS     = C.INCOTERMS
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_SHIPMENT_PLAN_FG F                    /* 출하계획 존재시 제외 */
                                    WHERE F.FROM_SITE           = XA.FROM_SITE
                                      AND F.ITEM_ID             = XA.ITEM_ID
                                      AND F.BOD_ID              = C.BOD_ID
                                      AND F.MEASURE             = 'SHIP_PLAN'
                                      AND F.DIVISION_ID         = V_DIVISION_ID
                                      AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND F.PLAN_TYPE           = V_PLAN_TYPE
                                      AND F.SEQ                 = N_SEQ)
                   AND C.BOD_TYPE       = 'SALES'
                   AND C.TRANSPORT_MODE <> 'AIR'
                   AND C.BOD_VALID_YN   = 'Y'
                   AND C.TO_YYYYMMDD   >= V_PLAN_START_YYYYMMDD) IA
             , SCM_MST_SITE_ITEM_PRIORITY A
             , GT_XESS_MEASURE            B
         WHERE IA.DIVISION_ID       = A.DIVISION_ID(+)
           AND IA.ITEM_ID           = A.ITEM_ID(+)
           AND IA.FROM_SITE         = A.PLANT_SITE_ID(+)
           AND A.VALID_YN(+)        = 'Y'
           AND A.FROM_YYYYMMDD(+)  <= V_TO_YYYYMMDD
           AND B.COLUMN_NAME        = 'SHIP_PLAN'
           AND IA.TRANSPORT_MODE   IS NOT NULL;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE SHIP_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        INSERT
          INTO GT_XESS_PSI_GLOBAL
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
          FROM GT_XESS_BOD_OTHER_SHIP_PLAN;

        /* 하위 PR_SCP_XLS_PSI_GLOBAL_ESS_S 가 읽는 #BOD_OTHER_SHIP_PLAN 공유분 */
        DELETE FROM GT_SCXL_BOD_OTHER_SHIP;

        INSERT
          INTO GT_SCXL_BOD_OTHER_SHIP
             ( ITEM_ID
             , FROM_SITE
             , TO_SITE
             , BOD_ID
             , PROJECT_CODE
             , INCOTERMS
             )
        SELECT ITEM_ID
             , FROM_SITE
             , TO_SITE
             , BOD_ID
             , PROJECT_CODE
             , INCOTERMS
          FROM GT_XESS_BOD_OTHER_SHIP_PLAN;
        /* ----------------------------------------------------------------------------------------------------------- end */


        /* ----------------------------------------------------------------------------------------------------------- */
        /* PACK_PROD, CELL_PROD (SCP_ANL_PRODUCTION_PLAN) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , NULL                          AS CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                           AS TO_SITE
             , '-'                           AS PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , A.SCM_SITE_ID                 AS FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , A.LINE_ID                     AS PROD_LINE
             , C.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)                    AS QTY
             , C.SORT_ORDER_NO
             , C.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , 'SCP_ANL_PRODUCTION_PLAN'     AS ATTRIBUTE1
             , A.OPERATION_ID                AS ATTRIBUTE9
          FROM SCP_ANL_PRODUCTION_PLAN A
             , SCM_SYS_CALENDAR_M      B
             , GT_XESS_MEASURE         C
         WHERE A.YYYYMMDD            = B.BASIS_YYYYMMDD
           AND (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                     WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                     ELSE '-'
                END)                 = C.COLUMN_NAME
           AND C.COLUMN_NAME        IN ('PACK_PROD', 'CELL_PROD')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
           /* AND A.LINE_ID              <> '-' */
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.ITEM_ID
                , A.SCM_SITE_ID
                , A.LINE_ID
                , C.COLUMN_NAME
                , A.YYYYMMDD
                , C.SORT_ORDER_NO
                , C.COLUMN_LABEL_NAME
                , A.OPERATION_ID;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE PACK_PROD, CELL_PROD (SCP_ANL_PRODUCTION_PLAN)    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* SELECT * INTO #ANL_SHIPMENT_PLAN_FG FROM #PSI_GLOBAL WITH (NOLOCK) WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG' */
        /* SELECT * INTO #ANL_PRODUCTION_PLAN  FROM #PSI_GLOBAL WITH (NOLOCK) WHERE ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN' */
        /* → #PSI_GLOBAL 은 이후 수정·삭제가 없고 뒤에 들어오는 행의 ATTRIBUTE1 은 위 두 값이 아니므로, */
        /*   별도 GTT 없이 GT_XESS_PSI_GLOBAL 을 같은 ATTRIBUTE1 조건으로 읽는다(결과 동일). */

/*
---- 단위처리시간 추출 --
--print N'position_3 #PSI_GLOBAL temp에 PROD data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , NULL                          AS CELL_ITEM_ID
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')           AS TO_SITE         /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
             , '-'                           AS PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , A.FROM_SITE
               /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT SA.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V SA
                     WHERE SA.DIVISION_ID = A.DIVISION_ID
                       AND SA.BOD_ID      = A.BOD_ID
                       AND SA.FROM_SITE   = A.FROM_SITE
                       AND ROWNUM         = 1), '-') AS TRANSPORT_MODE
             , '-'                           AS PROD_LINE
             , C.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD                    AS YYYYMMDD
             , NVL(A.QTY, 0)                 AS QTY             /* 기존 INTRANSIT 무시하고 모두 0 */
             , C.SORT_ORDER_NO
             , C.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI'  AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
             , SCM_SYS_CALENDAR_M         B
             , GT_XESS_MEASURE            C
         WHERE A.YYYYMMDD            = B.BASIS_YYYYMMDD
           AND (CASE A.MEASURE WHEN 'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN'
                               WHEN 'SHIP_REQ'  THEN 'SEMI_SHIP_REQ'
                               ELSE A.MEASURE
                END)                 = C.COLUMN_NAME
           AND C.COLUMN_NAME        IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_REQ')
           AND A.MEASURE            IN ('SHIP_PLAN', 'SHIP_REQ')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
           AND A.YYYYMMDD           >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD            < V_TO_YYYYMMDD;
           /* --AND A.YYYYMMDD            <=   @p_to_yyyymmdd      --말일포함(KSK, 20240814, 운영배포보류) */
           /* AND A.ITEM_ID             IN ('ACEN1052U-A1','APRSAKANG-A1','APRSAKANG-B1' ) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* --SELECT '#PSI_GLOBAL' TN , * FROM #PSI_GLOBAL--TEST */

        /* IF OBJECT_ID('tempdb..#ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL DROP TABLE #ANL_SHIPMENT_PLAN_SEMI */
        /* SELECT * INTO #ANL_SHIPMENT_PLAN_SEMI FROM #PSI_GLOBAL WITH (NOLOCK) WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI' */
        /* → GT_XESS_PSI_GLOBAL 을 같은 ATTRIBUTE1 조건으로 읽는다(결과 동일) */

/*
---- 단위처리시간 추출 --
--print N'position_4 #PSI_GLOBAL temp에 SEMI ship plan data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE
             , MAX(IA.PROD_LINE)             AS PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , MAX(IA.QTY)                   AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , IA.BOD_ID
             , MAX(IA.ATTRIBUTE1)            AS ATTRIBUTE1
             , MAX(IA.ATTRIBUTE9)            AS ATTRIBUTE9
          FROM (SELECT A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , NULL                              AS CELL_ITEM_ID
                     , A.ITEM_ID
                     , '-'                               AS TO_SITE
                     , '-'                               AS PROJECT_CODE
                     , 0                                 AS TO_BOH_QTY
                     , 0                                 AS FROM_BOH_QTY
                     , '-'                               AS INCOTERMS
                     , A.SITE_ID                         AS FROM_SITE
                     , '-'                               AS TRANSPORT_MODE
                     , '-'                               AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                  AS MEASURE        /* ACTIVATE_COMPLETED */
                     , TO_CHAR(A.END_TIME, 'YYYYMMDD')   AS YYYYMMDD
                     , SUM(NVL(A.COMPLETE_QTY, 0))       AS QTY
                     , B.SORT_ORDER_NO
                     , B.COLUMN_LABEL_NAME
                     , '-'                               AS BOD_ID
                     , 'SCP_PLN_PRODUCTION_PLAN'         AS ATTRIBUTE1
                     , A.OPERATION_ID                    AS ATTRIBUTE9
                  FROM SCP_PLN_PRODUCTION_PLAN A
                     , GT_XESS_MEASURE         B
                 WHERE B.COLUMN_NAME        IN ('CELL_CHAR_PLAN')
                   AND A.OPERATION_ID        = 'F6000'
                   AND A.DIVISION_ID         = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = V_PLAN_TYPE
                   AND A.SEQ                 = N_SEQ
                 GROUP BY A.DIVISION_ID
                        , A.OPERATION_GROUP
                        , A.ITEM_ID
                        , A.SITE_ID
                        , TO_CHAR(A.END_TIME, 'YYYYMMDD')
                        , B.SORT_ORDER_NO
                        , B.COLUMN_LABEL_NAME
                        , A.OPERATION_ID
                 UNION
                SELECT DISTINCT
                       C.DIVISION_ID
                     , C.OPERATION_GROUP
                     , NULL                              AS CELL_ITEM_ID
                     , C.ITEM_ID
                     , '-'                               AS TO_SITE
                     , '-'                               AS PROJECT_CODE
                     , 0                                 AS TO_BOH_QTY
                     , 0                                 AS FROM_BOH_QTY
                     , '-'                               AS INCOTERMS
                     , C.FROM_SITE
                     , '-'                               AS TRANSPORT_MODE
                     , '-'                               AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                  AS MEASURE        /* ACTIVATE_COMPLETED */
                     , C.YYYYMMDD
                     , 0                                 AS QTY
                     , 440                               AS SORT_ORDER_NO
                     , 'Char. Plan'                      AS COLUMN_LABEL_NAME
                     , '-'                               AS BOD_ID
                     , NULL                              AS ATTRIBUTE1
                     , NULL                              AS ATTRIBUTE9
                  FROM GT_XESS_PSI_GLOBAL C                                /* #ANL_PRODUCTION_PLAN */
                 WHERE C.ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'
                 UNION /* --KSK(250418) */
                SELECT D.DIVISION_ID
                     , D.OPERATION_GROUP
                     , NULL                              AS CELL_ITEM_ID
                     , G.ITEM_ID_PROD                    AS CELL_ITEM_ID   /* --CELL */
                     , '-'                               AS TO_SITE
                     , '-'                               AS PROJECT_CODE
                     , 0                                 AS TO_BOH_QTY
                     , 0                                 AS FROM_BOH_QTY
                     , '-'                               AS INCOTERMS
                     , D.SITE_ID                         AS FROM_SITE
                     , '-'                               AS TRANSPORT_MODE
                     , '-'                               AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                  AS MEASURE        /* ACTIVATE_COMPLETED */
                     , TO_CHAR(D.END_TIME, 'YYYYMMDD')   AS YYYYMMDD
                     , SUM(NVL(D.COMPLETE_QTY, 0))       AS QTY
                     , E.SORT_ORDER_NO
                     , E.COLUMN_LABEL_NAME
                     , '-'                               AS BOD_ID
                     , 'SCP_PLN_PRODUCTION_PLAN'         AS ATTRIBUTE1
                     , D.OPERATION_ID                    AS ATTRIBUTE9
                  FROM SCP_PLN_PRODUCTION_PLAN    D
                     , GT_XESS_MEASURE            E
                     , SCM_MST_SITE               F
                     , SCP_MST_CELL_PROD_ASSY_MAP G
                 WHERE D.DIVISION_ID         = F.DIVISION_ID
                   AND D.SITE_ID             = F.SCM_SITE_ID
                   AND F.DIVISION_ID         = G.DIVISION_ID
                   AND F.PLANT_ID            = G.PLANT_ID
                   AND D.ITEM_ID             = G.ITEM_ID_ASSY
                   AND E.COLUMN_NAME        IN ('CELL_CHAR_PLAN')
                   AND D.OPERATION_ID        = 'F6000'
                   AND D.DIVISION_ID         = V_DIVISION_ID
                   AND D.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND D.PLAN_TYPE           = V_PLAN_TYPE
                   AND D.SEQ                 = N_SEQ
                 GROUP BY D.DIVISION_ID
                        , D.OPERATION_GROUP
                        , G.ITEM_ID_PROD
                        , D.SITE_ID
                        , TO_CHAR(D.END_TIME, 'YYYYMMDD')
                        , E.SORT_ORDER_NO
                        , E.COLUMN_LABEL_NAME
                        , D.OPERATION_ID
                 UNION /* --KSK(250418) */
                SELECT DISTINCT
                       H.DIVISION_ID
                     , H.OPERATION_GROUP
                     , NULL                              AS CELL_ITEM_ID
                     , K.ITEM_ID_PROD                    AS CELL_ITEM_ID   /* --CELL */
                     , '-'                               AS TO_SITE
                     , '-'                               AS PROJECT_CODE
                     , 0                                 AS TO_BOH_QTY
                     , 0                                 AS FROM_BOH_QTY
                     , '-'                               AS INCOTERMS
                     , H.FROM_SITE
                     , '-'                               AS TRANSPORT_MODE
                     , '-'                               AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                  AS MEASURE        /* ACTIVATE_COMPLETED */
                     , H.YYYYMMDD
                     , 0                                 AS QTY
                     , 440                               AS SORT_ORDER_NO
                     , 'Char. Plan'                      AS COLUMN_LABEL_NAME
                     , '-'                               AS BOD_ID
                     , NULL                              AS ATTRIBUTE1
                     , NULL                              AS ATTRIBUTE9
                  FROM GT_XESS_PSI_GLOBAL         H                        /* #ANL_PRODUCTION_PLAN */
                     , SCM_MST_SITE               J
                     , SCP_MST_CELL_PROD_ASSY_MAP K
                 WHERE H.DIVISION_ID = J.DIVISION_ID
                   AND H.FROM_SITE   = J.SCM_SITE_ID
                   AND J.DIVISION_ID = K.DIVISION_ID
                   AND J.PLANT_ID    = K.PLANT_ID
                   AND H.ITEM_ID     = K.ITEM_ID_ASSY
                   AND H.ATTRIBUTE1  = 'SCP_ANL_PRODUCTION_PLAN'
                   /* KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - Start */
                 UNION
                SELECT DISTINCT
                       L.DIVISION_ID
                     , L.OPERATION_GROUP
                     , NULL                              AS CELL_ITEM_ID
                     , L.ITEM_ID
                     , '-'                               AS TO_SITE
                     , '-'                               AS PROJECT_CODE
                     , 0                                 AS TO_BOH_QTY
                     , 0                                 AS FROM_BOH_QTY
                     , '-'                               AS INCOTERMS
                     , L.FROM_SITE
                     , '-'                               AS TRANSPORT_MODE
                     , '-'                               AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                  AS MEASURE        /* ACTIVATE_COMPLETED */
                     , L.YYYYMMDD
                     , 0                                 AS QTY
                     , 440                               AS SORT_ORDER_NO
                     , 'Char. Plan'                      AS COLUMN_LABEL_NAME
                     , '-'                               AS BOD_ID
                     , NULL                              AS ATTRIBUTE1
                     , NULL                              AS ATTRIBUTE9
                  FROM GT_XESS_PSI_GLOBAL L                                /* #ANL_SHIPMENT_PLAN_SEMI */
                 WHERE L.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                   /* KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - End */
               ) IA
         WHERE IA.ITEM_ID IS NOT NULL
         GROUP BY IA.DIVISION_ID
                , IA.OPERATION_GROUP
                , IA.CELL_ITEM_ID
                , IA.ITEM_ID
                , IA.TO_SITE
                , IA.PROJECT_CODE
                , IA.TO_BOH_QTY
                , IA.FROM_BOH_QTY
                , IA.INCOTERMS
                , IA.FROM_SITE
                , IA.TRANSPORT_MODE
                /* , PROD_LINE */
                , IA.MEASURE
                , IA.YYYYMMDD
                , IA.SORT_ORDER_NO
                , IA.COLUMN_LABEL_NAME
                , IA.BOD_ID;
                /* --,ATTRIBUTE1 */
                /* --,ATTRIBUTE9 */

        /* IF @P_IS_DEBUG = 1 SELECT '697_#PSI_GLOBAL' AS "#PSI_GLOBAL",  * FROM #PSI_GLOBAL WHERE QTY >0  (디버그 결과셋) */
        IF P_IS_DEBUG = '1' THEN
            O_RETURN := 0;  /* AS-IS RETURN ; (값 없는 RETURN = 0) */
            RETURN;
        END IF;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* SELECT * INTO #SCP_PLN_PRODUCTION_PLAN FROM #PSI_GLOBAL WITH (NOLOCK) WHERE ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN' */
        /* → GT_XESS_PSI_GLOBAL 을 같은 ATTRIBUTE1 조건으로 읽는다(결과 동일) */

/*
---- 단위처리시간 추출 --
--print N'position_5 #PSI_GLOBAL temp에 CELL_CHAR_PLAN data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 대상 ITEM_ID 추출 */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_XESS_ITEM_ID;

        INSERT
          INTO GT_XESS_ITEM_ID
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , MAX(TO_BOH_QTY)               AS TO_BOH_QTY
             , MAX(FROM_BOH_QTY)             AS FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , V_PLAN_START_YYYYMMDD         AS YYYYMMDD
             , MAX(QTY)                      AS QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , MAX(ATTRIBUTE1)               AS ATTRIBUTE1
             , MAX(ATTRIBUTE9)               AS ATTRIBUTE9
          FROM GT_XESS_PSI_GLOBAL
         GROUP BY DIVISION_ID
                , OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                , TO_SITE
                , PROJECT_CODE
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE
                , PROD_LINE
                , MEASURE
                , SORT_ORDER_NO
                , COLUMN_LABEL_NAME
                , BOD_ID;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INTO #ITEM_ID ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' INTO #ITEM_ID  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* --,ATTRIBUTE1 */
        /* --,ATTRIBUTE9 */

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '800_ITEM_ID' AS  "#ITEM_ID" , * FROM "#ITEM_ID"  ;END  (디버그 결과셋) */

        /* IF OBJECT_ID('tempdb..#PSI_GLOBAL_ESS') IS NOT NULL DROP TABLE #PSI_GLOBAL_ESS; CREATE TABLE #PSI_GLOBAL_ESS (...) */
        DELETE FROM GT_XESS_PSI_GLOBAL_ESS;

/*
---- 단위처리시간 추출 --
--print N'position_6 #ITEM_ID temp 및 #PSI_GLOBAL_ESS temp create'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                           AS TO_SITE
             , '-'                           AS PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , '-'                           AS FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , '-'                           AS PROD_LINE
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , 'MKT_FCST_PACK_TOTAL'         AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV             = 'C'
           AND B.GUBUN           = 'ITEM_ID'
           AND A.MEASURE         = 'MKT_FCST'
           AND A.OPERATION_GROUP = 'P';

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
-- -- 단위처리시간 추출 --
--print N'position_7 #PSI_GLOBAL_ESS temp 에 MKT_FCST_PACK_TOTAL 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : ITEM_ID별 (SHIP_REQ_PACK_TOTAL) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                           AS TO_SITE
             , '-'                           AS PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , '-'                           AS FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , '-'                           AS PROD_LINE
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , 'SHIP_REQ_PACK_TOTAL'         AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV             = 'C'
           AND B.GUBUN           = 'ITEM_ID'
           AND A.MEASURE         = 'SHIP_REQ_PACK_TOTAL'
           AND A.OPERATION_GROUP = 'P';

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : ITEM_ID별 (SHIP_REQ_PACK_TOTAL) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
-- -- 단위처리시간 추출 --
--print N'position_8 #PSI_GLOBAL_ESS temp 에 SHIP_REQ_PACK_TOTAL 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , '-'                           AS PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE
             , A.PROD_LINE
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV     = 'C'
           AND B.GUBUN   = 'TO'
           AND A.MEASURE = 'MKT_FCST';

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
-- -- 단위처리시간 추출 --
--print N'position_9 #PSI_GLOBAL_ESS temp 에 ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , (CASE WHEN B.COLUMN_NAME IN ('PACK_SHIP_PLAN_TOTAL', 'CELL_SHIP_PLAN_TOTAL') THEN '-'
                     ELSE A.TO_SITE
                END)                         AS TO_SITE
             , (CASE WHEN B.COLUMN_NAME = 'SHIP_PLAN'    THEN A.PROJECT_CODE
                     WHEN B.COLUMN_NAME = 'SHIP_REQ'     THEN A.PROJECT_CODE
                     WHEN B.COLUMN_NAME = 'PLAN_REQ_GAP' THEN A.PROJECT_CODE
                     ELSE '-'
                END)                         AS PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , (CASE WHEN B.COLUMN_NAME IN ('PACK_SHIP_PLAN_TOTAL', 'CELL_SHIP_PLAN_TOTAL') THEN '-'
                     ELSE A.INCOTERMS
                END)                         AS INCOTERMS
             , A.FROM_SITE
             , (CASE WHEN B.COLUMN_NAME = 'SHIP_PLAN' THEN A.TRANSPORT_MODE
                     WHEN B.COLUMN_NAME = 'SHIP_REQ'  THEN A.TRANSPORT_MODE
                     /* --WHEN M.COLUMN_NAME   = 'PLAN_REQ_GAP' THEN X.PROJECT_CODE */
                     ELSE '-'
                END)                         AS TRANSPORT_MODE
             , A.PROD_LINE
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , (CASE WHEN B.COLUMN_NAME = 'SHIP_PLAN' THEN A.BOD_ID
                     WHEN B.COLUMN_NAME = 'SHIP_REQ'  THEN A.BOD_ID
                     ELSE '-'
                END)                         AS BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV     = 'C'
           AND B.GUBUN   = 'FROM'
           AND A.MEASURE = 'SHIP_PLAN';

        /* IF @P_IS_DEBUG = 1  SELECT '961' AS  #PSI_GLOBAL_ESS , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
-- -- 단위처리시간 추출 --
--print N'position_10 #PSI_GLOBAL_ESS temp 에 WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , (CASE WHEN B.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH') THEN A.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
             , (CASE WHEN B.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH') THEN '-' ELSE A.PROD_LINE END)      AS PROD_LINE
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , (CASE WHEN B.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH') THEN A.BOD_ID ELSE '-' END)         AS BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV             = 'P'
           AND B.GUBUN           = 'FROM'
           AND A.MEASURE         = 'PACK_PROD'
           AND A.OPERATION_GROUP = 'P';

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH)  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
             --IF OBJECT_ID('tempdb##MEASURE')        IS NOT NULL
                       -- DROP TABLE ##MEASURE
             --   SELECT * INTO ##MEASURE  FROM #MEASURE WITH (NOLOCK)

             --IF OBJECT_ID('tempdb##ITEM_ID')        IS NOT NULL
                       -- DROP TABLE ##ITEM_ID
             --   SELECT * INTO ##ITEM_ID  FROM #ITEM_ID WITH (NOLOCK)

             -- RETURN;

-- -- 단위처리시간 추출 --
--print N'position_11 #PSI_GLOBAL_ESS temp 에 PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- start */
        /* 생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가 :: KSW / 2020.08.20 */
        /* 전 처리에서 생성된 ITEM_ID 에 대한 PACK BOH/EOH 이외에 SCP_XLS_BOH 에 존재하는 재고정보가 표시되도록 보완 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* AS-IS NOT ITEM_ID + '|' + SCM_SITE_ID IN (...) / NOT ITEM_ID IN (SELECT CELL_ITEM_ID ...) → NOT EXISTS */
        /*   (AS-IS 비교 대상 FROM_SITE·CELL_ITEM_ID 는 NULL 이 없고 CELL_ITEM_ID 는 '' → Oracle NULL 이므로 NOT IN 을 쓰면 0행이 됨) */
        /* AS-IS ISNULL(ORIGIN_ITEM_ID,'') = '' → ORIGIN_ITEM_ID IS NULL */
        /* AS-IS INCOTERMS = '' → INCOTERMS = '-' (TO-BE SCP_XLS_BOH 적재 시 빈 값을 '-' 로 채움 - PR_SCP_XLS_BOH NVL(INCOTERMS,'-')) */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , '-'                           AS TO_SITE
             , '-'                           AS PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , IA.FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , '-'                           AS PROD_LINE
             , A.COLUMN_NAME                 AS MEASURE
             , IA.YYYYMMDD
             , (CASE WHEN A.COLUMN_NAME = 'PACK_BOH' THEN IA.QTY ELSE 0 END) AS QTY   /* --0                         AS QTY */
             , A.SORT_ORDER_NO
             , A.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , 'SCP_ANL_PRODUCTION_PLAN'     AS ATTRIBUTE1
               /* --, X.FROM_SITE               AS ATTRIBUTE9 */
             , (CASE WHEN INSTR(IA.FROM_SITE, '-') > 0 THEN SUBSTR(IA.FROM_SITE, 1, INSTR(IA.FROM_SITE, '-') - 1) ELSE IA.FROM_SITE END) AS ATTRIBUTE9
          FROM (SELECT XA.DIVISION_ID
                     , B.OPERATION_GROUP
                     , B.CELL_LIST                   AS CELL_ITEM_ID
                     , XA.SCM_SITE_ID                AS FROM_SITE
                     , XA.ITEM_ID
                     , XA.QTY
                     , XA.PLAN_START_YYYYMMDD        AS YYYYMMDD
                     , '-'                           AS TRANSPORT_MODE
                  FROM (SELECT C.DIVISION_ID
                             , C.PLAN_START_YYYYMMDD
                             , C.PLAN_TYPE
                             , C.SEQ
                             , C.SCM_SITE_ID
                             , C.INCOTERMS
                             , C.ITEM_ID
                             , SUM(C.QTY)            AS QTY
                          FROM SCP_XLS_BOH C
                         WHERE NOT EXISTS (SELECT 1
                                             FROM GT_XESS_PSI_GLOBAL_ESS D
                                            WHERE D.ITEM_ID   = C.ITEM_ID
                                              AND D.FROM_SITE = C.SCM_SITE_ID
                                              AND D.MEASURE   = 'PACK_BOH')
                           AND NOT EXISTS (SELECT 1
                                             FROM GT_XESS_PSI_GLOBAL_ESS E
                                            WHERE E.CELL_ITEM_ID = C.ITEM_ID
                                              AND E.MEASURE      = 'PACK_BOH')
                           AND C.ORIGIN_ITEM_ID     IS NULL
                           AND C.INCOTERMS           = '-'
                           AND C.DIVISION_ID         = V_DIVISION_ID
                           AND C.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                           AND C.PLAN_TYPE           = V_PLAN_TYPE
                           AND C.SEQ                 = N_SEQ
                         GROUP BY C.DIVISION_ID
                                , C.PLAN_START_YYYYMMDD
                                , C.PLAN_TYPE
                                , C.SEQ
                                , C.SCM_SITE_ID
                                , C.INCOTERMS
                                , C.ITEM_ID) XA
                     , SCP_MST_FINAL_ITEM_V B
                 WHERE B.ITEM_ID         = XA.ITEM_ID
                   AND B.OPERATION_GROUP = 'P') IA
             , GT_XESS_MEASURE A             /* CROSS APPLY #MEASURE */
         WHERE A.DIV          = 'P'
           AND A.GUBUN        = 'FROM'
           AND A.COLUMN_NAME IN ('PACK_BOH', 'PACK_EOH');

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가 :: KSW / 2020.08.20 */
        /* ----------------------------------------------------------------------------------------------------------- end */

/*
-- -- 단위처리시간 추출 --
--print N'position_12 #PSI_GLOBAL_ESS temp 에 PACK_BOH, PACK_EOH 재고정보 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL) */
        /* MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , (CASE WHEN B.COLUMN_NAME = 'SEMI_SHIP_PLAN' THEN A.TRANSPORT_MODE
                     WHEN B.COLUMN_NAME = 'SEMI_SHIP_REQ'  THEN A.TRANSPORT_MODE
                     ELSE '-'
                END)                         AS TRANSPORT_MODE
             , A.PROD_LINE
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , (CASE WHEN B.COLUMN_NAME = 'SEMI_SHIP_PLAN' THEN A.BOD_ID
                     WHEN B.COLUMN_NAME = 'SEMI_SHIP_REQ'  THEN A.BOD_ID
                     ELSE '-'
                END)                         AS BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV             = 'A'
           AND B.GUBUN           = 'FROM'
           AND B.COLUMN_NAME  LIKE 'SEMI%'
           AND A.MEASURE        IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_REQ')
           AND A.OPERATION_GROUP = 'A'
        /* SEMI_WHIN_TOTAL */
         UNION ALL
        SELECT DISTINCT
               C.DIVISION_ID
             , C.OPERATION_GROUP
             , C.CELL_ITEM_ID
             , C.ITEM_ID
             , C.TO_SITE
             , '-'                           AS PROJECT_CODE
             , C.TO_BOH_QTY
             , C.FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , '-'                           AS FROM_SITE
               /* --                              , (CASE M.COLUMN_NAME WHEN 'SEMI_PACK_PROD_CELL' THEN FROM_SITE ELSE '-' END) AS FROM_SITE */
             , '-'                           AS TRANSPORT_MODE
             , '-'                           AS PROD_LINE
             , D.COLUMN_NAME                 AS MEASURE
             , C.YYYYMMDD
             , 0                             AS QTY
             , D.SORT_ORDER_NO
             , D.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , C.ATTRIBUTE1
             , C.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID C
             , GT_XESS_MEASURE D             /* CROSS APPLY #MEASURE */
         WHERE D.DIV             = 'A'
           AND D.GUBUN           = 'TO'
           AND D.COLUMN_NAME  LIKE 'SEMI%'
           AND C.MEASURE        IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_REQ')
           AND C.OPERATION_GROUP = 'A';

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL)   ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* DC Link. 적용 : Pack 영역에서 Semi 관련 measure 가 표시되도록 추가한다. (DC link 만) */
        /* MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) */
        /* 2021.12.22   KSW         DC link. Pack Semi 계획에 관련 measure 생성로직 추가 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2025.09.02   kimcd   속도 개선 HASH 추가 : INNER HASH JOIN (MSSQL 조인 힌트 - 일반 내부조인으로 전환) */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , (CASE WHEN A.COLUMN_NAME = 'SEMI_SHIP_PLAN' THEN IA.TRANSPORT_MODE
                     WHEN A.COLUMN_NAME = 'SEMI_SHIP_REQ'  THEN IA.TRANSPORT_MODE
                     ELSE '-'
                END)                         AS TRANSPORT_MODE
             , IA.PROD_LINE
             , A.COLUMN_NAME                 AS MEASURE
             , IA.YYYYMMDD
             , 0                             AS QTY
             , A.SORT_ORDER_NO
             , A.COLUMN_LABEL_NAME
             , (CASE WHEN A.COLUMN_NAME = 'SEMI_SHIP_PLAN' THEN IA.BOD_ID
                     WHEN A.COLUMN_NAME = 'SEMI_SHIP_REQ'  THEN IA.BOD_ID
                     ELSE '-'
                END)                         AS BOD_ID
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       B.DIVISION_ID, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.TO_SITE, B.PROJECT_CODE, B.TO_BOH_QTY, B.FROM_BOH_QTY
                     , B.INCOTERMS, B.FROM_SITE, B.TRANSPORT_MODE, B.PROD_LINE, B.MEASURE, B.YYYYMMDD, B.QTY, B.SORT_ORDER_NO
                     , B.COLUMN_LABEL_NAME, B.BOD_ID, B.ATTRIBUTE1, B.ATTRIBUTE9
                  FROM GT_XESS_ITEM_ID B
                     , (SELECT DISTINCT
                               C.MODEL_ID                AS ITEM_ID
                             , C.CHILD_ITEM_ID           AS CELL_ITEM_ID
                             , C.ACCUMULATED_CHILD_QTY   AS CELL_QTY_PACK
                             , SA.MODULE_ID
                             , SA.MODULE_QTY_PACK
                          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                             , (SELECT D.DIVISION_ID
                                     , D.MODEL_ID
                                     , D.CHILD_ITEM_ID   AS MODULE_ID
                                     , D.CHILD_QTY       AS MODULE_QTY_PACK
                                  FROM SCM_MST_BOM_SN_V D                  /* --2021-03-09    SCP 대치 BOM 적용 */
                                     , SCM_MST_ITEM_SN  E
                                 WHERE D.CHILD_DIVISION_ID = E.DIVISION_ID
                                   AND D.CHILD_ITEM_ID     = E.ITEM_ID
                                   /* --AND I.FLOW_ID = 'P5200' */
                                   AND D.CHILD_COMPANY_ID  = E.COMPANY_ID  /* A002 빈강 추가 따른 조건 추가 */
                                   AND D.CHILD_SITE_ID     = E.SITE_ID
                                   AND E.ACTIVE_FLAG       = 'Y') SA
                         WHERE C.DIVISION_ID        = SA.DIVISION_ID
                           AND C.MODEL_ID           = SA.MODEL_ID
                           AND C.OPERATION_GROUP_ID = 'P') XA
                 WHERE B.ITEM_ID          = XA.CELL_ITEM_ID
                   AND XA.MODULE_ID      IN (SELECT DISTINCT F.ITEM_ID
                                               FROM SCM_MST_FINAL_ITEM_V F
                                              WHERE F.OPERATION_GROUP_ID = 'P'
                                                AND F.DC_YN              = 'Y'
                                                AND F.DIVISION_ID        = V_DIVISION_ID)
                   /* --AND Z.MODULE_ID = 'ETD1529A5A22'  --성능과부화 회피코드....delete DHJ 07/19/2023 */
                   AND B.ITEM_ID         <> XA.ITEM_ID
                   AND B.OPERATION_GROUP  = 'P'
                   AND B.MEASURE         IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_REQ')) IA
             , GT_XESS_MEASURE A             /* CROSS APPLY #MEASURE */
         WHERE A.DIV              = 'A'
           AND A.GUBUN            = 'FROM'
           AND A.COLUMN_NAME   LIKE 'SEMI%'
           AND IA.MEASURE        IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_REQ')
           AND IA.OPERATION_GROUP = 'P';     /* << Semi 는 'A' 이지만 DC link 는 'P' */

        /* IF @P_IS_DEBUG = 1 SELECT '1254_#ITEM_ID' AS  #ITEM_ID , * FROM #ITEM_ID  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN)    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN */
        /*                                 ,CELL_CHAR_AVAILABLE,CELL_FORM_PROGRESS,CELL_FORM_HOLD,CELL_FOR_FORM_END,CELL_PROD_FORM_END */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                           AS TO_SITE
             , '-'                           AS PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , A.FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , '-'                           AS PROD_LINE
               /* --                              , (CASE WHEN M.COLUMN_NAME ='CELL_TACT_TIME' THEN PROD_LINE ELSE  '-' END ) AS PROD_LINE */
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV              = 'A'
           AND B.GUBUN            = 'FROM'
           AND B.COLUMN_NAME   LIKE 'CELL%'
           AND A.MEASURE          = 'CELL_CHAR_PLAN'
           AND A.OPERATION_GROUP  = 'A'
           AND B.COLUMN_NAME NOT IN ('CELL_PROD', 'CELL_PROD_LOAD', 'CELL_TACT_TIME', 'CELL_WORKING_TIME');

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_14 #PSI_GLOBAL_ESS temp 에 CELL  measure 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* IF @P_IS_DEBUG = 1 SELECT '1303' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                           AS TO_SITE
             , '-'                           AS PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , A.FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , A.PROD_LINE
             , B.COLUMN_NAME                 AS MEASURE
             , A.YYYYMMDD
             , 0                             AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , (CASE WHEN B.COLUMN_NAME = 'CELL_TACT_TIME' THEN 'X' ELSE A.ATTRIBUTE1 END) AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_ITEM_ID A
             , GT_XESS_MEASURE B             /* CROSS APPLY #MEASURE */
         WHERE B.DIV             = 'A'
           AND B.GUBUN           = 'FROM'
           AND A.OPERATION_GROUP = 'A'
           AND B.COLUMN_NAME    IN ('CELL_PROD', 'CELL_PROD_LOAD', 'CELL_TACT_TIME')
           AND A.PROD_LINE      <> '-';

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD)    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_15 #PSI_GLOBAL_ESS temp 에 CELL_PROD,CELL_PROD_LOAD  measure 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* 튜닝 -- PR_SCP_XLS_PSI_GLOBAL_ESS_S 에서 이동 */
        /* #tmp_SCP_MST_TACT_TIME → 하위와 공유하는 GT_SCXL_TACT_TIME_TMP (TACT_TIME 칸은 본·하위 모두 미사용이라 GTT 에 없음) */
        DELETE FROM GT_SCXL_TACT_TIME_TMP;

        INSERT
          INTO GT_SCXL_TACT_TIME_TMP
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , YIELD
             )
        SELECT IA.DIVISION_ID
             , IA.PLANT_SITE_ID
             , IA.ITEM_ID
             , IA.OPERATION_ID
             , IA.LINE_ID
             , IA.YIELD
          FROM (SELECT A.DIVISION_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.YIELD, A.TACT_TIME
                  FROM SCP_MST_TACT_TIME A
                 WHERE A.DIVISION_ID = V_DIVISION_ID
                 /* -- AND OPERATION_ID IN ('P9500','P5500') */
                 UNION ALL
                SELECT B.DIVISION_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.OPERATION_ID, B.LINE_ID, B.YIELD, B.TACT_TIME
                  FROM SCP_MST_TACT_TIME_OSP B
                 WHERE B.DIVISION_ID = V_DIVISION_ID
                 /* -- AND OPERATION_ID IN ('P9500','P5500') */
               ) IA;

        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT A.DIVISION_ID
             , SUBSTR(A.PLANT_SITE_ID, -1, 1)    AS OPERATION_GROUP   /* RIGHT(PLANT_SITE_ID, 1) */
             , NULL                              AS CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                               AS TO_SITE
             , '-'                               AS PROJECT_CODE
             , 0                                 AS TO_BOH_QTY
             , 0                                 AS FROM_BOH_QTY
             , '-'                               AS INCOTERMS
             , A.PLANT_SITE_ID                   AS FROM_SITE
             , '-'                               AS TRANSPORT_MODE
             , A.LINE_ID                         AS PROD_LINE
             , B.COLUMN_NAME                     AS MEASURE
             , V_PLAN_START_YYYYMMDD             AS YYYYMMDD
             , 0                                 AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , '-'                               AS BOD_ID
             , 'SCP_ANL_PRODUCTION_PLAN'         AS ATTRIBUTE1
             , A.OPERATION_ID                    AS ATTRIBUTE9
          FROM GT_SCXL_TACT_TIME_TMP A
             , GT_XESS_MEASURE       B
         WHERE SUBSTR(A.PLANT_SITE_ID, -1, 1) = 'P'
           AND B.COLUMN_NAME IN ('PACK_WORKING_TIME', 'PACK_DIO', 'PACK_PROD_LOAD_TOTAL', 'PACK_PROD_TOTAL', 'PACK_TACT_TIME', 'CELL_TACT_TIME');

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_15_1 #PSI_GLOBAL_ESS temp 에 TECT TIME에 의한 생산 LINE 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                               AS TO_SITE
             , '-'                               AS PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , '-'                               AS INCOTERMS
             , A.FROM_SITE
             , '-'                               AS TRANSPORT_MODE
             , A.PROD_LINE
             , A.MEASURE
             , B.YYYYMMDD
             , B.TACT_TIME                       AS QTY
             , A.SORT_ORDER_NO
             , A.COLUMN_LABEL_NAME
             , '-'                               AS BOD_ID
             , 'O'                               AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_PSI_GLOBAL_ESS A
             , SCP_ANL_TACT_TIME      B
         WHERE A.DIVISION_ID  = B.DIVISION_ID
           AND A.ATTRIBUTE9   = B.OPERATION_ID
           AND A.FROM_SITE    = B.SCM_SITE_ID
           AND A.PROD_LINE    = B.LINE_ID
           AND A.ITEM_ID      = B.ITEM_ID
           /* --AND A.YYYYMMDD       = E.YYYYMMDD */
           AND A.YYYYMMDD    <= B.YYYYMMDD
           AND A.MEASURE      = 'CELL_TACT_TIME'
           AND B.YYYYMMDD    >= V_PLAN_START_YYYYMMDD
           AND B.YYYYMMDD     < V_TO_YYYYMMDD;
           /* --AND E.YYYYMMDD           <=  @p_to_yyyymmdd   --말일포함(KSK, 20240814, 운영배포보류) */

/*
                     --IF OBJECT_ID('tempdb..##PSI_GLOBAL') IS NOT NULL
                            --DROP TABLE ##PSI_GLOBAL

                     --SELECT * INTO ##PSI_GLOBAL FROM #PSI_GLOBAL WITH (NOLOCK)

                     --IF OBJECT_ID('tempdb..##PSI_GLOBAL_ESS') IS NOT NULL
                            --DROP TABLE ##PSI_GLOBAL_ESS

                     --SELECT * INTO ##PSI_GLOBAL_ESS  FROM #PSI_GLOBAL_ESS WITH (NOLOCK)
                     --return;

---- 단위처리시간 추출 --
--print N'position_15-2 #PSI_GLOBAL_ESS temp 에 CELL_TACT_TIME update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  CELL_TACT_TIME    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* MEASURE 0 추가 : */
        /* ----------------------------------------------------------------------------------------------------------- */
/*
                --INSERT #PSI_GLOBAL_ESS
                --SELECT  DIVISION_ID
                --       ,OPERATION_GROUP
                --       ,CELL_ITEM_ID
                --       ,ITEM_ID
                --       ,TO_SITE
                --       ,PROJECT_CODE
                --       ,TO_BOH_QTY
                --       ,FROM_BOH_QTY
                --       ,INCOTERMS
                --       ,FROM_SITE
                --       ,TRANSPORT_MODE
                --       ,PROD_LINE
                --       ,MEASURE
                --       , Y.YYYYMMDD
                --       ,'0' AS QTY
                --       ,SORT_ORDER_NO
                --       ,COLUMN_LABEL_NAME
                --       ,BOD_ID
                --       ,ATTRIBUTE1
                --       ,ATTRIBUTE9
                -- FROM #PSI_GLOBAL_ESS X WITH (NOLOCK)
                -- CROSS APPLY
                -- (  -- 364 DAYS
                --       SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                --        FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)
                --       WHERE 1=1
                --       AND C.BASIS_YYYYMMDD > @p_plan_start_yyyymmdd       -- 엔진시작일 제외
                --       AND C.BASIS_YYYYMMDD <  @p_to_yyyymmdd
                --  ) Y
                --WHERE 0 = 0
*/

        /* 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장 */
        DELETE FROM GT_XESS_TMP_PSI_GLOBAL_ESS;

        /* 0 값을 플랜시작일자만 추가한다. - 모든 item 의 모든 measure */
        INSERT
          INTO GT_XESS_TMP_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE
             , IA.PROD_LINE
             , IA.MEASURE
             , XA.YYYYMMDD
             , 0                                 AS QTY             /* '0' AS QTY */
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , IA.BOD_ID
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       A.DIVISION_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, A.ITEM_ID, A.TO_SITE, A.PROJECT_CODE, A.TO_BOH_QTY, A.FROM_BOH_QTY
                     , A.INCOTERMS, A.FROM_SITE, A.TRANSPORT_MODE, A.PROD_LINE, A.MEASURE, A.SORT_ORDER_NO, A.COLUMN_LABEL_NAME
                     , A.BOD_ID, A.ATTRIBUTE1, A.ATTRIBUTE9
                  FROM GT_XESS_PSI_GLOBAL_ESS A) IA
             , (SELECT DISTINCT SA.YYYYMMDD                                                         /* CROSS APPLY -- 364 DAYS */
                  FROM (/* --SELECT YYYYMMDD FROM #PSI_GLOBAL    C WITH(NOLOCK) UNION ALL */
                        SELECT V_PLAN_START_YYYYMMDD                                         AS YYYYMMDD
                          FROM DUAL
                         UNION ALL
                        SELECT TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD') AS YYYYMMDD
                          FROM DUAL) SA) XA;

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '1592' AS  #tmp_PSI_GLOBAL_ESS , * FROM #tmp_PSI_GLOBAL_ESS  END  (디버그 결과셋) */

        /* 0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_ESS 으로 복제 */
        DELETE FROM GT_XESS_PSI_GLOBAL_ESS;

        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
          FROM GT_XESS_TMP_PSI_GLOBAL_ESS;

        /* IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_ESS') IS NOT NULL DROP TABLE #tmp_PSI_GLOBAL_ESS; */
        DELETE FROM GT_XESS_TMP_PSI_GLOBAL_ESS;

        /* --SELECT  '#ESS_#TMP' TN, * FROM  #PSI_GLOBAL_ESS ;RETURN -1   --TEST */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_ESS 으로 복제    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_16 #PSI_GLOBAL_ESS temp 에 0 값 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

                 -- MKT_FCST
--                UPDATE X
--                SET X.QTY = Y.QTY
--                FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
--                INNER JOIN
--                (SELECT ITEM_ID, TO_SITE, MEASURE, INCOTERMS, YYYYMMDD, SUM(QTY) AS QTY
--                  FROM #ANL_SHIPMENT_PLAN_FG   WITH (NOLOCK)
--                  GROUP BY ITEM_ID,TO_SITE, MEASURE, INCOTERMS,YYYYMMDD
--                 ) Y
--                ON 0 = 0
--                AND X.TO_SITE         = Y.TO_SITE
----                AND X.FROM_SITE       = Y.FROM_SITE
--                AND X.MEASURE         = Y.MEASURE
--                AND X.ITEM_ID         = Y.ITEM_ID
--                AND X.YYYYMMDD        = Y.YYYYMMDD
--                AND X.INCOTERMS       = Y.INCOTERMS
----                AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
----                AND X.PROJECT_CODE    = Y.PROJECT_CODE
--                AND X.MEASURE         = 'MKT_FCST'
*/

        /* MKT_FCST (원문 MERGE 구조 그대로) */
        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , B.CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , '-'                    AS PROJECT_CODE    /* 중복방지 */
                    , B.TO_BOH_QTY
                    , B.FROM_BOH_QTY
                    , B.INCOTERMS
                    , B.FROM_SITE
                    , B.TRANSPORT_MODE
                    , B.PROD_LINE
                    , B.MEASURE
                    , B.YYYYMMDD
                    , SUM(B.QTY)             AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , B.BOD_ID
                    , B.ATTRIBUTE1
                    , B.ATTRIBUTE9
                 FROM GT_XESS_PSI_GLOBAL B                       /* #ANL_SHIPMENT_PLAN_FG */
                WHERE B.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
                  AND B.MEASURE    = 'MKT_FCST'
                GROUP BY B.DIVISION_ID, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.TO_SITE, B.TO_BOH_QTY, B.FROM_BOH_QTY
                       , B.INCOTERMS, B.FROM_SITE, B.TRANSPORT_MODE, B.PROD_LINE, B.MEASURE, B.YYYYMMDD, B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME, B.BOD_ID, B.ATTRIBUTE1, B.ATTRIBUTE9) XA
           ON (    A.OPERATION_GROUP = XA.OPERATION_GROUP
               AND A.ITEM_ID         = XA.ITEM_ID
               AND A.TO_SITE         = XA.TO_SITE
               AND A.PROJECT_CODE    = XA.PROJECT_CODE
               AND A.INCOTERMS       = XA.INCOTERMS
               AND A.MEASURE         = XA.MEASURE
               AND A.YYYYMMDD        = XA.YYYYMMDD)
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = XA.QTY
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  MKT_FCST    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_17 #PSI_GLOBAL_ESS temp 에 MKT_FCST update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

    --            UPDATE X
    --            SET X.QTY = Y.QTY
    --            FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
    --            INNER JOIN #ANL_SHIPMENT_PLAN_FG Y  WITH (NOLOCK)
    --            ON 0 = 0
    --            AND X.TO_SITE         = Y.TO_SITE
    --            AND X.FROM_SITE       = Y.FROM_SITE
    --            AND X.MEASURE         = Y.MEASURE
    --            AND X.ITEM_ID         = Y.ITEM_ID
    --            AND X.YYYYMMDD        = Y.YYYYMMDD
    --            AND X.INCOTERMS       = Y.INCOTERMS
    --            AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
    --            AND X.PROJECT_CODE    = Y.PROJECT_CODE
    --            AND X.MEASURE         IN ('SHIP_PLAN','SHIP_REQ')
                --AND X.BOD_ID          = Y.BOD_ID                  -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , B.CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , B.PROJECT_CODE                            /* 중복방지 */
                    , B.TO_BOH_QTY
                    , B.FROM_BOH_QTY
                    , B.INCOTERMS
                    , B.FROM_SITE
                    , B.TRANSPORT_MODE
                    , B.PROD_LINE
                    , B.MEASURE
                    , B.YYYYMMDD
                    , SUM(B.QTY)             AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , B.BOD_ID
                    , B.ATTRIBUTE1
                    , B.ATTRIBUTE9
                 FROM GT_XESS_PSI_GLOBAL B                       /* #ANL_SHIPMENT_PLAN_FG */
                WHERE B.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
                  AND B.MEASURE   IN ('SHIP_PLAN', 'SHIP_REQ')
                GROUP BY B.DIVISION_ID, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.TO_SITE, B.PROJECT_CODE, B.TO_BOH_QTY, B.FROM_BOH_QTY
                       , B.INCOTERMS, B.FROM_SITE, B.TRANSPORT_MODE, B.PROD_LINE, B.MEASURE, B.YYYYMMDD, B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME, B.BOD_ID, B.ATTRIBUTE1, B.ATTRIBUTE9) XA
           ON (    A.TO_SITE         = XA.TO_SITE
               AND A.FROM_SITE       = XA.FROM_SITE
               AND A.MEASURE         = XA.MEASURE
               AND A.ITEM_ID         = XA.ITEM_ID
               AND A.YYYYMMDD        = XA.YYYYMMDD
               AND A.INCOTERMS       = XA.INCOTERMS
               AND A.TRANSPORT_MODE  = XA.TRANSPORT_MODE
               AND A.PROJECT_CODE    = XA.PROJECT_CODE
               AND A.BOD_ID          = XA.BOD_ID)               /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = XA.QTY
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        /* IF @P_IS_DEBUG = 1  SELECT '1853_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  SHIP_PLAN ,  SHIP_REQ    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_18 #PSI_GLOBAL_ESS temp 에 SHIP_PLAN, SHIP_REQ update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

                -- PACK_PROD
--                UPDATE X
--                SET X.QTY = Y.QTY
--                FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
--                INNER JOIN #ANL_PRODUCTION_PLAN Y  WITH (NOLOCK)
--                ON 0 = 0
--                AND X.TO_SITE   = Y.TO_SITE
--                AND X.FROM_SITE = Y.FROM_SITE
--                AND X.MEASURE   = Y.MEASURE
--                AND X.YYYYMMDD  = Y.YYYYMMDD
--                AND X.ITEM_ID   = Y.ITEM_ID
--                AND X.PROD_LINE = Y.PROD_LINE
----                AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , B.CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , B.PROJECT_CODE
                    , B.TO_BOH_QTY
                    , B.FROM_BOH_QTY
                    , B.INCOTERMS
                    , B.FROM_SITE
                    , B.TRANSPORT_MODE
                    , B.PROD_LINE
                    , B.MEASURE
                    , B.YYYYMMDD
                    , SUM(B.QTY)             AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , B.BOD_ID
                    , B.ATTRIBUTE1
                    , B.ATTRIBUTE9
                 FROM GT_XESS_PSI_GLOBAL B                       /* #ANL_PRODUCTION_PLAN */
                WHERE B.ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'
                GROUP BY B.DIVISION_ID, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.TO_SITE, B.PROJECT_CODE, B.TO_BOH_QTY, B.FROM_BOH_QTY
                       , B.INCOTERMS, B.FROM_SITE, B.TRANSPORT_MODE, B.PROD_LINE, B.MEASURE, B.YYYYMMDD, B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME, B.BOD_ID, B.ATTRIBUTE1, B.ATTRIBUTE9) XA
           ON (    A.OPERATION_GROUP = XA.OPERATION_GROUP
               AND A.ITEM_ID         = XA.ITEM_ID
               AND A.TO_SITE         = XA.TO_SITE
               AND A.FROM_SITE       = XA.FROM_SITE
               AND A.MEASURE         = XA.MEASURE
               AND A.YYYYMMDD        = XA.YYYYMMDD
               AND A.PROD_LINE       = XA.PROD_LINE)
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = XA.QTY
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        /* IF @P_IS_DEBUG = 1  SELECT '1978_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from #ANL_PRODUCTION_PLAN    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_19 #PSI_GLOBAL_ESS temp 에 PACK_PROD update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

              -- SEMI_SHIP_PLAN
    --            UPDATE X
    --            SET X.QTY = Y.QTY
    --            FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
    --            INNER JOIN #ANL_SHIPMENT_PLAN_SEMI Y  WITH (NOLOCK)
    --            ON 0 = 0
    --            AND X.TO_SITE   = Y.TO_SITE
    --            AND X.FROM_SITE = Y.FROM_SITE
    --            AND X.MEASURE   = Y.MEASURE
    --            AND X.YYYYMMDD  = Y.YYYYMMDD
    --            AND X.ITEM_ID   = Y.ITEM_ID
    --            AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
                --AND X.BOD_ID          = Y.BOD_ID                  -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , B.CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , B.PROJECT_CODE
                    , B.TO_BOH_QTY
                    , B.FROM_BOH_QTY
                    , B.INCOTERMS
                    , B.FROM_SITE
                    , B.TRANSPORT_MODE
                    , B.PROD_LINE
                    , B.MEASURE
                    , B.YYYYMMDD
                    , SUM(B.QTY)             AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , B.BOD_ID
                    , B.ATTRIBUTE1
                    , B.ATTRIBUTE9
                 FROM GT_XESS_PSI_GLOBAL B                       /* #ANL_SHIPMENT_PLAN_SEMI */
                WHERE B.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                GROUP BY B.DIVISION_ID, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.TO_SITE, B.PROJECT_CODE, B.TO_BOH_QTY, B.FROM_BOH_QTY
                       , B.INCOTERMS, B.FROM_SITE, B.TRANSPORT_MODE, B.PROD_LINE, B.MEASURE, B.YYYYMMDD, B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME, B.BOD_ID, B.ATTRIBUTE1, B.ATTRIBUTE9) XA
           ON (    A.OPERATION_GROUP = XA.OPERATION_GROUP
               AND A.ITEM_ID         = XA.ITEM_ID
               AND A.TO_SITE         = XA.TO_SITE
               AND A.FROM_SITE       = XA.FROM_SITE
               AND A.MEASURE         = XA.MEASURE
               AND A.YYYYMMDD        = XA.YYYYMMDD
               AND A.TRANSPORT_MODE  = XA.TRANSPORT_MODE
               AND A.BOD_ID          = XA.BOD_ID)
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = XA.QTY
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        /* IF @P_IS_DEBUG = 1  SELECT '2101_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from #ANL_SHIPMENT_PLAN_SEMI    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_20 #PSI_GLOBAL_ESS temp 에 SEMI_SHIP_PLAN update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

                -- PRODUCTION
                --UPDATE X
                --SET X.QTY = Y.QTY
                --FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                --INNER JOIN #SCP_PLN_PRODUCTION_PLAN Y  WITH (NOLOCK)
                --ON 0 = 0
                --AND X.TO_SITE   = Y.TO_SITE
                --AND X.FROM_SITE = Y.FROM_SITE
                --AND X.MEASURE   = Y.MEASURE
                --AND X.YYYYMMDD  = Y.YYYYMMDD
                --AND X.ITEM_ID   = Y.ITEM_ID
                --AND X.PROD_LINE = Y.PROD_LINE
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , B.CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , B.PROJECT_CODE
                    , B.TO_BOH_QTY
                    , B.FROM_BOH_QTY
                    , B.INCOTERMS
                    , B.FROM_SITE
                    , B.TRANSPORT_MODE
                    , B.PROD_LINE
                    , B.MEASURE
                    , B.YYYYMMDD
                    , SUM(B.QTY)             AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , B.BOD_ID
                    , B.ATTRIBUTE1
                    , B.ATTRIBUTE9
                 FROM GT_XESS_PSI_GLOBAL B                       /* #SCP_PLN_PRODUCTION_PLAN */
                WHERE B.ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
                GROUP BY B.DIVISION_ID, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.TO_SITE, B.PROJECT_CODE, B.TO_BOH_QTY, B.FROM_BOH_QTY
                       , B.INCOTERMS, B.FROM_SITE, B.TRANSPORT_MODE, B.PROD_LINE, B.MEASURE, B.YYYYMMDD, B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME, B.BOD_ID, B.ATTRIBUTE1, B.ATTRIBUTE9) XA
           ON (    A.OPERATION_GROUP = XA.OPERATION_GROUP
               AND A.ITEM_ID         = XA.ITEM_ID
               AND A.TO_SITE         = XA.TO_SITE
               AND A.FROM_SITE       = XA.FROM_SITE
               AND A.MEASURE         = XA.MEASURE
               AND A.YYYYMMDD        = XA.YYYYMMDD
               AND A.PROD_LINE       = XA.PROD_LINE)
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = XA.QTY
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        /* IF @P_IS_DEBUG = 1  SELECT '2226_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from #SCP_PLN_PRODUCTION_PLAN    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_21 #PSI_GLOBAL_ESS temp 에 PRODUCTION update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* INTRANSIT 반영 */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_XESS_INTRANSIT;

        INSERT
          INTO GT_XESS_INTRANSIT
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , FROM_SITE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.SEQ
             , IA.OPERATION_GROUP
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.FROM_SITE
               /* --,MEASURE */
             , IA.YYYYMMDD
             , SUM(IA.QTY)                   AS QTY
             , IA.ATTRIBUTE1
          FROM (SELECT V_DIVISION_ID                                                     AS DIVISION_ID
                     , V_PLAN_START_YYYYMMDD                                             AS PLAN_START_YYYYMMDD
                     , V_PLAN_TYPE                                                       AS PLAN_TYPE
                     , V_SEQ                                                             AS SEQ
                     , B.OPERATION_GROUP
                     , A.ITEM_ID
                     , SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0) - 1)     AS TO_SITE
                     , SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0) + 2, 100)    AS FROM_SITE
                     , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')                             AS YYYYMMDD
                     , A.QTY                                                             AS QTY
                     , 'TH_ENG_STOCK_PLAN_SN'                                            AS ATTRIBUTE1
                  FROM TH_ENG_STOCK_PLAN_SN  A
                     , SCP_MST_FINAL_ITEM_V  B
                 WHERE A.ITEM_ID   = B.ITEM_ID
                   AND A.DESCR     = 'INT'
                   AND A.MASTER_ID = V_MASTER_ID
                   AND A.PLAN_ID   = V_ENGINE_PLAN_ID) IA
         GROUP BY IA.DIVISION_ID
                , IA.PLAN_START_YYYYMMDD
                , IA.PLAN_TYPE
                , IA.SEQ
                , IA.OPERATION_GROUP
                , IA.ITEM_ID
                , IA.TO_SITE
                , IA.FROM_SITE
                  /* --,MEASURE */
                , IA.YYYYMMDD
                , IA.ATTRIBUTE1;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## into #INTRANSIT ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  into #INTRANSIT    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
                 -- SEMI_INTRANSIT_ETA  --> SEMI_INTRANSIT,
                 -- INTRANSIT_ETA       --> INTRANSIT

                 --UPDATE X
                 --   SET X.QTY = ISNULL(Y.QTY,0)
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                 --     ON X.ITEM_ID    = Y.ITEM_ID
                 --    AND X.TO_SITE    = Y.TO_SITE
                 --    AND X.FROM_SITE  = Y.FROM_SITE
                 --    AND X.YYYYMMDD   = Y.YYYYMMDD
                 --    AND X.MEASURE    = 'INTRANSIT_ETA'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , NULL                       AS CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , '-'                        AS PROJECT_CODE
                    , 0                          AS TO_BOH_QTY
                    , 0                          AS FROM_BOH_QTY
                      /* --,A.INCOTERMS */
                    , B.FROM_SITE
                    , '-'                        AS TRANSPORT_MODE
                    , '-'                        AS PROD_LINE
                    , 'INTRANSIT_ETA'            AS MEASURE
                    , B.YYYYMMDD
                    , SUM(B.QTY)                 AS QTY
                    , C.SORT_ORDER_NO
                    , C.COLUMN_LABEL_NAME
                    , '-'                        AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
                 FROM GT_XESS_INTRANSIT B
                    , GT_XESS_MEASURE   C
                WHERE C.COLUMN_NAME = 'INTRANSIT_ETA'
                GROUP BY B.DIVISION_ID
                       , B.OPERATION_GROUP
                       , B.ITEM_ID
                       , B.TO_SITE
                         /* --,A.INCOTERMS */
                       , B.FROM_SITE
                       , B.YYYYMMDD
                       , C.SORT_ORDER_NO
                       , C.COLUMN_LABEL_NAME) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
                   /* --AND X.INCOTERMS  = Y.INCOTERMS */
               AND A.TO_SITE    = XA.TO_SITE
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.YYYYMMDD   = XA.YYYYMMDD
               AND A.MEASURE    = 'INTRANSIT_ETA')
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = NVL(XA.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY
                       /* --,INCOTERMS */
                     , FROM_SITE, TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY
                       /* --,Y.INCOTERMS */
                     , XA.FROM_SITE, XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1 );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '2388_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  INTRANSIT_ETA    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , NULL                         AS CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , B.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'SEMI_INTRANSIT_ETA'         AS MEASURE
                    , B.YYYYMMDD
                    , SUM(B.QTY)                   AS QTY
                    , C.SORT_ORDER_NO
                    , C.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                 FROM GT_XESS_INTRANSIT B
                    , GT_XESS_MEASURE   C
                WHERE C.COLUMN_NAME = 'SEMI_INTRANSIT_ETA'
                GROUP BY B.DIVISION_ID
                       , B.OPERATION_GROUP
                       , B.ITEM_ID
                       , B.TO_SITE
                         /* --,A.INCOTERMS */
                       , B.FROM_SITE
                       , B.YYYYMMDD
                       , C.SORT_ORDER_NO
                       , C.COLUMN_LABEL_NAME) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.TO_SITE    = XA.TO_SITE
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.YYYYMMDD   = XA.YYYYMMDD
               AND A.MEASURE    = 'SEMI_INTRANSIT_ETA')
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = NVL(XA.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS
                     , FROM_SITE, TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS
                     , XA.FROM_SITE, XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1 );

        /* IF @P_IS_DEBUG = 1  SELECT '2476_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  SEMI_INTRANSIT_ETA    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , NULL                       AS CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , '-'                        AS PROJECT_CODE
                    , 0                          AS TO_BOH_QTY
                    , SUM(B.QTY)                 AS FROM_BOH_QTY
                      /* --,A.INCOTERMS */
                    , B.FROM_SITE
                    , '-'                        AS TRANSPORT_MODE
                    , '-'                        AS PROD_LINE
                    , 'INTRANSIT'                AS MEASURE
                    , 0                          AS QTY
                    , C.SORT_ORDER_NO
                    , C.COLUMN_LABEL_NAME
                    , '-'                        AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
                 FROM GT_XESS_INTRANSIT B
                    , GT_XESS_MEASURE   C
                WHERE C.COLUMN_NAME = 'INTRANSIT'
                GROUP BY B.DIVISION_ID
                       , B.OPERATION_GROUP
                       , B.ITEM_ID
                       , B.TO_SITE
                         /* --,A.INCOTERMS */
                       , B.FROM_SITE
                       , C.SORT_ORDER_NO
                       , C.COLUMN_LABEL_NAME) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
                   /* --AND X.INCOTERMS  = Y.INCOTERMS */
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.TO_SITE    = XA.TO_SITE
               AND A.MEASURE    = 'INTRANSIT')
         WHEN MATCHED THEN
              UPDATE
                 SET A.FROM_BOH_QTY = NVL(XA.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY
                       /* --,INCOTERMS */
                     , FROM_SITE, TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY
                       /* --,Y.INCOTERMS */
                     , XA.FROM_SITE, XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, V_PLAN_START_YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1 );

        /* IF @P_IS_DEBUG = 1  SELECT '2562_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  SCP_ANL_SHIPMENT_PLAN_FG INTRANSIT    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT B.DIVISION_ID
                    , B.OPERATION_GROUP
                    , NULL                         AS CELL_ITEM_ID
                    , B.ITEM_ID
                    , B.TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , SUM(B.QTY)                   AS FROM_BOH_QTY
                      /* --,'-'             AS INCOTERMS */
                    , B.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'SEMI_INTRANSIT'             AS MEASURE
                    , 0                            AS QTY
                    , C.SORT_ORDER_NO
                    , C.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                 FROM GT_XESS_INTRANSIT B
                    , GT_XESS_MEASURE   C
                WHERE C.COLUMN_NAME = 'SEMI_INTRANSIT'
                GROUP BY B.DIVISION_ID
                       , B.OPERATION_GROUP
                       , B.ITEM_ID
                       , B.TO_SITE
                         /* --,A.INCOTERMS */
                       , B.FROM_SITE
                       , C.SORT_ORDER_NO
                       , C.COLUMN_LABEL_NAME) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
                   /* --AND X.INCOTERMS  = Y.INCOTERMS */
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.TO_SITE    = XA.TO_SITE
               AND A.MEASURE    = 'SEMI_INTRANSIT')
         WHEN MATCHED THEN
              UPDATE
                 SET A.FROM_BOH_QTY = NVL(XA.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY
                       /* --,INCOTERMS */
                     , FROM_SITE, TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.CELL_ITEM_ID, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY
                       /* --,Y.INCOTERMS */
                     , XA.FROM_SITE, XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, V_PLAN_START_YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1 );

        /* IF @P_IS_DEBUG = 1  SELECT '2650_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  SCP_ANL_SHIPMENT_PLAN_SEMI SEMI_INTRANSIT    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* 20231114. SEMI_SHIP_PLAN이 없어 SEMI_WHIN이 누락되는 현상 발생. */
        /* SEMI_INTRANSIT_ETA가 있는 것에 한해서 강제로 생성함. */
        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE
             , A.PROD_LINE
             , 'SEMI_WHIN'                   AS MEASURE
             , V_PLAN_START_YYYYMMDD         AS YYYYMMDD
             , 0                             AS QTY
             , 320                           AS SORT_ORDER_NO
             , 'Semi WH In'                  AS COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI'  AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_PSI_GLOBAL_ESS A
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_XESS_PSI_GLOBAL_ESS B
                            WHERE A.ITEM_ID         = B.ITEM_ID
                              AND A.TO_SITE         = B.TO_SITE
                              AND A.INCOTERMS       = B.INCOTERMS
                              AND A.FROM_SITE       = B.FROM_SITE
                              AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                              AND B.OPERATION_GROUP = 'A'
                              AND B.MEASURE         = 'SEMI_WHIN'
                              AND B.DIVISION_ID     = V_DIVISION_ID)
           AND A.OPERATION_GROUP = 'A'
           AND A.MEASURE         = 'SEMI_INTRANSIT_ETA'
           AND A.DIVISION_ID     = V_DIVISION_ID;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  #PSI_GLOBAL_ESS Semi WH In    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_22 #PSI_GLOBAL_ESS temp 에 INTRANSIT update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* CELL_FOR_FORM_END */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_XESS_PLN_TH_ENG_STOCK_PLAN;

        INSERT
          INTO GT_XESS_PLN_TH_ENG_STOCK_PLAN
             ( DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             , DESCR
             )
        SELECT SUBSTR(MASTER_ID, 1, 2)                                                                    AS DIVISION_ID
               /* --,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE */
             , CASE WHEN INSTR(SITE_ID, '~') = 0 THEN SITE_ID ELSE SUBSTR(SITE_ID, 1, INSTR(SITE_ID, '~') - 1) END AS FROM_SITE   /* 2020-08-11 KSW ~ 없는 data 존재 */
             , ITEM_ID
             , TO_CHAR(RECEIVING_DTTM, 'YYYYMMDD')                                                        AS YYYYMMDD
             , SUM(NVL(QTY, 0))                                                                           AS QTY
             , DESCR
          FROM SCP_PLN_TH_ENG_STOCK_PLAN
         WHERE MASTER_ID = V_MASTER_ID
           AND PLAN_ID   = V_ENGINE_PLAN_ID
           /* --                  AND A.LOT_ID LIKE 'FOR%' */
         GROUP BY SUBSTR(MASTER_ID, 1, 2)
                  /* --,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1) */
                , CASE WHEN INSTR(SITE_ID, '~') = 0 THEN SITE_ID ELSE SUBSTR(SITE_ID, 1, INSTR(SITE_ID, '~') - 1) END   /* 2020-08-11 KSW ~ 없는 data 존재 */
                , ITEM_ID
                , TO_CHAR(RECEIVING_DTTM, 'YYYYMMDD')
                , DESCR;

        /* 하위 PR_SCP_XLS_PSI_GLOBAL_ESS_S 가 읽는 #PLN_TH_ENG_STOCK_PLAN 공유분 */
        DELETE FROM GT_SCXL_ENG_STOCK_PLAN;

        INSERT
          INTO GT_SCXL_ENG_STOCK_PLAN
             ( ITEM_ID
             , FROM_SITE
             , QTY
             , DESCR
             )
        SELECT ITEM_ID
             , FROM_SITE
             , QTY
             , DESCR
          FROM GT_XESS_PLN_TH_ENG_STOCK_PLAN;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## into #PLN_TH_ENG_STOCK_PLAN ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from SCP_PLN_TH_ENG_STOCK_PLAN Semi WH In    ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Z.QTY,0)
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID,FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                 --               FROM #PLN_TH_ENG_STOCK_PLAN Y WITH (NOLOCK)
                 --              WHERE DESCR LIKE 'FOR%'
                 --              GROUP BY ITEM_ID,FROM_SITE,YYYYMMDD
                 --             ) Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FOR_FORM_END'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                  AS DIVISION_ID
                    , 'A'                            AS OPERATION_GROUP
                    , IA.ITEM_ID
                    , '-'                            AS TO_SITE
                    , '-'                            AS PROJECT_CODE
                    , 0                              AS TO_BOH_QTY
                    , 0                              AS FROM_BOH_QTY
                    , '-'                            AS INCOTERMS
                    , IA.FROM_SITE
                    , '-'                            AS TRANSPORT_MODE
                    , '-'                            AS PROD_LINE
                    , 'CELL_FOR_FORM_END'            AS MEASURE
                    , IA.YYYYMMDD
                    , NVL(IA.QTY, 0)                 AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                            AS BOD_ID
                    , NULL                           AS ATTRIBUTE1      /* 중복방지 */
                    , NULL                           AS ATTRIBUTE9      /* 중복방지 */
                 FROM (SELECT C.ITEM_ID
                            , C.FROM_SITE
                            , C.YYYYMMDD
                            , SUM(C.QTY)             AS QTY
                         FROM GT_XESS_PLN_TH_ENG_STOCK_PLAN C
                        WHERE C.DESCR LIKE 'FOR%'
                        GROUP BY C.ITEM_ID
                               , C.FROM_SITE
                               , C.YYYYMMDD) IA
                    , GT_XESS_MEASURE B
                WHERE B.COLUMN_NAME = 'CELL_FOR_FORM_END') XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.YYYYMMDD   = XA.YYYYMMDD
               AND A.MEASURE    = 'CELL_FOR_FORM_END')
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = NVL(XA.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        UPDATE GT_XESS_PSI_GLOBAL_ESS
           SET ATTRIBUTE1 = NULL   /* '' */
             , ATTRIBUTE9 = NULL   /* '' */
         WHERE MEASURE    = 'CELL_FOR_FORM_END';

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '2822_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into ##PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  measure CELL_FOR_FORM_END ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_23 #PSI_GLOBAL_ESS temp 에 CELL_FOR_FORM_END update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* CELL_FORM_PROGRESS */
        /* ----------------------------------------------------------------------------------------------------------- */
/*
--                 UPDATE X
--                    SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
--                   FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
--                   INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
--                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
--                                WHERE DESCR ='FOR'
----                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
--                                GROUP BY ITEM_ID, FROM_SITE
--                             )  Z
--                      ON X.ITEM_ID    = Z.ITEM_ID
--                     AND X.FROM_SITE  = Z.FROM_SITE
--                     AND X.MEASURE    = 'CELL_FORM_PROGRESS'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                  AS DIVISION_ID
                    , 'A'                            AS OPERATION_GROUP
                    , IA.ITEM_ID
                    , '-'                            AS TO_SITE
                    , '-'                            AS PROJECT_CODE
                    , 0                              AS TO_BOH_QTY
                    , IA.FROM_BOH_QTY
                    , '-'                            AS INCOTERMS
                    , IA.FROM_SITE
                    , '-'                            AS TRANSPORT_MODE
                    , '-'                            AS PROD_LINE
                    , 'CELL_FORM_PROGRESS'           AS MEASURE
                    , 0                              AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                            AS BOD_ID
                 FROM (SELECT C.ITEM_ID
                            , C.FROM_SITE
                            , SUM(C.QTY)             AS FROM_BOH_QTY
                         FROM GT_XESS_PLN_TH_ENG_STOCK_PLAN C
                        WHERE C.DESCR = 'FOR'
                          /* --                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd */
                        GROUP BY C.ITEM_ID
                               , C.FROM_SITE) IA
                    , GT_XESS_MEASURE B
                WHERE B.COLUMN_NAME = 'CELL_FORM_PROGRESS') XA
           /* 누락버그수정 :: 2023.07.02, KSK */
           ON (    A.DIVISION_ID = XA.DIVISION_ID
               AND A.ITEM_ID     = XA.ITEM_ID
               AND A.FROM_SITE   = XA.FROM_SITE
               AND A.MEASURE     = 'CELL_FORM_PROGRESS')
         WHEN MATCHED THEN
              UPDATE
                 SET A.FROM_BOH_QTY = NVL(XA.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, V_PLAN_START_YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID );

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  measure CELL_FORM_PROGRESS ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_24 #PSI_GLOBAL_ESS temp 에 CELL_FORM_PROGRESS update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* CELL_FORM_HOLD_UNDER 추가 */
        /* [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS) */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_XESS_STOCK_AGING;

        /* AS-IS : DATETIME 칸 비교의 'YYYYMMDD' 문자 인자는 날짜로 바꿔 비교 */
        INSERT
          INTO GT_XESS_STOCK_AGING
             ( FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             )
        SELECT SCM_SITE_ID                   AS FROM_SITE
             , ITEM_ID
             , (CASE WHEN UNHOLD_EXP_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                     ELSE TO_CHAR(UNHOLD_EXP_DATE, 'YYYYMMDD')
                END)                         AS YYYYMMDD
             , SUM(QTY)                      AS QTY
          FROM SCM_DNM_STOCK_AGING_V
         WHERE WIPHOLD_YN       = 'Y'
           AND UNHOLD_EXP_DATE IS NOT NULL
           AND CUTOFF_DATE      = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD')
         GROUP BY SCM_SITE_ID
                , ITEM_ID
                , (CASE WHEN UNHOLD_EXP_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                        ELSE TO_CHAR(UNHOLD_EXP_DATE, 'YYYYMMDD')
                   END);

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## into #tmp_SCM_DNM_STOCK_AGING_V ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  measure CELL_FORM_PROGRESS ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN #tmp_SCM_DNM_STOCK_AGING_V  Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                  AS DIVISION_ID
                    , 'A'                            AS OPERATION_GROUP
                    , B.ITEM_ID
                    , '-'                            AS TO_SITE
                    , '-'                            AS PROJECT_CODE
                    , 0                              AS TO_BOH_QTY
                    , 0                              AS FROM_BOH_QTY
                    , '-'                            AS INCOTERMS
                    , B.FROM_SITE
                    , '-'                            AS TRANSPORT_MODE
                    , '-'                            AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER'         AS MEASURE
                    , B.YYYYMMDD
                    , NVL(B.QTY, 0)                  AS QTY
                    , C.SORT_ORDER_NO
                    , C.COLUMN_LABEL_NAME
                    , '-'                            AS BOD_ID
                    , 'SCP_PLN_PRODUCTION_PLAN'      AS ATTRIBUTE1      /* 중복방지 */
                    , 'F6000'                        AS ATTRIBUTE9      /* 중복방지 */
                 FROM GT_XESS_STOCK_AGING B
                    , GT_XESS_MEASURE     C
                WHERE C.COLUMN_NAME = 'CELL_FORM_HOLD_UNDER'
                  AND B.FROM_SITE  IS NOT NULL) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.YYYYMMDD   = XA.YYYYMMDD
               AND A.MEASURE    = 'CELL_FORM_HOLD_UNDER')
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = NVL(XA.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3037_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* AS-IS 조건 그대로 : MEASURE = 'CELL_FORM_HOLD_UNDER' AND ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = '' */
        /*   (AND 가 OR 보다 먼저 묶임 → ATTRIBUTE9 가 빈 행은 MEASURE 와 무관하게 갱신) */
        UPDATE GT_XESS_PSI_GLOBAL_ESS
           SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
             , ATTRIBUTE9 = 'F6000'
         WHERE (    MEASURE    = 'CELL_FORM_HOLD_UNDER'
                AND ATTRIBUTE1 IS NULL)
            OR ATTRIBUTE9 IS NULL;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## into #PSI_GLOBAL_ESS  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from #tmp_SCM_DNM_STOCK_AGING_V ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
                  -- BOH


                 -- 보류중 해제일자가 없는수량
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='FOR_HOLD'
                  --              GROUP BY FROM_SITE, ITEM_ID
                  --           )  Z
                  --    ON X.ITEM_ID    = Z.ITEM_ID
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                  AS DIVISION_ID
                    , 'A'                            AS OPERATION_GROUP
                    , IA.ITEM_ID
                    , '-'                            AS TO_SITE
                    , '-'                            AS PROJECT_CODE
                    , 0                              AS TO_BOH_QTY
                    , IA.FROM_BOH_QTY
                    , '-'                            AS INCOTERMS
                    , IA.FROM_SITE
                    , '-'                            AS TRANSPORT_MODE
                    , '-'                            AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER'         AS MEASURE
                    , 0                              AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                            AS BOD_ID
                 FROM (SELECT C.FROM_SITE
                            , C.ITEM_ID
                            , SUM(C.QTY)             AS FROM_BOH_QTY
                         FROM GT_XESS_PLN_TH_ENG_STOCK_PLAN C
                        WHERE C.DESCR = 'FOR_HOLD'
                        GROUP BY C.FROM_SITE
                               , C.ITEM_ID) IA
                    , GT_XESS_MEASURE B
                WHERE B.COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.MEASURE    = 'CELL_FORM_HOLD_UNDER')
         WHEN MATCHED THEN
              UPDATE
                 SET A.FROM_BOH_QTY = NVL(XA.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, V_PLAN_START_YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3137_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## into #PSI_GLOBAL_ESS  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from CELL_FORM_HOLD_UNDER ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
                  -- 보류중 해제일자가 없는수량
                      -- BOH
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN (
                  --           SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                  --               FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
                  --              GROUP BY FROM_SITE, ITEM_ID
                  --              ) Z
                  --    ON X.ITEM_ID    = Z.ITEM_ID
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                  AS DIVISION_ID
                    , 'A'                            AS OPERATION_GROUP
                    , IA.ITEM_ID
                    , '-'                            AS TO_SITE
                    , '-'                            AS PROJECT_CODE
                    , 0                              AS TO_BOH_QTY
                    , NVL(IA.QTY, 0)                 AS FROM_BOH_QTY
                    , '-'                            AS INCOTERMS
                    , IA.FROM_SITE
                    , '-'                            AS TRANSPORT_MODE
                    , '-'                            AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER'         AS MEASURE
                    , 0                              AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                            AS BOD_ID
                 FROM (SELECT C.FROM_SITE
                            , C.ITEM_ID
                            , SUM(C.QTY)             AS QTY
                         FROM GT_XESS_STOCK_AGING C
                        GROUP BY C.FROM_SITE
                               , C.ITEM_ID) IA
                    , GT_XESS_MEASURE B
                WHERE B.COLUMN_NAME  = 'CELL_FORM_HOLD_UNDER'
                  AND IA.FROM_SITE IS NOT NULL) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.MEASURE    = 'CELL_FORM_HOLD_UNDER')
         WHEN MATCHED THEN
              UPDATE
                 SET A.FROM_BOH_QTY = A.FROM_BOH_QTY - XA.FROM_BOH_QTY
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, V_PLAN_START_YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3222_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## into #PSI_GLOBAL_ESS  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  measure CELL_FORM_HOLD_UNDER ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_25 #PSI_GLOBAL_ESS temp 에 hold 재고 update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* #tmp_SCM_DNM_STOCK_AGING_V2 : 1회 참조라 아래 MERGE 원천 인라인 뷰(XB)로 전환 */
        /*   --AND  UNHOLD_EXP_DATE                 IS NOT NULL */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## into #tmp_SCM_DNM_STOCK_AGING_V2  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from SCM_DNM_STOCK_AGING_V ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
                  --aging에서 hold 수량중 available_date or 예상해제일 늦은날짜 기준
                  --UPDATE X
                  --  SET X.QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                  --               FROM #tmp_SCM_DNM_STOCK_AGING_V2 Y  WITH (NOLOCK)
                  --              WHERE 0 = 0
                  --              --AND DESCR ='WH_HOLD'
                  --              GROUP BY ITEM_ID,FROM_SITE,Y.YYYYMMDD
                  --           )  Z
                  --    ON X.ITEM_ID    = Z.ITEM_ID
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.YYYYMMDD   = Z.YYYYMMDD
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                    AS DIVISION_ID
                    , 'A'                              AS OPERATION_GROUP
                    , IA.ITEM_ID
                    , '-'                              AS TO_SITE
                    , '-'                              AS PROJECT_CODE
                    , 0                                AS TO_BOH_QTY
                    , 0                                AS FROM_BOH_QTY
                    , '-'                              AS INCOTERMS
                    , IA.FROM_SITE
                    , '-'                              AS TRANSPORT_MODE
                    , '-'                              AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER_AVAILABLE' AS MEASURE
                    , IA.YYYYMMDD
                    , NVL(IA.QTY, 0)                   AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                              AS BOD_ID
                    , 'SCP_PLN_PRODUCTION_PLAN'        AS ATTRIBUTE1    /* 중복방지 */
                    , 'F6000'                          AS ATTRIBUTE9    /* 중복방지 */
                 FROM (SELECT XB.ITEM_ID
                            , XB.FROM_SITE
                            , SUM(XB.QTY)              AS QTY
                            , XB.YYYYMMDD
                         FROM (SELECT C.SCM_SITE_ID    AS FROM_SITE                  /* #tmp_SCM_DNM_STOCK_AGING_V2 */
                                    , C.ITEM_ID
                                    , (CASE WHEN C.AVAILABLE_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                                            ELSE TO_CHAR(C.AVAILABLE_DATE, 'YYYYMMDD')
                                       END)            AS YYYYMMDD
                                    , SUM(C.QTY)       AS QTY
                                 FROM SCM_DNM_STOCK_AGING_V C
                                WHERE C.WIPHOLD_YN  = 'Y'
                                  AND C.CUTOFF_DATE = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD')
                                GROUP BY C.SCM_SITE_ID
                                       , C.ITEM_ID
                                       , (CASE WHEN C.AVAILABLE_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                                               ELSE TO_CHAR(C.AVAILABLE_DATE, 'YYYYMMDD')
                                          END)) XB
                          /* --AND DESCR ='WH_HOLD' */
                        GROUP BY XB.ITEM_ID
                               , XB.FROM_SITE
                               , XB.YYYYMMDD) IA
                    , GT_XESS_MEASURE B
                WHERE B.COLUMN_NAME  = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
                  AND IA.FROM_SITE IS NOT NULL) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.YYYYMMDD   = XA.YYYYMMDD
               AND A.MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE')
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = NVL(XA.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID, XA.ATTRIBUTE1, XA.ATTRIBUTE9 );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3242_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* AS-IS 조건 그대로 (AND 가 OR 보다 먼저 묶임) */
        UPDATE GT_XESS_PSI_GLOBAL_ESS
           SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
             , ATTRIBUTE9 = 'F6000'
         WHERE (    MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
                AND ATTRIBUTE1 IS NULL)
            OR ATTRIBUTE9 IS NULL;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #tmp_SCM_DNM_STOCK_AGING_V2  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  measure CELL_FORM_HOLD_UNDER_AVAILABLE ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_26 #PSI_GLOBAL_ESS temp 에 hold 재고 2 update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* ----------------------------------------------------------------------------------------------------------- */
        /* CELL_FORM_HOLD_AFTER 추가 */
        /* [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS) */
        /* ----------------------------------------------------------------------------------------------------------- */
/*
                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                 --                FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                 --                WHERE DESCR ='WH_HOLD'
                 --               GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                 --            )  Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                  AS DIVISION_ID
                    , 'A'                            AS OPERATION_GROUP
                    , IA.ITEM_ID
                    , '-'                            AS TO_SITE
                    , '-'                            AS PROJECT_CODE
                    , 0                              AS TO_BOH_QTY
                    , 0                              AS FROM_BOH_QTY
                    , '-'                            AS INCOTERMS
                    , IA.FROM_SITE
                    , '-'                            AS TRANSPORT_MODE
                    , '-'                            AS PROD_LINE
                    , 'CELL_FORM_HOLD_AFTER'         AS MEASURE
                    , IA.YYYYMMDD
                    , NVL(IA.QTY, 0)                 AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                            AS BOD_ID
                    , NULL                           AS ATTRIBUTE1      /* 중복방지 */
                    , NULL                           AS ATTRIBUTE9      /* 중복방지 */
                 FROM (SELECT C.ITEM_ID
                            , C.FROM_SITE
                            , SUM(C.QTY)             AS QTY
                            , C.YYYYMMDD
                         FROM GT_XESS_PLN_TH_ENG_STOCK_PLAN C
                        WHERE (SELECT SA.OPERATION_GROUP
                                 FROM SCM_MST_SITE SA
                                WHERE SA.SCM_SITE_ID = C.FROM_SITE) = 'A'          /* CELL 생산 사이트 한정 */
                          AND C.DESCR = 'WH_HOLD'
                        GROUP BY C.ITEM_ID
                               , C.FROM_SITE
                               , C.YYYYMMDD) IA
                    , GT_XESS_MEASURE B
                WHERE B.COLUMN_NAME  = 'CELL_FORM_HOLD_AFTER'
                  AND IA.FROM_SITE IS NOT NULL) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.YYYYMMDD   = XA.YYYYMMDD
               AND A.MEASURE    = 'CELL_FORM_HOLD_AFTER')
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = NVL(XA.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, XA.YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3455_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  measure CELL_FORM_HOLD_AFTER ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
                  -- -- 보류중 해제일자가 없는수량
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='WH_HOLD'
                  --              GROUP BY ITEM_ID,FROM_SITE
                  --           )  Z
                  --    ON X.ITEM_ID    = Z.ITEM_ID
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
*/

        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT V_DIVISION_ID                  AS DIVISION_ID
                    , 'A'                            AS OPERATION_GROUP
                    , IA.ITEM_ID
                    , '-'                            AS TO_SITE
                    , '-'                            AS PROJECT_CODE
                    , 0                              AS TO_BOH_QTY
                    , IA.FROM_BOH_QTY
                    , '-'                            AS INCOTERMS
                    , IA.FROM_SITE
                    , '-'                            AS TRANSPORT_MODE
                    , '-'                            AS PROD_LINE
                    , 'CELL_FORM_HOLD_AFTER'         AS MEASURE
                    , 0                              AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                            AS BOD_ID
                    , NULL                           AS ATTRIBUTE1      /* 중복방지 */
                    , NULL                           AS ATTRIBUTE9      /* 중복방지 */
                 FROM (SELECT C.ITEM_ID
                            , C.FROM_SITE
                            , SUM(C.QTY)             AS FROM_BOH_QTY
                         FROM GT_XESS_PLN_TH_ENG_STOCK_PLAN C
                        WHERE C.DESCR = 'WH_HOLD'
                        GROUP BY C.ITEM_ID
                               , C.FROM_SITE) IA
                    , GT_XESS_MEASURE B
                WHERE B.COLUMN_NAME  = 'CELL_FORM_HOLD_AFTER'
                  AND IA.FROM_SITE IS NOT NULL) XA
           ON (    A.ITEM_ID    = XA.ITEM_ID
               AND A.FROM_SITE  = XA.FROM_SITE
               AND A.MEASURE    = 'CELL_FORM_HOLD_AFTER')
         WHEN MATCHED THEN
              UPDATE
                 SET A.FROM_BOH_QTY = NVL(XA.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID )
              VALUES ( XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID, XA.TO_SITE, XA.PROJECT_CODE, XA.TO_BOH_QTY, XA.FROM_BOH_QTY, XA.INCOTERMS, XA.FROM_SITE
                     , XA.TRANSPORT_MODE, XA.PROD_LINE, XA.MEASURE, V_PLAN_START_YYYYMMDD, XA.QTY, XA.SORT_ORDER_NO, XA.COLUMN_LABEL_NAME, XA.BOD_ID );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3544_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        UPDATE GT_XESS_PSI_GLOBAL_ESS
           SET ATTRIBUTE1 = NULL   /* '' */
             , ATTRIBUTE9 = NULL   /* '' */
         WHERE MEASURE    = 'CELL_FORM_HOLD_AFTER';

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '########## merge into #PSI_GLOBAL_ESS  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || '  from #PLN_TH_ENG_STOCK_PLAN  CELL_FORM_HOLD_AFTER ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* LT 계산용 테이블 생성 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* #SCP_MST_BOD_V → 하위와 공유하는 GT_SCXL_BOD_V */
        DELETE FROM GT_SCXL_BOD_V;

        INSERT
          INTO GT_SCXL_BOD_V
             ( DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
             , LT_TOTAL_BY_WEEK
             )
        SELECT DISTINCT
               DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
             , CEIL(LT_TOTAL / 7.0)          AS LT_TOTAL_BY_WEEK
          FROM SCP_MST_BOD_N_V                                   /* BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
         WHERE DIVISION_ID = V_DIVISION_ID;

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '##########  into #SCP_MST_BOD_V  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' into #SCP_MST_BOD_V ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* PACK공장 CELL 재고 UPDATE */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* PACK 일경우 */
        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리 */
/*
                UPDATE X
                   SET  CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                    AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.CELL_TYPE          = 'CP'     -- 활성화코드 분리 대응(Cell Product 조건 추가. 2023.06.15, KSK
                                                AND Y.OPERATION_GROUP_ID = 'A')
                FROM #PSI_GLOBAL_ESS X
                 WHERE OPERATION_GROUP   = 'P';
                 ;
*/
        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직 시작 */
        /* AS-IS : WITH model_child_item_id (DIVISION_ID, MODEL_ID 별 MIN(CHILD_ITEM_ID)) + UPDATE ... JOIN */
        /*   → 같은 조건의 MIN 상관 서브쿼리 + EXISTS (조인되지 않는 행은 갱신 제외 - 내부조인 의미 유지) */
        UPDATE GT_XESS_PSI_GLOBAL_ESS A
           SET A.CELL_ITEM_ID = (SELECT MIN(B.CHILD_ITEM_ID)
                                   FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                                  WHERE B.DIVISION_ID        = A.DIVISION_ID
                                    AND B.MODEL_ID           = A.ITEM_ID
                                    AND B.CELL_TYPE          = 'CP'      /* 활성화코드 분리 대응(CELL PRODUCT 조건 추가) :: 2023.06.15 , KSK */
                                    AND B.OPERATION_GROUP_ID = 'A'
                                    AND B.DIVISION_ID        = V_DIVISION_ID)
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                        WHERE C.DIVISION_ID        = A.DIVISION_ID
                          AND C.MODEL_ID           = A.ITEM_ID
                          AND C.CELL_TYPE          = 'CP'
                          AND C.OPERATION_GROUP_ID = 'A'
                          AND C.DIVISION_ID        = V_DIVISION_ID)
           AND A.OPERATION_GROUP = 'P';
        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직 끝 */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '##########  update #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PACK공장 CELL 재고 UPDATE ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가. 2023.06.15, KSK- start */
        /* AS-IS : WITH CP_INFO + UPDATE ... INNER JOIN F / LEFT JOIN FS·C1·C2·C3 → 행 ROWID 기준 MERGE (내부조인 F 유지) */
        MERGE INTO GT_XESS_PSI_GLOBAL_ESS A
        USING (SELECT SA.RID
                    , SA.CELL_ITEM_ID
                 FROM (WITH CP_INFO AS (SELECT M.DIVISION_ID
                                             , M.PLANT_ID
                                             , M.ITEM_ID_ASSY
                                             , M.ITEM_ID_PROD
                                             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY, M.PLANT_ID
                                                                      ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) AS PRIORITY_1ST
                                             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY
                                                                      ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) AS PRIORITY_2ND
                                             , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
                                                                      ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) AS PRIORITY_3RD
                                          FROM SCP_MST_CELL_PROD_ASSY_MAP M)
                       SELECT B.ROWID                                    AS RID
                            , CASE WHEN C.CELL_TYPE LIKE 'CA%'
                                   THEN NVL(NVL(NVL(E.ITEM_ID_PROD, F.ITEM_ID_PROD), G.ITEM_ID_PROD), B.ITEM_ID)
                                   ELSE B.ITEM_ID
                              END                                        AS CELL_ITEM_ID
                            , ROW_NUMBER() OVER (PARTITION BY B.ROWID ORDER BY NULL) AS RN
                         FROM GT_XESS_PSI_GLOBAL_ESS B
                            , SCP_MST_FINAL_ITEM_V   C
                            , SCM_MST_SITE           D
                            , CP_INFO                E
                            , CP_INFO                F
                            , CP_INFO                G
                        WHERE B.ITEM_ID           = C.ITEM_ID
                          AND B.DIVISION_ID       = D.DIVISION_ID(+)
                          AND B.FROM_SITE         = D.SCM_SITE_ID(+)
                          AND D.SITE_TYPE(+)      = 'PLANT'
                          AND B.DIVISION_ID       = E.DIVISION_ID(+)
                          AND D.PLANT_ID          = E.PLANT_ID(+)
                          AND B.ITEM_ID           = E.ITEM_ID_ASSY(+)
                          AND E.PRIORITY_1ST(+)   = 1
                          AND B.DIVISION_ID       = F.DIVISION_ID(+)
                          AND B.ITEM_ID           = F.ITEM_ID_ASSY(+)
                          AND F.PRIORITY_2ND(+)   = 1
                          AND B.ITEM_ID           = G.ITEM_ID_ASSY(+)
                          AND G.PRIORITY_3RD(+)   = 1
                          AND B.OPERATION_GROUP   = 'A') SA
                WHERE SA.RN = 1) XA
           ON (A.ROWID = XA.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET A.CELL_ITEM_ID = XA.CELL_ITEM_ID;
        /* CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가. 2023.06.15, KSK - end */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '##########  update #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가. ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3630_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* ----------------------------------------------------------------------------------------------------------- */
        /* LINE_TOTAL_LOAD_ENGINE (TACT_TIME,WORKING_TIME) */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* Line Load 율 로직 작업중 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* #LINE_WORKINGTIME_BY_LOSS → 하위와 공유하는 GT_SCXL_LINE_WORKTIME */
        DELETE FROM GT_SCXL_LINE_WORKTIME;

        /* Working Time 추출 (AS-IS 4번째 인자 '' → NULL : 함수에서 전체 Line) */
        INSERT
          INTO GT_SCXL_LINE_WORKTIME
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
             )
        SELECT DIVISION_ID
             , PLANT_SITE_ID                 AS SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
          FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(V_DIVISION_ID, V_PLAN_START_YYYYMMDD, V_TO_YYYYMMDD, NULL));

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '##########  into #LINE_WORKINGTIME_BY_LOSS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' into #LINE_WORKINGTIME_BY_LOSS ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* AS-IS UPDATE ... INNER JOIN → 상관 서브쿼리 + EXISTS (내부조인 의미 유지, 다건 시 1건) */
        UPDATE GT_XESS_PSI_GLOBAL_ESS A
           SET A.QTY = (SELECT B.WORKING_TIME
                          FROM GT_SCXL_LINE_WORKTIME B
                         WHERE B.DIVISION_ID  = A.DIVISION_ID
                           AND B.OPERATION_ID = A.ATTRIBUTE9
                           AND B.SCM_SITE_ID  = A.FROM_SITE
                           AND B.LINE_ID      = A.PROD_LINE
                           AND B.YYYYMMDD     = A.YYYYMMDD
                           AND ROWNUM         = 1)
         WHERE EXISTS (SELECT 1
                         FROM GT_SCXL_LINE_WORKTIME C
                        WHERE C.DIVISION_ID  = A.DIVISION_ID
                          AND C.OPERATION_ID = A.ATTRIBUTE9
                          AND C.SCM_SITE_ID  = A.FROM_SITE
                          AND C.LINE_ID      = A.PROD_LINE
                          AND C.YYYYMMDD     = A.YYYYMMDD)
           AND A.MEASURE IN ('PACK_WORKING_TIME', 'CELL_WORKING_TIME');

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '##########  update #LINE_WORKINGTIME_BY_LOSS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' update #LINE_WORKINGTIME_BY_LOSS ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        /* #LineLoad → GT_SCXL_LINELOAD (하위가 시작 시 다시 비우고 채움) */
        DELETE FROM GT_SCXL_LINELOAD;

        /* WEEK_COLUMN : AS-IS 'WQTY' + REPLICATE('0', 2 - LEN(순위)) + 순위 → 순위가 3자리 이상이면 REPLICATE 가 NULL 이 되어 전체 NULL */
        INSERT
          INTO GT_SCXL_LINELOAD
             ( DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP, OPERATION_ID, LINE_ID, MEASURE, QTY, CAPA_TACT, WORKING_TIME, YYYYMMDD, ISO_YYYYWW, WEEK_COLUMN )
        SELECT /* DISTINCT */
               A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.OPERATION_GROUP
             , A.OPERATION_ID
             , A.LINE_ID
             , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                     WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                END)                                                                       AS MEASURE
             , CASE WHEN C.WORKING_TIME <= 0.0 THEN 0
                    ELSE NVL(((ROUND(SUM(A.QTY * (D.TACT_TIME / 60)), 0) / C.WORKING_TIME)), 0) * 100
               END                                                                         AS QTY
             , NVL(ROUND(SUM(A.QTY * (D.TACT_TIME / 60)), 0), 0)                           AS CAPA_TACT
             , NVL(C.WORKING_TIME, 0)                                                      AS WORKING_TIME
             , A.YYYYMMDD                                                                  AS YYYYMMDD
             , B.ISO_YYYYWW                                                                AS ISO_YYYYWW
             , CASE WHEN LENGTH(TO_CHAR(DENSE_RANK() OVER (PARTITION BY A.LINE_ID ORDER BY B.ISO_YYYYWW))) > 2 THEN NULL
                    ELSE 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER (PARTITION BY A.LINE_ID ORDER BY B.ISO_YYYYWW)), 2, '0')
               END                                                                         AS WEEK_COLUMN
          FROM SCP_ANL_PRODUCTION_PLAN A
             , SCM_SYS_CALENDAR_M      B
             , GT_SCXL_LINE_WORKTIME   C
             , SCP_ANL_TACT_TIME       D
         WHERE A.YYYYMMDD            = B.BASIS_YYYYMMDD
           AND A.DIVISION_ID         = C.DIVISION_ID(+)
           AND A.OPERATION_ID        = C.OPERATION_ID(+)
           AND A.SCM_SITE_ID         = C.SCM_SITE_ID(+)
           AND A.LINE_ID             = C.LINE_ID(+)
           AND A.YYYYMMDD            = C.YYYYMMDD(+)
           AND A.DIVISION_ID         = D.DIVISION_ID(+)
           AND A.OPERATION_ID        = D.OPERATION_ID(+)
           AND A.SCM_SITE_ID         = D.SCM_SITE_ID(+)
           AND A.LINE_ID             = D.LINE_ID(+)
           AND A.ITEM_ID             = D.ITEM_ID(+)
           AND A.YYYYMMDD            = D.YYYYMMDD(+)
           /* --	                AND A.MEASURE             IN ('CELL_PROD','PACK_PROD') */
           AND A.MEASURE            IN ('PROD_PLAN_AMEND')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
           AND A.YYYYMMDD           >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD            < V_TO_YYYYMMDD
           /* --AND A.YYYYMMDD           <=  @p_to_yyyymmdd --말일포함(KSK, 20240814, 운영배포보류) */
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YYYYMMDD
                , C.WORKING_TIME
                , B.ISO_YYYYWW
                , A.OPERATION_GROUP
                , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                        WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                   END);

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3672_LINE_LOAD' AS  #LineLoad , * FROM #LineLoad WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */
        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '3674_PSI_GLOBAL_ESS' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '##########  into #LineLoad ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' into #LineLoad ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

        INSERT
          INTO GT_XESS_PSI_GLOBAL_ESS
             ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
             , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                           AS TO_SITE
             , A.PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , A.FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , A.PROD_LINE
             , B.MEASURE
             , A.YYYYMMDD
             , B.QTY
             , C.SORT_ORDER_NO
             , C.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XESS_PSI_GLOBAL_ESS A
             , GT_SCXL_LINELOAD       B
             , GT_XESS_MEASURE        C
         WHERE A.DIVISION_ID     = B.DIVISION_ID
           AND A.OPERATION_GROUP = B.OPERATION_GROUP
           AND A.FROM_SITE       = B.SCM_SITE_ID
           AND A.ATTRIBUTE9      = B.OPERATION_ID
           AND A.PROD_LINE       = B.LINE_ID
           AND A.YYYYMMDD        = B.YYYYMMDD
           AND B.MEASURE         = C.COLUMN_NAME;

        /* IF @P_IS_DEBUG = 1 SELECT '3781_PSI_GLOBAL_ESS' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD  (디버그 결과셋) */

        /* E20260331-000738 82사업부 MA Plan 수행 시 속도지연 */
        V_LOG_MESSAGE := '##########  into #PSI_GLOBAL_ESS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' INNER JOIN #LineLoad ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME, P_LOG_TYPE => 'TXN', P_LOG_COUNT => 0, P_LOG_MESSAGE => V_LOG_MESSAGE
                            , P_DESCRIPTION => V_DESCRIPTION, P_EVENT_DATE => D_EVENT_DATE, P_USER_ID => V_BATCH_USER );

/*
---- 단위처리시간 추출 --
--print N'position_27 #PSI_GLOBAL_ESS temp 에 LT update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --
*/

        /* 2021.06.03 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성 */
        /*  구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결) */

        /* 이력정보 START ------------------------------------------------------------------------------------------------- */
        /* 최근3주차  이력일자 */
        V_HIST_DATE := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 2 * 7, 'YYYYMMDD');

        SELECT COUNT(1)
          INTO N_EXISTS
          FROM SCP_XLS_PSI_GLOBAL_ESS_H
         WHERE PLAN_START_YYYYMMDD < V_HIST_DATE
           AND ROWNUM              = 1;

        IF N_EXISTS > 0 THEN
            /* 최근 3주차 이전데어터는 삭제 */
            DELETE
              FROM SCP_XLS_PSI_GLOBAL_ESS_H
             WHERE PLAN_START_YYYYMMDD < V_HIST_DATE;

            V_DESCRIPTION := 'DELETE HISTORY DONE BEFORE ' || V_HIST_DATE;
            D_EVENT_DATE  := SYSDATE;
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                    , P_LOG_TYPE     => 'END'
                                    , P_LOG_COUNT    => 1
                                    , P_LOG_MESSAGE  => '########## END of procedure ##########'
                                    , P_DESCRIPTION  => V_DESCRIPTION
                                    , P_EVENT_DATE   => D_EVENT_DATE
                                    , P_USER_ID      => V_BATCH_USER
                                    );
            END IF;
        END IF;

        /* 현재플랜과 동일한 이력 데이터 초기화 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_ESS_H
         WHERE DIVISION_ID         = V_DIVISION_ID
           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = V_PLAN_TYPE
           AND SEQ                 = N_SEQ;

        /* 저장플랜과 동일한 이력데이터 초기화 (AS-IS DELETE H FROM ... INNER JOIN → EXISTS) */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_ESS_H A
         WHERE EXISTS (SELECT 1
                         FROM SCP_XLS_PSI_GLOBAL_ESS B
                        WHERE B.DIVISION_ID         = A.DIVISION_ID
                          AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                          AND B.PLAN_TYPE           = A.PLAN_TYPE
                          AND B.SEQ                 = A.SEQ);

        /* 저장 플랜의 백업본 저장 (두 테이블 칸 구성·순서 동일 - 468칸) */
        INSERT
          INTO SCP_XLS_PSI_GLOBAL_ESS_H
        SELECT *
          FROM SCP_XLS_PSI_GLOBAL_ESS;
        /* 이력정보  ----------------------------------------------------------------------------------------- END */

        /* 사업부별 현재 데이터 삭제 */
        IF P_IS_DEBUG = '0' THEN
            DELETE
              FROM SCP_XLS_PSI_GLOBAL_ESS
             WHERE DIVISION_ID = V_DIVISION_ID;
        END IF;

        /* Plan End Date */
        BEGIN
            SELECT A.HORIZON_END_DATE
                 , (CASE WHEN TO_DATE(A.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(A.PLAN_NAME, 'YYYYMMDD') > 364 THEN 'Y' ELSE 'N' END)
                 , (CASE WHEN TO_DATE(A.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(A.PLAN_NAME, 'YYYYMMDD') > 364
                         THEN TO_DATE(A.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(A.PLAN_NAME, 'YYYYMMDD') - 363
                         ELSE 0
                    END)
              INTO V_PET_DATE
                 , V_BP_FLAG
                 , N_BP_DAYS
              FROM SCM_MST_PLAN A
             WHERE A.PLAN_ID     = (SELECT MAX(B.PLAN_ID)
                                      FROM SCM_MST_PLAN B
                                     WHERE B.DIVISION_ID        = V_DIVISION_ID
                                       AND TO_NUMBER(B.PLAN_ID) < 9999)
               AND A.DIVISION_ID = V_DIVISION_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;  /* AS-IS : 행이 없으면 초기값 유지 */
        END;

        V_CREATE_FROM_YYYYMMDD := V_PLAN_START_YYYYMMDD;
        V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');

        /* 하위 PR_SCP_XLS_PSI_GLOBAL_ESS_S 가 읽는 #PSI_GLOBAL_ESS 공유분 (세로형 20칸) */
        /*   ★ 기존 GT_SCXL_PSI_GLOBAL_ESS_SRC 는 가로형(QTY001~) 구조라 YYYYMMDD·QTY·COLUMN_LABEL_NAME 칸이 없음 */
        /*     → 정적 SQL 이면 컴파일 불가이므로 동적 SQL 로 적재(값 연결 없음). GTT 구조 정정 전에는 이 문장에서 ORA-00904 */
        DELETE FROM GT_SCXL_PSI_GLOBAL_ESS_SRC;

        EXECUTE IMMEDIATE
               'INSERT INTO GT_SCXL_PSI_GLOBAL_ESS_SRC '
            || '     ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE '
            || '     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 ) '
            || 'SELECT DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE '
            || '     , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9 '
            || '  FROM GT_XESS_PSI_GLOBAL_ESS';

        IF P_IS_DEBUG = '0' THEN
            PR_SCP_XLS_PSI_GLOBAL_ESS_S( P_PLAN_CYCLE           => V_PLAN_CYCLE
                                       , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                       , P_PLAN_ID              => V_PLAN_ID
                                       , P_MODELING_ID          => V_MODELING_ID
                                       , P_SEQ                  => V_SEQ
                                       , P_PLAN_TYPE            => V_PLAN_TYPE
                                       , P_MASTER_ID            => V_MASTER_ID
                                       , P_DIVISION_ID          => V_DIVISION_ID
                                       , P_ENGINE_PLAN_ID       => V_ENGINE_PLAN_ID
                                       , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                       , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                       , P_USER_ID              => V_BATCH_USER
                                       , P_IS_DEBUG             => P_IS_DEBUG
                                       , O_RETURN_CODE          => N_ROWS
                                       );
        END IF;

        IF (N_ROWS < 0) THEN
            O_RETURN := -1;  /* GOTO _RETURN_ERR_CODE : RETURN -1 */
            RETURN;
        END IF;

        IF V_BP_FLAG = 'Y' THEN
            /* 2년차 사업계획을 위한 1년차 키백업(KSK) */
            IF V_PLAN_START_YYYYMMDD = V_CREATE_FROM_YYYYMMDD THEN
                DBMS_OUTPUT.PUT_LINE('1 YEAR #XLS_KEYS PREPARE');

                DELETE FROM GT_XESS_XLS_KEYS;

                INSERT
                  INTO GT_XESS_XLS_KEYS
                     ( PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, CREATE_FROM_YYYYMMDD, DIVISION_ID
                     , OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                     , INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, BOD_ID, MEASURE
                     , XLS_KEY1 )
                SELECT PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, CREATE_FROM_YYYYMMDD, DIVISION_ID
                     , OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                     , INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, BOD_ID, MEASURE
                     , XLS_KEY1
                  FROM SCP_XLS_PSI_GLOBAL_ESS
                 WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD;

                /* --SELECT '#XLS_KEYS' TN , * FROM #XLS_KEYS --TEST */
            END IF;

            /* 2 YEAR PIVOT data 생성 */
            V_CREATE_FROM_YYYYMMDD := TO_CHAR(TO_DATE(V_CREATE_TO_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');
            V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');

            PR_SCP_XLS_PSI_GLOBAL_ESS_S( P_PLAN_CYCLE           => V_PLAN_CYCLE
                                       , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                       , P_PLAN_ID              => V_PLAN_ID
                                       , P_MODELING_ID          => V_MODELING_ID
                                       , P_SEQ                  => V_SEQ
                                       , P_PLAN_TYPE            => V_PLAN_TYPE
                                       , P_MASTER_ID            => V_MASTER_ID
                                       , P_DIVISION_ID          => V_DIVISION_ID
                                       , P_ENGINE_PLAN_ID       => V_ENGINE_PLAN_ID
                                       , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                       , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                       , P_USER_ID              => V_BATCH_USER
                                       , P_IS_DEBUG             => P_IS_DEBUG
                                       , O_RETURN_CODE          => N_ROWS
                                       );

            IF (N_ROWS < 0) THEN
                O_RETURN := -1;  /* GOTO _RETURN_ERR_CODE : RETURN -1 */
                RETURN;
            END IF;
        END IF;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 임시 TEMP  테이블 DROP */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* #MEASURE · #PSI_GLOBAL · #ANL_SHIPMENT_PLAN_FG · #ANL_PRODUCTION_PLAN · #ANL_SHIPMENT_PLAN_SEMI · #SCP_PLN_PRODUCTION_PLAN */
        /* #ITEM_ID · #PSI_GLOBAL_ESS · #INTRANSIT · #SCP_MST_BOD_V · #LineLoad · #LineLoad_WEEK_PIVOT · #TRANSPORT_MODE */
        /* #SCP_XLS_PSI_GLOBAL_ESS_MODEL_INVENTORY · #Rn · #CALENDAR · #HEADER · #PLN_PLANT_ONHAND · #BOH · #SCP_XLS_PSI_GLOBAL_ESS */
        /* #tmp_SCP_MST_TACT_TIME · #PROD_TACT_TIME_PIVOT · #BOD_OTHER_SHIP_PLAN · #XLS_KEYS */
        /* → GTT(ON COMMIT PRESERVE ROWS) 는 객체를 유지하고 다음 실행 시작 시 DELETE 로 초기화 */

        /* ----------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* ----------------------------------------------------------- */
        /* --IF @@TRANCOUNT > 0 */
        /* --  BEGIN */
        /* --    COMMIT TRAN T1; */
        /* --  END; */

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := 0;  /* AS-IS @@ROWCOUNT : 직전 문장이 DROP TABLE 이라 0 */
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        IF P_IS_DEBUG = '0' THEN
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );
        END IF;

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                    , P_LOG_TYPE     => V_LOG_TYPE
                                    , P_LOG_COUNT    => N_LOG_COUNT
                                    , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                    , P_DESCRIPTION  => V_DESCRIPTION
                                    , P_EVENT_DATE   => D_EVENT_DATE
                                    , P_USER_ID      => V_BATCH_USER
                                    );
            END IF;
            /* --      PRINT @@ERROR */
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    /* 임시 운영반영시에 주석처리 할것. */
    /* AS-IS : 분이 3자리 이상이면 REPLICATE 가 NULL 이 되어 V_EXEC_TIME 과 설명이 NULL */
    N_EXEC_SEC  := TRUNC((SYSDATE - D_START_TIME) * 86400);
    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(TRUNC(N_EXEC_SEC / 60))) > 2 THEN NULL
                        ELSE LPAD(TO_CHAR(TRUNC(N_EXEC_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(N_EXEC_SEC, 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := CASE WHEN V_EXEC_TIME IS NULL THEN NULL
                          ELSE '[' || V_MASTER_ID || '][' || V_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']'
                     END;
    D_EVENT_DATE  := SYSDATE;
    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;

    O_RETURN := 1;
    RETURN;  /* return 1 */
END;
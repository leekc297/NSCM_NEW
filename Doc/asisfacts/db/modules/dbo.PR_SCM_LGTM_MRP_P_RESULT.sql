
/*
 * Program ID   : PR_SCM_LGTM_MRP_P_RESULT
 * Description  : 장기재고 관련 다빈치수불부 제공용 정보 형성 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 *                              최초 생성
 * 2025.12.23   김준규   		[IT20250117A] 입고 이력 정보용 XIF_MRP_PO_WHIN_RESULT_R I/F 테이블이 MQ에서 SAP PO로 변경되면서 추출 로직 변경됨
 *                              기존 : 가장 마지막 ACCUM_DATE에 지금까지의 입고 누적을 전송
 *                              변경 : 일자별로 입고 전송
 * 2026/02/26   YMH				[E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경.
--EXEC [PR_SCM_LGTM_MRP_P_RESULT] '20250331', '202503', 'MRP-SCP-20250408-001'
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_LGTM_MRP_P_RESULT]
     @p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_base_yyyymm            NVARCHAR(6)
    ,@p_mrp_version_id             NVARCHAR(30)
AS
BEGIN
    --2025.01.16 Y.S.H Initial Release
    ------------------------------------------------------------------------
    -- Procedure 기본조건.
    ------------------------------------------------------------------------
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- LOG 용 변수 설정
    ------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_MRP_P_RESULT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- LOG 시작
    ------------------------------------------------------------------------
    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- Set Prameter
    ------------------------------------------------------------------------
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = ISNULL( @p_plan_start_yyyymmdd ,  CONVERT(NVARCHAR(8), GETDATE(), 112) )
    DECLARE @v_base_yyyymm          NVARCHAR(6)     = ISNULL( @p_base_yyyymm, SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, GETDATE()), 112 ),1,6) )
    DECLARE @v_basis_yyyymmdd       NVARCHAR(8)     = CONCAT( @p_base_yyyymm,'01');--2025.12.23 [IT20250117A] 입고 이력 정보용 XIF_MRP_PO_WHIN_RESULT_R I/F 테이블이 MQ에서 SAP PO로 변경되면서 추출 로직 변경됨 Start
    DECLARE @v_mrp_p_version_no     NVARCHAR(50)    = @p_mrp_version_id;
    DECLARE @v_add_days             NUMERIC         = 9;
    -- E20260211-001073 MRP 수신정보 버전체계 변경으로 버전체계를 날짜정보로 형성 기존로직 제거.
    -- DECLARE @v_result_yyyymmdd      NVARCHAR(8)     = SUBSTRING(MAX(@p_mrp_version_id), 9, 8);
    -- E20260211-001073 MRP 수신정보 버전체계 변경으로 버전체계를 날짜정보로 형성 
    DECLARE @v_result_yyyymmdd      NVARCHAR(8)		= @p_mrp_version_id;

    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- Transaction (START)
    ------------------------------------------------------------------------
    BEGIN TRANSACTION PR_SCM_LGTM_MRP_P_RESULT;
    ------------------------------------------------------------------------
    PRINT 'PST YMD: '+@v_plan_start_yyyymmdd+'//Basis YM: '+@v_base_yyyymm;
    ------------------------------------------------------------------------
    BEGIN TRY
        ------------------------------------------------------------------------
        -- Step 1. Temp Clear
        ------------------------------------------------------------------------
        IF OBJECT_ID (N'tempdb..#TEMP_INTRANSIT_QTY', N'U') IS NOT NULL DROP TABLE #TEMP_INTRANSIT_QTY;
        IF OBJECT_ID (N'tempdb..#TEMP_MRP_PLAN', N'U') IS NOT NULL DROP TABLE      #TEMP_MRP_PLAN;


        BEGIN
        ------------------------------------------------------------------------
        -- Step 2. Exist Data Clear
        ------------------------------------------------------------------------
            DELETE
            FROM    SCM_LGTM_MRP_P_RESULT
            WHERE   1=1
            AND     PLAN_TP_CD          = 'LGTM_MRP_P'
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        ------------------------------------------------------------------------
        END


        --BEGIN
        ------------------------------------------------------------------------
        -- Step 3. Get MRP Version & Result yyyymmdd
        ------------------------------------------------------------------------
            --SELECT    @v_mrp_p_version_no = MAX(MRP_VERSION_ID)
            --        , @v_result_yyyymmdd  = SUBSTRING(MAX(MRP_VERSION_ID), 9, 8)
            --FROM    XIF_MRP_BPS_MAT_PLAN_R_SN WITH(NOLOCK)
            --WHERE   1=1
            --AND     IF_RCV_DATE >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
            --AND     IF_RCV_DATE <  DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
            --;
        --END

        ------------------------------------------------------------------------
        PRINT 'Start Create MRP P & Result';
        ------------------------------------------------------------------------
        BEGIN
        ------------------------------------------------------------------------
        -- Step 4. Create ( MRP P Plan + Result for 1-month's Set )
        ------------------------------------------------------------------------
            SELECT    MM.PLANT_ID
                    , MM.PO_NO
                    , MM.ITEM_ID
                    , MM.RESULT_TYPE
                    , MM.SRCE_YYYYMM
                    , MM.PLAN_YYYYMM
                    , SUM(MM.QTY) AS QTY
                    , MAX(MM.MRP_VERSION_ID)    AS VERSION_NO
                    , MAX(MM.SUPPLIER_ID)       AS SUPPLIER_ID
                    , MAX(MM.SUPPLIER_NAME)     AS SUPPLIER_NAME
                    , MAX(MM.FLAG)              AS FLAG
                    , MAX(MM.PROPOSAL_TYPE)     AS PROPOSAL_TYPE
            INTO    #TEMP_MRP_PLAN
            FROM    (   --MRP P Plan---------------
                        SELECT    S.PLANT_ID            AS PLANT_ID
                                , S.PO_NO               AS PO_NO
                                , S.ITEM_ID             AS ITEM_ID
                                , S.RESULT_TYPE_NAME    AS RESULT_TYPE
                                , IIF(LEFT(ISNULL(ATTR_03, 'X'), 1) = 'F', SUBSTRING(ATTR_01, 1, 6), RESULT_DATE)   AS SRCE_YYYYMM
                                , IIF(S.RESULT_DATE < @v_base_yyyymm, @v_base_yyyymm, S.RESULT_DATE)              AS PLAN_YYYYMM
                                , S.RESULT_QUANTITY     AS QTY
                                -- [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜형식만 비교하게 변경. 기존로직 주석처리
                                --, S.MRP_VERSION_ID      AS MRP_VERSION_ID
                                -- [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜형식만 비교하게 변경
                                , @v_mrp_p_version_no   AS MRP_VERSION_ID
                                , S.SUPPLIER_ID         AS SUPPLIER_ID
                                , S.SUPPLIER_NAME       AS SUPPLIER_NAME
                                , S.FLAG                AS FLAG
                                , S.PROPOSAL_TYPE       AS PROPOSAL_TYPE
                        FROM    XIF_MRP_BPS_MAT_PLAN_R_SN S WITH(NOLOCK)
                        WHERE   1=1
                        -- [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜형식만 비교하게 변경. 기존로직 주석처리
                        -- AND     S.MRP_VERSION_ID      =  @v_mrp_p_version_no  
                        -- [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜형식만 비교하게 변경
                        AND     S.MRP_VERSION_ID      like @v_mrp_p_version_no +'_D%' -- 현재 버전체계 EX)20260224_D_52_001_BATCHMMHQ01_[PLANT]
                        AND     S.RESULT_TYPE_NAME   IN ('Proposal', 'In-Transit', 'Open PO', 'Requirement')
                        AND     S.ITEM_ID NOT IN (  SELECT  ITEM_ID
                                                    FROM    SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                                            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                            ON   L.SEGMENT1      = SIM.ITEM_CLASS
                                                            AND  L.LOOKUP_TYPE   = 'SCM_LGTM_MRP_P_EXC_ITEM_CLASS_CD'
                                                            AND  L.VALID_YN      = 'Y'
                                                            )
                        AND     S.FLAG    <> 'DEL'
                        -- [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜형식만 비교하게 변경 주석처리
						-- AND		S.ATTR_10 <> 'DEL_DML'
                        -- [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜형식만 비교하게 변경 개선로직
                        AND		ISNULL(S.ATTR_10,'') <> 'DEL_DML'
                        ------------------------------------------------------------
                        UNION ALL
                        --GR--------------------------------------------------------
                        --2025.12.23 [IT20250117A] 입고 이력 정보용 XIF_MRP_PO_WHIN_RESULT_R I/F 테이블이 MQ에서 SAP PO로 변경되면서 추출 로직 변경됨 Start                                    
                        SELECT    PLANT_ID                  AS PLANT_ID
                                , PO_NO                     AS PO_NO
                                , ITEM_ID                   AS ITEM_ID
                                , RESULT_TYPE               AS RESULT_TYPE
                                , SRCE_YYYYMM               AS SRCE_YYYYMM
                                , PLAN_YYYYMM               AS PLAN_YYYYMM
                                , QTY                       AS QTY
                                , MRP_VERSION_ID            AS MRP_VERSION_ID
                                , SUPPLIER_ID               AS SUPPLIER_ID
                                , SUPPLIER_NAME             AS SUPPLIER_NAME
                                , FLAG                      AS FLAG
                                , PROPOSAL_TYPE             AS PROPOSAL_TYPE
                        FROM (
                            SELECT    S.PLANT_CD                AS PLANT_ID
                                    , S.PO_NO                   AS PO_NO
                                    , S.ITEM_CD                 AS ITEM_ID
                                    , 'GR'                      AS RESULT_TYPE
                                    , SUBSTRING(S.GR_DT, 1, 6)  AS SRCE_YYYYMM
                                    , SUBSTRING(S.GR_DT, 1, 6)  AS PLAN_YYYYMM
                                    , S.GR_QTY                  AS QTY
                                    , @v_mrp_p_version_no       AS MRP_VERSION_ID
                                    , ''                        AS SUPPLIER_ID
                                    , ''                        AS SUPPLIER_NAME
                                    , ''                        AS FLAG
                                    , ''                        AS PROPOSAL_TYPE
                                    --PO_NO, PO_ITEM_NO가 구매기준 KEY이고 입고를 받을 시 DOC_NO가 채번이 된다
                                    --NERP도 데이터를 전송 시 PO_NO, PO_ITEM_NO, DOC_NO 기준으로 이미 전송된 것이 있을 경우제외 전송
                                    --당월이라면 PO_NO, PO_ITEM_NO, DOC_NO를 KEY로 해서 IF_SEQ가 마지막인 것을 사용
                                    , RNUM = ROW_NUMBER() OVER (PARTITION BY S.PO_NO, S.PO_ITEM_NO, S.DOC_NO ORDER BY S.IF_SEQ DESC)
                            FROM    XIF_MRP_PO_WHIN_RESULT_R_SN S WITH(NOLOCK)
                            WHERE   1=1
                            --2025.12.23 [IT20250117A] 입고 이력 정보용 XIF_MRP_PO_WHIN_RESULT_R I/F 테이블이 MQ에서 SAP PO로 변경되면서 추출 로직 변경됨 Start
                            --AND     SUBSTRING(S.ACCUM_DATE,1,8)    = ( SELECT  MAX(SUBSTRING(ACCUM_DATE,1,8))
                            --                                            FROM    XIF_MRP_PO_WHIN_RESULT_R_SN WITH(NOLOCK)
                            --                                            WHERE   1=1
                            --                                            AND     IF_RCV_DATE    >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
                            --                                            AND     IF_RCV_DATE     < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
                            --                                            )
                            AND     S.GR_DT         >= @v_basis_yyyymmdd
                            --2025.12.23 [IT20250117A] 입고 이력 정보용 XIF_MRP_PO_WHIN_RESULT_R I/F 테이블이 MQ에서 SAP PO로 변경되면서 추출 로직 변경됨 End
                            AND     S.GR_DT         < @v_result_yyyymmdd
                        ) S
                        WHERE RNUM = 1
                        --2025.12.23 [IT20250117A] 입고 이력 정보용 XIF_MRP_PO_WHIN_RESULT_R I/F 테이블이 MQ에서 SAP PO로 변경되면서 추출 로직 변경됨 End                                    
                    ) MM
            GROUP BY  MM.PLANT_ID
                    , MM.PO_NO
                    , MM.ITEM_ID
                    , MM.RESULT_TYPE
                    , MM.SRCE_YYYYMM
                    , MM.PLAN_YYYYMM
            ;
        END


        ------------------------------------------------------------------------
        PRINT 'Start Calculate Duplicated Data for MRP vs ERP Intransit';
        ------------------------------------------------------------------------
        -- Step 5. Calculate Duplicated Data for MRP vs ERP Intransit
        ------------------------------------------------------------------------
        BEGIN
            SELECT  PLANT_ID, PO_NO, ITEM_ID, SUM(INTRANSIT_QTY) AS INT_QTY, SUM(MRP_QTY) AS MRP_QTY
                    , CASE WHEN SUM(MRP_QTY) < 0 THEN SUM(MRP_QTY) ELSE IIF(SUM(MRP_QTY - INTRANSIT_QTY)<0, 0, SUM(MRP_QTY - INTRANSIT_QTY)) END AS ADDITIONAL_QTY
            INTO #TEMP_INTRANSIT_QTY
            FROM (  -- Ending Stock Intransit ---------
                    SELECT    B.PLANT_ID            AS PLANT_ID
                            , B.PURCHASE_PO         AS PO_NO
                            , B.ITEM_ID             AS ITEM_ID
                            , B.YYYYMM              AS YYYYMM
                            , B.QUANTITY            AS INTRANSIT_QTY
                            , 0                     AS MRP_QTY
                    FROM    SCP_ANL_MONTH_END_STOCK_R B WITH(NOLOCK)
                    LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  B.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE  1=1
                    AND B.YYYYMM                = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_base_yyyymm, '01'))),112),1,6)
                     -- [E20260211-001073] MRP 수신정보 버전체계 변경 주석처리
                    --AND    B.STORAGE_LOCATION   = N'미착'
                     -- [E20260211-001073] MRP 수신정보 버전체계 변경 로직 수정.
                    AND    B.STORAGE_LOCATION   in (N'미착', N'In-T')
                    AND     CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                 WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                 ELSE D.ITEM_TYPE
                                  END = N'원부자재'
                    -----------------------------------------------------
                    UNION ALL
                    -- MRP Data ----------------------
                    SELECT  T.PLANT_ID, T.PO_NO, T.ITEM_ID, T.PLAN_YYYYMM, 0 AS INTRANSIT_QTY, SUM(QTY) AS MRP_QTY
                    FROM    #TEMP_MRP_PLAN T WITH(NOLOCK)
                    WHERE   T.RESULT_TYPE IN ('GR', 'In-Transit')
                    GROUP BY T.PLANT_ID, T.PO_NO, T.ITEM_ID, T.PLAN_YYYYMM
                    ) MM
            WHERE 1=1
            GROUP BY PLANT_ID, PO_NO, ITEM_ID
            ;
        END


        BEGIN
        ------------------------------------------------------------------------
        PRINT 'Start Insert Data';
        ------------------------------------------------------------------------
        -- Step 6. Insert MRP P
        ------------------------------------------------------------------------
            INSERT INTO SCM_LGTM_MRP_P_RESULT
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,VERSION_NO
                    ,PLANT_ID
                    ,ITEM_ID
                    ,ITEM_NAME
                    ,RESULT_DATE
                    ,RESULT_TYPE_NAME
                    ,PO_NO
                    ,RESULT_QUANTITY
                    ,SUPPLIER_ID
                    ,SUPPLIER_NAME
                    ,FLAG
                    ,PROPOSAL_TYPE
                    ,PSI_ORD
                    ,COMPANY_ID
                    )
            SELECT   'LGTM_MRP_P'                           AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd                 AS PLAN_START_YYYYMMDD
                    ,MRPP.VERSION_NO                        AS VERSION_NO
                    ,MRPP.PLANT_ID                          AS PLANT_ID
                    ,MRPP.ITEM_ID                           AS ITEM_ID
                    ,MAX(SIM.ITEM_NAME)                     AS ITEM_NAME
                    ,MRPP.PLAN_YYYYMM                       AS RESULT_DATE
                    ,MRPP.RESULT_TYPE                       AS RESULT_TYPE_NAME
                    ,ISNULL(MRPP.PO_NO, '*')                AS PO_NO
                    ,SUM(IIF(MRPP.R_NUM=1, MRPP.QTY, 0))    AS RESULT_QUANTITY
                    ,MAX(MRPP.SUPPLIER_ID)                  AS SUPPLIER_ID
                    ,MAX(MRPP.SUPPLIER_NAME)                AS SUPPLIER_NAME
                    ,MAX(MRPP.FLAG)                         AS FLAG
                    ,MAX(MRPP.PROPOSAL_TYPE)                AS PROPOSAL_TYPE
                    ,99                                     AS PSI_ORD
                    ,SMS.COMPANY_ID                         AS COMPANY_ID
            FROM    (   ---< Origin MRP except intransit>---------------------------------------
                        SELECT      PLANT_ID
                                , ITEM_ID
                                , PLAN_YYYYMM
                                , QTY
                                , PO_NO
                                , RESULT_TYPE
                                , VERSION_NO
                                , SUPPLIER_ID
                                , SUPPLIER_NAME
                                , FLAG
                                , PROPOSAL_TYPE
                                , 1 AS R_NUM
                        FROM    #TEMP_MRP_PLAN MRP WITH(NOLOCK)
                        WHERE   1=1
                        AND     MRP.RESULT_TYPE IN ('Proposal', 'Open PO', 'Requirement')
                        AND     MRP.PLAN_YYYYMM >= @v_base_yyyymm
                        AND     MRP.ITEM_ID     NOT LIKE 'AC%'
                        -------------------------------------------------------------------------
                        UNION ALL
                        ---< Re-Calculated intransit>--------------------------------------------
                        SELECT    MRP.PLANT_ID
                                , MRP.ITEM_ID
                                , MIN(MRP.PLAN_YYYYMM) AS RSN_DT
                                , ISNULL(MAX(TMP.ADDITIONAL_QTY), 0) AS RSN_QTY
                                , MRP.PO_NO
                                , MRP.RESULT_TYPE
                                , MRP.VERSION_NO
                                , MAX(MRP.SUPPLIER_ID)      AS SUPPLIER_ID
                                , MAX(MRP.SUPPLIER_NAME)    AS SUPPLIER_NAME
                                , MAX(MRP.FLAG)             AS FLAG
                                , MAX(MRP.PROPOSAL_TYPE)    AS PROPOSAL_TYPE
                                , ROW_NUMBER()OVER(PARTITION BY MRP.PLANT_ID, MRP.ITEM_ID, MRP.PO_NO, MRP.VERSION_NO
                                                    ORDER BY MRP.RESULT_TYPE) AS R_NUM
                        FROM    #TEMP_MRP_PLAN MRP WITH(NOLOCK)
                                    LEFT OUTER JOIN #TEMP_INTRANSIT_QTY TMP
                                    ON  TMP.PLANT_ID    = MRP.PLANT_ID
                                    AND TMP.ITEM_ID     = MRP.ITEM_ID
                                    AND TMP.PO_NO       = MRP.PO_NO
                        WHERE   1=1
                        AND MRP.RESULT_TYPE IN ('In-transit', 'GR')
                        AND MRP.PLAN_YYYYMM >= @v_base_yyyymm
                        AND MRP.ITEM_ID     NOT LIKE 'AC%'
                        GROUP BY MRP.PLANT_ID, MRP.ITEM_ID, MRP.PO_NO, MRP.VERSION_NO, MRP.RESULT_TYPE
                    ) MRPP
                    LEFT OUTER JOIN (   SELECT  PLANT_ID, MAX(COMPANY_ID) AS COMPANY_ID, MAX(DIVISION_ID) AS DIVISION_ID
                                        FROM    SCM_MST_SITE SM WITH(NOLOCK)
                                        WHERE   1=1
                                        AND     SM.SITE_TYPE   = 'PLANT'
                                        GROUP BY PLANT_ID ) SMS
                        ON  SMS.PLANT_ID    = MRPP.PLANT_ID
                    LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
                        ON  SIM.DIVISION_ID = SMS.DIVISION_ID
                        AND SIM.COMPANY_ID  = SMS.COMPANY_ID
                        AND SIM.ITEM_ID     = MRPP.ITEM_ID
                    LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M STCM WITH(NOLOCK)
                        ON  STCM.CLASS_ID   = SIM.ITEM_CLASS
                    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                        ON      L.LOOKUP_TYPE   = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                        AND     L.VALID_YN      = 'Y'
                        AND     L.SEGMENT1      = SIM.ITEM_CLASS
            WHERE   1=1
            AND     ISNULL(L.ATTRIBUTE2,'')    <> 'ELTR'
            AND     STCM.LEVEL_1_ID            != 'EW' -- 포장재 제외
            GROUP BY MRPP.PLANT_ID
                    ,MRPP.ITEM_ID
                    ,MRPP.PLAN_YYYYMM
                    ,MRPP.VERSION_NO
                    ,MRPP.PO_NO
                    ,MRPP.RESULT_TYPE
                    ,ISNULL(L.ATTRIBUTE2,'')
                    ,STCM.LEVEL_1_ID
                    ,SMS.DIVISION_ID
                    ,SMS.COMPANY_ID
                    ,SIM.ITEM_CLASS
        ------------------------------------------------------------------------
        END
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        PRINT 'Step 6 End';
        ------------------------------------------------------------------------

        IF OBJECT_ID (N'tempdb..#TEMP_INTRANSIT_QTY', N'U') IS NOT NULL DROP TABLE #TEMP_INTRANSIT_QTY;
        IF OBJECT_ID (N'tempdb..#TEMP_MRP_PLAN', N'U') IS NOT NULL      DROP TABLE #TEMP_MRP_PLAN;

        COMMIT TRANSACTION;
    END TRY

    ------------------------------------------------------------------------
    BEGIN CATCH
    ------------------------------------------------------------------------
    ROLLBACK TRANSACTION PR_SCM_LGTM_MRP_P_RESULT;
    ------------------------------------------------------------------------
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + '' + ERROR_MESSAGE();
    ------------------------------------------------------------------------
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ------------------------------------------------------------------------
    END CATCH
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ------------------------------------------------------------------------
  END;

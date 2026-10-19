



CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_RMTL_YMH_20250722]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
	,@p_chg_plan_start_yyyymmdd     NVARCHAR(8)
	,@p_mrp_version_id             NVARCHAR(30)
AS 
BEGIN

-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_OIJ 'RMTL', '40', '20250303', '202503', '20250303', 'MRP-SCP-20250304-001'


    --2024.10.23 Philsu Park: SRCE_YYYYMM 반영 버전.
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
--jjg	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_RMTL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = @p_plan_tp_cd + '=>'+@p_division_id;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  

    ------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @v_plan_tp_cd           NVARCHAR(20)    = @p_plan_tp_cd;            -- 'RMTL';
    DECLARE @v_division_id          NVARCHAR(10)    = @p_division_id            -- '82';
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = @p_basis_yyyymm           -- '202407';'
    DECLARE @v_basis_yyyymmdd       NVARCHAR(8)     = CONCAT(@v_basis_yyyymm, '01')           -- '202407';'
    DECLARE @v_mrp_p_version_no     NVARCHAR(50);
    DECLARE @v_add_days             NUMERIC         = 16; -- 20250714 9->16
    DECLARE @v_plan_tp_org          NVARCHAR(10)    = SUBSTRING(@v_plan_tp_cd, 1, 4);
    DECLARE @v_result_yyyymmdd      NVARCHAR(8);
	DECLARE @v_chg_plan_start_yyyymmdd  NVARCHAR(8)     = @p_chg_plan_start_yyyymmdd    -- '20240701';
	DECLARE @v_mrp_version_id           NVARCHAR(30)    = @p_mrp_version_id;            -- 

    ------------------------------------------------------------------------  
		
	------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
--jjg	BEGIN TRANSACTION PR_SCM_LGTM_INV_ALLOCATION_RMTL;
	------------------------------------------------------------------------  
    PRINT 'Div.: '+@v_division_id+'//PST YMD: '+@v_plan_start_yyyymmdd+'//Basis YM: '+@v_basis_yyyymm;

	------------------------------------------------------------------------  
	BEGIN TRY

        IF OBJECT_ID (N'tempdb..#TEMP_ESS_ITEM', N'U') IS NOT NULL 		DROP TABLE #TEMP_ESS_ITEM;
        IF OBJECT_ID (N'tempdb..#TEMP_INTRANSIT_QTY', N'U') IS NOT NULL DROP TABLE #TEMP_INTRANSIT_QTY;
        IF OBJECT_ID (N'tempdb..#TEMP_MRP_PLAN', N'U') IS NOT NULL DROP TABLE #TEMP_MRP_PLAN;
        
		------------------------------------------------------------------------
		-- Step 1. Initialize Data
		------------------------------------------------------------------------
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-1. Delete SCM_LGTM_INV_PSI_SUMMARY_RMTL
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id          
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  

		
		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-2. Delete SCM_LGTM_INV_PSI_DETAIL_RMTL
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_DETAIL_RMTL
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id          
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  

        ------------------------------------------------------------------------
        -- 2024.10.21 Philsu Park: 테이블 이관 전으로 주석 처리.
        -- 2024.10.30 Philsu Park: 수량 검증 완료. 이관 준비.
        BEGIN
        ------------------------------------------------------------------------
            DELETE
            FROM    SCM_LGTM_MRP_P_RESULT
            WHERE   1=1
            AND     PLAN_TP_CD          = 'LGTM_MRP_P'
            AND     PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
        ------------------------------------------------------------------------
        END
        ------------------------------------------------------------------------

        BEGIN
            SELECT  @v_mrp_p_version_no = MAX(MRP_VERSION_ID)
                    , @v_result_yyyymmdd = SUBSTRING(MAX(MRP_VERSION_ID), 9, 8)
            FROM    XIF_MRP_BPS_MAT_PLAN_R_SN WITH(NOLOCK)
            WHERE   1=1
            --AND     IF_RCV_DATE >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)) 
            --AND     IF_RCV_DATE < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
            AND     MRP_VERSION_ID = @v_mrp_version_id --2025-02-10 OIJ  'MRP-SCP-20250101-001'
            ;
        END

		BEGIN
		------------------------------------------------------------------------
			UPDATE XIF_MRP_TB_RS_ITEM_CONSUM_R_SN
			SET		ATTRBT_4_VAL	    = 'P'
			WHERE   VRSN_ID				= @v_mrp_version_id
			AND     PLAN_TYP			= 'SCP'
			AND     BUCKET_TYP			= 'BUCKET_TYP_006'
			AND     ATTRBT_4_VAL	    = '*'
        ------------------------------------------------------------------------
		END

		
		------------------------------------------------------------------------  
        -- MRP P
        -- 2024.10.25 Philsu Park:  Incoterms가 F로 시작하는 경우, PLAN_YYYYMM은 출하월 기준으로 반영하며, SRCE_YYYYMM은 입고일 기준으로 반영
        --                          RESULT_DATE 값이 기준월 이전인 경우, 기준월로 반영해서 누락 케이스 방지.
        -- 2024.10.25 Philsu Park:  입고실적(GR)은 MRP 버전 날짜 기준으로 해당 날짜 이전일까지의 실적만 활용.
        ------------------------------------------------------------------------  
        BEGIN
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
			--		, '*'						as company_id  --jjg 추가 20250323
            INTO    #TEMP_MRP_PLAN
            FROM    (   -------------------------
                        --MRP P------------------
                        SELECT    S.PLANT_ID            AS PLANT_ID
                                , S.PO_NO               AS PO_NO
                                , S.ITEM_ID             AS ITEM_ID
                                , S.RESULT_TYPE_NAME    AS RESULT_TYPE
                                , IIF(LEFT(ISNULL(ATTR_03, 'X'), 1) = 'F', SUBSTRING(ATTR_01, 1, 6), RESULT_DATE)   AS SRCE_YYYYMM
                                , IIF(S.RESULT_DATE < @v_basis_yyyymm, @v_basis_yyyymm, S.RESULT_DATE)              AS PLAN_YYYYMM
                                , S.RESULT_QUANTITY     AS QTY
                                , S.MRP_VERSION_ID      AS MRP_VERSION_ID
                                , S.SUPPLIER_ID         AS SUPPLIER_ID
                                , S.SUPPLIER_NAME       AS SUPPLIER_NAME
                                , S.FLAG                AS FLAG
                                , S.PROPOSAL_TYPE       AS PROPOSAL_TYPE
                        FROM    XIF_MRP_BPS_MAT_PLAN_R_SN S WITH(NOLOCK)
                        WHERE   1=1
                        AND     S.MRP_VERSION_ID       = @v_mrp_version_id --2025-02-10 OIJ 
															--(   --SELECT  MAX(MRP_VERSION_ID)
               --                                             --FROM    XIF_MRP_BPS_MAT_PLAN_R_SN WITH(NOLOCK)
               --                                             --WHERE   1=1
               --                                             --AND     IF_RCV_DATE >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)) 
               --                                             --AND     IF_RCV_DATE < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
               --                                             'MRP-SCP-20250101-001'
               --                                             )
                        AND     S.RESULT_TYPE_NAME   IN ('Proposal', 'In-Transit', 'Open PO', 'Requirement')
						------------------------------------------------------------------------------------------ 2025.02.12 OIJ
						AND    S.FLAG    <> 'DEL'
						AND    S.ATTR_10 <> 'DEL_DML'
						--AND		(S.FLAG <> 'Ovd Req' OR S.PLANT_ID <> 'WA00') --잠시이용 추후에는 삭제
						AND not (S.FLAG = 'Ovd Req' AND S.PLANT_ID = 'WA00')
						------------------------------------------------------------------------------------------
                        AND     S.ITEM_ID NOT IN (  SELECT  ITEM_ID
                                                    FROM    SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                                            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                            ON   L.SEGMENT1      = SIM.ITEM_CLASS
                                                            AND  L.LOOKUP_TYPE   = 'SCM_LGTM_MRP_P_EXC_ITEM_CLASS_CD'
                                                            AND  L.VALID_YN      = 'Y' 
													
                                                            )
						AND    ISNULL(S.PO_NO, '') NOT LIKE '99%' --20250306 OIJ
                        UNION ALL
                        -------------------------
                        --GR---------------------
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
                        FROM    XIF_MRP_PO_WHIN_RESULT_R_SN S WITH(NOLOCK)
                        WHERE   1=1
                        --AND     S.ACCUM_DATE    = ( SELECT  MAX(ACCUM_DATE)
                        AND     SUBSTRING(S.ACCUM_DATE,1,8)    = ( SELECT  MAX(SUBSTRING(ACCUM_DATE,1,8))
                                                                   FROM    XIF_MRP_PO_WHIN_RESULT_R_SN WITH(NOLOCK)
                                                                   WHERE   1=1
                                                                   AND     IF_RCV_DATE    >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)) 
                                                                   AND     IF_RCV_DATE     < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
                                                                  )
																  --20250306 OIJ START
						AND     S.ITEM_CD NOT IN (  SELECT  ITEM_ID
                                                    FROM    SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                                            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                            ON   L.SEGMENT1      = SIM.ITEM_CLASS
                                                            AND  L.LOOKUP_TYPE   = 'SCM_LGTM_MRP_P_EXC_ITEM_CLASS_CD'
                                                            AND  L.VALID_YN      = 'Y' 
                                                            )		
						AND    ISNULL(S.PO_NO, '') NOT LIKE '99%'	
						--20250306 OIJ END
                        AND     S.GR_DT         < @v_result_yyyymmdd
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
		-- Step 1. P Insert 시 Intransit 중복 제거를 위한 GR, MRP Intransit 수량 산출.
		------------------------------------------------------------------------   
        BEGIN
            SELECT  PLANT_ID, PO_NO, ITEM_ID, SUM(INTRANSIT_QTY) AS INT_QTY, SUM(MRP_QTY) AS MRP_QTY
                    , CASE WHEN SUM(MRP_QTY) < 0 THEN SUM(MRP_QTY) ELSE IIF(SUM(MRP_QTY - INTRANSIT_QTY)<0, 0, SUM(MRP_QTY - INTRANSIT_QTY)) END AS ADDITIONAL_QTY
            INTO #TEMP_INTRANSIT_QTY
            FROM (  ----------------------------------
                    -- Ending Stock Intransit Data ---
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
                    AND B.YYYYMM                = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    --AND    B.DIVISION_ID        = @v_division_id
                    AND    B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                    AND     CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                 WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                 ELSE D.ITEM_TYPE
                                  END = N'원부자재'
                    UNION ALL
                    ----------------------------------
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
		-- Step 2-1-2. Insert P from MRP PO
		------------------------------------------------------------------------  



            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,PLANT_ID
                    ,GROUP_CODE1
                    ,ITEM_ID
                    ,ORIGIN_ITEM_ID
                    ,SRCE_YYYYMM
                    ,PLAN_YYYYMM
                    ,QTY
                    ,CURRENCY
                    ,STANDARD_COST
                    ,AMT
                    ,SCM_SITE_ID
                    ,OPERATION_GROUP
                    ,OPERATION_ID
                    ,DEVALUATION_AGE
                    ,LONG_TERM_TYPE_CODE
                    ,LONG_TERM_TYPE
                    ,VERSION_NO
                    ,PROCESS_GROUP
                    ,PROCESS_DETAIL
					,company_id   -- jjg 20250323
					)
            SELECT   @p_plan_tp_cd                                  AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd                         AS PLAN_START_YYYYMMDD
                    ,'P'						                    AS DATA_TP_CD
                    ,'P_MRP_PO'						                AS SRCE_TP_CD
                    ,SMS.DIVISION_ID				                AS DIVISION_ID
                    ,MRPP.PLANT_ID                                  AS PLANT_ID
                    ,SIM.ITEM_CLASS			                        AS GROUP_CODE1
                    ,MRPP.ITEM_ID                                   AS ITEM_ID
                    ,MRPP.ITEM_ID					                AS ORIGIN_ITEM_ID
                    ,MRPP.SRCE_YYYYMM                               AS SRCE_YYYYMM
                    ,MRPP.PLAN_YYYYMM                               AS PLAN_YYYYMM
                    ,SUM(MRPP.QTY)       					        AS QTY
                    ,NULL					                        AS CURRENCY
                    ,NULL						                    AS COST
                    ,NULL							                AS AMT
                    ,NULL		                                    AS SCM_SITE_ID
                    ,NULL	                                        AS OPERATION_GROUP
                    ,NULL			                                AS OPERATION_ID
                    ,NULL						                    AS DEVALUATION_AGE
                    ,NULL						                    AS LONG_TERM_TYPE_CODE
                    ,NULL						                    AS LONG_TERM_TYPE
                    ,MRPP.VRSN_ID						            AS VERSION_NO
                    ,STCM.PROCESS_GROUP                             AS PROCESS_GROUP
                    ,STCM.PROCESS_DETAIL                            AS PROCESS_DETAIL
					,'*'											as company_id --jjg 20250323
            FROM    ( SELECT      PLANT_ID
                                , ITEM_ID
                                , SRCE_YYYYMM
                                , PLAN_YYYYMM
                                , QTY
                                , PO_NO
                                , @v_mrp_p_version_no AS VRSN_ID
                        FROM      #TEMP_MRP_PLAN MRP WITH(NOLOCK)
                        WHERE     1=1
                        AND     MRP.RESULT_TYPE IN ('Proposal', 'Open PO')
                        AND     MRP.PLAN_YYYYMM >= @v_basis_yyyymm
                        AND     MRP.ITEM_ID    NOT LIKE 'AC%'
                        UNION ALL
                        SELECT    MRP.PLANT_ID
                                , MRP.ITEM_ID
                                , MIN(MRP.PLAN_YYYYMM) AS SRCE_YYYYMM
                                , MIN(MRP.PLAN_YYYYMM) AS PLAN_YYYYMM
                                , ISNULL(MAX(TMP.ADDITIONAL_QTY), 0) AS RSN_QTY
                                , MRP.PO_NO
                                , @v_mrp_p_version_no AS VRSN_ID
                        FROM    #TEMP_MRP_PLAN MRP WITH(NOLOCK)
                        LEFT OUTER JOIN #TEMP_INTRANSIT_QTY TMP
                        ON  TMP.PLANT_ID    = MRP.PLANT_ID
                        AND TMP.ITEM_ID     = MRP.ITEM_ID
                        AND TMP.PO_NO       = MRP.PO_NO
                        WHERE   1=1
                        AND MRP.RESULT_TYPE IN ('In-transit', 'GR')
                        AND MRP.PLAN_YYYYMM >= @v_basis_yyyymm
                        AND MRP.ITEM_ID    NOT LIKE 'AC%'
                        GROUP BY MRP.PLANT_ID, MRP.ITEM_ID, MRP.PO_NO, MRP.VERSION_NO
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
            AND     SMS.DIVISION_ID             =   @v_division_id
            AND     ISNULL(L.ATTRIBUTE2,'')    <> 'ELTR'
            AND     STCM.LEVEL_1_ID            != 'EW' -- 포장재 제외
            GROUP BY SMS.DIVISION_ID
                    ,MRPP.PLANT_ID
                    ,SIM.ITEM_CLASS
                    ,MRPP.ITEM_ID
                    ,MRPP.SRCE_YYYYMM
                    ,MRPP.PLAN_YYYYMM
                    ,MRPP.VRSN_ID
                    ,STCM.PROCESS_GROUP
                    ,STCM.PROCESS_DETAIL 
		------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------



        --SCM_LGTM_MRP_P_RESULT: 2024.10.21 Philsu Park: 테이블 이관 전으로 주석처리.
        --2024.10.30 Philsu Park: 수량검증 완료. 주석 해제 및 이관 검토.
        BEGIN
        ------------------------------------------------------------------------
		-- Step 2-1-2. Insert P from MRP PO (임시처리)
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
					,company_id
                    )
            SELECT   'LGTM_MRP_P'                           AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd                 AS PLAN_START_YYYYMMDD
                    ,MRPP.VERSION_NO						AS VERSION_NO
                    ,MRPP.PLANT_ID                          AS PLANT_ID
                    ,MRPP.ITEM_ID                           AS ITEM_ID
                    ,MAX(SIM.ITEM_NAME)		                AS ITEM_NAME
                    ,MRPP.PLAN_YYYYMM                       AS RESULT_DATE
                    ,MRPP.RESULT_TYPE                       AS RESULT_TYPE_NAME
                    ,ISNULL(MRPP.PO_NO, '*')                AS PO_NO
                    ,SUM(IIF(MRPP.R_NUM=1, MRPP.QTY, 0))    AS RESULT_QUANTITY
                    ,MAX(MRPP.SUPPLIER_ID)					AS SUPPLIER_ID
                    ,MAX(MRPP.SUPPLIER_NAME)				AS SUPPLIER_NAME
                    ,MAX(MRPP.FLAG)		                    AS FLAG
                    ,MAX(MRPP.PROPOSAL_TYPE)	            AS PROPOSAL_TYPE
                    ,99                                     AS PSI_ORD
					,'*'									as company_id  --jjg 추가 20250323
            FROM    ( SELECT      PLANT_ID
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
                        FROM      #TEMP_MRP_PLAN MRP WITH(NOLOCK)
                        WHERE     1=1
                        AND     MRP.RESULT_TYPE IN ('Proposal', 'Open PO', 'Requirement')
                        AND     MRP.PLAN_YYYYMM >= @v_basis_yyyymm
                        AND     MRP.ITEM_ID    NOT LIKE 'AC%'
                        UNION ALL
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
                        AND MRP.PLAN_YYYYMM >= @v_basis_yyyymm
                        AND MRP.ITEM_ID    NOT LIKE 'AC%'
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
		------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------


		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 2-2. Insert S-Target from SCP-FINAL
        -- 2024.08.29 Philsu Park: 실적구간 포함 조건 추가를 위한 제약 제거. PLAN_SRC_TYP <> '*'
		------------------------------------------------------------------------  
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,PLANT_ID
                ,GROUP_CODE1
                ,ITEM_ID
                ,ORIGIN_ITEM_ID
                ,SRCE_YYYYMM
                ,PLAN_YYYYMM
                ,QTY
                ,CURRENCY
                ,STANDARD_COST
                ,AMT
                ,SCM_SITE_ID
                ,OPERATION_GROUP
                ,OPERATION_ID
                ,DEVALUATION_AGE
                ,LONG_TERM_TYPE_CODE
                ,LONG_TERM_TYPE
                ,VERSION_NO
                ,PROCESS_GROUP
                ,PROCESS_DETAIL 
				,company_id  --jjg 추가 20250323
				)
            SELECT   @p_plan_tp_cd                                  AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd                         AS PLAN_START_YYYYMMDD
                    ,'S'						                    AS DATA_TP_CD
                    ,'S_MRP'						                AS SRCE_TP_CD
                    ,SMS.DIVISION_ID				                AS DIVISION_ID
                    ,R.PLANT_CD                                     AS PLANT_ID
                    ,SIM.ITEM_CLASS			                        AS GROUP_CODE1
                    ,R.ITEM_CD                                      AS ITEM_ID
                    ,R.ITEM_CD					                    AS ORIGIN_ITEM_ID
                    ,R.CONSUM_YYYYMM	                            AS SRCE_YYYYMM
                    ,R.CONSUM_YYYYMM                                AS PLAN_YYYYMM
                    ,SUM(R.CONSUM_QTY)					            AS QTY	
                    ,NULL					                        AS CURRENCY
                    ,NULL						                    AS COST
                    ,NULL							                AS AMT
                    ,NULL		                                    AS SCM_SITE_ID
                    ,NULL	                                        AS OPERATION_GROUP
                    ,NULL			                                AS OPERATION_ID
                    ,NULL						                    AS DEVALUATION_AGE
                    ,NULL						                    AS LONG_TERM_TYPE_CODE
                    ,NULL						                    AS LONG_TERM_TYPE
                    ,R.VRSN_ID						                AS VERSION_NO
                    ,STCM.PROCESS_GROUP                             AS PROCESS_GROUP
                    ,STCM.PROCESS_DETAIL                            AS PROCESS_DETAIL
					, '*'											as company_id  --jjg 추가 20250323
            FROM    XIF_MRP_TB_RS_ITEM_CONSUM_R_SN R with(nolock)
            LEFT OUTER JOIN (   SELECT  PLANT_ID, MAX(COMPANY_ID) AS COMPANY_ID, MAX(DIVISION_ID) AS DIVISION_ID
                                FROM    SCM_MST_SITE SM WITH(NOLOCK)
                                WHERE   1=1
                                AND     SM.SITE_TYPE   = 'PLANT'  
                                GROUP BY PLANT_ID ) SMS  
                ON  SMS.PLANT_ID    = R.PLANT_CD
            LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
                ON  SIM.DIVISION_ID = SMS.DIVISION_ID
                AND SIM.COMPANY_ID  = SMS.COMPANY_ID
                AND SIM.ITEM_ID     = R.ITEM_CD
            LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M STCM WITH(NOLOCK)
                ON  STCM.CLASS_ID   = SIM.ITEM_CLASS
            WHERE   1=1
            AND     R.PLAN_TYP          = 'SCP'
            AND     R.BUCKET_TYP        = 'BUCKET_TYP_006'
            AND     R.ATTRBT_4_VAL      = 'P'
            --AND     R.PLAN_SRC_TYP     <> '*'
            --AND     R.VRSN_ID           = 'MRP-SCP-20240906-001'
            AND     R.VRSN_ID   = @v_mrp_version_id --2025-02-10 OIJ 
									--(  ---SELECT  MAX(VRSN_ID)
         --                           ---FROM    XIF_MRP_TB_RS_ITEM_CONSUM_R_SN R with(nolock)
         --                           ---WHERE   IF_RCV_DATE >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)) 
         --                           ---AND     IF_RCV_DATE < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
         --                           --AND     VRSN_ID = 'MRP-SCP-20240906-001'  -- 2024.08.29 Philsu Park: 임시로 하드코딩.
         --                           'MRP-SCP-20250101-001'
         --                           )
            AND     SMS.DIVISION_ID     = @v_division_id
            AND     STCM.ITEM_TYPE      = N'원부자재'
            AND     STCM.LEVEL_1_ID    != 'EW' -- 포장재 제외
            AND     R.CONSUM_YYYYMM    >= @v_basis_yyyymm
            AND     ( R.PROD_PLAN_CD <> '*'  OR ( R.PROD_PLAN_CD = '*' AND P_ITEM_CD = '*' ) )
            AND     R.ITEM_CD NOT IN (  SELECT  ITEM_ID
                                        FROM    SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                ON   L.SEGMENT1      = SIM.ITEM_CLASS
                                                AND  L.LOOKUP_TYPE   = 'SCM_LGTM_MRP_P_EXC_ITEM_CLASS_CD'
                                                AND  L.VALID_YN      = 'Y' 
                                                )
            GROUP BY SMS.DIVISION_ID
                    ,R.PLANT_CD
                    ,SIM.ITEM_CLASS
                    ,R.ITEM_CD
                    ,R.CONSUM_YYYYMM
                    ,R.VRSN_ID
                    ,STCM.PROCESS_GROUP
                    ,STCM.PROCESS_DETAIL
            ;
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------
        PRINT 'Step 2-2 End';

     

        ------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-3. Insert Raw Material Inventory.
        -- 2024.10.31   Philsu Park:    평가감을 장기재고 테이블에서 구분 반영 처리
        --                              대상: VALUATION_CLASS IN ('3004','3109','7909','7929')
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,PLANT_ID
                ,GROUP_CODE1
                ,ITEM_ID
                ,ORIGIN_ITEM_ID
                ,SRCE_YYYYMM
                ,PLAN_YYYYMM
                ,QTY
                ,CURRENCY
                ,STANDARD_COST
                ,AMT
                ,SCM_SITE_ID
                ,OPERATION_GROUP
                ,OPERATION_ID
                ,DEVALUATION_AGE
                ,LONG_TERM_TYPE_CODE
                ,LONG_TERM_TYPE
                ,VERSION_NO
                ,PROCESS_GROUP
                ,PROCESS_DETAIL
				,company_id  --jjg 추가 20250323
                )
			SELECT    @v_plan_tp_cd                             AS PLAN_TP_CD
                    , @v_plan_start_yyyymmdd                    AS PLAN_START_YYYYMMDD
                    , MM.DATA_TP_CD                             AS DATA_TP_CD
                    , MM.SRCE_TP_CD                             AS SRCE_TP_CD
                    , MM.DIVISION_ID                            AS DIVISION_ID
                    , MM.PLANT_ID                               AS PLANT_ID
                    , MM.GROUP_CODE1                            AS GROUP_CODE1
                    , MM.ITEM_ID                                AS ITEM_ID
                    , MM.ITEM_ID                                AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM                            AS SRCE_YYYYMM
                    , MM.YYYYMM                                 AS PLAN_YYYYMM
                    , SUM(MM.LONG_TERM_STOCK_QTY)               AS QTY 
                    , NULL                                      AS CURRENCY
                    , NULL                                      AS STANDARD_COST
                    , NULL                                      AS AMT
                    , NULL                                      AS SCM_SITE_ID
                    , NULL                                      AS OPERATION_GROUP
                    , NULL                                      AS OPERATION_ID
                    , NULL                                      AS DEVALUATION_AGE
                    , NULL                                      AS LONG_TERM_TYPE_CODE
                    , NULL                                      AS LONG_TERM_TYPE
                    , NULL                                      AS VERSION_NO
                    , MAX(PROCESS_GROUP)                        AS PROCESS_GROUP
                    , MAX(PROCESS_DETAIL)                       AS PROCESS_DETAIL
					, '*'										as company_id  --jjg 추가 20250323
            FROM ( 
                    SELECT  A.DIVISION_ID           AS DIVISION_ID
                            , 'RESULT'              AS DATA_TP_CD
                            , CASE WHEN A.VALUATION_CLASS IN ('3004','3109','7909','7929') THEN 'BOH_DEVL' ELSE 'BOH_RMTL' END AS SRCE_TP_CD
                            , A.PLANT_ID            AS PLANT_ID
                            , A.ITEM_ID             AS ITEM_ID
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   ELSE D.ITEM_TYPE        
                                    END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , D.CLASS_ID            AS GROUP_CODE1
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , A.LONG_TERM_STOCK_QTY AS LONG_TERM_STOCK_QTY
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            , A.YYYYMM              AS YYYYMM
                    FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                    LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE 1=1
                    AND A.YYYYMM        > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND A.YYYYMM       <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND A.DIVISION_ID   = @v_division_id
                    UNION ALL
                    SELECT  A.DIVISION_ID           AS DIVISION_ID
                            , 'BOH'                 AS DATA_TP_CD
                            , CASE WHEN A.VALUATION_CLASS IN ('3004','3109','7909','7929') THEN 'BOH_DEVL' ELSE 'BOH_RMTL' END AS SRCE_TP_CD
                            , A.PLANT_ID            AS PLANT_ID
                            , A.ITEM_ID             AS ITEM_ID
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   ELSE D.ITEM_TYPE        
                                    END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , D.CLASS_ID            AS GROUP_CODE1
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , A.LONG_TERM_STOCK_QTY AS LONG_TERM_STOCK_QTY
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS YYYYMM
                    FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                    LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE 1=1
                    AND A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND A.DIVISION_ID   = @v_division_id
                ) MM
            WHERE 1=1
            AND MM.ITEM_TYPE    = N'원부자재'
            GROUP BY  MM.DATA_TP_CD
                    , MM.SRCE_TP_CD
                    , MM.DIVISION_ID
                    , MM.PLANT_ID
                    , MM.GROUP_CODE1
                    , MM.ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-3 End';



         BEGIN
		------------------------------------------------------------------------
		-- Step 2-4. Insert Intransit from Ending Stock.
        -- Valuation Class: 7900만 있음. 24년 6월 마감재고 기준.
        -- 2024.08.20 Philsu Park: 미착 중복 발생 케이스가 많아 제외하는것으로 합의.
		------------------------------------------------------------------------  
			INSERT INTO dbo.SCM_LGTM_INV_PSI_SUMMARY_RMTL
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,PLANT_ID
                ,GROUP_CODE1
                ,ITEM_ID
                ,ORIGIN_ITEM_ID
                ,SRCE_YYYYMM
                ,PLAN_YYYYMM
                ,QTY
                ,CURRENCY
                ,STANDARD_COST
                ,AMT
                ,SCM_SITE_ID
                ,OPERATION_GROUP
                ,OPERATION_ID
                ,DEVALUATION_AGE
                ,LONG_TERM_TYPE_CODE
                ,LONG_TERM_TYPE
                ,VERSION_NO
                ,PROCESS_GROUP
                ,PROCESS_DETAIL
				,company_id  --jjg 추가 20250323
                )
			SELECT  @v_plan_tp_cd           AS PLAN_TP_CD 
                    , @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , MM.DATA_TP_CD             AS DATA_TP_CD
                    , 'BOH_INTS'                AS SRCE_TP_CD
                    , MM.DIVISION_ID            AS DIVISION_ID
                    , MM.PLANT_ID               AS PLANT_ID
                    , MM.GROUP_CODE1            AS GROUP_CODE1
                    , MM.ITEM_ID                AS ITEM_ID
                    , MM.ITEM_ID                AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM            AS SRCE_YYYYMM
                    , MM.YYYYMM                 AS PLAN_YYYYMM
                    , SUM(MM.QUANTITY)          AS QTY 
                    , NULL                      AS CURRENCY
                    , NULL                      AS STANDARD_COST
                    , NULL                      AS AMT
                    , NULL                      AS SCM_SITE_ID
                    , NULL                      AS OPERATION_GROUP
                    , NULL                      AS OPERATION_ID
                    , NULL                      AS DEVALUATION_AGE
                    , NULL                      AS LONG_TERM_TYPE_CODE
                    , NULL                      AS LONG_TERM_TYPE
                    , NULL                      AS VERSION_NO
                    , MAX(MM.PROCESS_GROUP)     AS PROCESS_GROUP
                    , MAX(MM.PROCESS_DETAIL)    AS PROCESS_DETAIL
					, '*'						as company_id  --jjg 추가 20250323
                FROM ( 
                        SELECT  B.DIVISION_ID           AS DIVISION_ID
                                , 'RESULT'              AS DATA_TP_CD
                                , B.PLANT_ID            AS PLANT_ID
                                , B.ITEM_ID             AS ITEM_ID
                                , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                , B.VALUATION_CLASS     AS VALUATION_CLASS
                                , B.QUANTITY            AS QUANTITY
                                , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                , D.CLASS_ID            AS GROUP_CODE1
                                , D.PROCESS_GROUP       AS PROCESS_GROUP
                                , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE        
                                        END             AS ITEM_TYPE
                                , B.YYYYMM              AS SRCE_YYYYMM
                                , B.YYYYMM              AS YYYYMM
                                -- , @v_basis_yyyymm       AS SRCE_YYYYMM
                                -- , @v_basis_yyyymm       AS YYYYMM
                        FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON  C.ITEM_CLASS = D.CLASS_ID
                        WHERE  1=1
                        AND     B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND    B.DIVISION_ID        = @v_division_id
                        AND    B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                        --and B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        --and    B.VALUATION_CLASS IN ('3109', '7909', '7929')
                        UNION ALL
                        SELECT  B.DIVISION_ID           AS DIVISION_ID
                                , 'BOH'                 AS DATA_TP_CD
                                , B.PLANT_ID            AS PLANT_ID
                                , B.ITEM_ID             AS ITEM_ID
                                , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                , B.VALUATION_CLASS     AS VALUATION_CLASS
                                , B.QUANTITY            AS QUANTITY
                                , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                , D.CLASS_ID            AS GROUP_CODE1
                                , D.PROCESS_GROUP       AS PROCESS_GROUP
                                , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE        
                                        END             AS ITEM_TYPE
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                                -- , @v_basis_yyyymm       AS SRCE_YYYYMM
                                -- , @v_basis_yyyymm       AS YYYYMM
                        FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON  C.ITEM_CLASS = D.CLASS_ID
                        WHERE  1=1
                        and B.YYYYMM                = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND    B.DIVISION_ID        = @v_division_id
                        AND    B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                        /* AND     B.YYYYMM           >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                        --and    B.VALUATION_CLASS IN ('3109', '7909', '7929')                        
                    ) MM
                WHERE 1=1
                AND ITEM_TYPE   = N'원부자재' 
                GROUP BY  MM.DATA_TP_CD
                        , MM.DIVISION_ID
                        , MM.PLANT_ID
                        , MM.GROUP_CODE1
                        , MM.ITEM_ID
                        , MM.SRCE_YYYYMM
                        , MM.YYYYMM
                ;
		------------------------------------------------------------------------  
		END 
		------------------------------------------------------------------------  
        PRINT 'Step 2-4 End';
        ------------------------------------------------------------------------  
 

        /* BEGIN
		------------------------------------------------------------------------
		-- Step 2-5. Insert 평가감 Semi-Product from Ending Stock.
        -- 평가감은 일단 Item Id 그대로 유지. 매핑 없음.
        -- 2024.10.31   Philsu Park:    평가감을 장기재고에서 반영하므로, 마감재고 평가감 가져오는 구문 주석처리.
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,PLANT_ID
                ,GROUP_CODE1
                ,ITEM_ID
                ,ORIGIN_ITEM_ID
                ,SRCE_YYYYMM
                ,PLAN_YYYYMM
                ,QTY
                ,CURRENCY
                ,STANDARD_COST
                ,AMT
                ,SCM_SITE_ID
                ,OPERATION_GROUP
                ,OPERATION_ID
                ,DEVALUATION_AGE
                ,LONG_TERM_TYPE_CODE
                ,LONG_TERM_TYPE
                ,VERSION_NO
                ,PROCESS_GROUP
                ,PROCESS_DETAIL
                )
			SELECT  @v_plan_tp_cd               AS PLAN_TP_CD 
                    , @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , MM.DATA_TP_CD             AS DATA_TP_CD
                    , 'BOH_DEVL'                AS SRCE_TP_CD
                    , MM.DIVISION_ID            AS DIVISION_ID
                    , MM.PLANT_ID               AS PLANT_ID
                    , MM.GROUP_CODE1            AS GROUP_CODE1
                    , MM.ITEM_ID                AS ITEM_ID
                    , MM.ITEM_ID                AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM            AS SRCE_YYYYMM
                    , MM.YYYYMM                 AS PLAN_YYYYMM
                    , SUM(MM.QUANTITY)          AS QTY 
                    , NULL                      AS CURRENCY
                    , NULL                      AS STANDARD_COST
                    , NULL                      AS AMT
                    , NULL                      AS SCM_SITE_ID
                    , NULL                      AS OPERATION_GROUP
                    , NULL                      AS OPERATION_ID
                    , NULL                      AS DEVALUATION_AGE
                    , NULL                      AS LONG_TERM_TYPE_CODE
                    , NULL                      AS LONG_TERM_TYPE
                    , NULL                      AS VERSION_NO
                    , MAX(MM.PROCESS_GROUP)     AS PROCESS_GROUP
                    , MAX(MM.PROCESS_DETAIL)    AS PROCESS_DETAIL
                FROM ( 
                        --평가감.
                        SELECT B.DIVISION_ID        AS DIVISION_ID
                            , 'RESULT'              AS DATA_TP_CD
                            , B.PLANT_ID            AS PLANT_ID
                            , B.ITEM_ID             AS ITEM_ID
                            , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                            , B.VALUATION_CLASS     AS VALUATION_CLASS
                            , B.QUANTITY            AS QUANTITY
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   ELSE D.ITEM_TYPE        
                                    END             AS ITEM_TYPE
                            , D.CLASS_ID            AS GROUP_CODE1
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , B.YYYYMM              AS SRCE_YYYYMM
                            , B.YYYYMM              AS YYYYMM
                            -- , SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) AS SRCE_YYYYMM
                            -- , @v_basis_yyyymm       AS YYYYMM
                        FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID   = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON  C.ITEM_CLASS = D.CLASS_ID
                        WHERE  1=1
                        AND     B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND     B.DIVISION_ID       = @v_division_id
                        and     B.VALUATION_CLASS  IN ('3109', '7909', '7929')  -- 3109: 상품/저장품 할 때 가져다 쓰고 완제품에서는 제외.
                        AND     B.STORAGE_LOCATION != N'미착'
                        --and B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        UNION ALL 
                        SELECT B.DIVISION_ID        AS DIVISION_ID
                            , 'BOH'                 AS DATA_TP_CD
                            , B.PLANT_ID            AS PLANT_ID
                            , B.ITEM_ID             AS ITEM_ID
                            , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                            , B.VALUATION_CLASS     AS VALUATION_CLASS
                            , B.QUANTITY            AS QUANTITY
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   ELSE D.ITEM_TYPE        
                                    END             AS ITEM_TYPE
                            , D.CLASS_ID            AS GROUP_CODE1
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , B.YYYYMM              AS SRCE_YYYYMM
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                            -- , SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) AS SRCE_YYYYMM
                            -- , @v_basis_yyyymm       AS YYYYMM
                        FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID   = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON  C.ITEM_CLASS = D.CLASS_ID
                        WHERE  1=1
                        AND     B.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND     B.DIVISION_ID       = @v_division_id
                        AND     B.VALUATION_CLASS  IN ('3109', '7909', '7929')  -- 3109: 상품/저장품 할 때 가져다 쓰고 완제품에서는 제외.
                        AND     B.STORAGE_LOCATION != N'미착'
                        /* AND     B.YYYYMM           >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                    ) MM
                WHERE 1=1
                AND   MM.ITEM_TYPE  = N'원부자재'
                GROUP BY  MM.DATA_TP_CD
                        , MM.DIVISION_ID
                        , MM.PLANT_ID
                        , MM.GROUP_CODE1
                        , MM.ITEM_ID
                        , MM.SRCE_YYYYMM
                        , MM.YYYYMM
                ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-5 End'; */
        ------------------------------------------------------------------------  

        BEGIN
        ------------------------------------------------------------------------
		-- Step 2-9. Insert 완제품 재고 소진계획. 
        -- 2024.09.12 Philsu Park: 장기재고 소진계획 신규 UI 기준 테이블(SCP_ANL_LGTM_INV_MGMT_PLAN)로 변경.
        -- 2024.10.18 Philsu Park: 소진계획은 PLAN_TP_CD값이 네자리인경우만 반영.
		------------------------------------------------------------------------  
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,PLANT_ID
                ,GROUP_CODE1
                ,ITEM_ID
                ,ORIGIN_ITEM_ID
                ,SRCE_YYYYMM
                ,PLAN_YYYYMM
                ,QTY
                ,CURRENCY
                ,STANDARD_COST
                ,AMT
                ,SCM_SITE_ID
                ,OPERATION_GROUP
                ,OPERATION_ID
                ,DEVALUATION_AGE
                ,LONG_TERM_TYPE_CODE
                ,LONG_TERM_TYPE
                ,VERSION_NO
				,company_id  --jjg 추가 20250323
				)
            SELECT    @v_plan_tp_cd             AS PLAN_TP_CD 
                    , @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , 'S'                       AS DATA_TP_CD
                    , 'S_EXHT'                  AS SRCE_TP_CD
                    , @v_division_id            AS DIVISION_ID
                    , INV.PLANT_ID              AS PLANT_ID
                    , '*'                       AS GROUP_CODE1
                    , INV.ITEM_ID               AS ITEM_ID
                    , INV.ITEM_ID               AS ORIGIN_ITEM_ID
                    , INV.PLAN_YYYYMM           AS SRCE_YYYYMM
                    , INV.PLAN_YYYYMM           AS PLAN_YYYYMM
                    , SUM(INV.QTY)              AS QTY
                    , 'KRW'                     AS CURRENCY
                    , NULL                      AS STANDARD_COST
                    , NULL                      AS AMT
                    , NULL                      AS SCM_SITE_ID
                    , NULL                      AS OPERATION_GROUP
                    , NULL                      AS OPERATION_ID
                    , NULL                      AS DEVALUATION_AGE
                    , NULL                      AS LONG_TERM_TYPE_CODE
                    , NULL                      AS LONG_TERM_TYPE
                    , NULL                      AS VERSION_NO
					, '*'						as company_id  --jjg 추가 20250323
            FROM SCP_ANL_LGTM_INV_MGMT_PLAN INV WITH(NOLOCK)
            WHERE   INV.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     INV.PLAN_TP_CD          = @v_plan_tp_cd
            AND     INV.DIVISION_ID         = @v_division_id
            AND     @v_plan_tp_cd           = @v_plan_tp_org
            GROUP BY  INV.DIVISION_ID
                    , INV.PLANT_ID
                    , INV.ITEM_ID
                    , INV.PLAN_YYYYMM
            ;
        ------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------  
        PRINT 'Step 2-6 S_EXHT End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------  


        BEGIN
        ------------------------------------------------------------------------
		-- Step 2-10. Insert 원재료 정책재고 입고/출고계획. 
		------------------------------------------------------------------------  
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,PLANT_ID
                    ,GROUP_CODE1
                    ,ITEM_ID
                    ,ORIGIN_ITEM_ID
                    ,SRCE_YYYYMM
                    ,PLAN_YYYYMM
                    ,QTY
                    ,CURRENCY
                    ,STANDARD_COST
                    ,AMT
                    ,SCM_SITE_ID
                    ,OPERATION_GROUP
                    ,OPERATION_ID
                    ,DEVALUATION_AGE
                    ,LONG_TERM_TYPE_CODE
                    ,LONG_TERM_TYPE
                    ,VERSION_NO
					,company_id  --jjg 추가 20250323
					)
            SELECT    @v_plan_tp_cd                     AS PLAN_TP_CD 
                    , @v_plan_start_yyyymmdd            AS PLAN_START_YYYYMMDD
                    , PINV.PLAN_TP_CD                   AS DATA_TP_CD
                    , CASE  WHEN PINV.PLAN_TP_CD = 'P' THEN 'P_PINV'
                            WHEN PINV.PLAN_TP_CD = 'S' THEN 'S_PINV' END AS SRCE_TP_CD
                    , @v_division_id                    AS DIVISION_ID
                    , PINV.PLANT_ID                     AS PLANT_ID
                    , '*'                               AS GROUP_CODE1
                    , PINV.ITEM_ID                      AS ITEM_ID
                    , PINV.ITEM_ID                      AS ORIGIN_ITEM_ID
                    , SUBSTRING(PINV.PLAN_YYYYMMDD,1,6) AS SRCE_YYYYMM
                    , SUBSTRING(PINV.PLAN_YYYYMMDD,1,6) AS PLAN_YYYYMM
                    , SUM(PINV.QTY)                     AS QTY
                    , 'KRW'                             AS CURRENCY
                    , NULL                              AS STANDARD_COST
                    , NULL                              AS AMT
                    , NULL                              AS SCM_SITE_ID
                    , NULL                              AS OPERATION_GROUP
                    , NULL                              AS OPERATION_ID
                    , NULL                              AS DEVALUATION_AGE
                    , NULL                              AS LONG_TERM_TYPE_CODE
                    , NULL                              AS LONG_TERM_TYPE
                    , NULL                              AS VERSION_NO
					, '*'								as company_id  --jjg 추가 20250323
            FROM    SCP_ANL_LGTM_PCY_INV_MGMT_PLAN PINV WITH(NOLOCK)
            WHERE   PINV.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     PINV.DIVISION_ID         = @v_division_id
            --AND     @v_plan_tp_cd            = @v_plan_tp_org
            GROUP BY  PINV.PLAN_TP_CD 
                    , PINV.DIVISION_ID
                    , PINV.PLANT_ID
                    , PINV.ITEM_ID
                    , SUBSTRING(PINV.PLAN_YYYYMMDD,1,6)     
        ------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------  
        PRINT 'Step 2-6 Policy INV End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------  


        PRINT 'Step 2-7 Exception Logic Start' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------
		-- Step 2-7. 원재료 중 상품에 해당하는 데이터 삭제 처리
        -- ERAD00029AA 예외처리.
		------------------------------------------------------------------------  
        BEGIN
            DELETE  S
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL S
            INNER JOIN (SELECT  ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                        FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                        GROUP BY ITEM_ID
                        ) ITM
                ON ITM.ITEM_ID = S.ITEM_ID
            INNER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                ON ITM.ITEM_CLASS = CLS.CLASS_ID
            WHERE   1=1
            AND     S.PLAN_TP_CD            = @v_plan_tp_cd
            AND     S.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
            AND     S.DIVISION_ID           = @v_division_id
            AND     CLS.PROCESS_DETAIL      = 'Metal'
            AND     S.ITEM_ID              != 'ERAD00029AA'
        END



		-- 20250714 ESS CHANGE 로직 제거.

        --PRINT 'Step 2-7 Exception Logic End' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        --PRINT 'ESS Change Start: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------  
		/*

		BEGIN
            --82사업부 전극 원자재 Item 추출
            WITH ITEM_M AS  (   SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                )
            SELECT  DISTINCT ITEM_ID
            INTO    #TEMP_ESS_ITEM
            FROM 
                (   ----------------------------------------------------
                    -- 장기재고 -----------------------------------------
                    SELECT  A.ITEM_ID             AS ITEM_ID
                    FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                    LEFT JOIN ITEM_M C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE   1=1
                    AND    A.DIVISION_ID    IN ('81', '82')
                    AND     CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                 WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                 ELSE D.ITEM_TYPE        
                                 END        = N'원부자재'
                    AND D.PROCESS_GROUP     = N'전극 원자재'
                    AND (   (A.YYYYMM       > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                            AND A.YYYYMM   <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                            )
                        OR A.YYYYMM         = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        )
                    UNION 
                    ----------------------------------------------------
                    -- 미착재고 -----------------------------------------
                    SELECT    B.ITEM_ID             AS ITEM_ID
                    FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                    LEFT JOIN ITEM_M C
                        ON  B.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE  1=1
                    -- AND     B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    -- AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND (   (B.YYYYMM       > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                            AND B.YYYYMM   <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                            )
                        OR B.YYYYMM         = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        )
                    AND     B.DIVISION_ID      IN ('81', '82')
                    AND     B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                    AND     D.PROCESS_GROUP     = N'전극 원자재'
                    AND     CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                 WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                 ELSE D.ITEM_TYPE        
                                  END           = N'원부자재'
                    UNION 
                    ----------------------------------------------------
                    -- 평가감재고 -----------------------------------------
                    SELECT    B.ITEM_ID             AS ITEM_ID
                    FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                    LEFT JOIN ITEM_M C
                        ON  B.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE  1=1
                    AND (   (B.YYYYMM       > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                            AND B.YYYYMM   <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                            )
                        OR B.YYYYMM         = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        )
                    -- AND     B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    -- AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND     B.DIVISION_ID      IN ('81', '82')
                    AND     B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                    AND     D.PROCESS_GROUP     = N'전극 원자재'
                    and     B.VALUATION_CLASS  IN ('3109', '7909', '7929')
                    AND     CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                 WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                 ELSE D.ITEM_TYPE        
                                  END           = N'원부자재'
                ) PLN
            WHERE   1=1
            ;

            ------------------------------------------------------------------------
            -- Step 2-9. 82의 ESS 삭제. 81로 보내야함
            ------------------------------------------------------------------------ 
            IF  @v_division_id IN ('81', '82')
            ------------------------------------------------------------------------
                BEGIN 
                
                    DELETE FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
                    WHERE   1=1
                    AND     PLAN_TP_CD          = @v_plan_tp_cd
                    AND     DIVISION_ID         = @v_division_id
                    AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
                    AND     SRCE_TP_CD       LIKE 'BOH%'
                    AND     ITEM_ID            IN ( SELECT ITEM_ID FROM #TEMP_ESS_ITEM )
                    ;
            ------------------------------------------------------------------------ 
                END
            ------------------------------------------------------------------------ 
		    END
            ------------------------------------------------------------------------  
            PRINT 'Step 2-9 End';
            ------------------------------------------------------------------------
		*/

		-- 20250714 ESS CHANGE 로직 제거.
        ------------------------------------------------------------------------  
		--BEGIN
		------------------------------------------------------------------------
		-- Step 2-10. 81의 ESS를 82의 P로 생성
        -- 2024.10.31   Philsu Park:    평가감 원천을 마감재고 -> 장기재고 기준으로 변경.
        --                              장기재고(재고 + 평가감) + 마감재고(미착) 으로 구분 반영.
		------------------------------------------------------------------------ 
		/*

            IF  @v_division_id = '81'
            ------------------------------------------------------------------------
                BEGIN 
                ------------------------------------------------------------------------
                    WITH ITEM_M AS  (   SELECT ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                        FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                        GROUP BY ITEM_ID
                                        )
                    INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                        (PLAN_TP_CD
                        ,PLAN_START_YYYYMMDD
                        ,DATA_TP_CD
                        ,SRCE_TP_CD
                        ,DIVISION_ID
                        ,PLANT_ID
                        ,GROUP_CODE1
                        ,ITEM_ID
                        ,ORIGIN_ITEM_ID
                        ,SRCE_YYYYMM
                        ,PLAN_YYYYMM
                        ,QTY
                        ,CURRENCY
                        ,STANDARD_COST
                        ,AMT
                        ,SCM_SITE_ID
                        ,OPERATION_GROUP
                        ,OPERATION_ID
                        ,DEVALUATION_AGE
                        ,LONG_TERM_TYPE_CODE
                        ,LONG_TERM_TYPE
                        ,VERSION_NO
                        ,PROCESS_GROUP
                        ,PROCESS_DETAIL
						,company_id  --jjg 추가 20250323
                        )
                    SELECT    @v_plan_tp_cd                 AS PLAN_TP_CD
                            , @v_plan_start_yyyymmdd        AS PLAN_START_YYYYMMDD
                            , MM.DATA_TP_CD                 AS DATA_TP_CD
                            , MM.SRCE_TP_CD                 AS SRCE_TP_CD
                            , MM.DIVISION_ID                AS DIVISION_ID
                            , MM.PLANT_ID                   AS PLANT_ID
                            , MM.GROUP_CODE1                AS GROUP_CODE1
                            , MM.ITEM_ID                    AS ITEM_ID
                            , MM.ITEM_ID                    AS ORIGIN_ITEM_ID
                            , MM.SRCE_YYYYMM                AS SRCE_YYYYMM
                            , MM.YYYYMM                     AS PLAN_YYYYMM
                            , SUM(MM.LONG_TERM_STOCK_QTY)   AS QTY 
                            , NULL                          AS CURRENCY
                            , NULL                          AS STANDARD_COST
                            , NULL                          AS AMT
                            , NULL                          AS SCM_SITE_ID
                            , NULL                          AS OPERATION_GROUP
                            , NULL                          AS OPERATION_ID
                            , NULL                          AS DEVALUATION_AGE
                            , NULL                          AS LONG_TERM_TYPE_CODE
                            , NULL                          AS LONG_TERM_TYPE
                            , MAX(CONV_FLAG)                AS VERSION_NO
                            , MAX(PROCESS_GROUP)            AS PROCESS_GROUP
                            , MAX(PROCESS_DETAIL)           AS PROCESS_DETAIL
							, '*'							as company_id  --jjg 추가 20250323
                    FROM (
                            SELECT  @v_division_id          AS DIVISION_ID
                                    , 'RESULT'              AS DATA_TP_CD
                                    , CASE WHEN A.VALUATION_CLASS IN ('3004','3109','7909','7929') THEN 'BOH_DEVL' ELSE 'BOH_RMTL' END AS SRCE_TP_CD
                                    , A.PLANT_ID            AS PLANT_ID
                                    , A.ITEM_ID             AS ITEM_ID
                                    , D.CLASS_ID            AS GROUP_CODE1
                                    , D.PROCESS_GROUP       AS PROCESS_GROUP
                                    , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                                    , A.LONG_TERM_STOCK_QTY AS LONG_TERM_STOCK_QTY
                                    , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                    , A.YYYYMM              AS YYYYMM
                                    , IIF(A.DIVISION_ID='82', 'Y', 'N') AS CONV_FLAG
                            FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                            LEFT JOIN ITEM_M C
                                ON  A.ITEM_ID = C.ITEM_ID
                            LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                                ON  C.ITEM_CLASS = D.CLASS_ID
                            WHERE   1=1
                            AND     A.YYYYMM        > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                            AND     A.YYYYMM       <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                            AND     A.DIVISION_ID  IN ('81', '82')
                            AND     D.PROCESS_GROUP = N'전극 원자재'
                            AND     CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                         WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                         ELSE D.ITEM_TYPE        
                                         END        = N'원부자재'
                            UNION ALL
                            SELECT  @v_division_id          AS DIVISION_ID
                                    , 'BOH'                 AS DATA_TP_CD
                                    , CASE WHEN A.VALUATION_CLASS IN ('3004','3109','7909','7929') THEN 'BOH_DEVL' ELSE 'BOH_RMTL' END AS SRCE_TP_CD
                                    , A.PLANT_ID            AS PLANT_ID
                                    , A.ITEM_ID             AS ITEM_ID
                                    , D.CLASS_ID            AS GROUP_CODE1
                                    , D.PROCESS_GROUP       AS PROCESS_GROUP
                                    , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                                    , A.LONG_TERM_STOCK_QTY AS LONG_TERM_STOCK_QTY
                                    , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                    , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS YYYYMM
                                    , IIF(A.DIVISION_ID='82', 'Y', 'N') AS CONV_FLAG
                                    --, A.PLANT_ID            AS PLANT_ID
                                    --, D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                    -- , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                    --         WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                    --         ELSE D.ITEM_TYPE        
                                    --             END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                            LEFT JOIN ITEM_M C
                                ON  A.ITEM_ID = C.ITEM_ID
                            LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                                ON  C.ITEM_CLASS = D.CLASS_ID
                            WHERE   1=1
                            AND     A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                            AND     A.DIVISION_ID  IN ('81', '82')
                            AND     D.PROCESS_GROUP = N'전극 원자재'
                            AND     CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                         WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                         ELSE D.ITEM_TYPE        
                                         END        = N'원부자재'
                            UNION ALL
                            SELECT  @v_division_id          AS DIVISION_ID
                                    , 'RESULT'              AS DATA_TP_CD
                                    --, IIF(B.STORAGE_LOCATION = N'미착', 'BOH_INTS', 'BOH_DEVL') AS SRCE_TP_CD
                                    , 'BOH_INTS'            AS SRCE_TP_CD
                                    , B.PLANT_ID            AS PLANT_ID
                                    , B.ITEM_ID             AS ITEM_ID
                                    , D.CLASS_ID            AS GROUP_CODE1
                                    , D.PROCESS_GROUP       AS PROCESS_GROUP
                                    , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                                    , B.QUANTITY            AS QUANTITY
                                    , B.YYYYMM              AS SRCE_YYYYMM
                                    , B.YYYYMM              AS YYYYMM
                                    , IIF(B.DIVISION_ID='82', 'Y', 'N') AS CONV_FLAG
                                    -- , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                    -- , B.VALUATION_CLASS     AS VALUATION_CLASS
                                    -- , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                    -- , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                    --     WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                    --     ELSE D.ITEM_TYPE        
                                    --         END             AS ITEM_TYPE
                            FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                            LEFT JOIN ITEM_M C
                                ON  B.ITEM_ID = C.ITEM_ID
                            LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                                ON  C.ITEM_CLASS = D.CLASS_ID
                            WHERE   1=1
                            AND     B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                            AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                            AND     B.DIVISION_ID      IN ('81', '82')
                            AND     B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                                    --OR (B.STORAGE_LOCATION != N'미착' AND B.VALUATION_CLASS  IN ('3109', '7909', '7929'))
                                    --)
                            AND     D.PROCESS_GROUP     = N'전극 원자재'
                            AND     CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                         WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                         ELSE D.ITEM_TYPE        
                                         END            = N'원부자재'
                            UNION ALL
                            SELECT  @v_division_id          AS DIVISION_ID
                                    , 'BOH'                 AS DATA_TP_CD
                                    --, IIF(B.STORAGE_LOCATION = N'미착', 'BOH_INTS', 'BOH_DEVL') AS SRCE_TP_CD
                                    , 'BOH_INTS'            AS SRCE_TP_CD
                                    , B.PLANT_ID            AS PLANT_ID
                                    , B.ITEM_ID             AS ITEM_ID
                                    , D.CLASS_ID            AS GROUP_CODE1
                                    , D.PROCESS_GROUP       AS PROCESS_GROUP
                                    , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                                    , B.QUANTITY            AS QUANTITY
                                    , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                    , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                                    , IIF(B.DIVISION_ID='82', 'Y', 'N') AS CONV_FLAG
                                    -- , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                    -- , B.VALUATION_CLASS     AS VALUATION_CLASS
                                    -- , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                    -- , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                    --     WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                    --     ELSE D.ITEM_TYPE        
                                    --         END             AS ITEM_TYPE
                            FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                            LEFT JOIN ITEM_M C
                                ON  B.ITEM_ID = C.ITEM_ID
                            LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                                ON  C.ITEM_CLASS = D.CLASS_ID
                            WHERE   1=1
                            and     B.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                            AND     B.DIVISION_ID      IN ('81', '82')
                            AND     B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                                    --OR (B.STORAGE_LOCATION != N'미착' AND B.VALUATION_CLASS  IN ('3109', '7909', '7929'))
                                    --)
                            AND     D.PROCESS_GROUP     = N'전극 원자재'
                            AND     CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                         WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                         ELSE D.ITEM_TYPE        
                                         END            = N'원부자재'
                        ) MM
                    WHERE 1=1
                    GROUP BY  MM.DATA_TP_CD
                            , MM.SRCE_TP_CD
                            , MM.DIVISION_ID
                            , MM.PLANT_ID
                            , MM.GROUP_CODE1
                            , MM.ITEM_ID
                            , MM.SRCE_YYYYMM
                            , MM.YYYYMM
                    ;
                    ------------------------------------------------------------------------ 
                END
                    ------------------------------------------------------------------------ 
            END
		*/
		------------------------------------------------------------------------  
        --PRINT 'ESS Change End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        --PRINT 'Step 2-10 End';
        ------------------------------------------------------------------------

        IF OBJECT_ID (N'tempdb..#TEMP_PROD_PLAN', N'U') IS NOT NULL     DROP TABLE #TEMP_PROD_PLAN;
        IF OBJECT_ID (N'tempdb..#TEMP_ESS_ITEM', N'U') IS NOT NULL 		DROP TABLE #TEMP_ESS_ITEM;
        IF OBJECT_ID (N'tempdb..#TEMP_INTRANSIT_QTY', N'U') IS NOT NULL DROP TABLE #TEMP_INTRANSIT_QTY;
        IF OBJECT_ID (N'tempdb..#TEMP_MRP_PLAN', N'U') IS NOT NULL      DROP TABLE #TEMP_MRP_PLAN;

--jjg		COMMIT TRANSACTION;
	END TRY

	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
--jjg	ROLLBACK TRANSACTION PR_SCM_LGTM_INV_ALLOCATION_RMTL;
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

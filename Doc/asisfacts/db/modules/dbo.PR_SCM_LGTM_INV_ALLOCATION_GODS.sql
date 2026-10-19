
/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION_GODS
 * Description  : 장기재고 관련 상품 PSI EOH 정보 형성
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 *                              최초 생성
 * 2026/02/26   YMH				[E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경.
 * 2026/04/27   YMH             [E20260210-000483] SCM Long-term stock Mgmt 로직 수정 요청
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_GODS]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
	,@p_chg_plan_start_yyyymmdd     NVARCHAR(8)
	,@p_mrp_version_id			NVARCHAR(20)
AS 
BEGIN

	-- exec PR_SCM_LGTM_INV_ALLOCATION_GODS_OIJ 'GODS', '40', '20250303', '202503', '20250303', 'MRP-SCP-20250304-001'

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_GODS';
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
    DECLARE @v_add_days             NUMERIC         = 8;
    DECLARE @v_plan_tp_org          NVARCHAR(20)    = SUBSTRING(@v_plan_tp_cd, 1, 4);
	DECLARE @v_chg_plan_start_yyyymmdd  NVARCHAR(8)     = @p_chg_plan_start_yyyymmdd    
	DECLARE @v_mrp_version_id           NVARCHAR(20)    = @p_mrp_version_id;           
    ------------------------------------------------------------------------  
		
	------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
--jjg	BEGIN TRANSACTION PR_SCM_LGTM_INV_ALLOCATION_RMTL;
	------------------------------------------------------------------------  
    PRINT 'Div.: '+@v_division_id+'//PST YMD: '+@v_plan_start_yyyymmdd+'//Basis YM: '+@v_basis_yyyymm;

	------------------------------------------------------------------------  
	BEGIN TRY
		------------------------------------------------------------------------
		-- Step 1. Initialize Data
		------------------------------------------------------------------------
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-1. Delete SCM_LGTM_INV_PSI_SUMMARY_GODS
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS
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
            FROM    SCM_LGTM_INV_PSI_DETAIL_GODS
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id          
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  


		/* BEGIN
        ------------------------------------------------------------------------
		-- Step 2-1-2. Insert P from MRP PO (임시처리)
		------------------------------------------------------------------------  
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
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
                    ,PROCESS_DETAIL )
            SELECT   @p_plan_tp_cd                                  AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd                         AS PLAN_START_YYYYMMDD
                    ,'P'						                    AS DATA_TP_CD
                    ,'P_MRP_PO'						                AS SRCE_TP_CD
                    ,SMS.DIVISION_ID				                AS DIVISION_ID
                    ,SIM.ITEM_CLASS			                        AS GROUP_CODE1
                    ,MRPP.ITEM_CD                                   AS ITEM_ID
                    ,MRPP.ITEM_CD					                AS ORIGIN_ITEM_ID
                    ,MRPP.RST_DT                                    AS SRCE_YYYYMM
                    ,MRPP.RST_DT                                    AS PLAN_YYYYMM
                    ,SUM(MRPP.RST_QTY)       					    AS QTY
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
            FROM    TEMP_SCM_LGTM_MRP_S_RESULT MRPP WITH(NOLOCK)
                    LEFT OUTER JOIN (   SELECT  PLANT_ID, MAX(COMPANY_ID) AS COMPANY_ID, MAX(DIVISION_ID) AS DIVISION_ID
                                        FROM    SCM_MST_SITE SM WITH(NOLOCK)
                                        WHERE   1=1
                                        AND     SM.SITE_TYPE   = 'PLANT'  
                                        GROUP BY PLANT_ID ) SMS
                        ON  SMS.PLANT_ID    = MRPP.PLANT_CD
                    LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
                        ON  SIM.DIVISION_ID = SMS.DIVISION_ID
                        AND SIM.COMPANY_ID  = SMS.COMPANY_ID
                        AND SIM.ITEM_ID     = MRPP.ITEM_CD
                    LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M STCM WITH(NOLOCK)
                        ON  STCM.CLASS_ID   = SIM.ITEM_CLASS  
                    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                        ON      L.LOOKUP_TYPE   = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                        AND     L.VALID_YN      = 'Y'
                        AND     L.SEGMENT1      = SIM.ITEM_CLASS  
            WHERE   1=1
            AND     SMS.DIVISION_ID             =   @v_division_id
            AND     ISNULL(L.ATTRIBUTE2,'')    <> 'ELTR'
            --AND     MRPP.RST_TYP_NM         <> 'Requirement'
            --AND     (    MRPP.RST_TYP_NM  =  'Open PO' 
            --        OR ( MRPP.RST_TYP_NM  =  'Proposal'  AND  ISNULL(FLAG,'') <> 'Ovd PO' AND ISNULL(PO_NO,'') <> 'Y' /*AND ISNULL(MRPP.PROPOSAL_TYP,'') NOT IN ( 'DSP','ROP')*/ )       
            --        )
            --AND     MRPP.VRSN_ID     IN (SELECT MAX(VRSN_ID)
            --                            FROM   TEMP_SCM_LGTM_MRP_S_RESULT MRP WITH(NOLOCK)) 
            AND     MRPP.VRSN_ID                = 'MRP-SCP-20240801-001'
            AND     MRPP.ITEM_CD              NOT LIKE 'AC%'
            AND     MRPP.RST_DT                >= @v_basis_yyyymm
            AND     STCM.LEVEL_1_ID    != 'EW' -- 포장재 제외
            GROUP BY SMS.DIVISION_ID
                    ,SIM.ITEM_CLASS
                    ,MRPP.ITEM_CD
                    ,MRPP.RST_DT
                    ,MRPP.VRSN_ID	
                    ,STCM.PROCESS_GROUP
                    ,STCM.PROCESS_DETAIL 
		------------------------------------------------------------------------  
        END */
        ------------------------------------------------------------------------

        
		
		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 2-2. Insert S-Target from SCP-FINAL
		------------------------------------------------------------------------  
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
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
				,COMPANY_ID
				,PLANT_ID
				)
            SELECT   @p_plan_tp_cd                                  AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd                         AS PLAN_START_YYYYMMDD
                    ,'S'						                    AS DATA_TP_CD
                    ,'S_MRP'						                AS SRCE_TP_CD
                    ,SMS.DIVISION_ID				                AS DIVISION_ID
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
                    -- [E20260211-001073] ymh MRP 수신정보 버전체계 변경관련 주석처리.
                    -- ,R.VRSN_ID						                AS VERSION_NO
                    -- [E20260211-001073] ymh MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경
                    ,@v_mrp_version_id                              AS VERSION_NO
                    ,STCM.PROCESS_GROUP                             AS PROCESS_GROUP
                    ,STCM.PROCESS_DETAIL                            AS PROCESS_DETAIL
					,'*'											AS COMPANY_ID
					,'*'											AS PLANT_ID
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
            AND     R.ATTRBT_4_VAL  = 'S'
            -- [E20260211-001073] ymh MRP 수신정보 버전체계 변경관련 주석처리.
            -- AND     R.BUCKET_TYP    = 'BUCKET_TYP_006'
            AND     R.BASE_UOM     <> 'CELL'
            -- [E20260211-001073] ymh MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경관련 기존로직 주석처리.
            --AND     R.VRSN_ID			= @v_mrp_version_id			--2025-02-10 OIJ
            -- [E20260211-001073] ymh MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경
            AND   R.VRSN_ID			LIKE @v_mrp_version_id + '%'
									--IN (  ---SELECT  MAX(VRSN_ID)
         --                           ---FROM    XIF_MRP_TB_RS_ITEM_CONSUM_R_SN R with(nolock)
         --                           ---WHERE   IF_RCV_DATE >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)) 
         --                           ---AND     IF_RCV_DATE < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
         --                           ---AND     VRSN_ID = 'MRP-SCP-20240801-001'  -- 임시.
         --                           'MRP-SCP-20250101-001'
         --                           )
            AND     SMS.DIVISION_ID     = @v_division_id
            AND     R.CONSUM_YYYYMM    >= @v_basis_yyyymm
            -- AND     STCM.ITEM_TYPE      = N'원부자재'
            -- AND     STCM.LEVEL_1_ID    != 'EW' -- 포장재 제외
            /* AND     R.PLAN_TYP          = 'SCP'
            AND     R.BUCKET_TYP        = 'BUCKET_TYP_006'
            AND     R.ATTRBT_4_VAL      = 'P'
            AND     R.PLAN_SRC_TYP     <> '*' */
            GROUP BY SMS.DIVISION_ID
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
		-- Step 2-3. Insert S from RTF
        -- 주차 내 가장 최신 Cutoff 된 MF_W 의 RTF 수량을 사용
        -- 상품은 ITEM_ID 의 Length가 12자리 미만, 전극 ITEM Class에 해당하지 않는 대상.
        -- 2024.08.29 Philsu Park: Plan Start 기준 계획월의 실적구간은 실적에서 가져옴.
		------------------------------------------------------------------------  
            WITH S_RTF AS ( SELECT  S.DIVISION_ID
                                    , 'S_RTF' AS SRCE_TP_CD
                                    , S.ITEM_ID
                                    , S.YYYYMMDD
                                    , S.QTY
                                    , S.SCM_SITE_ID
                                    , S.VERSION_NO
                            FROM	DM_PLN_MKT_FCST_C S WITH(NOLOCK)
                            WHERE  1=1
                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청, 기존 로직 주석처리
                            --AND    S.CUTOFF_TYPE    = 'MF_W'
                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청 수정로직 
                            AND    S.CUTOFF_TYPE    = CASE WHEN @v_division_id = '40' THEN 'SF_W' ELSE 'MF_W' END
                            AND    S.MEASURE       IN ('RTF_SYS_RP')
                            AND    ( S.DIVISION_ID +  S.VERSION_NO ) IN (   SELECT V.DIVISION_ID + MAX(VERSION_NO)
                                                                            FROM   DM_MST_VERSION V WITH(NOLOCK)
                                                                                ,(SELECT CAL2.BASIS_YYYYMMDD
                                                                                    FROM   SCM_SYS_CALENDAR_M CAL1  WITH(NOLOCK) 
                                                                                        ,SCM_SYS_CALENDAR_M CAL2  WITH(NOLOCK) 
                                                                                    WHERE  1=1
                                                                                    AND    CAL1.ISO_YYYYWW      = CAL2.ISO_YYYYWW
                                                                                    AND    CAL1.BASIS_YYYYMMDD  = @v_plan_start_yyyymmdd
                                                                                    ) CAL
                                                                            WHERE  1=1
                                                                            AND    V.YYYYMMDD       = CAL.BASIS_YYYYMMDD
                                                                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청, 기존 로직 주석처리
                                                                            --AND    V.VERSION_TYPE   = 'MF_W'
                                                                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청 수정로직 
                                                                            AND    V.VERSION_TYPE   = CASE WHEN @v_division_id = '40' THEN 'SF_W' ELSE 'MF_W' END
                                                                            AND    V.DIVISION_ID    LIKE CONCAT(@v_division_id, '%')
                                                                            GROUP BY V.DIVISION_ID)
                            AND     S.YYYYMMDD     >= @v_basis_yyyymmdd
                            AND     S.YYYYMMDD      < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
                            AND     LEN(S.ITEM_ID)  < 12
                            UNION ALL
                            SELECT  S.DIVISION_ID
                                    , 'S_RTF' AS SRCE_TP_CD
                                    , S.ITEM_ID
                                    , S.YYYYMMDD
                                    , S.QTY
                                    , S.SCM_SITE_ID
                                    , S.VERSION_NO
                            FROM	DM_PLN_MKT_FCST_RESULT_C   S WITH(NOLOCK)
                            WHERE  1=1
                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청, 기존 로직 주석처리
                            --AND    S.CUTOFF_TYPE    = 'MF_W'
                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청 수정로직 
                            AND    S.CUTOFF_TYPE    = CASE WHEN @v_division_id = '40' THEN 'SF_W' ELSE 'MF_W' END
                            AND    S.MEASURE       IN ('RTF_SYS_RP')
                            AND    ( S.DIVISION_ID +  S.VERSION_NO ) IN (   SELECT V.DIVISION_ID + MAX(VERSION_NO)
                                                                            FROM   DM_MST_VERSION V WITH(NOLOCK)
                                                                                ,(SELECT CAL2.BASIS_YYYYMMDD
                                                                                    FROM   SCM_SYS_CALENDAR_M CAL1  WITH(NOLOCK) 
                                                                                        ,SCM_SYS_CALENDAR_M CAL2  WITH(NOLOCK) 
                                                                                    WHERE  1=1
                                                                                    AND    CAL1.ISO_YYYYWW      = CAL2.ISO_YYYYWW
                                                                                    AND    CAL1.BASIS_YYYYMMDD  = @v_plan_start_yyyymmdd
                                                                                    ) CAL
                                                                            WHERE  1=1
                                                                            AND    V.YYYYMMDD       = CAL.BASIS_YYYYMMDD
                                                                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청, 기존 로직 주석처리
                                                                            -- AND    V.VERSION_TYPE   = 'MF_W'
                                                                            -- E20260210-000483 SCM Long-term stock Mgmt 로직 수정 요청 수정로직 
                                                                            AND    V.VERSION_TYPE   = CASE WHEN @v_division_id = '40' THEN 'SF_W' ELSE 'MF_W' END
                                                                            AND    V.DIVISION_ID    LIKE CONCAT(@v_division_id, '%')
                                                                            GROUP BY V.DIVISION_ID)
                            AND     S.YYYYMMDD     >= @v_basis_yyyymmdd
                            AND     S.YYYYMMDD      < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
                            AND     LEN(S.ITEM_ID)  < 12
                            )
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
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
				,COMPANY_ID
				,PLANT_ID				
				)
            SELECT   @v_plan_tp_cd              AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd     AS PLAN_START_YYYYMMDD
                    ,'S'						AS DATA_TP_CD
                    ,S.SRCE_TP_CD				AS SRCE_TP_CD
                    ,S.DIVISION_ID              AS DIVISION_ID
                    ,ITM.ITEM_CLASS             AS GROUP_CODE1
                    ,S.ITEM_ID					AS ITEM_ID
                    ,S.ITEM_ID					AS ORIGIN_ITEM_ID
                    ,SUBSTRING(S.YYYYMMDD,1,6)	AS SRCE_YYYYMM
                    ,SUBSTRING(S.YYYYMMDD,1,6)	AS PLAN_YYYYMM
                    ,SUM(S.QTY)					AS QTY
                    ,NULL						AS CURRENCY
                    ,NULL						AS STANDARD_COST
                    ,NULL						AS AMT
                    ,NULL						AS SCM_SITE_ID
                    ,NULL						AS OPERATION_GROUP
                    ,NULL						AS OPERATION_ID
                    ,NULL						AS DEVALUATION_AGE
                    ,NULL						AS LONG_TERM_TYPE_CODE
                    ,NULL						AS LONG_TERM_TYPE
                    ,S.VERSION_NO				AS VERSION_NO
                    ,MAX(CLS.PROCESS_GROUP)     AS PROCESS_GROUP
                    ,MAX(CLS.PROCESS_DETAIL)    AS PROCESS_DETAIL
					,'*'											AS COMPANY_ID
					,'*'											AS PLANT_ID
            FROM	S_RTF           S WITH(NOLOCK)
            INNER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                ON  SMS.DIVISION_ID = S.DIVISION_ID
                AND SMS.SCM_SITE_ID = S.SCM_SITE_ID
            LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                GROUP BY DIVISION_ID, ITEM_ID
                            ) ITM
                ON  ITM.DIVISION_ID = S.DIVISION_ID
                AND ITM.ITEM_ID     = S.ITEM_ID
            LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                ON  CLS.CLASS_ID    = ITM.ITEM_CLASS
            WHERE  1=1
            AND     ITM.ITEM_CLASS NOT IN ( SELECT  LK.SEGMENT1 
                                            FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                            WHERE   1=1
                                            AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                                            AND     LK.VALID_YN     = 'Y'
                                            )
            GROUP BY S.SRCE_TP_CD
                    ,S.DIVISION_ID
                    ,S.ITEM_ID
                    ,ITM.ITEM_CLASS
                    ,SUBSTRING(S.YYYYMMDD,1,6)
                    ,S.VERSION_NO
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-3 End';

  

        ------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-3. Insert Raw Material Inventory.
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
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
				,COMPANY_ID
				,PLANT_ID
                )
			SELECT    @v_plan_tp_cd                             AS PLAN_TP_CD
                    , @v_plan_start_yyyymmdd                    AS PLAN_START_YYYYMMDD
                    , MM.DATA_TP_CD                             AS DATA_TP_CD
                    --, 'BOH_GODS'                                AS SRCE_TP_CD
                    , MM.BOH_TYPE                               AS SRCE_TP_CD
                    , MM.DIVISION_ID                            AS DIVISION_ID
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
					,'*'										AS COMPANY_ID
					,'*'										AS PLANT_ID
            FROM ( 
                    SELECT  A.DIVISION_ID           AS DIVISION_ID
                            , 'RESULT'              AS DATA_TP_CD
                            , A.PLANT_ID            AS PLANT_ID
                            , A.ITEM_ID             AS ITEM_ID
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
                                   WHEN ISNULL(C.ITEM_ID, '') = '' THEN N'상품'
                                   ELSE D.ITEM_TYPE        
                                    END                 AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , ISNULL(D.CLASS_ID, '-')   AS GROUP_CODE1
                            , D.PROCESS_GROUP           AS PROCESS_GROUP
                            , D.PROCESS_DETAIL          AS PROCESS_DETAIL
                            , A.LONG_TERM_STOCK_QTY     AS LONG_TERM_STOCK_QTY
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            , A.YYYYMM                  AS YYYYMM
                            -- , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            -- , @v_basis_yyyymm       AS YYYYMM
                            , CASE WHEN A.VALUATION_CLASS in ( '3004','3109','7909','7929' ) THEN 'BOH_DEVL' ELSE 'BOH_GODS' END AS BOH_TYPE
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
                    --AND A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND A.DIVISION_ID   = @v_division_id
                    UNION ALL
                    SELECT  A.DIVISION_ID           AS DIVISION_ID
                            , 'BOH'                 AS DATA_TP_CD
                            , A.PLANT_ID            AS PLANT_ID
                            , A.ITEM_ID             AS ITEM_ID
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
                                   WHEN ISNULL(C.ITEM_ID, '') = '' THEN N'상품'
                                   ELSE D.ITEM_TYPE        
                                    END                 AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , ISNULL(D.CLASS_ID, '-')   AS GROUP_CODE1
                            , D.PROCESS_GROUP           AS PROCESS_GROUP
                            , D.PROCESS_DETAIL          AS PROCESS_DETAIL
                            , A.LONG_TERM_STOCK_QTY     AS LONG_TERM_STOCK_QTY
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS YYYYMM
                            -- , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            -- , @v_basis_yyyymm       AS YYYYMM
                            , CASE WHEN A.VALUATION_CLASS in ( '3004','3109','7909','7929' ) THEN 'BOH_DEVL' ELSE 'BOH_GODS' END AS BOH_TYPE
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
                    /* AND A.YYYYMM       >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND A.YYYYMM       <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                ) MM
            WHERE 1=1
            AND (   MM.ITEM_TYPE    = N'상품' 
                OR  MM.GROUP_CODE1  = N'EM0306')
            GROUP BY  MM.DATA_TP_CD
                    , MM.BOH_TYPE
                    , MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , MM.ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-4 End';

  

        BEGIN
		------------------------------------------------------------------------
		-- Step 2-4. Insert Intransit from Ending Stock.
        -- Valuation Class: 7900만 있음. 24년 6월 마감재고 기준.
        -- 2024.08.20 Philsu Park: 미착 중복 발생 케이스가 많아 제외하는것으로 합의.
		------------------------------------------------------------------------  
			INSERT INTO dbo.SCM_LGTM_INV_PSI_SUMMARY_GODS
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
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
				,COMPANY_ID
				,PLANT_ID
                )
			SELECT  @v_plan_tp_cd           AS PLAN_TP_CD 
                    , @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , MM.DATA_TP_CD             AS DATA_TP_CD
                    , 'BOH_INTS'                AS SRCE_TP_CD
                    , MM.DIVISION_ID            AS DIVISION_ID
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
					,'*'						AS COMPANY_ID
					,'*'						AS PLANT_ID
                FROM ( 
                        SELECT  B.DIVISION_ID           AS DIVISION_ID
                                , 'RESULT'              AS DATA_TP_CD
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
                                       WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
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
                                       WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
                                       ELSE D.ITEM_TYPE        
                                        END             AS ITEM_TYPE
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                                -- , @v_basis_yyyymm       AS SRCE_YYYYMM
                                -- , @v_basis_yyyymm       AS YYYYMM
                        FROM    SCP_ANL_MONTH_END_STOCK_R B WITH(NOLOCK)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON  C.ITEM_CLASS = D.CLASS_ID
                        WHERE  1=1
                        AND B.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND B.DIVISION_ID       = @v_division_id
                        AND B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                        /* AND     B.YYYYMM           >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                        --and    B.VALUATION_CLASS IN ('3109', '7909', '7929')                        
                    ) MM
                WHERE 1=1
                AND (   MM.ITEM_TYPE    = N'상품' 
                    OR  MM.GROUP_CODE1  = N'EM0306')
                GROUP BY  MM.DATA_TP_CD
                        , MM.DIVISION_ID
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


        /*
        BEGIN
		------------------------------------------------------------------------
		-- Step 2-5. Insert 평가감 Semi-Product from Ending Stock.
        -- 평가감은 일단 Item Id 그대로 유지. 매핑 없음.
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
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
                            , B.ITEM_ID             AS ITEM_ID
                            , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                            , B.VALUATION_CLASS     AS VALUATION_CLASS
                            , B.QUANTITY            AS QUANTITY
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
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
                            , B.ITEM_ID             AS ITEM_ID
                            , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                            , B.VALUATION_CLASS     AS VALUATION_CLASS
                            , B.QUANTITY            AS QUANTITY
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
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
                AND (   MM.ITEM_TYPE    = N'상품' 
                    OR  MM.GROUP_CODE1  = N'EM0306')
                GROUP BY  MM.DATA_TP_CD
                        , MM.DIVISION_ID
                        , MM.GROUP_CODE1
                        , MM.ITEM_ID
                        , MM.SRCE_YYYYMM
                        , MM.YYYYMM
                ;
		------------------------------------------------------------------------  
		END*/
		------------------------------------------------------------------------  
        PRINT 'Step 2-5 End';
        ------------------------------------------------------------------------  

        BEGIN
        ------------------------------------------------------------------------
		-- Step 2-9. Insert 완제품 재고 소진계획. 
        -- 2024.09.12 Philsu Park: 장기재고 소진계획 신규 UI 기준 테이블(SCP_ANL_LGTM_INV_MGMT_PLAN)로 변경.
        -- 2024.10.18 Philsu Park: 소진계획은 초기 버전 아닌 경우에만 적재.
		------------------------------------------------------------------------  
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
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
				,COMPANY_ID
				,PLANT_ID	
				)
            SELECT    @v_plan_tp_cd             AS PLAN_TP_CD 
                    , @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , 'S'                       AS DATA_TP_CD
                    , 'S_EXHT'                  AS SRCE_TP_CD
                    , @v_division_id            AS DIVISION_ID
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
					,'*'						AS COMPANY_ID
					,'*'						AS PLANT_ID
            FROM SCP_ANL_LGTM_INV_MGMT_PLAN INV WITH(NOLOCK)
            WHERE   INV.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     INV.PLAN_TP_CD          = @v_plan_tp_cd
            AND     INV.DIVISION_ID         = @v_division_id
            and     @v_plan_tp_cd           = @v_plan_tp_org
            GROUP BY  INV.DIVISION_ID
                    , INV.ITEM_ID
                    , INV.PLAN_YYYYMM
            ;
        ------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------  
        PRINT 'Step 2-6 S_EXHT End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------  

        ------------------------------------------------------------------------  
		/* BEGIN
		------------------------------------------------------------------------
		-- Step 2-6. Insert Raw Material Inventory.
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
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
			SELECT    @v_plan_tp_cd                             AS PLAN_TP_CD
                    , @v_plan_start_yyyymmdd                    AS PLAN_START_YYYYMMDD
                    , 'S'                                       AS DATA_TP_CD
                    , 'S_EXHT'                                  AS SRCE_TP_CD
                    , MM.DIVISION_ID                            AS DIVISION_ID
                    , MM.GROUP_CODE1                            AS GROUP_CODE1
                    , MM.ITEM_ID                                AS ITEM_ID
                    , MM.ITEM_ID                                AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM                            AS SRCE_YYYYMM
                    , MM.YYYYMM                                 AS PLAN_YYYYMM
                    , SUM(MM.QTY)                               AS QTY 
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
            FROM ( 
                    SELECT  LTS.DIVISION_ID         AS DIVISION_ID
                            , LTS.PLANT_ID          AS PLANT_ID
                            , LTS.ITEM_ID           AS ITEM_ID
                            , LTS.LONG_TERM_TYPE    AS LONG_TERM_TYPE
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG                                                                                                                    
                            ,   CASE WHEN LTS.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                     WHEN LTS.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                     WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
                                     ELSE D.ITEM_TYPE
                                      END           AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , LTS.VALUATION_CLASS   AS VALUATION_CLASS
                            , IEP.QTY               AS QTY
                            , C.ITEM_CLASS          AS GROUP_CODE1
                            , IEP.PLAN_YYYYMM       AS SRCE_YYYYMM
                            , IEP.PLAN_YYYYMM       AS YYYYMM
                    FROM    SCP_ANL_LONG_TERM_STOCK         LTS WITH(NOLOCK)
                    INNER JOIN SCP_ANL_LGTM_INV_EXHT_PLAN   IEP WITH(NOLOCK)
                        ON  IEP.YYYYMM          = LTS.YYYYMM
                        AND IEP.PLANT_ID        = LTS.PLANT_ID
                        AND IEP.DIVISION_ID     = LTS.DIVISION_ID
                        AND IEP.ITEM_ID         = LTS.ITEM_ID
                        AND IEP.CHARG           = LTS.CHARG
                        AND IEP.DEVALUATION_AGE = LTS.DEVALUATION_AGE
                    LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  LTS.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE 1=1
                    AND LTS.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND LTS.DIVISION_ID   = @v_division_id
                ) MM
            WHERE 1=1
            AND (   MM.ITEM_TYPE    = N'상품' 
                OR  MM.GROUP_CODE1  = N'EM0306')
            GROUP BY  MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , MM.ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-6 End'; */

        PRINT 'Step 2-7 Exception Logic Start' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------
		-- Step 2-7. 원재료 Metal 중 원재료에서 처리하는 ERAD00029AA 삭제.
		------------------------------------------------------------------------  
        BEGIN
            DELETE  S
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS S
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
            AND     S.ITEM_ID               = 'ERAD00029AA'
        END

        PRINT 'Step 2-7 Exception Logic End' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);

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

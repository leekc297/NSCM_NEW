
/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION_SPRD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.08.01   hrkim		   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell/전극 완성 공정 하드코딩 변경 
 * 2025.11.05	YMH			   E20250821-001381 [LONGTERM STOCK MGMT] 가동중 중지 원인확인건
 */

CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_SPRD_YMH_20251114]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
	,@p_chg_plan_start_yyyymmdd     NVARCHAR(8)
	,@p_mrp_version_id             NVARCHAR(30)
AS 
BEGIN

-- exec PR_SCM_LGTM_INV_ALLOCATION_SPRD_OIJ 'SPRD_INIT', '82', '20250303', '202503', '20250303', 'MRP-SCP-20250311-001'

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_SPRD';
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
    DECLARE @v_plan_tp_cd           NVARCHAR(20)    = @p_plan_tp_cd;            -- 'SPRD';
    DECLARE @v_division_id          NVARCHAR(10)    = @p_division_id            -- '82';
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = @p_basis_yyyymm           -- '202407';'
    DECLARE @v_basis_yyyymmdd       NVARCHAR(8)     = CONCAT(@v_basis_yyyymm, '01')           -- '202407';'
    DECLARE @v_plan_tp_org          NVARCHAR(10)    = SUBSTRING(@v_plan_tp_cd, 1, 4);
    DECLARE @v_chg_plan_start_yyyymmdd  NVARCHAR(8)     = @p_chg_plan_start_yyyymmdd    
	DECLARE @v_mrp_version_id  NVARCHAR(8)     = @p_mrp_version_id    

    IF OBJECT_ID (N'tempdb..#TEMP_ESS_ITEM', N'U') IS NOT NULL 		DROP TABLE #TEMP_ESS_ITEM;
    ------------------------------------------------------------------------  
		
	------------------------------------------------------------------------------------
	-- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 (임시 테이블 변수)
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell/전극 Final공정 정보' 
	------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_ELEC_FINAL_OPERATION TABLE
	 (
		    OPERATION_GROUP					NVARCHAR(30)	NULL
		   ,OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_ELEC_FINAL_OPERATION
	SELECT DISTINCT
		   LK.SEGMENT3		AS OPERATION_GROUP
		  ,LK.SEGMENT1		AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	 IN ('A', 'E')	-- 공정그룹 (Cell/전극) 
	   AND LK.ATTRIBUTE1  = 'Y'			-- Final Operation
	------------------------------------------------------------------------------------

	------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
--jjg	BEGIN TRANSACTION PR_SCM_LGTM_INV_ALLOCATION_SPRD;
	------------------------------------------------------------------------  
    PRINT 'Div.: '+@v_division_id+'//PST YMD: '+@v_plan_start_yyyymmdd+'//Basis YM: '+@v_basis_yyyymm;
	PRINT 'Div.: '+@v_division_id+'//PST YMD: '+@v_chg_plan_start_yyyymmdd+'//Basis YM: '+@v_basis_yyyymm;
	------------------------------------------------------------------------  
	BEGIN TRY
		------------------------------------------------------------------------
		-- Step 1. Initialize Data
		------------------------------------------------------------------------
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-1. Delete SCM_LGTM_INV_PSI_SUMMARY_SPRD
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
		-- Step 1-2. Delete SCM_LGTM_INV_PSI_DETAIL_SPRD
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_DETAIL_SPRD
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
		-- Step 2. Insert Data
		------------------------------------------------------------------------
		-- Step 2-1. Insert P from SCP-FINAL
		------------------------------------------------------------------------  

            IF OBJECT_ID (N'tempdb..#TEMP_PROD_PLAN', N'U') IS NOT NULL 		DROP TABLE #TEMP_PROD_PLAN;

            WITH VERSION_INFO AS (  SELECT  PLM.DIVISION_ID, PLM.PLAN_NAME AS PLAN_START_YYYYMMDD, PLD.PLAN_TYPE, MAX(PLAN_SEQ) AS PLAN_SEQ
                                          , PLM.PLAN_NAME + '-' + PLD.PLAN_TYPE + '-' + DBO.FN_ZERO_LPAD(CONVERT(NVARCHAR,MAX(PLAN_SEQ)),2) AS PLAN_VERSION_ID
                                    FROM    SCM_MST_PLAN PLM WITH(NOLOCK)
                                    INNER JOIN SCM_MST_PLAN_DETAIL PLD WITH(NOLOCK)
                                        ON  PLM.DIVISION_ID = PLD.DIVISION_ID
                                        AND PLM.PLAN_ID     = PLD.PLAN_ID
                                    WHERE   1=1
                                    --AND     PLM.PLAN_NAME       = @v_plan_start_yyyymmdd
                                    AND     PLM.PLAN_NAME       = @v_chg_plan_start_yyyymmdd	--2025-02-10 OIJ
                                    AND     PLM.PLAN_CYCLE      = 'WEEKLY'
                                    AND     PLD.PLAN_TYPE       = 'FN'
                                    AND     PLD.CONFIRM_FLAG    = 'Y'
                                    AND     PLD.PLAN_STATUS     = '1'
                                    AND     PLD.UI_DISPLAY_YN   = 'Y'
                                    GROUP BY PLM.DIVISION_ID, PLM.PLAN_NAME, PLD.PLAN_TYPE
                                    )
            SELECT  PROD.*
            INTO    #TEMP_PROD_PLAN
            FROM ( 
                    SELECT  FINAL.*
                            , VER.PLAN_VERSION_ID
							, ISNULL(SMS.COMPANY_ID,'*')  AS COMPANY_ID	--jjg 20250322
							, ISNULL(SMS.PLANT_ID,'*')  AS PLANT_ID      --jjg 20250322
                    FROM    SCP_ANL_PRODUCTION_PLAN      FINAL WITH(NOLOCK)
						    -- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - Start 
						    INNER JOIN @SCP_CELL_ELEC_FINAL_OPERATION CE
								    ON CE.OPERATION_ID	= FINAL.OPERATION_ID 
						    -- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - End 
                    INNER JOIN VERSION_INFO VER
                        ON  VER.DIVISION_ID         = FINAL.DIVISION_ID
                        AND VER.PLAN_START_YYYYMMDD = FINAL.PLAN_START_YYYYMMDD
                        AND VER.PLAN_TYPE           = FINAL.PLAN_TYPE
                        AND VER.PLAN_SEQ            = FINAL.SEQ
					LEFT JOIN SCM_MST_SITE SMS WITH(NOLOCK)  --jjg 20250322
					    ON FINAL.SCM_SITE_ID		= SMS.SCM_SITE_ID   --jjg 20250322
--					   AND FINAL.DIVISION_ID		= SMS.DIVISION_ID   --jjg 20250322
					   AND FINAL.ORIGIN_DIVISION_ID = SMS.DIVISION_ID   --jjg 20250322         ====> 이부분 어떻게 해야 하나?
                    WHERE 1=1
                    --AND FINAL.ORIGIN_DIVISION_ID     LIKE CONCAT(@v_division_id, '%') -- 사업부(전극가상사업부 포함)
                    --AND FINAL.PLAN_START_YYYYMMDD       = @v_plan_start_yyyymmdd  --매주 월요일 날짜
                    AND     FINAL.PLAN_START_YYYYMMDD       = @v_chg_plan_start_yyyymmdd	--2025-02-10 OIJ
                    AND FINAL.PLAN_TYPE                 = 'FN'  -- SCP final version 구분
                    AND FINAL.MEASURE			        = 'PROD_PLAN_AMEND' 
                    AND FINAL.QTY                       > 0
					-- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - Start 
                    AND (   (FINAL.DIVISION_ID	     LIKE 'EE%' AND CE.OPERATION_GROUP = 'E')
                        OR  (FINAL.DIVISION_ID   NOT LIKE 'EE%' AND CE.OPERATION_GROUP = 'A')
                        )
					-- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - End
                    -- [PJ20257329] 변경전 AND (   (FINAL.DIVISION_ID	     LIKE 'EE%' AND FINAL.OPERATION_ID = 'E2000')
                    -- [PJ20257329] 변경전     OR  (FINAL.OPERATION_ID        IN ('A9000', 'A3000') AND FINAL.DIVISION_ID NOT LIKE 'EE%')
                    -- [PJ20257329] 변경전     )
                    --AND FINAL.DIVISION_ID		      NOT LIKE 'EE%'
                    AND FINAL.YYYYMMDD                 >= @v_basis_yyyymmdd
                    AND FINAL.YYYYMMDD                  < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_chg_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
                    -------------------------------------------------------
                    UNION ALL
                    -------------------------------------------------------
                    -------------------------------------------------------
                    SELECT  IIF(DPR.OPERATION_ID = 'E2000', 'EE', DPR.DIVISION_ID) AS DIVISION_ID
                            ,@v_plan_start_yyyymmdd             AS PLAN_START_YYYYMMDD
                            ,'FN'                               AS PLAN_TYPE
                            ,'1'                                AS SEQ
                            ,SUBSTRING(DPR.OPERATION_ID,1,1)    AS OPERATION_GROUP
                            ,SMS.SCM_SITE_ID                    AS SCM_SITE_ID
                            ,DPR.ITEM_ID                        AS ITEM_ID
                            ,DPR.LINE_ID                        AS LINE_ID
                            ,DPR.OPERATION_ID                   AS OPERATION_ID
                            ,'PROD_PLAN_AMEND'                  AS MEASURE
                            ,CONVERT(CHAR,DPR.PLAN_DATE, 112)   AS YYYYMMDD
                            ,DPR.ACTUAL_GOOD_QTY                AS QTY
                            ,DPR.DIVISION_ID                    AS ORIGIN_DIVISION_ID
                            ,''                                 AS ELECTRODE_TYPE
                            ,DPR.INSERT_ID                      AS CREATED_BY
                            ,DPR.INSERT_TIME                    AS CREATION_DATE
                            ,DPR.INSERT_ID                      AS LAST_UPDATED_BY
                            ,DPR.INSERT_TIME                    AS LAST_UPDATED_DATE
                            ,''                                 AS ATTIRUBTE1
                            ,''                                 AS ATTIRUBTE2
                            ,''                                 AS ATTIRUBTE3
                            ,''                                 AS ATTIRUBTE4
                            ,''                                 AS ATTIRUBTE5
                            ,''                                 AS ATTIRUBTE6
                            ,''                                 AS ATTIRUBTE7
                            ,''                                 AS ATTIRUBTE8
                            ,''                                 AS ATTIRUBTE9
                            ,''                                 AS ATTIRUBTE10
                            ,0                                  AS CELL_QTY
                            ,'RESULT'                           AS PLAN_VERSION_ID
							,DPR.COMPANY_ID						--jjg 20250322
							,DPR.PLANT_ID						--jjg 20250322
                    FROM   SCM_DNM_DAILY_PRODUCT_RESULT_SN DPR WITH(NOLOCK)
                    LEFT OUTER JOIN (   SELECT  PLANT_ID, MAX(SCM_SITE_ID) AS SCM_SITE_ID
                                        FROM    SCM_MST_SITE SM WITH(NOLOCK)
                                        WHERE   1=1
                                        AND     SM.SITE_TYPE   = 'PLANT'  
                                        GROUP BY PLANT_ID ) SMS
                        ON  SMS.PLANT_ID    = DPR.PLANT_ID
                    WHERE  1=1
                    AND    CONVERT(CHAR,PLAN_DATE, 112)  >= @v_basis_yyyymmdd
                    AND    CONVERT(CHAR,PLAN_DATE, 112)  <  @v_chg_plan_start_yyyymmdd--CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112)    
                    AND    DPR.OPERATION_ID IN (SELECT OPERATION_ID FROM @SCP_CELL_ELEC_FINAL_OPERATION) -- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경  
                    -- [PJ20257329] 변경전 AND    DPR.OPERATION_ID IN ('A9000', 'A3000', 'E2000')
					
					-------------------------------------------------------
                ) AS PROD
            ;


            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
				
            SELECT   @v_plan_tp_cd                                  AS PLAN_TP_CD
                    --,FINAL.PLAN_START_YYYYMMDD		                AS PLAN_START_YYYYMMDD
                    ,@v_plan_start_yyyymmdd                         AS PLAN_START_YYYYMMDD    -- 2024.12.05 YSH
                    ,'P'						                    AS DATA_TP_CD
                    ,'P'						                    AS SRCE_TP_CD
                    ,FINAL.ORIGIN_DIVISION_ID				        AS DIVISION_ID
                    ,'*'			                                AS GROUP_CODE1
                    ,FINAL.ITEM_ID                                  AS ITEM_ID
                    ,FINAL.ITEM_ID					                AS ORIGIN_ITEM_ID
                    ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS SRCE_YYYYMM
                    ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS PLAN_YYYYMM
                    ,SUM(FINAL.QTY)					                AS QTY	
                    ,NULL							                AS CURRENCY
                    ,NULL							                AS STANDARD_COST
                    ,NULL							                AS AMT
                    ,MAX(FINAL.SCM_SITE_ID)			                AS SCM_SITE_ID
                    ,MAX(FINAL.OPERATION_GROUP)		                AS OPERATION_GROUP
                    ,MAX(FINAL.OPERATION_ID)			            AS OPERATION_ID
                    ,NULL						                    AS DEVALUATION_AGE
                    ,NULL						                    AS LONG_TERM_TYPE_CODE
                    ,NULL						                    AS LONG_TERM_TYPE
                    ,MAX(PLAN_VERSION_ID)						    AS VERSION_NO
					,FINAL.COMPANY_ID						--jjg 20250322
					,'*'											AS PLANT_ID						--jjg 20250322
            FROM  #TEMP_PROD_PLAN        FINAL WITH(NOLOCK) 
            WHERE 1=1
            AND FINAL.ORIGIN_DIVISION_ID    = @v_division_id  -- 사업부(전극가상사업부 포함)
            --AND FINAL.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd  --매주 월요일 날짜
            AND FINAL.PLAN_START_YYYYMMDD   = @v_chg_plan_start_yyyymmdd	--2025-02-10 OIJ
            AND FINAL.PLAN_TYPE             = 'FN'  -- SCP final version 구분
            AND FINAL.MEASURE			    = 'PROD_PLAN_AMEND'
            AND FINAL.DIVISION_ID	     LIKE 'EE%'
            AND FINAL.OPERATION_ID          = 'E2000'
            AND FINAL.QTY                   > 0
            AND FINAL.YYYYMMDD             >= @v_basis_yyyymmdd
            AND FINAL.YYYYMMDD              < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
            GROUP BY FINAL.PLAN_START_YYYYMMDD
                    ,FINAL.ORIGIN_DIVISION_ID
                    --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)
                    ,FINAL.ITEM_ID
                    ,SUBSTRING(FINAL.YYYYMMDD,1,6)
					,FINAL.COMPANY_ID						--jjg 20250322
					,FINAL.PLANT_ID						--jjg 20250322
		------------------------------------------------------------------------  

		 INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
		SELECT   @v_plan_tp_cd                                  AS PLAN_TP_CD
                    --,FINAL.PLAN_START_YYYYMMDD		                AS PLAN_START_YYYYMMDD
                    ,@v_plan_start_yyyymmdd                         AS PLAN_START_YYYYMMDD    -- 2024.12.05 YSH
                    ,'P'						                    AS DATA_TP_CD
                    ,'P_SEMI_WHIN'						                    AS SRCE_TP_CD
                    ,S.DIVISION_ID						        AS DIVISION_ID
                    ,'*'			                                AS GROUP_CODE1
                    ,S.ITEM_ID                                  AS ITEM_ID
                    ,S.ITEM_ID					                AS ORIGIN_ITEM_ID
                    ,SUBSTRING(S.YYYYMM,1,6)	                AS SRCE_YYYYMM
                    ,SUBSTRING(S.YYYYMM,1,6)	                AS PLAN_YYYYMM
                    ,SUM(S.QTY)					                AS QTY	
                    ,NULL							                AS CURRENCY
                    ,NULL							                AS STANDARD_COST
                    ,NULL							                AS AMT
                    ,MAX(G.SCM_SITE_ID)			                AS SCM_SITE_ID
                    ,MAX(S.OPERATION_GROUP)		                AS OPERATION_GROUP
                    ,CASE WHEN S.OPERATION_GROUP = 'A' THEN 'A9000'  WHEN S.OPERATION_GROUP = 'E' THEN 'E2000' ELSE '' END  AS OPERATION_ID
                    ,NULL						                    AS DEVALUATION_AGE
                    ,NULL						                    AS LONG_TERM_TYPE_CODE
                    ,NULL						                    AS LONG_TERM_TYPE
                    ,''						    AS VERSION_NO
					,S.COMPANY_ID						--jjg 20250322
					,'*'						AS PLANT_ID						--jjg 20250322			
                    FROM   SCP_ANL_PSI_INTEGRATION S WITH(NOLOCK)
					LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
										FROM   SCM_ITEM_M_SN WITH(NOLOCK)
										GROUP BY DIVISION_ID, ITEM_ID
									) ITM
						ON  ITM.DIVISION_ID = S.DIVISION_ID
						AND ITM.ITEM_ID     = S.ITEM_ID
						AND S.OPERATION_GROUP = 'E'
					LEFT JOIN SCM_MST_SITE G
					ON S.DIVISION_ID = G.DIVISION_ID
					AND S.PLANT_ID = G.PLANT_ID
					AND S.OPERATION_GROUP = G.OPERATION_GROUP
					AND G.SITE_TYPE = 'PLANT'
                     WHERE  1=1
						AND		PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND		MEASURE IN ('SEMI_WH_IN')
						AND     S.DIVISION_ID = @v_division_id
						AND     ITM.ITEM_CLASS IN ( SELECT  LK.SEGMENT1 
															FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
															WHERE   1=1
															AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
															AND     LK.VALID_YN     = 'Y'
															)
            GROUP BY S.PLAN_START_YYYYMMDD
                    ,S.DIVISION_ID
                    ,S.ITEM_ID
                    ,S.YYYYMM
					,S.COMPANY_ID						--jjg 20250322
					,S.PLANT_ID						--jjg 20250322
					,S.OPERATION_GROUP

        END
		------------------------------------------------------------------------  
        PRINT 'Step 2-1 End';


        ------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-3. Insert S from RTF
        -- 주차 내 가장 최신 Cutoff 된 MF_W 의 RTF, AS_In_Plan 수량을 사용
        -- 반제품은 ITEM이 전극인 대상.
        -- 2024.08.29 Philsu Park: Plan Start 기준 계획월의 실적구간은 실적에서 가져옴.
        -- 2024.08.30 Philsu Park: AS_In_Plan 불필요(제품만 사용)
		------------------------------------------------------------------------  
		INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
				,COMPANY_ID  --JJG 20250322
				,PLANT_ID)   --JJG 20250322
		   SELECT   @v_plan_tp_cd				AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd     AS PLAN_START_YYYYMMDD
                    ,'S'						AS DATA_TP_CD
                    ,'S_RTF'					AS SRCE_TP_CD
                    ,S.DIVISION_ID				AS DIVISION_ID
                    ,'*'                        AS GROUP_CODE1
                    ,S.ITEM_ID					AS ITEM_ID
                    ,S.ITEM_ID					AS ORIGIN_ITEM_ID
                    ,S.YYYYMM					AS SRCE_YYYYMM
                    ,S.YYYYMM					AS PLAN_YYYYMM
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
                    ,''							AS VERSION_NO
					,ISNULL(S.COMPANY_ID, '*')             AS COMPANY_ID --JJG 20250322
					,'*'			            AS PLANT_ID --JJG 20250322
    FROM	SCP_ANL_PSI_INTEGRATION    S WITH(NOLOCK)
    LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                        FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                        GROUP BY DIVISION_ID, ITEM_ID
                    ) ITM
        ON  ITM.DIVISION_ID = S.DIVISION_ID
        AND ITM.ITEM_ID     = S.ITEM_ID
		AND S.OPERATION_GROUP = 'E'
    WHERE  1=1
	AND		PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
	AND		MEASURE IN ('SHIP_PLAN_RTF')
	AND     S.DIVISION_ID   =  @v_division_id
    AND     ITM.ITEM_CLASS IN ( SELECT  LK.SEGMENT1 
                                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                    WHERE   1=1
                                    AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                                    AND     LK.VALID_YN     = 'Y'
                                    )
    GROUP BY S.DIVISION_ID
            ,S.ITEM_ID
            ,S.YYYYMM
			,S.COMPANY_ID
			--,S.PLANT_ID

-------------------------------------------------------------------------------------------------------------------
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-2 End';


		------------------------------------------------------------------------  
        BEGIN

	INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
				,COMPANY_ID  --JJG 20250322
				,PLANT_ID)   --JJG 20250322
		   SELECT   @v_plan_tp_cd				AS PLAN_TP_CD
                    ,@v_plan_start_yyyymmdd     AS PLAN_START_YYYYMMDD
                    ,'S'						AS DATA_TP_CD
                    ,'S_SEMI_SHIP'					AS SRCE_TP_CD
                    ,S.DIVISION_ID				AS DIVISION_ID
                    ,'*'                        AS GROUP_CODE1
                    ,S.ITEM_ID					AS ITEM_ID
                    ,S.ITEM_ID					AS ORIGIN_ITEM_ID
                    ,S.YYYYMM					AS SRCE_YYYYMM
                    ,S.YYYYMM					AS PLAN_YYYYMM
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
                    ,''							AS VERSION_NO
					,ISNULL(S.COMPANY_ID, '*')             AS COMPANY_ID --JJG 20250322
					,'*'		                AS PLANT_ID --JJG 20250322
    FROM	SCP_ANL_PSI_INTEGRATION    S WITH(NOLOCK)
    LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                        FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                        GROUP BY DIVISION_ID, ITEM_ID
                    ) ITM
        ON  ITM.DIVISION_ID = S.DIVISION_ID
        AND ITM.ITEM_ID     = S.ITEM_ID
		AND S.OPERATION_GROUP = 'E'
    WHERE  1=1
	AND		PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
	AND		MEASURE IN ('SHIP_PLAN_SEMI')
	AND     S.DIVISION_ID = @v_division_id
    AND     ITM.ITEM_CLASS IN ( SELECT  LK.SEGMENT1 
                                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                    WHERE   1=1
                                    AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                                    AND     LK.VALID_YN     = 'Y'
                                    )
    GROUP BY S.DIVISION_ID
            ,S.ITEM_ID
            ,S.YYYYMM
			,S.COMPANY_ID
			--,S.PLANT_ID


    --        WITH S_RTF AS ( SELECT  S.DIVISION_ID
    --                                , 'S_RTF' AS SRCE_TP_CD
    --                                , S.ITEM_ID
    --                                , S.YYYYMMDD
    --                                , S.QTY
    --                                , S.SCM_SITE_ID
    --                                , S.VERSION_NO
    --                        FROM	DM_PLN_MKT_FCST_C S WITH(NOLOCK)
    --                        WHERE  1=1
    --                        AND    S.CUTOFF_TYPE    = 'MF_W'
    --                        AND    S.MEASURE       IN ('RTF_SYS_RP')
    --                        AND    ( S.DIVISION_ID +  S.VERSION_NO ) IN (   SELECT V.DIVISION_ID + MAX(VERSION_NO)
    --                                                                        FROM   DM_MST_VERSION V WITH(NOLOCK)
    --                                                                            ,(SELECT CAL2.BASIS_YYYYMMDD
    --                                                                                FROM   SCM_SYS_CALENDAR_M CAL1  WITH(NOLOCK) 
    --                                                                                    ,SCM_SYS_CALENDAR_M CAL2  WITH(NOLOCK) 
    --                                                                                WHERE  1=1
    --                                                                                AND    CAL1.ISO_YYYYWW      = CAL2.ISO_YYYYWW
    --                                                                                AND    CAL1.BASIS_YYYYMMDD  = @v_plan_start_yyyymmdd
    --                                                                                ) CAL
    --                                                                        WHERE  1=1
    --                                                                        AND    V.YYYYMMDD       = CAL.BASIS_YYYYMMDD
    --                                                                        AND    V.VERSION_TYPE   = 'MF_W'
    --                                                                        AND    V.DIVISION_ID    LIKE CONCAT(@v_division_id, '%')
    --                                                                        GROUP BY V.DIVISION_ID)
    --                        AND     S.YYYYMMDD     >= @v_basis_yyyymmdd
    --                        AND     S.YYYYMMDD      < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
    --                        UNION ALL
    --                        SELECT  S.DIVISION_ID
    --                                , 'S_RTF' AS SRCE_TP_CD
    --                                , S.ITEM_ID
    --                                , S.YYYYMMDD
    --                                , S.QTY
    --                                , S.SCM_SITE_ID
    --                                , S.VERSION_NO
    --                        FROM	DM_PLN_MKT_FCST_RESULT_C   S WITH(NOLOCK)
    --                        WHERE  1=1
    --                        AND    S.CUTOFF_TYPE        = 'MF_W'
    --                        AND    S.MEASURE            IN ('RTF_SYS_RP')
    --                        AND    ( S.DIVISION_ID +  S.VERSION_NO ) IN (   SELECT V.DIVISION_ID + MAX(VERSION_NO)
    --                                                                        FROM   DM_MST_VERSION V WITH(NOLOCK)
    --                                                                            ,(SELECT CAL2.BASIS_YYYYMMDD
    --                                                                                FROM   SCM_SYS_CALENDAR_M CAL1  WITH(NOLOCK) 
    --                                                                                    ,SCM_SYS_CALENDAR_M CAL2  WITH(NOLOCK) 
    --                                                                                WHERE  1=1
    --                                                                                AND    CAL1.ISO_YYYYWW      = CAL2.ISO_YYYYWW
    --                                                                                AND    CAL1.BASIS_YYYYMMDD  = @v_plan_start_yyyymmdd
    --                                                                                ) CAL
    --                                                                        WHERE  1=1
    --                                                                        AND    V.YYYYMMDD       = CAL.BASIS_YYYYMMDD
    --                                                                        AND    V.VERSION_TYPE   = 'MF_W'
    --                                                                        AND    V.DIVISION_ID    LIKE CONCAT(@v_division_id, '%')
    --                                                                        GROUP BY V.DIVISION_ID)
    --                        AND     S.YYYYMMDD         >= @v_basis_yyyymmdd
    --                        AND     S.YYYYMMDD          < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
    --                        )
    --        INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
    --            (PLAN_TP_CD
    --            ,PLAN_START_YYYYMMDD
    --            ,DATA_TP_CD
    --            ,SRCE_TP_CD
    --            ,DIVISION_ID
    --            ,GROUP_CODE1
    --            ,ITEM_ID
    --            ,ORIGIN_ITEM_ID
    --            ,SRCE_YYYYMM
    --            ,PLAN_YYYYMM
    --            ,QTY
    --            ,CURRENCY
    --            ,STANDARD_COST
    --            ,AMT
    --            ,SCM_SITE_ID
    --            ,OPERATION_GROUP
    --            ,OPERATION_ID
    --            ,DEVALUATION_AGE
    --            ,LONG_TERM_TYPE_CODE
    --            ,LONG_TERM_TYPE
    --            ,VERSION_NO
				--,COMPANY_ID  --JJG 20250322
				--,PLANT_ID)   --JJG 20250322
    --        SELECT   @v_plan_tp_cd              AS PLAN_TP_CD
    --                ,@v_plan_start_yyyymmdd     AS PLAN_START_YYYYMMDD
    --                ,'S'						AS DATA_TP_CD
    --                ,S.SRCE_TP_CD			    AS SRCE_TP_CD
    --                ,S.DIVISION_ID				AS DIVISION_ID
    --                ,'*'                        AS GROUP_CODE1
    --                ,S.ITEM_ID					AS ITEM_ID
    --                ,S.ITEM_ID					AS ORIGIN_ITEM_ID
    --                ,SUBSTRING(S.YYYYMMDD,1,6)	AS SRCE_YYYYMM
    --                ,SUBSTRING(S.YYYYMMDD,1,6)	AS PLAN_YYYYMM
    --                ,SUM(S.QTY)					AS QTY
    --                ,NULL						AS CURRENCY
    --                ,NULL						AS STANDARD_COST
    --                ,NULL						AS AMT
    --                ,NULL						AS SCM_SITE_ID
    --                ,NULL						AS OPERATION_GROUP
    --                ,NULL						AS OPERATION_ID
    --                ,NULL						AS DEVALUATION_AGE
    --                ,NULL						AS LONG_TERM_TYPE_CODE
    --                ,NULL						AS LONG_TERM_TYPE
    --                ,S.VERSION_NO				AS VERSION_NO
				--	,ISNULL(SMS.COMPANY_ID, '*')             AS COMPANY_ID --JJG 20250322
				--	,ISNULL(SMS.PLANT_ID, '*')               AS PLANT_ID --JJG 20250322
    --        FROM	S_RTF           S WITH(NOLOCK)
    --        INNER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
    --            ON  SMS.DIVISION_ID = S.DIVISION_ID
    --            AND SMS.SCM_SITE_ID = S.SCM_SITE_ID
    --        INNER JOIN (    SELECT  COMPANY_ID, DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS, MAX(EVAL_CLASS) AS EVAL_CLASS
    --                        FROM    SCM_ITEM_M_SN  WITH(NOLOCK)
    --                        GROUP BY COMPANY_ID, DIVISION_ID, ITEM_ID
    --                    ) ITM
    --            ON  ITM.COMPANY_ID  = SMS.COMPANY_ID
    --            AND ITM.DIVISION_ID = S.DIVISION_ID
    --            and ITM.ITEM_ID     = S.ITEM_ID
    --        WHERE  1=1
    --        AND     ITM.ITEM_CLASS IN ( SELECT  LK.SEGMENT1 
    --                                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
    --                                    WHERE   1=1
    --                                    AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
    --                                    AND     LK.VALID_YN     = 'Y'
    --                                    )
    --        GROUP BY S.SRCE_TP_CD
    --                ,S.DIVISION_ID
    --                ,S.ITEM_ID
    --                ,SUBSTRING(S.YYYYMMDD,1,6)
    --                ,S.VERSION_NO
				--	,SMS.COMPANY_ID  --JJG 20250322
				--	,SMS.PLANT_ID  --JJG 20250322
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-2-1 End';


		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 2-2. Insert S-Target from SCP-FINAL
        -- 2024.08.07 Philsu Park: Item_Id의 상위 모델 탐색 시 Cell 상위의 Pack Biz 모델을 찾는 경우가 있어 제약 추가.
        -- 2024.08.08 Philsu Park: BOM Priority 탐색 시 MODEL_ID = CHILD_ITEM_ID 로 잡히는 대상이 있어 제외 조건 추가.
        -- 2024.08.21 Philsu Park: 전극 공정 전개 시에는 전극 BOM을 우선적으로 적용.
		------------------------------------------------------------------------  
		    -- S FROM SCP-FINAL
            WITH SCP_ELEC AS (
                                SELECT  SME.DIVISION_ID, SME.PARENT_ITEM_ID, SME.CHILD_ITEM_ID, SME.USAGE, ITM.ITEM_CLASS
                                FROM    SCP_MST_BOM_ELEC  SME WITH(NOLOCK)
                                INNER JOIN (SELECT ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                            FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                                            GROUP BY ITEM_ID
                                            ) ITM
                                    ON SME.CHILD_ITEM_ID = ITM.ITEM_ID
                                INNER JOIN SCM_ITEM_CLASS_M_SN CLS WITH(NOLOCK)
                                    ON CLS.CLASS_ID = ITM.ITEM_CLASS
                                WHERE   1=1
                                AND     SME.SCP_YN = 'Y'
                                )
                , BOM_PRIORITY AS (
                                    SELECT  SMB.PLANT_ID, SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SMB.ITEM_CLASS, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                    FROM      ( SELECT DENSE_RANK()OVER(PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.MODEL_ID, SME.CONCATENATE_ITEM 
                                                                        ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                        , SME.PLANT_ID, SME.MODEL_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                        , T.ITEM_CLASS
                                                FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                INNER JOIN (SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                            FROM    SCM_ITEM_M_SN  WITH(NOLOCK)
                                                            GROUP BY DIVISION_ID, ITEM_ID
                                                            )  T
                                                    ON      T.DIVISION_ID   = SME.DIVISION_ID
                                                    AND     T.ITEM_ID       = SME.CHILD_ITEM_ID
                                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                    ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                    AND     L.VALID_YN      = 'Y'
                                                    AND     L.SEGMENT1      = 'SPRD'
                                                    AND     L.SEGMENT2      = T.ITEM_CLASS
                                                WHERE   1=1 
                                                AND     SME.ALT_PRIORITY    = 'Y'
                                                AND     SME.EFF_END_DATE   >= GETDATE()
                                                AND     SME.MODEL_ID       <> SME.CHILD_ITEM_ID
                                                AND     NOT EXISTS (SELECT 1 
                                                                    FROM   SCP_ELEC EC
                                                                    where  1=1
                                                                    AND    EC.DIVISION_ID      = SME.DIVISION_ID
                                                                    AND    EC.PARENT_ITEM_ID   = SME.MODEL_ID
                                                                    and    EC.ITEM_CLASS       = T.ITEM_CLASS
                                                                    )
                                                ) AS SMB
                                    WHERE 1=1
                                    AND     SMB.RNK = 1
                                    GROUP BY SMB.PLANT_ID, SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SMB.ITEM_CLASS
                                    )
                , BOM_WITHOUT_PLANT AS (
                                        SELECT  SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SMB.ITEM_CLASS, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                        FROM    (   SELECT  DENSE_RANK()OVER(PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.MODEL_ID, SME.CONCATENATE_ITEM
                                                                                ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                            , DENSE_RANK()OVER(PARTITION BY SME.DIVISION_ID, SME.MODEL_ID
                                                                            ORDER BY        SME.EFF_START_DATE DESC, SME.COMPANY_ID, SME.PLANT_ID, SME.SITE_ID ) AS RNK2
                                                            , SME.PLANT_ID, SME.MODEL_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                            , T.ITEM_CLASS
                                                    FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                    INNER JOIN (SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                                FROM    SCM_ITEM_M_SN  WITH(NOLOCK)
                                                                GROUP BY DIVISION_ID, ITEM_ID
                                                                )  T
                                                        ON      T.DIVISION_ID   = SME.DIVISION_ID
                                                        AND     T.ITEM_ID       = SME.CHILD_ITEM_ID
                                                    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                        ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                        AND     L.VALID_YN      = 'Y'
                                                        AND     L.SEGMENT1      = 'SPRD'
                                                        AND     L.SEGMENT2      = T.ITEM_CLASS
                                                    WHERE   1=1
                                                    AND     SME.ALT_PRIORITY    = 'Y'
                                                    AND     SME.EFF_END_DATE   >= GETDATE()
                                                    AND     SME.MODEL_ID       <> SME.CHILD_ITEM_ID
                                                    AND     NOT EXISTS (SELECT 1
                                                                        FROM   SCP_ELEC EC
                                                                        WHERE  1=1
                                                                        AND    EC.DIVISION_ID      = SME.DIVISION_ID
                                                                        AND    EC.PARENT_ITEM_ID   = SME.MODEL_ID
                                                                        AND    EC.ITEM_CLASS       = T.ITEM_CLASS
                                                                        )
                                                    ) AS SMB
                                        WHERE   1=1
                                        AND     SMB.RNK     = 1
                                        AND     SMB.RNK2    = 1
                                        GROUP BY SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SMB.ITEM_CLASS
                                        )
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
				,PLANT_ID)
            SELECT   PLN.PLAN_TP_CD                     AS PLAN_TP_CD
                    ,PLN.PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                    ,PLN.DATA_TP_CD                     AS DATA_TP_CD
                    ,PLN.SRCE_TP_CD                     AS SRCE_TP_CD
                    ,PLN.DIVISION_ID                    AS DIVISION_ID
                    ,PLN.GROUP_CODE1                    AS GROUP_CODE1
                    ,CASE WHEN L.ATTRIBUTE4 = 'Y' THEN ISNULL(ISNULL(ISNULL(EC.CHILD_ITEM_ID, COMBOM.CHILD_ITEM_ID), BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)
                          ELSE ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)   
                           END                          AS ITEM_ID
                    ,PLN.ORIGIN_ITEM_ID                 AS ORIGIN_ITEM_ID
                    ,PLN.SRCE_YYYYMM                    AS SRCE_YYYYMM
                    ,PLN.PLAN_YYYYMM                    AS PLAN_YYYYMM
                    ,SUM(CASE WHEN L.ATTRIBUTE4 = 'Y' THEN PLN.QTY * ISNULL(ISNULL(ISNULL(EC.USAGE, COMBOM.ACCUM_QTY), BOM2.ACCUM_QTY), 1)
                              ELSE PLN.QTY * ISNULL(ISNULL(COMBOM.ACCUM_QTY, BOM2.ACCUM_QTY), 1)
                               END)                     AS QTY
                    ,NULL                               AS CURRENCY
                    ,NULL                               AS STANDARD_COST
                    ,NULL                               AS AMT
                    ,MAX(PLN.SCM_SITE_ID)               AS SCM_SITE_ID
                    ,MAX(PLN.OPERATION_GROUP)           AS OPERATION_GROUP
                    ,MAX(PLN.OPERATION_ID)              AS OPERATION_ID
                    ,NULL                               AS DEVALUATION_AGE
                    ,NULL                               AS LONG_TERM_TYPE_CODE
                    ,NULL                               AS LONG_TERM_TYPE
                    ,MAX(PLN.VERSION_NO)                AS VERSION_NO
					,PLN.COMPANY_ID
					,'*'							 AS PLANT_ID
            FROM 
                (   SELECT   @v_plan_tp_cd                                  AS PLAN_TP_CD
                            --,FINAL.PLAN_START_YYYYMMDD		                AS PLAN_START_YYYYMMDD
                            ,@v_plan_start_yyyymmdd                         AS PLAN_START_YYYYMMDD -- 2024.12.05 YSH
                            ,'S'						                    AS DATA_TP_CD
                            ,'S_TARGET'						                AS SRCE_TP_CD
                            ,FINAL.ORIGIN_DIVISION_ID				        AS DIVISION_ID
                            ,'*'                                            AS GROUP_CODE1
                            ,ISNULL(BOM.MODEL_ID, FINAL.ITEM_ID)            AS MODEL_ID
                            ,FINAL.ITEM_ID					                AS ORIGIN_ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS SRCE_YYYYMM
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS PLAN_YYYYMM
                            ,SUM(FINAL.QTY)					                AS QTY
 --                           ,MAX(SMS.PLANT_ID)                              AS PLANT_ID
                            ,MAX(FINAL.SCM_SITE_ID)			                AS SCM_SITE_ID
                            ,MAX(FINAL.OPERATION_GROUP)		                AS OPERATION_GROUP
                            ,MAX(FINAL.OPERATION_ID)			            AS OPERATION_ID
                            ,NULL						                    AS DEVALUATION_AGE
                            ,NULL						                    AS LONG_TERM_TYPE_CODE
                            ,NULL						                    AS LONG_TERM_TYPE
                            ,MAX(PLAN_VERSION_ID)						    AS VERSION_NO
							,FINAL.COMPANY_ID
							,FINAL.PLANT_ID
                    FROM  #TEMP_PROD_PLAN    FINAL WITH(NOLOCK) 
						  -- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - Start
						  INNER JOIN @SCP_CELL_ELEC_FINAL_OPERATION CE
								  ON CE.OPERATION_GROUP = 'A' -- Cell 공정
								 AND CE.OPERATION_ID	= FINAL.OPERATION_ID 
						  -- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - End
                    LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                        ON  SMS.DIVISION_ID = FINAL.ORIGIN_DIVISION_ID
                        AND SMS.SCM_SITE_ID = FINAL.SCM_SITE_ID
                        AND SMS.SITE_TYPE   = 'PLANT'
                    LEFT OUTER JOIN (   SELECT    BOM.DIVISION_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID
                                                , MAX(CASE WHEN BOM.PARENT_ITEM_ID = BOM.MODEL_ID THEN BOM.PARENT_ITEM_ID ELSE BOM.MODEL_ID END) AS MODEL_ID -- 2024.07.31 Philsu Park: CELL Assy 모델을 찾기 위해 PARENT_ITEM_ID 걸어옴.
                                        FROM      SCM_MST_BOM_SN BOM WITH(NOLOCK)
                                        INNER JOIN SCM_ITEM_M_SN ITM WITH(NOLOCK)
                                            ON  1=1
                                            AND ITM.DIVISION_ID = BOM.DIVISION_ID
                                            and ITM.ITEM_ID     = CASE WHEN BOM.PARENT_ITEM_ID = BOM.MODEL_ID THEN BOM.PARENT_ITEM_ID ELSE BOM.MODEL_ID END
                                        INNER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                                            ON ITM.ITEM_CLASS       = CLS.CLASS_ID
                                            AND CLS.PROCESS_GROUP   = N'Cell'
                                        WHERE   1=1 
                                        AND     BOM.DIVISION_ID     = @v_division_id
                                        AND     BOM.PARENT_ITEM_ID != '*'
                                        AND     EXISTS (SELECT  1
                                                        FROM    SCM_MST_BOM_SN MB WITH(NOLOCK)
                                                        WHERE   MB.COMPANY_ID     = BOM.COMPANY_ID
                                                        AND     MB.DIVISION_ID    = BOM.DIVISION_ID
                                                        AND     MB.MODEL_ID       = BOM.PARENT_ITEM_ID
                                                        UNION ALL
                                                        SELECT  1
                                                        FROM    SCM_MST_BOM_SN MB WITH(NOLOCK)
                                                        WHERE   MB.COMPANY_ID     = BOM.COMPANY_ID
                                                        AND     MB.DIVISION_ID    = BOM.DIVISION_ID
                                                        AND     MB.CHILD_ITEM_ID  = BOM.PARENT_ITEM_ID
                                                        )
                                        GROUP BY BOM.DIVISION_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID
                                    ) BOM
                        ON      BOM.DIVISION_ID     = FINAL.ORIGIN_DIVISION_ID
                        AND     BOM.PLANT_ID        = SMS.PLANT_ID
                        AND     BOM.CHILD_ITEM_ID   = FINAL.ITEM_ID
                    WHERE 1=1
                    AND FINAL.ORIGIN_DIVISION_ID    = @v_division_id
                    --AND FINAL.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                    AND FINAL.PLAN_START_YYYYMMDD   = @v_chg_plan_start_yyyymmdd	--2025-02-10 OIJ
                    AND FINAL.PLAN_TYPE             = 'FN'
                    AND FINAL.MEASURE			    = 'PROD_PLAN_AMEND'
                    -- [PJ20257329] 변경전 AND FINAL.OPERATION_ID         IN ('A9000', 'A3000')
                    AND FINAL.QTY                   > 0
                    AND FINAL.DIVISION_ID		  NOT LIKE 'EE%'
                    AND FINAL.YYYYMMDD             >= @v_basis_yyyymmdd
                    AND FINAL.YYYYMMDD              < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112)
                    GROUP BY FINAL.PLAN_START_YYYYMMDD
                            ,FINAL.ORIGIN_DIVISION_ID
                            --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)
                            ,ISNULL(BOM.MODEL_ID, FINAL.ITEM_ID)
                            ,FINAL.ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)
							,FINAL.COMPANY_ID
							,FINAL.PLANT_ID

                ) PLN
            LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                AND     L.VALID_YN      = 'Y'
                AND     L.SEGMENT1      = 'SPRD'
            LEFT OUTER JOIN SCP_ELEC EC
                ON      EC.DIVISION_ID      = PLN.DIVISION_ID
                AND     EC.PARENT_ITEM_ID   = PLN.MODEL_ID
                AND     EC.ITEM_CLASS       = L.SEGMENT2
            LEFT OUTER JOIN BOM_PRIORITY COMBOM
                ON      COMBOM.PLANT_ID     = PLN.PLANT_ID
                AND     COMBOM.MODEL_ID     = PLN.MODEL_ID
                AND     COMBOM.ITEM_CLASS   = L.SEGMENT2
            LEFT OUTER JOIN BOM_WITHOUT_PLANT BOM2
                ON      BOM2.MODEL_ID                       = PLN.MODEL_ID
                AND     BOM2.ITEM_CLASS                     = L.SEGMENT2
                AND     ISNULL(COMBOM.CHILD_ITEM_ID, '')    = ''
            WHERE   1=1
            AND     (EC.ITEM_CLASS IS NOT NULL OR ISNULL(COMBOM.ITEM_CLASS, BOM2.ITEM_CLASS) IS NOT NULL)
            GROUP BY PLN.PLAN_TP_CD
                    ,PLN.PLAN_START_YYYYMMDD
                    ,PLN.DATA_TP_CD
                    ,PLN.SRCE_TP_CD
                    ,PLN.DIVISION_ID
                    ,PLN.GROUP_CODE1
                    ,CASE WHEN L.ATTRIBUTE4 = 'Y' THEN ISNULL(ISNULL(ISNULL(EC.CHILD_ITEM_ID, COMBOM.CHILD_ITEM_ID), BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)
                          ELSE ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)   
                           END
                    ,PLN.ORIGIN_ITEM_ID
                    ,PLN.SRCE_YYYYMM
                    ,PLN.PLAN_YYYYMM
					,PLN.COMPANY_ID
					--,PLN.PLANT_ID
            ;
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------
        PRINT 'Step 2-3 End' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);



        ------------------------------------------------------------------------
        -- 2024.08.27 Philsu Park
        -- S_TARGET 에서 전극 공정의 경우, 수율 적용한 수량 반영.
        ------------------------------------------------------------------------
        BEGIN
            WITH YIELD AS ( SELECT    YLD.COMPANY_ID    AS COMPANY_ID
                                    , YLD.PLANT_ID      AS PLANT_ID
                                    , YLD.ELEC_MODEL    AS ELEC_MODEL
                                    , CAL.BASIS_YYYYMM  AS PLAN_YYYYMM
                                    , AVG(YLD.QTY)      AS ELEC_YIELD_VALUE
                            FROM    SCP_RPT_ELEC_PSI YLD WITH(NOLOCK)
                            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                                ON  YLD.YYYYMMDD = CAL.BASIS_YYYYMMDD
                            INNER JOIN (SELECT ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                        FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                                        GROUP BY ITEM_ID
                                        ) ITM
                                ON YLD.ELEC_MODEL = ITM.ITEM_ID
                            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                AND     L.VALID_YN      = 'Y'
                                AND     L.SEGMENT1      = 'SPRD'
                                AND     L.SEGMENT2      = ITM.ITEM_CLASS
                                AND     L.ATTRIBUTE4    = 'Y' -- 전극 ITEM CLASS 여부.
                            WHERE   1=1
                            AND     YLD.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
                            AND     YLD.MEASURE            IN ('YIELD_A', 'YIELD_E')
                            AND     YLD.PLAN_TYPE           = 'FN'
                            GROUP BY  YLD.COMPANY_ID
                                    , YLD.PLANT_ID
                                    , YLD.ELEC_MODEL
                                    , CAL.BASIS_YYYYMM
                            )
            UPDATE S
            SET    QTY = QTY / ISNULL(( SELECT  Y.ELEC_YIELD_VALUE 
                                        FROM    YIELD Y
                                        WHERE   Y.COMPANY_ID    = MST.COMPANY_ID
                                        AND     Y.PLANT_ID      = MST.PLANT_ID
                                        AND     Y.ELEC_MODEL    = S.ITEM_ID
                                        AND     Y.PLAN_YYYYMM   = S.PLAN_YYYYMM
                                    ), 1)
                , LAST_UPDATE_DATE  = GETDATE()
                , LAST_UPDATED_BY   = 'ELEC_YIELD_APPLIED'
            FROM SCM_LGTM_INV_PSI_SUMMARY_SPRD S
            INNER JOIN SCM_MST_SITE MST WITH(NOLOCK)
                ON MST.SCM_SITE_ID = S.SCM_SITE_ID
            INNER JOIN (SELECT  ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                        FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                        GROUP BY ITEM_ID
                        ) ITM
                ON S.ITEM_ID = ITM.ITEM_ID
            INNER JOIN SCM_ITEM_CLASS_M_SN CLS WITH(NOLOCK)
                ON CLS.CLASS_ID = ITM.ITEM_CLASS
            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                AND     L.VALID_YN      = 'Y'
                AND     L.SEGMENT1      = 'SPRD'
                AND     L.SEGMENT2      = ITM.ITEM_CLASS
                AND     L.ATTRIBUTE4    = 'Y' -- 전극 ITEM CLASS 여부.
            WHERE   1=1
            and     s.PLAN_TP_CD            = @v_plan_tp_cd
            and     S.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
            AND     S.DIVISION_ID           = @v_division_id
            AND     S.DATA_TP_CD            = 'S'
            AND     S.SRCE_TP_CD            = 'S_TARGET'
            ;
        END

        PRINT 'Yield Applied: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);

        ------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-5. Insert EE Semi-Product BOH from Long Term Stock
        -- 2024.08.08   Philsu Park:    Slurry 제외 로직 추가(SCM_LGTM_INV_EXC_ITEM_CLASS_CD)
        -- 2024.10.31   Philsu Park:    평가감을 장기재고에서 구분해서 가져오는 로직 반영.
        --                              VALUATION_CLASS IN ( '3004','3109','7909','7929' )
		------------------------------------------------------------------------  


		

			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
				,PLANT_ID )
			SELECT    @v_plan_tp_cd                             AS PLAN_TP_CD
                    , @v_plan_start_yyyymmdd                    AS PLAN_START_YYYYMMDD
                    , MM.DATA_TP_CD                             AS DATA_TP_CD
                    , MM.SRCE_TP_CD                             AS SRCE_TP_CD
                    , MM.DIVISION_ID                            AS DIVISION_ID
                    , MM.GROUP_CODE1                            AS GROUP_CODE1
                    , MM.ITEM_ID                                AS ITEM_ID
                    --, ISNULL(BOM.PARENT_ITEM_ID, MM.ITEM_ID)    AS ITEM_ID
                    , MM.ITEM_ID                                AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM                            AS SRCE_YYYYMM
                    , MM.YYYYMM                                 AS PLAN_YYYYMM
                    , SUM(MM.LONG_TERM_STOCK_QTY)               AS QTY 
                    , 'KRW'                                     AS CURRENCY
                    , NULL                                      AS STANDARD_COST
                    , NULL                                      AS AMT
                    , NULL                                      AS SCM_SITE_ID
                    , NULL                                      AS OPERATION_GROUP
                    , NULL                                      AS OPERATION_ID
                    , NULL                                      AS DEVALUATION_AGE
                    , NULL                                      AS LONG_TERM_TYPE_CODE
                    , NULL                                      AS LONG_TERM_TYPE
                    , NULL                                      AS VERSION_NO
					, ISNULL(MM.COMPANY_ID, '*')                AS COMPANY_ID
					, '*'										AS PLANT_ID
            FROM (
                    SELECT
                        A.DIVISION_ID                   AS DIVISION_ID
                        , 'RESULT'                      AS DATA_TP_CD
                        , CASE WHEN A.VALUATION_CLASS IN ('3004','3109','7909','7929') THEN 'BOH_DEVL' ELSE 'BOH_SPRD' END AS SRCE_TP_CD
                        , A.PLANT_ID                    AS PLANT_ID
                        , A.ITEM_ID                     AS ITEM_ID
                        , D.ITEM_TYPE                   AS ITEM_TYPE_ORG
                        , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                               WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                               ELSE D.ITEM_TYPE        
                                END                     AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                        , D.PROCESS_GROUP               AS PROCESS_GROUP
                        , D.PROCESS_DETAIL              AS PROCESS_DETAIL
                        , A.VALUATION_CLASS             AS VALUATION_CLASS
                        , A.LONG_TERM_STOCK_QTY         AS LONG_TERM_STOCK_QTY
                        , '*'                           AS GROUP_CODE1
                        , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                        , A.YYYYMM                      AS YYYYMM
                        -- , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                        -- , @v_basis_yyyymm               AS YYYYMM
						,COMPANY_ID = (SELECT TOP 1 SMS.COMPANY_ID FROM SCM_MST_SITE SMS WITH(NOLOCK) WHERE SMS.DIVISION_ID = A.DIVISION_ID AND SMS.PLANT_ID = A.PLANT_ID)    -- JJG 추가 2025.03.22
                    FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                    LEFT JOIN (
                                SELECT DISTINCT PLANT_ID, PLANT_NAME
                                FROM SCM_PLANT_M_SN WITH(NOLOCK)
                                UNION ALL
                                SELECT SEGMENT1 AS PLANT_ID, SEGMENT2 AS PLANT_NAME
                                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                    WHERE LOOKUP_TYPE   = 'INVENTORY_SITE'
                                    AND VALID_YN = 'Y'
                                ) B
                        ON  A.PLANT_ID = B.PLANT_ID
                    LEFT JOIN ( SELECT  ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE   1=1
                    AND A.DIVISION_ID   = @v_division_id
                    AND A.YYYYMM        > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND A.YYYYMM       <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    --AND A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND C.ITEM_CLASS NOT IN (   SELECT  SEGMENT2    AS ITEM_CLASS -- 재고에서 Slurry 제외 로직 추가.
                                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                WHERE   LK.LOOKUP_TYPE  = 'SCM_LGTM_INV_EXC_ITEM_CLASS_CD'
                                                AND     LK.VALID_YN     = 'Y'
                                                AND     LK.SEGMENT1     = 'SPRD'
                                            )
                    UNION ALL
                    SELECT
                        A.DIVISION_ID                   AS DIVISION_ID
                        , 'BOH'                         AS DATA_TP_CD
                        , CASE WHEN A.VALUATION_CLASS IN ('3004','3109','7909','7929') THEN 'BOH_DEVL' ELSE 'BOH_SPRD' END AS SRCE_TP_CD
                        , A.PLANT_ID                    AS PLANT_ID
                        , A.ITEM_ID                     AS ITEM_ID
                        , D.ITEM_TYPE                   AS ITEM_TYPE_ORG
                        , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                               WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                               ELSE D.ITEM_TYPE
                                END                     AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                        , D.PROCESS_GROUP               AS PROCESS_GROUP
                        , D.PROCESS_DETAIL              AS PROCESS_DETAIL
                        , A.VALUATION_CLASS             AS VALUATION_CLASS
                        , A.LONG_TERM_STOCK_QTY         AS LONG_TERM_STOCK_QTY
                        , '*'                           AS GROUP_CODE1
                        , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                        , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS YYYYMM
                        -- , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                        -- , @v_basis_yyyymm               AS YYYYMM
						,COMPANY_ID = (SELECT TOP 1 SMS.COMPANY_ID FROM SCM_MST_SITE SMS WITH(NOLOCK) WHERE SMS.DIVISION_ID = A.DIVISION_ID AND SMS.PLANT_ID = A.PLANT_ID)    -- JJG 추가 2025.03.22
                    FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                    LEFT JOIN (
                                SELECT DISTINCT PLANT_ID, PLANT_NAME
                                FROM SCM_PLANT_M_SN WITH(NOLOCK)
                                UNION ALL
                                SELECT SEGMENT1 AS PLANT_ID, SEGMENT2 AS PLANT_NAME
                                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                    WHERE LOOKUP_TYPE   = 'INVENTORY_SITE'
                                    AND VALID_YN = 'Y'
                                ) B
                        ON  A.PLANT_ID = B.PLANT_ID
                    LEFT JOIN ( SELECT  ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE   1=1
                    AND A.DIVISION_ID   = @v_division_id
                    AND A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND C.ITEM_CLASS NOT IN (   SELECT  SEGMENT2    AS ITEM_CLASS -- 재고에서 Slurry 제외 로직 추가.
                                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                WHERE   LK.LOOKUP_TYPE  = 'SCM_LGTM_INV_EXC_ITEM_CLASS_CD'
                                                AND     LK.VALID_YN     = 'Y'
                                                AND     LK.SEGMENT1     = 'SPRD'
                                            )
                    /* AND A.YYYYMM        >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND A.YYYYMM        <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                ) MM
            WHERE 1=1
            AND MM.ITEM_TYPE        = N'반제품'
            AND MM.PROCESS_GROUP   != 'CELL'
            GROUP BY  MM.DATA_TP_CD
                    , MM.SRCE_TP_CD
                    , MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , MM.ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
					, MM.COMPANY_ID
					--, MM.PLANT_ID
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-5 End';


        BEGIN
		------------------------------------------------------------------------
		-- Step 2-6. Insert Intransit from Ending Stock.
        -- Valuation Class: 7900만 있음. 24년 6월 마감재고 기준.
        -- 2024.08.08 Philsu Park: Slurry 제외 로직 추가(SCM_LGTM_INV_EXC_ITEM_CLASS_CD)
		------------------------------------------------------------------------  

		

			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
				,PLANT_ID )
			SELECT  @v_plan_tp_cd               AS PLAN_TP_CD 
                    , @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , DATA_TP_CD                AS DATA_TP_CD
                    , 'BOH_INTS'                AS SRCE_TP_CD
                    , DIVISION_ID               AS DIVISION_ID
                    , GROUP_CODE1               AS GROUP_CODE1
                    , ITEM_ID                   AS ITEM_ID
                    , ITEM_ID                   AS ORIGIN_ITEM_ID
                    , SRCE_YYYYMM               AS SRCE_YYYYMM
                    , YYYYMM                    AS PLAN_YYYYMM
                    , SUM(QUANTITY)             AS QTY 
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
					, ISNULL(MM.COMPANY_ID,'*') -- 20251105 YMH E20250821-001381 오류수정
					, '*'						AS PLANT_ID
                FROM ( /*실적 UNION 계획 */
                        SELECT  B.DIVISION_ID       AS DIVISION_ID
                                , 'RESULT'          AS DATA_TP_CD
                                , B.ITEM_ID         AS ITEM_ID
                                , B.QUANTITY        AS QUANTITY
                                , D.ITEM_TYPE       AS ITEM_TYPE_ORG
                                , D.PROCESS_GROUP   AS PROCESS_GROUP
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE
                                        END         AS ITEM_TYPE
                                , '*'               AS GROUP_CODE1
                                , B.YYYYMM          AS SRCE_YYYYMM
                                , B.YYYYMM          AS YYYYMM
                                -- , @v_basis_yyyymm   AS SRCE_YYYYMM
                                -- , @v_basis_yyyymm   AS YYYYMM
								,B.PLANT_ID
								--,E.COMPANY_ID -- 20251105 YMH E20250821-001381 주석처리 기존로직 주석처리
								, B.COMPANY_ID -- 20251105 YMH E20250821-001381 주석처리 신규로직
                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON  C.ITEM_CLASS = D.CLASS_ID
					    LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
					       ON B.DIVISION_ID = E.DIVISION_ID
						  AND B.PLANT_ID = E.PLANT_ID
                        WHERE  1=1
                        AND B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        --and B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND B.DIVISION_ID       = @v_division_id
                        AND B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                        AND D.ITEM_TYPE         = N'반제품' 
                        AND D.PROCESS_GROUP    != 'CELL'
                        AND C.ITEM_CLASS NOT IN (   SELECT  SEGMENT2    AS ITEM_CLASS -- 재고에서 Slurry 제외 로직 추가.
                                                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                    WHERE   LK.LOOKUP_TYPE  = 'SCM_LGTM_INV_EXC_ITEM_CLASS_CD'
                                                    AND     LK.VALID_YN     = 'Y'
                                                    AND     LK.SEGMENT1     = 'SPRD'
                                                )
                        UNION ALL
                        SELECT  B.DIVISION_ID       AS DIVISION_ID
                                , 'BOH'             AS DATA_TP_CD
                                , B.ITEM_ID         AS ITEM_ID
                                , B.QUANTITY        AS QUANTITY
                                , D.ITEM_TYPE       AS ITEM_TYPE_ORG
                                , D.PROCESS_GROUP   AS PROCESS_GROUP
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE
                                        END         AS ITEM_TYPE
                                , '*'               AS GROUP_CODE1
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                                -- , @v_basis_yyyymm   AS SRCE_YYYYMM
                                -- , @v_basis_yyyymm   AS YYYYMM
								,B.PLANT_ID
								--,E.COMPANY_ID -- 20251105 YMH E20250821-001381 주석처리 기존로직 주석처리
								, B.COMPANY_ID -- 20251105 YMH E20250821-001381 주석처리 신규로직
                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON  C.ITEM_CLASS = D.CLASS_ID
					    LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
					       ON B.DIVISION_ID = E.DIVISION_ID
						  AND B.PLANT_ID = E.PLANT_ID
                        WHERE  1=1
                        /* AND B.YYYYMM           >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                        and B.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND B.DIVISION_ID       = @v_division_id
                        AND B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                        AND D.ITEM_TYPE         = N'반제품' 
                        AND D.PROCESS_GROUP    != 'CELL'
                        AND C.ITEM_CLASS NOT IN (   SELECT  SEGMENT2    AS ITEM_CLASS -- 재고에서 Slurry 제외 로직 추가.
                                                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                    WHERE   LK.LOOKUP_TYPE  = 'SCM_LGTM_INV_EXC_ITEM_CLASS_CD'
                                                    AND     LK.VALID_YN     = 'Y'
                                                    AND     LK.SEGMENT1     = 'SPRD'
                                                )
                    ) MM
                WHERE 1=1
                GROUP BY  DATA_TP_CD
                        , DIVISION_ID
                        , GROUP_CODE1
                        , ITEM_ID
                        , SRCE_YYYYMM
                        , YYYYMM
						, MM.COMPANY_ID
						--, MM.PLANT_ID
                ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-6 End';
        ------------------------------------------------------------------------  

-- to here 32s


        /* BEGIN
		------------------------------------------------------------------------
		-- Step 2-7. Insert 평가감 Semi-Product from Ending Stock.
        -- 평가감은 일단 Item Id 그대로 유지. 매핑 없음.
        -- 2024.10.31   Philsu Park:    평가감(BOH_DEVL)은 장기재고 Table에서 가져오는 것으로 변경. 기존 구문 주석처리.
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
                ,VERSION_NO)
			SELECT    @v_plan_tp_cd             AS PLAN_TP_CD 
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
            FROM ( 
                    --평가감.
                    SELECT B.DIVISION_ID            AS DIVISION_ID
                        , 'RESULT'                  AS DATA_TP_CD
                        , B.ITEM_ID                 AS ITEM_ID
                        , B.STORAGE_LOCATION        AS STORAGE_LOCATION
                        , B.VALUATION_CLASS         AS VALUATION_CLASS
                        , B.QUANTITY                AS QUANTITY
                        , D.ITEM_TYPE               AS ITEM_TYPE_ORG
                        , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                ELSE D.ITEM_TYPE        
                                END                 AS ITEM_TYPE
                        , '*'                       AS GROUP_CODE1
                        , D.PROCESS_GROUP           AS PROCESS_GROUP
                        , B.YYYYMM                  AS SRCE_YYYYMM
                        , B.YYYYMM                  AS YYYYMM
                        -- , SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) AS SRCE_YYYYMM
                        -- , @v_basis_yyyymm           AS YYYYMM
                    FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                    LEFT JOIN ( SELECT  ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  B.ITEM_ID   = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE   1=1
                    AND B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    --and     B.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND B.DIVISION_ID       = @v_division_id
                    AND B.VALUATION_CLASS  IN ('3109', '7909', '7929')
                    AND B.STORAGE_LOCATION != N'미착'
                    AND D.ITEM_TYPE         = N'반제품'
                    AND D.PROCESS_GROUP    != 'CELL'
                    AND C.ITEM_CLASS NOT IN (   SELECT  SEGMENT2    AS ITEM_CLASS -- 재고에서 Slurry 제외 로직 추가.
                                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                WHERE   LK.LOOKUP_TYPE  = 'SCM_LGTM_INV_EXC_ITEM_CLASS_CD'
                                                AND     LK.VALID_YN     = 'Y'
                                                AND     LK.SEGMENT1     = 'SPRD'
                                            )
                    UNION ALL
                    SELECT B.DIVISION_ID            AS DIVISION_ID
                        , 'BOH'                     AS DATA_TP_CD
                        , B.ITEM_ID                 AS ITEM_ID
                        , B.STORAGE_LOCATION        AS STORAGE_LOCATION
                        , B.VALUATION_CLASS         AS VALUATION_CLASS
                        , B.QUANTITY                AS QUANTITY
                        , D.ITEM_TYPE               AS ITEM_TYPE_ORG
                        , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                ELSE D.ITEM_TYPE        
                                END                 AS ITEM_TYPE
                        , '*'                       AS GROUP_CODE1
                        , D.PROCESS_GROUP           AS PROCESS_GROUP
                        , B.YYYYMM                  AS SRCE_YYYYMM
                        , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                        -- , SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) AS SRCE_YYYYMM
                        -- , @v_basis_yyyymm           AS YYYYMM
                    FROM    SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                    LEFT JOIN ( SELECT  ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  B.ITEM_ID   = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE   1=1
                    AND B.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND B.DIVISION_ID       = @v_division_id
                    AND B.VALUATION_CLASS  IN ('3109', '7909', '7929')
                    AND B.STORAGE_LOCATION != N'미착'
                    AND D.ITEM_TYPE         = N'반제품'
                    AND D.PROCESS_GROUP    != 'CELL'
                    AND C.ITEM_CLASS NOT IN (   SELECT  SEGMENT2    AS ITEM_CLASS -- 재고에서 Slurry 제외 로직 추가.
                                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                WHERE   LK.LOOKUP_TYPE  = 'SCM_LGTM_INV_EXC_ITEM_CLASS_CD'
                                                AND     LK.VALID_YN     = 'Y'
                                                AND     LK.SEGMENT1     = 'SPRD'
                                            )
                    /* AND B.YYYYMM           >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                ) MM
            WHERE 1=1
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
        PRINT 'Step 2-7 End'; */
        ------------------------------------------------------------------------  

        BEGIN
        ------------------------------------------------------------------------
		-- Step 2-9. Insert 완제품 재고 소진계획. 
        -- 2024.09.12 Philsu Park: 장기재고 소진계획 신규 UI 기준 테이블(SCP_ANL_LGTM_INV_MGMT_PLAN)로 변경.
        -- 2024.10.18 Philsu Park: 소진계획은 초기버전 이외에만 적용.
		------------------------------------------------------------------------  

		

            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
				,PLANT_ID )
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
					, isnull(INV.COMPANY_ID,'*')  AS COMPANY_ID
					, '*'					    AS PLANT_ID
            FROM SCP_ANL_LGTM_INV_MGMT_PLAN INV WITH(NOLOCK)
			LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
			       ON INV.DIVISION_ID = E.DIVISION_ID
			      AND INV.PLANT_ID = E.PLANT_ID
            WHERE   INV.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     INV.PLAN_TP_CD          = @v_plan_tp_cd
            AND     INV.DIVISION_ID         = @v_division_id
            and     @v_plan_tp_cd           = @v_plan_tp_org
            GROUP BY  INV.DIVISION_ID
                    , INV.ITEM_ID
                    , INV.PLAN_YYYYMM
					, INV.COMPANY_ID
					--, INV.PLANT_ID

            ;
        ------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------  
        PRINT 'Step 2-8 S_EXHT End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------  


        ------------------------------------------------------------------------  
		/* BEGIN
		------------------------------------------------------------------------
		-- Step 2-8. S from 소진계획 생성.
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD
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
                ,VERSION_NO)
			SELECT    @v_plan_tp_cd                             AS PLAN_TP_CD
                    , @v_plan_start_yyyymmdd                    AS PLAN_START_YYYYMMDD
                    , 'S'                                       AS DATA_TP_CD
                    , 'S_EXHT'                                  AS SRCE_TP_CD
                    , MM.DIVISION_ID                            AS DIVISION_ID
                    , MM.GROUP_CODE1                            AS GROUP_CODE1
                    , MM.ITEM_ID                                AS ITEM_ID
                    --, ISNULL(BOM.PARENT_ITEM_ID, MM.ITEM_ID)    AS ITEM_ID
                    , MM.ITEM_ID                                AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM                            AS SRCE_YYYYMM
                    , MM.YYYYMM                                 AS PLAN_YYYYMM
                    , SUM(MM.QTY)                               AS QTY 
                    , 'KRW'                                     AS CURRENCY
                    , NULL                                      AS STANDARD_COST
                    , NULL                                      AS AMT
                    , NULL                                      AS SCM_SITE_ID
                    , NULL                                      AS OPERATION_GROUP
                    , NULL                                      AS OPERATION_ID
                    , NULL                                      AS DEVALUATION_AGE
                    , NULL                                      AS LONG_TERM_TYPE_CODE
                    , NULL                                      AS LONG_TERM_TYPE
                    , NULL                                      AS VERSION_NO
            FROM ( 
                    SELECT  LTS.DIVISION_ID         AS DIVISION_ID
                            , LTS.PLANT_ID          AS PLANT_ID
                            , LTS.ITEM_ID           AS ITEM_ID
                            , LTS.LONG_TERM_TYPE    AS LONG_TERM_TYPE
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG                                                                                                                    
                            ,   CASE WHEN LTS.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                     WHEN LTS.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                     ELSE D.ITEM_TYPE
                                      END           AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , LTS.VALUATION_CLASS   AS VALUATION_CLASS
                            , IEP.QTY               AS QTY
                            , '*'                   AS GROUP_CODE1
                            /* , CASE WHEN ISNULL(T.GROUP_CODE1, '') = '' THEN LTS.ITEM_ID
                                   ELSE ISNULL(T.GROUP_CODE1, '')
                                    END             AS GROUP_CODE1 */
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
                    /* LEFT OUTER JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK)
                        ON  T.DIVISION_ID   = LTS.DIVISION_ID
                        AND T.ITEM_ID       = LTS.ITEM_ID */
                    WHERE 1=1
                    AND LTS.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND LTS.DIVISION_ID   = @v_division_id
                ) MM
            WHERE 1=1
            AND MM.ITEM_TYPE        = N'반제품'
            AND MM.PROCESS_GROUP   != 'CELL'
            GROUP BY  MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , MM.ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-8 End'; */

        PRINT 'ESS Change Start: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------  
		BEGIN
            --82사업부 전극 공정 Item 추출
            WITH BOM_PRIORITY AS (
                                    SELECT    SMB.PLANT_ID, SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                    FROM      ( SELECT DENSE_RANK()OVER(PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.MODEL_ID, SME.CONCATENATE_ITEM 
                                                                        ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                        , SME.PLANT_ID, SME.MODEL_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                INNER JOIN (SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                            FROM    SCM_ITEM_M_SN  WITH(NOLOCK)
                                                            GROUP BY DIVISION_ID, ITEM_ID
                                                            )  T
                                                    ON      T.DIVISION_ID   = SME.DIVISION_ID
                                                    AND     T.ITEM_ID       = SME.CHILD_ITEM_ID
                                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                    ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                    AND     L.VALID_YN      = 'Y'
                                                    AND     L.SEGMENT1      = @v_plan_tp_cd
                                                    AND     L.SEGMENT2      = T.ITEM_CLASS
                                                    AND     L.ATTRIBUTE4    = 'Y'
                                                WHERE   1=1
                                                AND     SME.ALT_PRIORITY    = 'Y'
                                                AND     SME.EFF_END_DATE   >= GETDATE()
                                                AND     SME.MODEL_ID       <> SME.CHILD_ITEM_ID
                                                ) AS SMB
                                    WHERE 1=1
                                    AND     SMB.RNK = 1
                                    GROUP BY SMB.PLANT_ID, SMB.MODEL_ID, SMB.CHILD_ITEM_ID
                                    )
                , BOM_WITHOUT_PLANT AS (
                                        SELECT  SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                        FROM    (   SELECT  DENSE_RANK()OVER(PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.MODEL_ID, SME.CONCATENATE_ITEM
                                                                                ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                            , DENSE_RANK()OVER(PARTITION BY SME.DIVISION_ID, SME.MODEL_ID
                                                                            ORDER BY        SME.EFF_START_DATE DESC, SME.COMPANY_ID, SME.PLANT_ID, SME.SITE_ID ) AS RNK2
                                                            , SME.PLANT_ID, SME.MODEL_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                    FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                    INNER JOIN (SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                                FROM    SCM_ITEM_M_SN  WITH(NOLOCK)
                                                                GROUP BY DIVISION_ID, ITEM_ID
                                                                )  T
                                                        ON      T.DIVISION_ID   = SME.DIVISION_ID
                                                        AND     T.ITEM_ID       = SME.CHILD_ITEM_ID
                                                    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                                        ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                        AND     L.VALID_YN      = 'Y'
                                                        AND     L.SEGMENT1      = @v_plan_tp_cd
                                                        AND     L.SEGMENT2      = T.ITEM_CLASS
                                                        AND     L.ATTRIBUTE4    = 'Y'
                                                    WHERE   1=1 
                                                    AND     SME.ALT_PRIORITY    = 'Y'
                                                    AND     SME.EFF_END_DATE   >= GETDATE()
                                                    AND     SME.MODEL_ID       <> SME.CHILD_ITEM_ID
                                                    ) AS SMB
                                        WHERE 1=1
                                        AND     SMB.RNK     = 1
                                        AND     SMB.RNK2    = 1
                                        GROUP BY SMB.MODEL_ID, SMB.CHILD_ITEM_ID
                                        )
            SELECT  DISTINCT ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID) AS ITEM_ID
            INTO    #TEMP_ESS_ITEM
            FROM 
                (   SELECT   FINAL.ORIGIN_DIVISION_ID				        AS DIVISION_ID
                            ,ISNULL(BOM.MODEL_ID, FINAL.ITEM_ID)            AS MODEL_ID
                            ,FINAL.ITEM_ID					                AS ORIGIN_ITEM_ID
                            ,FINAL.PLANT_ID                                   AS PLANT_ID
                    FROM  #TEMP_PROD_PLAN    FINAL WITH(NOLOCK) 
						  -- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - Start
						  INNER JOIN @SCP_CELL_ELEC_FINAL_OPERATION CE
								  ON CE.OPERATION_GROUP = 'A' -- Cell 공정
								 AND CE.OPERATION_ID	= FINAL.OPERATION_ID 
						  -- [PJ20257329] Cell/전극 완성 공정 하드 코딩 변경 - End
                    LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                        ON  SMS.DIVISION_ID = FINAL.ORIGIN_DIVISION_ID
                        AND SMS.SCM_SITE_ID = FINAL.SCM_SITE_ID
                        AND SMS.SITE_TYPE   = 'PLANT'
                    LEFT OUTER JOIN (   SELECT    BOM.DIVISION_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID
                                                , MAX(CASE WHEN BOM.PARENT_ITEM_ID = BOM.MODEL_ID THEN BOM.PARENT_ITEM_ID ELSE BOM.MODEL_ID END) AS MODEL_ID -- 2024.07.31 Philsu Park: CELL Assy 모델을 찾기 위해 PARENT_ITEM_ID 걸어옴.
                                        FROM      SCM_MST_BOM_SN BOM WITH(NOLOCK)
                                        INNER JOIN SCM_ITEM_M_SN ITM WITH(NOLOCK)
                                            ON  1=1
                                            AND ITM.DIVISION_ID = BOM.DIVISION_ID
                                            and ITM.ITEM_ID     = CASE WHEN BOM.PARENT_ITEM_ID = BOM.MODEL_ID THEN BOM.PARENT_ITEM_ID ELSE BOM.MODEL_ID END
                                        INNER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                                            ON ITM.ITEM_CLASS       = CLS.CLASS_ID
                                            AND CLS.PROCESS_GROUP   = N'Cell'
                                        WHERE   1=1 
                                        AND     BOM.PARENT_ITEM_ID != '*'
                                        AND     EXISTS (SELECT  1
                                                        FROM    SCM_MST_BOM_SN MB WITH(NOLOCK)
                                                        WHERE   MB.COMPANY_ID     = BOM.COMPANY_ID
                                                        AND     MB.DIVISION_ID    = BOM.DIVISION_ID
                                                        AND     MB.MODEL_ID       = BOM.PARENT_ITEM_ID
                                                        UNION ALL
                                                        SELECT  1
                                                        FROM    SCM_MST_BOM_SN MB WITH(NOLOCK)
                                                        WHERE   MB.COMPANY_ID     = BOM.COMPANY_ID
                                                        AND     MB.DIVISION_ID    = BOM.DIVISION_ID
                                                        AND     MB.CHILD_ITEM_ID  = BOM.PARENT_ITEM_ID
                                                        )
                                        GROUP BY BOM.DIVISION_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID
                                    ) BOM
                        ON      BOM.DIVISION_ID     = FINAL.ORIGIN_DIVISION_ID
                        AND     BOM.PLANT_ID        = SMS.PLANT_ID
                        AND     BOM.CHILD_ITEM_ID   = FINAL.ITEM_ID
                    WHERE 1=1
                    AND FINAL.ORIGIN_DIVISION_ID    = '82'
                    --AND FINAL.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                    AND FINAL.PLAN_START_YYYYMMDD   = @v_chg_plan_start_yyyymmdd	--2025-02-10 OIJ
                    AND FINAL.PLAN_TYPE             = 'FN'
                    AND FINAL.MEASURE			    = 'PROD_PLAN_AMEND'
                    -- [PJ20257329] 변경전 AND FINAL.OPERATION_ID         IN ('A9000', 'A3000')
                    AND FINAL.QTY                   > 0
                    AND FINAL.DIVISION_ID		  NOT LIKE 'EE%'
                    AND FINAL.YYYYMMDD             >= @v_basis_yyyymmdd
                    AND FINAL.YYYYMMDD              < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112)
                    GROUP BY FINAL.ORIGIN_DIVISION_ID
                            ,ISNULL(BOM.MODEL_ID, FINAL.ITEM_ID)
                            ,FINAL.ITEM_ID
                            ,FINAL.PLANT_ID
                ) PLN
            LEFT OUTER JOIN BOM_PRIORITY COMBOM
                ON      COMBOM.PLANT_ID     = PLN.PLANT_ID
                AND     COMBOM.MODEL_ID     = PLN.MODEL_ID
            LEFT OUTER JOIN BOM_WITHOUT_PLANT BOM2
                ON      BOM2.MODEL_ID                       = PLN.MODEL_ID
                AND     ISNULL(COMBOM.CHILD_ITEM_ID, '')    = ''
            WHERE   1=1
            AND     ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), PLN.ORIGIN_ITEM_ID) != PLN.ORIGIN_ITEM_ID
            ;

            ------------------------------------------------------------------------
            -- Step 2-9. 81의 ESS 삭제. 82로 보내야함
            ------------------------------------------------------------------------ 
            IF  @v_division_id = '81' 
            ------------------------------------------------------------------------
                BEGIN 
                
                    DELETE FROM SCM_LGTM_INV_PSI_SUMMARY_SPRD
                    WHERE   1=1
                    AND     PLAN_TP_CD          = @v_plan_tp_cd
                    AND     DIVISION_ID         = @v_division_id
                    AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
                    AND     DATA_TP_CD          = 'P'
                    AND     ITEM_ID             IN ( SELECT ITEM_ID FROM #TEMP_ESS_ITEM )
                    ;
            ------------------------------------------------------------------------ 
                END
            ------------------------------------------------------------------------ 
		    END
            ------------------------------------------------------------------------  
            PRINT 'Step 2-9 End';
            ------------------------------------------------------------------------



        ------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-10. 81의 ESS를 82의 P로 생성
		------------------------------------------------------------------------ 
            IF  @v_division_id = '82' 
            ------------------------------------------------------------------------
                BEGIN 
                ------------------------------------------------------------------------
                    
                 
                    SELECT   @v_plan_tp_cd                                  AS PLAN_TP_CD
                            --,FINAL.PLAN_START_YYYYMMDD		                AS PLAN_START_YYYYMMDD
                            ,@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD  -- 2024.12.05 YSH
                            ,'P'						                    AS DATA_TP_CD
                            ,'P'						                    AS SRCE_TP_CD
                            ,@v_division_id				                    AS DIVISION_ID
                            ,'*'                                            AS GROUP_CODE1
                            --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)			AS GROUP_CODE1
                            ,FINAL.ITEM_ID                                  AS ITEM_ID
                            ,FINAL.ITEM_ID					                AS ORIGIN_ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS SRCE_YYYYMM
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS PLAN_YYYYMM
                            ,SUM(FINAL.QTY)					                AS QTY	
                            ,NULL							                AS CURRENCY
                            ,NULL							                AS STANDARD_COST
                            ,NULL							                AS AMT
                            ,MAX(FINAL.SCM_SITE_ID)			                AS SCM_SITE_ID
                            ,MAX(FINAL.OPERATION_GROUP)		                AS OPERATION_GROUP
                            ,MAX(FINAL.OPERATION_ID)			            AS OPERATION_ID
                            ,NULL						                    AS DEVALUATION_AGE
                            ,NULL						                    AS LONG_TERM_TYPE_CODE
                            ,NULL						                    AS LONG_TERM_TYPE
                            ,'81_ESS'						                AS VERSION_NO
							,FINAL.COMPANY_ID	AS COMPANY_ID
							,'*'	AS PLANT_ID
                    FROM  #TEMP_PROD_PLAN        FINAL WITH(NOLOCK)
                    INNER JOIN #TEMP_ESS_ITEM                       ESS   WITH(NOLOCK)
                        ON ESS.ITEM_ID = FINAL.ITEM_ID
                    WHERE 1=1
                    AND FINAL.ORIGIN_DIVISION_ID    = '81'
                    --AND FINAL.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd 
                    AND FINAL.PLAN_START_YYYYMMDD   = @v_chg_plan_start_yyyymmdd	--2025-02-10 OIJ
                    AND FINAL.PLAN_TYPE             = 'FN'  
                    AND FINAL.MEASURE			    = 'PROD_PLAN_AMEND' 
                    AND FINAL.DIVISION_ID	     LIKE 'EE%'
                    AND FINAL.OPERATION_ID          = 'E2000'
                    AND FINAL.QTY                   > 0
                    AND FINAL.YYYYMMDD             >= @v_basis_yyyymmdd
                    AND FINAL.YYYYMMDD              < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
                    GROUP BY FINAL.PLAN_START_YYYYMMDD
                            ,FINAL.ORIGIN_DIVISION_ID
                            ,FINAL.ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)  
							,FINAL.COMPANY_ID
                    ------------------------------------------------------------------------ 
                END
                    ------------------------------------------------------------------------ 
            END
		------------------------------------------------------------------------  
        PRINT 'ESS Change End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        PRINT 'Step 2-10 End';
        ------------------------------------------------------------------------

        IF OBJECT_ID (N'tempdb..#TEMP_PROD_PLAN', N'U') IS NOT NULL     DROP TABLE #TEMP_PROD_PLAN;
        IF OBJECT_ID (N'tempdb..#TEMP_ESS_ITEM', N'U') IS NOT NULL 		DROP TABLE #TEMP_ESS_ITEM;

--jjg		COMMIT TRANSACTION;
	END TRY

	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
--jjg	ROLLBACK TRANSACTION PR_SCM_LGTM_INV_ALLOCATION_SPRD;
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

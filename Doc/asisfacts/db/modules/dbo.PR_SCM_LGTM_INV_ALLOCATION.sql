
/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION
 * Description  : 장기재고 관련 BOH,P,S 정보 취합/형성
 * OutTable     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.06.05   KIMCD          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                             E20250529-001245 MJ~로 시작하는 자재코드의 S 미형성으로 인한 재고 증가 현상 보완
 * 2025.08.01   hrkim		   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경 
 */
CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
	,@p_chg_plan_start_yyyymmdd     NVARCHAR(8)
AS 
BEGIN

--exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT_INIT', '81_ST', '20250303', '202503', '20250303'
--exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT_INIT', '81', '20250303', '202503', '20250303'
--exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT_INIT', '81_HD', '20250303', '202503', '20250303'
--exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT_INIT', '82', '20250303', '202503', '20250303'
--exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT_INIT', '40', '20250303', '202503', '20250303'
--exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT_INIT', '81_UC', '20250303', '202503', '20250303'
--exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT_INIT', '81_HM', '20250303', '202503', '20250303'


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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION';
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
    DECLARE @v_plan_tp_cd           NVARCHAR(20)    = @p_plan_tp_cd;            -- 'FERT';
    DECLARE @v_division_id          NVARCHAR(10)    = @p_division_id            -- '82';
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = @p_basis_yyyymm           -- '202407';    
    DECLARE @v_basis_yyyymmdd       NVARCHAR(8)     = CONCAT(@v_basis_yyyymm, '01')           -- '202407';
    DECLARE @v_plan_tp_org          NVARCHAR(20)    = SUBSTRING(@v_plan_tp_cd, 1, 4);
	DECLARE @v_chg_plan_start_yyyymmdd  NVARCHAR(8)     = @p_chg_plan_start_yyyymmdd    -- '20240701';
    ------------------------------------------------------------------------  
		
	------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final공정 정보' 
	------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'		-- 공정그룹 (Cell) 
	   AND LK.ATTRIBUTE1  = 'Y'		-- Final Operation
	------------------------------------------------------------------------------------

	------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
--jjg	BEGIN TRANSACTION PR_SCM_LGTM_INV_ALLOCATION;
	------------------------------------------------------------------------ 

    PRINT 'Div.: '+@v_division_id+'//PST YMD: '+@v_plan_start_yyyymmdd+'//Basis YM: '+@v_basis_yyyymm;

	------------------------------------------------------------------------  
	BEGIN TRY
		------------------------------------------------------------------------
		-- Step 1. Initialize Data
		------------------------------------------------------------------------
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-1. Delete SCM_LGTM_INV_PSI_SUMMARY
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     ORIGIN_DIVISION_ID          = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  
        PRINT 'Step 1-1 End';
		
		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-2. Delete SCM_LGTM_INV_PSI_DETAIL
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_DETAIL
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     ORIGIN_DIVISION_ID         = @v_division_id  --LIKE CONCAT(@v_division_id, '%')         
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 1-2 End';




		------------------------------------------------------------------------  
        BEGIN
        ------------------------------------------------------------------------
		-- Step 2. Insert Data
		------------------------------------------------------------------------
		-- Step 2-1. Insert P from SCP-FINAL
        /*
        2024.08.05 Philsu Park: Item_Id A공정 외에도 전부 BOM 상위로 올림.
        */

            IF OBJECT_ID (N'tempdb..#TEMP_PROD_PLAN', N'U') IS NOT NULL 		DROP TABLE #TEMP_PROD_PLAN;
           
            WITH VERSION_INFO AS (  SELECT  PLM.DIVISION_ID, PLM.PLAN_NAME AS PLAN_START_YYYYMMDD, PLD.PLAN_TYPE, MAX(PLAN_SEQ) AS PLAN_SEQ
                                          , PLM.PLAN_NAME + '-' + PLD.PLAN_TYPE + '-' + DBO.FN_ZERO_LPAD(CONVERT(NVARCHAR,MAX(PLAN_SEQ)),2) AS PLAN_VERSION_ID
                                    FROM    SCM_MST_PLAN PLM WITH(NOLOCK)
                                    INNER JOIN SCM_MST_PLAN_DETAIL PLD WITH(NOLOCK)
                                        ON  PLM.DIVISION_ID = PLD.DIVISION_ID
                                        AND PLM.PLAN_ID     = PLD.PLAN_ID
                                    WHERE   1=1
                                    --AND     PLM.PLAN_NAME       = @v_plan_start_yyyymmdd
                                    AND     PLM.PLAN_NAME		= @v_chg_plan_start_yyyymmdd  -- 2025.02.10 OIJ
                                    AND     PLM.PLAN_CYCLE      = 'WEEKLY'
                                    AND     PLD.PLAN_TYPE       = 'FN'
                                    AND     PLD.CONFIRM_FLAG    = 'Y'
                                    AND     PLD.PLAN_STATUS     = '1'
                                    AND     PLD.UI_DISPLAY_YN   = 'Y'
                                    GROUP BY PLM.DIVISION_ID, PLM.PLAN_NAME, PLD.PLAN_TYPE
                                    )
            -------------------------------------------------------
            -------------------------------------------------------

            SELECT PROD.*
            INTO #TEMP_PROD_PLAN
            FROM ( 
                    SELECT  FINAL.*
                            , VER.PLAN_VERSION_ID
							, SMS.COMPANY_ID	--OIJ
							, SMS.PLANT_ID      --OIJ
                    FROM    [10.34.220.88,7433].[lgce_scmprod].[dbo].SCP_ANL_PRODUCTION_PLAN      FINAL WITH(NOLOCK)
                    INNER JOIN VERSION_INFO VER
                        ON  VER.DIVISION_ID         = FINAL.DIVISION_ID
                        AND VER.PLAN_START_YYYYMMDD = FINAL.PLAN_START_YYYYMMDD
                        AND VER.PLAN_TYPE           = FINAL.PLAN_TYPE
                        AND VER.PLAN_SEQ            = FINAL.SEQ
					LEFT JOIN SCM_MST_SITE SMS WITH(NOLOCK)
					    ON FINAL.SCM_SITE_ID		= SMS.SCM_SITE_ID
					   AND FINAL.DIVISION_ID		= SMS.DIVISION_ID
                    WHERE 1=1
                    AND FINAL.ORIGIN_DIVISION_ID     LIKE CONCAT(@v_division_id, '%') -- 사업부(전극가상사업부 포함)
                    --AND FINAL.PLAN_START_YYYYMMDD       = @v_plan_start_yyyymmdd  --매주 월요일 날짜
                    AND FINAL.PLAN_START_YYYYMMDD  		= @v_chg_plan_start_yyyymmdd  -- 2025.02.10 OIJ
                    AND FINAL.PLAN_TYPE                 = 'FN'  -- SCP final version 구분
                    AND FINAL.MEASURE			        = 'PROD_PLAN_AMEND'
                    AND FINAL.QTY                       > 0
                    AND FINAL.DIVISION_ID		      NOT LIKE 'EE%'
                    AND FINAL.YYYYMMDD                 >= @v_basis_yyyymmdd
                    AND FINAL.YYYYMMDD                  < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
                    -------------------------------------------------------
                    UNION ALL
                    -------------------------------------------------------
                    -------------------------------------------------------
                    SELECT  DPR.DIVISION_ID                     AS DIVISION_ID
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
							,DPR.COMPANY_ID						
							,'*'								AS PLANT_ID	
                    FROM   SCM_DNM_DAILY_PRODUCT_RESULT_SN DPR WITH(NOLOCK)
                    LEFT OUTER JOIN (   SELECT PLANT_ID, MAX(SCM_SITE_ID) AS SCM_SITE_ID
                                        FROM   SCM_MST_SITE WITH(NOLOCK)
                                        WHERE SITE_TYPE = 'PLANT'
                                        GROUP BY PLANT_ID) SMS
                        ON  SMS.PLANT_ID = DPR.PLANT_ID
                    WHERE  1=1
                    AND    CONVERT(CHAR,PLAN_DATE, 112)  >= @v_basis_yyyymmdd
                    AND    CONVERT(CHAR,PLAN_DATE, 112)  <  @v_plan_start_yyyymmdd --CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112)    
                    AND    EXISTS ( SELECT SEGMENT1, SEGMENT2
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                    WHERE  1=1
                                    AND    LK.LOOKUP_TYPE      = 'SCM_LGTM_RESULT_OPERATION_ID'
                                    AND    LK.VALID_YN         = 'Y'
                                    AND    LK.SEGMENT1         = DPR.DIVISION_ID
                                    AND    LK.SEGMENT2         = DPR.OPERATION_ID 
                                )
                    -------------------------------------------------------
                    UNION ALL
                    -------------------------------------------------------
                    -------------------------------------------------------
                    SELECT  SDC.DIVISION_ID                 AS DIVISION_ID
                            ,@v_plan_start_yyyymmdd         AS PLAN_START_YYYYMMDD
                            ,'FN'                           AS PLAN_TYPE
                            ,'1'                            AS SEQ
                            ,RIGHT(SDC.SCM_SITE_ID, 1)		AS OPERATION_GROUP
                            ,SMS.SCM_SITE_ID                AS SCM_SITE_ID
                            ,SDC.ITEM_ID                    AS ITEM_ID
                            ,'-'                            AS LINE_ID
                            ,SMS.PLANT_ID                   AS OPERATION_ID
                            ,'PROD_PLAN_AMEND'              AS MEASURE
                            ,SDC.PROD_DATE                  AS YYYYMMDD
                            ,SDC.PROD_QTY                   AS QTY
                            ,SDC.DIVISION_ID                AS ORIGIN_DIVISION_ID
                            ,''                             AS ELECTRODE_TYPE
                            ,SDC.CREATED_BY                 AS CREATED_BY
                            ,SDC.CREATION_DATE              AS CREATION_DATE
                            ,SDC.LAST_UPDATED_BY            AS LAST_UPDATED_BY
                            ,SDC.LAST_UPDATE_DATE           AS LAST_UPDATED_DATE
                            ,''                             AS ATTIRUBTE1
                            ,''                             AS ATTIRUBTE2
                            ,''                             AS ATTIRUBTE3
                            ,''                             AS ATTIRUBTE4
                            ,''                             AS ATTIRUBTE5
                            ,''                             AS ATTIRUBTE6
                            ,''                             AS ATTIRUBTE7
                            ,''                             AS ATTIRUBTE8
                            ,''                             AS ATTIRUBTE9
                            ,''                             AS ATTIRUBTE10
                            ,0                              AS CELL_QTY
                            ,'RESULT'                       AS PLAN_VERSION_ID
							,SMS.COMPANY_ID						
							,'*'							AS PLANT_ID						
                        FROM   SCM_DNM_SCS_PROD_RESULT SDC WITH(NOLOCK)
                        LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                            ON  SMS.SCM_SITE_ID = SDC.SCM_SITE_ID
                            AND SMS.SITE_TYPE   = 'PLANT'    
                        WHERE   SDC.PROD_DATE  >= @v_basis_yyyymmdd
                        AND     SDC.PROD_DATE   < @v_plan_start_yyyymmdd
                    ) AS PROD
            ;


		------------------------------------------------------------------------  

            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
            SELECT  @v_plan_tp_cd                                  AS PLAN_TP_CD
                    --,FINAL.PLAN_START_YYYYMMDD		                AS PLAN_START_YYYYMMDD
                    ,@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD -- 2024.12.05 YSH
                    ,'P'						                    AS DATA_TP_CD
                    ,'P'						                    AS SRCE_TP_CD
                    ,LEFT(@v_division_id, 2)	                    AS DIVISION_ID
                    ,FINAL.ORIGIN_DIVISION_ID				        AS DIVISION_ID
                    ,'*'                                            AS GROUP_CODE1
                    --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)			AS GROUP_CODE1
                    ,CASE   WHEN SUBSTRING(FINAL.OPERATION_ID, 1, 1) IN ('F', 'A')
                            THEN ISNULL(BOM.PARENT_ITEM_ID, FINAL.ITEM_ID)
                            ELSE FINAL.ITEM_ID END					AS ITEM_ID
                    ,FINAL.ITEM_ID					                AS ORIGIN_ITEM_ID
                    ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS SRCE_YYYYMM
                    ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS PLAN_YYYYMM
                    ,SUM(FINAL.QTY)					                AS QTY	
                    ,''					                            AS CURRENCY
                    ,'0'						                    AS CURRENCY
                    ,0							                    AS AMT
                    ,MAX(FINAL.SCM_SITE_ID)			                AS SCM_SITE_ID
                    ,MAX(FINAL.OPERATION_GROUP)		                AS OPERATION_GROUP
                    ,MAX(FINAL.OPERATION_ID)			            AS OPERATION_ID
                    ,NULL						                    AS DEVALUATION_AGE
                    ,NULL						                    AS LONG_TERM_TYPE_CODE
                    ,NULL						                    AS LONG_TERM_TYPE
                    ,MAX(FINAL.PLAN_VERSION_ID)						AS VERSION_NO
					,ISNULL(FINAL.COMPANY_ID, '*')					AS COMPANY_ID							--20250317
					,'*'											AS PLANT_ID						--20250317
            FROM  #TEMP_PROD_PLAN      FINAL WITH(NOLOCK)
            LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                WHERE     1=1 
                                AND       DIVISION_ID    = @v_division_id  -- LIKE CONCAT(@v_division_id, '%')
                                AND       PARENT_ITEM_ID != '*'
                                GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                ) BOM
                ON      BOM.DIVISION_ID     = FINAL.ORIGIN_DIVISION_ID
                AND     BOM.CHILD_ITEM_ID   = FINAL.ITEM_ID 
            WHERE 1=1
            AND FINAL.ORIGIN_DIVISION_ID   = @v_division_id  -- LIKE CONCAT(@v_division_id, '%') -- 사업부(전극가상사업부 포함)
            --AND FINAL.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd  --매주 월요일 날짜
            AND FINAL.PLAN_START_YYYYMMDD	= @v_chg_plan_start_yyyymmdd  -- 2025.02.10 OIJ
            AND FINAL.PLAN_TYPE             = 'FN'  -- SCP final version 구분
            AND FINAL.MEASURE			    = 'PROD_PLAN_AMEND' 
            --AND FINAL.OPERATION_ID         IN ('P9500', 'P5500', 'A9000', 'A3000') 2024.07.25 Philsu Park: 외주 및 F 등 공정 전체 대상으로 가져옴.
            AND FINAL.QTY                   > 0
            AND FINAL.DIVISION_ID		  NOT LIKE 'EE%'
            AND FINAL.YYYYMMDD             >= @v_basis_yyyymmdd
            AND FINAL.YYYYMMDD              < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112) --Plan Start YMD 기준 53주 이후 구간 제외 처리.
            GROUP BY FINAL.PLAN_START_YYYYMMDD
                    ,FINAL.ORIGIN_DIVISION_ID
                    ,FINAL.ORIGIN_DIVISION_ID
                    --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)
                    ,CASE   WHEN SUBSTRING(FINAL.OPERATION_ID, 1, 1) IN ('F', 'A')
                            THEN ISNULL(BOM.PARENT_ITEM_ID, FINAL.ITEM_ID)
                            ELSE FINAL.ITEM_ID END
                    ,FINAL.ITEM_ID
                    ,SUBSTRING(FINAL.YYYYMMDD,1,6)
					,FINAL.COMPANY_ID
					--,FINAL.PLANT_ID
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  
        PRINT 'Step 2-1 End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);

		------------------------------------------------------------------------
		INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
                    ,LEFT(@v_division_id, 2)						        AS DIVISION_ID
					,S.DIVISION_ID						        AS ORIGIN_DIVISION_ID
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
					,ISNULL(S.COMPANY_ID, '*')  AS COMPANY_ID						--jjg 20250322
					,'*'						AS PLANT_ID						--jjg 20250322			
                    FROM   SCP_ANL_PSI_INTEGRATION S WITH(NOLOCK)
					LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
										FROM   SCM_ITEM_M_SN WITH(NOLOCK)
										GROUP BY DIVISION_ID, ITEM_ID
									) ITM
						ON  ITM.DIVISION_ID = S.DIVISION_ID
						AND ITM.ITEM_ID     = S.ITEM_ID
						AND S.OPERATION_GROUP IN ('A', 'P')
					LEFT JOIN SCM_MST_SITE G
					ON S.DIVISION_ID = G.DIVISION_ID
					AND S.PLANT_ID = G.PLANT_ID
					AND S.OPERATION_GROUP = G.OPERATION_GROUP
					AND G.SITE_TYPE = 'PLANT'
                     WHERE  1=1
						AND		PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND		MEASURE IN ('SEMI_WH_IN')
						AND     S.DIVISION_ID = @v_division_id
						AND     ITM.ITEM_CLASS NOT IN ( SELECT  LK.SEGMENT1 
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
					--,S.PLANT_ID						--jjg 20250322
					,S.OPERATION_GROUP


        BEGIN
        ------------------------------------------------------------------------
		-- Step 2. Insert Data
		------------------------------------------------------------------------
		/* 
        Step 2-2. Insert S Target.
        2024.07.25 Philsu Park: REQUIREMENT 대신 P 기준으로 S 소요량 전개.
        전개 시 하위 공정에 대해서는 SCM_LGTM_PSI_ITEM_CLASS_CD 룩업에 정의된 ITEM CLASS 정보로 한정한다.
        PLANT, MODEL 기준으로 CHILD_ITEM을 찾되 PLANT 정보가 부정확한 외주 등의 케이스에 대해 PLANT 제외한 기준으로 2차 결과값 반영.
        2024.08.01 Philsu Park: 이미 제품 P의 계획을 가져와서 전개하기 때문에, 
                                Item -> Model -> ES1901 이 아닌 Item을 Model로 간주해서 ES1901 찾아오는 형태로 변경.
        2024.08.05 Philsu Park: 특정 Item_Class의 경우 ES1901이 아닌 별도 Class로 전개 필요하여 제약 추가 적용
                                OPERATION_ID F로 시작하는 대상은 별도 처리하므로 제외 처리.
        2024.09.12 Philsu Park: 대치 BOM(SCM_MST_ALTER_BOM) 적용. 
                                SCP_PLAN_YN Y인 대상만 가져오고 수량은 기존 BOM 에서 찾는 형태로 유지(대치 BOM에 누적 Qty 가 없음.)
                                BOM 중 Cell Assy 로만 한정하기 위해 Exist 조건으로 처리.
                                ITEM Master는 동일 정보를 자주 호출해서 With절에 선언하는걸로 변경.
		 */
        ------------------------------------------------------------------------  
            WITH ITEM_M AS (SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                            FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                            GROUP BY DIVISION_ID, ITEM_ID
                            )
                , ALTER_BOM AS (
                                SELECT  DISTINCT TOP(1) WITH TIES
                                    A.DIVISION_ID
                                    ,A.CHILD_PLANT_ID
                                    ,A.MODEL_ID
                                    ,C.CHILD_ITEM_ID
                                    ,C.ALT_PRIORITY
                                FROM    SCM_MST_BOM_SN A WITH(NOLOCK)
                                INNER JOIN SCM_MST_ALTER_BOM C WITH(NOLOCK)
                                    ON  A.DIVISION_ID       = C.DIVISION_ID
                                    AND A.SITE_ID           = C.SITE_ID
                                    AND A.PLANT_ID          = C.PLANT_ID
                                    AND A.PARENT_ITEM_ID    = C.PARENT_ITEM_ID
                                    AND A.CHILD_ITEM_ID     = C.CHILD_ITEM_ID
                                    AND C.SCP_PLAN_YN       = 'Y'
                                INNER JOIN  (   SELECT    B.DIVISION_ID
                                                        , B.SITE_ID
                                                        , B.PLANT_ID
                                                        , B.PARENT_ITEM_ID
                                                        , B.CHILD_ITEM_ID
                                                        , B.EFF_START_DATE
                                                        , B.EFF_END_DATE
                                                        , B.ALT_ID
                                                        , B.ECO_CODE
                                                        , CONVERT(int, B.ALT_PRIORITY) AS ALT_PRIORITY
                                                        , ROW_NUMBER() OVER(PARTITION BY B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.PARENT_ITEM_ID, B.CHILD_ITEM_ID
                                                                            ORDER BY B.KEY_DATE DESC, B.BOM_VERSION_ID) AS SEQ
                                                FROM    SCM_MST_BOM_ENG_SN B WITH(NOLOCK)
                                                WHERE   1=1
                                                AND    B.EFF_END_DATE > DATEADD(dd, -7, dbo.fn_next_day(GETDATE(), 'MON'))
                                            ) B
                                            ON  C.DIVISION_ID       = B.DIVISION_ID
                                            AND C.SITE_ID           = B.SITE_ID
                                            AND C.PARENT_ITEM_ID    = B.PARENT_ITEM_ID
                                            AND C.CHILD_ITEM_ID     = B.CHILD_ITEM_ID
                                            AND B.SEQ               = 1
                                WHERE  1=1
                                AND     EXISTS (SELECT  1
                                                FROM    SCM_MST_BOM_SN BM WITH(NOLOCK)
                                                INNER JOIN ITEM_M IM
                                                    ON IM.DIVISION_ID   = BM.DIVISION_ID
                                                    AND IM.ITEM_ID      = BM.CHILD_ITEM_ID
                                                WHERE   1=1
                                                AND     A.DIVISION_ID   = BM.DIVISION_ID
                                                AND     A.SITE_ID       = BM.SITE_ID
                                                AND     A.PLANT_ID      = BM.PLANT_ID
                                                AND     A.CHILD_ITEM_ID = BM.PARENT_ITEM_ID
                                                AND     IM.ITEM_CLASS   = 'ES1901'
                                                )
                                ORDER BY C.ALT_PRIORITY
                                --GROUP BY A.DIVISION_ID, A.PLANT_ID, A.MODEL_ID
                                )
                , BOM_PRIORITY AS (
                                    SELECT  SMB.PLANT_ID, SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                            , MAX(UPPER_BOM_YN) AS UPPER_BOM_YN
                                    FROM    (   SELECT  DISTINCT 
                                                          DENSE_RANK()OVER( PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.MODEL_ID, SME.CONCATENATE_ITEM 
                                                                            ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                        , SME.PLANT_ID, SME.MODEL_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                        , ISNULL(LK.ATTRIBUTE2, 'Y') AS UPPER_BOM_YN
                                                        -- , ITM.ITEM_CLASS
                                                        -- , T.ITEM_CLASS
                                                        -- , ISNULL(LK.SEGMENT2, 'X') test
                                                FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                INNER JOIN ITEM_M ITM
                                                    ON      ITM.DIVISION_ID     = SME.DIVISION_ID
                                                    AND     ITM.ITEM_ID         = SME.MODEL_ID
                                                LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK with(nolock)
                                                    ON      LK.LOOKUP_TYPE      = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                    AND     LK.VALID_YN         = 'Y'
                                                    AND     LK.SEGMENT1         = @v_plan_tp_cd
                                                    AND     LK.ATTRIBUTE1    LIKE CONCAT('%', ITM.ITEM_CLASS, '%')
                                                INNER JOIN ITEM_M  T
                                                    ON      T.DIVISION_ID   = SME.DIVISION_ID
                                                    AND     T.ITEM_ID       = SME.CHILD_ITEM_ID
                                                    AND     T.ITEM_CLASS    = ISNULL(LK.SEGMENT2, T.ITEM_CLASS)
                                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                                                    ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                    AND     L.VALID_YN      = 'Y'
                                                    AND     L.SEGMENT1      = @v_plan_tp_cd
                                                    AND     L.SEGMENT2      = T.ITEM_CLASS
                                                    AND     L.ATTRIBUTE1    = IIF(LK.SEGMENT2 IS NULL, '', LK.ATTRIBUTE1)
                                                WHERE   1=1
                                                AND     SME.DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                                                AND     SME.ALT_PRIORITY    = 'Y'
                                                AND     SME.EFF_END_DATE   >= GETDATE()
                                                ) AS SMB
                                    WHERE   1=1
                                    AND     SMB.RNK = 1
                                    GROUP BY SMB.PLANT_ID, SMB.MODEL_ID, SMB.CHILD_ITEM_ID
                                )
                , BOM_WITHOUT_PLANT AS (
                                        SELECT    SMB.MODEL_ID, SMB.CHILD_ITEM_ID, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                                , MAX(UPPER_BOM_YN) AS UPPER_BOM_YN
                                        FROM      ( SELECT  DISTINCT 
                                                              DENSE_RANK()OVER( PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.MODEL_ID, SME.CONCATENATE_ITEM
                                                                                ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                            , DENSE_RANK()OVER( PARTITION BY    SME.DIVISION_ID, SME.MODEL_ID
                                                                                ORDER BY        SME.EFF_START_DATE DESC, SME.COMPANY_ID, SME.PLANT_ID, SME.SITE_ID ) AS RNK2
                                                            , SME.PLANT_ID, SME.MODEL_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                            , ISNULL(LK.ATTRIBUTE2, 'Y') AS UPPER_BOM_YN
                                                    FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                    INNER JOIN ITEM_M  ITM
                                                        ON      ITM.DIVISION_ID     = SME.DIVISION_ID
                                                        AND     ITM.ITEM_ID         = SME.MODEL_ID
                                                    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK with(nolock)
                                                        ON      LK.LOOKUP_TYPE      = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                        AND     LK.VALID_YN         = 'Y'
                                                        AND     LK.SEGMENT1         = @v_plan_tp_cd
                                                        AND     LK.ATTRIBUTE1    LIKE CONCAT('%', ITM.ITEM_CLASS, '%')
                                                    INNER JOIN ITEM_M  T
                                                        ON      T.DIVISION_ID       = SME.DIVISION_ID
                                                        AND     T.ITEM_ID           = SME.CHILD_ITEM_ID
                                                        AND     T.ITEM_CLASS        = ISNULL(LK.SEGMENT2, T.ITEM_CLASS)
                                                    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                                                        ON      L.LOOKUP_TYPE       = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                        AND     L.VALID_YN          = 'Y'
                                                        AND     L.SEGMENT1          = @v_plan_tp_cd
                                                        AND     L.SEGMENT2          = T.ITEM_CLASS
                                                        AND     L.ATTRIBUTE1        = IIF(LK.SEGMENT2 IS NULL, '', LK.ATTRIBUTE1)
                                                    WHERE   1=1
                                                    AND     SME.DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                                                    AND     SME.ALT_PRIORITY    = 'Y'
                                                    AND     SME.EFF_END_DATE   >= GETDATE()
                                                    --and     SME.MODEL_ID        = 'MPCISZISLD1V'
                                                    ) AS SMB
                                        WHERE 1=1
                                        AND     SMB.RNK     = 1
                                        AND     SMB.RNK2    = 1
                                        GROUP BY SMB.MODEL_ID, SMB.CHILD_ITEM_ID
                                        )
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,ORIGIN_DIVISION_ID
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
                    ,LEFT(@v_division_id, 2)                     AS DIVISION_ID
                    ,PLN.DIVISION_ID                    AS ORIGIN_DIVISION_ID
                    ,PLN.GROUP_CODE1                    AS GROUP_CODE1
                    --,ISNULL(BOM.PARENT_ITEM_ID, ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID))   AS ITEM_ID
                    ,ISNULL(ABM.CHILD_ITEM_ID, ISNULL(BOM.PARENT_ITEM_ID, ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)))   AS ITEM_ID
                    ,PLN.ORIGIN_ITEM_ID                 AS ORIGIN_ITEM_ID
                    ,PLN.SRCE_YYYYMM                    AS SRCE_YYYYMM
                    ,PLN.PLAN_YYYYMM                    AS PLAN_YYYYMM
                    ,SUM(PLN.QTY * ISNULL(ISNULL(COMBOM.ACCUM_QTY, BOM2.ACCUM_QTY), 1))         AS QTY
                    ,MAX(PLN.CURRENCY)                  AS CURRENCY
                    ,MAX(PLN.COST)                      AS STANDARD_COST
                    ,MAX(PLN.AMT)                       AS AMT
                    ,MAX(PLN.SCM_SITE_ID)               AS SCM_SITE_ID
                    ,MAX(PLN.OPERATION_GROUP)           AS OPERATION_GROUP
                    ,MAX(PLN.OPERATION_ID)              AS OPERATION_ID
                    ,NULL                               AS DEVALUATION_AGE
                    ,NULL                               AS LONG_TERM_TYPE_CODE
                    ,NULL                               AS LONG_TERM_TYPE
                    ,MAX(PLN.VERSION_NO)                AS VERSION_NO
					,ISNULL(PLN.COMPANY_ID, '*')		AS COMPANY_ID
					,PLN.PLANT_ID
            FROM 
                (   SELECT  @v_plan_tp_cd                                   AS PLAN_TP_CD
                            --,FINAL.PLAN_START_YYYYMMDD		                AS PLAN_START_YYYYMMDD
                            ,@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD -- 2024.12.05 YSH
                            ,'S'						                    AS DATA_TP_CD
                            ,'S_TARGET'						                AS SRCE_TP_CD
                            ,FINAL.ORIGIN_DIVISION_ID				        AS DIVISION_ID
                            ,'*'                                            AS GROUP_CODE1
                            --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)			AS GROUP_CODE1
                            ,FINAL.ITEM_ID					                AS MODEL_ID
                            ,FINAL.ITEM_ID					                AS ORIGIN_ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS SRCE_YYYYMM
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS PLAN_YYYYMM
                            ,SUM(FINAL.QTY)					                AS QTY	
                            ,''					                            AS CURRENCY
                            ,0                                              AS COST
                            ,0							                    AS AMT
                            --,MAX(SMS.PLANT_ID)                              AS PLANT_ID
                            ,MAX(FINAL.SCM_SITE_ID)			                AS SCM_SITE_ID
                            ,MAX(FINAL.OPERATION_GROUP)		                AS OPERATION_GROUP
                            ,MAX(FINAL.OPERATION_ID)			            AS OPERATION_ID
                            ,NULL						                    AS DEVALUATION_AGE
                            ,NULL						                    AS LONG_TERM_TYPE_CODE
                            ,NULL						                    AS LONG_TERM_TYPE
                            ,MAX(FINAL.PLAN_VERSION_ID)					    AS VERSION_NO
							,FINAL.COMPANY_ID						--20250317
							,'*'											AS PLANT_ID							--20250317
                    FROM    #TEMP_PROD_PLAN    FINAL WITH(NOLOCK) 
                    --LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                    --    ON  SMS.DIVISION_ID = FINAL.ORIGIN_DIVISION_ID
                    --    AND SMS.SCM_SITE_ID = FINAL.SCM_SITE_ID
                    --    AND SMS.SITE_TYPE   = 'PLANT'
                    WHERE 1=1
                    AND FINAL.ORIGIN_DIVISION_ID    = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                    --AND FINAL.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                    AND FINAL.PLAN_START_YYYYMMDD   = @v_chg_plan_start_yyyymmdd  -- 2025.02.10 OIJ
                    AND FINAL.PLAN_TYPE             = 'FN'
                    AND FINAL.MEASURE			    = 'PROD_PLAN_AMEND'
                    -- [PJ20257329] 변경전 AND FINAL.OPERATION_ID        NOT IN ('A9000', 'A3000') -- A공정은 반제품으로 포함시킴.
					-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 -- Start 
					AND FINAL.OPERATION_ID        NOT IN (SELECT CF.OPERATION_ID FROM @SCP_CELL_FINAL_OPERATION CF) -- A공정은 반제품으로 포함시킴.
					-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 -- End 
                    AND FINAL.OPERATION_ID		  NOT LIKE 'F%'
                    AND FINAL.QTY                   > 0
                    AND FINAL.DIVISION_ID		  NOT LIKE 'EE%'
                    AND FINAL.YYYYMMDD             >= @v_basis_yyyymmdd
                    AND FINAL.YYYYMMDD              < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112)
                    GROUP BY FINAL.PLAN_START_YYYYMMDD
                            ,FINAL.ORIGIN_DIVISION_ID
                            --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)
                            ,FINAL.ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)
							,FINAL.COMPANY_ID						--20250317
							
                ) PLN
            LEFT OUTER JOIN ALTER_BOM ABM
                ON      ABM.DIVISION_ID     = PLN.DIVISION_ID
                AND     ABM.CHILD_PLANT_ID  = PLN.PLANT_ID
                AND     ABM.MODEL_ID        = PLN.ORIGIN_ITEM_ID
            LEFT OUTER JOIN BOM_PRIORITY COMBOM
                ON      COMBOM.PLANT_ID     = PLN.PLANT_ID
                AND     COMBOM.MODEL_ID     = PLN.ORIGIN_ITEM_ID
            LEFT OUTER JOIN BOM_WITHOUT_PLANT BOM2
                ON      BOM2.MODEL_ID       = PLN.ORIGIN_ITEM_ID
                AND     ISNULL(COMBOM.CHILD_ITEM_ID, '') = ''
            LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                WHERE     1=1 
                                AND       PARENT_ITEM_ID != '*'
                                GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                ) BOM
                ON      BOM.DIVISION_ID     = PLN.DIVISION_ID
                AND     BOM.CHILD_ITEM_ID   = ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)
                AND     'Y'                 = ISNULL(ISNULL(COMBOM.UPPER_BOM_YN, BOM2.UPPER_BOM_YN), 'Y')
            WHERE   1=1
            GROUP BY PLN.PLAN_TP_CD
                    ,PLN.PLAN_START_YYYYMMDD
                    ,PLN.DATA_TP_CD
                    ,PLN.SRCE_TP_CD
                    ,PLN.DIVISION_ID
                    ,PLN.GROUP_CODE1
                    ,PLN.ORIGIN_ITEM_ID
                    --,ISNULL(BOM.PARENT_ITEM_ID, ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID))
                    ,ISNULL(ABM.CHILD_ITEM_ID, ISNULL(BOM.PARENT_ITEM_ID, ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)))
                    ,PLN.SRCE_YYYYMM
                    ,PLN.PLAN_YYYYMM
					,PLN.COMPANY_ID
					,PLN.PLANT_ID
            ;

        ------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  

-- jjg 여기까지 46초 걸림.



        
        ------------------------------------------------------------------------
        BEGIN
        ------------------------------------------------------------------------
		/* 
        2024.08.05 Philsu Park: OPERATION_ID F로 시작하는 대상은 1단계 하위 Child로 적용. 별도 처리.
		 */
        ------------------------------------------------------------------------  
            WITH BOM_PRIORITY AS (
                                    SELECT  SMB.PLANT_ID, SMB.PARENT_ITEM_ID, SMB.CHILD_ITEM_ID, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                            , MAX(UPPER_BOM_YN) AS UPPER_BOM_YN
                                    FROM    (   SELECT  DENSE_RANK()OVER(PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.PARENT_ITEM_ID, SME.CONCATENATE_ITEM 
                                                                            ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                        , SME.PLANT_ID, SME.PARENT_ITEM_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                        , ISNULL(LK.ATTRIBUTE2, 'Y') AS UPPER_BOM_YN
                                                FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                INNER JOIN ( SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                             FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                             GROUP BY DIVISION_ID, ITEM_ID
                                                            )  ITM
                                                    ON      ITM.DIVISION_ID     = SME.DIVISION_ID
                                                    AND     ITM.ITEM_ID         = SME.PARENT_ITEM_ID
                                                LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK with(nolock)
                                                    ON      LK.LOOKUP_TYPE      = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                    AND     LK.VALID_YN         = 'Y'
                                                    AND     LK.SEGMENT1         = @v_plan_tp_cd
                                                    AND     LK.ATTRIBUTE1    LIKE CONCAT('%', ITM.ITEM_CLASS, '%')
                                                INNER JOIN ( SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                             FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                             GROUP BY DIVISION_ID, ITEM_ID
                                                            )  T
                                                    ON      T.DIVISION_ID   = SME.DIVISION_ID
                                                    AND     T.ITEM_ID       = SME.CHILD_ITEM_ID
                                                    AND     T.ITEM_CLASS    = ISNULL(LK.SEGMENT2, T.ITEM_CLASS)
                                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                                                    ON      L.LOOKUP_TYPE   = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                    AND     L.VALID_YN      = 'Y'
                                                    AND     L.SEGMENT1      = @v_plan_tp_cd
                                                    AND     L.SEGMENT2      = T.ITEM_CLASS
                                                    AND     L.ATTRIBUTE1    = IIF(LK.SEGMENT2 IS NULL, '', LK.ATTRIBUTE1)
                                                WHERE   1=1
                                                AND     SME.DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                                                AND     SME.ALT_PRIORITY    = 'Y'
                                                AND     SME.EFF_END_DATE   >= GETDATE()
                                                ) AS SMB
                                    WHERE   1=1
                                    AND     SMB.RNK = 1
                                    GROUP BY SMB.PLANT_ID, SMB.PARENT_ITEM_ID, SMB.CHILD_ITEM_ID
                                )
                , BOM_WITHOUT_PLANT AS (
                                        SELECT    SMB.PARENT_ITEM_ID, SMB.CHILD_ITEM_ID, SUM(SMB.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
                                                , MAX(UPPER_BOM_YN) AS UPPER_BOM_YN
                                        FROM      ( SELECT DENSE_RANK()OVER(PARTITION BY    SME.COMPANY_ID, SME.DIVISION_ID, SME.SITE_ID, SME.PLANT_ID, SME.PARENT_ITEM_ID, SME.CONCATENATE_ITEM
                                                                            ORDER BY        SME.EFF_START_DATE DESC) AS RNK
                                                            , DENSE_RANK()OVER(PARTITION BY    SME.DIVISION_ID, SME.PARENT_ITEM_ID
                                                                            ORDER BY        SME.EFF_START_DATE DESC, SME.COMPANY_ID, SME.PLANT_ID, SME.SITE_ID ) AS RNK2
                                                            , SME.PLANT_ID, SME.PARENT_ITEM_ID, SME.CHILD_ITEM_ID, SME.ACCUMULATED_CHILD_QTY
                                                            , ISNULL(LK.ATTRIBUTE2, 'Y') AS UPPER_BOM_YN
															         -- 2025.06.05   KIMCD          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
                                                                     --                             E20250529-001245 MJ~로 시작하는 자재코드의 S 미형성으로 인한 재고 증가 현상 보완
																	 --                             상위 품목 반영을 기본으로 설정
                                                    FROM    SCM_MST_BOM_EFFECTIVE_SN SME WITH(NOLOCK)
                                                    INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                                    FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                                    GROUP BY DIVISION_ID, ITEM_ID
                                                                ) ITM
                                                        ON      ITM.DIVISION_ID     = SME.DIVISION_ID
                                                        AND     ITM.ITEM_ID         = SME.PARENT_ITEM_ID
                                                    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK with(nolock)
                                                        ON      LK.LOOKUP_TYPE      = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                        AND     LK.VALID_YN         = 'Y'
                                                        AND     LK.SEGMENT1         = @v_plan_tp_cd
                                                        AND     LK.ATTRIBUTE1    LIKE CONCAT('%', ITM.ITEM_CLASS, '%')
                                                    INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                                    FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                                    GROUP BY DIVISION_ID, ITEM_ID
                                                                )  T
                                                        ON      T.DIVISION_ID       = SME.DIVISION_ID
                                                        AND     T.ITEM_ID           = SME.CHILD_ITEM_ID
                                                        AND     T.ITEM_CLASS        = ISNULL(LK.SEGMENT2, T.ITEM_CLASS)
                                                    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                                                        ON      L.LOOKUP_TYPE       = 'SCM_LGTM_PSI_ITEM_CLASS_CD'
                                                        AND     L.VALID_YN          = 'Y'
                                                        AND     L.SEGMENT1          = @v_plan_tp_cd
                                                        AND     L.SEGMENT2          = T.ITEM_CLASS
                                                        AND     L.ATTRIBUTE1        = IIF(LK.SEGMENT2 IS NULL, '', LK.ATTRIBUTE1)
                                                    WHERE   1=1
                                                    AND     SME.DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                                                    AND     SME.ALT_PRIORITY    = 'Y'
                                                    AND     SME.EFF_END_DATE   >= GETDATE()
                                                    ) AS SMB
                                        WHERE 1=1
                                        AND     SMB.RNK     = 1
                                        AND     SMB.RNK2    = 1
                                        GROUP BY SMB.PARENT_ITEM_ID, SMB.CHILD_ITEM_ID
                                        )
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,ORIGIN_DIVISION_ID
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
                    ,LEFT(@v_division_id, 2)                    AS DIVISION_ID
                    ,PLN.DIVISION_ID                    AS ORIGIN_DIVISION_ID
                    ,PLN.GROUP_CODE1                    AS GROUP_CODE1
                    ,CASE WHEN ISNULL(COMBOM.UPPER_BOM_YN, BOM2.UPPER_BOM_YN) = 'Y' THEN ORIGIN_ITEM_ID
					      ELSE ISNULL(BOM.PARENT_ITEM_ID, ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)) END   AS ITEM_ID
					-- 2025.06.05   KIMCD          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
                    --                             E20250529-001245 MJ~로 시작하는 자재코드의 S 미형성으로 인한 재고 증가 현상 보완
					--                             활성화 후 공정 품목은 계획을 수요로 넣게 수정
                    ,PLN.ORIGIN_ITEM_ID                 AS ORIGIN_ITEM_ID
                    ,PLN.SRCE_YYYYMM                    AS SRCE_YYYYMM
                    ,PLN.PLAN_YYYYMM                    AS PLAN_YYYYMM
                    ,SUM(PLN.QTY * ISNULL(ISNULL(COMBOM.ACCUM_QTY, BOM2.ACCUM_QTY), 1))         AS QTY
                    ,MAX(PLN.CURRENCY)                  AS CURRENCY
                    ,MAX(PLN.COST)                      AS STANDARD_COST
                    ,MAX(PLN.AMT)                       AS AMT
                    ,MAX(PLN.SCM_SITE_ID)               AS SCM_SITE_ID
                    ,MAX(PLN.OPERATION_GROUP)           AS OPERATION_GROUP
                    ,MAX(PLN.OPERATION_ID)              AS OPERATION_ID
                    ,NULL                               AS DEVALUATION_AGE
                    ,NULL                               AS LONG_TERM_TYPE_CODE
                    ,NULL                               AS LONG_TERM_TYPE
                    ,MAX(PLN.VERSION_NO)                AS VERSION_NO
					,ISNULL(PLN.COMPANY_ID, '*')		AS COMPANY_ID
					,PLN.PLANT_ID
            FROM 
                (   SELECT  @v_plan_tp_cd                                   AS PLAN_TP_CD
                            --,FINAL.PLAN_START_YYYYMMDD		                AS PLAN_START_YYYYMMDD
                            ,@v_plan_start_yyyymmdd as PLAN_START_YYYYMMDD -- 2024.12.05 YSH
                            ,'S'						                    AS DATA_TP_CD
                            ,'S_TARGET'						                AS SRCE_TP_CD
                            ,FINAL.ORIGIN_DIVISION_ID				        AS DIVISION_ID
                            ,'*'			                                AS GROUP_CODE1
                            --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)			AS GROUP_CODE1
                            ,FINAL.ITEM_ID					                AS MODEL_ID
                            ,FINAL.ITEM_ID					                AS ORIGIN_ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS SRCE_YYYYMM
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)	                AS PLAN_YYYYMM
                            ,SUM(FINAL.QTY)					                AS QTY	
                            ,''					                            AS CURRENCY
                            ,0                                              AS COST
                            ,0							                    AS AMT
                            --MAX(SMS.PLANT_ID)                              AS PLANT_ID
                            ,MAX(FINAL.SCM_SITE_ID)			                AS SCM_SITE_ID
                            ,MAX(FINAL.OPERATION_GROUP)		                AS OPERATION_GROUP
                            ,MAX(FINAL.OPERATION_ID)			            AS OPERATION_ID
                            ,NULL						                    AS DEVALUATION_AGE
                            ,NULL						                    AS LONG_TERM_TYPE_CODE
                            ,NULL						                    AS LONG_TERM_TYPE
                            ,MAX(FINAL.PLAN_VERSION_ID)						AS VERSION_NO
							,FINAL.COMPANY_ID
							,'*'											AS PLANT_ID
                    FROM    #TEMP_PROD_PLAN    FINAL WITH(NOLOCK) 
                    /* LEFT OUTER JOIN  SCP_MST_FINAL_ITEM     T WITH(NOLOCK)
                        ON      T.DIVISION_ID   = FINAL.ORIGIN_DIVISION_ID
                        AND     T.ITEM_ID       = FINAL.ITEM_ID */
                    --LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                    --    ON  SMS.DIVISION_ID = FINAL.ORIGIN_DIVISION_ID
                    --    AND SMS.SCM_SITE_ID = FINAL.SCM_SITE_ID
                    --    AND SMS.SITE_TYPE   = 'PLANT'
                    WHERE 1=1
                    AND FINAL.ORIGIN_DIVISION_ID    = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                    --AND FINAL.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                    AND FINAL.PLAN_START_YYYYMMDD   = @v_chg_plan_start_yyyymmdd  -- 2025.02.10 OIJ
                    AND FINAL.PLAN_TYPE             = 'FN'
                    AND FINAL.MEASURE			    = 'PROD_PLAN_AMEND'
                    AND FINAL.OPERATION_ID       LIKE 'F%'
                    -- [PJ20257329] 변경전 AND FINAL.OPERATION_ID        NOT IN ('A9000', 'A3000') -- A공정은 반제품으로 포함시킴.
					-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 - Start 
                    AND FINAL.OPERATION_ID        NOT IN (SELECT CF.OPERATION_ID FROM @SCP_CELL_FINAL_OPERATION CF)
					-- [PJ20257329] Cell 완성 공정 하드 코딩 변경- End 
                    AND FINAL.QTY                   > 0
                    AND FINAL.DIVISION_ID		  NOT LIKE 'EE%'
                    AND FINAL.YYYYMMDD             >= @v_basis_yyyymmdd
                    AND FINAL.YYYYMMDD              < CONVERT(CHAR, DATEADD(WEEK, 52, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)), 112)
                    GROUP BY FINAL.PLAN_START_YYYYMMDD
                            ,FINAL.ORIGIN_DIVISION_ID
                            --,ISNULL(T.GROUP_CODE1, FINAL.ITEM_ID)
                            ,FINAL.ITEM_ID
                            ,SUBSTRING(FINAL.YYYYMMDD,1,6)
							,FINAL.COMPANY_ID
                ) PLN
            LEFT OUTER JOIN BOM_PRIORITY COMBOM
                ON      COMBOM.PLANT_ID         = PLN.PLANT_ID
                AND     COMBOM.PARENT_ITEM_ID   = PLN.ORIGIN_ITEM_ID
            LEFT OUTER JOIN BOM_WITHOUT_PLANT BOM2
                ON      BOM2.PARENT_ITEM_ID       = PLN.ORIGIN_ITEM_ID
                AND     ISNULL(COMBOM.CHILD_ITEM_ID, '') = ''
            LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                WHERE     1=1 
                                AND       PARENT_ITEM_ID != '*'
                                GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                ) BOM
                ON      BOM.DIVISION_ID     = PLN.DIVISION_ID
                AND     BOM.CHILD_ITEM_ID   = ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)
                AND     'Y'                 = ISNULL(ISNULL(COMBOM.UPPER_BOM_YN, BOM2.UPPER_BOM_YN), 'Y')
            WHERE   1=1
            GROUP BY PLN.PLAN_TP_CD
                    ,PLN.PLAN_START_YYYYMMDD
                    ,PLN.DATA_TP_CD
                    ,PLN.SRCE_TP_CD
                    ,PLN.DIVISION_ID
                    ,PLN.GROUP_CODE1
                    ,PLN.ORIGIN_ITEM_ID
                    ,CASE WHEN ISNULL(COMBOM.UPPER_BOM_YN, BOM2.UPPER_BOM_YN) = 'Y' THEN ORIGIN_ITEM_ID
					      ELSE ISNULL(BOM.PARENT_ITEM_ID, ISNULL(ISNULL(COMBOM.CHILD_ITEM_ID, BOM2.CHILD_ITEM_ID), ORIGIN_ITEM_ID)) END
					-- 2025.06.05   KIMCD          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
                    --                             E20250529-001245 MJ~로 시작하는 자재코드의 S 미형성으로 인한 재고 증가 현상 보완
					--                             활성화 후 공정 품목은 계획을 수요로 넣게 수정
                    ,PLN.SRCE_YYYYMM
                    ,PLN.PLAN_YYYYMM
					,PLN.COMPANY_ID
					,PLN.PLANT_ID
            ;
        END
		
        PRINT 'Step 2-2 S_Target End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);



		------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-3. Insert S from RTF
        -- 주차 내 가장 최신 Cutoff 된 MF_W 의 RTF, AS_In_Plan 수량을 사용
        -- 완제품은 ITEM이 전극이 아니고, ITEM_ID의 Length가 12자리 이상인 대상.
        -- 2024.08.29 Philsu Park: Plan Start 기준 계획월의 실적구간은 실적에서 가져옴.
        -- 2024.08.30 Philsu Park: AS_In_Plan은 중복 여지가 있어 S 숫자에서 제외.
		------------------------------------------------------------------------  

		INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
		SELECT    @v_plan_tp_cd						AS PLAN_TP_CD
            ,@v_plan_start_yyyymmdd					AS PLAN_START_YYYYMMDD
            ,'S'						AS DATA_TP_CD
            ,'S_RTF'				    AS SRCE_TP_CD -- 고정필요
            ,LEFT(@v_division_id, 2)				AS DIVISION_ID
            ,S.DIVISION_ID              AS ORIGIN_DIVISION_ID
            ,'*'                        AS GROUP_CODE1
            ,S.ITEM_ID					AS ITEM_ID
            ,S.ITEM_ID					AS ORIGIN_ITEM_ID
            ,YYYYMM						AS SRCE_YYYYMM
            ,YYYYMM						AS PLAN_YYYYMM
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
			,ISNULL(S.COMPANY_ID, '*')  AS COMPANY_ID
			,'*'						AS PLANT_ID  --JJG : DM의 SALES 사이트와 매칭되는 PLANT 는 없나봄.
    FROM	SCP_ANL_PSI_INTEGRATION    S WITH(NOLOCK)
    LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                        FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                        GROUP BY DIVISION_ID, ITEM_ID
                    ) ITM
        ON  ITM.DIVISION_ID = S.DIVISION_ID
        AND ITM.ITEM_ID     = S.ITEM_ID
		AND S.OPERATION_GROUP IN ('A', 'P')
    WHERE  1=1
	AND		PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
	AND		MEASURE IN ('SHIP_PLAN_RTF')
	AND     S.DIVISION_ID  = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
    AND     ITM.ITEM_CLASS NOT IN ( SELECT  LK.SEGMENT1 
                                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                    WHERE   1=1
                                    AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                                    AND     LK.VALID_YN     = 'Y'
                                    )
    GROUP BY S.DIVISION_ID
            ,S.ITEM_ID
            ,S.YYYYMM
			,S.COMPANY_ID



	INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
		SELECT    @v_plan_tp_cd						AS PLAN_TP_CD
            ,@v_plan_start_yyyymmdd					AS PLAN_START_YYYYMMDD
            ,'S'						AS DATA_TP_CD
            ,'S_SHIP_SEMI'				AS SRCE_TP_CD -- 고정필요
            ,LEFT(@v_division_id, 2)				AS DIVISION_ID
            ,S.DIVISION_ID              AS ORIGIN_DIVISION_ID
            ,'*'                        AS GROUP_CODE1
            ,S.ITEM_ID					AS ITEM_ID
            ,S.ITEM_ID					AS ORIGIN_ITEM_ID
            ,YYYYMM						AS SRCE_YYYYMM
            ,YYYYMM						AS PLAN_YYYYMM
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
			,ISNULL(S.COMPANY_ID, '*')	AS COMPANY_ID
			,'*'						AS PLANT_ID  --JJG : DM의 SALES 사이트와 매칭되는 PLANT 는 없나봄.
    FROM	SCP_ANL_PSI_INTEGRATION    S WITH(NOLOCK)
    LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                        FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                        GROUP BY DIVISION_ID, ITEM_ID
                    ) ITM
        ON  ITM.DIVISION_ID = S.DIVISION_ID
        AND ITM.ITEM_ID     = S.ITEM_ID
		AND S.OPERATION_GROUP IN ('A', 'P')
    WHERE  1=1
	AND		PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
	AND		MEASURE IN ('SHIP_PLAN_SEMI')
	AND     S.DIVISION_ID  = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
    AND     ITM.ITEM_CLASS NOT IN ( SELECT  LK.SEGMENT1 
                                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                    WHERE   1=1
                                    AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                                    AND     LK.VALID_YN     = 'Y'
                                    )
    GROUP BY S.DIVISION_ID
            ,S.ITEM_ID
            ,S.YYYYMM
			,S.COMPANY_ID


    --        WITH S_RTF AS ( SELECT  S.DIVISION_ID
    --                                , CASE WHEN S.MEASURE = 'RTF_SYS_RP' THEN 'S_RTF' ELSE 'S_AS' END AS SRCE_TP_CD
    --                                , S.ITEM_ID
    --                                , S.YYYYMMDD
    --                                , S.QTY
    --                                , S.SCM_SITE_ID
    --                                , S.VERSION_NO
    --                        FROM	DM_PLN_MKT_FCST_C S WITH(NOLOCK)
    --                        WHERE  1=1
    --                        AND    S.CUTOFF_TYPE    = 'MF_W'
    --                        AND    (S.MEASURE       = 'RTF_SYS_RP'
    --                            --OR (S.MEASURE       = 'AS_In_Plan' AND S.ITEM_ID <> 'APRSAL38L-A2')
    --                                )
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
    --                        AND     LEN(S.ITEM_ID) >= 12
    --                        --AND     S.ITEM_ID <> 'APRSAL38L-A2'
    --                        UNION ALL
    --                        SELECT  S.DIVISION_ID
    --                                , CASE WHEN S.MEASURE = 'RTF_SYS_RP' THEN 'S_RTF' ELSE 'S_AS' END AS SRCE_TP_CD
    --                                , S.ITEM_ID
    --                                , S.YYYYMMDD
    --                                , S.QTY
    --                                , S.SCM_SITE_ID
    --                                , S.VERSION_NO
    --                        FROM	DM_PLN_MKT_FCST_RESULT_C   S WITH(NOLOCK)
    --                        WHERE  1=1
    --                        AND    S.CUTOFF_TYPE        = 'MF_W'
    --                        AND    (S.MEASURE       = 'RTF_SYS_RP'
    --                        --    OR (S.MEASURE       = 'AS_In_Plan' AND S.ITEM_ID <> 'APRSAL38L-A2')
    --                                )
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
    --                        AND     LEN(S.ITEM_ID)     >= 12
    --                        --AND     S.ITEM_ID <> 'APRSAL38L-A2'
    --                        )
    --        INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
    --            (PLAN_TP_CD
    --            ,PLAN_START_YYYYMMDD
    --            ,DATA_TP_CD
    --            ,SRCE_TP_CD
    --            ,DIVISION_ID
    --            ,ORIGIN_DIVISION_ID
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
				--,COMPANY_ID
				--,PLANT_ID )
    --        SELECT   @v_plan_tp_cd              AS PLAN_TP_CD
    --                ,@v_plan_start_yyyymmdd     AS PLAN_START_YYYYMMDD
    --                ,'S'						AS DATA_TP_CD
    --                ,S.SRCE_TP_CD				AS SRCE_TP_CD
    --                ,@v_division_id				AS DIVISION_ID
    --                ,S.DIVISION_ID              AS ORIGIN_DIVISION_ID
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
				--	,SMS.COMPANY_ID
				--	,isnull(SMS.PLANT_ID,'*')	AS PLANT_ID  --JJG : DM의 SALES 사이트와 매칭되는 PLANT 는 없나봄.
    --        FROM	S_RTF           S WITH(NOLOCK)
    --        LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
    --            ON  SMS.DIVISION_ID = S.DIVISION_ID
    --            AND SMS.SCM_SITE_ID = S.SCM_SITE_ID
    --        LEFT OUTER JOIN (   SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
    --                            FROM   SCM_ITEM_M_SN WITH(NOLOCK)
    --                            GROUP BY DIVISION_ID, ITEM_ID
    --                        ) ITM
    --            ON  ITM.DIVISION_ID = S.DIVISION_ID
    --            AND ITM.ITEM_ID     = S.ITEM_ID
    --        WHERE  1=1
    --        AND     ITM.ITEM_CLASS NOT IN ( SELECT  LK.SEGMENT1 
    --                                        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
    --                                        WHERE   1=1
    --                                        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
    --                                        AND     LK.VALID_YN     = 'Y'
    --                                        )
    --        GROUP BY S.SRCE_TP_CD
    --                ,S.DIVISION_ID
    --                ,S.ITEM_ID
    --                ,SUBSTRING(S.YYYYMMDD,1,6)
    --                ,S.VERSION_NO
				--	,SMS.COMPANY_ID
				--	,SMS.PLANT_ID
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-3 End';

-- JJG 여기까지 1분 소요됨.


        ------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-4. Insert Product BOH from Long Term Stock
        /*
        2024.07.31 Philsu Park: AMDAU Mapping 반영.
        2024.08.02 Philsu Park: AMDAU Mapping Rule 보완
                                1차로 찾고, 2차로 SCM_MST_BOM_ENG_SN 에서 Priority = 1인 대상을 추가로 찾아옴.
                                Plant: A002 는 Service Plant 라서 A040으로 간주.
        2024.08.07 Philsu Park: AMDMO 는 생산계획이 있기 때문에 Mapping 안하는게 맞음. 제외처리.
        */
		------------------------------------------------------------------------  
			WITH AMDAU AS (SELECT     SMB.PLANT_ID              AS PLANT_ID
                                    , SMB.DIVISION_ID           AS DIVISION_ID
                                    , SMB.CHILD_ITEM_ID         AS ITEM_ID
									, SMB.COMPANY_ID			AS COMPANY_ID
                                    -- , CBOM.CHILD_ITEM_ID
                                    -- , CBOM.R_NUM
                                    , MAX(CASE WHEN ISNULL(SIM.FLOW_ID, '') = 'P5200' THEN SMB.PARENT_ITEM_ID 
                                                ELSE CBOM.CHILD_ITEM_ID END)    AS FINAL_ITEM_ID
                                    , MAX(CASE WHEN ISNULL(SIM.FLOW_ID, '') = 'P5200' THEN 1 
                                                ELSE (CBOM.CHILD_QTY/CBOM.PARENT_QTY) END) AS ACCUM_QTY
                            FROM      (SELECT  ROW_NUMBER()OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CHILD_ITEM_ID, BOM_VERSION_ID 
                                                                ORDER BY     KEY_DATE DESC, PARENT_ITEM_ID ASC
                                                                ) AS R_NUM
                                                , ALT_PRIORITY
                                                , PARENT_ITEM_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CHILD_ITEM_ID, BOM_VERSION_ID, KEY_DATE
                                                , CHILD_QTY
                                        FROM    SCM_MST_BOM_ENG_SN WITH(NOLOCK)
                                        WHERE   EFF_END_DATE >= GETDATE()
                                        )  SMB
                            INNER JOIN  SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                ON  SMB.COMPANY_ID      = SIM.COMPANY_ID
                                AND SMB.DIVISION_ID     = SIM.DIVISION_ID
                                AND SMB.SITE_ID         = SIM.SITE_ID
                                AND SMB.CHILD_ITEM_ID   = SIM.ITEM_ID
                            INNER JOIN  (SELECT  ROW_NUMBER()OVER(PARTITION BY BOM.PARENT_ITEM_ID, BOM.COMPANY_ID, BOM.DIVISION_ID, BOM.SITE_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID, BOM.BOM_VERSION_ID 
                                                                    ORDER BY   BOM.ALT_PRIORITY
                                                                    ) AS R_NUM
                                                , ALT_PRIORITY
                                                , BOM.PARENT_ITEM_ID, BOM.COMPANY_ID, BOM.DIVISION_ID, BOM.SITE_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID, BOM.BOM_VERSION_ID, BOM.KEY_DATE
                                                , CHILD_QTY, PARENT_QTY
                                        FROM    SCM_MST_BOM_ENG_SN BOM WITH(NOLOCK)
                                        INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                        FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                        GROUP BY DIVISION_ID, ITEM_ID
                                                    ) ITM
                                            ON    ITM.DIVISION_ID = BOM.DIVISION_ID
                                            AND   ITM.ITEM_ID     = BOM.CHILD_ITEM_ID
                                            AND   ITM.ITEM_CLASS IN ('EM0201')
                                        WHERE   BOM.EFF_END_DATE >= GETDATE()
                                        ) CBOM
                                ON  SMB.DIVISION_ID     = CBOM.DIVISION_ID
                                AND SMB.COMPANY_ID      = CBOM.COMPANY_ID
                                AND SMB.SITE_ID         = CBOM.SITE_ID
                                AND SMB.CHILD_ITEM_ID   = CBOM.PARENT_ITEM_ID
                                AND CBOM.R_NUM          = 1
                            WHERE   1=1 
                            and     SMB.R_NUM           = 1
                            AND     SIM.ITEM_CLASS     IN ('ES0901') --AMDAU, AMDMO
                            --AND     SMB.PARENT_ITEM_ID != '*'
                            --AND     SMB.ALT_PRIORITY    = 'Y'
                            --AND     SMB.EFF_END_DATE   >= GETDATE()
                            --and     SMB.CHILD_ITEM_ID LIKE 'AMDAU0453A%'
                            GROUP BY  SMB.PLANT_ID
                                    , SMB.DIVISION_ID
                                    , SMB.CHILD_ITEM_ID
									, SMB.COMPANY_ID
                            )
                , AMDAU2 AS (
                                SELECT  BOM.PLANT_ID        AS PLANT_ID
                                        , BOM.DIVISION_ID     AS DIVISION_ID
                                        , BOM.PARENT_ITEM_ID  AS ITEM_ID
                                        , BOM.CHILD_ITEM_ID   AS FINAL_ITEM_ID
                                        , (BOM.CHILD_QTY/BOM.PARENT_QTY)       AS ACCUM_QTY
                                FROM    SCM_MST_BOM_ENG_SN      BOM WITH(NOLOCK)
                                INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                GROUP BY DIVISION_ID, ITEM_ID
                                            )    SIM
                                    ON  BOM.DIVISION_ID     = SIM.DIVISION_ID
                                    AND BOM.PARENT_ITEM_ID  = SIM.ITEM_ID
                                INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                GROUP BY DIVISION_ID, ITEM_ID
                                            )    SIM2
                                    ON  BOM.DIVISION_ID   = SIM2.DIVISION_ID
                                    AND BOM.CHILD_ITEM_ID = SIM2.ITEM_ID
                                WHERE   1=1
                                AND     ISNULL(BOM.ALT_PRIORITY, 1) = 1
                                AND     BOM.EFF_END_DATE           >= GETDATE()
                                AND     SIM.ITEM_CLASS             IN ('ES0901')    -- AMDAU, AMDMO
                                AND     SIM2.ITEM_CLASS            IN ('EM0201')  -- Cell.
                            )
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,ORIGIN_DIVISION_ID
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

			SELECT  @v_plan_tp_cd               AS PLAN_TP_CD 
                , @v_plan_start_yyyymmdd        AS PLAN_START_YYYYMMDD
                , MM.DATA_TP_CD                 AS DATA_TP_CD
                --, 'BOH_FERT'                    AS SRCE_TP_CD
                , MM.BOH_TYPE                   AS SRCE_TP_CD
                ,LEFT(@v_division_id, 2)                AS DIVISION_ID
                , MM.DIVISION_ID                AS ORIGIN_DIVISION_ID
                , MM.GROUP_CODE1                AS GROUP_CODE1
                , MM.ITEM_ID                    AS ITEM_ID
                , MM.ORIGIN_ITEM_ID             AS ORIGIN_ITEM_ID
                , MM.SRCE_YYYYMM                AS SRCE_YYYYMM
                , MM.YYYYMM                     AS PLAN_YYYYMM
                , SUM(MM.LONG_TERM_STOCK_QTY)   AS QTY 
                , 'KRW'                         AS CURRENCY
                , NULL                          AS STANDARD_COST
                , NULL                          AS AMT
                , NULL                          AS SCM_SITE_ID
                , NULL                          AS OPERATION_GROUP
                , NULL                          AS OPERATION_ID
                , NULL                          AS DEVALUATION_AGE
                , NULL                          AS LONG_TERM_TYPE_CODE
                , NULL                          AS LONG_TERM_TYPE
                , NULL                          AS VERSION_NO
				, ISNULL(MM.COMPANY_ID, '*')    AS COMPANY_ID
				, MM.PLANT_ID
            FROM ( 
                    SELECT
                            A.DIVISION_ID           AS DIVISION_ID
                            , 'RESULT'              AS DATA_TP_CD
                            , '*'		            AS PLANT_ID
                            , CASE WHEN D.CLASS_ID IN ('ES0901') THEN ISNULL(ISNULL(AM.FINAL_ITEM_ID, AM2.FINAL_ITEM_ID),A.ITEM_ID)
                                   ELSE A.ITEM_ID 
                                    END             AS ITEM_ID
                            , A.ITEM_ID             AS ORIGIN_ITEM_ID
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   ELSE D.ITEM_TYPE 
                                    END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , CASE WHEN D.CLASS_ID IN ('ES0901') THEN ROUND(A.LONG_TERM_STOCK_QTY * ISNULL(ISNULL(AM.ACCUM_QTY, AM2.ACCUM_QTY), 1), 0) 
                                   ELSE A.LONG_TERM_STOCK_QTY 
                                    END             AS LONG_TERM_STOCK_QTY
                            , '*'                   AS GROUP_CODE1
                            --, CASE WHEN ISNULL(T.GROUP_CODE1, '') = '' THEN A.ITEM_ID ELSE ISNULL(T.GROUP_CODE1, '') END AS GROUP_CODE1
                            --, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2)) AS AGING_MONTHS
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            , A.YYYYMM              AS YYYYMM
                            --, LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS YYYYMM
                            --, @v_basis_yyyymm AS YYYYMM
                            , CASE WHEN A.VALUATION_CLASS in ( '3004','3109','7909','7929' ) THEN 'BOH_DEVL' ELSE 'BOH_FERT' END AS BOH_TYPE
							--, AM.COMPANY_ID
							,COMPANY_ID = (SELECT TOP 1 SMS.COMPANY_ID FROM SCM_MST_SITE SMS WITH(NOLOCK) WHERE SMS.DIVISION_ID = A.DIVISION_ID AND SMS.PLANT_ID = A.PLANT_ID)    -- JJG 추가 2025.03.21
                    FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                    LEFT OUTER JOIN AMDAU AM
                        ON      AM.DIVISION_ID  = A.DIVISION_ID
                        --AND     AM.PLANT_ID     = IIF(A.PLANT_ID = 'A002', 'A040', A.PLANT_ID)
                        AND     AM.PLANT_ID     = IIF(A.PLANT_ID = 'HQ05', 'HQ07', A.PLANT_ID)
                        AND     AM.ITEM_ID      = A.ITEM_ID
                    LEFT OUTER JOIN AMDAU2 AM2
                        ON      AM2.DIVISION_ID  = A.DIVISION_ID
                        --AND     AM2.PLANT_ID     = IIF(A.PLANT_ID = 'A002', 'A040', A.PLANT_ID)--A.PLANT_ID
                        AND     AM2.PLANT_ID     = IIF(A.PLANT_ID = 'HQ05', 'HQ07', A.PLANT_ID)--A.PLANT_ID
                        AND     AM2.ITEM_ID      = A.ITEM_ID
                        AND     ISNULL(AM.FINAL_ITEM_ID, '') = ''
                    LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON C.ITEM_CLASS = D.CLASS_ID
                    /* LEFT OUTER JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK)
                        ON    T.DIVISION_ID   = A.DIVISION_ID
                        AND   T.ITEM_ID       = A.ITEM_ID */
                    WHERE   1=1
                    AND     A.DIVISION_ID    = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                    AND     A.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND     A.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    --AND     A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    UNION ALL
                    SELECT  --당월 BOH.
                            A.DIVISION_ID           AS DIVISION_ID
                            , 'BOH'                 AS DATA_TP_CD
                            , '*'		            AS PLANT_ID
                            , CASE WHEN D.CLASS_ID IN ('ES0901') THEN ISNULL(ISNULL(AM.FINAL_ITEM_ID, AM2.FINAL_ITEM_ID),A.ITEM_ID)
                                   ELSE A.ITEM_ID 
                                    END             AS ITEM_ID
                            , A.ITEM_ID             AS ORIGIN_ITEM_ID
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                   WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                   ELSE D.ITEM_TYPE 
                                    END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , D.PROCESS_GROUP       AS PROCESS_GROUP
                            , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                            , CASE WHEN D.CLASS_ID IN ('ES0901') THEN ROUND(A.LONG_TERM_STOCK_QTY * ISNULL(ISNULL(AM.ACCUM_QTY, AM2.ACCUM_QTY), 1), 0) 
                                   ELSE A.LONG_TERM_STOCK_QTY 
                                    END             AS LONG_TERM_STOCK_QTY
                            , '*'                   AS GROUP_CODE1
                            --, CASE WHEN ISNULL(T.GROUP_CODE1, '') = '' THEN A.ITEM_ID ELSE ISNULL(T.GROUP_CODE1, '') END AS GROUP_CODE1
                            --, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2)) AS AGING_MONTHS
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                            , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS YYYYMM
                            --, @v_basis_yyyymm AS YYYYMM
                            , CASE WHEN A.VALUATION_CLASS in ( '3004','3109','7909','7929' ) THEN 'BOH_DEVL' ELSE 'BOH_FERT' END AS BOH_TYPE
							--, AM.COMPANY_ID
							,COMPANY_ID = (SELECT TOP 1 SMS.COMPANY_ID FROM SCM_MST_SITE SMS WITH(NOLOCK) WHERE SMS.DIVISION_ID = A.DIVISION_ID AND SMS.PLANT_ID = A.PLANT_ID)    -- JJG 추가 2025.03.21
                    FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
                    LEFT OUTER JOIN AMDAU AM
                        ON      AM.DIVISION_ID  = A.DIVISION_ID
                        --AND     AM.PLANT_ID     = IIF(A.PLANT_ID = 'A002', 'A040', A.PLANT_ID)
                        AND     AM.PLANT_ID     = IIF(A.PLANT_ID = 'HQ05', 'HQ07', A.PLANT_ID)
                        AND     AM.ITEM_ID      = A.ITEM_ID
                    LEFT OUTER JOIN AMDAU2 AM2
                        ON      AM2.DIVISION_ID  = A.DIVISION_ID
                        --AND     AM2.PLANT_ID     = IIF(A.PLANT_ID = 'A002', 'A040', A.PLANT_ID)--A.PLANT_ID
                        AND     AM2.PLANT_ID     = IIF(A.PLANT_ID = 'HQ05', 'HQ07', A.PLANT_ID)--A.PLANT_ID
                        AND     AM2.ITEM_ID      = A.ITEM_ID
                        AND     ISNULL(AM.FINAL_ITEM_ID, '') = ''
                    LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON C.ITEM_CLASS = D.CLASS_ID
                    /* LEFT OUTER JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK)
                        ON    T.DIVISION_ID   = A.DIVISION_ID
                        AND   T.ITEM_ID       = A.ITEM_ID */
                    WHERE   1=1
                    AND     A.DIVISION_ID    = @v_division_id  -- LIKE CONCAT(@v_division_id, '%')
                    AND     A.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    /* AND     A.YYYYMM        >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND     A.YYYYMM        <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                    
                    
                ) MM
            WHERE   1=1
            AND     MM.ITEM_TYPE = N'제품'
            GROUP BY  MM.DATA_TP_CD
                    , MM.BOH_TYPE
                    , MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , MM.ITEM_ID
                    , MM.ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
					, MM.COMPANY_ID
					, MM.PLANT_ID
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-4 End';

-- JJG 여기까지 1분 2초.
-- 2627Violation of PRIMARY KEY constraint 'PK_SCM_LGTM_INV_PSI_SUMMARY'. Cannot insert duplicate key in object 'dbo.SCM_LGTM_INV_PSI_SUMMARY'. The duplicate key value is (FERT, 20250303, P, P, 40, 40, *, MCCM350415A1, MACM350415A1, 202503, 202503).
-- 515Cannot insert the value NULL into column 'COMPANY_ID', table 'LGCE_SCMPROD.dbo.SCM_LGTM_INV_PSI_SUMMARY'; column does not allow nulls. INSERT fails.


        ------------------------------------------------------------------------  
		BEGIN
		------------------------------------------------------------------------
		-- Step 2-5. Insert Semi-Product BOH from Long Term Stock
        /* 
        Long Term Stock에서 반제품 Cell 만 가져옴.
         */
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
                    --, 'BOH_SPRD'                                AS SRCE_TP_CD
                    , MM.BOH_TYPE                               AS SRCE_TP_CD
                    ,LEFT(@v_division_id, 2)                            AS DIVISION_ID
                    , MM.DIVISION_ID                            AS ORIGIN_DIVISION_ID
                    , MM.GROUP_CODE1                            AS GROUP_CODE1
                    , ISNULL(BOM.PARENT_ITEM_ID, MM.ITEM_ID)    AS ITEM_ID
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
					, ISNULL(MM.COMPANY_ID, '*')				AS COMPANY_ID
					, MM.PLANT_ID
            FROM ( 
                    SELECT --실적, 계획 각각 집계. 실적 먼저.
                        A.DIVISION_ID           AS DIVISION_ID
                        , 'RESULT'              AS DATA_TP_CD
                        , '*'		            AS PLANT_ID
                        , A.ITEM_ID             AS ITEM_ID
                        , A.LONG_TERM_TYPE      AS LONG_TERM_TYPE
                        , D.ITEM_TYPE           AS ITEM_TYPE_ORG                                                                                                                    
                        , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                               WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                               ELSE D.ITEM_TYPE
                                END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                        , D.PROCESS_GROUP       AS PROCESS_GROUP
                        , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                        , A.VALUATION_CLASS     AS VALUATION_CLASS
                        , A.LONG_TERM_STOCK_QTY AS LONG_TERM_STOCK_QTY
                        , '*'                   AS GROUP_CODE1
                        , CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2)) AS AGING_MONTHS
                        , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                        , A.YYYYMM              AS YYYYMM
                        --, @v_basis_yyyymm       AS YYYYMM
                        , CASE WHEN A.VALUATION_CLASS in ( '3004','3109','7909','7929' ) THEN 'BOH_DEVL' ELSE 'BOH_SPRD' END AS BOH_TYPE
						, E.COMPANY_ID
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
                        ON A.PLANT_ID = B.PLANT_ID
                    LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON C.ITEM_CLASS = D.CLASS_ID
					LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
					    ON A.DIVISION_ID = E.DIVISION_ID
						AND A.PLANT_ID = E.PLANT_ID
                    WHERE 1=1
                    AND A.DIVISION_ID    = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                    AND     A.YYYYMM        > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND     A.YYYYMM       <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    --AND A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    UNION ALL
                    SELECT -- 계획월 BOH.
                        A.DIVISION_ID           AS DIVISION_ID
                        , 'BOH'                 AS DATA_TP_CD
                        , '*'		            AS PLANT_ID
                        , A.ITEM_ID             AS ITEM_ID
                        , A.LONG_TERM_TYPE      AS LONG_TERM_TYPE
                        , D.ITEM_TYPE           AS ITEM_TYPE_ORG                                                                                                                    
                        , CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                               WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                               ELSE D.ITEM_TYPE        
                                END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                        , D.PROCESS_GROUP       AS PROCESS_GROUP
                        , D.PROCESS_DETAIL      AS PROCESS_DETAIL
                        , A.VALUATION_CLASS     AS VALUATION_CLASS
                        , A.LONG_TERM_STOCK_QTY AS LONG_TERM_STOCK_QTY
                        , '*'                   AS GROUP_CODE1
                        , CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2)) AS AGING_MONTHS
                        , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, CONVERT(NUMERIC, RIGHT(A.DEVALUATION_AGE, 2))*(-1), CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                        , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(A.YYYYMM,'01'))), 112), 6) AS YYYYMM
                        --, @v_basis_yyyymm       AS YYYYMM
                        , CASE WHEN A.VALUATION_CLASS in ( '3004','3109','7909','7929' ) THEN 'BOH_DEVL' ELSE 'BOH_SPRD' END AS BOH_TYPE
						, E.COMPANY_ID
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
                        ON A.PLANT_ID = B.PLANT_ID
                    LEFT JOIN (SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                    ) C
                        ON  A.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON C.ITEM_CLASS = D.CLASS_ID
					LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
					    ON A.DIVISION_ID = E.DIVISION_ID
						AND A.PLANT_ID = E.PLANT_ID
                    WHERE 1=1
                    AND     A.DIVISION_ID   = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                    AND     A.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    /* AND     A.YYYYMM        >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND     A.YYYYMM        <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                ) MM
            LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                WHERE     1=1 
                                AND       DIVISION_ID     = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                                AND       PARENT_ITEM_ID != '*'
                                GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                ) BOM
            ON  BOM.DIVISION_ID     = MM.DIVISION_ID
            AND BOM.CHILD_ITEM_ID   = MM.ITEM_ID
            WHERE   1=1
            AND     MM.ITEM_TYPE        = N'반제품'
            AND     MM.PROCESS_GROUP    = 'CELL'
            GROUP BY  MM.DATA_TP_CD
                    , MM.BOH_TYPE
                    , MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , ISNULL(BOM.PARENT_ITEM_ID, MM.ITEM_ID)
                    , MM.ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
					, MM.PLANT_ID
					, MM.COMPANY_ID
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-5 End';

-- JJG 여기까지 1분 3초
	


        BEGIN
		------------------------------------------------------------------------
		-- Step 2-6. Insert Product Intransit from Ending Stock.
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
                    , MM.DATA_TP_CD             AS DATA_TP_CD
                    , 'BOH_INTS'                AS SRCE_TP_CD
                    ,LEFT(@v_division_id, 2)            AS DIVISION_ID
                    , MM.DIVISION_ID            AS ORIGIN_DIVISION_ID
                    , MM.GROUP_CODE1            AS GROUP_CODE1
                    , MM.ITEM_ID                AS ITEM_ID
                    , MM.ITEM_ID                AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM            AS SRCE_YYYYMM
                    , MM.YYYYMM                 AS PLAN_YYYYMM
                    , SUM(MM.QUANTITY)          AS QTY 
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
					, ISNULL(MM.COMPANY_ID, '*') AS COMPANY_ID
					, '*'						AS PLANT_ID
                FROM ( 
                        SELECT  /*실적.*/
                                B.DIVISION_ID
                                , 'RESULT'              AS DATA_TP_CD
                                , CASE WHEN (D.ITEM_TYPE = N'반제품' AND D.PROCESS_GROUP = 'CELL') THEN ISNULL(BOM.PARENT_ITEM_ID, B.ITEM_ID) 
                                       ELSE B.ITEM_ID 
                                        END             AS ITEM_ID
                                , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                , B.VALUATION_CLASS     AS VALUATION_CLASS
                                , B.QUANTITY            AS QUANTITY
                                , B.IN_TRANSIT          AS IN_TRANSIT
                                , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                , D.PROCESS_GROUP       AS PROCESS_GROUP
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE
                                        END             AS ITEM_TYPE
                                , '*'                   AS GROUP_CODE1
                                , B.YYYYMM              AS SRCE_YYYYMM
                                , B.YYYYMM              AS YYYYMM
                                -- , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                -- , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
								,B.PLANT_ID
								,E.COMPANY_ID
                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON C.ITEM_CLASS = D.CLASS_ID
                        /* LEFT OUTER JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK)
                            ON    T.DIVISION_ID   = B.DIVISION_ID
                            AND   T.ITEM_ID       = B.ITEM_ID */
                            LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                                FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                                WHERE     1=1 
                                                AND       DIVISION_ID     = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                                                AND       PARENT_ITEM_ID != '*'
                                                GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                                ) BOM
                            ON  BOM.DIVISION_ID     = B.DIVISION_ID
                            AND BOM.CHILD_ITEM_ID   = B.ITEM_ID 
					    LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
					       ON B.DIVISION_ID = E.DIVISION_ID
						  AND B.PLANT_ID = E.PLANT_ID
                        WHERE   1=1
                        AND     B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        --AND     B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND     B.DIVISION_ID       = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                        AND     B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                        AND    (D.ITEM_TYPE         = N'제품'
                            OR (D.ITEM_TYPE         = N'반제품' AND D.PROCESS_GROUP = 'CELL'))
                        UNION ALL
                        /*계획.*/
                        SELECT  B.DIVISION_ID
                                , 'BOH'                 AS DATA_TP_CD
                                , CASE WHEN (D.ITEM_TYPE = N'반제품' AND D.PROCESS_GROUP = 'CELL') THEN ISNULL(BOM.PARENT_ITEM_ID, B.ITEM_ID) 
                                       ELSE B.ITEM_ID 
                                        END             AS ITEM_ID
                                , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                , B.VALUATION_CLASS     AS VALUATION_CLASS
                                , B.QUANTITY            AS QUANTITY
                                , B.IN_TRANSIT          AS IN_TRANSIT
                                , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                , D.PROCESS_GROUP       AS PROCESS_GROUP
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE        
                                        END             AS ITEM_TYPE
                                , '*'                   AS GROUP_CODE1
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS SRCE_YYYYMM
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                                /* , CASE WHEN ISNULL(T.GROUP_CODE1, '') = '' THEN B.ITEM_ID 
                                       ELSE ISNULL(T.GROUP_CODE1, '') 
                                       END AS GROUP_CODE1 */
                                -- , @v_basis_yyyymm   AS SRCE_YYYYMM
                                -- , @v_basis_yyyymm   AS YYYYMM
								,B.PLANT_ID
								,E.COMPANY_ID
                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON C.ITEM_CLASS = D.CLASS_ID
                            LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                                FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                                WHERE     1=1 
                                                AND       DIVISION_ID     = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                                                AND       PARENT_ITEM_ID != '*'
                                                GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                                ) BOM
                            ON  BOM.DIVISION_ID     = B.DIVISION_ID
                            AND BOM.CHILD_ITEM_ID   = B.ITEM_ID 
					    LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
					       ON B.DIVISION_ID = E.DIVISION_ID
						  AND B.PLANT_ID = E.PLANT_ID
                        WHERE   1=1
                        AND     B.DIVISION_ID    = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                        AND     B.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND     B.STORAGE_LOCATION   IN (N'미착', N'IN-T')
                        AND    (D.ITEM_TYPE         = N'제품'
                            OR (D.ITEM_TYPE         = N'반제품' AND D.PROCESS_GROUP = 'CELL'))
                        /* AND     B.YYYYMM           >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                    ) MM
                WHERE 1=1
                GROUP BY  MM.DATA_TP_CD
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
        PRINT 'Step 2-6 End';


        ------------------------------------------------------------------------  
		
        /*BEGIN
		------------------------------------------------------------------------
		-- Step 2-8. Insert 평가감 Product from Ending Stock.
        -- 평가감은 일단 Item Id 그대로 유지. 매핑 없음.
		------------------------------------------------------------------------  
        	INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,ORIGIN_DIVISION_ID
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
                    , @v_division_id            AS DIVISION_ID
                    , MM.DIVISION_ID            AS DIVISION_ID
                    , MM.GROUP_CODE1            AS GROUP_CODE1
                    , MM.ITEM_ID                AS ITEM_ID
                    , MM.ORIGIN_ITEM_ID         AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM            AS SRCE_YYYYMM
                    , MM.YYYYMM                 AS PLAN_YYYYMM
                    , SUM(MM.QUANTITY)          AS QTY 
                    , 'KRW'                     AS CURRENCY
                    , NULL                      AS STANDARD_COST
                    , NULL                      AS AMT
                    , NULL                      AS SCM_SITE_ID
                    , NULL                      AS OPERATION_GROUP
                    , NULL                      AS OPERATION_ID
                    , NULL                      AS DEVALUATION_AGE
                    , NULL                      AS LONG_TERM_TYPE_CODE
                    , NULL                      AS LONG_TERM_TYPE
                    , NULL                      AS VERSION
                FROM ( 
                        --평가감.
                        SELECT  B.DIVISION_ID
                                , 'RESULT'              AS DATA_TP_CD
                                , CASE WHEN (D.ITEM_TYPE = N'반제품' AND D.PROCESS_GROUP = 'CELL') THEN ISNULL(BOM.PARENT_ITEM_ID, B.ITEM_ID) 
                                       ELSE B.ITEM_ID 
                                        END             AS ITEM_ID
                                , B.ITEM_ID             AS ORIGIN_ITEM_ID
                                , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                , B.VALUATION_CLASS     AS VALUATION_CLASS
                                , B.QUANTITY            AS QUANTITY
                                , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE        
                                        END             AS ITEM_TYPE
                                , '*'                   AS GROUP_CODE1
                                , D.PROCESS_GROUP       AS PROCESS_GROUP
                                , B.YYYYMM              AS SRCE_YYYYMM
                                , B.YYYYMM              AS YYYYMM
                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON C.ITEM_CLASS = D.CLASS_ID
                        LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                            FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                            WHERE     1=1 
                                            AND       PARENT_ITEM_ID != '*'
                                            GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                            ) BOM
                            ON      BOM.DIVISION_ID     = B.DIVISION_ID
                            AND     BOM.CHILD_ITEM_ID   = B.ITEM_ID
                        WHERE   1=1
                        AND     B.DIVISION_ID    LIKE CONCAT(@v_division_id, '%')
                        AND     B.YYYYMM            > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND     B.VALUATION_CLASS   IN ('3109', '7909', '7929')  -- 3109: 상품/저장품 할 때 가져다 쓰고 완제품에서는 제외.
                        AND     B.STORAGE_LOCATION  != N'미착'
                        AND     (D.ITEM_TYPE         = N'제품'
                             OR (D.ITEM_TYPE         = N'반제품' AND D.PROCESS_GROUP = 'CELL'))
                        UNION ALL
                        SELECT  B.DIVISION_ID
                                , 'BOH'                 AS DATA_TP_CD
                                , CASE WHEN (D.ITEM_TYPE = N'반제품' AND D.PROCESS_GROUP = 'CELL') THEN ISNULL(BOM.PARENT_ITEM_ID, B.ITEM_ID) 
                                       ELSE B.ITEM_ID 
                                        END             AS ITEM_ID
                                , B.ITEM_ID             AS ORIGIN_ITEM_ID
                                , B.STORAGE_LOCATION    AS STORAGE_LOCATION
                                , B.VALUATION_CLASS     AS VALUATION_CLASS
                                , B.QUANTITY            AS QUANTITY
                                , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                                , CASE WHEN B.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                       WHEN B.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                       ELSE D.ITEM_TYPE        
                                        END             AS ITEM_TYPE
                                , '*'                   AS GROUP_CODE1
                                , D.PROCESS_GROUP       AS PROCESS_GROUP
                                , B.YYYYMM              AS SRCE_YYYYMM
                                , LEFT(CONVERT(CHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(B.YYYYMM,'01'))), 112), 6) AS YYYYMM
                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                        LEFT JOIN ( SELECT  ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                    ) C
                            ON  B.ITEM_ID = C.ITEM_ID
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                            ON C.ITEM_CLASS = D.CLASS_ID
                        LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                            FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                            WHERE     1=1 
                                            AND       PARENT_ITEM_ID != '*'
                                            GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                            ) BOM
                            ON      BOM.DIVISION_ID     = B.DIVISION_ID
                            AND     BOM.CHILD_ITEM_ID   = B.ITEM_ID
                        WHERE   1=1
                        AND     B.DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                        AND     B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                        AND     B.VALUATION_CLASS   IN ('3109', '7909', '7929')  -- 3109: 상품/저장품 할 때 가져다 쓰고 완제품에서는 제외.
                        AND     B.STORAGE_LOCATION  != N'미착'
                        AND     (D.ITEM_TYPE         = N'제품'
                             OR (D.ITEM_TYPE         = N'반제품' AND D.PROCESS_GROUP = 'CELL'))
                        /* AND     B.YYYYMM           >= CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                        AND     B.YYYYMM           <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6) */
                    ) MM
                WHERE 1=1
                GROUP BY  MM.DATA_TP_CD
                        , MM.DIVISION_ID
                        , MM.GROUP_CODE1
                        , MM.ITEM_ID
                        , MM.ORIGIN_ITEM_ID
                        , MM.SRCE_YYYYMM
                        , MM.YYYYMM
                ;
		------------------------------------------------------------------------  
		END
        */        
		------------------------------------------------------------------------  
        PRINT 'Step 2-8 End';
        ------------------------------------------------------------------------  

        BEGIN
        ------------------------------------------------------------------------
		-- Step 2-9. Insert 완제품 재고 소진계획. 
        -- 2024.09.12 Philsu Park: 장기재고 소진계획 신규 UI 기준 테이블(SCP_ANL_LGTM_INV_MGMT_PLAN)로 변경.
        -- 2024.10.18 Philsu Park: 소진계획 반영은 초기버전 외 버전에만 적용.
		------------------------------------------------------------------------ 
		
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
                    ,LEFT(@v_division_id, 2)            AS DIVISION_ID
                    , INV.DIVISION_ID           AS ORIGIN_DIVISION_ID
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
					, ISNULL(INV.COMPANY_ID,'*')  AS COMPANY_ID
					, '*'						  AS PLANT_ID
            FROM SCP_ANL_LGTM_INV_MGMT_PLAN INV WITH(NOLOCK)
			LEFT JOIN SCM_PLANT_M_SN E WITH(NOLOCK)
			       ON INV.DIVISION_ID = E.DIVISION_ID
			      AND INV.PLANT_ID = E.PLANT_ID
            WHERE   INV.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     INV.PLAN_TP_CD          = @v_plan_tp_cd
            AND     INV.DIVISION_ID      = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
            and     @v_plan_tp_cd           = @v_plan_tp_org
            GROUP BY  INV.DIVISION_ID
                    , INV.ITEM_ID
                    , INV.PLAN_YYYYMM
					, ISNULL(INV.COMPANY_ID,'*')
					--, INV.PLANT_ID
            ;
--			SELECT * FROM SCP_ANL_LGTM_INV_MGMT_PLAN
        ------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------  
        PRINT 'Step 2-9 S_EXHT End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------  

        /* BEGIN
		------------------------------------------------------------------------
		-- Step 2-9. Insert 완제품 재고 소진계획. 
		------------------------------------------------------------------------  
			WITH AMDAU AS (SELECT     SMB.PLANT_ID              AS PLANT_ID
                                    , SMB.DIVISION_ID           AS DIVISION_ID
                                    , SMB.CHILD_ITEM_ID         AS ITEM_ID
                                    , MAX(CASE WHEN ISNULL(SIM.FLOW_ID, '') = 'P5200' THEN SMB.PARENT_ITEM_ID 
                                                ELSE CBOM.CHILD_ITEM_ID END)    AS FINAL_ITEM_ID
                                    , MAX(CASE WHEN ISNULL(SIM.FLOW_ID, '') = 'P5200' THEN 1 
                                                ELSE (CBOM.CHILD_QTY/CBOM.PARENT_QTY) END) AS ACCUM_QTY
                            FROM      (SELECT  ROW_NUMBER()OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CHILD_ITEM_ID, BOM_VERSION_ID 
                                                                ORDER BY     KEY_DATE DESC, PARENT_ITEM_ID ASC
                                                                ) AS R_NUM
                                                , ALT_PRIORITY
                                                , PARENT_ITEM_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CHILD_ITEM_ID, BOM_VERSION_ID, KEY_DATE
                                                , CHILD_QTY
                                        FROM    SCM_MST_BOM_ENG_SN WITH(NOLOCK)
                                        WHERE   EFF_END_DATE >= GETDATE()
                                        )  SMB
                            INNER JOIN  SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                ON  SMB.COMPANY_ID      = SIM.COMPANY_ID
                                AND SMB.DIVISION_ID     = SIM.DIVISION_ID
                                AND SMB.SITE_ID         = SIM.SITE_ID
                                AND SMB.CHILD_ITEM_ID   = SIM.ITEM_ID
                            INNER JOIN  (SELECT  ROW_NUMBER()OVER(PARTITION BY BOM.PARENT_ITEM_ID, BOM.COMPANY_ID, BOM.DIVISION_ID, BOM.SITE_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID, BOM.BOM_VERSION_ID 
                                                                    ORDER BY   BOM.ALT_PRIORITY
                                                                    ) AS R_NUM
                                                , ALT_PRIORITY
                                                , BOM.PARENT_ITEM_ID, BOM.COMPANY_ID, BOM.DIVISION_ID, BOM.SITE_ID, BOM.PLANT_ID, BOM.CHILD_ITEM_ID, BOM.BOM_VERSION_ID, BOM.KEY_DATE
                                                , CHILD_QTY, PARENT_QTY
                                        FROM    SCM_MST_BOM_ENG_SN BOM WITH(NOLOCK)
                                        INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                        FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                        GROUP BY DIVISION_ID, ITEM_ID
                                                    ) ITM
                                            ON    ITM.DIVISION_ID = BOM.DIVISION_ID
                                            AND   ITM.ITEM_ID     = BOM.CHILD_ITEM_ID
                                            AND   ITM.ITEM_CLASS IN ('EM0201')
                                        WHERE   BOM.EFF_END_DATE >= GETDATE()
                                        ) CBOM
                                ON  SMB.DIVISION_ID     = CBOM.DIVISION_ID
                                AND SMB.COMPANY_ID      = CBOM.COMPANY_ID
                                AND SMB.SITE_ID         = CBOM.SITE_ID
                                AND SMB.CHILD_ITEM_ID   = CBOM.PARENT_ITEM_ID
                                AND CBOM.R_NUM          = 1
                            WHERE   1=1 
                            and     SMB.R_NUM           = 1
                            AND     SIM.ITEM_CLASS     IN ('ES0901') --AMDAU, AMDMO
                            GROUP BY  SMB.PLANT_ID
                                    , SMB.DIVISION_ID
                                    , SMB.CHILD_ITEM_ID
                            )
                , AMDAU2 AS (
                                SELECT  BOM.PLANT_ID        AS PLANT_ID
                                    , BOM.DIVISION_ID     AS DIVISION_ID
                                    , BOM.PARENT_ITEM_ID  AS ITEM_ID
                                    , BOM.CHILD_ITEM_ID   AS FINAL_ITEM_ID
                                    , (BOM.CHILD_QTY/BOM.PARENT_QTY)       AS ACCUM_QTY
                                FROM    SCM_MST_BOM_ENG_SN      BOM WITH(NOLOCK)
                                INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                GROUP BY DIVISION_ID, ITEM_ID
                                            )    SIM
                                    ON  BOM.DIVISION_ID     = SIM.DIVISION_ID
                                    AND BOM.PARENT_ITEM_ID  = SIM.ITEM_ID
                                INNER JOIN (    SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                                GROUP BY DIVISION_ID, ITEM_ID
                                            )    SIM2
                                    ON  BOM.DIVISION_ID   = SIM2.DIVISION_ID
                                    AND BOM.CHILD_ITEM_ID = SIM2.ITEM_ID
                                WHERE   1=1
                                AND     ISNULL(BOM.ALT_PRIORITY, 1) = 1
                                AND     BOM.EFF_END_DATE           >= GETDATE()
                                AND     SIM.ITEM_CLASS             IN ('ES0901')    -- AMDAU
                                AND     SIM2.ITEM_CLASS            IN ('EM0201')  -- Cell.
                            )
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
                    , 'S'                       AS DATA_TP_CD
                    , 'S_EXHT'                  AS SRCE_TP_CD
                    , @v_division_id            AS DIVISION_ID
                    , MM.DIVISION_ID            AS ORIGIN_DIVISION_ID
                    , MM.GROUP_CODE1            AS GROUP_CODE1
                    , MM.ITEM_ID                AS ITEM_ID
                    , MM.ORIGIN_ITEM_ID         AS ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM            AS SRCE_YYYYMM
                    , MM.YYYYMM                 AS PLAN_YYYYMM
                    , SUM(MM.QTY)               AS QTY
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
            FROM ( 
                    SELECT    LTS.DIVISION_ID   AS DIVISION_ID
                            , LTS.PLANT_ID      AS PLANT_ID
                            , CASE WHEN D.CLASS_ID IN ('ES0901') THEN ISNULL(ISNULL(AM.FINAL_ITEM_ID, AM2.FINAL_ITEM_ID),LTS.ITEM_ID)
                                   ELSE LTS.ITEM_ID 
                                    END         AS ITEM_ID
                            , LTS.ITEM_ID       AS ORIGIN_ITEM_ID
                            , D.ITEM_TYPE       AS ITEM_TYPE_ORG
                            , CASE WHEN LTS.VALUATION_CLASS IN ('3020','3030','3040')                       THEN N'저장품'
                                   WHEN LTS.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재' THEN N'상품'
                                   ELSE D.ITEM_TYPE 
                                    END         AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
                            , D.PROCESS_GROUP   AS PROCESS_GROUP
                            , D.PROCESS_DETAIL  AS PROCESS_DETAIL
                            , '*'               AS GROUP_CODE1
                            , CASE WHEN D.CLASS_ID IN ('ES0901') THEN ROUND(IEP.QTY * ISNULL(ISNULL(AM.ACCUM_QTY, AM2.ACCUM_QTY), 1), 0) 
                                   ELSE IEP.QTY
                                    END         AS QTY
                            , IEP.PLAN_YYYYMM   AS SRCE_YYYYMM
                            , IEP.PLAN_YYYYMM   AS YYYYMM
                            /* , CASE WHEN ISNULL(T.GROUP_CODE1, '') = '' THEN LTS.ITEM_ID 
                                   ELSE ISNULL(T.GROUP_CODE1, '') 
                                    END         AS GROUP_CODE1 */
                    FROM SCP_ANL_LONG_TERM_STOCK            LTS WITH(NOLOCK)
                    INNER JOIN SCP_ANL_LGTM_INV_EXHT_PLAN   IEP WITH(NOLOCK)
                        ON  IEP.YYYYMM          = LTS.YYYYMM
                        AND IEP.PLANT_ID        = LTS.PLANT_ID
                        AND IEP.DIVISION_ID     = LTS.DIVISION_ID
                        AND IEP.ITEM_ID         = LTS.ITEM_ID
                        AND IEP.CHARG           = LTS.CHARG
                        AND IEP.DEVALUATION_AGE = LTS.DEVALUATION_AGE
                    LEFT OUTER JOIN AMDAU AM
                        ON      AM.DIVISION_ID  = LTS.DIVISION_ID
                        AND     AM.PLANT_ID     = IIF(LTS.PLANT_ID = 'A002', 'A040', LTS.PLANT_ID)
                        AND     AM.ITEM_ID      = LTS.ITEM_ID
                    LEFT OUTER JOIN AMDAU2 AM2
                        ON      AM2.DIVISION_ID  = LTS.DIVISION_ID
                        AND     AM2.PLANT_ID     = IIF(LTS.PLANT_ID = 'A002', 'A040', LTS.PLANT_ID)--A.PLANT_ID
                        AND     AM2.ITEM_ID      = LTS.ITEM_ID
                        AND     ISNULL(AM.FINAL_ITEM_ID, '') = ''
                    LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID
                                ) C
                        ON  LTS.ITEM_ID = C.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    /* LEFT OUTER JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK)
                        ON    T.DIVISION_ID   = LTS.DIVISION_ID
                        AND   T.ITEM_ID       = LTS.ITEM_ID */
                    WHERE   1=1
                    AND     LTS.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND     LTS.DIVISION_ID   LIKE CONCAT(@v_division_id, '%')
                ) MM
            WHERE   1=1
            AND     MM.ITEM_TYPE    = N'제품'
            GROUP BY  MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , MM.ITEM_ID
                    , MM.ORIGIN_ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-9 End'; */

        /* BEGIN
		------------------------------------------------------------------------
		-- Step 2-5. Insert Semi-Product BOH from Long Term Stock
        /* 
        Long Term Stock에서 반제품 Cell 만 가져옴.
         */
		------------------------------------------------------------------------  
			INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                (PLAN_TP_CD
                ,PLAN_START_YYYYMMDD
                ,DATA_TP_CD
                ,SRCE_TP_CD
                ,DIVISION_ID
                ,ORIGIN_DIVISION_ID
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
                    , @v_division_id                            AS DIVISION_ID
                    , MM.DIVISION_ID                            AS ORIGIN_DIVISION_ID
                    , MM.GROUP_CODE1                            AS GROUP_CODE1
                    , ISNULL(BOM.PARENT_ITEM_ID, MM.ITEM_ID)    AS ITEM_ID
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
            FROM ( 
                    SELECT  LTS.DIVISION_ID         AS DIVISION_ID
                            , LTS.PLANT_ID          AS PLANT_ID
                            , LTS.ITEM_ID           AS ITEM_ID
                            , LTS.LONG_TERM_TYPE    AS LONG_TERM_TYPE
                            , D.ITEM_TYPE           AS ITEM_TYPE_ORG
                            , CASE WHEN LTS.VALUATION_CLASS IN ('3020','3030','3040')                       THEN N'저장품'
                                   WHEN LTS.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재' THEN N'상품'
                                   ELSE D.ITEM_TYPE        
                                    END             AS ITEM_TYPE      -- 원반제구분 기말재고 방식(ITEM TYPE 구분 ON UI)
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
                        ON    T.DIVISION_ID   = LTS.DIVISION_ID
                        AND   T.ITEM_ID       = LTS.ITEM_ID */
                    WHERE 1=1
                    AND LTS.YYYYMM        = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND LTS.DIVISION_ID   LIKE CONCAT(@v_division_id, '%')
                ) MM
            LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID 
                                FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                WHERE     1=1 
                                AND       DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                                AND       PARENT_ITEM_ID != '*'
                                GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                ) BOM
                ON  BOM.DIVISION_ID     = MM.DIVISION_ID
                AND BOM.CHILD_ITEM_ID   = MM.ITEM_ID
            WHERE   1=1
            AND     MM.ITEM_TYPE        = N'반제품'
            AND     MM.PROCESS_GROUP    = 'CELL'
            GROUP BY MM.DIVISION_ID
                    , MM.GROUP_CODE1
                    , ISNULL(BOM.PARENT_ITEM_ID, MM.ITEM_ID)
                    , MM.ITEM_ID
                    , MM.SRCE_YYYYMM
                    , MM.YYYYMM
            ;
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 2-10 End'; */



		UPDATE SCM_LGTM_INV_PSI_SUMMARY	
		SET QTY = B.SUM_QTY
		FROM SCM_LGTM_INV_PSI_SUMMARY A,
		(
		select COMPANY_ID, PLANT_ID, PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, A.DIVISION_ID,  ORIGIN_DIVISION_ID, GROUP_CODE1, A.ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM, A.QTY
		,SUM(A.QTY) OVER (PARTITION BY  PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, A.DIVISION_ID,  ORIGIN_DIVISION_ID, GROUP_CODE1, A.ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM) AS SUM_QTY
					FROM SCM_LGTM_INV_PSI_SUMMARY A WITH(NOLOCK)
					WHERE 1=1
					AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
					AND A.ORIGIN_DIVISION_ID = @v_division_id
					AND A.ITEM_ID IN (SELECT DISTINCT SEGMENT2 AS ITEM_ID FROM SCM_ADM_LOOKUP_MASTER_DETAIL
										WHERE LOOKUP_TYPE = 'SCM_LGTM_INV_COMPANY_RELOCATE' AND VALID_YN = 'Y')
					AND A.PLAN_TP_CD = @p_plan_tp_cd
					) B
		WHERE A.COMPANY_ID = B.COMPANY_ID
		AND A.PLANT_ID = B.PLANT_ID
		AND A.PLAN_TP_CD = B.PLAN_TP_CD
		AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
		AND A.DATA_TP_CD = B.DATA_TP_CD
		AND A.SRCE_TP_CD = B.SRCE_TP_CD
		AND A.DIVISION_ID = B.DIVISION_ID
		AND A.ORIGIN_DIVISION_ID = B.ORIGIN_DIVISION_ID
		AND A.GROUP_CODE1 = B.GROUP_CODE1
		AND A.ITEM_ID = B.ITEM_ID
		AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID
		AND A.SRCE_YYYYMM = B.SRCE_YYYYMM
		AND A.PLAN_YYYYMM = B.PLAN_YYYYMM;


		UPDATE SCM_LGTM_INV_PSI_SUMMARY
		SET SCM_LGTM_INV_PSI_SUMMARY.QTY = 0
		, LAST_UPDATED_BY = 'COMPANY_SUM'
		from SCM_LGTM_INV_PSI_SUMMARY a
		inner join(
			select  PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, A.DIVISION_ID,  ORIGIN_DIVISION_ID, GROUP_CODE1, A.ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM, count(*) as cnt
			FROM SCM_LGTM_INV_PSI_SUMMARY A WITH(NOLOCK)
			WHERE 1=1
			AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND A.ORIGIN_DIVISION_ID = @v_division_id
			AND A.ITEM_ID IN (SELECT DISTINCT SEGMENT2 AS ITEM_ID FROM SCM_ADM_LOOKUP_MASTER_DETAIL
								WHERE LOOKUP_TYPE = 'SCM_LGTM_INV_COMPANY_RELOCATE' AND VALID_YN = 'Y')
			AND A.PLAN_TP_CD = @p_plan_tp_cd
			GROUP BY    PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, A.DIVISION_ID,  ORIGIN_DIVISION_ID, GROUP_CODE1, A.ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM
			HAVING count(*) > 1
		)b
		on a.PLAN_TP_CD = b.PLAN_TP_CD
		and a.PLAN_START_YYYYMMDD = b.PLAN_START_YYYYMMDD
		and a.DATA_TP_CD = b.DATA_TP_CD
		and a.SRCE_TP_CD = b.SRCE_TP_CD
		and a.DIVISION_ID = b.DIVISION_ID
		and a.ORIGIN_DIVISION_ID = b.ORIGIN_DIVISION_ID
		and a.GROUP_CODE1 = b.GROUP_CODE1
		and a.ITEM_ID = b.ITEM_ID
		and a.ORIGIN_ITEM_ID = b.ORIGIN_ITEM_ID
		and a.SRCE_YYYYMM = b.SRCE_YYYYMM
		and a.PLAN_YYYYMM = b.PLAN_YYYYMM
		LEFT JOIN(
					SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS ITEM_ID, SEGMENT3 AS FROM_COMPANY, SEGMENT4 AS TO_COMPANY FROM SCM_ADM_LOOKUP_MASTER_DETAIL
					WHERE LOOKUP_TYPE = 'SCM_LGTM_INV_COMPANY_RELOCATE' AND VALID_YN = 'Y'
					)c
		on a.ITEM_ID = c.ITEM_ID
		and a.DIVISION_ID = c.DIVISION_ID
		and a.COMPANY_ID = c.FROM_COMPANY
		where c.TO_COMPANY IS NOT NULL


		UPDATE SCM_LGTM_INV_PSI_SUMMARY
		SET SCM_LGTM_INV_PSI_SUMMARY.COMPANY_ID = B.TO_COMPANY_ID
		FROM SCM_LGTM_INV_PSI_SUMMARY A, 
		(SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS ITEM_ID, SEGMENT3 AS FROM_COMPANY_ID, SEGMENT4 AS TO_COMPANY_ID 
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'SCM_LGTM_INV_COMPANY_RELOCATE' AND VALID_YN = 'Y') B
		WHERE A.COMPANY_ID = B.FROM_COMPANY_ID
		AND A.DIVISION_ID = B.DIVISION_ID
		AND A.ITEM_ID = B.ITEM_ID
		AND A.PLAN_TP_CD = @p_plan_tp_cd
		AND A.LAST_UPDATED_BY <> 'COMPANY_SUM'
		AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		AND A.ORIGIN_DIVISION_ID = @v_division_id



        BEGIN
        ------------------------------------------------------------------------
		-- Step 3-1. 부자재 성격의 완제품 PSI 삭제 처리(EM0306)
		------------------------------------------------------------------------  
		DELETE
        FROM   SCM_LGTM_INV_PSI_SUMMARY
        WHERE  1=1
        AND    PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
        AND    ORIGIN_DIVISION_ID         = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
        AND    ITEM_ID IN   (   SELECT ITEM_ID
                                FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                WHERE  ITEM_CLASS = 'EM0306'
                            )
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 3-1 End';
        ------------------------------------------------------------------------

         BEGIN
            ------------------------------------------------------------------------
            -- Step 4. 완전 특화 로직!!!!!!
            ------------------------------------------------------------------------  
            -- 3단계/2단계가 혼용된 모델은 구분방법이 없어 ITEM으로 Hard coding한다.
            --              1st           2nd           3rd
            -- CASE1. ( MCSS20253-A4  MFSS20253-A4  MASS20253-A2 )
            -- CASE2. ( MCSS20253-A2                MASS20253-A2 )
            -- CASE3. ( MCSS22531-A1  MFSS22531-A1  MASS20253-A2 )
            -- 3단계/2단계 혼용 모델은 일반 3단계 모델의 1,2단계 집계가 아닌 1,3 단계로 한다.
            -- 3단계가 올라갈 2단계가 없는 경우가 있기 때문에 1,3으로 한다.
            ------------------------------------------------------------------------ 
            -- Step 4-1. 올라가있는 3단계의 P/BOH를 환원
            ------------------------------------------------------------------------ 
            UPDATE SCM_LGTM_INV_PSI_SUMMARY
            SET    ITEM_ID = ORIGIN_ITEM_ID
            WHERE  1=1
            AND    ORIGIN_DIVISION_ID          = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
            AND    PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
            AND    ORIGIN_ITEM_ID       = 'MASS20253-A2'

            ------------------------------------------------------------------------ 
            -- Step 4-2. 3으로 내려왔다가 2로 올라가있는 S Target을 다시 3으로 내림
            ------------------------------------------------------------------------ 
            UPDATE SCM_LGTM_INV_PSI_SUMMARY
            SET    ITEM_ID              = 'MASS20253-A2'
            WHERE  1=1
            AND    ORIGIN_DIVISION_ID          = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
            AND    PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
            AND    ORIGIN_ITEM_ID       IN ('MFSS20253-A4','MFSS22531-A1')
            AND    SRCE_TP_CD           = 'S_TARGET'

            ------------------------------------------------------------------------ 
            -- Step 4-2. 1,3 중 1에 머물러 있는 S/BOH를 3으로 내림
            ------------------------------------------------------------------------ 
            UPDATE SCM_LGTM_INV_PSI_SUMMARY
            SET    ITEM_ID             = 'MASS20253-A2'
            WHERE  1=1
            AND    ORIGIN_DIVISION_ID          = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
            AND    PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
            AND    ORIGIN_ITEM_ID       = 'MCSS20253-A2'
            ------------------------------------------------------------------------  
            END
            ------------------------------------------------------------------------  
            PRINT 'Step 4-1 End';
            ------------------------------------------------------------------------

            BEGIN
            ------------------------------------------------------------------------
            -- Step 4. 완전 특화 로직!!!!!!
            ------------------------------------------------------------------------  
            -- AMDMO로 전개되는 Pack Biz Hard Coding(임시)
            ------------------------------------------------------------------------ 
            -- Step 4-1. AMDMO 상위 모델의 S_Target 을 AMDMO 로 치환.
            ------------------------------------------------------------------------ 
            UPDATE SCM_LGTM_INV_PSI_SUMMARY
            SET    ITEM_ID              = 'AMDMO0001A'
                 , QTY                  = (QTY / 1248)*2
                 , LAST_UPDATE_DATE     = GETDATE()
                 , LAST_UPDATED_BY      = 'AMDMO_HardCoding'
            WHERE  1=1
            AND    PLAN_TP_CD           = @v_plan_tp_cd
            AND    ORIGIN_DIVISION_ID          = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
            AND    PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
            AND    SRCE_TP_CD           = 'S_TARGET'
            AND    ORIGIN_ITEM_ID       = 'MPCISZISLD1V'
            ------------------------------------------------------------------------  
            END
            ------------------------------------------------------------------------  
            PRINT 'Step 4-2 End';
            ------------------------------------------------------------------------

            PRINT 'Step 5 Start' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);

            ------------------------------------------------------------------------
            -- 2024.09.10 Philsu Park
            -- 활성화 수율 반영. 원천(SCP_MST_FORMATION)
            -- Item_id 기준으로 Cell Assy 공정의 Item 을 찾아서 원천의 수율정보를 찾아오되 0보다 크고 1보다 작은 경우만 반영한다.
            -- RTF: Cell Biz 인 경우 수율 적용
            -- S_TARGET: 수율 적용
            ------------------------------------------------------------------------
            BEGIN
                WITH YIELD AS (
                                SELECT  YLD.DIVISION_ID
                                        , YLD.ITEM_ID
                                        , AVG(ISNULL(YLD.SSP_MODIFY_YIELD, YLD.FORMATION_TOTAL_YIELD)) AS YIELD
                                FROM    SCP_MST_FORMATION YLD WITH(NOLOCK)
                                LEFT OUTER JOIN SCM_MST_SITE S WITH(NOLOCK)
                                    ON  S.DIVISION_ID   = YLD.DIVISION_ID
                                    AND S.SCM_SITE_ID   = YLD.PLANT_SITE_ID
                                WHERE   ISNULL(YLD.SSP_MODIFY_YIELD, YLD.FORMATION_TOTAL_YIELD) > 0
                                AND     ISNULL(YLD.SSP_MODIFY_YIELD, YLD.FORMATION_TOTAL_YIELD) < 1
                                GROUP BY YLD.DIVISION_ID
                                        , YLD.ITEM_ID
                                )
                UPDATE  SUM
                SET     QTY = QTY / ISNULL((
                                    SELECT  YLD.YIELD
                                    FROM    YIELD YLD 
                                    WHERE   YLD.DIVISION_ID = SUM.ORIGIN_DIVISION_ID
                                    AND     YLD.ITEM_ID     = ISNULL(BOM.CHILD_ITEM_ID, SUM.ITEM_ID)
                                    ), 1)
                        , LAST_UPDATE_DATE  = CURRENT_TIMESTAMP
                        , LAST_UPDATED_BY   = 'YIELD_APPLIED'
                FROM    SCM_LGTM_INV_PSI_SUMMARY SUM
                INNER JOIN (   SELECT ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM SCM_ITEM_M_SN WITH(NOLOCK)
                                GROUP BY ITEM_ID) ITM
                    ON ITM.ITEM_ID = SUM.ITEM_ID
                INNER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                    ON CLS.CLASS_ID = ITM.ITEM_CLASS
                LEFT OUTER JOIN (SELECT BOM.DIVISION_ID, BOM.PARENT_ITEM_ID, BOM.CHILD_ITEM_ID
                                    FROM SCM_MST_BOM_EFFECTIVE_SN BOM WITH(NOLOCK)
                                    INNER JOIN (   SELECT ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                    FROM SCM_ITEM_M_SN WITH(NOLOCK)
                                                    GROUP BY ITEM_ID) ITM
                                        ON ITM.ITEM_ID = BOM.CHILD_ITEM_ID
                                    WHERE   BOM.ALT_PRIORITY    = 'Y'
                                    AND     BOM.EFF_END_DATE   >= GETDATE()
                                    and     BOM.PARENT_ITEM_ID != '*'
                                    and     ITM.ITEM_CLASS      = 'ES1901'
                                    GROUP BY BOM.DIVISION_ID, BOM.PARENT_ITEM_ID, BOM.CHILD_ITEM_ID) BOM
                    ON  BOM.DIVISION_ID     = SUM.ORIGIN_DIVISION_ID
                    AND BOM.PARENT_ITEM_ID  = SUM.ITEM_ID
                WHERE   1=1
                AND     SUM.PLAN_TP_CD          = @v_plan_tp_cd
                AND     SUM.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
                AND     SUM.ORIGIN_DIVISION_ID      = @v_division_id  --LIKE CONCAT(@v_division_id, '%')
                AND     SUM.DATA_TP_CD          = 'S'
                AND     (SUM.SRCE_TP_CD = 'S_RTF' AND CLS.LEVEL_3_ID IN ('ES1901', 'EM0101', 'EM0201', 'EM0301')
                        OR SUM.SRCE_TP_CD = 'S_TARGET'
                        )
                AND     CLS.PROCESS_GROUP = 'Cell'
                ;
            END

            PRINT 'Yield Applied: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);

            IF OBJECT_ID (N'tempdb..#TEMP_PROD_PLAN', N'U') IS NOT NULL 		DROP TABLE #TEMP_PROD_PLAN;

-- exec PR_SCM_LGTM_INV_ALLOCATION_OIJ 'FERT', '40', '20250303', '202503', '20250303'




--jjg		COMMIT TRANSACTION;
	END TRY

	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
--jjg	ROLLBACK TRANSACTION PR_SCM_LGTM_INV_ALLOCATION;
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

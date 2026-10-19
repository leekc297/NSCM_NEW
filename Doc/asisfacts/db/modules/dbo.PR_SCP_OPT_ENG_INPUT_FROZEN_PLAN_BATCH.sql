
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_FROZEN_PLAN_BATCH]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.14 Taehyun Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_FROZEN_PLAN_BATCH';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME
    DECLARE @V_SCP_PLAN_DATE     NVARCHAR(8)
    DECLARE @V_SCP_PLAN_TYPE     NVARCHAR(8)
    DECLARE @V_SCP_PLAN_SEQ      NVARCHAR(8)
    DECLARE @V_FRZ_START_DATE    NVARCHAR(8)
    DECLARE @V_FRZ_END_DATE      NVARCHAR(8)
    DECLARE @V_SYS_DIVS_CD       NVARCHAR(8)
    DECLARE @V_PROD_FP_FRZ_TYPE  NVARCHAR(20)

    DECLARE @PROD_FROZEN_TEMP TABLE(
     SCM_SITE_ID NVARCHAR(20)
    ,ITEM_ID     NVARCHAR(50)
    ,STAGE       NVARCHAR(10)
    ,LINE_ID     NVARCHAR(20)
    ,PLAN_DATE   NVARCHAR(8)
    ,PLAN_IN_QTY NUMERIC(20,10)
    ,SOURCE_CHK  NVARCHAR(50)
    )
    ------------------------------------------------------------------------ 
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
		-- PR_SCP_OPT_ENG_INPUT_ITEM_BOM_ROUTING 에서 동일 정보 사용
        /* SELECT  @V_PROD_FROZEN = SEGMENT4
		FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
		AND     VALID_YN    = 'Y'
		AND     SEGMENT1    = @V_DIVISION_ID
		AND     SEGMENT2    = @V_GROUP_ID
        --AND     SEGMENT3    = 'PR' --임시
        AND     SEGMENT3    = @V_SCP_PLAN_TYPE

		SET @V_PROD_FROZEN_END = CONVERT(CHAR(8), DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE ), 112) -- Prod Frozen 다음 일자 정보
         */

        ------------------------------------------------------------------------
        -- Data Insert Start
        -- 2025.05.16 Philsu Park: Frozen 을 Stage단위로 구분 적용.
        ------------------------------------------------------------------------
		-- PR_SCP_OPT_ENG_INPUT_ITEM_BOM_ROUTING 에서 동일 정보 사용
  --      IF OBJECT_ID('TEMPDB..#PROD_FROZEN') IS NOT NULL
		--BEGIN 
		--	DROP TABLE  #PROD_FROZEN;
		--END;

  --      SELECT    SEGMENT4 AS STAGE
  --              , SEGMENT5 AS FROZEN_DAYS
  --              , CONVERT(CHAR(8), DATEADD(DD, ISNULL(TRY_CAST(SEGMENT5 AS INT), 0), @V_SCP_PLAN_DATE ), 112) AS FROZEN_END_YYYYMMDD
  --      INTO    #PROD_FROZEN
  --      FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
  --      WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN_NEW'
  --      AND     VALID_YN    = 'Y'
  --      AND     SEGMENT1    = @V_DIVISION_ID
  --      AND     SEGMENT2    = @V_GROUP_ID
  --      AND     SEGMENT3    = @V_SCP_PLAN_TYPE
        ------------------------------------------------------------------------
        -- 2025.06.23 김태현 : Frozen Master 정보 활용
        ------------------------------------------------------------------------
        SELECT  @V_SYS_DIVS_CD      = SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE    = PLAN_TYPE
               ,@V_SCP_PLAN_DATE    = PLAN_YYYYMMDD
               ,@V_SCP_PLAN_SEQ     = PLAN_SEQ
               ,@V_PROD_FP_FRZ_TYPE = PLAN_TYPE
        FROM    (SELECT  TOP 1 SYS_DIVS_CD
                              ,PLAN_TYPE
                              ,PLAN_YYYYMMDD
                              ,PLAN_SEQ
                 FROM    SCP_OPT_ENG_FROZEN_MASTER_SN WITH(NOLOCK)
                 WHERE   1=1
                 AND     PLAN_ID     = @V_PLAN_ID
                 AND     DIVISION_ID = @V_DIVISION_ID
                 AND     FROZEN_TYPE = 'PROD'
                ) A
        ------------------------------------------------------------------------
        -- 2025.06.23 김태현 : Frozen 출처에 따른 데이터 추출
        ------------------------------------------------------------------------
        IF @V_SYS_DIVS_CD = 'SCP'
            BEGIN
                INSERT INTO @PROD_FROZEN_TEMP
                SELECT  A.SCM_SITE_ID         AS SCM_SITE_ID
                       ,A.ITEM_ID             AS ITEM_ID
                       --,'ASSY' AS STAGE
                	   ,CASE WHEN MSE.OPERATION_GROUP = 'A'                          THEN 'ASSY'
                			 WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK'
                			 WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE'
                			--WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                		END                   AS STAGE
                	  /* PLAN_DATE 투입계획으로 변환 필요 / FP내에공정별LT관리되나 데이터 전체 0으로 따로 로직 반영 안함 */ 
                	   ,A.LINE_ID             AS LINE_ID
                       ,A.YYYYMMDD            AS PLAN_DATE
                       ,A.QTY                 AS PLAN_IN_QTY
                       ,'ANL_PRODUCTION_PLAN' AS SOURCE_CHK
                FROM    SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)    
                
                INNER JOIN ( 
                			SELECT *
                			FROM   SCM_MST_SITE  WITH (NOLOCK)
                			WHERE  DIVISION_ID = @V_DIVISION_ID 
                			AND    SITE_TYPE   = 'PLANT'
                			AND    VALID_YN    = 'Y'	
                			) MSE
                ON   A.SCM_SITE_ID = MSE.SCM_SITE_ID 
                AND ((MSE.DIVISION_ID  = '40' AND MSE.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                	OR  (MSE.DIVISION_ID <> '40' AND MSE.OPERATION_GROUP IN ('A', 'P') )
                	)
                
                INNER JOIN (SELECT DISTINCT DIVISION_ID
                							,ITEM_ID
                							,OPERATION_GROUP
                							,FLOW_ID
                							,ATTRIBUTE8
                			FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                			WHERE  DIVISION_ID = @V_DIVISION_ID--@P_DIVISION_ID  
                			AND    OPERATION_GROUP IN ('A', 'P')  
                			) FI
                ON    A.ITEM_ID     = FI.ITEM_ID
                AND   A.DIVISION_ID = FI.DIVISION_ID 
                	
                WHERE A.DIVISION_ID         = @V_DIVISION_ID
                AND   A.plan_start_yyyymmdd = @V_SCP_PLAN_DATE
                --AND   A.plan_type           = 'PR'  --임시
                AND   A.plan_type           = @V_SCP_PLAN_TYPE 
                AND   A.seq                 = @V_SCP_PLAN_SEQ  
                AND   A.measure             = 'PROD_PLAN_AMEND'
                AND   A.QTY                 >  0   
                AND   A.YYYYMMDD           >= @V_SCP_PLAN_DATE  
                AND   A.YYYYMMDD            < @V_PLAN_END_YYYYMMDD
                -- AND   A.YYYYMMDD           <  @V_PROD_FROZEN_END --DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE )
                AND     A.ITEM_ID IN   (SELECT DISTINCT ITEM_ID
                                      FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                      WHERE  PLAN_ID = @V_PLAN_ID
                                     )
                AND A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID =@V_PLAN_ID
                                AND     RESOURCE_TYPE = 'LINE'
                                )
            END
        ELSE IF @V_SYS_DIVS_CD = 'FP' AND @V_PROD_FP_FRZ_TYPE = 'Latest FP Plan'
            BEGIN
                INSERT INTO @PROD_FROZEN_TEMP
                SELECT  RP.PLANT_ID+'-'+FI.OPERATION_GROUP    AS SCM_SITE_ID
                       ,RP.ITEM_ID                            AS ITEM_ID
                	   ,CASE WHEN FI.OPERATION_GROUP = 'A'                          THEN 'ASSY'
                			 WHEN FI.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK'
                			 WHEN FI.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE'
                		END                                   AS STAGE
                	   ,RP.LINE_ID                            AS LINE_ID
                       ,CONVERT(NVARCHAR(8),RP.PLAN_DATE,112) AS PLAN_DATE
                       ,RP.PLAN_QTY                           AS PLAN_IN_QTY
                       ,'FP_PRODUCTION_PLAN_REALTIME'         AS SOURCE_CHK
                --FROM    [10.34.220.88,7433].[LGCE_FP_TR].[DBO].[IF_FP_RELEASE_PLAN_V] RP WITH(NOLOCK)
                FROM    SCM_DNM_FP_RELEASE_PLAN_V_SN RP WITH(NOLOCK)
                    INNER JOIN ( 
                                SELECT  DIVISION_ID
                                       ,PLANT_ID
                                       ,OPERATION_GROUP
                                FROM    SCM_MST_SITE WITH(NOLOCK)
                                WHERE   1=1
                                AND     VALID_YN = 'Y'
                    			AND    SITE_TYPE   = 'PLANT'
                                AND     DIVISION_ID = '40'
                                AND     OPERATION_GROUP = 'A'
                                UNION ALL
                                SELECT  DIVISION_ID
                                       ,PLANT_ID
                                       ,OPERATION_GROUP
                                FROM    SCM_MST_SITE WITH(NOLOCK)
                                WHERE   1=1
                                AND     VALID_YN = 'Y'
                    			AND    SITE_TYPE   = 'PLANT'
                                AND     DIVISION_ID != '40'
                                AND     OPERATION_GROUP IN('A','P')
                                ) SM
                        ON  RP.DIVISION_ID = SM.DIVISION_ID
                        AND RP.PLANT_ID    = SM.PLANT_ID
                    INNER JOIN (SELECT DISTINCT DIVISION_ID
                    							,ITEM_ID
                    							,OPERATION_GROUP
                    							,FLOW_ID
                    							,ATTRIBUTE8
                    			FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    			WHERE  DIVISION_ID = @V_DIVISION_ID--@P_DIVISION_ID  
                    			AND    OPERATION_GROUP IN ('A', 'P')  
                    			) FI
                        ON    RP.ITEM_ID         = FI.ITEM_ID
                        AND   RP.DIVISION_ID     = FI.DIVISION_ID 
                        AND   SM.OPERATION_GROUP = FI.OPERATION_GROUP
						-- 25.08.18 YSH 확정계획에서 ASSY Frozen 생성 시 F공정이 포함되는 것 방지
						AND   RP.OPERATION_ID	 = FI.FLOW_ID
                WHERE   RP.DIVISION_ID         = @V_DIVISION_ID
                AND     RP.PLAN_QTY            >  0   
                AND     RP.PLAN_DATE           >= @V_PLAN_START_YYYYMMDD  
                AND     RP.PLAN_DATE           <= @V_PLAN_END_YYYYMMDD
                AND     RP.ITEM_ID             IN (SELECT DISTINCT ITEM_ID
                                                   FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                   WHERE  PLAN_ID = @V_PLAN_ID
                                                  )
                AND     RP.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID =@V_PLAN_ID
                                AND     RESOURCE_TYPE = 'LINE'
                                )
            END
        ELSE IF @V_SYS_DIVS_CD = 'FP' AND @V_PROD_FP_FRZ_TYPE = 'CUT_OFF'
            BEGIN
                INSERT INTO @PROD_FROZEN_TEMP
                SELECT  RPP.SCM_SITE_ID                        AS SCM_SITE_ID
                       ,RPP.ITEM_ID                            AS ITEM_ID
                       --,'ASSY' AS STAGE
                	   ,CASE WHEN FI.OPERATION_GROUP = 'A'                          THEN 'ASSY'
                			 WHEN FI.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK'
                			 WHEN FI.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE'
                			--WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                		END                                    AS STAGE
                	  /* PLAN_DATE 투입계획으로 변환 필요 / FP내에공정별LT관리되나 데이터 전체 0으로 따로 로직 반영 안함 */ 
                	   ,RPP.LINE_ID                            AS LINE_ID
                       ,CONVERT(NVARCHAR(8),RPP.PLAN_DATE,112) AS PLAN_DATE
                       ,RPP.PLAN_QTY                           AS PLAN_IN_QTY
                       ,'FP_PRODUCTION_PLAN_CUTOFF'            AS SOURCE_CHK
                FROM    SCM_DNM_FP_RELEASE_PROD_PLAN_C RPP WITH(NOLOCK)
                    INNER JOIN ( 
                                SELECT  DIVISION_ID
                                       ,SCM_SITE_ID
                                       ,OPERATION_GROUP
                                FROM    SCM_MST_SITE WITH(NOLOCK)
                                WHERE   1=1
                                AND     VALID_YN = 'Y'
                    			AND    SITE_TYPE   = 'PLANT'
                                AND     DIVISION_ID = '40'
                                AND     OPERATION_GROUP = 'A'
                                UNION ALL
                                SELECT  DIVISION_ID
                                       ,SCM_SITE_ID
                                       ,OPERATION_GROUP
                                FROM    SCM_MST_SITE WITH(NOLOCK)
                                WHERE   1=1
                                AND     VALID_YN = 'Y'
                    			AND    SITE_TYPE   = 'PLANT'
                                AND     DIVISION_ID != '40'
                                AND     OPERATION_GROUP IN('A','P')
                                ) SM
                        ON  RPP.DIVISION_ID = SM.DIVISION_ID
                        AND RPP.SCM_SITE_ID = SM.SCM_SITE_ID
                    INNER JOIN (SELECT DISTINCT DIVISION_ID
                    							,ITEM_ID
                    							,OPERATION_GROUP
                    							,FLOW_ID
                    							,ATTRIBUTE8
                    			FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    			WHERE  DIVISION_ID = @V_DIVISION_ID--@P_DIVISION_ID  
                    			AND    OPERATION_GROUP IN ('A', 'P')  
                    			) FI
                        ON    RPP.ITEM_ID         = FI.ITEM_ID
                        AND   RPP.DIVISION_ID     = FI.DIVISION_ID 
						-- 25.08.18 YSH 확정계획에서 ASSY Frozen 생성 시 F공정이 포함되는 것 방지
						AND   RPP.OPERATION_ID	 = FI.FLOW_ID
                WHERE   RPP.DIVISION_ID         = @V_DIVISION_ID
                AND     RPP.YYYYMMDD            = @V_SCP_PLAN_DATE
                AND     RPP.PLAN_QTY            >  0   
                AND     RPP.PLAN_DATE           >= @V_PLAN_START_YYYYMMDD  
                AND     RPP.PLAN_DATE           <= @V_PLAN_END_YYYYMMDD
                AND     RPP.ITEM_ID             IN (SELECT DISTINCT ITEM_ID
                                                   FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                   WHERE  PLAN_ID = @V_PLAN_ID
                                                  )
                AND     RPP.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID =@V_PLAN_ID
                                AND     RESOURCE_TYPE = 'LINE'
                                )
            END
        -------------------------------------------------
        -- 임시 적용 : W07 Final Plan 정보 : START
        -- 2025.05.16 Philsu Park: STAGE별로 Frozen 구간 별도 적용.
        -- 2025.06.23 김태현 : FROZEN Master TABLE 적용
	    -------------------------------------------------
        INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
												PLAN_ID
											   ,FROZEN_ID
											   ,ROUTING_BOM_MAPPING_ID
											   ,OP_SEQ
											   ,RESOURCE_ID
											   ,QUANTITY
											   ,EFFECTIVE_DATE
											   ,ATTRIBUTE1
											   ,ATTRIBUTE2
											   ,ATTRIBUTE3
											   ,ATTRIBUTE13
											   ,ATTRIBUTE14
											   ,ATTRIBUTE15
											   )
        SELECT  @V_PLAN_ID                                                      AS PLAN_ID
               ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
               ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
               ,0                                                               AS OP_SEQ
               ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
               ,QTY                                                             AS QUANTITY
               ,PLAN_DATE                                                       AS EFFECTIVE_DATE
               ,SCM_SITE_ID                                                     AS SITE_ID
               ,ITEM_ID                                                         AS ITEM_ID    
               ,STAGE                                                           AS STAGE      
               ,SOURCE_CHK                                                      AS SOURCE_CHK
               ,LINE_ID                                                         AS LINE_ID    
               ,PLAN_MONTH                                                      AS PLAN_MONTH 
        FROM(
            SELECT   AA.SCM_SITE_ID          AS SCM_SITE_ID
                    ,AA.ITEM_ID              AS ITEM_ID
                    ,AA.STAGE                AS STAGE
                    ,AA.LINE_ID              AS LINE_ID
                    ,AA.PLAN_DATE            AS PLAN_DATE
                    ,LEFT(AA.PLAN_DATE,6)    AS PLAN_MONTH
                    ,SUM(AA.PLAN_IN_QTY)     AS QTY
                    ,AA.SOURCE_CHK           AS SOURCE_CHK
            FROM(
                SELECT   SCM_SITE_ID          AS SCM_SITE_ID
                        ,ITEM_ID              AS ITEM_ID
                        ,STAGE                AS STAGE
                        ,LINE_ID              AS LINE_ID
                        ,PLAN_DATE            AS PLAN_DATE
                        ,PLAN_IN_QTY          AS PLAN_IN_QTY
                        ,SOURCE_CHK           AS SOURCE_CHK
                FROM    @PROD_FROZEN_TEMP
			    ------------------------------------------------------------------------------------------------------
            ) AA
            INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                ON  1=1
                AND FM.PLAN_ID = @V_PLAN_ID
                AND AA.STAGE = FM.STAGE
                AND ((AA.SOURCE_CHK = 'LOOKUP_PROD_FIX' AND AA.PLAN_DATE >= FM.FROZEN_END_DATE)
                    OR (AA.SOURCE_CHK != 'LOOKUP_PROD_FIX' AND AA.PLAN_DATE < FM.FROZEN_END_DATE AND AA.PLAN_DATE >= FM.FROZEN_START_DATE)
                    )
            GROUP BY AA.SCM_SITE_ID, AA.ITEM_ID, AA.STAGE, AA.LINE_ID, AA.PLAN_DATE, AA.SOURCE_CHK
        ) A
            LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN B WITH(NOLOCK)
                ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                AND A.ITEM_ID     = B.ATTRIBUTE2
                AND A.STAGE       = B.ATTRIBUTE3
                AND A.LINE_ID     = B.ATTRIBUTE15
                AND A.PLAN_DATE   >= B.START_DATE
                AND A.PLAN_DATE   <  B.END_DATE
                AND B.PLAN_ID     = @V_PLAN_ID
        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK

    -------------------------------------------------
    -- 임시 적용 : W07 Final Plan 정보 : END
	-------------------------------------------------
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------
      -- ERROR LOG
	------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_PROGRAM_NAME, 16,1)
        ------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
    BEGIN
	    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END
    ------------------------------------------------------------------------
  END;

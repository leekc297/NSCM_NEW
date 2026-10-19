CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_ROUTING_RESOURCE_BATCH]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    --,@V_SCP_PLAN_DATE       NVARCHAR(8)
    --,@V_SCP_PLAN_TYPE       NVARCHAR(8)
    --,@V_SCP_PLAN_SEQ        NVARCHAR(8)
AS 
BEGIN
    --2025.02.12 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_ROUTING_RESOURCE_BATCH';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;
    DECLARE @V_PLAN_START_YYYYMM   NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM     NVARCHAR(6);
	
    --TOOL 제약 반영을 위한 임시테이블
    DECLARE @RR_TEMP TABLE(
     PLAN_ID             NVARCHAR(50)
    ,ROUTING_ID          NVARCHAR(200)
    ,OP_SEQ              NUMERIC(20,0)
    ,RESOURCE_CLASS_ID   NVARCHAR(200)
    ,RESOURCE_ID         NVARCHAR(100)
    ,LOAD_PER            NUMERIC(20,10)
    ,PRIORITY            NUMERIC(20,0)
    ,START_DATE          NVARCHAR(20)
    ,END_DATE            NVARCHAR(20)
    ,SETUP_GROUP_ID      NVARCHAR(200)
    ,SETUP_ID            NVARCHAR(200)
    ,GROUP_SETUP_TIME    NVARCHAR(100)
    ,SETUP_TIME          NVARCHAR(100)
    ,CONTAINER_CATEGORY  NVARCHAR(100)
    ,CONTAINER_SIZE      NUMERIC(20,0)
    ,ATTRIBUTE1          NVARCHAR(150)
    ,ATTRIBUTE2          NVARCHAR(150)
    ,ATTRIBUTE3          NVARCHAR(150)
    ,ATTRIBUTE14         NVARCHAR(150)
    ,ATTRIBUTE15         NVARCHAR(150)
    ,STEP                INT
    )
    --SOP EOP 반영을 위한 임시테이블
    DECLARE @SE_TEMP TABLE(
     ITEM_ID  NVARCHAR(100)
    ,LINE_ID  NVARCHAR(100)
    ,SOP_DATE NVARCHAR(8)
    ,EOP_DATE NVARCHAR(8)
    ,SOP_MM   NVARCHAR(6)
    ,EOP_MM   NVARCHAR(6)
    )

    -- 2025.10.27 Minyong Lee : Lookup -> UI Table 전환 (Ramp-up)
    -- Ramp-up 반영을 위한 임시테이블
    DECLARE @RU_TEMP TABLE(
        DIVISION_ID     NVARCHAR(60)
      , PLANT_ID        NVARCHAR(60)
      , LINE_ID         NVARCHAR(60)
      , OPERATION_ID    NVARCHAR(60)
      , ITEM_ID         NVARCHAR(100)
      , START_DATE      NVARCHAR(16)
      , END_DATE        NVARCHAR(16)
      , EFCY            NUMERIC(5,2)
      , VALID_YN        CHAR(1)
    )

    -- 2026.03.05 Minyong Lee : 형변환 Set-up 구간 적용 데이터 (전극 기준으로 조립에 동일 적용)
    DECLARE @SETUP_TEMP TABLE (
        DIVISION_ID         NVARCHAR(200) NOT NULL,
        SCM_SITE_ID         NVARCHAR(200) NOT NULL,
        LINE_ID             NVARCHAR(200) NULL,
        ITEM_ID             NVARCHAR(100) NULL,
        SETUP_GROUP_ID      NVARCHAR(100) NULL,
        SETUP_ID            NVARCHAR(100) NULL,
        GROUP_SETUP_TIME    INT NULL,
        SETUP_TIME          INT NULL,
        SUB_NO              NVARCHAR(100) NULL,
        BASIS_YYYYMMDD      NVARCHAR(16) NULL
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
        -- SET Param
        ------------------------------------------------------------------------
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;
        
        SELECT @V_PLAN_START_YYYYMM   = CONVERT(NVARCHAR(6),PLAN_START_DATE,112)
              ,@V_PLAN_END_YYYYMM     = CONVERT(NVARCHAR(6),PLAN_END_DATE,112)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @P_PLAN_ID

        --INSERT INTO @SE_TEMP
        --SELECT  ITEM_ID
        --       ,MIN(SOP_DATE) AS SOP_DATE
        --       ,MAX(EOP_DATE) AS EOP_DATE
        --       ,MIN(SOP_MM) AS SOP_MM
        --       ,MAX(EOP_MM) AS EOP_MM
        --FROM(
        --    SELECT  SEGMENT3                              AS ITEM_ID
        --           ,IIF(SEGMENT4 = 'SOP',ATTRIBUTE1,NULL) AS SOP_DATE
        --           ,IIF(SEGMENT4 = 'EOP',ATTRIBUTE1,NULL) AS EOP_DATE
        --           ,IIF(SEGMENT4 = 'SOP',LEFT(ATTRIBUTE1,6),NULL) AS SOP_MM
        --           ,IIF(SEGMENT4 = 'EOP',LEFT(ATTRIBUTE1,6),NULL) AS EOP_MM
        --    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --    WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_SOP_EOP_NEW'
        --    AND     LU.SEGMENT2    = @V_DIVISION_ID
        --    AND     LU.VALID_YN    = 'Y'

        --    ) SE
        --GROUP BY ITEM_ID	


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

        --신규 LOOKUP 적용
        INSERT INTO @SE_TEMP
        SELECT  ITEM_ID
               ,LINE_ID
               ,MIN(SOP_DATE) AS SOP_DATE
               ,MAX(EOP_DATE) AS EOP_DATE
               ,MIN(SOP_MM) AS SOP_MM
               ,MAX(EOP_MM) AS EOP_MM
        FROM(
            --SELECT  SEGMENT4                              AS ITEM_ID
            --       ,SEGMENT3                              AS LINE_ID
            --       ,IIF(SEGMENT5 = 'SOP',ATTRIBUTE2,NULL) AS SOP_DATE
            --       ,IIF(SEGMENT5 = 'EOP',ATTRIBUTE2,NULL) AS EOP_DATE
            --       ,IIF(SEGMENT5 = 'SOP',LEFT(ATTRIBUTE2,6),NULL) AS SOP_MM
            --       ,IIF(SEGMENT5 = 'EOP',LEFT(ATTRIBUTE2,6),NULL) AS EOP_MM
            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            --WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_SOP_EOP'
            --AND     LU.SEGMENT2    = @V_DIVISION_ID
            --AND     LU.VALID_YN    = 'Y'

            -- 2025.10.27 Minyong Lee : Lookup -> UI Table 전환
            SELECT  S.ITEM_ID      AS ITEM_ID
                  , S.LINE_ID      AS LINE_ID
                  , IIF(S.TYPE = 'SOP',S.DATE,NULL) AS SOP_DATE
                  , IIF(S.TYPE = 'EOP',S.DATE,NULL) AS EOP_DATE
                  , IIF(S.TYPE = 'SOP',LEFT(S.DATE,6),NULL) AS SOP_MM
                  , IIF(S.TYPE = 'EOP',LEFT(S.DATE,6),NULL) AS EOP_MM
            FROM    SCP_OPMZ_SOP_EOP S WITH(NOLOCK)
            WHERE   1=1
            AND     S.VALID_YN = 'Y'
            AND     S.DIVISION_ID = @V_DIVISION_ID

            ) SE
        GROUP BY ITEM_ID,LINE_ID
        
        -- 2025.10.27 Minyong Lee : Lookup -> UI Table 전환 (Ramp-up)
        -- Ramp-up (From/To) 
        INSERT INTO @RU_TEMP
        SELECT  R1.DIVISION_ID
              , R1.PLANT_ID
              , R1.LINE_ID
              , R1.OPERATION_ID
              , R1.ITEM_ID
              , R1.START_DATE
              , R1.END_DATE
              , R1.EFCY
              , R1.VALID_YN
        FROM    SCP_OPMZ_RAMP_UP R1 WITH(NOLOCK)
        WHERE   1=1
        AND     R1.VALID_YN = 'Y'
        AND     R1.DIVISION_ID = @V_DIVISION_ID

        -- Ramp-up (Interval)
        INSERT INTO @RU_TEMP
        SELECT  R2.DIVISION_ID
                , R2.PLANT_ID
                , R2.LINE_ID
                , R2.OPERATION_ID
                , R2.ITEM_ID
                , V.START_DATE
                , V.END_DATE
                , V.EFCY
                , R2.VALID_YN
        FROM    (
                SELECT  I.DIVISION_ID
                        , I.PLANT_ID
                        , I.LINE_ID
                        , I.OPERATION_ID
                        , I.ITEM_ID
                        , I.START_DATE                                                                                                          AS START_DATE1
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, I.ITVL1 - 1, CONVERT(DATETIME, I.START_DATE)), 112)                                 AS END_DATE1
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, I.ITVL1, CONVERT(DATETIME, I.START_DATE)), 112)                                     AS START_DATE2
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, I.ITVL1 + I.ITVL2 - 1, CONVERT(DATETIME, I.START_DATE)), 112)                       AS END_DATE2
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, I.ITVL1 + I.ITVL2, CONVERT(DATETIME, I.START_DATE)), 112)                           AS START_DATE3
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, I.ITVL1 + I.ITVL2 + I.ITVL3 - 1, CONVERT(DATETIME, I.START_DATE)), 112)             AS END_DATE3
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, I.ITVL1 + I.ITVL2 + I.ITVL3, CONVERT(DATETIME, I.START_DATE)), 112)                 AS START_DATE4
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, I.ITVL1 + I.ITVL2 + I.ITVL3 + I.ITVL4 - 1, CONVERT(DATETIME, I.START_DATE)), 112)   AS END_DATE4
                        , I.EFCY1
                        , I.EFCY2
                        , I.EFCY3
                        , I.EFCY4
                        , I.VALID_YN
                FROM    SCP_OPMZ_RAMP_UP_ITVL I
                ) R2
        CROSS APPLY (
            VALUES (R2.START_DATE1, R2.END_DATE1, R2.EFCY1),
                    (R2.START_DATE2, R2.END_DATE2, R2.EFCY2),
                    (R2.START_DATE3, R2.END_DATE3, R2.EFCY3),
                    (R2.START_DATE4, R2.END_DATE4, R2.EFCY4)
        ) AS V(START_DATE, END_DATE, EFCY)
        WHERE   1=1
        AND     R2.VALID_YN = 'Y'
        AND     R2.DIVISION_ID = @V_DIVISION_ID
        AND     V.START_DATE IS NOT NULL
        AND     V.END_DATE IS NOT NULL
        AND     V.EFCY IS NOT NULL
    
        -- 2026.03.05 Minyong Lee : 형변환 Set-up 구간 적용 데이터 (전극 기준으로 조립에 동일 적용)
     /*   INSERT INTO @SETUP_TEMP
        SELECT  SUI.DIVISION_ID
              , SUI.SCM_SITE_ID
              , SUI.LINE_ID
              , SUI.ITEM_ID
              , SUI.SETUP_GROUP_ID
              , SUI.SETUP_ID
              , SUI.GROUP_SETUP_TIME
              , SUI.SETUP_TIME
              , SUI.SUB_NO
              , CAL.BASIS_YYYYMMDD
        FROM    (
                SELECT  LU.SEGMENT2      AS DIVISION_ID
                      , LU.SEGMENT3      AS SCM_SITE_ID
                      , LU.SEGMENT4      AS LINE_ID
                      , ITS.ITEM_ID      AS ITEM_ID
                      , LU.ATTRIBUTE1    AS SETUP_GROUP_ID
                      , IIF(LU.ATTRIBUTE2='',NULL,LU.ATTRIBUTE2) AS SETUP_ID
                      , CONVERT(INT,CONVERT(NUMERIC(20,5),LU.ATTRIBUTE3)*86400)  AS GROUP_SETUP_TIME
                      , CONVERT(INT,CONVERT(NUMERIC(20,5),LU.ATTRIBUTE4)*86400)  AS SETUP_TIME
                      , LU.SEGMENT6      AS SUB_NO
                      , LU.ATTRIBUTE5    AS START_DATE
                      , LU.ATTRIBUTE6    AS END_DATE
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                    LEFT JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
                         ON     ITS.SITE_ID = LU.SEGMENT3
                        AND     ITS.STAGE      IN ('ASSY', 'MDLE', 'PACK')
                        AND     ITS.SETUP_GROUP_ID = LU.SEGMENT5
                WHERE   LU.SEGMENT2    = @V_DIVISION_ID
                AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP'
                AND     LU.SEGMENT6    <> '-'
                AND     ITS.PLAN_ID    = @V_PLAN_ID
                AND     LU.VALID_YN    = 'Y'
                ) SUI
            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON  CAL.BASIS_YYYYMMDD >= SUI.START_DATE 
                AND CAL.BASIS_YYYYMMDD <=  SUI.END_DATE*/

        ------------------------------------------------------------------------
        --BASIC DATA INSERT 
        ------------------------------------------------------------------------		
		IF OBJECT_ID('TEMPDB..#TACT_TIME') IS NOT NULL
		BEGIN 
			DROP TABLE  #TACT_TIME;
		END;

		SELECT DIVISION_ID, PLANT_ID, ITEM_ID, LINE_ID, MONTH, TACT_TIME, OPERATION_ID, STAGE, SCM_SITE_ID
		INTO #TACT_TIME
		FROM (  -- 소형 외 : FP 정보
				SELECT A.DIVISION_ID AS DIVISION_ID
					  ,A.PLANT_ID    AS PLANT_ID
					  ,A.ITEM_ID     AS ITEM_ID
					  ,A.LINE_ID     AS LINE_ID
					  ,A.MONTH       AS MONTH
					  ,A.TACT_TIME   AS TACT_TIME
					  ,A.OPERATION_ID   AS OPERATION_ID
					  ,CASE WHEN A.OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN 'ASSY'
					        WHEN A.OPERATION_ID IN ('P5500') THEN 'MDLE'
					        WHEN A.OPERATION_ID IN ('P9500') THEN 'PACK'
					   END AS STAGE
					  ,A.SCM_SITE_ID AS SCM_SITE_ID
				FROM   (
      --                  SELECT SEGMENT2   AS DIVISION_ID
				  --           , SEGMENT3   AS PLANT_ID
				  --           , SEGMENT4   AS SCM_SITE_ID
				  --           , SEGMENT5   AS OPERATION_ID
				  --           , ATTRIBUTE1 AS LINE_ID
				  --           , ATTRIBUTE2 AS ITEM_ID
				  --           , ATTRIBUTE3 AS MONTH
				  --           , CONVERT(FLOAT, ATTRIBUTE4)  AS TACT_TIME
						--FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
						--WHERE  LOOKUP_TYPE = 'SCP_OPT_MASTER_CAPA_TEMP'
						--AND    VALID_YN    = 'Y'

                        -- 2025.10.21 Minyong Lee : Lookup -> UI Table 전환
                        SELECT	CP.DIVISION_ID		AS DIVISION_ID
	                          , CP.PLANT_ID			AS PLANT_ID
	                          , ST.SCM_SITE_ID		AS SCM_SITE_ID
	                          , CP.OPERATION_ID		AS OPERATION_ID
	                          , CP.LINE_ID			AS LINE_ID
	                          , CP.ITEM_ID			AS ITEM_ID
	                          , CP.YYYYMM			AS MONTH
	                          , 86400 / (CP.CAPA * (ISNULL(CP.PRDN_OPER_RT, 100) / 100)) AS TACT_TIME
                        FROM	SCP_OPMZ_DDLY_CAPA CP WITH(NOLOCK)
	                        LEFT JOIN (
				                        SELECT	OPERATION_ID
					                          , OPERATION_GROUP
				                        FROM	SCM_MST_OPERATION_FLOW_V
				                        WHERE	1=1
				                        AND		VALID_YN = 'Y'
				                        GROUP BY
						                        OPERATION_ID
					                          , OPERATION_GROUP
				                        ) OP
		                        ON	CP.OPERATION_ID = OP.OPERATION_ID
	                        LEFT JOIN (
				                        SELECT	PLANT_ID
					                          , SCM_SITE_ID
					                          , OPERATION_GROUP
				                        FROM	SCM_MST_SITE
				                        WHERE	1=1
				                        AND		VALID_YN = 'Y'
				                        AND		PLANT_ID IS NOT NULL
				                        AND		SCM_SITE_ID IS NOT NULL 
				                        GROUP BY
						                        PLANT_ID
					                          , SCM_SITE_ID
					                          , OPERATION_GROUP
				                        ) ST
		                        ON	CP.PLANT_ID = ST.PLANT_ID
		                        AND	OP.OPERATION_GROUP = ST.OPERATION_GROUP
                        WHERE	CP.VALID_YN = 'Y'
                        AND		CP.DIVISION_ID = @V_DIVISION_ID
                        AND		CP.CAPA > 0
                        AND		(CP.PRDN_OPER_RT > 0 OR CP.PRDN_OPER_RT IS NULL)
				       ) A
				WHERE  1=1
				AND    A.DIVISION_ID <> '40' -- 소형 제외 
				AND    A.DIVISION_ID  = @V_DIVISION_ID
				AND    A.OPERATION_ID IN ('A3000', 'A8210', 'A9000', 'P5500', 'P9500')
				AND    A.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
				AND (A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
								  FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
								  WHERE   PLAN_ID =@V_PLAN_ID
								  AND     RESOURCE_TYPE = 'LINE')
					 OR A.LINE_ID IS NULL)
				AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
				  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
					  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
					  WHERE  PLAN_ID = @V_PLAN_ID
					 )

				-- 소형 : SCP CAPA(Mobility) 정보
                -- 2025.08.18 Philsu Park: 소형 PG별 Line Item Setup 정보 제약추가
				UNION
				SELECT A.DIVISION_ID AS DIVISION_ID
					  ,A.PLANT_ID    AS PLANT_ID
					  ,A.ITEM_ID     AS ITEM_ID
					  ,A.LINE_ID     AS LINE_ID
					  ,A.YYYYMM      AS MONTH
					  ,ROUND((60 * 60 * 24)/a.value, 6, 1)   AS TACT_TIME
					  ,A.OPERATION_ID   AS OPERATION_ID
					  ,CASE WHEN A.OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN 'ASSY'
					        WHEN A.OPERATION_ID IN ('P5500') THEN 'MDLE'
					        WHEN A.OPERATION_ID IN ('P9500') THEN 'PACK'
					   END AS STAGE
					  ,CASE WHEN A.OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN PLANT_ID +'-A'
					        WHEN A.OPERATION_ID IN ('P5500') THEN PLANT_ID +'-P'
					        WHEN A.OPERATION_ID IN ('P9500') THEN PLANT_ID +'-P'
					   END AS SCM_SITE_ID
				FROM   SCP_MST_CAPA A WITH (NOLOCK)
				WHERE  1=1
				AND    A.DIVISION_ID  = '40' -- 소형 전용 
				AND    A.DIVISION_ID  = @V_DIVISION_ID 
				AND    A.OPERATION_ID IN ('A3000', 'A8210', 'A9000', 'P5500', 'P9500')    
				AND    A.YYYYMM        BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM 
				AND    A.VALUE         > 0   
				AND (A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
								  FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
								  WHERE   PLAN_ID = @V_PLAN_ID
								  AND     RESOURCE_TYPE = 'LINE')
					 OR A.LINE_ID IS NULL)
				AND CONCAT(CONCAT(A.PLANT_ID,'-'+SUBSTRING(A.OPERATION_ID, 1, 1)), A.ITEM_ID) 
				  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
					  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
					  WHERE  PLAN_ID = @V_PLAN_ID
					 )
                /* 배치는 계획그룹 등록라인 제한 없이 사업부 전체 라인 대상 */
			) B;

        INSERT INTO @RR_TEMP(PLAN_ID             
                            ,ROUTING_ID          
                            ,OP_SEQ              
                            ,RESOURCE_CLASS_ID   
                            ,RESOURCE_ID         
                            ,LOAD_PER            
                            ,PRIORITY            
                            ,START_DATE          
                            ,END_DATE            
                            ,SETUP_GROUP_ID      
                            ,SETUP_ID            
                            ,GROUP_SETUP_TIME    
                            ,SETUP_TIME          
                            ,CONTAINER_CATEGORY  
                            ,CONTAINER_SIZE      
                            ,ATTRIBUTE1          
                            ,ATTRIBUTE2          
                            ,ATTRIBUTE3          
                            ,ATTRIBUTE14         
                            ,ATTRIBUTE15    
                            ,STEP
                            )
        SELECT DISTINCT @V_PLAN_ID                                              AS PLAN_ID
                       ,SITE+'::'+ITEM+'::'+STAGE+'::'+ISNULL(RESOURCE_NAME,'-')+'::'+ISNULL(MONTH,'-') AS ROUTING_ID
                       ,0                                                       AS OP_SEQ
                       ,RESOURCE_CLASS_ID                                       AS RESOURCE_CLASS_ID
                       ,SITE+'::'+ISNULL(RESOURCE_NAME,'-')                     AS RESOURCE_ID
                       ,LOAD_PER                                                AS LOAD_PER
                       ,PRIORITY                                                AS PRIORITY
                       ,START_DATE                                              AS START_DATE
                       ,END_DATE                                                AS END_DATE
                       ,NULL                                                    AS SETUP_GROUP_ID
                       ,NULL                                                    AS SETUP_ID
                       ,NULL                                                    AS GROUP_SETUP_TIME
                       ,NULL                                                    AS SETUP_TIME
                       ,NULL                                                    AS CONTAINER_CATEGORY
                       ,NULL                                                    AS CONTAINER_SIZE
                       ,SITE                                                    AS ATTRIBUTE1
                       ,ITEM                                                    AS ATTRIBUTE2
                       ,STAGE                                                   AS ATTRIBUTE3
                       ,MONTH                                                   AS ATTRIBUTE14
                       ,LINE_ID                                                 AS ATTRIBUTE15
                       ,1                                                       AS STEP
        FROM(
            /**********************
            1) P_PLANT 
            ***********************/
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID       AS ITEM
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'PACK' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'CHAR' -- STAGE 확인 ???
				   END AS STAGE
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'P_PLANT' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'A_PLANT' -- STAGE 확인 ???
				   END AS RESOURCE_CLASS_ID
                  --,'PACK'        AS STAGE
                  --,'P_PLANT'     AS RESOURCE_CLASS_ID
                  ,NULL      AS RESOURCE_NAME
                  ,NULL      AS MONTH
                  ,NULL      AS START_DATE
                  ,NULL      AS END_DATE
                  ,1         AS LOAD_PER
                  ,1         AS PRIORITY
                  ,NULL      AS LINE_ID
            FROM   [SCP_MST_OUTSOURCING_CAPA] A WITH(NOLOCK)

			INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
			ON  A.DIVISION_ID   = B.DIVISION_ID
			AND A.PLANT_SITE_ID = B.SCM_SITE_ID
			AND B.VALID_YN      = 'Y'
			AND B.OPERATION_GROUP IN ('A', 'P')

            WHERE 1=1
            AND   A.DIVISION_ID = @V_DIVISION_ID
            AND   @V_DIVISION_ID <> '40' -- 소형 Cell Demand : 소형은 Pack 제외
            AND   A.VALID_YN = 'Y'
            /************************* 
            소형 파일럿대상 18650 필터링 
            *************************/
            AND CONCAT(A.PLANT_SITE_ID, '_', A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID, '_',ITEM_ID )
                                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                        WHERE  PLAN_ID = @V_PLAN_ID
                                                       )
            GROUP BY A.PLANT_SITE_ID, A.ITEM_ID, B.OPERATION_GROUP
            /**********************
            2) P_MODEL
            ***********************/
            UNION ALL
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID   AS ITEM
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'PACK' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'CHAR' -- STAGE 확인 ???
				   END AS STAGE
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'P_MODEL' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'A_MODEL' -- STAGE 확인 ???
				   END AS RESOURCE_CLASS_ID
                  --,'PACK'    AS STAGE
                  --,'P_MODEL' AS RESOURCE_CLASS_ID
                  ,A.ITEM_ID AS RESOURCE_NAME
                  ,NULL      AS MONTH
                  ,NULL      AS START_DATE
                  ,NULL      AS END_DATE
                  ,1         AS LOAD_PER
                  ,1         AS PRIORITY
                  ,NULL      AS LINE_ID
            FROM  [SCP_MST_OUTSOURCING_CAPA] A WITH(NOLOCK)

			INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
			ON  A.DIVISION_ID   = B.DIVISION_ID
			AND A.PLANT_SITE_ID = B.SCM_SITE_ID
			AND B.VALID_YN      = 'Y'
			AND B.OPERATION_GROUP IN ('A', 'P')

            WHERE 1=1
            AND   A.DIVISION_ID = @V_DIVISION_ID
            AND   @V_DIVISION_ID <> '40' -- 소형 Cell Demand : 소형은 Pack 제외
            AND   A.VALID_YN = 'Y'
            /************************* 
            소형 파일럿대상 18650 필터링 
            *************************/
            AND CONCAT(A.PLANT_SITE_ID, '_', A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID, '_',ITEM_ID )
                                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                        WHERE  PLAN_ID = @V_PLAN_ID
                                                       )
            GROUP BY A.PLANT_SITE_ID, A.ITEM_ID, B.OPERATION_GROUP
            /**********************
            3) LINE
            ***********************/
            UNION ALL
            SELECT A.SCM_SITE_ID  AS SITE
                  ,A.ITEM_ID      AS ITEM
                  ,A.STAGE        AS STAGE
                  --,'A_LINE' AS RESOURCE_CLASS_ID
				  ,'LINE'       AS RESOURCE_CLASS_ID
                  ,A.LINE_ID    AS RESOURCE_NAME
                  ,A.MONTH      AS MONTH
                  ,CASE WHEN @V_PLAN_START_YYYYMMDD >= A.MONTH+'01' AND @V_PLAN_START_YYYYMMDD >= ISNULL(C.SOP_DATE,'11111111') THEN @V_PLAN_START_YYYYMMDD
                        WHEN A.MONTH+'01'   >= @V_PLAN_START_YYYYMMDD AND A.MONTH+'01' >= ISNULL(C.SOP_DATE,'11111111') THEN A.MONTH+'01'
                        ELSE ISNULL(C.SOP_DATE,'11111111')
                   END AS START_DATE
       --           ,CASE WHEN @V_PLAN_END_YYYYMMDD <= CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) AND @V_PLAN_END_YYYYMMDD <= ISNULL(C.EOP_DATE,'99999999') THEN @V_PLAN_END_YYYYMMDD
       --                 WHEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112)   <= @V_PLAN_END_YYYYMMDD 
						 --AND CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) <= ISNULL(C.EOP_DATE,'99999999') 
						 --   THEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112)
       --                 ELSE ISNULL(C.EOP_DATE,'99999999')
       --            END AS END_DATE -- 뒤에서 +1 일 처리 부분 제거
                  ,CASE WHEN @V_PLAN_END_YYYYMMDD <= CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) AND @V_PLAN_END_YYYYMMDD <= ISNULL(C.EOP_DATE,'29991231') THEN @V_PLAN_END_YYYYMMDD
                        WHEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) <= @V_PLAN_END_YYYYMMDD 
						 AND CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) <= ISNULL(C.EOP_DATE,'29991231') 
                        	THEN CONVERT(NVARCHAR(8),DATEADD(MONTH,1,A.MONTH+'01'),112)
                        ELSE CONVERT(NVARCHAR(8),DATEADD(DAY,1, CONVERT(DATETIME, ISNULL(C.EOP_DATE,'29991231')) ),112)
                   END AS END_DATE
                  ,A.TACT_TIME  AS LOAD_PER
                  ,B.PRIORITY   AS PRIORITY
                  ,A.LINE_ID    AS LINE_ID
            FROM #TACT_TIME A WITH(NOLOCK)
                LEFT JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B
                ON  A.PLANT_ID     = B.PLANT_ID
                AND A.LINE_ID      = B.LINE_ID
                AND A.OPERATION_ID = B.OPERATION_ID
                AND A.MONTH        = B.MONTH
                AND A.ITEM_ID      = B.ITEM_ID
				AND B.DIVISION_ID  = @V_DIVISION_ID
                LEFT OUTER JOIN @SE_TEMP C
                ON  A.ITEM_ID = C.ITEM_ID
                AND A.LINE_ID = C.LINE_ID -- 신규
            WHERE 1=1
            AND A.DIVISION_ID = @V_DIVISION_ID
            AND B.PRIORITY <> 'NULL'
            AND (    (C.SOP_MM IS NULL OR (A.ITEM_ID = C.ITEM_ID AND A.MONTH >= C.SOP_MM))
                 AND (C.EOP_MM IS NULL OR (A.ITEM_ID = C.ITEM_ID AND A.MONTH <= C.EOP_MM))
                 OR C.ITEM_ID IS NULL
                )
            GROUP BY A.PLANT_ID, A.ITEM_ID, A.LINE_ID, A.MONTH, A.TACT_TIME, B.PRIORITY,C.SOP_DATE,C.EOP_DATE, A.STAGE, A.SCM_SITE_ID
            ) A
        ------------------------------------------------------------------------
        -- DATA INSERT
        ------------------------------------------------------------------------   
       /* INSERT INTO @RR_TEMP(PLAN_ID
                            ,ROUTING_ID
                            ,OP_SEQ
                            ,RESOURCE_CLASS_ID
                            ,RESOURCE_ID
                            ,LOAD_PER
                            ,PRIORITY
                            ,START_DATE
                            ,END_DATE
                            ,SETUP_GROUP_ID
                            ,SETUP_ID
                            ,GROUP_SETUP_TIME
                            ,SETUP_TIME
                            ,CONTAINER_CATEGORY
                            ,CONTAINER_SIZE
                            ,ATTRIBUTE1
                            ,ATTRIBUTE2
                            ,ATTRIBUTE3
                            ,ATTRIBUTE14
                            ,ATTRIBUTE15
                            ,STEP
                            )
       /* SELECT  RT.PLAN_ID           
               ,RT.ROUTING_ID        
               ,RT.OP_SEQ            
               ,RT.RESOURCE_CLASS_ID 
               ,RT.RESOURCE_ID       
               ,RT.LOAD_PER          
               ,RT.PRIORITY          
               ,RT.START_DATE        
               ,RT.END_DATE          
               ,LU.SETUP_GROUP_ID    
               ,LU.SETUP_ID          
               ,LU.GROUP_SETUP_TIME  
               ,LU.SETUP_TIME        
               ,RT.CONTAINER_CATEGORY
               ,RT.CONTAINER_SIZE    
               ,RT.ATTRIBUTE1        
               ,RT.ATTRIBUTE2        
               ,RT.ATTRIBUTE3        
               ,RT.ATTRIBUTE14       
               ,RT.ATTRIBUTE15    
               ,2
        FROM @RR_TEMP RT
            ------------------------------------------------------------------------
            -- APPLY TO PRODUCT CHANGE CONSTRAINT
            ------------------------------------------------------------------------   
            LEFT OUTER JOIN (
                SELECT  LU.SEGMENT2    AS DIVISION_ID
                       ,LU.SEGMENT3    AS SCM_SITE_ID
                       ,LU.SEGMENT4    AS LINE_ID
                       ,ITS.ITEM_ID    AS ITEM_ID
                       ,LU.ATTRIBUTE1  AS SETUP_GROUP_ID
                       ,IIF(LU.ATTRIBUTE2='',NULL,LU.ATTRIBUTE2) AS SETUP_ID
                       ,CONVERT(INT,CONVERT(NUMERIC(20, 5),IIF(LU.ATTRIBUTE3 = '', '0', LU.ATTRIBUTE3))*86400)  AS GROUP_SETUP_TIME
                       ,CONVERT(INT,CONVERT(NUMERIC(20, 5),IIF(LU.ATTRIBUTE4 = '', '0', LU.ATTRIBUTE4))*86400)  AS SETUP_TIME
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
                ON      ITS.SITE_ID = LU.SEGMENT3
                AND     ITS.STAGE      IN ('ASSY', 'MDLE', 'PACK')
                AND     ITS.SETUP_GROUP_ID = LU.SEGMENT5
                WHERE   LU.SEGMENT2    = @V_DIVISION_ID
                AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP'
                AND     LU.SEGMENT6    = '-'
                AND     ITS.PLAN_ID    = @V_PLAN_ID
                AND     LU.VALID_YN    = 'Y'
            )LU 
            ON  RT.ATTRIBUTE1 = LU.SCM_SITE_ID
            AND RT.ATTRIBUTE2 = LU.ITEM_ID
            AND RT.ATTRIBUTE3 IN ('ASSY', 'MDLE', 'PACK')
            AND ATTRIBUTE15   = LU.LINE_ID
        UNION ALL*/
        ------------------------------------------------------------------------
        -- APPLY TO TOOL CONSTRAINT AND DATA INSERT
        ------------------------------------------------------------------------      
        SELECT  @V_PLAN_ID                        AS PLAN_ID
               --,RP.ATTRIBUTE1+'::'+RP.ATTRIBUTE2+'::'+RP.ATTRIBUTE3+'::'+LU.SEGMENT5+'@'+RP.ATTRIBUTE15+'::'+RP.ATTRIBUTE14 AS ROUTING_ID
               ,RP.ATTRIBUTE1+'::'+RP.ATTRIBUTE2+'::'+RP.ATTRIBUTE3+'::'+RP.ATTRIBUTE15+'::'+RP.ATTRIBUTE14 AS ROUTING_ID
               ,'0'                               AS OP_SEQ
               ,'Dummy_LINE'                      AS RESOURCE_CLASS_ID
               ,RP.ATTRIBUTE1+'::'+LU.SEGMENT5    AS RESOURCE_ID 
               ,RP.LOAD_PER                       AS LOAD_PER
               ,RP.PRIORITY                       AS PRIORITY
               ,IIF(RP.START_DATE<PF.FROZEN_END_DATE,PF.FROZEN_END_DATE,RP.START_DATE) AS START_DATE
               --,RP.START_DATE                     AS START_DATE
               ,RP.END_DATE                       AS END_DATE
               ,CASE WHEN LU.ATTRIBUTE1 = 'A' THEN CONCAT(LU.SEGMENT3, '::', LU.SEGMENT4)  --2025.05.09 Philsu Park: SetupGroupId 생성 Rule에 맞게 Site::Resource로 변경.
            --    ,CASE WHEN LU.ATTRIBUTE1 = 'A' THEN LU.SEGMENT4
                     WHEN LU.ATTRIBUTE1 = 'B' THEN NULL
                END                               AS SETUP_GROUP_ID
               ,NULL                              AS SETUP_ID
               ,NULL                              AS GROUP_SETUP_TIME
               ,NULL                              AS SETUP_TIME
               ,NULL                              AS CONTAINER_CATEGORY
               ,NULL                              AS CONTAINER_SIZE
               ,RP.ATTRIBUTE1                     AS ATTRIBUTE1
               ,RP.ATTRIBUTE2                     AS ATTRIBUTE2
               ,RP.ATTRIBUTE3                     AS ATTRIBUTE3
               ,RP.ATTRIBUTE14                    AS ATTRIBUTE14
               ,RP.ATTRIBUTE15                    AS ATTRIBUTE15
               ,2                                 AS STEP
        FROM    @RR_TEMP RP 
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            ON  RP.ATTRIBUTE1  = LU.SEGMENT3
            AND RP.ATTRIBUTE15 = LU.SEGMENT4
            AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
            AND LU.SEGMENT2    = @V_DIVISION_ID
            AND LU.VALID_YN    = 'Y'
            INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN PF
                ON  1=1
                AND PF.FROZEN_TYPE = 'PROD'
                AND RP.ATTRIBUTE3 = PF.STAGE
                AND RP.END_DATE   > PF.FROZEN_END_DATE*/

        INSERT INTO SCP_OPT_ENG_ROUTING_RESOURCE_SN(PLAN_ID
                                        ,ROUTING_ID
                                        ,OP_SEQ
                                        ,RESOURCE_CLASS_ID
                                        ,RESOURCE_ID
                                        ,LOAD_PER
                                        ,PRIORITY
                                        ,START_DATE
                                        ,END_DATE
                                        ,SETUP_GROUP_ID
                                        ,SETUP_ID
                                        ,GROUP_SETUP_TIME
                                        ,SETUP_TIME
                                        ,CONTAINER_CATEGORY
                                        ,CONTAINER_SIZE
                                        ,ATTRIBUTE1
                                        ,ATTRIBUTE2
                                        ,ATTRIBUTE3
                                        ,ATTRIBUTE14
                                        ,ATTRIBUTE15
                                        )

        SELECT FN.PLAN_ID            AS PLAN_ID         
              ,FN.ATTRIBUTE1+'::'+FN.ATTRIBUTE2+'::'+FN.ATTRIBUTE3+'::'+FN.ATTRIBUTE15+'::'+FN.START_DATE AS ROUTING_ID
              ,FN.OP_SEQ             AS OP_SEQ           
              ,FN.RESOURCE_CLASS_ID  AS RESOURCE_CLASS_ID
              ,FN.RESOURCE_ID        AS RESOURCE_ID      
              ,FN.LOAD_PER           AS LOAD_PER         
              ,FN.PRIORITY           AS PRIORITY         
              ,FN.START_DATE         AS START_DATE
              ,FN.END_DATE           AS END_DATE
              ,FN.SETUP_GROUP_ID     AS SETUP_GROUP_ID    
              ,FN.SETUP_ID           AS SETUP_ID          
              ,FN.GROUP_SETUP_TIME   AS GROUP_SETUP_TIME  
              ,FN.SETUP_TIME         AS SETUP_TIME        
              ,FN.CONTAINER_CATEGORY AS CONTAINER_CATEGORY
              ,FN.CONTAINER_SIZE     AS CONTAINER_SIZE    
              ,FN.ATTRIBUTE1         AS ATTRIBUTE1        
              ,FN.ATTRIBUTE2         AS ATTRIBUTE2        
              ,FN.ATTRIBUTE3         AS ATTRIBUTE3        
              ,FN.ATTRIBUTE14        AS ATTRIBUTE14       
              ,FN.ATTRIBUTE15        AS ATTRIBUTE15
        FROM(
            SELECT GR.PLAN_ID            AS PLAN_ID         
                  ,GR.GROUP_RANK         AS GROUP_RANK       
                  ,GR.OP_SEQ             AS OP_SEQ           
                  ,GR.RESOURCE_CLASS_ID  AS RESOURCE_CLASS_ID
                  ,GR.RESOURCE_ID        AS RESOURCE_ID      
                  ,GR.LOAD_PER           AS LOAD_PER         
                  ,GR.PRIORITY           AS PRIORITY         
                  ,MIN(GR.START_DATE)    AS START_DATE
                  ,MAX(GR.END_DATE)      AS END_DATE
                  ,GR.SETUP_GROUP_ID     AS SETUP_GROUP_ID    
                  ,GR.SETUP_ID           AS SETUP_ID          
                  ,GR.GROUP_SETUP_TIME   AS GROUP_SETUP_TIME  
                  ,GR.SETUP_TIME         AS SETUP_TIME        
                  ,GR.CONTAINER_CATEGORY AS CONTAINER_CATEGORY
                  ,GR.CONTAINER_SIZE     AS CONTAINER_SIZE    
                  ,GR.ATTRIBUTE1         AS ATTRIBUTE1        
                  ,GR.ATTRIBUTE2         AS ATTRIBUTE2        
                  ,GR.ATTRIBUTE3         AS ATTRIBUTE3        
                  ,GR.ATTRIBUTE14        AS ATTRIBUTE14       
                  ,GR.ATTRIBUTE15        AS ATTRIBUTE15
            FROM(
                SELECT CF.PLAN_ID
                      ,SUM(CF.CHANGE_FLAG) OVER(ORDER BY RESOURCE_CLASS_ID, RESOURCE_ID, ATTRIBUTE1, ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE14,ATTRIBUTE15,START_DATE ROWS UNBOUNDED PRECEDING) AS GROUP_RANK
                      ,CF.OP_SEQ
                      ,CF.RESOURCE_CLASS_ID
                      ,CF.RESOURCE_ID
                      ,CF.LOAD_PER
                      ,CF.PRIORITY
                      ,CF.START_DATE
                      ,CF.END_DATE
                      ,CF.SETUP_GROUP_ID
                      ,CF.SETUP_ID
                      ,CF.GROUP_SETUP_TIME
                      ,CF.SETUP_TIME
                      ,CF.CONTAINER_CATEGORY
                      ,CF.CONTAINER_SIZE
                      ,CF.ATTRIBUTE1
                      ,CF.ATTRIBUTE2
                      ,CF.ATTRIBUTE3
                      ,CF.ATTRIBUTE14
                      ,CF.ATTRIBUTE15
                      ,FROZEN_TYPE
                FROM(
                    SELECT PV.PLAN_ID
                          ,CASE WHEN LOAD_PER = PREV_LP AND PV.ATTRIBUTE14 = PREV_MONTH AND RESOURCE_ID = PREV_RI AND ATTRIBUTE2 = PREV_ITEM_ID THEN 0 ELSE 1 END CHANGE_FLAG
                          ,PV.OP_SEQ
                          ,PV.RESOURCE_CLASS_ID
                          ,PV.RESOURCE_ID
                          ,PV.LOAD_PER
                          ,PV.PRIORITY
                          ,PV.START_DATE
                          ,PV.END_DATE
                          ,PV.SETUP_GROUP_ID
                          ,PV.SETUP_ID
                          ,PV.GROUP_SETUP_TIME
                          ,PV.SETUP_TIME
                          ,PV.CONTAINER_CATEGORY
                          ,PV.CONTAINER_SIZE
                          ,PV.ATTRIBUTE1
                          ,PV.ATTRIBUTE2
                          ,PV.ATTRIBUTE3
                          ,PV.ATTRIBUTE14
                          ,PV.ATTRIBUTE15
                          ,FROZEN_TYPE
                    FROM(
                        SELECT LF.PLAN_ID
                              ,LAG(LOAD_PER)    OVER(ORDER BY RESOURCE_CLASS_ID, RESOURCE_ID, ATTRIBUTE1, ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE14,ATTRIBUTE15,START_DATE) AS PREV_LP
                              ,LAG(ATTRIBUTE14) OVER(ORDER BY RESOURCE_CLASS_ID, RESOURCE_ID, ATTRIBUTE1, ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE14,ATTRIBUTE15,START_DATE) AS PREV_MONTH
                              ,LAG(RESOURCE_ID) OVER(ORDER BY RESOURCE_CLASS_ID, RESOURCE_ID, ATTRIBUTE1, ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE14,ATTRIBUTE15,START_DATE) AS PREV_RI
                              ,LAG(ATTRIBUTE2)  OVER(ORDER BY RESOURCE_CLASS_ID, RESOURCE_ID, ATTRIBUTE1, ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE14,ATTRIBUTE15,START_DATE) AS PREV_ITEM_ID
                              ,LF.OP_SEQ
                              ,LF.RESOURCE_CLASS_ID
                              ,LF.RESOURCE_ID
                              ,LF.LOAD_PER
                              ,LF.PRIORITY
                              ,LF.START_DATE
                              ,LF.END_DATE
                              ,IIF(FROZEN_TYPE = 'FROZEN', NULL, LF.SETUP_GROUP_ID  ) AS SETUP_GROUP_ID
                              ,IIF(FROZEN_TYPE = 'FROZEN', NULL, LF.SETUP_ID        ) AS SETUP_ID
                              ,IIF(FROZEN_TYPE = 'FROZEN', NULL, LF.GROUP_SETUP_TIME) AS GROUP_SETUP_TIME
                              ,IIF(FROZEN_TYPE = 'FROZEN', NULL, LF.SETUP_TIME      ) AS SETUP_TIME
                              ,LF.CONTAINER_CATEGORY
                              ,LF.CONTAINER_SIZE
                              ,LF.ATTRIBUTE1
                              ,LF.ATTRIBUTE2
                              ,LF.ATTRIBUTE3
                              ,LF.ATTRIBUTE14
                              ,LF.ATTRIBUTE15
                              ,FROZEN_TYPE
                        FROM(
                            SELECT  RP.PLAN_ID
                                   --,RP.ROUTING_ID
                                   ,RP.OP_SEQ
                                   ,RP.RESOURCE_CLASS_ID
                                   ,RP.RESOURCE_ID
                                   ,CONVERT(NUMERIC(20,10),RP.LOAD_PER/(CONVERT(NUMERIC(20,2),ISNULL(RU.LOAD_PER,100))/100)) AS LOAD_PER
                                   ,RP.PRIORITY
                                   ,CAL.BASIS_YYYYMMDD                                         AS START_DATE
                                   ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CAL.BASIS_YYYYMMDD),112) AS END_DATE
                                   --,ISNULL(MIN(ISNULL(RU.RU_BASE_DATE,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112))),'-') AS START_DATE
                                   ----,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ISNULL(RU.RU_BASE_DATE,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112)))),112) AS END_DATE
                                   --,CONVERT(NVARCHAR(8),MAX(ISNULL(RU.RU_BASE_DATE,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112))),112) AS END_DATE
                                   ,RP.SETUP_GROUP_ID
                                   ,RP.SETUP_ID
                                   ,RP.GROUP_SETUP_TIME
                                   ,RP.SETUP_TIME
                                   ,RP.CONTAINER_CATEGORY
                                   ,RP.CONTAINER_SIZE
                                   ,RP.ATTRIBUTE1
                                   ,RP.ATTRIBUTE2
                                   ,RP.ATTRIBUTE3
                                   ,RP.ATTRIBUTE14
                                   ,RP.ATTRIBUTE15
                                   ,IIF(FM.FROZEN_END_DATE > CAL.BASIS_YYYYMMDD, 'FROZEN','NON_FROZEN') AS FROZEN_TYPE
                            FROM @RR_TEMP RP 
                                INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                                    ON  CAL.BASIS_YYYYMMDD >= RP.START_DATE 
                                    AND CAL.BASIS_YYYYMMDD <  RP.END_DATE
                                LEFT OUTER JOIN (
                                                --SELECT  SEGMENT3 AS SCM_SITE_ID
                                                --       ,SEGMENT4 AS LINE_ID
                                                --       ,SEGMENT5 AS ITEM_ID
                                                --       ,ATTRIBUTE4 AS LOAD_PER
                                                --       ,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112) AS RU_BASE_DATE
                                                --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                                --    INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                                                --    ON  BASIS_YYYYMMDD BETWEEN ATTRIBUTE2 AND ATTRIBUTE3
                                                --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_RAMPUP'
                                                --AND     SEGMENT2 = @V_DIVISION_ID
                                                --AND     VALID_YN = 'Y'

                                                -- 2025.10.27 Minyong Lee : Lookup -> UI Table 전환 (Ramp-up)
                                                SELECT  ST.SCM_SITE_ID  AS SCM_SITE_ID
                                                      , R.LINE_ID       AS LINE_ID
                                                      , R.ITEM_ID       AS ITEM_ID
                                                      , MAX(R.EFCY)     AS LOAD_PER
                                                      , CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112) AS RU_BASE_DATE
                                                FROM    @RU_TEMP R
                                                    LEFT JOIN (
				                                                SELECT	OPERATION_ID
					                                                  , OPERATION_GROUP
				                                                FROM	SCM_MST_OPERATION_FLOW_V
				                                                WHERE	1=1
				                                                AND		VALID_YN = 'Y'
				                                                GROUP BY
						                                                OPERATION_ID
					                                                  , OPERATION_GROUP
				                                                ) OP
		                                                ON	R.OPERATION_ID = OP.OPERATION_ID
	                                                LEFT JOIN (
				                                                SELECT	PLANT_ID
					                                                  , SCM_SITE_ID
					                                                  , OPERATION_GROUP
				                                                FROM	SCM_MST_SITE
				                                                WHERE	1=1
				                                                AND		VALID_YN = 'Y'
				                                                AND		PLANT_ID IS NOT NULL
				                                                AND		SCM_SITE_ID IS NOT NULL 
				                                                GROUP BY
						                                                PLANT_ID
					                                                  , SCM_SITE_ID
					                                                  , OPERATION_GROUP
				                                                ) ST
		                                                ON	R.PLANT_ID = ST.PLANT_ID
		                                                AND	OP.OPERATION_GROUP = ST.OPERATION_GROUP
                                                    INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                                                        ON  CAL.BASIS_YYYYMMDD BETWEEN R.START_DATE AND R.END_DATE
                                                WHERE   1=1
                                                AND     VALID_YN = 'Y'
                                                AND     DIVISION_ID = @V_DIVISION_ID
                                                GROUP BY ST.SCM_SITE_ID, R.LINE_ID, R.ITEM_ID, CAL.BASIS_DATE
                                                ) RU
                                        ON  RP.ATTRIBUTE1  = RU.SCM_SITE_ID
                                        AND RP.ATTRIBUTE2  = RU.ITEM_ID
                                        AND RP.ATTRIBUTE15 = RU.LINE_ID
                                        AND CAL.BASIS_YYYYMMDD = RU.RU_BASE_DATE
                                LEFT OUTER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                    ON  RP.PLAN_ID    = FM.PLAN_ID
                                    AND RP.ATTRIBUTE3 = FM.STAGE
                                -- 2026.03.05 Minyong Lee : 형변환 Set-up 구간 적용 데이터 (전극 기준으로 조립에 동일 적용)
                                LEFT OUTER JOIN @SETUP_TEMP SUD
                                    ON  CAL.BASIS_YYYYMMDD = SUD.BASIS_YYYYMMDD
                                    AND RP.ATTRIBUTE15 = SUD.LINE_ID
                                    AND RP.ATTRIBUTE2 = SUD.ITEM_ID
                                    AND RP.ATTRIBUTE1= SUD.SCM_SITE_ID
                            WHERE RP.STEP = 2
                            /*  2025.07.24 Philsu Park: ROUTING BLOCK 제약 추가: 룩업 입력된 구간의 ROUTING 정보를 생성하지 않음. 
                                2025.08.05 Phislu Park: TO_YYYYMMDD 는 +1일 처리.
                            */
                          /*  AND NOT EXISTS (
                                            SELECT 1
                                            FROM ( 
                                                    SELECT    SEGMENT4      AS SITE_ID
                                                            , SEGMENT5      AS ITEM_ID
                                                            , SEGMENT6      AS LINE_ID
                                                            , SEGMENT7      AS STAGE
                                                            , ATTRIBUTE1    AS FROM_YYYYMMDD
                                                            , CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, ATTRIBUTE2, 112)), 112) TO_YYYYMMDD
                                                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                    WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_ROUTING_BLOCKING'
                                                    AND     LK.VALID_YN     = 'Y'
                                                    AND     LK.SEGMENT2     = @V_DIVISION_ID
                                                    AND     LK.SEGMENT3     = @V_GROUP_ID
                                                ) MM
                                            WHERE   1=1
                                            AND     MM.SITE_ID          = RP.ATTRIBUTE1
                                            -- 2026.04.06 Minyong Lee : ROUTING_BLOCKING 룩업에 '-'로 등록 시 MODEL_LIST 기준을 빠지도록 로직 수정
                                            --AND     MM.ITEM_ID          = RP.ATTRIBUTE2
                                            AND     RP.ATTRIBUTE2       = IIF(MM.ITEM_ID='-',RP.ATTRIBUTE2,MM.ITEM_ID)
                                            AND     MM.STAGE            = RP.ATTRIBUTE3
                                            AND     MM.LINE_ID          = RP.ATTRIBUTE15
                                            AND     MM.FROM_YYYYMMDD   <= CAL.BASIS_YYYYMMDD
                                            AND     MM.TO_YYYYMMDD      > CAL.BASIS_YYYYMMDD
                                            )*/
                            ) LF
                        ) PV
                    ) CF
                )GR
            GROUP BY PLAN_ID,GROUP_RANK,OP_SEQ,RESOURCE_CLASS_ID,RESOURCE_ID,LOAD_PER,PRIORITY,SETUP_GROUP_ID,SETUP_ID,GROUP_SETUP_TIME,SETUP_TIME,CONTAINER_CATEGORY,CONTAINER_SIZE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE14,ATTRIBUTE15,FROZEN_TYPE
            ) FN
        ;

        ------------------------------------------------------------------------
        -- 2025.08.14 Philsu Park
        -- 신규버전 라인 인원 제약 반영. 룩업 등록된 SITE, STAGE, LINE 기준으로 업데이트.
        -- 2025.09.09 Philsu Park: Setup Group ID 가 공란인 대상은 알파벳 a로 마킹.
        -- 2025.09.15 Philsu Park: 제약 START - END 구간 조건 추가
        ------------------------------------------------------------------------  
       /* UPDATE  RR
        SET       USER_ATTB7    = LK.TOOL_ASSIGN_TYPE
                , USER_ATTB8    = LK.PERSONNEL_PER_LINE
                , USER_ATTB9    = CONCAT(LK.SITE_ID, '::', LK.LINE_GROUP)
                , SETUP_GROUP_ID = IIF(ISNULL(SETUP_GROUP_ID, '') = '', 'a', SETUP_GROUP_ID)
                , UPDATE_ID     = 'LINE_PERSONNEL_NEW'
                , UPDATE_TIME   = CURRENT_TIMESTAMP
        FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN RR
        INNER JOIN (
                    SELECT    LK.SEGMENT4   AS SITE_ID
                            , LK.SEGMENT5   AS LINE_ID
                            , LK.SEGMENT6   AS LINE_GROUP
                            , LK.SEGMENT7   AS STAGE
                            , 1             AS TOOL_ASSIGN_TYPE
                            , LK.ATTRIBUTE2 AS PERSONNEL_PER_LINE
                            , CONCAT(IIF(LK.ATTRIBUTE3 = '', @V_PLAN_START_YYYYMM, LK.ATTRIBUTE3), '01') AS START_YYYYMMDD
                            , CONVERT(NVARCHAR, DATEADD(MONTH, 1, CONVERT(DATE, CONCAT(IIF(LK.ATTRIBUTE4 = '', @V_PLAN_END_YYYYMM, LK.ATTRIBUTE4), '01'), 112)), 112) AS END_YYYYMMDD
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                    WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL_NEW'
                    AND     LK.VALID_YN     = 'Y'
                    AND     LK.SEGMENT2     = @V_DIVISION_ID
                    AND     LK.SEGMENT3     = @V_GROUP_ID
                    ) LK
            ON  RR.ATTRIBUTE1   = LK.SITE_ID
            AND RR.ATTRIBUTE3   = LK.STAGE
            AND RR.ATTRIBUTE15  = LK.LINE_ID
            AND RR.START_DATE  >= LK.START_YYYYMMDD
            AND RR.END_DATE    <= LK.END_YYYYMMDD
        WHERE   RR.PLAN_ID             = @V_PLAN_ID
        AND     RR.RESOURCE_CLASS_ID   = 'LINE'
        ;*/
        --SELECT  RP.PLAN_ID
        --       ,RP.ROUTING_ID
        --       ,RP.OP_SEQ
        --       ,RP.RESOURCE_CLASS_ID
        --       ,RP.RESOURCE_ID
        --       ,CONVERT(NUMERIC(20,10),RP.LOAD_PER/(CONVERT(NUMERIC(20,2),ISNULL(RU.LOAD_PER,100))/100)) AS LOAD_PER
        --       ,RP.PRIORITY
        --       ,CAL.BASIS_YYYYMMDD                                         AS START_DATE
        --       ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CAL.BASIS_YYYYMMDD),112) AS END_DATE
        --       --,ISNULL(MIN(ISNULL(RU.RU_BASE_DATE,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112))),'-') AS START_DATE
        --       ----,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ISNULL(RU.RU_BASE_DATE,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112)))),112) AS END_DATE
        --       --,CONVERT(NVARCHAR(8),MAX(ISNULL(RU.RU_BASE_DATE,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112))),112) AS END_DATE
        --       ,RP.SETUP_GROUP_ID
        --       ,RP.SETUP_ID
        --       ,RP.GROUP_SETUP_TIME
        --       ,RP.SETUP_TIME
        --       ,RP.CONTAINER_CATEGORY
        --       ,RP.CONTAINER_SIZE
        --       ,RP.ATTRIBUTE1
        --       ,RP.ATTRIBUTE2
        --       ,RP.ATTRIBUTE3
        --       ,RP.ATTRIBUTE14
        --       ,RP.ATTRIBUTE15
        --FROM @RR_TEMP RP 
        --    INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
        --        ON  CAL.BASIS_YYYYMMDD >= RP.START_DATE 
        --        AND CAL.BASIS_YYYYMMDD <  RP.END_DATE
        --    LEFT OUTER JOIN (
        --                    SELECT  SEGMENT3 AS SCM_SITE_ID
        --                           ,SEGMENT4 AS LINE_ID
        --                           ,SEGMENT5 AS ITEM_ID
        --                           ,ATTRIBUTE4 AS LOAD_PER
        --                           ,CONVERT(NVARCHAR(8),CAL.BASIS_DATE,112) AS RU_BASE_DATE
        --                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --                        INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
        --                        ON  BASIS_YYYYMMDD BETWEEN ATTRIBUTE2 AND ATTRIBUTE3
        --                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_RAMPUP'
        --                    AND     SEGMENT2 = @V_DIVISION_ID
        --                    AND     VALID_YN = 'Y'
        --                    ) RU
        --            ON  RP.ATTRIBUTE1  = RU.SCM_SITE_ID
        --            AND RP.ATTRIBUTE2  = RU.ITEM_ID
        --            AND RP.ATTRIBUTE15 = RU.LINE_ID
        --            AND CAL.BASIS_YYYYMMDD = RU.RU_BASE_DATE
        --WHERE RP.STEP = 2

        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

		IF OBJECT_ID('TEMPDB..#TACT_TIME') IS NOT NULL
		BEGIN 
			DROP TABLE  #TACT_TIME;
		END;	

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

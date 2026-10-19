
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_SR_ESS_INPUT_ITEM_SITE]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.11 TAEHYUN Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  


	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_SR_ESS_INPUT_ITEM_SITE';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;


    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	BEGIN TRY
        ------------------------------------------------------------------------
        -- SET Param
        ------------------------------------------------------------------------
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;

		IF OBJECT_ID('TEMPDB..#PRODUCTION') IS NOT NULL
		BEGIN 
			DROP TABLE  #PRODUCTION;
		END;

        WITH PLAN_GROUP AS (SELECT    GR.OPMZ_PLAN_GR_NAME  AS PLAN_GROUP_NAME
									, T.OPMZ_PLAN_GR_ID     AS PLAN_GROUP_ID
									, T.LINE_ID             AS LINE_ID
									, T.OPERATION_ID        AS OPERATION_ID
									, T.FACTORY_ID          AS FACTORY_ID
									, T.PLANT_ID            AS PLANT_ID
									, T.ITEM_ID             AS ITEM_ID
							FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
							INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
								ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
							WHERE   GR.OPMZ_PLAN_GR_NAME    = @V_GROUP_ID
							AND     T.VALID_YN              = 'Y'
					)
        SELECT    A.PLANT_SITE_ID AS SITE_ID
                , A.ITEM_ID     AS ITEM_ID
                ,'PRODUCTION'    AS ITEM_CLASS_ID -- MATERIAL 정보는 별도 추가 필요
                , CASE  WHEN FNL.OPERATION_GROUP_ID = 'A' AND FNL.ATTRIBUTE8    = 'CP'                                      THEN 'CHAR'
                        WHEN FNL.OPERATION_GROUP_ID = 'A' AND FNL.ATTRIBUTE8   != 'CP'                                      THEN 'ASY_AGING'
                        WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID       = 'P9500'                                   THEN 'LINK'
                        WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID	    = 'R5500'                                   THEN 'RACK' 
                        WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID       = 'P9500'                                   THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID       = 'P5500'                                   THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID	    = 'P9500'                                   THEN 'PACK' 
                        WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID	    = 'P5000'   AND A.ITEM_ID NOT LIKE 'EP%'    THEN 'PACK' 
                        WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID       = 'P5000'   AND A.ITEM_ID LIKE 'EP%'        THEN 'PACK' 
                        ELSE '-'
                    END              AS STAGE
                , FNL.NICK_NAME AS NICK_NAME
        INTO    #PRODUCTION
        FROM    SCM_MST_SITE_ITEM_PRIORITY A WITH(NOLOCK)
        INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
            ON  A.DIVISION_ID    = S.DIVISION_ID
            AND A.PLANT_SITE_ID  = S.SCM_SITE_ID
            AND S.SITE_TYPE      = 'PLANT'
            AND S.VALID_YN       = 'Y'
        INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8, NICK_NAME
                            FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                            WHERE  DIVISION_ID = @V_DIVISION_ID
                            AND    OPERATION_GROUP IN ('A', 'P')
                            ) FNL
            ON    A.ITEM_ID     = FNL.ITEM_ID
            AND   A.DIVISION_ID = FNL.DIVISION_ID 
        INNER JOIN (SELECT DISTINCT ATTRIBUTE1 AS SCM_SITE_ID, ATTRIBUTE2 AS ITEM_ID
                    FROM   SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
                    WHERE  PLAN_ID = @V_PLAN_ID
                    ) BOM
            ON  A.PLANT_SITE_ID = BOM.SCM_SITE_ID
            AND A.ITEM_ID       = BOM.ITEM_ID
        WHERE   A.DIVISION_ID   = @V_DIVISION_ID
        AND     A.VALID_YN      = 'Y'  
        AND     A.TO_YYYYMMDD  >= @V_PLAN_START_YYYYMMDD
        AND     A.ITEM_ID      IN ( SELECT  DISTINCT ITEM_ID
                                    FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                    WHERE   PLAN_ID = @V_PLAN_ID
                                    )
        UNION
        SELECT    ST.SCM_SITE_ID    AS SITE_ID
                , ILA.ITEM_ID       AS ITEM_ID
                ,'PRODUCTION'    AS ITEM_CLASS_ID -- MATERIAL 정보는 별도 추가 필요
                , CASE  WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'LINK'
                        WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID	  = 'R5500'    THEN 'RACK' 
                        WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID     = 'P5500'    THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID	  = 'P9500'    THEN 'PACK' 
                        WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID	  = 'P5000'    AND ILA.ITEM_ID NOT LIKE 'EP%'  THEN 'PACK' 
                        WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID     = 'P5000'    AND ILA.ITEM_ID LIKE 'EP%'      THEN 'PACK' 
                        ELSE '-'
                    END              AS STAGE
                , FNL.NICK_NAME AS NICK_NAME
        FROM SCP_MST_TACT_TIME_OSP ILA WITH(NOLOCK)
        INNER JOIN PLAN_GROUP GRP
            ON  ILA.LINE_ID         = GRP.LINE_ID
            AND ILA.OPERATION_ID    = GRP.OPERATION_ID
            AND ILA.ITEM_ID         = IIF(GRP.ITEM_ID='-', ILA.ITEM_ID, GRP.ITEM_ID)  -- item 명시 안되어있으면 assign 전체.
        INNER JOIN (
                    SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID,  FLOW_ID, ATTRIBUTE8, NICK_NAME
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  1=1
                    AND   ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                        OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                            )
                    ) FNL
            ON  ILA.DIVISION_ID = FNL.DIVISION_ID
            AND ILA.ITEM_ID     = FNL.ITEM_ID
        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  ILA.DIVISION_ID         = ST.DIVISION_ID
            AND ILA.PLANT_SITE_ID       = ST.SCM_SITE_ID
            AND FNL.OPERATION_GROUP     = ST.OPERATION_GROUP
            AND ST.VALID_YN             = 'Y'
        WHERE   1=1
        and     ila.division_id     = @V_DIVISION_ID
        AND     ILA.VALID_YN         = 'Y'
        AND     ILA.PRIORITY         <> 9
        AND     ILA.ITEM_ID      IN ( SELECT  DISTINCT ITEM_ID
                                    FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                    WHERE   PLAN_ID = @V_PLAN_ID
                                    )
        ;

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
        -- 1. DEMAND INSERT
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                            ,BUFFER_ID	
                                            ,SITE_ID	
                                            ,ITEM_ID	
                                            ,GRADE	
                                            ,SITE_TYPE	
                                            ,ITEM_CLASS_ID	
                                            ,INCH	
                                            ,FAB	
                                            ,STAGE	
                                            ,IS_INFINITE	
                                            ,IS_PURCHASED	
                                            ,PURCHASE_PERIOD	
                                            ,IS_NO_CARRY	
                                            ,STORAGE_ID	
                                            ,STORAGE_PER	
                                            ,SETUP_ID	
                                            ,SETUP_GROUP_ID	
                                            ,ITEM_GROUP_ID
                                            ,ATTRIBUTE1
                                            ,ATTRIBUTE2
                                            ,ATTRIBUTE3
                                            )
            SELECT   A.PLAN_ID                       AS PLAN_ID
                    ,A.BUFFER_ID                     AS BUFFER_ID
                    ,A.ATTRIBUTE1                    AS SITE_ID
                    ,A.ATTRIBUTE2                    AS ITEM_ID
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') +IIF(A.ATTRIBUTE4 IS NULL,'','@'+A.ATTRIBUTE4)+IIF(A.ATTRIBUTE5 IS NULL,'','@'+A.ATTRIBUTE5) AS GRADE
                    ,NULL                            AS SITE_TYPE
                    ,'DEMAND'                        AS ITEM_CLASS_ID
                    ,NULL                            AS INCH
                    ,NULL                            AS FAB
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS STAGE
                    ,NULL                            AS IS_INFINITE
                    ,NULL                            AS IS_PURCHASED
                    ,NULL                            AS PURCHASE_PERIOD
                    ,NULL                            AS IS_NO_CARRY
                    ,NULL                            AS STORAGE_ID
                    ,NULL                            AS STORAGE_PER
                    ,NULL                            AS SETUP_ID
                    ,NULL                            AS SETUP_GROUP_ID
                    ,NULL                            AS ITEM_GROUP_ID
                    ,A.ATTRIBUTE4                    AS INCOTERMS
                    ,A.ATTRIBUTE5                    AS PROJECT_CODE
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS STAGE
            FROM    SCP_OPT_ENG_DEMAND_SN A WITH(NOLOCK)
            INNER JOIN SCP_MST_FINAL_ITEM B WITH(NOLOCK) ON  A.ATTRIBUTE2 = B.ITEM_ID
                                                         AND B.DIVISION_ID= @V_DIVISION_ID
                                                         AND A.PLAN_ID    = @V_PLAN_ID
            WHERE   A.PLAN_ID = @V_PLAN_ID
            AND     A.ATTRIBUTE3 != 'CHAR'
            GROUP BY A.PLAN_ID, A.BUFFER_ID, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, B.NICK_NAME,A.ATTRIBUTE5

            ------------------------------------------------------------------------
            -- ADD DEMAND GROUP 
            ------------------------------------------------------------------------
            UNION ALL
            SELECT   A.PLAN_ID                       AS PLAN_ID
                    ,A.BUFFER_ID                     AS BUFFER_ID
                    ,A.ATTRIBUTE1                    AS SITE_ID
                    ,A.ATTRIBUTE2                    AS ITEM_ID
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') +IIF(A.ATTRIBUTE4 IS NULL,'','@'+A.ATTRIBUTE4)+IIF(A.ATTRIBUTE5 IS NULL,'','@'+A.ATTRIBUTE5) AS GRADE
                    ,NULL                            AS SITE_TYPE
                    ,'DEMAND'                        AS ITEM_CLASS_ID
                    ,NULL                            AS INCH
                    ,NULL                            AS FAB
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS STAGE
                    ,NULL                            AS IS_INFINITE
                    ,NULL                            AS IS_PURCHASED
                    ,NULL                            AS PURCHASE_PERIOD
                    ,NULL                            AS IS_NO_CARRY
                    ,NULL                            AS STORAGE_ID
                    ,NULL                            AS STORAGE_PER
                    ,NULL                            AS SETUP_ID
                    ,NULL                            AS SETUP_GROUP_ID
                    ,NULL                            AS ITEM_GROUP_ID
                    ,A.ATTRIBUTE4                    AS INCOTERMS
                    ,A.ATTRIBUTE5                    AS PROJECT_CODE
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS ATTRIBUTE3
            FROM    SCP_OPT_ENG_DEMAND_SN A WITH(NOLOCK)
            WHERE   PLAN_ID = @V_PLAN_ID
            AND     ATTRIBUTE12 = 'DEMAND_GROUP'
            GROUP BY A.PLAN_ID, A.BUFFER_ID, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
            ------------------------------------------------------------------------
            -- PRODUCTION INSERT
            ------------------------------------------------------------------------
            UNION ALL
            SELECT @V_PLAN_ID                            AS PLAN_ID
                  ,A.SITE_ID+'::'+A.ITEM_ID+'::'+A.STAGE AS BUFFER_ID
                  ,A.SITE_ID                             AS SITE_ID
                  ,A.ITEM_ID                             AS ITEM_ID
                  ,STAGE                                 AS GRADE
                  ,NULL                                  AS SITE_TYPE
                  ,'PRODUCTION'                          AS ITEM_CLASS_ID
                  ,NULL                                  AS INCH
                  ,NULL                                  AS FAB
                  ,STAGE                                 AS STAGE
                  ,NULL                                  AS IS_INFINITE
                  ,NULL                                  AS IS_PURCHASED
                  ,NULL                                  AS PURCHASE_PERIOD
                  ,NULL                                  AS IS_NO_CARRY
                  --,LU.ATTRIBUTE1                         AS STORAGE_ID
				  ,LU.SEGMENT3+'::'+LU.ATTRIBUTE1		 AS STORAGE_ID
                  ,IIF(LU.ATTRIBUTE1 IS NULL,NULL,1)     AS STORAGE_PER
                  ,NULL                                  AS SETUP_ID
                  ,A.NICK_NAME                           AS SETUP_GROUP_ID
                  ,NULL                                  AS ITEM_GROUP_ID
                  ,NULL                                  AS INCOTERMS
                  ,NULL                                  AS PROJECT_CODE
                  ,STAGE                                 AS ATTRIBUTE3
            FROM (
                ------------------------------
                -- PRODUCTION
                ------------------------------
				SELECT SITE_ID, ITEM_ID, ITEM_CLASS_ID, STAGE, NICK_NAME--, BOM_CFM
				FROM   #PRODUCTION

                ------------------------------
                -- PRODUCTION : ASY_AGING을 COPY하여 ASSY 처리
                ------------------------------
                UNION
				SELECT SITE_ID, ITEM_ID, ITEM_CLASS_ID, 'ASSY' AS STAGE, NICK_NAME--, BOM_CFM
				FROM   #PRODUCTION
                WHERE  1=1
                AND    STAGE = 'ASY_AGING' 
                ) AS A

            /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SL_ITEM_MAP'
            AND LU.SEGMENT2    = @V_DIVISION_ID
            AND LU.VALID_YN    = 'Y'
            AND A.SITE_ID      = LU.SEGMENT3
            AND A.ITEM_ID      = LU.SEGMENT4
            AND A.STAGE        = LU.SEGMENT5*/-- BLOCKED 2025.12.05 jongykim2: Warehouse Capacity
            -- ADDED 2025.12.05 jongykim2: Warehouse Capacity
            LEFT OUTER JOIN (
                SELECT T.DIVISION_ID AS SEGMENT2
                     , T.SCM_SITE_ID AS SEGMENT3
                     , T.ITEM_ID     AS SEGMENT4
                     , T.STAGE       AS SEGMENT5
                     , T.WH_NM       AS ATTRIBUTE1
                     , T.STOR_PER    AS ATTRIBUTE2
                     , T.STOR_LOC    AS ATTRIBUTE4
                FROM   SCP_OPMZ_WAREHOUSE_ITEM_MAPPING T WITH(NOLOCK)
                INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON     T.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE  T.DIVISION_ID     = @V_DIVISION_ID
                AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                AND    T.VALID_YN        = 'Y'
                AND    PG.VALID_YN       = 'Y'
               ) LU
                ON  1 = 1
                AND A.SITE_ID           = LU.SEGMENT3
                AND A.ITEM_ID           = LU.SEGMENT4
                AND A.STAGE             = LU.SEGMENT5
            --WHERE STAGE = 'PACK' OR (STAGE !='PACK' AND BOM_CFM IS NOT NULL)

			------------------------------------------------------------------------
			-- 2. SUBMDLE INSERT
			------------------------------------------------------------------------
			INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
												,BUFFER_ID	
												,SITE_ID	
												,ITEM_ID	
												,GRADE	
												,SITE_TYPE	
												,ITEM_CLASS_ID	
												,INCH	
												,FAB	
												,STAGE	
												,IS_INFINITE	
												,IS_PURCHASED	
												,PURCHASE_PERIOD	
												,IS_NO_CARRY	
												,STORAGE_ID	
												,STORAGE_PER	
												,SETUP_ID	
												,SETUP_GROUP_ID	
												,ITEM_GROUP_ID
												,ATTRIBUTE1
												,ATTRIBUTE2
												,ATTRIBUTE3
												)
            SELECT @V_PLAN_ID                            AS PLAN_ID
                  ,A.SITE_ID+'::'+A.ITEM_ID+'::'+A.STAGE AS BUFFER_ID
                  ,A.SITE_ID                             AS SITE_ID
                  ,A.ITEM_ID                             AS ITEM_ID
                  ,STAGE                                 AS GRADE
                  ,NULL                                  AS SITE_TYPE
                  ,'PRODUCTION'                          AS ITEM_CLASS_ID
                  ,NULL                                  AS INCH
                  ,NULL                                  AS FAB
                  ,STAGE                                 AS STAGE
                  ,NULL                                  AS IS_INFINITE
                  ,NULL                                  AS IS_PURCHASED
                  ,NULL                                  AS PURCHASE_PERIOD
                  ,NULL                                  AS IS_NO_CARRY
                  --,LU.ATTRIBUTE1                         AS STORAGE_ID
				  ,LU.SEGMENT3+'::'+LU.ATTRIBUTE1		 AS STORAGE_ID
                  ,IIF(LU.ATTRIBUTE1 IS NULL,NULL,1)     AS STORAGE_PER
                  ,NULL                                  AS SETUP_ID
                  ,A.NICK_NAME                           AS SETUP_GROUP_ID
                  ,NULL                                  AS ITEM_GROUP_ID
                  ,NULL                                  AS INCOTERMS
                  ,NULL                                  AS PROJECT_CODE
                  ,STAGE                                 AS ATTRIBUTE3
            FROM (
                ------------------------------
                -- PRODUCTION : SUBMDLE
                -- NICK이 여러개 나오는 경우 KEY 중복 방지를 위한 GROUP BY/20250507/김태현
                -- 2025.06.24 Philsu Park: Join 구문 일부 변경
                ------------------------------
                SELECT SITE_ID
                      ,ITEM_ID
                      ,STAGE
                      ,MAX(NICK_NAME) AS NICK_NAME
                FROM (
				     SELECT A.SITE_ID, B.ATTRIBUTE14 AS ITEM_ID, 'SUBMDLE' AS STAGE, ISNULL(MI.NICK_NAME, A.SETUP_GROUP_ID) AS NICK_NAME--, BOM_CFM
				     FROM   SCP_OPT_ENG_ITEM_SITE_SN A WITH(NOLOCK)		     
				     INNER JOIN SCP_OPT_ENG_BOM_SN B WITH(NOLOCK)
                        ON  A.PLAN_ID = B.PLAN_ID
                        AND A.SITE_ID = B.ATTRIBUTE1 -- PLANT_SITE_ID
                        AND A.ITEM_ID = B.ATTRIBUTE2 -- PARENT_ITEM_ID
                        AND A.STAGE   IN ('PACK')
                        AND B.MATERIAL_CLASS_ID = 'SUBMDLE'
				     LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
				     			FROM   SCM_MST_ITEM_SN WITH (NOLOCK) 
				     			WHERE  DIVISION_ID = @V_DIVISION_ID
				     			GROUP BY DIVISION_ID, ITEM_ID
				     			) MI
                        ON    A.ITEM_ID      = MI.ITEM_ID
                        AND   MI.DIVISION_ID = @V_DIVISION_ID
                        WHERE A.PLAN_ID = @V_PLAN_ID
				     -- 중복 제외
				     EXCEPT
				     SELECT A.SITE_ID, A.ITEM_ID, A.STAGE, A.SETUP_GROUP_ID AS NICK_NAME--, BOM_CFM
				     FROM   SCP_OPT_ENG_ITEM_SITE_SN A WITH(NOLOCK)                
				     WHERE  A.PLAN_ID = @V_PLAN_ID
                     AND    A.STAGE   = 'SUBMDLE'
                     ) SUB
                GROUP BY SITE_ID,ITEM_ID,STAGE
                ) AS A
            /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SL_ITEM_MAP'
            AND LU.SEGMENT2    = @V_DIVISION_ID
            AND LU.VALID_YN    = 'Y'
            AND A.SITE_ID      = LU.SEGMENT3
            AND A.ITEM_ID      = LU.SEGMENT4
            AND A.STAGE        = LU.SEGMENT5*/-- BLOCKED 2025.12.05 jongykim2: Warehouse Capacity
            -- ADDED 2025.12.05 jongykim2: Warehouse Capacity
            LEFT OUTER JOIN (
                SELECT T.DIVISION_ID AS SEGMENT2
                     , T.SCM_SITE_ID AS SEGMENT3
                     , T.ITEM_ID     AS SEGMENT4
                     , T.STAGE       AS SEGMENT5
                     , T.WH_NM       AS ATTRIBUTE1
                     , T.STOR_PER    AS ATTRIBUTE2
                     , T.STOR_LOC    AS ATTRIBUTE4
                FROM   SCP_OPMZ_WAREHOUSE_ITEM_MAPPING T WITH(NOLOCK)
                INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON     T.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE  T.DIVISION_ID     = @V_DIVISION_ID
                AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                AND    T.VALID_YN        = 'Y'
                AND    PG.VALID_YN       = 'Y'
               ) LU
                ON  1 = 1
                AND A.SITE_ID           = LU.SEGMENT3
                AND A.ITEM_ID           = LU.SEGMENT4
                AND A.STAGE             = LU.SEGMENT5
			
			------------------------------------------------------------------------
			-- 3. MATERIAL INSERT
            -- 2025.05.12 Philsu Park: 창고정보 추가를 위한 Join 구문 수정, STORAGE 관련 정보 추가 반영.
			------------------------------------------------------------------------
			INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
												,BUFFER_ID	
												,SITE_ID	
												,ITEM_ID	
												,GRADE	
												,SITE_TYPE	
												,ITEM_CLASS_ID	
												,INCH	
												,FAB	
												,STAGE	
												,IS_INFINITE	
												,IS_PURCHASED	
												,PURCHASE_PERIOD	
												,IS_NO_CARRY	
												,STORAGE_ID	
												,STORAGE_PER	
												,SETUP_ID	
												,SETUP_GROUP_ID	
												,ITEM_GROUP_ID
												,ATTRIBUTE1
												,ATTRIBUTE2
												,ATTRIBUTE3
												)
            SELECT @V_PLAN_ID                            AS PLAN_ID
                  ,A.SITE_ID+'::'+A.ITEM_ID+'::'+A.STAGE AS BUFFER_ID
                  ,A.SITE_ID                             AS SITE_ID
                  ,A.ITEM_ID                             AS ITEM_ID
                  ,A.STAGE                               AS GRADE
                  ,NULL                                  AS SITE_TYPE
                  ,'MATERIAL'                            AS ITEM_CLASS_ID
                  ,NULL                                  AS INCH
                  ,NULL                                  AS FAB
                  ,A.STAGE                               AS STAGE
                  ,NULL                                  AS IS_INFINITE
                  ,NULL                                  AS IS_PURCHASED
                  ,NULL                                  AS PURCHASE_PERIOD
                  ,NULL                                  AS IS_NO_CARRY
                  ,LU.SEGMENT3+'::'+LU.ATTRIBUTE1		 AS STORAGE_ID
                  ,IIF(LU.ATTRIBUTE1 IS NULL,NULL,1)     AS STORAGE_PER
                  ,NULL                                  AS SETUP_ID
                  ,NULL                                  AS SETUP_GROUP_ID
                  ,NULL                                  AS ITEM_GROUP_ID
                  ,NULL                                  AS INCOTERMS
                  ,NULL                                  AS PROJECT_CODE
                  ,A.STAGE                               AS ATTRIBUTE3
            FROM(
                SELECT DISTINCT PLANT_SITE_ID AS SITE_ID
                               ,CHILD_ITEM_ID AS ITEM_ID
                               ,'MATERIAL' AS ITEM_CLASS_ID
                               ,CHILD_STAGE AS STAGE
                FROM (
						------------------------------
						-- MATERIAL : SUBMDLE -> CHAR
						------------------------------
						SELECT A.SITE_ID AS PLANT_SITE_ID, B.ATTRIBUTE14 AS CHILD_ITEM_ID, B.ATTRIBUTE15 AS CHILD_STAGE
						FROM   SCP_OPT_ENG_ITEM_SITE_SN A WITH(NOLOCK)
				
						INNER JOIN SCP_OPT_ENG_BOM_SN B WITH(NOLOCK)
                
						ON  A.PLAN_ID = B.PLAN_ID
						AND A.SITE_ID = B.ATTRIBUTE1 -- PLANT_SITE_ID
						AND A.ITEM_ID = B.ATTRIBUTE2 -- PARENT_ITEM_ID
                        -- 2026.03.03 Minyong Lee : ESS_NAM Plan Gr SUBMDLE 버퍼 추가 대응
						AND A.STAGE   IN ('PACK', 'LINK', 'SUBMDLE')
                        WHERE A.PLAN_ID = @V_PLAN_ID

                    ) AS AA
                ) AS A
            INNER JOIN SCP_MST_FINAL_ITEM B WITH(NOLOCK) ON  A.ITEM_ID = B.ITEM_ID
                                                         AND B.DIVISION_ID= @V_DIVISION_ID
            /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_SL_ITEM_MAP'
                AND LU.SEGMENT2     = @V_DIVISION_ID
                AND LU.VALID_YN     = 'Y'
                AND A.SITE_ID       = LU.SEGMENT3
                AND A.ITEM_ID       = LU.SEGMENT4
                AND A.STAGE         = LU.SEGMENT5*/-- BLOCKED 2025.12.05 jongykim2: Warehouse Capacity
            -- ADDED 2025.12.05 jongykim2: Warehouse Capacity
            LEFT OUTER JOIN (
                SELECT T.DIVISION_ID AS SEGMENT2
                     , T.SCM_SITE_ID AS SEGMENT3
                     , T.ITEM_ID     AS SEGMENT4
                     , T.STAGE       AS SEGMENT5
                     , T.WH_NM       AS ATTRIBUTE1
                     , T.STOR_PER    AS ATTRIBUTE2
                     , T.STOR_LOC    AS ATTRIBUTE4
                FROM   SCP_OPMZ_WAREHOUSE_ITEM_MAPPING T WITH(NOLOCK)
                INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON     T.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE  T.DIVISION_ID     = @V_DIVISION_ID
                AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                AND    T.VALID_YN        = 'Y'
                AND    PG.VALID_YN       = 'Y'
               ) LU
                ON  1 = 1
                AND A.SITE_ID           = LU.SEGMENT3
                AND A.ITEM_ID           = LU.SEGMENT4
                AND A.STAGE             = LU.SEGMENT5
            LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS  WITH(NOLOCK) 
                ON  ITS.PLAN_ID     = @V_PLAN_ID
                AND ITS.BUFFER_ID   =A.SITE_ID+'::'+A.ITEM_ID+'::'+A.STAGE
            WHERE ITS.PLAN_ID IS NULL

            ------------------------------------------------------------------------
            -- 2nd OCV 신규 Buffer 추가
            ------------------------------------------------------------------------ 
            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                              ,BUFFER_ID	
                                              ,SITE_ID	
                                              ,ITEM_ID	
                                              ,GRADE	
                                              ,SITE_TYPE	
                                              ,ITEM_CLASS_ID	
                                              ,INCH	
                                              ,FAB	
                                              ,STAGE	
                                              ,IS_INFINITE	
                                              ,IS_PURCHASED	
                                              ,PURCHASE_PERIOD	
                                              ,IS_NO_CARRY	
                                              ,STORAGE_ID	
                                              ,STORAGE_PER	
                                              ,SETUP_ID	
                                              ,SETUP_GROUP_ID	
                                              ,ITEM_GROUP_ID
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
                                             )

            SELECT  @V_PLAN_ID                                      AS PLAN_ID
                   ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3 AS BUFFER_ID
                   ,LU.SEGMENT4                                     AS SITE_ID
                   ,LU.SEGMENT5                                     AS ITEM_ID
                   ,LU.ATTRIBUTE3                                   AS GRADE
                   ,NULL                                            AS SITE_TYPE
                   ,'PRODUCTION'                                    AS ITEM_CLASS_ID
                   ,NULL                                            AS INCH
                   ,NULL                                            AS FAB
                   ,LU.ATTRIBUTE3                                   AS STAGE
                   ,NULL                                            AS IS_INFINITE
                   ,NULL                                            AS IS_PURCHASED
                   ,NULL                                            AS PURCHASE_PERIOD
                   ,NULL                                            AS IS_NO_CARRY
                   ,NULL                                            AS STORAGE_ID
                   ,NULL                                            AS STORAGE_PER
                   ,NULL                                            AS SETUP_ID
                   ,NULL                                            AS SETUP_GROUP_ID
                   ,NULL                                            AS ITEM_GROUP_ID
                   ,NULL                                            AS INCOTERMS
                   ,NULL                                            AS PROJECT_CODE
                   ,LU.ATTRIBUTE3                                   AS STAGE
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS  WITH(NOLOCK) 
                    ON  ITS.PLAN_ID     = @V_PLAN_ID
                    AND ITS.BUFFER_ID   = LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3
            WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
            AND     VALID_YN    = 'Y'
            AND     SEGMENT3    = @V_GROUP_ID
            AND     ITS.PLAN_ID    IS NULL
            GROUP BY LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3

            ------------------------------------------------------------------------
            -- Item SIte 가 없는 INCOMING STOCK 은 ITEM_CLASS_ID = 'STOCK' 으로 추가
            --> ITEM_SITE를 만들어두고 없는애를 찾아야하기 때문에 INSERT를 끊어서 진행
            ------------------------------------------------------------------------ 
            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                              ,BUFFER_ID	
                                              ,SITE_ID	
                                              ,ITEM_ID	
                                              ,GRADE	
                                              ,SITE_TYPE	
                                              ,ITEM_CLASS_ID	
                                              ,INCH	
                                              ,FAB	
                                              ,STAGE	
                                              ,IS_INFINITE	
                                              ,IS_PURCHASED	
                                              ,PURCHASE_PERIOD	
                                              ,IS_NO_CARRY	
                                              ,STORAGE_ID	
                                              ,STORAGE_PER	
                                              ,SETUP_ID	
                                              ,SETUP_GROUP_ID	
                                              ,ITEM_GROUP_ID
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
                                             )
            SELECT @V_PLAN_ID                            AS PLAN_ID
                  ,A.BUFFER_ID                           AS BUFFER_ID
                  ,A.ATTRIBUTE1                          AS SITE_ID
                  ,A.ATTRIBUTE2                          AS ITEM_ID
                  ,CASE WHEN A.ATTRIBUTE3 LIKE '%BIZ%' THEN SUBSTRING(BUFFER_ID, dbo.FN_CHARINDEX_REV(BUFFER_ID, '::', 0) + 2, 1000)
				        ELSE A.ATTRIBUTE3			  
				   END                                   AS GRADE
                  ,NULL                                  AS SITE_TYPE
                  ,'STOCK'                               AS ITEM_CLASS_ID
                  ,NULL                                  AS INCH
                  ,NULL                                  AS FAB
                  ,A.ATTRIBUTE3                          AS STAGE
                  ,NULL                                  AS IS_INFINITE
                  ,NULL                                  AS IS_PURCHASED
                  ,NULL                                  AS PURCHASE_PERIOD
                  ,NULL                                  AS IS_NO_CARRY
                  ,NULL                                  AS STORAGE_ID
                  ,NULL                                  AS STORAGE_PER
                  ,NULL                                  AS SETUP_ID
                  ,NULL                                  AS SETUP_GROUP_ID
                  ,NULL                                  AS ITEM_GROUP_ID
                  ,A.ATTRIBUTE4                          AS INCOTERMS
                  ,A.ATTRIBUTE5                          AS PROJECT_CODE
                  ,A.ATTRIBUTE3                          AS ATTRIBUTE3
			FROM   SCP_OPT_ENG_INCOMING_STOCK_SN    A        WITH(NOLOCK)
            INNER JOIN SCP_MST_FINAL_ITEM B WITH(NOLOCK) ON  A.ATTRIBUTE2 = B.ITEM_ID
                                                         AND B.DIVISION_ID= @V_DIVISION_ID
			WHERE  1=1
			AND    A.PLAN_ID = @V_PLAN_ID
			AND    A.BUFFER_ID IN (
								SELECT BUFFER_ID FROM SCP_OPT_ENG_INCOMING_STOCK_SN WITH(NOLOCK) WHERE PLAN_ID = @V_PLAN_ID
								EXCEPT
								SELECT BUFFER_ID FROM SCP_OPT_ENG_ITEM_SITE_SN      WITH(NOLOCK) WHERE PLAN_ID = @V_PLAN_ID
							   )
            GROUP BY A.BUFFER_ID,A.ATTRIBUTE1,A.ATTRIBUTE2,A.ATTRIBUTE3,B.NICK_NAME,A.ATTRIBUTE4,A.ATTRIBUTE5 --MEB 테스트하면 KEY 중복에러 발생해서 추가하였음, KTH

            ------------------------------------------------------------------------
            -- 전진 검사를 위한 BUFFER 추가
            -- 2025.05.12 Philsu Park: 기 존재하는 Item Site 정보는 제외하는 제약 추가.
            --                         LT 중복 제거를 위한 DISTINCT 처리.
            ------------------------------------------------------------------------ 
            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                                    ,BUFFER_ID	
                                                    ,SITE_ID	
                                                    ,ITEM_ID	
                                                    ,GRADE	
                                                    ,SITE_TYPE	
                                                    ,ITEM_CLASS_ID	
                                                    ,INCH	
                                                    ,FAB	
                                                    ,STAGE	
                                                    ,IS_INFINITE	
                                                    ,IS_PURCHASED	
                                                    ,PURCHASE_PERIOD	
                                                    ,IS_NO_CARRY	
                                                    ,STORAGE_ID	
                                                    ,STORAGE_PER	
                                                    ,SETUP_ID	
                                                    ,SETUP_GROUP_ID	
                                                    ,ITEM_GROUP_ID
                                                    ,ATTRIBUTE1
                                                    ,ATTRIBUTE2
                                                    ,ATTRIBUTE3
                                                    )
            SELECT  DISTINCT 
                    @V_PLAN_ID                                                                              AS PLAN_ID
                   ,LU.ATTRIBUTE3+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE2+'@'+LU.ATTRIBUTE9+'@'+LU.ATTRIBUTE10  AS BUFFER_ID
                   ,LU.ATTRIBUTE3                                                                           AS SITE_ID
                   ,LU.SEGMENT5                                                                             AS ITEM_ID
                   ,LU.ATTRIBUTE2+'@'+LU.ATTRIBUTE9+'@'+LU.ATTRIBUTE10                                      AS GRADE
                   ,NULL                                                                                    AS SITE_TYPE
                   ,'MATERIAL'                                                                              AS ITEM_CLASS_ID
                   ,NULL                                                                                    AS INCH
                   ,NULL                                                                                    AS FAB
                   ,LU.ATTRIBUTE2                                                                           AS STAGE
                   ,NULL                                                                                    AS IS_INFINITE
                   ,NULL                                                                                    AS IS_PURCHASED
                   ,NULL                                                                                    AS PURCHASE_PERIOD
                   ,NULL                                                                                    AS IS_NO_CARRY
                   ,NULL                                                                                    AS STORAGE_ID
                   ,NULL                                                                                    AS STORAGE_PER
                   ,NULL                                                                                    AS SETUP_ID
                   ,NULL                                                                                    AS SETUP_GROUP_ID
                   ,NULL                                                                                    AS ITEM_GROUP_ID
                   ,LU.ATTRIBUTE9                                                                           AS INCOTERMS
                   ,LU.ATTRIBUTE10                                                                          AS PROJECT_CODE
                   ,LU.ATTRIBUTE2                                                                           AS STAGE
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS  WITH(NOLOCK) 
                ON  ITS.PLAN_ID     = @V_PLAN_ID
                AND ITS.BUFFER_ID   = CONCAT(LU.ATTRIBUTE3,'::',LU.SEGMENT5,'::',LU.ATTRIBUTE2,'@',LU.ATTRIBUTE9,'@',LU.ATTRIBUTE10)
            WHERE   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
            AND     LU.SEGMENT4     = 'A'
            AND     LU.SEGMENT3     = @V_DIVISION_ID
            AND     LU.SEGMENT2     = @V_GROUP_ID
            AND     LU.VALID_YN     = 'Y'
            AND     ITS.PLAN_ID    IS NULL
            



            ------------------------------------------------------------------------
            -- SCHEDULED_MOVE에 있지만 ITEM_SITE에 없는 데이터 등록
            --> ITEM_SITE + INCOMMING STOCK에 없는 BUFFER를 만들어두고 없는 애를 찾아야하기 때문에 INSERT를 끊어서 진행
            ------------------------------------------------------------------------ 
            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                              ,BUFFER_ID	
                                              ,SITE_ID	
                                              ,ITEM_ID	
                                              ,GRADE	
                                              ,SITE_TYPE	
                                              ,ITEM_CLASS_ID	
                                              ,INCH	
                                              ,FAB	
                                              ,STAGE	
                                              ,IS_INFINITE	
                                              ,IS_PURCHASED	
                                              ,PURCHASE_PERIOD	
                                              ,IS_NO_CARRY	
                                              ,STORAGE_ID	
                                              ,STORAGE_PER	
                                              ,SETUP_ID	
                                              ,SETUP_GROUP_ID	
                                              ,ITEM_GROUP_ID
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
                                             )
            SELECT SM.PLAN_ID                      AS PLAN_ID
                  ,SM.FROM_BUFFER_ID               AS BUFFER_ID
                  ,SM.ATTRIBUTE1                   AS SITE_ID
                  ,SM.ATTRIBUTE2                   AS ITEM_ID
                  ,SM.ATTRIBUTE3                   AS GRADE
                  ,NULL                            AS SITE_TYPE
                  ,'SCHEDULED'                     AS ITEM_CLASS_ID
                  ,NULL                            AS INCH
                  ,NULL                            AS FAB
                  ,SM.ATTRIBUTE3                   AS STAGE
                  ,NULL                            AS IS_INFINITE
                  ,NULL                            AS IS_PURCHASED
                  ,NULL                            AS PURCHASE_PERIOD
                  ,NULL                            AS IS_NO_CARRY
                  ,NULL                            AS STORAGE_ID
                  ,NULL                            AS STORAGE_PER
                  ,NULL                            AS SETUP_ID
                  ,NULL                            AS SETUP_GROUP_ID
                  ,NULL                            AS ITEM_GROUP_ID
                  ,NULL                            AS INCOTERMS
                  ,NULL                            AS PROJECT_CODE
                  ,SM.ATTRIBUTE3                   AS ATTRIBUTE3
            FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS  WITH(NOLOCK) 
                    ON  ITS.PLAN_ID   = SM.PLAN_ID
                    AND ITS.BUFFER_ID = SM.FROM_BUFFER_ID
                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) ON  SM.ATTRIBUTE2 = FI.ITEM_ID
                                                              AND FI.DIVISION_ID= @V_DIVISION_ID
            WHERE   SM.PLAN_ID = @V_PLAN_ID
            AND     ITS.PLAN_ID IS NULL
            GROUP BY SM.PLAN_ID, SM.FROM_BUFFER_ID, SM.ATTRIBUTE1, SM.ATTRIBUTE2, SM.ATTRIBUTE3, FI.NICK_NAME
            UNION ALL
            SELECT SM.PLAN_ID                      AS PLAN_ID
                  ,SM.TO_BUFFER_ID                 AS BUFFER_ID
                  ,SM.ATTRIBUTE4                   AS SITE_ID
                  ,SM.ATTRIBUTE2                   AS ITEM_ID
                  ,SM.ATTRIBUTE5+'@'+SM.ATTRIBUTE9+'@'+SM.ATTRIBUTE10 AS GRADE
                  ,NULL                            AS SITE_TYPE
                  ,'SCHEDULED'                     AS ITEM_CLASS_ID
                  ,NULL                            AS INCH
                  ,NULL                            AS FAB
                  ,SM.ATTRIBUTE5                   AS STAGE
                  ,NULL                            AS IS_INFINITE
                  ,NULL                            AS IS_PURCHASED
                  ,NULL                            AS PURCHASE_PERIOD
                  ,NULL                            AS IS_NO_CARRY
                  ,NULL                            AS STORAGE_ID
                  ,NULL                            AS STORAGE_PER
                  ,NULL                            AS SETUP_ID
                  ,NULL                            AS SETUP_GROUP_ID
                  ,NULL                            AS ITEM_GROUP_ID
                  ,SM.ATTRIBUTE9                   AS INCOTERMS
                  ,SM.ATTRIBUTE10                  AS PROJECT_CODE
                  ,SM.ATTRIBUTE5                   AS ATTRIBUTE3
            FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS  WITH(NOLOCK) 
                    ON  ITS.PLAN_ID   = SM.PLAN_ID
                    AND ITS.BUFFER_ID = SM.TO_BUFFER_ID
                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                    ON  SM.ATTRIBUTE2 = FI.ITEM_ID
                    AND FI.DIVISION_ID= @V_DIVISION_ID
            WHERE   SM.PLAN_ID = @V_PLAN_ID
            AND     ITS.PLAN_ID IS NULL
            GROUP BY SM.PLAN_ID, SM.TO_BUFFER_ID, SM.ATTRIBUTE4, SM.ATTRIBUTE2, SM.ATTRIBUTE5, SM.ATTRIBUTE9, FI.NICK_NAME, SM.ATTRIBUTE10

        ------------------------------------------------------------------------
        -- 형 교환 NICK NAME UPDATE -> LOOKUP DATA 기준
        ------------------------------------------------------------------------ 
        UPDATE  SCP_OPT_ENG_ITEM_SITE_SN
                SET SETUP_GROUP_ID = LU.SEGMENT5
        FROM    SCP_OPT_ENG_ITEM_SITE_SN EIS WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_NICK_FOR_SETUP'
                AND LU.SEGMENT1 = @V_DIVISION_ID
                AND LU.SEGMENT2 = @V_GROUP_ID
                AND EIS.SITE_ID = LU.SEGMENT3
                AND EIS.ITEM_ID = LU.SEGMENT4
        WHERE   1=1
        AND     EIS.PLAN_ID = @V_PLAN_ID
        AND     EIS.ITEM_CLASS_ID = 'PRODUCTION'


        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

		IF OBJECT_ID('TEMPDB..#PRODUCTION') IS NOT NULL
		BEGIN 
			DROP TABLE  #PRODUCTION;
		END;

        ------------------------------------------------------------------------
        -- STAGE가 ASSY, ASY_AGING이고, 소형에 대해서는 IS NO CARRY를 1로 수정함 -> 변책임님 요청사항
        -- 자동차 및 다른 부분 수정 가능
        ------------------------------------------------------------------------ 
        UPDATE SCP_OPT_ENG_ITEM_SITE_SN
        SET    IS_NO_CARRY = '1'
        FROM SCP_OPT_ENG_ITEM_SITE_SN WITH(NOLOCK)
        WHERE   1=1
        AND     PLAN_ID = @V_PLAN_ID
        AND     @V_DIVISION_ID = '40'
        AND     STAGE IN('ASSY','ASY_AGING')
        ------------------------------------------------------------------------
        -- 자동차의 경우 LOOKUP에 등록한 대상에 대해서만 IS NO CARRY를 1로 수정함 -> 남혁선임님 요청사항
        ------------------------------------------------------------------------ 
        UPDATE  SCP_OPT_ENG_ITEM_SITE_SN
        SET     SCP_OPT_ENG_ITEM_SITE_SN.IS_NO_CARRY = '1'
        FROM    SCP_OPT_ENG_ITEM_SITE_SN ISS WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  1=1
                AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_ISNOCARRY'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND LU.VALID_YN    = 'Y'
                AND ISS.SITE_ID    = LU.SEGMENT3
                AND ISS.ITEM_ID    = LU.SEGMENT4
                AND ISS.STAGE      = LU.SEGMENT5
        WHERE   ISS.PLAN_ID = @V_PLAN_ID

        ------------------------------------------------------------------------
        -- LINE FULL LOADING 제약이 있으면 DINAMIC RAMP UP 적용을 위해 IDLE 데이터 추가
        -- 2025-07-29 THK
        ------------------------------------------------------------------------ 
        INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID
                                            ,BUFFER_ID
                                            ,SITE_ID
                                            ,ITEM_ID
                                            ,GRADE
                                            ,ITEM_CLASS_ID
                                            ,STAGE
                                            ,ATTRIBUTE3
                                            )
        SELECT  @V_PLAN_ID              AS PLAN_ID
               ,SEGMENT3+'::IDLE::IDLE' AS BUFFER_ID
               ,SEGMENT3                AS SITE_ID
               ,'IDLE'                  AS ITEM_ID
               ,'IDLE'                  AS GRADE
               ,'PRODUCTION'            AS ITEM_CLASS_ID
               ,'IDLE'                  AS STAGE
               ,'IDLE'                  AS ATTRIBUTE3
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK) 
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     VALID_YN    = 'Y'

	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_ESS_RUN_MAIN_PROC;
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

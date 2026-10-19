


CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_SCHEDULED_MOVE]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    ,@T_SCP_PLAN            optTableType_SCP_PLAN READONLY
AS 
BEGIN
    --2025.02.14 Taehyun Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_SCHEDULED_MOVE';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @V_SHIP_FROZEN       INT;

    DECLARE @DM_TEMP TABLE(
     SITE_ID      NVARCHAR(100)
    ,ITEM_ID      NVARCHAR(100)
    ,INCOTERMS    NVARCHAR(100)
    ,PROJECT_CODE NVARCHAR(100)
    )

    DECLARE @SM_TEMP TABLE(
     PLAN_ID           NVARCHAR(100)
    ,SHIPPING_ORDER_ID NVARCHAR(100)
    ,FROM_BUFFER_ID    NVARCHAR(100)
    ,TO_BUFFER_ID      NVARCHAR(100)
    ,DEPARTURE_DATE    NVARCHAR(100)
    ,ARRIVAL_DATE      NVARCHAR(100)
    ,TRANSPORT_MODE    NVARCHAR(100)
    ,QTY               NUMERIC(20,0)
    ,RESOURCE_ID       NVARCHAR(100)
    ,LOAD_PER          NVARCHAR(100)
    ,FROM_SITE         NVARCHAR(100)
    ,ITEM_ID           NVARCHAR(100)
    ,FROM_STAGE        NVARCHAR(100)
    ,TO_SITE           NVARCHAR(100)
    ,TO_STAGE_SEMI     NVARCHAR(100)
    ,FENCE_IN_OUT      NVARCHAR(100)
    ,BOD_ID            NVARCHAR(100)
    ,SITE_TYPE         NVARCHAR(100)
    ,INCOTERMS         NVARCHAR(100)
    ,PROJECT_CODE      NVARCHAR(100)
    )

	-- 임시 : 아래 변수 수정 처리 필요
    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_SEQ    NVARCHAR(200)

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
		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		IF OBJECT_ID('TEMPDB..#SHIP_FROZEN') IS NOT NULL
		BEGIN 
			DROP TABLE  #SHIP_FROZEN;
		END;

		SELECT DIVISION_ID 
		INTO #DIVISION
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN = 'Y'
		AND    ATTRIBUTE3 <> 'EE'
		AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;
		
	    -- 전극 Plan Type 확인
		SELECT @V_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD
		     , @V_SCP_PLAN_TYPE = A.PLAN_TYPE
		     , @V_SCP_PLAN_SEQ  = A.PLAN_SEQ
        FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
		            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_TYPE_ORDER DESC, PLAN_SEQ DESC ) AS PLAN_RANK
               FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
			   -- 전극 Division 에 해당하는 사업부 확인
               WHERE  DIVISION_ID          = @V_DIVISION_ID -- 전극 Division 변수
               AND    PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 전주 월요일 YYYYMMDD
               AND    PLAN_START_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,  -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 당주 월요일 YYYYMMDD
              ) A   
        WHERE PLAN_RANK = 1 

		-- PR_SCP_OPT_ENG_GM_EE_INPUT_BOD 에서도 사용 : 전극만 사용하는 Lookup 임
		SELECT SEGMENT2 AS ITEM_ID
		     , SEGMENT3 AS FROM_SITE
		     , SEGMENT4 AS TO_SITE
		     , CONVERT(INT, SEGMENT5) AS SHIP_FROZEN
		INTO #SHIP_FROZEN
		FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		WHERE  LOOKUP_TYPE = 'SCP_OPT_ELEC_SHIP_FROZEN'
		AND    VALID_YN    = 'Y'
		AND    SEGMENT1    = @V_DIVISION_ID -- 전극 Division 변수
		
		--SELECT  @V_SHIP_FROZEN = SEGMENT4
		--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--WHERE   LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
		--AND     VALID_YN    = 'Y'
		--AND     SEGMENT1    = @V_DIVISION_ID
		--AND     SEGMENT2    = @V_GROUP_ID
  --      --AND     SEGMENT3    = 'PR' --임시
  --      AND     SEGMENT3    = @V_SCP_PLAN_TYPE

        --------------------------------------------------------
        -- PROJECT CODE UPDATE 용도
        -- INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준
        --------------------------------------------------------
        INSERT INTO @DM_TEMP
        SELECT SITE_ID
              ,ITEM_ID
              ,INCOTERMS
              ,PROJECT_CODE
        FROM(
            SELECT SITE_ID
                  ,ITEM_ID
                  ,INCOTERMS
                  ,PROJECT_CODE
                  ,ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,INCOTERMS,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
            FROM(
                 SELECT ATTRIBUTE1    AS SITE_ID
                       ,ATTRIBUTE2    AS ITEM_ID
                       ,ATTRIBUTE4    AS INCOTERMS
                       ,ATTRIBUTE5    AS PROJECT_CODE
                       ,MIN(DUE_DATE) AS MIN_DUE          
                 FROM SCP_OPT_ENG_DEMAND_SN WITH(NOLOCK) 
                 WHERE   PLAN_ID = @V_PLAN_ID
                 AND     ATTRIBUTE5 IS NOT NULL --PROJECT_CODE
                 AND     ATTRIBUTE4 IS NOT NULL --INCOTERMS
                 GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5
                 ) DM
            ) RM
        WHERE ROW_NUM =1
        UNION ALL
        SELECT SITE_ID
              ,ITEM_ID
              ,INCOTERMS
              ,PROJECT_CODE
        FROM(
            SELECT SITE_ID
                  ,ITEM_ID
                  ,INCOTERMS
                  ,PROJECT_CODE
                  ,ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
            FROM(
                 SELECT ATTRIBUTE1    AS SITE_ID
                       ,ATTRIBUTE2    AS ITEM_ID
                       ,NULL          AS INCOTERMS
                       ,ATTRIBUTE5    AS PROJECT_CODE
                       ,MIN(DUE_DATE) AS MIN_DUE          
                 FROM SCP_OPT_ENG_DEMAND_SN WITH(NOLOCK) 
                 WHERE   PLAN_ID = @V_PLAN_ID
                 AND     ATTRIBUTE5 IS NOT NULL
                 AND     ATTRIBUTE4 IS NULL
                 GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE5
                 ) DM
            ) RM
        WHERE ROW_NUM =1
    -------------------------------------------------
    -- 임시 적용 : SCP 정보 사용 : START
	-------------------------------------------------
        INSERT INTO @SM_TEMP
        SELECT @V_PLAN_ID                             AS PLAN_ID
              ,SHIPPING_ORDER_ID                      AS SHIPPING_ORDER_ID
              ,FROM_SITE+'::'+ITEM_ID+'::'+FROM_STAGE AS FROM_BUFFER_ID
              ,TO_SITE+'::'+ITEM_ID+'::'+TO_STAGE     AS TO_BUFFER_ID
              ,DEPARTURE_DATE                         AS DEPARTURE_DATE
              ,ARRIVAL_DATE                           AS ARRIVAL_DATE
              ,TRANSPORT_MODE                         AS TRANSPORT_MODE
              ,QTY                                    AS QTY
              ,NULL                                   AS RESOURCE_ID
              ,NULL                                   AS LOAD_PER
              ,FROM_SITE                              AS FROM_SITE    
              ,ITEM_ID                                AS ITEM_ID      
              ,FROM_STAGE                             AS FROM_STAGE   
              ,TO_SITE                                AS TO_SITE      
              ,TO_STAGE_SEMI                          AS TO_STAGE_SEMI
              ,'IN'                                   AS FENCE_IN_OUT -- OUT DATA를 넣어줄 때 확정 구간 내에있는 데이터를 구분하기 위한 FLAG
              ,BOD_ID                                 AS BOD_ID       
              ,SITE_TYPE                              AS SITE_TYPE    
              ,INCOTERMS                              AS INCOTERMS    
              ,PROJECT_CODE                           AS PROJECT_CODE
        FROM(
            SELECT  ROW_NUMBER() OVER(ORDER BY ITEM_ID) AS SHIPPING_ORDER_ID
                   ,FROM_SITE         AS FROM_SITE
                   ,TO_SITE           AS TO_SITE
                   ,TRANSPORT_MODE    AS TRANSPORT_MODE
                   ,ITEM_ID           AS ITEM_ID
                   ,FROM_STAGE        AS FROM_STAGE
                   ,TO_STAGE          AS TO_STAGE
                   ,DEPARTURE_DATE    AS DEPARTURE_DATE
                   ,ARRIVAL_DATE      AS ARRIVAL_DATE
                   ,SUM(QTY)          AS QTY
                   ,BOD_ID            AS BOD_ID
                   ,SITE_TYPE         AS SITE_TYPE
                   ,INCOTERMS         AS INCOTERMS
                   ,TO_STAGE_SEMI     AS TO_STAGE_SEMI
                   ,PROJECT_CODE      AS PROJECT_CODE
            FROM (
				  -- Shipment Plan FG : Sales 향
			        SELECT   NULL                         AS SHIPPING_ORDER_ID
            				,A.FROM_SITE                          AS FROM_SITE
            				,A.TO_SITE                            AS TO_SITE
            				,B.TRANSPORT_MODE                     AS TRANSPORT_MODE
            				,A.ITEM_ID                            AS ITEM_ID
                            ,B.BOD_ID                             AS BOD_ID
                            ,TS.SITE_TYPE                         AS SITE_TYPE
                            ,B.INCOTERMS                          AS INCOTERMS
            				--,'CHAR'                             AS FROM_STAGE
            				--,'CELL BIZ'                         AS TO_STAGE
							
                			,'ELEC_POST'                      AS FROM_STAGE
                			,'ELECBIZ' + '@' + B.INCOTERMS    AS TO_STAGE
                			,'ELECBIZ'                        AS TO_STAGE_SEMI -- ATTRIBUTE 저장을 위한 INCOTERMS제거

            				,A.YYYYMMDD                           AS DEPARTURE_DATE
            				,CONVERT(CHAR(8), DATEADD(DD, ISNULL(B.LT_TOTAL, 0), CONVERT(DATETIME, A.YYYYMMDD)), 112)  AS ARRIVAL_DATE
            				,A.QTY
                            ,A.PROJECT_CODE
					FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH (NOLOCK) 

					INNER JOIN SCP_MST_BOD_N_V B WITH (NOLOCK)
					ON  B.DIVISION_ID    = A.ORIGIN_FROM_DIVISION_ID
					AND B.BOD_ID         = A.BOD_ID
					AND B.FROM_YYYYMMDD <= A.YYYYMMDD    --유효한 기간의 BOD
					AND B.TO_YYYYMMDD   >= A.YYYYMMDD    --유효한 기간의 BOD
						   
					INNER JOIN SCM_MST_SITE FS WITH (NOLOCK) 
					ON  A.ORIGIN_FROM_DIVISION_ID = FS.DIVISION_ID
					AND A.FROM_SITE               = FS.SCM_SITE_ID
					AND FS.SITE_TYPE              = 'PLANT'
					AND FS.VALID_YN               = 'Y'		
					AND FS.OPERATION_GROUP       IN ('E')

					INNER JOIN SCM_MST_SITE TS WITH (NOLOCK) 
					ON  A.ORIGIN_TO_DIVISION_ID = TS.DIVISION_ID
					AND A.TO_SITE               = TS.SCM_SITE_ID
					AND TS.SITE_TYPE            = 'SALES'
					AND TS.VALID_YN             = 'Y'

					 LEFT JOIN #SHIP_FROZEN SF WITH(NOLOCK)
					 ON  A.FROM_SITE = SF.FROM_SITE
                     AND A.TO_SITE   = SF.TO_SITE
                     AND A.ITEM_ID   = SF.ITEM_ID	
					
					WHERE A.DIVISION_ID         = @V_DIVISION_ID -- EE : 전극 Plan Division
					AND   A.PLAN_START_YYYYMMDD = @V_SCP_PLAN_DATE
					AND   A.PLAN_TYPE           = @V_SCP_PLAN_TYPE
					AND   A.SEQ                 = @V_SCP_PLAN_SEQ
					AND   A.measure             = 'SHIP_PLAN_AMEND'
					AND   A.QTY                 >  0   
					AND   A.YYYYMMDD           >= @V_SCP_PLAN_DATE  
					AND   A.YYYYMMDD           <  CONVERT(NVARCHAR(8),DATEADD(DD, ISNULL(SF.SHIP_FROZEN, 0), @V_SCP_PLAN_DATE ),112)
					--AND   A.YYYYMMDD           <  DATEADD(DD, ISNULL(@V_SHIP_FROZEN, 0), @V_SCP_PLAN_DATE )
					/************************* 
					대상 프로젝트 ITEM 필터링 
					*************************/
					AND CONCAT(A.FROM_SITE, A.ITEM_ID) 
						IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
							FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
							WHERE  PLAN_ID = @V_PLAN_ID
						   ) 

				  -- Shipment Plan Semi : Cell Plant 향
                  UNION ALL
			        SELECT   NULL                         AS SHIPPING_ORDER_ID
            				,A.FROM_SITE                          AS FROM_SITE
            				,A.TO_SITE                            AS TO_SITE
            				,B.TRANSPORT_MODE                     AS TRANSPORT_MODE
            				,A.ITEM_ID                            AS ITEM_ID
                            ,B.BOD_ID                             AS BOD_ID
                            ,TS.SITE_TYPE                         AS SITE_TYPE
                            ,B.INCOTERMS                          AS INCOTERMS
            				--,'CHAR'                             AS FROM_STAGE
            				--,'CELL BIZ'                         AS TO_STAGE
							
                			,'ELEC_POST'                          AS FROM_STAGE
                			,'TARGETBIZ' + '@' + B.INCOTERMS AS TO_STAGE
                			,'TARGETBIZ'                     AS TO_STAGE_SEMI -- ATTRIBUTE 저장을 위한 INCOTERMS제거

            				,A.YYYYMMDD                           AS DEPARTURE_DATE
            				,CONVERT(CHAR(8), DATEADD(DD, ISNULL(B.LT_TOTAL, 0), CONVERT(DATETIME, A.YYYYMMDD)), 112)  AS ARRIVAL_DATE
            				,A.QTY
                            ,'-' AS PROJECT_CODE -- UNION을 위한 값이며, 실제로 BUFFER_ID에 넣진 않음.
					FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK) 

					INNER JOIN SCP_MST_BOD_N_V B WITH (NOLOCK)
					ON  B.DIVISION_ID    = A.ORIGIN_FROM_DIVISION_ID
					AND B.BOD_ID         = A.BOD_ID
					AND B.FROM_YYYYMMDD <= A.YYYYMMDD    --유효한 기간의 BOD
					AND B.TO_YYYYMMDD   >= A.YYYYMMDD    --유효한 기간의 BOD

					INNER JOIN SCM_MST_SITE FS WITH (NOLOCK) 
					ON  A.ORIGIN_FROM_DIVISION_ID = FS.DIVISION_ID
					AND A.FROM_SITE               = FS.SCM_SITE_ID
					AND FS.SITE_TYPE              = 'PLANT'
					AND FS.VALID_YN               = 'Y'		
					AND FS.OPERATION_GROUP       IN ('E')

					INNER JOIN SCM_MST_SITE TS WITH (NOLOCK) 
					ON  A.ORIGIN_TO_DIVISION_ID = TS.DIVISION_ID
					AND A.TO_SITE               = TS.SCM_SITE_ID
					AND TS.SITE_TYPE            = 'PLANT'
					AND TS.VALID_YN             = 'Y'
					AND TS.OPERATION_GROUP     IN ('A')

					 LEFT JOIN #SHIP_FROZEN SF WITH(NOLOCK)
					 ON  A.FROM_SITE = SF.FROM_SITE
                     AND A.TO_SITE   = SF.TO_SITE
                     AND A.ITEM_ID   = SF.ITEM_ID	
					
					WHERE A.DIVISION_ID         = @V_DIVISION_ID  -- EE : 전극 Plan Division
					AND   A.PLAN_START_YYYYMMDD = @V_SCP_PLAN_DATE
					AND   A.PLAN_TYPE           = @V_SCP_PLAN_TYPE
					AND   A.SEQ                 = @V_SCP_PLAN_SEQ
					AND   A.measure             = 'SHIP_PLAN_AMEND'
					AND   A.QTY                 >  0   
					AND   A.YYYYMMDD           >= @V_SCP_PLAN_DATE  
					AND   A.YYYYMMDD           <  CONVERT(NVARCHAR(8),DATEADD(DD, ISNULL(SF.SHIP_FROZEN, 0), @V_SCP_PLAN_DATE ),112)
					--AND   A.YYYYMMDD           <  DATEADD(DD, ISNULL(@V_SHIP_FROZEN, 0), @V_SCP_PLAN_DATE )
					/************************* 
					대상 프로젝트 ITEM 필터링 
					*************************/
					AND CONCAT(A.FROM_SITE, A.ITEM_ID) 
						IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
							FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
							WHERE  PLAN_ID = @V_PLAN_ID
						   ) 

            	  ) AA
            GROUP BY SHIPPING_ORDER_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, ITEM_ID, FROM_STAGE, TO_STAGE, DEPARTURE_DATE, ARRIVAL_DATE, BOD_ID, SITE_TYPE, INCOTERMS,TO_STAGE_SEMI,PROJECT_CODE
            ) A
    -------------------------------------------------
    --PROJECT CODE가 없는 데이터 DEMAND에서 찾아서 UPDATE
	-------------------------------------------------
    UPDATE @SM_TEMP
    SET PROJECT_CODE = DJ.PROJECT_CODE
    FROM @SM_TEMP SMT
        INNER JOIN (
                    SELECT SMT.PLAN_ID           
                          ,SMT.SHIPPING_ORDER_ID 
                          ,SMT.FROM_BUFFER_ID    
                          ,SMT.TO_BUFFER_ID      
                          ,SMT.DEPARTURE_DATE    
                          ,SMT.ARRIVAL_DATE      
                          ,SMT.TRANSPORT_MODE    
                          ,SMT.QTY               
                          ,SMT.RESOURCE_ID       
                          ,SMT.LOAD_PER          
                          ,SMT.FROM_SITE         
                          ,SMT.ITEM_ID           
                          ,SMT.MDF_ITEM_ID
                          ,SMT.FROM_STAGE        
                          ,SMT.TO_SITE           
                          ,SMT.TO_STAGE_SEMI     
                          ,SMT.FENCE_IN_OUT      
                          ,SMT.BOD_ID            
                          ,SMT.SITE_TYPE         
                          ,SMT.INCOTERMS         
                          ,DT.PROJECT_CODE
                    FROM(
                         SELECT PLAN_ID           
                               ,SHIPPING_ORDER_ID 
                               ,FROM_BUFFER_ID    
                               ,TO_BUFFER_ID      
                               ,DEPARTURE_DATE    
                               ,ARRIVAL_DATE      
                               ,TRANSPORT_MODE    
                               ,QTY               
                               ,RESOURCE_ID       
                               ,LOAD_PER          
                               ,FROM_SITE         
                               ,ITEM_ID           
                               ,IIF(LU.SEGMENT3 IS NULL, SMT.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                               ,FROM_STAGE        
                               ,TO_SITE           
                               ,TO_STAGE_SEMI     
                               ,FENCE_IN_OUT      
                               ,BOD_ID            
                               ,SITE_TYPE         
                               ,INCOTERMS         
                               ,PROJECT_CODE      
                         FROM    @SM_TEMP SMT
                             LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                 ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                 AND LU.SEGMENT2 = @V_DIVISION_ID
                                 AND SMT.ITEM_ID = LU.SEGMENT3
                                 AND LU.VALID_YN = 'Y'
                         WHERE   1=1
                         AND     SMT.PROJECT_CODE = '-'
                         ) SMT
                        INNER JOIN @DM_TEMP DT
                            ON  SMT.TO_SITE = DT.SITE_ID
                            AND SMT.MDF_ITEM_ID     = DT.ITEM_ID
                            AND (   (SMT.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                 OR (SMT.INCOTERMS = DT.INCOTERMS)
                                 OR (SMT.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                )
                    ) DJ
            ON  SMT.PLAN_ID                = DJ.PLAN_ID          
            AND SMT.SHIPPING_ORDER_ID      = DJ.SHIPPING_ORDER_ID
            AND SMT.FROM_BUFFER_ID         = DJ.FROM_BUFFER_ID   
            AND SMT.TO_BUFFER_ID           = DJ.TO_BUFFER_ID     
            AND SMT.DEPARTURE_DATE         = DJ.DEPARTURE_DATE   
            AND SMT.ARRIVAL_DATE           = DJ.ARRIVAL_DATE     
            AND SMT.TRANSPORT_MODE         = DJ.TRANSPORT_MODE   
            AND SMT.QTY                    = DJ.QTY              
            AND ISNULL(SMT.RESOURCE_ID,'') = ISNULL(DJ.RESOURCE_ID,'')
            AND ISNULL(SMT.LOAD_PER   ,'') = ISNULL(DJ.LOAD_PER   ,'')
            AND SMT.FROM_SITE              = DJ.FROM_SITE        
            AND SMT.ITEM_ID                = DJ.ITEM_ID          
            AND SMT.FROM_STAGE             = DJ.FROM_STAGE       
            AND SMT.TO_SITE                = DJ.TO_SITE          
            AND SMT.TO_STAGE_SEMI          = DJ.TO_STAGE_SEMI    
            AND SMT.FENCE_IN_OUT           = DJ.FENCE_IN_OUT     
            AND SMT.BOD_ID                 = DJ.BOD_ID           
            AND SMT.SITE_TYPE              = DJ.SITE_TYPE        
            AND SMT.INCOTERMS              = DJ.INCOTERMS        

    -------------------------------------------------
    --TO_BUFFER에 PROJECT_CODE 추가해서 INSERT
	-------------------------------------------------
    INSERT INTO SCP_OPT_ENG_SCHEDULED_MOVE_SN( PLAN_ID
                                           ,SHIPPING_ORDER_ID
                                           ,FROM_BUFFER_ID
                                           ,TO_BUFFER_ID
                                           ,DEPARTURE_DATE
                                           ,ARRIVAL_DATE
                                           ,TRANSPORT_MODE
                                           ,QUANTITY
                                           ,RESOURCE_ID
                                           ,LOAD_PER
                                           ,ATTRIBUTE1
                                           ,ATTRIBUTE2
                                           ,ATTRIBUTE3
                                           ,ATTRIBUTE4
                                           ,ATTRIBUTE5
                                           ,ATTRIBUTE6
                                           ,ATTRIBUTE7
                                           ,ATTRIBUTE8
                                           ,ATTRIBUTE9
                                           ,ATTRIBUTE10
                                          )
    SELECT  PLAN_ID          
           ,SHIPPING_ORDER_ID
           ,FROM_BUFFER_ID   
           ,TO_BUFFER_ID+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)
           ,DEPARTURE_DATE   
           ,ARRIVAL_DATE     
           ,TRANSPORT_MODE   
           ,QTY              
           ,RESOURCE_ID      
           ,LOAD_PER         
           ,FROM_SITE        
           ,ITEM_ID       
           ,FROM_STAGE       
           ,TO_SITE          
           ,TO_STAGE_SEMI    
           ,FENCE_IN_OUT     
           ,BOD_ID           
           ,SITE_TYPE        
           ,INCOTERMS        
           ,PROJECT_CODE
    FROM    @SM_TEMP
    WHERE   1=1
    AND     FROM_BUFFER_ID IS NOT NULL
    AND     TO_BUFFER_ID   IS NOT NULL
    -------------------------------------------------
    -- PACKING EQUIPMENT CONSTRAINTS UPDATE
    -- 2025.12.01 Minyong Lee : 5.20부 변경된 로직으로 주석처리
	-------------------------------------------------
    --UPDATE SCP_OPT_ENG_SCHEDULED_MOVE_SN
    --SET SCP_OPT_ENG_SCHEDULED_MOVE_SN.RESOURCE_ID = PE.FROM_SITE_ID +'::PACKING_EQUIPMENT@'+ STAGE
    --,   SCP_OPT_ENG_SCHEDULED_MOVE_SN.LOAD_PER    =  1
    --FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN WITH(NOLOCK)
    --    INNER JOIN(
    --              SELECT SEGMENT3                      AS ITEM_ID
    --                    ,SEGMENT4                      AS FROM_SITE_ID
    --                    ,SEGMENT5                      AS STAGE
    --                    ,'PACKING_EQUIPMENT@'+SEGMENT5 AS RESOURCE_NAME
    --                    ,ATTRIBUTE1                      AS TO_SITE_ID
    --                    ,ATTRIBUTE2                    AS FROM_DATE
    --                    ,ATTRIBUTE3                    AS TO_DATE
    --                    ,ATTRIBUTE4                    AS LOWER_VALUE
    --                    ,ATTRIBUTE5                    AS UPPER_VALUE
    --              FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
    --              WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
    --              AND    VALID_YN    = 'Y'
    --              AND    SEGMENT2    = @V_DIVISION_ID
    --              ) AS PE
    --    ON  SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE1 = PE.FROM_SITE_ID
    --    AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE2 = PE.ITEM_ID
    --    AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE3 = PE.STAGE
    --    AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE4 = PE.TO_SITE_ID
    --WHERE SCP_OPT_ENG_SCHEDULED_MOVE_SN.PLAN_ID = @V_PLAN_ID
    -------------------------------------------------
    -- 임시 적용 : SCP 정보 사용 : END
	-------------------------------------------------

    ------------------------------------------------------------------------
    -- 2nd OCV 적용을 위해 STAGE 변경
    ------------------------------------------------------------------------
    UPDATE  SCP_OPT_ENG_SCHEDULED_MOVE_SN
    SET     SCP_OPT_ENG_SCHEDULED_MOVE_SN.FROM_BUFFER_ID = SM.ATTRIBUTE1+'::'+SM.ATTRIBUTE2+'::'+LU.ATTRIBUTE3
           ,SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE3     = LU.ATTRIBUTE3
    FROM    SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
        INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
            AND LU.VALID_YN   = 'Y'
            AND LU.ATTRIBUTE1 = 'B'
            AND LU.SEGMENT2   = @V_DIVISION_ID
            AND LU.SEGMENT3   = @V_GROUP_ID
            AND SM.ATTRIBUTE1 = LU.SEGMENT4
            AND SM.ATTRIBUTE2 = LU.SEGMENT5
    WHERE   SM.PLAN_ID = @V_PLAN_ID
    AND     SM.DEPARTURE_DATE > CONVERT(NVARCHAR(8),DATEADD(DAY,CONVERT(INT,LU.ATTRIBUTE10),@V_PLAN_START_YYYYMMDD),112)

        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		IF OBJECT_ID('TEMPDB..#SHIP_FROZEN') IS NOT NULL
		BEGIN 
			DROP TABLE  #SHIP_FROZEN;
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

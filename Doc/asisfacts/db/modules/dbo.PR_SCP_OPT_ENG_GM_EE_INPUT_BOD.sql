

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_BOD]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    ,@T_SCP_PLAN            optTableType_SCP_PLAN READONLY
AS 
BEGIN
    --2025.02.11 TAEHYUN Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_BOD';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;
    DECLARE @V_SHIP_FROZEN       INT;
    DECLARE @BOD_TMP TABLE(
     PLAN_ID             NVARCHAR(50)
    ,BOD_ID              NVARCHAR(200)
    ,FROM_BUFFER_ID      NVARCHAR(100)
    ,TO_BUFFER_ID        NVARCHAR(100)
    ,TRANSPORT_MODE      NVARCHAR(50)
    ,PRIORITY            NUMERIC(20,0)
    ,TRANSIT_COST        NUMERIC(20,0)
    ,EFF_START_DATE      NVARCHAR(50)
    ,EFF_END_DATE        NVARCHAR(50)
    ,DEFAULT_LEAD_TIME   NUMERIC(20,0)
    ,SUNDAY_LEAD_TIME    NUMERIC(20,0)
    ,MONDAY_LEAD_TIME    NUMERIC(20,0)
    ,TUESDAY_LEAD_TIME   NUMERIC(20,0)
    ,WEDNESDAY_LEAD_TIME NUMERIC(20,0)
    ,THURSDAY_LEAD_TIME  NUMERIC(20,0)
    ,FRIDAY_LEAD_TIME    NUMERIC(20,0)
    ,SATURDAY_LEAD_TIME  NUMERIC(20,0)
    ,RESOURCE_ID         NVARCHAR(50)
    ,LOAD_PER            NVARCHAR(50)
    ,CONTAINER_CATEGORY  NVARCHAR(50)
    ,CONTAINER_SIZE      NUMERIC(20,0)
    ,TYPE	             NVARCHAR(50)
    ,ATTRIBUTE1          NVARCHAR(50)
    ,ATTRIBUTE2          NVARCHAR(50)
    ,ATTRIBUTE3          NVARCHAR(50)
    ,ATTRIBUTE4          NVARCHAR(50)
    ,ATTRIBUTE5          NVARCHAR(50)
    ,ATTRIBUTE6          NVARCHAR(50)
    ,ATTRIBUTE7          NVARCHAR(50)
    ,ATTRIBUTE8          NVARCHAR(50)
    ,ATTRIBUTE9          NVARCHAR(50)
    )	
    
    DECLARE @BOD_INS_TEMP TABLE(
     PLAN_ID             NVARCHAR (50)   NOT NULL
    ,BOD_ID              NVARCHAR (200)  NOT NULL
    ,FROM_BUFFER_ID      NVARCHAR (200)  NULL
    ,TO_BUFFER_ID        NVARCHAR (200)  NULL
    ,TRANSPORT_MODE      NVARCHAR (100)  NULL
    ,PRIORITY            NUMERIC  (20,0) NULL
    ,TRANSIT_COST        NUMERIC  (20,0) NULL
    ,EFF_START_DATE      NVARCHAR (20)   NULL
    ,EFF_END_DATE        NVARCHAR (20)   NULL
    ,DEFAULT_LEAD_TIME   NUMERIC  (20,0) NULL
    ,SUNDAY_LEAD_TIME    NUMERIC  (20,0) NULL
    ,MONDAY_LEAD_TIME    NUMERIC  (20,0) NULL
    ,TUESDAY_LEAD_TIME   NUMERIC  (20,0) NULL
    ,WEDNESDAY_LEAD_TIME NUMERIC  (20,0) NULL
    ,THURSDAY_LEAD_TIME  NUMERIC  (20,0) NULL
    ,FRIDAY_LEAD_TIME    NUMERIC  (20,0) NULL
    ,SATURDAY_LEAD_TIME  NUMERIC  (20,0) NULL
    ,RESOURCE_ID         NVARCHAR (100)  NULL
    ,LOAD_PER            NVARCHAR (100)  NULL
    ,CONTAINER_CATEGORY  NVARCHAR (100)  NULL
    ,CONTAINER_SIZE  	 NUMERIC  (20,0) NULL
    ,TYPE                NVARCHAR (100)  NULL
    ,ATTRIBUTE1          NVARCHAR (150)  NULL
    ,ATTRIBUTE2          NVARCHAR (150)  NULL
    ,ATTRIBUTE3          NVARCHAR (150)  NULL
    ,ATTRIBUTE4          NVARCHAR (150)  NULL
    ,ATTRIBUTE5          NVARCHAR (150)  NULL
    ,ATTRIBUTE6          NVARCHAR (150)  NULL
    ,ATTRIBUTE7          NVARCHAR (150)  NULL
    ,ATTRIBUTE8          NVARCHAR (150)  NULL
    ,ATTRIBUTE9          NVARCHAR (150)  NULL
    )

    --Second OCV 날짜 적용을 위한 변수 설정
    DECLARE @FROM_DATE NVARCHAR(8)
    DECLARE @BOD_TEMP TABLE(
     PLAN_ID             NVARCHAR(200)
    ,BOD_ID              NVARCHAR(200)
    ,FROM_BUFFER_ID      NVARCHAR(200)
    ,TO_BUFFER_ID        NVARCHAR(200)
    ,TRANSPORT_MODE      NVARCHAR(200)
    ,PRIORITY            NUMERIC(20,0)
    ,TRANSIT_COST        NUMERIC(20,0)
    ,EFF_START_DATE      NVARCHAR(200)
    ,EFF_END_DATE        NVARCHAR(200)
    ,DEFAULT_LEAD_TIME   NUMERIC(20,0)
    ,SUNDAY_LEAD_TIME    NUMERIC(20,0)
    ,MONDAY_LEAD_TIME    NUMERIC(20,0)
    ,TUESDAY_LEAD_TIME   NUMERIC(20,0)
    ,WEDNESDAY_LEAD_TIME NUMERIC(20,0)
    ,THURSDAY_LEAD_TIME  NUMERIC(20,0)
    ,FRIDAY_LEAD_TIME    NUMERIC(20,0)
    ,SATURDAY_LEAD_TIME  NUMERIC(20,0)
    ,RESOURCE_ID         NVARCHAR(200)
    ,LOAD_PER            NVARCHAR(200)
    ,CONTAINER_CATEGORY  NVARCHAR(200)
    ,CONTAINER_SIZE      NUMERIC(20,0)
    ,USER_ATTB1          NVARCHAR(200)
    ,USER_ATTB2          NVARCHAR(200)
    ,USER_ATTB3          NVARCHAR(200)
    ,USER_ATTB4          NVARCHAR(200)
    ,USER_ATTB5          NVARCHAR(200)
    ,USER_ATTB6          NVARCHAR(200)
    ,USER_ATTB7          NVARCHAR(200)
    ,USER_ATTB8          NVARCHAR(200)
    ,TYPE                NVARCHAR(200)
    ,ATTRIBUTE1          NVARCHAR(200)
    ,ATTRIBUTE2          NVARCHAR(200)
    ,ATTRIBUTE3          NVARCHAR(200)
    ,ATTRIBUTE4          NVARCHAR(200)
    ,ATTRIBUTE5          NVARCHAR(200)
    ,ATTRIBUTE6          NVARCHAR(200)
    ,ATTRIBUTE7          NVARCHAR(200)
    ,ATTRIBUTE8          NVARCHAR(200)
    ,ATTRIBUTE9          NVARCHAR(200)
    ,ATTRIBUTE10         NVARCHAR(200)
    ,ATTRIBUTE11         NVARCHAR(200)
    ,ATTRIBUTE12         NVARCHAR(200)
    ,ATTRIBUTE13         NVARCHAR(200)
    ,ATTRIBUTE14         NVARCHAR(200)
    ,ATTRIBUTE15         NVARCHAR(200)
    )
	-- 임시 : 아래 변수 수정 처리 필요
    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_SEQ    NVARCHAR(200)

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
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;
		
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

        --Sdcond OCV 날짜 적용
        SELECT  @FROM_DATE = CONVERT(NVARCHAR(8),DATEADD(DAY,CONVERT(INT,MIN(ATTRIBUTE10)),@V_PLAN_START_YYYYMMDD),112)
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     VALID_YN    = 'Y'
        AND     ATTRIBUTE1  = 'B'
        AND     SEGMENT2    = @V_DIVISION_ID
        AND     SEGMENT3    = @V_GROUP_ID

		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		IF OBJECT_ID('TEMPDB..#SHIP_FROZEN') IS NOT NULL
		BEGIN 
			DROP TABLE  #SHIP_FROZEN;
		END;

		-- PR_SCP_OPT_ENG_GM_EE_INPUT_SCHEDULED_MOVE 에서도 사용 : 전극만 사용하는 Lookup 임
		SELECT  SEGMENT2 AS ITEM_ID
		      , SEGMENT3 AS FROM_SITE
		      , SEGMENT4 AS TO_SITE
		      , CONVERT(INT, SEGMENT5) AS SHIP_FROZEN
		INTO #SHIP_FROZEN
		FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		WHERE   LOOKUP_TYPE = 'SCP_OPT_ELEC_SHIP_FROZEN'
		AND     VALID_YN    = 'Y'
		AND     SEGMENT1    = @V_DIVISION_ID -- 전극 Division 변수
		
		--SELECT  @V_SHIP_FROZEN = SEGMENT4
		--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--WHERE   LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
		--AND     VALID_YN    = 'Y'
		--AND     SEGMENT1    = @V_DIVISION_ID -- 전극 Division 변수
		--AND     SEGMENT2    = @V_GROUP_ID
  --      --AND     SEGMENT3    = 'PR' --임시
  --      AND     SEGMENT3    = @V_SCP_PLAN_TYPE -- 전극 Division 기준


		SELECT DIVISION_ID 
		INTO #DIVISION
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN = 'Y'
		AND    ATTRIBUTE3 <> 'EE'
		AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;
        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
            ------------------------------------------------------------------------
            -- BOD DATA INSERT TO TEMP TABLE (속도 ISSUE)
            ------------------------------------------------------------------------
            INSERT INTO @BOD_TMP
            SELECT @V_PLAN_ID             AS PLAN_ID
                  ,'TRK::'+ISA.BUFFER_ID+'::'+ISB.BUFFER_ID AS BOD_ID
                  ,ISA.BUFFER_ID          AS FROM_BUFFER_ID
                  ,ISB.BUFFER_ID          AS TO_BUFFER_ID
                  ,'TRK'                  AS TRANSPORT_MODE
                  ,1                      AS PRIORITY
                  ,NULL                   AS TRANSIT_COST
                  ,@V_PLAN_START_YYYYMMDD AS EFF_START_DATE
                  ,@V_PLAN_END_YYYYMMDD   AS EFF_END_DATE
                  ,0                      AS DEFAULT_LEAD_TIME  
                  ,0                      AS SUNDAY_LEAD_TIME   
                  ,0                      AS MONDAY_LEAD_TIME   
                  ,0                      AS TUESDAY_LEAD_TIME  
                  ,0                      AS WEDNESDAY_LEAD_TIME
                  ,0                      AS THURSDAY_LEAD_TIME 
                  ,0                      AS FRIDAY_LEAD_TIME   
                  ,0                      AS SATURDAY_LEAD_TIME 
                  ,NULL                   AS RESOURCE_ID        
                  ,NULL                   AS LOAD_PER           
                  ,NULL                   AS CONTAINER_CATEGORY 
                  ,NULL                   AS CONTAINER_SIZE     
                  ,NULL                   AS TYPE	   
                  ,ISA.SITE_ID            AS ATTRIBUTE1
                  ,ISA.ITEM_ID            AS ATTRIBUTE2
                  ,ISA.STAGE              AS ATTRIBUTE3
                  ,ISB.SITE_ID            AS ATTRIBUTE4
                  ,ISB.STAGE              AS ATTRIBUTE5
                  ,ISB.ATTRIBUTE1         AS ATTRIBUTE6
                  ,'-'                    AS ATTRIBUTE7
                  ,NULL                   AS ATTRIBUTE8
                  ,NULL                   AS ATTRIBUTE9
            FROM   SCP_OPT_ENG_ITEM_SITE_SN ISA WITH(NOLOCK)
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ISB WITH(NOLOCK)
                    ON  ISA.PLAN_ID = ISB.PLAN_ID
                    AND ISA.SITE_ID = ISB.SITE_ID
                    AND ISA.ITEM_ID = ISB.ITEM_ID
            WHERE  ISA.PLAN_ID =@V_PLAN_ID
            AND    ISA.STAGE IN ( 'NND')
            AND    ISB.STAGE IN ( 'TARGETBIZ')
            AND    ISA.ITEM_CLASS_ID  <> 'STOCK'
            AND    ISB.ITEM_CLASS_ID  <> 'STOCK'
   --         SELECT @V_PLAN_ID                                                      AS PLAN_ID
   --               ,TRANSPORT_MODE+'::'+FROM_SITE+'::'+BOD.ITEM_ID+'::'+FROM_STAGE 
   --                +'::'+TO_SITE+'::'+BOD.ITEM_ID+'::'+TO_STAGE
   --                +IIF(ITS.ATTRIBUTE2 IS NULL,'',+'@'+ITS.ATTRIBUTE2)+'::'+BOD_ID AS BOD_ID
   --               ,FROM_SITE+'::'+BOD.ITEM_ID+'::'+FROM_STAGE                      AS FROM_BUFFER_ID
   --               ,TO_SITE+'::'+BOD.ITEM_ID+'::'+TO_STAGE
   --               +IIF(ITS.ATTRIBUTE2 IS NULL,'',+'@'+ITS.ATTRIBUTE2)              AS TO_BUFFER_ID
   --               ,TRANSPORT_MODE                                                  AS TRANSPORT_MODE
   --               ,PRIORITY                                                        AS PRIORITY
   --               ,NULL                                                            AS TRANSIT_COST       
   --               ,EFF_START                                                       AS EFF_START_DATE     
   --               ,EFF_END                                                         AS EFF_END_DATE       
   --               ,LT_TOTAL                                                        AS DEFAULT_LEAD_TIME  
   --               --,SUN_LT                                                     AS SUNDAY_LEAD_TIME   
   --               --,MON_LT                                                     AS MONDAY_LEAD_TIME   
   --               --,TUE_LT                                                     AS TUESDAY_LEAD_TIME  
   --               --,WED_LT                                                     AS WEDNESDAY_LEAD_TIME
   --               --,THU_LT                                                     AS THURSDAY_LEAD_TIME 
   --               --,FRI_LT                                                     AS FRIDAY_LEAD_TIME   
   --               --,SAT_LT                                                     AS SATURDAY_LEAD_TIME 
			--	  ,CASE WHEN SUN_DE = 1 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN MON_DE = 1 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN TUE_DE = 1 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN WED_DE = 1 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN THU_DE = 1 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN FRI_DE = 1 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN SAT_DE = 1 THEN ISNULL(LT_TOTAL, 0)
			--			ELSE NULL 
			--		END AS SUNDAY_LEAD_TIME
			--	  ,CASE WHEN SUN_DE = 2 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN MON_DE = 2 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN TUE_DE = 2 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN WED_DE = 2 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN THU_DE = 2 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN FRI_DE = 2 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN SAT_DE = 2 THEN ISNULL(LT_TOTAL, 0)
			--			ELSE NULL 
			--		END AS MONDAY_LEAD_TIME
			--	  ,CASE WHEN SUN_DE = 3 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN MON_DE = 3 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN TUE_DE = 3 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN WED_DE = 3 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN THU_DE = 3 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN FRI_DE = 3 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN SAT_DE = 3 THEN ISNULL(LT_TOTAL, 0)
			--			ELSE NULL 
			--		END AS TUESDAY_LEAD_TIME
			--	  ,CASE WHEN SUN_DE = 4 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN MON_DE = 4 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN TUE_DE = 4 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN WED_DE = 4 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN THU_DE = 4 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN FRI_DE = 4 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN SAT_DE = 4 THEN ISNULL(LT_TOTAL, 0)
			--			ELSE NULL 
			--		END AS WEDNESDAY_LEAD_TIME
			--	  ,CASE WHEN SUN_DE = 5 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN MON_DE = 5 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN TUE_DE = 5 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN WED_DE = 5 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN THU_DE = 5 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN FRI_DE = 5 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN SAT_DE = 5 THEN ISNULL(LT_TOTAL, 0)
			--			ELSE NULL 
			--		END AS THURSDAY_LEAD_TIME
			--	  ,CASE WHEN SUN_DE = 6 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN MON_DE = 6 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN TUE_DE = 6 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN WED_DE = 6 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN THU_DE = 6 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN FRI_DE = 6 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN SAT_DE = 6 THEN ISNULL(LT_TOTAL, 0)
			--			ELSE NULL 
			--		END AS FRIDAY_LEAD_TIME
			--	  ,CASE WHEN SUN_DE = 7 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN MON_DE = 7 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN TUE_DE = 7 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN WED_DE = 7 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN THU_DE = 7 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN FRI_DE = 7 THEN ISNULL(LT_TOTAL, 0)
			--			WHEN SAT_DE = 7 THEN ISNULL(LT_TOTAL, 0)
			--			ELSE NULL 
			--		END AS SATURDAY_LEAD_TIME
   --               ,NULL                                                       AS RESOURCE_ID        
   --               ,NULL                                                       AS LOAD_PER           
   --               ,NULL                                                       AS CONTAINER_CATEGORY 
   --               ,NULL                                                       AS CONTAINER_SIZE     
   --               ,NULL                                                       AS TYPE	   
   --               ,FROM_SITE                                                  AS ATTRIBUTE1
   --               ,BOD.ITEM_ID                                                AS ATTRIBUTE2
   --               ,FROM_STAGE                                                 AS ATTRIBUTE3
   --               ,TO_SITE                                                    AS ATTRIBUTE4
   --               ,TO_STAGE                                                   AS ATTRIBUTE5
   --               ,INCOTERMS                                                  AS ATTRIBUTE6
   --               ,BOD_ID                                                     AS ATTRIBUTE7
   --               ,BOD_TYPE                                                   AS ATTRIBUTE8
   --               ,ITS.ATTRIBUTE2                                             AS ATTRIBUTE9
   --         FROM(
   --              SELECT FROM_SITE     
   --                    ,TO_SITE       
   --                    ,TRANSPORT_MODE
   --                    ,ITEM_ID       
   --                    ,FROM_STAGE    
   --                    ,TO_STAGE      
   --                    ,EFF_START     
   --                    ,EFF_END       
   --                    ,PRIORITY    
   --                    ,LT_TOTAL      
   --                    ,SUN_LT        
   --                    ,MON_LT        
   --                    ,TUE_LT        
   --                    ,WED_LT        
   --                    ,THU_LT        
   --                    ,FRI_LT        
   --                    ,SAT_LT   
			--     	   ,SUN_DE
			--     	   ,MON_DE
			--     	   ,TUE_DE
			--     	   ,WED_DE
			--     	   ,THU_DE
			--     	   ,FRI_DE
			--     	   ,SAT_DE
   --                    ,INCOTERMS
   --                    ,BOD_ID
   --                    ,BOD_TYPE
   --              FROM ( 
   --                  SELECT B.FROM_SITE
   --                        ,B.TO_SITE, B.TRANSPORT_MODE
   --                        ,BIE.ITEM_ID AS ITEM_ID

   --                  	  ,CASE WHEN FS.OSP_YN = 'Y'   THEN 'COATING'
   --                             ELSE 'ELEC_POST'
   --                  	   END AS FROM_STAGE
   --                  	  --,'ELEC_POST'  AS FROM_STAGE

   --                  	  ,CASE WHEN TS.SITE_TYPE = 'SALES'   THEN 'ELECBIZ' + '@' + B.INCOTERMS -- ELEC PLANT 출발 -> SALES 도착
   --                             WHEN TS.SITE_TYPE = 'PLANT'   THEN 'TARGETBIZ' + '@' + B.INCOTERMS -- ELEC PLANT 출발 -> CELL PLANT 도착
   --                  	   END AS TO_STAGE
			     		  
			--     		  -- (Plan 시작일자 + Ship Frozen) 과 BOD의 FROM YYYYMMDD 중 큰 일자를 EFF_START 로 지정
   --                  	  ,IIF(B.FROM_YYYYMMDD>= CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(SF.SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     		     , B.FROM_YYYYMMDD
			--     			 , CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(SF.SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     			  ) AS EFF_START
			     			  
			--     		  -- [(Plan 시작일자 + Ship Frozen) 과 BOD의 TO YYYYMMDD 중 큰 일자]와 @V_PLAN_END_YYYYMMDD 중 작은 일자를 EFF_END 로 지정
   --                  	  ,IIF(IIF(B.TO_YYYYMMDD>= CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(SF.SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     		         , B.TO_YYYYMMDD
			--     			     , CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(SF.SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     				  ) <= @V_PLAN_END_YYYYMMDD
			--     		     , CONVERT(NVARCHAR(8)
			--     			          ,DATEADD(DAY,1, IIF(B.TO_YYYYMMDD>= CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(SF.SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     		                                , B.TO_YYYYMMDD
			--     			                            , CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(SF.SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     				                         )
			--     					          )						 
			--     			          ,112)
			--     			 , @V_PLAN_END_YYYYMMDD
			--     			 ) AS EFF_END
			--	/*
   --                  	  ,IIF(B.FROM_YYYYMMDD>= CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(@V_SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     		     , B.FROM_YYYYMMDD
			--     			 , CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(@V_SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     			  ) AS EFF_START
			     			  
			--     		  -- [(Plan 시작일자 + Ship Frozen) 과 BOD의 TO YYYYMMDD 중 큰 일자]와 @V_PLAN_END_YYYYMMDD 중 작은 일자를 EFF_END 로 지정
   --                  	  ,IIF(IIF(B.TO_YYYYMMDD>= CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(@V_SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     		         , B.TO_YYYYMMDD
			--     			     , CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(@V_SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     				  ) <= @V_PLAN_END_YYYYMMDD
			--     		     , CONVERT(NVARCHAR(8)
			--     			          ,DATEADD(DAY,1, IIF(B.TO_YYYYMMDD>= CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(@V_SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     		                                , B.TO_YYYYMMDD
			--     			                            , CONVERT(NVARCHAR(8),DATEADD(DAY, ISNULL(@V_SHIP_FROZEN, 0), CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
			--     				                         )
			--     					          )						 
			--     			          ,112)
			--     			 , @V_PLAN_END_YYYYMMDD
			--     			 ) AS EFF_END
   --              */
   --                  	  ,B.PRIORITY
   --                  	  ,ISNULL(B.LT_TOTAL, 0) AS LT_TOTAL
   --                  	  ,CASE WHEN B.DAYS_SUN = 'Y' OR INC.SEGMENT5 = 'N' THEN ISNULL(B.LT_TOTAL, 0) ELSE NULL END AS SUN_LT
   --                        ,CASE WHEN B.DAYS_MON = 'Y' OR INC.SEGMENT5 = 'N' THEN ISNULL(B.LT_TOTAL, 0) ELSE NULL END AS MON_LT
   --                  	  ,CASE WHEN B.DAYS_TUE = 'Y' OR INC.SEGMENT5 = 'N' THEN ISNULL(B.LT_TOTAL, 0) ELSE NULL END AS TUE_LT
   --                  	  ,CASE WHEN B.DAYS_WED = 'Y' OR INC.SEGMENT5 = 'N' THEN ISNULL(B.LT_TOTAL, 0) ELSE NULL END AS WED_LT
   --                  	  ,CASE WHEN B.DAYS_THU = 'Y' OR INC.SEGMENT5 = 'N' THEN ISNULL(B.LT_TOTAL, 0) ELSE NULL END AS THU_LT
   --                        ,CASE WHEN B.DAYS_FRI = 'Y' OR INC.SEGMENT5 = 'N' THEN ISNULL(B.LT_TOTAL, 0) ELSE NULL END AS FRI_LT
   --                  	  ,CASE WHEN B.DAYS_SAT = 'Y' OR INC.SEGMENT5 = 'N' THEN ISNULL(B.LT_TOTAL, 0) ELSE NULL END AS SAT_LT
                 
			--     		  -- 선적 기준 요일이므로 공장 출하 기준 요일로 전환하기 위한 정보 : 아래에서 요일 전환 처리
   --                  	  ,CASE WHEN INC.SEGMENT5 = 'N' THEN 1
			--     		        WHEN B.DAYS_SUN = 'Y' THEN CASE WHEN (1-ISNULL(B.SHIP_LT_TOTAL, 0)%7) <= 0 THEN (1-ISNULL(B.SHIP_LT_TOTAL, 0)%7)+7  ELSE (1-ISNULL(B.SHIP_LT_TOTAL, 0)%7) END 
			--     		        ELSE NULL END AS SUN_DE
   --                        ,CASE WHEN INC.SEGMENT5 = 'N' THEN 2
			--     		        WHEN B.DAYS_MON = 'Y' THEN CASE WHEN (2-ISNULL(B.SHIP_LT_TOTAL, 0)%7) <= 0 THEN (2-ISNULL(B.SHIP_LT_TOTAL, 0)%7)+7  ELSE (2-ISNULL(B.SHIP_LT_TOTAL, 0)%7) END 
			--     		        ELSE NULL END AS MON_DE
   --                  	  ,CASE WHEN INC.SEGMENT5 = 'N' THEN 3
			--     		        WHEN B.DAYS_TUE = 'Y' THEN CASE WHEN (3-ISNULL(B.SHIP_LT_TOTAL, 0)%7) <= 0 THEN (3-ISNULL(B.SHIP_LT_TOTAL, 0)%7)+7  ELSE (3-ISNULL(B.SHIP_LT_TOTAL, 0)%7) END
			--     		        ELSE NULL END AS TUE_DE
   --                  	  ,CASE WHEN INC.SEGMENT5 = 'N' THEN 4
			--     		        WHEN B.DAYS_WED = 'Y' THEN CASE WHEN (4-ISNULL(B.SHIP_LT_TOTAL, 0)%7) <= 0 THEN (4-ISNULL(B.SHIP_LT_TOTAL, 0)%7)+7  ELSE (4-ISNULL(B.SHIP_LT_TOTAL, 0)%7) END
			--     		        ELSE NULL END AS WED_DE
   --                  	  ,CASE WHEN INC.SEGMENT5 = 'N' THEN 5
			--     		        WHEN B.DAYS_THU = 'Y' THEN CASE WHEN (5-ISNULL(B.SHIP_LT_TOTAL, 0)%7) <= 0 THEN (5-ISNULL(B.SHIP_LT_TOTAL, 0)%7)+7  ELSE (5-ISNULL(B.SHIP_LT_TOTAL, 0)%7) END 
			--     		        ELSE NULL END AS THU_DE
   --                        ,CASE WHEN INC.SEGMENT5 = 'N' THEN 6
			--     		        WHEN B.DAYS_FRI = 'Y' THEN CASE WHEN (6-ISNULL(B.SHIP_LT_TOTAL, 0)%7) <= 0 THEN (6-ISNULL(B.SHIP_LT_TOTAL, 0)%7)+7  ELSE (6-ISNULL(B.SHIP_LT_TOTAL, 0)%7) END
			--     		        ELSE NULL END AS FRI_DE
   --                  	  ,CASE WHEN INC.SEGMENT5 = 'N' THEN 7
			--     		        WHEN B.DAYS_SAT = 'Y' THEN CASE WHEN (7-ISNULL(B.SHIP_LT_TOTAL, 0)%7) <= 0 THEN (7-ISNULL(B.SHIP_LT_TOTAL, 0)%7)+7  ELSE (7-ISNULL(B.SHIP_LT_TOTAL, 0)%7) END
			--     		        ELSE NULL END AS SAT_DE
   --                        ,B.INCOTERMS
   --                        ,B.BOD_ID
   --                        ,B.BOD_TYPE
   --                  --	,'======'
   --                  --,B.BOD_TYPE
   --                  --	, ISNULL(B.SHIP_LT_TOTAL, 0) AS SHIP_LT_TOTAL
   --                  --	 , B.BEFORE_LT  AS ATTRIBUTE2	    --2021.05.10 추가
   --                  --	 , B.AFTER_LT   AS ATTRIBUTE3		--2021.05.10 추가	
   --                  --,B.*			
   --                  FROM SCP_MST_BOD_N_V B WITH (NOLOCK)  --20210707 기간별 VIEW로 변경(SCP_MST_BOD_V -> SCP_MST_BOD_N_V)

			--		 INNER JOIN #DIVISION D WITH(NOLOCK)
			--		 ON B.DIVISION_ID = D.DIVISION_ID				 
                 
   --                  INNER JOIN SCP_MST_BOD_ITEM BIE WITH (NOLOCK) 
   --                  ON  B.DIVISION_ID    = BIE.DIVISION_ID
   --                  AND B.BOD_ID         = BIE.BOD_ID
   --                  AND BIE.VALID_YN     = 'Y'

			--		 LEFT JOIN #SHIP_FROZEN SF WITH(NOLOCK)
			--		 ON  B.FROM_SITE = SF.FROM_SITE
   --                  AND B.TO_SITE   = SF.TO_SITE
   --                  AND BIE.ITEM_ID = SF.ITEM_ID	
                 
   --                  INNER JOIN SCM_MST_SITE FS WITH (NOLOCK) 
   --                  ON  B.DIVISION_ID    = FS.DIVISION_ID
   --                  AND B.FROM_SITE      = FS.SCM_SITE_ID
   --                  AND FS.SITE_TYPE     = 'PLANT'
   --                  AND FS.VALID_YN      = 'Y'
			--     	 AND FS.OPERATION_GROUP IN ('E') 
                     
			--		 -- SALES Site 일부는 사업부별로 같은 이름이; 존재하여 전극 처리 시 중복 오류가 예상되어 Group By 처리함
			--		 -- BOD 의 DIVISION_ID 는 FROM 기준이므로 전극의 경우 TO 는 DIVISION 조건 제외
   --                  INNER JOIN (SELECT SCM_SITE_ID
			--		                  , MAX(SITE_TYPE)       AS SITE_TYPE
			--		                  , MAX(OPERATION_GROUP) AS OPERATION_GROUP
			--		                  , MAX(OSP_YN)          AS OSP_YN
			--		             FROM   SCM_MST_SITE TS WITH (NOLOCK) 
			--					 WHERE  TS.VALID_YN  = 'Y'	
			--					 AND  ( TS.SITE_TYPE = 'SALES' OR TS.OPERATION_GROUP IN ('A')    
			--	    				  )	
			--					 GROUP BY SCM_SITE_ID
			--					) TS
   --                  ON  1=1 
   --                  AND B.TO_SITE        = TS.SCM_SITE_ID

   --                  LEFT JOIN (SELECT DISTINCT F.DIVISION_ID
   --                                            ,F.ITEM_ID
   --                                            ,F.OPERATION_GROUP
   --                                            ,F.FLOW_ID
   --                                            ,F.ATTRIBUTE8
   --                              FROM   SCP_MST_FINAL_ITEM F WITH (NOLOCK) 

			--					 INNER JOIN #DIVISION D WITH(NOLOCK)
			--					 ON F.DIVISION_ID = D.DIVISION_ID

   --                              WHERE  1=1
   --                              AND    F.OPERATION_GROUP IN ('E')  
   --                             ) FI
   --                  ON    BIE.ITEM_ID     = FI.ITEM_ID
   --                  AND   BIE.DIVISION_ID = FI.DIVISION_ID 
			     					
   --                  LEFT JOIN (SELECT SEGMENT1 AS INCOTERMS 
			--     	                , SEGMENT5  -- 항차적용여부
			--     				FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			--     				WHERE  LOOKUP_TYPE = 'INCOTERMS'
			--     				AND    VALID_YN = 'Y'
   --                             ) INC
   --                  ON    B.INCOTERMS     = INC.INCOTERMS
                     
   --                  WHERE 1 = 1
   --                  --AND   B.DIVISION_ID                  = @V_DIVISION_ID 
   --                  AND   B.BOD_VALID_YN                 = 'Y'
   --                  AND   B.FROM_YYYYMMDD               <= @V_PLAN_END_YYYYMMDD              --유효한 기간의 BOD만 생성 조건 추가, 2021.07.14, BY KKC
   --                  AND   B.TO_YYYYMMDD                 >= @V_PLAN_START_YYYYMMDD    --유효한 기간의 BOD만 생성 조건 추가, 2021.07.14, BY KKC
   --                  AND   FS.OPERATION_GROUP            IN ('E') -- 전극만 
   --                  AND (   TS.SITE_TYPE = 'SALES' 
   --                       OR FS.OPERATION_GROUP <> TS.OPERATION_GROUP 
   --                       OR (    FS.OPERATION_GROUP = TS.OPERATION_GROUP 
   --                           AND (FS.OSP_YN = 'Y' OR TS.OSP_YN = 'Y')
   --                           )
   --                      )
   --                  ) AS A
   --              GROUP BY FROM_SITE,TO_SITE,TRANSPORT_MODE,ITEM_ID,FROM_STAGE,TO_STAGE,EFF_START,EFF_END,PRIORITY,LT_TOTAL,SUN_LT,MON_LT,TUE_LT,WED_LT,THU_LT,FRI_LT,SAT_LT 
			--     	  ,SUN_DE,MON_DE,TUE_DE,WED_DE,THU_DE,FRI_DE,SAT_DE,INCOTERMS,BOD_ID,BOD_TYPE
   --         ) BOD
   --             LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
   --                 ON  1=1
   --                 AND ITS.PLAN_ID   = @V_PLAN_ID
   --                 AND BOD.TO_SITE   = ITS.SITE_ID
   --                 AND BOD.ITEM_ID   = ITS.ITEM_ID
   --                 AND BOD.TO_STAGE  = ITS.STAGE+IIF(ITS.ATTRIBUTE1 IS NULL,'','@'+ITS.ATTRIBUTE1)
   --                 AND BOD.INCOTERMS = ITS.ATTRIBUTE1
   --         /************************* 
   --         대상 프로젝트 ITEM 필터링 
   --         *************************/
			--AND CONCAT(BOD.FROM_SITE, BOD.ITEM_ID) 
			--	IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
			--		FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
			--		WHERE  PLAN_ID = @V_PLAN_ID
			--	   ) 

            ------------------------------------------------------------------------
            -- BOD DATA INSERT 
            -- BOD BLOCKING 제약을 위해 제약이 없는 경우와 제약이 있는 경우를 나눠서 계산
            -- 2025.09.22 Philsu Park: BLOCKING From Date = To Date 인 경우 DATEADD 0 일로 처리.
            -- 2025.09.23 Philsu Park: EFF_END_DATE = MAX(BASIS_YYYYMMDD) + 1일
			-- 2025.10.16 Philsu Park: 1 Day or N Days 전부 커버 가능하게 수정
			--  						-> BLOCKING 구간 계산할 때 DATE_ADD 하는 부분 제거, EFF_END_DATE 계산 시에만 +1일 더하게 유지.
            ------------------------------------------------------------------------
            INSERT INTO @BOD_INS_TEMP(PLAN_ID
                                     ,BOD_ID
                                     ,FROM_BUFFER_ID
                                     ,TO_BUFFER_ID
                                     ,TRANSPORT_MODE
                                     ,PRIORITY
                                     ,TRANSIT_COST       
                                     ,EFF_START_DATE     
                                     ,EFF_END_DATE       
                                     ,DEFAULT_LEAD_TIME  
                                     ,SUNDAY_LEAD_TIME   
                                     ,MONDAY_LEAD_TIME   
                                     ,TUESDAY_LEAD_TIME  
                                     ,WEDNESDAY_LEAD_TIME
                                     ,THURSDAY_LEAD_TIME 
                                     ,FRIDAY_LEAD_TIME   
                                     ,SATURDAY_LEAD_TIME 
                                     ,RESOURCE_ID        
                                     ,LOAD_PER           
                                     ,CONTAINER_CATEGORY 
                                     ,CONTAINER_SIZE     
                                     ,TYPE	   
                                     ,ATTRIBUTE1
                                     ,ATTRIBUTE2
                                     ,ATTRIBUTE3
                                     ,ATTRIBUTE4
                                     ,ATTRIBUTE5
                                     ,ATTRIBUTE6
                                     ,ATTRIBUTE7
                                     ,ATTRIBUTE8
                                     ,ATTRIBUTE9
                                     )
            SELECT BOD.PLAN_ID
                  ,BOD.BOD_ID+'::'+BOD.EFF_START_DATE AS BOD_ID
                  ,BOD.FROM_BUFFER_ID
                  ,BOD.TO_BUFFER_ID
                  ,BOD.TRANSPORT_MODE
                  ,BOD.PRIORITY
                  ,BOD.TRANSIT_COST       
                  ,BOD.EFF_START_DATE
                  ,BOD.EFF_END_DATE
                  ,BOD.DEFAULT_LEAD_TIME  
                  ,BOD.SUNDAY_LEAD_TIME   
                  ,BOD.MONDAY_LEAD_TIME   
                  ,BOD.TUESDAY_LEAD_TIME  
                  ,BOD.WEDNESDAY_LEAD_TIME
                  ,BOD.THURSDAY_LEAD_TIME 
                  ,BOD.FRIDAY_LEAD_TIME   
                  ,BOD.SATURDAY_LEAD_TIME 
                  ,BOD.RESOURCE_ID        
                  ,BOD.LOAD_PER           
                  ,BOD.CONTAINER_CATEGORY 
                  ,BOD.CONTAINER_SIZE     
                  ,BOD.TYPE	   
                  ,BOD.ATTRIBUTE1
                  ,BOD.ATTRIBUTE2
                  ,BOD.ATTRIBUTE3
                  ,BOD.ATTRIBUTE4
                  ,BOD.ATTRIBUTE5
                  ,BOD.ATTRIBUTE6
                  ,BOD.ATTRIBUTE7
                  ,BOD.ATTRIBUTE8
                  ,BOD.ATTRIBUTE9
            FROM @BOD_TMP BOD
            --    LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
            --        ON      1=1
            --        AND     BOD.ATTRIBUTE2 = LV.SEGMENT4
            --        AND     BOD.ATTRIBUTE7 = LV.ATTRIBUTE1
            --        AND     LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_BOD_BLOCKING'
            --        AND     VALID_YN       ='Y'
            --        AND     SEGMENT2       =@V_DIVISION_ID -- 전극 Division 변수
            --        AND     SEGMENT3       =@V_GROUP_ID
            --WHERE   LV.SEGMENT1 IS NULL

                -- 2026.04.29 Minyong Lee : Lookup -> UI 전환 (BOD Blocking)
                LEFT JOIN SCP_OPMZ_BOD_EXCLUDED_ITEM BE WITH(NOLOCK)
                    ON      1=1
                    AND     BOD.ATTRIBUTE2 = BE.ITEM_ID
                    AND     BOD.ATTRIBUTE7 = BE.BOD_ID
                    AND     BE.VALID_YN    ='Y'
                    AND     BE.DIVISION_ID = @V_DIVISION_ID
            WHERE   BE.BOD_ID IS NULL
            UNION ALL
            SELECT PLAN_ID
                  ,BOD_ID+'::'+MIN(BASIS_YYYYMMDD) AS BOD_ID
                  ,FROM_BUFFER_ID
                  ,TO_BUFFER_ID
                  ,TRANSPORT_MODE
                  ,PRIORITY
                  ,TRANSIT_COST       
                  ,MIN(BASIS_YYYYMMDD) AS EFF_START_DATE
                  ,CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, MAX(BASIS_YYYYMMDD), 112)), 112) AS EFF_END_DATE
                    --   ,MAX(BASIS_YYYYMMDD) AS EFF_END_DATE
                  ,DEFAULT_LEAD_TIME  
                  ,SUNDAY_LEAD_TIME   
                  ,MONDAY_LEAD_TIME   
                  ,TUESDAY_LEAD_TIME  
                  ,WEDNESDAY_LEAD_TIME
                  ,THURSDAY_LEAD_TIME 
                  ,FRIDAY_LEAD_TIME   
                  ,SATURDAY_LEAD_TIME 
                  ,RESOURCE_ID        
                  ,LOAD_PER           
                  ,CONTAINER_CATEGORY 
                  ,CONTAINER_SIZE     
                  ,TYPE	   
                  ,ATTRIBUTE1
                  ,ATTRIBUTE2
                  ,ATTRIBUTE3
                  ,ATTRIBUTE4
                  ,ATTRIBUTE5
                  ,ATTRIBUTE6
                  ,ATTRIBUTE7
                  ,ATTRIBUTE8
                  ,ATTRIBUTE9
            FROM(
                SELECT BOD.PLAN_ID
                      ,DATEADD(DAY, -ROW_NUMBER() OVER(PARTITION BY BOD.BOD_ID ORDER BY BOD.BASIS_YYYYMMDD),BOD.BASIS_YYYYMMDD) AS GRP
                      ,BOD.BOD_ID
                      ,BOD.FROM_BUFFER_ID
                      ,BOD.TO_BUFFER_ID
                      ,BOD.TRANSPORT_MODE
                      ,BOD.PRIORITY
                      ,BOD.TRANSIT_COST       
                      ,BOD.EFF_START_DATE     
                      ,BOD.EFF_END_DATE       
                      ,BOD.DEFAULT_LEAD_TIME  
                      ,BOD.SUNDAY_LEAD_TIME   
                      ,BOD.MONDAY_LEAD_TIME   
                      ,BOD.TUESDAY_LEAD_TIME  
                      ,BOD.WEDNESDAY_LEAD_TIME
                      ,BOD.THURSDAY_LEAD_TIME 
                      ,BOD.FRIDAY_LEAD_TIME   
                      ,BOD.SATURDAY_LEAD_TIME 
                      ,BOD.RESOURCE_ID        
                      ,BOD.LOAD_PER           
                      ,BOD.CONTAINER_CATEGORY 
                      ,BOD.CONTAINER_SIZE     
                      ,BOD.TYPE	   
                      ,BOD.ATTRIBUTE1
                      ,BOD.ATTRIBUTE2
                      ,BOD.ATTRIBUTE3
                      ,BOD.ATTRIBUTE4
                      ,BOD.ATTRIBUTE5
                      ,BOD.ATTRIBUTE6
                      ,BOD.ATTRIBUTE7
                      ,BOD.ATTRIBUTE8
                      ,BOD.ATTRIBUTE9
                      ,BOD.BASIS_YYYYMMDD
                FROM(
                    SELECT BOD.PLAN_ID
                          ,BOD.BOD_ID
                          ,BOD.FROM_BUFFER_ID
                          ,BOD.TO_BUFFER_ID
                          ,BOD.TRANSPORT_MODE
                          ,BOD.PRIORITY
                          ,BOD.TRANSIT_COST       
                          ,BOD.EFF_START_DATE     
                          ,BOD.EFF_END_DATE       
                          ,BOD.DEFAULT_LEAD_TIME  
                          ,BOD.SUNDAY_LEAD_TIME   
                          ,BOD.MONDAY_LEAD_TIME   
                          ,BOD.TUESDAY_LEAD_TIME  
                          ,BOD.WEDNESDAY_LEAD_TIME
                          ,BOD.THURSDAY_LEAD_TIME 
                          ,BOD.FRIDAY_LEAD_TIME   
                          ,BOD.SATURDAY_LEAD_TIME 
                          ,BOD.RESOURCE_ID        
                          ,BOD.LOAD_PER           
                          ,BOD.CONTAINER_CATEGORY 
                          ,BOD.CONTAINER_SIZE     
                          ,BOD.TYPE	   
                          ,BOD.ATTRIBUTE1
                          ,BOD.ATTRIBUTE2
                          ,BOD.ATTRIBUTE3
                          ,BOD.ATTRIBUTE4
                          ,BOD.ATTRIBUTE5
                          ,BOD.ATTRIBUTE6
                          ,BOD.ATTRIBUTE7
                          ,BOD.ATTRIBUTE8
                          ,BOD.ATTRIBUTE9
                          ,CAL1.BASIS_YYYYMMDD
                    FROM @BOD_TMP BOD
                        --LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                        --    ON      1=1
                        --    AND     BOD.ATTRIBUTE2 = LV.SEGMENT4
                        --    AND     BOD.ATTRIBUTE7 = LV.ATTRIBUTE1
                        --    AND     LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_BOD_BLOCKING'
                        --    AND     VALID_YN       ='Y'
                        --    AND     SEGMENT2       =@V_DIVISION_ID -- 전극 Division 변수
                        --    AND     SEGMENT3       =@V_GROUP_ID

                        -- 2026.04.29 Minyong Lee : Lookup -> UI 전환 (BOD Blocking)
                        LEFT JOIN SCP_OPMZ_BOD_EXCLUDED_ITEM BE WITH(NOLOCK)
                            ON      1=1
                            AND     BOD.ATTRIBUTE2 = BE.ITEM_ID
                            AND     BOD.ATTRIBUTE7 = BE.BOD_ID
                            AND     BE.VALID_YN    = 'Y'
                            AND     BE.DIVISION_ID = @V_DIVISION_ID
                        INNER JOIN SCM_SYS_CALENDAR_M CAL1 WITH(NOLOCK)
                            ON CAL1.BASIS_YYYYMMDD BETWEEN BOD.EFF_START_DATE AND EFF_END_DATE
                        LEFT OUTER JOIN (
          --                              SELECT SEGMENT4   AS ITEM_ID
          --                                    ,ATTRIBUTE1 AS BOD_ID
          --                                    ,CAL2.BASIS_YYYYMMDD AS NO_YYYYMMDD
          --                              FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
          --                              LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL2 WITH(NOLOCK)
          --                              	ON CAL2.BASIS_YYYYMMDD BETWEEN LV.ATTRIBUTE5 AND LV.ATTRIBUTE6
										---- ON CAL2.BASIS_YYYYMMDD BETWEEN CONVERT(NVARCHAR(8),DATEADD(DAY,IIF(LV.ATTRIBUTE5 = LV.ATTRIBUTE6, 0, 1),LV.ATTRIBUTE5),112) AND LV.ATTRIBUTE6
          --                              WHERE 1=1
          --                              AND     LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_BOD_BLOCKING'
          --                              AND     VALID_YN       ='Y'
          --                              AND     SEGMENT2       =@V_DIVISION_ID -- 전극 Division 변수
          --                              AND     SEGMENT3       =@V_GROUP_ID

                                        -- 2026.04.29 Minyong Lee : Lookup -> UI 전환 (BOD Blocking)
                                        SELECT  BE.ITEM_ID          AS ITEM_ID
                                              , BE.BOD_ID           AS BOD_ID
                                              , CAL2.BASIS_YYYYMMDD AS NO_YYYYMMDD
                                        FROM SCP_OPMZ_BOD_EXCLUDED_ITEM BE WITH(NOLOCK)
                                            LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL2 WITH(NOLOCK)
                                                ON CAL2.BASIS_YYYYMMDD BETWEEN BE.BOD_EX_FROM_YYYYMMDD AND BE.BOD_EX_TO_YYYYMMDD
                                        WHERE 1=1
                                        AND     BE.VALID_YN     = 'Y'
                                        AND     BE.DIVISION_ID  = @V_DIVISION_ID
                                        ) BB
                            ON      BOD.ATTRIBUTE2 = BB.ITEM_ID
                    AND     BOD.ATTRIBUTE7 = BB.BOD_ID
                    AND     CAL1.BASIS_YYYYMMDD = BB.NO_YYYYMMDD
                    -- 2026.04.29 Minyong Lee : Lookup -> UI 전환 (BOD Blocking)
                    WHERE   BE.BOD_ID IS NOT NULL
                    AND     BB.NO_YYYYMMDD IS NULL
                    GROUP BY BOD.PLAN_ID,BOD.BOD_ID,BOD.FROM_BUFFER_ID,BOD.TO_BUFFER_ID,BOD.TRANSPORT_MODE,BOD.PRIORITY,BOD.TRANSIT_COST,BOD.EFF_START_DATE,BOD.EFF_END_DATE,BOD.DEFAULT_LEAD_TIME,BOD.SUNDAY_LEAD_TIME,BOD.MONDAY_LEAD_TIME,BOD.TUESDAY_LEAD_TIME,BOD.WEDNESDAY_LEAD_TIME
                           ,BOD.THURSDAY_LEAD_TIME ,BOD.FRIDAY_LEAD_TIME,BOD.SATURDAY_LEAD_TIME ,BOD.RESOURCE_ID,BOD.LOAD_PER,BOD.CONTAINER_CATEGORY,BOD.CONTAINER_SIZE,BOD.TYPE,BOD.ATTRIBUTE1,BOD.ATTRIBUTE2,BOD.ATTRIBUTE3,BOD.ATTRIBUTE4,BOD.ATTRIBUTE5,BOD.ATTRIBUTE6,BOD.ATTRIBUTE7,BOD.ATTRIBUTE8,BOD.ATTRIBUTE9,CAL1.BASIS_YYYYMMDD
                ) BOD
            )GRP
            GROUP BY PLAN_ID,BOD_ID,FROM_BUFFER_ID,TO_BUFFER_ID,TRANSPORT_MODE,PRIORITY,TRANSIT_COST,DEFAULT_LEAD_TIME,SUNDAY_LEAD_TIME,MONDAY_LEAD_TIME,TUESDAY_LEAD_TIME,WEDNESDAY_LEAD_TIME,THURSDAY_LEAD_TIME,FRIDAY_LEAD_TIME,SATURDAY_LEAD_TIME,RESOURCE_ID,LOAD_PER
                    ,CONTAINER_CATEGORY,CONTAINER_SIZE,TYPE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,GRP
            ------------------------------------------------------------------------
            -- BOD DATA INSERT 
            -- 속도 이슈로 TEMP에 넣은 후 본 테이블에 INSERT
            -- 2025.09.23 Philsu Park: EFF_END_DATE 가 PED 보다 작거나 같게 수정.
            ------------------------------------------------------------------------
            INSERT INTO SCP_OPT_ENG_BOD_SN(PLAN_ID
                                          ,BOD_ID
                                          ,FROM_BUFFER_ID
                                          ,TO_BUFFER_ID
                                          ,TRANSPORT_MODE
                                          ,PRIORITY
                                          ,TRANSIT_COST       
                                          ,EFF_START_DATE     
                                          ,EFF_END_DATE       
                                          ,DEFAULT_LEAD_TIME  
                                          ,SUNDAY_LEAD_TIME   
                                          ,MONDAY_LEAD_TIME   
                                          ,TUESDAY_LEAD_TIME  
                                          ,WEDNESDAY_LEAD_TIME
                                          ,THURSDAY_LEAD_TIME 
                                          ,FRIDAY_LEAD_TIME   
                                          ,SATURDAY_LEAD_TIME 
                                          ,RESOURCE_ID        
                                          ,LOAD_PER           
                                          ,CONTAINER_CATEGORY 
                                          ,CONTAINER_SIZE     
                                          ,TYPE	   
                                          ,ATTRIBUTE1
                                          ,ATTRIBUTE2
                                          ,ATTRIBUTE3
                                          ,ATTRIBUTE4
                                          ,ATTRIBUTE5
                                          ,ATTRIBUTE6
                                          ,ATTRIBUTE7
                                          ,ATTRIBUTE8
                                          ,ATTRIBUTE9
                                          )
            SELECT  PLAN_ID
                   ,BOD_ID
                   ,FROM_BUFFER_ID
                   ,TO_BUFFER_ID
                   ,TRANSPORT_MODE
                   ,PRIORITY
                   ,TRANSIT_COST       
                   ,EFF_START_DATE     
                   ,LEAST(EFF_END_DATE, @V_PLAN_END_YYYYMMDD) AS EFF_END_DATE
                   ,DEFAULT_LEAD_TIME  
                   ,SUNDAY_LEAD_TIME   
                   ,MONDAY_LEAD_TIME   
                   ,TUESDAY_LEAD_TIME  
                   ,WEDNESDAY_LEAD_TIME
                   ,THURSDAY_LEAD_TIME 
                   ,FRIDAY_LEAD_TIME   
                   ,SATURDAY_LEAD_TIME 
                   ,RESOURCE_ID        
                   ,LOAD_PER           
                   ,CONTAINER_CATEGORY 
                   ,CONTAINER_SIZE     
                   ,TYPE	   
                   ,ATTRIBUTE1
                   ,ATTRIBUTE2
                   ,ATTRIBUTE3
                   ,ATTRIBUTE4
                   ,ATTRIBUTE5
                   ,ATTRIBUTE6
                   ,ATTRIBUTE7
                   ,ATTRIBUTE8
                   ,ATTRIBUTE9
            FROM    @BOD_INS_TEMP
        ------------------------------------------------------------------------
        -- Demand Group BOD Insert
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_BOD_SN(
               PLAN_ID
              ,BOD_ID
              ,FROM_BUFFER_ID
              ,TO_BUFFER_ID
              ,TRANSPORT_MODE
              ,PRIORITY
              ,TRANSIT_COST
              ,EFF_START_DATE
              ,EFF_END_DATE
              ,DEFAULT_LEAD_TIME
              ,SUNDAY_LEAD_TIME
              ,MONDAY_LEAD_TIME
              ,TUESDAY_LEAD_TIME
              ,WEDNESDAY_LEAD_TIME
              ,THURSDAY_LEAD_TIME
              ,FRIDAY_LEAD_TIME
              ,SATURDAY_LEAD_TIME
              ,RESOURCE_ID
              ,LOAD_PER
              ,CONTAINER_CATEGORY
              ,CONTAINER_SIZE
              ,TYPE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              )
        SELECT @V_PLAN_ID
              ,DM1.BUFFER_ID + DM2.BUFFER_ID AS BOD_ID
              ,DM1.BUFFER_ID          AS FROM_BUFFER_ID
              ,DM2.BUFFER_ID          AS TO_BUFFER_ID
              ,'TRK'                  AS TRANSPORT_MODE
              ,'1'                    AS PRIORITY
              ,NULL                   AS TRANSIT_COST
              ,@V_PLAN_START_YYYYMMDD AS EFF_START_DATE
              ,@V_PLAN_END_YYYYMMDD   AS EFF_END_DATE
              ,'0'                    AS DEFAULT_LEAD_TIME
              ,'0'                    AS SUNDAY_LEAD_TIME
              ,'0'                    AS MONDAY_LEAD_TIME
              ,'0'                    AS TUESDAY_LEAD_TIME
              ,'0'                    AS WEDNESDAY_LEAD_TIME
              ,'0'                    AS THURSDAY_LEAD_TIME
              ,'0'                    AS FRIDAY_LEAD_TIME
              ,'0'                    AS SATURDAY_LEAD_TIME
              ,NULL                   AS RESOURCE_ID
              ,NULL                   AS LOAD_PER
              ,NULL                   AS CONTAINER_CATEGORY
              ,NULL                   AS CONTAINER_SIZE
              ,NULL                   AS TYPE
              ,DM1.ATTRIBUTE1         AS ATTRIBUTE1
              ,DM1.ATTRIBUTE2         AS ATTRIBUTE2
              ,DM1.ATTRIBUTE3         AS ATTRIBUTE3
              ,DM2.ATTRIBUTE1         AS ATTRIBUTE4
              ,DM2.ATTRIBUTE2         AS ATTRIBUTE5
        FROM SCP_OPT_ENG_DEMAND_SN DM1 WITH(NOLOCK) -- 원래 DEMAND
        INNER JOIN SCP_OPT_ENG_DEMAND_SN DM2 WITH(NOLOCK)    -- GROUP DEMAND
        ON  DM1.PLAN_ID = DM2.PLAN_ID
        AND DM1.DEMAND_ID = 'D_'+DM2.DEMAND_ID
        AND DM1.ATTRIBUTE13 = 'GROUP_DEMAND'
        AND DM2.ATTRIBUTE12 = 'DEMAND_GROUP'
        WHERE DM1.PLAN_ID =@V_PLAN_ID
        GROUP BY DM1.BUFFER_ID, DM2.BUFFER_ID,DM1.ATTRIBUTE1,DM1.ATTRIBUTE2,DM1.ATTRIBUTE3,DM2.ATTRIBUTE1,DM2.ATTRIBUTE2

        ------------------------------------------------------------------------
        -- PACKING EQUIPMENT CONSTRAINTS UPDATE
        -- 2025.12.01 Minyong Lee : 5.20부 변경된 로직으로 주석처리
        ------------------------------------------------------------------------
        --UPDATE SCP_OPT_ENG_BOD_SN
        --SET SCP_OPT_ENG_BOD_SN.RESOURCE_ID = PE.FROM_SITE_ID +'::PACKING_EQUIPMENT@'+ STAGE
        --,   SCP_OPT_ENG_BOD_SN.LOAD_PER    =  1
        --,   SCP_OPT_ENG_BOD_SN.TYPE        =  1
        --FROM SCP_OPT_ENG_BOD_SN WITH(NOLOCK)
        --    INNER JOIN(
        --              SELECT SEGMENT3                      AS ITEM_ID
        --                    ,SEGMENT4                      AS FROM_SITE_ID
        --                    ,SEGMENT5                      AS STAGE
        --                    ,'PACKING_EQUIPMENT@'+SEGMENT5 AS RESOURCE_NAME
        --                    ,ATTRIBUTE1                    AS TO_SITE_ID
        --                    ,ATTRIBUTE2                    AS FROM_DATE
        --                    ,ATTRIBUTE3                    AS TO_DATE
        --                    ,ATTRIBUTE4                    AS LOWER_VALUE
        --                    ,ATTRIBUTE5                    AS UPPER_VALUE
        --              FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        --              WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
        --              AND    VALID_YN    = 'Y'
        --              AND    SEGMENT2    = @V_DIVISION_ID -- 전극 Division 변수
        --              ) AS PE
        --    ON  SCP_OPT_ENG_BOD_SN.ATTRIBUTE1 = PE.FROM_SITE_ID
        --    AND SCP_OPT_ENG_BOD_SN.ATTRIBUTE2 = PE.ITEM_ID
        --    AND SCP_OPT_ENG_BOD_SN.ATTRIBUTE3 = PE.STAGE
        --    AND SCP_OPT_ENG_BOD_SN.ATTRIBUTE4 = PE.TO_SITE_ID
        --WHERE SCP_OPT_ENG_BOD_SN.PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- 2nd OCV 적용을 위한 BOD UPDATE
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_BOD_SN
        SET SCP_OPT_ENG_BOD_SN.BOD_ID = BOD.TRANSPORT_MODE+'::'+BOD.ATTRIBUTE1+'::'+BOD.ATTRIBUTE2+'::'+S_OCV.LU_STAGE+'::'+BOD.TO_BUFFER_ID+'::'+BOD.ATTRIBUTE7+'::'+BOD.EFF_START_DATE
           ,SCP_OPT_ENG_BOD_SN.FROM_BUFFER_ID = BOD.ATTRIBUTE1+'::'+BOD.ATTRIBUTE2+'::'+S_OCV.LU_STAGE
           ,SCP_OPT_ENG_BOD_SN.ATTRIBUTE3 = S_OCV.LU_STAGE
        FROM    SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)
            INNER JOIN (
                       SELECT  SEGMENT4   AS FROM_SITE_ID
                              ,SEGMENT5   AS ITEM_ID
                              ,ATTRIBUTE3 AS LU_STAGE
                       FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                       WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                       AND     VALID_YN    = 'Y'
                       AND     ATTRIBUTE1  = 'B'
                       AND     SEGMENT2    = @V_DIVISION_ID
                       AND     SEGMENT3    = @V_GROUP_ID
                       GROUP BY SEGMENT4,SEGMENT5,ATTRIBUTE3
                       ) S_OCV
                ON  BOD.ATTRIBUTE1 = S_OCV.FROM_SITE_ID
                AND BOD.ATTRIBUTE2 = S_OCV.ITEM_ID
        WHERE   BOD.PLAN_ID = @V_PLAN_ID


        ----EFF_START_DATE가 @FROM_DATE 보다 작은 데이터는 기존 BOD를 유지해야하므로 EFF_END_DATE만 변경해서 임시테이블에 INSERT
        --INSERT INTO @BOD_TEMP
        --SELECT  PLAN_ID
        --       ,BOD_ID
        --       ,FROM_BUFFER_ID
        --       ,TO_BUFFER_ID
        --       ,TRANSPORT_MODE
        --       ,PRIORITY
        --       ,TRANSIT_COST
        --       ,EFF_START_DATE
        --       ,IIF(EFF_END_DATE<=@FROM_DATE,EFF_END_DATE,@FROM_DATE) EFF_END_DATE
        --       ,DEFAULT_LEAD_TIME
        --       ,SUNDAY_LEAD_TIME
        --       ,MONDAY_LEAD_TIME
        --       ,TUESDAY_LEAD_TIME
        --       ,WEDNESDAY_LEAD_TIME
        --       ,THURSDAY_LEAD_TIME
        --       ,FRIDAY_LEAD_TIME
        --       ,SATURDAY_LEAD_TIME
        --       ,RESOURCE_ID
        --       ,LOAD_PER
        --       ,CONTAINER_CATEGORY
        --       ,CONTAINER_SIZE
        --       ,USER_ATTB1
        --       ,USER_ATTB2
        --       ,USER_ATTB3
        --       ,USER_ATTB4
        --       ,USER_ATTB5
        --       ,USER_ATTB6
        --       ,USER_ATTB7
        --       ,USER_ATTB8
        --       ,TYPE
        --       ,ATTRIBUTE1
        --       ,ATTRIBUTE2
        --       ,ATTRIBUTE3
        --       ,ATTRIBUTE4
        --       ,ATTRIBUTE5
        --       ,ATTRIBUTE6
        --       ,ATTRIBUTE7
        --       ,ATTRIBUTE8
        --       ,ATTRIBUTE9
        --       ,ATTRIBUTE10
        --       ,ATTRIBUTE11
        --       ,ATTRIBUTE12
        --       ,ATTRIBUTE13
        --       ,ATTRIBUTE14
        --       ,ATTRIBUTE15
        --FROM    SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)
        --    INNER JOIN (
        --               SELECT  SEGMENT4   AS FROM_SITE_ID
        --                      ,SEGMENT5   AS ITEM_ID
        --                      ,ATTRIBUTE3 AS LU_STAGE
        --               FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --               WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        --               AND     VALID_YN    = 'Y'
        --               AND     ATTRIBUTE1  = 'B'
        --               AND     SEGMENT2    = @V_DIVISION_ID
        --               AND     SEGMENT3    = @V_GROUP_ID
        --               GROUP BY SEGMENT4,SEGMENT5,ATTRIBUTE3
        --               ) S_OCV
        --        ON  BOD.ATTRIBUTE1 = S_OCV.FROM_SITE_ID
        --        AND BOD.ATTRIBUTE2 = S_OCV.ITEM_ID
        --WHERE   PLAN_ID = @V_PLAN_ID
        --AND     EFF_START_DATE <= @FROM_DATE
        
        ---- EFF_END_DATE가 @FROM_DATE보다 작으면 임시테이블에서 추가된 값으로 넣어야하기 때문에 DELETE 처리
        --DELETE FROM SCP_OPT_ENG_BOD_SN
        --    FROM SCP_OPT_ENG_BOD_SN BOD
        --    INNER JOIN (
        --               SELECT  SEGMENT4   AS FROM_SITE_ID
        --                      ,SEGMENT5   AS ITEM_ID
        --                      ,ATTRIBUTE3 AS LU_STAGE
        --               FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --               WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        --               AND     VALID_YN    = 'Y'
        --               AND     ATTRIBUTE1  = 'B'
        --               AND     SEGMENT2    = @V_DIVISION_ID
        --               AND     SEGMENT3    = @V_GROUP_ID
        --               GROUP BY SEGMENT4,SEGMENT5,ATTRIBUTE3
        --               ) S_OCV
        --        ON  BOD.ATTRIBUTE1 = S_OCV.FROM_SITE_ID
        --        AND BOD.ATTRIBUTE2 = S_OCV.ITEM_ID
        --WHERE   BOD.PLAN_ID = @V_PLAN_ID
        --AND     BOD.EFF_END_DATE <= @FROM_DATE
        
        ---- BOD 변경이 일어나는 데이터 업데이트
        --UPDATE  BOD
        --SET     BOD.BOD_ID = BOD.TRANSPORT_MODE+'::'+BOD.ATTRIBUTE1+'::'+BOD.ATTRIBUTE2+'::'+S_OCV.LU_STAGE+'::'+BOD.TO_BUFFER_ID+'::'+BOD.ATTRIBUTE7+'::'+BOD.EFF_START_DATE
        --       ,BOD.FROM_BUFFER_ID = BOD.ATTRIBUTE1+'::'+BOD.ATTRIBUTE2+'::'+S_OCV.LU_STAGE
        --       ,BOD.ATTRIBUTE3 = S_OCV.LU_STAGE
        --       ,EFF_START_DATE = IIF(EFF_START_DATE >= @FROM_DATE,EFF_START_DATE,@FROM_DATE)
        --FROM    SCP_OPT_ENG_BOD_SN BOD
        --    INNER JOIN (
        --               SELECT  SEGMENT4   AS FROM_SITE_ID
        --                      ,SEGMENT5   AS ITEM_ID
        --                      ,ATTRIBUTE3 AS LU_STAGE
        --               FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --               WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        --               AND     VALID_YN    = 'Y'
        --               AND     ATTRIBUTE1  = 'B'
        --               AND     SEGMENT2    = @V_DIVISION_ID
        --               AND     SEGMENT3    = @V_GROUP_ID
        --               GROUP BY SEGMENT4,SEGMENT5,ATTRIBUTE3
        --               ) S_OCV
        --        ON  BOD.ATTRIBUTE1 = S_OCV.FROM_SITE_ID
        --        AND BOD.ATTRIBUTE2 = S_OCV.ITEM_ID
        --WHERE   EFF_END_DATE > @FROM_DATE
        --AND     PLAN_ID = @V_PLAN_ID
        
        ---- 위 업데이트 구문에 걸리면 안되므로 맨 마지막에 FROM_DATE가 FROM_DAYS보다 작은 데이터 INSERT
        --INSERT INTO SCP_OPT_ENG_BOD_SN(PLAN_ID            
        --                              ,BOD_ID             
        --                              ,FROM_BUFFER_ID     
        --                              ,TO_BUFFER_ID       
        --                              ,TRANSPORT_MODE     
        --                              ,PRIORITY           
        --                              ,TRANSIT_COST       
        --                              ,EFF_START_DATE     
        --                              ,EFF_END_DATE       
        --                              ,DEFAULT_LEAD_TIME  
        --                              ,SUNDAY_LEAD_TIME   
        --                              ,MONDAY_LEAD_TIME   
        --                              ,TUESDAY_LEAD_TIME  
        --                              ,WEDNESDAY_LEAD_TIME
        --                              ,THURSDAY_LEAD_TIME 
        --                              ,FRIDAY_LEAD_TIME   
        --                              ,SATURDAY_LEAD_TIME 
        --                              ,RESOURCE_ID        
        --                              ,LOAD_PER           
        --                              ,CONTAINER_CATEGORY 
        --                              ,CONTAINER_SIZE     
        --                              ,USER_ATTB1         
        --                              ,USER_ATTB2         
        --                              ,USER_ATTB3         
        --                              ,USER_ATTB4         
        --                              ,USER_ATTB5         
        --                              ,USER_ATTB6         
        --                              ,USER_ATTB7         
        --                              ,USER_ATTB8         
        --                              ,TYPE               
        --                              ,ATTRIBUTE1         
        --                              ,ATTRIBUTE2         
        --                              ,ATTRIBUTE3         
        --                              ,ATTRIBUTE4         
        --                              ,ATTRIBUTE5         
        --                              ,ATTRIBUTE6         
        --                              ,ATTRIBUTE7         
        --                              ,ATTRIBUTE8         
        --                              ,ATTRIBUTE9         
        --                              ,ATTRIBUTE10        
        --                              ,ATTRIBUTE11        
        --                              ,ATTRIBUTE12        
        --                              ,ATTRIBUTE13        
        --                              ,ATTRIBUTE14        
        --                              ,ATTRIBUTE15        
        --                              )
        --SELECT  PLAN_ID            
        --       ,BOD_ID             
        --       ,FROM_BUFFER_ID     
        --       ,TO_BUFFER_ID       
        --       ,TRANSPORT_MODE     
        --       ,PRIORITY           
        --       ,TRANSIT_COST       
        --       ,EFF_START_DATE     
        --       ,EFF_END_DATE       
        --       ,DEFAULT_LEAD_TIME  
        --       ,SUNDAY_LEAD_TIME   
        --       ,MONDAY_LEAD_TIME   
        --       ,TUESDAY_LEAD_TIME  
        --       ,WEDNESDAY_LEAD_TIME
        --       ,THURSDAY_LEAD_TIME 
        --       ,FRIDAY_LEAD_TIME   
        --       ,SATURDAY_LEAD_TIME 
        --       ,RESOURCE_ID        
        --       ,LOAD_PER           
        --       ,CONTAINER_CATEGORY 
        --       ,CONTAINER_SIZE     
        --       ,USER_ATTB1         
        --       ,USER_ATTB2         
        --       ,USER_ATTB3         
        --       ,USER_ATTB4         
        --       ,USER_ATTB5         
        --       ,USER_ATTB6         
        --       ,USER_ATTB7         
        --       ,USER_ATTB8         
        --       ,TYPE               
        --       ,ATTRIBUTE1         
        --       ,ATTRIBUTE2         
        --       ,ATTRIBUTE3         
        --       ,ATTRIBUTE4         
        --       ,ATTRIBUTE5         
        --       ,ATTRIBUTE6         
        --       ,ATTRIBUTE7         
        --       ,ATTRIBUTE8         
        --       ,ATTRIBUTE9         
        --       ,ATTRIBUTE10        
        --       ,ATTRIBUTE11        
        --       ,ATTRIBUTE12        
        --       ,ATTRIBUTE13        
        --       ,ATTRIBUTE14        
        --       ,ATTRIBUTE15       
        --FROM    @BOD_TEMP

		
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

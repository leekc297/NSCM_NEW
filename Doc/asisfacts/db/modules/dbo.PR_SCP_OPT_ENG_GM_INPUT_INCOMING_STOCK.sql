

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.07.07 Philsu Park: Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.PA
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @P_PLAN_TYPE         NVARCHAR(4000);
    DECLARE @P_SEQ               NVARCHAR(4000);
    DECLARE @P_MODELING_ID       NVARCHAR(4000);
    DECLARE @V_CUTOFF_DAY        NVARCHAR(8);
    DECLARE @D_CUTOFF_DAY        DATETIME;
    DECLARE @V_DEMAND_CUTOFF_DAY NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATE;
    DECLARE @MAX_TUESDAY         NVARCHAR(8)
    DECLARE @MAT_CONST_TEMP TABLE(
                                  MAT_ID       NVARCHAR(200)
                                 ,EFF_END_DATE NVARCHAR(8)
                                 )
    DECLARE @DM_TEMP TABLE(
     SITE_ID      NVARCHAR(100)
    ,ITEM_ID      NVARCHAR(100)
    ,INCOTERMS    NVARCHAR(100)
    ,PROJECT_CODE NVARCHAR(100)
    )
    DECLARE @OCV_EXCEPT_LIST TABLE(
     SCM_SITE_ID NVARCHAR(100)
    ,ITEM_ID     NVARCHAR(100)
    )
    -- 셀 생산지 버퍼 추가
    DECLARE @CELL_PROD_SITE TABLE(
      SALES_SITE_ID   NVARCHAR(200)
    , ITEM_ID         NVARCHAR(200)
    , OPERATION_GROUP NVARCHAR(10)
    )
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
        -- Get Param Info
        ------------------------------------------------------------------------
        SELECT @V_DIVISION_ID       = ATTRIBUTE1 
              ,@V_GROUP_ID          = ATTRIBUTE2 
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
        WHERE   BASIS_YYYYMMDD <= @V_PLAN_START_YYYYMMDD
        AND     DAYOFWEEK = 'TUE'

        SELECT @P_MODELING_ID       = MODELING_ID FROM SCM_MST_MODELING WITH(NOLOCK) WHERE PLAN_CYCLE = 'WEEKLY' AND DIVISION_ID = @V_DIVISION_ID;
        SELECT @P_PLAN_NAME         = @V_PLAN_START_YYYYMMDD;
        SELECT @D_PLAN_NAME         = CONVERT(DATE, @P_PLAN_NAME);


        SELECT @V_CUTOFF_DAY        = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)), 112);
        SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
        SELECT @V_DEMAND_CUTOFF_DAY  =  MAX(P.CUTOFF_YYYYMMDD)
                                        FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                        WHERE  P.DIVISION_ID      = @V_DIVISION_ID 							
                                        AND    P.CUTOFF_YYYYMMDD <= @V_PLAN_START_YYYYMMDD 
                                        AND    P.CUTOFF_YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD, -28, @MAX_TUESDAY), 112)

        ------------------------------------------------------------------------
        --자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용
        ------------------------------------------------------------------------
        --SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
        --FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        --WHERE  PLAN_ID = @V_PLAN_ID
        
        -- START 2025.11.19 jongykim2: Schelduled Reciept Information
        INSERT INTO @MAT_CONST_TEMP
        SELECT   ITEM_ID_CHILD AS MAT_ID
                ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(TO_YYYYMMDD)),112) AS EFF_END_DATE
        FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
        INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
        ON     LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
        WHERE  LU.DIVISION_ID     = @V_DIVISION_ID
        AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
        AND    LU.VALID_YN        = 'Y'
        AND    PG.VALID_YN        = 'Y'
        GROUP BY ITEM_ID_CHILD
        -- END 2025.11.19 jongykim2: Schelduled Reciept Information
        /* -- BLOCKED 2025.11.19 jongykim2
        SELECT   ATTRIBUTE1 AS MAT_ID
                ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
        FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
        AND      LU.VALID_YN    = 'Y'
        AND      LU.SEGMENT2    = @V_DIVISION_ID
        AND      LU.SEGMENT3    = @V_GROUP_ID
        GROUP BY ATTRIBUTE1
        */
        ------------------------------------------------------------------------
        --2nd OCV에 활용된 SUB MDLE 재고는 제외하기 위해서
        ------------------------------------------------------------------------
        INSERT INTO @OCV_EXCEPT_LIST
        SELECT MS.SCM_SITE_ID
              ,CHILD_ITEM_ID
        FROM SCM_MST_BOM_SN_V BOM WITH(NOLOCK)
            INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                ON BOM.PLANT_ID = MS.PLANT_ID
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                AND LU.VALID_YN    = 'Y'
                AND LU.SEGMENT2    = @V_DIVISION_ID
                AND LU.SEGMENT3    = @V_GROUP_ID
                AND LU.ATTRIBUTE1  = 'B'
        WHERE   1=1
        AND     MS.SCM_SITE_ID     = LU.SEGMENT4
        AND     BOM.PARENT_ITEM_ID = LU.SEGMENT5
        GROUP BY MS.SCM_SITE_ID, CHILD_ITEM_ID
        ------------------------------------------------------------------------
        -- 셀 생산지 버퍼 추가
        ------------------------------------------------------------------------
        INSERT INTO @CELL_PROD_SITE
        SELECT  LU.SEGMENT3            AS SALES_SITE_ID
               ,LU.SEGMENT4            AS ITEM_ID
               ,'_'+FI.OPERATION_GROUP AS OPERATION_GROUP
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
                ON  LU.SEGMENT1 = FI.DIVISION_ID
                AND LU.SEGMENT4 = FI.ITEM_ID
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
        AND     LU.SEGMENT1 = @V_DIVISION_ID
        AND     LU.SEGMENT2 = @V_GROUP_ID
        ------------------------------------------------------------------------
        --테스트를 위해 25년07주차로 고정
        ------------------------------------------------------------------------
        --SELECT @P_PLAN_NAME         = '20250210'; -- 당주 월요일 YYYYMMDD
        --SELECT @V_CUTOFF_DAY        = '20250209'; -- 지난주 일요일 YYYYMMDD
        --SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
        --SELECT @MAX_TUESDAY         = '20250211'
        --SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------

		IF OBJECT_ID('TEMPDB..#SCP_INVENTORY_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INVENTORY_I;
		END;		

		IF OBJECT_ID('TEMPDB..#SCP_INTRANSIT_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INTRANSIT_I;
		END;

		IF OBJECT_ID('TEMPDB..#CP_INFO') IS NOT NULL
		BEGIN 
			DROP TABLE  #CP_INFO;
		END;
		
        --------------------------------------------------------
        -- 재고 / 해상재고 INPUT 생성 전 중간 정보 생성 PROC 참고
        --     PR_SCP_ENG_IN_PRE_SET_INVENTORY
        --     PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS
        --------------------------------------------------------
        
        --------------------------------------------------------
        -- 1. 창고 재고 : WH
        --------------------------------------------------------
        -- 1.1 SALES 재고
		SELECT --DISTINCT 
               A.DIVISION_ID   AS DIVISION_ID
			  ,A.SCM_SITE_ID   AS SCM_SITE_ID 
			  ,'-'             AS INCOTERMS -- 뒤에서 별도 UPDATE 
			  ,A.STOCK_TYPE
			  ,A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              --,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              --      WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN CONVERT(CHAR(8), AVAILABLE_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATETIME, @P_PLAN_NAME)
                    ELSE                                                           CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))  
               END AS AVAILABLE_DATE
			  ,A.SCM_QTY AS QTY -- SCP 사용 QTY
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = '' THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
			  ,B.SITE_TYPE
			 , '-'                        AS location_code -- PLANT 재고 구분용 정보
             , '-'                        AS PROJECT_CODE  -- 뒤에서 별도 UPDATE
             , ISNULL(MSP.SCM_SITE_ID,'') AS CELL_PROD_SITE_ID
             , NULL                       AS OPERATION_ID
             , NULL                       AS LINE_ID
             , NULL                       AS B_DEGAS_YN
             , 'SALES'                    AS FLAG
		INTO   #SCP_INVENTORY_I
		FROM   SCM_DNM_STOCK      A WITH (NOLOCK)  

			   -- SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음
			 -- ,(SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
    --            FROM   SCM_MST_SITE  WITH(NOLOCK)
				--WHERE  1=1
    --            AND    SITE_TYPE        = 'SALES'
    --           ) B
            --소형 생산지 구분을 위한 분리
            INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                        FROM   SCM_MST_SITE  WITH(NOLOCK)
	                	WHERE  1=1
                        AND    SITE_TYPE        = 'SALES'
                       ) B
                ON  A.DIVISION_ID = B.DIVISION_ID
                AND A.SCM_SITE_ID = B.SCM_SITE_ID
            --INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
            --    ON A.PLANT_ID = MS.PLANT_ID
            LEFT OUTER JOIN @OCV_EXCEPT_LIST OCV
                ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                AND A.MES_ITEM_ID = OCV.ITEM_ID
            LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                ON  1=1
                AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
                AND A.ITEM_ID     = CPS.ITEM_ID
            LEFT OUTER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID,PLANT_ID
                             FROM   SCM_MST_SITE  WITH(NOLOCK)
	                	     WHERE  1=1
                             AND    PLANT_ID IS NOT NULL
                            ) MSP
                ON  1=1
                AND A.DIVISION_ID                  = MSP.DIVISION_ID
                AND A.PLANT_ID+CPS.OPERATION_GROUP = MSP.SCM_SITE_ID
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.DIVISION_ID      = @V_DIVISION_ID
        AND    OCV.ITEM_ID        IS NULL
		-- 소형은 CEll Biz 용 Demand 만 처리
		AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
			OR  (A.DIVISION_ID <> '40' )
			)
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        --AND    A.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
        --					 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
        --					 WHERE   PLAN_ID = @V_PLAN_ID
        --					 )
        AND (    (A.DIVISION_ID = '40' AND   CONCAT(B.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                  FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                                                  WHERE   PLAN_ID = @V_PLAN_ID
                                                                                  )
                 )
              OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                           WHERE   PLAN_ID = @V_PLAN_ID
                                                           )
                 )
             )
		;

        ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN INCOTERMS VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN location_code VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN LINE_ID VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN OPERATION_ID VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN B_DEGAS_YN VARCHAR(100) NULL;

        -- 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리
        INSERT INTO #SCP_INVENTORY_I
		SELECT --DISTINCT 
               A.DIVISION_ID      AS DIVISION_ID
			  ,A.TO_SCM_SITE_ID   AS SCM_SITE_ID
			  ,'-'                AS INCOTERMS -- 뒤에서 별도 UPDATE 
			  ,'SO'      AS STOCK_TYPE
			  ,A.ITEM_ID AS ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전
			  -- 엔진 오류로 Plan 구간 안으로 처리
              --,CONVERT(DATETIME, @V_CUTOFF_DAY) AS AVAILABLE_DATE
              ,CONVERT(DATETIME, @P_PLAN_NAME) AS AVAILABLE_DATE

			  ,A.DELIVERY_QTY AS QTY
			  ,'N'       AS WIPHOLD_YN
			  ,B.SITE_TYPE
			 , '-'             AS location_code -- PLANT 재고 구분용 정보
             , IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
             , IIF(CPS.ITEM_ID IS NULL,'',A.FROM_SCM_SITE_ID) AS CELL_PROD_SITE_ID
             , NULL            AS OPERATION_ID
             , NULL            AS LINE_ID
             , NULL            AS B_DEGAS_YN
             , 'SALES'         AS FLAG
		FROM   SCM_DNM_INTRANSIT_C  A WITH (NOLOCK)
            INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                FROM   SCM_MST_SITE  WITH(NOLOCK)
				WHERE  1=1
                AND    SITE_TYPE        = 'SALES'
               ) B
                ON  1=1
                AND A.DIVISION_ID    = B.DIVISION_ID
                AND A.TO_SCM_SITE_ID = B.SCM_SITE_ID
            LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                ON  1=1
                AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                AND A.ITEM_ID        = CPS.ITEM_ID
		WHERE  1 = 1
        AND    A.DIVISION_ID      = @V_DIVISION_ID
        AND    A.RESULT_DATE      = @V_CUTOFF_DAY
		-- SO Reserve Stock : result_type = 'B' 는 재고로 처리               
        AND    A.RESULT_TYPE      = 'B'                  
		AND    A.VALID_YN         = 'Y'   -- 해상재고      
		-- 소형은 CEll Biz 용 Demand 만 처리
		AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
			OR  (A.DIVISION_ID <> '40' )
			)
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
				    --       FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
				    --       WHERE   PLAN_ID = @V_PLAN_ID
				    --       )
        --소형 생산지 구분을 위한 분리
        AND (    (A.DIVISION_ID = '40' AND   CONCAT(A.FROM_SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                  FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                                                  WHERE   PLAN_ID = @V_PLAN_ID
                                                                                  )
                 )
              OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                           WHERE   PLAN_ID = @V_PLAN_ID
                                                           )
                 )
             )
	   ;  

        -- 1.3 SALES 재고 : INCOTERMS UPDATE
        UPDATE #SCP_INVENTORY_I
        SET    INCOTERMS  = ISNULL(ISNULL(B.MAX_INCOTERMS, C.MAX_INCOTERMS), 'DAP') -- DEMAND 없는 경우 DAP 처리
        FROM   #SCP_INVENTORY_I A
        LEFT JOIN ( SELECT  AA.SCM_SITE_ID, AA.ITEM_ID
				             --  VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) 
		                   ,MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP' 
                                ELSE AA.INCOTERMS
                                END ) MAX_INCOTERMS
                     FROM   DM_PLN_NET_DEMAND AA WITH(NOLOCK)
                            INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                        FROM   DM_PLN_NET_DEMAND WITH(NOLOCK)
                                        WHERE  DIVISION_ID     = @V_DIVISION_ID 
                                        AND    CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY -- @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                        GROUP BY  SCM_SITE_ID
                                        ) BB
                            ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                            AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                            AND AA.DIVISION_ID     = @V_DIVISION_ID 
                            AND AA.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY   

                            LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN 
                                        FROM   SCM_MST_SITE WITH (NOLOCK)
                                        WHERE  DIVISION_ID = @V_DIVISION_ID
                                        AND    VMI_YN      = 'Y') CC
                            ON     AA.DIVISION_ID = CC.DIVISION_ID 
                            AND    AA.SCM_SITE_ID = CC.SCM_SITE_ID 
                     GROUP BY AA.SCM_SITE_ID, AA.ITEM_ID
                   ) B
        ON     A.SCM_SITE_ID = B.SCM_SITE_ID 
        AND    A.ITEM_ID     = B.ITEM_ID 
        
        LEFT JOIN ( SELECT AA.SCM_SITE_ID
				            --  VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) 
		                  , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP' 
                                ELSE AA.INCOTERMS
                                END ) MAX_INCOTERMS
                    FROM   DM_PLN_NET_DEMAND AA WITH(NOLOCK)
                           INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                       FROM   DM_PLN_NET_DEMAND WITH(NOLOCK)
                                       WHERE  DIVISION_ID     = @V_DIVISION_ID   
                                       AND    CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY -- @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                       GROUP BY  SCM_SITE_ID
                                       ) BB
                           ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                           AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                           AND AA.DIVISION_ID     = @V_DIVISION_ID 
                           AND AA.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY   

                           LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN 
                                       FROM   SCM_MST_SITE WITH (NOLOCK)
                                       WHERE  DIVISION_ID = @V_DIVISION_ID
                                       AND    VMI_YN      = 'Y') CC
                           ON     AA.DIVISION_ID = CC.DIVISION_ID 
                           AND    AA.SCM_SITE_ID = CC.SCM_SITE_ID 
                    GROUP BY AA.SCM_SITE_ID
                   ) C
        ON     A.SCM_SITE_ID = C.SCM_SITE_ID 

		WHERE  1=1
		AND    A.SITE_TYPE       = 'SALES'
		;

        -- 1.4 PLANT 재고
		INSERT INTO   #SCP_INVENTORY_I
		SELECT A.DIVISION_ID   AS DIVISION_ID
			  ,A.SCM_SITE_ID   AS SCM_SITE_ID 
			  ,'-'             AS INCOTERMS
			  ,A.STOCK_TYPE
			  ,A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              --,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              --      WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN CONVERT(CHAR(8), AVAILABLE_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATETIME, @P_PLAN_NAME)
                    ELSE                                                           CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))  
               END AS AVAILABLE_DATE
			  ,A.SCM_QTY AS QTY 
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = '' THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
			  ,B.SITE_TYPE
			 , CASE WHEN ISNULL(op.location_code, '') <> '' OR ISNULL(st.location_code, '') <> '' THEN 'ASSY'
			       ELSE '-'
			   END           AS location_code -- PLANT 재고 구분용 정보
             ,''             AS PROJECT_CODE
             ,''             AS CELL_PROD_SITE_ID
             ,A.OPERATION_ID AS OPERATION_ID
             ,A.LINE_ID      AS LINE_ID
             ,NULL           AS B_DEGAS_YN
             ,'PLANT' AS FLAG
		FROM   SCM_DNM_STOCK      A WITH (NOLOCK)  

		INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                FROM   SCM_MST_SITE  WITH(NOLOCK)
				WHERE  1=1
                AND    DIVISION_ID      = @V_DIVISION_ID  
                AND    SITE_TYPE        = 'PLANT'
                --AND    OPERATION_GROUP IN ('A', 'P')
				AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외
					OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
					)
               ) B
		ON     A.DIVISION_ID      = B.DIVISION_ID
        AND    A.SCM_SITE_ID      = B.SCM_SITE_ID
               
        LEFT JOIN (  SELECT DISTINCT
                               a.operation_id
                            ,  a.location_code
                            ,  a.scm_site_id
                    FROM   scm_mst_location a WITH (NOLOCK)
                            INNER JOIN (SELECT scm_site_id  
                                        FROM   scm_mst_site
                                        WHERE  division_id     = @V_DIVISION_ID  
                                        AND    valid_yn        = 'Y'
                                        AND    operation_group IN ( 'A' ) 
                                        ) b
                            ON a.scm_site_id = b.scm_site_id 
                    WHERE  a.division_id = @V_DIVISION_ID --'81'
                    AND    a.valid_yn    = 'Y'
                    AND    location_code = 'PACKAGING' --활성화 전 재고
                    AND    (operation_id IS NOT NULL AND operation_id <> '')
                )  op -- 셀의 operation_id 별 사용대상 조회
        ON   A.operation_id = op.operation_id 
        AND  A.scm_site_id  = op.scm_site_id		   
               
        LEFT JOIN (  SELECT DISTINCT
                               a.storage_id
                            ,  a.location_code
                            ,  a.scm_site_id
                    FROM   DBO.scm_mst_location a WITH (NOLOCK)
                            INNER JOIN (SELECT scm_site_id  
                                        FROM   scm_mst_site
                                        WHERE  division_id     = @V_DIVISION_ID  
                                        AND    valid_yn        = 'Y'
                                        AND    operation_group IN ( 'A' ) 
                                        ) b
                            ON a.scm_site_id = b.scm_site_id 
                    WHERE  a.division_id = @V_DIVISION_ID --'81'
                    AND    a.valid_yn    = 'Y'
                    AND    location_code = 'PACKAGING' --활성화 전 재고
                    AND    (storage_id IS NOT NULL AND storage_id <> '')
                )  st -- 셀의 storage_id 별 사용대상 조회
        ON   A.storage_id   = st.storage_id 
        AND  A.scm_site_id  = st.scm_site_id
            --소형 생산지 구분을 위한 분리
            --INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
            --    ON A.PLANT_ID = MS.PLANT_ID
            LEFT OUTER JOIN @OCV_EXCEPT_LIST OCV
                ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                AND A.MES_ITEM_ID = OCV.ITEM_ID
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.DIVISION_ID      = @V_DIVISION_ID
        AND    OCV.ITEM_ID        IS NULL
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
          --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
		        --			 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
		        --			 WHERE   PLAN_ID = @V_PLAN_ID
		        --			 )
        --소형 생산지 구분을 위한 분리
        AND (    (A.DIVISION_ID = '40' AND   CONCAT(B.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                  FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                                                  WHERE   PLAN_ID = @V_PLAN_ID
                                                                                  )
                 )
              OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                           WHERE   PLAN_ID = @V_PLAN_ID
                                                           )
                 )
             )
		;
        --------------------------------------------------------
        -- 2. 활성화 재고 : FOR
        -- 2026.05.08 Minyong Lee : 활성화 재고 뷰 중복 스캔 제거 (쿼리 수행 시간 단축)
        --------------------------------------------------------
        WITH BASE_STOCK AS (
            SELECT *
                    ,MAX(CUTOFF_DATE) OVER (PARTITION BY DIVISION_ID, SITE_ID) AS MAX_CUTOFF_DATE
            FROM  SCM_DNM_STOCK_AGING_V WITH (NOLOCK)
            WHERE DIVISION_ID = @V_DIVISION_ID
            AND   CUTOFF_DATE >  DATEADD(DD, -7, @D_CUTOFF_DAY)  -- C의 조건을 여기서 한번에 처리
            AND   CUTOFF_DATE <= @D_CUTOFF_DAY
        )
		INSERT INTO   #SCP_INVENTORY_I
		SELECT A.DIVISION_ID   AS DIVISION_ID
			  ,A.SCM_SITE_ID   AS SCM_SITE_ID 
			  ,'-'             AS INCOTERMS
			  ,'FOR'           AS STOCK_TYPE 
			  ,A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CASE WHEN A.BEFORE_DEGAS != 'Y' AND CONVERT(CHAR(8), A.AVAILABLE_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATE, @P_PLAN_NAME)
                    WHEN A.BEFORE_DEGAS = 'Y'  AND CONVERT(CHAR(8), A.DEGAS_END_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATE, @P_PLAN_NAME) -- BEFORE DEGAS인 경우 DEGAS_END_DATE를 찍어줌
                    WHEN A.BEFORE_DEGAS = 'Y' THEN CONVERT(DATE, DEGAS_END_DATE)
                    ELSE A.AVAILABLE_DATE
               END  AS AVAILABLE_DATE
			  ,A.QTY  AS QTY 
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = '' THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
			  ,'PLANT' AS SITE_TYPE
			 , '-'             AS location_code -- PLANT 재고 구분용 정보
              ,''              AS PROJECT_CODE
              , ''             AS CELL_PROD_SITE_ID
              ,NULL            AS OPERATION_ID
              ,LINE_ID         AS LINE_ID
              ,BEFORE_DEGAS    AS B_DEGAS_YN
              ,'PLANT'         AS FLAG
        FROM   (
               SELECT A.*
               FROM   BASE_STOCK A
               WHERE  A.CUTOFF_DATE = A.MAX_CUTOFF_DATE
               AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
               ) A

               -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경
               LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, SITE_TYPE 
                            FROM   SCM_MST_SITE  WITH(NOLOCK) 
                            WHERE  1=1
		                    AND    DIVISION_ID   = @V_DIVISION_ID
                            AND    SITE_TYPE     = 'PLANT'	
                            AND    ISNULL(OSP_YN, 'N')  = 'N' --20180822 추가
                          ) B
               ON   A.SCM_SITE_ID   = B.SCM_SITE_ID 
               LEFT OUTER JOIN SCP_MST_FORMATION_V MF WITH(NOLOCK)
                ON  A.DIVISION_ID = MF.DIVISION_ID
                AND A.SCM_SITE_ID = MF.PLANT_SITE_ID
                AND A.ITEM_ID     = MF.ITEM_ID
        WHERE  B.DIVISION_ID IS NOT NULL -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함  
			 
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                   )

        --------------------------------------------------------
        -- 3. 해상 재고 : INT
        --------------------------------------------------------
        -- 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
        SELECT A.DIVISION_ID  AS DIVISION_ID
              ,A.ITEM_ID
              ,A.TO_SCM_SITE_ID   AS TO_SCM_SITE_ID
              ,A.FINAL_INCOTERMS  AS INCOTERMS
                -- 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CASE WHEN A.ETA_DATE < @P_PLAN_NAME THEN @P_PLAN_NAME
                    ELSE A.ETA_DATE
               END  AS ETA_DATE
	          ,A.DELIVERY_QTY
              --,IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
              ,CASE WHEN TS.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-' -- 법인간 이동 재고에는 Project Code 정보가 없음 
			        WHEN TS.SITE_TYPE = 'SALES' THEN IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) 
			        WHEN TS.SITE_TYPE = 'PLANT' THEN '' -- Plant 도착은 NULL 처리
			        ELSE IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) 
			   END AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
              ,IIF(CPS.ITEM_ID IS NULL,'',A.FROM_SCM_SITE_ID) AS CELL_PROD_SITE_ID
              ,NULL            AS OPERATION_ID
              ,NULL            AS LINE_ID
              ,NULL            AS B_DEGAS_YN
              ,TS.SITE_TYPE AS FLAG
		INTO   #SCP_INTRANSIT_I
		FROM   SCM_DNM_INTRANSIT_V  A WITH (NOLOCK)
               INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V WITH (NOLOCK)) FI
               ON   A.DIVISION_ID          = FI.DIVISION_ID
               AND  A.ITEM_ID              = FI.ITEM_ID
               AND  FI.OPERATION_GROUP_ID <> 'E' -- 전극 모델은 제외

               INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                           FROM   SCM_MST_SITE WITH (NOLOCK) 
                           WHERE  DIVISION_ID = @V_DIVISION_ID
                           AND    SITE_TYPE   = 'PLANT' 
                           AND    OPERATION_GROUP IN ('A', 'P') -- FROM_SITE 가 전극인 정보 제외
						   AND    VALID_YN    = 'Y'	
                         )  FS
               ON   A.DIVISION_ID          = FS.DIVISION_ID
               AND  A.FROM_SCM_SITE_ID     = FS.SCM_SITE_ID
				AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' )      -- 소형은 CEll Biz 용 Demand 만 처리
					OR  (FS.DIVISION_ID <> '40' )
					)	
			   
                INNER JOIN SCM_MST_SITE TS WITH (NOLOCK) 
                ON  A.DIVISION_ID    = TS.DIVISION_ID
                AND A.TO_SCM_SITE_ID = TS.SCM_SITE_ID
                --AND TS.SITE_TYPE      = 'SALES'
                AND TS.VALID_YN       = 'Y'	
				AND ((TS.DIVISION_ID  = '40' AND TS.SITE_TYPE = 'SALES' )      -- 소형은 CEll Biz 용 Demand 만 처리
					OR  (TS.DIVISION_ID <> '40' )
					)	
                LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                    ON  1=1
                    AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                    AND A.ITEM_ID        = CPS.ITEM_ID
        WHERE  1=1
        AND    A.DIVISION_ID   = @V_DIVISION_ID
        AND    A.RESULT_DATE   = @V_CUTOFF_DAY
		AND    A.RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
		
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --				 )
        --소형 생산지 구분을 위한 분리
        AND (    (A.DIVISION_ID = '40' AND   CONCAT(A.FROM_SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                  FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                                                  WHERE   PLAN_ID = @V_PLAN_ID
                                                                                  )
                 )
              OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                           WHERE   PLAN_ID = @V_PLAN_ID
                                                           )
                 )
             )

        ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL;
        ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN OPERATION_ID VARCHAR(100) NULL;
        ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN LINE_ID VARCHAR(100) NULL;
        ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN B_DEGAS_YN VARCHAR(100) NULL;
        -- 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함
        INSERT INTO   #SCP_INTRANSIT_I		
		SELECT A.DIVISION_ID
              ,A.ITEM_ID
              ,MS.SCM_SITE_ID              AS TO_SCM_SITE_ID
              ,'DAP'                       AS INCOTERMS -- VMI 임
              -- 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CONVERT(NVARCHAR(8), DATEADD(D, 1, A.CUTOFF_DATE), 112)  AS ETA_DATE -- PLAN 시작일자로 처리	
	          ,ISNULL(A.SCM_QTY, 0)        AS DELIVERY_QTY
              ,'-'                         AS PROJECT_CODE
              , ISNULL(MSP.SCM_SITE_ID,'') AS CELL_PROD_SITE_ID
              ,NULL                        AS OPERATION_ID
              ,NULL                        AS LINE_ID
              ,NULL                        AS B_DEGAS_YN
              ,'SALES'                     AS FLAG
		FROM   SCM_DNM_STOCK  A WITH (NOLOCK)
               INNER JOIN SCM_MST_VMI_INT_SLOC MS WITH(NOLOCK)
               ON    A.DIVISION_ID = MS.DIVISION_ID	
               AND   A.PLANT_ID    = MS.PLANT_ID
               AND   A.STORAGE_ID  = MS.STORAGE_ID
               AND   MS.VALID_YN   = 'Y'
            --소형 생산지 구분을 위한 분리
            INNER JOIN SCM_MST_SITE MSS WITH(NOLOCK)
                ON A.PLANT_ID = MSS.PLANT_ID
            LEFT OUTER JOIN @OCV_EXCEPT_LIST OCV
                ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                AND A.MES_ITEM_ID = OCV.ITEM_ID
            LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                ON  1=1
                AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
                AND A.ITEM_ID     = CPS.ITEM_ID
            LEFT OUTER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID,PLANT_ID
                             FROM   SCM_MST_SITE  WITH(NOLOCK)
	                	     WHERE  1=1
                             AND    PLANT_ID IS NOT NULL
                            ) MSP
                ON  1=1
                AND A.DIVISION_ID                  = MSP.DIVISION_ID
                AND A.PLANT_ID+CPS.OPERATION_GROUP = MSP.SCM_SITE_ID
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.DIVISION_ID      = @V_DIVISION_ID
        AND    OCV.ITEM_ID        IS NULL
		-- 소형은 CEll Biz 용 Demand 만 처리
		AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
			OR  (A.DIVISION_ID <> '40' )
			)
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                   )
        --소형 생산지 구분을 위한 분리
        AND (    (A.DIVISION_ID = '40' AND   CONCAT(MSS.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                  FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                                  WHERE   PLAN_ID = @V_PLAN_ID
                                                                                  )
                 )
              OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                           WHERE   PLAN_ID = @V_PLAN_ID
                                                           )
                 )
             )

        --------------------------------------------------------
        -- UPDATE PROJECT
        --------------------------------------------------------
            --------------------------------------------------------
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
            --------------------------------------------------------
            -- #SCP_INVENTORY_I 프로젝트 UPDATE
            --------------------------------------------------------
            -- START 2025-12-15 jongykim2: Demand Group Master
            IF OBJECT_ID('TEMPDB..#DEMAND_GROUP_T') IS NOT NULL
            BEGIN 
                DROP TABLE  #DEMAND_GROUP_T;
            END;
            SELECT T2.DIVISION_ID
                 , T2.ITEM_ID
                 , T.GROUP_NAME AS DEMAND_GROUP
                 , T2.PROJECT_CODE
            INTO   #DEMAND_GROUP_T
            FROM   SCP_MST_ITEM_GROUP T WITH(NOLOCK)
            INNER JOIN SCP_MST_ITEM_GROUP_DETAIL T2 WITH(NOLOCK)
            ON     T2.DIVISION_ID = T.DIVISION_ID
            AND    T2.GROUP_ID = T.GROUP_ID
            WHERE  1 = 1
            AND    T.DIVISION_ID = @V_DIVISION_ID
            AND    T.VALID_YN = 'Y'
            AND    ISNULL(T.ATTRIBUTE1, 'N') <> 'Y'
            AND    T2.VALID_YN = 'Y'
            ;
            -- END 2025-12-15 jongykim2:
            UPDATE #SCP_INVENTORY_I
            SET #SCP_INVENTORY_I.PROJECT_CODE = DJ.PROJECT_CODE
            FROM #SCP_INVENTORY_I INV
                INNER JOIN(
                           SELECT INV.DIVISION_ID
                                 ,INV.SCM_SITE_ID
                                 ,INV.INCOTERMS
                                 ,INV.STOCK_TYPE
                                 ,INV.ITEM_ID
                                 ,INV.MDF_ITEM_ID
                                 ,INV.AVAILABLE_DATE
                                 ,INV.QTY
                                 ,INV.WIPHOLD_YN
                                 ,INV.SITE_TYPE
                                 ,INV.LOCATION_CODE
                                 ,DT.PROJECT_CODE
                           FROM(
                                SELECT  INV.DIVISION_ID
                                       ,INV.SCM_SITE_ID
                                       ,INV.INCOTERMS
                                       ,INV.STOCK_TYPE
                                       ,INV.ITEM_ID
                                       --,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                       ,IIF(LU.ITEM_ID IS NULL, INV.ITEM_ID, LU.DEMAND_GROUP) AS MDF_ITEM_ID
                                       ,INV.AVAILABLE_DATE
                                       ,INV.QTY
                                       ,INV.WIPHOLD_YN
                                       ,INV.SITE_TYPE
                                       ,INV.location_code
                                FROM    #SCP_INVENTORY_I INV WITH(NOLOCK)
                                    /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                        ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT2 = @V_DIVISION_ID
                                        AND INV.ITEM_ID = LU.SEGMENT3
                                        AND LU.VALID_YN = 'Y'*/ -- blocked 2025-12-15 jongykim2
                                     -- Added 2025-12-15 jongykim2: Demand Group Master
                                     LEFT OUTER JOIN #DEMAND_GROUP_T LU WITH(NOLOCK)
                                        ON  INV.ITEM_ID = LU.ITEM_ID
                                WHERE   INV.FLAG         = 'SALES'
                                AND     INV.PROJECT_CODE = '-'
                                AND     INV.QTY>0
                                ) INV
                               INNER JOIN @DM_TEMP DT
                                   ON  INV.SCM_SITE_ID = DT.SITE_ID
                                   AND INV.MDF_ITEM_ID     = DT.ITEM_ID
                                   AND (   (INV.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                        OR (INV.INCOTERMS = DT.INCOTERMS)
                                        OR (INV.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                       )
                           ) DJ
                    ON  INV.DIVISION_ID    = DJ.DIVISION_ID
                    AND INV.SCM_SITE_ID    = DJ.SCM_SITE_ID
                    AND INV.INCOTERMS      = DJ.INCOTERMS
                    AND INV.STOCK_TYPE     = DJ.STOCK_TYPE
                    AND INV.ITEM_ID        = DJ.ITEM_ID
                    AND INV.AVAILABLE_DATE = DJ.AVAILABLE_DATE
                    AND INV.QTY            = DJ.QTY
                    AND INV.WIPHOLD_YN     = DJ.WIPHOLD_YN
                    AND INV.SITE_TYPE      = DJ.SITE_TYPE
                    AND INV.LOCATION_CODE  = DJ.LOCATION_CODE

            --------------------------------------------------------
            -- #SCP_INTRANSIT_I 프로젝트 UPDATE
            --------------------------------------------------------
            UPDATE #SCP_INTRANSIT_I
            SET #SCP_INTRANSIT_I.PROJECT_CODE = DJ.PROJECT_CODE
            FROM #SCP_INTRANSIT_I INV
                INNER JOIN (
                            SELECT INV.DIVISION_ID
                                  ,INV.ITEM_ID
                                  ,INV.TO_SCM_SITE_ID
                                  ,INV.INCOTERMS
                                  ,INV.ETA_DATE
                                  ,INV.DELIVERY_QTY
                                  ,INV.FLAG
                                  ,DT.PROJECT_CODE
                            FROM(
                                 SELECT INV.DIVISION_ID
                                       ,INV.ITEM_ID
                                       --,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                       ,IIF(LU.ITEM_ID IS NULL, INV.ITEM_ID, LU.DEMAND_GROUP) AS MDF_ITEM_ID
                                       ,INV.TO_SCM_SITE_ID
                                       ,INV.INCOTERMS
                                       ,INV.ETA_DATE
                                       ,INV.DELIVERY_QTY
                                       ,INV.PROJECT_CODE
                                       ,INV.FLAG
                                 FROM #SCP_INTRANSIT_I INV -- WHERE PROJECT_CODE = '-' AND FLAG ='SALES'
                                     /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                         ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                         AND LU.SEGMENT2 = @V_DIVISION_ID
                                         AND INV.ITEM_ID = LU.SEGMENT3
                                         AND LU.VALID_YN = 'Y'*/ -- blocked 2025-12-15 jongykim2
                                     -- Added 2025-12-15 jongykim2: Demand Group Master
                                     LEFT OUTER JOIN #DEMAND_GROUP_T LU WITH(NOLOCK)
                                         ON  INV.ITEM_ID = LU.ITEM_ID
                                 WHERE   INV.FLAG         = 'SALES'
                                 AND     INV.PROJECT_CODE = '-'
                                 AND     INV.DELIVERY_QTY>0
                                 ) INV
                                INNER JOIN @DM_TEMP DT
                                    ON  INV.TO_SCM_SITE_ID = DT.SITE_ID
                                    AND INV.MDF_ITEM_ID    = DT.ITEM_ID
                                    AND (   (INV.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                         OR (INV.INCOTERMS = DT.INCOTERMS)
                                         OR (INV.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                        )
                            )DJ
                    ON  INV.DIVISION_ID    = DJ.DIVISION_ID
                    AND INV.ITEM_ID        = DJ.ITEM_ID
                    AND INV.TO_SCM_SITE_ID = DJ.TO_SCM_SITE_ID
                    AND INV.INCOTERMS      = DJ.INCOTERMS
                    AND INV.ETA_DATE       = DJ.ETA_DATE
                    AND INV.DELIVERY_QTY   = DJ.DELIVERY_QTY
                    AND INV.FLAG           = DJ.FLAG

          -- CA별 CP 정보
		  SELECT M.DIVISION_ID
				,M.PLANT_ID
				,M.ITEM_ID_ASSY
				,M.ITEM_ID_PROD
				,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
												,M.ITEM_ID_ASSY
												,M.PLANT_ID
										ORDER BY M.VALID_YN DESC 
												,M.ITEM_ID_PROD) PRIORITY_1ST
				,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
												,M.ITEM_ID_ASSY
										ORDER BY M.VALID_YN DESC 
												,M.ITEM_ID_PROD) PRIORITY_2ND
				,ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
										ORDER BY M.VALID_YN DESC 
												,M.ITEM_ID_PROD) PRIORITY_3RD
		    INTO #CP_INFO
			FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
		   WHERE 1=1
			 AND M.VALID_YN = 'Y' ;

        --------------------------------------------------------
        -- 2025.09.23 Philsu Park: 재고 보정값 반영을 위한 TEMP Input.
        --------------------------------------------------------
        SELECT    ADJ.SCM_SITE_ID
                , ADJ.ITEM_ID
                , CASE  WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP'    THEN 'CHAR'
                        WHEN ISNULL(LM.OPERATION_ID, '') != ''                  THEN 'CHAR'
                        WHEN B.FLOW_ID = 'A9000'                                THEN 'ASSY@' + LS.LINE_SIDE
                        WHEN ITM.SCP_FLOW_ID = 'A8000'                          THEN 'STK@' + LS.LINE_SIDE
                        WHEN ADJ.BEFORE_DEGAS = 'Y'                             THEN 'B_DEGAS@' + LS.LINE_SIDE
                        WHEN ADJ.BEFORE_DEGAS = 'N'                             THEN 'A_DEGAS@' + LS.LINE_SIDE
                        ELSE '-' END    AS STAGE_BUFFER
                , CASE  WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP'    THEN 'CHAR'
                        WHEN ISNULL(LM.OPERATION_ID, '') != ''                  THEN 'CHAR'
                        WHEN B.FLOW_ID = 'A9000'                                THEN 'ASSY'
                        WHEN ITM.SCP_FLOW_ID = 'A8000'                          THEN 'STK'
                        WHEN ADJ.BEFORE_DEGAS = 'Y'                             THEN 'B_DEGAS'
                        WHEN ADJ.BEFORE_DEGAS = 'N'                             THEN 'A_DEGAS'
                        ELSE '-' END    AS STAGE
                , ADJ.INV_DATE          AS EFFECTIVE_DATE
                , ADJ.STOCK_TYPE        AS TYPE
                , SUM(ADJ.CHG_QTY)      AS QTY
                , ADJ.INCOTERMS         AS INCOTERMS
                , ADJ.PROJECT_CODE      AS PROJECT_CODE
                -- , ADJ.LINE_ID         AS LINE_ID
                -- , ADJ.BEFORE_DEGAS    AS B_DEGAS_YN
                -- , 'ADJUST'            AS FLAG
                -- , ADJ.QTY
        INTO     #INVENTORY_ADJUST
        FROM    SCP_OPMZ_INV_ADJ ADJ WITH(NOLOCK)
        LEFT OUTER JOIN (
                        SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                            --, * 
                        FROM   SCP_MST_FINAL_ITEM WITH(NOLOCK)
                        WHERE  DIVISION_ID = @V_DIVISION_ID
                        AND    OPERATION_GROUP IN ('A', 'P')
                        ) B
            ON    B.ITEM_ID     = ADJ.ITEM_ID
            AND   B.DIVISION_ID = ADJ.DIVISION_ID 
        LEFT OUTER JOIN (
                        SELECT  DISTINCT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID
                        FROM    SCM_LINE_M_SN M WITH(NOLOCK)
                        WHERE   M.DIVISION_ID   = @V_DIVISION_ID
                        AND     M.OPERATION_ID  = 'B1000'
                        AND     M.ACTIVE_FLAG   = 'Y'
                        ) LM
            ON  LM.DIVISION_ID  = ADJ.DIVISION_ID
            AND LM.PLANT_ID     = ADJ.FROM_SITE_ID
            AND LM.LINE_ID      = ADJ.LINE_ID
        INNER JOIN (
                        SELECT  DIVISION_ID, ITEM_ID, SCP_FLOW_ID
                        FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                        WHERE   DIVISION_ID = @V_DIVISION_ID
                        AND     SCP_FLOW_ID IS NOT NULL
                        GROUP BY DIVISION_ID, ITEM_ID, SCP_FLOW_ID
                        ) ITM
            ON  ITM.DIVISION_ID = ADJ.DIVISION_ID
            AND ITM.ITEM_ID = ADJ.ITEM_ID
        LEFT OUTER JOIN (
                            SELECT    SEGMENT3      AS SITE_ID
                                    , SEGMENT4      AS LINE_ID
                                    , ATTRIBUTE1    AS LINE_SIDE
                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                            WHERE   LK.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_LINE'
                            and     lk.segment1 = @V_DIVISION_ID
                            and     lk.segment2 = @V_GROUP_ID
                        ) LS
            ON  LS.SITE_ID = ADJ.SCM_SITE_ID
            AND LS.LINE_ID = ADJ.LINE_ID
        WHERE   ADJ.DIVISION_ID     = @V_DIVISION_ID
        AND     ADJ.CUTOFF_YYYYMMDD = @V_PLAN_START_YYYYMMDD
        -- AND     ADJ.CHG_QTY         > 0
        AND     ADJ.LINE_ID        != '-'
        AND     ADJ.INV_DATE >= @V_PLAN_START_YYYYMMDD
        AND     ADJ.INV_DATE <  @V_PLAN_END_YYYYMMDD
        GROUP BY  ADJ.SCM_SITE_ID
                , ADJ.ITEM_ID
                , CASE WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' THEN 'CHAR'
                    WHEN ISNULL(LM.OPERATION_ID, '') != '' THEN 'CHAR'
                    WHEN B.FLOW_ID = 'A9000' THEN 'ASSY@' + LS.LINE_SIDE
                    WHEN ITM.SCP_FLOW_ID = 'A8000' THEN 'STK@' + LS.LINE_SIDE
                    WHEN ADJ.BEFORE_DEGAS = 'Y' THEN 'B_DEGAS@' + LS.LINE_SIDE
                    WHEN ADJ.BEFORE_DEGAS = 'N' THEN 'A_DEGAS@' + LS.LINE_SIDE
                    ELSE '-' END
                , CASE WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' THEN 'CHAR'
                    WHEN ISNULL(LM.OPERATION_ID, '') != '' THEN 'CHAR'
                    WHEN B.FLOW_ID = 'A9000' THEN 'ASSY'
                    WHEN ITM.SCP_FLOW_ID = 'A8000' THEN 'STK'
                    WHEN ADJ.BEFORE_DEGAS = 'Y' THEN 'B_DEGAS'
                    WHEN ADJ.BEFORE_DEGAS = 'N' THEN 'A_DEGAS'
                    ELSE '-' END
                , ADJ.INV_DATE
                , ADJ.STOCK_TYPE
                , ADJ.INCOTERMS
                , ADJ.PROJECT_CODE


        --------------------------------------------------------
        -- INCOMING STOCK INSERT
        -- 2025.09.16 Philsu Park: Stage 판정 안되는 재고 제외.
        --------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN(PLAN_ID
                                                 ,STOCK_ID
                                                 ,BUFFER_ID
                                                 ,EFFECTIVE_DATE
                                                 ,TYPE
                                                 ,QUANTITY
                                                 ,ATTRIBUTE1
                                                 ,ATTRIBUTE2
                                                 ,ATTRIBUTE3
                                                 ,ATTRIBUTE4
                                                 ,ATTRIBUTE5
                                                 ,ATTRIBUTE6
                                                 )
        SELECT AA.PLAN_ID
              ,AA.STOCK_ID
              ,AA.BUFFER_ID
              ,AA.EFECTIVE_DATE
              ,AA.TYPE
              ,SUM(AA.QUANTITY) AS QUANTITY
              ,AA.SITE_ID
              ,AA.ITEM_ID
              ,AA.STAGE
              ,AA.INCOTERMS
              ,AA.PROJECT_CODE
              ,AA.STAGE_BUFFER
        FROM (
				SELECT @V_PLAN_ID                                                                 AS PLAN_ID
					  ,TYPE+'::'+SITE_ID+'::'+ITEM_ID+'::'+STAGE_BUFFER+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+'::'+EFECTIVE_DATE+IIF(CELL_PROD_SITE_ID='','','::'+CELL_PROD_SITE_ID) AS STOCK_ID
					  ,SITE_ID+'::'+ITEM_ID+'::'+STAGE_BUFFER+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+IIF(CELL_PROD_SITE_ID='','','::'+CELL_PROD_SITE_ID)                              AS BUFFER_ID
					  ,EFECTIVE_DATE                                                                               AS EFECTIVE_DATE
					  ,TYPE                                                                                        AS TYPE
					  ,QTY                                                                                         AS QUANTITY
					  ,SITE_ID                                                                                     AS SITE_ID
					  ,ITEM_ID                                                                                     AS ITEM_ID
					  ,STAGE                                                                                       AS STAGE
					  ,STAGE_BUFFER                                                                                AS STAGE_BUFFER
					  ,INCOTERMS                                                                                   AS INCOTERMS
					  ,PROJECT_CODE                                                                                AS PROJECT_CODE
				FROM (
					SELECT A.SCM_SITE_ID AS SITE_ID			       
						 --, A.ITEM_ID AS ITEM_ID
						 , CASE --> 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함
            					WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND a.DESCR LIKE 'WH%' AND A.LOCATION_CODE = '-' 
									 THEN ISNULL(ISNULL(ISNULL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD),C3.ITEM_ID_PROD), A.ITEM_ID) 
            					ELSE A.ITEM_ID 
							END ITEM_ID 
                         , CASE WHEN A.OPERATION_ID = 'A8000' THEN 'STK@'+LD.ATTRIBUTE1
                                WHEN A.OPERATION_ID = 'A9000' THEN 'ASSY@'+LD.ATTRIBUTE1
                                WHEN A.OPERATION_ID = 'F6000' THEN 'EOL@'+LD.ATTRIBUTE1
                                WHEN A.B_DEGAS_YN   = 'Y'     THEN 'B_DEGAS@'+LD.ATTRIBUTE1
                                WHEN A.B_DEGAS_YN   = 'N'     THEN 'A_DEGAS@'+LD.ATTRIBUTE1
            					WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                WHEN A.OPERATION_ID = 'B1000' THEN 'CHAR'
                                ELSE '-'
                            END AS STAGE_BUFFER
                         , CASE WHEN A.OPERATION_ID = 'A8000' THEN 'STK'
                                WHEN A.OPERATION_ID = 'A9000' THEN 'ASSY'
                                WHEN A.OPERATION_ID = 'F6000' THEN 'EOL'
                                WHEN A.B_DEGAS_YN   = 'Y'     THEN 'B_DEGAS'
                                WHEN A.B_DEGAS_YN   = 'N'     THEN 'A_DEGAS'
            					WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                WHEN A.OPERATION_ID = 'B1000' THEN 'CHAR'
                                ELSE '-'
                            END AS STAGE
            			 /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성 */
						 --, CASE 
            --					WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' 
								    --THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'PACK' ELSE 'PACKBIZ' END)
            --					WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' 
								    --THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'MDLE' ELSE 'MDLEBIZ' END)
            --					WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500')
								    --THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'SUBMDLE' ELSE 'SUBMDLEBIZ' END)
            					-- WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'PLANT' THEN 'PACK'
            					-- WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'SALES' THEN 'PACKBIZ'

            					-- WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'PLANT' THEN 'MDLE'
            					-- WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'SALES' THEN 'MDLEBIZ'

            					-- WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
            					-- WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
								
            					--WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
            					--WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'SALES' THEN 'CELLBIZ'

            					--WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND a.DESCR LIKE 'FOR%' THEN 'ASY_AGING' -- 활성화 재고
								--> 활성화 완료 재고 : 'CHAR' 버퍼 재고로 처리하고 ASSY Item 인 경우 CHAR Item 으로 Update 처리함 
								--> 활성화 전 재고 : 'ASSY'
            					--WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'ASY_AGING' ELSE 'ASSY' END) 
            					--WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'CHAR' ELSE 'ASSY' END) 
                                --> SUBMDLE는 FINAL ITEM에 없으므로 다른 TABLE에서 확인
            					--WHEN SMC.SCP_FLOW_ID = 'A8000' THEN 'STK'
            					--ELSE '-' END STAGE 
						 , CONVERT(VARCHAR(8), ISNULL(A.EFFSTARTDATE, CONVERT(DATETIME, @P_PLAN_NAME)), 112) AS EFECTIVE_DATE
						 , A.DESCR AS TYPE
						 , QTY AS QTY
            			 , INCOTERMS 
						 , PROJECT_CODE
                         , CELL_PROD_SITE_ID
					FROM   (
							SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID AS SCM_SITE_ID
            					 , INCOTERMS 
								 ,  CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))   AS EFFSTARTDATE
								 , SUM(QTY)        AS QTY					  
								 , CASE WHEN ISNULL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
										ELSE 'WH_HOLD'
								   END  AS DESCR
								 , location_code
								 , PROJECT_CODE
                                 , CELL_PROD_SITE_ID
                                 , OPERATION_ID
                                 , LINE_ID
                                 , B_DEGAS_YN
								 , FLAG
							FROM   #SCP_INVENTORY_I T WITH(NOLOCK)
							WHERE  1=1
							AND    T.STOCK_TYPE <> 'FOR' 
							GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, CONVERT(CHAR(8), AVAILABLE_DATE, 112), ISNULL(T.WIPHOLD_YN, 'N'), INCOTERMS, location_code, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, OPERATION_ID, LINE_ID, B_DEGAS_YN
            				HAVING SUM(T.QTY) > 0		      
            				UNION ALL
							-- 활성화 재고 : FOR 로 처리
							SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID AS SCM_SITE_ID
            					 , INCOTERMS 
								 , CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))   AS EFFSTARTDATE
								 , SUM(QTY)       AS QTY
								 , CASE WHEN ISNULL(T.WIPHOLD_YN, 'N') = 'N' THEN 'FOR'
										ELSE 'FOR_HOLD'
								   END  AS DESCR
								 , location_code
								 , PROJECT_CODE
                                 , CELL_PROD_SITE_ID
                                 , OPERATION_ID
                                 , LINE_ID
                                 , B_DEGAS_YN
								 , FLAG
							FROM   #SCP_INVENTORY_I T WITH(NOLOCK)
							WHERE  1=1
							AND    T.STOCK_TYPE  = 'FOR' -- 활성화 재고
							AND    T.QTY         > 0 
							GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, CONVERT(CHAR(8), AVAILABLE_DATE, 112), ISNULL(T.WIPHOLD_YN, 'N'), INCOTERMS , location_code, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, OPERATION_ID, LINE_ID, B_DEGAS_YN
							UNION ALL
							-- INTRANSIT SHIPMENT 재고 
							SELECT DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID AS SCM_SITE_ID
            					 , INCOTERMS 
								 ,  CONVERT(DATETIME, ETA_DATE)  AS EFFSTARTDATE
								 , SUM(DELIVERY_QTY)             AS QTY
								 , 'INT'                         AS DESCR    
								 , '-'                           AS location_code
								 , PROJECT_CODE
                                 , CELL_PROD_SITE_ID
                                 , OPERATION_ID
                                 , LINE_ID
                                 , B_DEGAS_YN
								 , FLAG
							FROM   #SCP_INTRANSIT_I T WITH(NOLOCK)
							WHERE  1=1
							AND    T.DELIVERY_QTY  > 0 
							AND   (T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')
							GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, ETA_DATE, INCOTERMS, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, OPERATION_ID, LINE_ID, B_DEGAS_YN
            
							) A
            
					LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
									--, * 
								FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
								WHERE  DIVISION_ID = @V_DIVISION_ID  
								AND    OPERATION_GROUP IN ('A', 'P')  
							   ) B
					ON    A.ITEM_ID     = B.ITEM_ID
					AND   A.DIVISION_ID = B.DIVISION_ID 

					LEFT  JOIN SCM_MST_SITE FS WITH(NOLOCK)
							ON FS.DIVISION_ID = A.DIVISION_ID
							AND FS.SCM_SITE_ID = A.SCM_SITE_ID
							AND FS.SITE_TYPE   = 'PLANT'
					LEFT  JOIN #CP_INFO C1
							ON  C1.DIVISION_ID	= A.DIVISION_ID
							AND C1.PLANT_ID		= FS.PLANT_ID
							AND C1.ITEM_ID_ASSY	= A.ITEM_ID
							AND C1.PRIORITY_1ST	= 1
					LEFT  JOIN #CP_INFO C2
							ON  C2.DIVISION_ID	= A.DIVISION_ID
							AND C2.ITEM_ID_ASSY	= A.ITEM_ID
							AND C2.PRIORITY_2ND	= 1
					LEFT  JOIN #CP_INFO C3
							ON  C3.ITEM_ID_ASSY	= A.ITEM_ID
							AND C3.PRIORITY_3RD	= 1          
                    LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LD WITH(NOLOCK)
                        ON  LD.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_LINE'
                        AND A.DIVISION_ID  = LD.SEGMENT1
                        AND LD.SEGMENT2    = @V_GROUP_ID
                        AND A.SCM_SITE_ID  = LD.SEGMENT3
                        AND A.LINE_ID      = LD.SEGMENT4
                    --SUBMDLE의 STAGE를 찾기 위해 추가
                    --LEFT  JOIN (
                    --            SELECT  SM.DIVISION_ID
                    --                   ,SM.SCM_SITE_ID
                    --                   ,IM.ITEM_ID
                    --                   ,IM.SCP_FLOW_ID
                    --                   ,IM.SCP_OPERATION_GROUP
                    --            FROM    SCM_ITEM_M_SN IM WITH(NOLOCK) 
                    --                INNER JOIN SCM_MST_SITE SM WITH(NOLOCK)
                    --                    ON  IM.COMPANY_ID = SM.COMPANY_ID
                    --                    AND IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
                    --            WHERE   1=1
                    --            AND     CONCAT (SM.SCM_SITE_ID,IM.ITEM_ID) IN(
                    --                                 SELECT  DISTINCT CONCAT (SCM_SITE_ID, ITEM_ID)
                    --                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                    --                                 WHERE   PLAN_ID = @V_PLAN_ID
                    --                                 )
                    --            AND     IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500') -- SUBMDLE만 걸리도록
                    --            -- AND     IM.SCP_OPERATION_GROUP = 'P'             -- SUBMDLE만 걸리도록
                    --            ) SMC
                    --     ON  A.DIVISION_ID = SMC.DIVISION_ID
                    --     AND A.SCM_SITE_ID = SMC.SCM_SITE_ID
                    --     AND A.ITEM_ID     = SMC.ITEM_ID
					WHERE  1=1
					--AND    A.ITEM_ID = B.ITEM_ID
					--AND    B.ITEM_TYPE <> 'R' --  R TYPE의 재고는 올리지 않음
            
					/************************* 
					대상 프로젝트 ITEM 필터링 
					*************************/
					AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
									   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
									   WHERE   PLAN_ID = @V_PLAN_ID
									 )
					) AS A
				WHERE 1=1
                AND STAGE != '-'
				AND EFECTIVE_DATE < @V_PLAN_END_YYYYMMDD
                AND NOT EXISTS ( 
                                SELECT  1
                                FROM    #INVENTORY_ADJUST ADJ
                                WHERE   ADJ.SCM_SITE_ID     = A.SITE_ID
                                AND     ADj.ITEM_ID         = A.ITEM_ID
                                AND     ADJ.STAGE_BUFFER    = A.STAGE_BUFFER
                                AND     ADJ.STAGE           = A.STAGE
                                AND     ADJ.TYPE            = A.TYPE
                                AND     ADj.EFFECTIVE_DATE  = A.EFECTIVE_DATE
                                AND     ADj.INCOTERMS       = A.INCOTERMS
                                AND     ADj.PROJECT_CODE    = A.PROJECT_CODE
                                )

				--------------------------------------------------------
				--  자재/포장재의 입고 예정정보
				--  2025.05.19 Philsu Park: GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용.
				--------------------------------------------------------
				UNION ALL
				SELECT  @V_PLAN_ID                                                 AS PLAN_ID
					   ,TYPE+'::'+SCM_SITE_ID+'::'+MAT_ID+'::'+STAGE+'::'+ARR_DATE AS STOCK_ID
					   ,SCM_SITE_ID+'::'+MAT_ID+'::'+STAGE                         AS BUFFER_ID
					   ,ARR_DATE                                                   AS EFFECTIVE_DATE
					   ,TYPE                                                       AS TYPE
					   ,QTY                                                        AS QUANTITY
					   ,SCM_SITE_ID                                                AS SITE_ID
					   ,MAT_ID                                                     AS ITEM_ID
					   ,STAGE                                                      AS STAGE
					   ,STAGE                                                      AS STAGE_BUFFER
					   ,'-'                                                        AS INCOTERMS
					   ,'-'                                                        AS PROJECT_CODE
				FROM(
                    -- START 2025.11.19 jongykim2: Schelduled Reciept Information
					SELECT  LU.PLANT_SITE_ID AS SCM_SITE_ID
						   ,LU.ITEM_ID_CHILD AS MAT_ID
						   ,'MATERIAL_CONST' AS STAGE
						   ,LU.TO_YYYYMMDD   AS ARR_DATE
						   ,LU.TO_EXPC_QTY   AS QTY
						   ,'MC'             AS TYPE
                    FROM    SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION LU WITH(NOLOCK)
                    INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                    ON      LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
					INNER JOIN @MAT_CONST_TEMP MAT
					ON      LU.ITEM_ID_CHILD    = MAT.MAT_ID
					WHERE   1 = 1
					AND     LU.DIVISION_ID      = @V_DIVISION_ID
                    AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                    AND     LU.VALID_YN         = 'Y'
                    AND     PG.VALID_YN         = 'Y'
					AND     LU.TO_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE
                    -- END 2025.11.19 jongykim2: Schelduled Reciept Information
                    /*
                    SELECT  LU.SEGMENT4      AS SCM_SITE_ID
						   ,LU.SEGMENT5      AS MAT_ID
						   ,'MATERIAL_CONST' AS STAGE
						   ,ATTRIBUTE1       AS ARR_DATE
						   ,ATTRIBUTE2       AS QTY
						   ,'MC'             AS TYPE
					FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
					INNER JOIN @MAT_CONST_TEMP MAT
					    ON  LU.SEGMENT5         = MAT.MAT_ID
					WHERE   LU.LOOKUP_TYPE      = 'SCP_OPT_ENG_CONST_INCOMMING_MATERIAL'
					AND     LU.VALID_YN         = 'Y'
                    AND     LU.SEGMENT2         = @V_DIVISION_ID
                    AND     LU.SEGMENT3         = @V_GROUP_ID
					AND     LU.ATTRIBUTE1 BETWEEN @V_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE */
					) MC
				WHERE ARR_DATE < @V_PLAN_END_YYYYMMDD
                --------------------------------------------------------
				--  2025.09.30 Philsu Park: Workbench 재고 추가
				--------------------------------------------------------
                UNION ALL
                SELECT @V_PLAN_ID                                                                 AS PLAN_ID
					  ,TYPE+'::'+SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE_BUFFER+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+'::'+EFFECTIVE_DATE AS STOCK_ID
					  ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE_BUFFER+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)                              AS BUFFER_ID
					  ,EFFECTIVE_DATE                                                                              AS EFFECTIVE_DATE
					  ,TYPE                                                                                        AS TYPE
					  ,QTY                                                                                         AS QUANTITY
					  ,SCM_SITE_ID                                                                                 AS SITE_ID
					  ,ITEM_ID                                                                                     AS ITEM_ID
					  ,STAGE                                                                                       AS STAGE
					  ,STAGE_BUFFER                                                                                AS STAGE_BUFFER
					  ,INCOTERMS                                                                                   AS INCOTERMS
					  ,PROJECT_CODE                                                                                AS PROJECT_CODE
                FROM    #INVENTORY_ADJUST INV
                WHERE QTY > 0
		) AA
            /* INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                ON  ML.PLAN_ID      = @V_PLAN_ID
                AND AA.SITE_ID      = ML.SCM_SITE_ID
                AND AA.ITEM_ID      = ML.ITEM_ID
                AND AA.STAGE_BUFFER = ML.STAGE */
		GROUP BY AA.PLAN_ID, AA.STOCK_ID, AA.BUFFER_ID, AA.EFECTIVE_DATE, AA.TYPE, AA.SITE_ID, AA.ITEM_ID, AA.STAGE, AA.STAGE_BUFFER, AA.INCOTERMS, AA.PROJECT_CODE

        ------------------------------------------------------------------------
        -- TRAY 제약을 위한 데이터 추가
        -- 2025-07-30 THK
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN(PLAN_ID
                                                 ,STOCK_ID
                                                 ,BUFFER_ID
                                                 ,EFFECTIVE_DATE
                                                 ,TYPE
                                                 ,QUANTITY
                                                 ,ATTRIBUTE1
                                                 ,ATTRIBUTE2
                                                 ,ATTRIBUTE3
                                                 ,ATTRIBUTE6
                                                 )
        SELECT  @V_PLAN_ID                                                                                 AS PLAN_ID
               ,'TRAY'+'::'+LU.SEGMENT4+'::'+SEGMENT5+'::'+SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3) AS STOCK_ID
               ,LU.SEGMENT4+'::'+SEGMENT5+'::'+SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3)             AS BUFFER_ID
               ,@V_PLAN_START_YYYYMMDD                                                                     AS EFFECTIVE_DATE
               ,'TRAY'                                                                                     AS TYPE
               ,CONVERT(NUMERIC(20,10),LU.ATTRIBUTE1 - ISNULL(INC.QUANTITY,0))                             AS QUANTITY -- changed 2025-12-02 ISNULL 처리
               ,LU.SEGMENT4                                                                                AS ATTRIBUTE1
               ,LU.SEGMENT5                                                                                AS ATTRIBUTE2
               ,LU.SEGMENT6                                                                                AS ATTRIBUTE3
               ,LU.SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3)                                         AS ATTRIBUTE6
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            --INNER JOIN( -- blocked 2025-12-02 jongykim2
            LEFT OUTER JOIN( -- changed 2025-12-02 jongykim2: left join으로 변경
                      SELECT ITEM_ID
                            ,EW_FLAG
                            ,SUM(QUANTITY) AS QUANTITY
                      FROM(
                          SELECT  'B_TRAY'            AS ITEM_ID
                                 ,RIGHT(ATTRIBUTE6,1) AS EW_FLAG
                                 ,QUANTITY            AS QUANTITY
                          FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INC WITH(NOLOCK)
                          WHERE   INC.PLAN_ID = @V_PLAN_ID
                          AND     (   (INC.ATTRIBUTE3 ='ASSY' AND INC.EFFECTIVE_DATE <= @V_PLAN_START_YYYYMMDD)
                                   OR INC.ATTRIBUTE3 = 'B_DEGAS')
                          ) INC
                      GROUP BY ITEM_ID,EW_FLAG
                      UNION ALL
                      SELECT ITEM_ID
                            ,EW_FLAG
                            ,SUM(QUANTITY) AS QUANTITY
                      FROM(
                          SELECT  'A_TRAY'            AS ITEM_ID
                                 ,RIGHT(ATTRIBUTE6,1) AS EW_FLAG
                                 ,QUANTITY            AS QUANTITY
                          FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INC WITH(NOLOCK)
                          WHERE   INC.PLAN_ID = @V_PLAN_ID
                          AND     INC.ATTRIBUTE3 = 'A_DEGAS'
                          ) INC
                      GROUP BY ITEM_ID,EW_FLAG
                      ) INC
                ON  LU.SEGMENT5 = INC.ITEM_ID
                AND LU.SEGMENT3 = INC.EW_FLAG
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
        AND     LU.VALID_YN    = 'Y'
        AND     LU.SEGMENT1    = @V_DIVISION_ID
        AND     LU.SEGMENT2    = @V_GROUP_ID
        ;

        --------------------------------------------------------
        -- 2025.09.08 Philsu Park: Hold 재고의 Release를 룩업 기반으로 반영. (PSD + n)
        -- 조립은 동편, 서편 구분이 있으므로 Attribute6(Stage+Side) 와 Join.
        --------------------------------------------------------
        UPDATE  S
        SET       S.EFFECTIVE_DATE  = CONVERT(NVARCHAR, DATEADD(DAY, LK.ADD_DAYS, @D_PLAN_NAME), 112)
                , S.UPDATE_ID       = 'HOLD_UPDATE'
                , S.UPDATE_TIME     = CURRENT_TIMESTAMP
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN S
        INNER JOIN (
                    SELECT    SEGMENT3 AS SITE_ID
                            , SEGMENT4 AS STAGE
                            , SEGMENT5 AS EW_FLAG
                            , IIF(SEGMENT5 = '-', SEGMENT4, CONCAT(SEGMENT4, '@', SEGMENT5)) AS EW_STAGE
                            , CONVERT(INT, ATTRIBUTE1) AS ADD_DAYS
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE  = 'SCP_OPT_ENG_GM_RELEASE_HOLD'
                    AND     VALID_YN     = 'Y'
                    AND     SEGMENT1     = @V_DIVISION_ID
                    AND     SEGMENT2     = @V_GROUP_ID
                    ) LK
            ON  LK.SITE_ID  = S.ATTRIBUTE1
            AND LK.EW_STAGE = S.ATTRIBUTE6
        WHERE   S.PLAN_ID   = @V_PLAN_ID
        AND     CHARINDEX('HOLD', S.TYPE) > 0
        ;
        
        --------------------------------------------------------
        -- 2nd OCV 재고는 INSP로 UPDATE 
        --------------------------------------------------------
        --UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
        --SET     SCP_OPT_ENG_INCOMING_STOCK_SN.STOCK_ID   = INC.TYPE+'::'+INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+OCV.TO_BE_STAGE+'::'+INC.EFFECTIVE_DATE
        --       ,SCP_OPT_ENG_INCOMING_STOCK_SN.BUFFER_ID  = INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+OCV.TO_BE_STAGE
        --       ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE3 = OCV.TO_BE_STAGE
        --FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INC WITH(NOLOCK)
        --    INNER JOIN (
        --               SELECT  ATTRIBUTE2 AS AS_IS_STAGE
        --                      ,ATTRIBUTE3 AS TO_BE_STAGE
        --                      ,SEGMENT4   AS SCM_SITE_ID
        --                      ,SEGMENT5   AS ITEM_ID
        --               FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --               WHERE   1=1
        --               AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        --               AND     LU.VALID_YN    = 'Y'
        --               AND     LU.SEGMENT2    = @V_DIVISION_ID
        --               AND     LU.SEGMENT3    = @V_GROUP_ID
        --               GROUP BY ATTRIBUTE2, ATTRIBUTE3, SEGMENT4, SEGMENT5
        --               ) OCV
        --        ON  INC.ATTRIBUTE1 = OCV.SCM_SITE_ID
        --        AND INC.ATTRIBUTE2 = OCV.ITEM_ID
        --        AND INC.ATTRIBUTE3 = OCV.AS_IS_STAGE
        --WHERE   INC.PLAN_ID = @V_PLAN_ID

        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------		

		IF OBJECT_ID('TEMPDB..#SCP_INVENTORY_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INVENTORY_I;
		END;		

		IF OBJECT_ID('TEMPDB..#SCP_INTRANSIT_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INTRANSIT_I;
		END;	

		IF OBJECT_ID('TEMPDB..#CP_INFO') IS NOT NULL
		BEGIN 
			DROP TABLE  #CP_INFO;
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



CREATE   PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
    -- 2025.08.08 Philsu Park: 소형 전극 재고 반영 시 PRODUCT_TYPE 제약조건 추가.
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK';
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
    DECLARE @D_PLAN_NAME         DATE; -- added 2025-11-24 jongykim2
    DECLARE @V_SINGLE_PLAN_TYPE  NVARCHAR(1); -- added 2025-11-24 jongykim2
    DECLARE @V_PLAN_GROUP_ORG    NVARCHAR(20); -- added 2025-11-24 jongykim2
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
        WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
        AND     DAYOFWEEK = 'TUE'

        SELECT @P_MODELING_ID       = MODELING_ID FROM SCM_MST_MODELING WITH(NOLOCK) WHERE PLAN_CYCLE = 'WEEKLY' AND DIVISION_ID = @V_DIVISION_ID;
        SELECT @P_PLAN_NAME         = @V_PLAN_START_YYYYMMDD ; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME         = CONVERT(DATE, @P_PLAN_NAME); -- added 2025-11-24 jongykim2
        SELECT @V_CUTOFF_DAY        = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)), 112) ; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
        SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
        SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD

        -- START 2025-11-24 jongykim2
        SELECT @V_SINGLE_PLAN_TYPE = CASE WHEN RIGHT(@V_GROUP_ID, 2) = '_C' THEN 'C' WHEN RIGHT(@V_GROUP_ID, 2) = '_A' THEN 'A' ELSE '-' END;
        SELECT @V_PLAN_GROUP_ORG = CASE WHEN RIGHT(@V_GROUP_ID, 2) IN ('_C', '_A') THEN LEFT(@V_GROUP_ID, LEN(@V_GROUP_ID) - 2) ELSE @V_GROUP_ID END;
        -- END 2025-11-24 jongykim2
        ------------------------------------------------------------------------
        --자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용
        ------------------------------------------------------------------------
        --SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
        --FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        --WHERE  PLAN_ID = @V_PLAN_ID
        
        INSERT INTO @MAT_CONST_TEMP
        -- START 2025.11.19 jongykim2: Schelduled Reciept Information
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
        /* -- START 2025.11.19 jongykim2
        SELECT   ATTRIBUTE1 AS MAT_ID
                ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
        FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
        AND      LU.VALID_YN    = 'Y'
        AND      LU.SEGMENT2    = @V_DIVISION_ID
        AND      LU.SEGMENT3    = @V_GROUP_ID
        GROUP BY ATTRIBUTE1 */

		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

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

		IF OBJECT_ID('TEMPDB..#SCP_INVENTORY_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INVENTORY_I;
		END;		

		IF OBJECT_ID('TEMPDB..#SCP_INTRANSIT_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INTRANSIT_I;
		END;

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
			 , '-'             AS location_code -- PLANT 재고 구분용 정보
             , '-'             AS PROJECT_CODE  -- 뒤에서 별도 UPDATE
             , 'SALES'         AS FLAG
		INTO   #SCP_INVENTORY_I
		FROM   SCM_DNM_STOCK      A WITH (NOLOCK)  
		INNER JOIN #DIVISION D WITH(NOLOCK)
		    ON A.DIVISION_ID = D.DIVISION_ID
		-- SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음
		INNER JOIN (SELECT DISTINCT  S.DIVISION_ID, S.SCM_SITE_ID, S.SITE_TYPE
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					INNER JOIN #DIVISION D WITH(NOLOCK)
					ON S.DIVISION_ID = D.DIVISION_ID
					WHERE  1=1
					AND    S.SITE_TYPE        = 'SALES'
					) B
            ON     A.DIVISION_ID      = B.DIVISION_ID
            AND    A.SCM_SITE_ID      = B.SCM_SITE_ID
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
		-- 전극 Item
		AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E'
        AND   (A.DIVISION_ID    = '40' AND A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
            OR A.DIVISION_ID   != '40')
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
		AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
			IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
				FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
				WHERE  PLAN_ID = @V_PLAN_ID
				) 
		;

        ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN INCOTERMS VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN LOCATION_CODE VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL;

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
			 , '-'             AS LOCATION_CODE -- PLANT 재고 구분용 정보
             , IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
             , 'SALES'         AS FLAG
		FROM   SCM_DNM_INTRANSIT_C  A WITH (NOLOCK)

		INNER JOIN #DIVISION D WITH(NOLOCK)
		ON A.DIVISION_ID = D.DIVISION_ID

		-- SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음
		INNER JOIN (SELECT DISTINCT  S.DIVISION_ID, S.SCM_SITE_ID, S.SITE_TYPE
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					INNER JOIN #DIVISION D WITH(NOLOCK)
					ON S.DIVISION_ID = D.DIVISION_ID
					WHERE  1=1
					AND    S.SITE_TYPE        = 'SALES'
					) B
		ON     A.DIVISION_ID      = B.DIVISION_ID
        AND    A.TO_SCM_SITE_ID   = B.SCM_SITE_ID

		WHERE  1 = 1
        AND    A.RESULT_DATE      = @V_CUTOFF_DAY
		-- SO Reserve Stock : result_type = 'B' 는 재고로 처리               
        AND    A.RESULT_TYPE      = 'B'                  
		AND    A.VALID_YN         = 'Y'   -- 해상재고    
		-- 전극 Item
		AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E'
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
		AND CONCAT(A.TO_SCM_SITE_ID, A.ITEM_ID) 
			IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
				FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
				WHERE  PLAN_ID = @V_PLAN_ID
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
                            INNER JOIN (SELECT DM.DIVISION_ID, DM.SCM_SITE_ID, MAX(DM.VERSION_NO) MAX_VERSION_NO
                                        FROM   DM_PLN_NET_DEMAND DM WITH(NOLOCK)

										INNER JOIN #DIVISION D WITH(NOLOCK)
										ON DM.DIVISION_ID = D.DIVISION_ID

                                        WHERE  1=1
                                        AND    DM.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY -- @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                        GROUP BY DM.DIVISION_ID, DM.SCM_SITE_ID
                                        ) BB
                            ON  AA.DIVISION_ID     = BB.DIVISION_ID 
                            AND AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                            AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                            AND AA.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY   

                            LEFT JOIN ( SELECT S.DIVISION_ID, S.SCM_SITE_ID, S.VMI_YN 
                                        FROM   SCM_MST_SITE S WITH (NOLOCK)

										INNER JOIN #DIVISION D WITH(NOLOCK)
										ON S.DIVISION_ID = D.DIVISION_ID

                                        WHERE  1=1
                                        AND    S.VMI_YN      = 'Y') CC
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
                           INNER JOIN ( SELECT DM.DIVISION_ID, DM.SCM_SITE_ID, MAX(DM.VERSION_NO) MAX_VERSION_NO
                                        FROM   DM_PLN_NET_DEMAND DM WITH(NOLOCK)

										INNER JOIN #DIVISION D WITH(NOLOCK)
										ON DM.DIVISION_ID = D.DIVISION_ID

                                        WHERE  1=1
                                        AND    DM.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY -- @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                        GROUP BY DM.DIVISION_ID, DM.SCM_SITE_ID
                                       ) BB
                            ON  AA.DIVISION_ID     = BB.DIVISION_ID 
                            AND AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                            AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                            AND AA.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY 

                           LEFT JOIN ( SELECT S.DIVISION_ID, S.SCM_SITE_ID, S.VMI_YN 
                                        FROM   SCM_MST_SITE S WITH (NOLOCK)

										INNER JOIN #DIVISION D WITH(NOLOCK)
										ON S.DIVISION_ID = D.DIVISION_ID

                                        WHERE  1=1
                                        AND    S.VMI_YN      = 'Y') CC
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
			  ,CASE WHEN B.OPERATION_GROUP = 'E' THEN '-' 
                    ELSE 'DAP'
               END AS INCOTERMS
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
			 --, CASE WHEN ISNULL(OP.LOCATION_CODE, '') <> '' THEN OP.LOCATION_CODE
			 --       WHEN ISNULL(ST.LOCATION_CODE, '') <> '' THEN ST.LOCATION_CODE
			 --       ELSE '-'
			 --  END AS LOCATION_CODE -- PLANT 재고 구분용 정보
			 , A.LOCATION_CODE AS LOCATION_CODE -- PLANT 재고 구분용 정보
             ,CASE WHEN B.OPERATION_GROUP = 'E' THEN '' 
                    ELSE '-'
               END AS PROJECT_CODE
             ,'PLANT' AS FLAG
		FROM   SCM_DNM_STOCK      A WITH (NOLOCK)  
		INNER JOIN (SELECT DISTINCT S.DIVISION_ID, S.SCM_SITE_ID, S.SITE_TYPE, S.OPERATION_GROUP
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					INNER JOIN #DIVISION D WITH(NOLOCK)
					ON S.DIVISION_ID = D.DIVISION_ID
					WHERE  1=1
					AND    S.SITE_TYPE        = 'PLANT'
					AND    S.OPERATION_GROUP IN ('E', 'A')
				   ) B
            ON     A.DIVISION_ID      = B.DIVISION_ID
            AND    A.SCM_SITE_ID      = B.SCM_SITE_ID
               
        --LEFT JOIN (  SELECT DISTINCT
        --                       A.OPERATION_ID
        --                    ,  A.LOCATION_CODE
        --            FROM   scm_mst_location a WITH (NOLOCK)
        --                    INNER JOIN (SELECT S.DIVISION_ID, S.scm_site_id  
        --                                FROM   scm_mst_site S WITH (NOLOCK)

								--		INNER JOIN #DIVISION D WITH(NOLOCK)
								--		ON S.DIVISION_ID = D.DIVISION_ID

        --                                WHERE  1=1
        --                                AND    S.valid_yn        = 'Y'
        --                                AND    S.operation_group IN ( 'A' ) 
        --                                ) b
        --                    ON  a.DIVISION_ID = b.DIVISION_ID 
        --                    AND a.scm_site_id = b.scm_site_id 
        --            WHERE  1=1
        --            AND    a.valid_yn    = 'Y'
        --            AND    location_code IN ('COATING', 'SLITTING'     -- 전극 공정
        --                                    ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정 : PACKAGING 이전
        --                                    )
        --            AND    (operation_id IS NOT NULL AND operation_id <> '')
        --        )  op -- 셀의 operation_id 별 사용대상 조회
        --ON   A.operation_id = op.operation_id 	   
               
        --LEFT JOIN (  SELECT DISTINCT
        --                       a.storage_id
        --                    ,  a.location_code
        --            FROM   DBO.scm_mst_location a WITH (NOLOCK)
        --                    INNER JOIN (SELECT S.DIVISION_ID, S.scm_site_id  
        --                                FROM   scm_mst_site S WITH (NOLOCK)

								--		INNER JOIN #DIVISION D WITH(NOLOCK)
								--		ON S.DIVISION_ID = D.DIVISION_ID

        --                                WHERE  1=1
        --                                AND    S.valid_yn        = 'Y'
        --                                AND    S.operation_group IN ( 'A' ) 
        --                                ) b
        --                    ON  a.DIVISION_ID = b.DIVISION_ID 
        --                    AND a.scm_site_id = b.scm_site_id 
        --            WHERE  1=1
        --            AND    a.valid_yn    = 'Y'
        --            AND    location_code IN ( 'COATING', 'SLITTING'     -- 전극 공정
        --                                    ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정 : PACKAGING 이전
        --                                    )
        --            AND    (storage_id IS NOT NULL AND storage_id <> '')

        --            UNION -- 전극 출하 SLOC는 별도 Lookup으로 설정
        --            SELECT a.segment3       AS storage_id
        --                 , 'ELECTRODE_SHIP' AS location_code
        --            FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
        --            WHERE  a.lookup_type = 'ELECTRODE_SHIP_SITE'
        --            AND    a.valid_yn    = 'Y'
        --        )  st -- 셀의 storage_id 별 사용대상 조회
        --ON   A.storage_id   = st.storage_id 

		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.LOCATION_CODE IN ( 'COATING', 'SLITTING'     -- 전극 공정
                                   ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정 : PACKAGING 이전
                                  )
        AND   (A.DIVISION_ID    = '40' AND A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
            OR A.DIVISION_ID   != '40')
        /************************* 
        대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 확인 필요
        *************************/
		AND ((B.OPERATION_GROUP = 'E' AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
										IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
											FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
											WHERE  PLAN_ID = @V_PLAN_ID
											) 
		     )
          OR (B.OPERATION_GROUP = 'A' AND A.ITEM_ID
										IN (SELECT DISTINCT PARENT_ITEM_ID
											FROM   SCP_OPT_ENG_BOM_ELEC_SN WITH(NOLOCK)
											WHERE  PLAN_ID = @V_PLAN_ID
											AND    SCP_YN  = 'Y'
											UNION
											SELECT DISTINCT CHILD_ITEM_ID
											FROM   SCP_OPT_ENG_BOM_ELEC_SN WITH(NOLOCK)
											WHERE  PLAN_ID = @V_PLAN_ID
											AND    SCP_YN  = 'Y'
											) 
		     )
			)
		;
    
        --------------------------------------------------------
        -- 3. 해상 재고 : INT
        --------------------------------------------------------
        -- 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
        SELECT A.DIVISION_ID  AS DIVISION_ID
              ,A.ITEM_ID
              ,A.TO_SCM_SITE_ID   AS TO_SCM_SITE_ID
              ,IIF(TS.SITE_TYPE != 'SALES' ,'DAP',A.FINAL_INCOTERMS)  AS INCOTERMS -- TS.SITE_TYPE가 SALES가 아니면 TARGETBIZ, TARGETBIZ의 INCOTERMS는 모두 DAP
              --,A.FINAL_INCOTERMS  AS INCOTERMS
                -- 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CASE WHEN A.ETA_DATE < @P_PLAN_NAME THEN @P_PLAN_NAME
                    ELSE A.ETA_DATE
               END  AS ETA_DATE
	          ,A.DELIVERY_QTY
              --,IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
              ,CASE WHEN TS.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-' -- 법인간 이동 재고에는 Project Code 정보가 없음 
			        WHEN TS.SITE_TYPE = 'SALES' THEN IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) 
			        WHEN TS.SITE_TYPE = 'PLANT' THEN '-'  -- Cell Plant 가 Demand 로 동작하므로 '-' 처리
			        ELSE IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) 
			   END AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT

              ,CASE WHEN TS.SITE_TYPE = 'SALES' THEN 'SALES'
                    ELSE 'INT'
               END  AS FLAG
		INTO   #SCP_INTRANSIT_I
		FROM   SCM_DNM_INTRANSIT_V  A WITH (NOLOCK)

			   INNER JOIN #DIVISION D WITH(NOLOCK)
			   ON A.DIVISION_ID = D.DIVISION_ID

               INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V WITH (NOLOCK)) FI
               ON   A.DIVISION_ID          = FI.DIVISION_ID
               AND  A.ITEM_ID              = FI.ITEM_ID
               AND  FI.OPERATION_GROUP_ID  = 'E' -- 전극 모델

               INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                           FROM   SCM_MST_SITE WITH (NOLOCK) 
                           WHERE  DIVISION_ID IN(SELECT DIVISION_ID FROM #DIVISION WITH(NOLOCK))
                           AND    SITE_TYPE   = 'PLANT' 
                           AND    OPERATION_GROUP IN ('E') -- FROM_SITE 가 전극인 정보
						   AND    VALID_YN    = 'Y'	
                         )  FS
               ON   A.DIVISION_ID          = FS.DIVISION_ID
               AND  A.FROM_SCM_SITE_ID     = FS.SCM_SITE_ID
			   
                INNER JOIN SCM_MST_SITE TS WITH (NOLOCK) 
                ON  A.DIVISION_ID    = TS.DIVISION_ID
                AND A.TO_SCM_SITE_ID = TS.SCM_SITE_ID
                AND TS.VALID_YN       = 'Y'	
				AND (TS.SITE_TYPE = 'SALES' OR  TS.OPERATION_GROUP = 'A')	

        WHERE  1=1
        AND    A.RESULT_DATE   = @V_CUTOFF_DAY
		AND    A.RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
		
        /************************* 
        대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 필요
        *************************/
		--AND CONCAT(A.TO_SCM_SITE_ID, A.ITEM_ID) 
		--	IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
		--		FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
		--		WHERE  PLAN_ID = @V_PLAN_ID
		--		) 
        /************************* 
        대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 확인 필요
        *************************/
		AND (A.ITEM_ID
						IN (SELECT DISTINCT PARENT_ITEM_ID
							FROM   SCP_OPT_ENG_BOM_ELEC_SN WITH(NOLOCK)
							WHERE  PLAN_ID = @V_PLAN_ID
							AND    SCP_YN  = 'Y'
							UNION
							SELECT DISTINCT CHILD_ITEM_ID
							FROM   SCP_OPT_ENG_BOM_ELEC_SN WITH(NOLOCK)
							WHERE  PLAN_ID = @V_PLAN_ID
							AND    SCP_YN  = 'Y'
							) 
			)

        ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL;
   
        -- 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함
        INSERT INTO   #SCP_INTRANSIT_I		
		SELECT A.DIVISION_ID
              ,A.ITEM_ID
              ,MS.SCM_SITE_ID           AS TO_SCM_SITE_ID
              ,'DAP' AS INCOTERMS -- VMI 임
              -- 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CONVERT(NVARCHAR(8), DATEADD(D, 1, A.CUTOFF_DATE), 112)  AS ETA_DATE -- PLAN 시작일자로 처리	
	          ,ISNULL(A.SCM_QTY, 0)     AS DELIVERY_QTY
              ,'-'                      AS PROJECT_CODE
              ,'SALES'                  AS FLAG
		FROM   SCM_DNM_STOCK  A WITH (NOLOCK)

        INNER JOIN #DIVISION D WITH(NOLOCK)
            ON A.DIVISION_ID = D.DIVISION_ID

        INNER JOIN SCM_MST_VMI_INT_SLOC MS WITH(NOLOCK)
            ON    A.DIVISION_ID = MS.DIVISION_ID	
            AND   A.PLANT_ID    = MS.PLANT_ID
            AND   A.STORAGE_ID  = MS.STORAGE_ID
            AND   MS.VALID_YN   = 'Y'
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
		-- 전극 Item
		AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E'
        AND   (A.DIVISION_ID    = '40' AND A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
            OR A.DIVISION_ID   != '40')
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
		AND CONCAT(MS.SCM_SITE_ID, A.ITEM_ID) 
			IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
				FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
				WHERE  PLAN_ID = @V_PLAN_ID
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
                                       ,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                       ,INV.AVAILABLE_DATE
                                       ,INV.QTY
                                       ,INV.WIPHOLD_YN
                                       ,INV.SITE_TYPE
                                       ,INV.location_code
                                FROM    #SCP_INVENTORY_I INV WITH(NOLOCK)
                                    LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                        ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT2 = @V_DIVISION_ID
                                        AND INV.ITEM_ID = LU.SEGMENT3
                                        AND LU.VALID_YN = 'Y'
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
                                 SELECT DIVISION_ID
                                       ,ITEM_ID
                                       ,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                       ,TO_SCM_SITE_ID
                                       ,INCOTERMS
                                       ,ETA_DATE
                                       ,DELIVERY_QTY
                                       ,PROJECT_CODE
                                       ,FLAG
                                 FROM #SCP_INTRANSIT_I INV -- WHERE PROJECT_CODE = '-' AND FLAG ='SALES'
                                     LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                         ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                         AND LU.SEGMENT2 = @V_DIVISION_ID
                                         AND INV.ITEM_ID = LU.SEGMENT3
                                         AND LU.VALID_YN = 'Y'
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
                    ;

        --------------------------------------------------------
        -- 2025.10.01 Philsu Park: Workbench 재고 반영.
        --------------------------------------------------------
        SELECT    ADJ.DIVISION_ID
                , ADJ.ITEM_ID
                , ADJ.SCM_SITE_ID
                , ADJ.INCOTERMS
                , ADJ.INV_DATE
                , ADJ.CHG_QTY AS QTY
                , ADJ.PROJECT_CODE
                , ADJ.STOCK_TYPE
                , ADJ.LOCATION_CODE
                , CASE  WHEN ADJ.LOCATION_CODE NOT IN ('COATING', 'SLITTING') THEN 'TARGETBIZ' -- Cell Plant 재고 Sales SIte 로 취급                    
                        WHEN ADJ.LOCATION_CODE = 'SLITTING' THEN 'ELEC_POST'
                        WHEN ADJ.LOCATION_CODE = 'COATING'  THEN 'COATING'
                        ELSE '-' END AS STAGE
        INTO     #INVENTORY_ADJUST
        FROM    SCP_OPMZ_INV_ADJ ADJ WITH(NOLOCK)
            INNER JOIN #DIVISION DIV
                ON ADJ.DIVISION_ID = DIV.DIVISION_ID
            --INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
            --    ON  ML.PLAN_ID = @V_PLAN_ID
            --    AND ADJ.SCM_SITE_ID = ML.SCM_SITE_ID
            --    AND ADJ.ITEM_ID     = ML.ITEM_ID
        WHERE   1=1
        AND     ADJ.CUTOFF_YYYYMMDD = @V_PLAN_START_YYYYMMDD  -- PLAN 주차 기준.
        AND     ADJ.LOCATION_CODE  != '-'
        AND     ADJ.INV_DATE >= @V_PLAN_START_YYYYMMDD
        AND     ADJ.INV_DATE <  @V_PLAN_END_YYYYMMDD
        ;
		   
        --------------------------------------------------------
        -- INCOMING STOCK INSERT
        -- 2025.06.18 Philsu Park: DEMAND_EXCEPTION 룩업 등록된 대상 중 STOCK_EXCEPTION = 'Y'인 ITEM의 전극 환산 ITEM을 제외한다.(Site 조건 없이 ITEM 기준으로만 체크)
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
                                                 )
        SELECT PLAN_ID
              ,STOCK_ID
              ,BUFFER_ID
              ,EFECTIVE_DATE
              ,TYPE
              ,SUM(QUANTITY) AS QUANTITY
              ,SITE_ID
              ,ITEM_ID
              ,STAGE
              ,INCOTERMS
              ,PROJECT_CODE
        FROM (
				SELECT @V_PLAN_ID                                                                 AS PLAN_ID
					  ,TYPE+'::'+SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE) +'::'+EFECTIVE_DATE AS STOCK_ID
					  ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)     AS BUFFER_ID
					  ,EFECTIVE_DATE                                                                               AS EFECTIVE_DATE
					  ,TYPE                                                                                        AS TYPE
					  ,QTY                                                                                         AS QUANTITY
					  ,SITE_ID                                                                                     AS SITE_ID
					  ,ITEM_ID                                                                                     AS ITEM_ID
					  ,STAGE                                                                                       AS STAGE
					  ,INCOTERMS                                                                                   AS INCOTERMS
					  ,PROJECT_CODE                                                                                AS PROJECT_CODE
				FROM (
					SELECT A.SCM_SITE_ID AS SITE_ID
						 --, A.ITEM_ID AS ITEM_ID -- CELL 재고를 전극으로 전환
						 , CASE WHEN ISNULL(B.CHILD_ITEM_ID, '') = ''  THEN A.ITEM_ID
            					ELSE B.CHILD_ITEM_ID
							END ITEM_ID 

            			 /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성 */
						 , CASE 
            					WHEN A.FLAG  = 'SALES'                              THEN 'ELECBIZ'
            					WHEN A.FLAG  = 'INT'                                THEN 'TARGETBIZ' -- 전극은 Cell PKG 를 Demand로 처리하므로 Cell 도착은 Sales SIte 로 취급
            					WHEN A.LOCATION_CODE NOT IN ('COATING', 'SLITTING') THEN 'TARGETBIZ' -- Cell Plant 재고 Sales SIte 로 취급
								
            					WHEN A.LOCATION_CODE = 'SLITTING' THEN 'ELEC_POST'
            					WHEN A.LOCATION_CODE = 'COATING'  THEN 'COATING'
            					ELSE '-' END STAGE 
						 , CONVERT(VARCHAR(8), ISNULL(A.EFFSTARTDATE, CONVERT(DATETIME, @P_PLAN_NAME)), 112) AS EFECTIVE_DATE
						 , A.DESCR AS TYPE
						 --, A.QTY AS QTY -- CELL 재고를 전극으로 전환
						 , CASE WHEN ISNULL(B.CHILD_ITEM_ID, '') = ''  THEN A.QTY
            					ELSE A.QTY * ISNULL(B.USAGE, 1)
							END QTY 
            			 , INCOTERMS 
						 , PROJECT_CODE
					FROM   (
							SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID AS SCM_SITE_ID
            					 , INCOTERMS 
								 ,  CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))   AS EFFSTARTDATE
								 , SUM(QTY)        AS QTY					  
								 , CASE WHEN ISNULL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
										ELSE 'WH_HOLD'
								   END  AS DESCR
								 , LOCATION_CODE
								 , PROJECT_CODE
								 , FLAG
							FROM   #SCP_INVENTORY_I T WITH(NOLOCK)
							WHERE  1=1
							GROUP 
            					BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, CONVERT(CHAR(8), AVAILABLE_DATE, 112), ISNULL(T.WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG
            				HAVING SUM(T.QTY) > 0	
							UNION ALL
							-- INTRANSIT SHIPMENT 재고 
							SELECT DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID AS SCM_SITE_ID
            					 , INCOTERMS 
								 ,  CONVERT(DATETIME, ETA_DATE)  AS EFFSTARTDATE
								 , SUM(DELIVERY_QTY)             AS QTY
								 , 'INT'                         AS DESCR    
								 , '-'                           AS LOCATION_CODE
								 , PROJECT_CODE
								 , FLAG
							FROM   #SCP_INTRANSIT_I T WITH(NOLOCK)
							WHERE  1=1
							AND    T.DELIVERY_QTY  > 0 
							AND   (T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')
							GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, ETA_DATE, INCOTERMS, PROJECT_CODE, FLAG
							) A

							-- CELL 재고를 전극으로 전환하기 위한 정보
							LEFT JOIN (
										SELECT PARENT_ITEM_ID, CHILD_ITEM_ID, MAX(USAGE) AS USAGE
										FROM   SCP_OPT_ENG_BOM_ELEC_SN LU WITH(NOLOCK)
										WHERE  PLAN_ID = @V_PLAN_ID
										AND    SCP_YN  = 'Y'
										GROUP BY PARENT_ITEM_ID, CHILD_ITEM_ID 
									  ) B
							ON A.ITEM_ID = B.PARENT_ITEM_ID
			   
							LEFT JOIN SCM_MST_SITE TS WITH (NOLOCK) 
							ON  A.DIVISION_ID = TS.DIVISION_ID
							AND A.SCM_SITE_ID = TS.SCM_SITE_ID
							AND TS.VALID_YN   = 'Y'	
					WHERE  1=1
                    AND     NOT EXISTS ( 
                                        SELECT  1
                                        FROM    #INVENTORY_ADJUST ADJ
                                        WHERE   ADJ.DIVISION_ID     = A.DIVISION_ID
                                        AND     ADJ.SCM_SITE_ID     = A.SCM_SITE_ID
                                        AND     ADJ.ITEM_ID         = ISNULL(B.CHILD_ITEM_ID, A.ITEM_ID)
                                        AND     ADJ.LOCATION_CODE   = A.LOCATION_CODE
                                        AND     ADJ.INV_DATE        = CONVERT(VARCHAR(8), ISNULL(A.EFFSTARTDATE, CONVERT(DATETIME, @P_PLAN_NAME)), 112)
                                        AND     ADJ.INCOTERMS       = A.INCOTERMS
                                        AND     ADJ.PROJECT_CODE    = A.PROJECT_CODE
                                        AND     ADJ.STOCK_TYPE      = A.DESCR
                                        )
					/************************* 
					대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 확인 필요
					*************************/
					AND ((A.FLAG  = 'SALES' AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
													IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
														FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
														WHERE  PLAN_ID = @V_PLAN_ID
														) 
						 )
					  OR (TS.OPERATION_GROUP = 'E' AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
													IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
														FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
														WHERE  PLAN_ID = @V_PLAN_ID
														) 
						 )
					  OR (TS.OPERATION_GROUP = 'A' AND A.ITEM_ID
													IN (SELECT DISTINCT PARENT_ITEM_ID
														FROM   SCP_OPT_ENG_BOM_ELEC_SN WITH(NOLOCK)
														WHERE  PLAN_ID = @V_PLAN_ID
														AND    SCP_YN  = 'Y'
														UNION
														SELECT DISTINCT CHILD_ITEM_ID
														FROM   SCP_OPT_ENG_BOM_ELEC_SN WITH(NOLOCK)
														WHERE  PLAN_ID = @V_PLAN_ID
														AND    SCP_YN  = 'Y'
														) 
						 )
						)
                    
					)  A
				WHERE 1=1
                ---------------------------------------------------------------------------------------
                -- 2025.06.18 Philsu Park
                -- Demand Exception 대상 중 STOCK_EXCEPTION Flag = 'Y' 인 경우 재고 반영 제외.
                ---------------------------------------------------------------------------------------
                AND NOT EXISTS (SELECT 1
                                FROM    (   
                                        --SELECT  DISTINCT 
                                        --        ISNULL(B.CHILD_ITEM_ID, LV.SEGMENT4)   AS ELEC_ITEM_ID
                                        --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                        --LEFT OUTER JOIN SCP_MST_BOM_ELEC B WITH (NOLOCK) 
                                        --    ON  LV.SEGMENT4 = B.PARENT_ITEM_ID -- ASSY Item
                                        --    AND B.SCP_YN    = 'Y'
                                        --WHERE   LV.LOOKUP_TYPE  = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                        --AND     LV.VALID_YN     = 'Y'
                                        --AND     LV.SEGMENT2     = @V_DIVISION_ID
                                        --AND     LV.SEGMENT5     = @V_GROUP_ID
                                        --AND     LV.ATTRIBUTE1   = 'ASSY' -- CELL PLAN 제외
                                        --AND     LV.ATTRIBUTE4   = 'Y'    -- STOCK_EXCEPTION
                                        ---- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                                        --AND     B.CHILD_ITEM_ID NOT IN (
                                        --                                SELECT  DISTINCT ATTRIBUTE2
                                        --                                FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                                        --                                WHERE   DM.PLAN_ID = @V_PLAN_ID
                                        --                               )

                                        -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                                        SELECT  DISTINCT 
                                                ISNULL(B.CHILD_ITEM_ID, D.ITEM_ID)   AS ELEC_ITEM_ID
                                        FROM    SCP_OPMZ_DEMAND_EXCEPTION D WITH(NOLOCK)
                                            LEFT JOIN SCP_MST_BOM_ELEC B WITH (NOLOCK) 
                                                ON  D.ITEM_ID = B.PARENT_ITEM_ID -- ASSY Item
                                                AND B.SCP_YN    = 'Y'
                                            LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                                ON  D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                                AND PG.VALID_YN = 'Y'
                                            INNER JOIN  (
                                                        SELECT  DISTINCT ITEM_ID
                                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                        WHERE   PLAN_ID = @V_PLAN_ID
                                                        ) MDL
                                                ON  D.ITEM_ID = MDL.ITEM_ID
                                        WHERE   1=1
                                        AND     D.VALID_YN      = 'Y'
                                        AND     D.DIVISION_ID   = @V_DIVISION_ID
                                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                                        --AND     D.STAGE         = 'TARGETBIZ'   -- CELL PLAN 제외
                                        AND     D.ATTRIBUTE1    = 'Y'           -- STOCK_EXCEPTION
                                        -- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                                        AND     B.CHILD_ITEM_ID NOT IN (
                                                                        SELECT  DISTINCT ATTRIBUTE2
                                                                        FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                                                                        WHERE   DM.PLAN_ID = @V_PLAN_ID
                                                                        )
                                        ) INV_EXCEPTION
                                WHERE   1=1
                                AND     INV_EXCEPTION.ELEC_ITEM_ID  = A.ITEM_ID
                                )
				AND EFECTIVE_DATE < @V_PLAN_END_YYYYMMDD
                --------------------------------------------------------
				-- 2025.10.01 Philsu Park: Workbench 재고 추가
				--------------------------------------------------------
                UNION ALL
                SELECT @V_PLAN_ID                                                                 AS PLAN_ID
					  ,STOCK_TYPE+'::'+SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+'::'+INV_DATE    AS STOCK_ID
					  ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)                            AS BUFFER_ID
					  ,INV_DATE                                                                                     AS EFFECTIVE_DATE
					  ,STOCK_TYPE                                                                                   AS TYPE
					  ,QTY                                                                                         AS QUANTITY
					  ,SCM_SITE_ID                                                                                 AS SITE_ID
					  ,ITEM_ID                                                                                     AS ITEM_ID
					  ,STAGE                                                                                       AS STAGE
					  ,INCOTERMS                                                                                   AS INCOTERMS
					  ,PROJECT_CODE                                                                                AS PROJECT_CODE
                FROM    #INVENTORY_ADJUST INV
                WHERE QTY > 0
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
					   ,SCM_SITE_ID                                                AS ATTRIBUTE1
					   ,MAT_ID                                                     AS ATTRIBUTE2
					   ,STAGE                                                      AS ATTRIBUTE3
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
                    /* -- BLOCKED END 2025.11.19 jongykim2
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
		) AA
		GROUP BY PLAN_ID, STOCK_ID, BUFFER_ID, EFECTIVE_DATE, TYPE, SITE_ID, ITEM_ID, STAGE, INCOTERMS, PROJECT_CODE

   
        --------------------------------------------------------
        -- NERP로 넘어가지 않는 대상에 대해서 재고 위치 조정
        -- 나중에 LOOK UP으로 변경해야 할수도 있음
        --------------------------------------------------------
        -- 1-1 G452-E에 이미 존재하는데, G451-A에도 있는 데이터 UPDATE
        --------------------------------------------------------
        UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
        SET     SCP_OPT_ENG_INCOMING_STOCK_SN.QUANTITY = INS.SUM_QTY
               ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE6 = 'AFTER_UPDATE'
        FROM(
            SELECT  ITEM_ID        AS ITEM_ID       
                   ,STAGE          AS STAGE         
                   ,EFFECTIVE_DATE AS EFFECTIVE_DATE
                   ,TYPE           AS TYPE          
                   ,SUM(QTY)       AS SUM_QTY
            FROM(
                SELECT  ATTRIBUTE2                                      AS ITEM_ID
                       ,IIF(ATTRIBUTE1='G451-A','ELEC_POST',ATTRIBUTE3) AS STAGE
                       ,EFFECTIVE_DATE                                  AS EFFECTIVE_DATE
                       ,TYPE                                            AS TYPE
                       ,QUANTITY                                        AS QTY
                FROM    SCP_OPT_ENG_INCOMING_STOCK_SN WITH(NOLOCK)
                WHERE   PLAN_ID= @V_PLAN_ID
                AND     ATTRIBUTE1 IN ('G452-E','G451-A')
                AND     TYPE       IN ('WH','WH_HOLD')
                AND     ATTRIBUTE2 = 'APCAN2049A'
                ) INS
            GROUP BY ITEM_ID,STAGE,EFFECTIVE_DATE,TYPE
            HAVING COUNT(ITEM_ID) > 1
            ) INS
        WHERE   SCP_OPT_ENG_INCOMING_STOCK_SN.PLAN_ID        = @V_PLAN_ID
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE1     = 'G452-E'
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE2     = INS.ITEM_ID
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.EFFECTIVE_DATE = INS.EFFECTIVE_DATE
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE3     = INS.STAGE
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.TYPE           = INS.TYPE
            
        --------------------------------------------------------
        -- 1-1 G452-E에 이미 존재하는데, G451-A에도 있는 데이터는 G451-A는 0으로 UPDATE
        --------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_INCOMING_STOCK_SN
        FROM(
            SELECT  ITEM_ID        AS ITEM_ID       
                   ,STAGE          AS STAGE         
                   ,EFFECTIVE_DATE AS EFFECTIVE_DATE
                   ,TYPE           AS TYPE          
                   ,SUM(QTY)       AS SUM_QTY
            FROM(
                SELECT  ATTRIBUTE2                                      AS ITEM_ID
                       ,IIF(ATTRIBUTE1='G451-A','ELEC_POST',ATTRIBUTE3) AS STAGE
                       ,EFFECTIVE_DATE                                  AS EFFECTIVE_DATE
                       ,TYPE                                            AS TYPE
                       ,QUANTITY                                        AS QTY
                FROM    SCP_OPT_ENG_INCOMING_STOCK_SN WITH(NOLOCK)
                WHERE   PLAN_ID= @V_PLAN_ID
                AND     ATTRIBUTE1 IN ('G452-E','G451-A')
                AND     TYPE       IN('WH','WH_HOLD')
                AND     ATTRIBUTE2 = 'APCAN2049A'
                ) INS
            GROUP BY ITEM_ID,STAGE,EFFECTIVE_DATE,TYPE
            HAVING COUNT(ITEM_ID) > 1
            ) INS
        WHERE   SCP_OPT_ENG_INCOMING_STOCK_SN.PLAN_ID        = @V_PLAN_ID
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE1     = 'G451-A'
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE2     = INS.ITEM_ID
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.EFFECTIVE_DATE = INS.EFFECTIVE_DATE
        --AND     SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE3     = INS.STAGE -- STAGE는 강제로 ELEC_POST로 변환했기 때문에 조건에서 제외
        AND     SCP_OPT_ENG_INCOMING_STOCK_SN.TYPE           = INS.TYPE
   
        --------------------------------------------------------
        -- 2 G452-E에 없고, G451-A에만 있는 데이터는 G452-E로 UPDATE
        --------------------------------------------------------
        UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN 
        SET     STOCK_ID  = TYPE+'::'+'G452-E'+'::'+ATTRIBUTE2+'::'+'ELEC_POST'+'::'+EFFECTIVE_DATE
               ,BUFFER_ID ='G452-E'+'::'+ATTRIBUTE2+'::'+'ELEC_POST'
               ,ATTRIBUTE1 = 'G452-E'
               ,ATTRIBUTE3 = 'ELEC_POST'
               ,ATTRIBUTE4 = '-'
               ,ATTRIBUTE5 = ''
               ,ATTRIBUTE6 = 'AFTER_UPDATE'
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN WITH(NOLOCK)  
        WHERE   PLAN_ID    =@V_PLAN_ID
        AND     TYPE       IN('WH','WH_HOLD')
        AND     ATTRIBUTE1 = 'G451-A'
        AND     ATTRIBUTE2 = 'APCAN2049A'
        --AND     QUANTITY  != 0
    
        --------------------------------------------------------
        -- 3 WA00-E, APCAN2049A는 TARGETBIZ로 변경
        --------------------------------------------------------
        UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN 
        SET     STOCK_ID  = TYPE+'::'+ATTRIBUTE1+'::'+ATTRIBUTE2+'::'+'TARGETBIZ@DAP@-'+'::'+EFFECTIVE_DATE
               ,BUFFER_ID =ATTRIBUTE1+'::'+ATTRIBUTE2+'::'+'TARGETBIZ@DAP@-'
               ,ATTRIBUTE1 = ATTRIBUTE1
               ,ATTRIBUTE3 = 'TARGETBIZ'
               ,ATTRIBUTE4 = 'DAP'
               ,ATTRIBUTE5 = '-'
               ,ATTRIBUTE6 = 'AFTER_UPDATE'
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN WITH(NOLOCK)  
        WHERE   PLAN_ID    = @V_PLAN_ID
        AND     TYPE       IN('WH','WH_HOLD')
        AND     ATTRIBUTE1 = 'WA00-E'
        AND     ATTRIBUTE2 = 'APCAN2049A'

        --------------------------------------------------------
        -- 4 2025.09.01 Philsu Park
        -- APCAN2049A: WA에 위치한 재고 삭제처리(재고 감안한 수요(출하)계획 반영.)
        --------------------------------------------------------
        DELETE
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN 
        WHERE   PLAN_ID         = @V_PLAN_ID
        AND     ATTRIBUTE1   LIKE 'WA00%'
        AND     ATTRIBUTE2      = 'APCAN2049A'
        -- AND     TYPE       IN('WH','WH_HOLD')
        ;


        --------------------------------------------------------
        -- 2025-11-24 jongykim2: Hold 재고의 Release를 룩업 기반으로 반영. (PSD + n)
        -- hold 재고의 유효일자를 PSD로 변경키 위해 기존 Lookup(SCP_OPT_ENG_GM_RELEASE_HOLD)을 사용하였음!
        --------------------------------------------------------
        UPDATE  S
        SET       S.EFFECTIVE_DATE  = CONVERT(NVARCHAR, DATEADD(DAY, LK.ADD_DAYS, @D_PLAN_NAME), 112)
                , S.UPDATE_ID       = 'HOLD_UPDATE'
                , S.UPDATE_TIME     = CURRENT_TIMESTAMP
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN S
        INNER JOIN (
                    SELECT    SEGMENT3 AS SITE_ID
                            , SEGMENT4 AS STAGE
                            , CONVERT(INT, ATTRIBUTE1) AS ADD_DAYS
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE  = 'SCP_OPT_ENG_GM_RELEASE_HOLD'
                    AND     VALID_YN     = 'Y'
                    AND     SEGMENT1     = @V_DIVISION_ID
                    --AND     SEGMENT2     = @V_GROUP_ID
                    AND     SEGMENT2     = @V_PLAN_GROUP_ORG
                    ) LK
            ON  LK.SITE_ID  = S.ATTRIBUTE1
            AND LK.STAGE    = S.ATTRIBUTE3
        WHERE   S.PLAN_ID   = @V_PLAN_ID
        AND     CHARINDEX('HOLD', S.TYPE) > 0
        ;

        -- 2026.04.08 Minyong Lee : 법인간 이동 재고 BUFFER_ID, STOCK_ID 생성 규칙 수정, INCOTERMS / PROJECT_CODE 제거
        SELECT  A.PLAN_ID
              , TYPE+'::'+A.ATTRIBUTE1+'::'+A.ATTRIBUTE2+'::'+A.ATTRIBUTE3+'::'+A.EFFECTIVE_DATE      AS STOCK_ID
              , A.ATTRIBUTE1+'::'+A.ATTRIBUTE2+'::'+A.ATTRIBUTE3                                      AS BUFFER_ID
              , A.EFFECTIVE_DATE
              , A.TYPE
              , SUM(A.QUANTITY)     AS QUANTITY
              , A.ATTRIBUTE1
              , A.ATTRIBUTE2
              , A.ATTRIBUTE3
              , '-'     AS ATTRIBUTE4
              , ''      AS ATTRIBUTE5
              , A.ATTRIBUTE15
        INTO #COMPANY_INT_STK
        FROM (
            SELECT  PLAN_ID
                  , EFFECTIVE_DATE
                  , TYPE
                  , QUANTITY
                  , ATTRIBUTE1
                  , ATTRIBUTE2
                  , ATTRIBUTE3
                  , ATTRIBUTE15
            FROM    SCP_OPT_ENG_INCOMING_STOCK_SN WITH(NOLOCK)
            WHERE   PLAN_ID = @V_PLAN_ID
            AND     STOCK_ID LIKE 'INT%'
            AND     ATTRIBUTE3 NOT LIKE '%BIZ'
        ) A
        GROUP BY PLAN_ID, EFFECTIVE_DATE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE15

        DELETE
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN
        WHERE   PLAN_ID = @V_PLAN_ID
        AND     STOCK_ID LIKE 'INT%'
        AND     ATTRIBUTE3 NOT LIKE '%BIZ'

        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN(
            PLAN_ID
          , STOCK_ID
          , BUFFER_ID
          , EFFECTIVE_DATE
          , TYPE
          , QUANTITY
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , ATTRIBUTE4
          , ATTRIBUTE5
          , ATTRIBUTE15
        )
        SELECT  PLAN_ID
              , STOCK_ID
              , BUFFER_ID
              , EFFECTIVE_DATE
              , TYPE
              , QUANTITY
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE15
        FROM    #COMPANY_INT_STK

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

		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		IF OBJECT_ID('TEMPDB..#COMPANY_INT_STK') IS NOT NULL
		BEGIN 
			DROP TABLE  #COMPANY_INT_STK;
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

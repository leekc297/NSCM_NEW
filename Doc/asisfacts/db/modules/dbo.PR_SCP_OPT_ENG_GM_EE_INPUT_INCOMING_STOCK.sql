

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_INCOMING_STOCK]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_INCOMING_STOCK';
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
        SELECT @D_PLAN_NAME         = CONVERT(DATE, @P_PLAN_NAME);
        SELECT @V_CUTOFF_DAY        = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)), 112) ; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
        SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
        SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD

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
        /* -- BLOCKED 2025.11.19 jongykim2
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
		SELECT A.DIVISION_ID                                      AS DIVISION_ID
			  ,A.SCM_SITE_ID                                      AS SCM_SITE_ID 
			  --,CASE WHEN B.OPERATION_GROUP = 'E' THEN '-' 
     --               ELSE 'DAP'
     --          END AS INCOTERMS
              ,'-'                                                AS INCOTERMS
			  ,A.STOCK_TYPE                                       AS STOCK_TYPE
			  ,A.ITEM_ID                                          AS ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              --,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              --      WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN CONVERT(CHAR(8), AVAILABLE_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATETIME, @P_PLAN_NAME)
                    ELSE                                                           CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))  
               END                                                AS AVAILABLE_DATE
			  ,A.SCM_QTY                                          AS QTY 
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = '' THEN 'N'
                    ELSE A.WIPHOLD_YN
               END                                                AS WIPHOLD_YN
			  ,B.SITE_TYPE
			 , A.LOCATION_CODE AS LOCATION_CODE -- PLANT 재고 구분용 정보
             --,CASE WHEN B.OPERATION_GROUP = 'E' THEN '' 
             --       ELSE '-'
             --  END                                                AS PROJECT_CODE
             ,'-'                                                  AS PROJECT_CODE
             ,'PLANT'                                             AS FLAG
        INTO #SCP_INVENTORY_I
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
               
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.LOCATION_CODE IN ( --,'FOLDING'
                                    'COATING'
                                    --,'LAMINATION'
                                    --,'CELL_OWMS'
                                    ,'SLITTING'
                                    --,'PACKAGING'
                                    --,'FORMATION_CHECK_PACKAGING'
                                    --,'FORMATION'
                                    ,'NOTCHING'


                                  )
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
        ;

        --------------------------------------------------------
        -- 2025.09.23 Philsu Park: 재고 보정값 반영을 위한 TEMP Input.
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
                /* , CASE WHEN SUBSTRING(ADJ.STOCK_TYPE, 1, 3) = 'FOR' THEN 'ASY_AGING'
                    ELSE ST.STAGE
                    END AS STAGE */
                -- , ADJ.QTY
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
        --FROM    SCP_OPMZ_INV_ADJ ADJ WITH(NOLOCK)
        --WHERE   ADJ.DIVISION_ID     = @V_DIVISION_ID
        --AND     ADJ.CUTOFF_YYYYMMDD = @V_PLAN_START_YYYYMMDD  -- PLAN 주차 기준.
        --AND     ADJ.LOCATION_CODE  != '-'
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
					  ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='-','','@'+PROJECT_CODE)     AS BUFFER_ID
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
						 , A.ITEM_ID AS ITEM_ID
                         -- GM 전극은 따로 전환하지 않고 자기 껄 바라봄/20250818/김태현 선임
						 --, CASE WHEN ISNULL(B.CHILD_ITEM_ID, '') = ''  THEN A.ITEM_ID
       --     					ELSE B.CHILD_ITEM_ID
							--END ITEM_ID 

            			 /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성 */
						 , CASE 
            					--WHEN A.LOCATION_CODE = 'SLITTING'  THEN 'COATING'
            					--WHEN A.LOCATION_CODE = 'COATING'  THEN 'COATING'
                 --               WHEN A.LOCATION_CODE = 'NOTCHING' THEN 'NND'
                                WHEN (ISNULL(OCV.STAGE,'') = '') AND A.LOCATION_CODE = 'SLITTING'  THEN 'COATING'
                                WHEN (ISNULL(OCV.STAGE,'') = '') AND A.LOCATION_CODE = 'COATING'   THEN 'COATING'
                                WHEN (ISNULL(OCV.STAGE,'') = '') AND A.LOCATION_CODE = 'NOTCHING'  THEN 'NND'
                                WHEN  ISNULL(OCV.STAGE,'') != '' THEN OCV.STAGE
            					--WHEN A.LOCATION_CODE = 'SLITTING'  THEN 'INSP_COT'
            					--WHEN A.LOCATION_CODE = 'COATING'  THEN 'INSP_COT'
                 --               WHEN A.LOCATION_CODE = 'NOTCHING' THEN 'INSP_NND'
            					WHEN A.LOCATION_CODE NOT IN ('COATING', 'NOTCHING') THEN 'TARGETBIZ' -- Cell Plant 재고 Sales SIte 로 취급
            					ELSE '-' END STAGE 
						 , CONVERT(VARCHAR(8), ISNULL(A.EFFSTARTDATE, CONVERT(DATETIME, @P_PLAN_NAME)), 112) AS EFECTIVE_DATE
						 , A.DESCR AS TYPE
						 , A.QTY AS QTY
                         -- GM 전극은 따로 전환하지 않고 자기 껄 바라봄/20250818/김태현 선임
						 --, CASE WHEN ISNULL(B.CHILD_ITEM_ID, '') = ''  THEN A.QTY
       --     					ELSE A.QTY * ISNULL(B.USAGE, 1)
							--END QTY 
                         , IIF(ISNULL(OCV.STAGE,'') = '', INCOTERMS, '-') AS INCOTERMS
                         , IIF(ISNULL(OCV.STAGE,'') = '', PROJECT_CODE, '-') AS PROJECT_CODE
            			--  , INCOTERMS 
						--  , PROJECT_CODE
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
                            AND     NOT EXISTS (
                                                SELECT 1
                                                FROM #INVENTORY_ADJUST ADJ
                                                WHERE   ADJ.DIVISION_ID = T.DIVISION_ID
                                                AND     ADJ.ITEM_ID     = T.ITEM_ID
                                                AND     ADJ.SCM_SITE_ID = T.SCM_SITE_ID
                                                AND     ADJ.LOCATION_CODE = T.LOCATION_CODE
                                                --AND     ADJ.INCOTERMS   = T.INCOTERMS
                                                AND     IIF(T.SITE_TYPE = 'PLANT',T.INCOTERMS,ADJ.INCOTERMS)   = T.INCOTERMS
                                                --AND     ADJ.PROJECT_CODE    = T.PROJECT_CODE
                                                AND     IIF(ADJ.PROJECT_CODE='','-',ADJ.PROJECT_CODE)    = T.PROJECT_CODE
                                                AND     ADJ.STOCK_TYPE  = CASE WHEN ISNULL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
                                                                                ELSE 'WH_HOLD'
                                                                        END
                                                AND     ADj.INV_DATE    = CONVERT(CHAR(8), AVAILABLE_DATE, 112)
                                                )
							GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, CONVERT(CHAR(8), AVAILABLE_DATE, 112), ISNULL(T.WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG
            				HAVING SUM(T.QTY) > 0
                            UNION 
                            SELECT    ADJ.DIVISION_ID   AS DIVISION_ID
                                    , ADJ.ITEM_ID       as ITEM_ID
                                    , ADJ.SCM_SITE_ID   AS SCM_SITE_ID
                                    , ADJ.INCOTERMS     AS INCOTERMS
                                    , ADJ.INV_DATE      AS INV_DATE
                                    , SUM(ADJ.QTY)      AS QTY
                                    , ADJ.STOCK_TYPE    AS DESCR
                                    , ADJ.LOCATION_CODE AS LOCATION_CODE
                                    , ADJ.PROJECT_CODE  AS PROJECT_CODE
                                    , NULL              AS FLAG
                                    /* , CASE WHEN SUBSTRING(ADJ.STOCK_TYPE, 1, 3) = 'FOR' THEN 'ASY_AGING'
                                        ELSE ST.STAGE
                                        END AS STAGE */
                                    -- , ADJ.QTY
                            FROM    #INVENTORY_ADJUST ADJ
                            GROUP BY   ADJ.DIVISION_ID, ADJ.ITEM_ID, ADJ.SCM_SITE_ID, ADJ.INCOTERMS, ADJ.INV_DATE, ADJ.PROJECT_CODE, ADJ.STOCK_TYPE, ADJ.LOCATION_CODE
                            HAVING  SUM(ADJ.QTY) > 0
							) A

							-- CELL 재고를 전극으로 전환하기 위한 정보
                            -- GM 전극은 따로 전환하지 않고 자기 껄 바라봄/20250818/김태현 선임
							--LEFT JOIN (
							--			SELECT PARENT_ITEM_ID, CHILD_ITEM_ID, MAX(USAGE) AS USAGE
							--			FROM   SCP_OPT_ENG_BOM_ELEC_SN LU WITH(NOLOCK)
							--			WHERE  PLAN_ID = @V_PLAN_ID
							--			AND    SCP_YN  = 'Y'
							--			GROUP BY PARENT_ITEM_ID, CHILD_ITEM_ID 
							--		  ) B
							--ON A.ITEM_ID = B.PARENT_ITEM_ID
			   
							LEFT JOIN SCM_MST_SITE TS WITH (NOLOCK) 
							    ON  A.DIVISION_ID = TS.DIVISION_ID
							    AND A.SCM_SITE_ID = TS.SCM_SITE_ID
							    AND TS.VALID_YN   = 'Y'	
                            LEFT OUTER JOIN (
                                            SELECT  SEGMENT4   AS SCM_SITE_ID
                                                   ,SEGMENT5   AS ITEM_ID
                                                   ,ATTRIBUTE3 AS STAGE
                                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                            WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                            AND     LU.SEGMENT2    = @V_DIVISION_ID
                                            AND     LU.SEGMENT3    = @V_GROUP_ID
                                            AND     LU.VALID_YN    = 'Y'
                                            GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE3
                                           ) OCV
                                ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                                AND A.ITEM_ID     = OCV.ITEM_ID

					WHERE  1=1
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
                                            WHERE   1=1
                                            AND     D.VALID_YN      = 'Y'
                                            AND     D.DIVISION_ID   = @V_DIVISION_ID
                                            AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                                            --AND     D.STAGE         = 'TARGETBIZ'   -- CELL PLAN 제외
                                            AND     D.ATTRIBUTE1    = 'Y'           -- STOCK_EXCEPTION
                                            ) INV_EXCEPTION
                                    WHERE   1=1
                                    AND     INV_EXCEPTION.ELEC_ITEM_ID  = A.ITEM_ID
                                    )
					)  A
				WHERE 1=1
				AND EFECTIVE_DATE < @V_PLAN_END_YYYYMMDD

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
                    /* -- BLOCKED 2025.11.19 jongykim2
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
        ;

        --------------------------------------------------------
        -- 2025.09.08 Philsu Park: Hold 재고의 Release를 룩업 기반으로 반영. (PSD + n)
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
            AND LK.EW_STAGE = S.ATTRIBUTE3
        WHERE   S.PLAN_ID   = @V_PLAN_ID
        AND     CHARINDEX('HOLD', S.TYPE) > 0
        ;

        IF OBJECT_ID('TEMPDB..#SCP_INVENTORY_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INVENTORY_I;
		END;		

		IF OBJECT_ID('TEMPDB..#SCP_INTRANSIT_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INTRANSIT_I;
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

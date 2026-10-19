
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_SR_INPUT_BOM]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_SR_INPUT_BOM';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;
    DECLARE @CHK_BOM_BATCH       NVARCHAR(100);

    --속도 개선용
    DECLARE @BOM_TEMP TABLE(
                            PLAN_ID             NVARCHAR(50)
                           ,BOM_ID              NVARCHAR(50)
                           ,OP_SEQ              INT
                           ,MATERIAL_CLASS_ID   NVARCHAR(50)
                           ,MATERIAL_BUFFER_ID  NVARCHAR(50)
                           ,PRIORITY            INT
                           ,CONSUME_QUANTITY    NUMERIC(20,10)
                           ,ATTRIBUTE1          NVARCHAR(50)
                           ,ATTRIBUTE2          NVARCHAR(50)
                           ,ATTRIBUTE3          NVARCHAR(50)
                           ,ATTRIBUTE14         NVARCHAR(50)
                           ,ATTRIBUTE15         NVARCHAR(50)
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
        -- CHECK BOM BATCH 
        ------------------------------------------------------------------------
        SELECT  TOP 1 @CHK_BOM_BATCH = LOG_TYPE
        FROM    scm_sys_log_batch WITH(NOLOCK) 
        WHERE   1=1
        AND     PROGRAM_NAME = 'PR_SCP_MST_ALTER_BOM_BATCH'
        ORDER BY LAST_UPDATE_DATE DESC

        IF @CHK_BOM_BATCH = 'START'
        BEGIN
            RAISERROR('BOM batch program is processing',15,1)
        END

        ------------------------------------------------------------------------
        -- SET Param
        ------------------------------------------------------------------------
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;

        ------------------------------------------------------------------------
        --TEST용 07주차 고정
        ------------------------------------------------------------------------
        --SELECT @P_PLAN_NAME = '20250210'; -- 당주 월요일 YYYYMMDD
        --SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;

        IF OBJECT_ID('TEMPDB..#PACK_BOM_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #PACK_BOM_LIST;
            END;

        SELECT A.*
                , B.SCP_PLAN_YN 
                , I.FLOW_ID
                , IC.FLOW_ID AS CHILD_FLOW_ID
                , CASE WHEN A.ALT_ID IS NULL AND ISNULL(IC.ITEM_CLASS, '') = 'ES0901' 
                    THEN ROW_NUMBER()OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PARENT_ITEM_ID ORDER BY A.CHILD_ITEM_ID) 
                ELSE NULL END AS R_NUM
                , CASE WHEN A.ALT_ID IS NULL AND ISNULL(IC.ITEM_CLASS, '') = 'ES0901' 
                    THEN COUNT(ITM.ITEM_ID)OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PARENT_ITEM_ID) 
                ELSE NULL END AS CNT
        INTO   #PACK_BOM_LIST
        FROM   SCM_MST_BOM_ENG_SN A WITH (NOLOCK)
        INNER JOIN SCM_MST_ITEM_SN I WITH (NOLOCK)
            ON  A.COMPANY_ID     = I.COMPANY_ID
            AND A.DIVISION_ID    = I.DIVISION_ID
            AND A.SITE_ID        = I.SITE_ID
            AND A.PARENT_ITEM_ID = I.ITEM_ID
            AND I.ACTIVE_FLAG    = 'Y'
        INNER JOIN SCM_MST_ITEM_SN IC WITH (NOLOCK)
            ON  A.COMPANY_ID     = IC.COMPANY_ID
            AND A.DIVISION_ID    = IC.DIVISION_ID
            AND A.SITE_ID        = IC.SITE_ID
            AND A.CHILD_ITEM_ID  = IC.ITEM_ID
            AND IC.ACTIVE_FLAG    = 'Y'
        LEFT OUTER JOIN SCM_MST_ITEM_SN ITM WITH (NOLOCK)
            ON  A.COMPANY_ID     = ITM.COMPANY_ID
            AND A.DIVISION_ID    = ITM.DIVISION_ID
            AND A.SITE_ID        = ITM.SITE_ID
            AND A.CHILD_ITEM_ID  = ITM.ITEM_ID
            AND ITM.ACTIVE_FLAG  = 'Y'
            AND ITM.ITEM_CLASS   = 'ES0901'
        LEFT OUTER JOIN SCM_MST_ALTER_BOM_V B WITH(NOLOCK)
            ON  A.DIVISION_ID    = B.DIVISION_ID
            AND A.SITE_ID        = B.SITE_ID
            AND A.PLANT_ID       = B.PLANT_ID
            AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
            AND A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
        WHERE  1=1
        AND    A.DIVISION_ID  = @V_DIVISION_ID
        --AND    @V_DIVISION_ID <> '40' -- 소형은 CELL Demand 만 처리하므로 Pack BOM 필요 없음
        AND    ISNULL(I.FLOW_ID, '')    != ''
        AND    I.FLOW_ID                != '-'
        AND    A.CHILD_QTY              >  0
        AND    A.EFF_END_DATE           >  @D_PLAN_NAME  -- PLAN NAME 일자에 유효한 BOM
        AND    @P_PLAN_NAME  <  CONVERT(VARCHAR(8),A.EFF_END_DATE,112)
        AND    A.ACTIVE_FLAG  = 'Y'
        AND   (A.ALT_ID IS NULL 
                OR (A.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NULL AND ISNULL(A.ALT_PRIORITY, 1) = 1) 
                OR (A.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NOT NULL AND B.SCP_PLAN_YN = 'Y'))
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        AND (A.PARENT_ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                            WHERE   PLAN_ID = @V_PLAN_ID
                            )
            OR A.CHILD_ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                            WHERE   PLAN_ID = @V_PLAN_ID
                            )
            )
        ;
        ------------------------------------------------------------------------
        -- DATA Insert
        ------------------------------------------------------------------------
        --바로 INSERT하면 속도가 느림
        INSERT INTO @BOM_TEMP(
                             PLAN_ID           
                            ,BOM_ID            
                            ,OP_SEQ            
                            ,MATERIAL_CLASS_ID 
                            ,MATERIAL_BUFFER_ID
                            ,PRIORITY          
                            ,CONSUME_QUANTITY  
                            ,ATTRIBUTE1        
                            ,ATTRIBUTE2        
                            ,ATTRIBUTE3        
                            ,ATTRIBUTE14       
                            ,ATTRIBUTE15       
        )
        SELECT @V_PLAN_ID
              ,PLANT_SITE_ID+'::'+PARENT_ITEM_ID+'::'+STAGE         AS BOM_ID
              ,0                                                    AS OP_SEQ
              ,MATERIAL_CLASS_ID                                    AS MATERIAL_CLASS_ID
            --   ,CHILD_STAGE                                       AS MATERIAL_CLASS_ID
              ,PLANT_SITE_ID+'::'+CHILD_ITEM_ID+'::'+CHILD_STAGE    AS MATERIAL_BUFFER_ID
              ,1                                                    AS PRIORITY
              ,CHILD_QTY                                            AS COMSUME_QUANTITY
              ,PLANT_SITE_ID                                        AS ATTRIBUTE1
              ,PARENT_ITEM_ID                                       AS ATTRIBUTE2
              ,STAGE                                                AS ATTRIBUTE3
              ,CHILD_ITEM_ID                                        AS ATTRIBUTE14
            --   ,MATERIAL_CLASS_ID                                    AS ATTRIBUTE15
              ,CHILD_STAGE                                          AS ATTRIBUTE15
        FROM(
            ------------------------------------------------------------------------
            -- 1. 법인 BOM : Pack
            -- 2025.06.17 Philsu Park: 대치가 아니라 조립관계인 SUBMDLE에 대해 MATERIAL_CLASS_ID 순차 처리.
            ------------------------------------------------------------------------
            SELECT C.SCM_SITE_ID AS PLANT_SITE_ID
				 , A.PARENT_ITEM_ID  AS PARENT_ITEM_ID
				 , CASE WHEN A.FLOW_ID = 'P9500' THEN 'PACK'
						WHEN A.FLOW_ID = 'P5500' THEN 'MDLE'
						WHEN A.FLOW_ID NOT IN ('P9500', 'P5500') THEN 'SUBMDLE'
				   END AS STAGE

				 , A.CHILD_ITEM_ID   AS CHILD_ITEM_ID

				 , CASE WHEN BC.OPERATION_GROUP = 'P' THEN 'SUBMDLE'
					    WHEN BC.OPERATION_GROUP = 'A' THEN 'CHAR'
				   END AS CHILD_STAGE
				 , CASE WHEN A.CNT > 1 THEN
                            CONCAT(CASE WHEN BC.OPERATION_GROUP = 'P' THEN 'SUBMDLE'
                                        WHEN BC.OPERATION_GROUP = 'A' THEN 'CHAR'
                                    END, CONVERT(NVARCHAR, A.R_NUM))
                        ELSE 
                                CASE WHEN BC.OPERATION_GROUP = 'P' THEN 'SUBMDLE'
                                     WHEN BC.OPERATION_GROUP = 'A' THEN 'CHAR'
                                END
                        END AS MATERIAL_CLASS_ID
				 , CASE WHEN ISNULL(MAX(A.PARENT_QTY), 0) = 0 THEN 1
						WHEN MAX(A.CHILD_QTY) < 0 THEN 0
						WHEN ROUND(MAX(A.CHILD_QTY) / MAX(A.PARENT_QTY), 3, 0) = 0 THEN 1
						ELSE ROUND(IIF(MAX(A.CHILD_QTY) < 0, 0, MAX(A.CHILD_QTY)) / MAX(A.PARENT_QTY), 3, 0)  
				   END AS CHILD_QTY
			FROM   #PACK_BOM_LIST A
            INNER JOIN ( SELECT PARENT_ITEM_ID
                                , COMPANY_ID
                                , DIVISION_ID
                                , SITE_ID
                                , PLANT_ID
                                , CHILD_ITEM_ID
                                , BOM_VERSION_ID
                                , FLOW_ID
                                , MAX(KEY_DATE) MAX_KEY_DATE                         
                            FROM  #PACK_BOM_LIST AA 
                            WHERE 1=1
                            GROUP BY PARENT_ITEM_ID
                                , COMPANY_ID
                                , DIVISION_ID
                                , SITE_ID
                                , PLANT_ID
                                , CHILD_ITEM_ID
                                , BOM_VERSION_ID
                                , FLOW_ID
                        ) D 
                ON     A.PARENT_ITEM_ID     = D.PARENT_ITEM_ID
                AND    A.COMPANY_ID         = D.COMPANY_ID
                AND    A.DIVISION_ID        = D.DIVISION_ID 
                AND    A.SITE_ID            = D.SITE_ID 
                AND    A.PLANT_ID           = D.PLANT_ID 
                AND    A.CHILD_ITEM_ID      = D.CHILD_ITEM_ID 
                AND    A.BOM_VERSION_ID     = D.BOM_VERSION_ID
                AND    A.FLOW_ID            = D.FLOW_ID 
                AND    A.KEY_DATE           = D.MAX_KEY_DATE 
            -- Parent 용 공정
            INNER JOIN (SELECT T.*
                        FROM   SCM_MST_OPERATION_FLOW_V T WITH(NOLOCK)
                        WHERE  T.DIVISION_ID = @V_DIVISION_ID
                        AND    T.VALID_YN    = 'Y'
                        AND    SUBSTRING(T.FLOW_ID, 1, 1) NOT IN ('A', 'E')  -- 전극 공정 제외 / CELL PACKAGE 공정은 UNION 아래서 처리
                        --UNION
                        --SELECT T.*
                        --FROM   SCM_MST_OPERATION_FLOW_V T WITH(NOLOCK)
                        --WHERE  T.DIVISION_ID = @V_DIVISION_ID
                        --AND    T.VALID_YN    = 'Y'
                        --AND     T.OPERATION_ID IN ('A3000', 'A8210', 'A9000')  -- CELL PACKAGE 하위 공정은 계획 대상 아님
                        ) B
                ON     A.COMPANY_ID         = B.COMPANY_ID
                AND    A.DIVISION_ID        = B.DIVISION_ID
                AND    A.SITE_ID            = B.SITE_ID
                AND    A.FLOW_ID            = B.FLOW_ID
            -- Child 용 공정
            INNER JOIN (SELECT T.*
                        FROM   SCM_MST_OPERATION_FLOW_V T WITH(NOLOCK)
                        WHERE  T.DIVISION_ID = @V_DIVISION_ID
                        AND    T.VALID_YN    = 'Y'
                        AND    SUBSTRING(T.FLOW_ID, 1, 1) NOT IN ('A', 'E')  -- 전극 공정 제외 / CELL PACKAGE 공정은 UNION 아래서 처리
                        UNION
                        SELECT T.*
                        FROM   SCM_MST_OPERATION_FLOW_V T WITH(NOLOCK)
                        WHERE  T.DIVISION_ID = @V_DIVISION_ID
                        AND    T.VALID_YN    = 'Y'
                        AND     T.OPERATION_ID IN ('A3000', 'A8210', 'A9000')  -- CELL PACKAGE 하위 공정은 계획 대상 아님
                        ) BC
                ON     A.COMPANY_ID         = BC.COMPANY_ID
                AND    A.DIVISION_ID        = BC.DIVISION_ID
                AND    A.SITE_ID            = BC.SITE_ID
                AND    A.CHILD_FLOW_ID      = BC.FLOW_ID
            INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
                ON     A.DIVISION_ID        = C.DIVISION_ID
                AND    A.PLANT_ID           = (CASE WHEN C.OSP_YN = 'Y' THEN C.LOGISTIC_PLANT_ID ELSE C.PLANT_ID END)
                AND    B.OPERATION_GROUP    = C.OPERATION_GROUP
                AND    C.VALID_YN           = 'Y'
			WHERE  1=1
			/* AND    A.FLOW_ID            IS NOT NULL
			AND    A.FLOW_ID           <> ''  
			AND    A.FLOW_ID           <> '-'  
			AND    A.CHILD_QTY         >  0  
			-- PLAN NAME 일자에 유효한 BOM
			AND    A.EFF_END_DATE      >  @D_PLAN_NAME */
        
			-- ISUZU 대상 중 외주PACK 생산품은 제외.
            -- 2025.06.19 Philsu Park: 대상 모델이 단 하나. 속도개선을 위해 막고 돌려봄.
			/* AND  NOT EXISTS (SELECT 'X'
							 FROM  (SELECT A.ITEM_ID , B.SCM_SITE_ID 
									FROM  ( SELECT * 
											FROM  SCM_MST_FINAL_ITEM_V A WITH(NOLOCK) 
											WHERE A.DIVISION_ID  = @V_DIVISION_ID
											AND   A.IS_YN        = 'Y'   -- ISUZU 대상 검색
											) A 
									INNER JOIN ( -- PACK 외주생산 ITEM 검색 
											SELECT E.DIVISION_ID , E.ITEM_ID , E.SCM_SITE_ID , B.OPERATION_GROUP 
											FROM  SCM_MST_SITE_ITEM E WITH (NOLOCK)
												, SCM_MST_SITE  B WITH(NOLOCK)
											WHERE 1=1
											AND    B.DIVISION_ID        = E.DIVISION_ID
											AND    B.SCM_SITE_ID        = E.SCM_SITE_ID
											AND    B.OSP_YN             = 'Y'         -- 외주 PACKER	
											AND    B.OPERATION_GROUP    = 'P'         -- PACK 작업
											) B 
											ON ( 1=1
											AND  B.DIVISION_ID = A.DIVISION_ID 
											AND  B.ITEM_ID     = A.ITEM_ID )                        
									) X 
							WHERE A.PARENT_ITEM_ID = X.ITEM_ID 
						)    -- NOT EXISTS 끝.
             */
			/************************* 
			대상 프로젝트 ITEM 필터링 
			*************************/
			AND (C.SCM_SITE_ID + A.PARENT_ITEM_ID)
							IN (SELECT DISTINCT SCM_SITE_ID + ITEM_ID 
								FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
								WHERE   PLAN_ID = @V_PLAN_ID
								)

			GROUP BY C.SCM_SITE_ID, A.PARENT_ITEM_ID, a.FLOW_ID
				   , A.CHILD_ITEM_ID, BC.OPERATION_GROUP  
                    , A.CNT, A.R_NUM
            ------------------------------------------------------------------------
            -- 2. 법인 BOM : Cell
            ------------------------------------------------------------------------
            UNION
            SELECT DISTINCT S.SCM_SITE_ID AS PLANT_SITE_ID
                          , A.MODEL_ID AS PARENT_ITEM_ID
                          , CASE WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID <> A.CHILD_ITEM_ID THEN 'CHAR'
            			         WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID  = A.CHILD_ITEM_ID THEN 'ASY_AGING'
            			    END AS  STAGE
            			  , A.CHILD_ITEM_ID
            			  , CASE WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID <> A.CHILD_ITEM_ID THEN 'ASY_AGING'
            			         WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID  = A.CHILD_ITEM_ID THEN 'ASSY'
            			    END AS CHILD_STAGE
            			  , CASE WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID <> A.CHILD_ITEM_ID THEN 'ASY_AGING'
            			         WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID  = A.CHILD_ITEM_ID THEN 'ASSY'
            			    END AS MATERIAL_CLASS_ID
                          , A.ACCUMULATED_CHILD_QTY AS CHILD_QTY   
            --SELECT A.*, B.ATTRIBUTE8, B.OPERATION_GROUP
            FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH(NOLOCK)
            
            LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                            --, * 
                        FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                        WHERE  DIVISION_ID = @V_DIVISION_ID
                        AND    OPERATION_GROUP IN ('A')  -- Cell BOM
                       ) B
            ON    A.MODEL_ID    = B.ITEM_ID
            AND   A.DIVISION_ID = B.DIVISION_ID 
                ------------------------------------------------------------------------
                INNER JOIN (SELECT * FROM SCM_MST_SITE S WITH(NOLOCK) 
                			WHERE  1=1
                			AND    S.DIVISION_ID     = @V_DIVISION_ID
                			AND    S.SITE_TYPE       = 'PLANT'
                			AND    S.OPERATION_GROUP IN ('A', 'P')
                			AND    S.OSP_YN         <> 'Y'
                			AND    S.VALID_YN        = 'Y'
                           ) S
                ON    A.DIVISION_ID     = S.DIVISION_ID
                AND   A.PLANT_ID        = S.PLANT_ID 
                AND   B.OPERATION_GROUP = S.OPERATION_GROUP 
                ------------------------------------------------------------------------
            WHERE 1=1
            AND A.DIVISION_ID = @V_DIVISION_ID
            AND A.OPERATION_GROUP_ID IN ('A')
            AND (
                  (B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1') -- CELL CP -> CELL CA  /  CELL CA -> CELL CA
                )
            AND A.EFF_END_DATE >= @D_PLAN_NAME
            /************************* 
            대상 프로젝트 ITEM 필터링 
            *************************/
			AND (S.SCM_SITE_ID + A.MODEL_ID)
							IN (SELECT DISTINCT SCM_SITE_ID + ITEM_ID 
								FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
								WHERE   PLAN_ID = @V_PLAN_ID
								)
			
            ------------------------------------------------------------------------
            -- 3. OSP BOM : PACK
            ------------------------------------------------------------------------
            UNION
            SELECT DISTINCT OSP.PLANT_SITE_ID AS PLANT_SITE_ID
                          , A.MODEL_ID AS PARENT_ITEM_ID
                          , 'PACK' AS  STAGE -- 외주는 PACK 단일 STAGE 로 정의
            			  , A.CHILD_ITEM_ID
            			  , 'CHAR' AS CHILD_STAGE
                          , 'CHAR' AS MATERIAL_CLASS_ID
            			  , A.ACCUMULATED_CHILD_QTY AS CHILD_QTY   
            FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH(NOLOCK)
            
            LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                            --, * 
                        FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                        WHERE  DIVISION_ID = @V_DIVISION_ID
                        AND    OPERATION_GROUP IN ('P')  
                       ) B
            ON    A.MODEL_ID    = B.ITEM_ID
            AND   A.DIVISION_ID = B.DIVISION_ID 
                ------------------------------------------------------------------------
                INNER JOIN (SELECT DISTINCT SP.DIVISION_ID, SP.ITEM_ID, SP.PLANT_SITE_ID, S.LOGISTIC_PLANT_ID
                            FROM   SCM_MST_SITE_ITEM_PRIORITY SP WITH (NOLOCK) 
                			INNER JOIN SCM_MST_SITE S WITH (NOLOCK) 
                			ON  SP.DIVISION_ID    = S.DIVISION_ID
                			AND SP.PLANT_SITE_ID  = S.SCM_SITE_ID
                			AND S.SITE_TYPE       = 'PLANT'
                			AND S.OPERATION_GROUP = 'P'
                			AND S.OSP_YN          = 'Y'
                			AND S.VALID_YN        = 'Y'
                            AND SP.DIVISION_ID    = @V_DIVISION_ID
                            AND SP.VALID_YN       = 'Y'  
                            AND SP.TO_YYYYMMDD   >= @P_PLAN_NAME  
                           ) OSP
                ON    A.MODEL_ID    = OSP.ITEM_ID
                AND   A.DIVISION_ID = OSP.DIVISION_ID 
                --AND   A.PLANT_ID    = OSP.LOGISTIC_PLANT_ID 
                ------------------------------------------------------------------------
            WHERE 1=1
            AND A.DIVISION_ID = @V_DIVISION_ID
            --AND @V_DIVISION_ID <> '40' -- 2026-03-10, 소형제외 블럭 -- 소형은 CELL Demand 만 처리하므로 Pack BOM 필요 없음
            AND A.OPERATION_GROUP_ID IN ('A')
            AND (B.OPERATION_GROUP = 'P' AND A.CELL_TYPE = 'CP') -- PACK -> CELL CP
            AND A.EFF_END_DATE >= @D_PLAN_NAME
            /************************* 
            대상 프로젝트 ITEM 필터링 
            *************************/
			AND (OSP.PLANT_SITE_ID + A.MODEL_ID)
							IN (SELECT DISTINCT SCM_SITE_ID + ITEM_ID 
								FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
								WHERE   PLAN_ID = @V_PLAN_ID
								)

            ) A
        ------------------------------------------------------------------------
        --본테이블 INSERT
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_BOM_SN( PLAN_ID
                                    ,BOM_ID
                                    ,OP_SEQ
                                    ,MATERIAL_CLASS_ID
                                    ,MATERIAL_BUFFER_ID
                                    ,PRIORITY
                                    ,CONSUME_QUANTITY
                                    ,ATTRIBUTE1
                                    ,ATTRIBUTE2
                                    ,ATTRIBUTE3
                                    ,ATTRIBUTE14
                                    ,ATTRIBUTE15
                                   )
        SELECT PLAN_ID
              ,BOM_ID
              ,OP_SEQ
              ,MATERIAL_CLASS_ID
              ,MATERIAL_BUFFER_ID
              ,PRIORITY
              ,CONSUME_QUANTITY
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE14
              ,ATTRIBUTE15
        FROM @BOM_TEMP
        ------------------------------------------------------------------------
        -- 4. 2nd OCV BOM 추가
        -- 2025.06.12 Philsu Park: Material Class 만들 때, PACK, MDLE 두종류가 있을 수 있어 Att2 값으로 반영.
        ------------------------------------------------------------------------
        UNION ALL
        SELECT  @V_PLAN_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3 AS BOM_ID
               ,0                                               AS OP_SEQ
            --    ,'MDLE'                                          AS MATERIAL_CLASS_ID
               ,LU.ATTRIBUTE2                                   AS MATERIAL_CLASS_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE2 AS MATERIAL_BUFFER_ID
               ,1                                               AS PRIORITY
               ,1                                               AS CONSUME_QUANTITY
               ,LU.SEGMENT4                                     AS ATTRIBUTE1
               ,LU.SEGMENT5                                     AS ATTRIBUTE2
               ,LU.ATTRIBUTE3                                   AS ATTRIBUTE3
               ,LU.SEGMENT5                                     AS ATTRIBUTE14
               ,LU.ATTRIBUTE2                                   AS ATTRIBUTE15
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     VALID_YN    = 'Y'
        AND     SEGMENT2    = @V_DIVISION_ID
        AND     SEGMENT3    = @V_GROUP_ID
        GROUP BY LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3,LU.ATTRIBUTE2
        ------------------------------------------------------------------------
        -- 5. 대치 BOM 추가
        ------------------------------------------------------------------------
        UNION ALL
        SELECT  @V_PLAN_ID  AS PLAN_ID
               ,ATTRIBUTE1  AS BOM_ID
               ,ATTRIBUTE2  AS OP_SEQ
               ,ATTRIBUTE3  AS MATERIAL_CLASS_ID
               ,ATTRIBUTE4  AS MATERIAL_BUFFER_ID
               ,ATTRIBUTE5  AS PRIORITY
               ,ATTRIBUTE6  AS CONSUME_QUANTITY
               ,ATTRIBUTE7  AS SCM_SITE_ID
               ,ATTRIBUTE8  AS ITEM_ID
               ,ATTRIBUTE9  AS STAGE
               ,ATTRIBUTE10 AS C_ITEM_ID
               ,ATTRIBUTE11 AS C_STAGE
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   1=1
        AND     LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_ALTERNATE_BOM'
        AND     VALID_YN    = 'Y'
        AND     SEGMENT2    = @V_DIVISION_ID
        AND     SEGMENT3    = @V_GROUP_ID

        OPTION(RECOMPILE)
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

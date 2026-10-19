
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_AFTER_CORRECT]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.07.07 Philsu Park: Initial Release
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_AFTER_CORRECT';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(6);
    DECLARE @FROZEN_CARRY_OVER_DATE NVARCHAR(100)


    --LINE 별 FULL LOADING 제약을 위한 임시테이블
    DECLARE @FL_EC_TEMP TABLE(
      PLAN_ID        NVARCHAR(100)
    , RESOURCE_ID    NVARCHAR(100)
    , STAGE          NVARCHAR(50)
    , TYPE           NVARCHAR(50)
    , START_DATE     NVARCHAR(8)
    , DAILY_VALUE    NVARCHAR(50)
    , CALENDAR_LEVEL NVARCHAR(10)
    , SCM_SITE_ID    NVARCHAR(50)
    , LINE_ID        NVARCHAR(50)
    )

    --호기 별 FULL LOADING 제약을 위한 임시테이블
    DECLARE @FL_EC_EQ_TEMP TABLE(
      PLAN_ID        NVARCHAR(100)
    , RESOURCE_ID    NVARCHAR(100)
    , STAGE          NVARCHAR(50)
    , TYPE           NVARCHAR(50)
    , START_DATE     NVARCHAR(8)
    , DAILY_VALUE    NVARCHAR(50)
    , CALENDAR_LEVEL NVARCHAR(10)
    , SCM_SITE_ID    NVARCHAR(50)
    , LINE_ID        NVARCHAR(50)
    , ORI_LINE_ID    NVARCHAR(50)
    )
    --호기 별 FULL LOADING 제약을 위한 임시테이블
    DECLARE @FL_EC_EQ_TEMP2 TABLE(
      PLAN_ID        NVARCHAR(100)
    , RESOURCE_ID    NVARCHAR(100)
    , STAGE          NVARCHAR(50)
    , TYPE           NVARCHAR(50)
    , START_DATE     NVARCHAR(8)
    , DAILY_VALUE    NVARCHAR(50)
    , CALENDAR_LEVEL NVARCHAR(10)
    , SCM_SITE_ID    NVARCHAR(50)
    , LINE_ID        NVARCHAR(50)
    , ORI_LINE_ID    NVARCHAR(50)
    , FULL_DAYS      NVARCHAR(8)
    )


    --호기별 FULL LOADING 비조업 확인을 위한 임시테이블
    DECLARE @NO_WORK_TEMP TABLE(
      START_DATE     NVARCHAR(8)
    , STAGE          NVARCHAR(50)
    )

    -- 2025.11.07 Minyong Lee : 단일모델 제약 시 FROZENCARRYOVERSETUPGROUPNAME 통일을 위한 임시테이블
    DECLARE @SETUPGROUPNAME TABLE(
        ATTRIBUTE4        NVARCHAR(50)
      , FROZENCARRYOVERSETUPGROUPNAME    NVARCHAR(100)
    )

    --------------------------------------------------
    --GM 재고 Rolling을 위한 변수 선언
    --------------------------------------------------
    --MATERIAL 재고 ROLLING을 위한 임시테이블
    DECLARE @M_INV_RL_TEMP TABLE(
     SCM_SITE_ID    NVARCHAR(100)
    ,M_ITEM_ID      NVARCHAR(100)
    ,BASE_DATE      NVARCHAR(100)
    ,EFFECTIVE_DATE NVARCHAR(100)
    ,M_INV_QTY      NUMERIC(20,10)
    )
    DECLARE @V_ROLLING_YN NVARCHAR(1)

    -- 생산 실적 UI와 동일한 기준으로 맞춤
    DECLARE @FP_RELEASE_PLAN_TEMP TABLE (
     PLANT_ID           NVARCHAR(100)
    ,ITEM_ID            NVARCHAR(100)
    ,LINE_ID            NVARCHAR(100)
    ,PLAN_DATE          DATETIME
    ,PLAN_IN_QTY        NUMERIC(20,10)
    )

    -- HORIZEN CALENDAR Infeasible 방지를 위한 변수 설정
    DECLARE @V_HORIZEN_ZERO_YN NVARCHAR(1) 
    DECLARE @V_MONTHLYOFF_YN   NVARCHAR(1) 
    DECLARE @MONTHLY_OFF_TEMP TABLE(
                                   DATE NVARCHAR(8)
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
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
        SELECT @V_PLAN_START_YYYYMM = LEFT(PLAN_START_DATE,6)
              ,@V_PLAN_END_YYYYMM   = LEFT(PLAN_END_DATE,6)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @V_PLAN_ID

        --FROZEN의 MAX일자를 FROZENCARRYOVERDATE로 지정
        SELECT  @FROZEN_CARRY_OVER_DATE = MAX(FROZEN_END_DATE) + ':000000'
        FROM    SCP_OPT_ENG_FROZEN_MASTER_SN WITH(NOLOCK)
        WHERE   PLAN_ID = @V_PLAN_ID
        AND     FROZEN_TYPE = 'PROD'
        --FROZEN의 MAX일자가 PSD보다 작거나 없으면 PSD로 변경
        SELECT  @FROZEN_CARRY_OVER_DATE = IIF(ISNULL(@FROZEN_CARRY_OVER_DATE,@V_PLAN_START_YYYYMMDD) <= @V_PLAN_START_YYYYMMDD,@V_PLAN_START_YYYYMMDD,@FROZEN_CARRY_OVER_DATE) + ':000000'
        ------------------------------------------------------------------------
        -- Data UPDATE
        --2025.05.27 Philsu Park: FROZENCARRYOVERDATE 값이 Fix를 보지 않게 제외.
        --2025.09.18 THKIM : EQ도 LINE과 동일한 기준으로 UPDATE 하기 위해 수정
        ------------------------------------------------------------------------
        --UPDATE SCP_OPT_ENG_RESOURCE_SN
        --SET SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERDATE           = A.FROZENCARRYOVERDATE
        --   ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPGROUPNAME = A.FROZENCARRYOVERSETUPGROUPNAME
        --   ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPITEMNAME  = A.FROZENCARRYOVERSETUPITEMNAME
        --FROM(
        --    SELECT	 SFP2.PLAN_ID                 AS PLAN_ID
        --    		,SFP2.RESOURCE_ID	          AS RESOURCE_ID
        --    		--,SFP2.EFFECTIVE_DATE+':000000' AS FROZENCARRYOVERDATE
        --            ,CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE,SFP2.EFFECTIVE_DATE)),112)+':000000' AS FROZENCARRYOVERDATE
        --    		,SFP2.ATTRIBUTE1              AS SITE_ID
        --    		,'LINE'				          AS RESOURCE_TYPE
        --    		,LU.SETUP_GROUP_ID	          AS FROZENCARRYOVERSETUPGROUPNAME
        --    		,LU.SETUP_ID		          AS FROZENCARRYOVERSETUPITEMNAME
        --    		,SFP2.ATTRIBUTE3	          AS GROUP_SETUP_CONTROL_CODE
        --    		,SFP2.ATTRIBUTE3	          AS ITEM_SETUP_CONTROL_CODE
        --    FROM	(SELECT ROW_NUMBER() OVER ( PARTITION BY PLAN_ID, RESOURCE_ID ORDER BY EFFECTIVE_DATE DESC, ATTRIBUTE2 DESC) AS ROWNUM
        --    			  ,SFP.* 	
        --    		 FROM   SCP_OPT_ENG_FROZEN_PLAN_SN SFP WITH(NOLOCK) 
        --    		 WHERE  PLAN_ID = @V_PLAN_ID 
        --             AND    SFP.ATTRIBUTE13 != 'LOOKUP_PROD_FIX' --2025.05.27 Philsu Park: FROZENCARRYOVERDATE 값이 Fix를 보지 않게 제외.
        --    		) SFP2
        --    		LEFT OUTER JOIN (
        --    				SELECT  LU.SEGMENT2    AS DIVISION_ID
        --    					   ,LU.SEGMENT3    AS SCM_SITE_ID
        --    					   ,LU.SEGMENT4    AS LINE_ID
        --    					   ,ITS.ITEM_ID    AS ITEM_ID
        --    					   ,LU.ATTRIBUTE1  AS SETUP_GROUP_ID
        --    					   ,IIF(LU.ATTRIBUTE2='',NULL,LU.ATTRIBUTE2) AS SETUP_ID
        --    					   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE3)*86400)  AS GROUP_SETUP_TIME
        --    					   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE4)*86400)  AS SETUP_TIME
        --    				FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --    				LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
        --    				ON      ITS.SITE_ID = LU.SEGMENT3
        --    				--AND     ITS.STAGE      = 'ASSY'
        --    				AND     ITS.STAGE      IN ('ASSY', 'MDLE', 'PACK', 'EOL', 'STK' )
        --    				AND     ITS.SETUP_GROUP_ID = LU.SEGMENT5
        --    				WHERE   LU.SEGMENT2    = @V_DIVISION_ID
        --    				AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP'
        --    				AND     ITS.PLAN_ID    = @V_PLAN_ID
        --                    AND     LU.VALID_YN    = 'Y'
        --    			)LU 
        --    			ON  SFP2.ATTRIBUTE1 = LU.SCM_SITE_ID
        --    			AND SFP2.ATTRIBUTE2 = LU.ITEM_ID
        --    			--AND SFP2.ATTRIBUTE3 = 'ASSY'
        --    			AND SFP2.ATTRIBUTE3 IN ('ASSY', 'MDLE', 'PACK', 'EOL', 'STK' )
        --    			AND SFP2.ATTRIBUTE14+'@'+ATTRIBUTE3 = LU.LINE_ID
        --    WHERE 1=1
        --    AND   SFP2.ROWNUM = 1
        --    ) A
        --WHERE   SCP_OPT_ENG_RESOURCE_SN.PLAN_ID       = @V_PLAN_ID
        --AND     SCP_OPT_ENG_RESOURCE_SN.RESOURCE_TYPE = 'LINE'
        --AND     SCP_OPT_ENG_RESOURCE_SN.RESOURCE_ID   = A.RESOURCE_ID

        UPDATE SCP_OPT_ENG_RESOURCE_SN 
        SET SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERDATE           = A.FROZENCARRYOVERDATE
           ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPGROUPNAME = A.FROZENCARRYOVERSETUPGROUPNAME
           ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPITEMNAME  = A.FROZENCARRYOVERSETUPITEMNAME
        FROM(
            SELECT	 SFP2.PLAN_ID                 AS PLAN_ID
            		,SFP2.RESOURCE_ID	          AS RESOURCE_ID
            		--,SFP2.EFFECTIVE_DATE+':000000' AS FROZENCARRYOVERDATE
                    ,CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE,SFP2.EFFECTIVE_DATE)),112)+':000000' AS FROZENCARRYOVERDATE
            		,SFP2.ATTRIBUTE1              AS SITE_ID
                    ,SFP2.ATTRIBUTE14             AS LINE_ID
                    ,SFP2.ATTRIBUTE4              AS STAGE_BUFFER
            		,'LINE'				          AS RESOURCE_TYPE
            		,LU.SETUP_GROUP_ID	          AS FROZENCARRYOVERSETUPGROUPNAME
            		,LU.SETUP_ID		          AS FROZENCARRYOVERSETUPITEMNAME
            		,SFP2.ATTRIBUTE3	          AS GROUP_SETUP_CONTROL_CODE
            		,SFP2.ATTRIBUTE3	          AS ITEM_SETUP_CONTROL_CODE
            FROM	(SELECT ROW_NUMBER() OVER ( PARTITION BY PLAN_ID, RESOURCE_ID ORDER BY EFFECTIVE_DATE DESC, ATTRIBUTE2 DESC) AS ROWNUM
            			  ,SFP.* 	
            		 FROM   SCP_OPT_ENG_FROZEN_PLAN_SN SFP WITH(NOLOCK) 
            		 WHERE  PLAN_ID = @V_PLAN_ID 
                     AND    SFP.ATTRIBUTE13 != 'LOOKUP_PROD_FIX' --2025.05.27 Philsu Park: FROZENCARRYOVERDATE 값이 Fix를 보지 않게 제외.
            		) SFP2
            		LEFT OUTER JOIN (
            				SELECT  LU.SEGMENT2    AS DIVISION_ID
            					   ,LU.SEGMENT3    AS SCM_SITE_ID
            					   ,LU.SEGMENT4    AS LINE_ID
            					   ,ITS.ITEM_ID    AS ITEM_ID
            					   ,LU.ATTRIBUTE1  AS SETUP_GROUP_ID
            					   ,IIF(LU.ATTRIBUTE2='',NULL,LU.ATTRIBUTE2) AS SETUP_ID
            					   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE3)*86400)  AS GROUP_SETUP_TIME
            					   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE4)*86400)  AS SETUP_TIME
            				FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            				LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            				ON      ITS.SITE_ID = LU.SEGMENT3
            				AND     ITS.STAGE      IN ('ASSY', 'MDLE', 'PACK', 'EOL', 'STK' )
            				AND     ITS.SETUP_GROUP_ID = LU.SEGMENT5
            				WHERE   LU.SEGMENT2    = @V_DIVISION_ID
            				AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP'
            				AND     ITS.PLAN_ID    = @V_PLAN_ID
                            AND     LU.VALID_YN    = 'Y'
            			)LU 
            			ON  SFP2.ATTRIBUTE1 = LU.SCM_SITE_ID
            			AND SFP2.ATTRIBUTE2 = LU.ITEM_ID
            			AND SFP2.ATTRIBUTE3 IN ('ASSY', 'MDLE', 'PACK', 'EOL', 'STK' )
            			AND SFP2.ATTRIBUTE14+'@'+ATTRIBUTE3 = LU.LINE_ID
            WHERE 1=1
            AND   SFP2.ROWNUM = 1
            ) A
        WHERE   SCP_OPT_ENG_RESOURCE_SN.PLAN_ID       = @V_PLAN_ID
        AND     SCP_OPT_ENG_RESOURCE_SN.RESOURCE_TYPE IN('LINE','EQ')
        AND     SCP_OPT_ENG_RESOURCE_SN.ATTRIBUTE1        = A.SITE_ID
        AND     IIF(SCP_OPT_ENG_RESOURCE_SN.RESOURCE_TYPE = 'LINE',SCP_OPT_ENG_RESOURCE_SN.ATTRIBUTE15,SCP_OPT_ENG_RESOURCE_SN.ATTRIBUTE14) = A.LINE_ID
        AND     SCP_OPT_ENG_RESOURCE_SN.ATTRIBUTE4        = A.STAGE_BUFFER

        ------------------------------------------------------------------------
        --20250915/THKIM : GM은 FROZEN이 없는 경우에 실적 기준으로 FROZENCARRYOVER UPDATE
        -- 2025.09.17 Philsu Park: Stage 조건 추가해서 실제 공정별 ITEM 찾아오게 수정.
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_RESOURCE_SN
        SET SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERDATE           = A.FROZENCARRYOVERDATE
           ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPGROUPNAME = A.FROZENCARRYOVERSETUPGROUPNAME
           ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPITEMNAME  = A.FROZENCARRYOVERSETUPITEMNAME
        FROM(
            SELECT  CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE,PR.PLAN_DATE)),112)+':000000' AS FROZENCARRYOVERDATE
                   ,LU.SETUP_GROUP_ID	                                                         AS FROZENCARRYOVERSETUPGROUPNAME
                   ,LU.SETUP_ID		                                                             AS FROZENCARRYOVERSETUPITEMNAME
                   ,PR.RESOURCE_ID                                                               AS RESOURCE_ID
            FROM(
                SELECT PR.PLANT_ID
                      ,PR.ITEM_ID
                      ,PR.LINE_ID
                      ,PR.PLAN_DATE
                      ,RS.SCM_SITE_ID
                      ,RS.STAGE
                      ,RS.STAGE_BUFFER
                      ,RS.RESOURCE_ID
                      ,ROW_NUMBER() OVER ( PARTITION BY RESOURCE_ID ORDER BY PR.PLAN_DATE DESC, PR.ITEM_ID DESC) AS ROWNUM
                FROM   SCM_DAILY_PRODUCT_RESULT_H_SN PR WITH(NOLOCK)
                    INNER JOIN (
                                SELECT RE.ATTRIBUTE1  AS SCM_SITE_ID
                                      ,RE.ATTRIBUTE3  AS STAGE
                                      ,RE.ATTRIBUTE4  AS STAGE_BUFFER
                                      ,ISNULL(RE.ATTRIBUTE14,RE.ATTRIBUTE15) AS LINE_ID
                                      ,RE.RESOURCE_ID AS RESOURCE_ID
                                      ,OP.OPERATION_ID
                                FROM SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                                INNER JOIN (SELECT	 SEGMENT1 AS DIVISION_ID
                                                    ,SEGMENT2 AS PLAN_GROUP
                                                    ,SEGMENT3 AS STAGE
                                                    ,SEGMENT5 AS OPERATION_ID
                                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                            WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
                                            AND     SEGMENT1    = @V_DIVISION_ID
                                            AND     SEGMENT2    = @V_GROUP_ID
                                            AND     VALID_YN    = 'Y') OP
                                    ON  OP.STAGE = RE.ATTRIBUTE3
                                WHERE RE.PLAN_ID = @V_PLAN_ID
                                AND   RE.ATTRIBUTE15 IS NOT NULL
                                GROUP BY RE.ATTRIBUTE1, RE.ATTRIBUTE3, RE.ATTRIBUTE4, RE.ATTRIBUTE14, RE.ATTRIBUTE15, RE.RESOURCE_ID, OP.OPERATION_ID
                                ) RS
                        ON  PR.LINE_ID      = RS.LINE_ID
                        AND PR.OPERATION_ID = RS.OPERATION_ID
                WHERE PR.PLAN_DATE   < @V_PLAN_START_YYYYMMDD
                AND   PLAN_DATE   >= DATEADD(MONTH,-2,@V_PLAN_START_YYYYMMDD)
			    AND   PR.DIVISION_ID = @V_DIVISION_ID 
                -- AND   PR.OPERATION_ID = 'A9000' -- 질문
                AND   PR.ACTUAL_GOOD_QTY > 0  -- 실적은 ACTUAL_GOOD_QTY
                GROUP BY PR.PLANT_ID,PR.ITEM_ID,PR.LINE_ID,PR.PLAN_DATE,RS.SCM_SITE_ID,RS.STAGE,RS.STAGE_BUFFER, RS.RESOURCE_ID
                ) PR
                LEFT OUTER JOIN (
                            	SELECT  LU.SEGMENT2    AS DIVISION_ID
                            		   ,LU.SEGMENT3    AS SCM_SITE_ID
                            		   ,LU.SEGMENT4    AS LINE_ID
                            		   ,ITS.ITEM_ID    AS ITEM_ID
                            		   ,LU.ATTRIBUTE1  AS SETUP_GROUP_ID
                            		   ,IIF(LU.ATTRIBUTE2='',NULL,LU.ATTRIBUTE2) AS SETUP_ID
                            		   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE3)*86400)  AS GROUP_SETUP_TIME
                            		   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE4)*86400)  AS SETUP_TIME
                            	FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                            	LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
                            	ON      ITS.SITE_ID = LU.SEGMENT3
                            	AND     ITS.STAGE      IN ('ASSY', 'MDLE', 'PACK', 'EOL', 'STK' )
                            	AND     ITS.SETUP_GROUP_ID = LU.SEGMENT5
                            	WHERE   LU.SEGMENT2    = @V_DIVISION_ID
                            	AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP'
                            	AND     ITS.PLAN_ID    = @V_PLAN_ID
                                AND     LU.VALID_YN    = 'Y'
                               )LU 
            			ON  PR.SCM_SITE_ID = LU.SCM_SITE_ID
            			AND PR.ITEM_ID = LU.ITEM_ID
            			AND PR.STAGE IN ('ASSY', 'MDLE', 'PACK', 'EOL', 'STK' )
            			AND PR.LINE_ID =LEFT(LU.LINE_ID,CHARINDEX('@',LU.LINE_ID)-1) 
            WHERE PR.ROWNUM = 1
            ) A
            WHERE   SCP_OPT_ENG_RESOURCE_SN.PLAN_ID       = @V_PLAN_ID
            AND     SCP_OPT_ENG_RESOURCE_SN.RESOURCE_TYPE IN('LINE','EQ')
            AND     SCP_OPT_ENG_RESOURCE_SN.RESOURCE_ID    = A.RESOURCE_ID
            AND     SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERDATE IS NULL

        ------------------------------------------------------------------------
        --20250918/THKIM : FROZEN CARRY OVER DATE 일괄 UPDATE(LINE,EQ,MODEL)
        ------------------------------------------------------------------------
        UPDATE  SCP_OPT_ENG_RESOURCE_SN 
        SET     FROZENCARRYOVERDATE = @FROZEN_CARRY_OVER_DATE
        WHERE   PLAN_ID = @V_PLAN_ID
        AND     RESOURCE_TYPE IN('LINE','EQ','MODEL')

        ------------------------------------------------------------------------
        -- 2025.11.07 Minyong Lee : 단일모델 제약을 고려한 FROZENCARRYOVERSETUPGROUPNAME 통일
        ------------------------------------------------------------------------
        INSERT INTO @SETUPGROUPNAME
        SELECT ATTRIBUTE4
             , MAX(A.FROZENCARRYOVERSETUPGROUPNAME) AS FROZENCARRYOVERSETUPGROUPNAME
        FROM   SCP_OPT_ENG_RESOURCE_SN A WITH(NOLOCK)
        WHERE  PLAN_ID = @V_PLAN_ID
        AND    RESOURCE_TYPE IN('LINE')
        GROUP BY STAGE, ATTRIBUTE4

        UPDATE  A
        SET     A.FROZENCARRYOVERSETUPGROUPNAME = SG.FROZENCARRYOVERSETUPGROUPNAME
        FROM    SCP_OPT_ENG_RESOURCE_SN A
            INNER JOIN @SETUPGROUPNAME SG
                ON A.ATTRIBUTE4 = SG.ATTRIBUTE4
        WHERE   A.PLAN_ID = @V_PLAN_ID
        AND     A.RESOURCE_TYPE IN ('LINE', 'EQ')

        UPDATE  A
        SET     A.FROZENCARRYOVERSETUPGROUPNAME = SG.FROZENCARRYOVERSETUPGROUPNAME
        FROM    SCP_OPT_ENG_RESOURCE_SN A
            INNER JOIN @SETUPGROUPNAME SG
                ON A.RESOURCE_NAME = SG.ATTRIBUTE4
        WHERE   A.PLAN_ID = @V_PLAN_ID
        AND     A.RESOURCE_TYPE IN ('MODEL')

        ------------------------------------------------------------------------
        --BOD 중 TO_BUFFER나 FROM_BUFFER가 ITEM_SITE에 없는 데이터는 삭제
        ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_BOD_SN 
        FROM SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)
            INNER JOIN (
                        SELECT PLAN_ID
                              ,BOD_ID
                        FROM(
                            SELECT A.PLAN_ID
                                  ,A.BOD_ID
                            FROM SCP_OPT_ENG_BOD_SN A WITH(NOLOCK)
                                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN B WITH(NOLOCK)
                                ON  A.PLAN_ID = B.PLAN_ID 
                                AND A.TO_BUFFER_ID = B.BUFFER_ID
                            WHERE 1=1
                            AND A.PLAN_ID = @V_PLAN_ID
                            AND B.PLAN_ID IS NULL
                            UNION ALL
                            SELECT A.PLAN_ID
                                  ,A.BOD_ID
                            FROM SCP_OPT_ENG_BOD_SN A WITH(NOLOCK)
                                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN B WITH(NOLOCK)
                                ON  A.PLAN_ID = B.PLAN_ID 
                                AND A.FROM_BUFFER_ID = B.BUFFER_ID
                            WHERE 1=1
                            AND A.PLAN_ID = @V_PLAN_ID
                            AND B.PLAN_ID IS NULL
                            ) A
                        GROUP BY A.PLAN_ID, A.BOD_ID
                    ) DEL
        ON  BOD.PLAN_ID = DEL.PLAN_ID
        AND BOD.BOD_ID  = DEL.BOD_ID
        WHERE BOD.PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- SCHEDULED_MOVE에 bod가 없으면 삭제
        -- BOD가 없는 SCHEDULED MOVE가 있어도 엔진이 돌아가는지 검증을 위해 주석처리
        ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN 
		FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN     a   with(nolock)		
		    left join SCP_OPT_ENG_BOD_SN b with(nolock)
		    on  a.plan_id = b.plan_id
		    and a.FROM_BUFFER_ID = b.FROM_BUFFER_ID
		    and a.TO_BUFFER_ID = b.TO_BUFFER_ID
		    and a.TRANSPORT_MODE = b.TRANSPORT_MODE
		WHERE a.PLAN_ID = @V_PLAN_ID
		and  b.BOD_ID IS NULL
        ------------------------------------------------------------------------
        -- LOAD PER UPDATE -> LOAD PER * YIELD
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_ROUTING_RESOURCE_SN
        SET SCP_OPT_ENG_ROUTING_RESOURCE_SN.LOAD_PER = SCP_OPT_ENG_ROUTING_RESOURCE_SN.LOAD_PER*SCP_OPT_ENG_ROUTING_SN.YIELD
        FROM SCP_OPT_ENG_ROUTING_RESOURCE_SN
            LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN 
            ON  SCP_OPT_ENG_ROUTING_RESOURCE_SN.PLAN_ID    = SCP_OPT_ENG_ROUTING_SN.PLAN_ID
            AND SCP_OPT_ENG_ROUTING_RESOURCE_SN.ROUTING_ID = SCP_OPT_ENG_ROUTING_SN.ROUTING_ID
            AND SCP_OPT_ENG_ROUTING_RESOURCE_SN.OP_SEQ	   = SCP_OPT_ENG_ROUTING_SN.OP_SEQ
        WHERE SCP_OPT_ENG_ROUTING_RESOURCE_SN.PLAN_ID = @V_PLAN_ID
        AND SCP_OPT_ENG_ROUTING_RESOURCE_SN.RESOURCE_CLASS_ID IN('LINE','MODEL','EQ')

        ------------------------------------------------------------------------
        -- FROZEN PLAN QUANTITY -> QUANTITY * YIELD
        -- 2026.07.09 Minyong Lee : [E20260708-001247] 최적화_YIELD 감안 Frozen 수량 보정 로직 오류 수정 요청
        ------------------------------------------------------------------------
        UPDATE A
        SET A.QUANTITY  = A.QUANTITY / ISNULL(B.YIELD,1)
        FROM SCP_OPT_ENG_FROZEN_PLAN_SN A
            INNER JOIN SCP_OPT_ENG_ROUTING_SN B
                ON  A.PLAN_ID       = B.PLAN_ID
                AND A.ROUTING_BOM_MAPPING_ID = 'RB' + B.ROUTING_ID
        WHERE A.PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- Delete Garbage Demand Data
        ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_DEMAND_SN
        WHERE   PLAN_ID = @V_PLAN_ID
        AND     ATTRIBUTE13 = 'GROUP_DEMAND'

        ------------------------------------------------------------------------
        --MATERIAL CONSTRAINTS
        -- 2025.07.18 Philsu Park: EFF_START 날짜가 END 날짜보다 뒤에 있으면 안됨.
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ITEM_BOM_ROUTING_SN(PLAN_ID,ROUTING_BOM_MAPPING_ID,BUFFER_ID,ROUTING_ID,BOM_ID,EFF_START_DATE,EFF_END_DATE,FROZEN_FENCE,PRIORITY
                                                    ,IN_CONTAINER_CATEGORY,IN_CONTAINER_SIZE,OUT_CONTAINER_CATEGORY,OUT_CONTAINER_SIZE)
        SELECT @V_PLAN_ID AS PLAN_ID
              ,'RB'+SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'+'::-::-' AS ROUTING_BOM_MAPPING_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'               AS BUFFER_ID                                             
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'+'::-::-'      AS ROUTING_ID                                                       
              ,NULL                                                           AS BOM_ID        
              ,LEAST(@V_PLAN_END_YYYYMMDD, EFF_END_DATE)                        AS EFF_START_DATE
              ,@V_PLAN_END_YYYYMMDD                                           AS EFF_END_DATE
              ,NULL                                                           AS FROZEN_FENCE
              ,1                                                              AS PRIORITY
              ,NULL                                                           AS IN_CONTAINER_CATEGORY
              ,NULL                                                           AS IN_CONTAINER_SIZE
              ,NULL                                                           AS OUT_CONTAINER_CATEGORY
              ,NULL                                                           AS OUT_CONTAINER_SIZE
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID AS SCM_SITE_ID
                    ,LU.ITEM_ID AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.TO_YYYYMMDD),112) AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON       LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.ITEM_ID = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('A_DEGAS','B_DEGAS','EOL','INSP')
            AND LU.PLANT_SITE_ID = ITS.SITE_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID       = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      PG.VALID_YN          = 'Y'
            AND      LU.VALID_YN          = 'Y'
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- BLOCKED 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1 AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    --,LU.ATTRIBUTE2 AS EFF_END_DATE
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.ATTRIBUTE3),112) AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.SEGMENT5 = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('A_DEGAS','B_DEGAS','EOL','INSP')
            AND LU.SEGMENT4 = ITS.SITE_ID
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID */
            ) MC
        GROUP BY SCM_SITE_ID, C_ITEM_ID, EFF_END_DATE
        
        INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID,ROUTING_ID,OP_SEQ,LEAD_TIME,YIELD,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3)
        SELECT @V_PLAN_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'+'::-::-' AS ROUTING_ID
              ,0                                                         AS OP_SEQ
              ,0                                                         AS LEAD_TIME
              ,1                                                         AS YIELD
              ,SCM_SITE_ID                                               AS ATTRIBUTE1
              ,C_ITEM_ID                                                 AS ATTRIBUTE2
              ,'MATERIAL_CONST'                                          AS ATTRIBUTE3
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID AS SCM_SITE_ID
                    ,LU.ITEM_ID AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.TO_YYYYMMDD),112) AS EFF_END_DATE
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON       LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID       = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      PG.VALID_YN          = 'Y'
            AND      LU.VALID_YN          = 'Y'
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- BLOCKED 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1   AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    --,LU.ATTRIBUTE2 AS EFF_END_DATE
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.ATTRIBUTE3),112) AS EFF_END_DATE
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID */
        ) MC
        GROUP BY SCM_SITE_ID, C_ITEM_ID

        INSERT INTO SCP_OPT_ENG_BOM_SN (PLAN_ID,BOM_ID,OP_SEQ,MATERIAL_CLASS_ID,MATERIAL_BUFFER_ID,PRIORITY,CONSUME_QUANTITY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15)
        SELECT @V_PLAN_ID                                       AS PLAN_ID
              ,SCM_SITE_ID+'::'+P_ITEM_ID+'::'+STAGE_BUFFER     AS BOM_ID
              ,0                                                AS OP_SEQ
              ,'MATERIAL_CONST'+ROWNUM                          AS MATERIAL_CLASS_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST' AS MATERIAL_BUFFER_ID
              ,1                                                AS PRIORITY
              ,CON_QTY                                          AS CONSUME_QUANTITY
              ,SCM_SITE_ID                                      AS ATTRIBUTE1
              ,P_ITEM_ID                                        AS ATTRIBUTE2
              ,P_STAGE                                          AS ATTRIBUTE3
              ,STAGE_BUFFER                                     AS ATTRIBUTE4
              ,CONCAT('MATERIAL_CONST', RIGHT(STAGE_BUFFER, 2)) AS ATTRIBUTE13
              ,C_ITEM_ID                                        AS ATTRIBUTE14
              ,'MATERIAL_CONST'                                 AS ATTRIBUTE15
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID AS SCM_SITE_ID
                    ,LU.ITEM_ID AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
                    ,LU.TO_YYYYMMDD AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
                    ,ITS.GRADE     AS STAGE_BUFFER
					,CONVERT(NVARCHAR, ROW_NUMBER() OVER ( PARTITION BY LU.ITEM_ID   ORDER BY LU.ITEM_ID  )) AS ROWNUM
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON       LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.ITEM_ID = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('A_DEGAS','B_DEGAS','EOL','INSP')
            AND LU.PLANT_SITE_ID = ITS.SITE_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID       = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      LU.VALID_YN          = 'Y'
            AND      PG.VALID_YN          = 'Y'
            GROUP BY LU.PLANT_SITE_ID ,LU.ITEM_ID ,LU.ITEM_ID_CHILD,LU.TO_EXPC_QTY,LU.TO_YYYYMMDD,ITS.STAGE, ITS.GRADE
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- BLOCKED 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1 AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    ,LU.ATTRIBUTE3 AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
                    ,ITS.GRADE     AS STAGE_BUFFER
					,CONVERT(NVARCHAR, ROW_NUMBER() OVER ( PARTITION BY LU.SEGMENT5   ORDER BY LU.SEGMENT5  )) AS ROWNUM
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.SEGMENT5 = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('A_DEGAS','B_DEGAS','EOL','INSP')
            AND LU.SEGMENT4 = ITS.SITE_ID
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID
            GROUP BY LU.SEGMENT4  ,LU.SEGMENT5  ,LU.ATTRIBUTE1,LU.ATTRIBUTE2,LU.ATTRIBUTE3,ITS.STAGE, ITS.GRADE */
            ) MC
        
        INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN (PLAN_ID,BUFFER_ID,SITE_ID,ITEM_ID,GRADE,SITE_TYPE,ITEM_CLASS_ID,INCH,FAB,STAGE,IS_INFINITE,IS_PURCHASED,PURCHASE_PERIOD
                                             ,IS_NO_CARRY,STORAGE_ID,STORAGE_PER,SETUP_ID,SETUP_GROUP_ID,ITEM_GROUP_ID,ATTRIBUTE3)
        SELECT @V_PLAN_ID                                       AS PLAN_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST' AS BUFFER_ID
              ,SCM_SITE_ID                                      AS SITE_ID
              ,C_ITEM_ID                                        AS ITEM_ID
              ,'MATERIAL_CONST'                                 AS GRADE
              ,NULL                                             AS SITE_TYPE
              ,'MATERIAL'                                       AS ITEM_CLASS_ID
              ,NULL                                             AS INCH
              ,NULL                                             AS FAB
              ,'M0'                                             AS STAGE
              ,NULL                                             AS IS_INFINITE
              ,NULL                                             AS IS_PURCHASED
              ,NULL                                             AS PURCHASE_PERIOD
              ,NULL                                             AS IS_NO_CARRY
              ,NULL                                             AS STORAGE_ID
              ,NULL                                             AS STORAGE_PER
              ,NULL                                             AS SETUP_ID
              ,NULL                                             AS SETUP_GROUP_ID
              ,NULL                                             AS ITEM_GROUP_ID
              ,'MATERIAL'                                       AS ATTRIBUTE3
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID AS SCM_SITE_ID
                    ,LU.ITEM_ID AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
                    ,LU.TO_YYYYMMDD AS EFF_END_DATE
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON       LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID       = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      PG.VALID_YN          = 'Y'
            AND      LU.VALID_YN          = 'Y'
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- END 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1 AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    ,LU.ATTRIBUTE3 AS EFF_END_DATE
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID */
            ) MC
        GROUP BY SCM_SITE_ID, C_ITEM_ID
        ------------------------------------------------------------------------
        --MATERIAL CONSTRAINTS - BOM UPDATE IN ITEM_BOM_ROUTING
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_ITEM_BOM_ROUTING_SN 
        SET SCP_OPT_ENG_ITEM_BOM_ROUTING_SN.BOM_ID = PM.BOM_ID
        FROM SCP_OPT_ENG_ITEM_BOM_ROUTING_SN IBR WITH(NOLOCK)
            INNER JOIN (
                        -- START 2025.11.19 jongykim2: Schelduled Reciept Information
                        SELECT  BOM.PLAN_ID
                               ,BOM.BOM_ID
                        FROM    SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
                                INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                    ON   LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                INNER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                        		    ON   BOM.PLAN_ID            = @V_PLAN_ID
                        		    AND  BOM.MATERIAL_CLASS_ID  = 'MATERIAL_CONST'
                        		    AND  LU.ITEM_ID	            = BOM.ATTRIBUTE2
                                    AND  LU.PLANT_SITE_ID       = BOM.ATTRIBUTE1
                        WHERE   1 = 1
                        AND     LU.DIVISION_ID       = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                        AND     PG.VALID_YN          = 'Y'
                        AND     LU.VALID_YN          = 'Y'
                        -- END 2025.11.19 jongykim2: Schelduled Reciept Information
                        /* -- BLOCKED 2025.11.19 jongykim2
                        SELECT  BOM.PLAN_ID
                               ,BOM.BOM_ID
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                INNER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                        		    ON   BOM.PLAN_ID			= @V_PLAN_ID
                        		    AND  BOM.MATERIAL_CLASS_ID  = 'MATERIAL_CONST'
                        		    AND  LU.SEGMENT5			= BOM.ATTRIBUTE2
                                    AND  LU.SEGMENT4            = BOM.ATTRIBUTE1
                        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
                        AND     LU.VALID_YN    = 'Y'
                        AND     LU.SEGMENT2    = @V_DIVISION_ID
                        AND     LU.SEGMENT3    = @V_GROUP_ID */
                        ) PM
                ON  IBR.PLAN_ID   = PM.PLAN_ID
                AND IBR.BUFFER_ID = PM.BOM_ID
                AND IBR.BOM_ID IS NULL
                AND IBR.PLAN_ID   = @V_PLAN_ID
        ;
        ------------------------------------------------------------------------
        -- FIX 반영할 때 FIX의 수량*완성TACK(단위 : 초) 만큼 EVERY_CALENDAR에 반영
        -- AFTER에서 ROUTING_RESOURCE의 LOAD PER 값을 수정하기 때문에 AFTER에서 진행
        -- 2025.07.17 Philsu Park: 81_UC에 맞게 Join 조건 변경.
        -- 2025.09.12 Philsu Park: Fix Item에 해당하는 Load_Per 값을 사용하게 수정.
        ------------------------------------------------------------------------
        WITH PROD_FIX AS (
            SELECT  CONCAT(LK.SEGMENT5, '::', LK.ATTRIBUTE1)      AS RESOURCE_ID
                    , CASE WHEN LK.SEGMENT4 = 'F6000' THEN 'EOL'
                           WHEN LK.SEGMENT4 = 'A9000' THEN 'ASSY'
                           WHEN LK.SEGMENT4 = 'A8000' THEN 'STK'
                           END    AS STAGE
                    -- ,LK.ATTRIBUTE2                   AS ITEM_ID
                    ,LK.ATTRIBUTE3                   AS START_DATE
                    ,CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, LK.ATTRIBUTE3, 112)), 112) AS END_DATE
                    ,SUM(CONVERT(NUMERIC(20,10),LK.ATTRIBUTE4)*RS.LOAD_PER) AS FIXED_VAL
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RS WITH(NOLOCK)
                ON  RS.PLAN_ID      = @V_PLAN_ID
                AND RS.RESOURCE_ID  = CONCAT(LK.SEGMENT5, '::', LK.ATTRIBUTE1)
                AND RS.ATTRIBUTE2   = LK.ATTRIBUTE2
                AND RS.START_DATE  <= LK.ATTRIBUTE3
                AND RS.END_DATE    >= CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, LK.ATTRIBUTE3, 112)), 112)
            WHERE   LK.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
            AND     LK.SEGMENT2    = @V_DIVISION_ID
            AND     LK.SEGMENT3    = @V_GROUP_ID
            AND     LK.VALID_YN    = 'Y'
            GROUP BY LK.SEGMENT5, LK.ATTRIBUTE1, LK.ATTRIBUTE3
                    , CASE WHEN LK.SEGMENT4 = 'F6000' THEN 'EOL'
                           WHEN LK.SEGMENT4 = 'A9000' THEN 'ASSY'
                           WHEN LK.SEGMENT4 = 'A8000' THEN 'STK'
                           END  --, LK.ATTRIBUTE2
        )
        UPDATE  EC
        SET      EC.DAILY_VALUE = CEILING(IIF(FIX.FIXED_VAL>86400,86400,FIX.FIXED_VAL))
                ,EC.UPDATE_ID   = EC.UPDATE_ID + '_AFTER'
                ,EC.UPDATE_TIME = GETDATE()
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN EC
        INNER JOIN PROD_FIX FIX
            ON  EC.RESOURCE_ID  = FIX.RESOURCE_ID
            AND EC.ATTRIBUTE3   = FIX.STAGE
            AND EC.START_DATE   = FIX.START_DATE
        WHERE   1=1
        AND     EC.PLAN_ID          = @V_PLAN_ID
        AND     EC.CALENDAR_LEVEL   = 'L6'
        ;
        ------------------------------------------------------------------------
        UPDATE  SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN
        SET     SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN.DAILY_VALUE = CEILING(IIF(FIX.FIX_QTY*RS.LOAD_PER>86400,86400,FIX.FIX_QTY*RS.LOAD_PER))
               ,SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN.UPDATE_ID   = EC.UPDATE_ID + '_AFTER'
               ,SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN.UPDATE_TIME = GETDATE()
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN EC WITH(NOLOCK) 
            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RS WITH(NOLOCK)
                ON  EC.PLAN_ID = RS.PLAN_ID
                AND EC.RESOURCE_ID = RS.RESOURCE_ID
                AND EC.START_DATE >= RS.START_DATE
                AND EC.END_DATE   <= RS.END_DATE
            INNER JOIN (
                        SELECT  CASE WHEN SEGMENT4 = 'F6000' THEN 'EOL'
                                     WHEN SEGMENT4 = 'A9000' THEN 'ASSY'
                                     WHEN SEGMENT4 = 'A8000' THEN 'STK'
                                     END    AS STAGE
                                ,SEGMENT5   AS SITE_ID
                                ,ATTRIBUTE1 AS LINE_ID
                                ,ATTRIBUTE2 AS ITEM_ID
                               ,ATTRIBUTE3                   AS FIX_DATE
                               ,SUM(CONVERT(INT,ATTRIBUTE4)) AS FIX_QTY
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID
                        AND     VALID_YN    = 'Y'
                        GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
                       ) FIX
                ON  FIX.SITE_ID     = EC.ATTRIBUTE1
                AND FIX.ITEM_ID     = EC.ATTRIBUTE2
                AND FIX.STAGE       = EC.ATTRIBUTE3
                AND FIX.LINE_ID     = EC.ATTRIBUTE15
                AND EC.START_DATE   = FIX.FIX_DATE
                
        WHERE   1=1
        AND     EC.PLAN_ID= @V_PLAN_ID
        AND     EC.CALENDAR_LEVEL = 'L6'
        ;


        ------------------------------------------------------------------------
        -- LINE FULL LOADING 조치 전에 미리 비조업을 담아둠 -> 호기 별  FULL LOADING에서 사용
        ------------------------------------------------------------------------
        INSERT INTO @NO_WORK_TEMP
        SELECT  CAL.BASIS_YYYYMMDD
               ,RE.STAGE
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN REC WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK) 
                ON  REC.PLAN_ID = RE.PLAN_ID
                AND REC.RESOURCE_ID = RE.RESOURCE_ID
            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON  BASIS_YYYYMMDD >= REC.START_DATE
                AND BASIS_YYYYMMDD <  REC.END_DATE
        WHERE   REC.PLAN_ID        = @V_PLAN_ID
        AND     REC.TYPE           = 'upper_limit'
        AND     REC.CALENDAR_LEVEL = 'L5'
        --AND     REC.DAILY_VALUE    = 0
		AND     CONVERT(NUMERIC(20,3),REC.DAILY_VALUE)    = 0
        GROUP BY CAL.BASIS_YYYYMMDD, RE.STAGE
        ------------------------------------------------------------------------
        -- LINE FULL LOADING
        -- 2025-07-29 THK : EVERY CALENDAR 조정 및 HORIZEN_CALENDAR, FROZEN PLAN INSERT
        ------------------------------------------------------------------------

        INSERT INTO @FL_EC_TEMP    
        SELECT  EC.PLAN_ID         AS PLAN_ID
               ,EC.RESOURCE_ID     AS RESOURCE_ID
               ,RS.STAGE           AS STAGE
               ,EC.TYPE            AS TYPE
               ,CAL.BASIS_YYYYMMDD AS START_DATE
               ,EC.DAILY_VALUE     AS DAILY_VALUE
               ,EC.CALENDAR_LEVEL  AS CALENDAR_LEVEL
               ,EC.ATTRIBUTE1      AS SCM_SITE_ID
               ,EC.ATTRIBUTE15     AS LINE_ID
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN EC WITH(NOLOCK) 
            INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                ON  EC.PLAN_ID = RS.PLAN_ID
                AND EC.RESOURCE_ID = RS.RESOURCE_ID
            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON  CAL.BASIS_YYYYMMDD >= EC.START_DATE
                AND CAL.BASIS_YYYYMMDD <  EC.END_DATE
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND RS.SITE_ID     = LU.SEGMENT3
                AND RS.STAGE       = LU.SEGMENT4
                AND LU.VALID_YN    = 'Y'
        WHERE   EC.PLAN_ID = @V_PLAN_ID
        ORDER BY CAL.BASIS_YYYYMMDD, TYPE, EC.ATTRIBUTE15
        
        --UPPER 기준 MAX LEVEL의 값을 가져와서 L7 UPPER 추가
        INSERT INTO @FL_EC_TEMP
        SELECT MEC.PLAN_ID     AS PLAN_ID
              ,MEC.RESOURCE_ID AS RESOURCE_ID
              ,MEC.STAGE       AS STAGE
              ,MEC.TYPE        AS TYPE
              ,MEC.START_DATE  AS START_DATE
              ,VEC.DAILY_VALUE AS DAILY_VALUE
              ,'L7'            AS CALENDAR_LEVEL
              ,MEC.SCM_SITE_ID AS SCM_SITE_ID
              ,MEC.LINE_ID     AS LINE_ID
        FROM(
             SELECT PLAN_ID
                   ,RESOURCE_ID
                   ,STAGE
                   ,TYPE
                   ,START_DATE
                   ,MAX(CALENDAR_LEVEL) AS MAX_CALENDAR_LEVEL
                   ,SCM_SITE_ID
                   ,LINE_ID
             FROM @FL_EC_TEMP
             WHERE TYPE = 'upper_limit'
             GROUP BY PLAN_ID, RESOURCE_ID, STAGE, TYPE, START_DATE, SCM_SITE_ID, LINE_ID
             ) MEC
            INNER JOIN @FL_EC_TEMP VEC
                ON  MEC.PLAN_ID            = VEC.PLAN_ID
                AND MEC.RESOURCE_ID        = VEC.RESOURCE_ID
                AND MEC.STAGE              = VEC.STAGE
                AND MEC.TYPE               = VEC.TYPE
                AND MEC.START_DATE         = VEC.START_DATE
                AND MEC.MAX_CALENDAR_LEVEL = VEC.CALENDAR_LEVEL
                AND MEC.SCM_SITE_ID        = VEC.SCM_SITE_ID
                AND MEC.LINE_ID            = VEC.LINE_ID
        
        --L7의 UPPER에 LOOKUP MARGIN 값을 곱해서 lower_limit L7 생성
        INSERT INTO @FL_EC_TEMP
        SELECT EC.PLAN_ID
              ,EC.RESOURCE_ID
              ,EC.STAGE
              ,'lower_limit'
              ,EC.START_DATE
              ,CONVERT(NUMERIC(20,3),EC.DAILY_VALUE)*CONVERT(NUMERIC(20,3),LU.ATTRIBUTE1)/100 AS DAILY_VALUE
              ,EC.CALENDAR_LEVEL
              ,EC.SCM_SITE_ID
              ,EC.LINE_ID
        FROM   @FL_EC_TEMP EC
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND EC.SCM_SITE_ID = LU.SEGMENT3
                AND EC.STAGE       = LU.SEGMENT4
                AND LU.VALID_YN    = 'Y'
        WHERE  CALENDAR_LEVEL = 'L7'


        --FROZEN구간과 FIX가 포함되어있는 날짜에 대해서는 L9,lower_limit 0으로 생성
        INSERT INTO @FL_EC_TEMP
        SELECT REC.PLAN_ID         AS PLAN_ID
              ,REC.RESOURCE_ID     AS RESOURCE_ID
              ,RE.STAGE            AS STAGE
              ,'lower_limit'       AS TYPE
              ,CAL.BASIS_YYYYMMDD  AS START_DATE
              ,'0'                 AS DAILY_VALUE
              ,'L9'                AS CALENDAR_LEVEL
              ,REC.ATTRIBUTE1      AS SCM_SITE_ID
              ,REC.ATTRIBUTE15     AS LINE_ID
        FROM SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN REC WITH(NOLOCK) 
            INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK) 
                ON  REC.PLAN_ID = RE.PLAN_ID
                AND REC.RESOURCE_ID = RE.RESOURCE_ID
            INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                ON  REC.PLAN_ID = FM.PLAN_ID
                AND RE.STAGE    = FM.STAGE
                AND FM.FROZEN_TYPE = 'PROD'
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND RE.SITE_ID     = LU.SEGMENT3
                AND RE.STAGE       = LU.SEGMENT4
                AND LU.VALID_YN    = 'Y'
            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON  CAL.BASIS_YYYYMMDD >= FM.FROZEN_START_DATE 
                AND CAL.BASIS_YYYYMMDD < FM.FROZEN_END_DATE 
                AND CAL.BASIS_YYYYMMDD >= REC.START_DATE
                AND CAL.BASIS_YYYYMMDD <  REC.END_DATE
        WHERE   REC.PLAN_ID = @V_PLAN_ID
        AND     RE.RESOURCE_TYPE = 'LINE'
        AND     REC.TYPE = 'lower_limit'
        GROUP BY REC.PLAN_ID, REC.RESOURCE_ID, RE.STAGE , REC.TYPE, CAL.BASIS_YYYYMMDD, REC.ATTRIBUTE1, REC.ATTRIBUTE15
        UNION ALL
        SELECT REC.PLAN_ID         AS PLAN_ID
              ,REC.RESOURCE_ID     AS RESOURCE_ID
              ,RE.STAGE            AS STAGE
              ,'lower_limit'       AS TYPE
              ,CAL.BASIS_YYYYMMDD  AS START_DATE
              ,'0'                 AS DAILY_VALUE
              ,'L9'                AS CALENDAR_LEVEL
              ,REC.ATTRIBUTE1      AS SCM_SITE_ID
              ,REC.ATTRIBUTE15     AS LINE_ID
        FROM SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN REC WITH(NOLOCK) 
            INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK) 
                ON  REC.PLAN_ID = RE.PLAN_ID
                AND REC.RESOURCE_ID = RE.RESOURCE_ID
            INNER JOIN (
                        SELECT  CASE WHEN SEGMENT4 = 'F6000' THEN 'EOL'
                                     WHEN SEGMENT4 = 'A9000' THEN 'ASSY'
                                     WHEN SEGMENT4 = 'A8000' THEN 'STK'
                                     END    AS STAGE
                                ,SEGMENT5   AS SITE_ID
                                ,ATTRIBUTE1 AS LINE_ID
                               ,ATTRIBUTE3                   AS FIX_DATE
                               ,SUM(CONVERT(INT,ATTRIBUTE4)) AS FIX_QTY
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID
                        AND     VALID_YN    = 'Y'
                        GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE1, ATTRIBUTE3
                       ) FIX
                ON  FIX.SITE_ID     = RE.ATTRIBUTE1
                AND FIX.STAGE       = RE.ATTRIBUTE3
                AND FIX.LINE_ID     = RE.ATTRIBUTE15
                AND REC.START_DATE  = FIX.FIX_DATE
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND RE.SITE_ID     = LU.SEGMENT3
                AND RE.STAGE       = LU.SEGMENT4
                AND LU.VALID_YN    = 'Y'
            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON  CAL.BASIS_YYYYMMDD =  FIX.FIX_DATE
                AND CAL.BASIS_YYYYMMDD >= REC.START_DATE
                AND CAL.BASIS_YYYYMMDD <  REC.END_DATE
        WHERE   REC.PLAN_ID = @V_PLAN_ID
        AND     RE.RESOURCE_TYPE = 'LINE'
        AND     REC.TYPE = 'lower_limit'
        GROUP BY REC.PLAN_ID, REC.RESOURCE_ID, RE.STAGE , REC.TYPE, CAL.BASIS_YYYYMMDD, REC.ATTRIBUTE1, REC.ATTRIBUTE15

        
        -- FROZEN구간을 제외하고 값이 0인 날짜는 HORIZEN CALENDAR로 이동
        INSERT INTO SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN(PLAN_ID
                                                            ,RESOURCE_ID
                                                            ,TYPE
                                                            ,START_DATE
                                                            ,END_DATE
                                                            ,VALUE
                                                            ,ATTRIBUTE15
                                                            )
        SELECT REC.PLAN_ID 
              ,REC.RESOURCE_ID
              ,REC.TYPE       
              ,REC.START_DATE
              ,REC.END_DATE
              ,REC.DAILY_VALUE
              ,REC.ATTRIBUTE15
        FROM(
            SELECT PLAN_ID         AS PLAN_ID    
                  ,RESOURCE_ID     AS RESOURCE_ID
                  ,STAGE           AS STAGE
                  ,TYPE            AS TYPE       
                  ,MIN(START_DATE) AS START_DATE
                  --,MAX(START_DATE) AS END_DATE
		    	  ,CONVERT(VARCHAR(8),DATEADD(DAY, 1, MAX(START_DATE)), 112) AS END_DATE
                  ,DAILY_VALUE     AS DAILY_VALUE
                  ,'FULL_LOADING'  AS ATTRIBUTE15
            FROM(
                SELECT PLAN_ID
                      ,RESOURCE_ID
                      ,STAGE
                      ,TYPE
                      ,START_DATE
                      ,DAILY_VALUE
                      ,DATEADD(DAY, - RN,START_DATE) AS GRP
                FROM(
                    SELECT PLAN_ID
                          ,RESOURCE_ID
                          ,STAGE
                          ,TYPE
                          ,START_DATE
                          ,DAILY_VALUE
                          ,ROW_NUMBER() OVER(PARTITION BY RESOURCE_ID, TYPE ORDER BY START_DATE) AS RN
                    FROM   @FL_EC_TEMP 
                    WHERE  CALENDAR_LEVEL = 'L7'
                    AND    TYPE           = 'upper_limit'
                    AND    CONVERT(NUMERIC(20,3),DAILY_VALUE)   = 0
                    ) FEC
                ) GEC
            GROUP BY PLAN_ID, RESOURCE_ID, TYPE, DAILY_VALUE, GRP, STAGE
            ) REC
            INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                ON  REC.PLAN_ID    = FM.PLAN_ID
                AND REC.STAGE      = FM.STAGE
                AND FM.FROZEN_TYPE = 'PROD'
        WHERE REC.START_DATE >= FM.FROZEN_END_DATE
        
         --FROZEN구간을 제외하고 값이 0인 날짜에 FROZEN PLAN을 86400/LOAD_PER -> 100을 넣어줌
        INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(PLAN_ID
                                              ,FROZEN_ID
                                              ,ROUTING_BOM_MAPPING_ID
                                              ,OP_SEQ
                                              ,RESOURCE_ID
                                              ,QUANTITY
                                              ,EFFECTIVE_DATE
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
        )
        SELECT  FE.PLAN_ID                         AS PLAN_ID
               ,FE.RESOURCE_ID+'::'+FE.START_DATE  AS FROZEN_ID
               ,'RB'+FE.SCM_SITE_ID+'::IDLE::IDLE' AS ROUTING_BOM_MAPPING_ID
               ,0                                  AS OP_SEQ
               ,FE.RESOURCE_ID                     AS RESOURCE_ID
               ,86400/RR.LOAD_PER                  AS QUANTITY
               ,FE.START_DATE                      AS EFFECTIVE_DATE
               ,FE.SCM_SITE_ID                     AS ATTRIBUTE1
               ,'IDLE'                             AS ATTRIBUTE2
               ,'IDLE'                             AS ATTRIBUTE3
        FROM    @FL_EC_TEMP FE
            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RR WITH(NOLOCK)
                ON  FE.PLAN_ID = RR.PLAN_ID
                AND FE.SCM_SITE_ID+'::IDLE::IDLE' = RR.ROUTING_ID
                AND FE.RESOURCE_ID = RR.RESOURCE_ID
            INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                ON  FE.PLAN_ID     = FM.PLAN_ID
                AND FE.STAGE       = FM.STAGE
                AND FM.FROZEN_TYPE = 'PROD'
        WHERE   1=1
        -- AND     FE.CALENDAR_LEVEL = 'L7'
        AND     FE.CALENDAR_LEVEL = 'L5'
        AND     CONVERT(NUMERIC(20,3),FE.DAILY_VALUE)    = 0
        AND     FE.TYPE           = 'upper_limit'
        AND     FE.START_DATE >= FM.FROZEN_END_DATE
        
        --L7 값이 0인 데이터는 삭제
        DELETE FROM @FL_EC_TEMP
        FROM    @FL_EC_TEMP FE
            INNER JOIN(
                      SELECT  RESOURCE_ID
                             ,START_DATE
                      FROM    @FL_EC_TEMP FE
                      WHERE   CALENDAR_LEVEL = 'L7'
                      AND     CONVERT(NUMERIC(20,3),DAILY_VALUE) = 0
                      GROUP BY RESOURCE_ID, START_DATE
                      ) DEL
                ON  FE.RESOURCE_ID = DEL.RESOURCE_ID
                AND FE.START_DATE  = DEL.START_DATE
        WHERE FE.CALENDAR_LEVEL != 'L9'
        
        --기존 데이터 삭제하고 다시 INSERT 
        DELETE FROM SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN EC WITH(NOLOCK) 
            INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                ON  EC.PLAN_ID = RS.PLAN_ID
                AND EC.RESOURCE_ID = RS.RESOURCE_ID
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND RS.SITE_ID     = LU.SEGMENT3
                AND RS.STAGE       = LU.SEGMENT4
                AND LU.VALID_YN    = 'Y'
        WHERE EC.PLAN_ID = @V_PLAN_ID
        
        INSERT INTO SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN(PLAN_ID
                                                          ,RESOURCE_ID
                                                          ,TYPE
                                                          ,START_DATE
                                                          ,END_DATE
                                                          ,CALENDAR_LEVEL
                                                          ,DAILY_VALUE
                                                          ,ATTRIBUTE1
                                                          ,ATTRIBUTE14
                                                          ,ATTRIBUTE15
                                                          )
        SELECT PLAN_ID         AS PLAN_ID
              ,RESOURCE_ID     AS RESOURCE_ID
              ,TYPE            AS TYPE
              ,MIN(START_DATE) AS START_DATE
              --,MAX(START_DATE) AS END_DATE
			  ,CONVERT(VARCHAR(8),DATEADD(DAY, 1, MAX(START_DATE)), 112) AS END_DATE
              ,CALENDAR_LEVEL  AS CALENDAR_LEVEL
              ,DAILY_VALUE     AS DAILY_VALUE
              ,SCM_SITE_ID     AS ATTRIBUTE1
              ,'FULL_LOADING'  AS ATTRIBUTE14
              ,LINE_ID         AS ATTRIBUTE15
        FROM(
            SELECT PLAN_ID
                  ,RESOURCE_ID
                  ,TYPE
                  ,START_DATE
                  ,CALENDAR_LEVEL
                  ,DAILY_VALUE
                  ,SCM_SITE_ID
                  ,LINE_ID
                  ,DATEADD(DAY,-RN,START_DATE) AS GRP
            FROM(
                SELECT PLAN_ID
                      ,RESOURCE_ID
                      ,TYPE
                      ,START_DATE
                      ,CALENDAR_LEVEL
                      ,DAILY_VALUE
                      ,SCM_SITE_ID
                      ,LINE_ID
                      ,ROW_NUMBER() OVER(PARTITION BY RESOURCE_ID,TYPE,CALENDAR_LEVEL ORDER BY RESOURCE_ID,TYPE,CALENDAR_LEVEL,START_DATE) AS RN
                FROM @FL_EC_TEMP
                ) REC
            ) GEC
        GROUP BY PLAN_ID, RESOURCE_ID, TYPE, CALENDAR_LEVEL, DAILY_VALUE, GRP, SCM_SITE_ID, LINE_ID


        ------------------------------------------------------------------------
        -- EQUIPMENT FULL LOADING
        -- 2025-08-06 THK : EVERY CALENDAR 및 FROZEN PLAN INSERT
        ------------------------------------------------------------------------
     --   -- 호기 별 임시 테이블에 날짜를 펼쳐서 데이터를 담아둔다 -> L0
     --   INSERT INTO @FL_EC_EQ_TEMP
     --   SELECT  EC.PLAN_ID
     --          ,EC.RESOURCE_ID
     --          ,RS.STAGE
     --          ,EC.TYPE
     --          ,CAL.BASIS_YYYYMMDD AS START_DATE
     --          ,EC.DAILY_VALUE
     --          ,EC.CALANDER_LEVEL
     --          ,EC.ATTRIBUTE1
     --          ,EC.ATTRIBUTE15
     --          ,EC.ORI_LINE_ID
     --   FROM(
     --       SELECT @V_PLAN_ID                                                   AS PLAN_ID
     --             ,RR.SITE_ID+'::'+RR.LINE_ID+'_'+LU.EQ_QTY+'@'+RR.BUFFER_STAGE AS RESOURCE_ID
     --             ,'upper_limit'                                                AS TYPE
     --             ,@V_PLAN_START_YYYYMMDD                                       AS START_DATE
     --             ,@V_PLAN_END_YYYYMMDD                                         AS END_DATE
     --             ,86400                                                        AS DAILY_VALUE
     --             ,'L0'                                                         AS CALANDER_LEVEL
     --             ,RR.SITE_ID                                                   AS ATTRIBUTE1
     --             ,RR.LINE_ID+'_'+LU.EQ_QTY                                     AS ATTRIBUTE15
     --             ,RR.LINE_ID                                                   AS ORI_LINE_ID
     --       FROM(
     --           SELECT  ATTRIBUTE1  AS SITE_ID
     --                  ,ATTRIBUTE15 AS LINE_ID
     --                  ,ATTRIBUTE3  AS STAGE
     --                  ,ATTRIBUTE4  AS BUFFER_STAGE
     --           FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
     --           WHERE   PLAN_ID= @V_PLAN_ID
     --           AND     RESOURCE_CLASS_ID = 'LINE'
     --           GROUP BY ATTRIBUTE1, ATTRIBUTE15, ATTRIBUTE3, ATTRIBUTE4
     --           ) RR
     --           INNER JOIN(                                                                                    
     --                     SELECT LU.SEGMENT1   AS DIVISION_ID                                                  
     --                           ,LU.SEGMENT2   AS GROUP_ID
     --                           ,LU.SEGMENT3   AS SITE_ID
     --                           ,LU.SEGMENT4   AS STAGE
     --                           ,CONVERT(NVARCHAR(100),NUM.NUM) AS EQ_QTY
     --                           ,LU.ATTRIBUTE2 AS MARGIN
     --                     FROM(
     --                         SELECT  TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NUM
     --                         FROM    sys.objects
     --                         ) NUM
     --                       INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
     --                           ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
     --                           AND LU.VALID_YN = 'Y'
     --                           AND NUM.NUM <= LU.ATTRIBUTE1
     --                           AND LU.SEGMENT1    = @V_DIVISION_ID
     --                           AND LU.SEGMENT2    = @V_GROUP_ID
     --                    ) LU
     --               ON  RR.SITE_ID = LU.SITE_ID
     --               AND RR.STAGE   = LU.STAGE
     --       UNION ALL
     --       SELECT @V_PLAN_ID                                                   AS PLAN_ID
     --             ,RR.SITE_ID+'::'+RR.LINE_ID+'_'+LU.EQ_QTY+'@'+RR.BUFFER_STAGE AS RESOURCE_ID
     --             ,'lower_limit'                                                AS TYPE
     --             ,@V_PLAN_START_YYYYMMDD                                       AS START_DATE
     --             ,@V_PLAN_END_YYYYMMDD                                         AS END_DATE
     --             ,86400                                                        AS DAILY_VALUE
     --             ,'L0'                                                         AS CALANDER_LEVEL
     --             ,RR.SITE_ID                                                   AS ATTRIBUTE1
     --             ,RR.LINE_ID+'_'+LU.EQ_QTY                                     AS ATTRIBUTE15
     --             ,RR.LINE_ID                                                   AS ORI_LINE_ID
     --       FROM(
     --           SELECT  ATTRIBUTE1  AS SITE_ID
     --                  ,ATTRIBUTE15 AS LINE_ID
     --                  ,ATTRIBUTE3  AS STAGE
     --                  ,ATTRIBUTE4  AS BUFFER_STAGE
     --           FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
     --           WHERE   PLAN_ID= @V_PLAN_ID
     --           AND     RESOURCE_CLASS_ID = 'LINE'
     --           GROUP BY ATTRIBUTE1, ATTRIBUTE15, ATTRIBUTE3, ATTRIBUTE4
     --           ) RR
     --           INNER JOIN(                                                                                    
     --                     SELECT LU.SEGMENT1   AS DIVISION_ID                                                  
     --                           ,LU.SEGMENT2   AS GROUP_ID
     --                           ,LU.SEGMENT3   AS SITE_ID
     --                           ,LU.SEGMENT4   AS STAGE
     --                           ,CONVERT(NVARCHAR(100),NUM.NUM) AS EQ_QTY
     --                           ,LU.ATTRIBUTE2 AS MARGIN
     --                     FROM(
     --                         SELECT  TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NUM
     --                         FROM    sys.objects
     --                         ) NUM
     --                       INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
     --                           ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
     --                           AND LU.VALID_YN = 'Y'
     --                           AND NUM.NUM <= LU.ATTRIBUTE1
     --                           AND LU.SEGMENT1    = @V_DIVISION_ID
     --                           AND LU.SEGMENT2    = @V_GROUP_ID
     --                    ) LU
     --               ON  RR.SITE_ID = LU.SITE_ID
     --               AND RR.STAGE   = LU.STAGE
     --       )EC
     --       INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
     --           ON  EC.PLAN_ID = RS.PLAN_ID
     --           AND EC.RESOURCE_ID = RS.RESOURCE_ID
     --       INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
     --           ON  CAL.BASIS_YYYYMMDD >= EC.START_DATE
     --           AND CAL.BASIS_YYYYMMDD <  EC.END_DATE


     --   -- FROZEN과 FIX 날짜에 L9으로 설정
     --   INSERT INTO @FL_EC_EQ_TEMP
     --   ---- FROZEN 구간에 대해 L9으로 lower_limit 생성
     --   SELECT FEE.PLAN_ID         AS PLAN_ID
     --         ,FEE.RESOURCE_ID     AS RESOURCE_ID
     --         ,FEE.STAGE           AS STAGE
     --         ,'lower_limit'       AS TYPE
     --         ,FEE.START_DATE      AS START_DATE
     --         ,'0'                 AS DAILY_VALUE
     --         ,'L9'                AS CALENDAR_LEVEL
     --         ,FEE.SCM_SITE_ID     AS SCM_SITE_ID
     --         ,FEE.LINE_ID         AS LINE_ID
     --         ,FEE.ORI_LINE_ID     AS ORI_LINE_ID
     --   FROM @FL_EC_EQ_TEMP FEE
     --       INNER JOIN (
     --                   SELECT  FM.STAGE           AS STAGE
     --                          ,CAL.BASIS_YYYYMMDD AS START_DATE
     --                   FROM    SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
     --                       INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
     --                           ON  FM.PLAN_ID = @V_PLAN_ID
     --                           AND FM.FROZEN_TYPE = 'PROD'
     --                           AND BASIS_YYYYMMDD >= FM.FROZEN_START_DATE
     --                           AND BASIS_YYYYMMDD < FM.FROZEN_END_DATE
     --                   ) FM
     --       ON  FEE.STAGE      = FM.STAGE
     --       AND FEE.START_DATE = FM.START_DATE 
     --       AND FEE.TYPE       = 'lower_limit'
     --   UNION ALL
     --   -- FIX 구간에 대해 L9으로 lower_limit 생성
     --   SELECT FEE.PLAN_ID         AS PLAN_ID
     --         ,FEE.RESOURCE_ID     AS RESOURCE_ID
     --         ,FEE.STAGE           AS STAGE
     --         ,'lower_limit'       AS TYPE
     --         ,FEE.START_DATE      AS START_DATE
     --         ,'0'                 AS DAILY_VALUE
     --         ,'L9'                AS CALENDAR_LEVEL
     --         ,FEE.SCM_SITE_ID     AS SCM_SITE_ID
     --         ,FEE.LINE_ID         AS LINE_ID
     --         ,FEE.ORI_LINE_ID     AS ORI_LINE_ID
     --   FROM @FL_EC_EQ_TEMP FEE
     --       INNER JOIN (
     --                   SELECT  CASE WHEN SEGMENT4 = 'F6000' THEN 'EOL'
     --                                WHEN SEGMENT4 = 'A9000' THEN 'ASSY'
     --                                WHEN SEGMENT4 = 'A8000' THEN 'STK'
     --                                END    AS STAGE
     --                           ,SEGMENT5   AS SITE_ID
     --                           ,ATTRIBUTE1 AS LINE_ID
     --                          ,ATTRIBUTE3                   AS FIX_DATE
     --                          ,SUM(CONVERT(INT,ATTRIBUTE4)) AS FIX_QTY
     --                   FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
     --                   WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
     --                   AND     SEGMENT2    = @V_DIVISION_ID
     --                   AND     SEGMENT3    = @V_GROUP_ID
     --                   AND     VALID_YN    = 'Y'
     --                   GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE1, ATTRIBUTE3
     --                  ) FIX
     --           ON  FIX.SITE_ID     = FEE.SCM_SITE_ID
     --           AND FIX.STAGE       = FEE.STAGE
     --           AND FIX.LINE_ID     = FEE.ORI_LINE_ID
     --           AND FIX.FIX_DATE    = FEE.START_DATE

     --   --FROZEN 구간보다 이후 날짜 구간에 대해서는 비조업 날짜에 FROZEN에  86400/LOAD_PER -> 100을 넣어줌
     --   INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(PLAN_ID
     --                                         ,FROZEN_ID
     --                                         ,ROUTING_BOM_MAPPING_ID
     --                                         ,OP_SEQ
     --                                         ,RESOURCE_ID
     --                                         ,QUANTITY
     --                                         ,EFFECTIVE_DATE
     --                                         ,ATTRIBUTE1
     --                                         ,ATTRIBUTE2
     --                                         ,ATTRIBUTE3
     --   )
     --   SELECT  FEE.PLAN_ID                               AS PLAN_ID
     --          ,FEE.RESOURCE_ID+'::'+FEE.START_DATE       AS FROZEN_ID
     --          ,'RB'+FEE.SCM_SITE_ID+'::IDLE_EQ::IDLE_EQ' AS ROUTING_BOM_MAPPING_ID
     --          ,0                                         AS OP_SEQ
     --          ,FEE.RESOURCE_ID                           AS RESOURCE_ID
     --          ,86400/RR.LOAD_PER                         AS QUANTITY
     --          ,FEE.START_DATE                            AS EFFECTIVE_DATE
     --          ,FEE.SCM_SITE_ID                           AS ATTRIBUTE1
     --          ,'IDLE_EQ'                                 AS ATTRIBUTE2
     --          ,'IDLE_EQ'                                 AS ATTRIBUTE3
     --   FROM    @FL_EC_EQ_TEMP FEE
     --       INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RR WITH(NOLOCK)
     --           ON  FEE.PLAN_ID = RR.PLAN_ID
     --           AND FEE.SCM_SITE_ID+'::IDLE_EQ::IDLE_EQ' = RR.ROUTING_ID
     --           AND FEE.RESOURCE_ID = RR.RESOURCE_ID
     --       INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
     --           ON  FEE.PLAN_ID     = FM.PLAN_ID
     --           AND FEE.STAGE       = FM.STAGE 
     --           AND FM.FROZEN_TYPE = 'PROD'
     --       INNER JOIN @NO_WORK_TEMP NW
     --           ON  FEE.STAGE       = NW.STAGE
     --           AND FEE.START_DATE  = NW.START_DATE
     --   WHERE   1=1
     --   AND     FEE.TYPE = 'upper_limit'
     --   AND     FEE.START_DATE >= FM.FROZEN_END_DATE

     --   -- 비조업 날짜는 'L9'을 제외하고 전체 삭제
     --   DELETE  @FL_EC_EQ_TEMP
     --   FROM    @FL_EC_EQ_TEMP FEE
     --       INNER JOIN @NO_WORK_TEMP NW 
     --           ON  FEE.START_DATE = NW.START_DATE
     --           AND FEE.STAGE      = NW.STAGE
     --   WHERE FEE.CALENDAR_LEVEL  != 'L9' 


     --   --날짜별로 다시 합쳐서 INSERT
     --   INSERT INTO SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN(PLAN_ID
     --                                                     ,RESOURCE_ID
     --                                                     ,TYPE
     --                                                     ,START_DATE
     --                                                     ,END_DATE
     --                                                     ,CALENDAR_LEVEL
     --                                                     ,DAILY_VALUE
     --                                                     ,ATTRIBUTE1
     --                                                     ,ATTRIBUTE14
     --                                                     ,ATTRIBUTE15
     --                                                     )
     --   SELECT PLAN_ID         AS PLAN_ID
     --         ,RESOURCE_ID     AS RESOURCE_ID
     --         ,TYPE            AS TYPE
     --         ,MIN(START_DATE) AS START_DATE
     --         --,MAX(START_DATE) AS END_DATE
			  --,CONVERT(VARCHAR(8),DATEADD(DAY, 1, MAX(START_DATE)), 112) AS END_DATE
     --         ,CALENDAR_LEVEL  AS CALENDAR_LEVEL
     --         ,DAILY_VALUE     AS DAILY_VALUE
     --         ,SCM_SITE_ID     AS ATTRIBUTE1
     --         ,'FULL_LOADING'  AS ATTRIBUTE14
     --         ,LINE_ID         AS ATTRIBUTE15
     --   FROM(
     --       SELECT PLAN_ID
     --             ,RESOURCE_ID
     --             ,TYPE
     --             ,START_DATE
     --             ,CALENDAR_LEVEL
     --             ,DAILY_VALUE
     --             ,SCM_SITE_ID
     --             ,LINE_ID
     --             ,DATEADD(DAY,-RN,START_DATE) AS GRP
     --       FROM(
     --           SELECT PLAN_ID
     --                 ,RESOURCE_ID
     --                 ,TYPE
     --                 ,START_DATE
     --                 ,CALENDAR_LEVEL
     --                 ,DAILY_VALUE
     --                 ,SCM_SITE_ID
     --                 ,LINE_ID
     --                 ,ROW_NUMBER() OVER(PARTITION BY RESOURCE_ID,TYPE,CALENDAR_LEVEL,DAILY_VALUE ORDER BY RESOURCE_ID,TYPE,CALENDAR_LEVEL,START_DATE) AS RN
     --           FROM @FL_EC_EQ_TEMP
     --           ) REC
     --       ) GEC
     --   GROUP BY PLAN_ID, RESOURCE_ID, TYPE, CALENDAR_LEVEL, DAILY_VALUE, GRP, SCM_SITE_ID, LINE_ID



        -- 호기 별 임시 테이블에 날짜를 펼쳐서 데이터를 담아둔다 -> L0
        INSERT INTO @FL_EC_EQ_TEMP2
        SELECT  EC.PLAN_ID
               ,EC.RESOURCE_ID
               ,'STK'
               ,EC.TYPE
               ,CAL.BASIS_YYYYMMDD AS START_DATE
               ,EC.DAILY_VALUE
               ,EC.CALANDER_LEVEL
               ,EC.ATTRIBUTE1
               ,EC.ATTRIBUTE15
               ,EC.ORI_LINE_ID
               ,EC.FULL_DAYS
        FROM(
            SELECT @V_PLAN_ID                                                   AS PLAN_ID
                  ,RR.SITE_ID+'::'+RR.LINE_ID+'_'+LU.EQ_QTY+'@'+RR.BUFFER_STAGE AS RESOURCE_ID
                  ,'upper_limit'                                                AS TYPE
                  ,@V_PLAN_START_YYYYMMDD                                       AS START_DATE
                  ,@V_PLAN_END_YYYYMMDD                                         AS END_DATE
                  ,86400                                                        AS DAILY_VALUE
                  ,'L0'                                                         AS CALANDER_LEVEL
                  ,RR.SITE_ID                                                   AS ATTRIBUTE1
                  ,RR.LINE_ID+'_'+LU.EQ_QTY                                     AS ATTRIBUTE15
                  ,RR.LINE_ID                                                   AS ORI_LINE_ID
                  ,FULL_DAYS                                                    AS FULL_DAYS
            FROM(
                SELECT  ATTRIBUTE1  AS SITE_ID
                       ,ATTRIBUTE15 AS LINE_ID
                       ,ATTRIBUTE3  AS STAGE
                       ,ATTRIBUTE4  AS BUFFER_STAGE
                FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
                WHERE   PLAN_ID= @V_PLAN_ID
                AND     RESOURCE_CLASS_ID = 'LINE'
                GROUP BY ATTRIBUTE1, ATTRIBUTE15, ATTRIBUTE3, ATTRIBUTE4
                ) RR
                INNER JOIN(                                                                                    
                          SELECT LU.SEGMENT1   AS DIVISION_ID                                                  
                                ,LU.SEGMENT2   AS GROUP_ID
                                ,LU.SEGMENT3   AS SITE_ID
                                ,LU.SEGMENT4   AS STAGE
                                ,CONVERT(NVARCHAR(100),NUM.NUM) AS EQ_QTY
                                ,LU.ATTRIBUTE2 AS MARGIN
                                ,LU.ATTRIBUTE3 AS FULL_DAYS
                          FROM(
                              SELECT  TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NUM
                              FROM    sys.objects
                              ) NUM
                            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
                                AND LU.VALID_YN = 'Y'
                                AND NUM.NUM <= LU.ATTRIBUTE1
                                AND LU.SEGMENT1    = @V_DIVISION_ID
                                AND LU.SEGMENT2    = @V_GROUP_ID
                         ) LU
                    ON  RR.SITE_ID = LU.SITE_ID
                    AND RR.STAGE   = LU.STAGE
            UNION ALL
            SELECT @V_PLAN_ID                                                   AS PLAN_ID
                  ,RR.SITE_ID+'::'+RR.LINE_ID+'_'+LU.EQ_QTY+'@'+RR.BUFFER_STAGE AS RESOURCE_ID
                  ,'lower_limit'                                                AS TYPE
                  ,@V_PLAN_START_YYYYMMDD                                       AS START_DATE
                  ,@V_PLAN_END_YYYYMMDD                                         AS END_DATE
                  ,86400                                                        AS DAILY_VALUE
                  ,'L0'                                                         AS CALANDER_LEVEL
                  ,RR.SITE_ID                                                   AS ATTRIBUTE1
                  ,RR.LINE_ID+'_'+LU.EQ_QTY                                     AS ATTRIBUTE15
                  ,RR.LINE_ID                                                   AS ORI_LINE_ID
                  ,LU.FULL_DAYS                                                 AS FULL_DAYS
            FROM(
                SELECT  ATTRIBUTE1  AS SITE_ID
                       ,ATTRIBUTE15 AS LINE_ID
                       ,ATTRIBUTE3  AS STAGE
                       ,ATTRIBUTE4  AS BUFFER_STAGE
                FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
                WHERE   PLAN_ID= @V_PLAN_ID
                AND     RESOURCE_CLASS_ID = 'LINE'
                GROUP BY ATTRIBUTE1, ATTRIBUTE15, ATTRIBUTE3, ATTRIBUTE4
                ) RR
                INNER JOIN(                                                                                    
                          SELECT LU.SEGMENT1   AS DIVISION_ID                                                  
                                ,LU.SEGMENT2   AS GROUP_ID
                                ,LU.SEGMENT3   AS SITE_ID
                                ,LU.SEGMENT4   AS STAGE
                                ,CONVERT(NVARCHAR(100),NUM.NUM) AS EQ_QTY
                                ,LU.ATTRIBUTE2 AS MARGIN
                                ,LU.ATTRIBUTE3 AS FULL_DAYS
                          FROM(
                              SELECT  TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NUM
                              FROM    sys.objects
                              ) NUM
                            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
                                AND LU.VALID_YN = 'Y'
                                AND NUM.NUM <= LU.ATTRIBUTE1
                                AND LU.SEGMENT1    = @V_DIVISION_ID
                                AND LU.SEGMENT2    = @V_GROUP_ID
                         ) LU
                    ON  RR.SITE_ID = LU.SITE_ID
                    AND RR.STAGE   = LU.STAGE
            )EC
            INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                ON  EC.PLAN_ID = RS.PLAN_ID
                AND EC.RESOURCE_ID = RS.RESOURCE_ID
            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON  CAL.BASIS_YYYYMMDD >= EC.START_DATE
                AND CAL.BASIS_YYYYMMDD <  EC.END_DATE

        --FULL_DAYS 이전 일자에 대해서만 FROZEN 구간과 FIX 구간에 대해서 L9생성, FULL_DAYS 이후 일자에 대해선 전부 L9으로 생성
        INSERT INTO @FL_EC_EQ_TEMP2
        --FROZEN 구간에 대해 L9으로 lower_limit 생성
        SELECT FEE.PLAN_ID         AS PLAN_ID
              ,FEE.RESOURCE_ID     AS RESOURCE_ID
              ,FEE.STAGE           AS STAGE
              ,'lower_limit'       AS TYPE
              ,FEE.START_DATE      AS START_DATE
              ,'0'                 AS DAILY_VALUE
              ,'L9'                AS CALENDAR_LEVEL
              ,FEE.SCM_SITE_ID     AS SCM_SITE_ID
              ,FEE.LINE_ID         AS LINE_ID
              ,FEE.ORI_LINE_ID     AS ORI_LINE_ID
              ,FEE.FULL_DAYS       AS FULL_DAYS
        FROM @FL_EC_EQ_TEMP2 FEE
            INNER JOIN (
                        SELECT  FM.STAGE           AS STAGE
                               ,CAL.BASIS_YYYYMMDD AS START_DATE
                        FROM    SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                                ON  FM.PLAN_ID = @V_PLAN_ID
                                AND FM.FROZEN_TYPE = 'PROD'
                                AND BASIS_YYYYMMDD >= FM.FROZEN_START_DATE
                                AND BASIS_YYYYMMDD < FM.FROZEN_END_DATE
                        ) FM
            ON  FEE.STAGE      = FM.STAGE
            AND FEE.START_DATE = FM.START_DATE 
            AND FEE.TYPE       = 'lower_limit'
            AND FEE.START_DATE  < CONVERT(NVARCHAR(8),DATEADD(DAY,CONVERT(INT,FEE.FULL_DAYS),@V_PLAN_START_YYYYMMDD),112)
        UNION ALL
        -- FIX 구간에 대해 L9으로 lower_limit 생성
        SELECT FEE.PLAN_ID         AS PLAN_ID
              ,FEE.RESOURCE_ID     AS RESOURCE_ID
              ,FEE.STAGE           AS STAGE
              ,'lower_limit'       AS TYPE
              ,FEE.START_DATE      AS START_DATE
              ,'0'                 AS DAILY_VALUE
              ,'L9'                AS CALENDAR_LEVEL
              ,FEE.SCM_SITE_ID     AS SCM_SITE_ID
              ,FEE.LINE_ID         AS LINE_ID
              ,FEE.ORI_LINE_ID     AS ORI_LINE_ID
              ,FEE.FULL_DAYS       AS FULL_DAYS
        FROM @FL_EC_EQ_TEMP2 FEE
            INNER JOIN (
                        SELECT  CASE WHEN SEGMENT4 = 'F6000' THEN 'EOL'
                                     WHEN SEGMENT4 = 'A9000' THEN 'ASSY'
                                     WHEN SEGMENT4 = 'A8000' THEN 'STK'
                                     END    AS STAGE
                                ,SEGMENT5   AS SITE_ID
                                ,ATTRIBUTE1 AS LINE_ID
                               ,ATTRIBUTE3                   AS FIX_DATE
                               ,SUM(CONVERT(INT,ATTRIBUTE4)) AS FIX_QTY
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID
                        AND     VALID_YN    = 'Y'
                        GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE1, ATTRIBUTE3
                       ) FIX
                ON  FIX.SITE_ID     = FEE.SCM_SITE_ID
                AND FIX.STAGE       = FEE.STAGE
                AND FIX.LINE_ID     = FEE.ORI_LINE_ID
                AND FIX.FIX_DATE    = FEE.START_DATE
                AND FEE.START_DATE  < CONVERT(NVARCHAR(8),DATEADD(DAY,CONVERT(INT,FEE.FULL_DAYS),@V_PLAN_START_YYYYMMDD),112)
        UNION ALL
        -- FULL_DAYS 이후 구간에 대해 L9으로 lower_limit 생성
        SELECT FEE.PLAN_ID         AS PLAN_ID
              ,FEE.RESOURCE_ID     AS RESOURCE_ID
              ,FEE.STAGE           AS STAGE
              ,'lower_limit'       AS TYPE
              ,FEE.START_DATE      AS START_DATE
              ,'0'                 AS DAILY_VALUE
              ,'L9'                AS CALENDAR_LEVEL
              ,FEE.SCM_SITE_ID     AS SCM_SITE_ID
              ,FEE.LINE_ID         AS LINE_ID
              ,FEE.ORI_LINE_ID     AS ORI_LINE_ID
              ,FEE.FULL_DAYS       AS FULL_DAYS
        FROM  @FL_EC_EQ_TEMP2 FEE
        WHERE 1=1
        AND   FEE.TYPE = 'lower_limit'
        AND   FEE.START_DATE  >= CONVERT(NVARCHAR(8),DATEADD(DAY,CONVERT(INT,FEE.FULL_DAYS),@V_PLAN_START_YYYYMMDD),112)
        ORDER BY 1,2,3,4,5,6,7

        --FROZEN 구간보다 이후 날짜 구간에 대해서는 비조업 날짜에 FROZEN에  86400/LOAD_PER -> 100을 넣어줌
        INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(PLAN_ID
                                              ,FROZEN_ID
                                              ,ROUTING_BOM_MAPPING_ID
                                              ,OP_SEQ
                                              ,RESOURCE_ID
                                              ,QUANTITY
                                              ,EFFECTIVE_DATE
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
        )
        SELECT  FEE.PLAN_ID                               AS PLAN_ID
               ,FEE.RESOURCE_ID+'::'+FEE.START_DATE       AS FROZEN_ID
               ,'RB'+FEE.SCM_SITE_ID+'::IDLE_EQ::IDLE_EQ' AS ROUTING_BOM_MAPPING_ID
               ,0                                         AS OP_SEQ
               ,FEE.RESOURCE_ID                           AS RESOURCE_ID
               ,86400/RR.LOAD_PER                         AS QUANTITY
               ,FEE.START_DATE                            AS EFFECTIVE_DATE
               ,FEE.SCM_SITE_ID                           AS ATTRIBUTE1
               ,'IDLE_EQ'                                 AS ATTRIBUTE2
               ,'IDLE_EQ'                                 AS ATTRIBUTE3
        FROM    @FL_EC_EQ_TEMP2 FEE
            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RR WITH(NOLOCK)
                ON  FEE.PLAN_ID = RR.PLAN_ID
                AND FEE.SCM_SITE_ID+'::IDLE_EQ::IDLE_EQ' = RR.ROUTING_ID
                AND FEE.RESOURCE_ID = RR.RESOURCE_ID
            INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                ON  FEE.PLAN_ID     = FM.PLAN_ID
                AND FEE.STAGE       = FM.STAGE 
                AND FM.FROZEN_TYPE = 'PROD'
            INNER JOIN @NO_WORK_TEMP NW
                ON  FEE.STAGE       = NW.STAGE
                AND FEE.START_DATE  = NW.START_DATE
        WHERE   1=1
        AND     FEE.TYPE = 'upper_limit'
        AND     FEE.START_DATE >= FM.FROZEN_END_DATE
        AND     FEE.START_DATE <  CONVERT(NVARCHAR(8),DATEADD(DAY,CONVERT(INT,FEE.FULL_DAYS),@V_PLAN_START_YYYYMMDD),112)

        -- 비조업 날짜는 'L9'을 제외하고 전체 삭제
        DELETE  @FL_EC_EQ_TEMP2
        FROM    @FL_EC_EQ_TEMP2 FEE
            INNER JOIN @NO_WORK_TEMP NW 
                ON  FEE.START_DATE = NW.START_DATE
                AND FEE.STAGE      = NW.STAGE
        WHERE FEE.CALENDAR_LEVEL  != 'L9' 


        --날짜별로 다시 합쳐서 INSERT
        INSERT INTO SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN(PLAN_ID
                                                          ,RESOURCE_ID
                                                          ,TYPE
                                                          ,START_DATE
                                                          ,END_DATE
                                                          ,CALENDAR_LEVEL
                                                          ,DAILY_VALUE
                                                          ,ATTRIBUTE1
                                                          ,ATTRIBUTE14
                                                          ,ATTRIBUTE15
                                                          )
        SELECT PLAN_ID         AS PLAN_ID
              ,RESOURCE_ID     AS RESOURCE_ID
              ,TYPE            AS TYPE
              ,MIN(START_DATE) AS START_DATE
              --,MAX(START_DATE) AS END_DATE
			  ,CONVERT(VARCHAR(8),DATEADD(DAY, 1, MAX(START_DATE)), 112) AS END_DATE
              ,CALENDAR_LEVEL  AS CALENDAR_LEVEL
              ,DAILY_VALUE     AS DAILY_VALUE
              ,SCM_SITE_ID     AS ATTRIBUTE1
              ,'FULL_LOADING'  AS ATTRIBUTE14
              ,LINE_ID         AS ATTRIBUTE15
        FROM(
            SELECT PLAN_ID
                  ,RESOURCE_ID
                  ,TYPE
                  ,START_DATE
                  ,CALENDAR_LEVEL
                  ,DAILY_VALUE
                  ,SCM_SITE_ID
                  ,LINE_ID
                  ,DATEADD(DAY,-RN,START_DATE) AS GRP
            FROM(
                SELECT PLAN_ID
                      ,RESOURCE_ID
                      ,TYPE
                      ,START_DATE
                      ,CALENDAR_LEVEL
                      ,DAILY_VALUE
                      ,SCM_SITE_ID
                      ,LINE_ID
                      ,ROW_NUMBER() OVER(PARTITION BY RESOURCE_ID,TYPE,CALENDAR_LEVEL ORDER BY RESOURCE_ID,TYPE,CALENDAR_LEVEL,START_DATE) AS RN
                FROM @FL_EC_EQ_TEMP2
                ) REC
            ) GEC
        GROUP BY PLAN_ID, RESOURCE_ID, TYPE, CALENDAR_LEVEL, DAILY_VALUE, GRP, SCM_SITE_ID, LINE_ID

        ------------------------------------------------------------------------
        -- GM MATERIAL 재고 ROLLING
        -- MATERIAL BOM은 AFTER에서 만들기 때문에 AFTER에서 진행
        ------------------------------------------------------------------------
        SELECT  @V_ROLLING_YN = ATTRIBUTE1
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_ONOFF_TEMP'
        AND     SEGMENT1 = @V_DIVISION_ID
        AND     SEGMENT2 = @V_GROUP_ID 
        AND     VALID_YN = 'Y'

        IF @V_ROLLING_YN = 'Y'
        BEGIN
            -- UI의 생산 실적과 동일한 기준으로 맞춤
            INSERT INTO @FP_RELEASE_PLAN_TEMP
            SELECT PLANT_ID
                  ,ITEM_ID
                  ,LINE_ID
                  ,PLAN_DATE
                  ,SUM(ISNULL(A.QTY_LANE,0) + ISNULL(A.DFCT_QTY2,0) + ISNULL(A.YIELD_LOSS_QTY,0) + ISNULL(A.PRDT_REQ_QTY2,0)) AS PLAN_IN_QTY
            FROM   SCM_DAILY_PRODUCT_RESULT_H_SN A WITH(NOLOCK)
            WHERE PLAN_DATE   < @V_PLAN_START_YYYYMMDD
			AND   DIVISION_ID = @V_DIVISION_ID 
            AND   OPERATION_ID = 'A9000' -- 질문
            GROUP BY PLANT_ID,ITEM_ID,LINE_ID,PLAN_DATE

            -- 기준일 이후, PSD 이전 MATERIAL 재고 데이터
            INSERT INTO @M_INV_RL_TEMP
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT  LU.PLANT_SITE_ID                           AS SCM_SITE_ID
                   ,LU.ITEM_ID_CHILD                           AS M_ITEM_ID
                   ,MIN(LU.TO_YYYYMMDD) OVER(PARTITION BY LU.PLANT_SITE_ID, LU.ITEM_ID_CHILD) AS BASE_DATE
                   ,LU.TO_YYYYMMDD                             AS EFFECTIVE_DATE
                   ,SUM(CONVERT(NUMERIC(20,10),LU.TO_EXPC_QTY)) AS M_INV_QTY
            FROM    SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON      LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE   1 = 1
            AND     LU.DIVISION_ID       = @V_DIVISION_ID
            AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND     TO_YYYYMMDD  < @V_PLAN_START_YYYYMMDD
            AND     PG.VALID_YN          = 'Y'
            AND     LU.VALID_YN          = 'Y'
            GROUP BY PLANT_SITE_ID, ITEM_ID_CHILD, TO_YYYYMMDD
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information            
            /*
            SELECT  SEGMENT4                                AS SCM_SITE_ID
                   ,SEGMENT5                                AS M_ITEM_ID
                   ,MIN(ATTRIBUTE3)                         AS BASE_DATE
                   ,ATTRIBUTE1                              AS EFFECTIVE_DATE
                   ,SUM(CONVERT(NUMERIC(20,10),ATTRIBUTE2)) AS M_INV_QTY
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
            WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_INCOMMING_MATERIAL'
            AND     SEGMENT2    = @V_DIVISION_ID
            AND     SEGMENT3    = @V_GROUP_ID
            AND     ATTRIBUTE3 <= ATTRIBUTE1 -- EFFECTIVE DATE가 BASE DATE보다 같거나 큰 재고가 대상
            AND     ATTRIBUTE1  < @V_PLAN_START_YYYYMMDD
            GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE1 */


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
            SELECT  @V_PLAN_ID                                                 AS PLAN_ID
            	   ,TYPE+'::'+SCM_SITE_ID+'::'+MAT_ID+'::'+STAGE+'::'+ARR_DATE AS STOCK_ID
            	   ,SCM_SITE_ID+'::'+MAT_ID+'::'+STAGE                         AS BUFFER_ID
            	   ,ARR_DATE                                                   AS EFFECTIVE_DATE
            	   ,TYPE                                                       AS TYPE
            	   ,SUM(QTY)                                                   AS QUANTITY
            	   ,SCM_SITE_ID                                                AS SITE_ID
            	   ,MAT_ID                                                     AS ITEM_ID
            	   ,STAGE                                                      AS STAGE
            	   ,STAGE                                                      AS STAGE_BUFFER
            	   ,'-'                                                        AS INCOTERMS
            	   ,'-'                                                        AS PROJECT_CODE
            FROM(
                -- 기준일 이후, PSD 이전까지의 재고/실적 반영을 위해
                SELECT IR.SCM_SITE_ID           AS SCM_SITE_ID
                      ,IR.M_ITEM_ID             AS MAT_ID
                      ,'MATERIAL_CONST'         AS STAGE
                      ,@V_PLAN_START_YYYYMMDD   AS ARR_DATE
                      ,M_INV_QTY - PR.TOTAL_QTY AS QTY
                      ,'DR'                     AS TYPE
                --FROM @M_INV_RL_TEMP IR: BLOCKED 2025.11.19 jongykim2
                FROM (--ADDED 2025.11.19 jongykim2: Schelduled Reciept Information
                      SELECT IR.SCM_SITE_ID
                            ,IR.M_ITEM_ID
                            ,SUM(M_INV_QTY) AS M_INV_QTY
                      FROM   @M_INV_RL_TEMP IR
                      GROUP BY IR.SCM_SITE_ID, IR.M_ITEM_ID
                     ) IR
                    INNER JOIN(
                               --BOM에서 찾은 상위 제품의 IN_QTY 생산 실적을 CONSUME_QTY와 곱해서 소요 수량을 구함
                               SELECT BD.SCM_SITE_ID               AS SCM_SITE_ID
                                     --,PR.ITEM_ID                   AS ITEM_ID
                                     ,BD.C_ITEM_ID                 AS C_ITEM_ID
                                     ,SUM(ISNULL(PR.PLAN_IN_QTY,1))*BD.C_QTY AS TOTAL_QTY
                                     ,BD.C_QTY                     AS C_QTY
                               FROM @FP_RELEASE_PLAN_TEMP PR 
                                   RIGHT OUTER JOIN(
                                             -- LOOKUP에 있는 MATERIAL 기준으로 BOM상위 제품을 찾음
                                             SELECT  MS.PLANT_ID          AS PLANT_ID
                                                    ,BOM.ATTRIBUTE2       AS P_ITEM_ID
                                                    ,BOM.ATTRIBUTE14      AS C_ITEM_ID
                                                    ,BOM.CONSUME_QUANTITY AS C_QTY
                                                    ,MI.BASE_DATE         AS BASE_DATE
                                                    ,MI.SCM_SITE_ID       AS SCM_SITE_iD
                                             FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                                                 INNER JOIN(
                                                           SELECT  SCM_SITE_ID
                                                                  ,M_ITEM_ID
                                                                  ,BASE_DATE
                                                           FROM    @M_INV_RL_TEMP
                                                           GROUP BY SCM_SITE_ID, M_ITEM_ID, BASE_DATE
                                                           ) MI
                                                     ON  BOM.ATTRIBUTE1  = MI.SCM_SITE_ID
                                                     AND BOM.ATTRIBUTE14 = MI.M_ITEM_ID
                                                 INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                                                     ON  MI.SCM_SITE_ID = MS.SCM_SITE_ID
                                             WHERE   BOM.PLAN_ID = @V_PLAN_ID
                                             GROUP BY MS.PLANT_ID, BOM.ATTRIBUTE2, BOM.ATTRIBUTE14, BOM.CONSUME_QUANTITY, MI.BASE_DATE, MI.SCM_SITE_ID
                                            ) BD
                                       ON  PR.PLAN_DATE  >= BD.BASE_DATE
                                       AND PR.PLAN_DATE   < @V_PLAN_START_YYYYMMDD
                                       AND PR.PLANT_ID    = BD.PLANT_ID
                                       AND PR.ITEM_ID     = BD.P_ITEM_ID
                                       AND PR.PLAN_IN_QTY > 0
                               GROUP BY BD.SCM_SITE_ID,BD.C_ITEM_ID,BD.C_QTY
                               ) PR
                        ON  IR.SCM_SITE_ID = PR.SCM_SITE_ID
                        AND IR.M_ITEM_ID   = PR.C_ITEM_ID
                WHERE M_INV_QTY - PR.TOTAL_QTY > 0
            	) MC
            WHERE ARR_DATE < @V_PLAN_END_YYYYMMDD
            GROUP BY TYPE, SCM_SITE_ID, MAT_ID, STAGE, ARR_DATE
        END

        ------------------------------------------------------------------------
        -- 2025.09.23/THKIM
        -- HORIZEN CALENDAR Infeasible 방지를 위한 BUCKET 추가
        ------------------------------------------------------------------------
        SELECT  @V_MONTHLYOFF_YN = IIF(COUNT(*)>0,'Y','N')
        FROM    SCP_OPT_ENG_PHASES_SN WITH(NOLOCK) 
        WHERE   PLAN_ID = @V_PLAN_ID
        AND     BUCKETLISTCODE = 'monthlyoff'
        
        SELECT  @V_HORIZEN_ZERO_YN = IIF(COUNT(*)>0, 'Y', 'N') 
        FROM    SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN WITH(NOLOCK) 
        WHERE   PLAN_ID = @V_PLAN_ID
        AND     TYPE    = 'upper_limit' 
        AND     VALUE   = 0 

        IF @V_MONTHLYOFF_YN = 'Y' AND @V_HORIZEN_ZERO_YN = 'Y'
        BEGIN
            -- upper limit, VALUE = 0인 데이터 대상으로 날짜 추출
            INSERT INTO @MONTHLY_OFF_TEMP
            SELECT  START_DATE
            FROM    SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN WITH(NOLOCK)
            WHERE   PLAN_ID = @V_PLAN_ID
            AND     TYPE    = 'upper_limit' 
            AND     VALUE   = 0 
            GROUP BY START_DATE
            UNION ALL
            SELECT  END_DATE
            FROM    SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN WITH(NOLOCK)
            WHERE   PLAN_ID = @V_PLAN_ID
            AND     TYPE    = 'upper_limit' 
            AND     VALUE   = 0 
            GROUP BY END_DATE
            
            -- 추출한 날짜 대상 매월 1일 추가
            INSERT INTO @MONTHLY_OFF_TEMP
            SELECT  DATE 
            FROM(
                SELECT BASIS_YYYYMM+'01' AS DATE
                FROM(
                    SELECT  MIN(DATE) AS MIN_DATE
                           ,MAX(DATE) AS MAX_DATE
                    FROM    @MONTHLY_OFF_TEMP
                    ) DT
                    INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                        ON  CAL.BASIS_YYYYMMDD >= MIN_DATE
                        AND CAL.BASIS_YYYYMMDD <= MAX_DATE
                GROUP BY BASIS_YYYYMM
                ) DT
            WHERE DT.DATE > @V_PLAN_START_YYYYMMDD
            AND   DT.DATE < @V_PLAN_END_YYYYMMDD
            
            -- PSD, PED 추가
            INSERT INTO @MONTHLY_OFF_TEMP VALUES(@V_PLAN_START_YYYYMMDD)
            INSERT INTO @MONTHLY_OFF_TEMP VALUES(@V_PLAN_END_YYYYMMDD)
        
            -- BUCKET에 입력
            INSERT INTO SCP_OPT_ENG_BUCKETS_SN(PLAN_ID
                                              ,BUCKET_NAME
                                              ,START_DATE
                                              )
            SELECT @V_PLAN_ID   AS PLAN_ID
                  ,'monthlyoff' AS BUCKET_NAME
                  ,DATE         AS START_DATE
            FROM @MONTHLY_OFF_TEMP MOT
			WHERE NOT EXISTS ( SELECT 'X'
			                   FROM   SCP_OPT_ENG_BUCKETS_SN WITH(NOLOCK)
							   WHERE  PLAN_ID	  = @V_PLAN_ID
							   AND    BUCKET_NAME = 'monthlyoff'
							   AND    START_DATE  = MOT.DATE )
            GROUP BY DATE
            ORDER BY DATE
        END 

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



CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_ITEM_BOM_ROUTING]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    ,@T_SCP_PLAN            optTableType_SCP_PLAN READONLY

AS 
BEGIN
    --2025.02.12 Taehyun Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	BEGIN DISTRIBUTED TRANSACTION

    COMMIT TRANSACTION

	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_ITEM_BOM_ROUTING';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE         DATETIME;
    DECLARE @V_PLAN_START_YYYYMM   NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM     NVARCHAR(6);
    DECLARE @V_PROD_FROZEN         INT;
    DECLARE @SE_TEMP TABLE(
     ITEM_ID  NVARCHAR(100)
    ,LINE_ID  NVARCHAR(100)
    ,SOP_DATE NVARCHAR(8)
    ,EOP_DATE NVARCHAR(8)
    ,SOP_MM   NVARCHAR(6)
    ,EOP_MM   NVARCHAR(6)
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
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
        SELECT @V_PLAN_START_YYYYMM   = CONVERT(NVARCHAR(6),PLAN_START_DATE,112)
              ,@V_PLAN_END_YYYYMM     = CONVERT(NVARCHAR(6),PLAN_END_DATE,112)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @P_PLAN_ID
		
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

		-- PR_SCP_OPT_ENG_EE_INPUT_FROZEN_PLAN 에서 동일 정보 사용
  --      SELECT  @V_PROD_FROZEN = SEGMENT4
		--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
		--AND     VALID_YN    = 'Y'
		--AND     SEGMENT1    = @V_DIVISION_ID -- 전극 Division 변수
		--AND     SEGMENT2    = @V_GROUP_ID
  --      --AND     SEGMENT3    = 'PR' --임시
  --      AND     SEGMENT3    = @V_SCP_PLAN_TYPE  -- 전극 Division 기준
        ------------------------------------------------------------------------
        -- DATA Insert
        -- 2026.06.26 Minyong Lee: EFF_START_DATE, EFF_END_DATE 로직 ROUTING_RESOURCE 기준으로 변경, 불필요 조건 및 JOIN 제거
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ITEM_BOM_ROUTING_SN(PLAN_ID
                                                ,ROUTING_BOM_MAPPING_ID
                                                ,BUFFER_ID
                                                ,ROUTING_ID
                                                ,BOM_ID
                                                ,EFF_START_DATE
                                                ,EFF_END_DATE
                                                ,FROZEN_FENCE
                                                ,PRIORITY
                                                )
        SELECT  A.PLAN_ID                                               AS PLAN_ID
               ,'RB'+ A.ROUTING_ID                                      AS ROUTING_MAPPING_ID
               ,A.BUFFER_ID                                             AS BUFFER_ID       
               ,A.ROUTING_ID                                            AS ROUTING_ID
               ,A.BOM_ID                                                AS BOM_ID
               ,ISNULL(A.START_DATE, IIF(MIN(A.MON_FIRST_DAY) IS NULL, NULL,MIN(A.MON_FIRST_DAY))) AS START_DATE
               ,ISNULL(A.END_DATE, IIF(MIN(A.MON_LAST_DAY) IS NULL, NULL, MAX(A.MON_LAST_DAY))) AS END_DATE
               --,IIF(ISNULL(A.RT_MONTH, '') = '', NULL,IIF(MIN(A.MON_FIRST_DAY) IS NULL, NULL,MIN(A.MON_FIRST_DAY))) AS MON_FIRST_DAY
               --,IIF(ISNULL(A.RT_MONTH, '') = '', NULL,IIF(MIN(A.MON_LAST_DAY) IS NULL, NULL, MAX(A.MON_LAST_DAY)))  AS MON_LAST_DAY
               ,A.FROZEN_FENCE                                          AS FROZEN_FENCE
               ,IIF(MIN(A.PRIORITY) IS NULL, NULL, MIN(A.PRIORITY))     AS PRIORITY
        FROM(
            SELECT  @V_PLAN_ID      AS PLAN_ID
            		,SIS.BUFFER_ID     AS BUFFER_ID
            		,SRO.ROUTING_ID    AS ROUTING_ID
                    ,SRO.MON_FIRST_DAY AS MON_FIRST_DAY
                    ,CASE WHEN SRO.MON_LAST_DAY IS NULL OR SRO.MON_LAST_DAY ='29991231' THEN NULL
                          ELSE CONVERT(NVARCHAR,SRO.MON_LAST_DAY,112)
                     END AS MON_LAST_DAY
                    ,RR.START_DATE     AS START_DATE
                    ,RR.END_DATE       AS END_DATE
            		,SBO.BOM_ID        AS BOM_ID
            		,PRO.FROM_YYYYMMDD AS EFF_START_DATE
            		,PRO.TO_YYYYMMDD   AS EFF_END_DATE
					-- FROZEN_FENCE 관련 로직 변경 시 PR_SCP_OPT_ENG_EE_INPUT_FROZEN_PLAN 의 PLAN_DATE 제약 부분도 같이 수정할 것
					-- Line 별 Capa 적용이 아니면 NULL
                    ,F.FROZEN_DAYS     AS FROZEN_FENCE
            		,PRO.PRIORITY      AS PRIORITY
					,SRO.ATTRIBUTE15   AS RT_MONTH
            FROM	SCP_OPT_ENG_ITEM_SITE_SN SIS			WITH(NOLOCK)
            		LEFT OUTER JOIN (SELECT  PLAN_ID
                                            ,SRO.ROUTING_ID
                                            ,SRO.ATTRIBUTE1
                                            ,SRO.ATTRIBUTE2
                                            ,SRO.ATTRIBUTE3
                                            ,SRO.ATTRIBUTE15
                                            ,CASE WHEN @V_PLAN_START_YYYYMMDD >= SRO.ATTRIBUTE15+'01' AND @V_PLAN_START_YYYYMMDD >= ISNULL(C.SOP_DATE,'11111111') THEN @V_PLAN_START_YYYYMMDD
                                                        WHEN SRO.ATTRIBUTE15+'01'   >= @V_PLAN_START_YYYYMMDD AND SRO.ATTRIBUTE15+'01' >= ISNULL(C.SOP_DATE,'11111111') THEN SRO.ATTRIBUTE15+'01'
                                                        ELSE ISNULL(C.SOP_DATE,'11111111')
                                                        END AS MON_FIRST_DAY
                                            ,CASE WHEN @V_PLAN_END_YYYYMMDD <= CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) AND @V_PLAN_END_YYYYMMDD <= ISNULL(C.EOP_DATE,'29991231') 
											         THEN @V_PLAN_END_YYYYMMDD
                                                  WHEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) <= @V_PLAN_END_YYYYMMDD 
												   AND CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) <= ISNULL(C.EOP_DATE,'29991231') 
												     THEN CONVERT(NVARCHAR(8),DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01'),112)
												  WHEN ISNULL(C.EOP_DATE,'29991231') = '29991231' THEN '29991231'
                                                  ELSE CONVERT(NVARCHAR(8),DATEADD(DAY,1, CONVERT(DATETIME, C.EOP_DATE) ),112)
                                             END AS MON_LAST_DAY

                                     FROM    SCP_OPT_ENG_ROUTING_SN SRO WITH(NOLOCK)
                                     --LEFT OUTER JOIN   SCM_SYS_CALENDAR_M CAL WITH(NOLOCK) 
                                     --ON      SRO.ATTRIBUTE15 = CAL.BASIS_YYYYMM
                                     --AND     SRO.PLAN_ID     = @V_PLAN_ID
                                     LEFT OUTER JOIN @SE_TEMP C 
                                     ON     SRO.ATTRIBUTE2  = C.ITEM_ID
                                     AND    SRO.PLAN_ID     = @V_PLAN_ID
                                     AND    SRO.ATTRIBUTE14 = C.LINE_ID 
                                     WHERE 1=1
                                     AND (SRO.ATTRIBUTE15 IS NULL OR
                                              ((C.SOP_MM IS NULL OR (SRO.ATTRIBUTE2 = C.ITEM_ID AND SRO.ATTRIBUTE15 >= C.SOP_MM))
                                               AND (C.EOP_MM IS NULL OR (SRO.ATTRIBUTE2 = C.ITEM_ID AND SRO.ATTRIBUTE15 <= C.EOP_MM))
                                               OR C.ITEM_ID IS NULL
                                              )
                                         )
                                     AND    SRO.PLAN_ID = @V_PLAN_ID
                                     GROUP BY    PLAN_ID,SRO.ROUTING_ID,SRO.ATTRIBUTE1,SRO.ATTRIBUTE2,SRO.ATTRIBUTE3,SRO.ATTRIBUTE15,C.SOP_DATE,C.EOP_DATE            
                    )SRO  
            			ON	SIS.PLAN_ID		= SRO.PLAN_ID
            			AND SIS.SITE_ID		= SRO.ATTRIBUTE1
            			AND SIS.ITEM_ID		= SRO.ATTRIBUTE2
            			AND SIS.ATTRIBUTE3	= SRO.ATTRIBUTE3
            		LEFT OUTER JOIN SCP_OPT_ENG_BOM_SN SBO  WITH(NOLOCK)
            			ON	SIS.PLAN_ID		= SBO.PLAN_ID
            			AND SIS.SITE_ID		= SBO.ATTRIBUTE1
            			AND SIS.ITEM_ID		= SBO.ATTRIBUTE2
            			AND SIS.ATTRIBUTE3	= SBO.ATTRIBUTE3
            		LEFT OUTER JOIN (	SELECT A.PLANT_SITE_ID, A.ITEM_ID, A.PRIORITY, A.FROM_YYYYMMDD, A.TO_YYYYMMDD
            							 FROM SCM_MST_SITE_ITEM_PRIORITY A WITH(NOLOCK)

											INNER JOIN #DIVISION D WITH(NOLOCK)
											ON A.DIVISION_ID = D.DIVISION_ID

            							 WHERE 1=1
            							 --AND DIVISION_ID = @V_DIVISION_ID
                                         --시<종 AND 종>시
            							 AND A.TO_YYYYMMDD >= CONVERT(NVARCHAR(8),GETDATE(),112)
            							 GROUP BY A.PLANT_SITE_ID, A.ITEM_ID, A.PRIORITY, A.FROM_YYYYMMDD, A.TO_YYYYMMDD
            						) PRO
            			ON  SIS.SITE_ID = PRO.PLANT_SITE_ID
            			AND SIS.ITEM_ID = PRO.ITEM_ID
                        AND PRO.FROM_YYYYMMDD < SRO.MON_LAST_DAY
                        AND PRO.TO_YYYYMMDD   >= SRO.MON_FIRST_DAY

					LEFT JOIN ( 
								SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROD_FROZEN --,*
								FROM   SCM_MST_SITE A WITH (NOLOCK)

								INNER JOIN #DIVISION D WITH(NOLOCK)
								ON A.DIVISION_ID = D.DIVISION_ID

								WHERE  1=1 -- DIVISION_ID = @V_DIVISION_ID 
								AND    A.SITE_TYPE   = 'PLANT'
								AND    A.VALID_YN    = 'Y'
								) MSE
					ON   SIS.SITE_ID      = MSE.SCM_SITE_ID 
                    -- THKIM/2025.09.25/FROZEN MASTER로 변경
                    LEFT OUTER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN F WITH(NOLOCK)
                        ON  1=1
                        AND F.PLAN_ID       = @V_PLAN_ID
                        AND F.FROZEN_TYPE   = 'PROD'
                        AND SIS.STAGE       = F.STAGE
                    LEFT JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RR WITH(NOLOCK)
                        ON  1=1
                        AND RR.PLAN_ID = @V_PLAN_ID
                        AND RR.ROUTING_ID = SRO.ROUTING_ID
            WHERE	1=1
            AND		SIS.PLAN_ID = @V_PLAN_ID
            AND     SIS.ITEM_CLASS_ID = 'PRODUCTION'
            ) A
            WHERE A.ROUTING_ID IS NOT NULL
            AND   A.MON_FIRST_DAY != A.MON_LAST_DAY
            
        GROUP BY A.PLAN_ID, A.BUFFER_ID, A.ROUTING_ID, A.BOM_ID, A.FROZEN_FENCE, A.RT_MONTH, A.START_DATE, A.END_DATE
		
        ------------------------------------------------------------------------
        -- LINE FULL LOADING 제약이 있으면 DINAMIC RAMP UP 적용을 위해 IDLE 데이터 추가
        -- 2025-07-29 THK
        ------------------------------------------------------------------------ 
        INSERT INTO SCP_OPT_ENG_ITEM_BOM_ROUTING_SN(PLAN_ID
                                                   ,ROUTING_BOM_MAPPING_ID
                                                   ,BUFFER_ID
                                                   ,ROUTING_ID
                                                   ,EFF_START_DATE
                                                   ,EFF_END_DATE
                                                   ,PRIORITY
                                                   ,ATTRIBUTE1
                                                   ,ATTRIBUTE2
                                                   ,ATTRIBUTE3
                                                   ,ATTRIBUTE4
                                                   )
        SELECT  @V_PLAN_ID                   AS PLAN_ID
               ,'RB'+SEGMENT3+'::IDLE::IDLE' AS ROUTING_BOM_MAPPING_ID
               ,SEGMENT3+'::IDLE::IDLE'      AS BUFFER_ID
               ,SEGMENT3+'::IDLE::IDLE'      AS ROUTING_ID
               ,@V_PLAN_START_YYYYMMDD       AS EFF_START_DATE
               ,@V_PLAN_END_YYYYMMDD         AS EFF_END_DATE
               ,1                            AS PRIORITY
               ,SEGMENT3                     AS ATTRIBUTE1
               ,'IDLE'                       AS ATTRIBUTE2
               ,'IDLE'                       AS ATTRIBUTE3
               ,'IDLE'                       AS ATTRIBUTE4
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK) 
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     VALID_YN    = 'Y'

		
		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
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


CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_ITEM_BOM_ROUTING_BATCH]
     @P_PLAN_ID             NVARCHAR(50)
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
	BEGIN DISTRIBUTED TRANSACTION

    COMMIT TRANSACTION

	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_ITEM_BOM_ROUTING_BATCH';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE         DATETIME;
    DECLARE @V_PLAN_START_YYYYMM   NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM     NVARCHAR(6);
    -- DECLARE @V_PROD_FROZEN         INT;
    DECLARE @SE_TEMP TABLE(
     ITEM_ID  NVARCHAR(100)
    ,LINE_ID  NVARCHAR(100)
    ,SOP_DATE NVARCHAR(8)
    ,EOP_DATE NVARCHAR(8)
    ,SOP_MM   NVARCHAR(6)
    ,EOP_MM   NVARCHAR(6)
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
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
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

        
        -- PR_SCP_OPT_ENG_INPUT_FROZEN_PLAN 에서 동일 정보 사용
        ------------------------------------------------------------------------
        -- Frozen Temp Start
        -- 2025.05.16 Philsu Park: Frozen Fence를 Stage 단위로 구분 처리.
        -- 2025.06.19 김태현 : FROZEN MASTER 테이블로 대체
        ------------------------------------------------------------------------
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
        ;
        ------------------------------------------------------------------------
        -- Frozen Temp End.
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- DATA Insert
        -- 2025.05.16 Philsu Park: Frozen Fence를 Stage 단위로 구분 처리.
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
                                                --,IN_CONTAINER_CATEGORY
                                                --,IN_CONTAINER_SIZE
                                                --,OUT_CONTAINER_CATEGORY
                                                --,OUT_CONTAINER_SIZE
                                                )
        SELECT  A.PLAN_ID                                               AS PLAN_ID
               ,'RB'+ A.ROUTING_ID                                      AS ROUTING_MAPPING_ID
               ,A.BUFFER_ID                                             AS BUFFER_ID       
               ,A.ROUTING_ID                                            AS ROUTING_ID
               ,A.BOM_ID                                                AS BOM_ID
               --,IIF(A.BOM_ID IS NOT NULL, NULL,IIF(MIN(A.MON_FIRST_DAY) IS NULL, NULL,MIN(A.MON_FIRST_DAY))) AS MON_FIRST_DAY
               --,IIF(A.BOM_ID IS NOT NULL, NULL,IIF(MIN(A.MON_LAST_DAY) IS NULL, NULL, MAX(A.MON_LAST_DAY)))  AS MON_LAST_DAY
               ,IIF(MIN(A.MON_FIRST_DAY) IS NULL, NULL,MIN(A.MON_FIRST_DAY)) AS MON_FIRST_DAY
               ,IIF(MIN(A.MON_LAST_DAY) IS NULL, NULL, MAX(A.MON_LAST_DAY))  AS MON_LAST_DAY
               ,A.FROZEN_FENCE                                          AS FROZEN_FENCE
               ,IIF(MIN(A.PRIORITY) IS NULL, NULL, MIN(A.PRIORITY))     AS PRIORITY
        FROM(
            SELECT  @V_PLAN_ID      AS PLAN_ID
            		,SIS.BUFFER_ID     AS BUFFER_ID
            		,SRO.ROUTING_ID    AS ROUTING_ID
                    ,IIF(SRO.MON_FIRST_DAY IS NULL OR SRO.MON_FIRST_DAY = '11111111',@V_PLAN_START_YYYYMMDD,SRO.MON_FIRST_DAY) AS MON_FIRST_DAY
                    ,CASE WHEN SRO.MON_LAST_DAY IS NULL OR SRO.MON_LAST_DAY ='29991231' THEN @V_PLAN_END_YYYYMMDD
                          --ELSE CONVERT(NVARCHAR,DATEADD(DAY,1,SRO.MON_LAST_DAY),112)
                          ELSE CONVERT(NVARCHAR,SRO.MON_LAST_DAY,112)
                     END AS MON_LAST_DAY
            		,SBO.BOM_ID        AS BOM_ID
            		,PRO.FROM_YYYYMMDD AS EFF_START_DATE
            		,PRO.TO_YYYYMMDD   AS EFF_END_DATE
					-- FROZEN_FENCE 관련 로직 변경 시 PR_SCP_OPT_ENG_INPUT_FROZEN_PLAN 의 PLAN_DATE 제약 부분도 같이 수정할 것
                    ,F.FROZEN_DAYS     AS FROZEN_FENCE
					/* ,CASE WHEN ISNULL(@V_PROD_FROZEN, 0) = 0              THEN NULL
					      WHEN SIS.ATTRIBUTE3 IN ('ASSY', 'MDLE', 'PACK') THEN @V_PROD_FROZEN 
					      ELSE NULL 
					 END   AS FROZEN_FENCE */
					--,CASE WHEN ISNULL(IIF(SIS.ATTRIBUTE3 NOT IN ('ASSY', 'MDLE', 'PACK'), 0, @V_PROD_FROZEN), '') = '' THEN NULL 
					--      WHEN @V_PROD_FROZEN = 0 THEN NULL
					--      ELSE @V_PROD_FROZEN 
					-- END   AS FROZEN_FENCE
            		,PRO.PRIORITY      AS PRIORITY
            FROM	SCP_OPT_ENG_ITEM_SITE_SN SIS			WITH(NOLOCK)
            LEFT OUTER JOIN (   SELECT   PLAN_ID
                                        ,SRO.ROUTING_ID
                                        ,SRO.ATTRIBUTE1
                                        ,SRO.ATTRIBUTE2
                                        ,SRO.ATTRIBUTE3
                                        ,CASE WHEN @V_PLAN_START_YYYYMMDD >= SRO.ATTRIBUTE15+'01' AND @V_PLAN_START_YYYYMMDD >= ISNULL(C.SOP_DATE,'11111111') THEN @V_PLAN_START_YYYYMMDD
                                                WHEN SRO.ATTRIBUTE15+'01'   >= @V_PLAN_START_YYYYMMDD AND SRO.ATTRIBUTE15+'01' >= ISNULL(C.SOP_DATE,'11111111') THEN SRO.ATTRIBUTE15+'01'
                                                ELSE ISNULL(C.SOP_DATE,'11111111')
                                            END AS MON_FIRST_DAY
                                        --,CASE WHEN @V_PLAN_END_YYYYMMDD <= CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) AND @V_PLAN_END_YYYYMMDD <= ISNULL(C.EOP_DATE,'99999999') THEN @V_PLAN_END_YYYYMMDD
                                        --      WHEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112)   <= @V_PLAN_END_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) <= ISNULL(C.EOP_DATE,'99999999') THEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112)
                                        --      ELSE ISNULL(C.EOP_DATE,'99999999')
                                        -- END AS MON_LAST_DAY -- 위에서 +1 일 처리 부분 제거
                                        ,CASE WHEN @V_PLAN_END_YYYYMMDD <= CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) AND @V_PLAN_END_YYYYMMDD <= ISNULL(C.EOP_DATE,'29991231') 
                                                    THEN @V_PLAN_END_YYYYMMDD
                                                WHEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) <= @V_PLAN_END_YYYYMMDD 
                                                AND CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01')),112) <= ISNULL(C.EOP_DATE,'29991231') 
                                                    THEN CONVERT(NVARCHAR(8),DATEADD(MONTH,1,SRO.ATTRIBUTE15+'01'),112)
                                                WHEN ISNULL(C.EOP_DATE,'29991231') = '29991231' THEN '29991231'
                                                ELSE CONVERT(NVARCHAR(8),DATEADD(DAY,1, CONVERT(DATETIME, C.EOP_DATE) ),112)
                                            END AS MON_LAST_DAY

                                FROM    SCP_OPT_ENG_ROUTING_SN SRO WITH(NOLOCK)
                                LEFT OUTER JOIN   SCM_SYS_CALENDAR_M CAL WITH(NOLOCK) 
                                ON      SRO.ATTRIBUTE15 = CAL.BASIS_YYYYMM
                                AND     SRO.PLAN_ID     = @V_PLAN_ID
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
                                AND     SRO.PLAN_ID = @V_PLAN_ID
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
            LEFT OUTER JOIN (	SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY, FROM_YYYYMMDD, TO_YYYYMMDD
                                    FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
                                    WHERE 1=1
                                    AND DIVISION_ID = @V_DIVISION_ID
                                    --시<종 AND 종>시
                                    AND TO_YYYYMMDD >= CONVERT(NVARCHAR(8),GETDATE(),112)
                                    GROUP BY PLANT_SITE_ID, ITEM_ID, PRIORITY, FROM_YYYYMMDD, TO_YYYYMMDD
                            ) PRO
                ON  SIS.SITE_ID = PRO.PLANT_SITE_ID
                AND SIS.ITEM_ID = PRO.ITEM_ID
                AND PRO.FROM_YYYYMMDD < SRO.MON_LAST_DAY
                AND PRO.TO_YYYYMMDD   >= SRO.MON_FIRST_DAY
            LEFT OUTER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN F
                ON  1=1
                AND F.PLAN_ID = @V_PLAN_ID
                AND F.FROZEN_TYPE = 'PROD'
                AND SIS.ATTRIBUTE3 = F.STAGE
            WHERE	1=1
            AND		SIS.PLAN_ID = @V_PLAN_ID
            AND     SIS.ITEM_CLASS_ID = 'PRODUCTION'
            ) A
            WHERE A.ROUTING_ID IS NOT NULL
            AND   A.MON_FIRST_DAY != A.MON_LAST_DAY
            
        GROUP BY A.PLAN_ID,A.BUFFER_ID,A.ROUTING_ID,A.BOM_ID,A.FROZEN_FENCE
        ------------------------------------------------------------------------
        -- ROUTING의 SCP_OPT_ENG_CONST_FORMATION_LT 적용을 위한 UPDATE
        -- ASY_AGING의 날짜만 업데이트하므로, 기존 데이터에 영향 없음
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_ITEM_BOM_ROUTING_SN
        SET SCP_OPT_ENG_ITEM_BOM_ROUTING_SN.EFF_START_DATE = RT.EFF_START_DATE
           ,SCP_OPT_ENG_ITEM_BOM_ROUTING_SN.EFF_END_DATE   = RT.EFF_END_DATE
        FROM SCP_OPT_ENG_ITEM_BOM_ROUTING_SN IBR WITH(NOLOCK) 
            INNER JOIN (
                       SELECT 'RB'+ROUTING_ID AS ROUTING_BOM_MAPPING_ID
                             ,PLAN_ID         AS PLAN_ID
                             ,ATTRIBUTE12     AS EFF_START_DATE
                             ,ATTRIBUTE13     AS EFF_END_DATE
                       FROM SCP_OPT_ENG_ROUTING_SN WITH(NOLOCK) 
                       WHERE PLAN_ID    = @V_PLAN_ID
                       AND   ATTRIBUTE3 IN ('ASY_AGING', 'CHAR')
                       AND   ATTRIBUTE12 IS NOT NULL
                       ) RT
                ON  1=1
                AND IBR.PLAN_ID = RT.PLAN_ID
                AND IBR.ROUTING_BOM_MAPPING_ID = RT.ROUTING_BOM_MAPPING_ID
        WHERE 1=1
        AND IBR.PLAN_ID = @V_PLAN_ID

        ------------------------------------------------------------------------
        -- 2nd OCV 제약 적용
        -- COBY_ITEM_PROD 적용을 위해선 IBR의 날짜 지정 필요
        ------------------------------------------------------------------------
       /* UPDATE  SCP_OPT_ENG_ITEM_BOM_ROUTING_SN
        SET     SCP_OPT_ENG_ITEM_BOM_ROUTING_SN.EFF_START_DATE = @V_PLAN_START_YYYYMMDD
               ,SCP_OPT_ENG_ITEM_BOM_ROUTING_SN.EFF_END_DATE = @V_PLAN_END_YYYYMMDD
        FROM    SCP_OPT_ENG_ITEM_BOM_ROUTING_SN WITH(NOLOCK)
        WHERE   1=1
        AND     PLAN_ID = @V_PLAN_ID
        AND     ROUTING_ID IN (
                              SELECT DISTINCT RT.ROUTING_ID
                              FROM    SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
                                  INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                      ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                      AND LU.SEGMENT2   = @V_DIVISION_ID
                                      AND LU.SEGMENT3   = @V_GROUP_ID
                                      AND RT.ATTRIBUTE1 = LU.SEGMENT4
                                      AND RT.ATTRIBUTE2 = LU.SEGMENT5
                                      AND RT.ATTRIBUTE3 = LU.ATTRIBUTE3
                                      AND RT.OP_SEQ     = LU.ATTRIBUTE5
                              WHERE   1=1
                              AND     PLAN_ID = @V_PLAN_ID
                              )*/

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

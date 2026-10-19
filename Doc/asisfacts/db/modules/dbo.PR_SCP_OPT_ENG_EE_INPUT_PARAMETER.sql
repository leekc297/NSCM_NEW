

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_PARAMETER]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
    -- 2025.07.07 Philsu Park: 양음극 2단 수행을 위한 Input 생성 Rule 반영.
    -- 2025.09.05 Philsu Park: 양음극 2단 수행 시 에러 방지를 위한 수정
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_PARAMETER';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    DECLARE @V_SINGLE_PLAN_FLAG    NVARCHAR(1);
	DECLARE @V_CHECK				NVARCHAR(1);
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
    -- 2025.07.07 Philsu Park
    -- 양극 또는 음극 지정한 Plan인지 전체 Plan인지 판단한다.
    ------------------------------------------------------------------------
    SELECT @V_SINGLE_PLAN_FLAG = CASE WHEN RIGHT(@V_GROUP_ID, 2) IN ('_C', '_A') THEN 'Y' ELSE 'N' END;

	SELECT 	@V_CHECK = ISNULL(ATTRIBUTE10, '')
	FROM 	SCP_OPMZ_PLAN_GR_M M WITH(NOLOCK)
	WHERE 	M.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
	;

	IF @V_CHECK = 'X'
		BEGIN
			SELECT @V_SINGLE_PLAN_FLAG = @V_CHECK;
		END

	------------------------------------------------------------------------
    -- Goal Data Insert Start
    ------------------------------------------------------------------------
    
        INSERT INTO SCP_OPT_ENG_GOALS_SN(
               PLAN_ID
              ,GOAL_ID
              ,[TYPE]
              ,[GROUP]
              ,EFF_START_DATE
              ,EFF_END_DATE
              ,SENSE
              ,TIME_WEIGHT_CODE
              ,BUCKET_NAME
              )
		SELECT	  PLAN_ID
				, GOAL_ID
				, [TYPE]
				, [GROUP]
				, EFF_START_DATE
				, EFF_END_DATE
				, SENSE
				, TME_WEIGHT_CODE
				, BUCKET_NAME
		FROM ( 
				SELECT @P_PLAN_ID AS PLAN_ID
						--   ,SEGMENT3   AS GOAL_ID
						,CASE WHEN @V_SINGLE_PLAN_FLAG = 'Y' THEN SEGMENT3 ELSE CONCAT(SEGMENT3, RIGHT(SEGMENT2, 2)) END AS GOAL_ID
						,ATTRIBUTE1 AS [TYPE]
						,ATTRIBUTE2 AS [GROUP]
						,ATTRIBUTE3 AS EFF_START_DATE
						,ATTRIBUTE4 AS EFF_END_DATE
						,ATTRIBUTE5 AS SENSE
						,ATTRIBUTE6 AS TME_WEIGHT_CODE
						,ATTRIBUTE7 AS BUCKET_NAME
						,DISPLAY_SEQ
					FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
					WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_GOALS_NEW'
					AND    VALID_YN     = 'Y'
					AND    SEGMENT1     = @V_DIVISION_ID
					AND    SEGMENT2  LIKE CONCAT(@V_GROUP_ID, '%')
					AND     ((@V_SINGLE_PLAN_FLAG = 'N'
						AND     SEGMENT2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
							) 
					OR  (@V_SINGLE_PLAN_FLAG = 'Y'
						AND     RIGHT(SEGMENT2, 2) IN ('_C', '_A')
							)
						)
					-- and     segment2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
					-- AND    RIGHT(SEGMENT2, 2) IN ('_C', '_A')
					-- AND    SEGMENT2     = @V_GROUP_ID
					UNION ALL
					SELECT @P_PLAN_ID AS PLAN_ID
						,SEGMENT3   AS GOAL_ID
						,ATTRIBUTE1 AS [TYPE]
						,ATTRIBUTE2 AS [GROUP]
						,ATTRIBUTE3 AS EFF_START_DATE
						,ATTRIBUTE4 AS EFF_END_DATE
						,ATTRIBUTE5 AS SENSE
						,ATTRIBUTE6 AS TME_WEIGHT_CODE
						,ATTRIBUTE7 AS BUCKET_NAME
						,DISPLAY_SEQ
					FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
					WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_GOALS_NEW'
					AND    VALID_YN     = 'Y'
					AND    SEGMENT1     = @V_DIVISION_ID
					AND    SEGMENT2  	= @V_GROUP_ID
					AND    @V_SINGLE_PLAN_FLAG = 'X'
				) MM
		ORDER BY DISPLAY_SEQ
    ------------------------------------------------------------------------
    -- Goal Data Insert End
    ------------------------------------------------------------------------
    -- OBJECTIVE_GOAL_MAPPING Data Insert Start
    ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_OBJECTIVE_GOAL_MAPPING_SN(
               PLAN_ID
              ,[OBJID]
              ,GOALID
              ,[WEIGHT]
              ,PRE_ACTIONCODE
              ,ITERATIVE_ACTIONCODE
              ,POST_ACTIONCODE
               )
		SELECT PLAN_ID
              ,[OBJID]
              ,GOALID
              ,[WEIGHT]
              ,PRE_ACTIONCODE
              ,ITERATIVE_ACTIONCODE
              ,POST_ACTIONCODE
		FROM ( 
				SELECT @P_PLAN_ID AS PLAN_ID
					,SEGMENT3   AS [OBJID]
					--   ,SEGMENT4   AS GOALID
					,CASE WHEN @V_SINGLE_PLAN_FLAG = 'Y' THEN SEGMENT4 ELSE CONCAT(SEGMENT4, RIGHT(SEGMENT2, 2)) END AS GOALID
					,ATTRIBUTE1 AS [WEIGHT]
					,ATTRIBUTE2 AS PRE_ACTIONCODE
					,ATTRIBUTE3 AS ITERATIVE_ACTIONCODE
					,ATTRIBUTE4 AS POST_ACTIONCODE
					,DISPLAY_SEQ
				FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_OBJ_GOAL_MAPPING_NEW'
				AND    VALID_YN     = 'Y'
				AND    SEGMENT1     = @V_DIVISION_ID
				AND    SEGMENT2  LIKE CONCAT(@V_GROUP_ID, '%')
				AND     ((@V_SINGLE_PLAN_FLAG = 'N'
					AND     SEGMENT2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
						) 
				OR  (@V_SINGLE_PLAN_FLAG = 'Y'
					AND     RIGHT(SEGMENT2, 2) IN ('_C', '_A')
						)
					)
				-- and     segment2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
				-- AND    RIGHT(SEGMENT2, 2) IN ('_C', '_A')
				-- AND    SEGMENT2 = @V_GROUP_ID
				UNION ALL
				SELECT @P_PLAN_ID AS PLAN_ID
					,SEGMENT3   AS [OBJID]
					,SEGMENT4   AS GOALID
					,ATTRIBUTE1 AS [WEIGHT]
					,ATTRIBUTE2 AS PRE_ACTIONCODE
					,ATTRIBUTE3 AS ITERATIVE_ACTIONCODE
					,ATTRIBUTE4 AS POST_ACTIONCODE
					,DISPLAY_SEQ
				FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_OBJ_GOAL_MAPPING_NEW'
				AND    VALID_YN     = 'Y'
				AND    SEGMENT1     = @V_DIVISION_ID
				AND    SEGMENT2   	= @V_GROUP_ID
				AND 	@V_SINGLE_PLAN_FLAG = 'X'
				) MM
		ORDER BY DISPLAY_SEQ
    ------------------------------------------------------------------------
    -- OBJECTIVE_GOAL_MAPPING Data Insert End
    ------------------------------------------------------------------------
    -- OBJECTIVES Data Insert Start
    ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_OBJECTIVES_SN(
               PLAN_ID
              ,OBJ_ID
              ,SEQ
              ,OBJFIX
              ,NBVFIX
              ,TIME_LIMIT
              ,OPTI_GAP
               )
		SELECT PLAN_ID
              ,OBJ_ID
              ,SEQ
              ,OBJFIX
              ,NBVFIX
              ,TIME_LIMIT
              ,OPTI_GAP
		FROM( 
				SELECT @P_PLAN_ID AS PLAN_ID
					,SEGMENT3   AS OBJ_ID
					--   ,SEGMENT4   AS SEQ
					,CASE WHEN @V_SINGLE_PLAN_FLAG = 'Y' THEN SEGMENT4 ELSE CONCAT(SEGMENT4, RIGHT(SEGMENT2, 2)) END AS SEQ
					,ATTRIBUTE1 AS OBJFIX
					,ATTRIBUTE2 AS NBVFIX
					,IIF(ATTRIBUTE3 = '',NULL,ATTRIBUTE3) AS TIME_LIMIT
					,ATTRIBUTE4 AS OPTI_GAP
					,DISPLAY_SEQ
				FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_OBJECTIVES_NEW'
				AND    VALID_YN     = 'Y'
				AND    SEGMENT1     = @V_DIVISION_ID
				AND    SEGMENT2  LIKE CONCAT(@V_GROUP_ID, '%')
				AND     ((@V_SINGLE_PLAN_FLAG = 'N'
					AND     SEGMENT2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
						) 
				OR  (@V_SINGLE_PLAN_FLAG = 'Y'
					AND     RIGHT(SEGMENT2, 2) IN ('_C', '_A')
						)
					)
				-- and     segment2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
				-- AND    RIGHT(SEGMENT2, 2) IN ('_C', '_A')
				-- AND    SEGMENT2    = @V_GROUP_ID
				UNION ALL
				SELECT @P_PLAN_ID AS PLAN_ID
					,SEGMENT3   AS OBJ_ID
					,SEGMENT4   AS SEQ
					,ATTRIBUTE1 AS OBJFIX
					,ATTRIBUTE2 AS NBVFIX
					,IIF(ATTRIBUTE3 = '',NULL,ATTRIBUTE3) AS TIME_LIMIT
					,ATTRIBUTE4 AS OPTI_GAP
					,DISPLAY_SEQ
				FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_OBJECTIVES_NEW'
				AND    VALID_YN     = 'Y'
				AND    SEGMENT1     = @V_DIVISION_ID
				AND    SEGMENT2  	= @V_GROUP_ID
				AND 	@V_SINGLE_PLAN_FLAG = 'X'
				) MM
		ORDER BY DISPLAY_SEQ
    ------------------------------------------------------------------------
    -- OBJECTIVES Data Insert End
    ------------------------------------------------------------------------
    -- PHASE Data Insert Start
    -- 2025.05.15 Philsu Park: Setupsize = PLAN_START_YMD - LEAST(PST+1+SETUPSIZE 입력값 로 산출된 월 말일 + 1일, PLAN_END_YMD)
    ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_PHASES_SN(
               PLAN_ID
              ,PHASESEQ
              ,ALLOCATIONCODES
              ,SETUPCODES
              ,CONTAINERCODES
              ,OBJECTIVES
              ,BUCKETLISTCODE
              ,MODEL_TYPE
              ,FROZENBUCKET
              ,SETUPSIZE
              ,HALFWEEKBUCKETSIZE
              ,PLANDAYS
              ,BATCH_EXECUTION
              ,REFLECT_RESULT
              ,PRINT_RESULT
              )
		SELECT PLAN_ID
              ,PHASESEQ
              ,ALLOCATIONCODES
              ,SETUPCODES
              ,CONTAINERCODES
              ,OBJECTIVES
              ,BUCKETLISTCODE
              ,MODEL_TYPE
              ,FROZENBUCKET
              ,SETUPSIZE
              ,HALFWEEKBUCKETSIZE
              ,PLANDAYS
              ,BATCH_EXECUTION
              ,REFLECT_RESULT
              ,PRINT_RESULT
		FROM ( 
				SELECT @P_PLAN_ID  AS PLAN_ID
					--   ,SEGMENT3    AS PHASESEQ
					,CASE WHEN @V_SINGLE_PLAN_FLAG = 'Y' THEN SEGMENT3 ELSE CONCAT(SEGMENT3, RIGHT(SEGMENT2, 2)) END AS PHASESEQ
					,ATTRIBUTE1  AS ALLOCATIONCODES
					,ATTRIBUTE2  AS SETUPCODES
					,ATTRIBUTE3  AS CONTAINERCODES
					,ATTRIBUTE4  AS OBJECTIVES
					,ATTRIBUTE5  AS BUCKETLISTCODE
					,ATTRIBUTE6  AS MODEL_TYPE
					,ATTRIBUTE7  AS FROZENBUCKET
					,CONVERT(NVARCHAR, DATEDIFF(DAY, CONVERT(DATE, @V_PLAN_START_YYYYMMDD), DATEADD(DAY, 1, LEAST(EOMONTH(DATEADD(DAY, 1+CONVERT(INT, IIF(ATTRIBUTE8 = '', NULL, ATTRIBUTE8)), CONVERT(DATE,@V_PLAN_START_YYYYMMDD))), CONVERT(DATE, @V_PLAN_END_YYYYMMDD))))) AS SETUPSIZE
					--   ,IIF(ATTRIBUTE8 = '', NULL, ATTRIBUTE8) AS SETUPSIZE
					,IIF(ATTRIBUTE9 = '', NULL, ATTRIBUTE9) AS HALFWEEKBUCKETSIZE
					,ATTRIBUTE10 AS PLANDAYS
					,ATTRIBUTE11 AS BATCH_EXECUTION
					,ATTRIBUTE12 AS REFLECT_RESULT
					,ATTRIBUTE13 AS PRINT_RESULT
					,DISPLAY_SEQ
				FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_PHASE_NEW'
				AND    VALID_YN    = 'Y'
				AND    SEGMENT1    = @V_DIVISION_ID
				AND    SEGMENT2  LIKE CONCAT(@V_GROUP_ID, '%')
				AND     ((@V_SINGLE_PLAN_FLAG = 'N'
					AND     SEGMENT2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
						) 
				OR  (@V_SINGLE_PLAN_FLAG = 'Y'
					AND     RIGHT(SEGMENT2, 2) IN ('_C', '_A')
						)
					)
				-- and     segment2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
				-- AND    RIGHT(SEGMENT2, 2) IN ('_C', '_A')
				-- AND    SEGMENT2    = @V_GROUP_ID
				UNION ALL
				SELECT @P_PLAN_ID  AS PLAN_ID
					,SEGMENT3    AS PHASESEQ
					,ATTRIBUTE1  AS ALLOCATIONCODES
					,ATTRIBUTE2  AS SETUPCODES
					,ATTRIBUTE3  AS CONTAINERCODES
					,ATTRIBUTE4  AS OBJECTIVES
					,ATTRIBUTE5  AS BUCKETLISTCODE
					,ATTRIBUTE6  AS MODEL_TYPE
					,ATTRIBUTE7  AS FROZENBUCKET
					,CONVERT(NVARCHAR, DATEDIFF(DAY, CONVERT(DATE, @V_PLAN_START_YYYYMMDD), DATEADD(DAY, 1, LEAST(EOMONTH(DATEADD(DAY, 1+CONVERT(INT, IIF(ATTRIBUTE8 = '', NULL, ATTRIBUTE8)), CONVERT(DATE,@V_PLAN_START_YYYYMMDD))), CONVERT(DATE, @V_PLAN_END_YYYYMMDD))))) AS SETUPSIZE
					--   ,IIF(ATTRIBUTE8 = '', NULL, ATTRIBUTE8) AS SETUPSIZE
					,IIF(ATTRIBUTE9 = '', NULL, ATTRIBUTE9) AS HALFWEEKBUCKETSIZE
					,ATTRIBUTE10 AS PLANDAYS
					,ATTRIBUTE11 AS BATCH_EXECUTION
					,ATTRIBUTE12 AS REFLECT_RESULT
					,ATTRIBUTE13 AS PRINT_RESULT
					,DISPLAY_SEQ
				FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_PHASE_NEW'
				AND    VALID_YN    = 'Y'
				AND    SEGMENT1    = @V_DIVISION_ID
				AND    SEGMENT2		= @V_GROUP_ID
				AND 	@V_SINGLE_PLAN_FLAG = 'X'
				) MM
		ORDER BY DISPLAY_SEQ
    ------------------------------------------------------------------------
    -- PHASE Data Insert End
    ------------------------------------------------------------------------
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

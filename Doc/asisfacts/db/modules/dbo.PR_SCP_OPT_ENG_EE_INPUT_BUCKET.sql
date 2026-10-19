

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_BUCKET]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
    -- 2025.09.05 Philsu Park: 양음극 2단 실행 시 에러 방지를 위한 조건 변경
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_BUCKET';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    DECLARE @V_SINGLE_PLAN_FLAG    NVARCHAR(1);
	DECLARE @V_CHECK				NVARCHAR(1);
    --DECLARE @V_R_PLAN_END_YYYYMMDD NVARCHAR(8);


    --SELECT @V_R_PLAN_END_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY,-1,@V_PLAN_END_YYYYMMDD),112)

    ------------------------------------------------------------------------ 
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

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
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY

        
    -- Data Insert Start
    -- 2025.09.18 Philsu Park: Month Bucket에 첫달은 무조건 PSD로 들어가야 함.
    ------------------------------------------------------------------------
	IF @V_SINGLE_PLAN_FLAG != 'X'
	 	BEGIN 
			INSERT INTO SCP_OPT_ENG_BUCKETS_SN(PLAN_ID,BUCKET_NAME,START_DATE)
			SELECT @V_PLAN_ID
				,BUCKETLISTCODE
				,YYYYMMDD
			FROM(
				SELECT  LU.ATTRIBUTE5          AS BUCKETLISTCODE
					,LU.ATTRIBUTE14         AS DAILY_DAYS
					,CAL.DAY_NUM            AS DAY_NUM
					,LU.ATTRIBUTE15         AS PHASE_TYPECAL
					,CAL.DAILY_DAY          AS DAILY_DAY 
					,CAL.WEEKLY_DAY         AS WEEKLY_DAY
					,CAL.MONTH_DAY          AS MONTH_DAY 
					,CASE WHEN LU.ATTRIBUTE15 = 'DAILY'  THEN DAILY_DAY
							WHEN @V_PLAN_END_YYYYMMDD = DAILY_DAY AND LU.ATTRIBUTE15 = 'MONTHLY'                        THEN DAILY_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) >  CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'WEEKLY'  THEN WEEKLY_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) <= CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'WEEKLY'  THEN DAILY_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) >  CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'MONTHLY' THEN MONTH_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) <= CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'MONTHLY' THEN DAILY_DAY
						END AS YYYYMMDD
				FROM(
					SELECT  CAL.BASIS_YYYYMMDD    AS DAILY_DAY
						,CAL.BASIS_START_DATE  AS WEEKLY_DAY
						,GREATEST(CAL.BASIS_YYYYMM+'01', @V_PLAN_START_YYYYMMDD) AS MONTH_DAY
						,ROW_NUMBER() OVER ( ORDER BY CAL.BASIS_YYYYMMDD) AS DAY_NUM 
					FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					WHERE   CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
					) CAL
				CROSS APPLY SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
				WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_PHASE_NEW'
				AND     LU.VALID_YN    = 'Y'
				AND     LU.SEGMENT1    = @V_DIVISION_ID
				--AND     LU.SEGMENT2    = @V_GROUP_ID
				AND    SEGMENT2  LIKE CONCAT(@V_GROUP_ID, '%')
				AND     ((@V_SINGLE_PLAN_FLAG = 'N'
					AND     SEGMENT2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
						) 
				OR  (@V_SINGLE_PLAN_FLAG = 'Y'
					AND     RIGHT(SEGMENT2, 2) IN ('_C', '_A')
						)
					)
				-- AND    RIGHT(SEGMENT2, 2) IN ('_C', '_A')
				) BK
			GROUP BY BUCKETLISTCODE, YYYYMMDD
			;
		END
	ELSE IF @V_SINGLE_PLAN_FLAG = 'X'
		BEGIN
			INSERT INTO SCP_OPT_ENG_BUCKETS_SN(PLAN_ID,BUCKET_NAME,START_DATE)
			SELECT @V_PLAN_ID
				,BUCKETLISTCODE
				,YYYYMMDD
			FROM(
				SELECT  LU.ATTRIBUTE5          AS BUCKETLISTCODE
					,LU.ATTRIBUTE14         AS DAILY_DAYS
					,CAL.DAY_NUM            AS DAY_NUM
					,LU.ATTRIBUTE15         AS PHASE_TYPECAL
					,CAL.DAILY_DAY          AS DAILY_DAY 
					,CAL.WEEKLY_DAY         AS WEEKLY_DAY
					,CAL.MONTH_DAY          AS MONTH_DAY 
					,CASE WHEN LU.ATTRIBUTE15 = 'DAILY'  THEN DAILY_DAY
							WHEN @V_PLAN_END_YYYYMMDD = DAILY_DAY AND LU.ATTRIBUTE15 = 'MONTHLY'                        THEN DAILY_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) >  CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'WEEKLY'  THEN WEEKLY_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) <= CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'WEEKLY'  THEN DAILY_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) >  CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'MONTHLY' THEN MONTH_DAY
							WHEN CONVERT(INT,CAL.DAY_NUM) <= CONVERT(INT,LU.ATTRIBUTE14) AND LU.ATTRIBUTE15 = 'MONTHLY' THEN DAILY_DAY
						END AS YYYYMMDD
				FROM(
					SELECT  CAL.BASIS_YYYYMMDD    AS DAILY_DAY
						,CAL.BASIS_START_DATE  AS WEEKLY_DAY
						,GREATEST(CAL.BASIS_YYYYMM+'01', @V_PLAN_START_YYYYMMDD) AS MONTH_DAY
						,ROW_NUMBER() OVER ( ORDER BY CAL.BASIS_YYYYMMDD) AS DAY_NUM 
					FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					WHERE   CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
					) CAL
				CROSS APPLY SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
				WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_PHASE_NEW'
				AND     LU.VALID_YN    = 'Y'
				AND     LU.SEGMENT1    = @V_DIVISION_ID
				AND     LU.SEGMENT2    = @V_GROUP_ID
				-- AND    SEGMENT2  LIKE CONCAT(@V_GROUP_ID, '%')
				-- AND     ((@V_SINGLE_PLAN_FLAG = 'N'
				-- 	AND     SEGMENT2 IN (CONCAT(@V_GROUP_ID, '_C'), CONCAT(@V_GROUP_ID, '_A'))
				-- 		) 
				-- OR  (@V_SINGLE_PLAN_FLAG = 'Y'
				-- 	AND     RIGHT(SEGMENT2, 2) IN ('_C', '_A')
				-- 		)
				-- 	)
				-- AND    RIGHT(SEGMENT2, 2) IN ('_C', '_A')
				) BK
			GROUP BY BUCKETLISTCODE, YYYYMMDD
			;
		END 

    ------------------------------------------------------------------------
    -- Weekly Bucket Create
	-- 2025.09.09 Philsu Park: 전극의 경우 WEEKLY Bucket을 Default로 생성해준다.
	------------------------------------------------------------------------
    INSERT INTO SCP_OPT_ENG_BUCKETS_SN(PLAN_ID,BUCKET_NAME,START_DATE)
    SELECT    @V_PLAN_ID            AS PLAN_ID
            , 'weekly'              AS BUCKETLISTCODE
            , CAL.BASIS_START_DATE  AS YYYYMMDD
    FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
    WHERE   CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
    AND NOT EXISTS (SELECT  1
                    FROM    SCP_OPT_ENG_BUCKETS_SN B WITH(NOLOCK)
                    WHERE   B.PLAN_ID       = @V_PLAN_ID
                    AND     B.BUCKET_NAME   = 'weekly'
                    AND     B.START_DATE    = CAL.BASIS_START_DATE
                    )
    GROUP BY CAL.BASIS_START_DATE
    
    ;

    ------------------------------------------------------------------------
	-- montly bucket create
	--     2025.03.24 Phase에 정의하지 않고 강제로 생성 ( PST ~ PET. PET는 하루 더하지 않는다 )
    -- 2025.05.21 Philsu Park: Goal 셋업 기준에 따라 자동 생성 처리. 일단 monthly만 반영한다.
	------------------------------------------------------------------------	
    WITH BUCKET AS (
        SELECT  DISTINCT ATTRIBUTE7 AS BUCKET_NAME
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
        WHERE   LOOKUP_TYPE                 = 'SCP_OPT_ENG_GOALS_NEW'
        AND     VALID_YN                    = 'Y'
        AND     L.ATTRIBUTE1             LIKE '%AT'
        AND     ISNULL(L.ATTRIBUTE7, '')   != ''
        AND     L.SEGMENT1                  = @V_DIVISION_ID
        AND     L.SEGMENT2                  = @V_GROUP_ID
        AND     CONCAT(L.SEGMENT2, L.SEGMENT3) IN  (SELECT  CONCAT(SEGMENT2, SEGMENT4)
                                                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_OBJ_GOAL_MAPPING_NEW'
                                                    AND     VALID_YN    = 'Y'
                                                    AND     SEGMENT1    = @V_DIVISION_ID
                                                    AND     SEGMENT2    = @V_GROUP_ID
                                                    )
    )
    INSERT INTO SCP_OPT_ENG_BUCKETS_SN(PLAN_ID,BUCKET_NAME,START_DATE)
    SELECT   @V_PLAN_ID     AS PLAN_ID
            ,BK.BUCKET_NAME AS BUCKET_NAME
            ,MON.START_DATE AS START_DATE
    FROM (
            SELECT    'monthly' AS BUCKET_NAME
                    , BASIS_YYYYMM, MIN(BASIS_YYYYMMDD) AS START_DATE
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
            GROUP BY BASIS_YYYYMM
            ------------------------------------------------------------------------
            UNION
            ------------------------------------------------------------------------
            --SELECT  BASIS_YYYYMM, CONVERT(NVARCHAR(8), DATEADD(DAY,-1,MIN(BASIS_YYYYMMDD)),112) AS START_DATE
            SELECT    'monthly' AS BUCKET_NAME
                    , BASIS_YYYYMM, MIN(BASIS_YYYYMMDD) AS START_DATE
            FROM    SCM_SYS_CALENDAR_M CAL2 WITH(NOLOCK)
            WHERE   CAL2.BASIS_YYYYMMDD = @V_PLAN_END_YYYYMMDD
            GROUP BY BASIS_YYYYMM
        ) MON
    INNER JOIN BUCKET BK 
        ON MON.BUCKET_NAME = BK.BUCKET_NAME
    WHERE NOT EXISTS ( SELECT   1
                       FROM     SCP_OPT_ENG_BUCKETS_SN BKT
                       WHERE    BKT.PLAN_ID     = @V_PLAN_ID 
                       AND      BKT.BUCKET_NAME = BK.BUCKET_NAME
                       AND      BKT.START_DATE  = MON.START_DATE
                       )
    ;

	/*
	------------------------------------------------------------------------
	-- montly bucket create
	--     2025.03.24 Phase에 정의하지 않고 강제로 생성 ( PST ~ PET. PET는 하루 더하지 않는다 )
	------------------------------------------------------------------------	
	INSERT INTO SCP_OPT_ENG_BUCKETS_SN(PLAN_ID,BUCKET_NAME,START_DATE)
	SELECT @V_PLAN_ID
		  ,'monthly'
		  ,MON.START_DATE
	FROM (
			SELECT  BASIS_YYYYMM, MIN(BASIS_YYYYMMDD) AS START_DATE
			FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
			WHERE   CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
			GROUP BY BASIS_YYYYMM
			------------------------------------------------------------------------
			UNION ALL 
			------------------------------------------------------------------------
			--SELECT  BASIS_YYYYMM, CONVERT(NVARCHAR(8), DATEADD(DAY,-1,MIN(BASIS_YYYYMMDD)),112) AS START_DATE
			SELECT  BASIS_YYYYMM, MIN(BASIS_YYYYMMDD) AS START_DATE
			FROM    SCM_SYS_CALENDAR_M CAL2 WITH(NOLOCK)
			WHERE   CAL2.BASIS_YYYYMMDD = @V_PLAN_END_YYYYMMDD
			GROUP BY BASIS_YYYYMM
	) MON
	*/
    ------------------------------------------------------------------------
    -- Data Insert End
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

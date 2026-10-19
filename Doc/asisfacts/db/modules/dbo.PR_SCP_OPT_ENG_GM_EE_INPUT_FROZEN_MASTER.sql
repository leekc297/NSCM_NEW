





CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_FROZEN_MASTER]
     @P_PLAN_ID     NVARCHAR(50)
AS 
BEGIN
    --2025.02.14 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_FROZEN_MASTER';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE         DATETIME;
    DECLARE @V_DIVISION_ID         NVARCHAR(100)
    DECLARE @V_GROUP_ID            NVARCHAR(100)
    DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(50)
    DECLARE @V_SCP_PLAN_DATE       NVARCHAR(8)
    DECLARE @V_SCP_PLAN_TYPE       NVARCHAR(20)
    DECLARE @V_SCP_PLAN_SEQ        NVARCHAR(8)
    DECLARE @V_PROD_FROZEN         INT
    DECLARE @V_PLAN_EXEC_TYPE      NVARCHAR(10)
    DECLARE @V_SHIP_SCP_PLAN_DATE  NVARCHAR(8)
    DECLARE @V_SHIP_SCP_PLAN_TYPE  NVARCHAR(20)
    DECLARE @V_SHIP_SCP_PLAN_SEQ   NVARCHAR(8)

    DECLARE @PROD_FROZEN TABLE(
      STAGE                 NVARCHAR(100)
    , FROZEN_START_YYYYMMDD NVARCHAR(8)
    , FROZEN_END_YYYYMMDD   NVARCHAR(8)
    , FROZEN_DAYS           NVARCHAR(50)
    )

    DECLARE @SHIP_FROZEN TABLE(
      STAGE                 NVARCHAR(100)
    , FROZEN_START_YYYYMMDD NVARCHAR(8)
    , FROZEN_END_YYYYMMDD   NVARCHAR(8)
    , FROZEN_DAYS           NVARCHAR(50)
    )
    ------------------------------------------------------------------------ 
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	BEGIN TRY

        -- 이전에 있던 PLAN_ID 정보는 삭제
        DELETE FROM SCP_OPT_ENG_FROZEN_MASTER_SN
        WHERE PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------ 
        --PLAN 기본 정보 생성
	    ------------------------------------------------------------------------
        SELECT  @V_DIVISION_ID         = A.DIVISION_ID
               ,@V_GROUP_ID            = A.PLAN_GROUP_ID
               ,@V_PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
               ,@V_PLAN_EXEC_TYPE      = A.PLAN_EXEC_TYPE
               --,@V_PLAN_END_YYYYMMDD   = A.PLAN_END_YYYYMMDD
        FROM(
             SELECT PM.DIVISION_ID          AS DIVISION_ID
                   ,PGM.OPMZ_PLAN_GR_NAME   AS PLAN_GROUP_ID
                   ,PM.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
                   ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,PM.PLAN_END_YYYYMMDD),112)  AS PLAN_END_YYYYMMDD
                   ,'UI'                    AS PLAN_EXEC_TYPE
             FROM     SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
                 INNER JOIN SCP_OPMZ_PLAN_GR_M PGM WITH(NOLOCK)
                     ON PM.OPMZ_PLAN_GR_ID = PGM.OPMZ_PLAN_GR_ID
             WHERE   PM.OPMZ_PLAN_ID = @V_PLAN_ID
             UNION
             SELECT  DIVISION_ID             AS DIVISION_ID
                    ,PLAN_TYPE_CODE          AS PLAN_GROUP_ID
                    ,PLAN_START_YYYYMMDD     AS PLAN_START_YYYYMMDD
                    ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,PLAN_END_YYYYMMDD),112) AS PLAN_END_YYYYMMDD
                    ,'MANUAL'                AS PLAN_EXEC_TYPE
             FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
             WHERE   1=1
             AND     PLAN_ID = @V_PLAN_ID
        ) A
        ------------------------------------------------------------------------ 
        --FROZEN MASTER 정보 생성
	    ------------------------------------------------------------------------
        --IF @V_DIVISION_ID != 'EE' 
        --    BEGIN
                ------------------------------------------------------------------------ 
                --FROZEN MASTER 정보 생성
	            ------------------------------------------------------------------------
                IF @V_PLAN_EXEC_TYPE = 'MANUAL'
                    BEGIN
                        SELECT @V_SCP_PLAN_DATE   = A.PLAN_START_YYYYMMDD 
                              ,@V_SCP_PLAN_TYPE   = A.PLAN_TYPE 
                              ,@V_SCP_PLAN_SEQ    = A.PLAN_SEQ 
                        FROM  (SELECT TOP 1 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
                               FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
                               WHERE  DIVISION_ID          = @V_DIVISION_ID
                               AND    PLAN_START_YYYYMMDD  = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
                               ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
                              ) A  

                        SELECT @V_SHIP_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD 
                              ,@V_SHIP_SCP_PLAN_TYPE = A.PLAN_TYPE 
                              ,@V_SHIP_SCP_PLAN_SEQ  = A.PLAN_SEQ 
                        FROM  (SELECT TOP 1 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
                               FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
                               WHERE  DIVISION_ID          = @V_DIVISION_ID
                               AND    PLAN_START_YYYYMMDD  = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
                               ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
                              ) A  
                        
                        ------------------------------------------------------------------------ 
                        -- FROZEN 기간 정보 생성 -> 수동인 경우만 사용
	                    ------------------------------------------------------------------------
                        INSERT INTO @PROD_FROZEN
                        SELECT   SEGMENT4         AS STAGE
                                ,@V_PLAN_START_YYYYMMDD AS FROZEN_START_YYYYMMDD
                                ,CONVERT(CHAR(8), DATEADD(DD, ISNULL(TRY_CAST(SEGMENT5 AS INT), 0), @V_PLAN_START_YYYYMMDD ), 112) AS FROZEN_END_YYYYMMDD
                                ,SEGMENT5         AS FROZEN_DAYS
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN_NEW'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT1    = @V_DIVISION_ID
                        AND     SEGMENT2    = @V_GROUP_ID
                        AND     SEGMENT3    = @V_SCP_PLAN_TYPE

                        INSERT INTO @SHIP_FROZEN
                        SELECT   'SHIP'           AS STAGE
                                ,@V_PLAN_START_YYYYMMDD AS FROZEN_START_YYYYMMDD
                                ,CONVERT(CHAR(8), DATEADD(DD, ISNULL(TRY_CAST(SEGMENT4 AS INT), 0), @V_PLAN_START_YYYYMMDD ), 112) AS FROZEN_END_YYYYMMDD
                                ,SEGMENT4         AS FROZEN_DAYS
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT1    = @V_DIVISION_ID
                        AND     SEGMENT2    = @V_GROUP_ID
                        AND     SEGMENT3    = @V_SCP_PLAN_TYPE
                    END
                ELSE IF @V_PLAN_EXEC_TYPE = 'UI'
                    --자동인 경우 입력된 데이터로 찾아옴
                    BEGIN
                        SELECT  @V_SCP_PLAN_DATE = V.PLAN_START_YYYYMMDD
                               ,@V_SCP_PLAN_TYPE = V.PLAN_TYPE
                               ,@V_SCP_PLAN_SEQ  = V.PLAN_SEQ
                        FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK)
                            INNER JOIN SCP_PLAN_VERSION_V V WITH(NOLOCK)
                                ON  V.DIVISION_ID     = @V_DIVISION_ID
                                AND V.PLAN_VERSION_ID = PROD_REF_SYS_PLAN_ID
                                AND OP.OPMZ_PLAN_ID   = @V_PLAN_ID
                                AND OP.PROD_REF_SYS_DIVS_CD = 'SCP'

                        SELECT  @V_SHIP_SCP_PLAN_DATE = V.PLAN_START_YYYYMMDD
                               ,@V_SHIP_SCP_PLAN_TYPE = V.PLAN_TYPE
                               ,@V_SHIP_SCP_PLAN_SEQ  = V.PLAN_SEQ
                        FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK)
                            INNER JOIN SCP_PLAN_VERSION_V V WITH(NOLOCK)
                                ON  V.DIVISION_ID     = @V_DIVISION_ID
                                AND V.PLAN_VERSION_ID = SHIP_REF_SYS_PLAN_ID
                                AND OP.OPMZ_PLAN_ID   = @V_PLAN_ID
                                AND OP.PROD_REF_SYS_DIVS_CD = 'SCP'

                        -- FP의 경우 최신 버전 OR CUTOFF 일자 확인을 위한 변수 설정
                        SELECT  @V_SCP_PLAN_DATE = IIF(PROD_REF_SYS_PLAN_ID = 'Latest FP Plan',NULL,PROD_REF_SYS_PLAN_ID)
                               ,@V_SCP_PLAN_TYPE = IIF(PROD_REF_SYS_PLAN_ID = 'Latest FP Plan',PROD_REF_SYS_PLAN_ID,'CUT_OFF')
                        FROM    SCP_OPMZ_PLAN_M WITH(NOLOCK)
                        WHERE   OPMZ_PLAN_ID         = @V_PLAN_ID
                        AND     PROD_REF_SYS_DIVS_CD = 'FP'
                    END

            --END


        ------------------------------------------------------------------------ 
        --DATA Insert
	    ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_FROZEN_MASTER_SN(
                                                 PLAN_ID
                                                ,DIVISION_ID
                                                ,FROZEN_TYPE
                                                ,SYS_DIVS_CD
                                                ,PLAN_TYPE
                                                ,PLAN_SEQ
                                                ,PLAN_YYYYMMDD
                                                ,STAGE
                                                ,FROZEN_START_DATE
                                                ,FROZEN_END_DATE
                                                ,FROZEN_DAYS
                                                ,ATTRIBUTE1	
                                                )
        ----------------------생산 FROZEN----------------------
        -- 수동/조립/SCP/COATING&NND
        SELECT  @V_PLAN_ID            AS PLAN_ID
               ,@V_DIVISION_ID        AS DIVISION_ID
               ,'PROD'                AS FROZEN_TYPE
               ,'SCP'                 AS SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE      AS PLAN_TYPE
               ,@V_SCP_PLAN_SEQ       AS PLAN_SEQ
			   --,'FP'				  AS SYS_DIVS_CD
			   --,'CUT_OFF'			  AS PLAN_TYPE
			   --,NULL				  AS PLAN_SEQ
               ,@V_SCP_PLAN_DATE      AS PLAN_YYYYMMDD
               ,STAGE                 AS STAGE
               ,FROZEN_START_YYYYMMDD AS FROZEN_START_DATE
               ,FROZEN_END_YYYYMMDD   AS FROZEN_END_DATE
               ,FROZEN_DAYS           AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE     AS ATTRIBUTE1
        FROM    @PROD_FROZEN
        WHERE   1=1
        AND     FROZEN_START_YYYYMMDD IS NOT NULL
        AND     FROZEN_END_YYYYMMDD   IS NOT NULL
        AND     FROZEN_DAYS           IS NOT NULL
        UNION ALL
        -- UI/조립/FP&SCP/PACK
        SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
               ,@V_DIVISION_ID               AS DIVISION_ID
               ,'PROD'                       AS FROZEN_TYPE
               ,PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE             AS PLAN_TYPE
               ,@V_SCP_PLAN_SEQ              AS PLAN_SEQ
               ,@V_SCP_PLAN_DATE             AS PLAN_YYYYMMDD
               ,'COATING'                       AS STAGE
               ,CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
               ,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112)) AS FROZEN_END_DATE
               ,DATEDIFF(DAY,CELL_PROD_FRZ_START_YYYYMMDD,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112))) AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
        FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK) 
        WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
        AND     CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
        AND     CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        UNION ALL
        -- UI/조립/FP&SCP/MDLE
        SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
               ,@V_DIVISION_ID               AS DIVISION_ID
               ,'PROD'                       AS FROZEN_TYPE
               ,PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE             AS PLAN_TYPE
               ,@V_SCP_PLAN_SEQ              AS PLAN_SEQ
               ,@V_SCP_PLAN_DATE             AS PLAN_YYYYMMDD
               ,'NND'                       AS STAGE
               ,CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
               ,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112)) AS FROZEN_END_DATE
               ,DATEDIFF(DAY,CELL_PROD_FRZ_START_YYYYMMDD,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112))) AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
        FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK) 
        WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
        AND     CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
        AND     CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        --UNION ALL
        -- UI/조립/FP&SCP/CELL
        /*SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
               ,@V_DIVISION_ID               AS DIVISION_ID
               ,'PROD'                       AS FROZEN_TYPE
               ,PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE             AS PLAN_TYPE
               ,@V_SCP_PLAN_SEQ              AS PLAN_SEQ
               ,@V_SCP_PLAN_DATE             AS PLAN_YYYYMMDD
               ,'ASSY'                       AS STAGE
               ,CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
               ,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112))    AS FROZEN_END_DATE
               ,DATEDIFF(DAY,CELL_PROD_FRZ_START_YYYYMMDD,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD))) AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
        FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK) 
        WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
        AND     CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
        AND     CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL*/
		--SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
  --             ,@V_DIVISION_ID               AS DIVISION_ID
  --             ,'PROD'                       AS FROZEN_TYPE
  --             ,PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
  --             ,@V_SCP_PLAN_TYPE             AS PLAN_TYPE
  --             ,@V_SCP_PLAN_SEQ              AS PLAN_SEQ
  --             ,@V_SCP_PLAN_DATE             AS PLAN_YYYYMMDD
  --             ,'ASSY'                       AS STAGE
  --             ,CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
  --             ,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112)) AS FROZEN_END_DATE
  --             ,DATEDIFF(DAY,CELL_PROD_FRZ_START_YYYYMMDD,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112))) AS FROZEN_DAY
  --             ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
  --      FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK) 
  --      WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
  --      AND     CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
  --      AND     CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
		--UNION ALL
		--SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
  --             ,@V_DIVISION_ID               AS DIVISION_ID
  --             ,'PROD'                       AS FROZEN_TYPE
  --             ,PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
  --             ,@V_SCP_PLAN_TYPE             AS PLAN_TYPE
  --             ,@V_SCP_PLAN_SEQ              AS PLAN_SEQ
  --             ,@V_SCP_PLAN_DATE             AS PLAN_YYYYMMDD
  --             ,'STK'                       AS STAGE
  --             ,CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
  --             ,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112)) AS FROZEN_END_DATE
  --             ,DATEDIFF(DAY,CELL_PROD_FRZ_START_YYYYMMDD,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112))) AS FROZEN_DAY
  --             ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
  --      FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK) 
  --      WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
  --      AND     CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
  --      AND     CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
		--UNION ALL
		--SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
  --             ,@V_DIVISION_ID               AS DIVISION_ID
  --             ,'PROD'                       AS FROZEN_TYPE
  --             ,PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
  --             ,@V_SCP_PLAN_TYPE             AS PLAN_TYPE
  --             ,@V_SCP_PLAN_SEQ              AS PLAN_SEQ
  --             ,@V_SCP_PLAN_DATE             AS PLAN_YYYYMMDD
  --             ,'EOL'                        AS STAGE
  --             ,CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
  --             ,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112)) AS FROZEN_END_DATE
  --             ,DATEDIFF(DAY,CELL_PROD_FRZ_START_YYYYMMDD,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112))) AS FROZEN_DAY
  --             ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
  --      FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK) 
  --      WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
  --      AND     CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
  --      AND     CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        ----------------------생산 FROZEN END----------------------
        ----------------------출하 FROZEN START----------------------
        -- MANUAL/조립/SCP
        UNION ALL
        SELECT  @V_PLAN_ID            AS PLAN_ID
               ,@V_DIVISION_ID        AS DIVISION_ID
               ,'SHIP'                AS FROZEN_TYPE
               ,'SCP'                 AS SYS_DIVS_CD
               ,@V_SHIP_SCP_PLAN_TYPE AS PLAN_TYPE
               ,@V_SHIP_SCP_PLAN_SEQ  AS PLAN_SEQ
			   --,'SSP'                 AS SYS_DIVS_CD
      --         ,NULL				  AS PLAN_TYPE
      --         ,NULL				  AS PLAN_SEQ
               ,NULL				  AS PLAN_YYYYMMDD
               ,STAGE                 AS STAGE
               ,FROZEN_START_YYYYMMDD AS FROZEN_START_DATE
               ,FROZEN_END_YYYYMMDD   AS FROZEN_END_DATE
               ,FROZEN_DAYS           AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE     AS ATTRIBUTE1
        FROM    @SHIP_FROZEN
        WHERE   1=1
        AND     FROZEN_START_YYYYMMDD IS NOT NULL
        AND     FROZEN_END_YYYYMMDD   IS NOT NULL
        AND     FROZEN_DAYS           IS NOT NULL
        UNION ALL
        -- UI/조립/SCP&SSP
        SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
               ,@V_DIVISION_ID               AS DIVISION_ID
               ,'SHIP'                       AS FROZEN_TYPE
               ,SHIP_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
               ,@V_SHIP_SCP_PLAN_TYPE        AS PLAN_TYPE
               ,@V_SHIP_SCP_PLAN_SEQ         AS PLAN_SEQ
               ,@V_SHIP_SCP_PLAN_DATE        AS PLAN_YYYYMMDD
               ,'SHIP'                       AS STAGE
               ,SHIP_FRZ_START_YYYYMMDD      AS FROZEN_START_DATE
               ,IIF(SHIP_FRZ_END_YYYYMMDD='',SHIP_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,SHIP_FRZ_END_YYYYMMDD),112)) AS FROZEN_END_DATE
               ,DATEDIFF(DAY,SHIP_FRZ_START_YYYYMMDD,IIF(SHIP_FRZ_END_YYYYMMDD='',SHIP_FRZ_START_YYYYMMDD,DATEADD(DAY,1,SHIP_FRZ_END_YYYYMMDD)))   AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
        FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK) 
        WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
        AND     SHIP_FRZ_START_YYYYMMDD IS NOT NULL
        AND     SHIP_FRZ_END_YYYYMMDD   IS NOT NULL
        ----------------------출하 FROZEN END----------------------
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


create PROCEDURE [dbo].[PR_XIF_FP_RELEASE_PLAN_SYNC_R_after]

-- ================================================================================================
-- Program ID          :
-- Program Name        : PR_XIF_FP_RELEASE_PLAN_SYNC_R
-- Param               :
-- Batch Period        : 10분
-- Description         : WA법인 FP 배포(Release)계획 오창 반영
--
-- Source System       : 오창 FP
-- Destination System  : WA FP
-- Source Table        : XIF_FP_RELEASE_PLAN_SYNC_R
-- Destination Table   : FP_DAILY_PRODUCTIOIN_PLAN_H
--
-- Create(Update) Date : 2023.10.27
-- Author              : JYJ
-- Version             : 1.0 Initial
--                       1.1 2023.10.27 kimcd  조립 하위 복수 배포되는 경우 보완
--                       1.2 2025.04.01 FP Pjt. 속도개선
-- ================================================================================================

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name             NVARCHAR(100) = 'PR_XIF_FP_RELEASE_PLAN_SYNC_R'
	DECLARE @v_descr                 NVARCHAR(250)
	DECLARE @v_count                 INTEGER	    = 0
	DECLARE @sysdate                 DATETIME2      = GETDATE()
	DECLARE @PROC_MSG                NVARCHAR(1000) = NULL;
	DECLARE @PROC_FLAG               NVARCHAR(50)   = 'N';
	-- ERROR_LINE
	DECLARE @v_temp1                 NVARCHAR(1000)
	DECLARE @v_temp2                 NVARCHAR(1000)
	DECLARE @INX                     INTEGER = 0;
    DECLARE @MAX_NUM                 INTEGER = 0;
	--변수 설정
	DECLARE @INSTANCE_ID             NVARCHAR(30)
	DECLARE @RELEASE_PLAN_ID         NVARCHAR(30)
	DECLARE @PLAN_GROUP_ID           NVARCHAR(30)
	DECLARE @PLAN_MAKE_DATE          NVARCHAR(8)
	DECLARE @GNRT_DTTM               DATETIME

    DECLARE @TAB TABLE
    (
        [TID]                  INT IDENTITY(1,1)    NOT NULL PRIMARY KEY,
        [INSTANCE_ID]          [NVARCHAR](30),
        [RELEASE_PLAN_ID]      [NVARCHAR](30),
        [PLAN_GROUP_ID]        [NVARCHAR](30),
		[PLAN_MAKE_DATE]       [NVARCHAR](8),
		[GNRT_DTTM]            DATETIME
    );

	----중복 실행 방지
	declare @lock_result INT;

	select @lock_result = count(*) --o.name
		from sys.dm_exec_requests as r with(nolock)
			cross apply  sys.dm_exec_sql_text(r.sql_handle) as st 
			JOIN SYS.OBJECTS as o  with(nolock)
		on st.objectid = o.object_id 
		and o.type = 'P'
		where object_name(st.objectid) is not null
		--and qs.status = 'runnable'
		and o.name = @v_proc_name
		and r.database_id = db_id()

	--PRINT @lock_result

	if @lock_result > 1
	BEGIN
	    PRINT 'The Procedure is already running.'
		return 0;
	END
	--

	if object_id('tempdb..#LAST_RELEASE') is not null
		drop table #LAST_RELEASE

	create table #LAST_RELEASE (
		INSTANCE_ID				NVARCHAR(30),
		RELEASE_PLAN_ID			NVARCHAR(30),
		[PLAN_GROUP_ID]			NVARCHAR(30),
		PLAN_MAKE_DATE			NVARCHAR(50),
		GNRT_DTTM				DATETIME
	)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- PROC_FLAG = 'N' 인터페이스된 데이타 추출
PRINT '-------------Plan : 100 ' +  CONVERT(CHAR(23), getdate(), 21)

	INSERT INTO @TAB (
           [INSTANCE_ID] 
		 , [RELEASE_PLAN_ID]
		 , [PLAN_GROUP_ID]
		 , [PLAN_MAKE_DATE]
		 , [GNRT_DTTM]
         )
    SELECT M.INSTANCE_ID
    	 , M.RELEASE_PLAN_ID
    	 , M.PLAN_GROUP_ID
    	 , MAX(M.PLAN_MAKE_DATE)   AS PLAN_MAKE_DATE
    	 , M.GNRT_DTTM             AS GNRT_DTTM
      FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R AS M
     WHERE 1 = 1
       AND M.PROC_FLAG = 'N'
       AND NOT EXISTS (  -- 과거에 처리되지 않은 건수체크가 false인 instance, plan_group 데이터는 처리 제외 (RTS_CELL_04는 처리되지 않고 있음)
	                  SELECT 1 
                        FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R AS S
    				   WHERE S.[INSTANCE_ID]   = M.[INSTANCE_ID]
    					 AND S.[PLAN_GROUP_ID] = M.[PLAN_GROUP_ID]
    					 AND S.PROC_FLAG       = 'N'
    					 AND S.GNRT_DTTM       < M.GNRT_DTTM
    				   GROUP BY  
					         S.INSTANCE_ID
						   , S.RELEASE_PLAN_ID
						   , S.PLAN_GROUP_ID
						   , S.GNRT_DTTM  -- 2023-10-27  kimcd  작업 시간을 GROUP BY에 추가
    				  HAVING MAX(S.ACCUM_COUNT) != COUNT(*) 
					  )
     GROUP BY 
	       M.INSTANCE_ID
    	 , M.RELEASE_PLAN_ID
         , M.PLAN_GROUP_ID
		 , M.GNRT_DTTM  -- 2023-10-27  kimcd  작업 시간을 GROUP BY에 추가
    HAVING MAX(M.ACCUM_COUNT) = COUNT(*)
     ORDER BY 5

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

PRINT '-------------Plan : 200 ' +  CONVERT(CHAR(23), getdate(), 21)


    SELECT @INX     = 1
         , @MAX_NUM = COUNT(*)
      FROM @TAB;

	WHILE @INX <= @MAX_NUM
    BEGIN

	    BEGIN TRY
		    BEGIN TRAN

            BEGIN
                SELECT @INSTANCE_ID			= INSTANCE_ID         
                     , @RELEASE_PLAN_ID		= RELEASE_PLAN_ID       
                     , @PLAN_GROUP_ID		= PLAN_GROUP_ID
				     , @PLAN_MAKE_DATE		= PLAN_MAKE_DATE
				     , @GNRT_DTTM			= GNRT_DTTM
                  FROM @TAB
                 WHERE TID = @INX
				   ;

			 	--UPDATE [dbo].[SY_XIF_FP_RELEASE_PLAN_SYNC_R] 
				 --  SET PROC_FLAG			= 'P'
     --            WHERE PROC_FLAG			= 'N'
     --              AND INSTANCE_ID			= @INSTANCE_ID
     --              AND RELEASE_PLAN_ID		= @RELEASE_PLAN_ID
     --              AND PLAN_GROUP_ID		= @PLAN_GROUP_ID
				 --  AND GNRT_DTTM			= @GNRT_DTTM  -- 2023-10-27  kimcd 정보 형성 시간을 조건에 추가
				 --  ;

PRINT '-------------Plan : 000 ' +  CONVERT(CHAR(23), getdate(), 21)

                UPDATE A 
				   SET [PLAN_QTY]                = 0
                     , [PLAN_IN_QTY]             = 0
                     , [ROLL_IN_QTY]             = 0
                     , [ROLL_OUT_QTY]            = 0
                     , [JR_IN_QTY]               = 0
                     , [JR_OUT_QTY]              = 0
                     , [BATCH_IN_QTY]            = 0
                     , [BATCH_OUT_QTY]           = 0
                     , [CELL_IN_QTY]             = 0
                     , [CELL_OUT_QTY]            = 0
                     , [FULL_CLEANING_FLAG]      = NULL		
                     , [PIG_CLEANING_FLAG]	   = NULL
                     , [MODEL_TYPE_CHANGE_FLAG]  = NULL		
                     , [SEQ]					   = 0
                     , [CELL_MATERIAL_ID]        = NULL
                     , [TOTAL_BATCH]             = NULL
                     , [SETUP_COLOR_CODE]		   = '-'
                     , [UPDATE_ID]               = @v_proc_name
                     , [UPDATE_TIME]             = GETDATE()
                  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A 
                     , ( 
					   SELECT M.FACTORY_ID
                            , M.INSTANCE_TYPE
                            , M.LINE_ID
                 		    , M.OPERATION_ID
                 		    , M.ELECTRODE_TYPE
                 		    , M.PLAN_TYPE
						    , M.PLAN_GROUP_ID 
						    , M.INSTANCE_ID
                         FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R as M with(nolock)
                        WHERE 1 = 1
                        --  AND M.PROC_FLAG        = 'P'
                          AND M.INSTANCE_ID			= @INSTANCE_ID
                          AND M.RELEASE_PLAN_ID		= @RELEASE_PLAN_ID
                          AND M.PLAN_GROUP_ID		= @PLAN_GROUP_ID
					      AND M.GNRT_DTTM			= @GNRT_DTTM  -- 2023-10-27  kimcd 정보 형성 시간을 조건에 추가
                       ) B
                 WHERE A.FACTORY_ID			= B.FACTORY_ID
                   AND A.INSTANCE_TYPE		= B.INSTANCE_TYPE
                   AND A.PLAN_DATE			>= @PLAN_MAKE_DATE
                   AND A.PLAN_TYPE			= B.PLAN_TYPE
                   AND A.LINE_ID			= B.LINE_ID
                   AND A.OPERATION_ID		= B.OPERATION_ID
                --AND	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE --2023-06-20수정(제외)
	                ;

PRINT '-------------Plan : 001 ' +  CONVERT(CHAR(23), getdate(), 21)

			    -- MERGE TABLE
                MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H as DP
                USING ( 
                      SELECT  
                             A.COMPANY_ID
                           , A.DIVISION_ID
                           , A.SITE_ID
                           , A.PLANT_ID
                           , A.FACTORY_ID
                           , A.PLAN_GROUP_ID
                           , A.INSTANCE_TYPE
                           , A.TOP_ITEM_ID
                           , A.ITEM_ID
                           , A.OPERATION_ID
                           , A.LOCATION
                           , A.PRODUCTION_TYPE
                           , A.MARKET
                           , A.LINE_ID
                           , A.ELECTRODE_TYPE
                           , A.PLAN_DATE
                           , A.PLAN_QTY
                           , A.PLAN_IN_QTY
                           , A.PLAN_TYPE
                           , A.EQUIPMENT_ID
                           , A.FP_PRODUCTION_TYPE
                           , A.ROLL_IN_QTY
                           , A.ROLL_OUT_QTY
                           , A.JR_IN_QTY
                           , A.JR_OUT_QTY
                           , A.BATCH_IN_QTY
                           , A.BATCH_OUT_QTY
                           , A.CELL_IN_QTY
                           , A.CELL_OUT_QTY
                           , A.FULL_CLEANING_FLAG      -- 2018-09-14 kimcd 추가 풀 세척					
                           , A.PIG_CLEANING_FLAG		  -- 2018-12-20 PIYONG 추가 PIG 세정					
                           , A.MODEL_TYPE_CHANGE_FLAG  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
                           , A.SEQ                     -- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
                           , A.CELL_MATERIAL_ID        -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                           , A.TOTAL_BATCH             -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                           , A.SETUP_COLOR_CODE		  -- 2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                           , A.SHIFT                   -- 2021-01-27 kimcd 시업 시간 shift추가
                           , A.[WORK_REQUEST_MODEL_ID]
                           , A.[VERSION]
                           , A.[PROD_SEQ]
                           , A.[PLM_EC_NO]             -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
						   , A.[INSTANCE_ID]
                        FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R as A with(nolock)
                       WHERE 1 = 1
                       --  AND A.PROC_FLAG        = 'P'
                         AND A.INSTANCE_ID      = @INSTANCE_ID
                         AND A.RELEASE_PLAN_ID  = @RELEASE_PLAN_ID
                         AND A.PLAN_GROUP_ID    = @PLAN_GROUP_ID
						 AND A.GNRT_DTTM        = @GNRT_DTTM  -- 2023-10-27  kimcd 정보 형성 시간을 조건에 추가
                         AND A.PLAN_QTY         > 0 
			          ) B
                   ON (        
				      DP.[FACTORY_ID]            = B.[FACTORY_ID]
                  AND DP.[INSTANCE_TYPE]         = B.[INSTANCE_TYPE]
                  AND DP.[PLAN_TYPE]             = B.[PLAN_TYPE]
                  AND DP.[ITEM_ID]               = B.[ITEM_ID]
                  AND DP.[LINE_ID]               = B.[LINE_ID]
                  AND DP.[PLAN_DATE]             = B.[PLAN_DATE]
                  AND DP.[TOP_ITEM_ID]           = B.[TOP_ITEM_ID]
                  AND DP.[OPERATION_ID]          = B.[OPERATION_ID]
                  AND DP.[FP_PRODUCTION_TYPE]    = B.[FP_PRODUCTION_TYPE]
                  AND DP.[MARKET]                = B.[MARKET]
                  AND DP.[EQUIPMENT_ID]          = B.[EQUIPMENT_ID]
                  AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
                  AND DP.[VERSION]               = B.[VERSION]
                  AND DP.[PROD_SEQ]              = B.[PROD_SEQ]
                  AND DP.[PLM_EC_NO]             = B.[PLM_EC_NO] -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
                  )
                 WHEN MATCHED THEN
					UPDATE 
					   SET DP.[PRODUCTION_TYPE]         = B.[PRODUCTION_TYPE]
                         , DP.[ELECTRODE_TYPE]          = B.[ELECTRODE_TYPE]
                         , DP.[PLAN_QTY]                = B.[PLAN_QTY]
                         , DP.[PLAN_IN_QTY]             = B.[PLAN_IN_QTY]
                         , DP.[ROLL_IN_QTY]             = B.[ROLL_IN_QTY]
                         , DP.[ROLL_OUT_QTY]            = B.[ROLL_OUT_QTY]
                         , DP.[JR_IN_QTY]               = B.[JR_IN_QTY]
                         , DP.[JR_OUT_QTY]              = B.[JR_OUT_QTY]
                         , DP.[BATCH_IN_QTY]            = B.[BATCH_IN_QTY]
                         , DP.[BATCH_OUT_QTY]           = B.[BATCH_OUT_QTY]
                         , DP.[CELL_IN_QTY]             = B.[CELL_IN_QTY]
                         , DP.[CELL_OUT_QTY]            = B.[CELL_OUT_QTY]
                         , DP.[FULL_CLEANING_FLAG]      = B.[FULL_CLEANING_FLAG]		-- 2018-09-14 kimcd 추가 풀 세척					
                         , DP.[PIG_CLEANING_FLAG]       = B.[PIG_CLEANING_FLAG]		-- 2018-12-20 PIYONG 추가 PIG 세정				
                         , DP.[MODEL_TYPE_CHANGE_FLAG]  = B.[MODEL_TYPE_CHANGE_FLAG]	-- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
                         , DP.[SEQ]                     = B.[SEQ]						-- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
                         , DP.[CELL_MATERIAL_ID]        = B.[CELL_MATERIAL_ID]  -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                         , DP.[TOTAL_BATCH]             = B.[TOTAL_BATCH]       -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                         , DP.[SETUP_COLOR_CODE]        = B.SETUP_COLOR_CODE			--2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                         , DP.[PLAN_GROUP_ID]           = CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.INSTANCE_ID ELSE B.PLAN_GROUP_ID END -- 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 갱신하도록 함
                         , DP.[SHIFT]                   = B.[SHIFT] -- 2021-01-27 kimcd 시업 시간 shift 추가
                         , DP.[UPDATE_ID]               = @v_proc_name
                         , DP.[UPDATE_TIME]             = GETDATE()
                         , DP.[LOCATION]                = B.[LOCATION] -- 2022-06-09 kimcd LOCATION 항상 갱신하도록 추가
                 WHEN NOT MATCHED THEN
					INSERT (     
					       [COMPANY_ID]
                         , [DIVISION_ID]
                         , [SITE_ID]
                         , [PLANT_ID]
                         , [FACTORY_ID]
                         , [PLAN_GROUP_ID]
                         , [INSTANCE_TYPE]
                         , [TOP_ITEM_ID]
                         , [ITEM_ID]
                         , [OPERATION_ID]
                         , [LOCATION]
                         , [PRODUCTION_TYPE]
                         , [MARKET]
                         , [LINE_ID]
                         , [ELECTRODE_TYPE]
                         , [PLAN_DATE]
                         , [PLAN_QTY]
                         , [PLAN_IN_QTY]
                         , [INSERT_ID]
                         , [INSERT_TIME]
                         , [UPDATE_ID]
                         , [UPDATE_TIME]
                         , [PLAN_TYPE]               -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
                         , [EQUIPMENT_ID]            -- 2018-02-23 kimcd 설비 정보 추가
                         , [FP_PRODUCTION_TYPE]
                         , [ROLL_IN_QTY]
                         , [ROLL_OUT_QTY]
                         , [JR_IN_QTY]
                         , [JR_OUT_QTY]
                         , [BATCH_IN_QTY]
                         , [BATCH_OUT_QTY]
                         , [CELL_IN_QTY]
                         , [CELL_OUT_QTY]
                         , [FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척					
                         , [PIG_CLEANING_FLAG]		 -- 2018-12-20 PIYONG 추가 PIG 세정				
                         , [MODEL_TYPE_CHANGE_FLAG]	 -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
                         , [SEQ]                     -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
                         , [CELL_MATERIAL_ID]        -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                         , [TOTAL_BATCH]             -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                         , [SETUP_COLOR_CODE]        -- 2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                         , [SHIFT]                   -- 2021-01-27 kimcd 시업 시간 shift 추가
                         , [WORK_REQUEST_MODEL_ID]
                         , [VERSION]
                         , [PROD_SEQ]
                         , [PLM_EC_NO]               -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
                         ) 
				    VALUES (    
					       B.[COMPANY_ID]
                         , B.[DIVISION_ID]
                         , B.[SITE_ID]
                         , B.[PLANT_ID]
                         , B.[FACTORY_ID]
                         , CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.INSTANCE_ID ELSE B.PLAN_GROUP_ID END
                         , B.[INSTANCE_TYPE]
                         , B.[TOP_ITEM_ID]
                         , B.[ITEM_ID]
                         , B.[OPERATION_ID]
                         , B.[LOCATION]
                         , B.[PRODUCTION_TYPE]
                         , B.[MARKET]
                         , B.[LINE_ID]
                         , B.[ELECTRODE_TYPE]
                         , B.[PLAN_DATE]
                         , B.[PLAN_QTY]
                         , B.[PLAN_IN_QTY]
                         , @v_proc_name
                         , GETDATE()
                         , @v_proc_name
                         , GETDATE()
                         , B.[PLAN_TYPE]               -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
                         , B.[EQUIPMENT_ID]            -- 2018-02-23 kimcd 설비 정보 추가
                         , B.[FP_PRODUCTION_TYPE]
                         , B.[ROLL_IN_QTY]
                         , B.[ROLL_OUT_QTY]
                         , B.[JR_IN_QTY]
                         , B.[JR_OUT_QTY]
                         , B.[BATCH_IN_QTY]
                         , B.[BATCH_OUT_QTY]
                         , B.[CELL_IN_QTY]
                         , B.[CELL_OUT_QTY]
                         , B.[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척						
                         , B.[PIG_CLEANING_FLAG]       -- 2018-12-20 PIYONG 추가 PIG 세정					
                         , B.[MODEL_TYPE_CHANGE_FLAG]  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경		
                         , B.[SEQ]                     -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
                         , B.[CELL_MATERIAL_ID]        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                         , B.[TOTAL_BATCH]             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
                         , B.[SETUP_COLOR_CODE]        --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                         , B.[SHIFT]                   --2021-01-27 kimcd 시업 시간 shift 추가
                         , B.[WORK_REQUEST_MODEL_ID]
                         , B.[VERSION]
                         , B.[PROD_SEQ]
                         , B.[PLM_EC_NO]               -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
                         );

PRINT '-------------Plan : 002 ' +  CONVERT(CHAR(23), getdate(), 21)

				-- 2023-10-27 계획 합산 시작
				IF @INSTANCE_ID LIKE 'RTS_CELL%'
				BEGIN

				    DELETE FROM #LAST_RELEASE;

					INSERT INTO #LAST_RELEASE (
						   INSTANCE_ID
						 , RELEASE_PLAN_ID
						 , A.PLAN_GROUP_ID
						 , PLAN_MAKE_DATE
						 , GNRT_DTTM
						 )
					SELECT A.INSTANCE_ID
                    	 , A.RELEASE_PLAN_ID
						 , A.PLAN_GROUP_ID
                    	 , A.PLAN_MAKE_DATE
                    	 , A.GNRT_DTTM
                     FROM ( 
						  --SELECT A.INSTANCE_ID
        --            		   , A.RELEASE_PLAN_ID
        --            		   , A.PLAN_MAKE_DATE
        --            		   , A.GNRT_DTTM
        --            		   , ROW_NUMBER() OVER (PARTITION BY A.INSTANCE_ID ORDER BY A.GNRT_DTTM DESC) AS ROW_NUM
        --            		FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R as A with(nolock)
        --            	   WHERE A.PROC_FLAG         IN ('P', 'Y')
        --            		 AND A.INSTANCE_ID      LIKE 'RTS_CELL%'
        --            		 AND A.INSTANCE_ID      LIKE  SUBSTRING(@INSTANCE_ID, 1,8) + '%'
        --            		 AND A.RELEASE_PLAN_ID  LIKE '%' + SUBSTRING(@PLAN_MAKE_DATE, 3,6)  + '%'

						  SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID, A.PLAN_GROUP_ID, A.PLAN_MAKE_DATE, A.GNRT_DTTM, ROW_NUMBER() OVER (PARTITION BY A.INSTANCE_ID ORDER BY A.GNRT_DTTM DESC) AS ROW_NUM
							FROM (
								  SELECT A.INSTANCE_ID
                    				   , A.RELEASE_PLAN_ID
									   , A.PLAN_GROUP_ID
                    				   , A.PLAN_MAKE_DATE
                    				   , A.GNRT_DTTM
                    				FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R as A with(nolock)
                    			   WHERE A.PROC_FLAG        = 'Y'
                    				 AND A.INSTANCE_ID      LIKE 'RTS_CELL%'
									 AND A.RELEASE_PLAN_ID  LIKE '%' + SUBSTRING(@PLAN_MAKE_DATE, 3,6)  + '%'
								   UNION ALL
								  SELECT A.INSTANCE_ID
                    				   , A.RELEASE_PLAN_ID
									   , A.PLAN_GROUP_ID
                    				   , A.PLAN_MAKE_DATE
                    				   , A.GNRT_DTTM
                    				FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R as A with(nolock)
                    			   WHERE 1 = 1
 									 --PROC_FLAG = 'P'
									 AND A.INSTANCE_ID      = @INSTANCE_ID
									 AND A.RELEASE_PLAN_ID  = @RELEASE_PLAN_ID
									 AND A.PLAN_GROUP_ID    = @PLAN_GROUP_ID
									 AND A.GNRT_DTTM        = @GNRT_DTTM  -- 2023-10-27  kimcd 정보 형성 시간을 조건에 추가
							     ) as A
                    	  ) A 
                    WHERE A.ROW_NUM = 1 
					;


                    UPDATE DP
                       SET DP.[PRODUCTION_TYPE]         = B.[PRODUCTION_TYPE]
                         , DP.[ELECTRODE_TYPE]          = B.[ELECTRODE_TYPE]
                         , DP.[PLAN_QTY]                = B.[PLAN_QTY]
                         , DP.[PLAN_IN_QTY]             = B.[PLAN_IN_QTY]
                         , DP.[ROLL_IN_QTY]             = B.[ROLL_IN_QTY]
                         , DP.[ROLL_OUT_QTY]            = B.[ROLL_OUT_QTY]
                         , DP.[JR_IN_QTY]               = B.[JR_IN_QTY]
                         , DP.[JR_OUT_QTY]              = B.[JR_OUT_QTY]
                         , DP.[BATCH_IN_QTY]            = B.[BATCH_IN_QTY]
                         , DP.[BATCH_OUT_QTY]           = B.[BATCH_OUT_QTY]
                         , DP.[CELL_IN_QTY]             = B.[CELL_IN_QTY]
                         , DP.[CELL_OUT_QTY]            = B.[CELL_OUT_QTY]
                         , DP.[SEQ]                     = B.[SEQ]
                         , DP.[CELL_MATERIAL_ID]        = B.[CELL_MATERIAL_ID]
                         , DP.[SHIFT]                   = B.[SHIFT]
                         , DP.[UPDATE_ID]               = @v_proc_name
                         , DP.[UPDATE_TIME]             = GETDATE()
                      FROM FP_DAILY_PRODUCTIOIN_PLAN_H as DP
                           INNER JOIN ( 
						              SELECT A.[FACTORY_ID] 
                                           , A.[INSTANCE_TYPE]
                                           , A.[PLAN_TYPE]
                                           , A.[ITEM_ID]
                                           , A.[LINE_ID]
                                           , A.[PLAN_DATE]
                                           , A.[TOP_ITEM_ID]
                                           , A.[OPERATION_ID]
                                           , A.[FP_PRODUCTION_TYPE]
                                           , A.[MARKET]
                                           , A.[EQUIPMENT_ID]
                                           , A.[WORK_REQUEST_MODEL_ID]
                                           , A.[VERSION]
                                           , A.[PROD_SEQ]
                                           , A.[PLM_EC_NO]
                                           , MAX(A.PRODUCTION_TYPE)     AS PRODUCTION_TYPE
                                           , MAX(A.ELECTRODE_TYPE)      AS ELECTRODE_TYPE
                                           , SUM(A.PLAN_QTY)            AS PLAN_QTY
                                           , SUM(A.PLAN_IN_QTY)         AS PLAN_IN_QTY
                                           , SUM(A.ROLL_IN_QTY)         AS ROLL_IN_QTY
                                           , SUM(A.ROLL_OUT_QTY)        AS ROLL_OUT_QTY
                                           , SUM(A.JR_IN_QTY)           AS JR_IN_QTY
                                           , SUM(A.JR_OUT_QTY)          AS JR_OUT_QTY
                                           , SUM(A.BATCH_IN_QTY)        AS BATCH_IN_QTY
                                           , SUM(A.BATCH_OUT_QTY)       AS BATCH_OUT_QTY
                                           , SUM(A.CELL_IN_QTY)         AS CELL_IN_QTY
                                           , SUM(A.CELL_OUT_QTY)        AS CELL_OUT_QTY
                                           , MAX(A.SEQ)                 AS SEQ
                                           , MAX(A.CELL_MATERIAL_ID)    AS CELL_MATERIAL_ID
                                           , MAX(A.SHIFT)               AS SHIFT
                                        FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R as A with(nolock)
                    	                     INNER JOIN #LAST_RELEASE as C
                                          ON C.INSTANCE_ID			= A.INSTANCE_ID
                                         AND C.RELEASE_PLAN_ID		= A.RELEASE_PLAN_ID
                                         --AND C.PLAN_MAKE_DATE		= A.PLAN_MAKE_DATE
										 AND C.PLAN_GROUP_ID        = A.PLAN_GROUP_ID
                                         AND C.GNRT_DTTM			= A.GNRT_DTTM 
                                             INNER JOIN ( 
											            SELECT B.FACTORY_ID, B.INSTANCE_TYPE, B.PLAN_TYPE, B.LINE_ID, B.OPERATION_ID
                                                          FROM [dbo].SY_XIF_FP_RELEASE_PLAN_SYNC_R as B with(nolock)
                                                               INNER JOIN  #LAST_RELEASE as A
                                                            ON B.INSTANCE_ID		= A.INSTANCE_ID
                                                           AND B.RELEASE_PLAN_ID	= A.RELEASE_PLAN_ID
                                                         --  AND B.PLAN_MAKE_DATE		= A.PLAN_MAKE_DATE
														   AND B.PLAN_GROUP_ID      = A.PLAN_GROUP_ID
                                                           AND B.GNRT_DTTM			= A.GNRT_DTTM 
                    	                                 GROUP BY B.FACTORY_ID, B.INSTANCE_TYPE, B.PLAN_TYPE, B.LINE_ID, B.OPERATION_ID
                    							        HAVING COUNT( DISTINCT B.RELEASE_PLAN_ID) > 1 ) B
                                          ON B.FACTORY_ID    = A.FACTORY_ID
                    					 AND B.INSTANCE_TYPE = A.INSTANCE_TYPE
                    					 AND B.PLAN_TYPE     = A.PLAN_TYPE
                    					 AND B.LINE_ID       = A.LINE_ID
                    					 AND B.OPERATION_ID  = A.OPERATION_ID
                    				   GROUP BY 
									         A.[FACTORY_ID]
                                           , A.[INSTANCE_TYPE]
                                           , A.[PLAN_TYPE]
                                           , A.[ITEM_ID]
                                           , A.[LINE_ID]
                                           , A.[PLAN_DATE]
                                           , A.[TOP_ITEM_ID]
                                           , A.[OPERATION_ID]
                                           , A.[FP_PRODUCTION_TYPE]
                                           , A.[MARKET]
                                           , A.[EQUIPMENT_ID]
                                           , A.[WORK_REQUEST_MODEL_ID]
                                           , A.[VERSION]
                                           , A.[PROD_SEQ]
                                           , A.[PLM_EC_NO] 
									  ) as B
                        ON DP.[FACTORY_ID]            = B.[FACTORY_ID]
                       AND DP.[INSTANCE_TYPE]         = B.[INSTANCE_TYPE]
                       AND DP.[PLAN_TYPE]             = B.[PLAN_TYPE]
                       AND DP.[ITEM_ID]               = B.[ITEM_ID]
                       AND DP.[LINE_ID]               = B.[LINE_ID]
                       AND DP.[PLAN_DATE]             = B.[PLAN_DATE]
                       AND DP.[TOP_ITEM_ID]           = B.[TOP_ITEM_ID]
                       AND DP.[OPERATION_ID]          = B.[OPERATION_ID]
                       AND DP.[FP_PRODUCTION_TYPE]    = B.[FP_PRODUCTION_TYPE]
                       AND DP.[MARKET]                = B.[MARKET]
                       AND DP.[EQUIPMENT_ID]          = B.[EQUIPMENT_ID]
                       AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
                       AND DP.[VERSION]               = B.[VERSION]
                       AND DP.[PROD_SEQ]              = B.[PROD_SEQ]
                       AND DP.[PLM_EC_NO]             = B.[PLM_EC_NO];
				-- 2023-10-27 계획 합산 종료 

				END

				--PROC_FLAG = Y
			 	UPDATE [dbo].[SY_XIF_FP_RELEASE_PLAN_SYNC_R] 
				   SET PROC_FLAG		= 'Y'
					 , PROC_DATE		= GETDATE()
                 WHERE 1 = 1
				   --and PROC_FLAG		= 'P'
                   AND INSTANCE_ID      = @INSTANCE_ID
                   AND RELEASE_PLAN_ID  = @RELEASE_PLAN_ID
                   AND PLAN_GROUP_ID    = @PLAN_GROUP_ID
				   AND GNRT_DTTM        = @GNRT_DTTM
				   ;

            END	

PRINT '-------------Plan : 003 ' +  CONVERT(CHAR(23), getdate(), 21)

			COMMIT TRAN

	    END TRY

	    BEGIN CATCH
	        ROLLBACK TRAN

		    -- 에러나도 로그는 인서트
		    SET @PROC_FLAG      = 'F'
            SET @PROC_MSG       = '[' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + '] ' + ERROR_MESSAGE()
		    SET @v_descr        = ERROR_MESSAGE()
		    
		    
		    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	    END CATCH

	    SET @INX = @INX + 1

    END

	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

	if object_id('tempdb..#LAST_RELEASE') is not null
		drop table #LAST_RELEASE

    SET NOCOUNT OFF
END

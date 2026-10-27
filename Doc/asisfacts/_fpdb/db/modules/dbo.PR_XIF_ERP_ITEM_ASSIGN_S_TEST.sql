 
 
CREATE PROCEDURE [dbo].[PR_XIF_ERP_ITEM_ASSIGN_S_TEST]

-- ================================================================================================
-- Program ID          : FP02490
-- Program Name        : PR_XIF_ERP_ITEM_ASSIGN_S
-- Param               :
-- Batch Period        : 15분
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : ERP
-- Source Table        : SCM_ITEM_LINE_ASSIGN_M
-- Destination Table   : XIF_ERP_ITEM_LINE_ASSIGN_S
--
-- Create Date		   : 2016.10.19
-- Update Date		   : 2018.12.03 piyong 1.1
--                       2022.07.14 kimcd  1.2

-- Author              : 김 춘 동
-- Version             : 1.0
--						 1.1 전송 대상 기간 체크 로직 변경
--							 설비 수정일자 추가
--                       1.2 2022-07-14 kimcd ERP W/C 관리 기준으로 라인으로 변경함에 따라 수정
--                       1.3 2025-01-04 kimcd NERP 대상과 그외 법인 if seq no 분리
--                       1.4 2026-06-23 E20260526-000110 FP -> ERP Line assign 데이터 전송 로직 점검, E20260619-001605 ESOT Lineassign - tacttime 데이터 전송 건
-- ================================================================================================
	--@P_COMPANY_ID  NVARCHAR(30)
	@P_COMPANY_ID NVARCHAR(30) = 'NULL'
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_ITEM_ASSIGN_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME    = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	
	-- ================================================
    -- Declare start
	-- ================================================

	/*
	 * NETJOB에서 파라미터없이 실행시 문자가아닌 NULL로 실행되도록 추가
	 */
	IF @P_COMPANY_ID = 'NULL'
		SET @P_COMPANY_ID = NULL

	
	DECLARE @IFSEQNO            NVARCHAR(50);
	DECLARE @NERPIFSEQNO        NVARCHAR(50);   -- 2025-01-04 kimcd NERP 대상과 그외 법인 if seq no 분리
	--DECLARE @NUM			    NUMERIC(10);
	DECLARE @COMPANY_ID		 NVARCHAR(30);
	DECLARE @DIVISION_ID	 NVARCHAR(30);
	DECLARE @SITE_ID		 NVARCHAR(30);
	DECLARE @PLANT_ID		 NVARCHAR(30);
	DECLARE @BUILNO 		 NVARCHAR(30);
	DECLARE @OPERATION_ID	 NVARCHAR(30);
	DECLARE @LINE_ID		 NVARCHAR(30);
	DECLARE @ITEM_ID            NVARCHAR(150);
	DECLARE @WORK_CENTER        NVARCHAR(30);
	DECLARE @TACT_TIME          NUMERIC(18,4);
	DECLARE @PRIORITY           NVARCHAR(50);
	DECLARE @ACTIVE_FLAG        NVARCHAR(1);
	DECLARE @CHECK_BOM      NVARCHAR(1);
	DECLARE @RES_PLANT          NVARCHAR(40);
	DECLARE @NERP_FLAG          NVARCHAR(40); -- 2025-01-04   kimcd   NERP 대상 PLANT 구분
	
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				
		BEGIN TRAN

			DECLARE CUR_ERP_ROUTE CURSOR FOR
			--DECLARE @P_COMPANY_ID NVARCHAR(1) = NULL
			SELECT top 10 --ROW_NUMBER() OVER( ORDER BY ITEM_ID) AS NUM 
				   ILA.[COMPANY_ID]
				 , ILA.[DIVISION_ID]
				 , ILA.[SITE_ID]
				 , ILA.[PLANT_ID]
				 , ILA.[FACTORY_ID]             AS BUILNO
				 , ISNULL(SEQ.MES_LINE_ID,SEM.[MES_LINE_ID])            AS LINE_ID
				 , ILA.[OPERATION_ID]
				 , ILA.[ITEM_ID]
				 , ISNULL(SEQ.WORK_CENTER_ID,SEM.[WORK_CENTER_ID])         AS WORK_CENTER
				 , (SELECT MIN(TTM.[TACT_TIME])
					FROM   [DBO].[SCM_TACT_TIME_M]  TTM  WITH(NOLOCK)
					WHERE  TTM.[COMPANY_ID]     = ILA.[COMPANY_ID]
					AND    TTM.[DIVISION_ID]    = ILA.[DIVISION_ID]
					AND    TTM.[SITE_ID]        = ILA.[SITE_ID]
					AND    TTM.[PLANT_ID]       = ILA.[PLANT_ID]
					AND    TTM.[FACTORY_ID]     = ILA.[FACTORY_ID]
					AND    TTM.[OPERATION_ID]   = ILA.[OPERATION_ID]
					AND    TTM.[LINE_ID]        = MAX(ILA.[LINE_ID])
					AND    TTM.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
					AND    TTM.[ITEM_ID]        = ILA.[ITEM_ID]
					AND    TTM.[MONTH]          = MIN(ILA.[MONTH]) )   AS TACT_TIME
				 , MIN(ILA.[PRIORITY])          AS PRIORITY
				 , 'Y'                          AS ACTIVE_FLAG
				 , (SELECT TOP 1 'Y' 
					FROM   [DBO].[SCM_BOM_M]  BM  WITH(NOLOCK)
					WHERE  BM.PARENT_ITEM_ID = ILA.ITEM_ID
					AND    BM.DIVISION_ID    = ILA.DIVISION_ID
					AND    BM.SITE_ID        = ILA.SITE_ID
					AND    BM.PLANT_ID       = ILA.PLANT_ID
					AND    BM.COMPANY_ID     = ILA.COMPANY_ID
					AND    BM.EFF_END_DATE  >= DATEADD(DD, -1, GETDATE()) )  AS CHECK_BOM
				 , (SELECT TOP 1 LV.SEGMENT1 
					FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]     LV  WITH(NOLOCK)
						 , [DBO].[SCM_BOM_FOR_RES_SHARE_M]  BM  WITH(NOLOCK)
					WHERE  LV.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
					AND    LV.ACTIVE_FLAG      = 'Y'
					AND    LV.ATTRIBUTE3       = BM.PLANT_ID
					AND    BM.PARENT_ITEM_ID = ILA.ITEM_ID
					AND    BM.DIVISION_ID    = ILA.DIVISION_ID
					AND    BM.SITE_ID        = ILA.SITE_ID
					AND    BM.PLANT_ID       = ILA.PLANT_ID
					AND    BM.COMPANY_ID     = ILA.COMPANY_ID
					AND    BM.EFF_END_DATE  >= DATEADD(DD, -1, GETDATE()) ) AS RES_PLANT
				 , (SELECT 'Y' FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'NERP_PLANT' AND SLV.ACTIVE_FLAG = 'Y' AND SLV.SEGMENT1 = ILA.[PLANT_ID] )  
					AS NERP_FLAG -- 2025-01-04   kimcd   NERP 대상 PLANT 구분
			FROM   [DBO].[SCM_OPERATION_M]         SOM WITH(NOLOCK)
				  --,[DBO].[SCM_EQUIPMENT_M]         SEM WITH(NOLOCK)
				  ,[DBO].[SCM_LINE_M]              SEM WITH(NOLOCK)  -- 2022-07-14 kimcd ERP W/C 관리 기준으로 라인으로 변경함에 따라 수정
					LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]         SEQ WITH(NOLOCK)
		 			ON    SEM.[COMPANY_ID]     = SEQ.[COMPANY_ID]
					AND   SEM.[DIVISION_ID]    = SEQ.[DIVISION_ID]
					AND   SEM.[SITE_ID]        = SEQ.[SITE_ID]
					AND   SEM.[PLANT_ID]       = SEQ.[PLANT_ID]
					AND   SEM.[FACTORY_ID]     = SEQ.[FACTORY_ID]
					AND   SEM.[OPERATION_ID]   = SEQ.[OPERATION_ID]
					AND   SEM.[LINE_ID]        = SEQ.[LINE_ID]
					AND   SEM.[ELECTRODE_TYPE] = SEQ.[ELECTRODE_TYPE]
					AND   SEQ.[EQUIPMENT_TYPE]  = 'M'
				  ,[DBO].[SCM_ITEM_LINE_ASSIGN_M]  ILA WITH(NOLOCK)
			WHERE SEM.[COMPANY_ID]     = ILA.[COMPANY_ID]
			AND   SEM.[DIVISION_ID]    = ILA.[DIVISION_ID]
			AND   SEM.[SITE_ID]        = ILA.[SITE_ID]
			AND   SEM.[PLANT_ID]       = ILA.[PLANT_ID]
			AND   SEM.[FACTORY_ID]     = ILA.[FACTORY_ID]
			AND   SEM.[OPERATION_ID]   = ILA.[OPERATION_ID]
			AND   SEM.[LINE_ID]        = ILA.[LINE_ID]
			AND   SEM.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
			AND   SOM.[COMPANY_ID]     = SEM.[COMPANY_ID]
			AND   SOM.[DIVISION_ID]    = SEM.[DIVISION_ID]
			AND   SOM.[SITE_ID]        = SEM.[SITE_ID]
			AND   SOM.[OPERATION_ID]   = SEM.[OPERATION_ID]
			AND   SOM.[WO_FLAG]        = 'Y'
			-- AND SEM.[EQUIPMENT_TYPE]  = 'M'   -- block checking main equipment
			--AND   ( @P_COMPANY_ID IS NULL OR ILA.[COMPANY_ID] = @P_COMPANY_ID )
			--AND   ( ILA.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE())
			--		OR
			--		SEM.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE()) --2018-12-03 PIYONG ADD					
			--	  )
			GROUP BY ILA.[COMPANY_ID]
				   , ILA.[DIVISION_ID]
				   , ILA.[SITE_ID]
				   , ILA.[PLANT_ID]
				   , ILA.[FACTORY_ID]
				   , ISNULL(SEQ.MES_LINE_ID,SEM.[MES_LINE_ID])
				   , ILA.[OPERATION_ID]
				   , ILA.[ITEM_ID]
				   , ILA.[ELECTRODE_TYPE]
				   , ISNULL(SEQ.WORK_CENTER_ID,SEM.[WORK_CENTER_ID])
				   OPTION (RECOMPILE);

		SET @ROWCOUNT = @@ROWCOUNT

		-- ================================================
		-- 로직 추가 start
		-- ================================================
		SET @IFSEQNO = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','')
		SET @NERPIFSEQNO = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') + 'N'   -- 2025-01-04 kimcd NERP 대상과 그외 법인 if seq no 분리

		SET @v_temp1 = 'STEP OPEN MAIN CURSOR'
		OPEN CUR_ERP_ROUTE

        FETCH NEXT FROM CUR_ERP_ROUTE INTO  @COMPANY_ID
										 , @DIVISION_ID
										 , @SITE_ID
										 , @PLANT_ID
										 , @BUILNO
										 , @LINE_ID
										 , @OPERATION_ID
										 , @ITEM_ID
										 , @WORK_CENTER
										 , @TACT_TIME
										 , @PRIORITY
										 , @ACTIVE_FLAG
										 , @CHECK_BOM
										 , @RES_PLANT
										 , @NERP_FLAG; -- 2025-01-04   kimcd   NERP 대상 PLANT 구분

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			IF @CHECK_BOM = 'Y'
				BEGIN
				IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
					BEGIN
						SET @v_temp1 = 'STEP MERGE [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S]'
						MERGE INTO [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S] ILA
						USING ( SELECT CASE WHEN @NERP_FLAG  = 'Y' THEN @NERPIFSEQNO ELSE @IFSEQNO END AS  IFSEQNO -- 2025-01-04   kimcd   NERP 대상 PLANT 구분하여 IFSEQNO 설정  
									 , @PLANT_ID       AS  PLANT_ID
									 , @BUILNO         AS  BUILNO
									 , @OPERATION_ID   AS  OPERATION_ID
									 , @LINE_ID        AS  LINE_ID
									 , @ITEM_ID        AS  ITEM_ID
									 , @WORK_CENTER    AS  WORK_CENTER
									 , @TACT_TIME      AS  TACT_TIME
									 , @PRIORITY       AS  PRIORITY
									 , @ACTIVE_FLAG    AS  ACTIVE_FLAG
								) XXX  -- Item, Operation, Line, Work Center 
						ON (    ILA.[PLANT_ID]     = XXX.[PLANT_ID]
							AND ILA.[BUILNO]       = XXX.[BUILNO]
							AND ILA.[OPERATION_ID] = XXX.[OPERATION_ID]
							AND ILA.[LINE_ID]      = XXX.[LINE_ID]
							AND ILA.[ITEM_ID]      = XXX.[ITEM_ID]
							AND ILA.[WORK_CENTER]  = XXX.[WORK_CENTER])
						WHEN MATCHED THEN
							UPDATE SET ILA.[IFSEQNO]        = XXX.IFSEQNO
									 , ILA.[TACT_TIME]      = XXX.TACT_TIME
									 , ILA.[PRIORITY]       = XXX.PRIORITY
									 , ILA.[TRANSFER_FLAG]  = 'N'
									 , ILA.[TRANSFER_DATE]  = NULL
									 , ILA.[MODIFY_USER_ID] = @v_proc_name
									 , ILA.[MODIFY_DATE]    = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ( [IFSEQNO]
								   , [PLANT_ID]
								   , [BUILNO]
								   , [LINE_ID]
								   , [OPERATION_ID]
								   , [ITEM_ID]
								   , [WORK_CENTER]
								   , [TACT_TIME]
								   , [PRIORITY]
								   , [ACTIVE_FLAG]
								   , [TRANSFER_FLAG]
								   , [TRANSFER_DATE]
								   , [CREATE_USER_ID]
								   , [CREATE_DATE]
								   , [MODIFY_USER_ID]
								   , [MODIFY_DATE]
								   )
							VALUES ( XXX.IFSEQNO
									,@PLANT_ID
									,XXX.BUILNO
									,XXX.LINE_ID
									,XXX.OPERATION_ID
									,XXX.ITEM_ID
									,XXX.WORK_CENTER
									,XXX.TACT_TIME
									,XXX.PRIORITY
									,'Y'              -- ACTIVE_FLAG
									,'N'              -- TRANSFER_FLAG
									,NULL             -- TRANSFER_DATE
									,@v_proc_name
									,GETDATE()
									,@v_proc_name
									,GETDATE()
									);
					END; -- IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
				END;

			IF @RES_PLANT IS NOT NULL
				BEGIN
				IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
					BEGIN
						SET @v_temp1 = 'STEP MERGE [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S]'
						MERGE INTO [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S] ILA
						USING ( SELECT CASE WHEN @NERP_FLAG  = 'Y' THEN @NERPIFSEQNO ELSE @IFSEQNO END AS  IFSEQNO -- 2025-01-04   kimcd   NERP 대상 PLANT 구분하여 IFSEQNO 설정  
									 , @RES_PLANT      AS  PLANT_ID
									 , @BUILNO         AS  BUILNO
									 , @OPERATION_ID   AS  OPERATION_ID
									 , @LINE_ID        AS  LINE_ID
									 , @ITEM_ID        AS  ITEM_ID
									 , @WORK_CENTER    AS  WORK_CENTER
									 , @TACT_TIME      AS  TACT_TIME
									 , @PRIORITY       AS  PRIORITY
									 , @ACTIVE_FLAG    AS  ACTIVE_FLAG
								) XXX  -- Item, Operation, Line, Work Center 
						ON (    ILA.[PLANT_ID]     = XXX.[PLANT_ID]
							AND ILA.[BUILNO]       = XXX.[BUILNO]
							AND ILA.[OPERATION_ID] = XXX.[OPERATION_ID]
							AND ILA.[LINE_ID]      = XXX.[LINE_ID]
							AND ILA.[ITEM_ID]      = XXX.[ITEM_ID]
							AND ILA.[WORK_CENTER]  = XXX.[WORK_CENTER])
						WHEN MATCHED THEN
							UPDATE SET ILA.[IFSEQNO]        = XXX.IFSEQNO
									 , ILA.[TACT_TIME]      = XXX.TACT_TIME
									 , ILA.[PRIORITY]       = XXX.PRIORITY
									 , ILA.[TRANSFER_FLAG]  = 'N'
									 , ILA.[TRANSFER_DATE]  = NULL
									 , ILA.[MODIFY_USER_ID] = @v_proc_name
									 , ILA.[MODIFY_DATE]    = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ( [IFSEQNO]
								   , [PLANT_ID]
								   , [BUILNO]
								   , [LINE_ID]
								   , [OPERATION_ID]
								   , [ITEM_ID]
								   , [WORK_CENTER]
								   , [TACT_TIME]
								   , [PRIORITY]
								   , [ACTIVE_FLAG]
								   , [TRANSFER_FLAG]
								   , [TRANSFER_DATE]
								   , [CREATE_USER_ID]
								   , [CREATE_DATE]
								   , [MODIFY_USER_ID]
								   , [MODIFY_DATE]
								   )
							VALUES ( XXX.IFSEQNO
									,@RES_PLANT
									,XXX.BUILNO
									,XXX.LINE_ID
									,XXX.OPERATION_ID
									,XXX.ITEM_ID
									,XXX.WORK_CENTER
									,XXX.TACT_TIME
									,XXX.PRIORITY
									,'Y'              -- ACTIVE_FLAG
									,'N'              -- TRANSFER_FLAG
									,NULL             -- TRANSFER_DATE
									,@v_proc_name
									,GETDATE()
									,@v_proc_name
									,GETDATE()
									);
					END; -- IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
				END;

			FETCH NEXT FROM CUR_ERP_ROUTE INTO  @COMPANY_ID
											 , @DIVISION_ID
											 , @SITE_ID
											 , @PLANT_ID
											 , @BUILNO
											 , @LINE_ID
											 , @OPERATION_ID
											 , @ITEM_ID
											 , @WORK_CENTER
											 , @TACT_TIME
											 , @PRIORITY
											 , @ACTIVE_FLAG
											 , @CHECK_BOM
											 , @RES_PLANT
											 , @NERP_FLAG; -- 2025-01-04   kimcd   NERP 대상 PLANT 구분

		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_ERP_ROUTE;
        DEALLOCATE CUR_ERP_ROUTE;   -- 메모리 해제


		-- ================================================
		-- IFSEQNO 5000개씩 나눠줌
		-- ================================================

		SET @v_temp1 = 'STEP SEQ CHANGE'
		;WITH CTE_UPDATE_SEQ AS (
			SELECT 
				IFSEQNO,
				ROW_NUMBER() OVER (PARTITION BY IFSEQNO ORDER BY (SELECT NULL)) AS RowNum
			FROM SY_XIF_ERP_ITEM_LINE_ASSIGN_S
			WHERE IFSEQNO LIKE @IFSEQNO +'%' 
		)
		UPDATE CTE_UPDATE_SEQ
		   SET IFSEQNO = CASE WHEN RIGHT(IFSEQNO, 1) = 'N' THEN CONVERT(NVARCHAR(20), CAST(SUBSTRING(IFSEQNO, 1, LEN(IFSEQNO) - 1) AS BIGINT) + ((RowNum - 1) / 5000)) + 'N'
			                  ELSE CONVERT(NVARCHAR(20), CAST(IFSEQNO AS BIGINT) + ((RowNum - 1) / 5000)) END
		WHERE RowNum > 5000;



		SET @v_temp1 = 'STEP END PROCEDURE'
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'LOG', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @data_s = CURSOR_STATUS('global','CUR_ERP_ROUTE')
		IF @data_s IN (1,0)
						 BEGIN
		                     CLOSE CUR_ERP_ROUTE;
                             DEALLOCATE CUR_ERP_ROUTE;   -- 메모리 해제
                         END
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH


	/**************************************************************/
	/*E20260526-000110 FP -> ERP Line assign 데이터 전송 로직 점검*/
	/**************************************************************/

	SET @sysdate = GETDATE()
	SET @v_temp1 = 'BOM'
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'LOG', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate


	BEGIN TRY				
		BEGIN TRAN
			DECLARE CUR_ERP_ROUTE2 CURSOR FOR
			    --DECLARE @P_COMPANY_ID NVARCHAR(1) = NULL
				SELECT   * 
				FROM(
								SELECT --ROW_NUMBER() OVER( ORDER BY ITEM_ID) AS NUM ,
								   ILA.[COMPANY_ID]
								 , ILA.[DIVISION_ID]
								 , ILA.[SITE_ID]
								 , ILA.[PLANT_ID]
								 , ILA.[FACTORY_ID]             AS BUILNO
								 , SEQ.[MES_LINE_ID]            AS LINE_ID
								 , ILA.[OPERATION_ID]
								 , ILA.[ITEM_ID]
								 , SEQ.[WORK_CENTER_ID]         AS WORK_CENTER
								 , (SELECT MIN(TTM.[TACT_TIME])
									FROM   [DBO].[SCM_TACT_TIME_M]  TTM  WITH(NOLOCK)
									WHERE  TTM.[COMPANY_ID]     = ILA.[COMPANY_ID]
									AND    TTM.[DIVISION_ID]    = ILA.[DIVISION_ID]
									AND    TTM.[SITE_ID]        = ILA.[SITE_ID]
									AND    TTM.[PLANT_ID]       = ILA.[PLANT_ID]
									AND    TTM.[FACTORY_ID]     = ILA.[FACTORY_ID]
									AND    TTM.[OPERATION_ID]   = ILA.[OPERATION_ID]
									AND    TTM.[LINE_ID]        = MAX(ILA.[LINE_ID])
									AND    TTM.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
									AND    TTM.[ITEM_ID]        = ILA.[ITEM_ID]
									AND    TTM.[MONTH]          = MIN(ILA.[MONTH]) )   AS TACT_TIME
								 , MIN(ILA.[PRIORITY])          AS PRIORITY
								 , 'Y'                          AS ACTIVE_FLAG
								 , 'Y'                          AS CHECK_BOM
								 , (SELECT TOP 1 LV.SEGMENT1 
									FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]     LV  WITH(NOLOCK)
										 , [DBO].[SCM_BOM_FOR_RES_SHARE_M]  BM  WITH(NOLOCK)
									WHERE  LV.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
									AND    LV.ACTIVE_FLAG      = 'Y'
									AND    LV.ATTRIBUTE3       = BM.PLANT_ID
									AND    BM.PARENT_ITEM_ID = ILA.ITEM_ID
									AND    BM.DIVISION_ID    = ILA.DIVISION_ID
									AND    BM.SITE_ID        = ILA.SITE_ID
									AND    BM.PLANT_ID       = ILA.PLANT_ID
									AND    BM.COMPANY_ID     = ILA.COMPANY_ID
									AND    BM.EFF_END_DATE  >= DATEADD(DD, -1, GETDATE()) ) AS RES_PLANT
								 , (SELECT 'Y' FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'NERP_PLANT' AND SLV.ACTIVE_FLAG = 'Y' AND SLV.SEGMENT1 = ILA.[PLANT_ID] )  
									AS NERP_FLAG -- 2025-01-04   kimcd   NERP 대상 PLANT 구분
							FROM   [DBO].[SCM_OPERATION_M]         SOM WITH(NOLOCK)
								 -- ,[DBO].[SCM_EQUIPMENT_M]         SEQ WITH(NOLOCK)
								  ,[DBO].[SCM_ITEM_LINE_ASSIGN_M]  ILA WITH(NOLOCK)
								  LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] SEQ WITH(NOLOCK)
									ON  SEQ.[COMPANY_ID]     = ILA.[COMPANY_ID]
									AND SEQ.[DIVISION_ID]    = ILA.[DIVISION_ID]
									AND SEQ.[SITE_ID]        = ILA.[SITE_ID]
									AND SEQ.[PLANT_ID]       = ILA.[PLANT_ID]
									AND SEQ.[FACTORY_ID]     = ILA.[FACTORY_ID]
									AND SEQ.[OPERATION_ID]   = ILA.[OPERATION_ID]
									AND SEQ.[LINE_ID]        = ILA.[LINE_ID]
									AND SEQ.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
									AND SEQ.[EQUIPMENT_TYPE] = 'M'
									AND SEQ.[ACTIVE_FLAG]    = 'Y'
								 ,[DBO].[SCM_BOM_M]               BM  WITH(NOLOCK)
							WHERE 1=1
							AND   SOM.[COMPANY_ID]     = SEQ.[COMPANY_ID]
							AND   SOM.[DIVISION_ID]    = SEQ.[DIVISION_ID]
							AND   SOM.[SITE_ID]        = SEQ.[SITE_ID]
							AND   SOM.[OPERATION_ID]   = SEQ.[OPERATION_ID]
							AND   SOM.[WO_FLAG]        = 'Y'
							AND   BM.PARENT_ITEM_ID    = ILA.ITEM_ID
							AND   BM.DIVISION_ID       = ILA.DIVISION_ID
							AND   BM.SITE_ID           = ILA.SITE_ID
							AND   BM.PLANT_ID          = ILA.PLANT_ID
							AND   BM.COMPANY_ID        = ILA.COMPANY_ID
							AND   BM.EFF_END_DATE     >= DATEADD(DD, -1, GETDATE())
							AND   BM.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE())     -- 2026-06-18 BOM UPDATE_TIME 체크
							AND   NOT EXISTS ( SELECT TOP 1 1 
														   FROM   [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S] EILS WITH(NOLOCK)
														   WHERE  EILS.[PLANT_ID]     = ILA.[PLANT_ID]
														   AND    EILS.[BUILNO]       = ILA.[FACTORY_ID]
														   AND    EILS.[OPERATION_ID] = ILA.[OPERATION_ID]
														   AND    EILS.[LINE_ID]      = SEQ.[MES_LINE_ID]
														   AND    EILS.[ITEM_ID]      = ILA.[ITEM_ID]
														   AND    EILS.[WORK_CENTER]  = SEQ.[WORK_CENTER_ID])
							AND   ( @P_COMPANY_ID IS NULL OR BM.[COMPANY_ID] = @P_COMPANY_ID )
							GROUP BY ILA.[COMPANY_ID]
								   , ILA.[DIVISION_ID]
								   , ILA.[SITE_ID]
								   , ILA.[PLANT_ID]
								   , ILA.[FACTORY_ID]
								   , SEQ.[MES_LINE_ID]
								   , ILA.[OPERATION_ID]
								   , ILA.[ITEM_ID]
								   , ILA.[ELECTRODE_TYPE]
								   , SEQ.[WORK_CENTER_ID]
					 UNION 
								 --DECLARE @P_COMPANY_ID NVARCHAR(1) = NULL
								   SELECT --ROW_NUMBER() OVER( ORDER BY ITEM_ID) AS NUM ,
								   ILA.[COMPANY_ID]
								 , ILA.[DIVISION_ID]
								 , ILA.[SITE_ID]
								 , ILA.[PLANT_ID]
								 , ILA.[FACTORY_ID]             AS BUILNO
								 , SEQ.[MES_LINE_ID]            AS LINE_ID
								 , ILA.[OPERATION_ID]
								 , ILA.[ITEM_ID]
								 , SEQ.[WORK_CENTER_ID]         AS WORK_CENTER
								 , (SELECT MIN(TTM.[TACT_TIME])
									FROM   [DBO].[SCM_TACT_TIME_M]  TTM  WITH(NOLOCK)
									WHERE  TTM.[COMPANY_ID]     = ILA.[COMPANY_ID]
									AND    TTM.[DIVISION_ID]    = ILA.[DIVISION_ID]
									AND    TTM.[SITE_ID]        = ILA.[SITE_ID]
									AND    TTM.[PLANT_ID]       = ILA.[PLANT_ID]
									AND    TTM.[FACTORY_ID]     = ILA.[FACTORY_ID]
									AND    TTM.[OPERATION_ID]   = ILA.[OPERATION_ID]
									AND    TTM.[LINE_ID]        = MAX(ILA.[LINE_ID])
									AND    TTM.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
									AND    TTM.[ITEM_ID]        = ILA.[ITEM_ID]
									AND    TTM.[MONTH]          = MIN(ILA.[MONTH]) )   AS TACT_TIME
								 , MIN(ILA.[PRIORITY])          AS PRIORITY
								 , 'Y'                          AS ACTIVE_FLAG
								 , 'Y'                          AS CHECK_BOM
								 , (SELECT TOP 1 LV.SEGMENT1 
									FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]     LV  WITH(NOLOCK)
										 , [DBO].[SCM_BOM_FOR_RES_SHARE_M]  BM  WITH(NOLOCK)
									WHERE  LV.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
									AND    LV.ACTIVE_FLAG      = 'Y'
									AND    LV.ATTRIBUTE3       = BM.PLANT_ID
									AND    BM.PARENT_ITEM_ID = ILA.ITEM_ID
									AND    BM.DIVISION_ID    = ILA.DIVISION_ID
									AND    BM.SITE_ID        = ILA.SITE_ID
									AND    BM.PLANT_ID       = ILA.PLANT_ID
									AND    BM.COMPANY_ID     = ILA.COMPANY_ID
									AND    BM.EFF_END_DATE  >= DATEADD(DD, -1, GETDATE()) ) AS RES_PLANT
								 , (SELECT 'Y' FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'NERP_PLANT' AND SLV.ACTIVE_FLAG = 'Y' AND SLV.SEGMENT1 = ILA.[PLANT_ID] )  
									AS NERP_FLAG -- 2025-01-04   kimcd   NERP 대상 PLANT 구분
							FROM   [DBO].[SCM_OPERATION_M]         SOM WITH(NOLOCK)
								 -- ,[DBO].[SCM_EQUIPMENT_M]         SEQ WITH(NOLOCK)
								  ,[DBO].[SCM_ITEM_LINE_ASSIGN_M]  ILA WITH(NOLOCK)
								  LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] SEQ WITH(NOLOCK)
									ON  SEQ.[COMPANY_ID]     = ILA.[COMPANY_ID]
									AND SEQ.[DIVISION_ID]    = ILA.[DIVISION_ID]
									AND SEQ.[SITE_ID]        = ILA.[SITE_ID]
									AND SEQ.[PLANT_ID]       = ILA.[PLANT_ID]
									AND SEQ.[FACTORY_ID]     = ILA.[FACTORY_ID]
									AND SEQ.[OPERATION_ID]   = ILA.[OPERATION_ID]
									AND SEQ.[LINE_ID]        = ILA.[LINE_ID]
									AND SEQ.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
									AND SEQ.[EQUIPMENT_TYPE] = 'M'
									AND SEQ.[ACTIVE_FLAG]    = 'Y'
								 ,[DBO].[SCM_BOM_M]               BM  WITH(NOLOCK)
							WHERE 1=1
							AND   SOM.[COMPANY_ID]     = SEQ.[COMPANY_ID]
							AND   SOM.[DIVISION_ID]    = SEQ.[DIVISION_ID]
							AND   SOM.[SITE_ID]        = SEQ.[SITE_ID]
							AND   SOM.[OPERATION_ID]   = SEQ.[OPERATION_ID]
							AND   SOM.[WO_FLAG]        = 'Y'
							AND   BM.PARENT_ITEM_ID    = ILA.ITEM_ID
							AND   BM.DIVISION_ID       = ILA.DIVISION_ID
							AND   BM.SITE_ID           = ILA.SITE_ID
							AND   BM.PLANT_ID          = ILA.PLANT_ID
							AND   BM.COMPANY_ID        = ILA.COMPANY_ID
							AND   BM.EFF_END_DATE     >= DATEADD(DD, -1, GETDATE())
							AND   EXISTS (
										SELECT 1
										FROM   [DBO].[SCM_TACT_TIME_M] TTM WITH(NOLOCK)
										WHERE  TTM.COMPANY_ID     = ILA.COMPANY_ID
										AND    TTM.DIVISION_ID    = ILA.DIVISION_ID
										AND    TTM.SITE_ID        = ILA.SITE_ID
										AND    TTM.PLANT_ID       = ILA.PLANT_ID
										AND    TTM.FACTORY_ID     = ILA.FACTORY_ID
										AND    TTM.OPERATION_ID   = ILA.OPERATION_ID
										AND    TTM.LINE_ID        = ILA.LINE_ID
										AND    TTM.ELECTRODE_TYPE = ILA.ELECTRODE_TYPE
										AND    TTM.ITEM_ID        = ILA.ITEM_ID
										AND    TTM.UPDATE_TIME    >= DATEADD(HOUR, -1, GETDATE()))  -- 2026-06-19 TACT_TIME UPDATE_TIME 체크	
							AND   ( @P_COMPANY_ID IS NULL OR BM.[COMPANY_ID] = @P_COMPANY_ID )
							GROUP BY ILA.[COMPANY_ID]
								   , ILA.[DIVISION_ID]
								   , ILA.[SITE_ID]
								   , ILA.[PLANT_ID]
								   , ILA.[FACTORY_ID]
								   , SEQ.[MES_LINE_ID]
								   , ILA.[OPERATION_ID]
								   , ILA.[ITEM_ID]
								   , ILA.[ELECTRODE_TYPE]
								   , SEQ.[WORK_CENTER_ID]
				   ) SUB
				   OPTION (RECOMPILE); 

		SET @ROWCOUNT = @@ROWCOUNT

		PRINT @IFSEQNO
		SET @IFSEQNO = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','')
		SET @NERPIFSEQNO = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') + 'N'   -- 2025-01-04 kimcd NERP 대상과 그외 법인 if seq no 분리
		PRINT @IFSEQNO
		SET @v_temp1 = 'STEP OPEN MAIN CURSOR2'
		OPEN CUR_ERP_ROUTE2

        FETCH NEXT FROM CUR_ERP_ROUTE2 INTO  @COMPANY_ID
										 , @DIVISION_ID
										 , @SITE_ID
										 , @PLANT_ID
										 , @BUILNO
										 , @LINE_ID
										 , @OPERATION_ID
										 , @ITEM_ID
										 , @WORK_CENTER
										 , @TACT_TIME
										 , @PRIORITY
										 , @ACTIVE_FLAG
										 , @CHECK_BOM
										 , @RES_PLANT
										 , @NERP_FLAG; -- 2025-01-04   kimcd   NERP 대상 PLANT 구분

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			IF @CHECK_BOM = 'Y' AND ISNULL(@WORK_CENTER,'') <>'' 
				BEGIN
				IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
					BEGIN
						SET @v_temp1 = 'STEP MERGE [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S]'
						MERGE INTO [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S] ILA
						USING ( SELECT CASE WHEN @NERP_FLAG  = 'Y' THEN @NERPIFSEQNO ELSE @IFSEQNO END AS  IFSEQNO -- 2025-01-04   kimcd   NERP 대상 PLANT 구분하여 IFSEQNO 설정  
									 , @PLANT_ID       AS  PLANT_ID
									 , @BUILNO         AS  BUILNO
									 , @OPERATION_ID   AS  OPERATION_ID
									 , @LINE_ID        AS  LINE_ID
									 , @ITEM_ID        AS  ITEM_ID
									 , @WORK_CENTER    AS  WORK_CENTER
									 , @TACT_TIME      AS  TACT_TIME
									 , @PRIORITY       AS  PRIORITY
									 , @ACTIVE_FLAG    AS  ACTIVE_FLAG
								) XXX  -- Item, Operation, Line, Work Center 
						ON (    ILA.[PLANT_ID]     = XXX.[PLANT_ID]
							AND ILA.[BUILNO]       = XXX.[BUILNO]
							AND ILA.[OPERATION_ID] = XXX.[OPERATION_ID]
							AND ILA.[LINE_ID]      = XXX.[LINE_ID]
							AND ILA.[ITEM_ID]      = XXX.[ITEM_ID]
							AND ILA.[WORK_CENTER]  = XXX.[WORK_CENTER])
						WHEN MATCHED THEN
							UPDATE SET ILA.[IFSEQNO]        = XXX.IFSEQNO
									 , ILA.[TACT_TIME]      = XXX.TACT_TIME
									 , ILA.[PRIORITY]       = XXX.PRIORITY
									 , ILA.[TRANSFER_FLAG]  = 'N'
									 , ILA.[TRANSFER_DATE]  = NULL
									 , ILA.[MODIFY_USER_ID] = @v_proc_name
									 , ILA.[MODIFY_DATE]    = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ( [IFSEQNO]
								   , [PLANT_ID]
								   , [BUILNO]
								   , [LINE_ID]
								   , [OPERATION_ID]
								   , [ITEM_ID]
								   , [WORK_CENTER]
								   , [TACT_TIME]
								   , [PRIORITY]
								   , [ACTIVE_FLAG]
								   , [TRANSFER_FLAG]
								   , [TRANSFER_DATE]
								   , [CREATE_USER_ID]
								   , [CREATE_DATE]
								   , [MODIFY_USER_ID]
								   , [MODIFY_DATE]
								   )
							VALUES ( XXX.IFSEQNO
									,@PLANT_ID
									,XXX.BUILNO
									,XXX.LINE_ID
									,XXX.OPERATION_ID
									,XXX.ITEM_ID
									,XXX.WORK_CENTER
									,XXX.TACT_TIME
									,XXX.PRIORITY
									,'Y'              -- ACTIVE_FLAG
									,'N'              -- TRANSFER_FLAG
									,NULL             -- TRANSFER_DATE
									,@v_proc_name
									,GETDATE()
									,@v_proc_name
									,GETDATE()
									);
					END; -- IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
				END;

			IF @RES_PLANT IS NOT NULL
				BEGIN
				IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
					BEGIN
						SET @v_temp1 = 'STEP MERGE [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S]'
						MERGE INTO [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S] ILA
						USING ( SELECT CASE WHEN @NERP_FLAG  = 'Y' THEN @NERPIFSEQNO ELSE @IFSEQNO END AS  IFSEQNO -- 2025-01-04   kimcd   NERP 대상 PLANT 구분하여 IFSEQNO 설정  
									 , @RES_PLANT      AS  PLANT_ID
									 , @BUILNO         AS  BUILNO
									 , @OPERATION_ID   AS  OPERATION_ID
									 , @LINE_ID        AS  LINE_ID
									 , @ITEM_ID        AS  ITEM_ID
									 , @WORK_CENTER    AS  WORK_CENTER
									 , @TACT_TIME      AS  TACT_TIME
									 , @PRIORITY       AS  PRIORITY
									 , @ACTIVE_FLAG    AS  ACTIVE_FLAG
								) XXX  -- Item, Operation, Line, Work Center 
						ON (    ILA.[PLANT_ID]     = XXX.[PLANT_ID]
							AND ILA.[BUILNO]       = XXX.[BUILNO]
							AND ILA.[OPERATION_ID] = XXX.[OPERATION_ID]
							AND ILA.[LINE_ID]      = XXX.[LINE_ID]
							AND ILA.[ITEM_ID]      = XXX.[ITEM_ID]
							AND ILA.[WORK_CENTER]  = XXX.[WORK_CENTER])
						WHEN MATCHED THEN
							UPDATE SET ILA.[IFSEQNO]        = XXX.IFSEQNO
									 , ILA.[TACT_TIME]      = XXX.TACT_TIME
									 , ILA.[PRIORITY]       = XXX.PRIORITY
									 , ILA.[TRANSFER_FLAG]  = 'N'
									 , ILA.[TRANSFER_DATE]  = NULL
									 , ILA.[MODIFY_USER_ID] = @v_proc_name
									 , ILA.[MODIFY_DATE]    = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ( [IFSEQNO]
								   , [PLANT_ID]
								   , [BUILNO]
								   , [LINE_ID]
								   , [OPERATION_ID]
								   , [ITEM_ID]
								   , [WORK_CENTER]
								   , [TACT_TIME]
								   , [PRIORITY]
								   , [ACTIVE_FLAG]
								   , [TRANSFER_FLAG]
								   , [TRANSFER_DATE]
								   , [CREATE_USER_ID]
								   , [CREATE_DATE]
								   , [MODIFY_USER_ID]
								   , [MODIFY_DATE]
								   )
							VALUES ( XXX.IFSEQNO
									,@RES_PLANT
									,XXX.BUILNO
									,XXX.LINE_ID
									,XXX.OPERATION_ID
									,XXX.ITEM_ID
									,XXX.WORK_CENTER
									,XXX.TACT_TIME
									,XXX.PRIORITY
									,'Y'              -- ACTIVE_FLAG
									,'N'              -- TRANSFER_FLAG
									,NULL             -- TRANSFER_DATE
									,@v_proc_name
									,GETDATE()
									,@v_proc_name
									,GETDATE()
									);
					END; -- IF @WORK_CENTER IS NOT NULL AND @WORK_CENTER != ''
				END;

			FETCH NEXT FROM CUR_ERP_ROUTE2 INTO  @COMPANY_ID
											 , @DIVISION_ID
											 , @SITE_ID
											 , @PLANT_ID
											 , @BUILNO
											 , @LINE_ID
											 , @OPERATION_ID
											 , @ITEM_ID
											 , @WORK_CENTER
											 , @TACT_TIME
											 , @PRIORITY
											 , @ACTIVE_FLAG
											 , @CHECK_BOM
											 , @RES_PLANT
											 , @NERP_FLAG; -- 2025-01-04   kimcd   NERP 대상 PLANT 구분

		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_ERP_ROUTE2;
        DEALLOCATE CUR_ERP_ROUTE2;   -- 메모리 해제


		-- ================================================
		-- IFSEQNO 5000개씩 나눠줌
		-- ================================================

		SET @v_temp1 = 'STEP SEQ CHANGE'
		;WITH CTE_UPDATE_SEQ AS (
			SELECT 
				IFSEQNO,
				ROW_NUMBER() OVER (PARTITION BY IFSEQNO ORDER BY (SELECT NULL)) AS RowNum
			FROM SY_XIF_ERP_ITEM_LINE_ASSIGN_S
			WHERE IFSEQNO LIKE @IFSEQNO +'%' 
		)
		UPDATE CTE_UPDATE_SEQ
		   SET IFSEQNO = CASE WHEN RIGHT(IFSEQNO, 1) = 'N' THEN CONVERT(NVARCHAR(20), CAST(SUBSTRING(IFSEQNO, 1, LEN(IFSEQNO) - 1) AS BIGINT) + ((RowNum - 1) / 5000)) + 'N'
			                  ELSE CONVERT(NVARCHAR(20), CAST(IFSEQNO AS BIGINT) + ((RowNum - 1) / 5000)) END
		WHERE RowNum > 5000;

		SET @v_temp1 = 'STEP2 END PROCEDURE'

		COMMIT TRAN

		SET @sysdate = GETDATE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @data_s = CURSOR_STATUS('global','CUR_ERP_ROUTE2')
		IF @data_s IN (1,0)
						 BEGIN
		                     CLOSE CUR_ERP_ROUTE2;
                             DEALLOCATE CUR_ERP_ROUTE2;   -- 메모리 해제
                         END
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

END;

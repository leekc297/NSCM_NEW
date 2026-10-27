
CREATE PROCEDURE [dbo].[PR_XIF_MES_WIP_HOLD_HISTORY_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_WIP_HOLD_HISTORY_R
-- Param               :
-- Batch Period        : 1HOUR
-- Description         : MES HOLD 정보 전환
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_WIP_HOLD_HISTORY_R
-- Destination Table   : SCM_RT_STOCK_H
--
-- Create Date		   : 2017.08.11
-- Update Date         : 2018-10-18 PIYONG 1.1

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 2018-10-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--						 1.2 2021-07-13 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--						                AREA ID (FACTORY ID) 기준으로 SITE ID 찾는것으로 변경
-- ================================================================================================

-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_IF_ID NVARCHAR(50) = 'NULL'


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_WIP_HOLD_HISTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IF_ID				NVARCHAR(50)
    DECLARE @ACCUM_DATE			NVARCHAR(50)
    DECLARE @SITE_ID			NVARCHAR(50)

	DECLARE @LOTID				NVARCHAR(50)
	DECLARE @WIPSEQ				NUMERIC(18,0)
	DECLARE @AREAID				NVARCHAR(30)
	DECLARE @PROCID				NVARCHAR(30)
	DECLARE @ITEM_ID			NVARCHAR(150)
	DECLARE @HOLD_DTTM			DATETIME
	DECLARE @HOLD_FLAG			NVARCHAR(1)
	DECLARE @HOLD_QTY			NUMERIC(18,5)
	DECLARE @HOLD_QTY2			NUMERIC(18,5)
	DECLARE @HOLD_CODE			NVARCHAR(50)
	DECLARE @UNHOLD_SCHD_DATE	NVARCHAR(8)
	DECLARE @UNHOLD_DTTM		DATETIME
	DECLARE @CUTOFF_DATE		NVARCHAR(50)

	DECLARE CUR_MES_HOLD CURSOR FOR
		--2021-07-13 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : AREA ID (FACTORY ID) 기준으로 SITE ID 찾는것으로 변경	
		--SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID
		SELECT IF_ID, ACCUM_DATE, ( SELECT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE Z.FACTORY_ID = MAX(AREAID) ) SITE_ID		
          FROM [SY_XIF_MES_WIP_HOLD_HISTORY_R]
         WHERE 1=1
           AND PROC_FLAG = 'N'
		   AND IF_ID  = ( CASE WHEN @P_IF_ID = 'NULL' OR @P_IF_ID IS NULL THEN IF_ID  ELSE @P_IF_ID END)
         GROUP BY IF_ID, ACCUM_DATE
        HAVING COUNT(1) = MAX(ACCUM_COUNT)
         ORDER BY IF_ID, ACCUM_DATE
		 ;
	

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR_MES_HOLD;
			FETCH NEXT FROM CUR_MES_HOLD INTO @IF_ID        
											    ,@ACCUM_DATE
                                                ,@SITE_ID		

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					IF ( @P_SITE_ID != 'NULL' AND @P_SITE_ID IS NOT NULL AND @SITE_ID = @P_SITE_ID ) OR (@P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL)		

						BEGIN

							UPDATE [dbo].[SY_XIF_MES_WIP_HOLD_HISTORY_R]
							   SET PROC_FLAG = 'P'
							 WHERE ISNULL(PROC_FLAG, 'N') = 'N'
							   AND IF_ID = @IF_ID
							   AND ACCUM_DATE = @ACCUM_DATE
							;

							DECLARE CUR_SCM_HOLD CURSOR FOR
								SELECT LOTID
									   ,WIPSEQ
									   /*	--2018-10-18 PIYONG DEL  E8동 사용 안함
									   ,CASE WHEN NJ_ELEC_FACTORY IN ( 'G452', 'A') AND AREAID = 'E7' THEN
													'E8'
										         ELSE
													AREAID
												  END AS AREAID
										*/
									   ,AREAID		--2018-10-18 PIYONG ADD
									   ,PROCID
									   ,PRODID AS ITEM_ID
									   ,HOLD_DTTM
									   ,HOLD_FLAG
									   ,HOLD_QTY
									   ,HOLD_QTY2
									   ,HOLD_CODE
									   ,UNHOLD_SCHD_DATE
									   ,UNHOLD_DTTM
									   , CONVERT(datetime, 
														SUBSTRING(@ACCUM_DATE, 1,4)+'-'+
														SUBSTRING(@ACCUM_DATE, 5,2)+'-'+
														SUBSTRING(@ACCUM_DATE, 7,2)+' '+
														SUBSTRING(@ACCUM_DATE, 9,2)+':'+
														SUBSTRING(@ACCUM_DATE, 11,2)+':00'
													, 120) AS CUTOFF_DATE
								 FROM [SY_XIF_MES_WIP_HOLD_HISTORY_R]
								WHERE 1=1
								  AND IF_ID = @IF_ID
								  AND ACCUM_DATE = @ACCUM_DATE
								  AND PROC_FLAG = 'P'

															
							OPEN CUR_SCM_HOLD;
							FETCH NEXT FROM CUR_SCM_HOLD INTO @LOTID
															  ,@WIPSEQ
															  ,@AREAID
															  ,@PROCID
															  ,@ITEM_ID
															  ,@HOLD_DTTM
															  ,@HOLD_FLAG
															  ,@HOLD_QTY
															  ,@HOLD_QTY2
															  ,@HOLD_CODE
															  ,@UNHOLD_SCHD_DATE
															  ,@UNHOLD_DTTM
															  ,@CUTOFF_DATE


							WHILE (@@FETCH_STATUS = 0)
								BEGIN
								

									MERGE INTO [dbo].[SCM_MES_WIP_HOLD_HISTORY_H] A
									USING (
											SELECT @LOTID AS LOTID
												   ,@WIPSEQ AS [WIPSEQ]
												   ,@AREAID AS FACTORY_ID
												   ,@PROCID AS OPERATION_ID
												   ,@ITEM_ID AS ITEM_ID
												   ,@HOLD_DTTM AS [HOLD_DTTM]
												   ,@HOLD_FLAG AS [HOLD_FLAG]
												   ,@HOLD_QTY AS [HOLD_QTY]
												   ,@HOLD_QTY2 AS [HOLD_QTY2]
												   ,@HOLD_CODE AS [HOLD_CODE]
												   ,@UNHOLD_SCHD_DATE AS [UNHOLD_SCHD_DATE]
												   ,@UNHOLD_DTTM AS [UNHOLD_DTTM]
												   ,@CUTOFF_DATE AS CUTOFF_DATE

											) B
										ON ( A.[LOTID] = B.[LOTID]
											 AND A.[WIPSEQ] = B.[WIPSEQ]
											 AND A.[HOLD_DTTM] = B.[HOLD_DTTM]
										  )
									 WHEN MATCHED THEN
										UPDATE SET [FACTORY_ID]			= B.[FACTORY_ID]
												  ,[OPERATION_ID]		= B.[OPERATION_ID] 
												  ,[ITEM_ID]			= B.[ITEM_ID]
												  ,[CUTOFF_DATE]		= B.[CUTOFF_DATE]
												  ,[HOLD_DTTM]			= B.[HOLD_DTTM]
												  ,[HOLD_FLAG]			= B.[HOLD_FLAG]
												  ,[HOLD_QTY]			= B.[HOLD_QTY]
												  ,[HOLD_QTY2]			= B.[HOLD_QTY2]
												  ,[HOLD_CODE]			= B.[HOLD_CODE]
												  ,[UNHOLD_SCHD_DATE]	= B.[UNHOLD_SCHD_DATE]
												  ,[UNHOLD_DTTM]		= B.[UNHOLD_DTTM]
												  ,A.[MODIFY_USER_ID]	= 'PR_XIF_MES_WIP_HOLD_HISTORY_R'
												  ,A.[MODIFY_DATE]		= GETDATE()
									WHEN NOT MATCHED THEN
										INSERT (  [LOTID]
												  ,[WIPSEQ]
												  ,[FACTORY_ID]
												  ,[OPERATION_ID]
												  ,[ITEM_ID]
												  ,[CUTOFF_DATE]
												  ,[HOLD_DTTM]
												  ,[HOLD_FLAG]
												  ,[HOLD_QTY]
												  ,[HOLD_QTY2]
												  ,[HOLD_CODE]
												  ,[UNHOLD_SCHD_DATE]
												  ,[UNHOLD_DTTM]
												  ,[CREATE_USER_ID]
												  ,[CREATE_DATE]
												  ,[MODIFY_USER_ID]
												  ,[MODIFY_DATE]
										) VALUES (
												 B.[LOTID]
												 ,B.[WIPSEQ]
												 ,B.[FACTORY_ID]
												 ,B.[OPERATION_ID]
												 ,B.[ITEM_ID]
												 ,B.[CUTOFF_DATE]
												 ,B.[HOLD_DTTM]
												 ,B.[HOLD_FLAG]
												 ,B.[HOLD_QTY]
												 ,B.[HOLD_QTY2]
												 ,B.[HOLD_CODE]
												 ,B.[UNHOLD_SCHD_DATE]
												 ,B.[UNHOLD_DTTM]       
												 ,'PR_XIF_MES_WIP_HOLD_HISTORY_R'
												 ,GETDATE()
												 ,'PR_XIF_MES_WIP_HOLD_HISTORY_R'
												 ,GETDATE()
										)
								;
						

									FETCH NEXT FROM CUR_SCM_HOLD INTO  @LOTID
																	  ,@WIPSEQ
																	  ,@AREAID
																	  ,@PROCID
																	  ,@ITEM_ID
																	  ,@HOLD_DTTM
																	  ,@HOLD_FLAG
																	  ,@HOLD_QTY
																	  ,@HOLD_QTY2
																	  ,@HOLD_CODE
																	  ,@UNHOLD_SCHD_DATE
																	  ,@UNHOLD_DTTM
																	  ,@CUTOFF_DATE
									;



								END;

							CLOSE CUR_SCM_HOLD;
							DEALLOCATE CUR_SCM_HOLD;  
							;

								

							SET @ROWCOUNT = @@ROWCOUNT

							UPDATE [dbo].[SY_XIF_MES_WIP_HOLD_HISTORY_R] SET
								PROC_FLAG = 'Y'
								,PROC_DATE = GETDATE()
							 WHERE PROC_FLAG = 'P'
							   AND IF_ID = @IF_ID
							   AND ACCUM_DATE = @ACCUM_DATE
							;

						END;

					FETCH NEXT FROM CUR_MES_HOLD INTO @IF_ID        
													  ,@ACCUM_DATE
													  ,@SITE_ID
					;



				END;

			CLOSE CUR_MES_HOLD;
			DEALLOCATE CUR_MES_HOLD;  

 

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END

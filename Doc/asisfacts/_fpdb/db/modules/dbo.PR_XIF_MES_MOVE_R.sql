
CREATE PROCEDURE [dbo].[PR_XIF_MES_MOVE_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_MOVE_R
-- Param               :
-- Batch Period        : 1HOUR
-- Description         : MES 재고 정보 전환
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_MOVE_R
-- Destination Table   : SCM_MES_MOVE_H
--
-- Create Date		   : 2017.08.11
-- Update Date         : 2018.10.18 PIYONG 1.1

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 2018-10-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--						 1.2 2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--						                      FROM_AREAID (FACTORY ID) 기준으로 SITE ID 찾는것으로 변경
--                       1.3 2025-01-03 kimcd MOVE_ORD_ID != 'NO_MOVE' 일자 변환 오류 처리
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_MOVE_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_message   nvarchar(1000)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IF_ID       NVARCHAR(50)
    DECLARE @ACCUM_DATE   nvarchar(50)
    DECLARE @SITE_ID     NVARCHAR(50)

	DECLARE @MOVE_ORD_ID		NVARCHAR(50)
	DECLARE @MOVE_TYPE_CODE		NVARCHAR(50)
	DECLARE @CUTOFF_DATE		NVARCHAR(50)
	DECLARE @MOVE_ORD_STAT_CODE	NVARCHAR(50)
	DECLARE @FROM_SHOPID		NVARCHAR(50)
	DECLARE @FROM_AREAID		NVARCHAR(50)
	DECLARE @FROM_PROCID		NVARCHAR(50)
	DECLARE @FROM_EQSGID		NVARCHAR(50)
	DECLARE @PRODID				NVARCHAR(150)
	DECLARE @TO_SHOPID			NVARCHAR(50)
	DECLARE @TO_AREAID			NVARCHAR(50)
	DECLARE @TO_PROCID			NVARCHAR(50)
	DECLARE @TO_EQSGID			NVARCHAR(50)
	DECLARE @MOVE_ORD_QTY		NUMERIC(18,5)
	DECLARE @MOVE_CMPL_QTY		NUMERIC(18,5)
	DECLARE @MOVE_CNCL_QTY		NUMERIC(18,5)
	DECLARE @MOVE_STRT_DTTM		DATETIME
	DECLARE @MOVE_END_DTTM		DATETIME
	DECLARE @MOVE_CNCL_DTTM		DATETIME
	DECLARE @MOVE_ORD_QTY2		NUMERIC(18,5)	
	DECLARE @MOVE_CMPL_QTY2		NUMERIC(18,5)
	DECLARE @MOVE_CNCL_QTY2		NUMERIC(18,5)
	DECLARE @INTRANSIT_FLAG		NVARCHAR(1)
	DECLARE @MOVE_MTHD_CODE		NVARCHAR(50)
	DECLARE @NOTE				NVARCHAR(2000)
	DECLARE @MOVE_NOTE			NVARCHAR(2000)
	DECLARE @RCPT_NOTE			NVARCHAR(2000)
	DECLARE @CNCL_NOTE			NVARCHAR(2000)

	DECLARE CUR_MES_MOVE CURSOR FOR
        --2021-06-03 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : FROM_AREAID (FACTORY ID) 기준으로 SITE ID 찾는것으로 변경
        --SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID
        SELECT IF_ID, ACCUM_DATE, ( SELECT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE Z.FACTORY_ID = MAX(FROM_AREAID) ) SITE_ID
          FROM [SY_XIF_MES_MOVE_R]
         WHERE 1=1
           AND PROC_FLAG = 'N'
		   AND IF_ID  = ( CASE WHEN @P_IF_ID = 'NULL' OR @P_IF_ID IS NULL THEN IF_ID  ELSE @P_IF_ID END)
         GROUP BY IF_ID, ACCUM_DATE
        HAVING ( COUNT(1) = MAX(ACCUM_COUNT)  OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 ) ) 
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
			OPEN CUR_MES_MOVE;
			FETCH NEXT FROM CUR_MES_MOVE INTO @IF_ID        
											    ,@ACCUM_DATE
                                                ,@SITE_ID		

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					IF ( @P_SITE_ID != 'NULL' AND @P_SITE_ID IS NOT NULL AND @SITE_ID = @P_SITE_ID ) OR (@P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL)		

						BEGIN

							UPDATE [dbo].[SY_XIF_MES_MOVE_R]
							   SET PROC_FLAG = 'P'
							 WHERE PROC_FLAG = 'N'
							   AND IF_ID = @IF_ID
							   AND ACCUM_DATE =  @ACCUM_DATE
							;

							DECLARE CUR_SCM_MOVE CURSOR FOR
								SELECT A.[MOVE_ORD_ID]
										,A.[MOVE_TYPE_CODE]
										,CONVERT(datetime
												 ,SUBSTRING(A.ACCUM_DATE, 1,4)+'-'+
													SUBSTRING(A.ACCUM_DATE, 5,2)+'-'+
													SUBSTRING(A.ACCUM_DATE, 7,2)+' '+
													SUBSTRING(A.ACCUM_DATE, 9,2)+':'+
													SUBSTRING(A.ACCUM_DATE, 11,2)+':00'
												 , 120) AS CUTOFF_DATE
										,A.[MOVE_ORD_STAT_CODE]
										/*	--2018-10-18 PIYIONG DEL E8동 사용 안함 
										,CASE WHEN A.[NJ_ELEC_FACTORY] IN ( 'G452', 'A') AND A.[FROM_AREAID] = 'E7' THEN
												'G452'
										      ELSE
												A.[FROM_SHOPID]
											  END AS [FROM_SHOPID]
										,CASE WHEN A.[NJ_ELEC_FACTORY] IN ( 'G452', 'A') AND A.[FROM_AREAID] = 'E7' THEN
												'E8'
										      ELSE
												A.[FROM_AREAID]
											  END AS [FROM_AREAID]
										*/
										,A.[FROM_SHOPID]
										,A.[FROM_AREAID]
										,A.[FROM_PROCID]
										,A.[FROM_EQSGID]
										,A.SEMI_PRODID  AS PRODID
										,A.[TO_SHOPID]
										,A.[TO_AREAID]
										,A.[TO_PROCID]
										,A.[TO_EQSGID]
										,A.[MOVE_ORD_QTY]
										,A.[MOVE_CMPL_QTY]
										,A.[MOVE_CNCL_QTY]
										,A.[MOVE_STRT_DTTM]
										,A.[MOVE_END_DTTM]
										,A.[MOVE_CNCL_DTTM]
										,A.[MOVE_ORD_QTY2]
										,A.[MOVE_CMPL_QTY2]
										,A.[MOVE_CNCL_QTY2]
										,A.[INTRANSIT_FLAG]
										,A.[MOVE_MTHD_CODE]
										,A.[NOTE]
										,A.[MOVE_NOTE]
										,A.[RCPT_NOTE]
										,A.[CNCL_NOTE]
								   FROM [dbo].[SY_XIF_MES_MOVE_R] A WITH(NOLOCK)
								  WHERE A.PROC_FLAG = 'P'
									AND A.IF_ID = @IF_ID
									AND A.ACCUM_DATE =  @ACCUM_DATE
									AND A.MOVE_ORD_ID != 'NO_MOVE'  -- 1.3 2025-01-03 kimcd MOVE_ORD_ID != 'NO_MOVE' 일자 변환 오류 처리
								  ORDER BY MOVE_ORD_ID

															
							OPEN CUR_SCM_MOVE;
							FETCH NEXT FROM CUR_SCM_MOVE INTO @MOVE_ORD_ID
																,@MOVE_TYPE_CODE
																,@CUTOFF_DATE
																,@MOVE_ORD_STAT_CODE
																,@FROM_SHOPID
																,@FROM_AREAID
																,@FROM_PROCID
																,@FROM_EQSGID
																,@PRODID
																,@TO_SHOPID
																,@TO_AREAID
																,@TO_PROCID
																,@TO_EQSGID
																,@MOVE_ORD_QTY
																,@MOVE_CMPL_QTY
																,@MOVE_CNCL_QTY
																,@MOVE_STRT_DTTM
																,@MOVE_END_DTTM
																,@MOVE_CNCL_DTTM
																,@MOVE_ORD_QTY2
																,@MOVE_CMPL_QTY2
																,@MOVE_CNCL_QTY2
																,@INTRANSIT_FLAG
																,@MOVE_MTHD_CODE
																,@NOTE
																,@MOVE_NOTE
																,@RCPT_NOTE
																,@CNCL_NOTE


							WHILE (@@FETCH_STATUS = 0)
								BEGIN
								

									MERGE INTO [dbo].[SCM_MES_MOVE_H] A
									USING (
											SELECT @MOVE_ORD_ID AS MOVE_ORD_ID
													,@MOVE_TYPE_CODE AS [MOVE_TYPE_CODE]
													,@CUTOFF_DATE AS [CUTOFF_DATE]
													,@MOVE_ORD_STAT_CODE AS [MOVE_ORD_STAT_CODE]
													,@FROM_SHOPID AS [FROM_SHOPID]
													,@FROM_AREAID AS [FROM_AREAID]
													,@FROM_PROCID AS [FROM_PROCID]
													,@FROM_EQSGID AS [FROM_EQSGID]
													,@PRODID AS [PRODID]
													,@TO_SHOPID AS  [TO_SHOPID]
													,@TO_AREAID AS [TO_AREAID]
													,@TO_PROCID AS [TO_PROCID]
													,@TO_EQSGID AS [TO_EQSGID]
													,@MOVE_ORD_QTY AS [MOVE_ORD_QTY]
													,@MOVE_CMPL_QTY AS [MOVE_CMPL_QTY]
													,@MOVE_CNCL_QTY AS [MOVE_CNCL_QTY]
													,@MOVE_STRT_DTTM AS [MOVE_STRT_DTTM]
													,@MOVE_END_DTTM AS [MOVE_END_DTTM]
													,@MOVE_CNCL_DTTM AS [MOVE_CNCL_DTTM]
													,@MOVE_ORD_QTY2 AS [MOVE_ORD_QTY2]
													,@MOVE_CMPL_QTY2 AS [MOVE_CMPL_QTY2]
													,@MOVE_CNCL_QTY2 AS [MOVE_CNCL_QTY2]
													,@INTRANSIT_FLAG AS [INTRANSIT_FLAG]
													,@MOVE_MTHD_CODE AS [MOVE_MTHD_CODE]
													,@NOTE AS [NOTE]
													,@MOVE_NOTE AS [MOVE_NOTE]
													,@RCPT_NOTE AS [RCPT_NOTE]
													,@CNCL_NOTE AS [CNCL_NOTE]

											) B
										ON ( A.MOVE_ORD_ID = B.MOVE_ORD_ID )
							 WHEN MATCHED THEN
								UPDATE SET A.[MOVE_TYPE_CODE]      = B.[MOVE_TYPE_CODE]
										   ,A.[CUTOFF_DATE]		   = B.[CUTOFF_DATE]
										   ,A.[MOVE_ORD_STAT_CODE] = B.[MOVE_ORD_STAT_CODE]
										   ,A.[FROM_SHOPID]        = B.[FROM_SHOPID]
										   ,A.[FROM_AREAID]        = B.[FROM_AREAID]
										   ,A.[FROM_PROCID]        = B.[FROM_PROCID]
										   ,A.[FROM_EQSGID]        = B.[FROM_EQSGID]
										   ,A.[PRODID]			   = B.[PRODID]
										   ,A.[TO_SHOPID]          = B.[TO_SHOPID]
										   ,A.[TO_AREAID]          = B.[TO_AREAID]
										   ,A.[TO_PROCID]          = B.[TO_PROCID]
										   ,A.[TO_EQSGID]          = B.[TO_EQSGID]
										   ,A.[MOVE_ORD_QTY]       = B.[MOVE_ORD_QTY]
										   ,A.[MOVE_CMPL_QTY]      = B.[MOVE_CMPL_QTY]
										   ,A.[MOVE_CNCL_QTY]      = B.[MOVE_CNCL_QTY]
										   ,A.[MOVE_STRT_DTTM]     = B.[MOVE_STRT_DTTM]
										   ,A.[MOVE_END_DTTM]      = B.[MOVE_END_DTTM]
										   ,A.[MOVE_CNCL_DTTM]     = B.[MOVE_CNCL_DTTM]
										   ,A.[MOVE_ORD_QTY2]      = B.[MOVE_ORD_QTY2]
										   ,A.[MOVE_CMPL_QTY2]     = B.[MOVE_CMPL_QTY2]
										   ,A.[MOVE_CNCL_QTY2]     = B.[MOVE_CNCL_QTY2]
										   ,A.[INTRANSIT_FLAG]     = B.[INTRANSIT_FLAG]
										   ,A.[MOVE_MTHD_CODE]     = B.[MOVE_MTHD_CODE]
										   ,A.[NOTE]               = B.[NOTE]
										  ,A.[MOVE_NOTE]           = B.[MOVE_NOTE]
										  ,A.[RCPT_NOTE]           = B.[RCPT_NOTE]
										  ,A.[CNCL_NOTE]           = B.[CNCL_NOTE]
										  ,A.[MODIFY_USER_ID]	   = 'PR_XIF_MES_MOVE_R'
										  ,A.[MODIFY_DATE]		   = GETDATE()
							WHEN NOT MATCHED THEN
								INSERT (  [MOVE_ORD_ID]
										  ,[MOVE_TYPE_CODE]
										  ,[CUTOFF_DATE]
										  ,[MOVE_ORD_STAT_CODE]
										  ,[FROM_SHOPID]
										  ,[FROM_AREAID]
										  ,[FROM_PROCID]
										  ,[FROM_EQSGID]
										  ,[PRODID]
										  ,[TO_SHOPID]
										  ,[TO_AREAID]
										  ,[TO_PROCID]
										  ,[TO_EQSGID]
										  ,[MOVE_ORD_QTY]
										  ,[MOVE_CMPL_QTY]
										  ,[MOVE_CNCL_QTY]
										  ,[MOVE_STRT_DTTM]
										  ,[MOVE_END_DTTM]
										  ,[MOVE_CNCL_DTTM]
										  ,[MOVE_ORD_QTY2]
										  ,[MOVE_CMPL_QTY2]
										  ,[MOVE_CNCL_QTY2]
										  ,[INTRANSIT_FLAG]
										  ,[MOVE_MTHD_CODE]
										  ,[NOTE]
										  ,[MOVE_NOTE]
										  ,[RCPT_NOTE]
										  ,[CNCL_NOTE]
										  ,[CREATE_USER_ID]
										  ,[CREATE_DATE]
										  ,[MODIFY_USER_ID]
										  ,[MODIFY_DATE]
								) VALUES (
										 B.[MOVE_ORD_ID]
										,B.[MOVE_TYPE_CODE]
										,B.[CUTOFF_DATE]  
										,B.[MOVE_ORD_STAT_CODE]
										,B.[FROM_SHOPID]       
										,B.[FROM_AREAID]       
										,B.[FROM_PROCID]       
										,B.[FROM_EQSGID]
										,B.[PRODID]       
										,B.[TO_SHOPID]         
										,B.[TO_AREAID]         
										,B.[TO_PROCID]         
										,B.[TO_EQSGID]         
										,B.[MOVE_ORD_QTY]      
										,B.[MOVE_CMPL_QTY]     
										,B.[MOVE_CNCL_QTY]     
										,B.[MOVE_STRT_DTTM]    
										,B.[MOVE_END_DTTM]     
										,B.[MOVE_CNCL_DTTM]    
										,B.[MOVE_ORD_QTY2]     
										,B.[MOVE_CMPL_QTY2]    
										,B.[MOVE_CNCL_QTY2]    
										,B.[INTRANSIT_FLAG]    
										,B.[MOVE_MTHD_CODE]    
										,B.[NOTE]              
										,B.[MOVE_NOTE]         
										,B.[RCPT_NOTE]         
										,B.[CNCL_NOTE]         
										,'PR_XIF_MES_MOVE_R'
										,GETDATE()
										,'PR_XIF_MES_MOVE_R'
										,GETDATE()
								)
							;

						

									FETCH NEXT FROM CUR_SCM_MOVE INTO @MOVE_ORD_ID
																		,@MOVE_TYPE_CODE
																		,@CUTOFF_DATE
																		,@MOVE_ORD_STAT_CODE
																		,@FROM_SHOPID
																		,@FROM_AREAID
																		,@FROM_PROCID
																		,@FROM_EQSGID
																		,@PRODID
																		,@TO_SHOPID
																		,@TO_AREAID
																		,@TO_PROCID
																		,@TO_EQSGID
																		,@MOVE_ORD_QTY
																		,@MOVE_CMPL_QTY
																		,@MOVE_CNCL_QTY
																		,@MOVE_STRT_DTTM
																		,@MOVE_END_DTTM
																		,@MOVE_CNCL_DTTM
																		,@MOVE_ORD_QTY2
																		,@MOVE_CMPL_QTY2
																		,@MOVE_CNCL_QTY2
																		,@INTRANSIT_FLAG
																		,@MOVE_MTHD_CODE
																		,@NOTE
																		,@MOVE_NOTE
																		,@RCPT_NOTE
																		,@CNCL_NOTE
									;



								END;

							CLOSE CUR_SCM_MOVE;
							DEALLOCATE CUR_SCM_MOVE;  
							;
								

							SET @ROWCOUNT = @@ROWCOUNT

							UPDATE [dbo].[SY_XIF_MES_MOVE_R] SET
								 PROC_FLAG = 'Y'
								,PROC_DATE = GETDATE()
							 WHERE PROC_FLAG = 'P'
							   AND IF_ID = @IF_ID
							   AND ACCUM_DATE = @ACCUM_DATE
							;

						END;

					FETCH NEXT FROM CUR_MES_MOVE INTO @IF_ID        
													  ,@ACCUM_DATE
													  ,@SITE_ID
					;



				END;

			CLOSE CUR_MES_MOVE;
			DEALLOCATE CUR_MES_MOVE;  

 

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN


		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr	= ERROR_MESSAGE()
		SET @v_message	= @IF_ID + '|' + @ACCUM_DATE + '|' + @SITE_ID
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_message, @v_descr, @sysdate

	END CATCH

END

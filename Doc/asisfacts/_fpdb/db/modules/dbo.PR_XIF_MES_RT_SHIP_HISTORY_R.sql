

CREATE PROCEDURE [dbo].[PR_XIF_MES_RT_SHIP_HISTORY_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_RT_SHIP_HISTORY_R
-- Param               :
-- Batch Period        : 30 MINUTE
-- Description         : 
--                       
--                       
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_RT_RCV_ISS_R, XIF_MES_RT_RCV_ISS_PLLT_R
-- Destination Table   : SCM_MES_RT_SHIP_HISTORY_H
--
-- Create Date		   : 2017.10.12
-- Update Date         : 2018-10-18 PIYONG 1.1
--			             
-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 2018-10-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--						 3.7 2021-07-09 kimis    ESNJ 6동 GMES DB 분리에 따른 변경 : Site 제거
-- ================================================================================================


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_RT_SHIP_HISTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @v_table     NVARCHAR(1000)


	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IF_ID        NVARCHAR(50)
	DECLARE @ACCUM_DATE   NVARCHAR(50)
	--2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Site 제거
	--DECLARE @SITE_ID      NVARCHAR(50)
	DECLARE @BASE_HOUR    NVARCHAR(2)

	DECLARE CUR_IF_MES_WIPHIST CURSOR FOR
		--2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Site 제거
		--SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID
		SELECT IF_ID, ACCUM_DATE
		  FROM [SY_XIF_MES_RT_RCV_ISS_PLLT_R]
		 WHERE 1=1
		   AND PROC_FLAG = 'P'
		 GROUP BY IF_ID, ACCUM_DATE
		HAVING ( COUNT(1) = MAX(ACCUM_COUNT)  OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 ) )  -- 전체를 수신받지 못한 경우에는 처리하지 않음.
		 ORDER BY IF_ID, ACCUM_DATE


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
		  
			UPDATE IP
			   SET PROC_FLAG    = 'P'
				   ,PROC_DATE    = GETDATE()
			  FROM [dbo].[SY_XIF_MES_RT_RCV_ISS_R] I
			 INNER JOIN [dbo].[SY_XIF_MES_RT_RCV_ISS_PLLT_R] IP
					 ON (I.IF_SEQ = IP.MASTER_IF_SEQ
						 AND I.RCV_ISS_ID = IP.RCV_ISS_ID)
			 WHERE I.RCV_ISS_TYPE_CODE IN ('SHIP', 'RETURN')
			   AND IP.PROC_FLAG = 'N'
			;


			OPEN CUR_IF_MES_WIPHIST;
			FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
												     ,@ACCUM_DATE
												     --2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Site 제거
												     --,@SITE_ID
		    ;

				WHILE (@@FETCH_STATUS = 0)
					BEGIN

						MERGE INTO [dbo].[SCM_MES_RT_SHIP_HISTORY_H] A
						USING ( SELECT I.[RCV_ISS_ID]
									   ,I.[RCV_ISS_TYPE_CODE]
									   ,I.[RCV_ISS_STAT_CODE]
									   ,I.[RCV_DTTM]
									   ,I.[RCV_QTY]
									   ,I.[ISS_DTTM]
									   ,I.[ISS_QTY]
									   ,I.[CNCL_DTTM]
									   ,I.[CNCL_QTY]
									   ,I.[ACT_USERID]
									   /*	--2018-10-18 PIYONG DEL E8동 사용 안함
									   ,CASE WHEN I.NJ_ELEC_FACTORY IN ( 'G452', 'A') AND I.[FROM_AREAID]  = 'E7' THEN 
												'E8'
											 ELSE
												I.[FROM_AREAID]
										 END [FROM_AREAID]
									   ,CASE WHEN I.NJ_ELEC_FACTORY IN ( 'G452', 'A') AND I.[TO_AREAID]  = 'E7' THEN 
												'E8'
											 ELSE
												I.[TO_AREAID]
										 END [TO_AREAID]
										*/
									   ,I.[FROM_AREAID]
									   ,I.[TO_AREAID]
									   ,I.[FROM_SLOC_ID]
									   ,I.[TO_SLOC_ID]
									   ,I.[SHIPTO_ID]
									   ,I.[RTN_TYPE_CODE]
									   ,I.[RCV_QTY2]
									   ,I.[ISS_QTY2]
									   ,I.[CNCL_QTY2]
									   ,I.[TO_SHOPID]
									   ,I.[FROM_SHOPID]
									   ,I.[APPRV_PASS_NO]
									   ,IP.[BOXID]
									   ,IP.[PRODID]
									   ,IP.[BOX_RCV_ISS_STAT_CODE]
									   ,IP.[TOTAL_QTY]
									   ,IP.[TOTAL_QTY2]
									   ,IP.[WIP_DEL_TRGT_FLAG]
									   ,IP.[INSUSER]
									   ,IP.[INSDTTM]
									   ,IP.[UPDUSER]
									   ,IP.[UPDDTTM]
								  FROM [dbo].[SY_XIF_MES_RT_RCV_ISS_R] I
								  INNER JOIN [dbo].[SY_XIF_MES_RT_RCV_ISS_PLLT_R] IP
									 ON (I.IF_SEQ = IP.MASTER_IF_SEQ
										 AND I.RCV_ISS_ID = IP.RCV_ISS_ID)
								  WHERE I.RCV_ISS_TYPE_CODE IN ('SHIP', 'RETURN')
								    AND I.RCV_ISS_STAT_CODE != 'SHIPPED'
									AND IP.PROC_FLAG = 'P'
									AND IP.IF_ID        = @IF_ID  
									AND IP.ACCUM_DATE   = @ACCUM_DATE
								) B
						 ON ( A.RCV_ISS_ID = B.RCV_ISS_ID
							  AND A.BOXID  = B.BOXID )
						WHEN MATCHED THEN
							UPDATE SET   A.RCV_ISS_TYPE_CODE        = B.RCV_ISS_TYPE_CODE          
										,A.RCV_ISS_STAT_CODE        = B.RCV_ISS_STAT_CODE      
										,A.RCV_DTTM		            = B.RCV_DTTM           
										,A.RCV_QTY		            = B.RCV_QTY           
										,A.ISS_DTTM		            = B.ISS_DTTM           
										,A.ISS_QTY		            = B.ISS_QTY           
										,A.CNCL_DTTM		        = B.CNCL_DTTM           
										,A.CNCL_QTY			        = B.CNCL_QTY           
										,A.ACT_USERID	            = B.ACT_USERID           
										,A.FROM_AREAID	            = B.FROM_AREAID         
										,A.TO_AREAID				= B.TO_AREAID
										,A.FROM_SLOC_ID				= B.FROM_SLOC_ID
										,A.TO_SLOC_ID				= B.TO_SLOC_ID						  
										,A.SHIPTO_ID	            = B.SHIPTO_ID             
										,A.RTN_TYPE_CODE	        = B.RTN_TYPE_CODE       
										,A.RCV_QTY2			        = B.RCV_QTY2       
										,A.ISS_QTY2			        = B.ISS_QTY2       
										,A.CNCL_QTY2			    = B.CNCL_QTY2       
										,A.TO_SHOPID			    = B.TO_SHOPID    
										,A.FROM_SHOPID			    = B.FROM_SHOPID    
										,A.APPRV_PASS_NO		    = B.APPRV_PASS_NO    
										,A.PRODID					= B.PRODID    
										,A.BOX_RCV_ISS_STAT_CODE	= B.BOX_RCV_ISS_STAT_CODE   
										,A.TOTAL_QTY				= B.TOTAL_QTY         
										,A.TOTAL_QTY2				= B.TOTAL_QTY2    
										,A.WIP_DEL_TRGT_FLAG        = B.WIP_DEL_TRGT_FLAG
										,A.MODIFY_USER_ID	        = 'PR_XIF_MES_RT_SHIP_HISTORY_R'
										,A.MODIFY_DATE	            = GETDATE()
					                
						WHEN NOT MATCHED THEN
							INSERT ( BOXID
									 ,RCV_ISS_ID
									 ,RCV_ISS_TYPE_CODE
									 ,RCV_ISS_STAT_CODE
									 ,RCV_DTTM
									 ,RCV_QTY
									 ,ISS_DTTM
									 ,ISS_QTY
									 ,CNCL_DTTM
									 ,CNCL_QTY
									 ,ACT_USERID
									 ,FROM_AREAID
									 ,TO_AREAID
									 ,FROM_SLOC_ID
									 ,TO_SLOC_ID
									 ,SHIPTO_ID
									 ,RTN_TYPE_CODE
									 ,RCV_QTY2
									 ,ISS_QTY2
									 ,CNCL_QTY2
									 ,TO_SHOPID
									 ,FROM_SHOPID
									 ,APPRV_PASS_NO
									 ,PRODID
									 ,BOX_RCV_ISS_STAT_CODE
									 ,TOTAL_QTY
									 ,TOTAL_QTY2
									 ,WIP_DEL_TRGT_FLAG
									 ,CREATE_USER_ID
									 ,CREATE_DATE
									 ,MODIFY_USER_ID
									 ,MODIFY_DATE
									)
							VALUES ( B.BOXID
									 ,B.RCV_ISS_ID
									 ,B.RCV_ISS_TYPE_CODE
									 ,B.RCV_ISS_STAT_CODE
									 ,B.RCV_DTTM
									 ,B.RCV_QTY
									 ,B.ISS_DTTM
									 ,B.ISS_QTY
									 ,B.CNCL_DTTM
									 ,B.CNCL_QTY
									 ,B.ACT_USERID
									 ,B.FROM_AREAID
									 ,B.TO_AREAID
									 ,B.FROM_SLOC_ID
									 ,B.TO_SLOC_ID
									 ,B.SHIPTO_ID
									 ,B.RTN_TYPE_CODE
									 ,B.RCV_QTY2
									 ,B.ISS_QTY2
									 ,B.CNCL_QTY2
									 ,B.TO_SHOPID
									 ,B.FROM_SHOPID
									 ,B.APPRV_PASS_NO
									 ,B.PRODID
									 ,B.BOX_RCV_ISS_STAT_CODE
									 ,B.TOTAL_QTY
									 ,B.TOTAL_QTY2
									 ,B.WIP_DEL_TRGT_FLAG
									 ,'PR_XIF_MES_RT_SHIP_HISTORY_R'
									 ,GETDATE()
									 ,'PR_XIF_MES_RT_SHIP_HISTORY_R'
									 ,GETDATE()
									)
						;



						UPDATE IP
							SET PROC_FLAG    = 'Y'
							   ,PROC_DATE    = GETDATE()
						   FROM [dbo].[SY_XIF_MES_RT_RCV_ISS_R] I
						  INNER JOIN [dbo].[SY_XIF_MES_RT_RCV_ISS_PLLT_R] IP
								 ON (I.IF_SEQ = IP.MASTER_IF_SEQ
									 AND I.RCV_ISS_ID = IP.RCV_ISS_ID)
						  WHERE I.RCV_ISS_TYPE_CODE IN ('SHIP', 'RETURN')
							AND IP.PROC_FLAG = 'P'
							AND IP.IF_ID        = @IF_ID  
							AND IP.ACCUM_DATE   = @ACCUM_DATE
						;


					  FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
															  ,@ACCUM_DATE
															  --2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Site 제거
															  --,@SITE_ID
															  ;


					END;

				CLOSE CUR_IF_MES_WIPHIST;
				DEALLOCATE CUR_IF_MES_WIPHIST;


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END

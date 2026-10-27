

CREATE PROCEDURE [dbo].[PR_XIF_ERP_MATERIAL_WAREHOUSING_R] 

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_MATERIAL_WAREHOUSING_R
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_MATERIAL_WAREHOUSING_R
-- Destination Table   : SCM_FCS_MATERIAL_WAREHOUSING_H
--
-- Create Date		   : 2019.12.02
-- Update Date		   : 

-- Author              : piyong
-- Version             : 1.0

-- ================================================================================================

AS

BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_MATERIAL_WAREHOUSING_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @IFSEQNO		bigint;
	DECLARE @COMPANY_ID		nvarchar(30);
	DECLARE @MAT_DOC_ID		nvarchar(30);
	DECLARE @MAT_DOC_YEAR	nvarchar(4);
	DECLARE @MAT_DOC_ITEM	nvarchar(4);

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRANSACTION PR_XIF_ERP_MATERIAL_WAREHOUSING;  
	
	BEGIN TRY

		DECLARE CUR_MATERIAL CURSOR FOR
			SELECT [IFSEQNO]
				   ,[COMPANY_ID]
				   ,[MAT_DOC_ID]
				   ,[MAT_DOC_YEAR]
				   ,[MAT_DOC_ITEM]
			  FROM SY_XIF_ERP_MATERIAL_WAREHOUSING_R EMD
/*			 WHERE EMD.PLANT_ID IN (
										  SELECT PLANT_ID
											FROM SCM_PLANT_M S
										   WHERE CONVERT(NVARCHAR(20), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120)	-- 현재 시간
												 BETWEEN (														-- 기준 시간
															SELECT DISTINCT CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
																			LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
															  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
															 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															   AND V.ACTIVE_FLAG = 'Y'
															   AND V.SEGMENT1    = S.PLANT_ID
														 )
													 AND (
															SELECT DISTINCT DATEADD(MI, 60,	-- 2019-10-13 kimcd class 작업 지연으로 60분으로 작업 대기 시간 연장. 기준 시간 30분 후
																					CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
																					LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
																																					 )
															  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
															 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															   AND V.ACTIVE_FLAG = 'Y'
															   AND V.SEGMENT1    = S.PLANT_ID
														 )
										)
*/
			 ORDER BY IFSEQNO

	

		OPEN CUR_MATERIAL;
			
		FETCH NEXT FROM CUR_MATERIAL INTO @IFSEQNO
										  ,@COMPANY_ID
										  ,@MAT_DOC_ID
										  ,@MAT_DOC_YEAR
										  ,@MAT_DOC_ITEM

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				MERGE INTO SCM_FCS_MATERIAL_WAREHOUSING_H A
				USING (
						SELECT [IFSEQNO]
								,[COMPANY_ID]
								,[MAT_DOC_ID]
								,[MAT_DOC_YEAR]
								,[MAT_DOC_ITEM]
								,[PO_NO]
								,[PO_ITEM_SEQ]
								,[DELIVERY_NO]
								,[DELIVERY_ITEM_SEQ]
								,[DIVISION_ID]
								,[VENDOR_CODE]
								,[VENDOR_NAME]
								,[DOC_INPUT_DATE]
								,[PLANT_ID]
								,[STORAGE_ID]
								,[ITEM_ID]
								,[ITEM_NAME]
								,[RECEIPT_QTY]
								,[HOLD_QTY]
								,[UOM]
								,[CREATE_DATE]
								,[CREATE_TIME]
								,[CREATE_USER_ID]
								,[UPDATE_DATE]
								,[UPDATE_TIME]
								,[UPDATE_USER_ID]
							FROM SY_XIF_ERP_MATERIAL_WAREHOUSING_R EMD
							WHERE [IFSEQNO] = @IFSEQNO
							AND [COMPANY_ID] = @COMPANY_ID
							AND [MAT_DOC_ID] = @MAT_DOC_ID
							AND [MAT_DOC_YEAR] = @MAT_DOC_YEAR
							AND [MAT_DOC_ITEM] = @MAT_DOC_ITEM
						  ) B
					   ON (
							A.[COMPANY_ID]			= B.[COMPANY_ID]
							AND A.[MAT_DOC_ID]		= B.[MAT_DOC_ID]
							AND A.[MAT_DOC_YEAR]	= B.[MAT_DOC_YEAR]
							AND A.[MAT_DOC_ITEM]	= B.[MAT_DOC_ITEM]
						  )
					 WHEN MATCHED THEN
							UPDATE SET A.[IFSEQNO]			= B.[IFSEQNO]
									,A.[PO_NO]				= B.[PO_NO]
									,A.[PO_ITEM_SEQ]		= B.[PO_ITEM_SEQ]
									,A.[DELIVERY_NO]		= B.[DELIVERY_NO]
									,A.[DELIVERY_ITEM_SEQ]	= B.[DELIVERY_ITEM_SEQ]
									,A.[DIVISION_ID]		= B.[DIVISION_ID]
									,A.[VENDOR_CODE]		= B.[VENDOR_CODE]
									,A.[VENDOR_NAME]		= B.[VENDOR_NAME]
									,A.[DOC_INPUT_DATE]		= B.[DOC_INPUT_DATE]
									,A.[PLANT_ID]			= B.[PLANT_ID]
									,A.[STORAGE_ID]			= B.[STORAGE_ID]
									,A.[ITEM_ID]			= B.[ITEM_ID]
									,A.[ITEM_NAME]			= B.[ITEM_NAME]
									,A.[RECEIPT_QTY]		= B.[RECEIPT_QTY]
									,A.[HOLD_QTY]			= B.[HOLD_QTY]
									,A.[UOM]				= B.[UOM]
									,A.[CREATE_DATE]		= B.[CREATE_DATE]
									,A.[CREATE_TIME]		= B.[CREATE_TIME]
									,A.[CREATE_USER_ID]		= B.[CREATE_USER_ID]
									,A.[UPDATE_DATE]		= B.[UPDATE_DATE]
									,A.[UPDATE_TIME]		= B.[UPDATE_TIME]
									,A.[UPDATE_USER_ID]		= B.[UPDATE_USER_ID]
									,A.[TRANSFER_DATE]		= GETDATE()
									,A.[TRANSFER_USER_ID]	= 'PR_XIF_ERP_MATERIAL_WAREHOUSING_R'
					 WHEN NOT MATCHED THEN
						INSERT (
							[IFSEQNO]
							,[COMPANY_ID]
							,[MAT_DOC_ID]
							,[MAT_DOC_YEAR]
							,[MAT_DOC_ITEM]
							,[PO_NO]
							,[PO_ITEM_SEQ]
							,[DELIVERY_NO]
							,[DELIVERY_ITEM_SEQ]
							,[DIVISION_ID]
							,[VENDOR_CODE]
							,[VENDOR_NAME]
							,[DOC_INPUT_DATE]
							,[PLANT_ID]
							,[STORAGE_ID]
							,[ITEM_ID]
							,[ITEM_NAME]
							,[RECEIPT_QTY]
							,[HOLD_QTY]
							,[UOM]
							,[CREATE_DATE]
							,[CREATE_TIME]
							,[CREATE_USER_ID]
							,[UPDATE_DATE]
							,[UPDATE_TIME]
							,[UPDATE_USER_ID]
							,[TRANSFER_DATE]
							,[TRANSFER_USER_ID]
						) VALUES (
							B.[IFSEQNO]
							,B.[COMPANY_ID]
							,B.[MAT_DOC_ID]
							,B.[MAT_DOC_YEAR]
							,B.[MAT_DOC_ITEM]
							,B.[PO_NO]
							,B.[PO_ITEM_SEQ]
							,B.[DELIVERY_NO]
							,B.[DELIVERY_ITEM_SEQ]
							,B.[DIVISION_ID]
							,B.[VENDOR_CODE]
							,B.[VENDOR_NAME]
							,B.[DOC_INPUT_DATE]
							,B.[PLANT_ID]
							,B.[STORAGE_ID]
							,B.[ITEM_ID]
							,B.[ITEM_NAME]
							,B.[RECEIPT_QTY]
							,B.[HOLD_QTY]
							,B.[UOM]
							,B.[CREATE_DATE]
							,B.[CREATE_TIME]
							,B.[CREATE_USER_ID]
							,B.[UPDATE_DATE]
							,B.[UPDATE_TIME]
							,B.[UPDATE_USER_ID]
							,GETDATE()
							,'PR_XIF_ERP_MATERIAL_WAREHOUSING_R'
						)
				;

				FETCH NEXT FROM CUR_MATERIAL INTO @IFSEQNO
												  ,@COMPANY_ID	
												  ,@MAT_DOC_ID
												  ,@MAT_DOC_YEAR
												  ,@MAT_DOC_ITEM

				;

			END

		CLOSE CUR_MATERIAL;
		DEALLOCATE CUR_MATERIAL;


		-- INTERFACE TABLE 데이터 삭제처리
		DELETE 
		  FROM SY_XIF_ERP_MATERIAL_WAREHOUSING_R
		;

		COMMIT WORK;

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', 0, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
	-----------------------------------------------------------------------------------------------------------------------------------------
	END TRY
	-----------------------------------------------------------------------------------------------------------------------------------------

	----------------------------------------------------------------	
	BEGIN CATCH
	----------------------------------------------------------------	
		---- 트랜잭션 (END)

		ROLLBACK TRANSACTION PR_XIF_ERP_MATERIAL_WAREHOUSING;

		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
	----------------------------------------------------------------	
	END CATCH;
	----------------------------------------------------------------	


  END;

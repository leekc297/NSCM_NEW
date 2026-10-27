
CREATE PROCEDURE [dbo].[PR_XIF_DW_SHIPPING_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_DW_SHIPPING_R
-- Param               :
-- Batch Period        : 1Day
-- Description         : MES 재고 정보 전환
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_WIP_R
-- Destination Table   : SCM_DW_SHIPPING_H
--
-- Create Date		   : 2017.11.08
-- Update Date		   : 2018.02.28 PIYONG 1.1
--						 2018.03.21 PIYONG 1.2

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 입력 대상 테이블 변경
--						     DELETE , INSERT  ->  MERGE 변경
--						 1.2 MARKET 추가
-- ================================================================================================

-- PARAMETER

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_SHIPPING_R'
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
	DECLARE @IFSEQNO        NVARCHAR(50)
    DECLARE @WORKDATE   NVARCHAR(50)
    DECLARE @SITE_ID      NVARCHAR(50)
	DECLARE @i_CNT        INTEGER


	DECLARE CUR_IF_DW_SHIPPING CURSOR FOR
		SELECT IFSEQNO, WORKDATE, SITE_ID
		  FROM [SY_XIF_DW_SHIPPING_R]
         WHERE 1=1
           AND TRANSFER_FLAG = 'N'
         GROUP BY IFSEQNO, WORKDATE, SITE_ID
         ORDER BY IFSEQNO, WORKDATE
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
			OPEN CUR_IF_DW_SHIPPING;
			FETCH NEXT FROM CUR_IF_DW_SHIPPING INTO @IFSEQNO        
											    ,@WORKDATE
                                                ,@SITE_ID		

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

						UPDATE [dbo].[SY_XIF_DW_SHIPPING_R]
							SET TRANSFER_FLAG = 'P'
							WHERE ISNULL(TRANSFER_FLAG, 'N') = 'N'
							AND IFSEQNO = @IFSEQNO
							AND WORKDATE =  @WORKDATE
							AND SITE_ID = @SITE_ID
						;

						INSERT INTO [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
								[PROC_NAME],
								[LOG_TYPE],
								[MESSAGE],
								[EVENT_DTTM]
							) VALUES (
								'PR_XIF_DW_SHIPPING_R',
								'LOG',
								CONCAT(' @IFSEQNO > ', @IFSEQNO ,' @SITE_ID > ', @SITE_ID, ' @WORKDATE > ',@WORKDATE ),
								GETDATE()
							)
						;
								

						MERGE INTO [dbo].[SCM_DW_SHIPPING_H] A
						USING ( SELECT (SELECT TOP 1 COMPANY_ID FROM SCM_FACTORY_M WHERE PLANT_ID = A.PLANT_ID) AS COMPANY_ID
										,(SELECT TOP 1 DIVISION_ID FROM SCM_FACTORY_M WHERE PLANT_ID = A.PLANT_ID) AS DIVISION_ID
										, CASE WHEN SITE_ID  = 'WH01'THEN
													'A001'
											   WHEN SITE_ID  = 'WH02'THEN
													'A002'
											   WHEN SITE_ID  = 'WH03'THEN
													'A002'
											   WHEN SITE_ID  = 'WH04'THEN
													'A003'
											   WHEN SITE_ID  = 'WH05'THEN
													'A004'
												 END   AS SITE_ID
										,PLANT_ID
										,BUILDING AS FACTORY_ID
										,A.ITEM_ID
										,SHIPPING_TYPE
										,GI_DATE AS SHIP_DATE
										,A.MARKET				-- 2018-03-21 PIYONG ADD
            							,SUM(A.GI_QTY) QTY
            							,'PR_XIF_DW_SHIPPING_R' AS INSERT_ID
            							,GETDATE() AS INSERT_TIME
            							,'PR_XIF_DW_SHIPPING_R' AS UPDATE_ID
            							,GETDATE() AS UPDATE_TIME
								   FROM [dbo].[SY_XIF_DW_SHIPPING_R] A WITH(NOLOCK)
								  WHERE A.TRANSFER_FLAG = 'P'
									AND A.IFSEQNO = @IFSEQNO
									AND A.SITE_ID = @SITE_ID
									AND A.WORKDATE = @WORKDATE
								  GROUP BY A.IFSEQNO
										,A.SITE_ID
										,A.PLANT_ID
										,A.BUILDING
										,A.WORKDATE
										,A.GI_DATE
										,A.ITEM_ID
										,A.SHIPPING_TYPE
										,A.MARKET				-- 2018-03-21 PIYONG ADD
									
							  ) B
						   ON (
							      A.[COMPANY_ID] = B.[COMPANY_ID]
								  AND A.[DIVISION_ID] = B.[DIVISION_ID]
								  AND A.[SITE_ID] = B.[SITE_ID]
								  AND A.[PLANT_ID] = B.[PLANT_ID]
								  AND A.[FACTORY_ID] = B.[FACTORY_ID]
								  AND A.[ITEM_ID] = B.[ITEM_ID]
								  AND A.[SHIPPING_TYPE] = B.[SHIPPING_TYPE]
								  AND A.[SHIP_DATE] = B.[SHIP_DATE]
							  )
						 WHEN MATCHED THEN                                                                                                                                                                                                                                                                 
							UPDATE SET [QTY] =  B.[QTY]
									   ,[MARKET] = B.[MARKET]				-- 2018-03-21 PIYONG ADD
										,[UPDATE_ID] =  B.UPDATE_ID
										,[UPDATE_TIME] =  B.UPDATE_TIME
						 WHEN NOT MATCHED THEN                                                                                                                  
							INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[ITEM_ID]
								,[SHIPPING_TYPE]
								,[SHIP_DATE]
								,[QTY]
								,[MARKET]				-- 2018-03-21 PIYONG ADD
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
							)VALUES (
								B.[COMPANY_ID]
								,B.[DIVISION_ID]
								,B.[SITE_ID]
								,B.[PLANT_ID]
								,B.[FACTORY_ID]
								,B.[ITEM_ID]
								,B.[SHIPPING_TYPE]
								,B.[SHIP_DATE]
								,B.[QTY]
								,B.[MARKET]				-- 2018-03-21 PIYONG ADD
								,B.INSERT_ID
								,B.INSERT_TIME
								,B.UPDATE_ID
								,B.UPDATE_TIME
							)
			;
						


						SET @ROWCOUNT = @@ROWCOUNT

						UPDATE [dbo].[SY_XIF_DW_SHIPPING_R]
						   SET TRANSFER_FLAG = 'Y'
							   ,TRANSFER_DATE = GETDATE()
						 WHERE TRANSFER_FLAG = 'P'
							AND IFSEQNO = @IFSEQNO
							AND WORKDATE = @WORKDATE
							AND SITE_ID = @SITE_ID
						;


				FETCH NEXT FROM CUR_IF_DW_SHIPPING INTO @IFSEQNO        
													,@WORKDATE
													,@SITE_ID
				;

				END;

			CLOSE CUR_IF_DW_SHIPPING;
			DEALLOCATE CUR_IF_DW_SHIPPING;  

 

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

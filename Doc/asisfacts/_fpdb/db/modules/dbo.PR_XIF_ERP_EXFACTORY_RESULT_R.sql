
CREATE PROCEDURE [dbo].[PR_XIF_ERP_EXFACTORY_RESULT_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_EXFACTORY_RESULT_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP XI
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_EXFACTORY_RESULT_R
-- Destination Table   : SCM_SHIPPING_RESULT_H
--
-- Create Date		   : 2016.08.16
-- Update Date		   : 2018.05.08 PIYONG 2.0
--					   : 2018.06.08 PIYONG 2.1
--					   : 2018.08.30 PIYONG 2.2
--					   : 2022.03.24 kimcd  2.3

-- Author              : 김 석
-- Version             : 1.0
--						 2.0  CUTOFF_DATE 기준으로 삭제 하는 로직 제거
--							  SCM_SHIPPING_RESULT_H INSERT -> MERGE 변경
--						 2.1  BOOK_KEEPING_DATE 추가
--							  기존 SHIP_DATE 데이터를 BOOK_KEEPING_DATE 컬럼에
--							  신규 BOOK_KEEPING_DATE컬럼에 PLANT_ISSUE_DATE 값을 입력
--							  실제 공장에서 출하되는 날짜가 PLANT_ISSUE_DATE
--						 2.2  SEQ에서 DOC_TYPE+DOC_SEQ 제거
--							  DOC_SEQ 정보 수신 안 받음
--							  DOC_TYPE에 전표번호 정보 대신 Transaction 상태를 수신
--                       2.3  2022-03-24 kimcd 가상 Divsion 사용에 따른 수신 Division 보완
-- ================================================================================================

-- ERP요청 SEQNO
@P_IFSEQNO NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_EXFACTORY_RESULT_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	--DECLARE @COMPANY     NVARCHAR(1000)


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
		  
		IF @P_IFSEQNO = 'NULL' or @P_IFSEQNO is null
		   SET @P_IFSEQNO = (
							 SELECT MAX(IFSEQNO)
							   FROM [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R] WITH(NOLOCK)
							  WHERE TRANSFER_FLAG = 'N'
							)

		UPDATE [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R]
		   SET TRANSFER_FLAG = 'P'
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'N'
		;

		-- CUTOFF_DATE 기준으로 삭제		--2018-05-08 PIYONG DEL
		/*
		DELETE FROM [dbo].[SCM_SHIPPING_RESULT_H]
         WHERE CUTOFF_DATE IN ( SELECT DISTINCT DATEADD(DD,-1,CAST([TRNF_DATE] AS DATE)) AS CUTOFF_DATE
		                          FROM [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R] A WITH(NOLOCK)
	                             WHERE IFSEQNO       = @P_IFSEQNO
		                           AND TRANSFER_FLAG = 'P'
			                 )
		;
	

		--UPDATE [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R] SET TRANSFER_FLAG = 'N' WHERE IFSEQNO = '2016092315512147'
		----2018-05-08 PIYONG  INSERT -> MERGE

		INSERT INTO [dbo].[SCM_SHIPPING_RESULT_H]
				   ([COMPANY_ID]
				   ,[DIVISION_ID]
				   ,[SITE_ID]
				   ,[PLANT_ID]
				   ,[CUTOFF_DATE]
				   ,[SEQ]
				   ,[SHOP_GROUP_ID]
				   ,[ITEM_ID]
				   ,[QTY]
				   ,[SHIP_DATE]
				   ,[TO_SITE_ID]
				   ,[TO_PLANT_ID]
				   ,[CUSTOMER_ID]
				   ,[PRODUCTION_TYPE]
				   ,[DESCRIPTION]
				   ,[INSERT_ID]
				   ,[INSERT_TIME]
				   ,[UPDATE_ID]
				   ,[UPDATE_TIME])
			SELECT  [COMPANY_ID]
			       ,[DIVISION_ID]
                   ,[SITE_ID]
                   ,[PLANT_ID]
                   ,[CUTOFF_DATE]
                   ,ROW_NUMBER() OVER( ORDER BY A.[COMPANY_ID], A.[DIVISION_ID], A.[PLANT_ID], A.[CUTOFF_DATE] ) AS SEQ
                   ,[SHOP_GROUP_ID]
                   ,[ITEM_ID]
                   ,SUM(CAST([QTY] AS NUMERIC(20,10))) AS QTY
                   ,[SHIP_DATE]
                   ,[TO_SITE_ID]
                   ,[TO_PLANT_ID]
                   ,[CUSTOMER_ID]
                   ,'MASS' AS PRODUCTION_TYPE
                   ,NULL AS DESCRIPTION
                   ,'PR_XIF_ERP_EXFACTORY_RESULT_R'
                   ,GETDATE()
                   ,'PR_XIF_ERP_EXFACTORY_RESULT_R'
                   ,GETDATE()
			  FROM (
					SELECT [COMPANY] AS COMPANY_ID
						   ,[DIVISION] AS DIVISION_ID
						   ,(SELECT MAX(SITE_ID) FROM [dbo].[SCM_PLANT_M] WHERE PLANT_ID = A.PLANT_ID) AS SITE_ID
						   ,[PLANT_ID]
						   ,CAST([TRNF_DATE] AS DATE) AS CUTOFF_DATE
						   ,NULL AS SEQ
						   ,NULL AS SHOP_GROUP_ID
						   ,[ITEM_ID]
						   ,[ORDER_QTY] AS QTY
						   --,[ACTUAL_EXFACTORY_DATE] AS SHIP_DATE
						   /* 테스트데이터로 00000000로 들어가있어 NULL로 넣음 */
						   ,CASE WHEN [ACTUAL_EXFACTORY_DATE] = '00000000' THEN NULL
						    ELSE [ACTUAL_EXFACTORY_DATE]
							 END AS SHIP_DATE
						   ,B.SITE_ID AS TO_SITE_ID
						   ,B.PLAN_ID AS TO_PLANT_ID
						   ,A.[BILLTO_CODE] AS CUSTOMER_ID
					  FROM [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R] A WITH(NOLOCK) LEFT OUTER JOIN
						   (
                            SELECT SEGMENT1 AS BILLTO_CODE,
                            	   SEGMENT3 AS SITE_ID,
                            	   SEGMENT4 AS PLAN_ID
                              FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
                             WHERE LOOKUP_TYPE_CODE = 'BILLTO_CODE_MAPPING'
						   ) B
					 
					 ON  A.BILLTO_CODE     = B.BILLTO_CODE
					 WHERE 1=1
					   AND A.[IFSEQNO]     = @P_IFSEQNO
					   AND A.TRANSFER_FLAG = 'P'
					) A
			  GROUP BY [COMPANY_ID]
			          ,[DIVISION_ID]
				      ,[SITE_ID]
				      ,[PLANT_ID]
				      ,[CUTOFF_DATE]
				      ,[SEQ]
				      ,[SHOP_GROUP_ID]
				      ,[ITEM_ID]
				      ,[SHIP_DATE]
				      ,[TO_SITE_ID]
				      ,[TO_PLANT_ID]
				      ,[CUSTOMER_ID]
		;
		*/

		MERGE INTO [dbo].[SCM_SHIPPING_RESULT_H] A
		USING (
				SELECT [COMPANY] AS COMPANY_ID
					   ,ISNULL( PD.PSEUDO_DIVISION_ID, [DIVISION]) AS DIVISION_ID -- 2022-03-24 kimcd 가상 Division 로직 추가
					   ,(SELECT MAX(SITE_ID) FROM [dbo].[SCM_PLANT_M] WHERE PLANT_ID = A.PLANT_ID) AS SITE_ID
					   ,A.[PLANT_ID]
					   ,SEQ
					   ,NULL AS SHOP_GROUP_ID
					   ,[ITEM_ID]
					   ,[EXFACTORY_QTY] AS QTY
						/* 테스트데이터로 00000000로 들어가있을 경우  [SYSTEM_EXFACTORY_DATE] 값을 넣음 */
					   ,CASE WHEN [ACTUAL_EXFACTORY_DATE] = '00000000' THEN
								[SYSTEM_EXFACTORY_DATE]
							 ELSE
								[ACTUAL_EXFACTORY_DATE]
							  END AS BOOK_KEEPING_DATE						--2018-06-08 PIYONG SHIP_DATE -> BOOK_KEEPING_DATE 변경
					   ,B.SITE_ID AS TO_SITE_ID
					   ,B.PLAN_ID AS TO_PLANT_ID
					   ,A.[BILLTO_CODE] AS CUSTOMER_ID
					   ,NULL AS [PRODUCTION_TYPE]
					   ,NULL AS [TRANSPORT_MODE]
					   ,[SO_NO]
					   ,[SO_ITEM_SEQ]
					   ,[DELIVERY_NO]
					   ,[DELIVERY_PARTNO]
					   ,[DOC_TYPE]
				--	   ,[DOC_SEQ]											-- 2018-08-30 PIYONG DEL
					   ,[SYSTEM_EXFACTORY_DATE]
					   ,CASE WHEN [PLANT_ISSUE_DATE] = '00000000' THEN		--2018-06-08 PIYONG ADD
								NULL
							 ELSE
								[PLANT_ISSUE_DATE]
							  END AS SHIP_DATE
				  FROM (
						SELECT COMPANY
							   ,DIVISION
							   ,PLANT_ID
							   ,SO_NO+SO_ITEM_SEQ+ DELIVERY_NO+DELIVERY_PARTNO AS SEQ		-- 2018-08-30 PIYONG  + DOC_TYPE+DOC_SEQ DEL
							   ,MAX(ITEM_ID) AS ITEM_ID
							   ,SO_NO
							   ,SO_ITEM_SEQ
							   ,DELIVERY_NO
							   ,DELIVERY_PARTNO
							   ,MAX(ACTUAL_EXFACTORY_DATE ) AS ACTUAL_EXFACTORY_DATE
							   ,MAX(SYSTEM_EXFACTORY_DATE ) AS SYSTEM_EXFACTORY_DATE
							   ,[DOC_TYPE]
							   --,[DOC_SEQ]													-- 2018-08-30 PIYONG DEL
							   ,SUM(CAST(EXFACTORY_QTY AS NUMERIC) ) AS EXFACTORY_QTY
   							   ,MAX(BILLTO_CODE) AS BILLTO_CODE
							   ,MAX(PLANT_ISSUE_DATE) AS PLANT_ISSUE_DATE					-- 2018-06-08 PIYONG ADD
						  FROM(
								-- 2018-08-30 PIYONG DOC_TYPE이 D90(DO 삭제) 경우
								-- COMPANY, DIVISION, PLANT_ID 정보가 안들어 올수도 있어 FP 테이블에 생성 되어 있는 정보를 찾아 입력
								SELECT	ISNULL(COMPANY, (
														SELECT TOP 1 COMPANY_ID
														  FROM [SCM_SHIPPING_RESULT_H]
														 WHERE SEQ = SO_NO+SO_ITEM_SEQ+ DELIVERY_NO+DELIVERY_PARTNO
														) ) AS COMPANY
									   ,ISNULL(DIVISION, (
														SELECT TOP 1 DIVISION
														  FROM [SCM_SHIPPING_RESULT_H]
														 WHERE SEQ = SO_NO+SO_ITEM_SEQ+ DELIVERY_NO+DELIVERY_PARTNO
														) ) AS DIVISION
									   ,ISNULL(PLANT_ID, (
														SELECT TOP 1 PLANT_ID
														  FROM [SCM_SHIPPING_RESULT_H]
														 WHERE SEQ = SO_NO+SO_ITEM_SEQ+ DELIVERY_NO+DELIVERY_PARTNO
														) ) AS PLANT_ID
									   ,SO_NO+SO_ITEM_SEQ+ DELIVERY_NO+DELIVERY_PARTNO AS SEQ		-- 2018-08-30 PIYONG  + DOC_TYPE+DOC_SEQ DEL
									   ,ITEM_ID
									   ,SO_NO
									   ,SO_ITEM_SEQ
									   ,DELIVERY_NO
									   ,DELIVERY_PARTNO
									   ,ACTUAL_EXFACTORY_DATE
									   ,SYSTEM_EXFACTORY_DATE
									   ,[DOC_TYPE]
									   ,EXFACTORY_QTY
   									   ,BILLTO_CODE
									   ,PLANT_ISSUE_DATE
								   FROM [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R] A WITH(NOLOCK) 
								 WHERE IFSEQNO = @P_IFSEQNO
								   AND TRANSFER_FLAG = 'P'
								   AND ORDER_TYPE != 'ZKN'
						       ) AA
						 GROUP BY COMPANY
							   ,DIVISION
							   ,PLANT_ID
							   ,SO_NO
							   ,SO_ITEM_SEQ
							   ,DELIVERY_NO
							   ,DELIVERY_PARTNO
							   ,DOC_TYPE
						--	   ,DOC_SEQ														-- 2018-08-30 PIYONG DEL
						--	   ,PLANT_ISSUE_DATE											-- 2018-06-08 PIYONG ADD  -- 2018-08-30 PIYONG DEL		
						) A
				   LEFT OUTER JOIN (
									SELECT SEGMENT1 AS BILLTO_CODE,
                            			   SEGMENT3 AS SITE_ID,
                            			   SEGMENT4 AS PLAN_ID
									  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									 WHERE LOOKUP_TYPE_CODE = 'BILLTO_CODE_MAPPING'
									) B
								ON  A.BILLTO_CODE = B.BILLTO_CODE
				   LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
					 ON PD.PLANT_ID = A.PLANT_ID
			  ) B
		  ON ( A.COMPANY_ID = B.COMPANY_ID
		       AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
			   AND A.PLANT_ID = B.PLANT_ID
			   AND A.SEQ = B.SEQ
		     )
		WHEN MATCHED THEN
			UPDATE SET [SHOP_GROUP_ID] =  B.[SHOP_GROUP_ID]
						,[ITEM_ID] =  B.[ITEM_ID]
						,[QTY] =  B.[QTY]
						,[SHIP_DATE] =  ISNULL(B.[SHIP_DATE], B.[BOOK_KEEPING_DATE])
						,[TO_SITE_ID] =  B.[TO_SITE_ID]
						,[TO_PLANT_ID] =  B.[TO_PLANT_ID]
						,[CUSTOMER_ID] =  B.[CUSTOMER_ID]
						,[PRODUCTION_TYPE] =  B.[PRODUCTION_TYPE]
						,[TRANSPORT_MODE] =  B.[TRANSPORT_MODE]
						,[SO_NO] =  B.[SO_NO]
						,[SO_ITEM_SEQ] =  B.[SO_ITEM_SEQ]
						,[DELIVERY_NO] =  B.[DELIVERY_NO]
						,[DELIVERY_PARTNO] =  B.[DELIVERY_PARTNO]
						,[DOC_TYPE] =  B.[DOC_TYPE]
					--	,[DOC_SEQ] =  B.[DOC_SEQ]											-- 2018-08-30 PIYONG DEL
						,[SYSTEM_EXFACTORY_DATE] =  B.[SYSTEM_EXFACTORY_DATE]
						,[BOOK_KEEPING_DATE] = B.[BOOK_KEEPING_DATE]						-- 2018-06-08 PIYONG ADD
						,[UPDATE_ID] = 'PR_XIF_ERP_EXFACTORY_RESULT_R'
						,[UPDATE_TIME] =  GETDATE()
						
		WHEN NOT MATCHED THEN
			INSERT ( 
				[COMPANY_ID]
				,[DIVISION_ID]
				,[SITE_ID]
				,[PLANT_ID]
				,[SEQ]
				,[SHOP_GROUP_ID]
				,[ITEM_ID]
				,[QTY]
				,[SHIP_DATE]
				,[TO_SITE_ID]
				,[TO_PLANT_ID]
				,[CUSTOMER_ID]
				,[PRODUCTION_TYPE]
				,[TRANSPORT_MODE]
				,[SO_NO]
				,[SO_ITEM_SEQ]
				,[DELIVERY_NO]
				,[DELIVERY_PARTNO]
				,[DOC_TYPE]
			--	,[DOC_SEQ]																	-- 2018-08-30 PIYONG DEL
				,[SYSTEM_EXFACTORY_DATE]		  
				,[BOOK_KEEPING_DATE]														--2018-06-08 PIYONG ADD
				,[INSERT_ID]
				,[INSERT_TIME]
				,[UPDATE_ID]
				,[UPDATE_TIME]
			) VALUES (
				B.[COMPANY_ID]
				,B.[DIVISION_ID]
				,B.[SITE_ID]
				,B.[PLANT_ID]
				,B.[SEQ]
				,B.[SHOP_GROUP_ID]
				,B.[ITEM_ID]
				,B.[QTY]
				,ISNULL(B.[SHIP_DATE], B.[BOOK_KEEPING_DATE])
				,B.[TO_SITE_ID]
				,B.[TO_PLANT_ID]
				,B.[CUSTOMER_ID]
				,B.[PRODUCTION_TYPE]
				,B.[TRANSPORT_MODE]
				,B.[SO_NO]
				,B.[SO_ITEM_SEQ]
				,B.[DELIVERY_NO]
				,B.[DELIVERY_PARTNO]
				,B.[DOC_TYPE]
			--	,B.[DOC_SEQ]																-- 2018-08-30 PIYONG DEL
				,B.[SYSTEM_EXFACTORY_DATE]
				,B.[BOOK_KEEPING_DATE]														--2018-06-08 PIYONG ADD
				,'PR_XIF_ERP_EXFACTORY_RESULT_R'
				,GETDATE()
				,'PR_XIF_ERP_EXFACTORY_RESULT_R'
				,GETDATE()
			)
		;

		SET @ROWCOUNT = @@ROWCOUNT

		UPDATE [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R]
		   SET TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = GETDATE()
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'P'
		;


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
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END






CREATE PROCEDURE [dbo].[PR_XIF_ERP_INVENTORY_R]

-- ================================================================================================
-- Program ID          : FP00880
-- Program Name        : PR_XIF_ERP_INVENTORY_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP XI
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_INVENTORY_R
-- Destination Table   : SCM_STOCK_H
--
-- Create Date		   : 2016.08.16
-- Update Date		   : 2017.04.21 PIYONG 1.2
--					   : 2017-05-08 PIYONG 1.4
--					   : 2018-01-10 PIYONG 1.5
--					   : 2018-02-13 PIYONG 1.6
--						 2018-08-06	PIYONG 1.7
--						 2018-09-03 PIYONG 2.0
--						 2018-10-19 PIYONG 2.1
--						 2018-10-23 PIYONG 2.2
--						 2019-04-18 PIYONG 2.3
--						 2019-05-22 PIYONG 2.4
--						 2022-03-24 kimcd  2.5
--						 2022-07-06 kimcd  2.6
--						 2022-11-28 leeseongmin  2.7

-- Author              : 김 석
-- Version             : 1.1   kimcd 201-01-03 add ERP inventory  toss to RCCP
--                     : 1.2   SCM_STOCK_H DELETE terms ADD
--                     : 1.3   ADD FP_APPLY_ITEM_ID kimcd 2017-05-04
--					   : 1.4   ADD QTY2
--					   : 1.5   GMES 재고 빼고 SCM_STOCK_H 에 입력
--					   : 1.6   FORMATION_TARGET_NETTING LOOK UP 관련 로직 삭제
--						 1.7   이동재고 추가
--						 2.0	SCM_STOCK_H 삭제 로직 변경
--						 2.1	RCCP 전송 로직 삭제
--						 2.2	DEFECT_QTY 추가
--						 2.3	PROCESS 실행 조건 추가
--						 2.4	SCM_STOCK_H 테이블에 적재 조건 추가  HOLD 수량이 > 0
--								SCM_STOCK_H 테이블에 적재 MERGE -> INSERT
--                       2.5   2022-03-24 kimcd 가상 Division 사용으로 로직 수정
--                       2.6   2022-07-06 kimcd from plant id 값 추가 수신
--                       2.7   2022-11-28 leeseongmin  RESTRICT QTY (제한사용 수량) 추가 수신
--                       2.8   2023.03.30 / CUSTOMER_ID, SPECIAL_STOCK_INDICATOR 추가 수신
--                       2.9   2023.06.14 FP Pjt. E20230613-000425 / ERP 재고 수신시 음수재고 미반영으로 인한 과다재고 산출
--                       3.0   2025.03.18 FP Pjt. QT_ISP_QTY(Q재고) 칼럼 추가하고 QTY+ISNULL(QT_ISP_QTY, 0) 처리
--                       3.1   2026.01.28 E20260128-000983 ERP 재고 I/F 프로그램 중 SEQ 발췌 로직 이상 수정건
-- ================================================================================================

-- ERP요청 SEQNO
@P_IFSEQNO NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_INVENTORY_R'
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
	DECLARE @SEQ_CNT	NUMERIC(20,10) --2018-09-03 PIYONG ADD


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
		  
			--UPDATE [dbo].[SY_XIF_ERP_INVENTORY_R] SET TRANSFER_FLAG = 'N' WHERE IFSEQNO = '2016112407011595'
			IF @P_IFSEQNO = 'NULL' OR @P_IFSEQNO IS NULL
			   SET @P_IFSEQNO = (SELECT MAX(IFSEQNO) FROM [dbo].[SY_XIF_ERP_INVENTORY_R] WITH(NOLOCK)
								  WHERE TRANSFER_FLAG = 'N'
								)

			IF @P_IFSEQNO != 'NULL' AND @P_IFSEQNO IS NOT NULL		--2019-04-18 PIYONG ADD
				BEGIN
					UPDATE [dbo].[SY_XIF_ERP_INVENTORY_R]
					   SET TRANSFER_FLAG = 'P'
					 WHERE IFSEQNO       = @P_IFSEQNO
					   AND TRANSFER_FLAG = 'N'
				;

				/*	--2018-10-19 piyong delete
				-- kimcd 201-01-03 add start ERP inventory  toss to RCCP
				INSERT INTO [dbo].[SY_XIF_RCCP_ERP_INVENTORY_S]
					  ([IF_SEQ]
					  ,[IF_TYPE]
					  ,[IF_ID]
					  ,[IF_INS_DATE]
					  ,[IF_FLAG]
					  ,[IF_SND_DATE]
					  ,[IFSEQNO]
					  ,[COMPANY]
					  ,[DIVISION]
					  ,[PLANT_ID]
					  ,[BUILDING]
					  ,[ITEM_ID]
					  ,[SLOC]
					  ,[VENDOR_CODE]
					  ,[EX_DATE]
					  ,[EX_TIME]
					  ,[GOOD_QTY]
					  ,[DEFECT_QTY]
					  ,[HOLD_QTY]
					  ,[UOM]
					  ,[CREATE_USER_ID]
					  ,[CREATE_DATE]
					  ,[MODIFY_USER_ID]
					  ,[MODIFY_DATE])
				SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR)
					  ,'S'
					  ,'OFP0_ORCP_FP_ERP_INVENTORY'
					  ,GETDATE()
					  ,'N'
					  ,NULL
					  ,[IFSEQNO]
					  ,[COMPANY]
					  ,[DIVISION]
					  ,[PLANT_ID]
					  ,[BUILDING]
					  ,A.[ITEM_ID]
					  ,[SLOC]
					  ,[VENDOR_CODE]
					  ,[EX_DATE]
					  ,[EX_TIME]
					  ,[GOOD_QTY]
					  ,[DEFECT_QTY]
					  ,[HOLD_QTY]
					  ,[UOM]
					  ,[CREATE_USER_ID]
					  ,[CREATE_DATE]
					  ,[MODIFY_USER_ID]
					  ,[MODIFY_DATE]
				FROM   DBO.SY_XIF_ERP_INVENTORY_R A WITH(NOLOCK)
			INNER JOIN [DBO].SCM_ITEM_M D
						ON A.ITEM_ID = D.ITEM_ID
						AND A.DIVISION = d.DIVISION_ID
						AND (SELECT TOP 1 C.SITE_ID
							   FROM [dbo].[SCM_PLANT_M] C
							  WHERE C.PLANT_ID = A.PLANT_ID) = D.SITE_ID
			INNER JOIN [DBO].[SCM_ITEM_CLASS_M] M
						ON D.ITEM_CLASS = M.CLASS_ID
						AND M.USE_FLAG = 'Y'
				WHERE  IFSEQNO       = @P_IFSEQNO
				AND    TRANSFER_FLAG = 'P';
				-- kimcd 201-01-03 add end ERP inventory  toss to RCCP

				-- CUTOFF_DATE 기준으로 삭제
				DELETE H
				  FROM [dbo].[SCM_STOCK_H] H
				 WHERE CUTOFF_DATE IN ( SELECT DISTINCT CAST(A.[EX_DATE] AS DATE) AS CUTOFF_DATE
										  FROM [dbo].[SY_XIF_ERP_INVENTORY_R] A WITH(NOLOCK)
										 WHERE IFSEQNO       = @P_IFSEQNO
										   AND TRANSFER_FLAG = 'P'
									 )
				   -- 지역별로 다른 timeline에 재고를 ERP에서 전송해줌.
				   --2018-09-03 PIYONG COMPANY -> EXSITS 변경  ERP에서 여러번 나눠 전송으로 변경
				   AND EXISTS  ( SELECT 1
								   FROM [dbo].[SY_XIF_ERP_INVENTORY_R] A WITH(NOLOCK)
								  WHERE IFSEQNO       = @P_IFSEQNO
									AND TRANSFER_FLAG = 'P'
									AND A.PLANT_ID = H.PLANT_ID
									AND A.ITEM_ID = H.ITEM_ID
									AND ISNULL(A.SLOC,'-') = ISNULL(H.STORAGE_ID,'-')
								)
				   AND STOCK_TYPE IN ('SUPPLY', 'INVENTORY')
				;
				*/

				--------------------------------------------------------------------------------------------------
				--2018-09-03 PIYONG ADD
					SET @SEQ_CNT = (
									SELECT ISNULL(MAX(SEQ),0)  AS SEQ
									  FROM [dbo].[SCM_STOCK_H] H
									 WHERE CUTOFF_DATE IN ( SELECT DISTINCT CAST(A.[EX_DATE] AS DATE) AS CUTOFF_DATE
															  FROM [dbo].[SY_XIF_ERP_INVENTORY_R] A WITH(NOLOCK)
															 WHERE IFSEQNO       = @P_IFSEQNO
															   AND TRANSFER_FLAG = 'P'
														  )
									   -- AND STOCK_TYPE IN ('SUPPLY', 'INVENTORY')-- 2026.01.28 E20260128-000983 ERP 재고 I/F 프로그램 중 SEQ 발췌 로직 이상 수정건
									);
/*				--2019-05-22 PIYONG DELL

				MERGE INTO [dbo].[SCM_STOCK_H] A
				USING ( 

						SELECT A.COMPANY_ID
							  ,A.DIVISION_ID
							  --,B.SITE_ID
							  ,(SELECT TOP 1 C.SITE_ID
								  FROM [dbo].[SCM_PLANT_M] C
								 WHERE C.PLANT_ID = A.PLANT_ID) AS SITE_ID
							  ,A.PLANT_ID
							  --,B.FACTORY_ID
							  ,CASE WHEN A.FACTORY_ID IS NULL THEN '-'
							   ELSE A.FACTORY_ID
								END AS FACTORY_ID
							  ,ISNULL(A.STORAGE_ID, '-') AS STORAGE_ID
							  ,A.CUTOFF_DATE
							  ,A.SEQ
							  ,A.[ITEM_ID]      
							  ,A.CUTOFF_TIME
							  ,A.QTY
							  ,A.[DEFECT_QTY]
							  ,A.[HOLD_QTY]
							  ,A.QTY_UOM
							  ,A.CUTOFF_DATETIME
							  ,A.OUTSOURCING_FACTORY
							  ,A.MOVING_QTY												-- PIYONG ADD 2018-08-06
						  FROM (
								SELECT A.[COMPANY]  AS COMPANY_ID
										,A.[DIVISION] AS DIVISION_ID
										,A.[PLANT_ID]
										,A.BUILDING   AS FACTORY_ID
										,A.[SLOC]     AS STORAGE_ID
										,A.[EX_DATE]  AS CUTOFF_DATE
										,@SEQ_CNT + ROW_NUMBER() OVER( ORDER BY A.[EX_DATE], A.[COMPANY], A.[DIVISION], A.[PLANT_ID], A.[ITEM_ID], A.[SLOC]
																			 , A.[VENDOR_CODE], A.[GOOD_QTY] DESC ) AS SEQ	-- 2018-09-03 PIYONG  A.[VENDOR_CODE] ADD
										,A.[ITEM_ID]      
										,A.[EX_TIME]  AS CUTOFF_TIME
										,ISNULL(A.[GOOD_QTY],0) AS QTY
										,A.[DEFECT_QTY]
										,A.[HOLD_QTY]
										,A.[UOM] AS QTY_UOM
										,A.[EX_DATE]+A.[EX_TIME] AS CUTOFF_DATETIME
										,A.VENDOR_CODE AS OUTSOURCING_FACTORY
										,A.MOVING_QTY									-- PIYONG ADD 2018-08-06
								   FROM [dbo].[SY_XIF_ERP_INVENTORY_R] A WITH(NOLOCK)
									--WHERE A.IFSEQNO = '2016112407011595'
								  WHERE [IFSEQNO]  = @P_IFSEQNO
									AND [TRANSFER_FLAG] = 'P'
		/*							-- PIYONG 2018-02-13 삭제
									AND NOT EXISTS (
														SELECT 1
															FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE SLV.LOOKUP_TYPE_CODE LIKE 'FORMATION_TARGET_NETTING%'
															AND SLV.SEGMENT2 = (SELECT DISTINCT SITE_ID FROM SCM_FACTORY_M WHERE PLANT_ID = A.[PLANT_ID])
															AND SLV.SEGMENT3 = A.[PLANT_ID]
															AND SLV.SEGMENT5 = A.[SLOC]
															AND ISNULL(SLV.ATTRIBUTE1, 'N') = 'Y'
											)	
		*/
							  ) A
						WHERE ( CAST (A.MOVING_QTY AS NUMERIC) > 0 OR CAST ( A.QTY AS NUMERIC ) > 0		--2018-09-03 PIYONG ADD 삭제된 수량 제거
								OR  CAST (A.DEFECT_QTY AS NUMERIC) > 0									--2019-05-22 PIYONG ADD DEFECT_QTY
							  ) 
					  ) B
				   ON ( A.COMPANY_ID  = B.COMPANY_ID
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.SITE_ID     = B.SITE_ID
						AND A.PLANT_ID    = B.PLANT_ID
						AND A.FACTORY_ID  = B.FACTORY_ID
						AND A.STORAGE_ID  = B.STORAGE_ID
						AND A.CUTOFF_DATE = B.CUTOFF_DATE
						AND A.SEQ         = B.SEQ
					   )
				  WHEN MATCHED THEN
					UPDATE SET A.ITEM_ID		  = B.ITEM_ID
						   ,A.FP_APPLY_ITEM_ID    = B.ITEM_ID -- kimcd add 2017-05-04
						   ,A.QTY                 = CAST(B.QTY AS NUMERIC(20,10))
						   ,A.QTY2                = CAST(B.QTY AS NUMERIC(20,10))-- PIYONG ADD 2017-05-08
						   ,A.QTY_UOM             = B.QTY_UOM
						   ,A.OUTSOURCING_FACTORY = B.OUTSOURCING_FACTORY
						   ,A.MOVING_QTY		  = CAST(B.MOVING_QTY AS NUMERIC(20,10))			-- PIYONG ADD 2018-08-06
						   ,A.DEFECT_QTY		  = CAST(B.DEFECT_QTY AS NUMERIC(20,10))			-- PIYONG ADD 2018-10-23
						   ,A.UPDATE_ID           = 'PR_XIF_ERP_INVENTORY_R'
						   ,A.UPDATE_TIME         = GETDATE()
					                
				 WHEN NOT MATCHED THEN
					INSERT ( 
						[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[STORAGE_ID]
						,[CUTOFF_DATE]
						,[SEQ]
						,[STOCK_TYPE]
						,[ITEM_ID]
						,[PRODUCTION_TYPE]
						,[AVAILABLE_DATE]
						,[REMAIN_LEAD_TIME]
						,[HOLDING_DATE]
						,[QTY]
						,[QTY2]					-- PIYONG ADD 2017-05-08
						,[QTY_UOM]
						,[STOCK_STATUS]
						,[OPERATION_ID]
						,[OUTSOURCING_FLAG]
						,[OUTSOURCING_FACTORY]
						,[FP_APPLY_ITEM_ID]		-- kimcd add 2017-05-04
						,[MOVING_QTY]			-- PIYONG ADD 2018-08-06
						,[DEFECT_QTY]			-- PIYONG ADD 2018-10-23
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
					) VALUES (
						B.COMPANY_ID
						,B.DIVISION_ID
						,B.SITE_ID
						,B.PLANT_ID
						,B.FACTORY_ID
						,B.STORAGE_ID
						,CAST(B.CUTOFF_DATE AS DATE)
						,B.SEQ
					--	,'INVENTORY'
						,CASE WHEN B.OUTSOURCING_FACTORY IS NOT NULL THEN 'SUPPLY'
								ELSE 'INVENTORY'
							END 
						,B.[ITEM_ID]
						,NULL
						,CONVERT(DATETIME,SUBSTRING(CUTOFF_DATETIME,1,8) + ' ' + SUBSTRING(CUTOFF_DATETIME,9,2) + ':' + SUBSTRING(CUTOFF_DATETIME,11,2) + ':' +SUBSTRING(CUTOFF_DATETIME,13,2))
						,0
						,GETDATE()
						,CAST(B.QTY AS NUMERIC(20,10))
						,CAST(B.QTY AS NUMERIC(20,10)) -- PIYONG ADD 2017-05-08
						,B.QTY_UOM
						,NULL
						,'-'
						,'-'
						,B.OUTSOURCING_FACTORY
						,B.ITEM_ID -- kimcd add 2017-05-04
						,CAST(B.MOVING_QTY AS NUMERIC(20,10))			-- PIYONG ADD 2018-08-06
						,CAST(B.DEFECT_QTY AS NUMERIC(20,10))			-- PIYONG ADD 2018-10-23
						,'PR_XIF_ERP_INVENTORY_R'
						,GETDATE()
						,'PR_XIF_ERP_INVENTORY_R'
						,GETDATE()
					)
				;
*/

					INSERT INTO SCM_STOCK_H ( 
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[STORAGE_ID]
							,[CUTOFF_DATE]
							,[SEQ]
							,[STOCK_TYPE]
							,[ITEM_ID]
							,[PRODUCTION_TYPE]
							,[AVAILABLE_DATE]
							,[REMAIN_LEAD_TIME]
							,[HOLDING_DATE]
							,[QTY]
							,[QTY2]
							,[QTY_UOM]
							,[STOCK_STATUS]
							,[OPERATION_ID]
							,[OUTSOURCING_FLAG]
							,[OUTSOURCING_FACTORY]
							,[FP_APPLY_ITEM_ID]
							,[MOVING_QTY]
							,[DEFECT_QTY]
							,[FROM_PLANT_ID]  -- 2022-07-06 kimcd 이동 중 수량의 출발 Plant 정보 추가 수신
							,[RESTRICT_QTY]   -- 2022-11-28 leeseongmin  EINME QTY (제한사용 수량) 추가 수신
							,CUSTOMER_ID
							,SPECIAL_STOCK_INDICATOR
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
							,QT_ISP_QTY
					) 
					SELECT B.COMPANY_ID
							,B.DIVISION_ID
							,B.SITE_ID
							,B.PLANT_ID
							,B.FACTORY_ID
							,B.STORAGE_ID
							,CAST(B.CUTOFF_DATE AS DATE) AS CUTOFF_DATE
							,B.SEQ
							,CASE WHEN B.OUTSOURCING_FACTORY IS NOT NULL THEN 'SUPPLY'
								  ELSE 'INVENTORY'
								  END													 AS STOCK_TYPE
							,B.[ITEM_ID]
							,NULL AS PRODUCTION_TYPE
							,CONVERT(DATETIME,SUBSTRING(CUTOFF_DATETIME,1,8) + ' ' + SUBSTRING(CUTOFF_DATETIME,9,2) + ':' + SUBSTRING(CUTOFF_DATETIME,11,2) + ':' +SUBSTRING(CUTOFF_DATETIME,13,2)) AS AVAILABLE_DATE
							,0 AS REMAIN_LEAD_TIME
							,GETDATE() AS HOOLDING_DATE
							,B.QTY + ISNULL(B.QT_ISP_QTY, 0) AS QTY
							,B.QTY + ISNULL(B.QT_ISP_QTY, 0) AS QTY2
							,B.QTY_UOM
							,NULL AS STOCK_STATUS
							,'-' AS OPERATION_ID
							,'-' AS OUTSOURCING_FLAG
							,B.OUTSOURCING_FACTORY
							,B.ITEM_ID AS FP_APPLY_ITEM_ID
							,CAST(B.MOVING_QTY AS NUMERIC(20,10)) AS  MOVING_QTY
							,CAST(B.DEFECT_QTY AS NUMERIC(20,10)) AS DEFECT_QTY
							,B.FROM_PLANT_ID  -- 2022-07-06 kimcd 이동 중 수량의 출발 Plant 정보 추가 수신
							,B.RESTRICT_QTY   -- 2022-11-28 leeseongmin  EINME QTY (제한사용 수량) 추가 수신
							,B.CUSTOMER_ID
							,B.SPECIAL_STOCK_INDICATOR
							,'PR_XIF_ERP_INVENTORY_R' AS INSERT_ID
							,GETDATE() AS INSERT_TIME
							,'PR_XIF_ERP_INVENTORY_R' AS UPDATE_ID
							,GETDATE() AS UPDATE_TIME
							,B.QT_ISP_QTY
					  FROM (
							SELECT A.COMPANY_ID
									,A.DIVISION_ID
									--,B.SITE_ID
									,(SELECT TOP 1 C.SITE_ID
										FROM [dbo].[SCM_PLANT_M] C
										WHERE C.PLANT_ID = A.PLANT_ID) AS SITE_ID
									,A.PLANT_ID
									--,B.FACTORY_ID
									,CASE WHEN A.FACTORY_ID IS NULL THEN '-'
									ELSE A.FACTORY_ID
									END AS FACTORY_ID
									,ISNULL(A.STORAGE_ID, '-') AS STORAGE_ID
									,A.CUTOFF_DATE
									,A.SEQ
									,A.[ITEM_ID]      
									,A.CUTOFF_TIME
									,CAST(A.QTY AS NUMERIC(20,10)) AS QTY
									,A.[DEFECT_QTY]
									,A.[HOLD_QTY]
									,A.QTY_UOM
									,A.CUTOFF_DATETIME
									,A.OUTSOURCING_FACTORY
									,A.MOVING_QTY
									,A.FROM_PLANT_ID  -- 2022-07-06 kimcd 이동 중 수량의 출발 Plant 정보 추가 수신
									,A.RESTRICT_QTY   -- 2022-11-28 leeseongmin  EINME QTY (제한사용 수량) 추가 수신
									,A.CUSTOMER_ID
									,A.SPECIAL_STOCK_INDICATOR
									,CAST(A.QT_ISP_QTY AS NUMERIC(20,10)) AS QT_ISP_QTY
							  FROM (
									SELECT A.[COMPANY]  AS COMPANY_ID
											,ISNULL(PD.PSEUDO_DIVISION_ID, A.[DIVISION]) AS DIVISION_ID
											,A.[PLANT_ID]
											,A.BUILDING   AS FACTORY_ID
											,A.[SLOC]     AS STORAGE_ID
											,A.[EX_DATE]  AS CUTOFF_DATE
											,@SEQ_CNT + ROW_NUMBER() OVER( ORDER BY A.[EX_DATE], A.[COMPANY], A.[DIVISION], A.[PLANT_ID], A.[ITEM_ID], A.[SLOC]
																					, A.[VENDOR_CODE], A.[GOOD_QTY] DESC ) AS SEQ
											,A.[ITEM_ID]      
											,A.[EX_TIME]  AS CUTOFF_TIME
											,ISNULL(A.[GOOD_QTY],'0') AS QTY
											,A.[DEFECT_QTY]
											,A.[HOLD_QTY]
											,A.[UOM] AS QTY_UOM
											,A.[EX_DATE]+A.[EX_TIME] AS CUTOFF_DATETIME
											,A.VENDOR_CODE AS OUTSOURCING_FACTORY
											,A.MOVING_QTY
											,A.ATTRIBUTE1 AS [FROM_PLANT_ID]  -- 2022-07-06 kimcd 이동 중 수량의 출발 Plant 정보 추가 수신
											,A.ATTRIBUTE2 AS [RESTRICT_QTY]   -- 2022-11-28 leeseongmin  EINME QTY (제한사용 수량) 추가 수신
											,A.ATTRIBUTE3 AS CUSTOMER_ID				--고객코드
											,A.ATTRIBUTE4 AS SPECIAL_STOCK_INDICATOR	--특별재고지시자
											,A.QT_ISP_QTY
									  FROM [dbo].[SY_XIF_ERP_INVENTORY_R] A WITH(NOLOCK)
									  		LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
												ON PD.PLANT_ID = A.PLANT_ID
									 WHERE [IFSEQNO]  = @P_IFSEQNO
									   AND [TRANSFER_FLAG] = 'P'
								   ) A
							--2.9   2023.06.14 FP Pjt. E20230613-000425 / ERP 재고 수신시 음수재고 미반영으로 인한 과다재고 산출
							 --WHERE ( CAST (A.MOVING_QTY AS NUMERIC) > 0 OR CAST ( A.QTY AS NUMERIC ) > 0
								--		OR CAST (A.DEFECT_QTY AS NUMERIC) > 0									--2019-05-22 PIYONG ADD DEFECT_QTY
								--		OR CAST (A.RESTRICT_QTY AS NUMERIC) > 0									--2022-11-28 leeseongmin  EINME QTY (제한사용 수량) 추가 수신
								--   )
							) B


					SET @ROWCOUNT = @@ROWCOUNT

					UPDATE [dbo].[SY_XIF_ERP_INVENTORY_R]
					   SET TRANSFER_FLAG = 'Y'
						  ,TRANSFER_DATE = GETDATE()
					 WHERE IFSEQNO       = @P_IFSEQNO
					   AND TRANSFER_FLAG = 'P'
					;

				END
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

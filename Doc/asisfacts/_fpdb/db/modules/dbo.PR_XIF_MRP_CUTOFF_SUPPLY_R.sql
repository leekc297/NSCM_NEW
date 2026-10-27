

CREATE PROCEDURE [dbo].[PR_XIF_MRP_CUTOFF_SUPPLY_R]

-- ================================================================================================
-- Program ID          : FP00981	Receive MRP Supply Snapshot
-- Program Name        : PR_XIF_MRP_CUTOFF_SUPPLY_R
-- Param               :
-- Batch Period        : 30 minute
-- Description         : MRP에서 관리하는 협력사 공급 계획을 MRP 수행을 위해 재고 + 공급 계획 가공한 정보를 수신
--
-- Source System       : MRP
-- Destination System  : FP SDB
-- Source Table        : DBO.SY_XIF_MRP_CUTOFF_SUPPLY_R
-- Destination Table   : LGCE_FP_TR.DBO.FP_MRP_CUTOFF_SUPPLY_H
--
-- Create Date		   : 2021.04.07
-- Update Date		   : 2021.04.07 kimcd 1.0
--                       2022.01.05 kimcd 1.2
--
-- Author              : kimcd
-- Version             : 1.0 initial creation
--                       1.1 2021-05-06 kimcd 공급 정보를 Supplier별로 수신
--                       1.2 2022-01-05 kimcd 공급 정보에 MRP 반영 여부, 창고 구분 추가
--                                            ATTRIBUTE2 : MRP 반영 여부 Y/N
--                                            ATTRIBUTE3 : RAW - Raw Mat S/LOC
--                                                         PRD - Prodution S/LOC
--                                                         OUT - Off-Site S/LOC
--                                                         VMI - VMI S/LOC
--                       1.3 2022-06-23 kimcd 재고 정보 중 창고 업는 정보는 in-transit을 합한 수량으로 수신 제외
--                       1.4 2023-06-26 FP Pjt. DATA_TYPE = 'M' : MOP 로직 추가
--                       1.5 2023-09-15 FP Pjt. 자재 가용성 점검 Report 논의
--                                ATTR_05	MRP Version
--                                ATTR_06	PRODUCT (Parent code), 복수개일 경우 쉼표로 구분
--                                ATTR_07	UOM : Kg, M, 등 단위
--                                ATTR_08	Item Category : Material Master에 정의된 Category 2번
--                                ATTR_09	자재제약 Flag Y/N (Y가 제약)
--                       1.6 2024-08-23 kimcd P : PO proposal, U : User confirmed 정보 유형 추가 수신
-- ================================================================================================

-- PARAMETER
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MRP_CUTOFF_SUPPLY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER       = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
    DECLARE @ACCUM_DATE   NVARCHAR(50)
    DECLARE @PLANT_ID     NVARCHAR(50)
	DECLARE @ATTR_02      NVARCHAR(50) -- 2021-05-06 kimcd 정보 유형. 일 시업 시간 Data - CUTOFF, 그 외 실시간 갱신용 정보 UPDATE
	DECLARE @CURRENT_SEQ  NUMERIC(20,0) -- 2021-05-06 kimcd Supplier별 수신 정보 갱신에서 최종 SEQ 번호 채번용
	DECLARE @CUTOFF_DATE  DATETIME


	DECLARE CUR_IF_MRP_ACCUM_DATE CURSOR FOR
		SELECT ACCUM_DATE
          FROM [SY_XIF_MRP_CUTOFF_SUPPLY_R]
         WHERE PROC_FLAG = 'N'
         GROUP BY ACCUM_DATE
        HAVING COUNT(1) = MAX(ACCUM_COUNT) -- 전체를 수신받지 못한 경우에는 처리하지 않음.
         ORDER BY ACCUM_DATE
		 ;

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR_IF_MRP_ACCUM_DATE;
			FETCH NEXT FROM CUR_IF_MRP_ACCUM_DATE INTO @ACCUM_DATE	

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					UPDATE [SY_XIF_MRP_CUTOFF_SUPPLY_R]
					SET PROC_FLAG = 'P'
					WHERE PROC_FLAG  = 'N'
					AND   ACCUM_DATE = @ACCUM_DATE;

					DECLARE CUR_IF_MRP_PLANT CURSOR FOR
						SELECT PLANT_ID, ATTR_02
						  FROM [SY_XIF_MRP_CUTOFF_SUPPLY_R]
						 WHERE PROC_FLAG  = 'P'
						 AND   ACCUM_DATE = @ACCUM_DATE
						 GROUP BY ACCUM_DATE, PLANT_ID , ATTR_02 -- 2021-05-06 kimcd ATTR_02 추가 일 시업 시간 Data - CUTOFF, 그 외 실시간 갱신용 정보 UPDATE
						 ORDER BY ACCUM_DATE, PLANT_ID
						 ;


					OPEN CUR_IF_MRP_PLANT;
					FETCH NEXT FROM CUR_IF_MRP_PLANT INTO @PLANT_ID, @ATTR_02 -- 2021-05-06 kimcd ATTR_02 추가 일 시업 시간 Data - CUTOFF, 그 외 실시간 갱신용 정보 UPDATE

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
							IF @ATTR_02 = 'CUTOFF'  -- 2021-05-06 kimcd ATTR_02 추가 일 시업 시간 Data - CUTOFF, 그 외 실시간 갱신용 정보 UPDATE
								BEGIN
									SELECT @CUTOFF_DATE = CONVERT( DATE, DBO.FN_SITE_TIME( P.SITE_ID))
									FROM   [dbo].[SCM_PLANT_M] P WITH(NOLOCK)
									WHERE  P.PLANT_ID = @PLANT_ID

									DELETE [dbo].[FP_MRP_CUTOFF_SUPPLY_H]
									WHERE  PLANT_ID    = @PLANT_ID
									AND    CUTOFF_DATE = @CUTOFF_DATE;

									INSERT INTO [dbo].[FP_MRP_CUTOFF_SUPPLY_H]
										([COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[SEQ]
										,[CUTOFF_DATE]
										,[SUPPLY_TYPE]
										,[FACTORY_ID]
										,[STORAGE_ID]
										,[ITEM_ID]
										,[AVAILABLE_DATE]
										,[QTY]
										,[ATTRIBUTE1] -- 2021-05-06 kimcd Supplier Code 추가
										,[ATTRIBUTE2] -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
										,[ATTRIBUTE3] -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
										,[ATTRIBUTE5]
										,[ATTRIBUTE6]
										,[ATTRIBUTE7]
										,[ATTRIBUTE8]
										,[ATTRIBUTE9]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME])
									SELECT P.[COMPANY_ID]
										  ,P.[DIVISION_ID]
										  ,P.[SITE_ID]
										  ,P.[PLANT_ID]
										  ,ROW_NUMBER() OVER ( PARTITION BY A.PLANT_ID ORDER BY A.[ITEM_ID] DESC ) AS SEQ
										  ,@CUTOFF_DATE
										  --,CASE WHEN A.DATA_TYPE = 'S' THEN 'STOCK' WHEN A.DATA_TYPE = 'R' THEN 'SUPPLY_PLAN' ELSE 'MOP' END AS [SUPPLY_TYPE]
										  ,ISNULL( SLV.ATTRIBUTE1, A.DATA_TYPE ) AS [SUPPLY_TYPE]
										  -- 2024-08-23 kimcd P : PO proposal, U : User confirmed 정보 유형 추가 수신
										  ,A.FACTORY_ID
										  ,A.SOC
										  ,A.ITEM_ID
										  ,CASE WHEN A.DATA_TYPE = 'S' THEN 
												CASE WHEN CONVERT(DATE, A.RTA, 112) < @CUTOFF_DATE THEN @CUTOFF_DATE ELSE CONVERT(DATE, A.RTA, 112) END
										   ELSE CONVERT(DATE, A.RTA, 112) END AS RTA
										  ,A.QTY
										  ,A.ATTR_01 -- 2021-05-06 kimcd Supplier Code 추가
										  ,A.ATTR_03 -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
										  ,A.ATTR_04 -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
												 , A.ATTR_05
												 , A.ATTR_06
												 , A.ATTR_07
												 , A.ATTR_08
												 , A.ATTR_09
										  ,@v_proc_name
										  ,GETDATE() -- INSERT_TIME
										  ,@v_proc_name
										  ,GETDATE() -- UPDATE_TIME
									FROM  ( SELECT A.DATA_TYPE
												 , A.PLANT_ID
												 , A.FACTORY_ID
												 , A.SOC
												 , A.ITEM_ID
												 , A.RTA
												 , SUM(A.QTY) AS QTY
												 , A.ATTR_01 -- 2021-05-06 kimcd Supplier Code 추가
											     , ISNULL(A.ATTR_03, 'Y')  AS ATTR_03 -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
										         , A.ATTR_04 -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
												 , A.ATTR_05
												 , A.ATTR_06
												 , A.ATTR_07
												 , A.ATTR_08
												 , A.ATTR_09
											FROM  [dbo].[SY_XIF_MRP_CUTOFF_SUPPLY_R]  A (NOLOCK)
											WHERE A.PROC_FLAG  = 'P'
											AND   A.ACCUM_DATE = @ACCUM_DATE
											AND   A.PLANT_ID   = @PLANT_ID
											AND   NOT ( A.DATA_TYPE = 'S' AND A.SOC IS NULL) -- 2022-06-23 kimcd 재고이면서 창고 없는 정보 제외
											GROUP BY A.DATA_TYPE
													,A.PLANT_ID
													,A.FACTORY_ID
													,A.SOC
													,A.ITEM_ID
													,A.RTA
													,A.ATTR_01 -- 2021-05-06 kimcd Supplier Code 추가
													,ISNULL(A.ATTR_03, 'Y') -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
													,A.ATTR_04 -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
												 , A.ATTR_05
												 , A.ATTR_06
												 , A.ATTR_07
												 , A.ATTR_08
												 , A.ATTR_09
										  ) A
										   INNER JOIN [dbo].[SCM_PLANT_M] P (NOLOCK)
										   ON A.PLANT_ID = P.PLANT_ID
										   LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)  -- 2024-08-23 kimcd P : PO proposal, U : User confirmed 정보 유형 추가 수신
										   ON  SLV.LOOKUP_TYPE_CODE = 'MRP_CUTOFF_SUPPLY'
										   AND SLV.SEGMENT1         = A.DATA_TYPE
										   AND SLV.ACTIVE_FLAG      = 'Y' ;

									SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
								END;
							ELSE IF @ATTR_02 = 'UPDATE'
								-- 2021-05-06 kimcd Supplier 별 수급 정보 수신 과정 추가 시작
								BEGIN
									SELECT @CUTOFF_DATE = MAX(CUTOFF_DATE)
									FROM   [dbo].[FP_MRP_CUTOFF_SUPPLY_H] WITH(NOLOCK)
									WHERE  PLANT_ID = @PLANT_ID

									SELECT @CURRENT_SEQ = ISNULL(MAX(SEQ), 0)
									FROM   [dbo].[FP_MRP_CUTOFF_SUPPLY_H] WITH(NOLOCK)
									WHERE  PLANT_ID    = @PLANT_ID
									AND    CUTOFF_DATE = @CUTOFF_DATE

									DELETE [dbo].[FP_MRP_CUTOFF_SUPPLY_H]
									WHERE  PLANT_ID    = @PLANT_ID
									AND    CUTOFF_DATE = @CUTOFF_DATE
									AND    ATTRIBUTE1 IN (  SELECT A.ATTR_01
															FROM  [dbo].[SY_XIF_MRP_CUTOFF_SUPPLY_R]  A (NOLOCK)
															WHERE A.PROC_FLAG  = 'P'
															AND   A.ACCUM_DATE = @ACCUM_DATE
															AND   A.PLANT_ID   = @PLANT_ID
															GROUP BY A.ATTR_01);

									INSERT INTO [dbo].[FP_MRP_CUTOFF_SUPPLY_H]
										([COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[SEQ]
										,[CUTOFF_DATE]
										,[SUPPLY_TYPE]
										,[FACTORY_ID]
										,[STORAGE_ID]
										,[ITEM_ID]
										,[AVAILABLE_DATE]
										,[QTY]
										,[ATTRIBUTE1] -- 2021-05-06 kimcd Supplier Code 추가
										,[ATTRIBUTE2] -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
										,[ATTRIBUTE3] -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
										,[ATTRIBUTE5]
										,[ATTRIBUTE6]
										,[ATTRIBUTE7]
										,[ATTRIBUTE8]
										,[ATTRIBUTE9]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME])
									SELECT P.[COMPANY_ID]
										  ,P.[DIVISION_ID]
										  ,P.[SITE_ID]
										  ,P.[PLANT_ID]
										  ,@CURRENT_SEQ + ROW_NUMBER() OVER ( PARTITION BY A.PLANT_ID ORDER BY A.[ITEM_ID] DESC ) AS SEQ
										  ,@CUTOFF_DATE
										  --,CASE WHEN A.DATA_TYPE = 'S' THEN 'STOCK' WHEN A.DATA_TYPE = 'R' THEN 'SUPPLY_PLAN' ELSE 'MOP' END AS [SUPPLY_TYPE]
										  ,ISNULL( SLV.ATTRIBUTE1, A.DATA_TYPE ) AS [SUPPLY_TYPE]
										  -- 2024-08-23 kimcd P : PO proposal, U : User confirmed 정보 유형 추가 수신
										  ,A.FACTORY_ID
										  ,A.SOC
										  ,A.ITEM_ID
										  ,CASE WHEN A.DATA_TYPE = 'S' THEN 
												CASE WHEN CONVERT(DATE, A.RTA, 112) < @CUTOFF_DATE THEN @CUTOFF_DATE ELSE CONVERT(DATE, A.RTA, 112) END
										   ELSE CONVERT(DATE, A.RTA, 112) END AS RTA
										  ,A.QTY
										  ,A.ATTR_01 -- 2021-05-06 kimcd Supplier Code 추가
										  ,A.ATTR_03 -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
										  ,A.ATTR_04 -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
												 , A.ATTR_05
												 , A.ATTR_06
												 , A.ATTR_07
												 , A.ATTR_08
												 , A.ATTR_09
										  ,@v_proc_name
										  ,GETDATE() -- INSERT_TIME
										  ,@v_proc_name
										  ,GETDATE() -- UPDATE_TIME
									FROM  ( SELECT A.DATA_TYPE
												 , A.PLANT_ID
												 , A.FACTORY_ID
												 , A.SOC
												 , A.ITEM_ID
												 , A.RTA
												 , SUM(A.QTY) AS QTY
												 , A.ATTR_01 -- 2021-05-06 kimcd Supplier Code 추가
											     , ISNULL(A.ATTR_03, 'Y')  AS ATTR_03 -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
										         , A.ATTR_04 -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
												 , A.ATTR_05
												 , A.ATTR_06
												 , A.ATTR_07
												 , A.ATTR_08
												 , A.ATTR_09
										    FROM  [dbo].[SY_XIF_MRP_CUTOFF_SUPPLY_R]  A (NOLOCK)
											WHERE A.PROC_FLAG  = 'P'
											AND   A.ACCUM_DATE = @ACCUM_DATE
											AND   A.PLANT_ID   = @PLANT_ID
											AND   NOT ( A.DATA_TYPE = 'S' AND A.SOC IS NULL) -- 2022-06-23 kimcd 재고이면서 창고 없는 정보 제외
											GROUP BY A.DATA_TYPE
													,A.PLANT_ID
													,A.FACTORY_ID
													,A.SOC
													,A.ITEM_ID
													,A.RTA
													,A.ATTR_01 -- 2021-05-06 kimcd Supplier Code 추가
													,ISNULL(A.ATTR_03, 'Y') -- 2022-01-05 kimcd MRP 반영 여부 추가 Y, N
													,A.ATTR_04 -- 2022-01-05 kimcd 창고 유형 추가 RAW, PRD, OUT, VMI
												 , A.ATTR_05
												 , A.ATTR_06
												 , A.ATTR_07
												 , A.ATTR_08
												 , A.ATTR_09

													) A
										   INNER JOIN [dbo].[SCM_PLANT_M] P (NOLOCK)
										   ON A.PLANT_ID = P.PLANT_ID
										   LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)  -- 2024-08-23 kimcd P : PO proposal, U : User confirmed 정보 유형 추가 수신
										   ON  SLV.LOOKUP_TYPE_CODE = 'MRP_CUTOFF_SUPPLY'
										   AND SLV.SEGMENT1         = A.DATA_TYPE
										   AND SLV.ACTIVE_FLAG      = 'Y' ;

									SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
								END;
								-- 2021-05-06 kimcd Supplier 별 수급 정보 수신 과정 추가 끝

							FETCH NEXT FROM CUR_IF_MRP_PLANT INTO @PLANT_ID, @ATTR_02 -- 2021-05-06 kimcd ATTR_02 추가 일 시업 시간 Data - CUTOFF, 그 외 실시간 갱신용 정보 UPDATE
						END; -- OPEN CUR_IF_MRP_PLANT의 END

					CLOSE CUR_IF_MRP_PLANT;
					DEALLOCATE CUR_IF_MRP_PLANT;  

					UPDATE [SY_XIF_MRP_CUTOFF_SUPPLY_R]
					SET  PROC_FLAG = 'Y'
						,PROC_DATE = GETDATE()
					WHERE PROC_FLAG  = 'P'
					AND   ACCUM_DATE = @ACCUM_DATE;

					FETCH NEXT FROM CUR_IF_MRP_ACCUM_DATE INTO @ACCUM_DATE;
				END; -- OPEN CUR_IF_MRP_ACCUM_DATE의 END

			CLOSE CUR_IF_MRP_ACCUM_DATE;
			DEALLOCATE CUR_IF_MRP_ACCUM_DATE;  
		-- ================================================
		-- 로직 추가 end
		-- ================================================


		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END;

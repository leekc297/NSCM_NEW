

CREATE PROCEDURE [dbo].[PR_XIF_SSP_DNM_MES_STOCK_81_82_R] 

-- ================================================================================================
-- Program ID          : FP00882
-- Program Name        : PR_XIF_SSP_DNM_MES_STOCK_81_82_R
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : SSP
-- Destination System  : FP SDB
-- Source Table        : LGCE_SCMDEV.DBO.SSP_DNM_MES_STOCK_81_82
-- Destination Table   : FP_SSP_STOCK_BACKUP_H
--
-- Create Date		   : 2020.09.21
-- Update Date		   : 2022.02.23 KIMCD 1.5

-- Author              : kimcd
-- Version             : 1.0 최초 생성. SSP 완성품 검사 대기 정보 수신
--                       1.1 2020-12-24 이동 중 수량 별도 컬럼에 형성 MOVING_OWMS MOVING_PACK
--                       1.2 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
--                       1.3 2021-04-08 kimcd LONG_TERM_FLAG 컬럼 추가. PRIMARY KEY에 추가
--                       1.4 2022-01-13 kimcd MOVING_OWMS 수량이 UI에 표시되지 않아 정상 수량에 합산
--                       1.5 2022-02-23 kimcd 기준 Table 변경
--                                            OLD : SSP_DNM_MES_STOCK_81_82
--                                            NEW : SSP_DNM_GMES_STOCK_81_82
-- ================================================================================================

AS

BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SSP_DNM_MES_STOCK_81_82_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @DIVISION_ID NVARCHAR(30);
	DECLARE @COMPANY_ID	 NVARCHAR(10);
	DECLARE @SITE_ID	 NVARCHAR(10);
	DECLARE @PLANT_ID	 NVARCHAR(10);

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRANSACTION PR_XIF_SSP_DNM_MES_STOCK_81_82_R;  
	
	BEGIN TRY

		DECLARE CUR_PLANT CURSOR FOR
			SELECT S.DIVISION_ID
			     , S.COMPANY_ID
				 , S.SITE_ID
				 , S.PLANT_ID
			FROM   SCM_PLANT_M S (NOLOCK)
			WHERE  CONVERT(NVARCHAR(20), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120)	-- 현재 시간
					BETWEEN (														-- 기준 시간
							SELECT DISTINCT CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
											LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
								FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
								WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND V.ACTIVE_FLAG = 'Y'
								AND V.SEGMENT1    = S.PLANT_ID
							)
						AND (
							SELECT DISTINCT DATEADD(MI, 120,	-- 시업 시간 2시간까지 재형성
													CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
													LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
																														)
								FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
								WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND V.ACTIVE_FLAG = 'Y'
								AND V.SEGMENT1    = S.PLANT_ID
							)
			 AND   EXISTS ( SELECT 1
			                FROM   SCM_FACTORY_M F (NOLOCK)
							WHERE  F.COMPANY_ID    = S.COMPANY_ID
							AND    F.DIVISION_ID   = S.DIVISION_ID
							AND    F.SITE_ID       = S.SITE_ID
							AND    F.PLANT_ID      = S.PLANT_ID
							AND    F.SHOP_GROUP_ID = 'A'
							AND    F.ACTIVE_FLAG   = 'Y'
							)

		OPEN CUR_PLANT;
			
		FETCH NEXT FROM CUR_PLANT INTO   @DIVISION_ID
										,@COMPANY_ID
										,@SITE_ID
										,@PLANT_ID

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				MERGE INTO FP_SSP_STOCK_BACKUP_H A
					USING (SELECT  B.DIVISION_ID
								 , B.COMPANY_ID
								 , B.PLANT_ID
								 , A.YYYYMMDD
								 , A.AVAILABLE_YN
								 , A.AREAID
								 , A.ITEM_ID
								 , A.PRJT_NAME
								 , A.HOLD
								 , A.AVAILABLE_DATE
								 , A.HOLD_RELEASE_DATE
								 , A.QTY
								 , A.PACK_MOVE_QTY
								 , A.OWMS_MOVE_QTY
								 , ISNULL(A.TO_SLOC_ID, '-') AS TO_SLOC_ID -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
								 , A.LONG_TERM_FLAG -- 2021-04-08 kimcd 장기재고구분 컬럼 추가. PRIMARY KEY에 추가
							FROM  ( SELECT A.YYYYMMDD
										 , A.AVAILABLE_YN
										 , A.AREAID -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. 도착지 동으로 수정
										 , A.ITEM_ID
										 , MAX(A.PRJT_NAME) AS PRJT_NAME
										 , A.HOLD
										 , A.AVAILABLE_DATE
										 , A.HOLD_RELEASE_DATE
										 , SUM(A.QTY)  AS QTY  -- 2020-12-24 kimcd 이동 중 수량 제외
										 , SUM(A.PACK_MOVE_QTY)  AS PACK_MOVE_QTY -- 2020-12-24 kimcd Pack 이동 중 수량
										 , SUM(A.OWMS_MOVE_QTY)  AS OWMS_MOVE_QTY -- 2020-12-24 kimcd OWMS 이동 중 수량
										 , A.TO_SLOC_ID -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
										 , A.LONG_TERM_FLAG -- 2021-04-08 kimcd 장기재고구분 컬럼 추가. PRIMARY KEY에 추가
									FROM  ( SELECT A.YYYYMMDD
												 , A.AVAILABLE_YN
												 , CASE WHEN ISNULL( A.ATTRIBUTE2, '-') LIKE '%MOVING%' THEN
														ISNULL(( SELECT TOP 1 L.FACTORY_ID
																 FROM   SCM_LINE_M  L (NOLOCK)
																 WHERE  L.DIVISION_ID = @DIVISION_ID
																 AND    L.SITE_ID     = @SITE_ID
																 AND    L.COMPANY_ID  = @COMPANY_ID
																 AND    ( L.DOMESTIC_SLOC_ID = A.ATTRIBUTE3 OR L.EXPORT_SLOC_ID = A.ATTRIBUTE3 )
																 AND    L.ACTIVE_FLAG = 'Y'
																 ORDER  BY L.FACTORY_ID
																 ), A.AREAID)
												   ELSE A.AREAID END AS AREAID -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. 도착지 동으로 수정
												 , A.ITEM_ID
												 , A.PRJT_NAME AS PRJT_NAME
												 , CASE WHEN A.MES_HOLD_YN = 'N' AND A.QMS_HOLD_YN ='N' AND A.SUBLOT_HOLD_YN ='N' AND A.PACK_HOLD_YN ='N' AND A.RTN_RCV_FLAG ='N' THEN 'N'
														ELSE 'Y'
												   END AS  HOLD
												 , ISNULL(CASE WHEN A.MES_HOLD_RELEASE > A.QMS_HOLD_RELEASE THEN A.MES_HOLD_RELEASE ELSE ISNULL(A.QMS_HOLD_RELEASE, A.MES_HOLD_RELEASE) END, A.YYYYMMDD) AS AVAILABLE_DATE
												 , ISNULL(CASE WHEN A.MES_HOLD_RELEASE > A.QMS_HOLD_RELEASE THEN A.MES_HOLD_RELEASE ELSE ISNULL(A.QMS_HOLD_RELEASE, A.MES_HOLD_RELEASE) END, '19900101') AS HOLD_RELEASE_DATE
												 --, ISNULL(CASE WHEN ISNULL( A.ATTRIBUTE2, '-') NOT LIKE '%MOVING%' THEN A.LOT_QTY END,0)  AS QTY  -- 2020-12-24 kimcd 이동 중 수량 제외
												 -- 2022-01-13 kimcd MOVING_OWMS 수량이 UI에 표시되지 않아 정상 수량에 합산되도록 CASE 문장 수정
												 , ISNULL(CASE WHEN ISNULL( A.ATTRIBUTE2, '-') !='MOVING_PACK' THEN A.LOT_QTY END,0)  AS QTY
												 , CASE WHEN A.ATTRIBUTE2 ='MOVING_PACK' THEN A.LOT_QTY END  AS PACK_MOVE_QTY -- 2020-12-24 kimcd Pack 이동 중 수량
												 , CASE WHEN A.ATTRIBUTE2 ='MOVING_OWMS' THEN A.LOT_QTY END  AS OWMS_MOVE_QTY -- 2020-12-24 kimcd OWMS 이동 중 수량
												 , CASE WHEN ISNULL( A.ATTRIBUTE2, '-') LIKE '%MOVING%' THEN A.ATTRIBUTE3 END TO_SLOC_ID -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
												 , ISNULL(A.ATTRIBUTE8, 'N')    AS LONG_TERM_FLAG --2021-04-08 kimcd 장기재고 구분자 추가
											-- FROM   LGCE_SCMDEV.DBO.SSP_DNM_MES_STOCK_81_82 A (NOLOCK)
											FROM   LGCE_SCMDEV.DBO.SSP_DNM_GMES_STOCK_81_82 A (NOLOCK) -- 2022-02-23 kimcd SSP 기준 Table 변경
											WHERE  A.YYYYMMDD     = CONVERT(NVARCHAR(8),GETDATE(),112)
											AND    A.DIVISION_ID  = @DIVISION_ID
											AND    A.COMPANY_ID	  = @COMPANY_ID
											AND    A.FROM_SITE LIKE @PLANT_ID + '%'
											AND    A.PLANT_ID	  = @PLANT_ID ) A
									GROUP  BY A.YYYYMMDD
											, A.AVAILABLE_YN
											, A.AREAID
											, A.ITEM_ID
											, A.HOLD
											, A.AVAILABLE_DATE
											, A.HOLD_RELEASE_DATE
											, A.TO_SLOC_ID -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
											, A.LONG_TERM_FLAG -- 2021-04-08 kimcd 장기재고구분 컬럼 추가. PRIMARY KEY에 추가
											 ) A,
									SCM_FACTORY_M B (NOLOCK)
							WHERE  B.FACTORY_ID = A.AREAID
							AND    B.COMPANY_ID = @COMPANY_ID
						  ) B
					   ON ( A.CUTOFF_DATE           = CONVERT(DATE,B.YYYYMMDD, 112)
							AND A.DIVISION_ID       = B.DIVISION_ID
							AND A.COMPANY_ID        = B.COMPANY_ID
							AND A.PLANT_ID          = B.PLANT_ID
							AND A.FACTORY_ID        = B.AREAID
							AND A.ITEM_ID           = B.ITEM_ID
							AND A.AVAILABLE_YN      = B.AVAILABLE_YN
							AND A.HOLD              = B.HOLD
							AND A.AVAILABLE_DATE    = CONVERT(DATE,B.AVAILABLE_DATE, 112)
							AND A.HOLD_RELEASE_DATE = CONVERT(DATE,B.HOLD_RELEASE_DATE, 112)
							AND A.TO_SLOC_ID        = B.TO_SLOC_ID -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
							AND A.LONG_TERM_FLAG    = B.LONG_TERM_FLAG -- 2021-04-08 kimcd 장기재고구분 컬럼 추가. PRIMARY KEY에 추가
							AND A.DATA_TYPE         = 'MES_CELL'
						  )
					 WHEN MATCHED THEN
							UPDATE SET    A.NICK_NAME   = B.PRJT_NAME
										, A.QTY         = B.QTY
										, A.PACK_MOVE_QTY = B.PACK_MOVE_QTY -- 2020-12-24 kimcd Pack 이동 중 수량
										, A.OWMS_MOVE_QTY = B.OWMS_MOVE_QTY -- 2020-12-24 kimcd OWMS 이동 중 수량
										, A.UPDATE_TIME = GETDATE()
										, A.UPDATE_ID   = @v_proc_name
					 WHEN NOT MATCHED THEN
						INSERT (  [CUTOFF_DATE]
								, [DIVISION_ID]
								, [COMPANY_ID]
								, [SITE_ID]
								, [PLANT_ID]
								, [FACTORY_ID]
								, [ITEM_ID]
								, [AVAILABLE_YN]
								, [HOLD]
								, [AVAILABLE_DATE]
								, [HOLD_RELEASE_DATE]
								, [DATA_TYPE]
								, [NICK_NAME]
								, [QTY]
								, [PACK_MOVE_QTY] -- 2020-12-24 kimcd Pack 이동 중 수량
								, [OWMS_MOVE_QTY] -- 2020-12-24 kimcd OWMS 이동 중 수량
								, [TO_SLOC_ID]    -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
								, [LONG_TERM_FLAG] -- 2021-04-08 kimcd 장기재고구분 컬럼 추가. PRIMARY KEY에 추가
								, [INSERT_ID]
								, [INSERT_TIME]
								, [UPDATE_ID]
								, [UPDATE_TIME] )
						VALUES (   CONVERT(DATE,B.YYYYMMDD, 112)
								 , B.DIVISION_ID
								 , B.COMPANY_ID
								 , @SITE_ID
								 , B.PLANT_ID
								 , B.AREAID
								 , B.ITEM_ID
								 , B.AVAILABLE_YN
								 , B.HOLD
								 , CONVERT(DATE,B.AVAILABLE_DATE, 112)
								 , CONVERT(DATE,B.HOLD_RELEASE_DATE, 112)
								 , 'MES_CELL' 
								 , B.PRJT_NAME
								 , B.QTY
								 , B.PACK_MOVE_QTY -- 2020-12-24 kimcd Pack 이동 중 수량
								 , B.OWMS_MOVE_QTY -- 2020-12-24 kimcd OWMS 이동 중 수량
								 , B.TO_SLOC_ID    -- 2020-12-30 kimcd TO_SLOC_ID 컬럼 추가. PRIMARY KEY에 추가
								 , B.LONG_TERM_FLAG -- 2021-04-08 kimcd 장기재고구분 컬럼 추가. PRIMARY KEY에 추가
								 , @v_proc_name
								 , GETDATE()
								 , @v_proc_name
								 , GETDATE() )
				;

			
				FETCH NEXT FROM CUR_PLANT INTO   @DIVISION_ID
												,@COMPANY_ID
												,@SITE_ID
												,@PLANT_ID;

			END

		CLOSE CUR_PLANT;
		DEALLOCATE CUR_PLANT;

		COMMIT WORK;

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', 0, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
	-----------------------------------------------------------------------------------------------------------------------------------------
	END TRY
	-----------------------------------------------------------------------------------------------------------------------------------------

	----------------------------------------------------------------	
	BEGIN CATCH
	----------------------------------------------------------------	
		---- 트랜잭션 (END)

		ROLLBACK TRANSACTION PR_XIF_SSP_DNM_MES_STOCK_81_82_R;

		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
	----------------------------------------------------------------	
	END CATCH;
	----------------------------------------------------------------	


  END;

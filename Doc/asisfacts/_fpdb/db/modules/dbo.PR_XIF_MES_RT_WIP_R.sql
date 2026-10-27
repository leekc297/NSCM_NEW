
CREATE PROCEDURE [dbo].[PR_XIF_MES_RT_WIP_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_RT_WIP_R
-- Param               :
-- Batch Period        : 1HOUR
-- Description         : MES 재고 정보 전환
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_RT_WIP_R
-- Destination Table   : SCM_RT_STOCK_H
--
-- Create Date		   : 2017.08.21
-- Update Date		   : 2017-08-31 PIYONG 1.1
--                     : 2017.09.01 kimcd  1.2
--                     : 2018.01.17 kimcd  1.3
--                     : 2018.03.29 kimcd  1.4
--                     : 2018.05.21 PIYONG 1.5
--					   : 2018.10.18 PIYONG 1.6
--						 2018.10.24 PIYONG 2.0
--						 2019.06.05 PIYONG 2.1

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 FP_APPLY_OPERATION_ID  조건 변경
--                       1.2 kimcd 2017-09-01 이동 중 재고의 line, operation 조회 방식 수정
--                       1.3 kimcd 2018-01-17 AC001(수리)공정에서 나오는 이동 중 재고는 WIP_TYPE_CODE를 IN으로 강제 전환
--                       1.4 kimcd 2018-03-29 P5000 CMA Assy의 경우 재고 Status가 END에 해당할 경우 하위 품목으로 전환되면 안 됨
--						 1.5 MAX(A.NJ_ELEC_FACTORY) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' 일때  EA로 적용
--						 1.6 2018-10-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--						 2.0 SCM_MES_RT_STOCK_H  생성 조회 쿼리 수정
--								SCM_BOM_M 서브쿼리에서 OUTER JOIN으로 변경( 대체코드 경우 ALT_PRIORITY=1 나오도록 변경, 누락데이터 보완)  
--						 2.1 UOM 조회시 COMPANY_ID 조회 조건 추가
--						 2.1 2021-07-13 kimis ESNJ 6동 GMES DB 분리에 따른 변경
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_RT_WIP_R'
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
	DECLARE @IF_ID        NVARCHAR(50)
    DECLARE @ACCUM_DATE   NVARCHAR(50)
    DECLARE @SITE_ID      NVARCHAR(50)
	DECLARE @i_CNT        INTEGER


	DECLARE CUR_IF_MES_WIP CURSOR FOR
		--2021-07-13 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : AREA ID (FACTORY ID) 기준으로 SITE ID 찾는것으로 변경	
		--SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID
		SELECT IF_ID, ACCUM_DATE, ( SELECT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE Z.FACTORY_ID = MAX(AREAID) ) SITE_ID		
          FROM [SY_XIF_MES_RT_WIP_R]
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
			OPEN CUR_IF_MES_WIP;
			FETCH NEXT FROM CUR_IF_MES_WIP INTO @IF_ID        
											    ,@ACCUM_DATE
                                                ,@SITE_ID		

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					IF ( @P_SITE_ID != 'NULL' AND @P_SITE_ID IS NOT NULL AND @SITE_ID = @P_SITE_ID ) OR (@P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL)		

						BEGIN

							UPDATE [dbo].[SY_XIF_MES_RT_WIP_R]
							   SET PROC_FLAG = 'P'
							 WHERE ISNULL(PROC_FLAG, 'N') = 'N'
							   AND IF_ID = @IF_ID
							   AND ACCUM_DATE =  @ACCUM_DATE
							;

							SET @i_CNT =  (SELECT ISNULL(MAX(SEQ), 0)
											 FROM [dbo].[SCM_MES_RT_STOCK_H]
										    WHERE CUTOFF_DATE = CONVERT(datetime, 
																		SUBSTRING(@ACCUM_DATE, 1,4)+'-'+
																		SUBSTRING(@ACCUM_DATE, 5,2)+'-'+
																		SUBSTRING(@ACCUM_DATE, 7,2)+' '+
																		SUBSTRING(@ACCUM_DATE, 9,2)+':'+
																		SUBSTRING(@ACCUM_DATE, 11,2)+':00'
																	, 120)
											  AND SITE_ID = @SITE_ID );

							MERGE INTO [dbo].[SCM_MES_RT_STOCK_H] A
							USING (
									SELECT A.[COMPANY_ID]
										   ,A.[DIVISION_ID]
										   ,A.[SITE_ID]
										   ,A.[PLANT_ID]
										   ,A.[FACTORY_ID]
										   ,A.[STORAGE_ID]
										   ,A.[CUTOFF_DATE]
										   ,ROW_NUMBER() OVER ( PARTITION BY @IF_ID ORDER BY A.[ITEM_ID] DESC ) + @i_CNT  AS [SEQ]		-- 2018-10-24 PIYONG DEL
										   ,A.[STOCK_TYPE]
										   ,A.[ITEM_ID]
										   ,A.[PRODUCTION_TYPE]
										   ,A.[AVAILABLE_DATE]
										   ,A.[REMAIN_LEAD_TIME]
										   ,A.[HOLDING_DATE]
										   ,A.[QTY]
										   ,A.[QTY_UOM]
										   ,A.[QTY2]
										   ,A.[STOCK_STATUS]
										   ,A.[OPERATION_ID]
										   ,A.LANE
										   ,A.[LINE_ID]
										   ,A.[OUTSOURCING_FLAG]
										   ,A.[OUTSOURCING_FACTORY]
										   ,A.[DESCRIPTION]
										   ,A.FP_APPLY_OPERATION_ID
										   , CASE SEGMENT5  WHEN 'PRE' THEN
																CHILD_ITEM_ID
																/*	--2018-10-24 PIYONG DEL
																( SELECT TOP 1 CHILD_ITEM_ID
																	FROM [dbo].[SCM_BOM_M] BOM
																	WHERE BOM.COMPANY_ID = A.COMPANY_ID
																	AND BOM.DIVISION_ID = A.DIVISION_ID
																	AND BOM.SITE_ID = A.SITE_ID
																	AND BOM.PLANT_ID = A.PLANT_ID
																	AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																	AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID) 
																	AND BOM.EFF_START_DATE <= GETDATE()
																	AND BOM.EFF_END_DATE > GETDATE()
																	)
																	*/
															 -- 2018-03-29 kimcd status 경우 추가 시작
															 WHEN 'STATUS' THEN
																	CASE WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' THEN
																			A.[ITEM_ID]
																		 ELSE
																			CHILD_ITEM_ID
																				/*	--2018-10-24 PIYONG DEL
																				( SELECT TOP 1 CHILD_ITEM_ID
																					FROM [dbo].[SCM_BOM_M] BOM
																					WHERE BOM.COMPANY_ID = A.COMPANY_ID
																					AND BOM.DIVISION_ID = A.DIVISION_ID
																					AND BOM.SITE_ID = A.SITE_ID
																					AND BOM.PLANT_ID = A.PLANT_ID
																					AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																					AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID) 
																					AND BOM.EFF_START_DATE <= GETDATE()
																					AND BOM.EFF_END_DATE > GETDATE()
																					)
																				*/
																		 END 
															-- 2018-03-29 kimcd status 경우 추가 끝
															ELSE                  
																A.[ITEM_ID]
															END AS FP_APPLY_ITEM_ID
										   , CASE SEGMENT5  WHEN 'PRE' THEN
																CASE  WHEN ( A.STOCK_STATUS = 'PROC' AND A.WIP_TYPE_CODE = 'OUT')
																			OR A.WIP_TYPE_CODE = 'PROD' THEN
																			0
																		ELSE
																			A.QTY2 * BOM.BOM_QTY
																			/*	--2018-10-24 PIYONG DEL
																			A.QTY2 *  ( SELECT TOP 1 CHILD_QTY / PARENT_QTY
																						FROM [dbo].[SCM_BOM_M] BOM
																						WHERE BOM.COMPANY_ID = A.COMPANY_ID
																						AND BOM.DIVISION_ID = A.DIVISION_ID
																						AND BOM.SITE_ID = A.SITE_ID
																						AND BOM.PLANT_ID = A.PLANT_ID
																						AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																						AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
																						AND BOM.EFF_START_DATE <= GETDATE()
																						AND BOM.EFF_END_DATE > GETDATE()
																					)
																			*/
																		END
															-- 2018-03-29 kimcd status type 추가 시작
															WHEN 'STATUS' THEN
																	CASE WHEN ( A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' ) AND A.WIP_TYPE_CODE != 'PROD'  THEN
																				A.QTY2
																		WHEN ( A.STOCK_STATUS = 'PROC' AND A.WIP_TYPE_CODE = 'OUT')
																				OR A.WIP_TYPE_CODE = 'PROD' THEN
																				0
																		ELSE
																			A.QTY2 * BOM.BOM_QTY
																			/*	--2018-10-24 PIYONG DEL
																			A.QTY2 *  ( SELECT TOP 1 CHILD_QTY / PARENT_QTY
																						FROM [dbo].[SCM_BOM_M] BOM
																						WHERE BOM.COMPANY_ID = A.COMPANY_ID
																						AND BOM.DIVISION_ID = A.DIVISION_ID
																						AND BOM.SITE_ID = A.SITE_ID
																						AND BOM.PLANT_ID = A.PLANT_ID
																						AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																						AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
																						AND BOM.EFF_START_DATE <= GETDATE()
																						AND BOM.EFF_END_DATE > GETDATE()
																					)
																			*/
																	END
																-- 2018-03-29 kimcd status type 추가 끝
																ELSE
																	CASE  WHEN ( A.STOCK_STATUS = 'PROC' AND A.WIP_TYPE_CODE = 'OUT')
																				OR A.WIP_TYPE_CODE = 'PROD' THEN
																							0
																							ELSE                  
																							A.QTY2
																							END
																END AS [FP_APPLY_WIPQTY]
										   ,A.WIPHOLD
										   ,A.WIP_TYPE_CODE -- kimcd add 2017-05-04
										   ,@IF_ID AS INSERT_ID
										   ,GETDATE() AS INSERT_TIME
       									   ,'PR_XIF_MES_WIP_R' AS UPDATE_ID
         								   ,GETDATE() AS UPDATE_TIME
								      FROM (
											SELECT A.[COMPANY_ID]
												   ,A.[DIVISION_ID]
												   ,A.[SITE_ID]
												   ,A.[PLANT_ID]
												   ,A.[FACTORY_ID]
												   ,A.[STORAGE_ID]
												   ,A.[CUTOFF_DATE]
												   ,A.[STOCK_TYPE]
												   ,A.[ITEM_ID]
												   ,A.[PRODUCTION_TYPE]
												   ,A.[AVAILABLE_DATE]
												   ,A.[REMAIN_LEAD_TIME]
												   ,A.[HOLDING_DATE]
												   ,A.[QTY]
												   ,(SELECT ITEM_UOM
													   FROM [DBO].SCM_ITEM_M D
															INNER JOIN [DBO].[SCM_ITEM_CLASS_M] M
																	ON D.ITEM_CLASS = M.CLASS_ID
																   AND M.USE_FLAG = 'Y'
													  WHERE A.[COMPANY_ID] = D.[COMPANY_ID]	-- 2019-06-05 PIYONG ADD
														AND A.DIVISION_ID = d.DIVISION_ID
														AND A.SITE_ID  = D.SITE_ID
														AND A.[ITEM_ID] = D.ITEM_ID) AS [QTY_UOM]
												   ,A.[QTY2]
												   ,A.[STOCK_STATUS]
												   ,A.[OPERATION_ID]
												   ,CASE WHEN SUBSTRING([ITEM_ID],1,3) = 'APC' THEN A.LANE ELSE NULL END AS LANE
												   ,A.[LINE_ID]
												   ,A.[OUTSOURCING_FLAG]
												   ,A.[OUTSOURCING_FACTORY]
												   ,A.[DESCRIPTION]
												   , CASE SEGMENT4  WHEN 'PRE' THEN
																		-- kimcd 2017-06-28 add start  E4 소형 3동 half slitting 예외 처리
																		CASE WHEN A.[FACTORY_ID] = 'E4' AND A.OPERATION_ID = 'E3000' THEN
																			'E2500'
																		ELSE
																		-- kimcd 2017-06-28 add end
																			ISNULL( ( SELECT TOP 1 F.OPERATION_ID				 
																						FROM DBO.SCM_OPERATION_M  O WITH(NOLOCK)
																								,DBO.SCM_ITEM_M       I WITH(NOLOCK)
																								,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
																						WHERE  I.COMPANY_ID   = A.COMPANY_ID
																						AND    I.DIVISION_ID  = A.DIVISION_ID
																						AND    I.SITE_ID      = A.SITE_ID
																						AND    I.ITEM_ID      = A.ITEM_ID
																						AND    F.COMPANY_ID   = I.COMPANY_ID
																						AND    F.DIVISION_ID  = I.DIVISION_ID
																						AND    F.SITE_ID      = I.SITE_ID
																						AND    F.FLOW_ID      = I.FLOW_ID
																						AND    F.OPERATION_ID < A.OPERATION_ID 
																						AND    O.COMPANY_ID   = F.COMPANY_ID
																						AND    O.DIVISION_ID  = F.DIVISION_ID
																						AND    O.SITE_ID      = F.SITE_ID
																						AND    O.OPERATION_ID = F.OPERATION_ID
																						ORDER  BY F.OPERATION_SEQ DESC) , A.OPERATION_ID)
																		END
																	WHEN 'STATUS' THEN 
																			CASE  WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' THEN
																					A.OPERATION_ID
																			ELSE
																				CASE WHEN A.[FACTORY_ID] = 'E4' AND A.OPERATION_ID = 'E3000' THEN
																					'E2500'
																				ELSE
																					ISNULL( ( SELECT TOP 1 F.OPERATION_ID				 
																						FROM DBO.SCM_OPERATION_M  O WITH(NOLOCK)
																								,DBO.SCM_ITEM_M       I WITH(NOLOCK)
																								,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
																						WHERE  I.COMPANY_ID   = A.COMPANY_ID
																						AND    I.DIVISION_ID  = A.DIVISION_ID
																						AND    I.SITE_ID      = A.SITE_ID
																						AND    I.ITEM_ID      = A.ITEM_ID
																						AND    F.COMPANY_ID   = I.COMPANY_ID
																						AND    F.DIVISION_ID  = I.DIVISION_ID
																						AND    F.SITE_ID      = I.SITE_ID
																						AND    F.FLOW_ID      = I.FLOW_ID
																						AND    F.OPERATION_ID < A.OPERATION_ID 
																						AND    O.COMPANY_ID   = F.COMPANY_ID
																						AND    O.DIVISION_ID  = F.DIVISION_ID
																						AND    O.SITE_ID      = F.SITE_ID
																						AND    O.OPERATION_ID = F.OPERATION_ID
																						ORDER  BY F.OPERATION_SEQ DESC) , A.OPERATION_ID)
																				END
																			END
																	ELSE                  
																		ISNULL( SEGMENT4, A.OPERATION_ID)	--	2017-08-31 PIYONG 1.1 CHANGE
																	END AS FP_APPLY_OPERATION_ID
										
												   ,A.WIPHOLD
												   ,A.WIP_TYPE_CODE
												   ,SEGMENT5												-- 2018-10-24 PIYONG ADD
												   ,A.[INSERT_ID]
												   ,A.[INSERT_TIME]
												   ,A.[UPDATE_ID]
												   ,A.[UPDATE_TIME]
											  FROM ( SELECT 
															/*	--2018-10-18 PIYONG E8동 사용안함 로직 제거
															CASE WHEN @SITE_ID = 'A002' THEN
																		CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452','A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN
																					'G450'
																				ELSE ISNULL( B.COMPANY_ID, C.COMPANY_ID) END 
																		ELSE
																		ISNULL( B.COMPANY_ID, C.COMPANY_ID)
																	END AS COMPANY_ID
															,CASE WHEN @SITE_ID = 'A002' THEN
																		CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
																					'81'
																				ELSE ISNULL( B.DIVISION_ID, C.DIVISION_ID)  END 
																		ELSE
																		ISNULL( B.DIVISION_ID, C.DIVISION_ID) 
																	END AS DIVISION_ID
															,ISNULL( B.SITE_ID, C.SITE_ID )  AS SITE_ID
															,CASE WHEN @SITE_ID = 'A002' THEN
																		CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
																				'G452'
																			ELSE
																				ISNULL( B.PLANT_ID, C.PLANT_ID )
																				END
																		ELSE
																		ISNULL( B.PLANT_ID, C.PLANT_ID )
																	END AS PLANT_ID
															,CASE WHEN @SITE_ID = 'A002' THEN
																		CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
																					'EA'	--2018-05-21 piyong E8 -> EA
																				ELSE ISNULL( B.FACTORY_ID, C.FACTORY_ID ) END 
																		ELSE
																		ISNULL( B.FACTORY_ID, C.FACTORY_ID ) 
																	END AS FACTORY_ID
															*/
															ISNULL( B.COMPANY_ID, C.COMPANY_ID) AS COMPANY_ID		--2018-10-18 PIYONG ADD
															,ISNULL( B.DIVISION_ID, C.DIVISION_ID) AS DIVISION_ID	--2018-10-18 PIYONG ADD
															,ISNULL( B.SITE_ID, C.SITE_ID )  AS SITE_ID				--2018-10-18 PIYONG ADD
															,ISNULL( B.PLANT_ID, C.PLANT_ID ) AS PLANT_ID			--2018-10-18 PIYONG ADD	
															,ISNULL( B.FACTORY_ID, C.FACTORY_ID ) AS FACTORY_ID		--2018-10-18 PIYONG ADD
															,'MES' AS STORAGE_ID
															, CONVERT(datetime, 
																	SUBSTRING(@ACCUM_DATE, 1,4)+'-'+
																	SUBSTRING(@ACCUM_DATE, 5,2)+'-'+
																	SUBSTRING(@ACCUM_DATE, 7,2)+' '+
																	SUBSTRING(@ACCUM_DATE, 9,2)+':'+
																	SUBSTRING(@ACCUM_DATE, 11,2)+':00'
																, 120) AS CUTOFF_DATE
            												,'WIP' AS STOCK_TYPE 
															,A.PRODID AS ITEM_ID
															,NULL PRODUCTION_TYPE
															,CASE WHEN A.WIPHOLD = 'Y' THEN
																		convert( varchar, dateadd( dd, 60, getdate() ) ,120 )
																	ELSE '1999-01-01 00:00:00'
																	END AS AVAILABLE_DATE
            												,0 AS REMAIN_LEAD_TIME
            												,ISNULL(MAX(A.HOLD_DATE), '1999-01-01 00:00:00') AS HOLDING_DATE
            												,SUM(A.WIPQTY) QTY
															,SUM(A.WIPQTY2) AS QTY2
															,A.LANE_QTY AS LANE
            												,wipstat AS STOCK_STATUS
															--, A.PROCID AS OPERATION_ID kimcd block 2017-09-01
															,CASE WHEN A.WIPSTAT = 'MOVING' THEN A.TO_PROCID ELSE A.PROCID END AS OPERATION_ID -- kimcd add 2017-09-01
															--,ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') AS LINE_ID  -- MES 라인 직접 사용 kimcd 2017-08-09 kimcd block 2017-09-01
															,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_EQSGID,'-') ELSE ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') END AS LINE_ID -- kimcd add 2017-09-01
            												,'-' AS OUTSOURCING_FLAG
															,NULL AS OUTSOURCING_FACTORY
            												,NULL AS DESCRIPTION
            												,A.IF_ID AS INSERT_ID
															,CASE WHEN A.WIPSTAT = 'MOVING' AND A.PROCID = 'AC001' THEN 'IN' ELSE A.WIP_TYPE_CODE END AS WIP_TYPE_CODE  -- 2018-01-17 kimcd AC001(수리)공정에서 나오는 이동 중 재고는 IN으로 강제 전환
															,A.WIPHOLD
            												,GETDATE() AS INSERT_TIME
            												,'PR_XIF_MES_RT_WIP_R' AS UPDATE_ID
            												,GETDATE() AS UPDATE_TIME
													   FROM [dbo].[SY_XIF_MES_RT_WIP_R] A WITH(NOLOCK)
															LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] B WITH(NOLOCK)
																-- ON A.EQPTID = B.EQUIPMENT_ID kimcd block 2017-09-01
																		ON CASE WHEN A.WIPSTAT = 'MOVING' THEN '' ELSE A.EQPTID END = B.EQUIPMENT_ID -- kimcd ADD 2017-09-01
																	   AND SUBSTRING(B.MES_LINE_ID,1,2)  =  B.FACTORY_ID -- 남경에 전극 설비가 PLANNING을 위해서 여러 BUILDING에 속해져 있음.
																	   AND A.EQSGID = B.MES_LINE_ID -- MES 라인 조건 추가
																	   AND A.PROCID = B.OPERATION_ID					 -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
															INNER JOIN ( SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
																		   FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK) ) C
																	ON SUBSTRING( CASE WHEN A.WIPSTAT = 'MOVING' THEN 
																						CASE WHEN A.TO_EQSGID ='' THEN 
																								A.EQSGID 
																							 ELSE 
																								A.TO_EQSGID 
																							 END  
																						ELSE 
																							A.EQSGID 
																						END ,1,2) =  C.FACTORY_ID
													  WHERE A.PROC_FLAG = 'P'
														AND ( A.COATING_SIDE_TYPE_CODE != 'T' OR A.COATING_SIDE_TYPE_CODE IS NULL )
														AND A.IF_ID = @IF_ID
														AND ISNULL( B.SITE_ID, C.SITE_ID ) = @SITE_ID
														AND ACCUM_DATE = @ACCUM_DATE
													  GROUP BY ISNULL( B.COMPANY_ID, C.COMPANY_ID)
															,ISNULL( B.DIVISION_ID, C.DIVISION_ID)
															,ISNULL( B.SITE_ID, C.SITE_ID )
															,ISNULL( B.PLANT_ID, C.PLANT_ID )
															,ISNULL( B.FACTORY_ID, C.FACTORY_ID )
															,A.PRODID
            												,ISNULL( A.UNHOLD_EXP_DATE, '1999-01-01 00:00:00') 
            												--,A.PROCID kimcd block 2017-09-01
															,CASE WHEN A.WIPSTAT = 'MOVING' THEN A.TO_PROCID ELSE A.PROCID END -- kimcd add 2017-09-01
															--,ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') -- MES 라인 직접 사용 kimcd 2017-08-09  -- kimcd block 2017-09-01
															,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_EQSGID,'-') ELSE ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') END -- kimcd add 2017-09-01
            												,A.IF_ID
															,wipstat
															,CASE WHEN A.WIPSTAT = 'MOVING' AND A.PROCID = 'AC001' THEN 'IN' ELSE A.WIP_TYPE_CODE END -- 2018-01-17 kimcd AC001(수리)공정에서 나오는 이동 중 재고는 IN으로 강제 전환
															,A.WIPHOLD
															,A.LANE_QTY	) A
												   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
																ON W.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
															   AND W.SEGMENT1 = A.OPERATION_ID
															   AND W.SEGMENT3 = A.WIP_TYPE_CODE
															   AND W.ACTIVE_FLAG = 'Y'
										   ) A
										--------------------------------------------------------------------------------------------------------------------------------------
										--2018-10-24 PIYONG ADD
										   LEFT OUTER JOIN (
															SELECT CHILD_QTY / PARENT_QTY	AS BOM_QTY
																   ,COMPANY_ID
																   ,BOM.DIVISION_ID
																   ,BOM.SITE_ID
																   ,BOM.PLANT_ID
																   ,BOM.PARENT_ITEM_ID
																   ,CHILD_ITEM_ID
																   ,ALT_PRIORITY
															  FROM [dbo].[SCM_BOM_M_V] BOM
															 WHERE 1=1
															   AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
															   AND BOM.EFF_START_DATE <= GETDATE()
															   AND BOM.EFF_END_DATE > GETDATE()
														   ) BOM
													    ON BOM.COMPANY_ID = A.COMPANY_ID
													   AND BOM.DIVISION_ID = A.DIVISION_ID
													   AND BOM.SITE_ID = A.SITE_ID
													   AND BOM.PLANT_ID = A.PLANT_ID
													   AND (BOM.ALT_PRIORITY = 1 OR BOM.ALT_PRIORITY IS NULL)
													   AND BOM.PARENT_ITEM_ID = (
																				CASE SEGMENT5 WHEN 'PRE' THEN
																									A.ITEM_ID
																							  WHEN 'STATUS' THEN
																									CASE WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' THEN
																										'-'
																									ELSE
																										A.ITEM_ID
																									END
																							   WHEN 'WAIT' THEN
																									CASE WHEN A.STOCK_STATUS = 'WAIT' THEN
																										A.ITEM_ID
																									ELSE
																										'-'
																									END
																								ELSE                  
																									'-'
																								END
																			 )
										--2018-10-24 PIYONG ADD END
										--------------------------------------------------------------------------------------------------------------------------------------
									) B
								ON ( A.COMPANY_ID = B.COMPANY_ID
									 AND A.DIVISION_ID = B.DIVISION_ID
									 AND A.SITE_ID = B.SITE_ID
									 AND A.PLANT_ID = B.PLANT_ID
									 AND A.FACTORY_ID = B.FACTORY_ID
									 AND A.STORAGE_ID = B.STORAGE_ID
									 AND A.CUTOFF_DATE = B.CUTOFF_DATE
									 AND A.SEQ  = B.SEQ
								  )
							 WHEN MATCHED THEN
								UPDATE SET A.[STOCK_TYPE]		= B.[STOCK_TYPE]
									,A.[ITEM_ID]				= B.[ITEM_ID]
									,A.[PRODUCTION_TYPE]		= B.[PRODUCTION_TYPE]
									,A.[AVAILABLE_DATE]			= B.[AVAILABLE_DATE]
									,A.[REMAIN_LEAD_TIME]		= B.[REMAIN_LEAD_TIME]
									,A.[HOLDING_DATE]			= B.[HOLDING_DATE]
									,A.[QTY]					= B.[QTY]
									,A.[QTY_UOM]				= B.[QTY_UOM]
									,A.[QTY2]					= B.[QTY2]
									,A.[STOCK_STATUS]			= B.[STOCK_STATUS]
									,A.[OPERATION_ID]			= B.[OPERATION_ID]
									,A.[LANE]					= B.[LANE]
									,A.[LINE_ID]				= B.[LINE_ID]
									,A.[OUTSOURCING_FLAG]		= B.[OUTSOURCING_FLAG]
									,A.[OUTSOURCING_FACTORY]	= B.[OUTSOURCING_FACTORY]
									,A.[DESCRIPTION]			= B.[DESCRIPTION]
									,A.[FP_APPLY_OPERATION_ID]	= B.[FP_APPLY_OPERATION_ID]
									,A.[FP_APPLY_ITEM_ID]		= B.[FP_APPLY_ITEM_ID]
									,A.[FP_APPLY_WIPQTY]		= B.[FP_APPLY_WIPQTY]
									,A.[WIPHOLD_YN]				= B.[WIPHOLD]
									,A.[WIP_TYPE_CODE]			= B.[WIP_TYPE_CODE]
									,A.[INSERT_ID]				= B.[INSERT_ID]
									,A.[UPDATE_ID]				= 'PR_XIF_MES_RT_WIP_R'
									,A.[UPDATE_TIME]			= GETDATE()
							WHEN NOT MATCHED THEN
								INSERT (  [COMPANY_ID]
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
										,[QTY_UOM]
										,[QTY2]
										,[STOCK_STATUS]
										,[OPERATION_ID]
										,[LANE]
										,[LINE_ID]
										,[OUTSOURCING_FLAG]
										,[OUTSOURCING_FACTORY]
										,[DESCRIPTION]
										,[FP_APPLY_OPERATION_ID]
										,[FP_APPLY_ITEM_ID]
										,[FP_APPLY_WIPQTY]
										,[WIPHOLD_YN]
										,[WIP_TYPE_CODE]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										)
								VALUES (
										 B.[COMPANY_ID]
										,B.[DIVISION_ID]
										,B.[SITE_ID]
										,B.[PLANT_ID]
										,B.[FACTORY_ID]
										,B.[STORAGE_ID]
										,B.[CUTOFF_DATE]
										,B.[SEQ]
										,B.[STOCK_TYPE]
										,B.[ITEM_ID]
										,B.[PRODUCTION_TYPE]
										,B.[AVAILABLE_DATE]
										,B.[REMAIN_LEAD_TIME]
										,B.[HOLDING_DATE]
										,B.[QTY]
										,B.[QTY_UOM]
										,B.[QTY2]
										,B.[STOCK_STATUS]
										,B.[OPERATION_ID]
										,B.[LANE]
										,B.[LINE_ID]
										,B.[OUTSOURCING_FLAG]
										,B.[OUTSOURCING_FACTORY]
										,B.[DESCRIPTION]
										,B.[FP_APPLY_OPERATION_ID]
										,B.[FP_APPLY_ITEM_ID]
										,B.[FP_APPLY_WIPQTY]
										,B.[WIPHOLD]
										,B.[WIP_TYPE_CODE]
										,B.[INSERT_ID]
										,GETDATE()
										,'PR_XIF_MES_RT_WIP_R'
										,GETDATE()
								)
						;

								

							SET @ROWCOUNT = @@ROWCOUNT

							UPDATE [dbo].[SY_XIF_MES_RT_WIP_R] SET
								PROC_FLAG = 'Y'
								,PROC_DATE = GETDATE()
							 WHERE PROC_FLAG = 'P'
							   AND IF_ID = @IF_ID
							   AND ACCUM_DATE = @ACCUM_DATE
							;

						END;

					FETCH NEXT FROM CUR_IF_MES_WIP INTO @IF_ID        
														,@ACCUM_DATE
														,@SITE_ID
					;



				END;

			CLOSE CUR_IF_MES_WIP;
			DEALLOCATE CUR_IF_MES_WIP;  

 

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

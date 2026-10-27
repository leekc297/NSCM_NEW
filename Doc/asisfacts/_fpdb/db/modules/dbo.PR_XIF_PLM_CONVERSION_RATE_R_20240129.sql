
CREATE PROCEDURE [dbo].[PR_XIF_PLM_CONVERSION_RATE_R_20240129]

-- ================================================================================================
-- Program ID          : FP03034
-- Program Name        : PR_XIF_PLM_CONVERSION_RATE_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : PLM
-- Destination System  : FP SDB
-- Source Table        : XIF_PLM_CONVERSION_RATE_R
-- Destination Table   : 
--
-- Create Date		   : 2020.11.06
-- Update Date		   : 2022.12.02 1.9 kimcd

-- Author              : KIMCD
-- Version             : 1.0 2020-11-06 kimcd - 광폭 양극의 경우 Jumboroll(m/batch)는 /2, Jumboroll(Cell/m)는 *2
--                       1.1 2021-02-17 kimcd 전체 자동차, ESS로 확대
--                       1.2 2021-03-30 kimcd 최종 갱신 사용자가 사용자인 경우도 작업의뢰서 기준으로 환산자 갱신
--                       1.2 2021-04-12 kimcd Lane 정보를 작업의뢰서 값 사용하도록 수정
--                       1.3 2021-05-14 kimcd Lane Master에서 Lane 값을 Primary Key에서 제거
--                       1.4 2021-06-07 kimcd FACTORY_ID = 'EA' ITEM_ID = 'APCAN1397A' AND PROD_VERSION_TYPE = 'PREWET_UNIT2' 은 수신 제외
--                       1.5 2021-12-13 kimcd EF동 음극도 광폭으로 수신
--                       1.6 2022-03-30 kimcd GM JV 가상 Division 81 Hard Coding 추가
--                       1.7 2022-05-23 kimcd 'EF','EI','EJ' 동의 광폭 Hard Coding 전환, E3000E4000 환산 유형 Lane 수신
--                       1.8 2022-08-23 leeseongmin [CSR : C20220801-000504] GSCM 모듈 간(SCP - FP) 전극 환산자 동기화 적용_BOM 변동간 환산자 업데이트 추가
--                       1.9 2022-12-02 kimcd 전극 버전별 생산 계획 수립하기 위해 환산자 버전별 가용 라인 정보 자동 형성
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_CONVERSION_RATE_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	DECLARE @ROWCOUNT    INTEGER       = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @COMPANY_ID  NVARCHAR(30)
	DECLARE @DIVISION_ID NVARCHAR(30)
	DECLARE @SITE_ID     NVARCHAR(30)
	DECLARE @PLANT_ID    NVARCHAR(30)
	DECLARE @IF_SEQ      NVARCHAR(50)
	DECLARE @WO_ID       NVARCHAR(50)
	DECLARE @AREA_ID     NVARCHAR(30)
	DECLARE @PROD_VERSION_TYPE  NVARCHAR(50)
	DECLARE @PLM_FACTORY NVARCHAR(50)
	DECLARE @PROD_VER_CODE NVARCHAR(10)
	DECLARE @VERSION_SEQ NVARCHAR(50)
	DECLARE @VERSION_TYPE NVARCHAR(10)
	DECLARE @MODEL_CODE  NVARCHAR(50)
	DECLARE @NICK_NAME   NVARCHAR(150)
	DECLARE @PANCAKE_ID  NVARCHAR(50)
	DECLARE @PROC_ID     NVARCHAR(30)
	DECLARE @ELECTRODE_TYPE NVARCHAR(50)
	DECLARE @CELL_BATCH  NUMERIC(18,5)
	DECLARE @M_BATCH     NUMERIC(18,5)
	DECLARE @JR_CELL_M   NUMERIC(18,5)
	DECLARE @PC_CELL_M   NUMERIC(18,5)
	DECLARE @LANE_QTY    NUMERIC(18,5)
	DECLARE @PC_M_BATCH  NUMERIC(18,5)
	DECLARE @APPLY_DATE  DATETIME
	DECLARE @B_PROD_VER_CODE NVARCHAR(10)
	DECLARE @HALF_FLAG   NVARCHAR(1)  -- 2022-05-23 E3000E4000 에서 Lane을 나눌 지 구분
	DECLARE @POST_TYPE   NVARCHAR(30) -- 2022-05-23 E3000E4000 형성 여부
	

	DECLARE CUR_CONVERSION_RATE CURSOR FOR
		SELECT  MAX(F.COMPANY_ID) AS COMPANY_ID,
				MAX(F.DIVISION_ID) AS DIVISION_ID,
				MAX(F.SITE_ID) AS SITE_ID,
				MAX(F.PLANT_ID) AS PLANT_ID,
				MAX(A.IF_SEQ) AS IF_SEQ,
				A.WO_ID, 
				A.AREA_ID,
				A.PROD_VERSION_TYPE,
				A.PLM_FACTORY,
				A.PROD_VER_CODE,
				ISNULL(A.VERSION_SEQ,'00') AS VERSION_SEQ,
				CASE  LEFT(A.PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE,
				A.MODEL_CODE,
				MAX(ISNULL(M.NICK_NAME,MM.NICK_NAME)) AS NICK_NAME,
				A.PANCAKE_ID,
				A.PROC_ID,
				(UPPER(LEFT(MAX(A.ELECTRODE_TYPE),1)) + LOWER(SUBSTRING(MAX(A.ELECTRODE_TYPE),2,LEN(MAX(A.ELECTRODE_TYPE))))) AS ELECTRODE_TYPE,
				MAX(A.CELL_BATCH) AS CELL_BATCH,
				CASE WHEN ((MAX(A.ELECTRODE_TYPE) = 'CATHODE' AND A.ATTR_01 = N'광폭') OR MAX(F.ALL_WIDE) = 'Y' ) THEN MAX(A.M_BATCH)/2 ELSE MAX(A.M_BATCH) END AS M_BATCH,  -- 2022-05-23 kimcd 'EF','EI','EJ' 동의 광폭 Hard Coding 을 F.ALL_WIDE로 전환 -- 2021-12-13 kimcd EA동 음극도 광폭으로 수신
				CASE WHEN ((MAX(A.ELECTRODE_TYPE) = 'CATHODE' AND A.ATTR_01 = N'광폭') OR MAX(F.ALL_WIDE) = 'Y' ) THEN MAX(A.JR_CELL_M) * 2 ELSE MAX(A.JR_CELL_M) END AS JR_CELL_M,  -- 2022-05-23 kimcd 'EF','EI','EJ' 동의 광폭 Hard Coding 을 F.ALL_WIDE로 전환-- 2021-12-13 kimcd EA동 음극도 광폭으로 수신
				MAX(A.PC_CELL_M) AS PC_CELL_M,
				--CASE WHEN MAX(A.ELECTRODE_TYPE) = 'CATHODE' AND A.ATTR_01 = N'광폭' THEN MAX(A.JR_CELL_M) * 2 ELSE MAX(A.JR_CELL_M) END / MAX(IL.LANE_QTY) AS PC_CELL_M,
				MAX(IL.LANE_QTY) AS LANE_QTY,
				CASE WHEN ((MAX(A.ELECTRODE_TYPE) = 'CATHODE' AND A.ATTR_01 = N'광폭') OR MAX(F.ALL_WIDE) = 'Y' ) THEN MAX(A.M_BATCH)/2 ELSE MAX(A.M_BATCH) END * MAX(IL.LANE_QTY) AS PC_M_BATCH,  -- 2022-05-23 kimcd 'EF','EI','EJ' 동의 광폭 Hard Coding 을 F.ALL_WIDE로 전환--  2021-12-13 kimcd EA동 음극도 광폭으로 수신
				MAX(A.APPLY_DATE) AS APPLY_DATE,
				MAX(A.B_PROD_VER_CODE) AS B_PROD_VER_CODE,
				CASE WHEN ((MAX(A.ELECTRODE_TYPE) = 'CATHODE' AND A.ATTR_01 = N'광폭') OR MAX(F.ALL_WIDE) = 'Y' ) THEN 'Y' END AS HALF_FLAG,  -- 2022-05-23 E3000E4000 에서 Lane을 나눌 지 구분
				(SELECT TOP 1 ATTRIBUTE1
				FROM    SCM_SYS_LOOKUP_VALUE SSLV (NOLOCK)
				WHERE   SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
				AND     SSLV.SEGMENT4 = A.AREA_ID
				AND     SSLV.SEGMENT5 = 'E3000E4000' )   AS POST_TYPE -- 2022-05-23 E3000E4000 형성 여부
		FROM   (SELECT  MAX(PCR.IF_SEQ) AS IF_SEQ,
						PCR.WO_ID, 
						PCR.AREA_ID,
						MAX(ISNULL(SSLV.ATTRIBUTE1, SSLV2.ATTRIBUTE1)) AS PROD_VERSION_TYPE,
						PCR.PLM_FACTORY,
						CASE WHEN PCR.AREA_ID = 'EA' THEN
							CASE WHEN PCR.PLM_FACTORY IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
								CONCAT(PCR.PROD_VER_CODE,'2')
							WHEN PCR.PLM_FACTORY IN ('CNNJ6C0A', 'CNNJ6E0A') THEN  -- 2020-12-03 kimcd 환산자 Case 문장 추가
								CONCAT(PCR.PROD_VER_CODE,'3')
							ELSE
								PCR.PROD_VER_CODE
							END
						ELSE
							PCR.PROD_VER_CODE
						END PROD_VER_CODE,
						PCR.PROD_VER_CODE  AS B_PROD_VER_CODE,
						PCR.VERSION_SEQ,
						PCR.MODEL_CODE,
						PCR.PANCAKE_ID,
						PCR.PROC_ID,
						MAX(CASE WHEN PCR.CONVERSION_ITEM_ID IN ('I-A001-ELEC-002', --  cell/batch
													'I-E001-ELEC-002',
													'I-E002-ELEC-002',
													'I-A002-ELEC-002') THEN
								CONVERT(NUMERIC(18,5),PCR.VALUE1)
							END) AS CELL_BATCH,
					   MAX(CASE WHEN PCR.CONVERSION_ITEM_ID IN ('I-E002-ELEC-009', -- m/batch
													'I-A001-ELEC-009',
													'I-A002-ELEC-009',
													'I-E001-ELEC-009') THEN
								CONVERT(NUMERIC(18,5),PCR.VALUE1)
							END) AS M_BATCH,
					   MAX(CASE WHEN PCR.CONVERSION_ITEM_ID IN ('I-A002-ELEC-014', -- 점보롤 cell/m
													'I-E001-ELEC-014',
													'I-A001-ELEC-014',
													'I-E002-ELEC-014') THEN
								CONVERT(NUMERIC(18,5),PCR.VALUE1)
							END) AS JR_CELL_M,
					   MAX(CASE WHEN PCR.CONVERSION_ITEM_ID IN ('I-A001-ELEC-030', -- 팬케이크 cell/m
													'I-A002-ELEC-030',
													'I-E001-ELEC-030',
													'I-E002-ELEC-030') THEN
								CONVERT(NUMERIC(18,5),PCR.VALUE1)
							END) AS PC_CELL_M,
					   MAX(CONVERT(DATE,PCR.APPLY_DATE,112)) AS APPLY_DATE,
					   PCR.ATTR_01,
					   MAX(PCR.ELECTRODE_TYPE) ELECTRODE_TYPE 
				FROM   SY_XIF_PLM_CONVERSION_RATE_R  PCR (NOLOCK)
						LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV (NOLOCK)
							ON  SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
							AND SSLV.SEGMENT4 = PCR.AREA_ID
							AND SSLV.SEGMENT5 = ISNULL(PCR.PLM_FACTORY, '-')
						LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2 (NOLOCK)
							ON  SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
							AND SSLV2.SEGMENT4 = PCR.AREA_ID
							AND SSLV2.SEGMENT5 = '-'
				WHERE  PCR.PROC_FLAG = 'N'
				AND    PCR.AREA_ID IN (SELECT F.FACTORY_ID FROM SCM_FACTORY_M F (NOLOCK) WHERE DIVISION_ID IN ('81','82') -- 2021-02-17 kimcd 전체 자동차, ESS로 확대
									   UNION ALL
									   SELECT F.FACTORY_ID
									   FROM   SCM_FACTORY_M F (NOLOCK),
									          SCM_PSEUDO_DIVISION_M PD (NOLOCK)
									   WHERE  F.PLANT_ID = PD.PLANT_ID
									   AND    PD.ORIGINAL_DIVISION_ID IN  ('81','82')) -- 2022-03-30 kimcd JV 가상 Division용 Hard Coding 추가
				AND    PCR.PROC_ID = 'E2000'
				AND    PCR.CONVERSION_ITEM_ID IN  ( 'I-A001-ELEC-002', --  cell/batch
													'I-E001-ELEC-002',
													'I-E002-ELEC-002',
													'I-A002-ELEC-002',
													'I-E002-ELEC-009', -- m/batch
													'I-A001-ELEC-009',
													'I-A002-ELEC-009',
													'I-E001-ELEC-009',
													'I-A002-ELEC-014', -- 점보롤 cell/m
													'I-E001-ELEC-014',
													'I-A001-ELEC-014',
													'I-E002-ELEC-014',
													'I-A001-ELEC-030', -- 팬케이크 cell/m
													'I-A002-ELEC-030',
													'I-E001-ELEC-030',
													'I-E002-ELEC-030')
				GROUP BY PCR.WO_ID, PCR.AREA_ID, PCR.PLM_FACTORY, PCR.PROD_VER_CODE, PCR.VERSION_SEQ, PCR.MODEL_CODE, PCR.PANCAKE_ID, PCR.PROC_ID,PCR.ATTR_01
				) A
				INNER JOIN SCM_FACTORY_M F (NOLOCK)
					ON A.AREA_ID           = F.FACTORY_ID
				INNER JOIN (SELECT  IL.WO_ID, 
									IL.AREA_ID,
									IL.PLM_FACTORY,
									IL.PROD_VER_CODE,
									ISNULL(IL.VERSION_SEQ,'00') AS VERSION_SEQ,
									IL.MODEL_CODE,
									IL.PANCAKE_ID,
									MAX(IL.VALUE1) AS LANE_QTY
							FROM  ( SELECT  PCR.WO_ID, 
											PCR.AREA_ID,
											PCR.PLM_FACTORY,
											PCR.PROD_VER_CODE,
											PCR.VERSION_SEQ,
											PCR.MODEL_CODE,
											CASE WHEN PCR.PANCAKE_ID LIKE '%,%'THEN LEFT(PCR.PANCAKE_ID, CHARINDEX(',', PCR.PANCAKE_ID)-1) ELSE PCR.PANCAKE_ID END PANCAKE_ID,
											PCR.ATTR_01,
											CASE WHEN ((PCR.ELECTRODE_TYPE = 'CATHODE' AND PCR.ATTR_01 = N'광폭') OR F.ALL_WIDE = 'Y' ) THEN VALUE1 * 2 ELSE VALUE1 END AS VALUE1  -- 2022-05-23 kimcd 'EF','EI','EJ' 동의 광폭 Hard Coding 을 F.ALL_WIDE로 전환 -- 2021-12-13 kimcd EA동 음극도 광폭으로 수신
									FROM    SY_XIF_PLM_CONVERSION_RATE_R PCR
											INNER JOIN (SELECT F.FACTORY_ID, F.ALL_WIDE FROM SCM_FACTORY_M F (NOLOCK) WHERE DIVISION_ID IN ('81','82') -- 2021-02-17 kimcd 전체 자동차, ESS로 확대
														UNION ALL
														SELECT F.FACTORY_ID, F.ALL_WIDE
														FROM   SCM_FACTORY_M F (NOLOCK),
																SCM_PSEUDO_DIVISION_M PD (NOLOCK)
														WHERE  F.PLANT_ID = PD.PLANT_ID
														AND    PD.ORIGINAL_DIVISION_ID IN  ('81','82')) F -- 2022-05-23 kimcd 'EF','EI','EJ' 동의 광폭 Hard Coding 을 F.ALL_WIDE로 전환 -- 2022-03-30 kimcd JV 가상 Division용 Hard Coding 추가
												ON PCR.AREA_ID = F.FACTORY_ID
									WHERE   PCR.PROC_FLAG = 'N'
									AND     PCR.CONVERSION_ITEM_ID IN ( 'I-A001-ELEC-007',	-- Lane수
																		'I-E001-ELEC-007',
																		'I-P001-ELEC-024',
																		'I-P002-ELEC-016',
																		'I-A002-ELEC-007',
																		'I-E002-ELEC-007')
									UNION ALL
									SELECT 	PCR.WO_ID, 
											PCR.AREA_ID,
											PCR.PLM_FACTORY,
											PCR.PROD_VER_CODE,
											PCR.VERSION_SEQ,
											PCR.MODEL_CODE,
											SUBSTRING(PCR.PANCAKE_ID, CHARINDEX(',', PCR.PANCAKE_ID)+1, LEN(PCR.PANCAKE_ID)) PANCAKE_ID,
											PCR.ATTR_01,
											CASE WHEN ((PCR.ELECTRODE_TYPE = 'CATHODE' AND PCR.ATTR_01 = N'광폭') OR F.ALL_WIDE = 'Y' ) THEN VALUE1 * 2 ELSE VALUE1 END AS VALUE1  -- 2021-12-13 kimcd EA동 음극도 광폭으로 수신
									FROM    SY_XIF_PLM_CONVERSION_RATE_R PCR
											INNER JOIN (SELECT F.FACTORY_ID, F.ALL_WIDE FROM SCM_FACTORY_M F (NOLOCK) WHERE DIVISION_ID IN ('81','82') -- 2021-02-17 kimcd 전체 자동차, ESS로 확대
														UNION ALL
														SELECT F.FACTORY_ID, F.ALL_WIDE
														FROM   SCM_FACTORY_M F (NOLOCK),
																SCM_PSEUDO_DIVISION_M PD (NOLOCK)
														WHERE  F.PLANT_ID = PD.PLANT_ID
														AND    PD.ORIGINAL_DIVISION_ID IN  ('81','82')) F -- 2022-05-23 kimcd 'EF','EI','EJ' 동의 광폭 Hard Coding 을 F.ALL_WIDE로 전환 -- 2022-03-30 kimcd JV 가상 Division용 Hard Coding 추가
												ON PCR.AREA_ID = F.FACTORY_ID
									WHERE   PCR.PROC_FLAG = 'N'
									AND     PCR.CONVERSION_ITEM_ID IN ( 'I-A001-ELEC-007',	-- Lane수
																		'I-E001-ELEC-007',
																		'I-P001-ELEC-024',
																		'I-P002-ELEC-016',
																		'I-A002-ELEC-007',
																		'I-E002-ELEC-007')
									AND     PCR.PANCAKE_ID LIKE '%,%') IL
							GROUP BY IL.WO_ID, IL.AREA_ID, IL.PLM_FACTORY, IL.PROD_VER_CODE, IL.VERSION_SEQ, IL.MODEL_CODE, IL.PANCAKE_ID
							) IL -- 2021-04-12 kimcd 레인을 작업의뢰서에서 수신
					ON		A.WO_ID           = IL.WO_ID
					AND 	A.AREA_ID         = IL.AREA_ID
					AND		A.PLM_FACTORY     = IL.PLM_FACTORY
					AND		A.B_PROD_VER_CODE = IL.PROD_VER_CODE
					AND		ISNULL(A.VERSION_SEQ,'00') = IL.VERSION_SEQ
					AND		A.MODEL_CODE      = IL.MODEL_CODE
					AND		A.PANCAKE_ID      = IL.PANCAKE_ID
				/* 2021-04-12 kimcd 레인을 작업의뢰서에서 수신하면서 막음
				  INNER JOIN SCM_ITEM_LANE_M IL (NOLOCK)
					ON      F.COMPANY_ID        = IL.COMPANY_ID
					AND     F.DIVISION_ID		= IL.DIVISION_ID
					AND     F.SITE_ID			= IL.SITE_ID
					AND     F.PLANT_ID		    = IL.PLANT_ID
					AND     A.AREA_ID			= IL.FACTORY_ID
					AND     A.PANCAKE_ID		= IL.ITEM_ID
					AND     A.PROD_VERSION_TYPE = IL.PROD_VERSION_TYPE*/
				LEFT OUTER JOIN SCM_ITEM_M M (NOLOCK)			--NICK_NAME
					ON  F.COMPANY_ID  = M.COMPANY_ID
					AND F.DIVISION_ID = M.DIVISION_ID
					AND F.SITE_ID     = M.SITE_ID
					AND A.MODEL_CODE  = M.[ITEM_ID]
				LEFT OUTER JOIN SCM_ITEM_M MM (NOLOCK)			--NICK_NAME
					ON  F.COMPANY_ID  = MM.COMPANY_ID
					AND F.DIVISION_ID = MM.DIVISION_ID
					AND F.SITE_ID     = MM.SITE_ID
					AND A.PANCAKE_ID  = MM.ITEM_ID
		WHERE   IL.LANE_QTY         > 0
		AND     NOT ( A.AREA_ID = 'EA' AND A.PANCAKE_ID = 'APCAN1397A' AND A.PROD_VERSION_TYPE = 'PREWET_UNIT2' ) -- 2021-06-07 kimcd 수신 제외
		GROUP BY A.WO_ID, A.AREA_ID, A.PROD_VERSION_TYPE, A.PLM_FACTORY, A.PROD_VER_CODE, A.VERSION_SEQ, A.MODEL_CODE, A.PANCAKE_ID, A.PROC_ID, A.ATTR_01
		HAVING MAX(A.CELL_BATCH) > 0
		AND    MAX(A.M_BATCH) > 0
		AND    MAX(A.JR_CELL_M) > 0
		AND    MAX(A.PC_CELL_M) > 0
		AND    MAX(A.APPLY_DATE) IS NOT NULL
		ORDER BY A.WO_ID

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	
	BEGIN TRY				

		-- ================================================
		-- 로직 추가
		-- ================================================
		UPDATE [dbo].[SY_XIF_PLM_CONVERSION_RATE_R]
		SET    PROC_FLAG = 'Y',
			   PROC_DATE = GETDATE()
 		WHERE  PROC_FLAG = 'N'
		AND    AREA_ID NOT IN (SELECT F.FACTORY_ID FROM SCM_FACTORY_M F (NOLOCK) WHERE DIVISION_ID IN ('81','82') -- 2021-02-17 kimcd 전체 자동차, ESS로 확대
							   UNION ALL
							   SELECT F.FACTORY_ID
							   FROM   SCM_FACTORY_M F (NOLOCK),
									  SCM_PSEUDO_DIVISION_M PD (NOLOCK)
							   WHERE  F.PLANT_ID = PD.PLANT_ID
							   AND    PD.ORIGINAL_DIVISION_ID IN  ('81','82')) -- 2022-03-30 kimcd JV 가상 Division용 Hard Coding 추가

		UPDATE [dbo].[SY_XIF_PLM_CONVERSION_RATE_R]
		SET    PROC_FLAG = 'Y',
			   PROC_DATE = GETDATE()
 		WHERE  PROC_FLAG = 'N'
		AND    PROC_ID  != 'E2000'
		AND    CONVERSION_ITEM_ID NOT IN (  'I-A001-ELEC-007',	-- Lane수
											'I-E001-ELEC-007',
											'I-P001-ELEC-024',
											'I-P002-ELEC-016',
											'I-A002-ELEC-007',
											'I-E002-ELEC-007') -- 2021-0-4-12 kimcd Lane은 E2000 공정에 없는 것이 많아 조건 추가

		OPEN CUR_CONVERSION_RATE;
		FETCH NEXT FROM CUR_CONVERSION_RATE INTO    @COMPANY_ID,
													@DIVISION_ID,
													@SITE_ID,
													@PLANT_ID,
													@IF_SEQ,
													@WO_ID,
													@AREA_ID,
													@PROD_VERSION_TYPE,
													@PLM_FACTORY,
													@PROD_VER_CODE,
													@VERSION_SEQ,
													@VERSION_TYPE,
													@MODEL_CODE,
													@NICK_NAME,
													@PANCAKE_ID,
													@PROC_ID,
													@ELECTRODE_TYPE,
													@CELL_BATCH,
													@M_BATCH,
													@JR_CELL_M,
													@PC_CELL_M,
													@LANE_QTY,
													@PC_M_BATCH,
													@APPLY_DATE,
													@B_PROD_VER_CODE,
													@HALF_FLAG,  -- 2022-05-23 E3000E4000 에서 Lane을 나눌 지 구분
													@POST_TYPE;  -- 2022-05-23 E3000E4000 형성 여부

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			-- 환산자 설정
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING ( SELECT  @COMPANY_ID  AS COMPANY_ID,
							@DIVISION_ID AS DIVISION_ID,
							@SITE_ID     AS SITE_ID,
							@PLANT_ID    AS PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE AS ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'cell/batch'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@CELL_BATCH AS VALUE,
							@PROD_VERSION_TYPE AS PROD_VERSION_TYPE,
							@VERSION_TYPE AS VERSION_TYPE,
							@VERSION_SEQ  AS PROD_SEQ,
							@APPLY_DATE   AS APPLY_DATE 
					UNION ALL
					SELECT  @COMPANY_ID,
							@DIVISION_ID,
							@SITE_ID,
							@PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'm/batch'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@M_BATCH AS VALUE,
							@PROD_VERSION_TYPE,
							@VERSION_TYPE,
							@VERSION_SEQ  AS PROD_SEQ,
							@APPLY_DATE
					UNION ALL
					SELECT  @COMPANY_ID,
							@DIVISION_ID,
							@SITE_ID,
							@PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'점보롤 cell/m'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@JR_CELL_M AS VALUE,
							@PROD_VERSION_TYPE,
							@VERSION_TYPE,
							@VERSION_SEQ  AS PROD_SEQ,
							@APPLY_DATE
					UNION ALL
					SELECT  @COMPANY_ID,
							@DIVISION_ID,
							@SITE_ID,
							@PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'펜케잌 cell/m'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@PC_CELL_M AS VALUE,
							@PROD_VERSION_TYPE,
							@VERSION_TYPE,
							@VERSION_SEQ  AS PROD_SEQ,
							@APPLY_DATE
					UNION ALL
					SELECT  @COMPANY_ID,
							@DIVISION_ID,
							@SITE_ID,
							@PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'Lane수'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@LANE_QTY  AS VALUE,
							@PROD_VERSION_TYPE,
							@VERSION_TYPE,
							@VERSION_SEQ  AS PROD_SEQ,
							@APPLY_DATE
					UNION ALL
					SELECT  @COMPANY_ID,
							@DIVISION_ID,
							@SITE_ID,
							@PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'Jumbo Roll (m/batch)'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@PC_M_BATCH AS VALUE,
							@PROD_VERSION_TYPE,
							@VERSION_TYPE,
							@VERSION_SEQ  AS PROD_SEQ,
							@APPLY_DATE
				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_ID]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[CATEGORY]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PJT_CODE]
				           ,[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
						   ,[CATEGORY] = B.[CATEGORY]
						   -- ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[VALUE] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R' THEN A.[VALUE] ELSE B.[VALUE] END END -- 차수가 다른 경우 값 갱신 
						   ,[VALUE] = B.[VALUE] -- 2021-03-30 kimcd 최종 갱신자 무관하게 작업의뢰서 기준으로 갱신
						   ,[MMD_VALUE] = B.[VALUE]
						   ,[VERSION_TYPE]		= B.VERSION_TYPE
						   ,[APPLY_DATE] = B.[APPLY_DATE]
						   ,[PROD_SEQ]   = B.[PROD_SEQ]
						   -- ,[UPDATE_ID] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R' THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신
						   ,[UPDATE_ID] = 'PR_XIF_PLM_ITEM_CONV_CALC_R' -- 2021-03-30 kimcd 최종 갱신자 무관하게 작업의뢰서 기준으로 갱신
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE]
					,[PROD_SEQ]
				) VALUES (
					 B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_ID]
					,B.[PJT_CODE]
					,B.[VERSION]
					,B.[OPERATION]
					,B.[ITEM_ID]
					,B.[ELECTRODE_TYPE]
					,B.[CATEGORY]
					,B.[VALUE]
					,B.[VALUE]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]
					,B.[PROD_SEQ]
				)	;			

			SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
			

			-- 전체 N으로 변경
			UPDATE [SCM_ITEM_CONV_CALC_M]
			   SET MAX_VER_FLAG = 'N'
   			 WHERE [COMPANY_ID]			= @COMPANY_ID
			  AND  [FACTORY_ID]			= @AREA_ID
			  AND  [MODEL_ID]			= @MODEL_CODE
			  AND  [OPERATION]			= @PROC_ID
			  AND  [ITEM_ID]			= @PANCAKE_ID
			  AND  [PROD_VERSION_TYPE]	= @PROD_VERSION_TYPE
			
			-- Y로 재설정
			UPDATE B
			   SET B.MAX_VER_FLAG = 'Y'
				   ,B.VERSION_TYPE = A.VERSION_TYPE
			  FROM [dbo].[SCM_ITEM_CONV_CALC_M] B
				   ,( SELECT A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.MODEL_ID
							 , A.OPERATION
							 , A.ITEM_ID
							 , A.VERSION
							 , A.VERSION_TYPE
							 , A.PROD_VERSION_TYPE
						FROM (
							   SELECT A.COMPANY_ID
									  , A.DIVISION_ID
									  , A.SITE_ID
									  , A.PLANT_ID
									  , A.FACTORY_ID
									  , A.MODEL_ID
									  , A.OPERATION
									  , A.ITEM_ID
									  , A.VERSION
									  , A.VERSION_TYPE
									  , A.PROD_VERSION_TYPE
									  , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
																	 , A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.VERSION_TYPE  ,A.PROD_VERSION_TYPE
																	 , CASE WHEN LEFT(VERSION, 1) = 'Z' THEN 'T' ELSE 'M' END
															   ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID
																	 , A.OPERATION, A.ITEM_ID , CASE RIGHT(VERSION, 1) WHEN 'W' THEN VERSION+'0'
																													   WHEN 'P' THEN VERSION+'0'
																													   WHEN 'S' THEN VERSION+'0'
																													   ELSE VERSION
																													   END DESC						 )  AS ROW_NUM
								 FROM (
										SELECT DISTINCT A.COMPANY_ID
											   , A.DIVISION_ID
											   , A.SITE_ID
											   , A.PLANT_ID
											   , A.FACTORY_ID
											   , A.MODEL_ID
											   , A.OPERATION
											   , A.ITEM_ID
											   , A.VERSION
											   , A.VERSION_TYPE
											   , A.PROD_VERSION_TYPE
										  FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
   										 WHERE A.[COMPANY_ID]			= @COMPANY_ID
										  AND  A.[FACTORY_ID]			= @AREA_ID
										  AND  A.[MODEL_ID]				= @MODEL_CODE
										  AND  A.[OPERATION]			= @PROC_ID
										  AND  A.[ITEM_ID]				= @PANCAKE_ID
										  AND  A.[PROD_VERSION_TYPE]	= @PROD_VERSION_TYPE
									  ) A
							 ) A
					   WHERE ROW_NUM = 1
				   ) A
			 WHERE A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
			   AND A.PLANT_ID = B.PLANT_ID
			   AND A.FACTORY_ID = B.FACTORY_ID
			   AND A.MODEL_ID = B.MODEL_ID
			   AND A.OPERATION = B.OPERATION
			   AND A.ITEM_ID = B.ITEM_ID
			   AND A.VERSION = B.VERSION
	   		   AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE

			-- 2021-04-12 kimcd 라인 Master 수신 시작
			MERGE INTO [dbo].[SCM_ITEM_LANE_M] IL
			USING (	SELECT   @COMPANY_ID        AS COMPANY_ID
							,@DIVISION_ID       AS DIVISION_ID
							,@SITE_ID           AS SITE_ID
							,@PLANT_ID          AS PLANT_ID
							,@AREA_ID           AS FACTORY_ID
							,@PANCAKE_ID        AS ITEM_ID
							,@LANE_QTY          AS LANE_QTY
							,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE
					) TEMP
				ON (
					IL.COMPANY_ID				= TEMP.COMPANY_ID
					AND IL.DIVISION_ID			= TEMP.DIVISION_ID
					AND IL.SITE_ID				= TEMP.SITE_ID
					AND IL.PLANT_ID				= TEMP.PLANT_ID
					AND IL.ITEM_ID				= TEMP.ITEM_ID
					 AND IL.LANE_QTY				= TEMP.LANE_QTY --2021-05-14 kimcd Lane Master에서 Lane 값을 Primary Key에서 제거
					AND IL.FACTORY_ID			= TEMP.FACTORY_ID
					AND IL.PROD_VERSION_TYPE	= TEMP.PROD_VERSION_TYPE							
					)
			WHEN MATCHED THEN
				UPDATE
					SET  IL.ACTIVE_FLAG = 'Y'
					    ,IL.LANE_QTY	= CASE WHEN TEMP.FACTORY_ID = 'EA' AND TEMP.ITEM_ID = 'APCAN1397A' AND TEMP.PROD_VERSION_TYPE = 'PREWET_UNIT2' THEN 8
										  ELSE TEMP.LANE_QTY END -- 2021-05-14 kimcd Lane Master에서 Lane 값을 Primary Key에서 제거
						,IL.UPDATE_ID   = 'PR_XIF_PLM_CONVERSION_RATE_R'
						,IL.UPDATE_TIME = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
						[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[ITEM_ID]
						,[LANE_QTY]
						,[GPLM_LANE_QTY]
						,[PROD_VERSION_TYPE]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
				) VALUES(      								
						TEMP.COMPANY_ID
						,TEMP.DIVISION_ID
						,TEMP.SITE_ID
						,TEMP.PLANT_ID
						,TEMP.FACTORY_ID
						,TEMP.ITEM_ID
						,TEMP.LANE_QTY
						,TEMP.LANE_QTY
						,TEMP.PROD_VERSION_TYPE
						,'PR_XIF_PLM_CONVERSION_RATE_R'
						,GETDATE()
						,'PR_XIF_PLM_CONVERSION_RATE_R'
						,GETDATE()
				)
			;
			-- 2021-04-12 kimcd 라인 Master 수신 종료

			-- 2022-05-23 kimcd 라인 전극 후 공정 Lane 정보 수신 시작
			IF @POST_TYPE IS NOT NULL AND @POST_TYPE != ''
				BEGIN
					MERGE INTO [dbo].[SCM_ITEM_LANE_M] IL
					USING (	SELECT   @COMPANY_ID        AS COMPANY_ID
									,@DIVISION_ID       AS DIVISION_ID
									,@SITE_ID           AS SITE_ID
									,@PLANT_ID          AS PLANT_ID
									,@AREA_ID           AS FACTORY_ID
									,@PANCAKE_ID        AS ITEM_ID
									--,CASE WHEN @HALF_FLAG = 'Y' THEN @LANE_QTY/2 ELSE @LANE_QTY END AS LANE_QTY
									,@LANE_QTY          AS LANE_QTY
									,@POST_TYPE         AS PROD_VERSION_TYPE
							) TEMP
						ON (
							IL.COMPANY_ID				= TEMP.COMPANY_ID
							AND IL.DIVISION_ID			= TEMP.DIVISION_ID
							AND IL.SITE_ID				= TEMP.SITE_ID
							AND IL.PLANT_ID				= TEMP.PLANT_ID
							AND IL.ITEM_ID				= TEMP.ITEM_ID
							-- AND IL.LANE_QTY				= TEMP.LANE_QTY 2021-05-14 kimcd Lane Master에서 Lane 값을 Primary Key에서 제거
							AND IL.FACTORY_ID			= TEMP.FACTORY_ID
							AND IL.PROD_VERSION_TYPE	= TEMP.PROD_VERSION_TYPE							
							)
					WHEN MATCHED THEN
						UPDATE
							SET  IL.ACTIVE_FLAG = 'Y'
								,IL.LANE_QTY	= CASE WHEN TEMP.FACTORY_ID = 'EA' AND TEMP.ITEM_ID = 'APCAN1397A' AND TEMP.PROD_VERSION_TYPE = 'PREWET_UNIT2' THEN 8
												  ELSE TEMP.LANE_QTY END -- 2021-05-14 kimcd Lane Master에서 Lane 값을 Primary Key에서 제거
								,IL.UPDATE_ID   = 'PR_XIF_PLM_CONVERSION_RATE_R'
								,IL.UPDATE_TIME = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[ITEM_ID]
								,[LANE_QTY]
								,[GPLM_LANE_QTY]
								,[PROD_VERSION_TYPE]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
						) VALUES(      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.ITEM_ID
								,TEMP.LANE_QTY
								,TEMP.LANE_QTY
								,TEMP.PROD_VERSION_TYPE
								,'PR_XIF_PLM_CONVERSION_RATE_R'
								,GETDATE()
								,'PR_XIF_PLM_CONVERSION_RATE_R'
								,GETDATE()
						)
					;
				END;
			-- 2022-05-23 kimcd 라인 전극 후 공정 Lane 정보 수신 종료

			-- 2022-12-02 kimcd 전극 버전별 생산 계획 수립하기 위해 환산자 버전별 가용 라인 정보 자동 형성 수신 시작
			MERGE INTO [dbo].[SCM_ITEM_CONV_CALC_USE_M] ICC
			USING (SELECT  DISTINCT 
			               @AREA_ID             AS [FACTORY_ID]
						  ,@MODEL_CODE          AS [MODEL_ID]
						  ,@PANCAKE_ID          AS [ITEM_ID]
						  ,ILA.[LINE_ID]        AS [LINE_ID]
						  ,ILA.[ELECTRODE_TYPE] AS [ELECTRODE_TYPE]
						  ,@PROD_VER_CODE       AS [VERSION]
						  ,ILA.[COMPANY_ID]
						  ,ILA.[DIVISION_ID]
						  ,ILA.[SITE_ID]
						  ,ILA.[PLANT_ID]
						  ,ILA.[OPERATION_ID]
						  ,'Y'                  AS [ACTIVE_FLAG]
			       FROM    SCM_ITEM_LINE_ASSIGN_M  ILA WITH(NOLOCK)
						   INNER JOIN SCM_LINE_M   LM  WITH(NOLOCK)
						   ON  ILA.COMPANY_ID     = LM.COMPANY_ID
						   AND ILA.DIVISION_ID    = LM.DIVISION_ID
						   AND ILA.SITE_ID        = LM.SITE_ID
						   AND ILA.PLANT_ID       = LM.PLANT_ID
						   AND ILA.FACTORY_ID     = LM.FACTORY_ID
						   AND ILA.OPERATION_ID   = LM.OPERATION_ID
						   AND ILA.LINE_ID        = LM.LINE_ID
						   AND ILA.ELECTRODE_TYPE = LM.ELECTRODE_TYPE
					WHERE ILA.MONTH       >= CONVERT(VARCHAR(6), DATEADD(M, -1, GETDATE()), 112)
					AND   ILA.ITEM_ID      = @PANCAKE_ID
					AND   LM.OPERATION_ID  = 'E2000'
					AND   LM.COMPANY_ID    = @COMPANY_ID
					AND   LM.DIVISION_ID   = @DIVISION_ID
					AND   LM.SITE_ID       = @SITE_ID
					AND   LM.PLANT_ID      = @PLANT_ID
					AND   LM.FACTORY_ID    = @AREA_ID
					AND   LM.PROD_VERSION_TYPE = @PROD_VERSION_TYPE
					AND   LM.ACTIVE_FLAG   = 'Y' ) ILA
			ON (    ICC.[FACTORY_ID]	 = ILA.[FACTORY_ID]
				AND ICC.[MODEL_ID]		 = ILA.[MODEL_ID]
				AND ICC.[ITEM_ID]		 = ILA.[ITEM_ID]
				AND ICC.[LINE_ID]		 = ILA.[LINE_ID]
				AND ICC.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
				AND ICC.[VERSION]        = ILA.[VERSION] )
			WHEN NOT MATCHED THEN
				INSERT (   [FACTORY_ID]
						  ,[MODEL_ID]
						  ,[ITEM_ID]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
						  ,[VERSION]
						  ,[COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[OPERATION_ID]
						  ,[ACTIVE_FLAG]
						  ,[INSERT_ID]
						  ,[INSERT_TIME]
						  ,[UPDATE_ID]
						  ,[UPDATE_TIME])
				VALUES (   ILA.[FACTORY_ID]
						  ,ILA.[MODEL_ID]
						  ,ILA.[ITEM_ID]
						  ,ILA.[LINE_ID]
						  ,ILA.[ELECTRODE_TYPE]
						  ,ILA.[VERSION]
						  ,ILA.[COMPANY_ID]
						  ,ILA.[DIVISION_ID]
						  ,ILA.[SITE_ID]
						  ,ILA.[PLANT_ID]
						  ,ILA.[OPERATION_ID]
						  ,ILA.[ACTIVE_FLAG]
						  ,'PR_XIF_PLM_CONVERSION_RATE_R'
						  ,GETDATE()
						  ,'PR_XIF_PLM_CONVERSION_RATE_R'
						  ,GETDATE());
  			-- 2022-12-02 kimcd 전극 버전별 생산 계획 수립하기 위해 환산자 버전별 가용 라인 정보 자동 형성 수신 종료

			-- I/F 수신 처리
			UPDATE SY_XIF_PLM_CONVERSION_RATE_R
			SET    PROC_FLAG = 'Y',
				   PROC_DATE = GETDATE()
			WHERE  PROC_FLAG     = 'N'
			AND    WO_ID         = @WO_ID
			AND    AREA_ID       = @AREA_ID
			AND    PLM_FACTORY   = @PLM_FACTORY
			AND    PROD_VER_CODE = @B_PROD_VER_CODE
			AND    ISNULL(VERSION_SEQ,'00') = @VERSION_SEQ
			AND    MODEL_CODE    = @MODEL_CODE
			AND    PANCAKE_ID    = @PANCAKE_ID
			-- AND    PROC_ID       = @PROC_ID 2021-04-12 kimcd Lane은 E2000 공정 외에 설정되어 조건 제거

			FETCH NEXT FROM CUR_CONVERSION_RATE INTO    @COMPANY_ID,
														@DIVISION_ID,
														@SITE_ID,
														@PLANT_ID,
														@IF_SEQ,
														@WO_ID,
														@AREA_ID,
														@PROD_VERSION_TYPE,
														@PLM_FACTORY,
														@PROD_VER_CODE,
														@VERSION_SEQ,
														@VERSION_TYPE,
														@MODEL_CODE,
														@NICK_NAME,
														@PANCAKE_ID,
														@PROC_ID,
														@ELECTRODE_TYPE,
														@CELL_BATCH,
														@M_BATCH,
														@JR_CELL_M,
														@PC_CELL_M,
														@LANE_QTY,
														@PC_M_BATCH,
														@APPLY_DATE,
														@B_PROD_VER_CODE,
														@HALF_FLAG,  -- 2022-05-23 E3000E4000 에서 Lane을 나눌 지 구분
														@POST_TYPE;  -- 2022-05-23 E3000E4000 형성 여부
		END;
		CLOSE CUR_CONVERSION_RATE;
		DEALLOCATE CUR_CONVERSION_RATE;    


	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH



	---------------------------------------------------------------------------------------------------------------
	------------------------- BOM 변동간 환산자 갱신 커서구문 추가 [CSR : C20220801-000504]------------------------
	---------------------------------------------------------------------------------------------------------------

	DECLARE CUR_BOM_SYCN CURSOR FOR

		SELECT AA.COMPANY_ID
			  ,AA.DIVISION_ID
			  ,AA.FACTORY_ID
			  ,AA.MODEL_ID
			  ,AA.VERSION
			  ,AA.OPERATION
			  ,AA.ITEM_ID
			  ,(AA.LANE_QTY * CM) AS JR_CELL_M
			  ,CM AS PC_CELL_M
			  ,SIC.VALUE *  CM AS CELL_BATCH
        FROM ( SELECT A.COMPANY_ID
		      ,A.DIVISION_ID
			  ,A.FACTORY_ID
			  ,A.MODEL_ID
			  ,A.VERSION
			  ,A.OPERATION
			  ,A.ITEM_ID
			  ,1 / (DBO.FN_GET_REQ_QTY_MODEL ( '-', A.MODEL_ID, A.ITEM_ID, A.EFF_START_DATE )) AS CM
			  ,A.LANE_NUMBER AS LANE_QTY			

		FROM  ( SELECT ICC.COMPANY_ID, ICC.DIVISION_ID, ICC.FACTORY_ID, ICC.MODEL_ID, ICC.VERSION, ICC.OPERATION, ICC.ITEM_ID, ICC.CATEGORY, MAX(ICC.VALUE) AS LANE_NUMBER, MAX(MCE.EFF_START_DATE) AS EFF_START_DATE
		FROM  [SCM_MODEL_COMP_EFFECTIVE_DATE]    MCE (NOLOCK)
		      INNER JOIN [SCM_ITEM_CONV_CALC_M]  ICC (NOLOCK)
			  ON  MCE.[CHILD_ITEM_ID]  = ICC.ITEM_ID
			  AND MCE.[MODEL_ID]       = ICC.MODEL_ID
		WHERE  MCE.UPDATE_TIME >=  DATEADD(HOUR, -1, GETDATE())  -- 2022-08-24 leeseongmin 1시간전 LIST로 조건설정 
		AND    ICC.FACTORY_ID IN (SELECT F.FACTORY_ID FROM SCM_FACTORY_M F (NOLOCK) WHERE DIVISION_ID IN ('81','82') -- 2021-02-17 kimcd 전체 자동차, ESS로 확대
								  UNION ALL
								  SELECT F.PLANT_ID
								  FROM   SCM_FACTORY_M F (NOLOCK),
								         SCM_PSEUDO_DIVISION_M PD (NOLOCK)
								  WHERE  F.PLANT_ID = PD.PLANT_ID
								  AND    PD.ORIGINAL_DIVISION_ID IN  ('81','82')) -- 2022-03-30 kimcd JV 가상 Division용 Hard Coding 추가
 	    AND   ICC.MAX_VER_FLAG   = 'Y'
	    AND   ICC.CATEGORY       = 'Lane Number'
		GROUP BY ICC.COMPANY_ID, ICC.DIVISION_ID, ICC.FACTORY_ID, ICC.MODEL_ID, ICC.VERSION, ICC.OPERATION, ICC.ITEM_ID, ICC.CATEGORY ) A
		INNER JOIN SCM_ITEM_M SIM (NOLOCK)
		ON  A.COMPANY_ID = SIM.COMPANY_ID
		AND A.DIVISION_ID = SIM.DIVISION_ID
		AND A.ITEM_ID     = SIM.ITEM_ID
		WHERE SIM.ITEM_UOM = 'M'
		) AA
		LEFT JOIN [SCM_ITEM_CONV_CALC_M] SIC (NOLOCK)
		ON  AA.COMPANY_ID  = SIC.COMPANY_ID
        AND AA.DIVISION_ID = SIC.DIVISION_ID
		AND AA.[FACTORY_ID]		= SIC.[FACTORY_ID]
		AND AA.[MODEL_ID]			= SIC.[MODEL_ID]
		AND AA.[VERSION]			= SIC.[VERSION]
		AND AA.[OPERATION]		= SIC.[OPERATION]
		AND AA.[ITEM_ID]			= SIC.[ITEM_ID]
		AND SIC.CATEGORY =  'Pancake (m/batch)'


    
	-- 로그 추가
	
	BEGIN TRY				

	OPEN CUR_BOM_SYCN;
		FETCH NEXT FROM CUR_BOM_SYCN INTO           @COMPANY_ID,
													@DIVISION_ID,
													@AREA_ID,
													@MODEL_CODE,
													@PROD_VER_CODE,
													@PROC_ID,
													@PANCAKE_ID,											  
												    @JR_CELL_M,
												    @PC_CELL_M,
													@CELL_BATCH

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			-- 환산자 갱신
				UPDATE [SCM_ITEM_CONV_CALC_M] 
				    SET 
				            [VALUE] = B.[VALUE] 
						   ,[MMD_VALUE] = B.[VALUE]										
						   ,[UPDATE_ID] = 'PR_XIF_PLM_ITEM_CONV_CALC_R' 
						   ,[UPDATE_TIME] = GETDATE() 
		           FROM [SCM_ITEM_CONV_CALC_M] A,   

		           (SELECT  @COMPANY_ID  AS COMPANY_ID,
							@DIVISION_ID AS DIVISION_ID,							
							@PLANT_ID    AS PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE AS ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'점보롤 cell/m'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@JR_CELL_M AS VALUE
												
					UNION ALL
					SELECT  @COMPANY_ID AS COMPANY_ID,
							@DIVISION_ID AS DIVISION_ID,						
							@PLANT_ID    AS PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE AS ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'펜케잌 cell/m'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@PC_CELL_M AS VALUE	
					
					UNION ALL
					SELECT  @COMPANY_ID AS COMPANY_ID,
							@DIVISION_ID AS DIVISION_ID,						
							@PLANT_ID    AS PLANT_ID,
							@AREA_ID    AS FACTORY_ID,
							@MODEL_CODE AS MODEL_ID,
							@NICK_NAME  AS PJT_CODE,
							@PROD_VER_CODE AS VERSION,
							@PROC_ID    AS OPERATION,
							@PANCAKE_ID AS ITEM_ID,
							@ELECTRODE_TYPE AS ELECTRODE_TYPE,
							(SELECT L.ATTRIBUTE1
							 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK)
							 WHERE  L.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
							 AND    L.SEGMENT1         = N'cell/batch'
							 AND    L.ACTIVE_FLAG      = 'Y') AS CATEGORY,
							@CELL_BATCH AS VALUE	
				
				  ) B
				WHERE 
				      A.[COMPANY_ID]		= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_ID]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[CATEGORY] ;				

			SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT

			FETCH NEXT FROM CUR_BOM_SYCN        INTO    @COMPANY_ID,
													    @DIVISION_ID,
													    @AREA_ID,
													    @MODEL_CODE,
													    @PROD_VER_CODE,
													    @PROC_ID,
													    @PANCAKE_ID,													  
													    @JR_CELL_M,
													    @PC_CELL_M,
														@CELL_BATCH
													   
		END;
 
	CLOSE CUR_BOM_SYCN;
	DEALLOCATE CUR_BOM_SYCN; 		

	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

	
	----------------------------- BOM 변동간 환산자 갱신 커서구문 추가 END [CSR : C20220801-000504] -----------------------------
END

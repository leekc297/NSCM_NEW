
CREATE PROCEDURE [dbo].[PR_XIF_MES_FORM_ROUTE_R]

-- ================================================================================================
-- Program ID          : FP00400
-- Program Name        : PR_XIF_MES_FORM_ROUTE_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : [SCM_MMD_FORM_ROUT]
--                       [SCM_MMD_FORM_ROUT_PROC]
--                       [SCM_MMD_FORM_ROUT_PROC_RECIPE]
--                       [SCM_MMD_OPERATION_M]
-- Destination Table   : SCM_AGING_ITEM_FLOW_M
--
-- Create(Update) Date : 2022.06.24
-- Author              : 김춘동
-- Version             : 1.0 2021-11-08 최초 형성 기존 PR_XIF_FCS_ROUTE_R 기반에서 수정
--                       1.1 2022-05-26 PROC_SEQNO 누락 보완
--                       1.2 2022-06-24 활성화 MES Route에서 공정별로 초 단위 관리하는 경우 초로 작업 시간 계산
--                       1.3 2023-05-31 kimcd A5동 Route 조회 커럼 조건  수정
--                       1.4 2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
--                       1.5 2024-11-20 chkim.68 하드코딩 전환의 인라인코드를 변수로 처리
--                       1.6 2025-02-19 폴란드 Aging L/T 변경
-- ================================================================================================
-- PARAMETER
 @P_SITE_ID  NVARCHAR(50) = NULL
,@P_BASIS_START_TIME  NVARCHAR(6) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_FORM_ROUTE_R'
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
	DECLARE @COMPANY          NVARCHAR(1000)
	DECLARE @DIVISION         NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)
	DECLARE @ITEM_ID          NVARCHAR(1000)
	DECLARE @PLANT_ID         NVARCHAR(1000)
	DECLARE @PROD_VERSION     NVARCHAR(1000)
	DECLARE @EFF_START_DATE   NVARCHAR(1000)
	DECLARE @EFF_END_DATE     NVARCHAR(1000)
	DECLARE @WORK_CENTER_ID   NVARCHAR(1000)
	DECLARE @LINE_CODE        NVARCHAR(1000)
	DECLARE @OPERATION        NVARCHAR(1000)
	DECLARE @PRIORITY         NVARCHAR(1000)
	DECLARE @VALID_YN         NVARCHAR(1000)
	DECLARE @BOM_VERSION      NVARCHAR(1000)
	DECLARE @V_IFSEQNO	      NVARCHAR(1000)

	DECLARE @ROUTE_ID			NVARCHAR(50)	-- 2018-06-19 PIYONG ADD
	DECLARE @LINE_ID			NVARCHAR(50)	-- 2018-06-19 PIYONG ADD
	DECLARE @NEXT_ROUTE_ID		NVARCHAR(150)	-- 2018-06-19 PIYONG ADD
	DECLARE @OPERATION_ID		NVARCHAR(30)	-- 2018-06-19 PIYONG ADD
	DECLARE @OPERATION_SEQ		NUMERIC(20,10)	-- 2018-06-19 PIYONG ADD
	DECLARE @OPERATION_STEP		NUMERIC(20,10)	-- 2018-06-19 PIYONG ADD
	DECLARE @FACTORY_ID         NVARCHAR(50)    -- 2018-12-26 KIMCD ADD
	DECLARE @C_SITE_ID			NVARCHAR(50)	-- 2020-05-04 PIYONG ADD
	DECLARE @C_FACTORY_ID		NVARCHAR(50)	-- 2020-05-04 PIYONG ADD
	DECLARE @C_SOURCE_INDEX		NVARCHAR(50)	-- 2020-05-04 PIYONG ADD

	DECLARE @FCS_ROUTE_EXCEPT_PLANT_ID NVARCHAR(50) = ''
	DECLARE @FCS_ROUTE_PLANT_ID_COND_A TABLE(CODE NVARCHAR(50));
	DECLARE @FCS_ROUTE_PLANT_ID_COND_B TABLE(CODE NVARCHAR(50));
	DECLARE @FCS_ROUTE_PLANT_ID_COND_C TABLE(CODE NVARCHAR(50));

	SELECT @FCS_ROUTE_EXCEPT_PLANT_ID = (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MES_FORM_ROUTE_R' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')

	INSERT INTO @FCS_ROUTE_PLANT_ID_COND_A 
		SELECT SEGMENT2 AS CODE FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MES_FORM_ROUTE_R' AND SEGMENT1  = '14401' AND ACTIVE_FLAG='Y'
	INSERT INTO @FCS_ROUTE_PLANT_ID_COND_B
		SELECT SEGMENT2 AS CODE FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MES_FORM_ROUTE_R' AND SEGMENT1  = '99999' AND ACTIVE_FLAG='Y'
	INSERT INTO @FCS_ROUTE_PLANT_ID_COND_C
		SELECT SEGMENT2 AS CODE FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MES_FORM_ROUTE_R' AND SEGMENT1  = '100000' AND ACTIVE_FLAG='Y'

	
	CREATE TABLE #ROUTE_ID (ROUTID  NVARCHAR(200),
						    AREAID  NVARCHAR(30))
	
	CREATE TABLE #TEMP_ROUTE (
								SITE_ID NVARCHAR(30),
								PLANT_ID NVARCHAR(30),
								BUILDING NVARCHAR(30), 
								MODEL_ID NVARCHAR(150), 
								ROUTE_ID NVARCHAR(30),
								LINE_ID NVARCHAR(30),
								OP_ID NVARCHAR(30),
								OP_SEQ NVARCHAR(30),
								OP_STEP NVARCHAR(30),
								ROUTE_TYPE_CD NVARCHAR(10),
								END_TIME NUMERIC(18,0),
								ROUTE_DESC NVARCHAR(2000),
								OP_NAME NVARCHAR(2000),
								EXTRA_LIMIT_TIME NUMERIC(18,0)
							)

							

	DECLARE CUR CURSOR FOR
		SELECT SITE_ID
			   , FACTORY_ID
		  FROM SCM_FACTORY_M F WITH(NOLOCK)
			   INNER JOIN (
							SELECT SEGMENT1
									,SEGMENT2
								FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
								WHERE LOOKUP_TYPE_CODE = 'FORMATION_MES_FP_FACTORY_MAPPING'
								AND ACTIVE_FLAG = 'Y'
							) S
						ON (
								S.SEGMENT1 = F.PLANT_ID
								AND S.SEGMENT2 = F.FACTORY_ID
							)
		 WHERE SHOP_GROUP_ID ='A'
		   AND ACTIVE_FLAG = 'Y'
		   AND FACTORY_ID  NOT IN ('M4', 'S2')
		   AND SITE_ID     = @P_SITE_ID
		   AND PLANT_ID    IN ( SELECT SEGMENT1
								FROM   SCM_SYS_LOOKUP_VALUE (NOLOCK)
								WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND    SEGMENT2 = @P_BASIS_START_TIME
								)
		 GROUP BY DIVISION_ID
			   , SITE_ID
			   , PLANT_ID
			   , FACTORY_ID
	--2020-06-17 PIYONG ADD
	--------------------------------------------------------------------------------------------------------------------------------------------------------

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		    INSERT INTO  #ROUTE_ID
				(ROUTID
				,AREAID)
			SELECT ROUTID
				  ,AREAID
			FROM   SCM_MMD_FORM_ROUT
			WHERE  ROUTID IN  ( SELECT ROUTID 
								FROM   SCM_MMD_FORM_ROUT
								WHERE  UPDATE_TIME > DATEADD(D,-2,GETDATE())
								UNION ALL
								SELECT ROUTID 
								FROM   SCM_MMD_FORM_ROUT_PROC
								WHERE  UPDATE_TIME > DATEADD(D,-2,GETDATE())
								UNION ALL
								SELECT ROUTID 
								FROM   SCM_MMD_FORM_ROUT_PROC_RECIPE
								WHERE  UPDATE_TIME > DATEADD(D,-2,GETDATE())
								)

		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR;
			FETCH NEXT FROM CUR INTO @C_SITE_ID
								 , @C_FACTORY_ID

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					DELETE FROM #TEMP_ROUTE

					INSERT INTO #TEMP_ROUTE
					SELECT F.SITE_ID,
							F.PLANT_ID ,
							TR.AREAID AS BUILDING ,
							TR.MDLLOT_ID AS MODEL_ID,
							TR.ROUTID AS ROUTE_ID,
							TR.EQSGID AS LINE_ID,
							TRO.PROCID AS OP_ID,  -- 2023-05-31 kimcd TROR에서 TRO 로 수정
							TRO.PROC_SEQNO    AS OP_SEQ,
							ISNULL(TROR.PROC_STEP_NO,1) AS OP_STEP, -- 2023-05-31 kimcd NULL 처리
							TR.ROUT_TYPE_CODE AS ROUTE_TYPE_CD,
							CASE WHEN TRO.ACTIVE_FLAG = 'Y' AND TROR.ACTIVE_FLAG = 'Y' THEN CASE WHEN TMO.END_TIME_UOM = 'SEC' THEN ISNULL (CONVERT(NUMERIC(18,2), TROR.END_TIME), 0.0)/60.0 ELSE ISNULL (TROR.END_TIME, 0) END ELSE 0 END AS END_TIME,
							-- 2022-06-24 kimcd END_TIME_UOM 컬럼 조건 추가 초 변환 로직 추가
							TR.ROUT_NAME AS ROUTE_DESC,
							TMO.OPERATION_NAME AS OP_NAME,
							0 AS EXTRA_LIMIT_TIME	-- 2019-11-11 PIYONG ADD
						FROM #ROUTE_ID R
						    INNER JOIN SCM_MMD_FORM_ROUT TR
							ON R.ROUTID = TR.ROUTID
							AND R.AREAID = TR.AREAID
							INNER JOIN SCM_FACTORY_M F (NOLOCK)
							ON R.AREAID = F.FACTORY_ID
							INNER JOIN SCM_MMD_FORM_ROUT_PROC TRO
									ON TR.ROUTID	= TRO.ROUTID
							LEFT OUTER JOIN SCM_MMD_FORM_ROUT_PROC_RECIPE TROR
										ON TRO.ROUTID	= TROR.ROUTID
										AND TRO.PROCID	= TROR.PROCID
							RIGHT OUTER JOIN SCM_MMD_OPERATION_M TMO
										ON TRO.PROCID	= TMO.OPERATION_ID  -- 2023-05-31 kimcd TROR에서 TRO 로 수정
										AND TMO.OPERATION_TYPE = 'P'
						WHERE TR.ACTIVE_FLAG = 'Y'
						AND   R.AREAID = @C_FACTORY_ID


				--SELECT TOP 1* FROM DBO.SCM_AGING_ITEM_FLOW_M
					MERGE INTO  DBO.SCM_AGING_ITEM_FLOW_M AIF
					USING (SELECT   A.COMPANY_ID     
							,A.DIVISION_ID    
							,A.SITE_ID        
							,A.PLANT         
							,A.BUILDING      
							,B.MODEL_ID
							,A.ROUTE_ID
							,A.LINE_ID 
							,A.OP_ID         
							,A.OP_SEQ        
							,A.OP_STEP       
							,A.ROUTE_TYPE_CD 
							,A.END_TIME      
							,A.ROUTE_DESC    
							,A.OP_NAME
							,DEFAULT_ROUTE
							,DEFAULT_FLAG		--B: BASIC(기본) C:CAPACITY(용량)    
							,CASE --WHEN ISNULL(MP.ATTRIBUTE2, 'C') = 'B' AND END_TIME > 5760 THEN		
								  --	5760
								  --WHEN ISNULL(MP.ATTRIBUTE2, 'C') = 'C' AND END_TIME > 14400 THEN
								  --	14400
								  WHEN A.SITE_ID = 'A004' AND CAST( A.OP_SEQ AS NUMERIC) >= 91 THEN					-- 2019-08-20 piyong ADD 폴란드 특별 조건 추가
									0
								  -- 하드코딩 전환
								  -- WHEN ( END_TIME > 14400 AND A.PLANT NOT IN  ( 'A010', 'G182' )  )			-- 2018-10-31 piyong CHANGE 28800 -> 14400  -- 2019-11-18 PIYONG CHANGE A010 ADD
								  --      OR ( A.PLANT = 'G182' AND ( END_TIME = 99999 OR END_TIME > 28800 ) ) 	-- 2018-11-06 KIMCD G182가 아니고 100일 초과나 G182이고 99999는 0으로 갱신
								  --      OR ( A.PLANT = 'A010' AND ( END_TIME >= 99999 ) )					 	-- 2019-11-18 PIYONG ADD
								   WHEN ( END_TIME > 14400 AND A.PLANT NOT IN  (SELECT CODE FROM  @FCS_ROUTE_PLANT_ID_COND_A) )			-- 2018-10-31 piyong CHANGE 28800 -> 14400  -- 2019-11-18 PIYONG CHANGE A010 ADD
								        OR ( A.PLANT in (SELECT CODE FROM @FCS_ROUTE_PLANT_ID_COND_B) AND ( END_TIME = 99999 OR END_TIME > 28800 ) ) 	-- 2018-11-06 KIMCD G182가 아니고 100일 초과나 G182이고 99999는 0으로 갱신
										OR ( A.PLANT in (SELECT CODE FROM @FCS_ROUTE_PLANT_ID_COND_C) AND ( END_TIME >= 99999 ) )					 	-- 2019-11-18 PIYONG ADD

																												THEN
									0
								  ELSE
									END_TIME
								  END AS STANDARD_LT
							--2018-05-25 PIYONG ADD 끝
							-----------------------------------------------------------------------------
						   ,A.EXTRA_LIMIT_TIME								-- 2019-11-11 PIYONG ADD
					  FROM (
							--2018-05-14 PIYONG UPDATE
							SELECT F.COMPANY_ID
								   ,F.DIVISION_ID
								   ,F.SITE_ID
								   ,A.PLANT_ID AS PLANT		--2018-10-26 PIYONG CHANGE  F.PLANT_ID -> A.PLANT
								   ,A.BUILDING
								   ,A.MODEL_ID -- MDM 에서 모델 연결정보를 받아오면 바꿔야 함.
								   ,A.ROUTE_ID
								   ,A.LINE_ID  -- FCS 라인과 FP의 LINE 연결정보를 가지고 변경해야 함.
								   ,A.OP_ID
								   ,A.OP_SEQ
								   ,A.OP_STEP
								   ,A.ROUTE_TYPE_CD
								   ,A.END_TIME
								   ,A.ROUTE_DESC
								   ,A.OP_NAME
								   ,MP.ATTRIBUTE4 AS DEFAULT_ROUTE
								   ,ISNULL(MP.ATTRIBUTE2, 'C')	AS DEFAULT_FLAG		--B: BASIC(기본) C:CAPACITY(용량)
								   ,A.EXTRA_LIMIT_TIME								-- 2019-11-11 PIYONG ADD
								   ,ROW_NUMBER() OVER (PARTITION BY A.PLANT_ID,
																 [BUILDING],
																 [MODEL_ID],
																 UPPER([ROUTE_ID]),
																 [LINE_ID],
																 [OP_ID],
																 [OP_SEQ],
																 [OP_STEP]
														ORDER BY A.PLANT_ID ASC,
															  [BUILDING] ASC,
															  [MODEL_ID] ASC,
															  UPPER([ROUTE_ID]) ASC,
															  [LINE_ID] ASC,
															  [OP_ID] ASC,
															  [OP_SEQ] ASC,
															  [OP_STEP] ASC,
															  MP.ATTRIBUTE5 DESC,		--2019-05-14 PIYONG ADD
															  [END_TIME] DESC
																					   ) NUM
							  FROM (
									  SELECT AR.[BUILDING] AS BUILDING
											,ISNULL(LM.[LINE_ID], AR.LINE_ID ) AS LINE_ID   -- FCS 라인과 FP의 LINE 연결정보를 가지고 변경해야 함.
											,AR.MODEL_ID
											,AR.ROUTE_ID
											,AR.OP_ID
											,AR.OP_SEQ
											,AR.OP_STEP
											,AR.ROUTE_TYPE_CD
											,AR.END_TIME
											,AR.ROUTE_DESC
											,AR.OP_NAME
											,AR.PLANT_ID AS PLANT_ID	--2018-10-26 PIYONG ADD -- 2019-05-14 PIYONG CHANGE	AR.PLANT_ID -> ISNULL(SSLV1.ATTRIBUTE1,AR.PLANT_ID )
											,AR.EXTRA_LIMIT_TIME								-- 2019-11-11 PIYONG ADD
									   FROM #TEMP_ROUTE AR 
											INNER JOIN (
														SELECT *
														  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														 WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
														   AND ACTIVE_FLAG = 'Y'
													   ) SSLV
													ON AR.LINE_ID  = SSLV.SEGMENT2
												   AND AR.SITE_ID = SSLV.SEGMENT1
												   AND AR.BUILDING = SSLV.ATTRIBUTE1										--2019-10-08 PIYONG ADD
											LEFT OUTER JOIN (
																SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																  FROM SCM_LINE_M
																 WHERE OPERATION_ID IN ( 'F5300','F5500','F5600','F6000')	--2019-05-14 PIYONG ADD 'F5300','F5500','F5600' 
															) LM
														 ON SSLV.SEGMENT5 = LM.LINE_ID
														AND SSLV.SEGMENT1 = LM.SITE_ID
											
								   ) A
							 INNER JOIN [DBO].[SCM_FACTORY_M] F WITH(NOLOCK)
									 ON A.BUILDING = F.FACTORY_ID
							  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
										   ON MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
										  AND SEGMENT1 = A.ROUTE_TYPE_CD
							--2018-05-14 PIYONG UPDATE 끝
							 WHERE F.FACTORY_ID = @C_FACTORY_ID
						   ) A
						   ,(
								SELECT MODEL_ID, 
									   MODEL_LOT_ID,
									   FACTORY_ID			--2018-11-15 PIYONG ADD
								  FROM FP_MODEL_LOT_M with(nolock)
								-- where ACTIVE_FLAG = 'Y'
						   ) B
					 WHERE A.MODEL_ID = B.MODEL_LOT_ID
					   AND A.BUILDING = B.FACTORY_ID	--2018-11-15 PIYONG ADD
					   AND A.NUM = 1) XXX
					ON    ( AIF.[COMPANY_ID] = XXX.COMPANY_ID
							AND AIF.[DIVISION_ID] = XXX.DIVISION_ID
							AND AIF.[SITE_ID] = XXX.SITE_ID
							AND AIF.[PLANT_ID] = XXX.PLANT
							AND AIF.[FACTORY_ID] = XXX.BUILDING
							AND AIF.[ITEM_ID] = XXX.MODEL_ID
							AND AIF.[ROUTE_ID] = XXX.ROUTE_ID
							AND AIF.[LINE_ID] = XXX.LINE_ID
							AND AIF.[OPERATION_ID] = XXX.OP_ID
							AND AIF.[OPERATION_SEQ] = XXX.OP_SEQ
							AND AIF.[OPERATION_STEP] = XXX.OP_STEP )
					WHEN MATCHED THEN
						UPDATE SET   AIF.[ROUTE_TYPE]       = XXX.ROUTE_TYPE_CD 
									,AIF.[PROCESSING_TIME]  = XXX.END_TIME      
									,AIF.[ROUTE_DESCRIPTION] = XXX.ROUTE_DESC    
									,AIF.[OPERATION_NAME]   = XXX.OP_NAME
									,AIF.[DEFAULT_ROUTE]    = XXX.DEFAULT_ROUTE
									,AIF.[DEFAULT_FLAG]     = XXX.DEFAULT_FLAG
									,AIF.[STANDARD_LT]      = XXX.STANDARD_LT
									,AIF.[EXTRA_LIMIT_TIME] = XXX.EXTRA_LIMIT_TIME
									,AIF.[UPDATE_ID]        = @v_proc_name
									,AIF.[UPDATE_TIME]      = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
								 [COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[ITEM_ID]
								,[ROUTE_ID]
								,[LINE_ID]
								,[OPERATION_ID]
								,[OPERATION_SEQ]
								,[OPERATION_STEP]
								,[ROUTE_TYPE]
								,[PROCESSING_TIME]
								,[ROUTE_DESCRIPTION]
								,[OPERATION_NAME]
								,[INSERT_ID]
								,[INSERT_TIME]
							    ,[UPDATE_ID]
								,[UPDATE_TIME]
								,[DEFAULT_ROUTE]
								,[DEFAULT_FLAG]
								,[STANDARD_LT]
								,[EXTRA_LIMIT_TIME]	)
						VALUES ( XXX.COMPANY_ID     
								,XXX.DIVISION_ID    
								,XXX.SITE_ID        
								,XXX.PLANT         
								,XXX.BUILDING      
								,XXX.MODEL_ID
								,XXX.ROUTE_ID
								,XXX.LINE_ID 
								,XXX.OP_ID         
								,XXX.OP_SEQ        
								,XXX.OP_STEP       
								,XXX.ROUTE_TYPE_CD 
								,XXX.END_TIME      
								,XXX.ROUTE_DESC    
								,XXX.OP_NAME
								,@v_proc_name
								,GETDATE()
								,@v_proc_name
								,GETDATE()
								,XXX.DEFAULT_ROUTE
								,XXX.DEFAULT_FLAG
								,XXX.STANDARD_LT
								,XXX.EXTRA_LIMIT_TIME);
     

					SET @ROWCOUNT = @@ROWCOUNT

					--2019-04-22 PIYONG 기준정보에 맞지 않는 정보 삭제
					DELETE AIF
					  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] AIF
						   , SCM_FACTORY_M F
					 WHERE AIF.COMPANY_ID = F.COMPANY_ID    
					   AND AIF.DIVISION_ID  = F.DIVISION_ID   
					   AND AIF.SITE_ID  = F.SITE_ID       
					   AND AIF.PLANT_ID != F.PLANT_ID        
					   AND AIF.FACTORY_ID  = F.FACTORY_ID
					   AND AIF.FACTORY_ID = @C_FACTORY_ID

					-- 2021-11-08 kimcd 비활성화된 Route 삭제
					DELETE AIF
					  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] AIF
						   , SCM_FACTORY_M F WITH(NOLOCK)
						   , #ROUTE_ID R
						   , SCM_MMD_FORM_ROUT  FR
					 WHERE AIF.COMPANY_ID  = F.COMPANY_ID    
					   AND AIF.DIVISION_ID = F.DIVISION_ID   
					   AND AIF.SITE_ID     = F.SITE_ID       
					   AND AIF.PLANT_ID    = F.PLANT_ID        
					   AND AIF.FACTORY_ID  = F.FACTORY_ID
					   AND AIF.ROUTE_ID    = R.ROUTID 
					   AND F.FACTORY_ID    = R.AREAID
					   AND R.ROUTID        = FR.ROUTID
					   AND FR.ACTIVE_FLAG  = 'N'
					   AND R.AREAID        = @C_FACTORY_ID
					   AND AIF.FACTORY_ID  = @C_FACTORY_ID

					-- 2023-05-31 kimcd 비활성화된 Operation SEQ 삭제
					DELETE AIF
					  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] AIF
						   , SCM_FACTORY_M F WITH(NOLOCK)
						   , #ROUTE_ID R
					 WHERE AIF.COMPANY_ID  = F.COMPANY_ID    
					   AND AIF.DIVISION_ID = F.DIVISION_ID   
					   AND AIF.SITE_ID     = F.SITE_ID       
					   AND AIF.PLANT_ID    = F.PLANT_ID        
					   AND AIF.FACTORY_ID  = F.FACTORY_ID
					   AND AIF.ROUTE_ID    = R.ROUTID 
					   AND F.FACTORY_ID    = R.AREAID
					   AND AIF.UPDATE_TIME < CONVERT(DATE, GETDATE())
					   AND R.AREAID        = @C_FACTORY_ID
					   AND AIF.FACTORY_ID  = @C_FACTORY_ID

			-----------------------------------------------------------------------------------------------------------
			-- PIYONG 2018-03-22 용량 ROUTE의 마지막 공정일 경우 PROCESSING_TIME의 값을 0으로 치환 시작
			-----------------------------------------------------------------------------------------------------------
					IF @C_SITE_ID != 'A004'
						BEGIN
							UPDATE A
							   SET --PROCESSING_TIME = 0	--2018-05-25 PIYONG DEL
								   [STANDARD_LT] = 0		--2018-05-25 PIYONG ADD	--2019-07-25 PIYONG CHANGE 폴란드는 1일로 변경 -- 2019-08-08-21 PIYONG CHANGE  CASE WHEN A.SITE_ID = 'A004' THEN 1440 ELSE 0 END -> 0
							  FROM [SCM_AGING_ITEM_FLOW_M] A
								   ,(
										SELECT *
										  FROM (
												SELECT COMPANY_ID
													   , DIVISION_ID
													   , SITE_ID
													   , PLANT_ID
													   , FACTORY_ID
													   , ITEM_ID
													   , ROUTE_ID
													   , LINE_ID
													   , ROUTE_TYPE
													   , OPERATION_ID
													   , OPERATION_SEQ
													   ,ROW_NUMBER() OVER( PARTITION BY PLANT_ID, FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID				--	2018-11-06 KIMCD PARTITION BY에 PLANT_ID 추가
																			   ORDER BY OPERATION_SEQ DESC, OPERATION_STEP DESC			) AS NUM	--	2018-05-25 PIYONG OPERATION_STEP DESC ADD
												  FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
												 WHERE DEFAULT_FLAG = 'C'	-- 용량 ROUTE
												   AND PROCESSING_TIME <> 0	--2018-06-19 PIYONG ADD
												   -- 하드코딩 전환
												   --AND PLANT_ID != 'G182'  -- 2018-11-06 KIMCD G182가 아닌 경우만 마지막 공정 0으로 갱신
												   AND PLANT_ID != @FCS_ROUTE_EXCEPT_PLANT_ID  -- 2018-11-06 KIMCD G182가 아닌 경우만 마지막 공정 0으로 갱신
												   AND FACTORY_ID = @C_FACTORY_ID
											   ) BB
										 WHERE NUM  = 1 
								   ) B
							 WHERE A.COMPANY_ID = B.COMPANY_ID
							   AND A.DIVISION_ID = B.DIVISION_ID
							   AND A.SITE_ID = B.SITE_ID
							   AND A.PLANT_ID = B.PLANT_ID
							   AND A.FACTORY_ID = B.FACTORY_ID
							   AND A.ITEM_ID = B.ITEM_ID
							   AND A.ROUTE_ID = B.ROUTE_ID
							   AND A.LINE_ID = B.LINE_ID
							   AND A.OPERATION_ID = B.OPERATION_ID
							   AND A.OPERATION_SEQ = B.OPERATION_SEQ
   							   AND A.ROUTE_TYPE = B.ROUTE_TYPE
						END
			
					-----------------------------------------------------------------------------------------------------------------------------------------------
					-- 2019-08-20 PIYONG ADD 폴란드 별도
					IF @C_SITE_ID = 'A004'
						BEGIN
							UPDATE A
							   SET [STANDARD_LT] = --CASE WHEN A.DEFAULT_FLAG = 'C' THEN
															0								-- 2019-10-07 PIYONG CHANGE 2160 -> 0
														--ELSE
														--	1440
														--END
							  FROM [SCM_AGING_ITEM_FLOW_M] A
								   ,(
									  SELECT *
										FROM (
											  SELECT COMPANY_ID
													 , DIVISION_ID
													 , SITE_ID
													 , PLANT_ID
													 , FACTORY_ID
													 , ITEM_ID
													 , ROUTE_ID
													 , LINE_ID
													 , ROUTE_TYPE
													 , OPERATION_ID
													 , OPERATION_SEQ
													 , DEFAULT_FLAG
													 , ROW_NUMBER() OVER( PARTITION BY DEFAULT_FLAG, PLANT_ID, FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID
																			  ORDER BY OPERATION_SEQ DESC, OPERATION_STEP DESC							) AS NUM
												FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
											   WHERE SITE_ID = 'A004'--@P_SITE_ID
												 AND PROCESSING_TIME <> 0
												 AND OPERATION_SEQ < 91
											 ) BB
									   WHERE NUM  = 1 
								   ) B
							 WHERE A.COMPANY_ID = B.COMPANY_ID
							   AND A.DIVISION_ID = B.DIVISION_ID
							   AND A.SITE_ID = B.SITE_ID
							   AND A.PLANT_ID = B.PLANT_ID
							   AND A.FACTORY_ID = B.FACTORY_ID
							   AND A.ITEM_ID = B.ITEM_ID
							   AND A.ROUTE_ID = B.ROUTE_ID
							   AND A.LINE_ID = B.LINE_ID
							   AND A.OPERATION_ID = B.OPERATION_ID
							   AND A.OPERATION_SEQ = B.OPERATION_SEQ
   							   AND A.ROUTE_TYPE = B.ROUTE_TYPE
							   AND A.DEFAULT_FLAG = B.DEFAULT_FLAG
						END
					-- 2019-08-20 PIYONG ADD 폴란드 별도
					-----------------------------------------------------------------------------------------------------------------------------------------------

			-----------------------------------------------------------------------------------------------------------
			-- PIYONG 2018-03-22 용량 ROUTE의 마지막 공정일 경우 PROCESSING_TIME의 값을 0으로 치환 끝
			-----------------------------------------------------------------------------------------------------------


				--	PIYONG 2017-11-30 복사한 DEFAULT_ROUTE, STANDARD_LT 데이터로 수정 끝  
				-----------------------------------------------------------------------------------------------------------
/*
				select factory_id, item_id, ROUTE_ID, line_id, route_type,OPERATION_ID, OPERATION_SEQ, PROCESSING_TIME total_time --  sum(PROCESSING_TIME) total_time
					into #tempRoute 
					from (
						select factory_id, item_id, ROUTE_ID, line_id, OPERATION_ID, OPERATION_SEQ, PROCESSING_TIME, ROUTE_TYPE
								,ROW_NUMBER() over ( partition by item_id, ROUTE_ID, line_id   order by OPERATION_SEQ desc ) last_op
							from [dbo].[SCM_AGING_ITEM_FLOW_M] WITH(NOLOCK)
						) w
				where ( ( last_op = 1 and  PROCESSING_TIME < 900000) or last_op <> 1 )
				;

			--	2018.03.08 PIYONG	DEFAULT_FLAG  Y,N -> S, F	--	2018-05-25 주석처리
			SELECT FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID, ROUTE_TYPE, OPERATION_ID, OPERATION_SEQ, DEFAULT_ROUTE --2018-03-22 PIYONG  DEFAULT_ROUTE ADD
				   ,CASE WHEN DEFAULT_FLAG = 'B' AND PROCESSING_TIME > 5760 THEN
							5760
						 WHEN DEFAULT_FLAG = 'C' AND PROCESSING_TIME > 14400 THEN
							14400
						 ELSE
							PROCESSING_TIME
						 END AS total_time
			 INTO #tempRoute
			 FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
*/
			--select * into [dbo].[SCM_AGING_ITEM_FLOW_M_BK] from [dbo].[SCM_AGING_ITEM_FLOW_M]
					UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
					   SET NEXT_ROUTE_ID = B.NEXT_ROUTE_ID
					  --   ,ROUTE_TOTAL_TIME = B.NEXT_STEP_TIME		--2019-04-08 PIYONG DEL
					  FROM [DBO].[SCM_AGING_ITEM_FLOW_M] AS A WITH (NOLOCK)
						   INNER JOIN (
										SELECT FACTORY_ID
												,X.ITEM_ID
												,X.ROUTE_ID
												,X.LINE_ID
												,X.ROUTE_TYPE
												,CASE WHEN x.ROUTE_TYPE IN (SELECT SEGMENT1		--2018-05-25 PIYONG look up으로 변경
																			  FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																			 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																			   AND ATTRIBUTE2 = 'B') THEN (
																											SELECT TOP 1 [ROUTE_ID]					--2018-03-22 PIYONG MAX([ROUTE_ID]) -> TOP 1 [ROUTE_ID]
																												FROM [SCM_AGING_ITEM_FLOW_M] w		--2018-05-25 PIYONG tempRoute -> [SCM_AGING_ITEM_FLOW_M] 변경
																												WHERE w.ITEM_ID    = x.ITEM_ID
																												AND w.LINE_ID    = x.line_id
																												AND w.FACTORY_ID = x.FACTORY_ID
																												AND w.ROUTE_ID   <> x.ROUTE_ID
																												AND w.ROUTE_TYPE  = 'C'
																												ORDER BY DEFAULT_ROUTE  DESC, ROUTE_ID DESC --2018-03-22 PIYONG  ORDER BY ADD
																											)
													  ELSE NULL END NEXT_ROUTE_ID
											/*	--2019-04-08 PIYONG DEL
											,CASE WHEN X.ROUTE_TYPE IN (SELECT SEGMENT1		--2018-05-25 PIYONG LOOK UP으로 변경
																		  FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																		   AND ATTRIBUTE2 = 'B') THEN (
																										SELECT SUM(W.STANDARD_LT)				--2018-05-25 PIYONG TOTAL_TIME -> STANDARD_LT으로 변경
																										  FROM [SCM_AGING_ITEM_FLOW_M] W		--2018-05-25 PIYONG TEMPROUTE -> [SCM_AGING_ITEM_FLOW_M] 으로 변경
																										 WHERE W.ITEM_ID    = X.ITEM_ID
																										   AND W.LINE_ID    = X.LINE_ID
																										   AND W.FACTORY_ID = X.FACTORY_ID
																										   AND W.ROUTE_ID   <> X.ROUTE_ID
																										   AND W.ROUTE_TYPE  = 'C'
																										-- 2018-03-22 KIMCD 복수 ROUTE의 LEAD TIME 합산되는 것을 막기 위해 ROUTE_ID 조건 추가 시작
																										   AND W.ROUTE_ID =  ( SELECT TOP 1 [ROUTE_ID]				--2018-03-22 PIYONG MAX([ROUTE_ID]) -> TOP 1 [ROUTE_ID]
																																	FROM [SCM_AGING_ITEM_FLOW_M] Y		--2018-05-25 PIYONG TEMPROUTE -> [SCM_AGING_ITEM_FLOW_M] 변경
																																WHERE Y.ITEM_ID    = X.ITEM_ID
																																	AND Y.LINE_ID    = X.LINE_ID
																																	AND Y.FACTORY_ID = X.FACTORY_ID
																																	AND Y.ROUTE_ID   <> X.ROUTE_ID
																																	AND Y.ROUTE_TYPE  = 'C'
																																ORDER BY DEFAULT_ROUTE  DESC, ROUTE_ID DESC --2018-03-22 PIYONG  ORDER BY ADD
																																)
																										-- 2018-03-22 KIMCD 복수 ROUTE의 LEAD TIME 합산되는 것을 막기 위해 ROUTE_ID 조건 추가 종료
																										)
													ELSE NULL END NEXT_STEP_TIME
											*/
										  FROM [SCM_AGING_ITEM_FLOW_M] X WITH (NOLOCK)		--2018-05-25 PIYONG TEMPROUTE -> [SCM_AGING_ITEM_FLOW_M] 변경
										 WHERE FACTORY_ID = @C_FACTORY_ID
										 AND	x.ROUTE_TYPE IN (SELECT SEGMENT1		--2018-05-25 PIYONG look up으로 변경
																 FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																 AND ATTRIBUTE2 = 'B')  -- 2020-07-09 kimcd 미리 갱신될 대상만 추출
										 GROUP BY FACTORY_ID
											   ,X.ITEM_ID
											   ,X.ROUTE_ID
											   ,X.LINE_ID
											   ,X.ROUTE_TYPE
									  ) AS B 
								   ON A.ROUTE_ID = B.ROUTE_ID
								  AND A.ITEM_ID = B.ITEM_ID
								  AND A.LINE_ID = B.LINE_ID
								  AND A.FACTORY_ID = B.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
					;


					-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2019-04-08 PIYONG  속도개선을 위한 분리
					UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
					   SET ROUTE_TOTAL_TIME = B.NEXT_STEP_TIME
					  FROM [DBO].[SCM_AGING_ITEM_FLOW_M] AS A WITH (NOLOCK)
						   INNER JOIN (
										SELECT FACTORY_ID
												,X.ITEM_ID
												,X.ROUTE_ID
												,X.LINE_ID
												,X.ROUTE_TYPE
												,CASE WHEN X.ROUTE_TYPE IN (
																			SELECT SEGMENT1
																			  FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																			 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																			   AND ATTRIBUTE2 = 'B') THEN (
																											SELECT SUM(W.STANDARD_LT)
																											  FROM [SCM_AGING_ITEM_FLOW_M] W
																											 WHERE W.ITEM_ID    = X.ITEM_ID
																											   AND W.LINE_ID    = X.LINE_ID
																											   AND W.FACTORY_ID = X.FACTORY_ID
																											   AND W.ROUTE_ID   <> X.ROUTE_ID
																											   AND W.ROUTE_TYPE  = 'C'
																											   AND W.ROUTE_ID = MAX(X.NEXT_ROUTE_ID)  -- 2020-07-09 kimcd 미리 찾아 놓은 next route id 사용
																											                    /* (
																																   SELECT TOP 1 [ROUTE_ID]
																																	 FROM [SCM_AGING_ITEM_FLOW_M] Y
																																	WHERE Y.ITEM_ID    = X.ITEM_ID
																																	  AND Y.LINE_ID    = X.LINE_ID
																																	  AND Y.FACTORY_ID = X.FACTORY_ID
																																	  AND Y.ROUTE_ID   <> X.ROUTE_ID
																																	  AND Y.ROUTE_TYPE  = 'C'
																																	ORDER BY DEFAULT_ROUTE  DESC, ROUTE_ID DESC
																																	
																																) */
																											)
													  ELSE NULL END NEXT_STEP_TIME
										  FROM [SCM_AGING_ITEM_FLOW_M] X WITH (NOLOCK)
										 WHERE FACTORY_ID =	@C_FACTORY_ID
										   AND X.NEXT_ROUTE_ID IS NOT NULL -- 2020-07-09 kimcd 갱신할 다음 Route가 존재하는 경우만 갱신
										 GROUP BY FACTORY_ID
											   ,X.ITEM_ID
											   ,X.ROUTE_ID
											   ,X.LINE_ID
											   ,X.ROUTE_TYPE
									  ) AS B 
								   ON A.ROUTE_ID = B.ROUTE_ID
								  AND A.ITEM_ID = B.ITEM_ID
								  AND A.LINE_ID = B.LINE_ID
								  AND A.FACTORY_ID = B.FACTORY_ID
					;
					--2019-04-08 PIYONG  속도개선을 위한 분리
					-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
					


					----------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-08-13 PIYONG ADD
					UPDATE X
					   SET REMAIN_TIME = ( SELECT SUM([STANDARD_LT]) 
											 FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
											WHERE A.SITE_ID = X.SITE_ID
											  AND A.ITEM_ID = X.ITEM_ID
											  AND A.LINE_ID = X.LINE_ID
											  AND A.FACTORY_ID = X.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
											  AND A.ROUTE_ID = X.ROUTE_ID
											  AND (
													( OPERATION_SEQ = X.OPERATION_SEQ  AND OPERATION_STEP >= X.OPERATION_STEP )
													OR ( OPERATION_SEQ > X.OPERATION_SEQ )
												  )
											GROUP BY A.ITEM_ID
													,A.ROUTE_ID
													,A.LINE_ID 
											) 
					  FROM [DBO].[SCM_AGING_ITEM_FLOW_M] AS X WITH (NOLOCK)
					 WHERE FACTORY_ID = @C_FACTORY_ID
					;
			--2018-08-13 PIYONG ADD
			----------------------------------------------------------------------------------------------------------------------------------------------------


			--2018-06-19 PIYONG ADD ----------------------------------------------------------------------------------------------------------------------------
			--N2.1 OCV2까지 총 L/T
					DECLARE CUR_OCV2_B CURSOR FOR
						SELECT A.SITE_ID, A.ITEM_ID, A.ROUTE_ID, A.NEXT_ROUTE_ID, A.LINE_ID, A.OPERATION_ID, A.OPERATION_SEQ, A.OPERATION_STEP, A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
						  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
						 WHERE A.FACTORY_ID = @C_FACTORY_ID
						   AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_FCS_SHIPPING_TERM_M )
						   AND A.DEFAULT_FLAG = 'B'
						 ORDER BY A.ROUTE_ID, A.ITEM_ID,  A.NEXT_ROUTE_ID, A.LINE_ID, A.OPERATION_SEQ, A.OPERATION_STEP

					DECLARE CUR_OCV2_C CURSOR FOR
						SELECT A.SITE_ID, A.ITEM_ID, A.ROUTE_ID, A.LINE_ID, A.OPERATION_ID, A.OPERATION_SEQ, A.OPERATION_STEP, A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
						  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
						 WHERE A.FACTORY_ID = @C_FACTORY_ID
						   AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_FCS_SHIPPING_TERM_M )
						   AND A.DEFAULT_FLAG = 'C'
						   AND A.OPERATION_SEQ <= (
													SELECT OPERATION_SEQ
													  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] C
													 WHERE C.ROUTE_ID = A.ROUTE_ID
													   AND C.ITEm_ID = A.ITEM_ID
													   AND C.DEFAULT_FLAG = 'C'
												       AND C.OPERATION_ID = N'812'			--2018-09-27 PIYONG ADD
							   						   AND C.OPERATION_SEQ > 0				--2018-09-27 PIYONG ADD
													--   AND C.OPERATION_NAME = N'OCV #02'	--2018-09-27 PIYONG DEL
													   AND C.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
												  )
						ORDER BY A.ROUTE_ID, A.ITEM_ID, A.LINE_ID, A.OPERATION_SEQ, A.OPERATION_STEP


					OPEN CUR_OCV2_B;
					FETCH NEXT FROM CUR_OCV2_B INTO @SITE_ID
													,@ITEM_ID
													,@ROUTE_ID
													,@NEXT_ROUTE_ID
													,@LINE_ID
													,@OPERATION_ID
													,@OPERATION_SEQ
													,@OPERATION_STEP
													,@FACTORY_ID  -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
					--기본 ROUTE
							UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
							   SET OCV2_TOTAL_TIME = (
													  SELECT SUM([STANDARD_LT]) +
															 (
															  SELECT SUM([STANDARD_LT]) 
																FROM [dbo].[SCM_AGING_ITEM_FLOW_M] B
															   WHERE B.ROUTE_ID = A.NEXT_ROUTE_ID
																 AND B.ITEM_ID = A.ITEM_ID
																 AND B.LINE_ID = A.LINE_ID
																 AND B.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
																 AND B.DEFAULT_FLAG = 'C'
																 AND B.OPERATION_SEQ <= (
																						 SELECT OPERATION_SEQ
																						   FROM [dbo].[SCM_AGING_ITEM_FLOW_M] C
																						  WHERE C.ROUTE_ID = A.NEXT_ROUTE_ID
																							AND C.ITEM_ID = A.ITEM_ID
																							AND C.LINE_ID = A.LINE_ID
																							AND C.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
																							AND C.DEFAULT_FLAG = 'C'
																							AND C.OPERATION_ID = N'812'			--2018-09-27 PIYONG ADD
																						    AND C.OPERATION_SEQ > 0				--2018-09-27 PIYONG ADD
																						--  AND C.OPERATION_NAME = N'OCV #02'	--2018-09-27 PIYONG DEL
																						)
															 ) + (SELECT ATTRIBUTE1 * 24 * 60
																	FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
																   WHERE LOOKUP_TYPE_CODE  = 'FORMATION_SHIP_EOH_EXCEPT'
																	 AND SEGMENT2 = 'AGING'
																	 AND SEGMENT4 = @ITEM_ID )
														FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
													   WHERE A.SITE_ID = @SITE_ID
														 AND A.ITEM_ID = @ITEM_ID
														 AND A.LINE_ID = @LINE_ID
														 AND A.DEFAULT_FLAG = 'B'
														 AND ROUTE_ID = @ROUTE_ID
														 AND A.FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
														 AND (
																( OPERATION_SEQ = @OPERATION_SEQ  AND OPERATION_STEP >= @OPERATION_STEP )
																OR ( OPERATION_SEQ > @OPERATION_SEQ )
															 )
													   GROUP BY A.ITEM_ID
															 , A.ROUTE_ID
															 , A.NEXT_ROUTE_ID
															 , A.LINE_ID
															 , A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
													 )
								WHERE ROUTE_ID = @ROUTE_ID
								   AND NEXT_ROUTE_ID = @NEXT_ROUTE_ID
								   AND OPERATION_ID = @OPERATION_ID
								   AND OPERATION_SEQ = @OPERATION_SEQ
								   AND OPERATION_STEP = @OPERATION_STEP
								   AND LINE_ID = @LINE_ID
								   AND ITEM_ID = @ITEM_ID
								   AND FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

							FETCH NEXT FROM CUR_OCV2_B INTO @SITE_ID
															,@ITEM_ID
															,@ROUTE_ID
															,@NEXT_ROUTE_ID
															,@LINE_ID
															,@OPERATION_ID
															,@OPERATION_SEQ
															,@OPERATION_STEP
															,@FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

						  END;

					CLOSE CUR_OCV2_B;
					DEALLOCATE CUR_OCV2_B; 


					--용량 ROUTE
					OPEN CUR_OCV2_C;
					FETCH NEXT FROM CUR_OCV2_C INTO @SITE_ID
													,@ITEM_ID
													,@ROUTE_ID
													,@LINE_ID
													,@OPERATION_ID
													,@OPERATION_SEQ
													,@OPERATION_STEP
													,@FACTORY_ID  -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

					WHILE (@@FETCH_STATUS = 0)
						BEGIN

							UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
							   SET OCV2_TOTAL_TIME = (
													  SELECT SUM([STANDARD_LT]) + (
																				   SELECT ATTRIBUTE1 * 24 * 60
																					 FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
																					WHERE LOOKUP_TYPE_CODE  = 'FORMATION_SHIP_EOH_EXCEPT'
																					  AND SEGMENT2 = 'AGING'
																					  AND SEGMENT4 = @ITEM_ID
																				  )
														FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
													   WHERE A.SITE_ID = @SITE_ID
														 AND A.ITEM_ID = @ITEM_ID
														 AND A.LINE_ID = @LINE_ID
														 AND A.DEFAULT_FLAG = 'C'
														 AND ROUTE_ID = @ROUTE_ID
														 AND A.FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
														 AND (
																( OPERATION_SEQ = @OPERATION_SEQ  AND OPERATION_STEP >= @OPERATION_STEP )
																OR ( OPERATION_SEQ > @OPERATION_SEQ )
															 )
														 AND OPERATION_SEQ <= (
																				SELECT OPERATION_SEQ
																				  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] C
																				 WHERE C.ROUTE_ID = A.ROUTE_ID
																				   AND C.ITEm_ID = A.ITEM_ID
																				   AND C.LINE_ID = A.LINE_ID
																				   AND C.DEFAULT_FLAG = 'C'
																				   AND C.OPERATION_ID = N'812'			--2018-09-27 PIYONG ADD
														   						   AND C.OPERATION_SEQ > 0				--2018-09-27 PIYONG ADD
																				-- AND C.OPERATION_NAME = N'OCV #02'	--2018-09-27 PIYONG DEL
																				   AND C.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
																			  )
													   GROUP BY A.ITEM_ID
															 , A.ROUTE_ID
															 , A.LINE_ID
													 )
								WHERE ROUTE_ID = @ROUTE_ID
								  AND OPERATION_ID = @OPERATION_ID
								  AND OPERATION_SEQ = @OPERATION_SEQ
								  AND OPERATION_STEP = @OPERATION_STEP
								  AND LINE_ID = @LINE_ID
								  AND ITEM_ID = @ITEM_ID
								  AND FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

							FETCH NEXT FROM CUR_OCV2_C INTO @SITE_ID
															,@ITEM_ID
															,@ROUTE_ID
															,@LINE_ID
															,@OPERATION_ID
															,@OPERATION_SEQ
															,@OPERATION_STEP
															,@FACTORY_ID  -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

						  END;

					CLOSE CUR_OCV2_C;
					DEALLOCATE CUR_OCV2_C; 

			--2018-06-19 PIYONG ADD ----------------------------------------------------------------------------------------------------------------------------
					FETCH NEXT FROM CUR INTO @C_SITE_ID
											 , @C_FACTORY_ID
					;

				END;

			CLOSE CUR;
			DEALLOCATE CUR;  
--			END;
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
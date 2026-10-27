
create PROCEDURE [dbo].[PR_XIF_MES_RT_RESULT_EXCEPT_R_20231020]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_RT_RESULT_EXCEPT_R
-- Param               :
-- Batch Period        : 30 MINUTE
-- Description         : MES WO 삭제 및 PEGGING 누락 처리
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_RT_RESULT_EXCEPT_R
-- Destination Table   : 
--
-- Create Date		   : 2017.10.16
-- Update Date		   : 2017.11.09 PIYONG 1.1
--						 2018.03.07 PIYONG 1.2
--						 2018.05.23 KIMCD 1.3
--                       2018.12.18 KIMCD 1.4
--                       2020.07.27 kimcd 1.41

-- Author              : PIYONG
-- Version             : 1.0
--					   : 1.1 PLAN_ID 설정값 변경 FP_PLAN_ID + '_00X'     ->  'RESULT_EXP_'+replace(replace( replace( convert(varchar, getdate(),120), ' ',''),':',''),'-','') + '-XX'
--						 1.2  MES 전송시 ATTR_12에 TOP_ITEM_ID 추가
--                       1.3 kimcd 2018-05-23 전송에서 WO별로 중복 제거되도록 로직 보완
--                       1.4 2018-12-18 kimcd mes work order master에 수량 1로 갱신
--                       1.41 2020-07-27 kimcd mixer 공정의 ATTR_01(Total Batch), ATTR_03(Total Batch Kg) 전송 정보 제거
--                       1.5. 2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                                       동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                                       라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--                       1.6 2022-11-24 kimcd 전극 생산 버전별 계획 수립에 따른 전송 정보 추가
--                       1.7 2023-11-01 FP Pjt. 스마트 팩토리 핵심 IT 품질 시스템 구축_FP영역 / PDS 전송 추가
-- ================================================================================================

-- PARAMETER

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_RT_RESULT_EXCEPT_R'
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

	DECLARE @CHECK_CODE   NVARCHAR(50)
	DECLARE @MIX_CHK	  NVARCHAR(50) = ''
	DECLARE @WO		      NVARCHAR(50)
	DECLARE @WO2	      NVARCHAR(50)
	DECLARE @TOP_WO	      NVARCHAR(50)
	DECLARE @BACK_WO      NVARCHAR(50)
	DECLARE @IF_SEQ		  NVARCHAR(50)

	DECLARE @PLAN_ID	  NVARCHAR(50)
		
	DECLARE @seq_next	  BIGINT
	DECLARE @chk_WO		  INTEGER	  = 0
	DECLARE @chk_WO2	  INTEGER	  = 0

	DECLARE @XIF_MES_WO_S TABLE(
		[IF_SEQ]			[nvarchar](50) NOT NULL,
		[IF_TYPE]			[nvarchar](1) NOT NULL,
		[IF_ID]				[nvarchar](50) NOT NULL,
		[IF_INS_DATE]		[datetime] NULL,
		[IF_FLAG]			[nvarchar](1) NOT NULL,
		[IF_SND_DATE]		[datetime] NULL,
		[RSLT_IF_SEQ]		[bigint] NULL,
		[RSLT_PROC_FLAG]	[nvarchar](1) NULL,
		[RSLT_PROC_MSG]		[nvarchar](1000) NULL,
		[PLAN_ID]			[nvarchar](50) NULL,
		[PLANT_ID]			[nvarchar](50) NULL,
		[BUILNO]			[nvarchar](50) NULL,
		[LINE_ID]			[nvarchar](50) NULL,
		[OPERATION_ID]		[nvarchar](50) NULL,
		[EQUIPMENT_ID]		[nvarchar](50) NULL,
		[ITEM_ID]			[nvarchar](50) NULL,
		[DEMAND_ID]			[nvarchar](150) NULL,
		[WO]				[nvarchar](50) NULL,
		[WO_TYPE]			[nvarchar](50) NULL,
		[WO_DETAIL]			[nvarchar](50) NULL,
		[PLAN_DATE]			[nvarchar](50) NULL,
		[START_TIME]		[nvarchar](50) NULL,
		[END_TIME]			[nvarchar](50) NULL,
		[IN_QTY]			[nvarchar](50) NULL,
		[OUT_QTY]			[nvarchar](50) NULL,
		[IS_RELEASE]		[nvarchar](50) NULL,
		[CREATE_PSN_ID]		[nvarchar](50) NULL,
		[CREATE_DATE]		[datetime] NULL,
		[UPDATE_PSN_ID]		[nvarchar](50) NULL,
		[UPDATE_DATE]		[datetime] NULL,
		[LANE_QTY]			[nvarchar](50) NULL,
		[UNIT]				[nvarchar](50) NULL,
		[ORDER_TYPE]		[nvarchar](50) NULL,
		[BATCH_ORDER_ID]	[nvarchar](30) NULL,
		[SLITTER_PLANT]		[nvarchar](30) NULL,
		[MARKET]			[nvarchar](1) NULL,
		[ATTR_01]			[nvarchar](50) NULL,
		[ATTR_02]			[nvarchar](50) NULL,
		[ATTR_03]			[nvarchar](50) NULL,
		[ATTR_04]			[nvarchar](50) NULL,
		[ATTR_05]			[nvarchar](50) NULL,
		[ATTR_06]			[nvarchar](50) NULL,
		[ATTR_07]			[nvarchar](50) NULL,
		[ATTR_08]			[nvarchar](50) NULL,
		[ATTR_09]			[nvarchar](50) NULL,
		[ATTR_10]			[nvarchar](50) NULL,
		[ATTR_11]			[nvarchar](50) NULL,
		[ATTR_12]			[nvarchar](50) NULL,
		[ATTR_13]			[nvarchar](50) NULL,
		[ATTR_14]			[nvarchar](50) NULL,
		[ATTR_15]			[nvarchar](50) NULL,
		[ATTR_16]			[nvarchar](50) NULL,
		[ATTR_17]			[nvarchar](50) NULL,
		[ATTR_18]			[nvarchar](50) NULL,
		[ATTR_19]			[nvarchar](50) NULL,
		[ATTR_20]			[nvarchar](50) NULL,
		[ATTR_21]			[nvarchar](1000) NULL,
		[ATTR_22]			[nvarchar](1000) NULL,
		[ATTR_23]			[nvarchar](1000) NULL,
		[ATTR_24]			[nvarchar](1000) NULL,
		[ATTR_25]			[nvarchar](1000) NULL,
		[ATTR_26]			[nvarchar](1000) NULL,
		[ATTR_27]			[nvarchar](1000) NULL,
		[ATTR_28]			[nvarchar](1000) NULL,
		[ATTR_29]			[nvarchar](1000) NULL,
		[ATTR_30]			[nvarchar](1000) NULL
		) 

	DECLARE CUR_IF_MES_RESULT_EXCEPT CURSOR FOR
        --2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : PLANT ID 기준으로 SITE ID 찾는것으로 변경
        --SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID
        SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE Z.PLANT_ID = MAX(C.PLANT_ID) ) SITE_ID
          FROM [SY_XIF_MES_RT_RESULT_EXCEPT_R] C
         WHERE 1=1
           AND PROC_FLAG = 'N'
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
			OPEN CUR_IF_MES_RESULT_EXCEPT;
			FETCH NEXT FROM CUR_IF_MES_RESULT_EXCEPT INTO @IF_ID        
													      ,@ACCUM_DATE
		                                                  ,@SITE_ID


			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					UPDATE [dbo].[SY_XIF_MES_RT_RESULT_EXCEPT_R]
					   SET PROC_FLAG = 'P'
					 WHERE ISNULL(PROC_FLAG, 'N') = 'N'
					   AND CHECK_CODE NOT IN ( 'A003', 'A005' )						--NO TOP BACK WO, No Pegging Info (ERP I/F ERROR)는 제외
					   AND IF_ID = @IF_ID
					   AND ACCUM_DATE =  @ACCUM_DATE
					;

					DECLARE CUR_RESULT CURSOR FOR
						SELECT CHECK_CODE
							   ,WO
							   ,WO2
							   ,IF_SEQ
						FROM   ( SELECT CHECK_CODE
									   ,WO
									   ,WO2
									   ,IF_SEQ
									   ,ROW_NUMBER() OVER( PARTITION BY WO, WO2 ORDER BY IF_SEQ DESC) ROWNUMS -- 2018-05-23 kimcd W/O명이 한번에 2개 이상 전송되는 것 방지 위해 조건 추가
								  FROM [dbo].[SY_XIF_MES_RT_RESULT_EXCEPT_R]
								 WHERE 1=1
								   AND PROC_FLAG = 'P'
								   AND IF_ID = @IF_ID
								   AND ACCUM_DATE =  @ACCUM_DATE ) A
						WHERE ROWNUMS = 1 -- 2018-05-23 kimcd W/O명이 한번에 2개 이상 전송되는 것 방지 위해 조건 추가
						;

					OPEN CUR_RESULT;
					FETCH NEXT FROM CUR_RESULT INTO @CHECK_CODE
												    ,@WO
												    ,@WO2
													,@IF_SEQ

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
							-- 초기화
							SET @chk_WO = 0;
							SET @chk_WO2 = 0;

							SET @MIX_CHK = (SELECT SEGMENT1
											  FROM DBO.SCM_SYS_LOOKUP_VALUE S
											 WHERE LOOKUP_TYPE_CODE = 'FP_OPERATION'
											   AND ATTRIBUTE6 = 'Y'
											   AND EXISTS (
														   SELECT 1
															 FROM (
																	SELECT TOP 1 OPERATION_ID
																	  FROM SY_XIF_MES_WO_S
																	 WHERE WO = @WO
																	   AND IF_ID != 'OFP0_OPLM_FP_WO'
																	 ORDER BY IF_SEQ DESC
																  ) A
															WHERE SEGMENT1 = OPERATION_ID
														  )
											)

							-- WO 존재 확인
							SET @chk_WO = CASE WHEN @MIX_CHK IS NULL THEN
													( SELECT COUNT(*) FROM SY_XIF_MES_WO_S WHERE WO = @WO )	-- MIX가 아닐 경우

											   ELSE
													( SELECT COUNT(*) FROM SY_XIF_ERP_PRODUCTION_PLAN_S WHERE WORK_ORDER_ID = @WO )

											   END

							--같은 @ACCUM_DATE에 TOP/BACK 동시에 존재 하면 BACK은 전송하지 않는다
							IF (SELECT TOP 1 ATTR_05			--현재의 @WO에 연결된 WO의 TOP/BACK 확인
							      FROM SY_XIF_MES_WO_S
							     WHERE IF_ID != 'OFP0_OPLM_FP_WO'
							       AND WO = (
										     SELECT TOP 1 WO	--현재의 @WO에 연결된 WO가 같은 @ACCUM_DATE에 존재함
										       FROM [dbo].[SY_XIF_MES_RT_RESULT_EXCEPT_R]
										      WHERE 1=1
										        AND PROC_FLAG = 'P'
										        AND IF_ID = @IF_ID
										        AND ACCUM_DATE =  @ACCUM_DATE
										        AND WO = (
													       SELECT TOP 1 ATTR_06			
														     FROM SY_XIF_MES_WO_S
														    WHERE WO = @WO
														      AND IF_ID != 'OFP0_OPLM_FP_WO'
													      )
										    ) 
								) = 'T' AND @CHECK_CODE IN ( 'A001', 'A002')   --현재의 @WO가 BACK
								BEGIN
									--메시지 구분을 하기 위한 값 0보다 작아야함, -1에 의미는 없음
									SET @chk_WO = -1;
								END

							IF @CHECK_CODE = 'A004'				-- PEGGING 누락일 경우 하위 WO 존재 확인
								BEGIN
									SET @chk_WO2 = (
													SELECT COUNT(*)
													  FROM SY_XIF_MES_WO_S
													 WHERE WO = @WO2
													   AND IF_ID != 'OFP0_OPLM_FP_WO'
												   )
								END

							--WO가 존재 할때만 실행
							IF ( @chk_WO > 0 AND @CHECK_CODE IN ( 'A001', 'A002') ) OR ( @chk_WO > 0 AND @chk_WO2 > 0 AND @CHECK_CODE = 'A004' )
								BEGIN

									SET @seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]

									IF @CHECK_CODE IN ( 'A001', 'A002')
										BEGIN
											-- TOP /BACK 확인
											IF (SELECT SOURCES.ATTR_05
												  FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
													   ,(SELECT WO
															    ,IF_SEQ
																,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
														   FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
														  WHERE WO = @WO
														    AND IF_ID != 'OFP0_OPLM_FP_WO'
														 ) XX
												 WHERE SOURCES.WO = XX.WO
												   AND SOURCES.IF_SEQ = XX.IF_SEQ
												   AND XX.LATESTS = 1)	 = 'B'						-- 현재의 WO가 BACK이면
												BEGIN
													SET @TOP_WO = (
																   SELECT SOURCES.ATTR_06
																	 FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																		  ,(SELECT WO
																				   ,IF_SEQ
																				   ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
																			  FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																			 WHERE WO = @WO
																			   AND IF_ID != 'OFP0_OPLM_FP_WO'
																		  ) XX
																	WHERE SOURCES.WO = XX.WO
																	  AND SOURCES.IF_SEQ = XX.IF_SEQ
																	  AND XX.LATESTS = 1
																  );
													SET @BACK_WO = @WO;

												END

											 ELSE
												BEGIN
													SET @TOP_WO = @WO;
													SET @BACK_WO = (
																	SELECT SOURCES.ATTR_06
																	  FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																		   ,(SELECT WO
																				    ,IF_SEQ
																				    ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
																			   FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																			  WHERE WO = @WO
																			    AND IF_ID != 'OFP0_OPLM_FP_WO'
																		   ) XX
																     WHERE SOURCES.WO = XX.WO
																	   AND SOURCES.IF_SEQ = XX.IF_SEQ
																	   AND XX.LATESTS = 1
																   );
													
												END

											SET @PLAN_ID = 'RESULT_EXP_'+replace(replace( replace( convert(varchar, getdate(),120), ' ',''),':',''),'-','') + '-XX';

											--MES 전송
											IF @MIX_CHK IS NULL											--MIXING 공정이 아닐경에만 MES 전송 조건 시작
												BEGIN

													--TOP 전송
													INSERT INTO @XIF_MES_WO_S 
													    (
														 [IF_SEQ]
														,[IF_TYPE]
														,[IF_ID]
														,[IF_INS_DATE]
														,[IF_FLAG]
														,[IF_SND_DATE]
														,[RSLT_IF_SEQ]
														,[RSLT_PROC_FLAG]
														,[RSLT_PROC_MSG]
														,[PLAN_ID]
														,[PLANT_ID]
														,[BUILNO]
														,[LINE_ID]
														,[OPERATION_ID]
														,[EQUIPMENT_ID]
														,[ITEM_ID]
														,[DEMAND_ID]
														,[WO]
														,[WO_TYPE]
														,[WO_DETAIL]
														,[PLAN_DATE]
														,[START_TIME]
														,[END_TIME]
														,[IN_QTY]
														,[OUT_QTY]
														,[IS_RELEASE]
														,[CREATE_PSN_ID]
														,[CREATE_DATE]
														,[UPDATE_PSN_ID]
														,[UPDATE_DATE]
														,[LANE_QTY]
														,[UNIT]
														,[ORDER_TYPE]
														,[BATCH_ORDER_ID]
														,[SLITTER_PLANT]
														,[MARKET]
														-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
														,[ATTR_02]
														-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
														,[ATTR_04]
														,[ATTR_05]
														,[ATTR_06]
														,[ATTR_07]
														,[ATTR_08]
														,[ATTR_09]
														,[ATTR_10]
														,[ATTR_11]
														,[ATTR_12]	--2018.03.07 PIYONG ADD
														,[ATTR_15]  -- 2022-11-24 kimcd  ROLL_INPUT_QTY
														,[ATTR_16]  -- 2022-11-24 kimcd  ROLL_END_QTY
														,[ATTR_17]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_18]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_19]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_20]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													)											
													SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
															,'S'	-- [IF_TYPE]
															--2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
															--,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
															,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.[BUILNO])) FROM SCM_MMD_LINE_M L  WHERE L.FACTORY_ID = SOURCES.[BUILNO] AND L.LINE_ID = SOURCES.[LINE_ID] ),'') +'_'+'FP_WO' -- [IF_ID]
															,GETDATE() -- [IF_INS_DATE] 2020-07-27 kimcd 전송 정보 형성 시간을 현재 시간으로 입력
															,'N' --[IF_FLAG]
															,NULL
															,NULL -- [RSLT_IF_SEQ]
															,NULL--[RSLT_PROC_FLAG]
															,NULL--[RSLT_PROC_MSG]
															,@PLAN_ID AS PLAN_ID
															,[PLANT_ID]
															,[BUILNO]
															,[LINE_ID]
															,[OPERATION_ID]
															,[EQUIPMENT_ID]
															,[ITEM_ID]
															,[DEMAND_ID]
															,SOURCES.[WO]
															,[WO_TYPE]
															,[WO_DETAIL]
															,[PLAN_DATE]
															,[START_TIME]
															,[END_TIME]
															,1 -- [PLAN_IN_QTY]
															,1 -- [PLAN_QTY]
															,[IS_RELEASE]
															,[CREATE_PSN_ID]
															,[CREATE_DATE]
															,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112) --[UPDATE_PSN_ID]
															,GETDATE() --[UPDATE_DATE]
															,[LANE_QTY]
															,[UNIT]
															,[ORDER_TYPE]
															,[BATCH_ORDER_ID]
															,[SLITTER_PLANT]
															,[MARKET]
															-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
															,[ATTR_02]
															-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
															,[ATTR_04]
															,[ATTR_05]
															,[ATTR_06]
															,[ATTR_07]
															,[ATTR_08]
															,[ATTR_09]
															,[ATTR_10]
															,[ATTR_11]
															,[ATTR_12]	--2018.03.07 PIYONG ADD
															,[ATTR_15]  -- 2022-11-24 kimcd  ROLL_INPUT_QTY
															,[ATTR_16]  -- 2022-11-24 kimcd  ROLL_END_QTY
															,[ATTR_17]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,[ATTR_18]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,[ATTR_19]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,[ATTR_20]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													   FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
															,(SELECT WO
																	 ,IF_SEQ
																	 ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
															    FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
															   WHERE WO = @TOP_WO
																 AND IF_ID != 'OFP0_OPLM_FP_WO'
															) XX
													  WHERE SOURCES.WO = XX.WO
														AND SOURCES.IF_SEQ = XX.IF_SEQ
														AND XX.LATESTS = 1

													-- 2018-12-18 kimcd top wo 수량 갱신 시작
													UPDATE  DBO.FP_MES_PRODUCTION_PLAN_M
													SET     [PLAN_QTY]     = 1
														   ,[PLAN_IN_QTY]  = 1
														   ,[UPDATE_ID]    = @v_proc_name
														   ,[UPDATE_TIME]  = GETDATE()
													WHERE  [WORK_ORDER_ID] = @TOP_WO
													-- 2018-12-18 kimcd top wo 수량 갱신 끝

													--BACK 전송
													INSERT INTO @XIF_MES_WO_S
													    (
														 [IF_SEQ]
														,[IF_TYPE]
														,[IF_ID]
														,[IF_INS_DATE]
														,[IF_FLAG]
														,[IF_SND_DATE]
														,[RSLT_IF_SEQ]
														,[RSLT_PROC_FLAG]
														,[RSLT_PROC_MSG]
														,[PLAN_ID]
														,[PLANT_ID]
														,[BUILNO]
														,[LINE_ID]
														,[OPERATION_ID]
														,[EQUIPMENT_ID]
														,[ITEM_ID]
														,[DEMAND_ID]
														,[WO]
														,[WO_TYPE]
														,[WO_DETAIL]
														,[PLAN_DATE]
														,[START_TIME]
														,[END_TIME]
														,[IN_QTY]
														,[OUT_QTY]
														,[IS_RELEASE]
														,[CREATE_PSN_ID]
														,[CREATE_DATE]
														,[UPDATE_PSN_ID]
														,[UPDATE_DATE]
														,[LANE_QTY]
														,[UNIT]
														,[ORDER_TYPE]
														,[BATCH_ORDER_ID]
														,[SLITTER_PLANT]
														,[MARKET]
														-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
														,[ATTR_02]
														-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
														,[ATTR_04]
														,[ATTR_05]
														,[ATTR_06]
														,[ATTR_07]
														,[ATTR_08]
														,[ATTR_09]
														,[ATTR_10]
														,[ATTR_11]
														,[ATTR_12]	--2018.03.07 PIYONG ADD
														,[ATTR_15]  -- 2022-11-24 kimcd  ROLL_INPUT_QTY
														,[ATTR_16]  -- 2022-11-24 kimcd  ROLL_END_QTY
														,[ATTR_17]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_18]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_19]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_20]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													)											
													SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
															,'S'	-- [IF_TYPE]
															--2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
															--,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
															,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.[BUILNO])) FROM SCM_MMD_LINE_M L  WHERE L.FACTORY_ID = SOURCES.[BUILNO] AND L.LINE_ID = SOURCES.[LINE_ID] ),'') +'_'+'FP_WO' -- [IF_ID]
															,GETDATE() -- [IF_INS_DATE] 2020-07-27 kimcd 전송 정보 형성 일자를 현재일시로 입력
															,'N' --[IF_FLAG]
															,NULL
															,NULL -- [RSLT_IF_SEQ]
															,NULL--[RSLT_PROC_FLAG]
															,NULL--[RSLT_PROC_MSG]
															,@PLAN_ID AS [PLAN_ID]
															,[PLANT_ID]
															,[BUILNO]
															,[LINE_ID]
															,[OPERATION_ID]
															,[EQUIPMENT_ID]
															,[ITEM_ID]
															,[DEMAND_ID]
															,SOURCES.[WO]
															,[WO_TYPE]
															,[WO_DETAIL]
															,[PLAN_DATE]
															,[START_TIME]
															,[END_TIME]
															,1 -- [PLAN_IN_QTY]
															,1 -- [PLAN_QTY]
															,[IS_RELEASE]
															,[CREATE_PSN_ID]
															,[CREATE_DATE]
															,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112) --[UPDATE_PSN_ID]
															,GETDATE() --[UPDATE_DATE]
															,[LANE_QTY]
															,[UNIT]
															,[ORDER_TYPE]
															,[BATCH_ORDER_ID]
															,[SLITTER_PLANT]
															,[MARKET]
															-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
															,[ATTR_02]
															-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
															,[ATTR_04]
															,[ATTR_05]
															,[ATTR_06]
															,[ATTR_07]
															,[ATTR_08]
															,[ATTR_09]
															,[ATTR_10]
															,[ATTR_11]
															,[ATTR_12]	--2018.03.07 PIYONG ADD
															,[ATTR_15]  -- 2022-11-24 kimcd  ROLL_INPUT_QTY
															,[ATTR_16]  -- 2022-11-24 kimcd  ROLL_END_QTY
															,[ATTR_17]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,[ATTR_18]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,[ATTR_19]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,[ATTR_20]  -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													   FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
															,(SELECT WO
																	 ,IF_SEQ
																	 ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
															    FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
															   WHERE WO = @BACK_WO
																 AND IF_ID != 'OFP0_OPLM_FP_WO'
															) XX
													  WHERE SOURCES.WO = XX.WO
														AND SOURCES.IF_SEQ = XX.IF_SEQ
														AND XX.LATESTS = 1


													--> LOOP 밖에서 MES/PDS 일괄 전송 (@XIF_MES_WO_S -> SY_XIF_MES_WO_S)

													-- 2018-12-18 kimcd back wo 수량 갱신 시작
													UPDATE  DBO.FP_MES_PRODUCTION_PLAN_M
													SET     [PLAN_QTY]     = 1
														   ,[PLAN_IN_QTY]  = 1
														   ,[UPDATE_ID]    = @v_proc_name
														   ,[UPDATE_TIME]  = GETDATE()
													WHERE  [WORK_ORDER_ID] = @BACK_WO
													-- 2018-12-18 kimcd back wo 수량 갱신 끝

												END		--MIX 아닐때만 전송 조건 끝

											--ERP 전송
											--TOP 전송
											INSERT INTO  DBO.SY_XIF_ERP_PRODUCTION_PLAN_S(
													[IFSEQNO]
													,[SEQ]
													,[FP_PLAN_ID]
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[FIX_TYPE]
													,[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,[MODIFY_USER_ID]
													,[MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[ATTRIBUTE9]
													,[ATTRIBUTE10]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
													,[TECO_IND]
											) 
											SELECT SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(26),GETDATE(),21),'-',''),':',''),' ',''),'.',''),1,16) -- [IFSEQNO]
													,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
													,@PLAN_ID AS FP_PLAN_ID
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,S.[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,1 -- [PLAN_IN_QTY]
													,1 -- [PLAN_QTY]
													,[FIX_TYPE]
													,'N' --[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112)  -- [MODIFY_USER_ID]
													,GETDATE() -- [MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
													,[TECO_IND]
											   FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S S
											   JOIN (SELECT IFSEQNO
															,WORK_ORDER_ID
													   FROM (SELECT ROW_NUMBER() OVER ( PARTITION BY [WORK_ORDER_ID] ORDER BY IFSEQNO DESC) NUMES
																	,IFSEQNO
																	,[WORK_ORDER_ID]
															   FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] SS
															  WHERE SS.[WORK_ORDER_ID] = @TOP_WO
															)A
													  WHERE A.NUMES = 1
													) X
												 ON S.IFSEQNO = X.IFSEQNO
												AND S.WORK_ORDER_ID = X.WORK_ORDER_ID

											--BACK 전송
											INSERT INTO  DBO.SY_XIF_ERP_PRODUCTION_PLAN_S(
												[IFSEQNO]
												,[SEQ]
												,[FP_PLAN_ID]
												,[PLANT_ID]
												,[FACTORY_ID]
												,[LINE_ID]
												,[OPERATION_ID]
												,[BOM_VERSION_ID]
												,[WORK_CENTER_ID]
												,[ITEM_ID]
												,[DEMAND_ID]
												,[WORK_ORDER_ID]
												,[ORDER_TYPE]
												,[PLAN_DATE]
												,[START_TIME]
												,[END_TIME]
												,[PLAN_IN_QTY]
												,[PLAN_QTY]
												,[FIX_TYPE]
												,[TRANSFER_FLAG]
												,[TRANSFER_DATE]
												,[CREATE_USER_ID]
												,[CREATE_DATE]
												,[MODIFY_USER_ID]
												,[MODIFY_DATE]
												,[LANE_QTY]
												,[BATCH_ORDER_ID]
												,[SLITTER_PLANT]
												,[MARKET]
												,[ATTRIBUTE1]
												,[ATTRIBUTE2]
												,[ATTRIBUTE3]
												,[ATTRIBUTE4]
												,[ATTRIBUTE5]
												,[ATTRIBUTE6]
												,[ATTRIBUTE7]
												,[ATTRIBUTE8]
												,[ATTRIBUTE9]
												,[ATTRIBUTE10]
												,[TOP_BACK_IND]
												,[LINK_WO]
												,[FP_PLAN_QTY]
												,[FP_SNAP_QTY]
												,[TECO_IND]
											) 
											SELECT CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ',''))+1) -- [IFSEQNO]
												   ,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
													,@PLAN_ID AS FP_PLAN_ID
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,S.[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,1 -- [PLAN_IN_QTY]
													,1 -- [PLAN_QTY]
													,[FIX_TYPE]
													,'N' --[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112)  -- [MODIFY_USER_ID]
													,GETDATE() -- [MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
												   ,[TECO_IND]
											  FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S S
											  JOIN ( SELECT IFSEQNO
															,WORK_ORDER_ID
													   FROM (SELECT ROW_NUMBER() OVER ( PARTITION BY [WORK_ORDER_ID] ORDER BY IFSEQNO DESC) NUMES
																	,IFSEQNO
																	,[WORK_ORDER_ID]
															   FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] SS
															  WHERE SS.[WORK_ORDER_ID] = @BACK_WO
															)A
													  WHERE A.NUMES = 1
													) X
												 ON S.IFSEQNO = X.IFSEQNO
												AND S.WORK_ORDER_ID = X.WORK_ORDER_ID

										END

									ELSE IF @CHECK_CODE = 'A004'
										BEGIN
											INSERT INTO [dbo].[SY_XIF_MES_WO_PEGGING_S] (
													[IF_SEQ]
													,[IF_TYPE]
													,[IF_ID]
													,[IF_INS_DATE]
													,[IF_FLAG]
													,[IF_SND_DATE]
													,[RSLT_IF_SEQ]
													,[RSLT_PROC_FLAG]
													,[RSLT_PROC_MSG]
													,[PLAN_ID]
													,[PLANT_ID]
													,[BUILNO]
													,[LINE_ID]
													,[OPERATION_ID]
													,[WO]
													,[QTY]
													,[FROM_WO]
													,[CREATE_PSN_ID]
													,[CREATE_DATE]
													,[UPDATE_PSN_ID]
													,[UPDATE_DATE]
													,[ATTR_01]
													,[ATTR_02]
													,[ATTR_03]
													,[ATTR_04]
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10]
											)
											SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
													,'S'																          -- IF_TYPE
													--2021-07-08 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
													--,'OFP0'+'_'+( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.BUILNO ) +'_'+'FP_WO_PEGGING'
													,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.BUILNO)) FROM SCM_MMD_LINE_M L  WHERE L.FACTORY_ID = SOURCES.BUILNO AND L.LINE_ID = SOURCES.LINE_ID ),'') +'_'+'FP_WO_PEGGING'
													,GETDATE()																	  -- IF_INS_DATE
													,'N'																		  -- IF_FLAG
													,NULL																	      -- IF_SND_DATE
													,NULL																		  -- RSLT_IF_SEQ
													,NULL																		  -- RSLT_PROC_FLAG
													,NULL																		  -- RSLT_PROC_MSG
													,'RESULT_EXP_'+replace(replace( replace( convert(varchar, getdate(),120), ' ',''),':',''),'-','') + '-XX' AS PLAN_ID    -- PLAN_ID
													,SOURCES.PLANT_ID															  -- PLANT_ID
													,BUILNO																          -- BUILNO
													,SOURCES.LINE_ID AS TO_LINE_ID
													,SOURCES.OPERATION_ID														  -- OPERATION_ID
													,SOURCES.WO																	  -- WO
													,SOURCES.IN_QTY
													,@WO2																		  -- FROM_WO
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R'										      -- CREATE_PSN_ID
													,GETDATE()																	  -- CREATE_DATE
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R'											  -- UPDATE_PSN_ID
													,GETDATE()															          -- UPDATE_DATE
													,@seq_next																	  -- ATTR_01
													,NULL															              -- ATTR_02
													,NULL																		  -- ATTR_03
													,NULL																          -- ATTR_04
													,NULL																	      -- ATTR_05
													,NULL																          -- ATTR_06
													,NULL																          -- ATTR_07
													,NULL																	      -- ATTR_08
													,NULL																          -- ATTR_09
													,NULL																          -- ATTR_10
											   FROM DBO.SY_XIF_MES_WO_S SOURCES
											  WHERE SOURCES.WO = @WO
												AND IF_SEQ = (SELECT TOP 1 IF_SEQ
																FROM [DBO].[SY_XIF_MES_WO_S] S
															   WHERE 1=1
																 AND WO = @WO
																 AND IF_ID != 'OFP0_OPLM_FP_WO'
															   ORDER BY IF_SEQ DESC )
										END
/*
									ELSE IF @CHECK_CODE = 'A005'
										BEGIN
											-- TOP /BACK 확인
											IF (SELECT SOURCES.ATTR_05
												  FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
													   ,(SELECT WO
															    ,IF_SEQ
																,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
														  FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
														 WHERE WO = @WO
														   AND IF_ID != 'OFP0_OPLM_FP_WO'
														 ) XX
												  WHERE SOURCES.WO = XX.WO
													AND SOURCES.IF_SEQ = XX.IF_SEQ
													AND XX.LATESTS = 1)	 = 'T'						-- 현재의 WO가 BACK이면
												BEGIN
													SET @TOP_WO = (
																   SELECT SOURCES.ATTR_06
																	 FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																		  ,(SELECT WO
																				   ,IF_SEQ
																				   ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
																			  FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																			 WHERE WO = @WO
																			   AND IF_ID != 'OFP0_OPLM_FP_WO'
																		   ) XX
																	 WHERE SOURCES.WO = XX.WO
																	   AND SOURCES.IF_SEQ = XX.IF_SEQ
																	   AND XX.LATESTS = 1
																  );
													SET @BACK_WO = @WO;
												END

											 ELSE
												BEGIN
													SET @TOP_WO = @WO;
													SET @BACK_WO = (
																	SELECT SOURCES.ATTR_06
																	  FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																		   ,(SELECT WO
																				    ,IF_SEQ
																				    ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
																			   FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
																			  WHERE WO = @WO
																			    AND IF_ID != 'OFP0_OPLM_FP_WO'
																		   ) XX
																     WHERE SOURCES.WO = XX.WO
																	   AND SOURCES.IF_SEQ = XX.IF_SEQ
																	   AND XX.LATESTS = 1
																   );
													
												END



											--MES COATING 전송
											--TOP 전송
											INSERT INTO [DBO].[SY_XIF_MES_WO_S] (
													[IF_SEQ]
													,[IF_TYPE]
													,[IF_ID]
													,[IF_INS_DATE]
													,[IF_FLAG]
													,[IF_SND_DATE]
													,[RSLT_IF_SEQ]
													,[RSLT_PROC_FLAG]
													,[RSLT_PROC_MSG]
													,[PLAN_ID]
													,[PLANT_ID]
													,[BUILNO]
													,[LINE_ID]
													,[OPERATION_ID]
													,[EQUIPMENT_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,[WO]
													,[WO_TYPE]
													,[WO_DETAIL]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,[IN_QTY]
													,[OUT_QTY]
													,[IS_RELEASE]
													,[CREATE_PSN_ID]
													,[CREATE_DATE]
													,[UPDATE_PSN_ID]
													,[UPDATE_DATE]
													,[LANE_QTY]
													,[UNIT]
													,[ORDER_TYPE]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTR_01]
													,[ATTR_02]
													,[ATTR_03]
													,[ATTR_04]
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10]
											)											
											SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
													,'S'	-- [IF_TYPE]
													,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
													,[IF_INS_DATE]
													,'N' --[IF_FLAG]
													,[IF_SND_DATE]
													,NULL -- [RSLT_IF_SEQ]
													,NULL--[RSLT_PROC_FLAG]
													,NULL--[RSLT_PROC_MSG]
													,PLAN_ID + '_00X'
													,[PLANT_ID]
													,[BUILNO]
													,[LINE_ID]
													,[OPERATION_ID]
													,[EQUIPMENT_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,SOURCES.[WO]
													,[WO_TYPE]
													,[WO_DETAIL]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,1 -- [PLAN_IN_QTY]
													,1 -- [PLAN_QTY]
													,[IS_RELEASE]
													,[CREATE_PSN_ID]
													,[CREATE_DATE]
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112) --[UPDATE_PSN_ID]
													,GETDATE() --[UPDATE_DATE]
													,[LANE_QTY]
													,[UNIT]
													,[ORDER_TYPE]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTR_01]
													,[ATTR_02]
													,[ATTR_03]
													,[ATTR_04]
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10]
											   FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
													,(SELECT WO
															 ,IF_SEQ
															 ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
														FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
													   WHERE WO = @TOP_WO
														 AND IF_ID != 'OFP0_OPLM_FP_WO'
													) XX
											  WHERE SOURCES.WO = XX.WO
												AND SOURCES.IF_SEQ = XX.IF_SEQ
												AND XX.LATESTS = 1

											--BACK 전송
											INSERT INTO [DBO].[SY_XIF_MES_WO_S] (
													[IF_SEQ]
													,[IF_TYPE]
													,[IF_ID]
													,[IF_INS_DATE]
													,[IF_FLAG]
													,[IF_SND_DATE]
													,[RSLT_IF_SEQ]
													,[RSLT_PROC_FLAG]
													,[RSLT_PROC_MSG]
													,[PLAN_ID]
													,[PLANT_ID]
													,[BUILNO]
													,[LINE_ID]
													,[OPERATION_ID]
													,[EQUIPMENT_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,[WO]
													,[WO_TYPE]
													,[WO_DETAIL]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,[IN_QTY]
													,[OUT_QTY]
													,[IS_RELEASE]
													,[CREATE_PSN_ID]
													,[CREATE_DATE]
													,[UPDATE_PSN_ID]
													,[UPDATE_DATE]
													,[LANE_QTY]
													,[UNIT]
													,[ORDER_TYPE]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTR_01]
													,[ATTR_02]
													,[ATTR_03]
													,[ATTR_04]
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10]
											)											
											SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
													,'S'	-- [IF_TYPE]
													,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WHERE F.FACTORY_ID = SOURCES.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
													,[IF_INS_DATE]
													,'N' --[IF_FLAG]
													,[IF_SND_DATE]
													,NULL -- [RSLT_IF_SEQ]
													,NULL--[RSLT_PROC_FLAG]
													,NULL--[RSLT_PROC_MSG]
													,PLAN_ID + '_00X'
													,[PLANT_ID]
													,[BUILNO]
													,[LINE_ID]
													,[OPERATION_ID]
													,[EQUIPMENT_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,SOURCES.[WO]
													,[WO_TYPE]
													,[WO_DETAIL]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,1 -- [PLAN_IN_QTY]
													,1 -- [PLAN_QTY]
													,[IS_RELEASE]
													,[CREATE_PSN_ID]
													,[CREATE_DATE]
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112) --[UPDATE_PSN_ID]
													,GETDATE() --[UPDATE_DATE]
													,[LANE_QTY]
													,[UNIT]
													,[ORDER_TYPE]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTR_01]
													,[ATTR_02]
													,[ATTR_03]
													,[ATTR_04]
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10]
											   FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
													,(SELECT WO
															 ,IF_SEQ
															 ,ROW_NUMBER() OVER ( PARTITION BY WO ORDER BY IF_SEQ DESC ) LATESTS
														FROM [DBO].[SY_XIF_MES_WO_S] SOURCES 
													   WHERE WO = @BACK_WO
														 AND IF_ID != 'OFP0_OPLM_FP_WO'
													) XX
											  WHERE SOURCES.WO = XX.WO
												AND SOURCES.IF_SEQ = XX.IF_SEQ
												AND XX.LATESTS = 1

											--ERP COATING 전송
											--TOP 전송
											INSERT INTO  DBO.SY_XIF_ERP_PRODUCTION_PLAN_S(
													[IFSEQNO]
													,[SEQ]
													,[FP_PLAN_ID]
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[FIX_TYPE]
													,[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,[MODIFY_USER_ID]
													,[MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[ATTRIBUTE9]
													,[ATTRIBUTE10]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
													,[TECO_IND]
											) 
											SELECT CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ',''))+2) -- [IFSEQNO]
													,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
													,FP_PLAN_ID + '_00X'
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,S.[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,1 -- [PLAN_IN_QTY]
													,1 -- [PLAN_QTY]
													,[FIX_TYPE]
													,'N' --[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112)  -- [MODIFY_USER_ID]
													,GETDATE() -- [MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
													,[TECO_IND]
											   FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S S
											   JOIN (SELECT IFSEQNO
															,WORK_ORDER_ID
													   FROM (SELECT ROW_NUMBER() OVER ( PARTITION BY [WORK_ORDER_ID] ORDER BY IFSEQNO DESC) NUMES
																	,IFSEQNO
																	,[WORK_ORDER_ID]
															   FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] SS
															  WHERE SS.[WORK_ORDER_ID] = @TOP_WO
															)A
													  WHERE A.NUMES = 1
													) X
												 ON S.IFSEQNO = X.IFSEQNO
												AND S.WORK_ORDER_ID = X.WORK_ORDER_ID

											--BACK 전송
											INSERT INTO  DBO.SY_XIF_ERP_PRODUCTION_PLAN_S(
													[IFSEQNO]
													,[SEQ]
													,[FP_PLAN_ID]
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[FIX_TYPE]
													,[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,[MODIFY_USER_ID]
													,[MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[ATTRIBUTE9]
													,[ATTRIBUTE10]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
													,[TECO_IND]
											) 
											SELECT CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ',''))+3) -- [IFSEQNO]
													,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
													,FP_PLAN_ID + '_00X'
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,S.[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,1 -- [PLAN_IN_QTY]
													,1 -- [PLAN_QTY]
													,[FIX_TYPE]
													,'N' --[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112)  -- [MODIFY_USER_ID]
													,GETDATE() -- [MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
													,[TECO_IND]
												FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S S
												JOIN (SELECT IFSEQNO
															,WORK_ORDER_ID
														FROM (SELECT ROW_NUMBER() OVER ( PARTITION BY [WORK_ORDER_ID] ORDER BY IFSEQNO DESC) NUMES
																	,IFSEQNO
																	,[WORK_ORDER_ID]
															   FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] SS
															  WHERE SS.[WORK_ORDER_ID] = @BACK_WO
															)A
														WHERE A.NUMES = 1
													) X
												ON S.IFSEQNO = X.IFSEQNO
												AND S.WORK_ORDER_ID = X.WORK_ORDER_ID

											--MIXING ERP전송
											INSERT INTO  DBO.SY_XIF_ERP_PRODUCTION_PLAN_S(
												[IFSEQNO]
												,[SEQ]
												,[FP_PLAN_ID]
												,[PLANT_ID]
												,[FACTORY_ID]
												,[LINE_ID]
												,[OPERATION_ID]
												,[BOM_VERSION_ID]
												,[WORK_CENTER_ID]
												,[ITEM_ID]
												,[DEMAND_ID]
												,[WORK_ORDER_ID]
												,[ORDER_TYPE]
												,[PLAN_DATE]
												,[START_TIME]
												,[END_TIME]
												,[PLAN_IN_QTY]
												,[PLAN_QTY]
												,[FIX_TYPE]
												,[TRANSFER_FLAG]
												,[TRANSFER_DATE]
												,[CREATE_USER_ID]
												,[CREATE_DATE]
												,[MODIFY_USER_ID]
												,[MODIFY_DATE]
												,[LANE_QTY]
												,[BATCH_ORDER_ID]
												,[SLITTER_PLANT]
												,[MARKET]
												,[ATTRIBUTE1]
												,[ATTRIBUTE2]
												,[ATTRIBUTE3]
												,[ATTRIBUTE4]
												,[ATTRIBUTE5]
												,[ATTRIBUTE6]
												,[ATTRIBUTE7]
												,[ATTRIBUTE8]
												,[ATTRIBUTE9]
												,[ATTRIBUTE10]
												,[TOP_BACK_IND]
												,[LINK_WO]
												,[FP_PLAN_QTY]
												,[FP_SNAP_QTY]
												,[TECO_IND]
											) 
											SELECT CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ',''))+4) -- [IFSEQNO]
													,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
													,FP_PLAN_ID + '_00X'
													,[PLANT_ID]
													,[FACTORY_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													,[BOM_VERSION_ID]
													,[WORK_CENTER_ID]
													,[ITEM_ID]
													,[DEMAND_ID]
													,S.[WORK_ORDER_ID]
													,[ORDER_TYPE]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,1 -- [PLAN_IN_QTY]
													,1 -- [PLAN_QTY]
													,[FIX_TYPE]
													,'N' --[TRANSFER_FLAG]
													,[TRANSFER_DATE]
													,[CREATE_USER_ID]
													,[CREATE_DATE]
													,'PR_XIF_MES_RT_RESULT_EXCEPT_R_'+CONVERT( NVARCHAR(8), GETDATE(), 112)  -- [MODIFY_USER_ID]
													,GETDATE() -- [MODIFY_DATE]
													,[LANE_QTY]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE3]
													,[ATTRIBUTE4]
													,[ATTRIBUTE5]
													,[ATTRIBUTE6]
													,[ATTRIBUTE7]
													,[ATTRIBUTE8]
													,[PLAN_IN_QTY]
													,[PLAN_QTY]
													,[TOP_BACK_IND]
													,[LINK_WO]
													,[FP_PLAN_QTY]
													,[FP_SNAP_QTY]
													,[TECO_IND]
											   FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S S
											   JOIN (SELECT IFSEQNO
															,WORK_ORDER_ID
													   FROM (SELECT ROW_NUMBER() OVER ( PARTITION BY [WORK_ORDER_ID] ORDER BY IFSEQNO DESC) NUMES
																	,IFSEQNO
																	,[WORK_ORDER_ID]
															   FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] SS
															  WHERE SS.[WORK_ORDER_ID] = @WO2
															)A
													  WHERE A.NUMES = 1
													) X
												 ON S.IFSEQNO = X.IFSEQNO
												AND S.WORK_ORDER_ID = X.WORK_ORDER_ID

										END
*/
								END

							ELSE IF @chk_WO < 0
								BEGIN
									--I/F 테이블에 TOP WO와 같은 ACCUM_DATE에 존재하는 경우
									UPDATE [dbo].[SY_XIF_MES_RT_RESULT_EXCEPT_R]
									   SET PROC_MSG = 'received TOP WORK ORDER together.'
									 WHERE PROC_FLAG = 'P'
									   AND IF_SEQ = @IF_SEQ
								 END

							ELSE IF @chk_WO2 = 0 AND @CHECK_CODE = 'A004'
								BEGIN
									--I/F 테이블에 TOP WO와 같은 ACCUM_DATE에 존재하는 경우
									UPDATE [dbo].[SY_XIF_MES_RT_RESULT_EXCEPT_R]
									   SET PROC_MSG = 'MIXING WORK ORDER has been removed from Table.'
									 WHERE PROC_FLAG = 'P'
									   AND IF_SEQ = @IF_SEQ
								 END
							ELSE
								BEGIN
									--송신테이블에 WO가 존재하지 않을 경우  PROC_MSG컬럼에 사유를 저장하여 정상적인 I/F처리에와 구분한다
									UPDATE [dbo].[SY_XIF_MES_RT_RESULT_EXCEPT_R]
									   SET PROC_MSG = 'WORK ORDER has been removed from Table.'
									 WHERE PROC_FLAG = 'P'
									   AND IF_SEQ = @IF_SEQ

								END

							FETCH NEXT FROM CUR_RESULT INTO @CHECK_CODE
														    ,@WO
														    ,@WO2
															,@IF_SEQ
							;

						END;

					CLOSE CUR_RESULT;
					DEALLOCATE CUR_RESULT;  
								

					SET @ROWCOUNT = @@ROWCOUNT;

					UPDATE [dbo].[SY_XIF_MES_RT_RESULT_EXCEPT_R]
					   SET PROC_FLAG = 'Y'
						   ,PROC_DATE = GETDATE()
					 WHERE IF_ID = @IF_ID
					   AND ACCUM_DATE = @ACCUM_DATE
					;

					FETCH NEXT FROM CUR_IF_MES_RESULT_EXCEPT INTO @IF_ID        
																  ,@ACCUM_DATE
																  ,@SITE_ID

					;



				END;


			CLOSE CUR_IF_MES_RESULT_EXCEPT;
			DEALLOCATE CUR_IF_MES_RESULT_EXCEPT;  

		-- MES 전송
		INSERT INTO SY_XIF_MES_WO_S
                  ( [IF_SEQ]                                                                                                                                                                                                                                  
				  , [IF_TYPE]                                                                                                                                                                                                                                   
				  , [IF_ID]                                                                                                                                                                                                                                     
				  , [IF_INS_DATE]                                                                                                                                                                                                                               
				  , [IF_FLAG]                                                                                                                                                                                                                                   
				  , [IF_SND_DATE]                                                                                                                                                                                                                               
				  , [RSLT_IF_SEQ]                                                                                                                                                                                                                               
				  , [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
				  , [RSLT_PROC_MSG]                                                                                                                                                                                                                             
				  , [PLAN_ID]                                                                                                                                                                                                                                   
				  , [PLANT_ID]                                                                                                                                                                                                                                  
				  , [BUILNO]                                                                                                                                                                                                                                    
				  , [LINE_ID]                                                                                                                                                                                                                                   
				  , [OPERATION_ID]                                                                                                                                                                                                                              
				  , [EQUIPMENT_ID]                                                                                                                                                                                                                              
				  , [ITEM_ID]                                                                                                                                                                                                                                   
				  , [DEMAND_ID]                                                                                                                                                                                                                                 
				  , [WO]                                                                                                                                                                                                                                        
				  , [WO_TYPE]                                                                                                                                                                                                                                   
				  , [WO_DETAIL]                                                                                                                                                                                                                                 
				  , [PLAN_DATE]                                                                                                                                                                                                                                 
				  , [START_TIME]                                                                                                                                                                                                                                
				  , [END_TIME]                                                                                                                                                                                                                                  
				  , [IN_QTY]                                                                                                                                                                                                                                    
				  , [OUT_QTY]                                                                                                                                                                                                                                   
				  , [IS_RELEASE]                                                                                                                                                                                                                                
				  , [CREATE_PSN_ID]                                                                                                                                                                                                                             
				  , [CREATE_DATE]                                                                                                                                                                                                                               
				  , [UPDATE_PSN_ID]                                                                                                                                                                                                                             
				  , [UPDATE_DATE]                                                                                                                                                                                                                               
				  , [LANE_QTY]                                                                                                                                                                                                                                  
				  , [UNIT]                                                                                                                                                                                                                                      
				  , [ORDER_TYPE]    
				  , [BATCH_ORDER_ID]
				  , [SLITTER_PLANT]
				  , [MARKET]
				  , [ATTR_01]
				  , [ATTR_02]
				  , [ATTR_03]
				  , [ATTR_04]
				  , [ATTR_05] 
				  , [ATTR_06] 
				  , [ATTR_07] 
				  , [ATTR_08] 
				  , [ATTR_09] 
				  , [ATTR_10] 
				  , [ATTR_11] 
				  , [ATTR_12] 
				  , [ATTR_13] 
				  , [ATTR_14] 
				  , [ATTR_15] 
				  , [ATTR_16] 
				  , [ATTR_17] 
				  , [ATTR_18] 
				  , [ATTR_19] 
				  , [ATTR_20] 
					)
			 SELECT 
				    [IF_SEQ]                                                                                                   
				  , [IF_TYPE]                                                                                                  
				  , [IF_ID]                                                                                                    
				  , [IF_INS_DATE]                                                                                              
				  , [IF_FLAG]                                                                                                  
				  , [IF_SND_DATE]                                                                                              
				  , [RSLT_IF_SEQ]                                                                                              
				  , [RSLT_PROC_FLAG]                                                                                           
				  , [RSLT_PROC_MSG]                                                                                            
				  , [PLAN_ID]                                                                                                  
				  , [PLANT_ID]                                                                                                 
				  , [BUILNO]                                                                                                   
				  , [LINE_ID]                                                                                                  
				  , [OPERATION_ID]                                                                                             
				  , [EQUIPMENT_ID]                                                                                             
				  , [ITEM_ID]                                                                                                  
				  , [DEMAND_ID]                                                                                                
				  , [WO]                                                                                                       
				  , [WO_TYPE]                                                                                                  
				  , [WO_DETAIL]                                                                                                
				  , [PLAN_DATE]                                                                                                
				  , [START_TIME]                                                                                               
				  , [END_TIME]                                                                                                 
				  , [IN_QTY]                                                                                                   
				  , [OUT_QTY]                                                                                                  
				  , [IS_RELEASE]                                                                                               
				  , [CREATE_PSN_ID]                                                                                            
				  , [CREATE_DATE]                                                                                              
				  , [UPDATE_PSN_ID]                                                                                            
				  , [UPDATE_DATE]                                                                                              
				  , [LANE_QTY]                                                                                                 
				  , [UNIT]                                                                                                     
				  , [ORDER_TYPE]    
				  , [BATCH_ORDER_ID]
				  , [SLITTER_PLANT]
				  , [MARKET]
				  , [ATTR_01]
				  , [ATTR_02]
				  , [ATTR_03]
				  , [ATTR_04]
				  , [ATTR_05] 
				  , [ATTR_06] 
				  , [ATTR_07] 
				  , [ATTR_08] 
				  , [ATTR_09] 
				  , [ATTR_10] 
				  , [ATTR_11] 
				  , [ATTR_12] 
				  , [ATTR_13] 
				  , [ATTR_14] 
				  , [ATTR_15] 
				  , [ATTR_16] 
				  , [ATTR_17] 
				  , [ATTR_18] 
				  , [ATTR_19] 
				  , [ATTR_20] 
			   FROM @XIF_MES_WO_S
			   ;


		-- PDS 전송
		INSERT INTO SY_XIF_PDS_WO_S
                  ( [IF_SEQ]                                                                                                                                                                                                                                  
				  , [IF_TYPE]                                                                                                                                                                                                                                   
				  , [IF_ID]                                                                                                                                                                                                                                     
				  , [IF_INS_DATE]                                                                                                                                                                                                                               
				  , [IF_FLAG]                                                                                                                                                                                                                                   
				  , [IF_SND_DATE]                                                                                                                                                                                                                               
				  , [RSLT_IF_SEQ]                                                                                                                                                                                                                               
				  , [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
				  , [RSLT_PROC_MSG]                                                                                                                                                                                                                             
				  , [PLAN_ID]                                                                                                                                                                                                                                   
				  , [PLANT_ID]                                                                                                                                                                                                                                  
				  , [BUILNO]                                                                                                                                                                                                                                    
				  , [LINE_ID]                                                                                                                                                                                                                                   
				  , [OPERATION_ID]                                                                                                                                                                                                                              
				  , [EQUIPMENT_ID]                                                                                                                                                                                                                              
				  , [ITEM_ID]                                                                                                                                                                                                                                   
				  , [DEMAND_ID]                                                                                                                                                                                                                                 
				  , [WO]                                                                                                                                                                                                                                        
				  , [WO_TYPE]                                                                                                                                                                                                                                   
				  , [WO_DETAIL]                                                                                                                                                                                                                                 
				  , [PLAN_DATE]                                                                                                                                                                                                                                 
				  , [START_TIME]                                                                                                                                                                                                                                
				  , [END_TIME]                                                                                                                                                                                                                                  
				  , [IN_QTY]                                                                                                                                                                                                                                    
				  , [OUT_QTY]                                                                                                                                                                                                                                   
				  , [IS_RELEASE]                                                                                                                                                                                                                                
				  , [CREATE_PSN_ID]                                                                                                                                                                                                                             
				  , [CREATE_DATE]                                                                                                                                                                                                                               
				  , [UPDATE_PSN_ID]                                                                                                                                                                                                                             
				  , [UPDATE_DATE]                                                                                                                                                                                                                               
				  , [LANE_QTY]                                                                                                                                                                                                                                  
				  , [UNIT]                                                                                                                                                                                                                                      
				  , [ORDER_TYPE]    
				  , [BATCH_ORDER_ID]
				  , [SLITTER_PLANT]
				  , [MARKET]
				  , [ATTR_01]
				  , [ATTR_02]
				  , [ATTR_03]
				  , [ATTR_04]
				  , [ATTR_05] 
				  , [ATTR_06] 
				  , [ATTR_07] 
				  , [ATTR_08] 
				  , [ATTR_09] 
				  , [ATTR_10]
				  , [ATTR_11]							  
				  , [ATTR_12] 
				  , [ATTR_13] 
				  , [ATTR_14] 
				  , [ATTR_15] 
				  , [ATTR_16] 
				  , [ATTR_17] 
				  , [ATTR_18] 
				  , [ATTR_19] 
				  , [ATTR_20] 
				  )
			 SELECT 
				    X.[IF_SEQ]                                                                                                   
				  , X.[IF_TYPE]                                                                                                  
				  , 'OFP0_GPDS_FP_WO' --[IF_ID]                                                                                                    
				  , X.[IF_INS_DATE]                                                                                              
				  , X.[IF_FLAG]                                                                                                  
				  , X.[IF_SND_DATE]                                                                                              
				  , X.[RSLT_IF_SEQ]                                                                                              
				  , X.[RSLT_PROC_FLAG]                                                                                           
				  , X.[RSLT_PROC_MSG]                                                                                            
				  , X.[PLAN_ID]                                                                                                  
				  , X.[PLANT_ID]                                                                                                 
				  , X.[BUILNO]                                                                                                   
				  , X.[LINE_ID]                                                                                                  
				  , X.[OPERATION_ID]                                                                                             
				  , X.[EQUIPMENT_ID]                                                                                             
				  , X.[ITEM_ID]                                                                                                  
				  , X.[DEMAND_ID]                                                                                                
				  , X.[WO]                                                                                                       
				  , X.[WO_TYPE]                                                                                                  
				  , X.[WO_DETAIL]                                                                                                
				  , X.[PLAN_DATE]                                                                                                
				  , X.[START_TIME]                                                                                               
				  , X.[END_TIME]                                                                                                 
				  , X.[IN_QTY]                                                                                                   
				  , X.[OUT_QTY]                                                                                                  
				  , X.[IS_RELEASE]                                                                                               
				  , X.[CREATE_PSN_ID]                                                                                            
				  , X.[CREATE_DATE]                                                                                              
				  , X.[UPDATE_PSN_ID]                                                                                            
				  , X.[UPDATE_DATE]                                                                                              
				  , X.[LANE_QTY]                                                                                                 
				  , X.[UNIT]                                                                                                     
				  , X.[ORDER_TYPE]    
				  , X.[BATCH_ORDER_ID]
				  , X.[SLITTER_PLANT]
				  , X.[MARKET]
				  , X.[ATTR_01]
				  , X.[ATTR_02]
				  , X.[ATTR_03]
				  , X.[ATTR_04]
				  , X.[ATTR_05] 
				  , X.[ATTR_06] 
				  , X.[ATTR_07] 
				  , X.[ATTR_08] 
				  , X.[ATTR_09] 
				  , X.[ATTR_10] 
				  , X.[ATTR_11] 
				  , X.[ATTR_12] 
				  , X.[ATTR_13] 
				  , X.[ATTR_14] 
				  , X.[ATTR_15] 
				  , X.[ATTR_16] 
				  , X.[ATTR_17] 
				  , X.[ATTR_18] 
				  , X.[ATTR_19] 
				  , X.[ATTR_20] 
			   FROM @XIF_MES_WO_S as x
					join scm_factory_m as y with(nolock)
				 on x.[BUILNO] = y.factory_id
			  where y.company_id = 'G670'
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

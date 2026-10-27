--CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_WO_UPLOAD]
CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_WO_UPLOAD]
-- ================================================================================================
-- Program ID          : FP00XXX
-- Program Name        : PR_SCM_MANUAL_WO_UPLOAD
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : MES, ERP
-- Source Table        : FP_MPP_WPP_BASE_PLAN_H, FP_MPP_WPP_BASE_PLAN_M 
-- Destination Table   : FP_MANUAL_WORK_ORDER_H, 
--                       FP_AMEND_PRODUCTION_PLAN_R, FP_RELEASE_FIX_PLAN_H  FP_PRODUCTION_PLAN_EQUIPMENT_R, 
--                       FP_PRODUCTION_PLAN_R, 
-- 
-- Create Date		   : 2017.07.17
-- Update Date		   : 2022.07.13
--
-- Author              : KIMCD
-- Version             : 1.0
--                       1.1 Clear No used Mixer, Half Slitting 2017-08-01 kimcd
--                       1.2 2017-08-08 KIMCD 남경 전극 UPLOAD 허용.
--                       1.3 kimcd 2017-08-19 소형 전극 Pilot, F6200 공정 추가
--                       1.4 kimcd 2017-08-29 오창 소형 조립 Pilot Instance 등록에 따른 수정
--                       1.5 kimcd 2017-11-04 남경 조립 허용. market 구분 추가. plan group 기반 배포 로직 반영
--                       1.6 kimcd 2017-11-22 plan amend 설정에 따라 FP_AMEND_PLAN_R에도 정보 추가 형성
--                       1.7 kimcd 2018-01-30 오창 자동차 확산
--						 1.8 kimcd 2018-02-11 FP_MANUAL_WORK_ORDER_H 테이블 조회시 rolling이나 upload 구분 없이 최종 배포된 계획 기준으로 
--                                            조회되도록 수정
--						 1.9 kimcd 2018-02-23 슬러리 top item id를 pancake item이 전달되도록 로직 수정
--                       2.0 kimcd 2018-03-06 work order 채번 방식 변경. Half Slitting MO 형성에서 Item Line Assign 검증 제거
--                       2.1 kimcd 2018-12-21 commit 단위 변경. commit 오류 보완
--                       2.2 kimcd 2019-06-04 PRODUCTION_TYPE 값이 S-TEST인 경우 TEST로 치환
--                       2.3 kimcd 2022-07-13 설비 정보 없어도 WO 형성할 수 있도록 로직 수정
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- ================================================================================================
	@P_PLAN_WEEK      NVARCHAR(10)  = NULL,
	@P_PLAN_REVISION  NVARCHAR(100) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

  
	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MANUAL_WO_UPLOAD'
	DECLARE @v_message   NVARCHAR(250)
	DECLARE @n_row_count INTEGER	   = 0
	DECLARE @n_log_count INTEGER	   = 0
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @COMPANY_ID  NVARCHAR(30)
	DECLARE @DIVISION_ID NVARCHAR(30)
	DECLARE @SITE_ID     NVARCHAR(30)
	DECLARE	@PLANT_ID    NVARCHAR(30)
	DECLARE @LINK_FACTORY_ID  NVARCHAR(30)  -- 2017-11-04 변수명 FACTORY_ID에서 LINK_FACTORY_ID로 변경
	DECLARE @PLAN_GROUP_ID    NVARCHAR(30)  -- 2017-11-04 Plan 그룹별 배포를 대비하여 Plan Group id 변수 추가
	DECLARE @INSTANCE_ID NVARCHAR(30)
	DECLARE @INSTANCE_TYPE NVARCHAR(2)
	DECLARE @ NVARCHAR(2)
	DECLARE @UPDATE_BY   NVARCHAR(30)
	DECLARE @PLAN_ID     NVARCHAR(30)
	DECLARE @N_CNT       INTEGER	   = 0
	DECLARE @BASE_DATE   DATE
	DECLARE @V_ORDER_DATE_CODE NVARCHAR(30)
	DECLARE @LOCAL_GETDATE DATE             -- 2017-11-04 PSI Amend를 사용하는 경우 일자 순서 맞추기 위해 변수 추가
	DECLARE @LAST_PLAN_ID	NVARCHAR(100)	-- 2018-02-11 kimcd 최종 배포된 plan id 조회
	DECLARE @LAST_PLAN_TYPE NVARCHAR(30)	-- 2018-02-11 kimcd 최종 배포된 plan의 정보 유형

	DECLARE @PLAN_ID_TEMP_TABLE TABLE (
					COMPANY_ID       [NVARCHAR](30),
					DIVISION_ID      [NVARCHAR](30),
					SITE_ID          [NVARCHAR](30),
					PLANT_ID         [NVARCHAR](30),
					LINK_FACTORY_ID  [NVARCHAR](30),   -- 2017-11-04 kimcd plan group 기준으로 배포될 경우 추가. FACTORY_ID 제거하고 사용
					PLAN_GROUP_ID    [NVARCHAR](30),   -- 2017-11-04 kimcd plan group 추가 계획 그룹 기준으로 배포할 경우
					INSTANCE_ID      [NVARCHAR](30),
					INSTANCE_TYPE    [NVARCHAR](2),
					UPDATE_BY        [NVARCHAR](30),
					PLAN_ID          [NVARCHAR](30),
					PLAN_WEEK        [NVARCHAR](10),
					PLAN_REVISION    [NVARCHAR](100))
					

	DECLARE @SEQ		 INTEGER

	DECLARE @TEMP_TABLE TABLE (
					[CUTOFF_DATE]       [DATETIME],
					[COMPANY_ID]        [NVARCHAR](30),
					[DIVISION_ID]       [NVARCHAR](30),
					[SITE_ID]           [NVARCHAR](30),
					[PLANT_ID]          [NVARCHAR](30),
					[FACTORY_ID]        [NVARCHAR](30),
					[PLAN_WEEK]         [NVARCHAR](10),
					[PLAN_REVISION]     [NVARCHAR](100),
					[INSTANCE_ID]       [NVARCHAR](30),
					[PLAN_ID]           [NVARCHAR](30),
					[PRODUCTION_TYPE]   [NVARCHAR](30),
					[WORK_ORDER_SPL_ID] [NVARCHAR](150),
					[WORK_ORDER_ID]     [NVARCHAR](150),
					[ITEM_ID]           [NVARCHAR](150),
					[OPERATION_ID]      [NVARCHAR](30),
					[LINE_ID]           [NVARCHAR](30),
					[EQUIPMENT_ID]      [NVARCHAR](50),
					[MARKET]            [NVARCHAR](10), -- kimcd 2017-11-04 남경 market 추가
					[PLAN_DATE]         [DATETIME],
					[REMAIN_QTY]        [NUMERIC](20,4),
					[ACTUAL_QTY]        [NUMERIC](20,4),
					[ACCUM_PLAN_QTY]    [NUMERIC](20,4),
					[ROW_SEQ]           [NUMERIC](5),
					[FIXED_YN]          [NVARCHAR](30))


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))  + '-  P_PLAN_WEEK:' + @P_PLAN_WEEK + '-  P_PLAN_REVISION:'+ @P_PLAN_REVISION  
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @BASE_DATE = CAST(GETDATE() AS DATE)

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

    BEGIN TRY
	--BEGIN TRANSACTION;
    BEGIN
		IF (@P_PLAN_WEEK IS NULL OR @P_PLAN_REVISION IS NULL)
			BEGIN
				RAISERROR ('Paramter Plan Week or Plan Revision are NULL. All Parameters are Required Value.', -- Message text.
							16, -- Severity.
							1 -- State.
							);
			END;
    
      	DECLARE CUR_INSTANCE_ID CURSOR FOR
			SELECT WPH.[COMPANY_ID]
				,WPH.[DIVISION_ID]
				,WPH.[SITE_ID]
				,WPH.[PLANT_ID]
				,WPH.[FACTORY_ID]     -- 2017-11-04 kimcd @LINK_FACTORY_ID
				,WPH.[PLAN_GROUP_ID]  -- 2017-11-04 kimcd plan group 기반 배포 조건 추가
				,ISNULL(RH.[INSTANCE_ID],CASE WHEN WPH.[INSTANCE_ID] = 'KR_CELL_M' THEN WPH.[INSTANCE_ID] + '_P' ELSE WPH.[INSTANCE_ID] END)  AS INSTANCE_ID
				 -- kimcd 2017-08-19 PILOT의 의미로 _P 추가. 한국 조립 Pilot 구분하기위한 수단으로 사용
				,WPH.INSTANCE_TYPE
				,WPH.UPDATE_ID
			FROM   ( SELECT  [PLAN_WEEK]
							,[PLAN_REVISION]
							,[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[PLAN_GROUP_ID]  -- 2017-11-04 kimcd plan group별 배포 기준 추가
							,[INSTANCE_ID]
							,(SELECT TOP 1 FIF.[INSTANCE_TYPE]
								FROM  [FP_INSTANCE_FACTORY_M] FIF WITH(NOLOCK)
								WHERE FIF.[FACTORY_ID]  = BPH.[FACTORY_ID]
								AND   FIF.[INSTANCE_ID] = BPH.[INSTANCE_ID] )  AS INSTANCE_TYPE
							,BPH.UPDATE_ID
					FROM  [dbo].[FP_MPP_WPP_BASE_PLAN_H]  BPH WITH(NOLOCK)
					WHERE   BPH.[WO] = 'Y'  
					AND     BPH.PLAN_WEEK     = @P_PLAN_WEEK
					AND     BPH.PLAN_REVISION = @P_PLAN_REVISION )  WPH
					LEFT OUTER JOIN (SELECT ZZ.SITE_ID
											,ZZ.INSTANCE_ID
											,ZZ.INSTANCE_DATE
											,ZZ.RELEASE_PLAN_ID    AS PLAN_ID
											,ZZ.PLAN_GROUP_ID  -- 2017-11-04 kimcd plan group별 배포 조건 추가
											,ZZ.DIVISION_ID
											,ZZ.FACTORY_ID
											,ZZ.AMEND_PLAN_ID
											,ZZ.INSTANCE_TYPE
										FROM ( SELECT  B.SITE_ID
													,A.INSTANCE_ID
													,A.INSTANCE_DATE
													,A.DIVISION_ID
													,A.FACTORY_ID
													,A.PLAN_GROUP_ID  -- 2017-11-04 kimcd plan group별 배포 조건 추가
													,A.RELEASE_PLAN_ID
													,A.AMEND_PLAN_ID
													,B.INSTANCE_TYPE
													,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION         
													-- 2017-11-04 kimcd A.PLAN_GROUP_ID 를 PARTITION BY 절에 추가
												FROM    DBO.FP_RELEASE_PLAN_INFO_H  A WITH(NOLOCK)
													,  ( SELECT  FIF.INSTANCE_ID  -- kimcd 2017-08-29 한국 소형 조립 Pilot 추출
																,FIF.INSTANCE_TYPE
																,F.SITE_ID
																,F.FACTORY_ID
																,O.OPERATION_ID
																-- 2017-11-04 kimcd add plan group영향 수정 시작
																,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE F.FACTORY_ID END  AS LINK_FACTORY_ID 
																,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
														FROM     DBO.[FP_INSTANCE_FACTORY_M] FIF WITH(NOLOCK)     
																,DBO.SCM_FACTORY_M           F   WITH(NOLOCK)   
																,SCM_OPERATION_M             O   WITH(NOLOCK)
																,SCM_SYS_LOOKUP_VALUE        SLV WITH(NOLOCK)
																   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																   ON  MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																   AND MP.SEGMENT1 = SLV.SEGMENT1
																   AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
														WHERE FIF.FACTORY_ID    = F.FACTORY_ID
														AND   FIF.ACTIVE_FLAG   = 'Y'
														AND   FIF.ACTIVE_FLAG   = F.ACTIVE_FLAG     
														AND   FIF.INSTANCE_TYPE = O.INSTANCE_TYPE
														AND   F.COMPANY_ID      = O.COMPANY_ID
														AND   F.DIVISION_ID     = O.DIVISION_ID
														AND   F.SITE_ID         = O.SITE_ID
														AND   FIF.INSTANCE_ID  != 'KR_CELL_M' -- kimcd 2017-08-29 오창 소형 조립 제거
														AND   SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
														AND   SLV.SEGMENT1      = FIF.INSTANCE_ID
														-- 2017-11-04 kimcd add plan group영향 수정 끝
														) B      
												WHERE A.INSTANCE_ID   = B.INSTANCE_ID
												AND   A.FACTORY_ID    = B.LINK_FACTORY_ID -- 2017-11-04 kimcd plan group별 배보 대비하여 조건 수정 factory_id -> link_factory_id로 변경
												AND   A.PLAN_GROUP_ID = B.PLAN_GROUP_ID   -- 2017-11-04 kimcd plan group별 배포위해 조건 추가
											) ZZ       
										WHERE ZZ.NUMS = 1 ) RH
				ON   WPH.[SITE_ID]       =  RH.SITE_ID
				-- AND	 WPH.[DIVISION_ID]   =	RH.DIVISION_ID 2017-11-22 DIVISION ID가 안들어가서 조건 막음
				AND	 WPH.[FACTORY_ID]	 =	RH.FACTORY_ID
				AND  WPH.[PLAN_GROUP_ID] =  RH.PLAN_GROUP_ID  -- 2017-11-04 kimcd plan group별 배포 조건 추가
				AND	 WPH.[INSTANCE_TYPE] =	RH.INSTANCE_TYPE

		OPEN CUR_INSTANCE_ID;
		FETCH NEXT FROM CUR_INSTANCE_ID INTO @COMPANY_ID
											,@DIVISION_ID
											,@SITE_ID
											,@PLANT_ID
											,@LINK_FACTORY_ID  -- 2017-11-04 kimcd 제품 특성별 배포 대비하여 factory id 값을 link factory id로 변경
											,@PLAN_GROUP_ID    -- 2017-11-04 kimcd 제품 특성별 배포 변수 추가
											,@INSTANCE_ID
											,@INSTANCE_TYPE
											,@UPDATE_BY;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF @PLANT_ID NOT in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_MANUAL_WO_UPLOAD' AND SEGMENT1  = 'NK_PLANTS' AND ACTIVE_FLAG = 'Y')-- 2017-08-08 kimcd 남경 Plant 추가 kimcd 2017-08-19 오창 소형 Plant 추가 kimcd 2017-11-04 남경 조립 공장 추가 kimcd 2018-01-30 오창 자동차 확산
						BEGIN
							RAISERROR ('Error. Work Order Type is used only by A011, A041, 3050, G182, G183, G452 Plant. or A010 Pilot, Edge Tab Welding', -- Message text.
										16, -- Severity.
										1 -- State.
										);
						END;

					SELECT @PLAN_ID = CASE WHEN PLAN_ID = 'EMPTY' THEN
												 @INSTANCE_ID + '-' + CONVERT(NVARCHAR(8), @BASE_DATE, 112) + '-99'
											 ELSE
												 @INSTANCE_ID + '-' + CONVERT(NVARCHAR(8), @BASE_DATE, 112) + '-'
													+ REPLICATE ('0',2-LEN((CONVERT(NUMERIC, RIGHT((A.PLAN_ID), 2))-1))) + CAST ( (CONVERT(NUMERIC, RIGHT((A.PLAN_ID), 2))-1) AS NVARCHAR ) 
											 END
					FROM (	SELECT ISNULL(MIN(PLAN_ID), 'EMPTY') AS PLAN_ID
							FROM   SCM_FP_PLAN_H A
							WHERE  1=1
							AND    A.INSTANCE_ID = @INSTANCE_ID
							AND    A.PLAN_TYPE   = 'RELEASE'
							AND    CONVERT(NVARCHAR(8), A.PLAN_START_TIME, 112) = CONVERT(NVARCHAR(8), @BASE_DATE, 112)
							) A
      
					SET @N_CNT = 0

					SELECT  @N_CNT = COUNT(1)
					FROM    SCM_FP_PLAN_H
					WHERE   INSTANCE_ID = @INSTANCE_ID
					AND     PLAN_ID     = @PLAN_ID

					IF @N_CNT = 0
					BEGIN
						SET @v_temp1 = 'SCM_FP_PLAN_H'
        
						INSERT INTO SCM_FP_PLAN_H
							(	INSTANCE_ID
							  , PLAN_ID
							  , PLAN_TYPE
							  , SITE_ID
							  , PLAN_START_TIME
							  , PLAN_HORIZON
							  , DEMAND_HORIZON
							  , BASIS_PLAN_ID
							  ,	CONFIRM_ID
							  ,	CONFIRM_TIME
							  ,	CONFIRM_FLAG
							  , RELEASE_ID
							  , RELEASE_TIME
							  , RELEASE_FLAG
							  ,	DESCRIPTION
							  , INSERT_ID
							  , INSERT_TIME
							  , UPDATE_ID
							  , UPDATE_TIME
							)
						VALUES(@INSTANCE_ID
							  , @PLAN_ID       -- PLAN_ID
							  , 'RELEASE'      -- PLAN_TYPE
							  , @SITE_ID       -- SITE_ID
							  , @BASE_DATE     -- PLAN_START_TIME
							  , 56 -- PLAN_HORIZON
							  , 56 -- DEMAND_HORIZON
							  , @PLAN_ID       -- BASIS_PLAN_ID
							  , @UPDATE_BY     -- CONFIRM_ID
							  , GETDATE()
							  , 'Y'            -- CONFIRM_FLAG
							  , @UPDATE_BY     -- RELEASE_ID
							  , GETDATE()      -- RELEASE_TIME
							  , 'P'            -- RELEASE_FLAG
							  , 'P_PLAN_WEEK:' + @P_PLAN_WEEK + '-  P_PLAN_REVISION:'+ @P_PLAN_REVISION -- DESCRIPTION
							  , @v_proc_name
							  , GETDATE()
							  , @v_proc_name
							  , GETDATE() )
					END;
      
					SET @v_temp1 = 'SCM_FP_PLAN_DETAIL_H'

					SET @N_CNT = 0
					
					IF @PLAN_GROUP_ID = '-' -- 2017-11-04 kimcd plan group 기반 배포에 따른 로직 분기
						BEGIN
							SELECT  @N_CNT = COUNT(1)
							FROM    SCM_FP_PLAN_DETAIL_H
							WHERE   INSTANCE_ID      = @INSTANCE_ID
							AND     PLAN_DATE        = CONVERT(NVARCHAR(8), @BASE_DATE, 112)
							AND     FACTORY_ID       = @LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반 배포에 따른 변수명 변경 FACTORY_ID -> LINK_FACTORY_ID
							

							IF @N_CNT = 0
								BEGIN
									SET @v_temp1 = 'INSERT SCM_FP_PLAN_DETAIL_H'
        
									INSERT INTO SCM_FP_PLAN_DETAIL_H
										(  [PLAN_DATE]
										  ,[INSTANCE_ID]
										  ,[DIVISION_ID]
										  ,[FACTORY_ID]
										  ,[PLAN_ID]
										  ,[CONFIRM_ID]
										  ,[CONFIRM_TIME]
										  ,[CONFIRM_FLAG]
										  ,[RELEASE_TIME]
										  ,[RELEASE_FLAG]
										  ,[RELEASE_PLAN_ID]
										  ,[DESCRIPTION]
										  ,[INSERT_ID]
										  ,[INSERT_TIME]
										  ,[UPDATE_ID]
										  ,[UPDATE_TIME]
										)
									VALUES( CONVERT(NVARCHAR(8), @BASE_DATE, 112)  -- PLAN_DATE
										  ,	@INSTANCE_ID
										  , @DIVISION_ID
										  , @LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반 배포에 따른 변수 변경 FACTORY_ID -> LINK_FACTORY_ID
										  , @PLAN_ID       -- PLAN_ID
										  , @UPDATE_BY     -- CONFIRM_ID
										  , GETDATE()
										  , 'Y'            -- CONFIRM_FLAG
										  , GETDATE()      -- RELEASE_TIME
										  , 'P'            -- RELEASE_FLAG
										  , @PLAN_ID       -- [RELEASE_PLAN_ID]
										  , 'P_PLAN_WEEK:' + @P_PLAN_WEEK + '-  P_PLAN_REVISION:'+ @P_PLAN_REVISION -- DESCRIPTION
										  , @v_proc_name
										  , GETDATE()
										  , @v_proc_name
										  , GETDATE() )
								END;
							ELSE
								BEGIN
									SET @v_temp1 = 'UPDATE SCM_FP_PLAN_DETAIL_H'

									UPDATE SCM_FP_PLAN_DETAIL_H SET
										   PLAN_ID          = @PLAN_ID
										  ,CONFIRM_ID       = @UPDATE_BY
										  ,CONFIRM_TIME     = GETDATE() 
										  ,CONFIRM_FLAG     = 'Y'
										  ,RELEASE_TIME     = GETDATE() 
										  ,RELEASE_FLAG     = 'P'
										  ,RELEASE_PLAN_ID  = @PLAN_ID
										  ,DESCRIPTION      = 'P_PLAN_WEEK:' + @P_PLAN_WEEK + '-  P_PLAN_REVISION:'+ @P_PLAN_REVISION -- DESCRIPTION
									WHERE  INSTANCE_ID      = @INSTANCE_ID
									AND    PLAN_DATE        = CONVERT(NVARCHAR(8), @BASE_DATE, 112)
									AND    FACTORY_ID       = @LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반 배포에 따른 변수 변경 FACTORY_ID -> LINK_FACTORY_ID
								END;
						END;
					-- 2017-11-04 kimcd plan group 기반으로 배포할 경우 시작
					ELSE
						BEGIN
							SELECT  @N_CNT = COUNT(1)
							FROM    SCM_FP_PLAN_GROUP_DETAIL_H
							WHERE   INSTANCE_ID      = @INSTANCE_ID
							AND     PLAN_DATE        = CONVERT(NVARCHAR(8), @BASE_DATE, 112)
							AND     PLAN_GROUP_ID    = @PLAN_GROUP_ID

							IF @N_CNT = 0
								BEGIN
									SET @v_temp1 = 'INSERT SCM_FP_PLAN_GROUP_H'
        
									INSERT INTO SCM_FP_PLAN_GROUP_DETAIL_H
										(  [PLAN_DATE]
										  ,[INSTANCE_ID]
										  ,[PLAN_GROUP_ID]
										  ,[PLAN_ID]
										  ,[CONFIRM_ID]
										  ,[CONFIRM_TIME]
										  ,[CONFIRM_FLAG]
										  ,[RELEASE_TIME]
										  ,[RELEASE_FLAG]
										  ,[RELEASE_PLAN_ID]
										  ,[DESCRIPTION]
										  ,[INSERT_ID]
										  ,[INSERT_TIME]
										  ,[UPDATE_ID]
										  ,[UPDATE_TIME]
										)
									VALUES( CONVERT(NVARCHAR(8), @BASE_DATE, 112)  -- PLAN_DATE
										  ,	@INSTANCE_ID
										  , @PLAN_GROUP_ID
										  , @PLAN_ID       -- PLAN_ID
										  , @UPDATE_BY     -- CONFIRM_ID
										  , GETDATE()
										  , 'Y'            -- CONFIRM_FLAG
										  , GETDATE()      -- RELEASE_TIME
										  , 'P'            -- RELEASE_FLAG
										  , @PLAN_ID       -- [RELEASE_PLAN_ID]
										  , 'P_PLAN_WEEK:' + @P_PLAN_WEEK + '-  P_PLAN_REVISION:'+ @P_PLAN_REVISION -- DESCRIPTION
										  , @v_proc_name
										  , GETDATE()
										  , @v_proc_name
										  , GETDATE() )
								END;
							ELSE
								BEGIN
									SET @v_temp1 = 'UPDATE SCM_FP_PLAN_DETAIL_H'

									UPDATE SCM_FP_PLAN_GROUP_DETAIL_H SET
										   PLAN_ID          = @PLAN_ID
										  ,CONFIRM_ID       = @UPDATE_BY
										  ,CONFIRM_TIME     = GETDATE() 
										  ,CONFIRM_FLAG     = 'Y'
										  ,RELEASE_TIME     = GETDATE() 
										  ,RELEASE_FLAG     = 'P'
										  ,RELEASE_PLAN_ID  = @PLAN_ID
										  ,DESCRIPTION      = 'P_PLAN_WEEK:' + @P_PLAN_WEEK + '-  P_PLAN_REVISION:'+ @P_PLAN_REVISION -- DESCRIPTION
									WHERE  INSTANCE_ID      = @INSTANCE_ID
									AND    PLAN_DATE        = CONVERT(NVARCHAR(8), @BASE_DATE, 112)
									AND    PLAN_GROUP_ID    = @PLAN_GROUP_ID
								END;
						END;
					-- 2017-11-04 kimcd plan group 기반으로 배포할 경우 끝

					SET @v_temp1 = 'INSERT @PLAN_ID_TEMP_TABLE'
					INSERT INTO @PLAN_ID_TEMP_TABLE
							(	COMPANY_ID,
								DIVISION_ID,
								SITE_ID,
								PLANT_ID,
								LINK_FACTORY_ID,  -- 2017-11-04 kimcd plan group id 배포로 factory_id에서 link_factory_id로 변경
								PLAN_GROUP_ID,    -- 2017-11-04 kimcd plan group id 배포로 제품 특성 추가
								INSTANCE_ID,
								INSTANCE_TYPE,
								UPDATE_BY,
								PLAN_ID,
								PLAN_WEEK,
								PLAN_REVISION )
					VALUES ( @COMPANY_ID
							,@DIVISION_ID
							,@SITE_ID
							,@PLANT_ID
							,@LINK_FACTORY_ID     -- 2017-11-04 kimcd plan group id 배포로 factory_id에서 link_factory_id로 변경
							,@PLAN_GROUP_ID       -- 2017-11-04 kimcd plan group id 배포로 제품 특성 추가
							,@INSTANCE_ID
							,@INSTANCE_TYPE
							,@UPDATE_BY
							,@PLAN_ID
							,@P_PLAN_WEEK
							,@P_PLAN_REVISION
							)

					FETCH NEXT FROM CUR_INSTANCE_ID INTO @COMPANY_ID
														,@DIVISION_ID
														,@SITE_ID
														,@PLANT_ID
														,@LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group id 배포로 factory_id에서 link_factory_id로 변경
														,@PLAN_GROUP_ID    -- 2017-11-04 kimcd plan group id 배포로 제품 특성 추가
														,@INSTANCE_ID
														,@INSTANCE_TYPE
														,@UPDATE_BY;

				END;
			
			CLOSE CUR_INSTANCE_ID;
			DEALLOCATE CUR_INSTANCE_ID;  

			SET @n_row_count = 1
              
			--LOG 생성
			SET @v_message = @n_row_count
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null
		END;

	--COMMIT TRANSACTION;
    END TRY

	BEGIN CATCH
		--ROLLBACK
		--ROLLBACK TRANSACTION;

		SET @v_descr = ERROR_MESSAGE()

	    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

		-- commit; 2018-12-21 kimcd 불필요한 commit 제거
	END CATCH

	BEGIN TRY				
	--BEGIN TRANSACTION;
		-- ================================================
		-- 로직 추가
		-- ================================================
		BEGIN
			SET @v_temp1 = 'DELETE OLD DATA'
			DELETE	FROM  [DBO].[FP_MANUAL_WORK_ORDER_H]
			WHERE  [CUTOFF_DATE]   = @BASE_DATE
			AND    [PLAN_WEEK]     = @P_PLAN_WEEK
			AND    [PLAN_REVISION] = @P_PLAN_REVISION
			AND    [PLAN_TYPE]     = 'UPLOAD';

			--2018-02-11 최종 배포된 plan 찾기
			IF @PLAN_GROUP_ID = '-' 
				SELECT @LAST_PLAN_ID = PLAN_ID, @LAST_PLAN_TYPE = PLAN_TYPE
				FROM ( SELECT H.PLAN_ID, H.PLAN_TYPE
							 ,ROW_NUMBER() OVER( PARTITION BY H.CUTOFF_DATE ORDER BY H.INSERT_TIME DESC ) AS NUM
					   FROM   [FP_MANUAL_WORK_ORDER_H] H
							 ,@PLAN_ID_TEMP_TABLE PTT
					   WHERE  H.CUTOFF_DATE   = @BASE_DATE
					   AND    H.COMPANY_ID  = PTT.COMPANY_ID
					   AND    H.DIVISION_ID = PTT.DIVISION_ID
					   AND    H.PLANT_ID    = PTT.PLANT_ID
					   AND    H.FACTORY_ID  = PTT.LINK_FACTORY_ID
					   AND    H.INSTANCE_ID = PTT.INSTANCE_ID
					   ) AA
				WHERE NUM = 1
			ELSE
				SELECT @LAST_PLAN_ID = PLAN_ID, @LAST_PLAN_TYPE = PLAN_TYPE
				FROM ( SELECT H.PLAN_ID, H.PLAN_TYPE
							 ,ROW_NUMBER() OVER( PARTITION BY H.CUTOFF_DATE ORDER BY H.INSERT_TIME DESC ) AS NUM
					   FROM   [FP_MANUAL_WORK_ORDER_H] H
							 ,[SCM_LINE_M]             L WITH(NOLOCK)
							 ,@PLAN_ID_TEMP_TABLE PTT
					   WHERE H.CUTOFF_DATE  = @BASE_DATE
					   AND   H.COMPANY_ID   = L.COMPANY_ID
					   AND   H.DIVISION_ID  = L.DIVISION_ID
					   AND   H.SITE_ID      = L.SITE_ID
					   AND   H.PLANT_ID     = L.PLANT_ID
					   AND   H.FACTORY_ID   = L.FACTORY_ID
					   AND   H.LINE_ID      = L.LINE_ID
					   AND   H.OPERATION_ID = L.OPERATION_ID
					   AND   H.COMPANY_ID   = PTT.COMPANY_ID
					   AND   H.DIVISION_ID  = PTT.DIVISION_ID
					   AND   H.PLANT_ID     = PTT.PLANT_ID
					   AND   L.MODEL_TYPE   = PTT.PLAN_GROUP_ID
					   AND   H.INSTANCE_ID  = PTT.INSTANCE_ID
					   ) AA
				WHERE NUM = 1


			SET @v_temp1 = '@TEMP_TABLE'
			INSERT INTO   @TEMP_TABLE
				(	[CUTOFF_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[PLAN_WEEK],
					[PLAN_REVISION],
					[INSTANCE_ID],
					[PLAN_ID],
					[PRODUCTION_TYPE],
					[WORK_ORDER_SPL_ID],
					[WORK_ORDER_ID],
					[ITEM_ID],
					[OPERATION_ID],
					[LINE_ID],
					[EQUIPMENT_ID],
					[MARKET], -- kimcd 2017-11-04 남경 수출/내수 구분 추가
					[PLAN_DATE],
					[REMAIN_QTY],
					[ACTUAL_QTY],
					[ACCUM_PLAN_QTY],
					[ROW_SEQ],
					[FIXED_YN])
			SELECT   @BASE_DATE -- [CUTOFF_DATE]
					,WBP.[COMPANY_ID]
					,WBP.[DIVISION_ID]
					,WBP.[SITE_ID]
					,WBP.[PLANT_ID]
					,WBP.[FACTORY_ID]
					,WBP.[PLAN_WEEK]
					,WBP.[PLAN_REVISION]
					,WBP.[INSTANCE_ID]
					,WBP.[PLAN_ID]
					,WBP.[PRODUCTION_TYPE]
					,MWO.[WORK_ORDER_SPL_ID]
					,MWO.[WORK_ORDER_ID]
					,WBP.[ITEM_ID]
					,WBP.[OPERATION_ID]
					,WBP.[LINE_ID]
					,WBP.[EQUIPMENT_ID]
					,WBP.[MARKET]  -- kimcd 2017-11-04 남경 수출/내수 구분 추가
					,WBP.[PLAN_DATE]
					,MWO.[REMAIN_QTY]
					,MWO.[ACTUAL_QTY]
					,WBP.PLAN_QTY - SUM(ISNULL(MWO.REMAIN_QTY,0)) OVER ( PARTITION BY	WBP.[FACTORY_ID], WBP.[PRODUCTION_TYPE], WBP.[ITEM_ID], WBP.[OPERATION_ID], WBP.[LINE_ID], WBP.[EQUIPMENT_ID],WBP.[MARKET], WBP.[PLAN_DATE] -- kimcd 2017-11-04 남경 수출/내수 구분자 추가
																		ORDER BY MWO.[ACTUAL_QTY] DESC, MWO.[BASE_PLAN_START_TIME], MWO.[WORK_ORDER_SPL_ID] ) AS ACCUM_PLAN_QTY
					,ROW_NUMBER()  OVER ( PARTITION BY	WBP.[FACTORY_ID], WBP.[PRODUCTION_TYPE], WBP.[ITEM_ID], WBP.[OPERATION_ID], WBP.[LINE_ID], WBP.[EQUIPMENT_ID], WBP.[MARKET], WBP.[PLAN_DATE] -- kimcd 2017-11-04 남경 수출/내수 구분자 추가
										  ORDER BY MWO.[ACTUAL_QTY] DESC, MWO.[BASE_PLAN_START_TIME], MWO.[WORK_ORDER_SPL_ID] ) AS ROW_SEQ
					,MWO.[FIXED_YN]
			FROM   ( SELECT  MAX(WBP.[COMPANY_ID])   AS [COMPANY_ID]
							,MAX(WBP.[DIVISION_ID])  AS [DIVISION_ID]
							,MAX(WBP.[SITE_ID])      AS [SITE_ID]
							,MAX(WBP.[PLANT_ID])     AS [PLANT_ID]
							,WBP.[FACTORY_ID]
							,WBP.[PLAN_WEEK]
							,WBP.[PLAN_REVISION]
							,MO.[INSTANCE_ID]
							,MO.[PLAN_ID]
							,CASE WHEN WBP.[PRODUCTION_TYPE] = 'S-TEST' THEN 'TEST' ELSE WBP.[PRODUCTION_TYPE] END  AS [PRODUCTION_TYPE]  -- 2019-06-04 kimcd S-TEST 제거 위해 CASE 도입하고 GROUP BY 추가
							,WBP.[ITEM_ID]
							,WBP.[OPERATION_ID]
							,WBP.[LINE_ID]
							,CASE WHEN WBP.[EQUIPMENT_ID] IS NULL OR WBP.[EQUIPMENT_ID] = '' THEN '-' ELSE WBP.[EQUIPMENT_ID] END AS EQUIPMENT_ID -- 2022-07-13 kimcd 설비 정보 없어도 WO 형성할 수 있도록 로직 수정
							,WBP.[MARKET] -- kimcd 2017-11-04 수출/내수 구분 추가
							,WBP.[PLAN_DATE]
							,SUM(WBP.[PLAN_QTY])     AS [PLAN_QTY]
					FROM   @PLAN_ID_TEMP_TABLE  MO
						 ,[DBO].[FP_MPP_WPP_BASE_PLAN_M]  WBP WITH(NOLOCK)
					WHERE  MO.[COMPANY_ID]      = WBP.[COMPANY_ID]
					AND    MO.[DIVISION_ID]     = WBP.[DIVISION_ID]
					AND    MO.[SITE_ID]         = WBP.[SITE_ID]
					AND    MO.[PLANT_ID]        = WBP.[PLANT_ID]
					-- AND    MO.[FACTORY_ID]      = WBP.[FACTORY_ID] 2017-11-04 kimcd 조건 제거. plan group id로 배포할 경우 대비
					AND    MO.[PLAN_WEEK]       = WBP.[PLAN_WEEK]
					AND    MO.[PLAN_REVISION]   = WBP.[PLAN_REVISION]
					GROUP BY WBP.[FACTORY_ID]  -- 2019-06-04 kimcd S-TEST 제거 위해 CASE 도입하고 GROUP BY 추가
							,WBP.[PLAN_WEEK]
							,WBP.[PLAN_REVISION]
							,MO.[INSTANCE_ID]
							,MO.[PLAN_ID]
							,CASE WHEN WBP.[PRODUCTION_TYPE] = 'S-TEST' THEN 'TEST' ELSE WBP.[PRODUCTION_TYPE] END
							,WBP.[ITEM_ID]
							,WBP.[OPERATION_ID]
							,WBP.[LINE_ID]
							,CASE WHEN WBP.[EQUIPMENT_ID] IS NULL OR WBP.[EQUIPMENT_ID] = '' THEN '-' ELSE WBP.[EQUIPMENT_ID] END -- 2022-07-13 kimcd 설비 정보 없어도 WO 형성할 수 있도록 로직 수정
							,WBP.[MARKET] -- kimcd 2017-11-04 수출/내수 구분 추가
							,WBP.[PLAN_DATE] ) WBP
					LEFT OUTER JOIN [DBO].[FP_MANUAL_WORK_ORDER_H]  MWO WITH(NOLOCK)
					ON  WBP.[FACTORY_ID]      = MWO.[FACTORY_ID]
					AND WBP.[PRODUCTION_TYPE] = MWO.[PRODUCTION_TYPE]
					AND WBP.[ITEM_ID]         = MWO.[ITEM_ID]
					AND WBP.[OPERATION_ID]    = MWO.[OPERATION_ID]
					AND WBP.[LINE_ID]         = MWO.[LINE_ID]
					AND WBP.[EQUIPMENT_ID]    = MWO.[EQUIPMENT_ID]
					AND WBP.[MARKET]          = MWO.[MARKET]  -- kimcd 2017-11-04 남경 수출/내수 구분자 추가
					AND WBP.[PLAN_DATE]       = MWO.[PLAN_DATE]
					AND MWO.[CUTOFF_DATE]     = @BASE_DATE
					-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 시작
					AND MWO.PLAN_ID           = @LAST_PLAN_ID
					AND MWO.[PLAN_TYPE]       = @LAST_PLAN_TYPE
					-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 종료

			SET @n_row_count = @@ROWCOUNT

			SET @v_temp1 = 'FP_MANUAL_WORK_ORDER_H'
			INSERT INTO [FP_MANUAL_WORK_ORDER_H]
					(  [COMPANY_ID]
					  ,[DIVISION_ID]
					  ,[SITE_ID]
					  ,[PLANT_ID]
					  ,[FACTORY_ID]
					  ,[PLAN_WEEK]
					  ,[PLAN_REVISION]
					  ,[INSTANCE_ID]
					  ,[PLAN_ID]
					  ,[CUTOFF_DATE]
					  ,[WORK_ORDER_SPL_ID]
					  ,[WORK_ORDER_ID]
					  ,[DEMAND_ID]
					  ,[PRODUCTION_TYPE]
					  ,[ORDER_TYPE]
					  ,[ITEM_ID]
					  ,[TOP_ITEM_ID]
					  ,[OPERATION_ID]
					  ,[LINE_ID]
					  ,[ELECTRODE_TYPE]
					  ,[EQUIPMENT_ID]
					  ,[PLAN_DATE]
					  ,[PLAN_START_TIME]
					  ,[PLAN_END_TIME]
					  ,[REMAIN_QTY]
					  ,[REMAIN_IN_QTY]
					  ,[BASE_PLAN_START_TIME]
					  ,[ACTUAL_QTY]
					  ,[RUNNING_FLAG]
					  ,[WO_STATUS]
					  ,[MARKET]
					  ,[LANE_QTY]
					  ,[BATCH_ORDER_ID]
					  ,[ROLLING_PLAN_DATE]
					  ,[INSERT_ID]
					  ,[INSERT_TIME]
					  ,[UPDATE_ID]
					  ,[UPDATE_TIME]
					  ,[PLAN_TYPE]
					  ,[FIXED_YN])
			SELECT TT.[COMPANY_ID]
				  ,TT.[DIVISION_ID]
				  ,TT.[SITE_ID]
				  ,TT.[PLANT_ID]
				  ,TT.[FACTORY_ID]
				  ,TT.[PLAN_WEEK]
				  ,TT.[PLAN_REVISION]
				  ,TT.[INSTANCE_ID]
				  ,TT.[PLAN_ID]
				  ,TT.[CUTOFF_DATE]
				  ,ISNULL( TT.[WORK_ORDER_SPL_ID], 'NEW_U_'+ CONVERT(NVARCHAR(5), ROW_NUMBER() OVER (ORDER BY TT.[PLAN_DATE], TT.[EQUIPMENT_ID], TT.MARKET, TT.[ROW_SEQ])))  -- 2017-11-04 kimcd market 추가
				  ,ISNULL( TT.[WORK_ORDER_ID], 'NEW_U_'+ CONVERT(NVARCHAR(5), ROW_NUMBER() OVER (ORDER BY TT.[PLAN_DATE], TT.[EQUIPMENT_ID], TT.MARKET, TT.[ROW_SEQ])))      -- 2017-11-04 kimcd market 추가
				  ,'MANUAL_DEMAND' -- [DEMAND_ID]
				  ,TT.[PRODUCTION_TYPE]
				  ,CASE WHEN SOM.WO_FLAG = 'Y' THEN 'WO' WHEN SOM.MO_FLAG = 'Y' THEN 'MO' END  -- [ORDER_TYPE]
				  ,TT.[ITEM_ID]
				  ,TT.[ITEM_ID] -- [TOP_ITEM_ID]
				  ,TT.[OPERATION_ID]
				  ,TT.[LINE_ID]
				  ,NULL -- [ELECTRODE_TYPE]
				  ,TT.[EQUIPMENT_ID]
				  ,TT.[PLAN_DATE]
				  ,CONVERT ( DATETIME, CONVERT( NVARCHAR(10), TT.PLAN_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + SUBSTRING(STL.SEGMENT2, 3,2) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120)
				  ,CONVERT ( DATETIME, CONVERT( NVARCHAR(10), TT.PLAN_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + SUBSTRING(STL.SEGMENT2, 3,2) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120) + 1
				  ,CASE WHEN TT.[ACCUM_PLAN_QTY] < 0  THEN 
						CASE WHEN TT.[ACCUM_PLAN_QTY] + TT.[REMAIN_QTY] > 0 THEN
							TT.[ACCUM_PLAN_QTY] + TT.[REMAIN_QTY]
						ELSE
							0
						END
				  WHEN ROW_NUMBER() OVER ( PARTITION BY	TT.[FACTORY_ID], TT.[PRODUCTION_TYPE], TT.[ITEM_ID], TT.[OPERATION_ID], TT.[LINE_ID], TT.[EQUIPMENT_ID], TT.[MARKET], TT.[PLAN_DATE]  -- 2017-11-04 kimcd market 추가
										   ORDER BY TT.[ROW_SEQ]) = MAX(TT.[ROW_SEQ])  OVER ( PARTITION BY	TT.[FACTORY_ID], TT.[PRODUCTION_TYPE], TT.[ITEM_ID], TT.[OPERATION_ID], TT.[LINE_ID], TT.[EQUIPMENT_ID], TT.[MARKET], TT.[PLAN_DATE]  -- 2017-11-04 kimcd market 추가
																							  ) THEN
						ISNULL(TT.[REMAIN_QTY],0) + TT.[ACCUM_PLAN_QTY]
				  ELSE
					   TT.[REMAIN_QTY]
				  END   --[REMAIN_QTY]
				  ,(CASE WHEN TT.[ACCUM_PLAN_QTY] < 0  THEN 
						CASE WHEN TT.[ACCUM_PLAN_QTY] + TT.[REMAIN_QTY] > 0 THEN
							TT.[ACCUM_PLAN_QTY] + TT.[REMAIN_QTY]
						ELSE
							0
						END
				  WHEN ROW_NUMBER() OVER ( PARTITION BY	TT.[FACTORY_ID], TT.[PRODUCTION_TYPE], TT.[ITEM_ID], TT.[OPERATION_ID], TT.[LINE_ID], TT.[EQUIPMENT_ID], TT.[MARKET], TT.[PLAN_DATE]  -- 2017-11-04 kimcd market 추가
										   ORDER BY TT.[ROW_SEQ]) = MAX(TT.[ROW_SEQ])  OVER ( PARTITION BY	TT.[FACTORY_ID], TT.[PRODUCTION_TYPE], TT.[ITEM_ID], TT.[OPERATION_ID], TT.[LINE_ID], TT.[EQUIPMENT_ID], TT.[MARKET], TT.[PLAN_DATE]  -- 2017-11-04 kimcd market 추가
																							  )  THEN
						ISNULL(TT.[REMAIN_QTY],0) + TT.[ACCUM_PLAN_QTY]
				  ELSE
					   TT.[REMAIN_QTY]
				  END) * ( CASE WHEN SY.YIELD = 0 THEN 1 ELSE ISNULL( 1/SY.YIELD, 1) END)  [REMAIN_IN_QTY]
				  ,NULL -- [BASE_PLAN_START_TIME]
				  ,ISNULL(TT.ACTUAL_QTY,0) -- [ACTUAL_QTY]
				  ,'-' -- [RUNNING_FLAG]
				  ,'OPEN' -- [WO_STATUS]
				  --,'D' -- [MARKET]
				  ,TT.[MARKET] -- kimcd 2017-11-04 남경 수출/내수 구분자 추가
				  , (SELECT TOP 1 ILM.[LANE_QTY]
					 FROM   [dbo].[SCM_ITEM_LANE_M]  ILM WITH(NOLOCK)
					 WHERE  ILM.[COMPANY_ID]  = TT.[COMPANY_ID]
					 AND	ILM.[DIVISION_ID] = TT.[DIVISION_ID]
					 AND	ILM.[SITE_ID]     = TT.[SITE_ID]
					 AND	ILM.[PLANT_ID]    = TT.[PLANT_ID]
					 AND	ILM.[ITEM_ID]     = TT.[ITEM_ID]
					 AND	ILM.[FACTORY_ID]  = TT.[FACTORY_ID]
					 ORDER  BY LANE_QTY DESC) -- [LANE_QTY]
				  ,NULL       --[BATCH_ORDER_ID]
				  ,NULL       -- [ROLLING_PLAN_DATE]
				  ,@UPDATE_BY -- [INSERT_ID]
				  ,GETDATE()  -- [INSERT_TIME]
				  ,@UPDATE_BY -- [UPDATE_ID]
				  ,GETDATE()  -- [UPDATE_TIME]
				  ,'UPLOAD'   -- [PLAN_TYPE]
				  ,CASE WHEN TT.[WORK_ORDER_ID] LIKE 'NEW%' THEN 'N' WHEN TT.[WORK_ORDER_ID] IS NULL THEN 'N' ELSE 'Y' END  -- AND    MWO.[WORK_ORDER_SPL_ID] NOT LIKE 'NEW%'
			FROM     @TEMP_TABLE   TT
					LEFT OUTER JOIN DBO.SCM_YIELD_M SY WITH(NOLOCK)
					ON  TT.[COMPANY_ID]   = SY.[COMPANY_ID]
					AND TT.[DIVISION_ID]  = SY.[DIVISION_ID]
					AND TT.[SITE_ID]      = SY.[SITE_ID]
					AND TT.[PLANT_ID]     = SY.[PLANT_ID]
					AND TT.[FACTORY_ID]   = SY.[FACTORY_ID]
					AND TT.[OPERATION_ID] = SY.[OPERATION_ID]
					AND TT.[LINE_ID]      = SY.[LINE_ID]
					AND TT.[ITEM_ID]      = SY.[ITEM_ID]
					AND SUBSTRING(CONVERT(NVARCHAR(20), TT.PLAN_DATE, 112) ,1, 6) = SY.[MONTH]
					,DBO.SCM_OPERATION_M       SOM WITH(NOLOCK)
					,DBO.SCM_SYS_LOOKUP_VALUE  STL WITH(NOLOCK)
			WHERE  STL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
			AND    STL.SEGMENT1         = TT.PLANT_ID
			AND    STL.ACTIVE_FLAG      = 'Y'
			AND    TT.COMPANY_ID        = SOM.COMPANY_ID
			AND    TT.DIVISION_ID       = SOM.DIVISION_ID
			AND    TT.SITE_ID           = SOM.SITE_ID
			AND    TT.OPERATION_ID      = SOM.OPERATION_ID;

			SET @n_row_count = @n_row_count + @@ROWCOUNT
			SET @v_temp1 = 'CLEAR FP_MANUAL_WORK_ORDER_H'
			INSERT INTO [FP_MANUAL_WORK_ORDER_H]
					(  [COMPANY_ID]
					  ,[DIVISION_ID]
					  ,[SITE_ID]
					  ,[PLANT_ID]
					  ,[FACTORY_ID]
					  ,[PLAN_WEEK]
					  ,[PLAN_REVISION]
					  ,[INSTANCE_ID]
					  ,[PLAN_ID]
					  ,[CUTOFF_DATE]
					  ,[WORK_ORDER_SPL_ID]
					  ,[WORK_ORDER_ID]
					  ,[DEMAND_ID]
					  ,[PRODUCTION_TYPE]
					  ,[ORDER_TYPE]
					  ,[ITEM_ID]
					  ,[TOP_ITEM_ID]
					  ,[OPERATION_ID]
					  ,[LINE_ID]
					  ,[ELECTRODE_TYPE]
					  ,[EQUIPMENT_ID]
					  ,[PLAN_DATE]
					  ,[PLAN_START_TIME]
					  ,[PLAN_END_TIME]
					  ,[REMAIN_QTY]
					  ,[REMAIN_IN_QTY]
					  ,[BASE_PLAN_START_TIME]
					  ,[ACTUAL_QTY]
					  ,[RUNNING_FLAG]
					  ,[WO_STATUS]
					  ,[MARKET]
					  ,[LANE_QTY]
					  ,[BATCH_ORDER_ID]
					  ,[ROLLING_PLAN_DATE]
					  ,[INSERT_ID]
					  ,[INSERT_TIME]
					  ,[UPDATE_ID]
					  ,[UPDATE_TIME]
					  ,[PLAN_TYPE]
					  ,[FIXED_YN])
			SELECT MWO.[COMPANY_ID]
				  ,MWO.[DIVISION_ID]
				  ,MWO.[SITE_ID]
				  ,MWO.[PLANT_ID]
				  ,MWO.[FACTORY_ID]
				  ,MO.[PLAN_WEEK]
				  ,MO.[PLAN_REVISION]
				  ,MO.[INSTANCE_ID]
				  ,MO.[PLAN_ID]
				  ,MWO.[CUTOFF_DATE]
				  ,MWO.[WORK_ORDER_SPL_ID]
				  ,MWO.[WORK_ORDER_ID]
				  ,MWO.[DEMAND_ID]
				  ,MWO.[PRODUCTION_TYPE]
				  ,MWO.[ORDER_TYPE]
				  ,MWO.[ITEM_ID]
				  ,MWO.[TOP_ITEM_ID]
				  ,MWO.[OPERATION_ID]
				  ,MWO.[LINE_ID]
				  ,NULL -- [ELECTRODE_TYPE]
				  ,MWO.[EQUIPMENT_ID]
				  ,MWO.[PLAN_DATE]
				  ,MWO.[PLAN_START_TIME]
				  ,MWO.[PLAN_END_TIME]
				  ,0 	  --[REMAIN_QTY]
				  ,0      --[REMAIN_IN_QTY]
				  ,MWO.[BASE_PLAN_START_TIME]
				  ,ISNULL(MWO.ACTUAL_QTY,0) -- [ACTUAL_QTY]
				  ,MWO.[RUNNING_FLAG]
				  ,MWO.[WO_STATUS]
				  ,MWO.[MARKET]
				  ,MWO.[LANE_QTY]
				  ,MWO.[BATCH_ORDER_ID]
				  ,MWO.[ROLLING_PLAN_DATE]
				  ,@UPDATE_BY -- [INSERT_ID]
				  ,GETDATE()  -- [INSERT_TIME]
				  ,@UPDATE_BY -- [UPDATE_ID]
				  ,GETDATE()  -- [UPDATE_TIME]
				  ,'UPLOAD'   -- [PLAN_TYPE]
				  ,'Y' -- MWO.[FIXED_YN]  2018-02-11  kimcd 취소 정보는 모두 FIX로 넣음
			FROM   @PLAN_ID_TEMP_TABLE  MO
				  ,[DBO].[FP_MANUAL_WORK_ORDER_H]  MWO WITH(NOLOCK)
			WHERE  MO.[COMPANY_ID]      = MWO.[COMPANY_ID]
			AND    MO.[DIVISION_ID]     = MWO.[DIVISION_ID]
			AND    MO.[SITE_ID]         = MWO.[SITE_ID]
			AND    MO.[PLANT_ID]        = MWO.[PLANT_ID]
			-- AND    MO.[FACTORY_ID]      = MWO.[FACTORY_ID] 2017-11-04 kimcd 제품 특성별 배포에 따른 공장 동 정보 미상용으로 조건 제외
			AND    MO.[INSTANCE_ID]     = MWO.[INSTANCE_ID] -- kimcd 2017-08-19 A2000, A3000, F6200 공정별 계획 구분하기 위해 INSTANCE_ID 추가
			-- kimcd 2017-11-04 주석 처리 대상 목록에서 제외 대상 조건으로 수정 AND    MWO.[OPERATION_ID]  IN ('A2000', 'A3000', 'F6200', 'E2000') -- kimcd 2017-08-19 공정 추가. Pilot, 활성화 tab, A2000, A3000, F6200
			AND    MWO.[OPERATION_ID] NOT IN ('E1000', 'E2500') -- kimcd 2017-11-04 남경 전극 전 공정의 제외 대상만 제외함.
			AND    MWO.[CUTOFF_DATE]    = @BASE_DATE
			-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 시작
			AND    MWO.PLAN_ID		    = @LAST_PLAN_ID
			AND    MWO.[PLAN_TYPE]      = @LAST_PLAN_TYPE
			-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 종료
			AND    MWO.[WORK_ORDER_SPL_ID] NOT LIKE 'NEW%'
			-- 2017-11-04  kimcd 동일 동이거나 동일 plan group인 경우만 취소 시작
			AND    EXISTS ( SELECT 1
			                FROM   SCM_LINE_M SL WITH(NOLOCK)
							WHERE  SL.FACTORY_ID   = MWO.FACTORY_ID
							AND    SL.LINE_ID      = MWO.LINE_ID
							AND    SL.OPERATION_ID = MWO.OPERATION_ID
							AND    SL.FACTORY_ID   = CASE WHEN MO.LINK_FACTORY_ID = '-' THEN SL.FACTORY_ID ELSE MO.LINK_FACTORY_ID END
							AND    SL.MODEL_TYPE   = CASE WHEN MO.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE MO.PLAN_GROUP_ID END )
			-- 2017-11-04  kimcd 동일 동이거나 동일 plan group인 경우만 취소 끝
			-- 2017-11-04  kimcd site division기준으로 active한 공정만 취소 시작
			AND    EXISTS ( SELECT 1
			                FROM   SCM_OPERATION_M SO WITH(NOLOCK)
							WHERE  SO.[COMPANY_ID]   = MWO.[COMPANY_ID]
							AND    SO.[DIVISION_ID]  = MWO.[DIVISION_ID]
							AND    SO.[SITE_ID]      = MWO.[SITE_ID]
							AND    SO.[OPERATION_ID] = MWO.[OPERATION_ID]
							AND    SO.[ACTIVE_FLAG]  = 'Y' )
			-- 2017-11-04  kimcd site division기준으로 active한 공정만 취소 끝
			AND    NOT EXISTS (SELECT 1 
							   FROM  [DBO].[FP_MANUAL_WORK_ORDER_H] CMW WITH(NOLOCK)
							   WHERE CMW.[CUTOFF_DATE]   = @BASE_DATE
							   AND   CMW.[PLAN_WEEK]     = MO.[PLAN_WEEK]
							   AND   CMW.[PLAN_REVISION] = MO.[PLAN_REVISION]
							   -- AND   CMW.[FACTORY_ID]    = MO.[FACTORY_ID] 2017-11-04 kimcd plan group별 배포에 따른 Factory 조건 제거
							   AND   CMW.[WORK_ORDER_SPL_ID] = MWO.[WORK_ORDER_SPL_ID]
							   AND   CMW.[INSTANCE_ID]   = MO.[INSTANCE_ID]
							   AND   CMW.[PLAN_ID]       = MO.[PLAN_ID]
							   AND   CMW.[PLAN_TYPE]     = 'UPLOAD')

			SET @v_temp1 = 'E2500 SCM_FP_PLAN_DETAIL_H'
			INSERT INTO [FP_MANUAL_WORK_ORDER_H]
					(  [COMPANY_ID]
					  ,[DIVISION_ID]
					  ,[SITE_ID]
					  ,[PLANT_ID]
					  ,[FACTORY_ID]
					  ,[PLAN_WEEK]
					  ,[PLAN_REVISION]
					  ,[INSTANCE_ID]
					  ,[PLAN_ID]
					  ,[CUTOFF_DATE]
					  ,[WORK_ORDER_SPL_ID]
					  ,[WORK_ORDER_ID]
					  ,[DEMAND_ID]
					  ,[PRODUCTION_TYPE]
					  ,[ORDER_TYPE]
					  ,[ITEM_ID]
					  ,[TOP_ITEM_ID]
					  ,[OPERATION_ID]
					  ,[LINE_ID]
					  ,[EQUIPMENT_ID]
					  ,[PLAN_DATE]
					  ,[PLAN_START_TIME]
					  ,[PLAN_END_TIME]
					  ,[REMAIN_QTY]
					  ,[REMAIN_IN_QTY]
					  ,[ACTUAL_QTY]
					  ,[RUNNING_FLAG]
					  ,[WO_STATUS]
					  ,[MARKET]
					  ,[LANE_QTY]
					  ,[INSERT_ID]
					  ,[INSERT_TIME]
					  ,[UPDATE_ID]
					  ,[UPDATE_TIME]
					  ,[PLAN_TYPE]
					  ,[FIXED_YN])
			SELECT   XXX.[COMPANY_ID]
					,XXX.[DIVISION_ID]
					,XXX.[SITE_ID]
					,XXX.[PLANT_ID]
					,XXX.[FACTORY_ID]
					,XXX.[PLAN_WEEK]
					,XXX.[PLAN_REVISION]
					,XXX.[INSTANCE_ID]
					,XXX.[PLAN_ID]
					,XXX.[CUTOFF_DATE]
					,'NEW_H_'+ CONVERT(NVARCHAR(5), ROW_NUMBER() OVER (ORDER BY XXX.[PLAN_DATE], XXX.[ITEM_ID], EM.EQUIPMENT_ID))
					,'NEW_H_'+ CONVERT(NVARCHAR(5), ROW_NUMBER() OVER (ORDER BY XXX.[PLAN_DATE], XXX.[ITEM_ID], EM.EQUIPMENT_ID)) 
					,'MANUAL_DEMAND' AS DEMAND_ID
					,XXX.[PRODUCTION_TYPE]
					,'M0' [ORDER_TYPE]
					,XXX.[ITEM_ID]
					,XXX.[TOP_ITEM_ID]
					,XXX.[OPERATION_ID]
					--,ILA.[LINE_ID]  2018-03-06 kimcd item line assign 검증 제거
					,EM.[LINE_ID]  --  2018-03-06 kimcd item line assign 검증 제거
					,EM.[EQUIPMENT_ID]
					,XXX.[PLAN_DATE]
					,XXX.[PLAN_START_TIME]
					,XXX.[PLAN_END_TIME]
					,XXX.[REMAIN_QTY]
					,XXX.[REMAIN_QTY]          AS REMAIN_IN_QTY
					,0    AS ACTUAL_QTY
					,'-' -- [RUNNING_FLAG]
					,'OPEN' -- [WO_STATUS]
					,'D' -- [MARKET]          2017-11-04 kimcd 수출/내수 구분 기본 값을 E로 통일
					, (SELECT TOP 1 ILM.[MAIN_LANE_QTY]
						FROM   [dbo].[SCM_ITEM_LANE_M]  ILM WITH(NOLOCK)
						WHERE  ILM.[COMPANY_ID]  = XXX.[COMPANY_ID]
						AND	ILM.[DIVISION_ID] = XXX.[DIVISION_ID]
						AND	ILM.[SITE_ID]     = XXX.[SITE_ID]
						AND	ILM.[PLANT_ID]    = XXX.[PLANT_ID]
						AND	ILM.[ITEM_ID]     = XXX.[ITEM_ID]
						AND	ILM.[FACTORY_ID]  = XXX.[FACTORY_ID]
						AND    ILM.[HALF_SLIT_FLAG] = 'Y'
						ORDER  BY ILM.[MAIN_LANE_QTY] DESC) -- [LANE_QTY]
					,@UPDATE_BY -- [INSERT_ID]
					,GETDATE()  -- [INSERT_TIME]
					,@UPDATE_BY -- [UPDATE_ID]
					,GETDATE()  -- [UPDATE_TIME]
					,'UPLOAD'   -- [PLAN_TYPE]
					,'N'        -- [FIXED_YN]
			FROM   ( SELECT  XX.[COMPANY_ID]
							,XX.[DIVISION_ID]
							,XX.[SITE_ID]
							,XX.[PLANT_ID]
							,XX.[FACTORY_ID]
							,XX.[PLAN_WEEK]
							,XX.[PLAN_REVISION]
							,XX.[INSTANCE_ID]
							,XX.[PLAN_ID]
							,XX.[CUTOFF_DATE]
							,XX.[PRODUCTION_TYPE]
							,XX.[ITEM_ID]
							,XX.[ITEM_ID]                       AS TOP_ITEM_ID
							,XX.[OPERATION_ID]
							,XX.[PLAN_DATE]
							,MAX(XX.[PLAN_START_TIME])          AS PLAN_START_TIME
							,MAX(XX.[PLAN_END_TIME])            AS PLAN_END_TIME
							,SUM(XX.[REMAIN_QTY])               AS REMAIN_QTY
							,SUM(XX.[REMAIN_QTY])               AS REMAIN_IN_QTY
							,0                                  AS ACTUAL_QTY
						FROM   ( 	SELECT MWO.[COMPANY_ID]
											,MWO.[DIVISION_ID]
											,MWO.[SITE_ID]
											,MWO.[PLANT_ID]
											,MWO.[FACTORY_ID]
											,MO.[PLAN_WEEK]
											,MO.[PLAN_REVISION]
											,MO.[INSTANCE_ID]
											,MO.[PLAN_ID]
											,MWO.[CUTOFF_DATE]
											,MWO.[PRODUCTION_TYPE]
											,MWO.[ITEM_ID]
											,'E2500'     AS OPERATION_ID
											,MWO.[PLAN_DATE]
											,MWO.[PLAN_START_TIME]
											,MWO.[PLAN_END_TIME]
											,MWO.[REMAIN_QTY]
									FROM   @PLAN_ID_TEMP_TABLE  MO
											,[DBO].[SCM_SYS_LOOKUP_VALUE]    SLV WITH(NOLOCK)
											,[DBO].[FP_MANUAL_WORK_ORDER_H]  MWO WITH(NOLOCK)
									WHERE  MO.[COMPANY_ID]      = MWO.[COMPANY_ID]
									AND    MO.[DIVISION_ID]     = MWO.[DIVISION_ID]
									AND    MO.[SITE_ID]         = MWO.[SITE_ID]
									AND    MO.[PLANT_ID]        = MWO.[PLANT_ID]
									AND    MO.[LINK_FACTORY_ID] = MWO.[FACTORY_ID]   -- 2017-11-04 kimcd half slitting은 한국 소형 3동만 존재함. 기존과 같이 factory id 직접 연결 유지
									AND    MO.[INSTANCE_ID]     = MWO.[INSTANCE_ID]
									AND	   MO.[PLAN_ID]         = MWO.[PLAN_ID]
									AND	   MO.[PLAN_WEEK]       = MWO.[PLAN_WEEK]
									AND	   MO.[PLAN_REVISION]   = MWO.[PLAN_REVISION]
									AND    MWO.[OPERATION_ID]   = 'E2000'
									AND    MWO.[CUTOFF_DATE]    = @BASE_DATE
									AND    MWO.[PLAN_TYPE]      = 'UPLOAD'
									AND    SLV.[LOOKUP_TYPE_CODE] = 'HALF_SLIT_FACTORY'
									AND    MWO.[FACTORY_ID]     = SLV.[SEGMENT1]
									AND    SLV.[ACTIVE_FLAG]    = 'Y'
									AND    MWO.[REMAIN_QTY]     > 0 -- 2017-08-01 kimcd add
									UNION ALL
									SELECT MO.[COMPANY_ID]
											,MO.[DIVISION_ID]
											,MO.[SITE_ID]
											,MO.[PLANT_ID]
											,MO.[LINK_FACTORY_ID]  -- 2017-11-04 kimcd plan group(제품 특성)별 
											,MO.[PLAN_WEEK]
											,MO.[PLAN_REVISION]
											,MO.[INSTANCE_ID]
											,MO.[PLAN_ID]
											,@BASE_DATE  AS CUTOFF_DATE
											,'MASS'      AS PRODUCTION_TYPE 
											,SH.[ITEM_ID]
											,'E2500'     AS OPERATION_ID
											,@BASE_DATE  AS PLAN_DATE
											,CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @BASE_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + SUBSTRING(STL.SEGMENT2, 3,2) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120)
											,CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @BASE_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + SUBSTRING(STL.SEGMENT2, 3,2) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120) + 1
											,ISNULL(SH.MODIFY_FP_APPLY_WIPQTY,ISNULL(SH.FP_APPLY_WIPQTY, 0)) AS REMAIN_QTY
									FROM   @PLAN_ID_TEMP_TABLE  MO
											,[DBO].[SCM_SYS_LOOKUP_VALUE]   SLV WITH(NOLOCK)
											,[DBO].[SCM_SYS_LOOKUP_VALUE]   STL WITH(NOLOCK)
											,[DBO].[SCM_STOCK_H]            SH  WITH(NOLOCK)
									WHERE  MO.[COMPANY_ID]    = SH.[COMPANY_ID]
									AND    MO.[DIVISION_ID]   = SH.[DIVISION_ID]
									AND    MO.[SITE_ID]       = SH.[SITE_ID]
									AND    MO.[PLANT_ID]      = SH.[PLANT_ID]
									AND    MO.[LINK_FACTORY_ID]   = SH.[FACTORY_ID]  -- 2017-11-04 kimcd half slitting은 한국 소형 3동만 존재함. 기존과 같이 factory id 직접 연결 유지
									AND    SLV.[LOOKUP_TYPE_CODE] = 'HALF_SLIT_FACTORY'
									AND    MO.[LINK_FACTORY_ID]   = SLV.[SEGMENT1]   -- 2017-11-04 kimcd half slitting은 한국 소형 3동만 존재함. 기존과 같이 factory id 직접 연결 유지
									AND    SLV.[ACTIVE_FLAG]  = 'Y'
									AND    STL.[LOOKUP_TYPE_CODE] = 'BASIS_START_TIME_PLANT'
									AND    STL.[SEGMENT1]         = MO.[PLANT_ID]
									AND    STL.[ACTIVE_FLAG]      = 'Y'
									AND    SH.[CUTOFF_DATE]     = @BASE_DATE 
									AND    SH.[STOCK_TYPE]      = 'WIP'
									AND    SH.[AVAILABLE_DATE]  >= SH.[HOLDING_DATE]
									AND    SH.[AVAILABLE_DATE]  <= SH.[CUTOFF_DATE]
									AND    ISNULL(SH.[FP_APPLY_OPERATION_ID], SH.[OPERATION_ID]) = 'E2000'
									AND    FLOOR(ISNULL(SH.[MODIFY_FP_APPLY_WIPQTY],ISNULL(SH.[FP_APPLY_WIPQTY], 0))) > 0
									AND    EXISTS (	SELECT 1
													FROM   SCM_ITEM_LANE_M SIL WITH(NOLOCK)
													WHERE  SIL.[COMPANY_ID]   = SH.[COMPANY_ID]
													AND    SIL.[DIVISION_ID]  = SH.[DIVISION_ID]
													AND    SIL.[SITE_ID]      = SH.[SITE_ID]
													AND    SIL.[FACTORY_ID]   = SH.[FACTORY_ID]
													AND    SIL.[ITEM_ID]      = SH.[ITEM_ID]
													AND    SIL.[HALF_SLIT_FLAG] = 'Y'
													) ) XX		
						GROUP BY XX.[COMPANY_ID]
								,XX.[DIVISION_ID]
								,XX.[SITE_ID]
								,XX.[PLANT_ID]
								,XX.[FACTORY_ID]
								,XX.[PLAN_WEEK]
								,XX.[PLAN_REVISION]
								,XX.[INSTANCE_ID]
								,XX.[PLAN_ID]
								,XX.[CUTOFF_DATE]
								,XX.[PRODUCTION_TYPE]
								,XX.[ITEM_ID]
								,XX.[OPERATION_ID]
								,XX.[PLAN_DATE] ) XXX,
				  -- DBO.SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK), 2018-03-06 kimcd item line assign 검증 제거
				  DBO.SCM_EQUIPMENT_M        EM  WITH(NOLOCK)
			WHERE  /*ILA.[COMPANY_ID]   = XXX.[COMPANY_ID]
			AND ILA.[DIVISION_ID]  = XXX.[DIVISION_ID]
			AND ILA.[SITE_ID]      = XXX.[SITE_ID]
			AND ILA.[PLANT_ID]     = XXX.[PLANT_ID]
			AND ILA.[FACTORY_ID]   = XXX.[FACTORY_ID]
			AND ILA.[OPERATION_ID] = XXX.[OPERATION_ID]
			AND ILA.[ITEM_ID]      = XXX.[ITEM_ID]
			AND SUBSTRING(CONVERT(NVARCHAR(20), XXX.PLAN_DATE, 112) ,1, 6) = ILA.[MONTH]
			AND ILA.[ACTIVE_FLAG]  = 'Y' item line assign 검증 제거 2018-03-06 kimcd */
				XXX.[COMPANY_ID]   = EM.[COMPANY_ID]
			AND XXX.[DIVISION_ID]  = EM.[DIVISION_ID]
			AND XXX.[SITE_ID]      = EM.[SITE_ID]
			AND XXX.[PLANT_ID]     = EM.[PLANT_ID]
			AND XXX.[FACTORY_ID]   = EM.[FACTORY_ID]
			AND XXX.[OPERATION_ID] = EM.[OPERATION_ID]
			-- AND ILA.[LINE_ID]      = EM.[LINE_ID]  2018-03-06 kimcd item line assign 검증 제거
			-- AND ILA.[ELECTRODE_TYPE]= EM.[ELECTRODE_TYPE]  2018-03-06 kimcd item line assign 검증 제거
			AND EM.[EQUIPMENT_TYPE] = 'M'
			AND EM.[ACTIVE_FLAG]    = 'Y'
			;

			SET @n_row_count = @n_row_count + @@ROWCOUNT

			--LOG 생성
			SET @v_message = @n_row_count
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null
		END;

	--COMMIT TRANSACTION;
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

	BEGIN TRY				
	--BEGIN TRANSACTION;
	BEGIN
		-- ================================================
		-- 로직 추가
		-- ================================================
	  	DECLARE CUR_PLAN_ID CURSOR FOR
			SELECT  COMPANY_ID,
					DIVISION_ID,
					SITE_ID,
					PLANT_ID,
					LINK_FACTORY_ID,  -- 2017-11-04 kimcd Factory id에서 Link factory_id로 전환
					PLAN_GROUP_ID,    -- 2017-11-04 kimcd plan group 기반 배포로 컬럼추가
					INSTANCE_ID,
					INSTANCE_TYPE,
					UPDATE_BY,
					PLAN_ID
			FROM    @PLAN_ID_TEMP_TABLE  MO;

		OPEN CUR_PLAN_ID;
		FETCH NEXT FROM CUR_PLAN_ID INTO @COMPANY_ID
										,@DIVISION_ID
										,@SITE_ID
										,@PLANT_ID
										,@LINK_FACTORY_ID  -- 2017-11-04 kimcd Factory id에서 Link factory_id로 전환
										,@PLAN_GROUP_ID    -- 2017-11-04 kimcd plan group 기반 배포로 컬럼추가
										,@INSTANCE_ID
										,@INSTANCE_TYPE
										,@UPDATE_BY
										,@PLAN_ID

		WHILE (@@FETCH_STATUS = 0)
			BEGIN	 

				SELECT  @V_ORDER_DATE_CODE = SUBSTRING(PLAN_DATE, 3, 2)
												+ CASE SUBSTRING(PLAN_DATE, 5, 2)
													WHEN '10' THEN 'A'
													WHEN '11' THEN 'B'
													WHEN '12' THEN 'C'
													ELSE SUBSTRING(PLAN_DATE, 6, 1)
												END
												+ SUBSTRING(PLAN_DATE, 7, 2)
				FROM   (    
						SELECT CONVERT(NVARCHAR, PLAN_START_TIME, 112) AS PLAN_DATE                                  
						FROM   SCM_FP_PLAN_H  A
						WHERE  A.INSTANCE_ID = @INSTANCE_ID
						AND    A.PLAN_ID     = @PLAN_ID
						) A               

				BEGIN TRANSACTION;
				SET @v_temp1 = 'FP_DAILY_PLAN_ORDER_R';
				INSERT INTO FP_DAILY_PLAN_ORDER_R
					 (
					   INSTANCE_ID
					 , FP_PLAN_ID
					 , WORK_ORDER_SPL_ID
					 , WORK_ORDER_ID
					 , NEW_ORDER_ID
					 , SITE_ID      -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
					 , PLAN_DATE    -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
					 , ERP_OPERATION_ID
					 , ORDER_SEQ
					 , DEMAND_ID
					 , INSERT_ID
					 , INSERT_TIME
					 )
				SELECT DISTINCT
					   A.INSTANCE_ID
					 , @PLAN_ID AS FP_PLAN_ID
					 , A.WORK_ORDER_SPL_ID
					 , A.WORK_ORDER_ID
					 -- 확정 계획 유지하고, 아니면 신규로 채번한다.
					 , CASE WHEN A.FIX_TYPE = 'F' THEN A.ORG_WORK_ORDER_ID
							WHEN A.FIX_TYPE = 'N' THEN A.NEW_PLAN_ORDER_ID
					   END  AS NEW_ORDER_ID
		             , A.SITE_ID    -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
		             , A.PLAN_DATE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
					 , A.ERP_OPERATION_ID
					 , A.SEQ
					 , A.DEMAND_ID
					 , @UPDATE_BY   AS INSERT_ID
					 , GETDATE()    AS INSERT_TIME
				FROM   (
						SELECT A.INSTANCE_ID
							 , A.SITE_ID -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
							 , A.WORK_ORDER_SPL_ID
							 , A.WORK_ORDER_ID
							 , CASE WHEN A.INSTANCE_CODE = '-' THEN 'W'
									ELSE A.INSTANCE_CODE
							   END  -- + ISNULL(C.KEY_VALUE, '1') -- 2018-03-06 kimcd work order id 채번 rule 변경에 주석처리
											   -- + @V_ORDER_DATE_CODE -- 2018-03-06 kimcd work order id 채번 rule 변경에 주석처리
											   + A.DATE_CODE -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 변경
											   + A.ERP_OPERATION_ID
											   + '0' -- -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 0 처리
											   + ORDER_ID
								 AS NEW_PLAN_ORDER_ID
							 , A.DEMAND_ID
							 , A.INSTANCE_CODE
							 , A.PLAN_DATE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
							 , A.ERP_OPERATION_ID
							 , A.SEQ
							 , A.ORG_WORK_ORDER_ID
							 , A.FIX_TYPE
							 , A.SEQ_SPLIT
							 , B.ORDER_ID
						FROM   (
								SELECT A.INSTANCE_ID
									 , A.SITE_ID  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
									 , A.WORK_ORDER_SPL_ID
									 , A.WORK_ORDER_ID
									 , A.DEMAND_ID
									 , A.PRODUCTION_TYPE
									 , A.PLAN_DATE -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
									 , A.ERP_OPERATION_ID
									 , A.INSTANCE_CODE
									 , A.ORG_WORK_ORDER_ID
									 , A.FIX_TYPE
									 --, COUNT(1) OVER (PARTITION BY A.ERP_OPERATION_ID  ORDER BY A.WORK_ORDER_SPL_ID) + ISNULL(B.MAX_ORDER_SEQ, 0) SEQ  2018-03-06 kimcd work order id 채번 rule 변경에 따른 주석 처리
									 , SUM(A.NEW_WORK_CHECK) OVER (PARTITION BY A.PLAN_DATE, A.ERP_OPERATION_ID  ORDER BY A.WORK_ORDER_SPL_ID) + ISNULL(B.MAX_ORDER_SEQ, 0) AS SEQ  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
									 , COUNT(1) OVER (PARTITION BY A.ORG_WORK_ORDER_ID ORDER BY A.WORK_ORDER_SPL_ID) SEQ_SPLIT
									 , SUBSTRING(A.PLAN_DATE, 3,2)        -- 년도
										+ CASE SUBSTRING(A.PLAN_DATE, 5,2)  WHEN '10' THEN 'A'
																			WHEN '11' THEN 'B'
																			WHEN '12' THEN 'C'
																			ELSE SUBSTRING(A.PLAN_DATE, 6,1)
										  END                            -- 월
										+ SUBSTRING(A.PLAN_DATE, 7,2)    -- 일
										AS DATE_CODE   -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
								FROM   (
										SELECT DISTINCT
											   A.INSTANCE_ID
											 , A.SITE_ID
											 , A.WORK_ORDER_SPL_ID
											 , A.WORK_ORDER_ID
											 , A.DEMAND_ID
											 , A.PRODUCTION_TYPE
											 , A.PLAN_DATE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
											 , A.ERP_OPERATION_ID
											 , A.INSTANCE_CODE
											 , A.ORG_WORK_ORDER_ID
											 , A.FIX_TYPE
											 , A.NEW_WORK_CHECK  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
										FROM   (SELECT A.INSTANCE_ID
													 , A.SITE_ID
													 , A.WORK_ORDER_SPL_ID
													 , A.WORK_ORDER_ID
													 , A.DEMAND_ID
													 , A.PRODUCTION_TYPE
													 , CONVERT(NVARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
													 , C.ERP_OPERATION_ID
													 , B.KEY_VALUE AS INSTANCE_CODE
													 , A.WORK_ORDER_SPL_ID AS ORG_WORK_ORDER_ID    -- 2018-03-06 kimcd work order id 채번 rule 변경. SUBSTRING 제거
													 , CASE WHEN A.FIXED_YN = 'Y'               THEN 'F'
															--WHEN PLAN_DATE > @v_confirm_date  THEN 'P'
															ELSE 'N'
													   END  AS FIX_TYPE
													 , CASE WHEN A.FIXED_YN = 'Y'             THEN 0
																							  ELSE 1
													   END  AS NEW_WORK_CHECK     -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가                                           
												FROM   FP_MANUAL_WORK_ORDER_H A,
													   FP_INSTANCE_CONFIG_M B WITH(NOLOCK),
													   SCM_OPERATION_M C WITH(NOLOCK)
												WHERE  A.INSTANCE_ID = @INSTANCE_ID
												-- AND    A.FACTORY_ID  = @FACTORY_ID 2017-1104 kimcd plan group 배포 대비로 조건 제거
												AND    A.PLAN_ID     = @PLAN_ID
												AND    CASE WHEN A.INSTANCE_ID = 'KR_CELL_M_P' THEN
															'KR_CELL_M'
														ELSE A.INSTANCE_ID END = B.INSTANCE_ID -- kimcd 2017-08-19 Instance id 변환. 오창 소형 조립 Pilot 경우 위해
												AND    B.CATEGORY_ID = 'EXPORT' 
												AND    B.KEY_ID = 'INSTANCE_CODE'
												AND    A.COMPANY_ID = C.COMPANY_ID
												AND    A.DIVISION_ID = C.DIVISION_ID
												AND    A.SITE_ID = C.SITE_ID
												AND    A.OPERATION_ID = C.OPERATION_ID
												-- kimcd 2017-11-04 block condition. 작업 대상 조건에서 작업 제외 대상으로 전환 AND    A.OPERATION_ID IN ('A2000', 'A3000', 'F6200', 'E2000','E2500') -- kimcd 2017-08-19 공정 추가. Pilot, 활성화 tab, A2000, A3000, F6200
												AND    A.OPERATION_ID NOT IN ('E1000') -- kimcd 2017-11-04 mixer만 제외되도록 전환
											   ) A
									   ) A
									   /*LEFT OUTER JOIN (-- 기존 발생된 ORDER SEQ 를 찾음.
														-- 2017.05.30 : INSTANCE 분리에 따라 INSTANCE_ID 를 빼고, SITE_ID 를 추가함
														SELECT A.SITE_ID, B.ERP_OPERATION_ID, MAX(B.ORDER_SEQ) AS MAX_ORDER_SEQ
														FROM   SCM_FP_PLAN_H A,
															   FP_DAILY_PLAN_ORDER_R B
														WHERE  1=1
														AND    A.PLAN_TYPE   = 'RELEASE'
														AND    CONVERT(nvarchar(8), A.PLAN_START_TIME, 112) = CONVERT(nvarchar(8), @BASE_DATE, 112)
														AND    A.INSTANCE_ID = B.INSTANCE_ID
														AND    A.PLAN_ID = B.FP_PLAN_ID
														GROUP  BY A.SITE_ID, B.ERP_OPERATION_ID                               
														) B
											ON    A.SITE_ID           = B.SITE_ID
											AND   A.ERP_OPERATION_ID  = B.ERP_OPERATION_ID -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 조인 제거*/
										LEFT OUTER JOIN (-- 기존 발생된 ORDER SEQ 를 찾음.
														SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, MAX(A.ORDER_SEQ) AS MAX_ORDER_SEQ
														FROM   FP_DAILY_PLAN_ORDER_SEQ_R A
														GROUP  BY A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID
														) B
											ON    A.SITE_ID           = B.SITE_ID
											AND   A.PLAN_DATE         = B.PLAN_DATE
											AND   A.ERP_OPERATION_ID  = B.ERP_OPERATION_ID -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 SEQ 찾는 대상 TABLE 변경
							   ) A
							   INNER HASH JOIN FP_ORDER_SEQ B WITH(NOLOCK)
									 ON   A.SEQ = B.ORDER_NO
							   --LEFT OUTER JOIN FP_INSTANCE_CONFIG_M  C WITH(NOLOCK)
							   --	ON    A.PRODUCTION_TYPE = C.KEY_ID
							   --		AND   C.INSTANCE_ID = 'COMMON'
							   --		AND   C.CATEGORY_ID = 'DEMAND_TYPE'
					   ) A
               
				SET @n_row_count = @@ROWCOUNT
              
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				-- 2018-12-21 kimcd 로그 호출 제거 EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null
				-- 2018-12-21 kimcd 로그 입력 시작
				INSERT dbo.TH_LOG_HISTORY(
					EVENT_DTTM, 
					MASTER_ID, 
					PLAN_ID, 
					PROC_NAME, 
					TABLE_NAME, 
					LOG_TYPE, 
					LOG_COUNT, 
					LOG_CODE, 
					MESSAGE, 
					DESCR)
				VALUES (
					   sysdatetime(), 
					   @INSTANCE_ID, 
					   @PLAN_ID, 
					   @v_proc_name, 
					   @v_temp1, 
					   'INSERT', 
					   @n_log_count, 
					   NULL, 
					   @v_message, 
					   NULL)
				-- 2018-12-21 kimcd 로그 입력 종료

				-- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 SEQ 찾는 대상에 정보 추가 입력 시작
				SET @v_temp1 = 'FP_DAILY_PLAN_ORDER_SEQ_R'

				MERGE  FP_DAILY_PLAN_ORDER_SEQ_R A 
				USING  (
						SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, MAX(ORDER_SEQ) AS ORDER_SEQ
						FROM   FP_DAILY_PLAN_ORDER_R A
						WHERE  INSTANCE_ID = @INSTANCE_ID
						AND    FP_PLAN_ID  = @PLAN_ID
						GROUP  BY A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID
					   ) B
				ON     ( A.SITE_ID              = B.SITE_ID
						 AND A.PLAN_DATE        = B.PLAN_DATE
						 AND A.ERP_OPERATION_ID = B.ERP_OPERATION_ID )
				WHEN MATCHED THEN 
					UPDATE
					SET    A.ORDER_SEQ = CASE WHEN A.ORDER_SEQ < B.ORDER_SEQ THEN B.ORDER_SEQ ELSE A.ORDER_SEQ END
				WHEN NOT MATCHED THEN
				INSERT 
					 (
					   SITE_ID
					 , PLAN_DATE
					 , ERP_OPERATION_ID
					 , ORDER_SEQ
					 , INSERT_ID
					 , INSERT_TIME
					 )
				VALUES ( B.SITE_ID, B.PLAN_DATE, B.ERP_OPERATION_ID, B.ORDER_SEQ
					 , @v_proc_name , GETDATE() -- INSERT_TIME
					 );
				SET @n_row_count = @@ROWCOUNT
				COMMIT TRANSACTION;
              
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'MERGE', @n_log_count, null, @v_message, null
				-- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 SEQ 찾는 대상에 정보 추가 입력 끝

				SET @v_temp1 = 'UPDATE WORK_ORDER_SPL_ID.WO'
				UPDATE MWO
				SET    MWO.WORK_ORDER_SPL_ID = FPO.NEW_ORDER_ID
					  ,MWO.WORK_ORDER_ID     = FPO.NEW_ORDER_ID
				FROM     [DBO].[FP_MANUAL_WORK_ORDER_H]    MWO
						,[DBO].[FP_DAILY_PLAN_ORDER_R]     FPO
				WHERE  MWO.INSTANCE_ID       = FPO.INSTANCE_ID
				AND	   MWO.PLAN_ID           = FPO.FP_PLAN_ID
				AND	   MWO.WORK_ORDER_SPL_ID = FPO.WORK_ORDER_SPL_ID
				AND	   MWO.WORK_ORDER_ID     = FPO.WORK_ORDER_ID
				AND    MWO.INSTANCE_ID       = @INSTANCE_ID
				-- AND    MWO.FACTORY_ID        = @FACTORY_ID 2017-11-04 kimcd plan group별 배포로 조건 제거
				AND    MWO.PLAN_ID           = @PLAN_ID
				AND    MWO.FIXED_YN          = 'N'

				SET @v_temp1 = 'INSERT PLAN AMEND'
				INSERT INTO FP_AMEND_PRODUCTION_PLAN_R
					(  [MASTER_ID]
					  ,[PLAN_ID]
					  ,[WORK_ORDER_ID]
					  ,[BEFORE_SITE_ID] -- FACTORY_ID
					  ,[AFTER_SITE_ID]  -- FACTORY_ID
					  ,[BEFORE_ROUTE_ID] -- LINE_ID
					  ,[AFTER_ROUTE_ID]  -- LINE_ID
					  ,[BEFORE_OPERATION_ID]
					  ,[AFTER_OPERATION_ID]
					  ,[BEFORE_RESOURCE_ID] -- EQUIPMENT_ID
					  ,[AFTER_RESOURCE_ID]  -- EQUIPMENT_ID
					  ,[BEFORE_PLAN_DATE]   -- 20170720
					  ,[AFTER_PLAN_DATE]
					  ,[BEFORE_START_TIME]  -- 20170720060000
					  ,[AFTER_START_TIME]
					  ,[BEFORE_END_TIME]    -- 20170720082352
					  ,[AFTER_END_TIME]
					  ,[WORKING_TIME]      -- WORKING TYPE  1
					  ,[BEFORE_SEQ]
					  ,[AFTER_SEQ]
					  ,[BEFORE_QTY]
					  ,[AFTER_QTY]
					  ,[BEFORE_IN_QTY]
					  ,[AFTER_IN_QTY]
					  ,[ITEM_ID]
					  ,[FIXED_YN]
					  ,[SPLIT_YN]  -- 'N'
					  ,[DEMAND_ID]
					  ,[DEMAND_TYPE]  -- PRODUCTION TYPE
					  ,[ORDER_TYPE]
					  ,[MFG_WEEK]   -- 추자 정보 넣고.
					  ,[SOP_WEEK]   -- 주차 정보 넣고
					  ,[ORG_WORK_ORDER_ID]  -- WORK ORDER ID
					  ,[DEMAND_DUE_DATE] -- PLAN DATE  2017-09-13
					  ,[BATCH_ORDER_ID]  -- '-'
					  ,[OPERATION_EPST]  -- START TIME 2017-07-20 06:00:00.000
					  ,[OPERATION_LPST]  -- START TIME 2017-07-20 06:00:00.000
					  ,[LANE_QTY]
					  ,[LANE_TACT_QTY]   -- LANE
					  ,[ITEM_UOM]        
					  ,[WO_DAY_SPLIT_YN] -- 'N'
					  ,[SETUP_TIME]      -- 0.0
					  ,[SETUP_TIME_UOM]  -- 'SECOND'
					  ,[UI_EDIT_YN]      -- 'N'
					  ,[MARKET]          -- 'D'
					  ,[INSERT_ID]
					  ,[INSERT_TIME]
					  ,[UPDATE_ID]
					  ,[UPDATE_TIME])
				SELECT MWO.[INSTANCE_ID]   AS MASTER_ID
					  ,MWO.[PLAN_ID]
					  ,MWO.[WORK_ORDER_ID]
					  ,MWO.[FACTORY_ID]    AS BEFORE_SITE_ID -- FACTORY_ID
					  ,MWO.[FACTORY_ID]    AS AFTER_SITE_ID  -- FACTORY_ID
					  ,MWO.[LINE_ID]       AS BEFORE_ROUTE_ID -- LINE_ID
					  ,MWO.[LINE_ID]       AS AFTER_ROUTE_ID  -- LINE_ID
					  ,MWO.[OPERATION_ID]  AS BEFORE_OPERATION_ID
					  ,MWO.[OPERATION_ID]  AS AFTER_OPERATION_ID
					  ,MWO.[EQUIPMENT_ID]  AS BEFORE_RESOURCE_ID -- EQUIPMENT_ID
					  ,MWO.[EQUIPMENT_ID]  AS AFTER_RESOURCE_ID  -- EQUIPMENT_ID
					  ,CONVERT(NVARCHAR(8), MWO.[PLAN_DATE], 112) AS BEFORE_PLAN_DATE   -- 20170720
					  ,CONVERT(NVARCHAR(8), MWO.[PLAN_DATE], 112) AS AFTER_PLAN_DATE
					  ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),MWO.PLAN_START_TIME,120),'-',''),':',''),' ','') AS BEFORE_START_TIME  -- 20170720060000
					  ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),MWO.PLAN_START_TIME,120),'-',''),':',''),' ','') AS AFTER_START_TIME
					  ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),MWO.PLAN_END_TIME,120),'-',''),':',''),' ','')   AS BEFORE_END_TIME    -- 20170720082352
					  ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),MWO.PLAN_END_TIME,120),'-',''),':',''),' ','')   AS AFTER_END_TIME
					  ,1 AS WORKING_TIME     -- WORKING T  1
					  ,ROW_NUMBER() OVER ( PARTITION BY	MWO.[FACTORY_ID], MWO.[OPERATION_ID], MWO.[LINE_ID], MWO.[OPERATION_ID], MWO.[EQUIPMENT_ID]  -- 2022-07-13 kimcd 설비 제거 반영 라인 공정을 파티션에 추가
										   ORDER BY MWO.[PLAN_START_TIME], MWO.[BASE_PLAN_START_TIME])  AS BEFORE_SEQ
					  ,ROW_NUMBER() OVER ( PARTITION BY	MWO.[FACTORY_ID], MWO.[OPERATION_ID], MWO.[LINE_ID], MWO.[OPERATION_ID], MWO.[EQUIPMENT_ID]  -- 2022-07-13 kimcd 설비 제거 반영 라인 공정을 파티션에 추가
										   ORDER BY MWO.[PLAN_START_TIME], MWO.[BASE_PLAN_START_TIME])  AS AFTER_SEQ
					  ,MWO.[REMAIN_QTY]  AS BEFORE_QTY
					  ,MWO.[REMAIN_QTY]  AS AFTER_QTY
					  ,MWO.[REMAIN_IN_QTY]   AS BEFORE_IN_QTY
					  ,MWO.[REMAIN_IN_QTY]   AS AFTER_IN_QTY
					  ,MWO.[ITEM_ID]
					  ,MWO.[FIXED_YN]
					  ,'N'                   AS SPLIT_YN  -- 'N'
					  ,MWO.[DEMAND_ID]
					  ,MWO.[PRODUCTION_TYPE] AS DEMAND_TYPE  -- PRODUCTION TYPE
					  ,SUBSTRING(MWO.[ORDER_TYPE],1,1)  AS ORDER_TYPE  --   [ORDER_TYPE]
					  ,SDM.[WEEK]            AS MFG_WEEK   -- WEEK NUMBER.
					  ,SDM.[WEEK]            AS SOP_WEEK   -- 주차 정보 넣고
					  ,MWO.[WORK_ORDER_ID]   AS ORG_WORK_ORDER_ID  -- WORK ORDER ID
					  ,MWO.[PLAN_DATE]       AS DEMAND_DUE_DATE    -- PLAN DATE  2017-09-13
					  ,'-'                   AS BATCH_ORDER_ID     -- '-'
					  ,MWO.[PLAN_START_TIME] AS OPERATION_EPST     -- START TIME 2017-07-20 06:00:00.000
					  ,MWO.[PLAN_START_TIME] AS OPERATION_LPST     -- START TIME 2017-07-20 06:00:00.000
					  ,MWO.[LANE_QTY]
					  ,MWO.[LANE_QTY]        AS LANE_TACT_QTY      -- LANE
					  ,SIM.[ITEM_UOM]        
					  ,'N'                   AS WO_DAY_SPLIT_YN    -- 'N'
					  ,0.0                   AS SETUP_TIME         -- 0.0
					  ,'SECOND'              AS SETUP_TIME_UOM     -- 'SECOND'
					  ,'N'                   AS UI_EDIT_YN         -- 'N'
					  ,MWO.MARKET            AS MARKET             -- 2017-11-04 kimcd market 값을 받아오도록 수정
					  ,@UPDATE_BY -- [INSERT_ID]
					  ,GETDATE()  -- [INSERT_TIME]
					  ,@UPDATE_BY -- [UPDATE_ID]
					  ,GETDATE()  -- [UPDATE_TIME]
				FROM	 [DBO].[SCM_SYS_CALENDAR_M]      SDM WITH(NOLOCK)
						,[DBO].[SCM_ITEM_M]              SIM WITH(NOLOCK)
						,[DBO].[FP_MANUAL_WORK_ORDER_H]  MWO
				WHERE  MWO.[COMPANY_ID]     = @COMPANY_ID
				AND    MWO.[DIVISION_ID]    = @DIVISION_ID
				AND    MWO.[SITE_ID]        = @SITE_ID
				AND    MWO.[PLANT_ID]       = @PLANT_ID
				-- AND    MWO.[FACTORY_ID]     = @FACTORY_ID 2017-11-04 kimcd plan group 기반 배포 대응으로 조건 제거
				AND    MWO.[INSTANCE_ID]    = @INSTANCE_ID
				AND	   MWO.[PLAN_ID]        = @PLAN_ID
				AND	   MWO.[PLAN_WEEK]      = @P_PLAN_WEEK
				AND	   MWO.[PLAN_REVISION]  = @P_PLAN_REVISION
				AND    MWO.[COMPANY_ID]     = SIM.[COMPANY_ID]
				AND    MWO.[DIVISION_ID]    = SIM.[DIVISION_ID]
				AND    MWO.[SITE_ID]        = SIM.[SITE_ID]
				AND    MWO.[ITEM_ID]        = SIM.[ITEM_ID]
				AND    SDM.[DATE_ID]        = MWO.[PLAN_DATE]
				AND    MWO.[PLAN_TYPE]      = 'UPLOAD'
				
				SET @n_row_count = @@ROWCOUNT
              
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null

				SET @v_temp1 = 'INSERT PSI PLAN AMEND'
				IF (SELECT TOP 1 SLV.ATTRIBUTE1
					FROM   SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
                    WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI'
					AND    SLV.SEGMENT1         = @INSTANCE_ID) = 'PSI AMEND UI'
				BEGIN
					SET @LOCAL_GETDATE = [dbo].[FN_SITE_TIME] (@SITE_ID);

					INSERT INTO FP_AMEND_PLAN_R
						(  [INSTANCE_ID]
						  ,[FP_PLAN_ID]
						  ,[COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[CATEGORY_ID] -- PLAN 으로 통일
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[ITEM_ID]
						  ,[OPERATION_ID]
						  ,[FACTORY_ID]
						  ,[LOCATION]
						  ,[PRODUCTION_TYPE]
						  ,[MARKET]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
						  ,[PLAN_DATE]
						  ,[TOP_ITEM_ID]
						  ,[ITEM_TYPE]
						  ,[IN_QTY]
						  ,[OUT_QTY]
						  ,[DATE_SEQ]
						  ,[INSERT_ID]
						  ,[INSERT_TIME]
						  ,[PLAN_GROUP_ID]
						  ,[UPDATE_ID]
						  ,[UPDATE_TIME])
					SELECT MWO.[INSTANCE_ID]
						  ,MWO.[PLAN_ID]
						  ,MWO.[COMPANY_ID]
						  ,MWO.[DIVISION_ID]
						  ,'PLAN'          -- [CATEGORY_ID]
						  ,MWO.[SITE_ID]
						  ,MWO.[PLANT_ID]
						  ,MWO.[ITEM_ID]
						  ,MWO.[OPERATION_ID]
						  ,MWO.[FACTORY_ID]
						  ,ISNULL(LM.[LOCATION],'-')
						  ,MWO.[PRODUCTION_TYPE]
						  ,MWO.MARKET
						  ,MWO.[LINE_ID]
						  ,ISNULL(SEM.[ELECTRODE_TYPE],'-')
						  ,MWO.[PLAN_DATE]
						  ,MWO.[ITEM_ID]   -- [TOP_ITEM_ID]
						  ,MAX(SICL.LEVEL_NAME)  -- [ITEM_TYPE]
						  ,SUM(MWO.[REMAIN_IN_QTY])  -- [IN_QTY]
						  ,SUM(MWO.[REMAIN_QTY])     -- [OUT_QTY]
						  ,MAX(DATEDIFF(DD, MWO.[PLAN_DATE], @LOCAL_GETDATE) + 1) -- [DATE_SEQ]
						  ,@UPDATE_BY -- [INSERT_ID]
						  ,GETDATE()  -- [INSERT_TIME]
						  ,@PLAN_GROUP_ID  -- [PLAN_GROUP_ID]
						  ,@UPDATE_BY -- [UPDATE_ID]
						  ,GETDATE()  -- [UPDATE_TIME]
					FROM   [DBO].[SCM_ITEM_M]              SIM  WITH(NOLOCK)
						  ,[DBO].[SCM_ITEM_CLASS_LEVEL_M]  SICL WITH(NOLOCK)
						  ,[DBO].[FP_MANUAL_WORK_ORDER_H]  MWO
						   --LEFT OUTER JOIN SCM_EQUIPMENT_M SEM  WITH(NOLOCK)
						   --ON  SEM.FACTORY_ID   = MWO.FACTORY_ID
						   --AND SEM.OPERATION_ID = MWO.OPERATION_ID
						   --AND SEM.EQUIPMENT_ID = MWO.EQUIPMENT_ID
						   LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M SEM WITH(NOLOCK) -- 2022-07-13 kimcd 설비 정보 제거
						   ON	SEM.[COMPANY_ID]  = MWO.[COMPANY_ID]
						   AND  SEM.[DIVISION_ID] = MWO.[DIVISION_ID]
						   AND  SEM.[SITE_ID]     = MWO.[SITE_ID]
						   AND  SEM.[PLANT_ID]    = MWO.[PLANT_ID]
						   AND  SEM.[FACTORY_ID]  = MWO.[FACTORY_ID]
						   AND  SEM.[ITEM_ID]     = MWO.[ITEM_ID]
						   AND  SEM.[OPERATION_ID]= MWO.[OPERATION_ID]
						   AND  SEM.[LINE_ID]     = MWO.[LINE_ID]
						   AND  SEM.[MONTH]       = CONVERT(NVARCHAR(6), MWO.[PLAN_DATE], 112)
						   LEFT OUTER JOIN SCM_LINE_M LM WITH(NOLOCK) -- 2022-07-13 kimcd 설비 정보 제거
						   ON	LM.[COMPANY_ID]  = SEM.[COMPANY_ID]
						   AND  LM.[DIVISION_ID] = SEM.[DIVISION_ID]
						   AND  LM.[SITE_ID]     = SEM.[SITE_ID]
						   AND  LM.[PLANT_ID]    = SEM.[PLANT_ID]
						   AND  LM.[FACTORY_ID]  = SEM.[FACTORY_ID]
						   AND  LM.[OPERATION_ID]= SEM.[OPERATION_ID]
						   AND  LM.[LINE_ID]     = SEM.[LINE_ID]
						   AND  LM.[ELECTRODE_TYPE] = SEM.[ELECTRODE_TYPE]
					WHERE  MWO.[COMPANY_ID]     = @COMPANY_ID
					AND    MWO.[DIVISION_ID]    = @DIVISION_ID
					AND    MWO.[SITE_ID]        = @SITE_ID
					AND    MWO.[PLANT_ID]       = @PLANT_ID
					AND    MWO.[INSTANCE_ID]    = @INSTANCE_ID
					AND	   MWO.[PLAN_ID]        = @PLAN_ID
					AND	   MWO.[PLAN_WEEK]      = @P_PLAN_WEEK
					AND	   MWO.[PLAN_REVISION]  = @P_PLAN_REVISION
					AND    MWO.[COMPANY_ID]     = SIM.[COMPANY_ID]
					AND    MWO.[DIVISION_ID]    = SIM.[DIVISION_ID]
					AND    MWO.[SITE_ID]        = SIM.[SITE_ID]
					AND    MWO.[ITEM_ID]        = SIM.[ITEM_ID]
					AND    SIM.[ITEM_CLASS]     = SICL.[LEVEL_ID]
					AND    MWO.[PLAN_TYPE]      = 'UPLOAD'
					GROUP BY MWO.[INSTANCE_ID]
							,MWO.[PLAN_ID]
							,MWO.[COMPANY_ID]
							,MWO.[DIVISION_ID]
							,MWO.[SITE_ID]
							,MWO.[PLANT_ID]
							,MWO.[ITEM_ID]
							,MWO.[OPERATION_ID]
							,MWO.[FACTORY_ID]
							,ISNULL(LM.[LOCATION],'-')
							,MWO.[PRODUCTION_TYPE]
							,MWO.[MARKET]
							,MWO.[LINE_ID]
							,ISNULL(SEM.[ELECTRODE_TYPE],'-')
							,MWO.[PLAN_DATE]
				
					SET @n_row_count = @@ROWCOUNT
              
					--LOG 생성
					SET @v_message = @n_row_count
					SET @n_log_count = @n_log_count + 1
					SET @sysdate = GETDATE()
					EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null
				END;

				BEGIN
				-- @v_factory_id 에 따라 로직 분리 함
				WAITFOR DELAY '0:0:3' -- 선행 Transaction 종료 대기
				IF @LINK_FACTORY_ID = 'E4' OR @LINK_FACTORY_ID = 'EA'  -- 2017-08-08 KIMCD  남경 EA 공장 추가  -- 2017-11-04 kimcd plan group 기반 배포에 따른 변수 변경 FACTORY_ID -> LINK_FACTORY_ID
					BEGIN
						EXEC PR_SCM_MANUAL_WO_MERGE_ONETWO_E4  @INSTANCE_ID, @PLAN_ID, @LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반 배포에 따른 변수 변경 FACTORY_ID -> LINK_FACTORY_ID
					END
				ELSE
					BEGIN
						EXEC PR_SCM_MANUAL_WO_MERGE_ONEONE_ETC  @INSTANCE_ID, @PLAN_ID, @LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반 배포에 따른 변수 변경 FACTORY_ID -> LINK_FACTORY_ID
					END
				END

				FETCH NEXT FROM CUR_PLAN_ID INTO @COMPANY_ID
												,@DIVISION_ID
												,@SITE_ID
												,@PLANT_ID
												,@LINK_FACTORY_ID  -- 2017-11-04 kimcd Factory id에서 Link factory_id로 전환
												,@PLAN_GROUP_ID    -- 2017-11-04 kimcd plan group 기반 배포로 컬럼추가
												,@INSTANCE_ID
												,@INSTANCE_TYPE
												,@UPDATE_BY
												,@PLAN_ID

			END;
			
			CLOSE CUR_PLAN_ID;
			DEALLOCATE CUR_PLAN_ID;  
		END;
		
	--	COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

	BEGIN TRY				
	--BEGIN TRANSACTION;
	BEGIN
		WAITFOR DELAY '0:0:3' -- 선행 Transaction 종료 대기
		-- ================================================
		-- 로직 추가
		-- ================================================
		DECLARE CUR_REL_PLAN_ID CURSOR FOR
			SELECT  COMPANY_ID,
					DIVISION_ID,
					SITE_ID,
					PLANT_ID,
					LINK_FACTORY_ID,  -- 2017-11-04 kimcd Factory id에서 Link factory_id로 전환
					PLAN_GROUP_ID,    -- 2017-11-04 kimcd plan group 기반 배포로 컬럼추가
					INSTANCE_ID,
					INSTANCE_TYPE,
					UPDATE_BY,
					PLAN_ID
			FROM    @PLAN_ID_TEMP_TABLE  MO;

		OPEN CUR_REL_PLAN_ID;
		FETCH NEXT FROM CUR_REL_PLAN_ID INTO @COMPANY_ID
											,@DIVISION_ID
											,@SITE_ID
											,@PLANT_ID
											,@LINK_FACTORY_ID  -- 2017-11-04 kimcd Factory id에서 Link factory_id로 전환
											,@PLAN_GROUP_ID    -- 2017-11-04 kimcd plan group 기반 배포로 컬럼추가
											,@INSTANCE_ID
											,@INSTANCE_TYPE
											,@UPDATE_BY
											,@PLAN_ID

		WHILE (@@FETCH_STATUS = 0)
			BEGIN	 
				SELECT  @V_ORDER_DATE_CODE = SUBSTRING(PLAN_DATE, 3, 2)
												+ CASE SUBSTRING(PLAN_DATE, 5, 2)
													WHEN '10' THEN 'A'
													WHEN '11' THEN 'B'
													WHEN '12' THEN 'C'
													ELSE SUBSTRING(PLAN_DATE, 6, 1)
												END
												+ SUBSTRING(PLAN_DATE, 7, 2)
				FROM   (    
						SELECT CONVERT(NVARCHAR, PLAN_START_TIME, 112) AS PLAN_DATE                                  
						FROM   SCM_FP_PLAN_H  A
						WHERE  A.INSTANCE_ID = @INSTANCE_ID
						AND    A.PLAN_ID     = @PLAN_ID
						) A               

				BEGIN TRANSACTION;
				SET @v_temp1 = 'FP_DAILY_PLAN_ORDER_R AT MIXER';
				INSERT INTO FP_DAILY_PLAN_ORDER_R
						(
						INSTANCE_ID
						, FP_PLAN_ID
						, WORK_ORDER_SPL_ID
						, WORK_ORDER_ID
						, NEW_ORDER_ID
						, SITE_ID     -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
						, PLAN_DATE   -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
						, ERP_OPERATION_ID
						, ORDER_SEQ
						, DEMAND_ID
						, INSERT_ID
						, INSERT_TIME
						)
				SELECT DISTINCT
						A.INSTANCE_ID
						, @PLAN_ID AS FP_PLAN_ID
						, A.WORK_ORDER_SPL_ID
						, A.WORK_ORDER_ID
						-- 확정 계획 유지하고, 아니면 신규로 채번한다.
						, CASE WHEN A.FIX_TYPE = 'F' THEN A.ORG_WORK_ORDER_ID
							WHEN A.FIX_TYPE = 'N' THEN A.NEW_PLAN_ORDER_ID
						END  AS NEW_ORDER_ID
						, A.SITE_ID    -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
						, A.PLAN_DATE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
						, A.ERP_OPERATION_ID
						, A.SEQ
						, A.DEMAND_ID
						, @UPDATE_BY   AS INSERT_ID
						, GETDATE()    AS INSERT_TIME
				FROM   (
						SELECT A.INSTANCE_ID
								,A.SITE_ID -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
								, A.WORK_ORDER_SPL_ID
								, A.WORK_ORDER_ID
								, CASE WHEN A.INSTANCE_CODE = '-' THEN 'W'
									ELSE A.INSTANCE_CODE
								END  -- + ISNULL(C.KEY_VALUE, '1') -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 주석 처리
												+ A.DATE_CODE    -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
												+ A.ERP_OPERATION_ID
												+ '0'         -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 reserve 값 추가
												+ B.ORDER_ID
									AS NEW_PLAN_ORDER_ID
								, A.DEMAND_ID
								, A.INSTANCE_CODE
								, A.PLAN_DATE   -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
								, A.ERP_OPERATION_ID
								, A.SEQ
								, A.ORG_WORK_ORDER_ID
								, A.FIX_TYPE
								, A.SEQ_SPLIT
								, B.ORDER_ID
						FROM   (
								SELECT A.INSTANCE_ID
										, A.SITE_ID   -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
										, A.WORK_ORDER_SPL_ID
										, A.WORK_ORDER_ID
										, A.DEMAND_ID
										, A.PRODUCTION_TYPE
										, A.PLAN_DATE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
										, A.ERP_OPERATION_ID
										, A.INSTANCE_CODE
										, A.ORG_WORK_ORDER_ID
										, A.FIX_TYPE
										-- , COUNT(1) OVER (PARTITION BY A.ERP_OPERATION_ID  ORDER BY A.WORK_ORDER_SPL_ID) + ISNULL(B.MAX_ORDER_SEQ, 0) SEQ 2018-03-06 kimcd work order id 채번 rule 변경에 따른 주석 처리
										, SUM(A.NEW_WORK_CHECK) OVER (PARTITION BY A.PLAN_DATE, A.ERP_OPERATION_ID  ORDER BY A.WORK_ORDER_SPL_ID) + ISNULL(B.MAX_ORDER_SEQ, 0) SEQ
										  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
										, COUNT(1) OVER (PARTITION BY A.ORG_WORK_ORDER_ID ORDER BY A.WORK_ORDER_SPL_ID) SEQ_SPLIT
										 , SUBSTRING(A.PLAN_DATE, 3,2)        -- 년도
											 + CASE SUBSTRING(A.PLAN_DATE, 5,2) WHEN '10' THEN 'A'
																				WHEN '11' THEN 'B'
																				WHEN '12' THEN 'C'
																						  ELSE SUBSTRING(A.PLAN_DATE, 6,1)
											   END                            -- 월
											 + SUBSTRING(A.PLAN_DATE, 7,2)    -- 일
											 AS DATE_CODE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
								FROM   (
										SELECT DISTINCT
												A.INSTANCE_ID
												, A.SITE_ID
												, A.WORK_ORDER_SPL_ID
												, A.WORK_ORDER_ID
												, A.DEMAND_ID
												, A.PRODUCTION_TYPE
												, A.PLAN_DATE -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
												, A.ERP_OPERATION_ID
												, A.INSTANCE_CODE
												, A.ORG_WORK_ORDER_ID
												, A.FIX_TYPE
												, A.NEW_WORK_CHECK -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
										FROM   (SELECT A.MASTER_ID AS INSTANCE_ID
														, ( SELECT TOP 1 F.SITE_ID
														    FROM   DBO.SCM_FACTORY_M F WITH(NOLOCK) 
														    WHERE  F.FACTORY_ID = A.AFTER_SITE_ID ) AS SITE_ID
														, A.WORK_ORDER_ID  AS WORK_ORDER_SPL_ID
														, A.WORK_ORDER_ID
														, A.DEMAND_ID
														, A.DEMAND_TYPE    AS PRODUCTION_TYPE
														, A.AFTER_PLAN_DATE AS PLAN_DATE  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가
														, C.ERP_OPERATION_ID
														, B.KEY_VALUE AS INSTANCE_CODE
														, SUBSTRING(A.WORK_ORDER_ID, 1, 13) AS ORG_WORK_ORDER_ID
														, CASE WHEN A.FIXED_YN = 'Y'               THEN 'F'
															--WHEN PLAN_DATE > @v_confirm_date  THEN 'P'
															ELSE 'N'
														  END  AS FIX_TYPE
														, CASE WHEN A.FIXED_YN = 'Y' THEN 0
                                                               ELSE 1
														  END  AS NEW_WORK_CHECK     -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 추가                                     
												FROM    FP_AMEND_PRODUCTION_PLAN_R A,
														FP_INSTANCE_CONFIG_M B WITH(NOLOCK),
														SCM_OPERATION_M C WITH(NOLOCK)
												WHERE  A.MASTER_ID     = @INSTANCE_ID
												AND    A.AFTER_SITE_ID = @LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반 배포로 변수명 변경. factory_id -> link_factory_id. mixer는 동별 배포에서만 발생하여 조건을 제거하지는 않음
												AND    A.PLAN_ID       = @PLAN_ID
												AND    A.MASTER_ID     = B.INSTANCE_ID
												AND    B.CATEGORY_ID   = 'EXPORT' 
												AND    B.KEY_ID        = 'INSTANCE_CODE'
												AND    C.COMPANY_ID    = @COMPANY_ID
												AND    C.DIVISION_ID   = @DIVISION_ID
												AND    C.SITE_ID       = @SITE_ID
												AND    A.AFTER_OPERATION_ID = C.OPERATION_ID                                        
												AND    A.AFTER_OPERATION_ID = 'E1000'
												) A
										) A
										/*LEFT OUTER JOIN (-- 기존 발생된 ORDER SEQ 를 찾음.
														-- 2017.05.30 : INSTANCE 분리에 따라 INSTANCE_ID 를 빼고, SITE_ID 를 추가함
														SELECT A.SITE_ID, B.ERP_OPERATION_ID, MAX(B.ORDER_SEQ) AS MAX_ORDER_SEQ
														FROM   SCM_FP_PLAN_H A,
																FP_DAILY_PLAN_ORDER_R B
														WHERE  1=1
														AND    A.PLAN_TYPE   = 'RELEASE'
														AND    CONVERT(nvarchar(8), A.PLAN_START_TIME, 112) = CONVERT(nvarchar(8), @BASE_DATE, 112)
														AND    A.INSTANCE_ID = B.INSTANCE_ID
														AND    A.PLAN_ID = B.FP_PLAN_ID
														GROUP  BY A.SITE_ID, B.ERP_OPERATION_ID                               
														) B
											ON    A.SITE_ID           = B.SITE_ID
											AND   A.ERP_OPERATION_ID  = B.ERP_OPERATION_ID -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 주석 처리*/
										LEFT OUTER JOIN (-- 기존 발생된 ORDER SEQ 를 찾음.
														SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, MAX(A.ORDER_SEQ) AS MAX_ORDER_SEQ
														FROM   FP_DAILY_PLAN_ORDER_SEQ_R A
														GROUP  BY A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID
														) B
											ON    A.SITE_ID           = B.SITE_ID
											AND   A.PLAN_DATE         = B.PLAN_DATE
											AND   A.ERP_OPERATION_ID  = B.ERP_OPERATION_ID  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 OUTER JOIN 변경
								) A
								INNER HASH JOIN FP_ORDER_SEQ B WITH(NOLOCK)
										ON   A.SEQ = B.ORDER_NO
								--LEFT OUTER JOIN FP_INSTANCE_CONFIG_M  C WITH(NOLOCK)
								--	ON    A.PRODUCTION_TYPE = C.KEY_ID
								--	AND   C.INSTANCE_ID = 'COMMON'
								--	AND   C.CATEGORY_ID = 'DEMAND_TYPE'  -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 주석 처리
						) A
               
				SET @n_row_count = @@ROWCOUNT
              
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()

				-- 2018-12-21 kimcd 로그 호출 제거 EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null
				-- 2018-12-21 kimcd 로그 입력 시작
				INSERT dbo.TH_LOG_HISTORY(
					EVENT_DTTM, 
					MASTER_ID, 
					PLAN_ID, 
					PROC_NAME, 
					TABLE_NAME, 
					LOG_TYPE, 
					LOG_COUNT, 
					LOG_CODE, 
					MESSAGE, 
					DESCR)
				VALUES (
					   sysdatetime(), 
					   @INSTANCE_ID, 
					   @PLAN_ID, 
					   @v_proc_name, 
					   @v_temp1, 
					   'INSERT', 
					   @n_log_count, 
					   NULL, 
					   @v_message, 
					   NULL)
				-- 2018-12-21 kimcd 로그 입력 종료

				-- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 SEQ 찾는 대상에 정보 추가 입력 시작
				SET @v_temp1 = 'FP_DAILY_PLAN_ORDER_SEQ_R'

				MERGE  FP_DAILY_PLAN_ORDER_SEQ_R A 
				USING  (
						SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, MAX(ORDER_SEQ) AS ORDER_SEQ
						FROM   FP_DAILY_PLAN_ORDER_R A
						WHERE  INSTANCE_ID = @INSTANCE_ID
						AND    FP_PLAN_ID  = @PLAN_ID
						GROUP  BY A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID
					   ) B
				ON     ( A.SITE_ID              = B.SITE_ID
						 AND A.PLAN_DATE        = B.PLAN_DATE
						 AND A.ERP_OPERATION_ID = B.ERP_OPERATION_ID )
				WHEN MATCHED THEN 
					UPDATE
					SET    A.ORDER_SEQ = CASE WHEN A.ORDER_SEQ < B.ORDER_SEQ THEN B.ORDER_SEQ ELSE A.ORDER_SEQ END
				WHEN NOT MATCHED THEN
				INSERT 
					 (
					   SITE_ID
					 , PLAN_DATE
					 , ERP_OPERATION_ID
					 , ORDER_SEQ
					 , INSERT_ID
					 , INSERT_TIME
					 )
				VALUES ( B.SITE_ID, B.PLAN_DATE, B.ERP_OPERATION_ID, B.ORDER_SEQ
					 , @v_proc_name , GETDATE() -- INSERT_TIME
					 );
				SET @n_row_count = @@ROWCOUNT
        		COMMIT TRANSACTION;
              
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'MERGE', @n_log_count, null, @v_message, null
				-- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 SEQ 찾는 대상에 정보 추가 입력 끝

				SET @v_temp1 = 'UPDATE FP_ORDER_PEGGING_R'
				UPDATE OPR
				SET    OPR.FROM_WORK_ORDER_ID  = FPO.NEW_ORDER_ID
				FROM     [DBO].[FP_ORDER_PEGGING_R]           OPR
				        ,[DBO].[FP_AMEND_PRODUCTION_PLAN_R]   MWO
						,[DBO].[FP_DAILY_PLAN_ORDER_R]        FPO
				WHERE  MWO.MASTER_ID     = FPO.INSTANCE_ID
				AND	   MWO.PLAN_ID       = FPO.FP_PLAN_ID
				AND	   MWO.WORK_ORDER_ID = FPO.WORK_ORDER_SPL_ID
				AND	   MWO.WORK_ORDER_ID = FPO.WORK_ORDER_ID
				AND    OPR.INSTANCE_ID   = @INSTANCE_ID
				AND    OPR.FP_PLAN_ID    = @PLAN_ID
				AND    OPR.FROM_FACTORY_ID = @LINK_FACTORY_ID -- 2017-11-04 kimcd plan group 배포로 변수명 변경 factory_id -> link_factory_id. mixer는 동별 배분에서만 발생하여 조건은 유지함.
				AND    OPR.FROM_WORK_ORDER_ID = FPO.WORK_ORDER_ID
				AND    MWO.MASTER_ID     = @INSTANCE_ID
				AND    MWO.AFTER_SITE_ID = @LINK_FACTORY_ID -- 2017-11-04 kimcd plan group 배포로 변수명 변경 factory_id -> link_factory_id. mixer는 동별 배분에서만 발생하여 조건은 유지함.
				AND    MWO.PLAN_ID       = @PLAN_ID
				AND    MWO.FIXED_YN      = 'N'
				AND    MWO.AFTER_OPERATION_ID = 'E1000'

				SET @v_temp1 = 'UPDATE WORK_ORDER_ID MIXER'
				UPDATE MWO
				SET    MWO.WORK_ORDER_ID  = FPO.NEW_ORDER_ID
				FROM     [DBO].[FP_AMEND_PRODUCTION_PLAN_R]    MWO
						,[DBO].[FP_DAILY_PLAN_ORDER_R]        FPO
				WHERE  MWO.MASTER_ID     = FPO.INSTANCE_ID
				AND	   MWO.PLAN_ID       = FPO.FP_PLAN_ID
				AND	   MWO.WORK_ORDER_ID = FPO.WORK_ORDER_SPL_ID
				AND	   MWO.WORK_ORDER_ID = FPO.WORK_ORDER_ID
				AND    MWO.MASTER_ID     = @INSTANCE_ID
				AND    MWO.AFTER_SITE_ID = @LINK_FACTORY_ID -- 2017-11-04 kimcd plan group 배포로 변수명 변경 factory_id -> link_factory_id. mixer는 동별 배분에서만 발생하여 조건은 유지함.
				AND    MWO.PLAN_ID       = @PLAN_ID
				AND    MWO.FIXED_YN      = 'N'
				AND    MWO.AFTER_OPERATION_ID = 'E1000'

				SET @v_temp1 = 'INSERT FP_PRODUCTION_PLAN_EQUIPMENT_R'
			   INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
						  (  INSTANCE_ID        
							,FP_PLAN_ID       
							,COMPANY_ID       
							,DIVISION_ID      
							,SITE_ID          
							,PLANT_ID         
							,FACTORY_ID       
							,WORK_ORDER_SPL_ID
							,WORK_ORDER_ID  
							,BATCH_ORDER_ID
							,BIN_ORDER_ID  --'-'
							,ORDER_TYPE    -- 'M' , 'W'
							,SCP_TARGET_ID --   'MANUAL'
							,DEMAND_ID     --    'MANUAL'
							,ITEM_ID  
							,LANE_QTY
							,TOP_ITEM_ID       -- 'TOP ITEM'
							,TOP_WORK_ORDER_ID -- 'TOP WORK ORDER'
							,LINE_ID          
							,OPERATION_ID   
							,ELECTRODE_TYPE
							,WORK_CENTER_ID   
							,EQUIPMENT_ID     
							,PLAN_DATE        
							,START_TIME       
							,END_TIME         
							,PLAN_QTY         
							,PLAN_IN_QTY
							,ITEM_UOM      
							,FIX_TYPE         
							,PRODUCTION_TYPE   -- MASS
							,MARKET
							,MFG_WEEK
							,DEMAND_DIVISION_ID
							,INSERT_ID        
							,INSERT_TIME      
						  )
				SELECT  @INSTANCE_ID  AS MASTER_ID
					  , @PLAN_ID      AS PLAN_ID
					  , @COMPANY_ID   AS COMPANY_ID
					  , @DIVISION_ID  AS DIVISION_ID
					  , @SITE_ID      AS SITE_ID
					  , @PLANT_ID     AS PLANT_ID
					  -- , @FACTORY_ID   AS FACTORY_ID
					  , A.FACTORY_ID  -- 2017-11-04 kimcd 공장 동 정보 컬럼 변경. 제품 유형별 배포 대비
					  , A.WORK_ORDER_ID AS WORK_ORDER_SPL_ID
					  , A.WORK_ORDER_ID
					  , ISNULL(A.BATCH_ORDER_ID,'-')  AS BATCH_ORDER_ID
					  , '-'           AS BIN_ORDER_ID
					  , ISNULL(A.ORDER_TYPE, 'W')     AS ORDER_TYPE  -- M W
					  , A.DEMAND_ID   AS SCP_TARGET_ID
					  , A.DEMAND_ID
					  , A.ITEM_ID
					  , A.LANE_QTY
					  -- , A.ITEM_ID             AS TOP_ITEM_ID 2018-02-23 kimcd top item id 값을 pegging 기준으로 상위 품목 찾는 로직 추가. 슬러리의 상위 pancake 정보 전달되도록 수정
					  -- 2018-02-23 kimcd top item id 추출 로직 추가 시작
					  , ISNULL((SELECT TOP 1 OPR.TO_ITEM_ID
								FROM   [DBO].[FP_ORDER_PEGGING_R] OPR WITH(NOLOCK)
								WHERE  OPR.INSTANCE_ID        = @INSTANCE_ID
								AND    OPR.FP_PLAN_ID         = @PLAN_ID
								AND    OPR.FROM_FACTORY_ID    = @LINK_FACTORY_ID
								AND    OPR.FROM_WORK_ORDER_ID = A.WORK_ORDER_ID
								AND    OPR.FROM_OPERATION_ID  = 'E1000')  ,A.ITEM_ID)  AS TOP_ITEM_ID
					  -- 2018-02-23 kimcd top item id 추출 로직 추가 끝
					  , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
					  , A.LINE_ID             AS LINE_ID
					  , A.OPERATION_ID
					  , ISNULL(LM.ELECTRODE_TYPE,'-') AS ELECTRODE_TYPE -- 2022-07-13 kimcd 설비 정보 제거 -- kimcd 2017-08-01 add no data found case
					  , LM.WORK_CENTER_ID -- 2022-07-13 kimcd 설비 정보 제거
					  , A.EQUIPMENT_ID         AS EQUIPMENT_ID
					  , A.PLAN_DATE
					  , A.START_TIME
					  , A.END_TIME
					  , ROUND(A.PLAN_QTY,0)    AS PLAN_QTY
					  , ROUND(A.PLAN_IN_QTY,0) AS PLAN_IN_QTY
					  , ( SELECT TOP 1 SIM.[ITEM_UOM]
					      FROM   DBO.SCM_ITEM_M SIM WITH(NOLOCK) 
						  WHERE  SIM.[COMPANY_ID]  = @COMPANY_ID
						  AND    SIM.[DIVISION_ID] = @DIVISION_ID
						  AND    SIM.[SITE_ID]     = @SITE_ID
						  AND    SIM.[ITEM_ID]     = A.ITEM_ID ) AS ITEM_UOM
					  , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'N' END AS FIX_TYPE
					  , A.DEMAND_TYPE          AS PRODUCTION_TYPE  -- MASS
					  , A.MARKET
					  , A.MFG_WEEK
					  , @DIVISION_ID    AS DEMAND_DIVISION_ID
					  , @UPDATE_BY      AS INSERT_ID
					  , GETDATE()       AS INSERT_TIME
				FROM  (
						SELECT  MWO.MASTER_ID, MWO.PLAN_ID, MWO.WORK_ORDER_ID,
								MWO.ITEM_ID, MWO.AFTER_SITE_ID AS FACTORY_ID, MWO.AFTER_ROUTE_ID AS LINE_ID, MWO.AFTER_OPERATION_ID AS OPERATION_ID, MWO.AFTER_RESOURCE_ID AS EQUIPMENT_ID,
								MWO.DEMAND_ID, MWO.FIXED_YN, MWO.LANE_QTY, MWO.ITEM_UOM, MWO.BATCH_ORDER_ID, MWO.DEMAND_TYPE, MWO.ORDER_TYPE, MWO.MARKET, MWO.MFG_WEEK
							   , CONVERT(DATETIME, SUBSTRING(MWO.AFTER_PLAN_DATE, 1, 4) 
												   + '-' + SUBSTRING(MWO.AFTER_PLAN_DATE, 5, 2)
												   + '-' + SUBSTRING(MWO.AFTER_PLAN_DATE, 7, 2)) AS PLAN_DATE
							   , CONVERT(DATETIME, SUBSTRING(MWO.AFTER_START_TIME, 1, 4) 
												   + '-' + SUBSTRING(MWO.AFTER_START_TIME, 5, 2)
												   + '-' + SUBSTRING(MWO.AFTER_START_TIME, 7, 2)
												   + ' ' + SUBSTRING(MWO.AFTER_START_TIME, 9, 2)
												   + ':' + SUBSTRING(MWO.AFTER_START_TIME, 11, 2)
												   + ':' + SUBSTRING(MWO.AFTER_START_TIME, 13, 2)) AS START_TIME
							   , CONVERT(DATETIME, SUBSTRING(MWO.AFTER_END_TIME, 1, 4) 
												   + '-' + SUBSTRING(MWO.AFTER_END_TIME, 5, 2)
												   + '-' + SUBSTRING(MWO.AFTER_END_TIME, 7, 2)
												   + ' ' + SUBSTRING(MWO.AFTER_END_TIME, 9, 2)
												   + ':' + SUBSTRING(MWO.AFTER_END_TIME, 11, 2)
												   + ':' + SUBSTRING(MWO.AFTER_END_TIME, 13, 2)) AS END_TIME,
								MWO.AFTER_QTY   AS PLAN_QTY,
								MWO.AFTER_IN_QTY AS PLAN_IN_QTY
						FROM   [DBO].[FP_AMEND_PRODUCTION_PLAN_R]   MWO
						WHERE  MWO.MASTER_ID     = @INSTANCE_ID
						-- AND    MWO.AFTER_SITE_ID = @FACTORY_ID 2017-11-4 kimcd 제품 특성 기준으로 배포하는 경우 대비 동 조건 제거
						AND    MWO.PLAN_ID       = @PLAN_ID
					  ) A
						LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M SEM WITH(NOLOCK) -- 2022-07-13 kimcd 설비 정보 제거
						ON	 SEM.[FACTORY_ID]  = A.[FACTORY_ID]
						AND  SEM.[ITEM_ID]     = A.[ITEM_ID]
						AND  SEM.[OPERATION_ID]= A.[OPERATION_ID]
						AND  SEM.[LINE_ID]     = A.[LINE_ID]
						AND  SEM.[MONTH]       = CONVERT(NVARCHAR(6), A.[PLAN_DATE], 112)
						LEFT OUTER JOIN SCM_LINE_M LM WITH(NOLOCK) -- 2022-07-13 kimcd 설비 정보 제거
						ON	LM.[COMPANY_ID]  = SEM.[COMPANY_ID]
						AND  LM.[DIVISION_ID] = SEM.[DIVISION_ID]
						AND  LM.[SITE_ID]     = SEM.[SITE_ID]
						AND  LM.[PLANT_ID]    = SEM.[PLANT_ID]
						AND  LM.[FACTORY_ID]  = SEM.[FACTORY_ID]
						AND  LM.[OPERATION_ID]= SEM.[OPERATION_ID]
						AND  LM.[LINE_ID]     = SEM.[LINE_ID]
						AND  LM.[ELECTRODE_TYPE] = SEM.[ELECTRODE_TYPE]
				WHERE  A.MASTER_ID     = @INSTANCE_ID
				AND    A.PLAN_ID       = @PLAN_ID
				-- AND    A.FACTORY_ID    = @FACTORY_ID 2017-11-4 kimcd 제품 특성 기준으로 배포하는 경우 대비 동 조건 제거

				SET @n_row_count = @@ROWCOUNT
        
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null

				--  kimcd add start 2017-08-01 -- add logic for clearing old mixer, half slit order
				SET @v_temp1 = 'INSERT CLEAR FP_PRODUCTION_PLAN_EQUIPMENT_R FOR CLEAR'
			   INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
						  (  INSTANCE_ID        
							,FP_PLAN_ID       
							,COMPANY_ID       
							,DIVISION_ID      
							,SITE_ID          
							,PLANT_ID         
							,FACTORY_ID       
							,WORK_ORDER_SPL_ID
							,WORK_ORDER_ID  
							,BATCH_ORDER_ID
							,BIN_ORDER_ID  --'-'
							,ORDER_TYPE    -- 'M' , 'W'
							,SCP_TARGET_ID --   'MANUAL'
							,DEMAND_ID     --    'MANUAL'
							,ITEM_ID  
							,LANE_QTY
							,TOP_ITEM_ID       -- 'TOP ITEM'
							,TOP_WORK_ORDER_ID -- 'TOP WORK ORDER'
							,LINE_ID          
							,OPERATION_ID   
							,ELECTRODE_TYPE
							,WORK_CENTER_ID   
							,EQUIPMENT_ID     
							,PLAN_DATE        
							,START_TIME       
							,END_TIME         
							,PLAN_QTY         
							,PLAN_IN_QTY
							,ITEM_UOM      
							,FIX_TYPE         
							,PRODUCTION_TYPE   -- MASS
							,MARKET
							,MFG_WEEK
							,DEMAND_DIVISION_ID
							,INSERT_ID        
							,INSERT_TIME      
						  )
				SELECT  @INSTANCE_ID  AS MASTER_ID
					  , @PLAN_ID      AS PLAN_ID
					  , @COMPANY_ID   AS COMPANY_ID
					  , @DIVISION_ID  AS DIVISION_ID
					  , @SITE_ID      AS SITE_ID
					  , @PLANT_ID     AS PLANT_ID
					  , @LINK_FACTORY_ID   -- 2017-11-04 kimcd mixer, half slitting은 동별 할당에서만 발생함. 변수 명만 FACTORY_ID에서 LINK_FACTORY_ID로 변경함
					  , MWO.WORK_ORDER_SPL_ID
					  , MWO.WORK_ORDER_ID
					  , ISNULL(MWO.BATCH_ORDER_ID,'-')  AS BATCH_ORDER_ID
					  , '-'           AS BIN_ORDER_ID
					  , ISNULL(SUBSTRING(MWO.[ORDER_TYPE],1,1), 'W')     AS ORDER_TYPE  -- M W
					  , MWO.DEMAND_ID   AS SCP_TARGET_ID
					  , MWO.DEMAND_ID
					  , MWO.ITEM_ID
					  , MWO.LANE_QTY
					  , MWO.TOP_ITEM_ID         AS TOP_ITEM_ID  -- 2018-02-23 kimcd top item id 추가
					  , MWO.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
					  , MWO.LINE_ID             AS LINE_ID
					  , MWO.OPERATION_ID
					  , ISNULL(D.ELECTRODE_TYPE,'-') AS ELECTRODE_TYPE
					  , D.WORK_CENTER_ID
					  , MWO.EQUIPMENT_ID        AS EQUIPMENT_ID
					  , MWO.PLAN_DATE
					  , MWO.PLAN_START_TIME     AS START_TIME
					  , MWO.PLAN_END_TIME       AS END_TIME
					  , 0    AS PLAN_QTY
					  , 0    AS PLAN_IN_QTY
					  , ( SELECT TOP 1 SIM.[ITEM_UOM]
					      FROM   DBO.SCM_ITEM_M SIM WITH(NOLOCK) 
						  WHERE  SIM.[COMPANY_ID]  = @COMPANY_ID
						  AND    SIM.[DIVISION_ID] = @DIVISION_ID
						  AND    SIM.[SITE_ID]     = @SITE_ID
						  AND    SIM.[ITEM_ID]     = MWO.ITEM_ID ) AS ITEM_UOM
					  , 'F'   AS FIX_TYPE
					  , MWO.PRODUCTION_TYPE  -- MASS
					  , MWO.MARKET
					  , (SELECT SDM.[WEEK]
						 FROM	 [DBO].[SCM_SYS_CALENDAR_M]      SDM WITH(NOLOCK)
						 WHERE  SDM.[DATE_ID]      = MWO.[PLAN_DATE] )  AS MFG_WEEK
					  , @DIVISION_ID    AS DEMAND_DIVISION_ID
					  , @UPDATE_BY      AS INSERT_ID
					  , GETDATE()       AS INSERT_TIME
				FROM   [DBO].[FP_MANUAL_WORK_ORDER_H]  MWO WITH(NOLOCK)
					  LEFT OUTER JOIN (
										SELECT A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID
											 , A.EQUIPMENT_ID
										FROM   (
												SELECT FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, WORK_CENTER_ID, EQUIPMENT_ID
												FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
												WHERE  ACTIVE_FLAG = 'Y'
												AND    EQUIPMENT_TYPE = 'M'
											   ) A
									   ) D
							ON   MWO.EQUIPMENT_ID = D.EQUIPMENT_ID
							AND  MWO.FACTORY_ID   = D.FACTORY_ID
							AND  MWO.OPERATION_ID = D.OPERATION_ID
							AND  MWO.LINE_ID      = D.LINE_ID
				WHERE  MWO.[COMPANY_ID]   = @COMPANY_ID
				AND    MWO.[DIVISION_ID]  = @DIVISION_ID
				AND    MWO.[SITE_ID]      = @SITE_ID
				AND    MWO.[PLANT_ID]     = @PLANT_ID
				AND    MWO.[FACTORY_ID]   = @LINK_FACTORY_ID -- 2017-11-04 kimcd mixer, half slitting은 동별 할당에서만 발생함. 조건을 FACTORY_ID에서 LINK_FACTORY_ID로 변경함
				AND    MWO.[OPERATION_ID] IN ( 'E1000', 'E2500')
				AND    MWO.[CUTOFF_DATE]  = @BASE_DATE
				-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 시작
				AND    MWO.PLAN_ID        = @LAST_PLAN_ID
				AND    MWO.[PLAN_TYPE]    = @LAST_PLAN_TYPE
				-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 종료
				AND    MWO.[WORK_ORDER_SPL_ID] NOT LIKE 'NEW%'
				AND    NOT EXISTS (SELECT 1 
								   FROM  [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] CMW WITH(NOLOCK)
								   WHERE CMW.[FP_PLAN_ID]   = @PLAN_ID
								   AND   CMW.[INSTANCE_ID]  = @INSTANCE_ID
								   AND   CMW.[COMPANY_ID]   = MWO.[COMPANY_ID]
								   AND   CMW.[DIVISION_ID]  = MWO.[DIVISION_ID]
								   AND   CMW.[SITE_ID]      = MWO.[SITE_ID]
								   AND   CMW.[PLANT_ID]     = MWO.[PLANT_ID]
								   AND   CMW.[FACTORY_ID]   = MWO.[FACTORY_ID]
								   AND   CMW.[WORK_ORDER_SPL_ID] = MWO.[WORK_ORDER_SPL_ID]
								   AND   CMW.[WORK_ORDER_ID] = MWO.[WORK_ORDER_ID])

				SET @n_row_count = @@ROWCOUNT
        
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null
				--  kimcd add end   2017-08-01

				--  kimcd add start 2018-02-11 -- add logic for clearing old mixer. 
				SET @v_temp1 = 'INSERT MIXER ORDER FOR HISTORY'
				INSERT INTO [DBO].[FP_MANUAL_WORK_ORDER_H]
					(  [COMPANY_ID]
					  ,[DIVISION_ID]
					  ,[SITE_ID]
					  ,[PLANT_ID]
					  ,[FACTORY_ID]
					  ,[PLAN_WEEK]
					  ,[PLAN_REVISION]
					  ,[INSTANCE_ID]
					  ,[PLAN_ID]
					  ,[CUTOFF_DATE]
					  ,[WORK_ORDER_SPL_ID]
					  ,[WORK_ORDER_ID]
					  ,[DEMAND_ID]
					  ,[PRODUCTION_TYPE]
					  ,[ORDER_TYPE]
					  ,[ITEM_ID]
					  ,[TOP_ITEM_ID]
					  ,[OPERATION_ID]
					  ,[LINE_ID]
					  ,[ELECTRODE_TYPE]
					  ,[EQUIPMENT_ID]
					  ,[PLAN_DATE]
					  ,[PLAN_START_TIME]
					  ,[PLAN_END_TIME]
					  ,[REMAIN_QTY]
					  ,[REMAIN_IN_QTY]
					  ,[BASE_PLAN_START_TIME]
					  ,[ACTUAL_QTY]
					  ,[RUNNING_FLAG]
					  ,[WO_STATUS]
					  ,[MARKET]
					  ,[LANE_QTY]
					  ,[BATCH_ORDER_ID]
					  ,[ROLLING_PLAN_DATE]
					  ,[INSERT_ID]
					  ,[INSERT_TIME]
					  ,[UPDATE_ID]
					  ,[UPDATE_TIME]
					  ,[PLAN_TYPE]
					  ,[FIXED_YN])
				SELECT  @COMPANY_ID   AS COMPANY_ID
					  , @DIVISION_ID  AS DIVISION_ID
					  , @SITE_ID      AS SITE_ID
					  , @PLANT_ID     AS PLANT_ID
					  , A.FACTORY_ID
					  , @P_PLAN_WEEK
					  , @P_PLAN_REVISION 
					  ,	@INSTANCE_ID
					  , @PLAN_ID      AS PLAN_ID
					  , @BASE_DATE
					  , A.WORK_ORDER_ID
					  , A.WORK_ORDER_ID
					  , A.DEMAND_ID
					  , A.DEMAND_TYPE  AS PRODUCTION_TYPE -- PRODUCTION TYPE
					  , A.ORDER_TYPE + 'O'
					  , A.ITEM_ID
					  -- , A.ITEM_ID             AS TOP_ITEM_ID 2018-02-23 kimcd top item id 값을 pegging 기준으로 상위 품목 찾는 로직 추가. 슬러리의 상위 pancake 정보 전달되도록 수정
					  -- 2018-02-23 kimcd top item id 추출 로직 추가 시작
					  , ISNULL((SELECT TOP 1 OPR.TO_ITEM_ID
								FROM   [DBO].[FP_ORDER_PEGGING_R] OPR WITH(NOLOCK)
								WHERE  OPR.INSTANCE_ID        = @INSTANCE_ID
								AND    OPR.FP_PLAN_ID         = @PLAN_ID
								AND    OPR.FROM_FACTORY_ID    = @LINK_FACTORY_ID
								AND    OPR.FROM_WORK_ORDER_ID = A.WORK_ORDER_ID
								AND    OPR.FROM_OPERATION_ID  = 'E1000')  ,A.ITEM_ID)  AS TOP_ITEM_ID
					  -- 2018-02-23 kimcd top item id 추출 로직 추가 끝
					  , A.OPERATION_ID
					  , A.LINE_ID
					  , ISNULL( ( SELECT TOP 1 B.ELECTRODE_TYPE
								  FROM   SCM_EQUIPMENT_M B WITH(NOLOCK)
								  WHERE  B.ACTIVE_FLAG = 'Y'
								  AND    B.EQUIPMENT_TYPE = 'M'
								  AND    B.EQUIPMENT_ID = A.EQUIPMENT_ID
								  AND    B.FACTORY_ID   = A.FACTORY_ID
								  AND    B.OPERATION_ID = A.OPERATION_ID
								  AND    B.LINE_ID      = A.LINE_ID ), '-')   -- ELECTRODE_TYPE
					  , A.EQUIPMENT_ID
					  , A.PLAN_DATE
					  , A.START_TIME
					  , A.END_TIME
					  , A.PLAN_QTY
					  , A.PLAN_IN_QTY
					  , NULL   -- [BASE_PLAN_START_TIME]
					  , 0      -- [ACTUAL_QTY]
					  , '-'    -- [RUNNING_FLAG]
					  , 'OPEN' -- [WO_STATUS]
					  , A.MARKET
					  , NULL   -- [LANE_QTY]
					  , A.BATCH_ORDER_ID
					  , NULL       -- [ROLLING_PLAN_DATE]
					  , @UPDATE_BY -- [INSERT_ID]
					  , GETDATE()  -- [INSERT_TIME]
					  , @UPDATE_BY -- [UPDATE_ID]
					  , GETDATE()  -- [UPDATE_TIME]
					  , 'UPLOAD'   -- [PLAN_TYPE]
					  , A.FIXED_YN
				FROM  (
						SELECT  MWO.MASTER_ID, MWO.PLAN_ID, MWO.WORK_ORDER_ID,
								MWO.ITEM_ID, MWO.AFTER_SITE_ID AS FACTORY_ID, MWO.AFTER_ROUTE_ID AS LINE_ID, MWO.AFTER_OPERATION_ID AS OPERATION_ID, MWO.AFTER_RESOURCE_ID AS EQUIPMENT_ID,
								MWO.DEMAND_ID, MWO.FIXED_YN, MWO.LANE_QTY, MWO.ITEM_UOM, MWO.BATCH_ORDER_ID, MWO.DEMAND_TYPE, MWO.ORDER_TYPE, MWO.MARKET, MWO.MFG_WEEK
							   , CONVERT(DATETIME, SUBSTRING(MWO.AFTER_PLAN_DATE, 1, 4) 
												   + '-' + SUBSTRING(MWO.AFTER_PLAN_DATE, 5, 2)
												   + '-' + SUBSTRING(MWO.AFTER_PLAN_DATE, 7, 2)) AS PLAN_DATE
							   , CONVERT(DATETIME, SUBSTRING(MWO.AFTER_START_TIME, 1, 4) 
												   + '-' + SUBSTRING(MWO.AFTER_START_TIME, 5, 2)
												   + '-' + SUBSTRING(MWO.AFTER_START_TIME, 7, 2)
												   + ' ' + SUBSTRING(MWO.AFTER_START_TIME, 9, 2)
												   + ':' + SUBSTRING(MWO.AFTER_START_TIME, 11, 2)
												   + ':' + SUBSTRING(MWO.AFTER_START_TIME, 13, 2)) AS START_TIME
							   , CONVERT(DATETIME, SUBSTRING(MWO.AFTER_END_TIME, 1, 4) 
												   + '-' + SUBSTRING(MWO.AFTER_END_TIME, 5, 2)
												   + '-' + SUBSTRING(MWO.AFTER_END_TIME, 7, 2)
												   + ' ' + SUBSTRING(MWO.AFTER_END_TIME, 9, 2)
												   + ':' + SUBSTRING(MWO.AFTER_END_TIME, 11, 2)
												   + ':' + SUBSTRING(MWO.AFTER_END_TIME, 13, 2)) AS END_TIME,
								MWO.AFTER_QTY   AS PLAN_QTY,
								MWO.AFTER_IN_QTY AS PLAN_IN_QTY
						FROM   [DBO].[FP_AMEND_PRODUCTION_PLAN_R]   MWO
						WHERE  MWO.MASTER_ID     = @INSTANCE_ID
						AND    MWO.PLAN_ID       = @PLAN_ID
						AND    MWO.AFTER_OPERATION_ID = 'E1000'
					  ) A

				SET @n_row_count = @@ROWCOUNT
        
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null

				SET @v_temp1 = 'INSERT MIXER,HALF SLIT FOR HISTORY'
				INSERT INTO [FP_MANUAL_WORK_ORDER_H]
						(  [COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[FACTORY_ID]
						  ,[PLAN_WEEK]
						  ,[PLAN_REVISION]
						  ,[INSTANCE_ID]
						  ,[PLAN_ID]
						  ,[CUTOFF_DATE]
						  ,[WORK_ORDER_SPL_ID]
						  ,[WORK_ORDER_ID]
						  ,[DEMAND_ID]
						  ,[PRODUCTION_TYPE]
						  ,[ORDER_TYPE]
						  ,[ITEM_ID]
						  ,[TOP_ITEM_ID]
						  ,[OPERATION_ID]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
						  ,[EQUIPMENT_ID]
						  ,[PLAN_DATE]
						  ,[PLAN_START_TIME]
						  ,[PLAN_END_TIME]
						  ,[REMAIN_QTY]
						  ,[REMAIN_IN_QTY]
						  ,[BASE_PLAN_START_TIME]
						  ,[ACTUAL_QTY]
						  ,[RUNNING_FLAG]
						  ,[WO_STATUS]
						  ,[MARKET]
						  ,[LANE_QTY]
						  ,[BATCH_ORDER_ID]
						  ,[ROLLING_PLAN_DATE]
						  ,[INSERT_ID]
						  ,[INSERT_TIME]
						  ,[UPDATE_ID]
						  ,[UPDATE_TIME]
						  ,[PLAN_TYPE]
						  ,[FIXED_YN])
				SELECT MWO.[COMPANY_ID]
					  ,MWO.[DIVISION_ID]
					  ,MWO.[SITE_ID]
					  ,MWO.[PLANT_ID]
					  ,MWO.[FACTORY_ID]
					  ,MO.[PLAN_WEEK]
					  ,MO.[PLAN_REVISION]
					  ,MO.[INSTANCE_ID]
					  ,MO.[PLAN_ID]
					  ,MWO.[CUTOFF_DATE]
					  ,MWO.[WORK_ORDER_SPL_ID]
					  ,MWO.[WORK_ORDER_ID]
					  ,MWO.[DEMAND_ID]
					  ,MWO.[PRODUCTION_TYPE]
					  ,MWO.[ORDER_TYPE]
					  ,MWO.[ITEM_ID]
					  ,MWO.[TOP_ITEM_ID]
					  ,MWO.[OPERATION_ID]
					  ,MWO.[LINE_ID]
					  ,NULL -- [ELECTRODE_TYPE]
					  ,MWO.[EQUIPMENT_ID]
					  ,MWO.[PLAN_DATE]
					  ,MWO.[PLAN_START_TIME]
					  ,MWO.[PLAN_END_TIME]
					  ,0 	  --[REMAIN_QTY]
					  ,0      --[REMAIN_IN_QTY]
					  ,MWO.[BASE_PLAN_START_TIME]
					  ,ISNULL(MWO.ACTUAL_QTY,0) -- [ACTUAL_QTY]
					  ,MWO.[RUNNING_FLAG]
					  ,MWO.[WO_STATUS]
					  ,MWO.[MARKET]
					  ,MWO.[LANE_QTY]
					  ,MWO.[BATCH_ORDER_ID]
					  ,MWO.[ROLLING_PLAN_DATE]
					  ,@UPDATE_BY -- [INSERT_ID]
					  ,GETDATE()  -- [INSERT_TIME]
					  ,@UPDATE_BY -- [UPDATE_ID]
					  ,GETDATE()  -- [UPDATE_TIME]
					  ,'UPLOAD'   -- [PLAN_TYPE]
					  ,MWO.[FIXED_YN]
				FROM   @PLAN_ID_TEMP_TABLE  MO
					  ,[DBO].[FP_MANUAL_WORK_ORDER_H]  MWO WITH(NOLOCK)
				WHERE  MO.[COMPANY_ID]      = MWO.[COMPANY_ID]
				AND    MO.[DIVISION_ID]     = MWO.[DIVISION_ID]
				AND    MO.[SITE_ID]         = MWO.[SITE_ID]
				AND    MO.[PLANT_ID]        = MWO.[PLANT_ID]
				-- AND    MO.[FACTORY_ID]      = MWO.[FACTORY_ID] 2017-11-04 kimcd 제품 특성별 배포에 따른 공장 동 정보 미상용으로 조건 제외
				AND    MO.[INSTANCE_ID]     = MWO.[INSTANCE_ID] -- kimcd 2017-08-19 A2000, A3000, F6200 공정별 계획 구분하기 위해 INSTANCE_ID 추가
				-- kimcd 2017-11-04 주석 처리 대상 목록에서 제외 대상 조건으로 수정 AND    MWO.[OPERATION_ID]  IN ('A2000', 'A3000', 'F6200', 'E2000') -- kimcd 2017-08-19 공정 추가. Pilot, 활성화 tab, A2000, A3000, F6200
				AND    MWO.[OPERATION_ID]  IN ('E1000', 'E2500') -- kimcd 2017-11-04 남경 전극 전 공정의 제외 대상만 제외함.
				AND    MWO.[CUTOFF_DATE]    = @BASE_DATE
				-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 시작
				AND    MWO.PLAN_ID		    = @LAST_PLAN_ID
				AND    MWO.[PLAN_TYPE]      = @LAST_PLAN_TYPE
				-- 2018-02-11  kimcd 최종 배포된 계획 기준으로 정보 형성 종료
				AND    MWO.[WORK_ORDER_SPL_ID] NOT LIKE 'NEW%'
				-- 2017-11-04  kimcd 동일 동이거나 동일 plan group인 경우만 취소 시작
				AND    EXISTS ( SELECT 1
								FROM   SCM_LINE_M SL WITH(NOLOCK)
								WHERE  SL.FACTORY_ID   = MWO.FACTORY_ID
								AND    SL.LINE_ID      = MWO.LINE_ID
								AND    SL.OPERATION_ID = MWO.OPERATION_ID
								AND    SL.FACTORY_ID   = CASE WHEN MO.LINK_FACTORY_ID = '-' THEN SL.FACTORY_ID ELSE MO.LINK_FACTORY_ID END
								AND    SL.MODEL_TYPE   = CASE WHEN MO.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE MO.PLAN_GROUP_ID END )
				-- 2017-11-04  kimcd 동일 동이거나 동일 plan group인 경우만 취소 끝
				-- 2017-11-04  kimcd site division기준으로 active한 공정만 취소 시작
				AND    EXISTS ( SELECT 1
								FROM   SCM_OPERATION_M SO WITH(NOLOCK)
								WHERE  SO.[COMPANY_ID]   = MWO.[COMPANY_ID]
								AND    SO.[DIVISION_ID]  = MWO.[DIVISION_ID]
								AND    SO.[SITE_ID]      = MWO.[SITE_ID]
								AND    SO.[OPERATION_ID] = MWO.[OPERATION_ID]
								AND    SO.[ACTIVE_FLAG]  = 'Y' )
				-- 2017-11-04  kimcd site division기준으로 active한 공정만 취소 끝
				AND    NOT EXISTS (SELECT 1 
								   FROM  [DBO].[FP_MANUAL_WORK_ORDER_H] CMW WITH(NOLOCK)
								   WHERE CMW.[CUTOFF_DATE]   = @BASE_DATE
								   AND   CMW.[PLAN_WEEK]     = MO.[PLAN_WEEK]
								   AND   CMW.[PLAN_REVISION] = MO.[PLAN_REVISION]
								   -- AND   CMW.[FACTORY_ID]    = MO.[FACTORY_ID] 2017-11-04 kimcd plan group별 배포에 따른 Factory 조건 제거
								   AND   CMW.[WORK_ORDER_SPL_ID] = MWO.[WORK_ORDER_SPL_ID]
								   AND   CMW.[INSTANCE_ID]   = MO.[INSTANCE_ID]
								   AND   CMW.[PLAN_ID]       = MO.[PLAN_ID]
								   AND   CMW.[PLAN_TYPE]     = 'UPLOAD')

				SET @n_row_count = @@ROWCOUNT
        
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null
				--  kimcd add end   2018-02-11

			  SET @v_temp1 = 'UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R JR QTY'
			  UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
			  SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.ROLL_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
																		   THEN A.PLAN_IN_QTY -- Pancake
																		   WHEN UPPER(B.ITEM_UOM) != 'M'
																		   THEN A.PLAN_IN_QTY -- Pancake
																				/ ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
																												  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
																				/ (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
																											WHEN 'CM' THEN 100
																											WHEN 'MM' THEN 1000
																													  ELSE 1 END)
																	  ELSE NULL END),
					 FP_PRODUCTION_PLAN_EQUIPMENT_R.ROLL_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
																			THEN A.PLAN_QTY -- Pancake
																			WHEN UPPER(B.ITEM_UOM) != 'M'
																			THEN A.PLAN_QTY -- Pancake
																				/ ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
																												  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
																				/ (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
																											WHEN 'CM' THEN 100
																											WHEN 'MM' THEN 1000
																													  ELSE 1 END)
																	   ELSE NULL END),
					 FP_PRODUCTION_PLAN_EQUIPMENT_R.JR_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
																		   THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
																									 WHEN A.LANE_QTY = 0      THEN 1
																									 ELSE A.LANE_QTY
																								END  -- Roll
																		   WHEN UPPER(B.ITEM_UOM) != 'M'
																		   THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
																									 WHEN A.LANE_QTY = 0      THEN 1
																									 ELSE A.LANE_QTY
																								END  -- Roll
																				/ ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
																												  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
																				/ (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
																											WHEN 'CM' THEN 100
																											WHEN 'MM' THEN 1000
																													  ELSE 1 END)
																	  ELSE NULL END),
					 FP_PRODUCTION_PLAN_EQUIPMENT_R.JR_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
																			THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
																								   WHEN A.LANE_QTY = 0      THEN 1
																								   ELSE A.LANE_QTY
																							  END  -- Roll
																			WHEN UPPER(B.ITEM_UOM) != 'M'
																			THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
																								   WHEN A.LANE_QTY = 0      THEN 1
																								   ELSE A.LANE_QTY
																							  END  -- Roll
																				/ ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
																												  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
																				/ (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
																											WHEN 'CM' THEN 100
																											WHEN 'MM' THEN 1000
																													  ELSE 1 END)
																	   ELSE NULL END)                                                                                              
			  FROM FP_PRODUCTION_PLAN_EQUIPMENT_R A,
				   SCM_ITEM_M B,
				   SCM_ITEM_CLASS_M C,
				   SCM_ITEM_LANE_M D
			  WHERE 1=1
			  AND   A.INSTANCE_ID = @INSTANCE_ID
			  AND   A.FP_PLAN_ID  = @PLAN_ID
			  -- AND   A.FACTORY_ID  = @FACTORY_ID 2017-11-04 kimcd 조건 제거 제품 특성별 배포 대비
			  AND A.ITEM_ID = B.ITEM_ID
			  AND A.DIVISION_ID = B.DIVISION_ID
			  AND A.SITE_ID = B.SITE_ID
			  AND B.ITEM_CLASS = C.CLASS_ID
			  AND C.LEVEL_2_CODE = 'APC'
			  AND A.DIVISION_ID = D.DIVISION_ID
			  AND A.SITE_ID = D.SITE_ID
			  AND A.PLANT_ID = D.PLANT_ID
			  AND A.FACTORY_ID = D.FACTORY_ID
			  AND A.ITEM_ID = D.ITEM_ID
          
			  SET @v_message = 'ROLL_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
			  SET @n_log_count += 1
			  EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, 'UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R JR QTY', 'UPDATE', @n_log_count, null, @v_message, null 

			SET @v_temp1 = 'UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R BATCH QTY'
			UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
			SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.BATCH_QTY     = A.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE)
				 , FP_PRODUCTION_PLAN_EQUIPMENT_R.BATCH_SUM_QTY = A.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE)
			FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
					SCM_ITEM_EQUIP_RATE_BATCH_M B WITH(NOLOCK)
			WHERE  1=1
			AND    A.INSTANCE_ID    = @INSTANCE_ID
			AND    A.FP_PLAN_ID     = @PLAN_ID
			-- AND    A.FACTORY_ID     = @FACTORY_ID 2017-11-04 kimcd 조건 제거 제품 특성별 배포 대비
			AND    A.COMPANY_ID     = B.COMPANY_ID
			AND    A.DIVISION_ID    = B.DIVISION_ID
			AND    A.SITE_ID        = B.SITE_ID
			AND    A.PLANT_ID       = B.PLANT_ID
			AND    A.FACTORY_ID     = B.FACTORY_ID
			AND    A.OPERATION_ID   = B.OPERATION_ID
			AND    A.ITEM_ID        = B.ITEM_ID
			AND    B.ACTIVE_FLAG    = 'Y'
			AND    FLOOR(B.BATCH_LOT_SIZE) > 0
           
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, 'UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R BATCH QTY', 'UPDATE', @n_log_count, null, @v_message, null 

			SET @v_temp1 = 'INSERT  FP_DAILY_PRODUCTION_PLAN_R'
			INSERT INTO FP_DAILY_PRODUCTION_PLAN_R
				(
				  INSTANCE_ID
				, FP_PLAN_ID
				, COMPANY_ID
				, DIVISION_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, WORK_ORDER_SPL_ID
				, WORK_ORDER_ID
				, ORG_DEMAND_ID
				, DEMAND_ID
				, ITEM_ID
				, TOP_ITEM_ID
				, OPERATION_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, EQUIPMENT_ID
				, PLAN_DATE
				, START_TIME
				, END_TIME
				, PLAN_QTY
				, PLAN_IN_QTY
				, ITEM_UOM
				, ROLL_IN_QTY
				, ROLL_OUT_QTY
				, JR_IN_QTY
				, JR_OUT_QTY
				, FIX_TYPE
				, PRODUCTION_TYPE  -- MASS
				, LINE_ITEM_SEQ
				, OPERATION_ITEM_SEQ
				, LANE_QTY
				, LANE_TACT_QTY -- LANE_QTY
				, BATCH_ORDER_ID
				, BIN_ORDER_ID
				, MFG_WEEK
				, DEMAND_DIVISION_ID
				, INSERT_ID
				, INSERT_DTTM
				, MARKET  -- 2017-11-04 kimcd 수출 내수 구분자 추가     
				)       
			SELECT 
				  INSTANCE_ID
				, FP_PLAN_ID
				, COMPANY_ID
				, DIVISION_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, WORK_ORDER_SPL_ID
				, WORK_ORDER_ID
				, DEMAND_ID  AS ORG_DEMAND_ID
				, DEMAND_ID
				, ITEM_ID
				, TOP_ITEM_ID
				, OPERATION_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, EQUIPMENT_ID
				, PLAN_DATE
				, START_TIME
				, END_TIME
				, PLAN_QTY
				, PLAN_IN_QTY
				, ITEM_UOM
				, ROLL_IN_QTY
				, ROLL_OUT_QTY
				, JR_IN_QTY
				, JR_OUT_QTY
				, FIX_TYPE
				, PRODUCTION_TYPE  -- MASS
				, 1 AS LINE_ITEM_SEQ
				, 1 AS OPERATION_ITEM_SEQ
				, LANE_QTY
				, LANE_QTY    AS LANE_TACT_QTY -- LANE_QTY
				, BATCH_ORDER_ID
				, BIN_ORDER_ID
				, MFG_WEEK
				, DEMAND_DIVISION_ID
				, @UPDATE_BY     AS INSERT_ID
				, GETDATE()      AS INSERT_DATE
				, MARKET -- 2017-11-04 kimcd 수출 내수 구분자 추가
			FROM  FP_PRODUCTION_PLAN_EQUIPMENT_R  A
			WHERE  A.INSTANCE_ID  = @INSTANCE_ID
			AND    A.FP_PLAN_ID   = @PLAN_ID
			-- AND    A.FACTORY_ID   = @FACTORY_ID 2017-11-04 kimcd 조건 제거 제품 특성별 배포 대비

			SET @n_row_count = @@ROWCOUNT

			--LOG 생성
			SET @v_message = @n_row_count
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null

			SET @v_temp1 = 'UPDATE FP_DAILY_PRODUCTION_PLAN_R'
	        UPDATE FP_DAILY_PRODUCTION_PLAN_R
            SET    FP_DAILY_PRODUCTION_PLAN_R.BATCH_IN_QTY = A.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE) 
                 , FP_DAILY_PRODUCTION_PLAN_R.BATCH_OUT_QTY = A.PLAN_QTY   / FLOOR(B.BATCH_LOT_SIZE) 
            FROM   FP_DAILY_PRODUCTION_PLAN_R A,
                   SCM_ITEM_EQUIP_RATE_BATCH_M B
            WHERE  1=1
            AND    A.INSTANCE_ID    = @INSTANCE_ID
            AND    A.FP_PLAN_ID     = @PLAN_ID
            -- AND    A.FACTORY_ID     = @FACTORY_ID 2017-11-04 kimcd 조건 제거 제품 특성별 배포 대비
            AND    A.COMPANY_ID     = B.COMPANY_ID
            AND    A.DIVISION_ID    = B.DIVISION_ID
            AND    A.SITE_ID        = B.SITE_ID
            AND    A.PLANT_ID       = B.PLANT_ID
            AND    A.FACTORY_ID     = B.FACTORY_ID
            AND    A.OPERATION_ID   = B.OPERATION_ID
            AND    A.ITEM_ID        = B.ITEM_ID
            AND    B.ACTIVE_FLAG    = 'Y'
            AND    FLOOR(B.BATCH_LOT_SIZE) > 0

            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'UPDATE', @n_log_count, null, @v_message, null 

			SET @v_temp1 = 'UPDATE FP_PRODUCTION_PLAN_R'
			 INSERT INTO FP_PRODUCTION_PLAN_R
					( INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					--, WORK_ORDER_SPL_ID
					, WORK_ORDER_ID
					, BATCH_ORDER_ID
					, BIN_ORDER_ID
					, ORDER_TYPE
					, SCP_TARGET_ID
					, DEMAND_ID
					, ITEM_ID
					, LANE_QTY
					, TOP_ITEM_ID
					, LINE_ID
					, OPERATION_ID
					, ELECTRODE_TYPE
					, WORK_CENTER_ID
					--, EQUIPMENT_ID
					, PLAN_DATE
					, START_TIME
					, END_TIME
					, PLAN_QTY
					, PLAN_IN_QTY
					, ITEM_UOM
					, ROLL_IN_QTY
					, ROLL_OUT_QTY
					, JR_IN_QTY
					, JR_OUT_QTY
					, BATCH_QTY
					, BATCH_SUM_QTY
					, FIX_TYPE
					, PRODUCTION_TYPE
					, MARKET
					, LANE_TACT_QTY
					, MFG_WEEK
					, DEMAND_DIVISION_ID
					, INSERT_ID
					, INSERT_TIME
					)
			  SELECT  INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					--, WORK_ORDER_SPL_ID
					, WORK_ORDER_ID
					, BATCH_ORDER_ID
					, BIN_ORDER_ID
					, ORDER_TYPE
					, SCP_TARGET_ID
					, DEMAND_ID
					, ITEM_ID
					, LANE_QTY
					, TOP_ITEM_ID
					, LINE_ID
					, OPERATION_ID
					, ELECTRODE_TYPE
					, WORK_CENTER_ID
					--, EQUIPMENT_ID
					, PLAN_DATE
					, START_TIME
					, END_TIME
					, PLAN_QTY
					, PLAN_IN_QTY
					, ITEM_UOM
					, ROLL_IN_QTY
					, ROLL_OUT_QTY
					, JR_IN_QTY
					, JR_OUT_QTY
					, BATCH_QTY
					, BATCH_SUM_QTY
					, FIX_TYPE
					, PRODUCTION_TYPE
					, MARKET
					, LANE_QTY AS LANE_TACT_QTY
					, MFG_WEEK
					, DEMAND_DIVISION_ID
					, @UPDATE_BY     AS INSERT_ID
					, GETDATE()      AS INSERT_DATE
			  FROM  FP_PRODUCTION_PLAN_EQUIPMENT_R  A
			  WHERE  A.INSTANCE_ID  = @INSTANCE_ID
			  AND    A.FP_PLAN_ID   = @PLAN_ID
			  -- AND    A.FACTORY_ID   = @FACTORY_ID 2017-11-04 kimcd 조건 제거 제품 특성별 배포 대비
			  AND    A.ORDER_TYPE   = 'W'

				SET @n_row_count = @@ROWCOUNT
        
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null

				SET @v_temp1 = 'INSERT FP_RELEASE_FIX_PLAN_H'
				INSERT INTO FP_RELEASE_FIX_PLAN_H
					  (
					   INSTANCE_ID
					 , INSTANCE_DATE
					 , RELEASE_PLAN_ID
					 , AMEND_PLAN_ID
					 , DIVISION_ID
					 , FACTORY_ID
					 , WORK_ORDER_ID
					 , ITEM_ID
					 , LINE_ID
					 , OPERATION_ID
					 , ELECTRODE_TYPE
					 , EQUIPMENT_ID
					 , FIX_TYPE
					 , PLAN_DATE
					 , START_TIME
					 , END_TIME
					 , PLAN_QTY
					 , PLAN_IN_QTY
					 , PRODUCTION_TYPE
					 , MARKET
					 , BATCH_ORDER_ID
					 , LANE_QTY
					 , INSERT_ID
					 , INSERT_TIME        
					  )
				SELECT @INSTANCE_ID AS INSTANCE_ID
					 , CONVERT(nvarchar(8), @BASE_DATE, 112) AS PLAN_DATE
					 , A.FP_PLAN_ID AS RELEASE_PLAN_ID
					 , A.FP_PLAN_ID AS AMEND_PLAN_ID
					 , A.DIVISION_ID
					 , A.FACTORY_ID
					 , A.WORK_ORDER_SPL_ID    AS WORK_ORDER_ID  -- FP_PRODUCTION_PLAN_EQUIPMENT_R 는 WORK_ORDER_SPL_ID
					 , A.ITEM_ID
					 , A.LINE_ID
					 , A.OPERATION_ID
					 , A.ELECTRODE_TYPE
					 , A.EQUIPMENT_ID
					 , A.FIX_TYPE
					 , A.PLAN_DATE
					 , A.START_TIME
					 , A.END_TIME
					 , A.PLAN_QTY
					 , A.PLAN_IN_QTY
					 , A.PRODUCTION_TYPE
					 , A.MARKET
					 , A.BATCH_ORDER_ID
					 , ISNULL(A.LANE_QTY, 0) AS LANE_QTY
					, @UPDATE_BY     AS INSERT_ID
					, GETDATE()      AS INSERT_DATE   
				FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
				WHERE  A.INSTANCE_ID  = @INSTANCE_ID
				AND    A.FP_PLAN_ID   = @PLAN_ID
				-- AND    A.FACTORY_ID   = @FACTORY_ID    -- 동별로 RELEASE  2017-11-04 kimcd 조건 제거 제품 특성별 배포 대비
				AND    A.PLAN_QTY     > 0

				SET @n_row_count = @@ROWCOUNT
              
				--LOG 생성
				SET @v_message = @n_row_count
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @INSTANCE_ID, @PLAN_ID, @v_proc_name, @v_temp1, 'INSERT', @n_log_count, null, @v_message, null

				FETCH NEXT FROM CUR_REL_PLAN_ID INTO @COMPANY_ID
													,@DIVISION_ID
													,@SITE_ID
													,@PLANT_ID
													,@LINK_FACTORY_ID -- 2017-11-04 kimcd 제품 특성별 계획 배포에 따른 변수 변경. FACTORY_ID -> LINK_FACTORY_ID
													,@PLAN_GROUP_ID   -- 2017-11-04 kimcd 제품 특성별 계획 배포에 따른 변수 추가. 제품 특성 정보
													,@INSTANCE_ID
													,@INSTANCE_TYPE
													,@UPDATE_BY
													,@PLAN_ID

			END;
			
			CLOSE CUR_REL_PLAN_ID;
			DEALLOCATE CUR_REL_PLAN_ID;  
	END;
	--COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

	BEGIN TRY				
	--BEGIN TRANSACTION;
	BEGIN
		WAITFOR DELAY '0:0:3' -- 선행 Transaction 종료 대기
		-- ================================================
		-- 로직 추가
		-- ================================================
		DECLARE CUR_SEND_PLAN_ID CURSOR FOR
			SELECT  COMPANY_ID,
					DIVISION_ID,
					SITE_ID,
					PLANT_ID,
					LINK_FACTORY_ID,  -- 2017-11-04 kimcd 제품 특성별 계획 배포 대비 변수 명 변경 FACTORY_ID -> LINK_FACTORY_ID
					PLAN_GROUP_ID,    -- 2017-11-04 kimcd 제품 특성별 계획 배포용. 제품 특성 변수 추가
					INSTANCE_ID,
					INSTANCE_TYPE,
					UPDATE_BY,
					PLAN_ID
			FROM    @PLAN_ID_TEMP_TABLE  MO;

		OPEN CUR_SEND_PLAN_ID;
		FETCH NEXT FROM CUR_SEND_PLAN_ID INTO @COMPANY_ID
											, @DIVISION_ID
											, @SITE_ID
											, @PLANT_ID
											, @LINK_FACTORY_ID    -- 2017-11-04 kimcd 제품 특성별 계획 배포 대비 변수 명 변경 FACTORY_ID -> LINK_FACTORY_ID
											, @PLAN_GROUP_ID      -- 2017-11-04 kimcd 제품 특성별 계획 배포용. 제품 특성 변수 추가
											, @INSTANCE_ID
											, @INSTANCE_TYPE
											, @UPDATE_BY
											, @PLAN_ID

		WHILE (@@FETCH_STATUS = 0)
			BEGIN	 
				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------
				  -- ERP 배포 : START
				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------

				  -- ERP 배포
				  BEGIN
								SET @n_log_count = @n_log_count + 1
								SET @v_descr = @INSTANCE_ID + ' PR_XIF_ERP_PRODUCTION_PLAN_S Start'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
					
								EXEC PR_XIF_ERP_PRODUCTION_PLAN_S @PLAN_ID

								SET @n_log_count = @n_log_count + 1
								SET @v_descr = @INSTANCE_ID + ' PR_XIF_ERP_PRODUCTION_PLAN_S End'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
				  END
      
				  -- MES 배포
				  BEGIN
								SET @n_log_count = @n_log_count + 1
								SET @v_message = @INSTANCE_ID + ' PR_XIF_MES_WO_PEGGING_S Start'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
					
								EXEC PR_XIF_MES_WO_PEGGING_S @PLAN_ID

								SET @n_log_count = @n_log_count + 1
								SET @v_message = @INSTANCE_ID + ' PR_XIF_MES_WO_PEGGING_S End'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
          
								SET @n_log_count = @n_log_count + 1
								SET @v_message = @INSTANCE_ID + ' PR_XIF_MES_WO_S Start'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
					
								EXEC PR_XIF_MES_WO_S @PLAN_ID

								SET @n_log_count = @n_log_count + 1
								SET @v_message = @INSTANCE_ID + ' PR_XIF_MES_WO_S End'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
          
								SET @n_log_count = @n_log_count + 1
								SET @v_message = @INSTANCE_ID + ' PR_XIF_MES_DAILY_PP_S Start'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
					
								EXEC PR_XIF_MES_DAILY_PP_S @PLAN_ID

								SET @n_log_count = @n_log_count + 1
								SET @v_message = @INSTANCE_ID + ' PR_XIF_MES_DAILY_PP_S End'
								EXEC PR_LOG_PROCESS @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
				  END

				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------
				  -- ERP 배포 : END
				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------
				  -----------------------------------------------------------------------------------------------------------
				  
					----------------------------------- 10. PR_XIF_MES_ERP_WO_MASTER 프로시저 실행 시작 -----------------------------------
					-- 활성화는 실행안함 활성화 타입만 빼야하고 FORM_FW 는 추가하는 거로 개선해야 함 @@@
					--IF @v_instance_type != 'F'
					/*BEGIN
						EXEC PR_XIF_MES_ERP_WO_MASTER @PLAN_ID
		
						--LOG 생성
						SET @v_message = @INSTANCE_ID + 'PR_XIF_MES_ERP_WO_MASTER'
						SET @n_log_count = @n_log_count + 1
						EXECUTE pr_log_process  @sysdate, @INSTANCE_ID, @PLAN_ID, @v_proc_name, null, 'CALL', @n_log_count, null, @v_message, null
					
					END
		*/
					----------------------------------- 10. PR_XIF_MES_ERP_WO_MASTER 프로시저 실행 종료 -----------------------------------
      
				  BEGIN
					IF @PLAN_GROUP_ID = '-' -- 2017-11-04 kimcd 동별 배포의 경우만 수행
						BEGIN
							SET @v_temp1 = 'DELETE FP_RELEASE_PLAN_INFO_H-FACTORY BASE'
							DELETE FROM A
							FROM   FP_RELEASE_PLAN_INFO_H A,
								   (
									SELECT A.INSTANCE_ID
										 , A.PLAN_DATE    AS INSTANCE_DATE
										 , A.DIVISION_ID
										 , B.FACTORY_ID
										 , @PLAN_ID       AS RELEASE_PLAN_ID
										 , PLAN_ID        AS AMEND_PLAN_ID
									FROM   SCM_FP_PLAN_DETAIL_H A,
										   (
											SELECT DISTINCT
												   A.DIVISION_ID, A.FACTORY_ID
											FROM   SCM_FACTORY_M A WITH(NOLOCK),
												   FP_INSTANCE_FACTORY_M B WITH(NOLOCK)
											WHERE  A.FACTORY_ID  = B.FACTORY_ID
											AND    B.INSTANCE_ID = CASE WHEN @INSTANCE_ID = 'KR_CELL_M_P' THEN
																	   'KR_CELL_M'
																   ELSE @INSTANCE_ID END -- kimcd 2017-08-19 Instance id 변환. 오창 소형 조립 Pilot 경우 위해
										   ) B
									WHERE  A.INSTANCE_ID  = @INSTANCE_ID
									AND    A.PLAN_DATE    = @BASE_DATE
									AND    A.DIVISION_ID  = B.DIVISION_ID
									AND    (CASE WHEN A.FACTORY_ID='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END=B.FACTORY_ID) 
									AND    A.FACTORY_ID   = @LINK_FACTORY_ID    -- 동별로 RELEASE 2017-11-04 kimcd 조건 변수 변경. FACTORY_ID -> LINK_FACTORY_ID
								   ) B
							WHERE  A.INSTANCE_DATE    = B.INSTANCE_DATE
							AND    A.INSTANCE_ID      = B.INSTANCE_ID
							AND    A.DIVISION_ID      = B.DIVISION_ID
							AND    A.FACTORY_ID       = B.FACTORY_ID
							AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
							AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
							AND   EXISTS (
										  SELECT 1
										  FROM   FP_PRODUCTION_PLAN_R X
										  WHERE  X.INSTANCE_ID  = @INSTANCE_ID
										  AND    X.FP_PLAN_ID   = @PLAN_ID
										  AND    X.FACTORY_ID   = A.FACTORY_ID       -- 실재 존재하는 FACTORY 만
										  AND    X.FACTORY_ID   = @LINK_FACTORY_ID   -- 동별로 RELEASE  2017-11-04 kimcd 조건 변수 변경. FACTORY_ID -> LINK_FACTORY_ID
										 )
						END  -- 2017-11-04 kimcd 동별 배포의 경우만 수행

					-- 2017-11-04 kimcd 제품 특성. plan group 기반으로 배포할 경우 삭제 과정 추가 시작
					IF @LINK_FACTORY_ID = '-' -- 제품 특성 기준으로 배포하는 경우만 수행
						BEGIN
							SET @v_temp1 = 'DELETE FP_RELEASE_PLAN_INFO_H-PLAN GROUP BASE'
							DELETE FROM A
							FROM   FP_RELEASE_PLAN_INFO_H A,
								   (
									SELECT A.INSTANCE_ID
										 , A.PLAN_DATE    AS INSTANCE_DATE
										 , A.PLAN_GROUP_ID
										 , @PLAN_ID       AS RELEASE_PLAN_ID
										 , PLAN_ID        AS AMEND_PLAN_ID
									FROM   SCM_FP_PLAN_GROUP_DETAIL_H A
									WHERE  A.INSTANCE_ID   = @INSTANCE_ID
									AND    A.PLAN_DATE     = @BASE_DATE
									AND    A.PLAN_GROUP_ID = @PLAN_GROUP_ID    -- 2017-11-04 kimcd plan group 기반으로 배포할 경우 조건
								   ) B
							WHERE  A.INSTANCE_DATE    = B.INSTANCE_DATE
							AND    A.INSTANCE_ID      = B.INSTANCE_ID
							AND    A.FACTORY_ID       = '-'
							AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
							AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
							AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
							AND   EXISTS (
										  SELECT 1
										  FROM   SCM_LINE_M           SL WITH(NOLOCK)
												,FP_PRODUCTION_PLAN_R X
										  WHERE  SL.FACTORY_ID   = X.FACTORY_ID
										  AND    SL.LINE_ID      = X.LINE_ID
										  AND    SL.OPERATION_ID = X.OPERATION_ID
										  AND    SL.MODEL_TYPE   = @PLAN_GROUP_ID
										  AND    X.INSTANCE_ID   = @INSTANCE_ID
										  AND    X.FP_PLAN_ID    = @PLAN_ID
										 )
						END
					-- 2017-11-04 kimcd 제품 특성. plan group 기반으로 배포할 경우 삭제 과정 추가 끝
        
					IF @PLAN_GROUP_ID = '-' -- 2017-11-04 kimcd 동별 배포의 경우만 수행
						BEGIN
							SET @v_temp1 = 'INSERT FP_RELEASE_PLAN_INFO_H - FACTORY'
							-- RELEASE 는 모두 적재
							INSERT INTO FP_RELEASE_PLAN_INFO_H
								 (
								   INSTANCE_ID
								 , INSTANCE_DATE
								 , DIVISION_ID
								 , FACTORY_ID
								 , PLAN_GROUP_ID     -- 2017-11-04 kimcd 추가 제품 특성별 배포
								 , RELEASE_PLAN_ID
								 , AMEND_PLAN_ID
								 , INSERT_ID
								 , INSERT_TIME       
								 )
							SELECT A.INSTANCE_ID
								 , A.PLAN_DATE    AS INSTANCE_DATE
								 , A.DIVISION_ID
								 , B.FACTORY_ID
								 , '-'               -- 2017-11-04 kimcd 추가 제품 특성별 배포
								 , @PLAN_ID       AS RELEASE_PLAN_ID
								 , PLAN_ID        AS AMEND_PLAN_ID
								 , @UPDATE_BY     AS INSERT_ID
								 , GETDATE()      AS INSERT_TIME       
							FROM   SCM_FP_PLAN_DETAIL_H A,
								   (
									SELECT DISTINCT
										   A.DIVISION_ID, A.FACTORY_ID
									FROM   SCM_FACTORY_M A WITH(NOLOCK),
										   FP_INSTANCE_FACTORY_M B WITH(NOLOCK)
									WHERE  A.FACTORY_ID  = B.FACTORY_ID
									AND    B.INSTANCE_ID = CASE WHEN @INSTANCE_ID = 'KR_CELL_M_P' THEN
																'KR_CELL_M'
															ELSE @INSTANCE_ID END -- kimcd 2017-08-19 Instance id 변환. 오창 소형 조립 Pilot 경우 위해
								   ) B
							WHERE  A.INSTANCE_ID  = @INSTANCE_ID
							AND    A.PLAN_DATE    = @BASE_DATE
							AND    A.DIVISION_ID  = B.DIVISION_ID
							AND    (CASE WHEN A.FACTORY_ID='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END=B.FACTORY_ID)
							AND    A.FACTORY_ID   = @LINK_FACTORY_ID    -- 동별로 RELEASE 2017-11-04 kimcd 조건 변수 변경. FACTORY_ID -> LINK_FACTORY_ID 
							AND   EXISTS (
										  SELECT 1
										  FROM   FP_PRODUCTION_PLAN_R X
										  WHERE  X.INSTANCE_ID  = @INSTANCE_ID
										  AND    X.FP_PLAN_ID   = @PLAN_ID
										  AND    X.FACTORY_ID   = A.FACTORY_ID    -- 살재 존재하는 FACTORY 만
										  AND    X.FACTORY_ID   = @LINK_FACTORY_ID   -- 동별로 RELEASE  2017-11-04 kimcd 조건 변수 변경. FACTORY_ID -> LINK_FACTORY_ID
										 )
						END -- 2017-11-04 kimcd 동별 배포의 경우만 수행

					-- 2017-11-04 kimcd 제품 특성. plan group 기반으로 배포할 경우 입력 과정 추가 시작
					IF @LINK_FACTORY_ID = '-' -- 제품 특성 기준으로 배포하는 경우만 수행
						BEGIN
							SET @v_temp1 = 'INSERT FP_RELEASE_PLAN_INFO_H - PLAN GROUP'
							INSERT INTO FP_RELEASE_PLAN_INFO_H
								 (
								   INSTANCE_ID
								 , INSTANCE_DATE
								 , DIVISION_ID
								 , FACTORY_ID
								 , PLAN_GROUP_ID
								 , RELEASE_PLAN_ID
								 , AMEND_PLAN_ID
								 , INSERT_ID
								 , INSERT_TIME       
								 )
							SELECT A.INSTANCE_ID
								 , A.PLAN_DATE    AS INSTANCE_DATE
								 /* 2017-11-22 kimcd 정상 release하는 경우 값이 없어서 수정함
								 , (SELECT TOP 1 W.DIVISION_ID FROM FP_PRODUCTION_PLAN_R W
									WHERE  W.INSTANCE_ID = @INSTANCE_ID
									AND    W.FP_PLAN_ID  = @PLAN_ID)   AS DIVISION_ID*/
								 , '-'  -- DIVISION_ID  2017-11-22 kimcd division id 안 넣는 것으로 수정 - plan release data 참조
								 , '-'  -- FACTORY_ID
								 , A.PLAN_GROUP_ID
								 , @PLAN_ID       AS RELEASE_PLAN_ID
								 , PLAN_ID        AS AMEND_PLAN_ID
								 , @UPDATE_BY     AS INSERT_ID
								 , GETDATE()      AS INSERT_TIME       
							FROM   SCM_FP_PLAN_GROUP_DETAIL_H A
							WHERE  A.INSTANCE_ID   = @INSTANCE_ID
							AND    A.PLAN_DATE     = @BASE_DATE
							AND    A.PLAN_GROUP_ID = @PLAN_GROUP_ID    -- 2017-11-04 kimcd plan group 기반으로 배포할 경우 조건
							AND   EXISTS (
										  SELECT 1
										  FROM   SCM_LINE_M           SL WITH(NOLOCK)
												,FP_PRODUCTION_PLAN_R X
										  WHERE  SL.FACTORY_ID   = X.FACTORY_ID
										  AND    SL.LINE_ID      = X.LINE_ID
										  AND    SL.OPERATION_ID = X.OPERATION_ID
										  AND    SL.MODEL_TYPE   = @PLAN_GROUP_ID
										  AND    X.INSTANCE_ID   = @INSTANCE_ID
										  AND    X.FP_PLAN_ID    = @PLAN_ID
										 )
						END
					-- 2017-11-04 kimcd 제품 특성. plan group 기반으로 배포할 경우 입력 과정 추가 끝
				END

				SET @v_temp1 = 'UPDATE FP_RELEASE_FIX_PLAN_H'
				UPDATE SCM_FP_PLAN_H
				SET    RELEASE_FLAG = 'Y'
					,  RELEASE_TIME = GETDATE()
				WHERE  [INSTANCE_ID] = @INSTANCE_ID
				AND    [PLAN_ID]     = @PLAN_ID
				AND    [PLAN_TYPE]   = 'RELEASE'

				IF @PLAN_GROUP_ID = '-'
					BEGIN
						SET @v_temp1 = 'UPDATE FP_RELEASE_FIX_PLAN_H'
						UPDATE SCM_FP_PLAN_DETAIL_H SET
								 RELEASE_TIME     = GETDATE() 
								,RELEASE_FLAG     = 'Y'
						WHERE  INSTANCE_ID      = @INSTANCE_ID
						AND    PLAN_DATE        = CONVERT(NVARCHAR(8), @BASE_DATE, 112)
						AND    FACTORY_ID       = @LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반으로 배포할 경우 대응용 변수 변경
					END
				ELSE
					BEGIN
						SET @v_temp1 = 'UPDATE FP_RELEASE_FIX_PLAN_H'
						UPDATE SCM_FP_PLAN_GROUP_DETAIL_H SET
								 RELEASE_TIME     = GETDATE() 
								,RELEASE_FLAG     = 'Y'
						WHERE  INSTANCE_ID      = @INSTANCE_ID
						AND    PLAN_DATE        = CONVERT(NVARCHAR(8), @BASE_DATE, 112)
						AND    PLAN_GROUP_ID    = @PLAN_GROUP_ID     -- 2017-11-04 kimcd plan group 기반으로 배포할 경우 조건
					END;

				FETCH NEXT FROM CUR_SEND_PLAN_ID INTO @COMPANY_ID
													,@DIVISION_ID
													,@SITE_ID
													,@PLANT_ID
													,@LINK_FACTORY_ID  -- 2017-11-04 kimcd plan group 기반으로 배포할 경우 대응용 변수 변경
													,@PLAN_GROUP_ID    -- 2017-11-04 kimcd plan group 기반으로 배포할 경우 조건 추가
													,@INSTANCE_ID
													,@INSTANCE_TYPE
													,@UPDATE_BY
													,@PLAN_ID

			END;
			
			CLOSE CUR_SEND_PLAN_ID;
			DEALLOCATE CUR_SEND_PLAN_ID;  
		END;
	--	COMMIT TRANSACTION;
		WAITFOR DELAY '0:0:3' -- 선행 Transaction 종료 대기

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, 'END MANUAL WO CREATE AND SEND', '############### End of procedure ###############', NULL, @sysdate

	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

END

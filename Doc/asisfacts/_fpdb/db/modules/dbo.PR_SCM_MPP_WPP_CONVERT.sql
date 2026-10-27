
-- CREATE PROCEDURE [dbo].[PR_SCM_MPP_WPP_CONVERT]
CREATE PROCEDURE [dbo].[PR_SCM_MPP_WPP_CONVERT]

-- ================================================================================================
-- Program ID          : FP01628
-- Program Name        : PR_SCM_MPP_WPP_CONVERT
-- Param               :
-- Batch Period        : called from Amend UI
-- Description         :
--
-- Source System       : FP Engine Plan
-- Destination System  : FP MPP WPP
-- Source Table        : FP_DAILY_PRODUCTIOIN_PLAN_R, SCM_FP_PLAN_H
-- Destination Table   : FP_MPP_WPP_BASE_PLAN_H, FP_MPP_WPP_BASE_PLAN_M
--
-- Create(Update) Date : 2022-11-02
-- Author              : KIMCD
-- Version             : 2.0
--                       매개변수 추가 WPP 주차, MPP 월
--                       1.2
--                       PIYONG 계획 이력 정보에 MPP, WPP 확정 계획 추가
--                       2018-04-09 kimcd FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량.
--                                        Pancake Meter, Jumbo Roll Meter, Batch Qty, Cell 수량 추가
--                       2018-04-23 kimcd MPP, WPP 계획은 계획 편성 일자로만 전송됨.
--                                        동일월, 동일 주의 과거 일자 계획은 기존 MPP, WPP 기준으로 정보 추가 형성함.
--                       2018-05-15 kimcd 일자별 계획 전송에서 LOCK 발생하는 경우 발생하여 
--                                        FP_DAILY_PRODUCTIOIN_PLAN_H 삭제 과정에서 NOLOCK 삭제
--                       2019-02-25 kimcd 일자별 계획 누적에서 정보 삭제 기준을 Plan Group 제거하고 라인 기준으로 변경
--                       2019-03-05 kimcd 전면 재개발
--                                        CONDITION_TYPE : 매개변수 유형
--											INSTANCE_ID  : FP Instance ID
--											FP_PLAN_ID   : 매개변수 전달된 확정 Plan Id
--											TYPE         : WPP, MPP 구분
--											TABLE_NAME   : 정보 조회해야 할 Table 정의 - 전극, Cell, Form, Pack 구분용
--											LINE_ID      : 재형성해야 할 Line
--											OPERATION_ID : 재형성해야 할 공정
--											FROM_DATE    : 재형성 일자 범위 From
--											TO_DATE      : 재형성 일자 범위 To
--                       2019-03-27 kimcd 전극 일별 계획 수량 컬럼 수정 M - WPP_OUT_QTY_M EA - WPP_OUT_QTY_CELL
--                       2019-03-27 kimcd 일자별 계획 형성에서 중복 오류 보완
--                       2019-04-08 kimcd 최종 릴리즈 아닌 history로 변경
--						 2019-08-27 PIYONG 전극 [ROLL_IN_QTY], [JR_IN_QTY], [CELL_IN_QTY], [BATCH_IN_QTY] 수량 추가
--						 2020-01-30 PIYONG FP_AMEND_PLAN_FORM_H 의 PRODUCTION_TYPE 생성 로직 변경
--                       2020-03-05 kimcd  오류 수정 - Active_flag 조건 추가
--                       2021-08-26 kimcd  MPP, WPP 계획과 DPP의 DW 취합 기준을 1원화하기 위해서 기존 정보 삭제하지 않고 수량 갱신함
--                       2021-09-17 kimcd  설비를 '-'로 넣는 조립,활성화,Pack에서 ELECTRODE_TYPE을 ON 조건에서 제거
--                       2022-06-09 kimcd  location을 항상 라인 값 기준으로 갱신하도록 함
--                       2022-11-02 kimcd  전극 version, ec no 추가 관리
--                       2023-10-01 FP Pjt. WPP/MPP에 Cell PLM_EC_NO 적용
-- ================================================================================================
    @P_CALL_SEQUENCE_ID NVARCHAR(30)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MPP_WPP_CONVERT'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(200)
	DECLARE @v_temp2     NVARCHAR(200)
	DECLARE @v_temp3     NVARCHAR(200)
	DECLARE @INSTANCE_ID  NVARCHAR(50)  -- : FP Instance ID
	DECLARE @FP_PLAN_ID   NVARCHAR(50)  -- : 매개변수 전달된 확정 Plan Id
	DECLARE @TYPE         NVARCHAR(10)  -- : WPP, MPP 구분
	DECLARE @TABLE_NAME   NVARCHAR(50)  -- : 정보 조회해야 할 Table 정의 - 전극, Cell, Form, Pack 구분용
	DECLARE @FROM_DATE    DATETIME      -- : 재형성 일자 범위 From
	DECLARE @TO_DATE      DATETIME      -- : 재형성 일자 범위 To									
	DECLARE @FACTORY_ID    NVARCHAR(30)
	DECLARE @PLAN_GROUP_ID NVARCHAR(50)
	DECLARE @USER_ID       NVARCHAR(50)

	DECLARE @PLAN_WEEK   NVARCHAR(10)
	DECLARE @FIRST_CREATE_DATE  DATE
	DECLARE @SECOND_CREATE_DATE DATE
	DECLARE @THIRD_CREATE_DATE  DATE
	DECLARE @FOURTH_CREATE_DATE DATE
	DECLARE @PLAN_MONTH   NVARCHAR(10)
	
	DECLARE @TEMP_TABLE TABLE (
			 PLAN_WEEK         NVARCHAR(10)
			,PLAN_REVISION     NVARCHAR(100)
			,CURRENT_NUM       INTEGER ) -- 2017-12-27 kimcd REVISION을 누적하여 채번하기 위해 변수 선언

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp3 = 'CALL_SEQUENCE_ID: ' + ISNULL(@P_CALL_SEQUENCE_ID ,'')

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', @v_temp3, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
		IF @P_CALL_SEQUENCE_ID = ''
			SET @P_CALL_SEQUENCE_ID = NULL

		IF (@P_CALL_SEQUENCE_ID IS NULL)
			BEGIN
				RAISERROR ('Parameter Call Sequence_id is NULL. The Parameter is Required Value.', -- Message text.
							16, -- Severity.
							1 -- State.
							);
			END;

		SELECT  @INSTANCE_ID  = MAX(CASE WHEN CONDITION_TYPE = 'INSTANCE_ID' THEN CONDITION_VALUE END)  -- : FP Instance ID
			   ,@FP_PLAN_ID   = MAX(CASE WHEN CONDITION_TYPE = 'FP_PLAN_ID' THEN CONDITION_VALUE END)  -- : 매개변수 전달된 확정 Plan Id
			   ,@TYPE         = MAX(CASE WHEN CONDITION_TYPE = 'TYPE' THEN CONDITION_VALUE END)  -- : WPP, MPP 구분
			   ,@TABLE_NAME   = MAX(CASE WHEN CONDITION_TYPE = 'TABLE_NAME' THEN CONDITION_VALUE END)  -- : 정보 조회해야 할 Table 정의 - 전극, Cell, Form, Pack 구분용
			   ,@FROM_DATE    = CONVERT(DATETIME, MAX(CASE WHEN CONDITION_TYPE = 'FROM_DATE' THEN CONDITION_VALUE END), 112)  -- : 재형성 일자 범위 From
			   ,@TO_DATE      = CONVERT(DATETIME, MAX(CASE WHEN CONDITION_TYPE = 'TO_DATE' THEN CONDITION_VALUE END), 112)  -- : 재형성 일자 범위 To
			   ,@USER_ID      = MAX(INSERT_ID)	
		FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
		WHERE  CALL_SEQUENCE = @P_CALL_SEQUENCE_ID
		AND    CONDITION_TYPE IN  ('INSTANCE_ID','FP_PLAN_ID','TYPE','TABLE_NAME', 'FROM_DATE', 'TO_DATE')

		SELECT @PLAN_GROUP_ID = A.PLAN_GROUP_ID
			  ,@FACTORY_ID    = A.FACTORY_ID
		FROM  (	SELECT A.PLAN_GROUP_ID
					  ,A.FACTORY_ID
					  ,ROW_NUMBER() OVER (ORDER BY INSERT_TIME DESC) AS R_NUM
				FROM   DBO.FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
				WHERE  A.INSTANCE_ID     = @INSTANCE_ID
				AND    A.RELEASE_PLAN_ID = @FP_PLAN_ID ) A
		WHERE  R_NUM = 1  -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경

		IF @TYPE = 'WPP'
			BEGIN
				DECLARE C_WEEK_DATE  CURSOR FOR
					SELECT WEEK, CASE WHEN MIN(WEEKSTART_DATE) < @FROM_DATE THEN
									  MIN(WEEKSTART_DATE)
								 END                            AS FIRST_CREATE_DATE
								,CASE WHEN MIN(WEEKSTART_DATE) < @FROM_DATE THEN
									  @FROM_DATE
								 ELSE  MIN(WEEKSTART_DATE) END  AS SECOND_CREATE_DATE
								,CASE WHEN MAX(WEEKEND_DATE) > @TO_DATE THEN
									  @TO_DATE
								 ELSE  MAX(WEEKEND_DATE) END    AS THIRD_CREATE_DATE
								,CASE WHEN MAX(WEEKEND_DATE) > @TO_DATE THEN
									  MAX(WEEKEND_DATE)
								 END                            AS FOURTH_CREATE_DATE
					FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
					WHERE  SSC.DATE_ID >= @FROM_DATE
					AND    SSC.DATE_ID <= @TO_DATE 
					GROUP  BY WEEK

				IF @TABLE_NAME = 'FP_AMEND_PLAN_CELL_H'
					BEGIN
						OPEN C_WEEK_DATE
				        FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,(  SELECT SSC.YEAR + SSC.MONTH
										FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
										WHERE  SSC.DATE_ID = CONVERT(DATE,SP.PLAN_START_TIME))  -- [PLAN_MONTH]
									,'Y'-- WPP
									,'N' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SP.INSTANCE_ID    = @INSTANCE_ID

							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							--INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
							--		(   [PLAN_WEEK]
							--			,[PLAN_REVISION]
							--			,[COMPANY_ID]
							--			,[DIVISION_ID]
							--			,[SITE_ID]
							--			,[PLANT_ID]
							--			,[FACTORY_ID]
							--			,[LINE_ID]
							--			,[OPERATION_ID]
							--			,[EQUIPMENT_ID]
							--			,[PRODUCTION_TYPE]
							--			,[ITEM_ID]
							--			,[PLAN_DATE]
							--			,[PLAN_QTY]
							--			,[ROLL_QTY]
							--			,[JR_QTY]
							--			,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
							--			,[BATCH_QTY]
							--			,[INSERT_ID]
							--			,[INSERT_TIME]
							--			,[UPDATE_ID]
							--			,[UPDATE_TIME]
							--			,[MARKET]
							--			)
							--SELECT @PLAN_WEEK
							--		,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
							--			FROM   @TEMP_TABLE T
							--			WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
							--		,MAX(DP.COMPANY_ID)
							--		,MAX(DP.DIVISION_ID)
							--		,MAX(DP.SITE_ID)
							--		,MAX(DP.PLANT_ID)
							--		,DP.FACTORY_ID
							--		,DP.LINE_ID
							--		,DP.OPERATION_ID
							--		,'-' -- [EQUIPMENT_ID]
							--		,DP.PRODUCTION_TYPE
							--		,DP.ITEM_ID
							--		,DP.PLAN_DATE
							--		,SUM(DP.WPP_OUT_QTY)    -- PLAN QTY
							--		,NULL                   -- ROLL QTY
							--		,NULL                   -- JR QTY
							--		,SUM(DP.WPP_CELL_OUT_QTY)   -- 2018-04-09 kimcd cell out 수량 추가
							--		,NULL                   -- BATCH QTY
							--		,@USER_ID               -- INSERT ID
							--		,GETDATE()              -- INSERT TIME
							--		,@USER_ID               -- UPDATE ID
							--		,GETDATE()              -- UPDATE TIME
							--		,ISNULL(DP.MARKET, 'D') -- PLAN_GROUP_ID
							--FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
							--		FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
							--		WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
							--		AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
							--		,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
							--		,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
							--		,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							--WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							--AND    SL.LINE_ID        = DP.LINE_ID
							--AND    SL.OPERATION_ID   = DP.OPERATION_ID
							--AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							--AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							--AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							--AND    SP.INSTANCE_ID    = @INSTANCE_ID
							--AND    SP.PLAN_ID        = @FP_PLAN_ID
							--AND    DP.INSTANCE_ID    = @INSTANCE_ID
							--AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							--AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							--AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							--AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'LINE_ID' )
							--AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'OPERATION_ID' )
							--GROUP  BY SP.PLAN_WEEK
							--			,DP.FP_PLAN_ID 
							--			,SL.MODEL_TYPE
							--			,DP.PLAN_DATE
							--			,DP.LINE_ID
							--			,DP.OPERATION_ID
							--			,DP.ITEM_ID
							--			,DP.FACTORY_ID
							--			,DP.PRODUCTION_TYPE
							--			,ISNULL(DP.MARKET, 'D');

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(    [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_QTY]
										,[JR_QTY]
										,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										)
                                SELECT  [PLAN_WEEK]
										,[PLAN_REVISION]
										,MAX([COMPANY_ID]) 
										,MAX([DIVISION_ID])
										,MAX([SITE_ID])
										,MAX([PLANT_ID])
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,SUM([PLAN_QTY])        AS PLAN_QTY
										,NULL                   AS ROLL_QTY
										,NULL                   AS JR_QTY
										,SUM([CELL_QTY])        AS CELL_QTY
										,NULL                   AS BATCH_QTY
										,@USER_ID               AS INSERT_ID
										,GETDATE()              AS INSERT_TIME
										,@USER_ID               AS UPDATE_ID
										,GETDATE()              AS UPDATE_TIME
										,[MARKET]

                                FROM (
										SELECT @PLAN_WEEK AS PLAN_WEEK
												,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
													FROM   @TEMP_TABLE T
													WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
													AS PLAN_REVISION
												,MAX(DP.COMPANY_ID) AS COMPANY_ID
												,MAX(DP.DIVISION_ID) AS DIVISION_ID
												,MAX(DP.SITE_ID) AS SITE_ID
												,MAX(DP.PLANT_ID) AS PLANT_ID
												,DP.FACTORY_ID AS FACTORY_ID
												,DP.LINE_ID
												,DP.OPERATION_ID
												,'-'      AS EQUIPMENT_ID
												,DP.PRODUCTION_TYPE
												,DP.ITEM_ID
												,DP.PLAN_DATE
												,SUM(DP.WPP_OUT_QTY)    AS PLAN_QTY
												,SUM(DP.WPP_CELL_OUT_QTY)   AS CELL_QTY-- 2018-04-09 kimcd cell out 수량 추가
												,ISNULL(DP.MARKET, 'D') AS MARKET
										FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
														,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
												FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
												WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
												AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
												,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
												,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
												,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
										WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
										AND    SL.LINE_ID        = DP.LINE_ID
										AND    SL.OPERATION_ID   = DP.OPERATION_ID
										AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
										AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
										AND    SP.PLAN_ID        = DP.FP_PLAN_ID
										AND    SP.INSTANCE_ID    = @INSTANCE_ID
										AND    SP.PLAN_ID        = @FP_PLAN_ID
										AND    DP.INSTANCE_ID    = @INSTANCE_ID
										AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
										AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
										AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
										AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'LINE_ID' )
										AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP  BY SP.PLAN_WEEK
													,DP.FP_PLAN_ID 
													,SL.MODEL_TYPE
													,DP.PLAN_DATE
													,DP.LINE_ID
													,DP.OPERATION_ID
													,DP.ITEM_ID
													,DP.FACTORY_ID
													,DP.PRODUCTION_TYPE
													,ISNULL(DP.MARKET, 'D')
                                   ) AS X
								   GROUP BY 
										[PLAN_WEEK]
									   ,[PLAN_REVISION]
									   ,[FACTORY_ID]
									   ,[LINE_ID]
									   ,[OPERATION_ID]
									   ,[EQUIPMENT_ID]
									   ,[PRODUCTION_TYPE]
									   ,[ITEM_ID]
									   ,[PLAN_DATE]
									   ,[MARKET]
										;


							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM(  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_WEEK_DATE;
						DEALLOCATE C_WEEK_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'WPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- WPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( 
							SELECT B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,A.FACTORY_ID
									,A.PLAN_GROUP_ID
									,(SELECT TOP 1 INSTANCE_TYPE
										FROM ( SELECT FF.INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID != 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID = 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
									,A.TOP_ITEM_ID
									,A.ITEM_ID
									,A.OPERATION_ID
									,ISNULL((SELECT LOCATION 
												FROM SCM_LINE_M WITH(NOLOCK)
												WHERE LINE_ID = A.LINE_ID
												AND OPERATION_ID = A.OPERATION_ID
												AND FACTORY_ID = A.FACTORY_ID
												AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
									,A.FP_PRODUCTION_TYPE
									,A.MARKET
									,A.LINE_ID
									,A.ELECTRODE_TYPE
									,A.PLAN_DATE
									,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
									,A.PLAN_IN_QTY
									,'PR_SCM_MPP_WPP_CONVERT' AS [INSERT_ID]
									,GETDATE() AS [INSERT_TIME]
									,'PR_SCM_MPP_WPP_CONVERT' AS [UPDATE_ID]
									,GETDATE() AS [UPDATE_TIME]
									,'WPP'  AS [PLAN_TYPE]       -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
									,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.ROLL_IN_QTY
									,A.ROLL_OUT_QTY
									,A.JR_IN_QTY
									,A.JR_OUT_QTY
									,A.BATCH_IN_QTY
									,A.BATCH_OUT_QTY
									,A.CELL_IN_QTY
									,A.CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM (
									SELECT PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
											,ISNULL(MARKET,'D') AS MARKET
											,LINE_ID
											,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
											,PP.PLAN_DATE
											,SUM(WPP_OUT_QTY) AS PLAN_QTY
											,SUM(WPP_IN_QTY) AS PLAN_IN_QTY
											,MAX(A.INSTANCE_ID) AS INSTANCE_ID
											,'-'                    AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
											,NULL                   AS ROLL_IN_QTY
											,NULL                   AS ROLL_OUT_QTY
											,NULL                   AS JR_IN_QTY
											,NULL                   AS JR_OUT_QTY
											,NULL                   AS BATCH_IN_QTY
											,NULL                   AS BATCH_OUT_QTY
											,SUM(PP.WPP_CELL_IN_QTY)    AS CELL_IN_QTY
											,SUM(PP.WPP_CELL_OUT_QTY)   AS CELL_OUT_QTY
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
											,'-' AS [WORK_REQUEST_MODEL_ID]
											,'-' AS [VERSION]
											,'-' AS [PROD_SEQ]
											,PP.PLM_EC_NO AS [PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										FROM FP_AMEND_PLAN_CELL_H PP WITH(NOLOCK),
											(SELECT TOP 1
														   INSTANCE_DATE AS PLAN_DATE
														 , INSTANCE_ID
														 , DIVISION_ID
														 , FACTORY_ID
														 , PLAN_GROUP_ID
														 , RELEASE_PLAN_ID
													FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
													WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
													AND    INSTANCE_ID     = @INSTANCE_ID
													ORDER BY C.INSERT_TIME DESC
													) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경		
										WHERE A.INSTANCE_ID  = @INSTANCE_ID
										AND   PP.INSTANCE_ID = @INSTANCE_ID
										AND   PP.PLAN_DATE  >= @FROM_DATE
										AND   PP.PLAN_DATE  <= @TO_DATE
										AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
										AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'LINE_ID' )
										AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP BY PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
											,ISNULL(MARKET,'D')
											,LINE_ID
											,PP.PLAN_DATE
											,PP.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									) A
									, SCM_FACTORY_M B WITH(NOLOCK)
								WHERE A.FACTORY_ID = B.FACTORY_ID ) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]       = B.[VERSION]
							AND	DP.[PROD_SEQ]      = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]     = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID] )
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);

					END; -- IF @TABLE_NAME = 'FP_AMEND_PLAN_CELL_H'
				ELSE IF @TABLE_NAME = 'FP_AMEND_PLAN_PACK_H'
					BEGIN
						OPEN C_WEEK_DATE
				        FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,(  SELECT SSC.YEAR + SSC.MONTH
										FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
										WHERE  SSC.DATE_ID = CONVERT(DATE,SP.PLAN_START_TIME))  -- [PLAN_MONTH]
									,'Y'-- WPP
									,'N' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							--INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
							--		(   [PLAN_WEEK]
							--			,[PLAN_REVISION]
							--			,[COMPANY_ID]
							--			,[DIVISION_ID]
							--			,[SITE_ID]
							--			,[PLANT_ID]
							--			,[FACTORY_ID]
							--			,[LINE_ID]
							--			,[OPERATION_ID]
							--			,[EQUIPMENT_ID]
							--			,[PRODUCTION_TYPE]
							--			,[ITEM_ID]
							--			,[PLAN_DATE]
							--			,[PLAN_QTY]
							--			,[ROLL_QTY]
							--			,[JR_QTY]
							--			,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
							--			,[BATCH_QTY]
							--			,[INSERT_ID]
							--			,[INSERT_TIME]
							--			,[UPDATE_ID]
							--			,[UPDATE_TIME]
							--			,[MARKET])
							--SELECT @PLAN_WEEK
							--		,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
							--			FROM   @TEMP_TABLE T
							--			WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
							--		,MAX(DP.COMPANY_ID)
							--		,MAX(DP.DIVISION_ID)
							--		,MAX(DP.SITE_ID)
							--		,MAX(DP.PLANT_ID)
							--		,DP.FACTORY_ID
							--		,DP.LINE_ID
							--		,DP.OPERATION_ID
							--		,'-' -- [EQUIPMENT_ID]
							--		,DP.PRODUCTION_TYPE
							--		,DP.ITEM_ID
							--		,DP.PLAN_DATE
							--		,SUM(DP.WPP_OUT_QTY)    -- PLAN QTY
							--		,NULL                   -- ROLL QTY
							--		,NULL                   -- JR QTY
							--		,NULL                   -- CELL QTY   -- 2018-04-09 kimcd cell out 수량 추가
							--		,NULL                   -- BATCH QTY
							--		,@USER_ID               -- INSERT ID
							--		,GETDATE()              -- INSERT TIME
							--		,@USER_ID               -- UPDATE ID
							--		,GETDATE()              -- UPDATE TIME
							--		,ISNULL(DP.MARKET, 'D') -- PLAN_GROUP_ID
							--FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
							--		FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
							--		WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
							--		AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
							--		,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
							--		,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
							--		,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							--WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							--AND    SL.LINE_ID        = DP.LINE_ID
							--AND    SL.OPERATION_ID   = DP.OPERATION_ID
							--AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							--AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							--AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							--AND    SP.INSTANCE_ID    = @INSTANCE_ID
							--AND    SP.PLAN_ID        = @FP_PLAN_ID
							--AND    DP.INSTANCE_ID    = @INSTANCE_ID
							--AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							--AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							--AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							--AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'LINE_ID' )
							--AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'OPERATION_ID' )
							--GROUP  BY SP.PLAN_WEEK
							--			,DP.FP_PLAN_ID 
							--			,SL.MODEL_TYPE
							--			,DP.PLAN_DATE
							--			,DP.LINE_ID
							--			,DP.OPERATION_ID
							--			,DP.ITEM_ID
							--			,DP.FACTORY_ID
							--			,DP.PRODUCTION_TYPE
							--			,ISNULL(DP.MARKET, 'D');


							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(    [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_QTY]
										,[JR_QTY]
										,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										)
                                SELECT  [PLAN_WEEK]
										,[PLAN_REVISION]
										,MAX([COMPANY_ID]) 
										,MAX([DIVISION_ID])
										,MAX([SITE_ID])
										,MAX([PLANT_ID])
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,SUM([PLAN_QTY])        AS PLAN_QTY
										,NULL                   AS ROLL_QTY
										,NULL                   AS JR_QTY
										,NULL                   AS CELL_QTY
										,NULL                   AS BATCH_QTY
										,@USER_ID               AS INSERT_ID
										,GETDATE()              AS INSERT_TIME
										,@USER_ID               AS UPDATE_ID
										,GETDATE()              AS UPDATE_TIME
										,[MARKET]

                                FROM (
										SELECT @PLAN_WEEK AS PLAN_WEEK
												,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
													FROM   @TEMP_TABLE T
													WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
													AS PLAN_REVISION
												,MAX(DP.COMPANY_ID) AS COMPANY_ID
												,MAX(DP.DIVISION_ID) AS DIVISION_ID
												,MAX(DP.SITE_ID) AS SITE_ID
												,MAX(DP.PLANT_ID) AS PLANT_ID
												,DP.FACTORY_ID AS FACTORY_ID
												,DP.LINE_ID
												,DP.OPERATION_ID
												,'-'      AS EQUIPMENT_ID
												,DP.PRODUCTION_TYPE
												,DP.ITEM_ID
												,DP.PLAN_DATE
												,SUM(DP.WPP_OUT_QTY)    AS PLAN_QTY
												,NULL					AS CELL_QTY-- 2018-04-09 kimcd cell out 수량 추가
												,ISNULL(DP.MARKET, 'D') AS MARKET
										FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
														,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
												FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
												WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
												AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
												,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
												,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
												,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
										WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
										AND    SL.LINE_ID        = DP.LINE_ID
										AND    SL.OPERATION_ID   = DP.OPERATION_ID
										AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
										AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
										AND    SP.PLAN_ID        = DP.FP_PLAN_ID
										AND    SP.INSTANCE_ID    = @INSTANCE_ID
										AND    SP.PLAN_ID        = @FP_PLAN_ID
										AND    DP.INSTANCE_ID    = @INSTANCE_ID
										AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
										AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
										AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
										AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'LINE_ID' )
										AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP  BY SP.PLAN_WEEK
													,DP.FP_PLAN_ID 
													,SL.MODEL_TYPE
													,DP.PLAN_DATE
													,DP.LINE_ID
													,DP.OPERATION_ID
													,DP.ITEM_ID
													,DP.FACTORY_ID
													,DP.PRODUCTION_TYPE
													,ISNULL(DP.MARKET, 'D')
                                   ) AS X
								   GROUP BY 
										[PLAN_WEEK]
									   ,[PLAN_REVISION]
									   ,[FACTORY_ID]
									   ,[LINE_ID]
									   ,[OPERATION_ID]
									   ,[EQUIPMENT_ID]
									   ,[PRODUCTION_TYPE]
									   ,[ITEM_ID]
									   ,[PLAN_DATE]
									   ,[MARKET]
										;




							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_WEEK_DATE;
						DEALLOCATE C_WEEK_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
										 ,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'WPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- WPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( SELECT B.COMPANY_ID
										,B.DIVISION_ID
										,B.SITE_ID
										,B.PLANT_ID
										,A.FACTORY_ID
										,A.PLAN_GROUP_ID
										,(SELECT TOP 1 INSTANCE_TYPE
											FROM ( SELECT FF.INSTANCE_TYPE
														FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
														WHERE FF.ACTIVE_FLAG = 'Y'     
														AND FF.INSTANCE_ID != 'KR_CELL_M_P'
														AND FF.INSTANCE_ID = A.INSTANCE_ID
													UNION ALL
													SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
														WHERE FF.ACTIVE_FLAG = 'Y'     
														AND FF.INSTANCE_ID = 'KR_CELL_M_P'
														AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
										,A.TOP_ITEM_ID
										,A.ITEM_ID
										,A.OPERATION_ID
										,ISNULL((SELECT LOCATION 
													FROM SCM_LINE_M WITH(NOLOCK)
													WHERE LINE_ID = A.LINE_ID
													AND OPERATION_ID = A.OPERATION_ID
													AND FACTORY_ID = A.FACTORY_ID
													AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
										,A.FP_PRODUCTION_TYPE
										,A.MARKET
										,A.LINE_ID
										,A.ELECTRODE_TYPE
										,A.PLAN_DATE
										,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
										,A.PLAN_IN_QTY
										,'PR_SCM_MPP_WPP_CONVERT' AS INSERT_ID
										,GETDATE() AS INSERT_TIME
										,'PR_SCM_MPP_WPP_CONVERT' AS UPDATE_ID
										,GETDATE() AS UPDATE_TIME
										,'WPP' AS PLAN_TYPE         -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
										,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
										-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
										,A.ROLL_IN_QTY
										,A.ROLL_OUT_QTY
										,A.JR_IN_QTY
										,A.JR_OUT_QTY
										,A.BATCH_IN_QTY
										,A.BATCH_OUT_QTY
										,A.CELL_IN_QTY
										,A.CELL_OUT_QTY
										-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
										,A.[WORK_REQUEST_MODEL_ID]
										,A.[VERSION]
										,A.[PROD_SEQ]
										,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									FROM (
										SELECT PP.FACTORY_ID
												,A.PLAN_GROUP_ID
												,TOP_ITEM_ID
												,ITEM_ID
												,OPERATION_ID
												,PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
												,ISNULL(MARKET,'D') AS MARKET
												,LINE_ID
												,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
												,PP.PLAN_DATE
												,SUM(WPP_OUT_QTY) AS PLAN_QTY
												,SUM(WPP_IN_QTY) AS PLAN_IN_QTY
												,MAX(A.INSTANCE_ID) AS INSTANCE_ID
												,'-'                    AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
												-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
												,NULL                   AS ROLL_IN_QTY
												,NULL                   AS ROLL_OUT_QTY
												,NULL                   AS JR_IN_QTY
												,NULL                   AS JR_OUT_QTY
												,NULL                   AS BATCH_IN_QTY
												,NULL                   AS BATCH_OUT_QTY
												,NULL                   AS CELL_IN_QTY
												,NULL                   AS CELL_OUT_QTY
												-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
												,'-' AS [WORK_REQUEST_MODEL_ID]
												,'-' AS [VERSION]
												,'-' AS [PROD_SEQ]
												,'-' AS [PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											FROM FP_AMEND_PLAN_PACK_H PP WITH(NOLOCK),
												(SELECT TOP 1
															   INSTANCE_DATE AS PLAN_DATE
															 , INSTANCE_ID
															 , DIVISION_ID
															 , FACTORY_ID
															 , PLAN_GROUP_ID
															 , RELEASE_PLAN_ID
														FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
														WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
														AND    INSTANCE_ID     = @INSTANCE_ID
														ORDER BY C.INSERT_TIME DESC
														) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											WHERE A.INSTANCE_ID  = @INSTANCE_ID
											AND   PP.INSTANCE_ID = @INSTANCE_ID
											AND   PP.PLAN_DATE  >= @FROM_DATE
											AND   PP.PLAN_DATE  <= @TO_DATE
											AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
											AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																		FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																		WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																		AND    CONDITION_TYPE = 'LINE_ID' )
											AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																		FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																		WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																		AND    CONDITION_TYPE = 'OPERATION_ID' )
											GROUP BY PP.FACTORY_ID
												,A.PLAN_GROUP_ID
												,TOP_ITEM_ID
												,ITEM_ID
												,OPERATION_ID
												,PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
												,ISNULL(MARKET,'D')
												,LINE_ID
												,PP.PLAN_DATE
												--,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										) A
										, SCM_FACTORY_M B WITH(NOLOCK)
									WHERE A.FACTORY_ID = B.FACTORY_ID) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND	DP.[WORK_REQUEST_MODEL_ID]	= B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]	   = B.[VERSION]
							AND	DP.[PROD_SEQ]	   = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]	   = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID] )
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO] )  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO]-- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
					END; -- IF @TABLE_NAME = 'FP_AMEND_PLAN_PACK_H'
				ELSE IF @TABLE_NAME = 'FP_AMEND_DAILY_PLAN_H'
					BEGIN
						OPEN C_WEEK_DATE
				        FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_DAILY_PLAN_H      DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,(  SELECT SSC.YEAR + SSC.MONTH
										FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
										WHERE  SSC.DATE_ID = CONVERT(DATE,SP.PLAN_START_TIME))  -- [PLAN_MONTH]
									,'Y'-- WPP
									,'N' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_DAILY_PLAN_H      DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_IN_QTY]	--2019-08-27 PIYONG ADD
										,[ROLL_QTY]
										,[JR_IN_QTY]	--2019-08-27 PIYONG ADD
										,[JR_QTY]
										,[CELL_IN_QTY]	--2019-08-27 PIYONG ADD
										,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
										,[BATCH_IN_QTY]	--2019-08-27 PIYONG ADD
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										,[WORK_REQUEST_MODEL_ID]
										,[VERSION]
										,[PROD_SEQ]
										,[PLM_EC_NO])  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							SELECT @PLAN_WEEK
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
									,MAX(DP.COMPANY_ID)
									,MAX(DP.DIVISION_ID)
									,MAX(DP.SITE_ID)
									,MAX(DP.PLANT_ID)
									,DP.FACTORY_ID
									,DP.LINE_ID
									,DP.OPERATION_ID
									,DP.[EQUIPMENT_ID]
									,DP.PRODUCTION_TYPE
									,DP.ITEM_ID
									,DP.PLAN_DATE
									,SUM(CASE WHEN SI.ITEM_UOM = 'EA' THEN DP.WPP_OUT_QTY_CELL ELSE DP.WPP_OUT_QTY_M END)       -- PLAN QTY -- 2019-03-27 kimcd UOM에 따른 일자별 수량 사용
									,SUM(DP.WPP_IN_QTY_M)		-- ROLL QTY		--2019-08-27 PIYONG ADD
									,SUM(DP.WPP_OUT_QTY_M)     -- ROLL QTY
									,SUM(DP.WPP_IN_QTY_JR)		-- JR QTY		--2019-08-27 PIYONG ADD
									,SUM(DP.WPP_OUT_QTY_JR)    -- JR QTY
									,SUM(DP.WPP_IN_QTY_CELL)	-- CELL QTY		--2019-08-27 PIYONG ADD
									,SUM(DP.WPP_OUT_QTY_CELL)  -- CELL QTY   -- 2018-04-09 kimcd cell out 수량 추가
									,SUM(DP.WPP_IN_QTY_BATCH)	-- BATCH QT		--2019-08-27 PIYONG ADD
									,SUM(DP.WPP_OUT_QTY_BATCH) -- BATCH QTY
									,@USER_ID                  -- INSERT ID
									,GETDATE()                 -- INSERT TIME
									,@USER_ID                  -- UPDATE ID
									,GETDATE()                 -- UPDATE TIME
									,ISNULL(DP.MARKET, 'D')    -- PLAN_GROUP_ID
									,DP.[WORK_REQUEST_MODEL_ID]
									,DP.[VERSION]
									,ISNULL(DP.[PROD_SEQ],'-') AS PROD_SEQ
									,DP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_DAILY_PLAN_H      DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									,DBO.SCM_ITEM_M                 SI WITH(NOLOCK)  -- 2019-03-27 kimcd item uom 정보 추가
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SI.COMPANY_ID     = DP.COMPANY_ID    -- 2019-03-27 kimcd item uom 정보 추가
							AND    SI.DIVISION_ID    = DP.DIVISION_ID   -- 2019-03-27 kimcd item uom 정보 추가
							AND    SI.SITE_ID        = DP.SITE_ID       -- 2019-03-27 kimcd item uom 정보 추가
							AND    SI.ITEM_ID        = DP.ITEM_ID       -- 2019-03-27 kimcd item uom 정보 추가
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
														 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														 AND    CONDITION_TYPE = 'LINE_ID' )
							AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														 AND    CONDITION_TYPE = 'OPERATION_ID' )
							GROUP  BY SP.PLAN_WEEK
										,DP.FP_PLAN_ID 
										,SL.MODEL_TYPE
										,DP.PLAN_DATE
										,DP.LINE_ID
										,DP.OPERATION_ID
										,DP.[EQUIPMENT_ID]
										,DP.ITEM_ID
										,DP.FACTORY_ID
										,DP.PRODUCTION_TYPE
										,ISNULL(DP.MARKET, 'D')
										,DP.[WORK_REQUEST_MODEL_ID]
										,DP.[VERSION]
										,ISNULL(DP.[PROD_SEQ],'-')
										,DP.[PLM_EC_NO];  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리

							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[ROLL_QTY]
											,[JR_IN_QTY]	--2019-08-27 PIYONG ADD
											,[JR_QTY]
											,[CELL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[CELL_QTY]
											,[BATCH_IN_QTY]	--2019-08-27 PIYONG ADD	
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_IN_QTY)	-- ROLL_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_IN_QTY)		-- JR_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_IN_QTY)	-- CELL_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_IN_QTY)	-- BATCH_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[ROLL_QTY]
											,[JR_IN_QTY]	--2019-08-27 PIYONG ADD
											,[JR_QTY]
											,[CELL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[CELL_QTY]
											,[BATCH_IN_QTY]	--2019-08-27 PIYONG ADD
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_IN_QTY)	-- ROLL_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_IN_QTY)		-- JR_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_IN_QTY)	-- CELL_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_IN_QTY)	-- BATCH_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM ( SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
 									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_WEEK_DATE;
						DEALLOCATE C_WEEK_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'WPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- WPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( SELECT B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,A.FACTORY_ID
									,A.PLAN_GROUP_ID
									,(SELECT TOP 1 INSTANCE_TYPE
										FROM ( SELECT FF.INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID != 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID = 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
									,A.TOP_ITEM_ID
									,A.ITEM_ID
									,A.OPERATION_ID
									,ISNULL((SELECT LOCATION 
												FROM SCM_LINE_M WITH(NOLOCK)
												WHERE LINE_ID = A.LINE_ID
												AND OPERATION_ID = A.OPERATION_ID
												AND FACTORY_ID = A.FACTORY_ID
												AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
									,A.FP_PRODUCTION_TYPE
									,A.MARKET
									,A.LINE_ID
									,A.ELECTRODE_TYPE
									,A.PLAN_DATE
									,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
									,A.PLAN_IN_QTY
									,'PR_SCM_MPP_WPP_CONVERT' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_SCM_MPP_WPP_CONVERT' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME
									,'WPP' AS PLAN_TYPE      -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
									,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.ROLL_IN_QTY
									,A.ROLL_OUT_QTY
									,A.JR_IN_QTY
									,A.JR_OUT_QTY
									,A.BATCH_IN_QTY
									,A.BATCH_OUT_QTY
									,A.CELL_IN_QTY
									,A.CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM (
									SELECT PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
											,ISNULL(MARKET,'D') AS MARKET
											,LINE_ID
											,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
											,PP.PLAN_DATE
											,SUM(CASE WHEN SI.ITEM_UOM = 'EA' THEN PP.WPP_OUT_QTY_CELL ELSE PP.WPP_OUT_QTY_M END)  AS PLAN_QTY     -- PLAN QTY -- 2019-03-27 kimcd UOM에 따른 일자별 수량 사용
											,SUM(CASE WHEN SI.ITEM_UOM = 'EA' THEN PP.WPP_IN_QTY_CELL ELSE PP.WPP_IN_QTY_M END)    AS PLAN_IN_QTY    -- PLAN IN QTY -- 2019-03-27 kimcd UOM에 따른 일자별 수량 사용
											,MAX(A.INSTANCE_ID) AS INSTANCE_ID
											,PP.EQUIPMENT_ID        AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
											,SUM(PP.WPP_IN_QTY_M)   AS ROLL_IN_QTY
											,SUM(PP.WPP_OUT_QTY_M)   AS ROLL_OUT_QTY
											,SUM(PP.WPP_IN_QTY_JR)   AS JR_IN_QTY
											,SUM(PP.WPP_OUT_QTY_JR)   AS JR_OUT_QTY
											,SUM(PP.WPP_IN_QTY_BATCH)   AS BATCH_IN_QTY
											,SUM(PP.WPP_OUT_QTY_BATCH)   AS BATCH_OUT_QTY
											,SUM(PP.WPP_IN_QTY_CELL)   AS CELL_IN_QTY
											,SUM(PP.WPP_OUT_QTY_CELL)   AS CELL_OUT_QTY
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
											,PP.[WORK_REQUEST_MODEL_ID]
											,PP.[VERSION]
											,ISNULL(PP.[PROD_SEQ],'-') AS PROD_SEQ
											,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										FROM FP_AMEND_DAILY_PLAN_H PP WITH(NOLOCK),
											(  SELECT TOP 1
															INSTANCE_DATE AS PLAN_DATE
															, INSTANCE_ID
															, DIVISION_ID
															, FACTORY_ID
															, PLAN_GROUP_ID
															, RELEASE_PLAN_ID
													FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
													WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
													AND    INSTANCE_ID     = @INSTANCE_ID
													ORDER BY C.INSERT_TIME DESC
													) A, -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											SCM_ITEM_M SI WITH(NOLOCK)           -- 2019-03-27 kimcd item uom 정보 추가
										WHERE SI.COMPANY_ID   = PP.COMPANY_ID    -- 2019-03-27 kimcd item uom 정보 추가
										AND    SI.DIVISION_ID = PP.DIVISION_ID   -- 2019-03-27 kimcd item uom 정보 추가
										AND    SI.SITE_ID     = PP.SITE_ID       -- 2019-03-27 kimcd item uom 정보 추가
										AND    SI.ITEM_ID     = PP.ITEM_ID       -- 2019-03-27 kimcd item uom 정보 추가
										AND   A.INSTANCE_ID  = @INSTANCE_ID
										AND   PP.INSTANCE_ID = @INSTANCE_ID
										AND   PP.PLAN_DATE  >= @FROM_DATE
										AND   PP.PLAN_DATE  <= @TO_DATE
										AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
										AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'LINE_ID' )
										AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP BY PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
											,ISNULL(MARKET,'D')
											,LINE_ID
											,PP.PLAN_DATE
											,PP.EQUIPMENT_ID
											,PP.[WORK_REQUEST_MODEL_ID]
											,PP.[VERSION]
											,ISNULL(PP.[PROD_SEQ],'-')
											,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									) A
									, SCM_FACTORY_M B WITH(NOLOCK)
								WHERE A.FACTORY_ID = B.FACTORY_ID ) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID]
							AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]	   = B.[VERSION]
							AND	DP.[PROD_SEQ]	   = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]	   = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							)
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
					END; -- IF @TABLE_NAME = 'FP_AMEND_DAILY_PLAN_H'
				ELSE IF @TABLE_NAME = 'FP_AMEND_PLAN_FORM_H'
					BEGIN
						OPEN C_WEEK_DATE
				        FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN

							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_PLAN_FORM_H       DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    DP.FACTORY_ID    != '-'
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,(  SELECT SSC.YEAR + SSC.MONTH
										FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
										WHERE  SSC.DATE_ID = CONVERT(DATE,SP.PLAN_START_TIME))  -- [PLAN_MONTH]
									,'Y'-- WPP
									,'N' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_FORM_H       DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    DP.FACTORY_ID    != '-'
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_QTY]
										,[JR_QTY]
										,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										,[WORK_REQUEST_MODEL_ID]
										,[VERSION]
										,[PROD_SEQ]
										,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										)
							SELECT @PLAN_WEEK
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
									,MAX(DP.COMPANY_ID)
									,MAX(DP.DIVISION_ID)
									,MAX(DP.SITE_ID)
									,MAX(DP.PLANT_ID)
									,DP.FACTORY_ID
									,DP.LINE_ID
									,DP.OPERATION_ID
									,'-' -- [EQUIPMENT_ID]
									,ISNULL(SSLV.PRODUCTION_TYPE, DP.PRODUCTION_TYPE ) AS PRODUCTION_TYPE -- 2020-01-30 PIYONG CHANGE
									,DP.ITEM_ID
									,DP.PLAN_DATE
									,SUM(DP.WPP_OUT_QTY)    -- PLAN QTY
									,NULL                   -- ROLL QTY
									,NULL                   -- JR QTY
									,NULL                   -- CELL QTY   -- 2018-04-09 kimcd cell out 수량 추가
									,NULL                   -- BATCH QTY
									,@USER_ID               -- INSERT ID
									,GETDATE()              -- INSERT TIME
									,@USER_ID               -- UPDATE ID
									,GETDATE()              -- UPDATE TIME
									,ISNULL(DP.MARKET, 'D') -- PLAN_GROUP_ID
									,'-' AS [WORK_REQUEST_MODEL_ID]
									,'-' AS [VERSION]
									,'-' AS [PROD_SEQ]
									,'-' AS [PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_FORM_H       DP WITH(NOLOCK)
									------------------------------------------------------------------------------------------------------------------
									--2020-01-30 PIYONG ADD
									LEFT OUTER JOIN (
														SELECT SEGMENT1 AS DIVISION_ID
															   ,SEGMENT2 AS SITE_ID
															   ,SEGMENT3 AS PLANT_ID
															   ,SEGMENT4 AS ITEM_ID
															   ,ATTRIBUTE1 AS PRODUCTION_TYPE
														  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
														 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_TYPE'
														 AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
													) SSLV
												 ON DP.DIVISION_ID = SSLV.DIVISION_ID
												AND DP.SITE_ID = SSLV.SITE_ID
												AND DP.PLANT_ID = SSLV.PLANT_ID
												AND DP.ITEM_ID = SSLV.ITEM_ID
									--2020-01-30 PIYONG ADD END
									------------------------------------------------------------------------------------------------------------------
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    DP.FACTORY_ID    != '-'
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
														 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														 AND    CONDITION_TYPE = 'LINE_ID' )
							AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														 AND    CONDITION_TYPE = 'OPERATION_ID' )
							GROUP  BY SP.PLAN_WEEK
										,DP.FP_PLAN_ID 
										,SL.MODEL_TYPE
										,DP.PLAN_DATE
										,DP.LINE_ID
										,DP.OPERATION_ID
										,DP.ITEM_ID
										,DP.FACTORY_ID
										,ISNULL(SSLV.PRODUCTION_TYPE, DP.PRODUCTION_TYPE )	-- 2020-01-30 PIYONG CHANGE
										,ISNULL(DP.MARKET, 'D')
										-- ,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										;

							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) AS PRODUCTION_TYPE -- 2020-01-30 PIYONG CHANGE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
										------------------------------------------------------------------------------------------------------------------
										--2020-01-30 PIYONG ADD
										LEFT OUTER JOIN (
															SELECT SEGMENT1 AS DIVISION_ID
																   ,SEGMENT2 AS SITE_ID
																   ,SEGMENT3 AS PLANT_ID
																   ,SEGMENT4 AS ITEM_ID
																   ,ATTRIBUTE1 AS PRODUCTION_TYPE
															  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
															 WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
															 AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
														) SSLV
													 ON PP.DIVISION_ID = SSLV.DIVISION_ID
													AND PP.SITE_ID = SSLV.SITE_ID
													AND PP.PLANT_ID = SSLV.PLANT_ID
													AND PP.ITEM_ID = SSLV.ITEM_ID
										--2020-01-30 PIYONG ADD END
										------------------------------------------------------------------------------------------------------------------
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE )			-- 2020-01-30 PIYONG CHANGE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) AS PRODUCTION_TYPE -- 2020-01-30 PIYONG CHANGE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
										------------------------------------------------------------------------------------------------------------------
										--2020-01-30 PIYONG ADD
									   LEFT OUTER JOIN (
														SELECT SEGMENT1 AS DIVISION_ID
															   ,SEGMENT2 AS SITE_ID
															   ,SEGMENT3 AS PLANT_ID
															   ,SEGMENT4 AS ITEM_ID
															   ,ATTRIBUTE1 AS PRODUCTION_TYPE
														  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
														 WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
														 AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
													   ) SSLV
													ON PP.DIVISION_ID = SSLV.DIVISION_ID
												   AND PP.SITE_ID = SSLV.SITE_ID
												   AND PP.PLANT_ID = SSLV.PLANT_ID
												   AND PP.ITEM_ID = SSLV.ITEM_ID
										--2020-01-30 PIYONG ADD END
										------------------------------------------------------------------------------------------------------------------
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'WPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE )		-- 2020-01-30 PIYONG CHANGE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
 									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_WEEK_DATE INTO  @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_WEEK_DATE;
						DEALLOCATE C_WEEK_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'WPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- WPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( SELECT B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,A.FACTORY_ID
									,A.PLAN_GROUP_ID
									,(SELECT TOP 1 INSTANCE_TYPE
										FROM ( SELECT FF.INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID != 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID = 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
									,A.TOP_ITEM_ID
									,A.ITEM_ID
									,A.OPERATION_ID
									,ISNULL((SELECT LOCATION 
												FROM SCM_LINE_M WITH(NOLOCK)
												WHERE LINE_ID = A.LINE_ID
												AND OPERATION_ID = A.OPERATION_ID
												AND FACTORY_ID = A.FACTORY_ID
												AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
									,A.FP_PRODUCTION_TYPE
									,A.MARKET
									,A.LINE_ID
									,A.ELECTRODE_TYPE
									,A.PLAN_DATE
									,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
									,A.PLAN_IN_QTY
									,'PR_SCM_MPP_WPP_CONVERT' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_SCM_MPP_WPP_CONVERT' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME
									,'WPP' AS PLAN_TYPE     -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
									,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.ROLL_IN_QTY
									,A.ROLL_OUT_QTY
									,A.JR_IN_QTY
									,A.JR_OUT_QTY
									,A.BATCH_IN_QTY
									,A.BATCH_OUT_QTY
									,A.CELL_IN_QTY
									,A.CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM (
									SELECT PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가 -- 2020-01-30 PIYONG CHANGE
											,ISNULL(MARKET,'D') AS MARKET
											,LINE_ID
											,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
											,PP.PLAN_DATE
											,SUM(WPP_OUT_QTY) AS PLAN_QTY
											,SUM(WPP_IN_QTY) AS PLAN_IN_QTY
											,MAX(A.INSTANCE_ID) AS INSTANCE_ID
											,'-'                    AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
											,NULL                   AS ROLL_IN_QTY
											,NULL                   AS ROLL_OUT_QTY
											,NULL                   AS JR_IN_QTY
											,NULL                   AS JR_OUT_QTY
											,NULL                   AS BATCH_IN_QTY
											,NULL                   AS BATCH_OUT_QTY
											,NULL                   AS CELL_IN_QTY
											,NULL                   AS CELL_OUT_QTY
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
											,'-' AS [WORK_REQUEST_MODEL_ID]
											,'-' AS [VERSION]
											,'-' AS [PROD_SEQ]
											,'-' AS [PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										FROM FP_AMEND_PLAN_FORM_H PP WITH(NOLOCK)
										   ------------------------------------------------------------------------------------------------------------------
										   --2020-01-30 PIYONG ADD
										   LEFT OUTER JOIN (
															SELECT SEGMENT1 AS DIVISION_ID
																   ,SEGMENT2 AS SITE_ID
																   ,SEGMENT3 AS PLANT_ID
																   ,SEGMENT4 AS ITEM_ID
																   ,ATTRIBUTE1 AS PRODUCTION_TYPE
															  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
															 WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
															 AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
														   ) SSLV
														ON PP.DIVISION_ID = SSLV.DIVISION_ID
													   AND PP.SITE_ID = SSLV.SITE_ID
													   AND PP.PLANT_ID = SSLV.PLANT_ID
													   AND PP.ITEM_ID = SSLV.ITEM_ID
										   --2020-01-30 PIYONG ADD END
										   ------------------------------------------------------------------------------------------------------------------
											,(  SELECT TOP 1
														   INSTANCE_DATE AS PLAN_DATE
														 , INSTANCE_ID
														 , DIVISION_ID
														 , FACTORY_ID
														 , PLAN_GROUP_ID
														 , RELEASE_PLAN_ID
													FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
													WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
													AND    INSTANCE_ID     = @INSTANCE_ID
													ORDER BY C.INSERT_TIME DESC
													) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
										WHERE A.INSTANCE_ID  = @INSTANCE_ID
										AND   PP.INSTANCE_ID = @INSTANCE_ID
										AND   PP.PLAN_DATE  >= @FROM_DATE
										AND   PP.PLAN_DATE  <= @TO_DATE
										AND   PP.FACTORY_ID    != '-'
										AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
										AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'LINE_ID' )
										AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP BY PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정  --2020-01-30 PIYONG CHANGE
											,ISNULL(MARKET,'D')
											,LINE_ID
											,PP.PLAN_DATE
											-- ,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									) A
									, SCM_FACTORY_M B WITH(NOLOCK)
								WHERE A.FACTORY_ID = B.FACTORY_ID ) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID]
							AND	DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]	   = B.[VERSION]
							AND	DP.[PROD_SEQ]	   = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]	   = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							)
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
					END; -- IF @TABLE_NAME = 'FP_AMEND_PLAN_FORM_H'

			END; -- IF @TYPE = 'WPP'
		ELSE IF @TYPE = 'MPP'
			BEGIN
				DECLARE C_MONTH_DATE  CURSOR FOR
					SELECT YEAR+MONTH AS PLAN_MONTH
					     , MIN(WEEK) AS PLAN_WEEK
						 , CASE WHEN MIN(DATEADD(mm, DATEDIFF(mm,0,DATE_ID), 0)) < @FROM_DATE THEN
							  MIN(DATEADD(mm, DATEDIFF(mm,0,DATE_ID), 0))
						 END                            AS FIRST_CREATE_DATE
						,CASE WHEN MIN(DATEADD(mm, DATEDIFF(mm,0,DATE_ID), 0)) < @FROM_DATE THEN
							  @FROM_DATE
						 ELSE  MIN(DATEADD(mm, DATEDIFF(mm,0,DATE_ID), 0)) END  AS SECOND_CREATE_DATE
						,CASE WHEN MAX(DATEADD(D,-1,DATEADD(mm, DATEDIFF(mm,0,DATE_ID) + 1, 0))) > @TO_DATE THEN
							  @TO_DATE
						 ELSE  MAX(DATEADD(D,-1,DATEADD(mm, DATEDIFF(mm,0,DATE_ID) + 1, 0))) END    AS THIRD_CREATE_DATE
						,CASE WHEN MAX(DATEADD(D,-1,DATEADD(mm, DATEDIFF(mm,0,DATE_ID) + 1, 0))) > @TO_DATE THEN
							  MAX(DATEADD(D,-1,DATEADD(mm, DATEDIFF(mm,0,DATE_ID) + 1, 0)))
						 END                            AS FOURTH_CREATE_DATE
					FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
					WHERE  SSC.DATE_ID >= @FROM_DATE
					AND    SSC.DATE_ID <= @TO_DATE 
					GROUP  BY YEAR+MONTH

				IF @TABLE_NAME = 'FP_AMEND_PLAN_CELL_H'
					BEGIN
						OPEN C_MONTH_DATE
				        FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
														, @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,@PLAN_MONTH   -- [PLAN_MONTH]
									,'N'-- WPP
									,'Y' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							--INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
							--		(   [PLAN_WEEK]
							--			,[PLAN_REVISION]
							--			,[COMPANY_ID]
							--			,[DIVISION_ID]
							--			,[SITE_ID]
							--			,[PLANT_ID]
							--			,[FACTORY_ID]
							--			,[LINE_ID]
							--			,[OPERATION_ID]
							--			,[EQUIPMENT_ID]
							--			,[PRODUCTION_TYPE]
							--			,[ITEM_ID]
							--			,[PLAN_DATE]
							--			,[PLAN_QTY]
							--			,[ROLL_QTY]
							--			,[JR_QTY]
							--			,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
							--			,[BATCH_QTY]
							--			,[INSERT_ID]
							--			,[INSERT_TIME]
							--			,[UPDATE_ID]
							--			,[UPDATE_TIME]
							--			,[MARKET])
							--SELECT @PLAN_WEEK
							--		,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
							--			FROM   @TEMP_TABLE T
							--			WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
							--		,MAX(DP.COMPANY_ID)
							--		,MAX(DP.DIVISION_ID)
							--		,MAX(DP.SITE_ID)
							--		,MAX(DP.PLANT_ID)
							--		,DP.FACTORY_ID
							--		,DP.LINE_ID
							--		,DP.OPERATION_ID
							--		,'-' -- [EQUIPMENT_ID]
							--		,DP.PRODUCTION_TYPE
							--		,DP.ITEM_ID
							--		,DP.PLAN_DATE
							--		,SUM(DP.MPP_OUT_QTY)    -- PLAN QTY
							--		,NULL                   -- ROLL QTY
							--		,NULL                   -- JR QTY
							--		,SUM(DP.MPP_CELL_OUT_QTY)   -- 2018-04-09 kimcd cell out 수량 추가
							--		,NULL                   -- BATCH QTY
							--		,@USER_ID               -- INSERT ID
							--		,GETDATE()              -- INSERT TIME
							--		,@USER_ID               -- UPDATE ID
							--		,GETDATE()              -- UPDATE TIME
							--		,ISNULL(DP.MARKET, 'D') -- PLAN_GROUP_ID
							--FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
							--		FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
							--		WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
							--		AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
							--		,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
							--		,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
							--		,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							--WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							--AND    SL.LINE_ID        = DP.LINE_ID
							--AND    SL.OPERATION_ID   = DP.OPERATION_ID
							--AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							--AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							--AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							--AND    SP.INSTANCE_ID    = @INSTANCE_ID
							--AND    SP.PLAN_ID        = @FP_PLAN_ID
							--AND    DP.INSTANCE_ID    = @INSTANCE_ID
							--AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							--AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							--AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							--AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'LINE_ID' )
							--AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'OPERATION_ID' )
							--GROUP  BY SP.PLAN_WEEK
							--			,DP.FP_PLAN_ID 
							--			,SL.MODEL_TYPE
							--			,DP.PLAN_DATE
							--			,DP.LINE_ID
							--			,DP.OPERATION_ID
							--			,DP.ITEM_ID
							--			,DP.FACTORY_ID
							--			,DP.PRODUCTION_TYPE
							--			,ISNULL(DP.MARKET, 'D');


							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(    [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_QTY]
										,[JR_QTY]
										,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										)
                                SELECT  [PLAN_WEEK]
										,[PLAN_REVISION]
										,MAX([COMPANY_ID]) 
										,MAX([DIVISION_ID])
										,MAX([SITE_ID])
										,MAX([PLANT_ID])
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,SUM([PLAN_QTY])        AS PLAN_QTY     
										,NULL                   AS ROLL_QTY
										,NULL                   AS JR_QTY
										,SUM([CELL_QTY])        AS CELL_QTY
										,NULL                   AS BATCH_QTY
										,@USER_ID               AS INSERT_ID
										,GETDATE()              AS INSERT_TIME
										,@USER_ID               AS UPDATE_ID
										,GETDATE()              AS UPDATE_TIME
										,[MARKET]

                                FROM (
										SELECT @PLAN_WEEK AS PLAN_WEEK
												,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
													FROM   @TEMP_TABLE T
													WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
													AS PLAN_REVISION
												,MAX(DP.COMPANY_ID) AS COMPANY_ID
												,MAX(DP.DIVISION_ID) AS DIVISION_ID
												,MAX(DP.SITE_ID) AS SITE_ID
												,MAX(DP.PLANT_ID) AS PLANT_ID
												,DP.FACTORY_ID AS FACTORY_ID
												,DP.LINE_ID
												,DP.OPERATION_ID
												,'-'      AS EQUIPMENT_ID
												,DP.PRODUCTION_TYPE
												,DP.ITEM_ID
												,DP.PLAN_DATE
												,SUM(DP.MPP_OUT_QTY)		AS PLAN_QTY
												,SUM(DP.MPP_CELL_OUT_QTY)   AS CELL_QTY-- 2018-04-09 kimcd cell out 수량 추가
												,ISNULL(DP.MARKET, 'D') AS MARKET
										FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
														,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
												FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
												WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
												AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
												,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
												,DBO.FP_AMEND_PLAN_CELL_H       DP WITH(NOLOCK)
												,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
										WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
										AND    SL.LINE_ID        = DP.LINE_ID
										AND    SL.OPERATION_ID   = DP.OPERATION_ID
										AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
										AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
										AND    SP.PLAN_ID        = DP.FP_PLAN_ID
										AND    SP.INSTANCE_ID    = @INSTANCE_ID
										AND    SP.PLAN_ID        = @FP_PLAN_ID
										AND    DP.INSTANCE_ID    = @INSTANCE_ID
										AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
										AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
										AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
										AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'LINE_ID' )
										AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP  BY SP.PLAN_WEEK
													,DP.FP_PLAN_ID 
													,SL.MODEL_TYPE
													,DP.PLAN_DATE
													,DP.LINE_ID
													,DP.OPERATION_ID
													,DP.ITEM_ID
													,DP.FACTORY_ID
													,DP.PRODUCTION_TYPE
													,ISNULL(DP.MARKET, 'D')
                                   ) AS X
								   GROUP BY 
										[PLAN_WEEK]
									   ,[PLAN_REVISION]
									   ,[FACTORY_ID]
									   ,[LINE_ID]
									   ,[OPERATION_ID]
									   ,[EQUIPMENT_ID]
									   ,[PRODUCTION_TYPE]
									   ,[ITEM_ID]
									   ,[PLAN_DATE]
									   ,[MARKET]
										;




							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM ( SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
 									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
															, @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_MONTH_DATE;
						DEALLOCATE C_MONTH_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'MPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- MPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( SELECT B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,A.FACTORY_ID
									,A.PLAN_GROUP_ID
									,(SELECT TOP 1 INSTANCE_TYPE
										FROM ( SELECT FF.INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID != 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID = 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
									,A.TOP_ITEM_ID
									,A.ITEM_ID
									,A.OPERATION_ID
									,ISNULL((SELECT LOCATION 
												FROM SCM_LINE_M WITH(NOLOCK)
												WHERE LINE_ID = A.LINE_ID
												AND OPERATION_ID = A.OPERATION_ID
												AND FACTORY_ID = A.FACTORY_ID
												AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
									,A.FP_PRODUCTION_TYPE
									,A.MARKET
									,A.LINE_ID
									,A.ELECTRODE_TYPE
									,A.PLAN_DATE
									,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
									,A.PLAN_IN_QTY
									,'PR_SCM_MPP_WPP_CONVERT' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_SCM_MPP_WPP_CONVERT' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME
									,'MPP' AS PLAN_TYPE        -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
									,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.ROLL_IN_QTY
									,A.ROLL_OUT_QTY
									,A.JR_IN_QTY
									,A.JR_OUT_QTY
									,A.BATCH_IN_QTY
									,A.BATCH_OUT_QTY
									,A.CELL_IN_QTY
									,A.CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM (
									SELECT PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
											,ISNULL(MARKET,'D') AS MARKET
											,LINE_ID
											,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
											,PP.PLAN_DATE
											,SUM(MPP_OUT_QTY) AS PLAN_QTY
											,SUM(MPP_IN_QTY) AS PLAN_IN_QTY
											,MAX(A.INSTANCE_ID) AS INSTANCE_ID
											,'-'                    AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
											,NULL                   AS ROLL_IN_QTY
											,NULL                   AS ROLL_OUT_QTY
											,NULL                   AS JR_IN_QTY
											,NULL                   AS JR_OUT_QTY
											,NULL                   AS BATCH_IN_QTY
											,NULL                   AS BATCH_OUT_QTY
											,SUM(PP.MPP_CELL_IN_QTY)    AS CELL_IN_QTY
											,SUM(PP.MPP_CELL_OUT_QTY)   AS CELL_OUT_QTY
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
											,'-'  AS [WORK_REQUEST_MODEL_ID]
											,'-'  AS [VERSION]
											,'-'  AS [PROD_SEQ]
											,PP.PLM_EC_NO AS [PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										FROM FP_AMEND_PLAN_CELL_H PP WITH(NOLOCK),
											(  SELECT TOP 1
														   INSTANCE_DATE AS PLAN_DATE
														 , INSTANCE_ID
														 , DIVISION_ID
														 , FACTORY_ID
														 , PLAN_GROUP_ID
														 , RELEASE_PLAN_ID
													FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
													WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
													AND    INSTANCE_ID     = @INSTANCE_ID
													ORDER BY C.INSERT_TIME DESC
													) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
										WHERE A.INSTANCE_ID  = @INSTANCE_ID
										AND   PP.INSTANCE_ID = @INSTANCE_ID
										AND   PP.PLAN_DATE  >= @FROM_DATE
										AND   PP.PLAN_DATE  <= @TO_DATE
										AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
										AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'LINE_ID' )
										AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP BY PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
											,ISNULL(MARKET,'D')
											,LINE_ID
											,PP.PLAN_DATE
											,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									) A
									, SCM_FACTORY_M B WITH(NOLOCK)
								WHERE A.FACTORY_ID = B.FACTORY_ID ) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND	DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]	   = B.[VERSION]
							AND	DP.[PROD_SEQ]	   = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]	   = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID] )
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
					END; -- IF @TABLE_NAME = 'FP_AMEND_PLAN_CELL_H'
				ELSE IF @TABLE_NAME = 'FP_AMEND_PLAN_PACK_H'
					BEGIN
						OPEN C_MONTH_DATE
				        FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
														, @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,@PLAN_MONTH  -- [PLAN_MONTH]
									,'N'-- WPP
									,'Y' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							--INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
							--		(   [PLAN_WEEK]
							--			,[PLAN_REVISION]
							--			,[COMPANY_ID]
							--			,[DIVISION_ID]
							--			,[SITE_ID]
							--			,[PLANT_ID]
							--			,[FACTORY_ID]
							--			,[LINE_ID]
							--			,[OPERATION_ID]
							--			,[EQUIPMENT_ID]
							--			,[PRODUCTION_TYPE]
							--			,[ITEM_ID]
							--			,[PLAN_DATE]
							--			,[PLAN_QTY]
							--			,[ROLL_QTY]
							--			,[JR_QTY]
							--			,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
							--			,[BATCH_QTY]
							--			,[INSERT_ID]
							--			,[INSERT_TIME]
							--			,[UPDATE_ID]
							--			,[UPDATE_TIME]
							--			,[MARKET])
							--SELECT @PLAN_WEEK
							--		,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
							--			FROM   @TEMP_TABLE T
							--			WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
							--		,MAX(DP.COMPANY_ID)
							--		,MAX(DP.DIVISION_ID)
							--		,MAX(DP.SITE_ID)
							--		,MAX(DP.PLANT_ID)
							--		,DP.FACTORY_ID
							--		,DP.LINE_ID
							--		,DP.OPERATION_ID
							--		,'-' -- [EQUIPMENT_ID]
							--		,DP.PRODUCTION_TYPE
							--		,DP.ITEM_ID
							--		,DP.PLAN_DATE
							--		,SUM(DP.MPP_OUT_QTY)    -- PLAN QTY
							--		,NULL                   -- ROLL QTY
							--		,NULL                   -- JR QTY
							--		,NULL                   -- CELL QTY   -- 2018-04-09 kimcd cell out 수량 추가
							--		,NULL                   -- BATCH QTY
							--		,@USER_ID               -- INSERT ID
							--		,GETDATE()              -- INSERT TIME
							--		,@USER_ID               -- UPDATE ID
							--		,GETDATE()              -- UPDATE TIME
							--		,ISNULL(DP.MARKET, 'D') -- PLAN_GROUP_ID
							--FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
							--		FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
							--		WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
							--		AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
							--		,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
							--		,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
							--		,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							--WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							--AND    SL.LINE_ID        = DP.LINE_ID
							--AND    SL.OPERATION_ID   = DP.OPERATION_ID
							--AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							--AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							--AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							--AND    SP.INSTANCE_ID    = @INSTANCE_ID
							--AND    SP.PLAN_ID        = @FP_PLAN_ID
							--AND    DP.INSTANCE_ID    = @INSTANCE_ID
							--AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							--AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							--AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							--AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'LINE_ID' )
							--AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'OPERATION_ID' )
							--GROUP  BY SP.PLAN_WEEK
							--			,DP.FP_PLAN_ID 
							--			,SL.MODEL_TYPE
							--			,DP.PLAN_DATE
							--			,DP.LINE_ID
							--			,DP.OPERATION_ID
							--			,DP.ITEM_ID
							--			,DP.FACTORY_ID
							--			,DP.PRODUCTION_TYPE
							--			,ISNULL(DP.MARKET, 'D');


							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(    [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_QTY]
										,[JR_QTY]
										,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										)
                                SELECT  [PLAN_WEEK]
										,[PLAN_REVISION]
										,MAX([COMPANY_ID]) 
										,MAX([DIVISION_ID])
										,MAX([SITE_ID])
										,MAX([PLANT_ID])
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,SUM([PLAN_QTY])        AS PLAN_QTY
										,NULL                   AS ROLL_QTY
										,NULL                   AS JR_QTY
										,NULL					AS CELL_QTY
										,NULL                   AS BATCH_QTY
										,@USER_ID               AS INSERT_ID
										,GETDATE()              AS INSERT_TIME
										,@USER_ID               AS UPDATE_ID
										,GETDATE()              AS UPDATE_TIME
										,[MARKET]

                                FROM (
										SELECT @PLAN_WEEK AS PLAN_WEEK
												,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
													FROM   @TEMP_TABLE T
													WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
													AS PLAN_REVISION
												,MAX(DP.COMPANY_ID) AS COMPANY_ID
												,MAX(DP.DIVISION_ID) AS DIVISION_ID
												,MAX(DP.SITE_ID) AS SITE_ID
												,MAX(DP.PLANT_ID) AS PLANT_ID
												,DP.FACTORY_ID AS FACTORY_ID
												,DP.LINE_ID
												,DP.OPERATION_ID
												,'-'      AS EQUIPMENT_ID
												,DP.PRODUCTION_TYPE
												,DP.ITEM_ID
												,DP.PLAN_DATE
												,SUM(DP.MPP_OUT_QTY)    AS PLAN_QTY
												,NULL					AS CELL_QTY-- 2018-04-09 kimcd cell out 수량 추가
												,ISNULL(DP.MARKET, 'D') AS MARKET
										FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
														,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
												FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
												WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
												AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
												,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
												,DBO.FP_AMEND_PLAN_PACK_H       DP WITH(NOLOCK)
												,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
										WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
										AND    SL.LINE_ID        = DP.LINE_ID
										AND    SL.OPERATION_ID   = DP.OPERATION_ID
										AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
										AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
										AND    SP.PLAN_ID        = DP.FP_PLAN_ID
										AND    SP.INSTANCE_ID    = @INSTANCE_ID
										AND    SP.PLAN_ID        = @FP_PLAN_ID
										AND    DP.INSTANCE_ID    = @INSTANCE_ID
										AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
										AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
										AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
										AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'LINE_ID' )
										AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP  BY SP.PLAN_WEEK
													,DP.FP_PLAN_ID 
													,SL.MODEL_TYPE
													,DP.PLAN_DATE
													,DP.LINE_ID
													,DP.OPERATION_ID
													,DP.ITEM_ID
													,DP.FACTORY_ID
													,DP.PRODUCTION_TYPE
													,ISNULL(DP.MARKET, 'D')
                                   ) AS X
								   GROUP BY 
										[PLAN_WEEK]
									   ,[PLAN_REVISION]
									   ,[FACTORY_ID]
									   ,[LINE_ID]
									   ,[OPERATION_ID]
									   ,[EQUIPMENT_ID]
									   ,[PRODUCTION_TYPE]
									   ,[ITEM_ID]
									   ,[PLAN_DATE]
									   ,[MARKET]
										;


							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
		 							 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM ( SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
															, @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_MONTH_DATE;
						DEALLOCATE C_MONTH_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'MPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- MPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( SELECT B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,A.FACTORY_ID
									,A.PLAN_GROUP_ID
									,(SELECT TOP 1 INSTANCE_TYPE
										FROM ( SELECT FF.INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID != 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID = 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
									,A.TOP_ITEM_ID
									,A.ITEM_ID
									,A.OPERATION_ID
									,ISNULL((SELECT LOCATION 
												FROM SCM_LINE_M WITH(NOLOCK)
												WHERE LINE_ID = A.LINE_ID
												AND OPERATION_ID = A.OPERATION_ID
												AND FACTORY_ID = A.FACTORY_ID
												AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
									,A.FP_PRODUCTION_TYPE
									,A.MARKET
									,A.LINE_ID
									,A.ELECTRODE_TYPE
									,A.PLAN_DATE
									,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
									,A.PLAN_IN_QTY
									,'PR_SCM_MPP_WPP_CONVERT' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_SCM_MPP_WPP_CONVERT' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME
									,'MPP'  AS PLAN_TYPE    -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
									,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.ROLL_IN_QTY
									,A.ROLL_OUT_QTY
									,A.JR_IN_QTY
									,A.JR_OUT_QTY
									,A.BATCH_IN_QTY
									,A.BATCH_OUT_QTY
									,A.CELL_IN_QTY
									,A.CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM (
									SELECT PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
											,ISNULL(MARKET,'D') AS MARKET
											,LINE_ID
											,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
											,PP.PLAN_DATE
											,SUM(MPP_OUT_QTY) AS PLAN_QTY
											,SUM(MPP_IN_QTY) AS PLAN_IN_QTY
											,MAX(A.INSTANCE_ID) AS INSTANCE_ID
											,'-'                    AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
											,NULL                   AS ROLL_IN_QTY
											,NULL                   AS ROLL_OUT_QTY
											,NULL                   AS JR_IN_QTY
											,NULL                   AS JR_OUT_QTY
											,NULL                   AS BATCH_IN_QTY
											,NULL                   AS BATCH_OUT_QTY
											,NULL                   AS CELL_IN_QTY
											,NULL                   AS CELL_OUT_QTY
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
											,'-' AS [WORK_REQUEST_MODEL_ID]
											,'-' AS [VERSION]
											,'-' AS [PROD_SEQ]
											,'-' AS [PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										FROM FP_AMEND_PLAN_PACK_H PP WITH(NOLOCK),
											(  SELECT TOP 1
														   INSTANCE_DATE AS PLAN_DATE
														 , INSTANCE_ID
														 , DIVISION_ID
														 , FACTORY_ID
														 , PLAN_GROUP_ID
														 , RELEASE_PLAN_ID
													FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
													WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
													AND    INSTANCE_ID     = @INSTANCE_ID
													ORDER BY C.INSERT_TIME DESC
													) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
										WHERE A.INSTANCE_ID  = @INSTANCE_ID
										AND   PP.INSTANCE_ID = @INSTANCE_ID
										AND   PP.PLAN_DATE  >= @FROM_DATE
										AND   PP.PLAN_DATE  <= @TO_DATE
										AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
										AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'LINE_ID' )
										AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP BY PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
											,ISNULL(MARKET,'D')
											,LINE_ID
											,PP.PLAN_DATE
											--,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리

									) A
									, SCM_FACTORY_M B WITH(NOLOCK)
								WHERE A.FACTORY_ID = B.FACTORY_ID ) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID]
							AND	DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]	   = B.[VERSION]
							AND	DP.[PROD_SEQ]	   = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]	   = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							)
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
					END; -- IF @TABLE_NAME = 'FP_AMEND_PLAN_PACK_H'
				ELSE IF @TABLE_NAME = 'FP_AMEND_DAILY_PLAN_H'
					BEGIN
						OPEN C_MONTH_DATE
				        FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
														, @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_DAILY_PLAN_H      DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,@PLAN_MONTH  -- [PLAN_MONTH]
									,'N'-- WPP
									,'Y' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_DAILY_PLAN_H      DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_IN_QTY]	--2019-08-27 PIYONG ADD
										,[ROLL_QTY]
										,[JR_IN_QTY]	--2019-08-27 PIYONG ADD
										,[JR_QTY]
										,[CELL_IN_QTY]	--2019-08-27 PIYONG ADD
										,[CELL_QTY]
										,[BATCH_IN_QTY]	--2019-08-27 PIYONG ADD
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										,[WORK_REQUEST_MODEL_ID]
										,[VERSION]
										,[PROD_SEQ]
										,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										)
							SELECT @PLAN_WEEK
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
									,MAX(DP.COMPANY_ID)
									,MAX(DP.DIVISION_ID)
									,MAX(DP.SITE_ID)
									,MAX(DP.PLANT_ID)
									,DP.FACTORY_ID
									,DP.LINE_ID
									,DP.OPERATION_ID
									,DP.[EQUIPMENT_ID]
									,DP.PRODUCTION_TYPE
									,DP.ITEM_ID
									,DP.PLAN_DATE
									,SUM(CASE WHEN SI.ITEM_UOM = 'EA' THEN DP.MPP_OUT_QTY_CELL ELSE DP.MPP_OUT_QTY_M END)     -- PLAN QTY -- 2019-03-27 kimcd UOM에 따른 일자별 수량 사용
									,SUM(DP.MPP_IN_QTY_M)		-- ROLL_IN_QTY	--2019-08-27 PIYONG ADD
									,SUM(DP.MPP_OUT_QTY_M)     -- ROLL QTY
									,SUM(DP.MPP_IN_QTY_JR)		-- JR_IN_QTY	--2019-08-27 PIYONG ADD
									,SUM(DP.MPP_OUT_QTY_JR)    -- JR QTY
									,SUM(DP.MPP_IN_QTY_CELL)	-- CELL_IN_QTY	--2019-08-27 PIYONG ADD
									,SUM(DP.MPP_OUT_QTY_CELL)  -- CELL QTY   -- 2018-04-09 kimcd cell out 수량 추가
									,SUM(DP.MPP_IN_QTY_BATCH)	-- BATCH_IN_QTY	--2019-08-27 PIYONG ADD
									,SUM(DP.MPP_OUT_QTY_BATCH) -- BATCH QTY
									,@USER_ID                  -- INSERT ID
									,GETDATE()                 -- INSERT TIME
									,@USER_ID                  -- UPDATE ID
									,GETDATE()                 -- UPDATE TIME
									,ISNULL(DP.MARKET, 'D')    -- PLAN_GROUP_ID
									,DP.[WORK_REQUEST_MODEL_ID]
									,DP.[VERSION]
									,ISNULL(DP.[PROD_SEQ],'-') AS PROD_SEQ
									,DP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_DAILY_PLAN_H      DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									,SCM_ITEM_M                     SI WITH(NOLOCK)           -- 2019-03-27 kimcd item uom 정보 추가
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    SI.COMPANY_ID     = DP.COMPANY_ID    -- 2019-03-27 kimcd item uom 정보 추가
							AND    SI.DIVISION_ID    = DP.DIVISION_ID   -- 2019-03-27 kimcd item uom 정보 추가
							AND    SI.SITE_ID        = DP.SITE_ID       -- 2019-03-27 kimcd item uom 정보 추가
							AND    SI.ITEM_ID        = DP.ITEM_ID       -- 2019-03-27 kimcd item uom 정보 추가
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
														 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														 AND    CONDITION_TYPE = 'LINE_ID' )
							AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														 AND    CONDITION_TYPE = 'OPERATION_ID' )
							GROUP  BY SP.PLAN_WEEK
										,DP.FP_PLAN_ID 
										,SL.MODEL_TYPE
										,DP.PLAN_DATE
										,DP.LINE_ID
										,DP.OPERATION_ID
										,DP.[EQUIPMENT_ID]
										,DP.ITEM_ID
										,DP.FACTORY_ID
										,DP.PRODUCTION_TYPE
										,ISNULL(DP.MARKET, 'D')
										,DP.[WORK_REQUEST_MODEL_ID]
										,DP.[VERSION]
										,ISNULL(DP.[PROD_SEQ],'-')
										,DP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										;

							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[ROLL_QTY]
											,[JR_IN_QTY]	--2019-08-27 PIYONG ADD
											,[JR_QTY]
											,[CELL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[CELL_QTY]
											,[BATCH_IN_QTY]	--2019-08-27 PIYONG ADD
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_IN_QTY)	-- ROLLIN_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_IN_QTY)		-- JR_IN_QTY		--2019-08-27 PIYONG ADD
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_IN_QTY)	-- CELL_IN_QTY		--2019-08-27 PIYONG ADD
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_IN_QTY)	-- BATCH_IN_QTY		--2019-08-27 PIYONG ADD
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
 									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[ROLL_QTY]
											,[JR_IN_QTY]	--2019-08-27 PIYONG ADD
											,[JR_QTY]
											,[CELL_IN_QTY]	--2019-08-27 PIYONG ADD
											,[CELL_QTY]
											,[BATCH_IN_QTY]	--2019-08-27 PIYONG ADD
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,PP.PRODUCTION_TYPE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_IN_QTY)	-- ROLL_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_IN_QTY)		-- JR_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_IN_QTY)	-- CEL_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_IN_QTY)	-- BATCH_IN_QTY	--2019-08-27 PIYONG ADD
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,PP.PRODUCTION_TYPE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
															, @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_MONTH_DATE;
						DEALLOCATE C_MONTH_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'MPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- MPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( SELECT B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,A.FACTORY_ID
									,A.PLAN_GROUP_ID
									,(SELECT TOP 1 INSTANCE_TYPE
										FROM ( SELECT FF.INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID != 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID = 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
									,A.TOP_ITEM_ID
									,A.ITEM_ID
									,A.OPERATION_ID
									,ISNULL((SELECT LOCATION 
												FROM SCM_LINE_M WITH(NOLOCK)
												WHERE LINE_ID = A.LINE_ID
												AND OPERATION_ID = A.OPERATION_ID
												AND FACTORY_ID = A.FACTORY_ID
												AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
									,A.FP_PRODUCTION_TYPE
									,A.MARKET
									,A.LINE_ID
									,A.ELECTRODE_TYPE
									,A.PLAN_DATE
									,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
									,A.PLAN_IN_QTY
									,'PR_SCM_MPP_WPP_CONVERT' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_SCM_MPP_WPP_CONVERT' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME
									,'MPP' AS PLAN_TYPE      -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
									,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.ROLL_IN_QTY
									,A.ROLL_OUT_QTY
									,A.JR_IN_QTY
									,A.JR_OUT_QTY
									,A.BATCH_IN_QTY
									,A.BATCH_OUT_QTY
									,A.CELL_IN_QTY
									,A.CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM (
									SELECT PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
											,ISNULL(MARKET,'D') AS MARKET
											,LINE_ID
											,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
											,PP.PLAN_DATE
											,SUM(CASE WHEN SI.ITEM_UOM = 'EA' THEN PP.MPP_OUT_QTY_CELL ELSE PP.MPP_OUT_QTY_M END)  AS PLAN_QTY     -- PLAN QTY -- 2019-03-27 kimcd UOM에 따른 일자별 수량 사용
											,SUM(CASE WHEN SI.ITEM_UOM = 'EA' THEN PP.MPP_IN_QTY_CELL ELSE PP.MPP_IN_QTY_M END)    AS PLAN_IN_QTY    -- PLAN IN QTY -- 2019-03-27 kimcd UOM에 따른 일자별 수량 사용
											,MAX(A.INSTANCE_ID) AS INSTANCE_ID
											,PP.EQUIPMENT_ID        AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
											,SUM(PP.MPP_IN_QTY_M)   AS ROLL_IN_QTY
											,SUM(PP.MPP_OUT_QTY_M)   AS ROLL_OUT_QTY
											,SUM(PP.MPP_IN_QTY_JR)   AS JR_IN_QTY
											,SUM(PP.MPP_OUT_QTY_JR)   AS JR_OUT_QTY
											,SUM(PP.MPP_IN_QTY_BATCH)   AS BATCH_IN_QTY
											,SUM(PP.MPP_OUT_QTY_BATCH)   AS BATCH_OUT_QTY
											,SUM(PP.MPP_IN_QTY_CELL)   AS CELL_IN_QTY
											,SUM(PP.MPP_OUT_QTY_CELL)   AS CELL_OUT_QTY
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
											,PP.[WORK_REQUEST_MODEL_ID]
											,PP.[VERSION]
											,ISNULL(PP.[PROD_SEQ],'-') AS PROD_SEQ
											,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										FROM FP_AMEND_DAILY_PLAN_H PP WITH(NOLOCK),
											(  SELECT TOP 1
														   INSTANCE_DATE AS PLAN_DATE
														 , INSTANCE_ID
														 , DIVISION_ID
														 , FACTORY_ID
														 , PLAN_GROUP_ID
														 , RELEASE_PLAN_ID
													FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
													WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
													AND    INSTANCE_ID     = @INSTANCE_ID
													ORDER BY C.INSERT_TIME DESC
													) A, -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											SCM_ITEM_M SI WITH(NOLOCK)          -- 2019-03-27 kimcd item uom 정보 추가
										WHERE SI.COMPANY_ID  = PP.COMPANY_ID    -- 2019-03-27 kimcd item uom 정보 추가
										AND   SI.DIVISION_ID = PP.DIVISION_ID   -- 2019-03-27 kimcd item uom 정보 추가
										AND   SI.SITE_ID     = PP.SITE_ID       -- 2019-03-27 kimcd item uom 정보 추가
										AND   SI.ITEM_ID     = PP.ITEM_ID       -- 2019-03-27 kimcd item uom 정보 추가
										AND   A.INSTANCE_ID  = @INSTANCE_ID
										AND   PP.INSTANCE_ID = @INSTANCE_ID
										AND   PP.PLAN_DATE  >= @FROM_DATE
										AND   PP.PLAN_DATE  <= @TO_DATE
										AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
										AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'LINE_ID' )
										AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP BY PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
											,ISNULL(MARKET,'D')
											,LINE_ID
											,PP.PLAN_DATE
											,PP.EQUIPMENT_ID
											,PP.[WORK_REQUEST_MODEL_ID]
											,PP.[VERSION]
											,ISNULL(PP.[PROD_SEQ],'-')
											,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											) A
									, SCM_FACTORY_M B WITH(NOLOCK)
								WHERE A.FACTORY_ID = B.FACTORY_ID ) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID]
							AND	DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]	   = B.[VERSION]
							AND	DP.[PROD_SEQ]	   = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]	   = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							)
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
					END; -- IF @TABLE_NAME = 'FP_AMEND_DAILY_PLAN_H'
				ELSE IF @TABLE_NAME = 'FP_AMEND_PLAN_FORM_H'
					BEGIN
						OPEN C_MONTH_DATE
				        FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
														, @PLAN_WEEK
														, @FIRST_CREATE_DATE
														, @SECOND_CREATE_DATE
														, @THIRD_CREATE_DATE
														, @FOURTH_CREATE_DATE
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							-- HEADER
							INSERT INTO @TEMP_TABLE
							SELECT   B.PLAN_WEEK
									,B.PLAN_REVISION
									,COUNT(A.PLAN_REVISION)
							FROM   (SELECT DISTINCT
											@PLAN_WEEK     AS PLAN_WEEK -- [PLAN_WEEK]
											,DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END AS PLAN_REVISION-- PLAN_REVISION
									FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
													,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
											FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
											WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
											AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
											,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
											,DBO.FP_AMEND_PLAN_FORM_H       DP WITH(NOLOCK)
											,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
									WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
									AND    SL.LINE_ID        = DP.LINE_ID
									AND    SL.OPERATION_ID   = DP.OPERATION_ID
									AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
									AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
									AND    SP.PLAN_ID        = DP.FP_PLAN_ID
									AND    DP.FACTORY_ID    != '-'
									AND    SP.INSTANCE_ID    = @INSTANCE_ID
									AND    SP.PLAN_ID        = @FP_PLAN_ID
									AND    DP.INSTANCE_ID    = @INSTANCE_ID
									AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
									AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
									AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END) B
									LEFT OUTER JOIN [dbo].[FP_MPP_WPP_BASE_PLAN_H] A
									ON    A.PLAN_WEEK     = B.PLAN_WEEK
									AND   A.PLAN_REVISION LIKE B.PLAN_REVISION + '%'
							GROUP BY B.PLAN_WEEK
									,B.PLAN_REVISION; -- 2017-12-27 kimcd REVISION을 반복 채번하기 위해서 변수 Table에 입력

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_H]
									(   [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[INSTANCE_ID]
										,[PLAN_MONTH]
										,[WPP]
										,[MPP]
										,[MRP]
										,[WO]
										,[PLAN_DESCRIPTION]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[PLAN_GROUP_ID] )
							SELECT DISTINCT
									@PLAN_WEEK  -- [PLAN_WEEK]
									,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
										FROM   @TEMP_TABLE T
										WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd Table에서 추출함.
									,DP.COMPANY_ID
									,DP.DIVISION_ID
									,DP.SITE_ID
									,DP.PLANT_ID
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN '-' ELSE DP.FACTORY_ID END -- FACTORY ID
									,DP.INSTANCE_ID
									,@PLAN_MONTH  -- [PLAN_MONTH]
									,'N'-- WPP
									,'Y' -- CASE WHEN @P_MPP_FLAG = 'Y' THEN @P_MPP_FLAG ELSE 'N' END -- MPP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- CASE WHEN @P_MRP_FLAG = 'Y' THEN @P_MRP_FLAG ELSE 'N' END -- MRP -- 2018-04-23 kimcd MRP 계획 분리
									,'N' -- WO
									,DP.FP_PLAN_ID -- PLAN_DESCRIPTION
									,@USER_ID      -- INSERT ID
									,GETDATE()     -- INSERT TIME
									,@USER_ID      -- UPDATE ID
									,GETDATE()     -- UPDATE TIME
									,CASE WHEN SLV.PLAN_TYPE = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE '-' END -- PLAN_GROUP_ID
							FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
									FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
									AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
									,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_FORM_H       DP WITH(NOLOCK)
									,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							AND    SL.LINE_ID        = DP.LINE_ID
							AND    SL.OPERATION_ID   = DP.OPERATION_ID
							AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							AND    DP.FACTORY_ID    != '-'
							AND    SP.INSTANCE_ID    = @INSTANCE_ID
							AND    SP.PLAN_ID        = @FP_PLAN_ID
							AND    DP.INSTANCE_ID    = @INSTANCE_ID
							AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END

							--INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
							--		(   [PLAN_WEEK]
							--			,[PLAN_REVISION]
							--			,[COMPANY_ID]
							--			,[DIVISION_ID]
							--			,[SITE_ID]
							--			,[PLANT_ID]
							--			,[FACTORY_ID]
							--			,[LINE_ID]
							--			,[OPERATION_ID]
							--			,[EQUIPMENT_ID]
							--			,[PRODUCTION_TYPE]
							--			,[ITEM_ID]
							--			,[PLAN_DATE]
							--			,[PLAN_QTY]
							--			,[ROLL_QTY]
							--			,[JR_QTY]
							--			,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
							--			,[BATCH_QTY]
							--			,[INSERT_ID]
							--			,[INSERT_TIME]
							--			,[UPDATE_ID]
							--			,[UPDATE_TIME]
							--			,[MARKET])
							--SELECT @PLAN_WEEK
							--		,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
							--			FROM   @TEMP_TABLE T
							--			WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
							--		,MAX(DP.COMPANY_ID)
							--		,MAX(DP.DIVISION_ID)
							--		,MAX(DP.SITE_ID)
							--		,MAX(DP.PLANT_ID)
							--		,DP.FACTORY_ID
							--		,DP.LINE_ID
							--		,DP.OPERATION_ID
							--		,'-' -- [EQUIPMENT_ID]
							--		,ISNULL(SSLV.PRODUCTION_TYPE, DP.PRODUCTION_TYPE ) AS PRODUCTION_TYPE
							--		,DP.ITEM_ID
							--		,DP.PLAN_DATE
							--		,SUM(DP.MPP_OUT_QTY)    -- PLAN QTY
							--		,NULL                   -- ROLL QTY
							--		,NULL                   -- JR QTY
							--		,NULL                   -- CELL QTY   -- 2018-04-09 kimcd cell out 수량 추가
							--		,NULL                   -- BATCH QTY
							--		,@USER_ID               -- INSERT ID
							--		,GETDATE()              -- INSERT TIME
							--		,@USER_ID               -- UPDATE ID
							--		,GETDATE()              -- UPDATE TIME
							--		,ISNULL(DP.MARKET, 'D') -- PLAN_GROUP_ID
							--FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
							--				,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
							--		FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
							--		WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
							--		AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
							--		,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
							--		,DBO.FP_AMEND_PLAN_FORM_H       DP WITH(NOLOCK)
							--		------------------------------------------------------------------------------------------------------------------
							--		--2020-01-30 PIYONG ADD
							--	   LEFT OUTER JOIN (
							--						SELECT SEGMENT1 AS DIVISION_ID
							--								,SEGMENT2 AS SITE_ID
							--								,SEGMENT3 AS PLANT_ID
							--								,SEGMENT4 AS ITEM_ID
							--								,ATTRIBUTE1 AS PRODUCTION_TYPE
							--							  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
							--							WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
							--							AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
							--					   ) SSLV
							--					ON DP.DIVISION_ID	= SSLV.DIVISION_ID
							--				   AND DP.SITE_ID		= SSLV.SITE_ID
							--				   AND DP.PLANT_ID		= SSLV.PLANT_ID
							--				   AND DP.ITEM_ID		= SSLV.ITEM_ID
							--		--2020-01-30 PIYONG ADD END
							--		------------------------------------------------------------------------------------------------------------------
							--		,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
							--WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
							--AND    SL.LINE_ID        = DP.LINE_ID
							--AND    SL.OPERATION_ID   = DP.OPERATION_ID
							--AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
							--AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
							--AND    SP.PLAN_ID        = DP.FP_PLAN_ID
							--AND    DP.FACTORY_ID    != '-'
							--AND    SP.INSTANCE_ID    = @INSTANCE_ID
							--AND    SP.PLAN_ID        = @FP_PLAN_ID
							--AND    DP.INSTANCE_ID    = @INSTANCE_ID
							--AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
							--AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
							--AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
							--AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
							--AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'LINE_ID' )
							--AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
							--							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							--							 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
							--							 AND    CONDITION_TYPE = 'OPERATION_ID' )
							--GROUP  BY SP.PLAN_WEEK
							--			,DP.FP_PLAN_ID 
							--			,SL.MODEL_TYPE
							--			,DP.PLAN_DATE
							--			,DP.LINE_ID
							--			,DP.OPERATION_ID
							--			,DP.ITEM_ID
							--			,DP.FACTORY_ID
							--			,ISNULL(SSLV.PRODUCTION_TYPE, DP.PRODUCTION_TYPE )
							--			,ISNULL(DP.MARKET, 'D');

							INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
									(    [PLAN_WEEK]
										,[PLAN_REVISION]
										,[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,[PLAN_QTY]
										,[ROLL_QTY]
										,[JR_QTY]
										,[CELL_QTY]  -- 2018-04-09 kimcd cell out 수량 추가
										,[BATCH_QTY]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										,[MARKET]
										)
                                SELECT  [PLAN_WEEK]
										,[PLAN_REVISION]
										,MAX([COMPANY_ID]) 
										,MAX([DIVISION_ID])
										,MAX([SITE_ID])
										,MAX([PLANT_ID])
										,[FACTORY_ID]
										,[LINE_ID]
										,[OPERATION_ID]
										,[EQUIPMENT_ID]
										,[PRODUCTION_TYPE]
										,[ITEM_ID]
										,[PLAN_DATE]
										,SUM([PLAN_QTY])        AS PLAN_QTY
										,NULL                   AS ROLL_QTY
										,NULL                   AS JR_QTY
										,NULL                   AS CELL_QTY
										,NULL                   AS BATCH_QTY
										,@USER_ID               AS INSERT_ID
										,GETDATE()              AS INSERT_TIME
										,@USER_ID               AS UPDATE_ID
										,GETDATE()              AS UPDATE_TIME
										,[MARKET]

                                FROM (
										SELECT @PLAN_WEEK AS PLAN_WEEK
												,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
													FROM   @TEMP_TABLE T
													WHERE  PLAN_REVISION = DP.FP_PLAN_ID + '_' + CASE WHEN MAX(SLV.PLAN_TYPE) = 'PLAN GROUP' THEN SL.MODEL_TYPE ELSE DP.FACTORY_ID END ) -- PLAN_REVISION 2017-12-27 kimcd table에서 추출
													AS PLAN_REVISION
												,MAX(DP.COMPANY_ID) AS COMPANY_ID
												,MAX(DP.DIVISION_ID) AS DIVISION_ID
												,MAX(DP.SITE_ID) AS SITE_ID
												,MAX(DP.PLANT_ID) AS PLANT_ID
												,DP.FACTORY_ID AS FACTORY_ID
												,DP.LINE_ID
												,DP.OPERATION_ID
												,'-'      AS EQUIPMENT_ID
												,ISNULL(SSLV.PRODUCTION_TYPE, DP.PRODUCTION_TYPE) AS PRODUCTION_TYPE
												,DP.ITEM_ID
												,DP.PLAN_DATE
												,SUM(DP.MPP_OUT_QTY)    AS PLAN_QTY
												,NULL					AS CELL_QTY-- 2018-04-09 kimcd cell out 수량 추가
												,ISNULL(DP.MARKET, 'D') AS MARKET
										FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
														,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
												FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
												WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
												AND   SLV.SEGMENT1          = @INSTANCE_ID )  SLV
												,DBO.SCM_LINE_M                 SL WITH(NOLOCK)
									,DBO.FP_AMEND_PLAN_FORM_H       DP WITH(NOLOCK)
									------------------------------------------------------------------------------------------------------------------
									--2020-01-30 PIYONG ADD
								   LEFT OUTER JOIN (
													SELECT SEGMENT1 AS DIVISION_ID
															,SEGMENT2 AS SITE_ID
															,SEGMENT3 AS PLANT_ID
															,SEGMENT4 AS ITEM_ID
															,ATTRIBUTE1 AS PRODUCTION_TYPE
														  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
														WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
														AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
												   ) SSLV
												ON DP.DIVISION_ID	= SSLV.DIVISION_ID
											   AND DP.SITE_ID		= SSLV.SITE_ID
											   AND DP.PLANT_ID		= SSLV.PLANT_ID
											   AND DP.ITEM_ID		= SSLV.ITEM_ID
									--2020-01-30 PIYONG ADD END
									------------------------------------------------------------------------------------------------------------------
												,DBO.SCM_FP_PLAN_H              SP WITH(NOLOCK)
										WHERE  SL.FACTORY_ID     = DP.FACTORY_ID
										AND    SL.LINE_ID        = DP.LINE_ID
										AND    SL.OPERATION_ID   = DP.OPERATION_ID
										AND    SL.ELECTRODE_TYPE = DP.ELECTRODE_TYPE
										AND    SP.INSTANCE_ID    = DP.INSTANCE_ID
										AND    SP.PLAN_ID        = DP.FP_PLAN_ID
										AND    SP.INSTANCE_ID    = @INSTANCE_ID
										AND    SP.PLAN_ID        = @FP_PLAN_ID
										AND    DP.FACTORY_ID    != '-'
										AND    DP.INSTANCE_ID    = @INSTANCE_ID
										AND    DP.FP_PLAN_ID     = @FP_PLAN_ID
										AND    DP.FACTORY_ID     = CASE WHEN SLV.FACTORY_ID = '-' THEN DP.FACTORY_ID ELSE  SLV.FACTORY_ID END
										AND    SL.MODEL_TYPE     = CASE WHEN SLV.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE SLV.PLAN_GROUP_ID END
										AND    DP.PLAN_DATE     >= @SECOND_CREATE_DATE -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.PLAN_DATE     <= @THIRD_CREATE_DATE  -- 2017-12-27 kimcd 계획 추출할 일자 제한
										AND    DP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'LINE_ID' )
										AND    DP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	 WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	 AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP  BY SP.PLAN_WEEK
													,DP.FP_PLAN_ID 
													,SL.MODEL_TYPE
													,DP.PLAN_DATE
													,DP.LINE_ID
													,DP.OPERATION_ID
													,DP.ITEM_ID
													,DP.FACTORY_ID
													,ISNULL(SSLV.PRODUCTION_TYPE, DP.PRODUCTION_TYPE)
													,ISNULL(DP.MARKET, 'D')
                                   ) AS X
								   GROUP BY 
										[PLAN_WEEK]
									   ,[PLAN_REVISION]
									   ,[FACTORY_ID]
									   ,[LINE_ID]
									   ,[OPERATION_ID]
									   ,[EQUIPMENT_ID]
									   ,[PRODUCTION_TYPE]
									   ,[ITEM_ID]
									   ,[PLAN_DATE]
									   ,[MARKET]
										;

							IF @FIRST_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) AS PRODUCTION_TYPE --2020-01-30 PIYONG CHANGE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,  (SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM (SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
									   ------------------------------------------------------------------------------------------------------------------
										--2020-01-30 PIYONG ADD
									   LEFT OUTER JOIN (
														SELECT SEGMENT1 AS DIVISION_ID
															   ,SEGMENT2 AS SITE_ID
															   ,SEGMENT3 AS PLANT_ID
															   ,SEGMENT4 AS ITEM_ID
															   ,ATTRIBUTE1 AS PRODUCTION_TYPE
														  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
														 WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
														 AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
													   ) SSLV
													ON PP.DIVISION_ID = SSLV.DIVISION_ID
												   AND PP.SITE_ID = SSLV.SITE_ID
												   AND PP.PLANT_ID = SSLV.PLANT_ID
												   AND PP.ITEM_ID = SSLV.ITEM_ID
										--2020-01-30 PIYONG ADD END
										------------------------------------------------------------------------------------------------------------------
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE     >= @FIRST_CREATE_DATE 
								AND    PP.PLAN_DATE     <  @SECOND_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) --2020-01-30 PIYONG CHANGE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							IF @FOURTH_CREATE_DATE IS NOT NULL
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 시작
								INSERT INTO [dbo].[FP_MPP_WPP_BASE_PLAN_M]
										(   [PLAN_WEEK]
											,[PLAN_REVISION]
											,[COMPANY_ID]
											,[DIVISION_ID]
											,[SITE_ID]
											,[PLANT_ID]
											,[FACTORY_ID]
											,[LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[PRODUCTION_TYPE]
											,[ITEM_ID]
											,[PLAN_DATE]
											,[PLAN_QTY]
											,[ROLL_QTY]
											,[JR_QTY]
											,[CELL_QTY]
											,[BATCH_QTY]
											,[INSERT_ID]
											,[INSERT_TIME]
											,[UPDATE_ID]
											,[UPDATE_TIME]
											,[MARKET]
											,[WORK_REQUEST_MODEL_ID]
											,[VERSION]
											,[PROD_SEQ]
											,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
											)
								SELECT @PLAN_WEEK
										,( SELECT T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
											FROM   @TEMP_TABLE T
											WHERE  PLAN_REVISION = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
										,MAX(PP.COMPANY_ID)
										,MAX(PP.DIVISION_ID)
										,MAX(PP.SITE_ID)
										,MAX(PP.PLANT_ID)
										,PP.FACTORY_ID
										,PP.LINE_ID
										,PP.OPERATION_ID
										,MAX(PP.EQUIPMENT_ID)
										,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) AS PRODUCTION_TYPE --2020-01-30 PIYONG CHANGE
										,PP.ITEM_ID
										,PP.PLAN_DATE
										,SUM(PP.PLAN_QTY)   -- PLAN QTY
										,SUM(PP.ROLL_OUT_QTY)   -- ROLL QTY
										,SUM(PP.JR_OUT_QTY)     -- JR QTY
										,SUM(PP.CELL_OUT_QTY)   -- CELL_QTY
										,SUM(PP.BATCH_OUT_QTY)  -- BATCH QTY
										,@USER_ID      -- INSERT ID
										,GETDATE()     -- INSERT TIME
										,@USER_ID      -- UPDATE ID
										,GETDATE()     -- UPDATE TIME
										,PP.MARKET
										,PP.[WORK_REQUEST_MODEL_ID]
										,PP.[VERSION]
										,PP.[PROD_SEQ]
										,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM   (SELECT SLV.ATTRIBUTE1  AS PLAN_TYPE
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE ISNULL(@FACTORY_ID, '-') END  AS FACTORY_ID 
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE ISNULL(@PLAN_GROUP_ID,'-') END  AS PLAN_GROUP_ID
										FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
										WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_ID'
										AND   SLV.SEGMENT1          = @INSTANCE_ID )  RV
									,( SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
										FROM ( SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
												,( SELECT A.[INSTANCE_ID]
														,INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID != 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												UNION ALL
													SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
														,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
														,B.SITE_ID
														,B.FACTORY_ID
														,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
														,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
													FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
														,DBO.SCM_FACTORY_M B WITH(NOLOCK)
														,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND MP.SEGMENT1 = SLV.SEGMENT1
																	AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
													WHERE A.FACTORY_ID = B.FACTORY_ID     
													AND A.ACTIVE_FLAG = 'Y'     
													AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
													AND A.INSTANCE_ID = 'KR_CELL_M_P'
													AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND SLV.SEGMENT1 = A.INSTANCE_ID
												) B      
										WHERE A.INSTANCE_ID = B.INSTANCE_ID
											AND A.FACTORY_ID = B.LINK_FACTORY_ID
											AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
											AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
											AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										) B
									,  [dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H]  PP WITH(NOLOCK)
									   ------------------------------------------------------------------------------------------------------------------
										--2020-01-30 PIYONG ADD
									   LEFT OUTER JOIN (
														SELECT SEGMENT1 AS DIVISION_ID
															   ,SEGMENT2 AS SITE_ID
															   ,SEGMENT3 AS PLANT_ID
															   ,SEGMENT4 AS ITEM_ID
															   ,ATTRIBUTE1 AS PRODUCTION_TYPE
														  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
														 WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
														 AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
													   ) SSLV
													ON PP.DIVISION_ID = SSLV.DIVISION_ID
												   AND PP.SITE_ID = SSLV.SITE_ID
												   AND PP.PLANT_ID = SSLV.PLANT_ID
												   AND PP.ITEM_ID = SSLV.ITEM_ID
										--2020-01-30 PIYONG ADD END
										------------------------------------------------------------------------------------------------------------------
								WHERE  PP.FACTORY_ID = B.FACTORY_ID
								AND    PP.INSTANCE_TYPE = B.INSTANCE_TYPE
								AND    PP.PLAN_TYPE      = 'MPP'
								AND    PP.PLAN_DATE      > @THIRD_CREATE_DATE 
								AND    PP.PLAN_DATE     <= @FOURTH_CREATE_DATE
								AND    PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'LINE_ID' )
								AND    PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																AND    CONDITION_TYPE = 'OPERATION_ID' )
								AND    EXISTS ( SELECT   TOP 1  1
												FROM     [dbo].[FP_MPP_WPP_BASE_PLAN_H]  MWB
														,@TEMP_TABLE                     T
												WHERE    MWB.PLAN_WEEK     = @PLAN_WEEK
												AND      MWB.PLAN_REVISION = T.PLAN_REVISION + '_' + CONVERT(NVARCHAR(10), T.CURRENT_NUM + 1)
												AND      T.PLAN_REVISION   = @FP_PLAN_ID + '_' + CASE WHEN RV.PLAN_TYPE = 'PLAN GROUP' THEN RV.PLAN_GROUP_ID ELSE RV.FACTORY_ID END )
							GROUP  BY RV.PLAN_TYPE
									 ,RV.PLAN_GROUP_ID
									 ,RV.FACTORY_ID
									 ,PP.LINE_ID
									 ,PP.OPERATION_ID
									 ,PP.ITEM_ID
									 ,PP.FACTORY_ID
									 ,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) --2020-01-30 PIYONG CHANGE
									 ,PP.MARKET
									 ,PP.PLAN_DATE -- 2019-03-27 kimcd group by 추가
									 ,PP.[WORK_REQUEST_MODEL_ID]
									 ,PP.[VERSION]
									 ,PP.[PROD_SEQ]
									 ,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									 ;
								-- 2018-04-23 kimcd 과거 일자 계획은 기존 최종 Plan Revision 정보 기반으로 복사하여 형성 끝

							DELETE @TEMP_TABLE -- 2018-04-23 kimcd clear temp table

							FETCH NEXT FROM C_MONTH_DATE INTO  @PLAN_MONTH
															, @PLAN_WEEK
															, @FIRST_CREATE_DATE
															, @SECOND_CREATE_DATE
															, @THIRD_CREATE_DATE
															, @FOURTH_CREATE_DATE
						END  -- WHILE @@FETCH_STATUS = 0  C_DATA
						CLOSE C_MONTH_DATE;
						DEALLOCATE C_MONTH_DATE;   -- 메모리 해제

						-- 기존 누적 계획 정리
						-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
						UPDATE A
						SET  [PLAN_QTY]      = 0
							,[PLAN_IN_QTY]   = 0
							,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
							,[UPDATE_TIME]   = GETDATE()
							,[ROLL_IN_QTY]   = 0
							,[ROLL_OUT_QTY]  = 0
							,[JR_IN_QTY]     = 0
							,[JR_OUT_QTY]    = 0
							,[BATCH_IN_QTY]  = 0
							,[BATCH_OUT_QTY] = 0
							,[CELL_IN_QTY]   = 0
							,[CELL_OUT_QTY]  = 0
							FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
								,(
									SELECT A.PLAN_GROUP_ID
											,B.INSTANCE_TYPE
											,B.FACTORY_ID
		 									,A.DIVISION_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
											,A.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
									FROM (  SELECT TOP 1
													   INSTANCE_DATE AS PLAN_DATE
													 , INSTANCE_ID
													 , DIVISION_ID
													 , FACTORY_ID
													 , PLAN_GROUP_ID
													 , RELEASE_PLAN_ID
												FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
												WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
												AND    INSTANCE_ID     = @INSTANCE_ID
												ORDER BY C.INSERT_TIME DESC
												) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
											,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID != 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											UNION ALL
												SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
													,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																AND MP.SEGMENT1 = SLV.SEGMENT1
																AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												WHERE A.FACTORY_ID = B.FACTORY_ID     
												AND A.ACTIVE_FLAG = 'Y'     
												AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												AND A.INSTANCE_ID = 'KR_CELL_M_P'
												AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND SLV.SEGMENT1 = A.INSTANCE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
										AND A.FACTORY_ID = B.LINK_FACTORY_ID
										AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
										AND A.INSTANCE_ID = @INSTANCE_ID
										AND A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
								) B
							WHERE A.FACTORY_ID = B.FACTORY_ID
							AND   A.INSTANCE_TYPE = B.INSTANCE_TYPE
							AND   A.PLAN_DATE >= @FROM_DATE
							AND   A.PLAN_DATE <= @TO_DATE
							AND   A.PLAN_TYPE  = 'MPP'
							AND   A.LINE_ID       IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'LINE_ID' )
							AND   A.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
														FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
														WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
														AND    CONDITION_TYPE = 'OPERATION_ID' )


						-- MPP 데이터 생성
						MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
						USING ( SELECT B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,A.FACTORY_ID
									,A.PLAN_GROUP_ID
									,(SELECT TOP 1 INSTANCE_TYPE
										FROM ( SELECT FF.INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID != 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
													FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
													WHERE FF.ACTIVE_FLAG = 'Y'     
													AND FF.INSTANCE_ID = 'KR_CELL_M_P'
													AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
									,A.TOP_ITEM_ID
									,A.ITEM_ID
									,A.OPERATION_ID
									,ISNULL((SELECT LOCATION 
												FROM SCM_LINE_M WITH(NOLOCK)
												WHERE LINE_ID = A.LINE_ID
												AND OPERATION_ID = A.OPERATION_ID
												AND FACTORY_ID = A.FACTORY_ID
												AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
									,A.FP_PRODUCTION_TYPE
									,A.MARKET
									,A.LINE_ID
									,A.ELECTRODE_TYPE
									,A.PLAN_DATE
									,ISNULL(A.PLAN_QTY,0) AS PLAN_QTY
									,A.PLAN_IN_QTY
									,'PR_SCM_MPP_WPP_CONVERT' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_SCM_MPP_WPP_CONVERT' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME
									,'MPP' AS PLAN_TYPE     -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
									,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.ROLL_IN_QTY
									,A.ROLL_OUT_QTY
									,A.JR_IN_QTY
									,A.JR_OUT_QTY
									,A.BATCH_IN_QTY
									,A.BATCH_OUT_QTY
									,A.CELL_IN_QTY
									,A.CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
								FROM (
									SELECT PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가 --2020-01-30 PIYONG CHANGE
											,ISNULL(MARKET,'D') AS MARKET
											,LINE_ID
											,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
											,PP.PLAN_DATE
											,SUM(MPP_OUT_QTY) AS PLAN_QTY
											,SUM(MPP_IN_QTY) AS PLAN_IN_QTY
											,MAX(A.INSTANCE_ID) AS INSTANCE_ID
											,'-'                    AS EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
											,NULL                   AS ROLL_IN_QTY
											,NULL                   AS ROLL_OUT_QTY
											,NULL                   AS JR_IN_QTY
											,NULL                   AS JR_OUT_QTY
											,NULL                   AS BATCH_IN_QTY
											,NULL                   AS BATCH_OUT_QTY
											,NULL                   AS CELL_IN_QTY
											,NULL                   AS CELL_OUT_QTY
											-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
											,'-' AS [WORK_REQUEST_MODEL_ID]
											,'-' AS [VERSION]
											,'-' AS [PROD_SEQ]
											,'-' AS [PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
										FROM FP_AMEND_PLAN_FORM_H PP WITH(NOLOCK)
										   ------------------------------------------------------------------------------------------------------------------
										   --2020-01-30 PIYONG ADD
										   LEFT OUTER JOIN (
															SELECT SEGMENT1 AS DIVISION_ID
																   ,SEGMENT2 AS SITE_ID
																   ,SEGMENT3 AS PLANT_ID
																   ,SEGMENT4 AS ITEM_ID
																   ,ATTRIBUTE1 AS PRODUCTION_TYPE
															  FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
															 WHERE LOOKUP_TYPE_CODE= 'FORMATION_EXCEPTION_TYPE'
															 AND   ACTIVE_FLAG      = 'Y' -- 2020-03-05 kimcd 조건 추가
														   ) SSLV
														ON PP.DIVISION_ID = SSLV.DIVISION_ID
													   AND PP.SITE_ID = SSLV.SITE_ID
													   AND PP.PLANT_ID = SSLV.PLANT_ID
													   AND PP.ITEM_ID = SSLV.ITEM_ID
											--2020-01-30 PIYONG ADD END
											------------------------------------------------------------------------------------------------------------------
											,(  SELECT TOP 1
														   INSTANCE_DATE AS PLAN_DATE
														 , INSTANCE_ID
														 , DIVISION_ID
														 , FACTORY_ID
														 , PLAN_GROUP_ID
														 , RELEASE_PLAN_ID
													FROM   DBO.FP_RELEASE_PLAN_INFO_H C(NOLOCK)
													WHERE  RELEASE_PLAN_ID = @FP_PLAN_ID
													AND    INSTANCE_ID     = @INSTANCE_ID
													ORDER BY C.INSERT_TIME DESC
													) A -- 2019-04-08 kimcd SCM_FP_PLAN_DETAIL_H 에서  FP_RELEASE_PLAN_INFO_H 로 변경
										WHERE A.INSTANCE_ID  = @INSTANCE_ID
										AND   PP.INSTANCE_ID = @INSTANCE_ID
										AND   PP.PLAN_DATE  >= @FROM_DATE
										AND   PP.PLAN_DATE  <= @TO_DATE
										AND   PP.FACTORY_ID    != '-'
										AND   A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
										AND   A.FACTORY_ID    = ISNULL(@FACTORY_ID, '-')     -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   A.PLAN_GROUP_ID = ISNULL(@PLAN_GROUP_ID, '-')  -- 2018-04-23 kimcd 조건 추가. 다른 Plan이 변경됨
										AND   PP.LINE_ID       IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'LINE_ID' )
										AND   PP.OPERATION_ID  IN ( SELECT CONDITION_VALUE 
																	FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
																	WHERE  CALL_SEQUENCE  = @P_CALL_SEQUENCE_ID
																	AND    CONDITION_TYPE = 'OPERATION_ID' )
										GROUP BY PP.FACTORY_ID
											,A.PLAN_GROUP_ID
											,TOP_ITEM_ID
											,PP.ITEM_ID
											,OPERATION_ID
											,ISNULL(SSLV.PRODUCTION_TYPE, PP.PRODUCTION_TYPE ) -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정 --2020-01-30 PIYONG CHANGE
											,ISNULL(MARKET,'D')
											,LINE_ID
											,PP.PLAN_DATE
											--,PP.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									) A
									, SCM_FACTORY_M B WITH(NOLOCK)
								WHERE A.FACTORY_ID = B.FACTORY_ID ) B
						ON (	DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID]
							AND	DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]	   = B.[VERSION]
							AND	DP.[PROD_SEQ]	   = B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]	   = B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리							
							)
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = 'PR_SCM_MPP_WPP_CONVERT'
										,DP.[UPDATE_TIME]   = GETDATE()
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION] -- 2022-06-09 kimcd location 항상 갱신하도록 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[FP_PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[FP_PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO] -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
					END; -- IF @TABLE_NAME = 'FP_AMEND_PLAN_FORM_H'

			END; -- IF @TYPE = 'MPP'
	--------------------------------------------------------------------------------------------------------------------
	----- 2018-03-15 PIYONG   FP_DAILY_PRODUCTIOIN_PLAN_H 정보 생성 끝
	--------------------------------------------------------------------------------------------------------------------


		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN;

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
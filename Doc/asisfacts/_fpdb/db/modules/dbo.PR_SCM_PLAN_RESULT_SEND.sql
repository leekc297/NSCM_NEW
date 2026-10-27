CREATE PROCEDURE [dbo].[PR_SCM_PLAN_RESULT_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_PLAN_RESULT_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : Plan 종료시에 Plan 결과 검증 Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2017.02.14
-- Update Date		   : 2017.06.14 PIYONG 1.3
--						 2017.07.13 PIYONG 1.5
--						 2017.08.25	PIYONG 1.7
--						 2017.09.29	PIYONG 2.0
--						 2017.11.06	PIYONG 2.1
--						 2017.11.16	PIYONG 2.2
--						 2018.02.07 PIYONG 2.3
--                       2018.04.29 kimcd  2.4
--                       2018.05.17 kimcd  2.5
--                       2018.07.24 kimcd  2.6
--                       2018.09.11 PIYONG 3.0
--						 2018.12.03 PIYONG 3.1
--                       2018.12.18 kimcd  3.2
--						 2019.03.18 PIYONG 3.3
--						 2019.05.15 PIYONG 3.4
--						 2019.06.03 PIYONG 3.5
--                       2020.12.16 kimcd  3.6

-- Author              : 
-- Version             : 1.1   Initial Creation
--                       1.2   kimcd change atcutal qty table
--						 1.3   2017-06-14 PIYONG	 실적 합산시 ADD_QTY 추가
--						 1.4   2017-06-14 PIYONG	 실적수량 조회시 ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--						 1.5   실적 수량 조회 조건 추가
--							   RELEASE 조회 쿼리 조건 추가( 여러번 RELEASE 시 값이 배수로 나오는 문제로 인한 추가 )
--                       1.6   2017-07-31 kimcd 7일 구간 조회에서 확정 WO 조회로 수정. Cell Hard Pegging용 Amend 조회 수정
--						 1.7   SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--						 2.0   PEGGING 누락 정보 추가
--						 2.1   PEGGING 누락 확인 쿼리 수정 PLAN_ID -> RELEASE_PLAN_ID
--							   조회 조건 plan_group_id  추가
--						 2.2   1) AMEND 조회 쿼리에  UI_TYPE 조건 추가
--							   2) PSI Amend용 조회 문장 추가
--							   3) plan_group_id 인자값 추가로 제목처리 변경
--						 2.3   AMEND 데이터 조회시 FATORY 기준이 아닌 PLAN_GROUP 별로 계획을 수립했을때 조건 추가(INSTANCE_PLANNING_GROUP)
--                       2.4   kimcd 변경 필요한 정보만 mes로 전송됨 validation 일별 수량 추출 방식 변경
--                       2.5   kimcd Amend 정보 조회하는 것에 수량 0보다 큰 조건 추가. 사업부 이동 생산의 경우 검증 오류 방지
--                       2.6   2018-07-24 kimcd MES 정보 조회에서 FP Plan ID 기반 XIF_MES_WO_S 정보 존재 CHECK하는 문장 제거
--						 3.0   TABLE_HEAD_CONTENT2,TABLE_CONTENTS2 주석처리
--						 3.1   BOM 적용일자로 변경 GETDATE() -> A.START_TIME
--                       3.2   2018-12-18 kimcd 수량 점검을 out 수량 기준으로 수행
--						 3.3   PEGGING 체크 조건 변경
--						 3.4   SCM_BOM_M 조회시 ACTIVE_FLAG='Y' 조건 추가
--						 3.5   MES 투입 수량과 생산 계획 동기화
--								-ERP, MES 생산 계획시 MES에 투입 된 WO에 수량을 0로 내릴려고 할때 투입된 수량을 변경하므로 엔진 계획수량으로 변경
--                       3.6   2020-12-26 kimcd Plan Group 배포에서 A6000 공정은 Plan Group 기반으로 라인 관리 안 되어 조건에서 예외 처리
--                       3.7   2024-04-08 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영
-- ================================================================================================
-- PARAMETER
@instance_id    NVARCHAR(100) = 'KR_E_PRE',
@instance_date  NVARCHAR(100) = '20170418',
@factory_id     NVARCHAR(100) =  'E1',
@plan_group_id  NVARCHAR(100) =  '-'


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_PLAN_RESULT_SEND'
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
	DECLARE @MAIL_PKEY             NVARCHAR(100)
	DECLARE @MAIL_SEQ              numeric
	DECLARE @MAIL_SUBJECT          NVARCHAR(1000)
	DECLARE @MAIL_SUBJECT2         NVARCHAR(1000)
	DECLARE @MAIL_BODY             NVARCHAR(4000)
	DECLARE @MAIL_QUERY            NVARCHAR(4000)
	DECLARE @ATTACH_FILE_NAME      NVARCHAR(4000)
	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)                               
	DECLARE @MAIL_PROFILE_NAME     NVARCHAR(100)
	DECLARE @MAIL_SEND_FLAG        NVARCHAR(1)
	DECLARE @MAIL_QUERY2           NVARCHAR(4000)
	DECLARE @RtnCode               INT


	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS        NVARCHAR(MAX)
	DECLARE @TABLE_HEAD_CONTENT    NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS2       NVARCHAR(MAX)
	DECLARE @TABLE_HEAD_CONTENT2   NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS3       NVARCHAR(MAX)
	DECLARE @TABLE_HEAD_CONTENT3   NVARCHAR(MAX)
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)
	DECLARE @S_QUERY               NVARCHAR(MAX)

	-- 중복되는 BOM 체크
	DECLARE @BOM_CNT		   INT = 0;



	SET @ROWCOUNT = @@ROWCOUNT

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
		
       SET @MAIL_TITLE = 'TEST Summary'+'__'+@instance_id+'__'+@instance_date+'__'+ISNULL(@factory_id,@plan_group_id)	--2017.11.16 PIYONG 처리 변경

       SET @TABLE_HEAD_CONTENT = (
									select 'PLANT_ID' as td ,'FACTORY_ID' as td ,'OPERATION_ID' as td ,'ITEM_ID' as td ,'MAKE_DATE' as td ,'ERP' as td ,'MES' as td ,'RELEASE' as td ,'AMEND' as td ,'PLAN_EQUIPMENT' as td ,'CHK1_RELEASE' as td  ,'CHK2_MES' as td ,'CHK3_ERP' as td 
									 FOR   XML RAW('tr'), ELEMENTS
	                             )
	   SET @MAIL_CONTENT = N'Release결과'

       SET @TABLE_CONTENTS = ( SELECT td = PLANT_ID, td = FACTORY_ID, td = OPERATION_ID, td = ITEM_ID, td = MAKE_DATE, td = ERP, td = MES, td = RELEASE, td = AMEND, td = PLAN_EQUIPMENT_R, td = CHK1_RELEASE, td = CHK2_MES, td = CHK3_ERP
							    FROM (
           								select PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE
                									 , SUM(case when groups = 'ERP' then make_qty else 0 end) 'ERP'
                									 , SUM(case when groups = 'MES' then make_qty else 0 end)  'MES' 
                									 , SUM(case when groups = 'RELEASE' then make_qty else 0 end ) 'RELEASE'
                									 , SUM(case when groups = 'AMEND' then make_qty else 0 end ) 'AMEND'
                									 , SUM(case when groups = 'PLAN_EQUIPMENT_R' then make_qty else 0 end ) 'PLAN_EQUIPMENT_R'
                									 , CASE WHEN  SUM(case when groups = 'AMEND' then make_qty else 0 end ) <> SUM(case when groups = 'RELEASE' then make_qty else 0 end ) THEN 'NG_RELEASE' ELSE '' END CHK1_RELEASE
                									 , CASE WHEN  SUM(case when groups = 'RELEASE' then make_qty else 0 end ) <> SUM(case when groups = 'MES' then make_qty else 0 end) THEN 'NG_MES' ELSE '' END CHK2_MES                
                									 , CASE WHEN  SUM(case when groups = 'MES' then make_qty else 0 end) <> SUM(case when groups = 'ERP' then make_qty else 0 end) THEN 'NG_ERP' ELSE '' END CHK3_ERP
           								from (

												select 'ERP' as groups, plant_id, factory_id, operation_id, item_id, make_date, sum(make_qty) as make_qty
												from  ( select 'ERP' groups , plant_id, a.factory_id, OPERATION_ID, item_id,SUBSTRING(a.plan_date,1,8) make_date , a.FP_PLAN_QTY--a.plan_qty /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/	-- 2019-06-03 PIYONG 엔진 수량으로 변경 PLAN_QTY -> FP_PLAN_QTY
																																											/*	- (SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
																																																/*	2018-12-18 kimcd 실적 양품 수량으로 제한
																																																    + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0)) 
																																																	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0)) 
																																																	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))
																																																	+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0)) */
																																																,0)
																																													  FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
																																													 WHERE W.WOID   = A.WORK_ORDER_ID
																																													   AND W.PROCID = A.OPERATION_ID
																																													   AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
																																													)	*/ as  make_qty
															from [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] a  WITH(NOLOCK)
																 ,(
																	SELECT   DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID
																		   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS  -- 2017-11-06  PIYONG 최종릴리즈 찾기위해 PARTITION BY에 , PLAN_GROUP_ID 조건 추가
																	  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
																	 WHERE INSTANCE_ID =  @instance_id  
																	   AND INSTANCE_DATE = @instance_date
																	   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																								FACTORY_ID
																							 ELSE @factory_id
																							  END
																	  -- 2017-11-06  PIYONG 최종릴리즈 찾기위해 조건 추가
																	   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																								PLAN_GROUP_ID
																							 ELSE @plan_group_id
																							  END
																 ) plans
														   where fp_plan_id = plans.plan_id
															 and plans.nums = 1
															 and ( a.[TOP_BACK_IND] = 'B' or a.[TOP_BACK_IND] is null )
															 AND A.FIX_TYPE = 'Y' -- 2017-07-31 KIMCD ADD
--															 and a.FACTORY_ID = plans.FACTORY_ID	--2017-11-06 PIYONG DELETE (SY_XIF_ERP_PRODUCTION_PLAN_S에 FACTORY_ID 값이 '-' 없어 조건 제거
														-- 2018-04-29 kimcd work order master 관리에 따른 erp i/f 정보 추출 방식 수정 시작
               											UNION ALL        
    														select 'ERP' AS GROUPS,  a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112) , a.plan_qty /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/
     															from [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_R] a  WITH(NOLOCK)
      															,(
	      															SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
        																		, row_number() over ( partition by instance_id, instance_date, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID order by insert_time desc ) nums	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
      																  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
      																 WHERE INSTANCE_ID = @instance_id
																	   AND INSTANCE_DATE = @instance_date
																	   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																								FACTORY_ID
																							 ELSE @factory_id
																							  END
																		-- 2017-11-06 PIYONG  조회 조건 추가
																	   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																									PLAN_GROUP_ID
																								ELSE @plan_group_id
																								 END
      															) plans
    															where a.FP_PLAN_ID = plans.plan_id
     															--and  plan_date <= dateadd(dd,7, convert(datetime,plans.instance_date) )   -- 대상 날짜..  일주일치만 check. block -- 2017-07-31 KIMCD block
																and  FIX_TYPE   IN ('F','N')  -- 2017-07-31 KIMCD add
     															and  ORDER_TYPE IN ('W')
																and  plans.nums = 1     
																AND  NOT EXISTS ( SELECT 1
																				  FROM   [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] XEP WITH(NOLOCK)
																				  WHERE  XEP.FP_PLAN_ID = A.FP_PLAN_ID
																				  AND    XEP.WORK_ORDER_ID = A.WORK_ORDER_ID )
														-- 2018-04-29 kimcd work order master 관리에 따른 erp i/f 정보 추출 방식 수정 끝
														  ) planss
													group by plant_id, factory_id, OPERATION_ID, item_id,make_date
												UNION ALL
												select 'MES' as groups, plant_id, factory_id, OPERATION_ID, item_id, make_date, sum(make_qty) as make_qty
												  from (select 'MES' as groups
                                                               , F.PLANT_ID -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
                                                               , a.builno factory_id
                                                               , OPERATION_ID
                                                               , item_id
                                                               , replace( SUBSTRING(a.plan_date,1,10) ,'-','') make_date 
                                                               , CAST(A.ATTR_08 AS NUMERIC)--out_qty /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/ --2019-06-03 PIYONG 엔진 수량으로 변경 OUT_QTY -> ATTR_08
																																																/*	- ( SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
																																																						/*2018-12-18 kimcd 실적 양품 수량으로 제한
																																																						+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))
																																																						+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0)) 
																																																						+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))
																																																						+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))*/
																																																					 ,0)
																																																		   FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)
																																																		  WHERE W.WOID   = A.WO
																																																			AND	W.PROCID = A.OPERATION_ID
																																																			AND	W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')  	-- PIYONG 2017-08-25 PROD 추가
																																																			AND	W.WO_DETL_ID = A.WO_DETAIL
																																																		)*/ AS make_qty
														  from [dbo].SY_XIF_MES_WO_S a
                                                         INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
                                                            ON F.FACTORY_ID = a.BUILNO  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
															   ,(
																SELECT FACTORY_ID, RELEASE_PLAN_ID plan_id
																	   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) nums-- 2017-11-06  PIYONG 최종릴리즈 찾기위해 PARTITION BY에 , PLAN_GROUP_ID 조건 추가
																  FROM [DBO].FP_RELEASE_PLAN_INFO_H H  WITH(NOLOCK)
																 WHERE INSTANCE_ID =  @instance_id
																   AND INSTANCE_DATE = @instance_date
																   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																							 FACTORY_ID
																						 ELSE @factory_id
																						  END
																  -- 2017-11-06  PIYONG 최종릴리즈 찾기위해 조건 추가
																   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																								PLAN_GROUP_ID
																							 ELSE @plan_group_id
																							  END
															   ) plans
														 where a.plan_id = plans.plan_id
--														   and builno = plans.FACTORY_ID  		--2017-11-06 PIYONG DELETE (SY_XIF_MES_WO_S에 builno 값이 '-' 없어 조건 제거
														   and plans.nums = 1
														   and ( a.attr_05 = 'B' or a.attr_05 is null )
														   AND A.IS_RELEASE = 'Y' -- 2017-07-31 KIMCD ADD
														   and if_id <> 'OFP0_OPLM_FP_WO'
														-- 2018-04-29 kimcd work order master 관리에 따른 MES i/f 정보 추출 방식 수정 시작
               											UNION ALL        
    														select 'MES' AS GROUPS,  a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112) , a.plan_qty /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/
     															from [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_R] a  WITH(NOLOCK)
      															,(
	      															SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
        																		, row_number() over ( partition by instance_id, instance_date, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID order by insert_time desc ) nums	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
      																  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
      																 WHERE INSTANCE_ID = @instance_id
																	   AND INSTANCE_DATE = @instance_date
																	   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																								FACTORY_ID
																							 ELSE @factory_id
																							  END
																		-- 2017-11-06 PIYONG  조회 조건 추가
																	   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																									PLAN_GROUP_ID
																								ELSE @plan_group_id
																								 END
      															) plans
    															where a.FP_PLAN_ID = plans.plan_id
     															--and  plan_date <= dateadd(dd,7, convert(datetime,plans.instance_date) )   -- 대상 날짜..  일주일치만 check. block -- 2017-07-31 KIMCD block
																and  FIX_TYPE   IN ('F','N')  -- 2017-07-31 KIMCD add
																and  plans.nums = 1     
																/* 2018-07-24 kimcd FP Plan ID 기반 정보 존재 점검하는 문장 제거
																AND  EXISTS ( SELECT 1
																			  FROM   [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK)
																			  WHERE  XMW.PLAN_ID   = A.FP_PLAN_ID ) */
																AND  NOT EXISTS ( SELECT 1
																				  FROM   [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK)
																				  WHERE  XMW.PLAN_ID   = A.FP_PLAN_ID
																				  AND    XMW.WO        = A.WORK_ORDER_ID
																				  AND    XMW.WO_DETAIL = A.WORK_ORDER_SPL_ID )
														-- 2018-04-29 kimcd work order master 관리에 따른 erp i/f 정보 추출 방식 수정 끝
													   ) planss
												 group by plant_id, factory_id, OPERATION_ID, item_id, make_date
												-- 2017-07-31 KIMCD ADD Start
             									UNION ALL
												select 'AMEND' as groups, ( select f.plant_id from dbo.scm_factory_m f where f.factory_id = w.after_site_id ) as PLANT_ID
														,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty  /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/
												FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w
													  ,(
                          								SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
															   ,PLAN_GROUP_ID																							--2017-11-06 PIYONG ADD
															   , SLV.ATTRIBUTE1 AS UI_TYPE							   -- 2017-11-16 PIYONG UI_TYPE 추가
                                   							   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) nums-- 2017-11-06  PIYONG 최종릴리즈 찾기위해 PARTITION BY에 , PLAN_GROUP_ID 조건 추가
                           								  FROM [DBO].FP_RELEASE_PLAN_INFO_H H  WITH(NOLOCK)
															   , SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK) -- 2017-11-16 PIYONG TABLE 추가 
                           								 WHERE INSTANCE_ID = @instance_id
														   AND INSTANCE_DATE = @instance_date
														   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																					FACTORY_ID 
																				 ELSE
																					@factory_id
																				  END
														  -- 2017-11-06  PIYONG 최종릴리즈 찾기위해 조건 추가
														   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																						PLAN_GROUP_ID
																					ELSE
																						@plan_group_id
																					 END
														   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI' -- 2017-11-16 조건 추가
														   AND SLV.SEGMENT1   = H.INSTANCE_ID  -- 2017-11-16 조건 추가
													   ) plans,
													  (
														select DEMAND_ID, MIN(AFTER_PLAN_DATE) AS PLAN_DATE
														FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w
															  ,(
                          										SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
																		,PLAN_GROUP_ID																				--2017-11-06 PIYONG ADD
																		, SLV.ATTRIBUTE1 AS UI_TYPE							   -- 2017-11-16 PIYONG UI_TYPE 추가
                                   									   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) nums-- 2017-11-06  PIYONG 최종릴리즈 찾기위해 PARTITION BY에 , PLAN_GROUP_ID 조건 추가
                           										  FROM [DBO].FP_RELEASE_PLAN_INFO_H H  WITH(NOLOCK)
																		, SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK) -- 2017-11-16 PIYONG TABLE 추가 
                           										 WHERE INSTANCE_ID = @instance_id
																   AND INSTANCE_DATE = @instance_date
																   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																							FACTORY_ID
																						 ELSE @factory_id
																						  END
																  -- 2017-11-06  PIYONG 최종릴리즈 찾기위해 조건 추가
																   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																								PLAN_GROUP_ID
																							 ELSE @plan_group_id
																							  END
																   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI' -- 2017-11-16 조건 추가
																   AND SLV.SEGMENT1   = H.INSTANCE_ID  -- 2017-11-16 조건 추가

															   ) plans
														where master_id = plans.instance_id
														and  w.plan_id = plans.basis_plan_id
														AND  w.after_in_qty > 0
														and  plans.nums = 1
--														and  after_site_id = plans.FACTORY_ID  --2017-11-06 PIYONG DELDE
														--2017-11-06 PIYONG 조회 조건 변경
														AND  PLANS.UI_TYPE = 'AMEND UI'  -- 2017-11-16 PIYONG 조건 추가
														-- FP_AMEND_PRODUCTION_PLAN_R 테이블에 PLAN_GROUP_ID컬럼이 없기 때문에  FACTORY 기준 또는 PLAN GROUP기준으로 조회한다.
														AND   EXISTS (SELECT 1 
																	   FROM   SCM_LINE_M   SLM WITH(NOLOCK)
																	   WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID
																	   AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID
																	   AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID
																	   AND    ( SLM.FACTORY_ID = plans.FACTORY_ID
																				OR SLM.MODEL_TYPE = plans.PLAN_GROUP_ID)) -- 해당 라인이 배포에 참여했는 지 검증한다.
														group by DEMAND_ID
													  ) x
												where master_id = plans.instance_id
												and  w.plan_id = plans.basis_plan_id
--												and  after_site_id = plans.FACTORY_ID  --2017-11-06 PIYONG DELTE
												--2017-11-06 PIYONG 조회 조건 변경
												AND  PLANS.UI_TYPE = 'AMEND UI'  -- 2017-11-16 PIYONG 조건 추가
												-- FP_AMEND_PRODUCTION_PLAN_R 테이블에 PLAN_GROUP_ID컬럼이 없기 때문에  FACTORY 기준 또는 PLAN GROUP기준으로 조회한다.
												AND   EXISTS (SELECT 1 
																FROM   SCM_LINE_M   SLM WITH(NOLOCK)
																WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID
																AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID
																AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID
																AND    ( SLM.FACTORY_ID = plans.FACTORY_ID
																		OR SLM.MODEL_TYPE = plans.PLAN_GROUP_ID)) -- 해당 라인이 배포에 참여했는 지 검증한다.
												and  w.demand_id = x.demand_id
												AND  (
														(	
															@factory_id IS NOT NULL AND PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
																												   FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																												  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
																												    AND SLV.ACTIVE_FLAG = 'Y'
																													AND SLV.SEGMENT1 = plans.INSTANCE_ID
																													AND SLV.SEGMENT2 = W.AFTER_SITE_ID), convert(datetime,plans.instance_date) ) -- 2017-11-16 PIYONG  PLAN FACTORY ID에서 W.AFTER_SITE_ID로 변경
														-- 2018-02-07 PIYONG  ADD 시작
														)OR( 
															@plan_group_id IS NOT NULL AND  PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
																													   FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																													  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
																													    AND SLV.ACTIVE_FLAG = 'Y'
																													    AND SLV.SEGMENT1 = plans.INSTANCE_ID
																													    AND SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )
														  )
														-- 2018-02-07 PIYONG  ADD 끝
													  )
												and  plans.nums = 1
												AND  W.AFTER_IN_QTY > 0 -- 2018-05-17 kimcd 사업부 이동 생산에 대비하여 0보다 큰 수량만 취함
												and  exists (
															  select 1
															  from   FP_INSTANCE_CONFIG_M k
															  where  k.instance_id = w.master_id
															  AND    k.CATEGORY_ID  = 'PLAN_CATEGORY'
															  AND    k.KEY_ID       = 'CELL_HARD_PEGGING'
															  AND    k.KEY_VALUE    = 'Y'                                  
															)
												group by after_site_id, after_operation_id, ITEM_ID, after_plan_date
												-- 2017-07-31 KIMCD ADD End
               									UNION ALL
                   								select 'AMEND', ( select f.plant_id from dbo.scm_factory_m f where f.factory_id = w.after_site_id ) as PLANT_ID
                           								,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty  /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/
                   								  FROM [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w
                         							   ,(
                          								SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
																,PLAN_GROUP_ID																				--2017-11-06 PIYONG ADD
																, SLV.ATTRIBUTE1 AS UI_TYPE							   -- 2017-11-16 PIYONG UI_TYPE 추가
                                   								, ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) nums	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
                           								  FROM [DBO].FP_RELEASE_PLAN_INFO_H H WITH(NOLOCK)
																, SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK) -- 2017-11-16 PIYONG TABLE 추가 
                           								 WHERE INSTANCE_ID = @instance_id 
														   AND INSTANCE_DATE = @instance_date
														   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																					FACTORY_ID
																				 ELSE @factory_id
																				  END
															-- 2017-11-06 PIYONG  조회 조건 추가
														   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																						PLAN_GROUP_ID
																					ELSE @plan_group_id
																					END
														   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI' -- 2017-11-16 조건 추가
														   AND SLV.SEGMENT1   = H.INSTANCE_ID  -- 2017-11-16 조건 추가
                          							  ) plans
                   								where master_id = plans.instance_id
                   								and  w.plan_id = plans.basis_plan_id
--												and  after_site_id = plans.FACTORY_ID  --2017-11-06 PIYONG DELDE
												--2017-11-06 PIYONG 조회 조건 변경
												AND  PLANS.UI_TYPE = 'AMEND UI'  -- 2017-11-16 조건 추가
												-- FP_AMEND_PRODUCTION_PLAN_R 테이블에 PLAN_GROUP_ID컬럼이 없기 때문에  FACTORY 기준 또는 PLAN GROUP기준으로 조회한다.
												AND   EXISTS (SELECT 1 
																FROM   SCM_LINE_M   SLM WITH(NOLOCK)
																WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID
																AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID
																AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID
																AND    ( SLM.FACTORY_ID = plans.FACTORY_ID
																		OR SLM.MODEL_TYPE = plans.PLAN_GROUP_ID)) -- 해당 라인이 배포에 참여했는 지 검증한다.
                   								and  plans.nums = 1
												AND  W.AFTER_IN_QTY > 0 -- 2018-05-17 kimcd 사업부 이동 생산에 대비하여 0보다 큰 수량만 취함
												--   and w.item_id = 'APCCA0544A'
												and  (
														(	
															@factory_id IS NOT NULL AND AFTER_PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
																												   FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																												  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
																												    AND SLV.ACTIVE_FLAG = 'Y'
																													AND SLV.SEGMENT1 = plans.INSTANCE_ID
																													AND SLV.SEGMENT2 = W.AFTER_SITE_ID), convert(datetime,plans.instance_date) ) -- 2017-07-31 KIMCD add lookup date  -- 2017-11-16 PIYONG  PLAN FACTORY ID에서 W.AFTER_SITE_ID로 변경
														-- 2018-02-07 PIYONG  ADD 시작
														)OR( 
															@plan_group_id IS NOT NULL AND  AFTER_PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
																													   FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																													  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
																													    AND SLV.ACTIVE_FLAG = 'Y'
																													    AND SLV.SEGMENT1 = plans.INSTANCE_ID
																													    AND SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )
														  )
														 -- 2018-02-07 PIYONG  ADD 끝
													  )
												and  not exists (
															  select 1
															  from   FP_INSTANCE_CONFIG_M k
															  where  k.instance_id = w.master_id
															  AND    k.CATEGORY_ID  = 'PLAN_CATEGORY'
															  AND    k.KEY_ID       = 'CELL_HARD_PEGGING'
															  AND    k.KEY_VALUE    = 'Y'                                  
															) -- 2017-07-31 KIMCD ADD
                   								group by after_site_id, after_operation_id, ITEM_ID, after_plan_date
												-- 2017-11-16 PIYONG  PSI Amend용 조회 문장 추가 시작
												UNION ALL
												SELECT 'AMEND' AS GROUPS, MAX(W.PLANT_ID) AS PLANT_ID
														,W.FACTORY_ID AS FACTORY_ID, W.OPERATION_ID, W.ITEM_ID, PLAN_DATE MAKE_DATE , CEILING(SUM(OUT_QTY)) MAKE_QTY  /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/
												   FROM [DBO].[FP_AMEND_PLAN_R] W WITH(NOLOCK)
														,(SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
																 ,PLAN_GROUP_ID																				--2017-11-06 PIYONG ADD
																 , SLV.ATTRIBUTE1 AS UI_TYPE							   -- 2017-11-16 PIYONG UI_TYPE 추가
                                   								 , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) nums	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
                           								    FROM [DBO].FP_RELEASE_PLAN_INFO_H H  WITH(NOLOCK)
																 , SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK) -- 2017-11-16 PIYONG TABLE 추가 
                           								   WHERE INSTANCE_ID = @instance_id 
														     AND INSTANCE_DATE = @instance_date
														     AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																						FACTORY_ID
																				   ELSE
																						@factory_id
																				    END
														     AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																						PLAN_GROUP_ID
																					  ELSE
																						@plan_group_id
																					   END
														     AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI' -- 2017-11-16 조건 추가
														     AND SLV.SEGMENT1   = H.INSTANCE_ID  -- 2017-11-16 조건 추가
														   )  plans
													 WHERE W.INSTANCE_ID = PLANS.INSTANCE_ID
													   AND W.FP_PLAN_ID  = PLANS.BASIS_PLAN_ID
													   AND PLANS.UI_TYPE = 'PSI AMEND UI'
													   AND EXISTS (SELECT 1 
																	 FROM SCM_LINE_M   SLM WITH(NOLOCK)
																	WHERE SLM.FACTORY_ID   = W.FACTORY_ID
																	  AND SLM.LINE_ID      = W.LINE_ID
																	  AND SLM.OPERATION_ID = W.OPERATION_ID
																	  AND ( SLM.FACTORY_ID = PLANS.FACTORY_ID OR SLM.MODEL_TYPE = PLANS.PLAN_GROUP_ID)
																	  AND SLM.OPERATION_ID != 'A6000' 
																	UNION ALL
																	SELECT 1 
																	FROM   SCM_LINE_M   SLM WITH(NOLOCK)
																	WHERE  SLM.FACTORY_ID   = W.FACTORY_ID
																	AND    SLM.LINE_ID      = W.LINE_ID
																	AND    SLM.OPERATION_ID = W.OPERATION_ID
																	AND    SLM.OPERATION_ID = 'A6000')  -- 2020-12-26 kimcd Plan Group 배포에서 A6000 공정은 Plan Group 기반으로 라인 관리 안 되어 조건에서 예외 처리
													   AND PLANS.NUMS = 1
													   AND  W.IN_QTY > 0 -- 2018-05-17 kimcd 사업부 이동 생산에 대비하여 0보다 큰 수량만 취함
													   AND (
																(	
																	@FACTORY_ID IS NOT NULL AND PLAN_DATE <= DATEADD(DD,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
																														   FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																														  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
																															AND SLV.ACTIVE_FLAG = 'Y'
																															AND SLV.SEGMENT1 = PLANS.INSTANCE_ID
																															AND SLV.SEGMENT2 = W.FACTORY_ID), CONVERT(DATETIME,PLANS.INSTANCE_DATE) ) -- 2017-11-16 PIYONG  PLAN FACTORY ID에서 W.AFTER_SITE_ID로 변경
																-- 2018-02-07 PIYONG  ADD 시작
																)OR( 
																	@PLAN_GROUP_ID IS NOT NULL AND  PLAN_DATE <= DATEADD(DD,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
																															   FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																															  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
																																AND SLV.ACTIVE_FLAG = 'Y'
																																AND SLV.SEGMENT1 = PLANS.INSTANCE_ID
																																AND SLV.SEGMENT2 = PLANS.PLAN_GROUP_ID), CONVERT(DATETIME,PLANS.INSTANCE_DATE) )
																  )
																-- 2018-02-07 PIYONG  ADD 끝
														   )
													 GROUP BY W.FACTORY_ID, OPERATION_ID, ITEM_ID, PLAN_DATE, PLANS.PLAN_ID
													-- 2017-11-16 PIYONG PSI Amend용 조회 문장 추가 끝
               									UNION ALL
                    									-- RELEASE  INFERCAGE  
                   								SELECT  'RELEASE', ( select f.plant_id from dbo.scm_factory_m f where f.factory_id = w.FACTORY_ID ) as PLANT_ID
                           								, W.FACTORY_ID , W.OPERATION_ID , W.ITEM_ID , CONVERT(VARCHAR, W.PLAN_DATE,112) AS PLAN_DATE , CEILING(sum(PLAN_QTY)) make_qty /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/  --, W.PLAN_QTY , W.PLAN_IN_QTY  
                   								FROM    dbo.FP_RELEASE_FIX_PLAN_H  W   
                         								,(
                          								SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
                                   								, row_number() over ( partition by INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID order by insert_time desc ) nums	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
                          								  FROM [DBO].FP_RELEASE_PLAN_INFO_H H  WITH(NOLOCK)
                           								 WHERE INSTANCE_ID = @instance_id
														   AND INSTANCE_DATE = @instance_date
														   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																					FACTORY_ID 
																				 ELSE @factory_id
																				  END
														  -- 2017-11-06 PIYONG  조회 조건 추가
														  AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																						PLAN_GROUP_ID
																				   ELSE @plan_group_id
																					END
                          								) plans
                   								where W.INSTANCE_ID   = plans.instance_id
                   								and  w.AMEND_PLAN_ID  = plans.basis_plan_id
--                   								and  W.FACTORY_ID     = plans.FACTORY_ID		--2017-11-06 PIYONG DELETE (FP_RELEASE_FIX_PLAN_H에 FACTORY_ID 값이 '-' 없어 조건 제거
												and  w.RELEASE_PLAN_ID = plans.PLAN_ID									  --PIYONG	2017-07-14 추가
                   								and  plans.nums = 1       
                   								--and  plan_date <= dateadd(dd,7, convert(datetime,plans.instance_date) )   -- 대상 날짜..  일주일치만 check. -- 2017-07-31 KIMCD block
                   								group by W.FACTORY_ID, W.operation_id, W.ITEM_ID, W.plan_date          
               									UNION ALL        
    												select 'PLAN_EQUIPMENT_R',  a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112) , sum( a.plan_qty)  /* 2018-12-18 kimcd in에서 out 컬럼으로 수정*/
     													from [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_R] a  WITH(NOLOCK)
      													,(
	      													SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
        																, row_number() over ( partition by instance_id, instance_date, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID order by insert_time desc ) nums	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
      														  FROM [DBO].FP_RELEASE_PLAN_INFO_H H  WITH(NOLOCK)
      														 WHERE INSTANCE_ID = @instance_id
															   AND INSTANCE_DATE = @instance_date
														       AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																						FACTORY_ID
																					 ELSE @factory_id
																					  END
																-- 2017-11-06 PIYONG  조회 조건 추가
															   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																							PLAN_GROUP_ID
																					    ELSE @plan_group_id
																					     END
      													) plans
    													where a.FP_PLAN_ID = plans.plan_id
     													--and  plan_date <= dateadd(dd,7, convert(datetime,plans.instance_date) )   -- 대상 날짜..  일주일치만 check. block -- 2017-07-31 KIMCD block
														and  FIX_TYPE   IN ('F','N')  -- 2017-07-31 KIMCD add
     													and  ORDER_TYPE IN ('W')
														and  plans.nums = 1     
    												group by a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112)
             							  ) a
           								group by plant_id, factory_id, OPERATION_ID, item_id, make_date
  							  -- having SUM(case when groups = 'AMEND' then make_qty else 0 end ) <> SUM(case when groups = 'RELEASE' then make_qty else 0 end )
  							  --    or SUM(case when groups = 'AMEND' then make_qty else 0 end ) <> SUM(case when groups = 'MES' then make_qty else 0 end )
      							   ) Z
							WHERE 1=1
							ORDER BY OPERATION_ID , ITEM_ID, MAKE_DATE
							 FOR   XML RAW('tr'), ELEMENTS
							)
/*
       SET @TABLE_HEAD_CONTENT2 = (
									select 'WORK_ORDER_ID' as td ,'THIS_RELEASE' as td ,'LAST_RELEASE' as td ,'THIS_FACTORY_ID' as td ,'THIS_RELEASE_START' as td 
									    ,'THIS_RELEASE_END' as td ,'THIS_RELEASE_IN_QTY' as td ,'THIS_RELEASE_QTY' as td
									    ,'LAST_FACTORY_ID' as td,'LAST_RELEASE_START' as td ,'LAST_RELEASE_END' as td ,'LAST_RELEASE_IN_QTY' as td ,'LAST_RELEASE_QTY' as td
									 FOR   XML RAW('tr'), ELEMENTS
	                             )

       SET @TABLE_CONTENTS2 = (
									select td = all_wo.work_order_id, td = SUM( case when type = 'THIS' then 1 else 0 end ) , td = sum( case when type = 'LAST' then 1 else 0 end)
										  ,td = max(FACTORY_ID) ,td = max(start_time) , td = max(end_time) , td = max(plan_in_qty) , td = max(plan_qty) 
										  ,td = max(last_factory_id) , td = max(LAST_START), td = max(LAST_END) , td = max(LAST_IN_QTY) , td = max(LAST_QTY) 
									  from (
											 select 'THIS' type, a.work_order_id as work_order_id,   a.PLAN_DATE, a.start_time, a.end_time, plan_in_qty, plan_qty, a.FACTORY_ID
												   ,  '' as LAST_START , '' as LAST_END, 0 as LAST_IN_QTY, 0  as LAST_QTY, '' as last_factory_id
											   from [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] a
												   ,(
      													SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
        														   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) nums	--2017-11-10 PIYONG PARTITION BY A.PLAN_GROUP_ID ADD
      													  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
      													 WHERE INSTANCE_ID = @instance_id
														   AND INSTANCE_DATE = @instance_date
														   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																					FACTORY_ID
																				 ELSE @factory_id
																				  END
														  -- 2017-11-06 PIYONG  조회 조건 추가
														  AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																						PLAN_GROUP_ID
																				   ELSE @plan_group_id
																					END
													) b
											 where a.FP_PLAN_ID = b.plan_id
--											   and a.FACTORY_ID = b.FACTORY_ID	--2017-11-06 PIYONG DELETE SY_XIF_ERP_PRODUCTION_PLAN_S에 FACTORY_ID 값이 '-' 없어 조건 제거
											   and b.nums = 1
											UNION ALL
											 select 'LAST' type, c.work_order_id as work_order_id, '' as PLAN_DATE,  '' as start_time, '' as end_time, 0 as plan_in_qty, 0 as plan_qty, '' as factory_id
												   ,  c.start_time as LAST_START , c.end_time as LAST_END, c.plan_in_qty as LAST_IN_QTY, c.plan_qty  as LAST_QTY, c.FACTORY_ID as last_factory_id
											   from [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] c
												   ,(
      													SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, RELEASE_PLAN_ID plan_id, AMEND_PLAN_ID basis_plan_id
        														   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) nums	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
      													  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
														  WHERE INSTANCE_ID = @instance_id
														    AND INSTANCE_DATE < @instance_date 
															AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN 
																					FACTORY_ID 
																				   ELSE
																					@factory_id 
																					END
															-- 2017-11-06 PIYONG  조회 조건 추가
															AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																						PLAN_GROUP_ID
																					 ELSE
																						@plan_group_id
																					 END
													) b
											 where c.FP_PLAN_ID = b.plan_id
--											   and c.FACTORY_ID = b.FACTORY_ID		--2017-11-06 PIYONG DELETE SY_XIF_ERP_PRODUCTION_PLAN_S에 FACTORY_ID 값이 '-' 없어 조건 제거
											   and b.nums = 1
											   and c.plan_in_qty <> 0 

										  ) all_wo
									group by all_wo.work_order_id
									order by max(FACTORY_ID), max(start_time)
								     FOR   XML RAW('tr'), ELEMENTS
	                           )
*/
	--PIYONG 2017-09-29  PEGGING 누락 체크 추가
	 SET @TABLE_HEAD_CONTENT3 = (
									SELECT 'FP_PLAN_ID' AS td 
											,'PLANT_ID' AS td
											,'FACTORY_ID' AS td
											,'OPERATION_ID' AS td
											,'WORK_ORDER_ID' AS td
											,'PLAN_DATE' AS td
											,'PARENT_ITEM_ID' AS td
											,'LINE_ID' AS td
											,'PLAN_QTY' AS td
											,'PLAN_IN_QTY' AS td
											,'CHILD_ITEM_ID' AS td
											,'CHILD_ASSIGN_LINE_ID' AS td 
											,'CHILD_ASSIGN_PRIORITY' AS td
											,'CHILD_ASSIGN_EXCEPT' AS td
									    FOR XML RAW('tr'), ELEMENTS
	                             )
	--PIYONG 2017-09-29  PEGGING 누락 체크 추가
       SET @TABLE_CONTENTS3 = ( SELECT td = FP_PLAN_ID,    td = PLANT_ID,    td = FACTORY_ID,     td = OPERATION_ID,
									  td = WORK_ORDER_ID, td = PLAN_DATE,   td = PARENT_ITEM_ID, td = LINE_ID,
									  td = PLAN_QTY,      td = PLAN_IN_QTY, td = CHILD_ITEM_ID,  td = CHILD_ASSIGN_LINE_ID,
									  td = CHILD_ASSIGN_PRIORITY, td = CHILD_ASSIGN_EXCEPT
							    FROM (SELECT FP_PLAN_ID
											 ,PLANT_ID
											 ,FACTORY_ID
											 ,OPERATION_ID
											 ,WORK_ORDER_ID
											 ,CONVERT(nvarchar(10), PLAN_DATE, 120 ) AS PLAN_DATE
											 ,PARENT_ITEM_ID
											 ,LINE_ID
											 ,CAST(PLAN_QTY AS INT) AS PLAN_QTY
											 ,CAST(PLAN_IN_QTY AS INT) AS PLAN_IN_QTY
											 ,CHILD_ITEM_ID 
											 ,LINE_ID AS CHILD_ASSIGN_LINE_ID
											 ,ISNULL( (SELECT PRIORITY
														 FROM SCM_ITEM_LINE_ASSIGN_M  WITH(NOLOCK)
														WHERE ITEM_ID = CHILD_ITEM_ID
														  AND PLANT_ID = PLANT_ID
														  AND FACTORY_ID = FACTORY_ID
														  AND LINE_ID    = A.LINE_ID
														  AND MONTH = CONVERT(VARCHAR(6),A.PLAN_DATE, 112)
														  AND ACTIVE_FLAG = 'Y')
																											, '') AS CHILD_ASSIGN_PRIORITY
											 ,CASE WHEN (
														 SELECT PRIORITY
														   FROM [dbo].[SCM_ITEM_LINE_ASSIGN_EXCEPT_M]  WITH(NOLOCK)
														  WHERE PLANT_ID   =  A.PLANT_ID
														    AND FACTORY_ID = A.FACTORY_ID
														    AND ITEM_ID    = A.CHILD_ITEM_ID
														    AND LINE_ID    = A.LINE_ID
														    AND START_TIME <= A.PLAN_DATE
														    AND END_TIME   > A.PLAN_DATE
														    AND ACTIVE_FLAG = 'N') IS NULL THEN 'N' ELSE 'Y'END AS CHILD_ASSIGN_EXCEPT
									   FROM (
											SELECT A.COMPANY_ID
												   ,A.DIVISION_ID
												   ,A.SITE_ID
												   ,A.PLANT_ID
												   ,A.FACTORY_ID
												   ,A.OPERATION_ID
												   ,A.WORK_ORDER_ID
												   ,PLAN_DATE
												   ,A.FP_PLAN_ID
												   ,A.LINE_ID
												   ,A.PLAN_QTY
												   ,A.PLAN_IN_QTY
												   ,PARENT_ITEM_ID
												   ,CHILD_ITEM_ID
												   ,CASE WHEN A.ALT_ID IS NULL THEN 1 
														 ELSE ROW_NUMBER() OVER ( PARTITION BY A.PARENT_ITEM_ID, A.WORK_ORDER_ID, A.ALT_ID ORDER BY I.LINE_ID DESC, A.ALT_PRIORITY, A.CHILD_ITEM_ID) END AS ORD_PRIORITY
											  FROM (
													SELECT A.COMPANY_ID
															, A.DIVISION_ID
															, A.SITE_ID
															, A.PLANT_ID
															, A.FACTORY_ID
															, A.OPERATION_ID
															, A.PLAN_DATE
															, A.FP_PLAN_ID
															, A.WORK_ORDER_ID
															, A.PLAN_QTY
															, A.PLAN_IN_QTY
															, A.LINE_ID 
															, B.PARENT_ITEM_ID
															, B.CHILD_ITEM_ID
															, B.ALT_ID
															, B.ALT_PRIORITY
													   FROM DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R A WITH(NOLOCK)
														    ,DBO.SCM_BOM_M B WITH(NOLOCK)
														    ,DBO.SCM_FP_PLAN_DETAIL_H C WITH(NOLOCK)
													  WHERE 1=1
													   AND B.PARENT_ITEM_ID = A.ITEM_ID 
													   AND B.PLANT_ID = A.PLANT_ID 
													   AND CHILD_ITEM_ID LIKE 'ASL%' 
													   AND EFF_START_DATE <= A.START_TIME	-- 2018-12-03 PIYONG BOM 적용일자로 변경 GETDATE() -> A.START_TIME
													   AND EFF_END_DATE > A.START_TIME		-- 2018-12-03 PIYONG BOM 적용일자로 변경 GETDATE() -> A.START_TIME
													   AND B.ACTIVE_FLAG = 'Y'				-- 2019-05-15 PIYONG ADD
													   AND A.FP_PLAN_ID   = C.RELEASE_PLAN_ID
													   AND C.RELEASE_FLAG = 'Y'
   													   AND C.INSTANCE_ID  = @instance_id
													   AND C.PLAN_DATE    = @instance_date
													   AND C.RELEASE_PLAN_ID = (
																			--  2017-11-06  PIYONG 최종 릴리즈 찾기 시작
																			-------------------------------------------------------------
																			 SELECT RELEASE_PLAN_ID
																			   FROM (
																					  SELECT RELEASE_PLAN_ID
																							 , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS	--2017-11-10 PIYONG PARTITION BY PLAN_GROUP_ID ADD
																						FROM [DBO].FP_RELEASE_PLAN_INFO_H
																					   WHERE INSTANCE_ID = @instance_id
																						 AND INSTANCE_DATE = @instance_date
																						 AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																												  FACTORY_ID
																											   ELSE @factory_id
																											    END
																						 AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																													   PLAN_GROUP_ID
																												  ELSE
																													   @plan_group_id
																												    END
																				   ) A
																				WHERE NUMS = 1
																				
																			-------------------------------------------------------------
																			--  2017-11-06  PIYONG 최종 릴리즈 찾기 끝
																				)
													   AND ORDER_TYPE = 'W'
													   AND PLAN_IN_QTY > 0.0
													   AND OPERATION_ID IN ( 'E2000', 'S2000')
												   ) A
											  LEFT OUTER JOIN  DBO.SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)
													  ON A.PLANT_ID =  I.PLANT_ID
													 AND A.FACTORY_ID  = I.FACTORY_ID
													 AND A.CHILD_ITEM_ID = I.ITEM_ID
													 AND A.LINE_ID = I.LINE_ID
													 AND ACTIVE_FLAG = 'Y'
													 AND MONTH = CONVERT(VARCHAR(6),A.PLAN_DATE, 112)
													 AND I.PRIORITY != '9'
													 AND NOT EXISTS  (
																	  SELECT 1
																	    FROM [dbo].[SCM_ITEM_LINE_ASSIGN_EXCEPT_M]  WITH(NOLOCK)
																	   WHERE PLANT_ID =  A.PLANT_ID
																		 AND FACTORY_ID  = A.FACTORY_ID
																		 AND ITEM_ID = A.CHILD_ITEM_ID
																		 AND OPERATION_ID = I.OPERATION_ID
																		 AND LINE_ID = I.LINE_ID
																		 AND START_TIME <= A.PLAN_DATE
																		 AND END_TIME >= A.PLAN_DATE								-- 2019-03-18 PIYONG CHANGE > -> >= 당일 포함
																		 AND ( ACTIVE_FLAG = 'N' OR PRIORITY = 0 OR PRIORITY = 9 )	-- 2019-03-18 PIYONG ADD
																	)
											) A
									  WHERE ORD_PRIORITY = 1
										AND NOT EXISTS (
														SELECT 1
														  FROM DBO.FP_ORDER_PEGGING_R B  WITH(NOLOCK)
														 WHERE B.FP_PLAN_ID       = A.FP_PLAN_ID
														   AND B.TO_WORK_ORDER_ID = A.WORK_ORDER_ID
														   AND B.FROM_ITEM_ID     = A.CHILD_ITEM_ID
													   )         								

														
      							     ) Z
							   WHERE 1=1
							   ORDER BY OPERATION_ID , PARENT_ITEM_ID, PLAN_DATE
							 FOR   XML RAW('tr'), ELEMENTS
							)


    SET @TABLE_BODY = '  	<html>
								<head>
								<title>Untitled Document</title>
								<style>
   									* {margin:0;padding:0;}
   									body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   									table {border-collapse:collapse;width:100%;}
   									table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   									table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   									table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;}
   									table tbody td {text-align:left;padding:6px 8px;}
   									table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;}
                                    .hori-table table thead td {text-align:center;padding:3px;}  
   									.hori-table table tbody td {text-align:center;padding:3px;}
   									.vertical-table, .hori-table {margin-bottom:20px;}
								</style>
								</head>
								<body>' +
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') + 'Report generated on : ' + CONVERT(VARCHAR(10), GETDATE(), 120) + '
   									<br>
   									<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-top:2px solid #c8294b; max-width:1020px;''>
               									<thead>' +
                   									@TABLE_HEAD_CONTENT + 
               									'</thead>
               									<tbody>' +
               									ISNULL(@TABLE_CONTENTS, '') + '
               									</tbody>
											</table>'/*		+'
           									<table style=''border-top:2px solid #c8294b; max-width:1020px;''>
               									<thead>' +
                   									@TABLE_HEAD_CONTENT2 + 
               									'</thead>
               									<tbody>' +
               									ISNULL(@TABLE_CONTENTS2, '') + '
               									</tbody>
           									</table>'*/		+'
           									<table style=''border-top:2px solid #c8294b; max-width:1020px;''>
               									<thead>' +
                   									@TABLE_HEAD_CONTENT3 + 
               									'</thead>
               									<tbody>' +
               									ISNULL(@TABLE_CONTENTS3, '') + '
               									</tbody>
           									</table>
       									</div>
   									</div>
								</body>
								</html>'

						SET @MAIL_RECEIVER_LIST = 'kimcd@lgespartner.com;chkim.68@lgespartner.com'

	                     exec  msdb.dbo.sp_send_dbmail
							  @profile_name           = 'FP_MAIL_TEST'
							, @recipients             = @MAIL_RECEIVER_LIST
							, @query_result_separator = ';'
							, @subject                = @MAIL_TITLE
							, @body                   = @TABLE_BODY
							, @body_format            = 'html'
							/*
							, @query                  = @S_QUERY
                            , @attach_query_result_as_file = 1
							, @exclude_query_output   = 1
							, @query_result_no_padding= 1
							, @query_result_header    = 1
							, @query_attachment_filename = 'WO_GAP_CHECK.csv'
							*/
      

      
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


--CREATE PROCEDURE [dbo].[PR_XIF_MMD_ALL_R]
CREATE PROCEDURE [dbo].[PR_XIF_MMD_ALL_R_20240320]
-- ================================================================================================
-- Program ID          : FP00080 공정  수신
--                       FP00110 Line 정보 전환
--                       FP00140 호기 전환
--                       FP00340 V/D Recipe를 Tact Time에 반영
--                       FP02260 MMD half slitting 비율 수신(SCM_CO_PRODUCT_M)
--                       FP02390 PROCESSSEGMENT 수신정보 전환(SCM_OPERATION_M)
--                       FP02450 MMD의 Model3자리 컬럼 수신
--                       FP02470 MMD의 loss type 수신
--
-- Program Name        : PR_XIF_MMD_ALL_R
-- Param               :
-- Batch Period        : 20 minutes
-- Description         : GET MMD data from MMD
--
-- Source System       : MMD
-- Destination System  : FP SDB
-- Source Table        : XIF_MMD_BAS_ITEM_DATA_R
-- Destination Table   : SCM_OPERATION_M
--                       SCM_MMD_LINE_M
--                       SCM_EQUIPMENT_M
--                       SCM_OPERATION_FLOW_M
--                       SCM_CO_PRODUCT_M
--                       SCM_ITEM_M
--                       SCM_LINE_M
--                       XIF_MMD_BAS_ITEM_DATA_S
--                       SCM_MMD_OPERATION_M
--                       SCM_MMD_OPERATION_UNIT_M -- 2022-08-27 leeseongmin [CSR: C20220826-000120] 신규테이블
--                       SCM_MMD_FORM_ROUT
--                       SCM_MMD_FORM_ROUT_PROC
--                       SCM_MMD_FORM_ROUT_PROC_RECIPE
--
-- Create(Update) Date : 2022.07.12
-- Author              : kim choon dong
-- Version             : 2.4
--                       2017-01-26			AREA 항목 추가
--						 2017-04-30			PROCESSEQUIPMENT DISABLE 로직 수정. EQUIPMENT가 삭제되는 오류 방지
--                       2017-05-19			EQUIPMENT에서 FP_LINE과 MES_LINE 값이 같은 경우 FP_LINE도 갱신
--											MES에서 라인 변경된 경우 대비.. FP-049
--                       2017-05-24			FP-058
--											EQUIPMENT 수신에서 BAS_ATTR45(COATER_EQPT_TYPE_CODE) 컬럼 추가
--											Coater 설비의 양면, 단면 구분
--                       2017-08-02 kimcd	Route 수신에서 기존 Route Path의 양산 Route 구분값 복사
--                       2017-08-18 kimcd	'TB_MMD_SHOP_PRDT_ROUT' 수신에서 활성화 ROUTE 구분함.
--											활성화 Route의 경우 Cell-Cell 정보인 경우만 수신하도록 함. 
--                       2017-09-02 kimcd	EM010103 cell 위에 cell 존재하는 경우 조립 route skip로직 추가
--                       2017-09-28 kimcd	nick name이 null인 경우 null로 갱신 단. 선분산 제외
--											설비의 라인이 변경된 경우 mes line을 갱신한다. - 새로 insert 하지 않음.
--											Route 수신에서 active N인 것이 존재함. N인 경우 정보 삭제하자
--                       2017-11-08 kimcd	설비 수신에서 층 정보 추가.F6000 공정 강제 복사 과정 추가. LINE 명 수정
--                       2017-11-17 kimcd	남경 소형 조립 A6000 제거
--                       2017-12-04 kimcd	MES Line Name 수신. Equipment에 Location 중복 경우 처리 보완
--                       2017-12-09 kimcd	남경 소형 활성화 후 공정 Cell 조립 Route skip 로직 보완
--                       2017-12-15 kimcd	활성화 후 공정 Route를 MMD에서 수신 불가능하여 Item Class 관리로 hard coding
--                       2017-12-26 kimcd	활성화 후 공정 Route 점검을 양산 Route 아닌 것도 포함되도록 조건 변경
--                       2017-12-27 kimcd	location 갱신에서 main 설비 기준으로만 갱신하도록 조건 추가
--                       2017-12-30 kimcd	라인의 설비 중 첫 설비의 location 기준으로 라인 location 설정
--                       2018-02-02 kimcd	층 구분하여 계획 수립하는 G182를 제외하고 층 정보 제거함
--                       2018-06-08 kimcd	F7200(Taping) 2D 모델, F7300(Side Taping) 일반 모델 공정 구분하기 위해 HARD CODING
--                       2018-07-11 kimcd	PROCESSEQUIPMENTSEGMENT - SCM LINE M에 창고 정보 추가
--											TB_MMD_SHIPTO_PACK_COND_MOBILE, TB_MMD_SHIPTO_PACK_COND_AUTO 활성화 공정에서 Pack 이동 단위 관리
--											소형 특성 공정용 Formation Route 설정 로직 추가
--                       2018-08-15 kimcd	활성화 공정 Route 수신에서 FRT005는 예외 처리 - 갱신되면 안됨
--                       2018-09-26 kimcd	소형 활성화 lot size 오류 처리
--                       2018-10-02 kimcd	활성화 후 공정에서 DSF는 degas(F4000)만 설정되도록 보완
--											수작업 특성(F5600)의 경우 값 유지
--                       2018-12-03 kimcd	선분산 pre wetting 공정용 품목 코드 E0500 공정 추가
--                       2019-01-07 kimcd	라인별 창고 수신에서 처리 오류 제거
--                       2019-02-15 kimcd	MES 사용자 정보 수신 - PC User 권한 추가용
--                       2019-03-12 kimcd	재료 사업본부 추가에 따른 재조정
--                       2019-03-15 kimcd	목표 수율 수신
--                       2019-03-21 kimcd	목표 수율에서 비정상 수치 제거
--                       2019-04-01 kimcd	수율 수치 기준으로 100 나누는 로직 분기
--                       2019-04-05 kimcd	BOM 전개하여 하위 구성품 찾는 로직 추가
--                       2019-08-01 kimcd	A5000A6000이 A5000 operation flow가 공장동별 설비에 따라 구분되어 사용됨.
--											MMD에서는 Option 형태로 등록됨. MMD 정보 수신하는 과정에서
--											각 법인별 Operation 사용 여부에 따라 품목에 설정되도록 수정
--                       2019-08-09 kimcd	GMES 공정 PC에 기본 Password 설정
--                       2019-08-29 kimcd	Formation Flow id 형성 lookup을 company 기준으로 변경 - G184, G664 구분용
--                       2019-09-25 kimcd	SCM_LINE_M에 창고 정보 추가 수신
--                       2020-01-10 kimcd	Product에 Pack 제품 그룹 명. 설비 수신에서 라인 없으면 Y로 변경. 
--											수율 수신에서 조립,활성화 공정만 미수신 유지
--											TB_MMD_SHIPTO 선적 도착지 정보 수신
--                       2020-01-16 kimcd	LOTTYPE 유형 추가 수신
--                       2020-01-21 kimcd	남경 원각 초소형의 활성화 Flow가 F5100 공정임. Route 형성 과정 수정
--                       2020-04-13 kimcd	ART006, ART008 하위 조립품의 공정에 따라 Tapping, Side Tapping 공정 달라지도록 ART008 조건 추가
--                       2020-06-26 kimcd	IF_RCV_DATE 조회추가. Operation_Group이 일반인 경우만 수신. Operation에도 갱신하도록 제한
--                       2020-09-23 kimcd	Route Path 형성에서 P5200 P5000 존재하는 경우 P5000은 제거하는 로직 추가
--											제품규격 #2(규격 및 공정제어) Pack 차수별 경과일수 수신
--                       2021-06-30 kimcd	BAS_ATTR80  Interface 시스템 명 MES SOURCE GROUP 수신 추가
--											라인 창고 수신에서 라인 직접 갱신하는 문장 추가
--                       2021-10-19 kimcd	활성화 세부 공정을 수신하기 위해 별도 MMD Operation Master 구성
--                       2021-10-23 kimcd	활성화 MES Tray(캐리어) 정보 추가
--                       2021-10-25 kimcd	PRODUCTPROCESSCONTROLSPEC(제품규격#2 (규격 및 공정제어) Pack)
--											TB_MMD_PRDT_2ND_OCV_VLTG(제품별 2ND OCV Voltage 관리)
--											2nd OCV 검사 Lead Time 로직 변경
--                       2021-11-01 kimcd	SCM_MMD_FORM_ROUT
--											SCM_MMD_FORM_ROUT_PROC
--											SCM_MMD_FORM_ROUT_PROC_RECIPE
--											MMD 활성화 라우트 정보 수신
--                       2022-01-18 kimcd	SCM_MMD_MCS_RACK_M - 적극 정권 보관 Capa 관리용
--											SCM_MMD_ELECTRODE_CERTI_GROUP_M 전극 후 공정 생산 가능 라인 관리용
--											SCM_MMD_ELECTRODE_CERTI_GROUP_EQPT_M 전극 후 공정 생산 가능 라인 관리용
--											정보 추가 수신
--                       2022-02-23 kimcd	SCM_MMD_PRDT_WH_RACK_M - MMD 기준 창고 RACK 연결 정보
--											SCM_MMD_PRDT_WH_M MMD 기준 창고 Master
--											정보 추가 수신
--                       2022-03-18 kimcd	가상 Division 로직 반영
--                       2022-05-27 kimcd	설비 정보에 MMD 기준 정보 보관 컬럼 추가
--                       2022-07-12 kimcd	scm_line_m mes_line_id, work_center_id 컬럼추가
--                       2022-08-27 leeseo	ngmin [CSR: C20220826-000120] MMD 기준 정보 추가 수신 (AGING 공정별시간)
--                       2023-01-20 kimcd	WA 법인 동별 Tray Simulation에 따라 Master 수신 작업 보완
--                       2023-05-15 FP Pjt. 'TB_MMD_FCS_CST_TYPE'에 'A6' 추가
--                       2023-06-23 FP Pjt. 활성화 공정 반제품 전환 / Cell Assy 일 경우 상위 Product 항목 제거
--                       2023-09-22 FP Pjt. TB_MMD_FCS_CST_TYPE에 'S3' 추가 (NJ 활성화 MES 전환 Pjt 요청)
--                       2023-11-01 FP Pjt. TB_MMD_FCS_CST_TYPE에 'A3' 추가 (NA 활성화 MES 전환 Pjt 요청)
--                       2023-12-01 FP Pjt. TB_MMD_FCS_CST_TYPE에 'MC' 추가 (오창2공장 MC동 증설)
--                       2024-01-01 FP Pjt. TB_MMD_FCS_CST_TYPE에 'A7' 추가
--                       2024-01-01 FP Pjt. TB_MMD_FCS_CST_TYPE에 'AF' 추가
--                       2024-04-01 SCP Pjt.TB_MMD_EQPT_PRDT_SPEED 추가
-- ================================================================================================
    @P_BAS_ITEM_ID  NVARCHAR(50)
AS
	DECLARE C_DATA  CURSOR FOR
        SELECT [IF_SEQ]
			  ,SUBSTRING(IF_ID,1,4)   AS IF_SOURCE  -- 2019-03-12 kimcd 재료 구분자
			  ,[IF_RCV_DATE]   -- 2020-06-26 kimcd IF_RCV_DATE 조회추가
		      ,[BAS_ITEM_ID]
              ,[DISTRB_TG_BAS_ITEM_NAME]
              ,[SRC_REPSTR_ID]
              ,[SRC_BAS_ITEM_ID]
              ,[SRC_KEY_SEQ_NO]
              ,[SRC_HIST_SEQ_NO]
              ,[BAS_KEY_ATTR1]
              ,[BAS_KEY_ATTR2]
              ,[BAS_KEY_ATTR3]
              ,[BAS_KEY_ATTR4]
              ,[BAS_KEY_ATTR5]
              ,[BAS_KEY_ATTR6]
              ,[BAS_KEY_ATTR7]
              ,[BAS_KEY_ATTR8]
              ,[BAS_KEY_ATTR9]
              ,[BAS_KEY_ATTR10]
              ,[BAS_ATTR1]
              ,[BAS_ATTR2]
              ,[BAS_ATTR3]
              ,[BAS_ATTR4]
              ,[BAS_ATTR5]
              ,[BAS_ATTR6]
              ,[BAS_ATTR7]
              ,[BAS_ATTR8]
              ,[BAS_ATTR9]
              ,[BAS_ATTR10]
              ,[BAS_ATTR11]
              ,[BAS_ATTR12]
              ,[BAS_ATTR13]
              ,[BAS_ATTR14]
              ,[BAS_ATTR15]
			  ,[BAS_ATTR16]
			  ,[BAS_ATTR17]  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
			  ,[BAS_ATTR18]  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
			  ,[BAS_ATTR19]
			  ,[BAS_ATTR20]
			  ,[BAS_ATTR21]
			  ,[BAS_ATTR22]
			  ,[BAS_ATTR23]
			  ,[BAS_ATTR24]
			  ,[BAS_ATTR25]
			  ,[BAS_ATTR26]
			  ,[BAS_ATTR27]
			  ,[BAS_ATTR28]
			  ,[BAS_ATTR29]
			  ,[BAS_ATTR31]
              ,[BAS_ATTR32]
              ,[BAS_ATTR33]
              ,[BAS_ATTR34]
              ,[BAS_ATTR35]
              ,[BAS_ATTR36]
              ,[BAS_ATTR37]
              ,[BAS_ATTR38]
              ,[BAS_ATTR39]
              ,[BAS_ATTR40]
              ,[BAS_ATTR41]
              ,[BAS_ATTR42]
              ,[BAS_ATTR43]
              ,[BAS_ATTR44]
              ,[BAS_ATTR45]
              ,[BAS_ATTR46]
              ,[BAS_ATTR47]
              ,[BAS_ATTR48]
              ,[BAS_ATTR49]
              ,[BAS_ATTR50]
			  ,[BAS_ATTR56]  -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
			  ,[BAS_ATTR57]  -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
			  ,[BAS_ATTR80]  -- 2021-06-30 kimcd Interface 시스템 명 MES SOURCE GROUP 수신 추가
              ,[BAS_ATTR_MSG]
              ,[USE_FLAG]
              ,[DEL_FLAG]
        FROM  [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] WITH(NOLOCK)
        WHERE ( @P_BAS_ITEM_ID IS NULL OR [BAS_ITEM_ID] = @P_BAS_ITEM_ID )
		AND   [BAS_ITEM_ID] != 'TB_MMD_SHOP_PRDT_ROUT'
		AND   IF_ID       = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 재료 사업본부 추가에 따른 조회 대상 제한
		AND   [PROC_FLAG] = 'P'
		ORDER BY [IF_RCV_DATE];

	DECLARE C_ITEM_OP_DATA  CURSOR FOR
        SELECT [IF_SEQ]
			  ,SUBSTRING(IF_ID,1,4)   AS IF_SOURCE  -- 2019-03-12 kimcd 재료 구분자
			  ,[IF_RCV_DATE]   -- 2020-06-26 kimcd IF_RCV_DATE 조회추가
		      ,[BAS_ITEM_ID]
              ,[DISTRB_TG_BAS_ITEM_NAME]
              ,[SRC_REPSTR_ID]
              ,[SRC_BAS_ITEM_ID]
              ,[SRC_KEY_SEQ_NO]
              ,[SRC_HIST_SEQ_NO]
              ,[BAS_KEY_ATTR1] -- [SHOPID] 플랜트아이디
              ,[BAS_KEY_ATTR2] -- [PRODID] 제품아이디
              ,[BAS_KEY_ATTR3] -- [ROUTID] 경로아이디
              ,[BAS_ATTR1]     -- [EQSGID] 설비세그먼트아이디
              ,[BAS_ATTR_MSG]
              ,[USE_FLAG]
              ,[DEL_FLAG]
			  ,( SELECT TOP 1 'Y'
			     FROM   DBO.SCM_MMD_ROUTEPATH_M  R
				 WHERE  R.[ROUTID]   = A.[BAS_KEY_ATTR3]
				 AND    R.[FLOWID]   = R.[FLOWID_TO]
				 -- AND    R.[FLOWNORM] = 'Y' 2017-12-26 kimcd block condiion - FRT005처럼 양산 ROUTE로 연결 안 되는 경우도 활성화 라우트로 포함.
				 AND    (R.[PROCID] LIKE 'F%' OR R.[PROCID_TO] LIKE 'F%') )  AS FORM_ROUTE -- kimcd 2017-08-18 add 활성화 Route 구분
        FROM  [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] A WITH(NOLOCK)
        WHERE ( @P_BAS_ITEM_ID IS NULL OR [BAS_ITEM_ID] = @P_BAS_ITEM_ID )
		AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
		AND   IF_ID       = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 재료 사업본부 추가에 따른 조회 대상 제한
		AND   [PROC_FLAG] = 'P'
		ORDER BY [IF_RCV_DATE];

    DECLARE @IF_SEQ                   NVARCHAR(50)
	DECLARE @IF_SOURCE                NVARCHAR(50)   -- 2019-03-12 kimcd 재료 구분자
	DECLARE @IF_RCV_DATE              DATETIME       -- 2020-06-26 kimcd IF_RCV_DATE 조회추가
    DECLARE @BAS_ITEM_ID              NVARCHAR(50)
	DECLARE @DISTRB_TG_BAS_ITEM_NAME  NVARCHAR(200)
	DECLARE @SRC_REPSTR_ID            NVARCHAR(50)
	DECLARE @SRC_BAS_ITEM_ID          NVARCHAR(50)
	DECLARE @SRC_KEY_SEQ_NO           NUMERIC(13,3)
	DECLARE @SRC_HIST_SEQ_NO          NUMERIC(13,3)
	DECLARE @BAS_KEY_ATTR1            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR2            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR3            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR4            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR5            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR6            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR7            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR8            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR9            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR10           NVARCHAR(100)
	DECLARE @BAS_ATTR1                NVARCHAR(2000)
	DECLARE @BAS_ATTR2                NVARCHAR(2000)
	DECLARE @BAS_ATTR3                NVARCHAR(2000)
	DECLARE @BAS_ATTR4                NVARCHAR(2000)
	DECLARE @BAS_ATTR5                NVARCHAR(2000)
	DECLARE @BAS_ATTR6                NVARCHAR(2000)
	DECLARE @BAS_ATTR7                NVARCHAR(2000)
	DECLARE @BAS_ATTR8                NVARCHAR(2000)
	DECLARE @BAS_ATTR9                NVARCHAR(2000)
	DECLARE @BAS_ATTR10               NVARCHAR(2000)
	DECLARE @BAS_ATTR11               NVARCHAR(2000)
	DECLARE @BAS_ATTR12               NVARCHAR(2000)
	DECLARE @BAS_ATTR13               NVARCHAR(2000)
	DECLARE @BAS_ATTR14               NVARCHAR(2000)
	DECLARE @BAS_ATTR15               NVARCHAR(2000)
	DECLARE @BAS_ATTR16               NVARCHAR(2000)
	DECLARE @BAS_ATTR17               NVARCHAR(2000)  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
	DECLARE @BAS_ATTR18               NVARCHAR(2000)  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
	DECLARE @BAS_ATTR19               NVARCHAR(2000)
	DECLARE @BAS_ATTR20               NVARCHAR(2000)
	DECLARE @BAS_ATTR21               NVARCHAR(2000)
	DECLARE @BAS_ATTR22               NVARCHAR(2000)
	DECLARE @BAS_ATTR23               NVARCHAR(2000)
	DECLARE @BAS_ATTR24               NVARCHAR(2000)
	DECLARE @BAS_ATTR25               NVARCHAR(2000)
	DECLARE @BAS_ATTR26               NVARCHAR(2000)
	DECLARE @BAS_ATTR27               NVARCHAR(2000)
	DECLARE @BAS_ATTR28               NVARCHAR(2000)
	DECLARE @BAS_ATTR29               NVARCHAR(2000)
	DECLARE @BAS_ATTR31               NVARCHAR(2000)
	DECLARE @BAS_ATTR32               NVARCHAR(2000)
	DECLARE @BAS_ATTR33               NVARCHAR(2000)
	DECLARE @BAS_ATTR34               NVARCHAR(2000)
	DECLARE @BAS_ATTR35               NVARCHAR(2000)
	DECLARE @BAS_ATTR36               NVARCHAR(2000)
	DECLARE @BAS_ATTR37               NVARCHAR(2000)
	DECLARE @BAS_ATTR38               NVARCHAR(2000)
	DECLARE @BAS_ATTR39               NVARCHAR(2000)
	DECLARE @BAS_ATTR40               NVARCHAR(2000)
	DECLARE @BAS_ATTR41               NVARCHAR(2000)
	DECLARE @BAS_ATTR42               NVARCHAR(2000)
	DECLARE @BAS_ATTR43               NVARCHAR(2000)
	DECLARE @BAS_ATTR44               NVARCHAR(2000)
	DECLARE @BAS_ATTR45               NVARCHAR(2000)
	DECLARE @BAS_ATTR46               NVARCHAR(2000)
	DECLARE @BAS_ATTR47               NVARCHAR(2000)
	DECLARE @BAS_ATTR48               NVARCHAR(2000)
	DECLARE @BAS_ATTR49               NVARCHAR(2000)
	DECLARE @BAS_ATTR50               NVARCHAR(2000)
	DECLARE @BAS_ATTR56               NVARCHAR(2000) -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
	DECLARE @BAS_ATTR57               NVARCHAR(2000) -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
	DECLARE @BAS_ATTR80               NVARCHAR(2000) -- 2021-06-30 kimcd Interface 시스템 명 MES SOURCE GROUP 수신 추가
	DECLARE @BAS_ATTR_MSG             NVARCHAR(4000)
	DECLARE @USE_FLAG                 NVARCHAR(1)
	DECLARE @DEL_FLAG                 NVARCHAR(1)
	DECLARE @LANG_TXT                 NVARCHAR(10) = 'en-US\'
	DECLARE @KR_LANG_TXT              NVARCHAR(10) = 'ko-KR\'

	DECLARE @COMPANY_ID               NVARCHAR(30)
	DECLARE @DIVISION_ID              NVARCHAR(30)
	DECLARE @SITE_ID                  NVARCHAR(30)
	DECLARE @PLANT_ID                 NVARCHAR(30)
	DECLARE @FACTORY_ID               NVARCHAR(30)
	DECLARE @LINE_ID                  NVARCHAR(30)
	DECLARE @EQUIPMENT_ID             NVARCHAR(150)
	DECLARE @ITEM_ID	              NVARCHAR(150)
	DECLARE @ADD_EXTRA                NVARCHAR(30)
	DECLARE @LOC_YN                   NVARCHAR(30)  -- 2018-02-02 kimcd add. equipment location(층) 수신 여부 관리

	DECLARE @CHECK_OP                 NVARCHAR(1)
    DECLARE @PROCESS_FLAG             NVARCHAR(1)
	DECLARE @OPERATION_ID             NVARCHAR(30)
	DECLARE @OPERATION_NAME           NVARCHAR(150)
	DECLARE @ERP_OPERATION_ID         NVARCHAR(30)
	DECLARE @OPERATION_GROUP_ID       NVARCHAR(1)
	DECLARE @OPERATION_GROUP_NAME     NVARCHAR(1)
	DECLARE @SHOP_GROUP_ID            NVARCHAR(1)
	DECLARE @SCM_LINE_CREATE          NVARCHAR(1)
	DECLARE @EQUIPMENT_NAME           NVARCHAR(150)
	DECLARE @WORK_CENTER_ID           NVARCHAR(30)
	DECLARE @EQUIPMENT_TYPE			  NVARCHAR(20)
	DECLARE @ELECTRODE_TYPE			  NVARCHAR(20)
	DECLARE @MES_LINE_ID              NVARCHAR(30)
	DECLARE @WO_FLAG                  NVARCHAR(1)
	DECLARE @MO_FLAG                  NVARCHAR(1)
	DECLARE @ACTIVE_FLAG              NVARCHAR(1)
	DECLARE @INSTANCE_TYPE            NVARCHAR(2)
	
	DECLARE @OPERATION_ID_CNT		  INT = 0;
	DECLARE @MMD_ROUTEPATH_CNT        INT = 0;
	DECLARE @PROC_MSG			      NVARCHAR(2000) = 'Success';
	
	DECLARE @ROUTEPATH_FLAG           NVARCHAR(1)
	DECLARE @ROUTID                   NVARCHAR(50)
	DECLARE @FLOWID_FOR_QUERY         NVARCHAR(50)
	DECLARE @FLOWID_TO                NVARCHAR(50)
	DECLARE @PROCID_TO                NVARCHAR(100)
	DECLARE @FLOWID                   NVARCHAR(50)
	DECLARE @PROCID                   NVARCHAR(100)
	DECLARE @NLEVEL                   NUMERIC(13,3)
	DECLARE @PATH                     NVARCHAR(2000)
	DECLARE @OP_TABLE table
            ( COMPANY_ID              NVARCHAR(30)
	        , DIVISION_ID             NVARCHAR(30)
	        , SITE_ID                 NVARCHAR(30)
	        , ROUTID                  NVARCHAR(50)
	        , FLOWID_TO               NVARCHAR(50)
	        , PROCID_TO               NVARCHAR(100)
	        , FLOWID                  NVARCHAR(50)
	        , PROCID                  NVARCHAR(100)
	        , NLEVEL                  NUMERIC(13,3)
	        )
    DECLARE @FLOW_ID                  NVARCHAR(150)
	DECLARE @I_COMPANY_ID             NVARCHAR(30)
	DECLARE @I_DIVISION_ID            NVARCHAR(30)
	DECLARE @I_SITE_ID                NVARCHAR(30)
	DECLARE @I_FLOWID_TO              NVARCHAR(50)
	DECLARE @I_PROCID_TO              NVARCHAR(100)
	DECLARE @I_FLOWID                 NVARCHAR(50)
	DECLARE @I_PROCID                 NVARCHAR(100)
	DECLARE @I_OPERATION_SEQ          NUMERIC(13,3)
	DECLARE @I_NLEVEL                 NUMERIC(13,3)
	DECLARE @LAST_FLOWID_TO           NVARCHAR(50)
	DECLARE @LAST_PROCID_TO           NVARCHAR(100)
	DECLARE @LAST_FLOWID              NVARCHAR(50)
	DECLARE @LAST_PROCID              NVARCHAR(100)
	DECLARE @CHECK_ROUTE_TYPE         NVARCHAR(20)
	DECLARE @MES_ERP_INTERFACE_FLAG   NVARCHAR(10)

	DECLARE @TOP_ITEM_ID			  NVARCHAR(150)
	DECLARE @PARENT_ITEM_ID			  NVARCHAR(150)
	DECLARE @CHILD_ITEM_ID			  NVARCHAR(150)
	DECLARE @PHANTOM				  NVARCHAR(150)
	DECLARE @MAKE_BUY                 NVARCHAR(10)
	DECLARE @LOOP_FLAG                NVARCHAR(10)
	DECLARE @LOOP_COUNT               INT
	DECLARE @MIN_LEVEL                NUMERIC(13,3)
	DECLARE @PATH_LEVEL               NUMERIC(13,3)
	DECLARE @HOLD_COMPANY_ID          NVARCHAR(30)
	DECLARE @HOLD_DIVISION_ID         NVARCHAR(30)
	DECLARE @HOLD_SITE_ID             NVARCHAR(30)
	DECLARE @R_OPERATION_GROUP_ID     NVARCHAR(1)
	DECLARE @FORM_ROUTE               NVARCHAR(1) -- kimcd 2017-08-18 add 활성화 Route 구분
	DECLARE @SKIP_ROUTE_FLAG          NVARCHAR(1) -- kimcd 2017-09-02 조립 Route 형성 예외 flag
	DECLARE @SECOND_TIME              NUMERIC(3)    -- 2020-09-23 kimcd 제품규격 #2(규격 및 공정제어) 수신하면서 추가 차수
	DECLARE @KEEP_DAYS                NVARCHAR(30)  -- 2020-09-23 kimcd 제품규격 #2(규격 및 공정제어) 수신하면서 추가 보관일자
	DECLARE @CONCATED_KEEP_DAYS       NVARCHAR(500) -- 2020-09-23 kimcd 제품규격 #2(규격 및 공정제어) 수신하면서 추가 연결된 보관일자
	

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

    -- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MMD_ALL_R'
	DECLARE @if_id_code  NVARCHAR(50)  = 'OFP0_OSC1_BAS_ITEM_DATA'
	DECLARE @send_if_seq NVARCHAR(50)
	DECLARE @send_date   NVARCHAR(50)
	DECLARE @if_seq_next BIGINT
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	DECLARE @MONTH_DATE  DATETIME     = DATEADD(D,-30, GETDATE()) -- 2020-06-26 kimcd IF_RCV_DATE 30일 이전 정보는 수신으로 정리용 기준 변수
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	DECLARE @site_s      INTEGER
	SET @send_date = 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

    BEGIN TRY

    SET @v_temp1 = 'STEP UPDATE [SCM_ITEM_M].[DESCRIPTION]'
	UPDATE I
	SET    [DESCRIPTION] = (SELECT TOP 1 M.BAS_KEY_ATTR2
							FROM   [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] M WITH(NOLOCK)
							WHERE  M.BAS_ITEM_ID = 'PRODUCT'
							AND    M.PROC_FLAG   = 'N'
							AND    M.BAS_KEY_ATTR2 IS NOT NULL
							AND    I.ITEM_ID     = M.BAS_KEY_ATTR1
							AND    M.IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 전지 제한
							ORDER  BY M.IF_SEQ DESC)
			,[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
			,[UPDATE_TIME] = GETDATE()
	FROM   [DBO].[SCM_ITEM_M] I
	WHERE  I.ITEM_ID IN ( SELECT M.BAS_KEY_ATTR1
							FROM   [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] M WITH(NOLOCK)
							WHERE  M.BAS_ITEM_ID = 'PRODUCT'
							AND    M.PROC_FLAG   = 'N'
							AND    M.BAS_KEY_ATTR2 IS NOT NULL
							AND    M.IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 전지 제한
							)
	-- 2022-03-18 전체 Division 조건 제거 AND    I.DIVISION_ID IN ('40','81','82') -- 2019-03-12 kimcd 전지 제한 소형 전지, 자동차 전지, ESS
	;

    SET @v_temp1 = 'STEP UPDATE [SCM_ITEM_M].[NICK_NAME]'
	UPDATE I
	SET    [NICK_NAME]   = (SELECT TOP 1 CASE WHEN ( I.[ITEM_ID] LIKE 'ASLPD%' OR I.[ITEM_ID] LIKE 'ASLPW%' ) THEN I.[NICK_NAME] ELSE M.BAS_ATTR31 END -- kimcd 2018-12-03 ASLPW 조건 추가. kimcd 2017-09-28  NICK이 NULL 값이 경우 NULL로 갱신
							FROM   [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] M WITH(NOLOCK)
							WHERE  M.BAS_ITEM_ID = 'PRODUCT'
							AND    M.PROC_FLAG   = 'N'
							-- AND    M.BAS_ATTR31 IS NOT NULL block kimcd 2017-09-28  NICK이 NULL 값이 경우 NULL로 갱신. 단 선분산은 제외. 선분산의 NICK NAME은 강제 설정한 값임.
							AND    I.ITEM_ID     = M.BAS_KEY_ATTR1
							AND    M.IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 전지 제한
							ORDER  BY M.IF_SEQ DESC)
			,[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
			,[UPDATE_TIME] = GETDATE()
	FROM   [DBO].[SCM_ITEM_M] I
	WHERE  I.ITEM_ID IN  ( SELECT  M.BAS_KEY_ATTR1
							FROM    [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] M WITH(NOLOCK)
							WHERE   M.BAS_ITEM_ID = 'PRODUCT'
							AND     M.PROC_FLAG   = 'N'
							-- AND     M.BAS_ATTR31 IS NOT NULL block kimcd 2017-09-28 
							AND     M.IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 전지 제한
							)
    -- 2022-03-18 전체 Division 조건 제거 AND    I.DIVISION_ID IN ('40','81','82') -- 2019-03-12 kimcd 전지 제한 소형 전지, 자동차 전지, ESS
	;
	-- 2020-01-10 kimcd Pack 제품 그룹 코드 추가 시작
    SET @v_temp1 = 'STEP UPDATE [SCM_ITEM_M].[PACK_PRODUCT_GROUP_CODE]'
	UPDATE I
	SET    [PACK_PRODUCT_GROUP_CODE]   = (  SELECT TOP 1 M.BAS_ATTR67
											FROM   [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] M WITH(NOLOCK)
											WHERE  M.BAS_ITEM_ID = 'PRODUCT'
											AND    M.PROC_FLAG   = 'N'
											AND    M.BAS_ATTR67 IS NOT NULL
											AND    I.ITEM_ID     = M.BAS_KEY_ATTR1
											AND    M.IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA'
											ORDER  BY M.IF_SEQ DESC)
			,[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
			,[UPDATE_TIME] = GETDATE()
	FROM   [DBO].[SCM_ITEM_M] I
	WHERE  I.ITEM_ID IN  ( SELECT  M.BAS_KEY_ATTR1
							FROM    [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] M WITH(NOLOCK)
							WHERE   M.BAS_ITEM_ID = 'PRODUCT'
							AND     M.PROC_FLAG   = 'N'
							AND     M.BAS_ATTR67 IS NOT NULL
							AND     M.IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA'
							)
    -- 2022-03-18 전체 Division 조건 제거 AND    I.DIVISION_ID IN ('40','81','82')
	;
	-- 2020-01-10 kimcd Pack 제품 그룹 코드 추가 끝

	SET @v_temp1 = 'STEP UPDATE PRODUCT XIF_MMD_BAS_ITEM_DATA_R'
	UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
	SET    proc_flag = 'Y'
			,[UPDDTTM] = GETDATE()
	WHERE  proc_flag = 'N'
	AND    bas_item_id = 'PRODUCT'
	AND    IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA';  -- 2019-03-12 kimcd 전지 제한

	-- 2019-02-15 kimcd 공정 PC 사용자만 수신 시작
	SET @v_temp1 = 'STEP UPDATE PERSON XIF_MMD_BAS_ITEM_DATA_R'
	UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
	SET    proc_flag = 'Y'
			,[UPDDTTM] = GETDATE()
	WHERE  proc_flag = 'N'
	AND    bas_item_id = 'PERSON'
	AND    IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 전지 제한
	AND    BAS_KEY_ATTR3 != 'P'; -- P	공정 PC ID
	-- 2019-02-15 kimcd 공정 PC 사용자만 수신 끝

	-- 2020-09-23 kimcd P5400 공정의 2nd OCV 조건만 회신하도록 Flag Y 처리 시작
	SET @v_temp1 = 'STEP UPDATE PRODUCTPROCESSCONTROLSPEC XIF_MMD_BAS_ITEM_DATA_R'
	UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
	SET	   PROC_FLAG = 'Y'
		  ,[UPDDTTM] = GETDATE()
	WHERE [PROC_FLAG] = 'N'
	AND   BAS_ITEM_ID = 'PRODUCTPROCESSCONTROLSPEC'
	AND   IF_ID       = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 2019-03-12 kimcd 전지 제한
	AND   NOT ( BAS_KEY_ATTR5 IN ('PDPCSETU','STPERMITCNT') AND   BAS_KEY_ATTR4 = 'P5300' ) -- 2021-10-25 kimcd 공정,제어 항목 수정
	-- 2020-09-23 kimcd P5400 공정의 2nd OCV 조건만 회신하도록 Flag Y 처리 끝

    -- BEGIN TRANSACTION; 2020-01-10 kimcd transaction block 제거
	        
    	SET @v_temp1 = 'STEP UPDATE XIF_MMD_BAS_ITEM_DATA_R'
		UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
		SET    [PROC_FLAG]   = 'P'
		      ,[UPDDTTM]     = GETDATE()
		WHERE ( @P_BAS_ITEM_ID IS NULL OR [BAS_ITEM_ID] = @P_BAS_ITEM_ID )
		AND   ISNULL([PROC_FLAG],'N') = 'N'
		AND    IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA';  -- 2019-03-12 kimcd 전지 제한

        SET @v_temp1 = 'STEP OPEN CURSOR XIF_MMD_BAS_ITEM_DATA_R'
    	OPEN C_DATA
        FETCH NEXT FROM C_DATA INTO @IF_SEQ
								  , @IF_SOURCE      -- 2019-03-12 kimcd 재료 구분자
								  , @IF_RCV_DATE    -- 2020-06-26 kimcd IF_RCV_DATE 조회추가
	                              , @BAS_ITEM_ID
	                              , @DISTRB_TG_BAS_ITEM_NAME
	                              , @SRC_REPSTR_ID
	                              , @SRC_BAS_ITEM_ID
	                              , @SRC_KEY_SEQ_NO
	                              , @SRC_HIST_SEQ_NO
	                              , @BAS_KEY_ATTR1
	                              , @BAS_KEY_ATTR2
	                              , @BAS_KEY_ATTR3
	                              , @BAS_KEY_ATTR4
	                              , @BAS_KEY_ATTR5
	                              , @BAS_KEY_ATTR6
	                              , @BAS_KEY_ATTR7
	                              , @BAS_KEY_ATTR8
	                              , @BAS_KEY_ATTR9
	                              , @BAS_KEY_ATTR10
	                              , @BAS_ATTR1
	                              , @BAS_ATTR2
	                              , @BAS_ATTR3
	                              , @BAS_ATTR4
	                              , @BAS_ATTR5
	                              , @BAS_ATTR6
	                              , @BAS_ATTR7
	                              , @BAS_ATTR8
	                              , @BAS_ATTR9
	                              , @BAS_ATTR10
	                              , @BAS_ATTR11
	                              , @BAS_ATTR12
	                              , @BAS_ATTR13
	                              , @BAS_ATTR14
	                              , @BAS_ATTR15
								  , @BAS_ATTR16
								  , @BAS_ATTR17  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
								  , @BAS_ATTR18  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
								  , @BAS_ATTR19
								  , @BAS_ATTR20
								  , @BAS_ATTR21
								  , @BAS_ATTR22
								  , @BAS_ATTR23
								  , @BAS_ATTR24
								  , @BAS_ATTR25
								  , @BAS_ATTR26
								  , @BAS_ATTR27
								  , @BAS_ATTR28
								  , @BAS_ATTR29
	                              , @BAS_ATTR31
	                              , @BAS_ATTR32
	                              , @BAS_ATTR33
	                              , @BAS_ATTR34
	                              , @BAS_ATTR35
	                              , @BAS_ATTR36
	                              , @BAS_ATTR37
	                              , @BAS_ATTR38
	                              , @BAS_ATTR39
	                              , @BAS_ATTR40
	                              , @BAS_ATTR41
	                              , @BAS_ATTR42
	                              , @BAS_ATTR43
	                              , @BAS_ATTR44
	                              , @BAS_ATTR45
	                              , @BAS_ATTR46
	                              , @BAS_ATTR47
	                              , @BAS_ATTR48
	                              , @BAS_ATTR49
	                              , @BAS_ATTR50
								  , @BAS_ATTR56  -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
								  , @BAS_ATTR57  -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
								  , @BAS_ATTR80  -- 2021-06-30 kimcd Interface 시스템 명 MES SOURCE GROUP 수신 추가
	                              , @BAS_ATTR_MSG
	                              , @USE_FLAG
	                              , @DEL_FLAG
    
        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			SET @if_id_code = REPLACE( @if_id_code, 'OSC1', @IF_SOURCE)  -- 2019-03-12 kimcd IF ID 변경

            IF @BAS_ITEM_ID = 'PROCESS' 
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

                    -- PROCESS 입력용 SITE CURSOR
                    DECLARE C_PROCESS_SITE CURSOR FOR
						--SELECT DISTINCT SSM.[COMPANY_ID]
                        --     , SEM.[DIVISION_ID]
                        --     , SSM.[SITE_ID]
						--FROM  [dbo].[SCM_SITE_M] SSM
						--    , [dbo].[SCM_EQUIPMENT_M]  SEM
						--WHERE  SEM.[COMPANY_ID]   = SSM.[COMPANY_ID]
						--AND    SEM.[SITE_ID]      = SSM.[SITE_ID]
						--AND    SEM.[OPERATION_ID] = @BAS_KEY_ATTR1;
						SELECT DISTINCT SSM.[COMPANY_ID]
							 , SDM.[DIVISION_ID]
							 , SSM.[SITE_ID]
							 , LV.[ATTRIBUTE2]    AS ERP_OPERATION_ID
						FROM   [dbo].[SCM_SITE_M]       SSM  WITH(NOLOCK)
						     , [dbo].[SCM_DIVISION_M]   SDM  WITH(NOLOCK)
							 , [DBO].[SCM_SYS_LOOKUP_VALUE]  LV  WITH(NOLOCK)
						WHERE  SSM.[COMPANY_ID]      = SDM.[COMPANY_ID]
						AND    LV.[LOOKUP_TYPE_CODE] = 'FP_OPERATION'
						AND    LV.[SEGMENT1]         = @BAS_KEY_ATTR1
						AND    LV.[ACTIVE_FLAG]      = 'Y'
						-- 2022-03-18 전체 Division 조건 제거 AND    ( ( @IF_SOURCE = 'OSC2' AND SDM.DIVISION_ID IN ('42', '44') )
						-- 2022-03-18 전체 Division 조건 제거          OR ( @IF_SOURCE = 'OSC1' AND SDM.DIVISION_ID IN ('40', '81', '82') ) ) -- 2019-03-12 kimcd 전지 제한 42 display 재로, 44 전지 재료
						;

					SET @PROCESS_FLAG = 'Y';
                    SET @v_temp1 = 'STEP OPEN CURSOR PROCESS SITE'
    		        OPEN C_PROCESS_SITE
                    FETCH NEXT FROM C_PROCESS_SITE INTO @COMPANY_ID
                                                       ,@DIVISION_ID
                                                       ,@SITE_ID
													   ,@ERP_OPERATION_ID
                    WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
                    BEGIN
					    SET @v_temp1 = 'STEP MERGE SCM_OPERATION_M'
                        MERGE INTO [DBO].[SCM_OPERATION_M] SOM
						USING ( SELECT @COMPANY_ID     AS COMPANY_ID
									  ,@DIVISION_ID    AS DIVISION_ID
									  ,@SITE_ID        AS SITE_ID
									  ,@BAS_KEY_ATTR1  AS OPERATION_ID
									  ,ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
											  ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
											 ) AS OPERATION_NAME ) XXX
						ON    (     SOM.[COMPANY_ID]   = XXX.COMPANY_ID 
								AND SOM.[DIVISION_ID]  = XXX.DIVISION_ID
								AND SOM.[SITE_ID]      = XXX.SITE_ID
								AND SOM.[OPERATION_ID] = XXX.OPERATION_ID )
						WHEN MATCHED THEN
							UPDATE SET SOM.[OPERATION_NAME]   = XXX.OPERATION_NAME    -- 공정명칭
									  --,SOM.[ACTIVE_FLAG]      = @USE_FLAG           -- 설비 사용여부 2017-11-17 kimcd block. 사용 여부 FP에서 별도 관리
									  --,SOM.[ERP_OPERATION_ID] = @BAS_ATTR10         -- ERP 공정 ID 실제 관리 안 되어 수신 불가
									  ,SOM.[MES_ERP_INTERFACE_FLAG] = @BAS_ATTR3      -- [ERPRPTIUSE] ERP 보고 사용여부
					    			  ,SOM.[UPDATE_ID]        = 'PR_XIF_MMD_ALL_R'
									  ,SOM.[UPDATE_TIME]      = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]              -- 회사 코드
									,[DIVISION_ID]             -- 사업부 코드
									,[SITE_ID]                 -- 지역 코드
									,[OPERATION_ID]            -- 단위 공정 ID
									,[OPERATION_NAME]          -- 단위 공정 명
									,[ERP_OPERATION_ID]        -- ERP 단위 공정 실제 관리 안 되어 수신 불가
									,[WO_FLAG]                 -- WO 형성 여부 - 초기 값은 MES_ERP_INTERFACE_FLAG로 넣는다
									,[MES_ERP_INTERFACE_FLAG]  -- [ERPRPTIUSE] ERP 보고 사용여부
									,[OPERATION_GROUP_ID]      -- 공정 Group ID
									,[OPERATION_GROUP_NAME]    -- 공정 Group 명
									,[SHOP_GROUP_ID]           -- shop group id
									,[ACTIVE_FLAG]             -- 유효 여부
									,[INSTANCE_TYPE]           -- FP 엔진 instrance type
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									)
							VALUES ( @COMPANY_ID
									,@DIVISION_ID
									,@SITE_ID
									,@BAS_KEY_ATTR1      -- 공정 ID
									,XXX.OPERATION_NAME  -- 공정명칭
									,@ERP_OPERATION_ID   -- LOOKUP CODE 값 사용하여 형성 -- ERP 공정 ID 실제 관리 안 되어 수신 불가
									,@BAS_ATTR3          -- [WO_FLAG]  -- [ERPRPTIUSE] ERP 보고 사용여부
									,@BAS_ATTR3          -- [ERPRPTIUSE] ERP 보고 사용여부
									,'*'                 -- 공정 Group id
									,'*'                 -- 공정 group 명
									,'*'                 -- shop group id
									,@USE_FLAG           -- 설비 사용여부
									,'*'                 -- [INSTANCE_TYPE]
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									);  
    					SET @v_count = @v_count + 1;

						FETCH NEXT FROM C_PROCESS_SITE INTO @COMPANY_ID
												           ,@DIVISION_ID
												           ,@SITE_ID
														   ,@ERP_OPERATION_ID
					END -- WHILE @@FETCH_STATUS = 0  C_PROCESS_SITE
					CLOSE C_PROCESS_SITE;
			        DEALLOCATE C_PROCESS_SITE;   -- 메모리 해제

					-- 2021-10-19 kimcd SCM_MMD_OPERATION_M 갱신 시작
					SET @v_temp1 = 'STEP MERGE SCM_MMD_OPERATION_M'
                    MERGE INTO [DBO].[SCM_MMD_OPERATION_M] SOM
					USING ( SELECT @BAS_KEY_ATTR1 AS OPERATION_ID
								  ,@BAS_KEY_ATTR2 AS OPERATION_TYPE
								  ,ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
										  ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
										  ) AS OPERATION_NAME
								  ,@BAS_ATTR2  AS DESCRIPTION
								  ,@BAS_ATTR3  AS ERP_RESULT_USE
								  ,@BAS_ATTR4  AS MES_RESULT_USE
								  ,@BAS_ATTR8  AS EQUIPMENT_USE
								  ,@BAS_ATTR10 AS ERP_OPERATION_ID
								  ,@BAS_ATTR38 AS OPERATION_SHORT_ID
								  ,@BAS_ATTR47 AS PLAN_MANAGE_TYPE
								  ,@USE_FLAG AS USE_FLAG                  -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES USE_FLAG 수신 추가
								  ,@BAS_ATTR56 AS PROC_GR_CODE            -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
								  ,@BAS_ATTR57 AS PROC_DETL_TYPE_CODE     -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
					              ) XXX
					ON    (     SOM.[OPERATION_ID]   = XXX.OPERATION_ID 
							AND SOM.[OPERATION_TYPE]  = XXX.OPERATION_TYPE )
					WHEN MATCHED THEN
						UPDATE SET SOM.[OPERATION_NAME]     = XXX.OPERATION_NAME
								  ,SOM.[DESCRIPTION]        = XXX.DESCRIPTION
								  ,SOM.[ERP_RESULT_USE]     = XXX.ERP_RESULT_USE
								  ,SOM.[MES_RESULT_USE]     = XXX.MES_RESULT_USE
								  ,SOM.[EQUIPMENT_USE]      = XXX.EQUIPMENT_USE
								  ,SOM.[ERP_OPERATION_ID]   = XXX.ERP_OPERATION_ID
								  ,SOM.[OPERATION_SHORT_ID] = XXX.OPERATION_SHORT_ID
								  ,SOM.[PLAN_MANAGE_TYPE]   = XXX.PLAN_MANAGE_TYPE
					    		  ,SOM.[UPDATE_ID]          = 'PR_XIF_MMD_ALL_R'
								  ,SOM.[UPDATE_TIME]        = GETDATE()
								  ,SOM.[USE_FLAG]           = XXX.USE_FLAG               -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES USE_FLAG 수신 추가
								  ,SOM.[PROC_GR_CODE]       = XXX.PROC_GR_CODE           -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
								  ,SOM.[PROC_DETL_TYPE_CODE]= XXX.PROC_DETL_TYPE_CODE    -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
					WHEN NOT MATCHED THEN
						INSERT ( [OPERATION_ID]	      -- 공정 ID
								,[OPERATION_TYPE]     -- 공정 유형
								,[OPERATION_NAME]	  -- 공정명칭
								,[DESCRIPTION]	      -- 공정 설명
								,[ERP_RESULT_USE]	  -- ERP 보고 사용여부
								,[MES_RESULT_USE]	  -- MES 실적 사용여부
								,[EQUIPMENT_USE]	  -- 설비 사용여부
								,[ERP_OPERATION_ID]	  -- ERP 공정 ID
								,[OPERATION_SHORT_ID] -- 공정 약어 코드
								,[PLAN_MANAGE_TYPE]	  -- 계획 관리 유형 코드
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
								,[USE_FLAG]               -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES USE_FLAG 수신 추가
								,[PROC_GR_CODE]           -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
								,[PROC_DETL_TYPE_CODE]    -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
								)
						VALUES ( XXX.OPERATION_ID
								,XXX.OPERATION_TYPE
								,XXX.OPERATION_NAME
								,XXX.DESCRIPTION
								,XXX.ERP_RESULT_USE
								,XXX.MES_RESULT_USE
								,XXX.EQUIPMENT_USE
								,XXX.ERP_OPERATION_ID
								,XXX.OPERATION_SHORT_ID
								,XXX.PLAN_MANAGE_TYPE
								,'PR_XIF_MMD_ALL_R'
								,GETDATE()
								,'PR_XIF_MMD_ALL_R'
								,GETDATE()
								,XXX.USE_FLAG               -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES USE_FLAG 수신 추가
								,XXX.PROC_GR_CODE           -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
								,XXX.PROC_DETL_TYPE_CODE    -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
								);
					-- 2021-10-19 kimcd SCM_MMD_OPERATION_M 갱신 끝

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG]   = 'P'
							AND   [BAS_ITEM_ID] = 'PROCESS'
							AND   [IF_SEQ]      = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						BEGIN
							SET @CHECK_OP = NULL;
							SELECT @CHECK_OP = 'Y'
							FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  LV  WITH(NOLOCK)
							WHERE  LV.[LOOKUP_TYPE_CODE] = 'FP_OPERATION'
							AND    LV.[SEGMENT1]         = @BAS_KEY_ATTR1
							AND    LV.[ACTIVE_FLAG]      = 'Y';
							
							IF @CHECK_OP = 'Y'
								BEGIN
									UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
									SET [PROC_FLAG] = 'N'
									   ,[UPDDTTM]   = GETDATE()
									WHERE [PROC_FLAG] = 'P'
									AND   [BAS_ITEM_ID] = 'PROCESS'
									AND   [IF_SEQ]    = @IF_SEQ;
								END;
							ELSE
								BEGIN
									UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
									SET [PROC_FLAG] = 'Y'
									   ,[UPDDTTM]   = GETDATE()
									WHERE [PROC_FLAG]   = 'P'
									AND   [BAS_ITEM_ID] = 'PROCESS'
									AND   [IF_SEQ]      = @IF_SEQ;

									SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
									SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

									INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
										([IF_SEQ]             -- [nvarchar](50) NOT NULL,
										,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
										,[IF_ID]              -- [nvarchar](50) NOT NULL,
										,[IF_SND_DATE]        -- [datetime] NULL,
										,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
										,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										)
									VALUES
										(@send_if_seq
										,'R'
										,@if_id_code
										,GETDATE()
										,@IF_SEQ
										,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										);									
								END;
						END;

			    END;  -- IF @BAS_ITEM_ID = 'PROCESS'

            ELSE IF @BAS_ITEM_ID = 'EQUIPMENT'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

                    -- EQUIPMENT 입력용 LINE CURSOR
                    DECLARE C_EQUIPMENT_LINE CURSOR FOR
						SELECT SLM.[COMPANY_ID]
                             , SLM.[DIVISION_ID]
                             , SLM.[SITE_ID]
							 , SLM.[PLANT_ID]
							 , SLM.[FACTORY_ID]
							 , ( SELECT TOP 1  M.SEGMENT2
							     FROM   DBO.SCM_SYS_LOOKUP_VALUE  M
								 WHERE  M.LOOKUP_TYPE_CODE = 'EQUIPMENT_ADD_FOR_RES_SHARE'
								 AND    M.SEGMENT1         = SLM.FACTORY_ID
								 AND    M.ACTIVE_FLAG      = 'Y'  ) AS ADD_EXTRA
							 , ( SELECT L.SEGMENT2
								 FROM   SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
								 WHERE  L.LOOKUP_TYPE_CODE = 'WIP_LOCATION'
								 AND    L.ACTIVE_FLAG      = 'Y'
								 AND    L.SEGMENT1         = SLM.PLANT_ID ) AS LOC_YN  -- 2018-02-02 kimcd add location 수신 여부 관리
						FROM  [dbo].[SCM_MMD_LINE_M]  SLM  WITH(NOLOCK)
						WHERE  SLM.[LINE_ID] = @BAS_KEY_ATTR3; -- LINE ID


                    SET @v_temp1 = 'STEP OPEN CURSOR EQUIPMENT LINE'
    		        OPEN C_EQUIPMENT_LINE
                    FETCH NEXT FROM C_EQUIPMENT_LINE INTO @COMPANY_ID
                                                         ,@DIVISION_ID
                                                         ,@SITE_ID
														 ,@PLANT_ID
														 ,@FACTORY_ID
														 ,@ADD_EXTRA
														 ,@LOC_YN   -- 2018-02-02 kimcd add location 수신 여부 관리
                    WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
                    BEGIN
					    SET @PROCESS_FLAG = 'Y'

					    SET @v_temp1 = 'STEP MERGE SCM_EQUIPMENT_M'
                        MERGE INTO [DBO].[SCM_EQUIPMENT_M] SEM
						USING ( SELECT @COMPANY_ID     AS COMPANY_ID
									  ,@DIVISION_ID    AS DIVISION_ID
									  ,@SITE_ID        AS SITE_ID
									  ,@PLANT_ID       AS PLANT_ID
									  ,@FACTORY_ID     AS FACTORY_ID
									  ,@BAS_KEY_ATTR1  AS EQUIPMENT_ID
									  ,ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
											  ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
											 ) AS EQUIPMENT_NAME
									  ,CASE WHEN @BAS_ATTR7 = '' THEN
												'M'
											ELSE
												@BAS_ATTR7
											END AS EQUIPMENT_TYPE
									  ,CASE WHEN @BAS_ATTR32 = '' THEN
											'-'
											WHEN @BAS_ATTR32 IS NULL THEN
											'-'
											ELSE
												@BAS_ATTR32
											END AS ELECTRODE
									  ,CASE WHEN @BAS_ATTR45 = '' THEN
												NULL
											ELSE
												@BAS_ATTR45
											END     AS COATER_EQPT_TYPE_CODE -- FP-058 2017-05-24 kimcd Coater 설비 양면, 단면 설비 구분자 추가
									  ,CASE WHEN @LOC_YN = 'Y' THEN CASE WHEN @BAS_ATTR36 IS NULL OR @BAS_ATTR36 = '' THEN '-' ELSE @BAS_ATTR36 END ELSE '-' END AS LOCATION -- 설비 층 번호[EQPT_FLOOR_NO] 2017-11-08 kimcd -- 2018-02-02 kimcd location 관리하는 plant에서만 층 수신함.
									  -- 2022-07-12 kimcd location 빈문자열 처리 로직 추가
									   ) XXX
						ON    ( /*    SEM.[COMPANY_ID]   = XXX.COMPANY_ID
						        AND SEM.[DIVISION_ID]  = XXX.DIVISION_ID
								AND SEM.[SITE_ID]      = XXX.SITE_ID */
								-- SEM.[PLANT_ID]     = XXX.PLANT_ID -- 2022-05-27 kimcd EQUIPMENT ID를 실질적인 KEY로 사용. 2017-12-16 kimcd key 중복 오류 회피하기 위해 plant 조건 복원
								/*AND SEM.[FACTORY_ID]   = XXX.FACTORY_ID  2017-09-28 kimcd 설비기준으로만 기존 정보 존재 여부를 확인 - 공장 정보를 무시함. MMD는 Equipment_id가 Key 값임 */
								SEM.[EQUIPMENT_ID] = XXX.EQUIPMENT_ID )
						WHEN MATCHED THEN
							UPDATE SET SEM.[COMPANY_ID]      = @COMPANY_ID   -- 2017-09-28 kimcd 추가 시작
									  ,SEM.[DIVISION_ID]     = @DIVISION_ID
									  ,SEM.[SITE_ID]         = @SITE_ID
									  ,SEM.[PLANT_ID]        = @PLANT_ID
									  ,SEM.[FACTORY_ID]      = @FACTORY_ID   -- 2017-09-28 kimcd 추가 끝 - 설비 ID에 설정된 라인 기준으로 상위 조직 정보를 모두 동기화함.
									  ,SEM.[EQUIPMENT_NAME]  = XXX.EQUIPMENT_NAME  -- 설비 명
									  ,SEM.[MES_LINE_ID]     = @BAS_KEY_ATTR3      -- 라인
									  ,SEM.[WORK_CENTER_ID]  = CASE WHEN @BAS_ATTR33 = '' THEN NULL ELSE @BAS_ATTR33 END         -- WORK CENTER ID
									  ,SEM.[EQUIPMENT_TYPE]  = XXX.EQUIPMENT_TYPE  -- @BAS_ATTR7   [EQPTLEVEL] 설비 레벨
									  -- 2016-10-19 임시 김춘동 시작
									  -- ,SEM.[ELECTRODE_TYPE]  = XXX.ELECTRODE       -- 전극 유형 코드
									  ,SEM.[ELECTRODE_TYPE] = CASE WHEN SEM.[UPDATE_ID] = 'PR_XIF_MMD_ALL_R' THEN
									                              CASE WHEN ( SELECT TOP 1  M.ATTRIBUTE4
																			  FROM   DBO.SCM_SYS_LOOKUP_VALUE  M WITH(NOLOCK)
																			  WHERE  M.LOOKUP_TYPE_CODE = 'FP_OPERATION'
																			  AND    M.SEGMENT1         = SEM.[OPERATION_ID]
																			  AND    M.ACTIVE_FLAG      = 'Y')  = 'Y' THEN
																	  CASE WHEN XXX.ELECTRODE = 'A' THEN
																				'Anode'
																		   WHEN XXX.ELECTRODE = 'C' THEN
																				'Cathode'
																	  END
															      ELSE
																      XXX.ELECTRODE
															      END
															  ELSE
															      SEM.[ELECTRODE_TYPE]
															  END
									  -- 2016-10-19 임시 김춘동 끝
									  ,SEM.[ACTIVE_FLAG]     = @USE_FLAG          -- 유효 여부 Y/N
									  ,SEM.[LINE_ID] = CASE WHEN SEM.FACTORY_ID != @FACTORY_ID THEN @BAS_KEY_ATTR3 ELSE 
															CASE WHEN SEM.[LINE_ID] = SEM.[MES_LINE_ID] THEN
									                            @BAS_KEY_ATTR3
														    ELSE
																SEM.[LINE_ID]
															END
													   END -- 2022-05-27 kimcd 동이 바뀌면 항상 수정 -- 2017-05-19 kimcd add mes line id가 유지되는 경우 fp line도 갱신 FP-049
									  ,SEM.[COATER_EQPT_TYPE_CODE] = XXX.COATER_EQPT_TYPE_CODE  -- FP-058 2017-05-24 kimcd Coater 설비 양면, 단면 설비 구분자 추가
					    			  -- ,SEM.[UPDATE_ID]       = 'PR_XIF_MMD_ALL_R'
									  ,SEM.[UPDATE_TIME]     = GETDATE()
									  ,SEM.[LOCATION]        = XXX.[LOCATION] -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
									  ,SEM.[MMD_EQUIPMENT_TYPE] = @BAS_ATTR7   -- 2022-05-27 kimcd MMD 설비 유형 보존
									  ,SEM.[MMD_ELECTRODE_TYPE] = @BAS_ATTR32  -- 2022-05-27 kimcd MMD 극성 유형 보존
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]	    -- 회사 코드
								   , [DIVISION_ID]	    -- 사업부 코드
								   , [SITE_ID]	        -- 지역 코드
								   , [PLANT_ID]	        -- 공장 코드
								   , [FACTORY_ID]	    -- 공장 동 코드
								   , [EQUIPMENT_ID]	    -- 설비 ID
								   , [EQUIPMENT_NAME]	-- 설비 명
								   , [OPERATION_ID]	    -- 단위 공정(OPERATION_ID) ID -- '*'
								   , [LINE_ID]	        -- 라인
								   , [MES_LINE_ID]      -- MES 라인
								   , [WORK_CENTER_ID]	-- WORK CENTER ID
								   , [EQUIPMENT_TYPE]	-- "설비 유형 - MAIN/SUB"
								   , [ELECTRODE_TYPE]	-- 전극
								   , [ACTIVE_FLAG]	    -- "유효 여부- Y/N"
								   , [COATER_EQPT_TYPE_CODE] -- FP-058 2017-05-24 kimcd Coater 설비 양면, 단면 설비 구분자 추가
								   , [INSERT_ID]	    -- 등록자
								   , [INSERT_TIME]	    -- 등록일
								   , [UPDATE_ID]	    -- 수정자
								   , [UPDATE_TIME]	    -- 수정일
								   , [LOCATION]         -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
								   , [MMD_EQUIPMENT_TYPE] -- 2022-05-27 kimcd MMD 설비 유형 보존
								   , [MMD_ELECTRODE_TYPE] -- 2022-05-27 kimcd MMD 극성 유형 보존
									)
							VALUES ( @COMPANY_ID
									,@DIVISION_ID
									,@SITE_ID
									,@PLANT_ID
									,@FACTORY_ID
									,@BAS_KEY_ATTR1      -- 설비 ID
									,XXX.EQUIPMENT_NAME  -- 설비 명
									,'*'                 -- 단위 공정(OPERATION_ID) ID
									,@BAS_KEY_ATTR3      -- 라인
									,@BAS_KEY_ATTR3      -- MES 라인
									,CASE WHEN @BAS_ATTR33 = '' THEN NULL ELSE @BAS_ATTR33 END         -- WORK CENTER ID
									,XXX.EQUIPMENT_TYPE  -- @BAS_ATTR7   [EQPTLEVEL] 설비 레벨
									,XXX.ELECTRODE       -- @BAS_ATTR32         -- 전극
									,@USE_FLAG           -- 유효 여부 Y/N
									,XXX.COATER_EQPT_TYPE_CODE   -- FP-058 2017-05-24 kimcd Coater 설비 양면, 단면 설비 구분자 추가
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									,XXX.LOCATION        -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
								    ,@BAS_ATTR7          -- 2022-05-27 kimcd MMD 설비 유형 보존
								    ,@BAS_ATTR32         -- 2022-05-27 kimcd MMD 극성 유형 보존
									);
    					SET @v_count = @v_count + 1;

						IF @ADD_EXTRA IS NOT NULL
							BEGIN

								SET @v_temp1 = 'STEP MERGE SCM_EQUIPMENT_M'
								MERGE INTO [DBO].[SCM_EQUIPMENT_M] SEM
								USING ( SELECT F.COMPANY_ID     AS COMPANY_ID
											  ,F.DIVISION_ID    AS DIVISION_ID
											  ,F.SITE_ID        AS SITE_ID
											  ,F.PLANT_ID       AS PLANT_ID
											  ,F.FACTORY_ID     AS FACTORY_ID
											  ,@BAS_KEY_ATTR1   AS EQUIPMENT_ID
											  ,ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
													  ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
													 ) AS EQUIPMENT_NAME
											  ,CASE WHEN @BAS_ATTR7 = '' THEN
														'M'
													ELSE
														@BAS_ATTR7
													END AS EQUIPMENT_TYPE
											  ,CASE WHEN @BAS_ATTR32 = '' THEN
													'-'
													WHEN @BAS_ATTR32 IS NULL THEN
													'-'
													ELSE
														@BAS_ATTR32
													END AS ELECTRODE
											 ,CASE WHEN @LOC_YN = 'Y' THEN @BAS_ATTR36 ELSE '-' END AS LOCATION -- 설비 층 번호[EQPT_FLOOR_NO] 2017-11-08 kimcd -- 2018-02-02 kimcd location 관리하는 plant에서만 층 수신함.
										FROM  DBO.SCM_FACTORY_M F WITH(NOLOCK)
										WHERE F.FACTORY_ID = @ADD_EXTRA ) XXX
								ON    (     SEM.[COMPANY_ID]   = XXX.COMPANY_ID
										AND SEM.[DIVISION_ID]  = XXX.DIVISION_ID
										AND SEM.[SITE_ID]      = XXX.SITE_ID
										AND SEM.[PLANT_ID]     = XXX.PLANT_ID
										AND SEM.[FACTORY_ID]   = XXX.FACTORY_ID
										AND SEM.[EQUIPMENT_ID] = XXX.EQUIPMENT_ID )
								WHEN MATCHED THEN
									UPDATE SET SEM.[EQUIPMENT_NAME]  = XXX.EQUIPMENT_NAME  -- 설비 명
											  ,SEM.[MES_LINE_ID]     = @BAS_KEY_ATTR3      -- 라인
											  ,SEM.[WORK_CENTER_ID]  = @BAS_ATTR33         -- WORK CENTER ID
											  ,SEM.[EQUIPMENT_TYPE]  = XXX.EQUIPMENT_TYPE  -- @BAS_ATTR7   [EQPTLEVEL] 설비 레벨
											  -- 2016-10-19 임시 김춘동 시작
											  -- ,SEM.[ELECTRODE_TYPE]  = XXX.ELECTRODE       -- 전극 유형 코드
											  ,SEM.[ELECTRODE_TYPE] = CASE WHEN SEM.[UPDATE_ID] = 'PR_XIF_MMD_ALL_R' THEN
																		  CASE WHEN ( SELECT TOP 1  M.ATTRIBUTE4
																					  FROM   DBO.SCM_SYS_LOOKUP_VALUE  M WITH(NOLOCK)
																					  WHERE  M.LOOKUP_TYPE_CODE = 'FP_OPERATION'
																					  AND    M.SEGMENT1         = SEM.[OPERATION_ID]
																					  AND    M.ACTIVE_FLAG      = 'Y')  = 'Y' THEN
																			  CASE WHEN XXX.ELECTRODE = 'A' THEN
																						'Anode'
																				   WHEN XXX.ELECTRODE = 'C' THEN
																						'Cathode'
																			  END
																		  ELSE
																			  XXX.ELECTRODE
																		  END
																	  ELSE
																		  SEM.[ELECTRODE_TYPE]
																	  END
											  -- 2016-10-19 임시 김춘동 끝
											  ,SEM.[ACTIVE_FLAG]     = @USE_FLAG          -- 유효 여부 Y/N
					    					  -- ,SEM.[UPDATE_ID]       = 'PR_XIF_MMD_ALL_R'
											  ,SEM.[UPDATE_TIME]     = GETDATE()
											  ,SEM.[LOCATION]        = XXX.[LOCATION] -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
								WHEN NOT MATCHED THEN
									INSERT ( [COMPANY_ID]	    -- 회사 코드
										   , [DIVISION_ID]	    -- 사업부 코드
										   , [SITE_ID]	        -- 지역 코드
										   , [PLANT_ID]	        -- 공장 코드
										   , [FACTORY_ID]	    -- 공장 동 코드
										   , [EQUIPMENT_ID]	    -- 설비 ID
										   , [EQUIPMENT_NAME]	-- 설비 명
										   , [OPERATION_ID]	    -- 단위 공정(OPERATION_ID) ID -- '*'
										   , [LINE_ID]	        -- 라인
										   , [MES_LINE_ID]      -- MES 라인
										   , [WORK_CENTER_ID]	-- WORK CENTER ID
										   , [EQUIPMENT_TYPE]	-- "설비 유형 - MAIN/SUB"
										   , [ELECTRODE_TYPE]	-- 전극
										   , [ACTIVE_FLAG]	    -- "유효 여부- Y/N"
										   , [INSERT_ID]	    -- 등록자
										   , [INSERT_TIME]	    -- 등록일
										   , [UPDATE_ID]	    -- 수정자
										   , [UPDATE_TIME]	    -- 수정일
										   , [LOCATION]         -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
											)
									VALUES ( XXX.COMPANY_ID
											,XXX.DIVISION_ID
											,XXX.SITE_ID
											,XXX.PLANT_ID
											,XXX.FACTORY_ID
											,@BAS_KEY_ATTR1      -- 설비 ID
											,XXX.EQUIPMENT_NAME  -- 설비 명
											,'*'                 -- 단위 공정(OPERATION_ID) ID
											,@BAS_KEY_ATTR3      -- 라인
											,@BAS_KEY_ATTR3      -- MES 라인
											,@BAS_ATTR33         -- WORK CENTER ID
											,XXX.EQUIPMENT_TYPE  -- @BAS_ATTR7   [EQPTLEVEL] 설비 레벨
											,XXX.ELECTRODE       -- @BAS_ATTR32         -- 전극
											,@USE_FLAG           -- 유효 여부 Y/N
											,'PR_XIF_MMD_ALL_R'
											,GETDATE()
											,'PR_XIF_MMD_ALL_R'
											,GETDATE()
											,XXX.LOCATION        -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
											);

							END;


						-- 2022-07-12 kimcd 설비 정보 영향도 제거 시작
						-- 설비에 ERP W/C 정보 설정되면 라인 정보도 동기화
						UPDATE LM
						SET    [MES_LINE_ID]       = EM.[MES_LINE_ID]
							 , [WORK_CENTER_ID]    = CASE WHEN EM.[WORK_CENTER_ID] IS NOT NULL AND EM.[WORK_CENTER_ID] != '' THEN EM.[WORK_CENTER_ID] ELSE LM.[WORK_CENTER_ID] END
							 , [UPDATE_ID]         = 'PR_XIF_MMD_ALL_R'
							 , [UPDATE_TIME]       = GETDATE()
						FROM   [DBO].[SCM_EQUIPMENT_M] EM   WITH(NOLOCK)
							 , [DBO].[SCM_LINE_M]  LM
					    WHERE  LM.[COMPANY_ID]     = EM.[COMPANY_ID]
						AND    LM.[DIVISION_ID]    = EM.[DIVISION_ID]
						AND    LM.[SITE_ID]        = EM.[SITE_ID]
						AND    LM.[PLANT_ID]       = EM.[PLANT_ID]
						AND    LM.[FACTORY_ID]     = EM.[FACTORY_ID]
						AND    LM.[OPERATION_ID]   = EM.[OPERATION_ID]
						AND    LM.[LINE_ID]        = EM.[LINE_ID]
						AND    LM.[ELECTRODE_TYPE] = ISNULL(EM.[ELECTRODE_TYPE],'-')
						AND    EM.[ACTIVE_FLAG]    = 'Y'
						AND    EM.[OPERATION_ID]  != '*'
						AND    EM.[EQUIPMENT_ID]   = @BAS_KEY_ATTR1
						-- 2022-07-12 kimcd 설비 정보 영향도 제거 끝

                    FETCH NEXT FROM C_EQUIPMENT_LINE INTO @COMPANY_ID
                                                         ,@DIVISION_ID
                                                         ,@SITE_ID
														 ,@PLANT_ID
														 ,@FACTORY_ID
														 ,@ADD_EXTRA
														 ,@LOC_YN  -- 2018-02-02 kimcd add location 수신 여부 관리

					END -- WHILE @@FETCH_STATUS = 0  C_EQUIPMENT_LINE
					CLOSE C_EQUIPMENT_LINE;
			        DEALLOCATE C_EQUIPMENT_LINE;   -- 메모리 해제

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'EQUIPMENT'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

							SET @SCM_LINE_CREATE = 'Y'  -- FP Line 추가 필요. Pack 공정에 Main 설비 표시
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = CASE WHEN @BAS_KEY_ATTR3 IS NULL THEN 'Y' ELSE 'N' END -- 2020-01-10 kimcd 라인 정보 없으면 수신된 것으로 변경
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'EQUIPMENT'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- IF @BAS_ITEM_ID = 'EQUIPMENT'

             ELSE IF @BAS_ITEM_ID = 'PROCESSEQUIPMENT'
			    BEGIN

				    SET @PROCESS_FLAG = 'N'

                    -- EQUIPMENT UPDATE CURSOR
                    DECLARE C_EQUIPMENT CURSOR FOR
						SELECT DISTINCT 
						       SEM.[COMPANY_ID]			-- 회사 코드
                             , SEM.[DIVISION_ID]		-- 사업부 코드
                             , SEM.[SITE_ID]			-- 지역 코드
							 , SEM.[PLANT_ID]			-- 공장 코드
							 , SEM.[FACTORY_ID]			-- 공장 동 코드
							 , SEM.[EQUIPMENT_ID]		-- 설비 ID
						     , SEM.[EQUIPMENT_NAME]		-- 설비 명
						     , SEM.[MES_LINE_ID]		--
						     , SEM.[WORK_CENTER_ID]		-- WORK CENTER ID
						     , SEM.[EQUIPMENT_TYPE]		-- "설비 유형 - MAIN/SUB"
						     , SEM.[ELECTRODE_TYPE]		-- 전극
						FROM   [dbo].[SCM_EQUIPMENT_M]  SEM  WITH(NOLOCK)
						WHERE  SEM.[EQUIPMENT_ID] = @BAS_KEY_ATTR2; -- EQUIPMENT ID

                    SET @v_temp1 = 'STEP OPEN CURSOR EQUIPMENT'
    		        OPEN C_EQUIPMENT
                    FETCH NEXT FROM C_EQUIPMENT INTO @COMPANY_ID
                                                    ,@DIVISION_ID
                                                    ,@SITE_ID
												    ,@PLANT_ID
													,@FACTORY_ID
													,@EQUIPMENT_ID
													,@EQUIPMENT_NAME	-- 설비 명
													,@MES_LINE_ID	    -- 라인
													,@WORK_CENTER_ID	-- WORK CENTER ID
													,@EQUIPMENT_TYPE	-- "설비 유형 - MAIN/SUB"
													,@ELECTRODE_TYPE	-- 전극

                    WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
                    BEGIN
					    SET @PROCESS_FLAG = 'Y'
						IF ISNULL(@USE_FLAG,'Y') = 'Y' 
							BEGIN
								SET @v_temp1 = 'STEP UPDATE SCM_EQUIPMENT_M'
								MERGE INTO [DBO].[SCM_EQUIPMENT_M] SEM
								USING ( SELECT @COMPANY_ID     AS COMPANY_ID
											  ,@DIVISION_ID    AS DIVISION_ID
											  ,@SITE_ID        AS SITE_ID
											  ,@PLANT_ID       AS PLANT_ID
											  ,@FACTORY_ID     AS FACTORY_ID
											  ,@BAS_KEY_ATTR1  AS OPERATION_ID
											  ,( SELECT TOP 1  M.ATTRIBUTE4
												 FROM   DBO.SCM_SYS_LOOKUP_VALUE  M WITH(NOLOCK)
												 WHERE  M.LOOKUP_TYPE_CODE = 'FP_OPERATION'
												 AND    M.SEGMENT1         = @BAS_KEY_ATTR1
												 AND    M.ACTIVE_FLAG      = 'Y' )   AS ELETRO_CHECK
											  ,@EQUIPMENT_ID   AS EQUIPMENT_ID ) XXX
								ON    (     SEM.[COMPANY_ID]   = XXX.COMPANY_ID
										AND SEM.[DIVISION_ID]  = XXX.DIVISION_ID
										AND SEM.[SITE_ID]      = XXX.SITE_ID
										AND SEM.[PLANT_ID]     = XXX.PLANT_ID
										AND SEM.[FACTORY_ID]   = XXX.FACTORY_ID
										AND ( SEM.[OPERATION_ID] = XXX.OPERATION_ID
											  OR SEM.[OPERATION_ID] = '*')
										AND SEM.[EQUIPMENT_ID] = XXX.EQUIPMENT_ID )
								WHEN MATCHED THEN
									UPDATE SET SEM.[OPERATION_ID] = XXX.OPERATION_ID
							     			  -- 2016-10-19 임시 김춘동 시작
											  -- ,SEM.[ELECTRODE_TYPE]  = XXX.ELECTRODE       -- 전극 유형 코드
											  ,SEM.[ELECTRODE_TYPE] =  CASE WHEN SEM.[UPDATE_ID] = 'PR_XIF_MMD_ALL_R' THEN
																			CASE WHEN  XXX.ELETRO_CHECK = 'Y' AND SEM.[ELECTRODE_TYPE] = 'A' THEN
																				'Anode'
																			WHEN XXX.ELETRO_CHECK = 'Y' AND SEM.[ELECTRODE_TYPE] = 'C' THEN
																				'Cathode'
																			ELSE
																				SEM.[ELECTRODE_TYPE]
																			END
																	   ELSE
																		   SEM.[ELECTRODE_TYPE]
																	   END
											  -- 2016-10-19 임시 김춘동 끝
											  ,SEM.[ACTIVE_FLAG]  = @USE_FLAG
											  --,SEM.[UPDATE_ID]    = 'PR_XIF_MMD_ALL_R'
											  ,SEM.[UPDATE_TIME]  = GETDATE()
								WHEN NOT MATCHED THEN
									INSERT ( [COMPANY_ID]	    -- 회사 코드
										   , [DIVISION_ID]	    -- 사업부 코드
										   , [SITE_ID]	        -- 지역 코드
										   , [PLANT_ID]	        -- 공장 코드
										   , [FACTORY_ID]	    -- 공장 동 코드
										   , [EQUIPMENT_ID]	    -- 설비 ID
										   , [EQUIPMENT_NAME]	-- 설비 명
										   , [OPERATION_ID]	    -- 단위 공정(OPERATION_ID) ID
										   , [LINE_ID]	        -- 라인
										   , [MES_LINE_ID]      -- MES LINE
										   , [WORK_CENTER_ID]	-- WORK CENTER ID
										   , [EQUIPMENT_TYPE]	-- "설비 유형 - MAIN/SUB"
										   , [ELECTRODE_TYPE]	-- 전극
										   , [ACTIVE_FLAG]	    -- "유효 여부- Y/N"
										   , [INSERT_ID]	    -- 등록자
										   , [INSERT_TIME]	    -- 등록일
										   , [UPDATE_ID]	    -- 수정자
										   , [UPDATE_TIME]	    -- 수정일
											)
									VALUES ( @COMPANY_ID
											,@DIVISION_ID
											,@SITE_ID
											,@PLANT_ID
											,@FACTORY_ID
											,@EQUIPMENT_ID		-- 설비 ID
											,@EQUIPMENT_NAME	-- 설비 명
											,@BAS_KEY_ATTR1     -- 단위 공정(OPERATION_ID) ID
											,@MES_LINE_ID	    -- 라인
											,@MES_LINE_ID	    -- MES LINE
											,@WORK_CENTER_ID	-- WORK CENTER ID
											,@EQUIPMENT_TYPE	-- "설비 유형 - MAIN/SUB"
											-- 2016-10-19 임시 김춘동 시작
											-- ,@ELECTRODE_TYPE	-- 전극
											,CASE WHEN XXX.ELETRO_CHECK = 'Y' AND @ELECTRODE_TYPE = 'A' THEN
												 'Anode'
											 WHEN XXX.ELETRO_CHECK = 'Y' AND @ELECTRODE_TYPE = 'C' THEN
												 'Cathode'
											 ELSE
												 @ELECTRODE_TYPE
											 END
											-- 2016-10-19 임시 김춘동 끝
											,@USE_FLAG          -- 유효 여부 Y/N
											,'PR_XIF_MMD_ALL_R'
											,GETDATE()
											,'PR_XIF_MMD_ALL_R'
											,GETDATE()
											);

    							SET @v_count = @v_count + 1;

								-- 2022-07-12 kimcd 설비 정보 영향도 제거 시작
								-- 설비에 ERP W/C 정보 설정되면 라인 정보도 동기화
								IF @WORK_CENTER_ID IS NOT NULL 
									BEGIN
										UPDATE LM
										SET    [MES_LINE_ID]       = EM.[MES_LINE_ID]
											 , [WORK_CENTER_ID]    = CASE WHEN EM.[WORK_CENTER_ID] IS NOT NULL AND EM.[WORK_CENTER_ID] != '' THEN EM.[WORK_CENTER_ID] ELSE LM.[WORK_CENTER_ID] END
											 , [UPDATE_ID]         = 'PR_XIF_MMD_ALL_R'
											 , [UPDATE_TIME]       = GETDATE()
										FROM   [DBO].[SCM_EQUIPMENT_M] EM   WITH(NOLOCK)
											 , [DBO].[SCM_LINE_M]  LM
										WHERE  LM.[COMPANY_ID]     = EM.[COMPANY_ID]
										AND    LM.[DIVISION_ID]    = EM.[DIVISION_ID]
										AND    LM.[SITE_ID]        = EM.[SITE_ID]
										AND    LM.[PLANT_ID]       = EM.[PLANT_ID]
										AND    LM.[FACTORY_ID]     = EM.[FACTORY_ID]
										AND    LM.[OPERATION_ID]   = EM.[OPERATION_ID]
										AND    LM.[LINE_ID]        = EM.[LINE_ID]
										AND    LM.[ELECTRODE_TYPE] = ISNULL(EM.[ELECTRODE_TYPE],'-')
										AND    EM.[ACTIVE_FLAG]    = 'Y'
										AND    EM.[OPERATION_ID]  != '*'
										AND    EM.[EQUIPMENT_ID]   = @BAS_KEY_ATTR2;
									END;
								-- 2022-07-12 kimcd 설비 정보 영향도 제거 끝
							END;
						ELSE
							BEGIN
								DELETE A
								FROM   [DBO].[SCM_EQUIPMENT_M] A
								WHERE  A.[COMPANY_ID]   = @COMPANY_ID
								AND    A.[DIVISION_ID]  = @DIVISION_ID
								AND    A.[SITE_ID]      = @SITE_ID
								AND    A.[PLANT_ID]     = @PLANT_ID
								AND    A.[FACTORY_ID]   = @FACTORY_ID
								AND    A.[MES_LINE_ID]  = @MES_LINE_ID
								AND    A.[OPERATION_ID] = @BAS_KEY_ATTR1
								AND    A.[EQUIPMENT_ID] = @EQUIPMENT_ID
								-- kimcd modify start 2017-04-30
								AND    EXISTS ( SELECT 1
												FROM   [DBO].[SCM_EQUIPMENT_M] B
												WHERE  B.[COMPANY_ID]    = @COMPANY_ID
												AND    B.[DIVISION_ID]   = @DIVISION_ID
												AND    B.[SITE_ID]       = @SITE_ID
												AND    B.[PLANT_ID]      = @PLANT_ID
												AND    B.[FACTORY_ID]    = @FACTORY_ID
												AND    B.[MES_LINE_ID]   = @MES_LINE_ID
												AND    B.[OPERATION_ID] != @BAS_KEY_ATTR1
												AND    B.[EQUIPMENT_ID]  = @EQUIPMENT_ID
												);

								IF @@ROWCOUNT = 0
									UPDATE [DBO].[SCM_EQUIPMENT_M]
									SET    [OPERATION_ID] = '*'
										  ,[UPDATE_ID]    = 'PR_XIF_MMD_ALL_R'
										  ,[UPDATE_TIME]  = GETDATE()
									WHERE  [COMPANY_ID]   = @COMPANY_ID
									AND    [DIVISION_ID]  = @DIVISION_ID
									AND    [SITE_ID]      = @SITE_ID
									AND    [PLANT_ID]     = @PLANT_ID
									AND    [FACTORY_ID]   = @FACTORY_ID
									AND    [MES_LINE_ID]  = @MES_LINE_ID
									AND    [OPERATION_ID] = @BAS_KEY_ATTR1
									AND    [EQUIPMENT_ID] = @EQUIPMENT_ID;
								-- kimcd modify end 2017-04-30
							END; 

						-- PROCESS 입력용 EQUIPMENT CURSOR
						DECLARE C_OP_CHECK CURSOR FOR
						    SELECT A.[COMPANY_ID]
								 , A.[DIVISION_ID]
								 , A.[SITE_ID]
								 , A.[OPERATION_ID]
								 , A.[OPERATION_NAME]
								 , A.[ERP_OPERATION_ID]
								 , A.[OPERATION_GROUP_ID]
								 , A.[OPERATION_GROUP_NAME]
								 , A.[SHOP_GROUP_ID]
								 , A.[WO_FLAG]
								 , A.[MO_FLAG]
								 , A.[ACTIVE_FLAG]
								 , A.[INSTANCE_TYPE]
						    FROM   ( SELECT SEM.[COMPANY_ID]
											 , SEM.[DIVISION_ID]
											 , SEM.[SITE_ID]
											 , SEM.[OPERATION_ID]
											 , SOMI.[OPERATION_NAME]
											 , SOMI.[ERP_OPERATION_ID]
											 , SOMI.[OPERATION_GROUP_ID]
											 , SOMI.[OPERATION_GROUP_NAME]
											 , SOMI.[SHOP_GROUP_ID]
											 , SOMI.[WO_FLAG]
											 , SOMI.[MO_FLAG]
											 , SOMI.[ACTIVE_FLAG]
											 , SOMI.[INSTANCE_TYPE]
											 , ROW_NUMBER() OVER (ORDER BY SEM.[SITE_ID])   ROW_NUM
										FROM  [dbo].[SCM_OPERATION_M]  SOMI  WITH(NOLOCK)
											, [dbo].[SCM_EQUIPMENT_M]  SEM   WITH(NOLOCK)
										WHERE SEM.[COMPANY_ID]  = @COMPANY_ID
										AND   SEM.[DIVISION_ID] = @DIVISION_ID
										AND   SEM.[SITE_ID]     = @SITE_ID
										AND   SEM.[PLANT_ID]    = @PLANT_ID
										AND   SEM.[FACTORY_ID]  = @FACTORY_ID
										AND   SEM.[EQUIPMENT_ID]= @EQUIPMENT_ID
										AND   SEM.[OPERATION_ID]= @BAS_KEY_ATTR1 -- 공정
										AND   SOMI.[OPERATION_ID] = SEM.[OPERATION_ID]
										AND   NOT EXISTS ( SELECT 1
														   FROM   [dbo].[SCM_OPERATION_M]  SOM  WITH(NOLOCK)
									    				   WHERE  SOM.[COMPANY_ID]   = SEM.[COMPANY_ID]
														   AND    SOM.[DIVISION_ID]  = SEM.[DIVISION_ID]
														   AND    SOM.[SITE_ID]      = SEM.[SITE_ID]
														   AND    SOM.[OPERATION_ID] = SEM.[OPERATION_ID]
														   )
									) A
							WHERE  A.ROW_NUM = 1;

						SET @v_temp1 = 'STEP OPEN CURSOR C_OP_CHECK'
    					OPEN C_OP_CHECK
						FETCH NEXT FROM C_OP_CHECK INTO @COMPANY_ID
													  , @DIVISION_ID
													  , @SITE_ID
													  , @OPERATION_ID
													  , @OPERATION_NAME
													  , @ERP_OPERATION_ID
													  , @OPERATION_GROUP_ID
													  , @OPERATION_GROUP_NAME
													  , @SHOP_GROUP_ID
													  , @WO_FLAG
													  , @MO_FLAG
													  , @ACTIVE_FLAG
													  , @INSTANCE_TYPE


						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							SET @v_temp1 = 'STEP INSERT SCM_OPERATION_M AT PROCESSEQUIPMENT'
							INSERT INTO [DBO].[SCM_OPERATION_M]
								       ( [COMPANY_ID]              -- 회사 코드
										,[DIVISION_ID]             -- 사업부 코드
										,[SITE_ID]                 -- 지역 코드
										,[OPERATION_ID]            -- 단위 공정 ID
										,[OPERATION_NAME]          -- 단위 공정 명
										,[ERP_OPERATION_ID]        -- ERP 단위 공정
										,[OPERATION_GROUP_ID]      -- 공정 Group ID
										,[OPERATION_GROUP_NAME]    -- 공정 Group 명
										,[SHOP_GROUP_ID]           -- shop group id
										,[WO_FLAG]
										,[MO_FLAG]
										,[ACTIVE_FLAG]             -- 유효 여부
										,[INSTANCE_TYPE]           -- FP 엔진 instrance type
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
										)
							VALUES ( @COMPANY_ID
									,@DIVISION_ID
									,@SITE_ID
									,@OPERATION_ID         -- 공정 ID
									,@OPERATION_NAME       -- 공정명칭
									,@ERP_OPERATION_ID     -- ERP 공정 ID
									,@OPERATION_GROUP_ID   -- 공정 Group id
									,@OPERATION_GROUP_NAME -- 공정 group 명
									,@SHOP_GROUP_ID        -- shop group id
									,@WO_FLAG
									,@MO_FLAG
									,@ACTIVE_FLAG          -- 설비 사용여부
									,@INSTANCE_TYPE        -- [INSTANCE_TYPE]
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									);  

							FETCH NEXT FROM C_OP_CHECK INTO @COMPANY_ID
														  , @DIVISION_ID
														  , @SITE_ID
														  , @OPERATION_ID
														  , @OPERATION_NAME
														  , @ERP_OPERATION_ID
														  , @OPERATION_GROUP_ID
														  , @OPERATION_GROUP_NAME
														  , @SHOP_GROUP_ID
														  , @WO_FLAG
														  , @MO_FLAG
														  , @ACTIVE_FLAG
														  , @INSTANCE_TYPE
						END -- WHILE @@FETCH_STATUS = 0  C_OP_CHECK
						CLOSE C_OP_CHECK;
						DEALLOCATE C_OP_CHECK;   -- 메모리 해제

						FETCH NEXT FROM C_EQUIPMENT INTO @COMPANY_ID
														,@DIVISION_ID
														,@SITE_ID
														,@PLANT_ID
														,@FACTORY_ID
														,@EQUIPMENT_ID
														,@EQUIPMENT_NAME	-- 설비 명
														,@MES_LINE_ID	    -- 라인
														,@WORK_CENTER_ID	-- WORK CENTER ID
														,@EQUIPMENT_TYPE	-- "설비 유형 - MAIN/SUB"
														,@ELECTRODE_TYPE	-- 전극

					END -- WHILE @@FETCH_STATUS = 0  C_EQUIPMENT
					CLOSE C_EQUIPMENT;
			        DEALLOCATE C_EQUIPMENT;   -- 메모리 해제


                    IF @PROCESS_FLAG = 'Y'
                        BEGIN

							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'PROCESSEQUIPMENT'
							AND   [IF_SEQ]    = @IF_SEQ;


							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

							SET @SCM_LINE_CREATE = 'Y'  -- FP Line 추가 필요. Pack 공정에 Main 설비 표시

						END;
					ELSE

						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'PROCESSEQUIPMENT'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- IF @BAS_ITEM_ID = 'PROCESSEQUIPMENT'

            ELSE IF @BAS_ITEM_ID = 'EQUIPMENTSEGMENT'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

                    -- LINE 입력용 FACTORY CURSOR
                    DECLARE C_LINE_FACTORY CURSOR FOR
						SELECT SSM.[COMPANY_ID]
							 , SSM.[DIVISION_ID]
							 , SSM.[SITE_ID]
							 , SSM.[PLANT_ID]
							 , SSM.[FACTORY_ID]
						FROM   [dbo].[SCM_FACTORY_M]  SSM   WITH(NOLOCK)
						WHERE  SSM.[FACTORY_ID] = @BAS_KEY_ATTR2; -- AREA ID, FACTORY_ID

                    SET @v_temp1 = 'STEP OPEN CURSOR LINE SHOP'
    		        OPEN C_LINE_FACTORY
                    FETCH NEXT FROM C_LINE_FACTORY INTO @COMPANY_ID
													   ,@DIVISION_ID
                                                       ,@SITE_ID
												       ,@PLANT_ID
													   ,@FACTORY_ID
                    WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
                    BEGIN
					    SET @PROCESS_FLAG = 'Y'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_LINE_M'
                        MERGE INTO [DBO].[SCM_MMD_LINE_M] SLM
						USING ( SELECT @COMPANY_ID     AS COMPANY_ID
									  ,@DIVISION_ID    AS DIVISION_ID
									  ,@SITE_ID        AS SITE_ID
									  ,@PLANT_ID       AS PLANT_ID
									  ,@FACTORY_ID     AS FACTORY_ID
									  ,@BAS_KEY_ATTR1  AS LINE_ID
									  ,ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
											  ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
											 ) AS LINE_NAME ) XXX
						ON    (     SLM.[COMPANY_ID]   = XXX.COMPANY_ID
						        AND SLM.[DIVISION_ID]  = XXX.DIVISION_ID
								AND SLM.[SITE_ID]      = XXX.SITE_ID
								AND SLM.[PLANT_ID]     = XXX.PLANT_ID
								AND SLM.[FACTORY_ID]   = XXX.FACTORY_ID
								AND SLM.[LINE_ID] = XXX.LINE_ID )
						WHEN MATCHED THEN
							UPDATE SET SLM.LINE_NAME        = XXX.LINE_NAME     -- LINE DESCRIPTION
									  ,SLM.LINE_TYPE        = @BAS_KEY_ATTR3    -- [EQSGTYPE] 라인 유형
									  ,SLM.[DESCRIPTION]    = @BAS_ATTR2	    -- [EQSGDESC] 라인 설명
									  ,SLM.[ACTIVE_FLAG]    = @USE_FLAG         -- 유효 여부 Y/N
									  ,SLM.[MES_SOURCE_GROUP] = CASE WHEN @BAS_ATTR80 = '' THEN NULL ELSE @BAS_ATTR80 END     -- 2021-06-30 kimcd Interface 시스템 명 MES SOURCE GROUP 수신 추가
					    			  ,SLM.[UPDATE_ID]      = 'PR_XIF_MMD_ALL_R'
									  ,SLM.[UPDATE_TIME]    = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]	    -- 회사 코드
								   , [DIVISION_ID]	    -- 사업부 코드
								   , [SITE_ID]	        -- 지역 코드
								   , [PLANT_ID]	        -- 공장 코드
								   , [FACTORY_ID]	    -- 공장 동 코드
								   , [LINE_ID]	        -- LINE
								   , [LINE_NAME]        -- LINE 명
								   , [LINE_TYPE]        -- 라인 유형
								   , [DESCRIPTION]
								   , [ACTIVE_FLAG]	    -- "유효 여부- Y/N"
								   , [MES_SOURCE_GROUP] -- 2021-06-30 kimcd Interface 시스템 명 MES SOURCE GROUP 수신 추가
								   , [INSERT_ID]	    -- 등록자
								   , [INSERT_TIME]	    -- 등록일
								   , [UPDATE_ID]	    -- 수정자
								   , [UPDATE_TIME]	    -- 수정일
									)
							VALUES ( @COMPANY_ID
									,@DIVISION_ID
									,@SITE_ID
									,@PLANT_ID
									,@FACTORY_ID
									,@BAS_KEY_ATTR1      -- LINE ID
									,XXX.LINE_NAME       -- LINE 명
									,@BAS_KEY_ATTR3      -- [EQSGTYPE] 라인 유형
									,@BAS_ATTR2	         -- [EQSGDESC] 라인 설명
									,@USE_FLAG           -- 유효 여부 Y/N
									,@BAS_ATTR80         -- 2021-06-30 kimcd Interface 시스템 명 MES SOURCE GROUP 수신 추가
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									);
    					SET @v_count = @v_count + 1;

						-- 2017-12-04 kimcd MES 라인명 수신 과정 구성
						SET @v_temp1 = 'STEP UPDATE SCM_LINE_M - MES LINE NAME'
						UPDATE LM
						SET	   LM.[MES_LINE_NAME]    = ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
															  ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
															  )
							,  LM.[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
							-- ,  LM.[UPDATE_TIME] = GETDATE() 2022-08-26 kimcd 불필요한 갱신일자 제거
						FROM   [DBO].[SCM_LINE_M]      LM  WITH(NOLOCK)
						WHERE  LM.[COMPANY_ID]     = @COMPANY_ID
						AND    LM.[DIVISION_ID]    = @DIVISION_ID
						AND    LM.[SITE_ID]        = @SITE_ID
						AND    LM.[PLANT_ID]       = @PLANT_ID
						AND    LM.[FACTORY_ID]     = @FACTORY_ID
						AND    LM.[LINE_ID]        = @BAS_KEY_ATTR1;

                    FETCH NEXT FROM C_LINE_FACTORY INTO @COMPANY_ID
                                                       ,@DIVISION_ID
                                                       ,@SITE_ID
												       ,@PLANT_ID
											           ,@FACTORY_ID

					END -- WHILE @@FETCH_STATUS = 0  C_LINE_FACTORY
					CLOSE C_LINE_FACTORY;
			        DEALLOCATE C_LINE_FACTORY;   -- 메모리 해제

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'EQUIPMENTSEGMENT'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'EQUIPMENTSEGMENT'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- @BAS_ITEM_ID = 'EQUIPMENTSEGMENT'
            ELSE IF @BAS_ITEM_ID = 'PRODUCT'
			    BEGIN
				    SET @PROCESS_FLAG = 'Y'

					SET @v_temp1 = 'STEP UPDATE SCM_ITEM_M'
					UPDATE [DBO].[SCM_ITEM_M]
					SET    [DESCRIPTION] = @BAS_KEY_ATTR2
						  ,[NICK_NAME]   = ISNULL(@BAS_ATTR31,[NICK_NAME])
						  ,[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
						  ,[UPDATE_TIME] = GETDATE()
					WHERE  ITEM_ID = @BAS_KEY_ATTR1;

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    -- Lookup Table CURSOR
                    /*DECLARE C_LOOKUP_PRODUCT CURSOR FOR
						SELECT C.COMPANY_ID
							  ,C.DIVISION_ID
							  ,C.SITE_ID
							  ,C.PLANT_ID
							  ,B.SEGMENT1 AS FACTORY_ID
							FROM [DBO].[SCM_SYS_LOOKUP_TYPE_M] A  WITH(NOLOCK)
								,[DBO].[SCM_SYS_LOOKUP_VALUE] B   WITH(NOLOCK)
								,[DBO].[SCM_FACTORY_M] C          WITH(NOLOCK)
							WHERE A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
							  AND A.LOOKUP_TYPE_CODE = 'HALF_SLIT_FACTORY'
							  AND B.SEGMENT1         = C.FACTORY_ID;

                    SET @v_temp1 = 'STEP OPEN CURSOR LOOKUP PRODUCT'
    		        OPEN C_LOOKUP_PRODUCT
                    FETCH NEXT FROM C_LOOKUP_PRODUCT INTO @COMPANY_ID
														 ,@DIVISION_ID
														 ,@SITE_ID
														 ,@PLANT_ID
														 ,@FACTORY_ID

                    WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
                    BEGIN
					    SET @PROCESS_FLAG = 'Y'

					    SET @v_temp1 = 'STEP UPDATE SCM_CO_PRODUCT_M'
					    UPDATE [dbo].[SCM_CO_PRODUCT_M]
						SET	   [CO_PRODUCT_LANE] =  CAST(@BAS_ATTR35 AS NUMERIC(20,10))
				 			 , [LEFT_LANE]       =  CAST(@BAS_ATTR36 AS NUMERIC(20,10))
				 			 , [RIGHT_LANE]      =  CAST(@BAS_ATTR37 AS NUMERIC(20,10))
				 			 , [UPDATE_ID]       =  @V_PROC_NAME
				 			 , [UPDATE_TIME]     =  GETDATE()
						WHERE  [COMPANY_ID]  = @COMPANY_ID
						AND    [DIVISION_ID] = @DIVISION_ID
						AND    [SITE_ID]     = @SITE_ID
						AND    [PLANT_ID]    = @PLANT_ID
						AND    [FACTORY_ID]  = @FACTORY_ID
						AND    [ITEM_ID]     = @BAS_KEY_ATTR1;

						IF (@BAS_ATTR35 IS NOT NULL OR @BAS_ATTR36 IS NOT NULL OR @BAS_ATTR37 IS NOT NULL) 
						AND @@ROWCOUNT = 0
							SET @v_temp1 = 'STEP INSERT SCM_CO_PRODUCT_M'
							INSERT INTO [dbo].[SCM_CO_PRODUCT_M]
								([COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[ITEM_ID]
								,[CO_PRODUCT_LANE]
								,[LEFT_LANE]
								,[RIGHT_LANE]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
								)
				 			VALUES ( @COMPANY_ID 
									,@DIVISION_ID
									,@SITE_ID    
									,@PLANT_ID   
									,@FACTORY_ID 
									,@BAS_KEY_ATTR1	
									,CAST(@BAS_ATTR35 AS NUMERIC(20,10))
									,CAST(@BAS_ATTR36 AS NUMERIC(20,10))
									,CAST(@BAS_ATTR37 AS NUMERIC(20,10))
				 					,@v_proc_name
				 					,GETDATE()
				 					,@v_proc_name
				 					,GETDATE()
				 					);

   						SET @v_count = @v_count + 1;

						FETCH NEXT FROM C_LOOKUP_PRODUCT INTO @COMPANY_ID
															 ,@DIVISION_ID
															 ,@SITE_ID
															 ,@PLANT_ID
															 ,@FACTORY_ID
															;

					END -- WHILE @@FETCH_STATUS = 0  C_LOOKUP_PRODUCT
					CLOSE C_LOOKUP_PRODUCT;
			        DEALLOCATE C_LOOKUP_PRODUCT;   -- 메모리 해제*/

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'PRODUCT'
							AND   [IF_SEQ]      = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'PRODUCT'
						AND   [IF_SEQ]      = @IF_SEQ;

				END; -- IF @BAS_ITEM_ID = 'PRODUCT'
            ELSE IF @BAS_ITEM_ID = 'PROCESSSEGMENT'
			    BEGIN
				    IF @BAS_KEY_ATTR2 = 'PG' -- 2020-06-26 kimcd 양산 Group만 수신
						BEGIN
							SET @PROCESS_FLAG = 'N'

							SET @v_temp1 = 'STEP SCM_MMD_OPERATION_GROUP_M Insert, Update'

							-- scm_mmd_operation_group 테이블에 없으면 인서트 있으면 없데이트 한다.
							MERGE INTO [dbo].[SCM_MMD_OPERATION_GROUP_M] A
							USING ( 
									SELECT @BAS_KEY_ATTR1  AS OPERATION_GROUP_ID
										  ,ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
												  ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
												 ) AS OPERATION_GROUP_NAME ) B
							ON (      
									A.OPERATION_GROUP_ID  = B.OPERATION_GROUP_ID
								)
							WHEN MATCHED THEN
				 			UPDATE SET   A.OPERATION_GROUP_NAME =  B.OPERATION_GROUP_NAME
				 						,A.UPDATE_ID            =  @V_PROC_NAME
				 						,A.UPDATE_TIME          =  GETDATE()
												
				                 
							WHEN NOT MATCHED THEN
				 			INSERT (
									[OPERATION_GROUP_ID]
								   ,[OPERATION_GROUP_NAME]
								   ,[INSERT_ID]
								   ,[INSERT_TIME]
								   ,[UPDATE_ID]
								   ,[UPDATE_TIME]
									)
				 			VALUES (
				 					 @BAS_KEY_ATTR1 
									,B.OPERATION_GROUP_NAME
				 					,@v_proc_name
				 					,GETDATE()
				 					,@v_proc_name
				 					,GETDATE()
				 					)
							;

							SET @v_temp1 = 'STEP SCM_OPERATION_M Update'

							-- SCM_OPERATION_M 테이블의 OPERATION_GROUP_NAME 컬럼을 SHOP_GROUP_ID 조건으로 일괄 업데이트 한다.
							UPDATE [DBO].[SCM_OPERATION_M]
							SET [OPERATION_GROUP_NAME] = @BAS_ATTR2
				 			   ,[UPDATE_ID]            = @V_PROC_NAME        
				 			   ,[UPDATE_TIME]          = GETDATE()				
							WHERE [SHOP_GROUP_ID]      = @BAS_KEY_ATTR1
							;

							SET @PROCESS_FLAG = 'Y'

							IF @PROCESS_FLAG = 'Y'
								BEGIN
									UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
									SET [PROC_FLAG] = 'Y'
									   ,[UPDDTTM]   = GETDATE()
									WHERE [PROC_FLAG] = 'P'
									AND   [BAS_ITEM_ID] = 'PROCESSSEGMENT'
									AND   [IF_SEQ]      = @IF_SEQ;

									SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
									SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

									INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
										([IF_SEQ]             -- [nvarchar](50) NOT NULL,
										,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
										,[IF_ID]              -- [nvarchar](50) NOT NULL,
										,[IF_SND_DATE]        -- [datetime] NULL,
										,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
										,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										)
									VALUES
										(@send_if_seq
										,'R'
										,@if_id_code
										,GETDATE()
										,@IF_SEQ
										,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										);

								END;
							ELSE
								UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
								SET [PROC_FLAG] = 'N'
								   ,[UPDDTTM]   = GETDATE()
								WHERE [PROC_FLAG] = 'P'
								AND   [BAS_ITEM_ID] = 'PROCESSSEGMENT'
								AND   [IF_SEQ]      = @IF_SEQ;
						END; -- IF @BAS_KEY_ATTR2 = 'PG' -- 2020-06-26 kimcd 양산 Group만 수신
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'Y'
							,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'PROCESSSEGMENT'
						AND   [IF_SEQ]      = @IF_SEQ;  -- 2020-06-26 kimcd PG 양산용 Group이 아닌 경우 수신으로 처리
				END; -- IF @BAS_ITEM_ID = 'PROCESSSEGMENT'

            ELSE IF @BAS_ITEM_ID = 'PROCESSSEGMENTPROCESS'
			    BEGIN

					SET @v_temp1 = 'STEP SCM_OPERATION_M Update'

					-- SCM_OPERATION_M에 Operation이 존재하는 경우 OPERATION_GROUP_ID를 갱신한다
					-- Operation이 없는 경우 갱신하지 않고, I/F도 완료된 것으로 변경하지 않음
					SET @OPERATION_ID_CNT = 0
					SELECT @OPERATION_ID_CNT = COUNT(OPERATION_ID) 
					  FROM [DBO].[SCM_OPERATION_M]  A  WITH(NOLOCK)
					 WHERE OPERATION_ID = @BAS_KEY_ATTR2
					   AND EXISTS (SELECT 1 
					               FROM   [dbo].[SCM_MMD_OPERATION_GROUP_M] B
							       WHERE  B.OPERATION_GROUP_ID = @BAS_KEY_ATTR1); -- 2020-06-26 kimcd OPERATION GROUP이 수신된 경우만 갱신

					SET @PROCESS_FLAG = 'Y'
					-- Operation이 없는 경우 갱신하지 않고, I/F도 완료된 것으로 변경하지 않음
					IF (@OPERATION_ID_CNT) > 0
						BEGIN  

							-- SCM_OPERATION_M에 Operation이 존재하는 경우 OPERATION_GROUP_ID를 갱신한다
							-- OPERATION_GROUP_NAME도 갱신한다
							UPDATE [DBO].[SCM_OPERATION_M]
							SET [OPERATION_GROUP_ID]   = @BAS_KEY_ATTR1
							   ,[OPERATION_GROUP_NAME] = (SELECT OPERATION_GROUP_NAME FROM [DBO].[SCM_MMD_OPERATION_GROUP_M] WITH(NOLOCK) WHERE OPERATION_GROUP_ID = @BAS_KEY_ATTR1)
				 			   ,[UPDATE_ID]         = @V_PROC_NAME        
				 			   ,[UPDATE_TIME]       = GETDATE()				
							WHERE [OPERATION_ID]    = @BAS_KEY_ATTR2
							;

							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG]     = 'Y'
							   ,[UPDDTTM]       = GETDATE()
							WHERE [PROC_FLAG]   = 'P'
							  AND [BAS_ITEM_ID] = 'PROCESSSEGMENTPROCESS'
							  AND [BAS_KEY_ATTR1] = @BAS_KEY_ATTR1
							  AND [BAS_KEY_ATTR2] = @BAS_KEY_ATTR2
							  AND [IF_SEQ]        = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = CASE WHEN @IF_RCV_DATE < @MONTH_DATE THEN 'Y' ELSE 'N' END -- 2020-06-26 kimcd 한달이상 공정,공정군 없어서 수신 안 된 것은 수신 처리
							,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND [BAS_ITEM_ID] = 'PROCESSSEGMENTPROCESS'
						AND [BAS_KEY_ATTR1] = @BAS_KEY_ATTR1
						AND [BAS_KEY_ATTR2] = @BAS_KEY_ATTR2
						AND [IF_SEQ]        = @IF_SEQ;

				END; -- IF @BAS_ITEM_ID = 'PROCESSSEGMENTPROCESS'

            ELSE IF @BAS_ITEM_ID = 'TB_MMD_MDLLOT'
			    BEGIN

					SET @v_temp1 = 'STEP FP_MODEL_LOT_M Merge'

					-- Model Lot 정보저장    
					MERGE INTO [DBO].[FP_MODEL_LOT_M] A
					USING ( 
					        SELECT B.[COMPANY_ID]
							      ,B.[DIVISION_ID]
								  ,B.[SITE_ID]
								  ,B.[PLANT_ID]
								  ,B.[FACTORY_ID]
								  ,A.[BAS_KEY_ATTR2] AS MODEL_ID
								  --,ISNULL((SELECT ITEM_ID
							   --           FROM SCM_ITEM_M WITH(NOLOCK)
							   --           WHERE APPLIED_MODEL = A.[BAS_KEY_ATTR2]
							   --           AND ITEM_CLASS = 'ES1901'
										--  AND COMPANY_ID = B.[COMPANY_ID]
										--  AND DIVISION_ID = B.[DIVISION_ID]
										--  AND SITE_ID = B.[SITE_ID]
										--  AND COMPANY_ID = 'C100'
										--  )
										--  , A.[BAS_KEY_ATTR2] 
										--  ) AS MODEL_ID
								  ,A.[BAS_ATTR1]     AS MODEL_LOT
								  ,A.[USE_FLAG]      AS ACTIVE_FLAG
						      FROM 
								   (
									SELECT @BAS_ITEM_ID   AS BAS_ITEM_ID
										  ,@BAS_KEY_ATTR1 AS BAS_KEY_ATTR1
										  ,@BAS_KEY_ATTR2 AS BAS_KEY_ATTR2
										  ,@BAS_ATTR1     AS BAS_ATTR1
										  ,@USE_FLAG      AS USE_FLAG
								    ) A,
									(
									SELECT TOP 1
									       [COMPANY_ID]
										  ,[DIVISION_ID]
										  ,[SITE_ID]
										  ,[PLANT_ID]
										  ,[FACTORY_ID]
									  FROM [DBO].[SCM_FACTORY_M]  WITH(NOLOCK)
									 WHERE [FACTORY_ID] = @BAS_KEY_ATTR1
									) B
							  WHERE A.BAS_KEY_ATTR1 = B.FACTORY_ID
							
				 		  ) B
					ON (      
							A.COMPANY_ID  = B.COMPANY_ID
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.SITE_ID     = B.SITE_ID
						AND A.PLANT_ID    = B.PLANT_ID
						AND A.FACTORY_ID  = B.FACTORY_ID
						AND A.MODEL_ID    = B.MODEL_ID
						)
					WHEN MATCHED THEN
				 	UPDATE SET  A.ACTIVE_FLAG  = B.ACTIVE_FLAG
				 			   ,A.MODEL_LOT_ID = B.MODEL_LOT
				 			   ,A.UPDATE_ID    = @V_PROC_NAME        
				 			   ,A.UPDATE_TIME  = GETDATE()
												
				                 
					WHEN NOT MATCHED THEN
				 	INSERT (
						     [COMPANY_ID]
						    ,[DIVISION_ID]
						    ,[SITE_ID]
						    ,[PLANT_ID]
						    ,[FACTORY_ID]
						    ,[MODEL_ID]
						    ,[MODEL_LOT_ID]
						    ,[ACTIVE_FLAG]
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
							,B.MODEL_ID
							,B.MODEL_LOT
							,B.ACTIVE_FLAG  
				 		    ,@V_PROC_NAME
				 			,GETDATE()
				 			,@V_PROC_NAME
				 			,GETDATE()
				 			);

					SET @PROCESS_FLAG = 'Y'

					UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
					SET [PROC_FLAG] = 'Y'
					   ,[UPDDTTM]   = GETDATE()
					WHERE [PROC_FLAG]   = 'P'
					AND   [BAS_ITEM_ID] = 'TB_MMD_MDLLOT'
					AND   [IF_SEQ]      = @IF_SEQ;

					SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
					SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

					INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
						([IF_SEQ]             -- [nvarchar](50) NOT NULL,
						,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
						,[IF_ID]              -- [nvarchar](50) NOT NULL,
						,[IF_SND_DATE]        -- [datetime] NULL,
						,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
						,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						)
					VALUES
						(@send_if_seq
						,'R'
						,@if_id_code
						,GETDATE()
						,@IF_SEQ
						,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						);

				END; -- IF @BAS_ITEM_ID = 'TB_MMD_MDLLOT'

            ELSE IF @BAS_ITEM_ID = 'TB_MMD_EQPT_LOSS_CODE'
			    BEGIN
					SET @v_temp1 = 'STEP SCM_OFF_TYPE_M Merge'
					MERGE INTO [DBO].[SCM_OFF_TYPE_M] A
					USING ( SELECT  [COMPANY_ID]
									,'-'  			AS DIVISION_ID
									,'-'			AS SITE_ID
									,'-'			AS PLANT_ID
									,@BAS_KEY_ATTR1 AS OFF_TYPE_ID
									,ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
											,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) )
												    AS OFF_TYPE_NAME
									,@BAS_ATTR2     AS DESCRIPTION
									,@BAS_ATTR3     AS OFF_CATEGORY_ID
									,CASE WHEN @BAS_ATTR4 = '' THEN
											  NULL
										  ELSE
											  CAST(@BAS_ATTR4 AS NUMERIC(10,0))
										  END       AS SORT_ORDER
									,@BAS_ATTR5     AS DISP_COLR_CODE
									,@USE_FLAG      AS ACTIVE_FLAG
				 		    FROM   [DBO].[SCM_COMPANY_M] WITH(NOLOCK) ) B
					ON (      
							A.COMPANY_ID  = B.COMPANY_ID
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.SITE_ID     = B.SITE_ID
						AND A.PLANT_ID    = B.PLANT_ID
						AND A.OFF_TYPE_ID = B.OFF_TYPE_ID
						)
					WHEN MATCHED THEN
				 	UPDATE SET  A.OFF_TYPE_NAME   = B.OFF_TYPE_NAME
				 			   ,A.DESCRIPTION     = B.DESCRIPTION
							   ,A.OFF_CATEGORY_ID = B.OFF_CATEGORY_ID
							   ,A.SORT_ORDER      = B.SORT_ORDER
							   ,A.DISP_COLR_CODE  = B.DISP_COLR_CODE
							   ,A.ACTIVE_FLAG     = B.ACTIVE_FLAG
				 			   ,A.UPDATE_ID       = @V_PROC_NAME
				 			   ,A.UPDATE_TIME     = GETDATE()
					WHEN NOT MATCHED THEN
				 	INSERT ( [COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[OFF_CATEGORY_ID]
							,[OFF_TYPE_ID]
							,[OFF_TYPE_NAME]
							,[DESCRIPTION]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
							,[SORT_ORDER]
							,[DISP_COLR_CODE]
							,[ACTIVE_FLAG]
							)
				 	VALUES (
						    B.COMPANY_ID
						   ,B.DIVISION_ID
						   ,B.SITE_ID
						   ,B.PLANT_ID
						   ,B.OFF_CATEGORY_ID
						   ,B.OFF_TYPE_ID
						   ,B.OFF_TYPE_NAME
						   ,B.DESCRIPTION
						   ,@V_PROC_NAME
						   ,GETDATE()
						   ,@V_PROC_NAME
						   ,GETDATE()
						   ,B.SORT_ORDER
						   ,B.DISP_COLR_CODE
						   ,B.ACTIVE_FLAG
				 			);

					SET @v_temp1 = 'STEP SCM_OFF_CATEGORY_M Merge'
					INSERT INTO [DBO].[SCM_OFF_CATEGORY_M]
						( [COMPANY_ID]
						 ,[DIVISION_ID]
						 ,[SITE_ID]
						 ,[PLANT_ID]
						 ,[OFF_CATEGORY_ID]
						 ,[OFF_CATEGORY_NAME]
						 ,[DESCRIPTION]
						 ,[INSERT_ID]
						 ,[INSERT_TIME]
						 ,[UPDATE_ID]
						 ,[UPDATE_TIME] )
				 	SELECT DISTINCT
						   A.[COMPANY_ID]
						 , A.[DIVISION_ID]
						 , A.[SITE_ID]
						 , A.[PLANT_ID]
						 , A.[OFF_CATEGORY_ID]
						 , B.[VALUE_DESCRIPTION]
						 , B.[VALUE_DESCRIPTION]
						 , @V_PROC_NAME
						 , GETDATE()
						 , @V_PROC_NAME
						 , GETDATE()
					FROM   [DBO].[SCM_OFF_TYPE_M] A   WITH(NOLOCK)
						  ,[DBO].[SCM_SYS_LOOKUP_VALUE] B  WITH(NOLOCK)
					WHERE  A.[OFF_CATEGORY_ID]  = B.[SEGMENT1]
					AND    A.[OFF_TYPE_ID]      = @BAS_KEY_ATTR1
					AND    B.[LOOKUP_TYPE_CODE] = 'UPPER_LOSS_TYPE'
					AND    B.[ACTIVE_FLAG]      = 'Y'
					AND    NOT EXISTS ( SELECT 'X'
										FROM   [DBO].[SCM_OFF_CATEGORY_M] C  WITH(NOLOCK)
										WHERE  C.[COMPANY_ID]  = A.[COMPANY_ID]
										AND    C.[DIVISION_ID] = A.[DIVISION_ID]
										AND    C.[SITE_ID]     = A.[SITE_ID]
										AND    C.[PLANT_ID]    = A.[PLANT_ID]
										AND    C.[OFF_CATEGORY_ID] = A.[OFF_CATEGORY_ID] );

					UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
					SET [PROC_FLAG] = 'Y'
					   ,[UPDDTTM]   = GETDATE()
					WHERE [PROC_FLAG]   = 'P'
					AND   [BAS_ITEM_ID] = 'TB_MMD_EQPT_LOSS_CODE'
					AND   [IF_SEQ]      = @IF_SEQ;

					SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
					SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

					INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
						([IF_SEQ]             -- [nvarchar](50) NOT NULL,
						,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
						,[IF_ID]              -- [nvarchar](50) NOT NULL,
						,[IF_SND_DATE]        -- [datetime] NULL,
						,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
						,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						)
					VALUES
						(@send_if_seq
						,'R'
						,@if_id_code
						,GETDATE()
						,@IF_SEQ
						,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						);

				END; -- IF @BAS_ITEM_ID = 'TB_MMD_EQPT_LOSS_CODE'

            ELSE IF @BAS_ITEM_ID = 'ROUTEPATH'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					IF @USE_FLAG = 'Y'   -- 2017-09-28 KIMCD ADD. 사용할 경우 값 갱신.
						BEGIN
							-- CHECK OPERATION
							DECLARE C_CHECK_OPERATION CURSOR FOR
								SELECT DISTINCT 
									   PM.[COMPANY_ID]
									 , PM.[DIVISION_ID]
									 , PM.[SITE_ID]
								FROM   [dbo].[SCM_PLANT_M]     PM  WITH(NOLOCK)
								-- 2022-03-18 전체 Division 조건 제거 WHERE  ( ( @IF_SOURCE = 'OSC2' AND PM.DIVISION_ID IN ('42', '44') )
								-- 2022-03-18 전체 Division 조건 제거 		OR ( @IF_SOURCE = 'OSC1' AND PM.DIVISION_ID IN ('40', '81', '82') ) ); -- 2019-03-12 kimcd 전지 제한 42 display 재로, 44 전지 재료

							SET @v_temp1 = 'STEP OPEN CURSOR CHECK OPERATION'
    						OPEN C_CHECK_OPERATION
							FETCH NEXT FROM C_CHECK_OPERATION INTO @COMPANY_ID
																  ,@DIVISION_ID
																  ,@SITE_ID
							WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
							BEGIN
								SET @PROCESS_FLAG = 'Y'
								SET @ROUTEPATH_FLAG = 'Y'

								SET @v_temp1 = 'STEP MERGE SCM_MMD_ROUTEPATH_M'
								MERGE INTO [DBO].[SCM_MMD_ROUTEPATH_M] SMR
								USING ( SELECT @COMPANY_ID     AS COMPANY_ID
												,@DIVISION_ID    AS DIVISION_ID
												,@SITE_ID        AS SITE_ID
												,@BAS_KEY_ATTR1  AS ROUTID           -- 경로 ID
												,@BAS_KEY_ATTR2  AS FLOWID           -- 경로흐름 ID
												,ISNULL( (SELECT SSLV.[ATTRIBUTE1]
														FROM  [DBO].[SCM_SYS_LOOKUP_VALUE] SSLV
														WHERE SSLV.[LOOKUP_TYPE_CODE] = 'MMD_OPERATION_REPLACE'
														AND   SSLV.[ACTIVE_FLAG]      = 'Y'
														AND   SSLV.[SEGMENT1]         = @BAS_KEY_ATTR3 ),@BAS_KEY_ATTR3)  AS PROCID           -- 공정 ID
												,@BAS_KEY_ATTR4  AS FLOWID_TO        -- 다음 경로흐름 ID
												,ISNULL( (SELECT SSLV.[ATTRIBUTE1]
														FROM  [DBO].[SCM_SYS_LOOKUP_VALUE] SSLV
														WHERE SSLV.[LOOKUP_TYPE_CODE] = 'MMD_OPERATION_REPLACE'
														AND   SSLV.[ACTIVE_FLAG]      = 'Y'
														AND   SSLV.[SEGMENT1]         = @BAS_KEY_ATTR5 ),@BAS_KEY_ATTR5)  AS PROCID_TO        -- 다음 공정ID
												,@BAS_ATTR1      AS PATHTYPE         -- 경로유형
												,@BAS_ATTR2      AS CONNECT_POS      -- 연결 위치
												,@BAS_ATTR3      AS CONNECT_POS_TO   -- 다음 연결 위치
										) XXX
								ON    (     SMR.[COMPANY_ID]   = XXX.COMPANY_ID
										AND SMR.[DIVISION_ID]  = XXX.DIVISION_ID
										AND SMR.[SITE_ID]      = XXX.SITE_ID
										AND SMR.[ROUTID]       = XXX.ROUTID
										AND SMR.[FLOWID]       = XXX.FLOWID
										AND SMR.[PROCID]       = XXX.PROCID
										AND SMR.[FLOWID_TO]    = XXX.FLOWID_TO
										AND SMR.[PROCID_TO]    = XXX.PROCID_TO
										)
								WHEN MATCHED THEN
									UPDATE SET SMR.[PATHTYPE]       = XXX.PATHTYPE
												,SMR.[CONNECT_POS]    = XXX.CONNECT_POS
												,SMR.[CONNECT_POS_TO] = XXX.CONNECT_POS_TO
												,SMR.[REVISE_FLAG]    = 'Y'
												,SMR.[UPDATE_ID]      = @v_proc_name
												,SMR.[UPDATE_TIME]    = GETDATE()
								WHEN NOT MATCHED THEN
									INSERT ( [COMPANY_ID]	    -- 회사 코드
											, [DIVISION_ID]	    -- 사업부 코드
											, [SITE_ID]	        -- 지역 코드
											, [ROUTID]           -- 경로 ID
											, [FLOWID]           -- 경로흐름 ID
											, [PROCID]           -- 공정 ID
											, [FLOWID_TO]        -- 다음 경로흐름 ID
											, [PROCID_TO]        -- 다음 공정ID
											, [PATHTYPE]         -- 경로유형
											, [CONNECT_POS]      -- 연결 위치
											, [CONNECT_POS_TO]   -- 다음 연결 위치
											, [REVISE_FLAG]      -- OPERATION_FLOW 수정 대상
											, [INSERT_ID]	    -- 등록자
											, [INSERT_TIME]	    -- 등록일
											, [UPDATE_ID]	    -- 수정자
											, [UPDATE_TIME]	    -- 수정일
											)
									VALUES ( @COMPANY_ID
											,@DIVISION_ID
											,@SITE_ID
											,@BAS_KEY_ATTR1  -- 경로 ID
											,@BAS_KEY_ATTR2  -- 경로흐름 ID
											,XXX.PROCID    -- @BAS_KEY_ATTR3  -- 공정 ID
											,@BAS_KEY_ATTR4  -- 다음 경로흐름 ID
											,XXX.PROCID_TO -- @BAS_KEY_ATTR5  -- 다음 공정ID
											,@BAS_ATTR1      -- 경로유형
											,@BAS_ATTR2      -- 연결 위치
											,@BAS_ATTR3      -- 다음 연결 위치
											,'Y'             -- OPERATION_FLOW 수정 대상
											,@v_proc_name
											,GETDATE()
											,@v_proc_name
											,GETDATE()
											);
    							SET @v_count = @v_count + 1;

							FETCH NEXT FROM C_CHECK_OPERATION INTO @COMPANY_ID
																  ,@DIVISION_ID
																  ,@SITE_ID

							END -- WHILE @@FETCH_STATUS = 0  C_CHECK_OPERATION
							CLOSE C_CHECK_OPERATION;
							DEALLOCATE C_CHECK_OPERATION;   -- 메모리 해제
						END -- IF @USE_FLAG = 'Y' 인경우 과정 종료
					-- 2017-09-28 KIMCD 추가 시작 - DISABLE된 경우 로직 추가
					ELSE IF @USE_FLAG = 'N' -- 사용하지 않는 경우 삭제함.
						BEGIN
							SET @PROCESS_FLAG = 'Y'
							SET @ROUTEPATH_FLAG = 'Y'

							SET @v_temp1 = 'STEP DELETE SCM_MMD_ROUTEPATH_M'
							DELETE FROM SMR
							FROM  [DBO].[SCM_MMD_ROUTEPATH_M] SMR
								  ,( SELECT  @BAS_KEY_ATTR1  AS ROUTID           -- 경로 ID
											,@BAS_KEY_ATTR2  AS FLOWID           -- 경로흐름 ID
											,ISNULL( (SELECT SSLV.[ATTRIBUTE1]
													FROM  [DBO].[SCM_SYS_LOOKUP_VALUE] SSLV
													WHERE SSLV.[LOOKUP_TYPE_CODE] = 'MMD_OPERATION_REPLACE'
													AND   SSLV.[ACTIVE_FLAG]      = 'Y'
													AND   SSLV.[SEGMENT1]         = @BAS_KEY_ATTR3 ),@BAS_KEY_ATTR3)  AS PROCID           -- 공정 ID
											,@BAS_KEY_ATTR4  AS FLOWID_TO        -- 다음 경로흐름 ID
											,ISNULL( (SELECT SSLV.[ATTRIBUTE1]
													FROM  [DBO].[SCM_SYS_LOOKUP_VALUE] SSLV
													WHERE SSLV.[LOOKUP_TYPE_CODE] = 'MMD_OPERATION_REPLACE'
													AND   SSLV.[ACTIVE_FLAG]      = 'Y'
													AND   SSLV.[SEGMENT1]         = @BAS_KEY_ATTR5 ),@BAS_KEY_ATTR5)  AS PROCID_TO        -- 다음 공정ID
									) XXX
							WHERE SMR.[ROUTID]       = XXX.ROUTID
							AND   SMR.[FLOWID]       = XXX.FLOWID
							AND   SMR.[PROCID]       = XXX.PROCID
							AND   SMR.[FLOWID_TO]    = XXX.FLOWID_TO
							AND   SMR.[PROCID_TO]    = XXX.PROCID_TO
							-- 2022-03-18 전체 Division 조건 제거 AND  ( ( @IF_SOURCE = 'OSC2' AND SMR.DIVISION_ID IN ('42', '44') )
						    -- 2022-03-18 전체 Division 조건 제거      OR ( @IF_SOURCE = 'OSC1' AND SMR.DIVISION_ID IN ('40', '81', '82') ) ) -- 2019-03-12 kimcd 전지 제한 42 display 재로, 44 전지 재료

							SET @v_temp1 = 'STEP MARK SCM_MMD_ROUTEPATH_M AS RECREATE'
							UPDATE [DBO].[SCM_MMD_ROUTEPATH_M]
							SET    [REVISE_FLAG]    = 'Y'
									,[UPDATE_ID]      = @v_proc_name
									,[UPDATE_TIME]    = GETDATE()  
							WHERE [ROUTID]       = @BAS_KEY_ATTR1  -- 경로 ID
							AND   [FLOWID]       = @BAS_KEY_ATTR2  -- 경로흐름 ID
							AND   [FLOWID_TO]    = @BAS_KEY_ATTR4  -- 다음 경로흐름 ID
							-- 2022-03-18 전체 Division 조건 제거 AND  ( ( @IF_SOURCE = 'OSC2' AND DIVISION_ID IN ('42', '44') )
						    -- 2022-03-18 전체 Division 조건 제거      OR ( @IF_SOURCE = 'OSC1' AND DIVISION_ID IN ('40', '81', '82') ) ) -- 2019-03-12 kimcd 전지 제한 42 display 재로, 44 전지 재료

						END;
						-- 2017-09-28 KIMCD 추가 종료 - DISABLE된 경우 -- 삭제 과정 추가


                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'ROUTEPATH'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR) 

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'ROUTEPATH'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- @BAS_ITEM_ID = 'ROUTEPATH'
			ELSE IF @BAS_ITEM_ID = 'ROUTEFLOW'
			    BEGIN
					SET @v_temp1 = 'STEP SCM_MMD_ROUTEPATH_M DATA CHECK'
					SET @MMD_ROUTEPATH_CNT = 0
					SELECT @MMD_ROUTEPATH_CNT = COUNT(MR.[FLOWID]) 
					FROM   [DBO].[SCM_MMD_ROUTEPATH_M]  MR WITH(NOLOCK)
					WHERE  MR.[ROUTID]    = @BAS_KEY_ATTR1	-- [ROUTID] 생산경로 ID
					AND    MR.[FLOWID]    = @BAS_KEY_ATTR2	-- [FLOWID] 경로흐름 ID
					AND    MR.[FLOWID_TO] = @BAS_KEY_ATTR2	-- [FLOWID] 경로흐름 ID
					-- 2022-03-18 전체 Division 조건 제거 AND   ( ( @IF_SOURCE = 'OSC2' AND MR.DIVISION_ID IN ('42', '44') )
					-- 2022-03-18 전체 Division 조건 제거 	  OR ( @IF_SOURCE = 'OSC1' AND MR.DIVISION_ID IN ('40', '81', '82') ) ); -- 2019-03-12 kimcd 전지 제한 42 display 재로, 44 전지 재료

					SET @PROCESS_FLAG = 'Y'
					-- ROUTEPATH이 없는 경우 갱신하지 않고, I/F도 완료된 것으로 변경하지 않음
					IF (@MMD_ROUTEPATH_CNT) > 0
						BEGIN  
							SET @ROUTEPATH_FLAG = 'Y' -- ROUTE PATH 재형성하도록 FLAG 설정
							-- SCM_MMD_ROUTEPATH_M에 FLOWID가 존재하는 경우 SCM_MMD_ROUTEPATH_M를 갱신한다
							SET @v_temp1 = 'STEP SCM_MMD_ROUTEPATH_M UPDATE'
							UPDATE [DBO].[SCM_MMD_ROUTEPATH_M]
							SET	   [FLOWNORM]     = @BAS_ATTR4      -- [FLOWNORM] 경로흐름 정상설정 여부
								 , [REVISE_FLAG]  = 'Y'
				 				 , [UPDATE_ID]    = @V_PROC_NAME
				 				 , [UPDATE_TIME]  = GETDATE()
							WHERE  [ROUTID]    = @BAS_KEY_ATTR1	 -- [ROUTID] 생산경로 ID
							AND    [FLOWID]    = @BAS_KEY_ATTR2	 -- [FLOWID] 경로흐름 ID
							AND    [FLOWID_TO] = @BAS_KEY_ATTR2 -- [FLOWID] 경로흐름 ID
							-- 2022-03-18 전체 Division 조건 제거 AND    ( ( @IF_SOURCE = 'OSC2' AND DIVISION_ID IN ('42', '44') )
						    -- 2022-03-18 전체 Division 조건 제거        OR ( @IF_SOURCE = 'OSC1' AND DIVISION_ID IN ('40', '81', '82') ) ); -- 2019-03-12 kimcd 전지 제한 42 display 재로, 44 전지 재료

							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG]     = 'Y'
							   ,[UPDDTTM]       = GETDATE()
							WHERE [PROC_FLAG]   = 'P'
							  AND [BAS_ITEM_ID] = 'ROUTEFLOW'
							  AND [BAS_KEY_ATTR1] = @BAS_KEY_ATTR1
							  AND [BAS_KEY_ATTR2] = @BAS_KEY_ATTR2
							  AND [IF_SEQ]        = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = CASE WHEN @IF_RCV_DATE < @MONTH_DATE THEN 'Y' ELSE 'N' END -- 2020-06-26 kimcd 한달이상 Route 없어서 수신 안 된 것은 수신 처리
							,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND [BAS_ITEM_ID] = 'ROUTEFLOW'
						AND [BAS_KEY_ATTR1] = @BAS_KEY_ATTR1
						AND [BAS_KEY_ATTR2] = @BAS_KEY_ATTR2
						AND [IF_SEQ]        = @IF_SEQ;

				END; -- IF @BAS_ITEM_ID = 'ROUTEFLOW'
            ELSE IF @BAS_ITEM_ID = 'EQUIPMENTGROUP' 
			    BEGIN
					UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
					SET [PROC_FLAG] = 'Y'
						,[UPDDTTM]   = GETDATE()
					WHERE [PROC_FLAG]   = 'P'
					AND   [BAS_ITEM_ID] = 'EQUIPMENTGROUP'
					AND   [IF_SEQ]      = @IF_SEQ;

					SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
					SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR) 

					INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
						([IF_SEQ]             -- [nvarchar](50) NOT NULL,
						,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
						,[IF_ID]              -- [nvarchar](50) NOT NULL,
						,[IF_SND_DATE]        -- [datetime] NULL,
						,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
						,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						)
					VALUES
						(@send_if_seq
						,'R'
						,@if_id_code
						,GETDATE()
						,@IF_SEQ
						,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						);
			    END;  -- IF @BAS_ITEM_ID = 'EQUIPMENTGROUP'
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_EQPT_PRDT_ST'
			    BEGIN
					SET @PROCESS_FLAG = 'Y'

					SET @v_temp1 = 'STEP MERGE SCM_MMD_EQPT_PRDT_ST_M'
                    MERGE INTO [DBO].[SCM_MMD_EQPT_PRDT_ST_M] MES
					USING ( SELECT @BAS_KEY_ATTR1  AS EQUIPMENT_ID     -- 설비 ID
								 , @BAS_KEY_ATTR2  AS ITEM_ID          -- 품목 ID
								 , CAST(CASE WHEN @BAS_ATTR1 = '' THEN NULL ELSE @BAS_ATTR1 END AS NUMERIC(10,2))     AS MES_ST           -- MES 관리 ST
								 , CAST(CASE WHEN @BAS_ATTR2 = '' THEN NULL ELSE @BAS_ATTR2 END AS NUMERIC(10,2))     AS RMS_ST           -- RMS 표준 ST
								 , CAST(CASE WHEN @BAS_ATTR3 = '' THEN NULL ELSE @BAS_ATTR3 END AS NUMERIC(10,2))     AS CALC_ST          -- DW 통계 ST
								 , @USE_FLAG       AS ACTIVE_FLAG
							) XXX
					ON    (     MES.[EQUIPMENT_ID] = XXX.EQUIPMENT_ID
						    AND MES.[ITEM_ID]      = XXX.ITEM_ID
							)
					WHEN MATCHED THEN
						UPDATE SET MES.[MES_ST]      = XXX.MES_ST
							      ,MES.[RMS_ST]      = XXX.RMS_ST
							      ,MES.[CALC_ST]     = XXX.CALC_ST
								  ,MES.[ACTIVE_FLAG] = XXX.ACTIVE_FLAG
								  ,MES.[UPDATE_ID]   = @v_proc_name
								  ,MES.[UPDATE_TIME] = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (  [EQUIPMENT_ID]    -- 설비 ID
								, [ITEM_ID]         -- 반제품 코드
								, [MES_ST]          -- MES에서 사용하는 ST. 생산팀 관리
								, [RMS_ST]          -- RMS상의 설계 ST
								, [CALC_ST]         -- 실적 기반으로 DW 통계 ST
								, [ACTIVE_FLAG]     -- 유효 여부 - Y/N
								, [INSERT_ID]	    -- 등록자
								, [INSERT_TIME]	    -- 등록일
								, [UPDATE_ID]	    -- 수정자
								, [UPDATE_TIME]	    -- 수정일
								)
						VALUES ( XXX.EQUIPMENT_ID
								,XXX.ITEM_ID
								,XXX.MES_ST
								,XXX.RMS_ST
								,XXX.CALC_ST
								,XXX.ACTIVE_FLAG
								,@v_proc_name
								,GETDATE()
								,@v_proc_name
								,GETDATE()
								);
    				SET @v_count = @v_count + 1;

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_EQPT_PRDT_ST'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR) 

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_EQPT_PRDT_ST'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- @BAS_ITEM_ID = 'TB_MMD_EQPT_PRDT_ST'
			ELSE IF @BAS_ITEM_ID = 'AREA' -- 2017-01-26 추가
			    BEGIN
				    SET @PROCESS_FLAG = 'Y'

					SET @v_temp1 = 'STEP UPDATE SCM_FACTORY_M'
					UPDATE [DBO].[SCM_FACTORY_M]
					SET    [MES_SOURCE_GROUP] = @BAS_ATTR38
						  ,[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
						  ,[UPDATE_TIME] = GETDATE()
					WHERE  FACTORY_ID = @BAS_KEY_ATTR1;

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'AREA'
							AND   [IF_SEQ]      = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);

						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'AREA'
						AND   [IF_SEQ]      = @IF_SEQ;
				END; -- IF @BAS_ITEM_ID = 'AREA'
			-- 2018-07-11 kimcd 라인 공정별 창고, 출하 이동 단위 수신 추가 시작
			ELSE IF @BAS_ITEM_ID = 'PROCESSEQUIPMENTSEGMENT' 
			    BEGIN
				    SET @PROCESS_FLAG = 'N'
					SET @ERP_OPERATION_ID = NULL;

                    SET @v_temp1 = 'STEP UPDATE SCM_LINE_M SLOC 1'
                    UPDATE LM
					SET    LM.DOMESTIC_SLOC_ID = @BAS_ATTR17
						  ,LM.EXPORT_SLOC_ID   = @BAS_ATTR18
						  ,LM.COMP_DOMESTIC_SLOC_ID = @BAS_KEY_ATTR4 -- 2019-09-25 kimcd  완성 내수 창고
						  ,LM.COMP_EXPORT_SLOC_ID   = @BAS_ATTR4     -- 2019-09-25 kimcd  완성 수출 창고
						  ,LM.UPDATE_ID        = @v_proc_name
						  --,LM.[UPDATE_TIME] = GETDATE() 2022-08-26 kimcd 불필요한 갱신일자 제거
					FROM   DBO.SCM_LINE_M       LM
					WHERE  LM.PLANT_ID       = @BAS_KEY_ATTR3
					AND    LM.LINE_ID        = @BAS_KEY_ATTR2
					AND    LM.OPERATION_ID   = @BAS_KEY_ATTR1
					AND    @USE_FLAG         = 'Y'

                    SET @v_temp1 = 'STEP UPDATE SCM_LINE_M SLOC 2'
                    UPDATE LM
					SET    LM.DOMESTIC_SLOC_ID = @BAS_ATTR17
						  ,LM.EXPORT_SLOC_ID   = @BAS_ATTR18
						  ,LM.COMP_DOMESTIC_SLOC_ID = @BAS_KEY_ATTR4 -- 2019-09-25 kimcd  완성 내수 창고
						  ,LM.COMP_EXPORT_SLOC_ID   = @BAS_ATTR4     -- 2019-09-25 kimcd  완성 수출 창고
						  ,LM.UPDATE_ID        = @v_proc_name
						  --,LM.[UPDATE_TIME] = GETDATE() 2022-08-26 kimcd 불필요한 갱신일자 제거
					FROM   DBO.SCM_LINE_M       LM
						  ,DBO.SCM_EQUIPMENT_M  EM WITH(NOLOCK)
					WHERE  LM.COMPANY_ID     = EM.COMPANY_ID
					AND    LM.DIVISION_ID    = EM.DIVISION_ID
					AND    LM.SITE_ID        = EM.SITE_ID
					AND    LM.PLANT_ID       = EM.PLANT_ID
					AND    LM.FACTORY_ID     = EM.FACTORY_ID
					AND    LM.OPERATION_ID   = EM.OPERATION_ID
					AND    LM.LINE_ID        = EM.LINE_ID
					AND    LM.ELECTRODE_TYPE = ISNULL(EM.ELECTRODE_TYPE, '-')
					AND    EM.PLANT_ID       = @BAS_KEY_ATTR3
					AND    EM.MES_LINE_ID    = @BAS_KEY_ATTR2
					AND    EM.OPERATION_ID   = @BAS_KEY_ATTR1
					AND    @USE_FLAG         = 'Y'

					-- SET @v_count = @v_count + @@ROWCOUNT; 2019-01-07 kimcd record count에 값을 넣으면 1로 인식되어 아래 process_flag 설정 로직에서 로직 오류 발생

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

					SELECT TOP 1 @ERP_OPERATION_ID = LV.[ATTRIBUTE2]
					FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  LV  WITH(NOLOCK)
					WHERE  LV.[LOOKUP_TYPE_CODE] = 'FP_OPERATION'
					AND    LV.[SEGMENT1]         = @BAS_KEY_ATTR1
					AND    LV.[ACTIVE_FLAG]      = 'Y';

                    IF @PROCESS_FLAG = 'Y' OR @ERP_OPERATION_ID IS NULL OR ISNULL(@USE_FLAG, 'N') = 'N' OR @IF_RCV_DATE < @MONTH_DATE -- 2020-06-26 kimcd 한달이상 라인,설비 없어서 수신 안 된 것은 수신 처리
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG]   = 'P'
							AND   [BAS_ITEM_ID] = 'PROCESSEQUIPMENTSEGMENT'
							AND   [IF_SEQ]      = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'N'
								,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'PROCESSEQUIPMENTSEGMENT'
							AND   [IF_SEQ]    = @IF_SEQ;
						END;
			    END;  -- IF @BAS_ITEM_ID = 'PROCESSEQUIPMENTSEGMENT'
			ELSE IF @BAS_ITEM_ID = 'TB_MMD_SHIPTO_PACK_COND_AUTO' 
			    BEGIN
				    SET @PROCESS_FLAG = 'N'
                    SET @v_temp1 = 'STEP MERGE SCM_SHIPTO_PACK_COND_M'
					MERGE INTO [DBO].[SCM_SHIPTO_PACK_COND_M] SPC
					USING ( SELECT B.DIVISION_ID
								  ,A.LINE_ID                -- 설비세그먼트아이디
								  ,A.ITEM_ID                -- 제품아이디
								  ,A.SHIPTO_ID              -- 출하처 아이디
								  ,A.PACK_TYPE              -- 포장 유형
								  ,A.PACK_VER               -- 포장 버전
								  ,A.CHRT_INSP_FLAG         -- 특성 검사 여부
								  ,A.BCD_2D_INSP_FLAG       -- 바코드 2D 검사 여부
								  ,A.PRDT_INSP_FLAG         -- 제품 검사 여부
								  ,A.TRAY_CELL_QTY          -- 트레이 셀 수량
								  ,A.TRAY_LAYER_QTY         -- 트레이 단 수량
								  ,A.BOX_TOTL_CELL_QTY      -- 박스 전체 셀 수량
								  ,A.OCV2_ELPS_DAYS         -- OCV2 경과 일수
								  ,A.USE_FLAG               -- 사용여부
							FROM   ( SELECT  ISNULL(@BAS_KEY_ATTR1,'-')	AS LINE_ID                -- 설비세그먼트아이디
											,@BAS_KEY_ATTR2	            AS ITEM_ID                -- 제품아이디
											,ISNULL(@BAS_ATTR1,'-')     AS SHIPTO_ID              -- 출하처 아이디
											,'-'					    AS PACK_TYPE              -- 포장 유형
											,'-'					    AS PACK_VER               -- 포장 버전
											,@BAS_ATTR2				    AS CHRT_INSP_FLAG         -- 특성 검사 여부
											,@BAS_ATTR3				    AS BCD_2D_INSP_FLAG       -- 바코드 2D 검사 여부
											,@BAS_ATTR4				    AS PRDT_INSP_FLAG         -- 제품 검사 여부
											,CASE WHEN ISNUMERIC(@BAS_ATTR5) = 1 THEN @BAS_ATTR5 ELSE NULL END	AS TRAY_CELL_QTY          -- 트레이 셀 수량
											,CASE WHEN ISNUMERIC(@BAS_ATTR6) = 1 THEN @BAS_ATTR6 ELSE NULL END  AS TRAY_LAYER_QTY         -- 트레이 단 수량
											,CASE WHEN ISNUMERIC(@BAS_ATTR7) = 1 THEN @BAS_ATTR7 ELSE NULL END  AS BOX_TOTL_CELL_QTY      -- 박스 전체 셀 수량
											,CASE WHEN ISNUMERIC(@BAS_ATTR8) = 1 THEN @BAS_ATTR8 ELSE NULL END  AS OCV2_ELPS_DAYS         -- OCV2 경과 일수
											,@USE_FLAG				    AS USE_FLAG               -- 사용여부
											) A,
									(SELECT '81' AS DIVISION_ID UNION ALL
									 SELECT '82' AS DIVISION_ID ) B
						) XXX
					ON    ( SPC.[DIVISION_ID]   = XXX.[DIVISION_ID]
							AND SPC.[LINE_ID]   = XXX.[LINE_ID]    -- 설비세그먼트아이디
							AND SPC.[ITEM_ID]   = XXX.[ITEM_ID]    -- 제품아이디
							AND SPC.[SHIPTO_ID] = XXX.[SHIPTO_ID]  -- 출하처 아이디
							AND SPC.[PACK_TYPE] = XXX.[PACK_TYPE]  -- 포장 유형
							AND SPC.[PACK_VER]  = XXX.[PACK_VER]   -- 포장 버전
							)
					WHEN MATCHED THEN
						UPDATE SET   SPC.[CHRT_INSP_FLAG]    = XXX.[CHRT_INSP_FLAG]          -- 특성 검사 여부
									,SPC.[BCD_2D_INSP_FLAG]  = XXX.[BCD_2D_INSP_FLAG]        -- 바코드 2D 검사 여부
									,SPC.[PRDT_INSP_FLAG]    = XXX.[PRDT_INSP_FLAG]          -- 제품 검사 여부
									,SPC.[TRAY_CELL_QTY]     = XXX.[TRAY_CELL_QTY]           -- 트레이 셀 수량
									,SPC.[TRAY_LAYER_QTY]    = XXX.[TRAY_LAYER_QTY]          -- 트레이 단 수량
									,SPC.[BOX_TOTL_CELL_QTY] = XXX.[BOX_TOTL_CELL_QTY]       -- 박스 전체 셀 수량
									,SPC.[OCV2_ELPS_DAYS]    = XXX.[OCV2_ELPS_DAYS]          -- OCV2 경과 일수
									,SPC.[USE_FLAG]          = XXX.[USE_FLAG]                -- 사용여부
									,SPC.[UPDATE_ID]         = @v_proc_name
									,SPC.[UPDATE_TIME]       = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (  [DIVISION_ID]
								, [LINE_ID]            -- 설비세그먼트아이디
								, [ITEM_ID]            -- 제품아이디
								, [SHIPTO_ID]          -- 출하처 아이디
								, [PACK_TYPE]          -- 포장 유형
								, [PACK_VER]           -- 포장 버전
								, [CHRT_INSP_FLAG]     -- 특성 검사 여부
								, [BCD_2D_INSP_FLAG]   -- 바코드 2D 검사 여부
								, [PRDT_INSP_FLAG]     -- 제품 검사 여부
								, [TRAY_CELL_QTY]      -- 트레이 셀 수량
								, [TRAY_LAYER_QTY]     -- 트레이 단 수량
								, [BOX_TOTL_CELL_QTY]  -- 박스 전체 셀 수량
								, [OCV2_ELPS_DAYS]     -- OCV2 경과 일수
								, [USE_FLAG]           -- 사용여부
								, [INSERT_ID]	       -- 등록자
								, [INSERT_TIME]	       -- 등록일
								, [UPDATE_ID]	       -- 수정자
								, [UPDATE_TIME]	       -- 수정일
								)
						VALUES (  XXX.[DIVISION_ID]
								, XXX.[LINE_ID]            -- 설비세그먼트아이디
								, XXX.[ITEM_ID]            -- 제품아이디
								, XXX.[SHIPTO_ID]          -- 출하처 아이디
								, XXX.[PACK_TYPE]          -- 포장 유형
								, XXX.[PACK_VER]           -- 포장 버전
								, XXX.[CHRT_INSP_FLAG]     -- 특성 검사 여부
								, XXX.[BCD_2D_INSP_FLAG]   -- 바코드 2D 검사 여부
								, XXX.[PRDT_INSP_FLAG]     -- 제품 검사 여부
								, XXX.[TRAY_CELL_QTY]      -- 트레이 셀 수량
								, XXX.[TRAY_LAYER_QTY]     -- 트레이 단 수량
								, XXX.[BOX_TOTL_CELL_QTY]  -- 박스 전체 셀 수량
								, XXX.[OCV2_ELPS_DAYS]     -- OCV2 경과 일수
								, XXX.[USE_FLAG]           -- 사용여부
								, @v_proc_name
								, GETDATE()
								, @v_proc_name
								, GETDATE()
								);


                    SET @v_count = @v_count + @@ROWCOUNT;

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

					IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG]   = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_SHIPTO_PACK_COND_AUTO'
							AND   [IF_SEQ]      = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'N'
								,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_SHIPTO_PACK_COND_AUTO'
							AND   [IF_SEQ]    = @IF_SEQ;
						END;
			    END;  -- IF @BAS_ITEM_ID = 'TB_MMD_SHIPTO_PACK_COND_AUTO'
			ELSE IF @BAS_ITEM_ID = 'TB_MMD_SHIPTO_PACK_COND_MOBILE' 
			    BEGIN
				    SET @PROCESS_FLAG = 'N'
                    SET @v_temp1 = 'STEP MERGE SCM_SHIPTO_PACK_COND_M2'
					MERGE INTO [DBO].[SCM_SHIPTO_PACK_COND_M] SPC
					USING ( SELECT '40'                        AS DIVISION_ID
					              ,'-'                         AS LINE_ID                     -- 설비세그먼트아이디
                                  ,@BAS_KEY_ATTR2              AS ITEM_ID                     -- 제품아이디
					              ,ISNULL(@BAS_KEY_ATTR1,'-')  AS SHIPTO_ID                   -- 출하처 아이디
                                  ,ISNULL(@BAS_KEY_ATTR3,'-')  AS PACK_TYPE                   -- 포장 유형
                                  ,ISNULL(@BAS_KEY_ATTR4,'-')  AS PACK_VER                    -- 포장 버전
                                  ,@BAS_ATTR1                  AS PACK_DESC                   -- 포장 설명
                                  ,SUBSTRING(@BAS_ATTR2,1,1)   AS LOT_MIX_FLAG                -- LOT 혼입 여부 2018-09-26 kimcd 자리수 짤림 보완
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR3) = 1  THEN @BAS_ATTR3  ELSE NULL END AS BOX_TOTL_CELL_QTY           -- 박스 전체 셀 수량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR4) = 1  THEN @BAS_ATTR4  ELSE NULL END AS TRAY_CELL_QTY               -- 트레이 셀 수량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR5) = 1  THEN @BAS_ATTR5  ELSE NULL END AS TRAY_LAYER_QTY              -- 트레이 단 수량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR6) = 1  THEN @BAS_ATTR6  ELSE NULL END AS PLLT_BOX_QTY                -- 팔레트 박스 수량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR7) = 1  THEN @BAS_ATTR7  ELSE NULL END AS TRAY_NET_WEIGHT             -- 트레이 순 중량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR8) = 1  THEN @BAS_ATTR8  ELSE NULL END AS BOX_NET_WEIGHT              -- 박스 순 중량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR9) = 1  THEN @BAS_ATTR9  ELSE NULL END AS CELL_NET_WEIGHT             -- 셀 순 중량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR10) = 1 THEN @BAS_ATTR10 ELSE NULL END AS VLTG                        -- 전압
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR11) = 1 THEN @BAS_ATTR11 ELSE NULL END AS CAPA                        -- 용량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR12) = 1 THEN @BAS_ATTR12 ELSE NULL END AS OUTER_BOX_AIR_SHIP_QTY      -- 외부 박스 항공 출하 수량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR13) = 1 THEN @BAS_ATTR13 ELSE NULL END AS OUTER_BOX_AIR_EXPR_QTY      -- 외부 박스 항공 특송 수량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR14) = 1 THEN @BAS_ATTR14 ELSE NULL END AS INNER_BOX_QTY               -- 내부 박스 수량
                                  ,CASE WHEN ISNUMERIC(@BAS_ATTR15) = 1 THEN @BAS_ATTR15 ELSE NULL END AS INNER_BOX_NONE_SLIPSHT_QTY  -- 내부 박스 NONE 간지 수량
                                  ,@USE_FLAG                   AS USE_FLAG                    -- 사용 여부
						) XXX
					ON    ( SPC.[DIVISION_ID]   = XXX.[DIVISION_ID]
							AND SPC.[LINE_ID]   = XXX.[LINE_ID]      -- 설비세그먼트아이디
							AND SPC.[ITEM_ID]   = XXX.[ITEM_ID]      -- 제품아이디
							AND SPC.[SHIPTO_ID] = XXX.[SHIPTO_ID]    -- 출하처 아이디
							AND SPC.[PACK_TYPE] = XXX.[PACK_TYPE]    -- 포장 유형
							AND SPC.[PACK_VER]  = XXX.[PACK_VER]     -- 포장 버전
							)
					WHEN MATCHED THEN
						UPDATE SET   SPC.[PACK_DESC]                  = XXX.[PACK_DESC]                  -- 포장 설명
									,SPC.[LOT_MIX_FLAG]               = XXX.[LOT_MIX_FLAG]               -- LOT 혼입 여부
									,SPC.[BOX_TOTL_CELL_QTY]          = XXX.[BOX_TOTL_CELL_QTY]          -- 박스 전체 셀 수량
									,SPC.[TRAY_CELL_QTY]              = XXX.[TRAY_CELL_QTY]              -- 트레이 셀 수량
									,SPC.[TRAY_LAYER_QTY]             = XXX.[TRAY_LAYER_QTY]             -- 트레이 단 수량
									,SPC.[PLLT_BOX_QTY]               = XXX.[PLLT_BOX_QTY]               -- 팔레트 박스 수량
									,SPC.[TRAY_NET_WEIGHT]            = XXX.[TRAY_NET_WEIGHT]            -- 트레이 순 중량
									,SPC.[BOX_NET_WEIGHT]             = XXX.[BOX_NET_WEIGHT]             -- 박스 순 중량
									,SPC.[CELL_NET_WEIGHT]            = XXX.[CELL_NET_WEIGHT]            -- 셀 순 중량
									,SPC.[VLTG]                       = XXX.[VLTG]                       -- 전압
									,SPC.[CAPA]                       = XXX.[CAPA]                       -- 용량
									,SPC.[OUTER_BOX_AIR_SHIP_QTY]     = XXX.[OUTER_BOX_AIR_SHIP_QTY]     -- 외부 박스 항공 출하 수량
									,SPC.[OUTER_BOX_AIR_EXPR_QTY]     = XXX.[OUTER_BOX_AIR_EXPR_QTY]     -- 외부 박스 항공 특송 수량
									,SPC.[INNER_BOX_QTY]              = XXX.[INNER_BOX_QTY]              -- 내부 박스 수량
									,SPC.[INNER_BOX_NONE_SLIPSHT_QTY] = XXX.[INNER_BOX_NONE_SLIPSHT_QTY] -- 내부 박스 NONE 간지 수량
									,SPC.[USE_FLAG]                   = XXX.[USE_FLAG]                   -- 사용 여부
									,SPC.[UPDATE_ID]                  = @v_proc_name
									,SPC.[UPDATE_TIME]                = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (  [DIVISION_ID]
					            , [LINE_ID]                     -- 설비세그먼트아이디
                                , [ITEM_ID]                     -- 제품아이디
					            , [SHIPTO_ID]                   -- 출하처 아이디
                                , [PACK_TYPE]                   -- 포장 유형
                                , [PACK_VER]                    -- 포장 버전
                                , [PACK_DESC]                   -- 포장 설명
                                , [LOT_MIX_FLAG]                -- LOT 혼입 여부
                                , [BOX_TOTL_CELL_QTY]           -- 박스 전체 셀 수량
                                , [TRAY_CELL_QTY]               -- 트레이 셀 수량
                                , [TRAY_LAYER_QTY]              -- 트레이 단 수량
                                , [PLLT_BOX_QTY]                -- 팔레트 박스 수량
                                , [TRAY_NET_WEIGHT]             -- 트레이 순 중량
                                , [BOX_NET_WEIGHT]              -- 박스 순 중량
                                , [CELL_NET_WEIGHT]             -- 셀 순 중량
                                , [VLTG]                        -- 전압
                                , [CAPA]                        -- 용량
                                , [OUTER_BOX_AIR_SHIP_QTY]      -- 외부 박스 항공 출하 수량
                                , [OUTER_BOX_AIR_EXPR_QTY]      -- 외부 박스 항공 특송 수량
                                , [INNER_BOX_QTY]               -- 내부 박스 수량
                                , [INNER_BOX_NONE_SLIPSHT_QTY]  -- 내부 박스 NONE 간지 수량
                                , [USE_FLAG]                    -- 사용 여부
								, [INSERT_ID]	                -- 등록자
								, [INSERT_TIME]	                -- 등록일
								, [UPDATE_ID]	                -- 수정자
								, [UPDATE_TIME]	                -- 수정일
								)
						VALUES (  XXX.[DIVISION_ID]
					            , XXX.[LINE_ID]                     -- 설비세그먼트아이디
                                , XXX.[ITEM_ID]                     -- 제품아이디
					            , XXX.[SHIPTO_ID]                   -- 출하처 아이디
                                , XXX.[PACK_TYPE]                   -- 포장 유형
                                , XXX.[PACK_VER]                    -- 포장 버전
                                , XXX.[PACK_DESC]                   -- 포장 설명
                                , XXX.[LOT_MIX_FLAG]                -- LOT 혼입 여부
                                , XXX.[BOX_TOTL_CELL_QTY]           -- 박스 전체 셀 수량
                                , XXX.[TRAY_CELL_QTY]               -- 트레이 셀 수량
                                , XXX.[TRAY_LAYER_QTY]              -- 트레이 단 수량
                                , XXX.[PLLT_BOX_QTY]                -- 팔레트 박스 수량
                                , XXX.[TRAY_NET_WEIGHT]             -- 트레이 순 중량
                                , XXX.[BOX_NET_WEIGHT]              -- 박스 순 중량
                                , XXX.[CELL_NET_WEIGHT]             -- 셀 순 중량
                                , XXX.[VLTG]                        -- 전압
                                , XXX.[CAPA]                        -- 용량
                                , XXX.[OUTER_BOX_AIR_SHIP_QTY]      -- 외부 박스 항공 출하 수량
                                , XXX.[OUTER_BOX_AIR_EXPR_QTY]      -- 외부 박스 항공 특송 수량
                                , XXX.[INNER_BOX_QTY]               -- 내부 박스 수량
                                , XXX.[INNER_BOX_NONE_SLIPSHT_QTY]  -- 내부 박스 NONE 간지 수량
                                , XXX.[USE_FLAG]                    -- 사용 여부
                                , @v_proc_name
								, GETDATE()
								, @v_proc_name
								, GETDATE()
								);


                    SET @v_count = @v_count + @@ROWCOUNT;

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

					IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG]   = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_SHIPTO_PACK_COND_MOBILE'
							AND   [IF_SEQ]      = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'N'
								,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_SHIPTO_PACK_COND_MOBILE'
							AND   [IF_SEQ]    = @IF_SEQ;
						END;
			    END;  -- IF @BAS_ITEM_ID = 'TB_MMD_SHIPTO_PACK_COND_MOBILE'
			-- 2018-07-11 kimcd 라인 공정별 창고, 출하 이동 단위 수신 추가 끝
			-- 2019-02-15 kimcd MES 공정 PC 사용자 추가 시작
			ELSE IF @BAS_ITEM_ID = 'PERSON' 
			    BEGIN
				    IF @IF_SOURCE = 'OSC1'  -- 2019-03-12 kimcd 전지만 수신
						BEGIN
							SET @PROCESS_FLAG = 'N'
							SET @v_temp1 = 'STEP MERGE USER'
							MERGE INTO [dbo].[TH_UIS_USER_DETAIL] A
							USING ( SELECT  @BAS_KEY_ATTR1  AS USERID
										   ,SUBSTRING(ISNULL(@BAS_ATTR2,@BAS_KEY_ATTR1),1,100) AS USERNAME
										   ,@USE_FLAG       AS USE_FLAG
									) B
							ON (           A.USER_ID        =  B.USERID
							   )
							WHEN MATCHED THEN
								 UPDATE SET A.USER_NAME     = B.USERNAME 
										   ,A.DEPARTMENT    = 'GMES PC'  
										   ,A.USE_FLAG      = B.USE_FLAG
										   ,A.USER_STATUS   = CASE B.USE_FLAG WHEN 'N' THEN 'Deleted' ELSE 'normal' END
										   ,A.UPDATE_ID     = @v_proc_name
										   ,A.UPDATE_DTTM   = GETDATE()
					                
							WHEN NOT MATCHED THEN
								 INSERT (   USER_ID
										   ,USER_NAME
										   ,DEPARTMENT
										   ,USE_FLAG
										   ,USER_STATUS
										   ,PASS_CODE -- 비밀 번호 2019-08-09 kimcd 비밀번호 기본 값 설정
										   ,INSERT_ID
										   ,INSERT_DTTM
										   ,UPDATE_ID
										   ,UPDATE_DTTM
										)
								 VALUES (   B.USERID
										   ,B.USERNAME
										   ,'GMES PC'
										   ,B.USE_FLAG
										   ,CASE B.USE_FLAG WHEN 'N' THEN 'Deleted' ELSE 'normal' END
										   ,'iSeELyi6n1/2nU9iXIoGWJEJpI7/It1vjg9JMHyuzMM=' -- 비밀 번호 2019-08-09 kimcd 비밀번호 기본 값 설정
										   ,@v_proc_name
										   ,GETDATE()
										   ,@v_proc_name
										   ,GETDATE()
										);

							SET @v_temp1 = 'STEP MERGE TH_UIS_USER_ROLE_RELATE'
							MERGE INTO [dbo].[TH_UIS_USER_ROLE_RELATE] A
							USING ( SELECT  @BAS_KEY_ATTR1  AS USERID
										   ,'RA10101006'    AS ROLE_ID	 -- GMES Authority
										   ,@USE_FLAG       AS USE_FLAG
									) B
							ON (           A.USER_ID        =  B.USERID
									AND    A.ROLE_ID        =  B.ROLE_ID
							   )
							WHEN MATCHED THEN
								 UPDATE SET A.USE_AT_FLAG   = B.USE_FLAG
										   ,A.UPDATE_ID     = @v_proc_name
										   ,A.UPDATE_DTTM   = GETDATE()
							WHEN NOT MATCHED THEN
								 INSERT (  [USER_ID]
										  ,[ROLE_ID]
										  ,[APPLY_DTTM]
										  ,[USE_AT_FLAG]
										  ,[INSERT_ID]
										  ,[INSERT_DTTM]
										  ,[UPDATE_ID]
										  ,[UPDATE_DTTM]
										)
								 VALUES (   B.USERID
										   ,B.ROLE_ID
										   ,GETDATE()  -- [APPLY_DTTM]
										   ,B.USE_FLAG
										   ,@v_proc_name
										   ,GETDATE()
										   ,@v_proc_name
										   ,GETDATE()
										);

							SET @v_temp1 = 'STEP MERGE TH_UIS_USER_FACTORY_RELATE'
							MERGE INTO [dbo].[TH_UIS_USER_FACTORY_RELATE] A
							USING ( SELECT  @BAS_KEY_ATTR1  AS USERID
										   ,'SG10005063'    AS ROLE_ID	 -- GMES Authority
										   ,@USE_FLAG       AS USE_FLAG
									) B
							ON (           A.USER_ID        =  B.USERID
									AND    A.ROLE_ID        =  B.ROLE_ID
							   )
							WHEN MATCHED THEN
								 UPDATE SET A.USE_AT_FLAG   = B.USE_FLAG
										   ,A.UPDATE_ID     = @v_proc_name
										   ,A.UPDATE_DTTM   = GETDATE()
							WHEN NOT MATCHED THEN
								 INSERT (  [USER_ID]
										  ,[ROLE_ID]
										  ,[APPLY_DTTM]
										  ,[USE_AT_FLAG]
										  ,[INSERT_ID]
										  ,[INSERT_DTTM]
										  ,[UPDATE_ID]
										  ,[UPDATE_DTTM]
										)
								 VALUES (   B.USERID
										   ,B.ROLE_ID
										   ,GETDATE()  -- [APPLY_DTTM]
										   ,B.USE_FLAG
										   ,@v_proc_name
										   ,GETDATE()
										   ,@v_proc_name
										   ,GETDATE()
										);

							IF 	@@ROWCOUNT > 0
								SET @PROCESS_FLAG = 'Y'
							ELSE
								SET @PROCESS_FLAG = 'N'

							IF @PROCESS_FLAG = 'Y'
								BEGIN
									UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
									SET [PROC_FLAG] = 'Y'
									   ,[UPDDTTM]   = GETDATE()
									WHERE [PROC_FLAG]   = 'P'
									AND   [BAS_ITEM_ID] = 'PERSON'
									AND   [IF_SEQ]      = @IF_SEQ;

									SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
									SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

									INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
										([IF_SEQ]             -- [nvarchar](50) NOT NULL,
										,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
										,[IF_ID]              -- [nvarchar](50) NOT NULL,
										,[IF_SND_DATE]        -- [datetime] NULL,
										,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
										,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										)
									VALUES
										(@send_if_seq
										,'R'
										,@if_id_code
										,GETDATE()
										,@IF_SEQ
										,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										);
								END;
							ELSE
								BEGIN
									UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
									SET [PROC_FLAG] = 'N'
										,[UPDDTTM]   = GETDATE()
									WHERE [PROC_FLAG] = 'P'
									AND   [BAS_ITEM_ID] = 'PERSON'
									AND   [IF_SEQ]    = @IF_SEQ;
								END;
						END;
					ELSE -- @IF_SOURCE = 'OSC1'  -- 2019-03-12 kimcd 전지만 수신
						BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
								,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG]   = 'P'
							AND   [BAS_ITEM_ID] = 'PERSON'
							AND   [IF_SEQ]      = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END; -- @IF_SOURCE = 'OSC1'  -- 2019-03-12 kimcd 전지만 수신의 ELSE
			    END;  -- IF @BAS_ITEM_ID = 'PERSON'
			-- 2019-02-15 kimcd MES 공정 PC를 사용자에 추가 끝
			-- 2019-03-15 kimcd MMD 목표 수율 수신 추가 시작
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_TRGT_YLD'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

                    -- 목표 수율 입력용 PLANT CURSOR
                    DECLARE C_TRGT_YLD_LINE CURSOR FOR
						SELECT DISTINCT SLM.[COMPANY_ID]
							 , SLM.[DIVISION_ID]
							 , SLM.[SITE_ID]
							 , SLM.[PLANT_ID]
						FROM   [dbo].[SCM_LINE_M]  SLM   WITH(NOLOCK)
						WHERE  LINE_ID      = @BAS_KEY_ATTR1  
 						AND    OPERATION_ID = @BAS_KEY_ATTR2;

                    SET @v_temp1 = 'STEP OPEN CURSOR C_TRGT_YLD_LINE'
    		        OPEN C_TRGT_YLD_LINE
                    FETCH NEXT FROM C_TRGT_YLD_LINE INTO @COMPANY_ID
                                                         ,@DIVISION_ID
                                                         ,@SITE_ID
														 ,@PLANT_ID
                    WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
                    BEGIN
					    SET @v_temp1 = 'STEP MERGE FP_MMD_YIELD_M'
                        MERGE INTO [DBO].[FP_MMD_YIELD_M] MY
						USING ( SELECT A.ITEM_ID
						              ,B.MON
									  ,B.YIELD
								FROM   ( SELECT DISTINCT 
											   I.ITEM_ID
										FROM   [DBO].[SCM_ITEM_M]          I WITH(NOLOCK)
											  ,[DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE]  C WITH(NOLOCK)
										WHERE  C.[CHILD_COMPANY_ID]  = I.[COMPANY_ID]
										AND    C.[CHILD_DIVISION_ID] = I.[DIVISION_ID]
										AND    C.[CHILD_SITE_ID]     = I.[SITE_ID]
										AND    C.[CHILD_ITEM_ID]     = I.[ITEM_ID]
										AND    C.[COMPANY_ID]  = @COMPANY_ID
										AND    C.[DIVISION_ID] = @DIVISION_ID
										AND    C.[SITE_ID]     = @SITE_ID
										AND    C.[MODEL_ID]    = @BAS_KEY_ATTR3     -- ITEM_ID
										AND    C.[PLANT_ID]    = C.[CHILD_PLANT_ID]
										AND    C.[MODEL_ID]   != C.[CHILD_ITEM_ID]
										AND    I.[FLOW_ID]  LIKE '%' + @BAS_KEY_ATTR2 + '%'   -- 공정포함된 품목만 추출
										AND    ( @BAS_KEY_ATTR4 = 'N' OR ( SUBSTRING(C.[CHILD_ITEM_ID],4,1) = @BAS_KEY_ATTR4 ) ) -- 극성 관리 여부 
										UNION
										SELECT DISTINCT 
											   I.ITEM_ID
										FROM   [DBO].[SCM_ITEM_M]          I WITH(NOLOCK)
										WHERE  I.[COMPANY_ID]  = @COMPANY_ID
										AND    I.[DIVISION_ID] = @DIVISION_ID
										AND    I.[SITE_ID]     = @SITE_ID
										AND    I.[ITEM_ID]     = @BAS_KEY_ATTR3     -- ITEM_ID
										AND    ( @BAS_KEY_ATTR2 LIKE 'F%' OR I.[FLOW_ID]   LIKE '%' + @BAS_KEY_ATTR2 + '%' )  -- 활성화 공정은 모두 수신, 공정포함된 품목만 추출
										AND    ( @BAS_KEY_ATTR4 = 'N' OR ( SUBSTRING(I.[ITEM_ID],4,1) = @BAS_KEY_ATTR4 ) ) 
										UNION -- 2019-04-05 kimcd 하위 BOM 전개하여 하위 구성품 찾는 로직 추가
										SELECT DISTINCT 
											   I.ITEM_ID
										FROM   [DBO].[SCM_ITEM_M]  I WITH(NOLOCK),
										       [DBO].[SCM_BOM_M]  C WITH(NOLOCK)
										WHERE  C.[COMPANY_ID]  = I.[COMPANY_ID]
										AND    C.[DIVISION_ID] = I.[DIVISION_ID]
										AND    C.[SITE_ID]     = I.[SITE_ID]
										AND    C.[CHILD_ITEM_ID] = I.[ITEM_ID]
										AND    C.[COMPANY_ID]  = @COMPANY_ID
										AND    C.[DIVISION_ID] = @DIVISION_ID
										AND    C.[SITE_ID]     = @SITE_ID
										AND    C.[PLANT_ID]    = @PLANT_ID
										AND    C.[PARENT_ITEM_ID] = @BAS_KEY_ATTR3     -- ITEM_ID
										AND    C.[EFF_END_DATE] > GETDATE()
										AND    I.[FLOW_ID]   LIKE '%' + @BAS_KEY_ATTR2 + '%'
										AND    ( @BAS_KEY_ATTR4 = 'N' OR ( SUBSTRING(I.[ITEM_ID],4,1) = @BAS_KEY_ATTR4 ) ) ) A -- 극성 관리 여부 
									 ,( SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '01' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR1) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR1) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR1) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR1) * 100 END END/100, 1) AS YIELD UNION ALL 
									    SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '02' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR2) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR2) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR2) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR2) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '03' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR3) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR3) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR3) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR3) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '04' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR4) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR4) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR4) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR4) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '05' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR5) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR5) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR5) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR5) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '06' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR6) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR6) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR6) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR6) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '07' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR7) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR7) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR7) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR7) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '08' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR8) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR8) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR8) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR8) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '09' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR9) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR9) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR9) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR9) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '10' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR10) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR10) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR10) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR10) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '11' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR11) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR11) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR11) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR11) * 100 END END/100, 1) AS YIELD UNION ALL
										SELECT SUBSTRING(@BAS_KEY_ATTR5,1,4) + '12' AS MON, ISNULL(CASE WHEN ISNUMERIC(@BAS_ATTR12) != 1 THEN 100 ELSE CASE WHEN CONVERT(NUMERIC(18, 6), @BAS_ATTR12) > 1 THEN CONVERT(NUMERIC(18, 6), @BAS_ATTR12) ELSE CONVERT(NUMERIC(18, 6), @BAS_ATTR12) * 100 END END/100, 1) AS YIELD ) B
										-- 2019-03-21 kimcd 년 4자리 제한, yield 숫자만 수신 2019-04-01 숫자 1 기준으로 100 곱하는 로직 추가
								 ) XXX
						ON    ( MY.[LINE_ID]          = @BAS_KEY_ATTR1
								AND MY.[OPERATION_ID] = @BAS_KEY_ATTR2
								AND MY.[MODEL_ID]     = @BAS_KEY_ATTR3
								AND MY.[ITEM_ID]      = XXX.ITEM_ID
								AND MY.[MONTH]        = XXX.MON )
						WHEN MATCHED THEN
							UPDATE SET MY.[YIELD]         = XXX.YIELD
					    			  ,MY.[UPDATE_ID]     = 'PR_XIF_MMD_ALL_R'
									  ,MY.[UPDATE_TIME]   = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ( [LINE_ID]       -- MES LINE
									,[OPERATION_ID]  -- OPERATION
									,[MODEL_ID]      -- MODEL MMD 전송한 품목
									,[ITEM_ID]       -- 하위 공정 생산 반제품
									,[MONTH]
									,[YIELD]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									)
							VALUES ( @BAS_KEY_ATTR1   -- LINE
									,@BAS_KEY_ATTR2   -- OPERATION
									,@BAS_KEY_ATTR3   -- MODEL MMD 관리 품목
									,XXX.ITEM_ID      -- 하위 공정 생산 반제품
									,XXX.MON          -- 년월
									,XXX.YIELD
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									,'PR_XIF_MMD_ALL_R'
									,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    FETCH NEXT FROM C_TRGT_YLD_LINE INTO @COMPANY_ID
													    ,@DIVISION_ID
													    ,@SITE_ID
														,@PLANT_ID
					END -- WHILE @@FETCH_STATUS = 0  C_TRGT_YLD_LINE
					CLOSE C_TRGT_YLD_LINE;
			        DEALLOCATE C_TRGT_YLD_LINE;   -- 메모리 해제

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_TRGT_YLD'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = CASE WHEN @BAS_KEY_ATTR3 != 'ALL' AND ( @BAS_KEY_ATTR2 LIKE 'A%' OR @BAS_KEY_ATTR2 LIKE 'F%')
						                        AND @IF_RCV_DATE > @MONTH_DATE THEN 'N' ELSE 'Y' END -- 2020-06-26 kimcd IF_RCV_DATE 30일 이전 정보는 수신으로 정리. 2020-01-10 kimcd 조립, 활성화의 경우만 잔여 정보 유지
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_TRGT_YLD'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- @BAS_ITEM_ID = 'TB_MMD_TRGT_YLD'
			-- 2019-03-15 kimcd MMD 목표 수율 수신 추가 끝
			-- 2020-01-10 kimcd 도착지 Master 정보 입력 시작
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_SHIPTO'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_SHIPTO_M'
                        MERGE INTO [DBO].[SCM_MMD_SHIPTO_M] SMS
						USING ( SELECT  @BAS_KEY_ATTR1    AS   SHIPTO_ID,              -- 출하처 아이디
                                        ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
											  , [DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
											  )           AS   SHIPTO_NAME,            -- 출하처 명
										@BAS_ATTR2        AS   ADDR,                   -- 주소
										@BAS_ATTR3        AS   PLLT_PROD_DEVL_DAYS,    -- 팔레트 생산 편차 일수팔레트 기준 Validation 사용
										@BAS_ATTR4        AS   ISS_PROD_DEVL_DAYS,     -- 출고 생산 편차 일수출고 기준 Validation 사용
										@BAS_ATTR5        AS   OWMS_ISS_FLAG,          -- OWMS 출고 여부
										@BAS_KEY_ATTR2    AS   SHIPTO_CUSTOMERID,      -- 출하처 고객사 아이디
										@BAS_ATTR6        AS   SORT_NO,                -- 정렬 번호
										@USE_FLAG         AS   ACTIVE_FLAG,            -- 사용 여부
										@BAS_ATTR7        AS   PLANT_ID,               -- 플랜트 ID
										@BAS_ATTR8        AS   PACK_LABEL_USE_FLAG,    -- 포장 라벨 사용 여부
										@BAS_ATTR9        AS   PRDT_REQ_FLAG,          -- 물품 청구 여부Y인 출하처로 출고시 IF 하지 않고 물품청구 처리 위한 정보 남김
										@BAS_ATTR10       AS   BAS_SHIPTO_FLAG,        -- 기준 출하처 여부
										@BAS_ATTR11       AS   ELTR_OQC_INSP_CHK_FLAG, -- 전극 OQC 검사 체크 여부 전극 포장시 출하검사 체크 여부
										@BAS_ATTR12       AS   SHIPTO_COMPANY_CODE     -- 출하처 COMPANY 코드
											 ) XXX
						ON    (     SMS.[SHIPTO_ID]   = XXX.SHIPTO_ID )
						WHEN MATCHED THEN
							UPDATE SET  SMS.[SHIPTO_NAME]         = XXX.SHIPTO_NAME,            -- 출하처 명
										SMS.[ADDR]                = XXX.ADDR,                   -- 주소
										SMS.[PLLT_PROD_DEVL_DAYS] = XXX.PLLT_PROD_DEVL_DAYS,    -- 팔레트 생산 편차 일수팔레트 기준 Validation 사용
										SMS.[ISS_PROD_DEVL_DAYS]  = XXX.ISS_PROD_DEVL_DAYS,     -- 출고 생산 편차 일수출고 기준 Validation 사용
										SMS.[OWMS_ISS_FLAG]       = XXX.OWMS_ISS_FLAG,          -- OWMS 출고 여부
										SMS.[SHIPTO_CUSTOMERID]   = XXX.SHIPTO_CUSTOMERID,      -- 출하처 고객사 아이디
										SMS.[SORT_NO]             = XXX.SORT_NO,                -- 정렬 번호
										SMS.[ACTIVE_FLAG]         = XXX.ACTIVE_FLAG,            -- 사용 여부
										SMS.[PLANT_ID]            = XXX.PLANT_ID,               -- 플랜트 ID
										SMS.[PACK_LABEL_USE_FLAG] = XXX.PACK_LABEL_USE_FLAG,    -- 포장 라벨 사용 여부
										SMS.[PRDT_REQ_FLAG]       = XXX.PRDT_REQ_FLAG,          -- 물품 청구 여부Y인 출하처로 출고시 IF 하지 않고 물품청구 처리 위한 정보 남김
										SMS.[BAS_SHIPTO_FLAG]     = XXX.BAS_SHIPTO_FLAG,        -- 기준 출하처 여부
										SMS.[ELTR_OQC_INSP_CHK_FLAG] = XXX.ELTR_OQC_INSP_CHK_FLAG, -- 전극 OQC 검사 체크 여부 전극 포장시 출하검사 체크 여부
										SMS.[SHIPTO_COMPANY_CODE] = XXX.SHIPTO_COMPANY_CODE,    -- 출하처 COMPANY 코드
										SMS.[UPDATE_ID]           = 'PR_XIF_MMD_ALL_R',
										SMS.[UPDATE_TIME]         = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ([SHIPTO_ID],              -- 출하처 아이디
									[SHIPTO_NAME],            -- 출하처 명
									[ADDR],                   -- 주소
									[PLLT_PROD_DEVL_DAYS],    -- 팔레트 생산 편차 일수팔레트 기준 Validation 사용
									[ISS_PROD_DEVL_DAYS],     -- 출고 생산 편차 일수출고 기준 Validation 사용
									[OWMS_ISS_FLAG],          -- OWMS 출고 여부
									[SHIPTO_CUSTOMERID],      -- 출하처 고객사 아이디
									[SORT_NO],                -- 정렬 번호
									[ACTIVE_FLAG],            -- 사용 여부
									[PLANT_ID],               -- 플랜트 ID
									[PACK_LABEL_USE_FLAG],    -- 포장 라벨 사용 여부
									[PRDT_REQ_FLAG],          -- 물품 청구 여부Y인 출하처로 출고시 IF 하지 않고 물품청구 처리 위한 정보 남김
									[BAS_SHIPTO_FLAG],        -- 기준 출하처 여부
									[ELTR_OQC_INSP_CHK_FLAG], -- 전극 OQC 검사 체크 여부 전극 포장시 출하검사 체크 여부
									[SHIPTO_COMPANY_CODE],    -- 출하처 COMPANY 코드
								    [INSERT_ID],	          -- 등록자
								    [INSERT_TIME],	          -- 등록일
								    [UPDATE_ID],	          -- 수정자
								    [UPDATE_TIME]	          -- 수정일
									)
							VALUES (XXX.SHIPTO_ID,              -- 출하처 아이디
									XXX.SHIPTO_NAME,            -- 출하처 명
									XXX.ADDR,                   -- 주소
									XXX.PLLT_PROD_DEVL_DAYS,    -- 팔레트 생산 편차 일수팔레트 기준 Validation 사용
									XXX.ISS_PROD_DEVL_DAYS,     -- 출고 생산 편차 일수출고 기준 Validation 사용
									XXX.OWMS_ISS_FLAG,          -- OWMS 출고 여부
									XXX.SHIPTO_CUSTOMERID,      -- 출하처 고객사 아이디
									XXX.SORT_NO,                -- 정렬 번호
									XXX.ACTIVE_FLAG,            -- 사용 여부
									XXX.PLANT_ID,               -- 플랜트 ID
									XXX.PACK_LABEL_USE_FLAG,    -- 포장 라벨 사용 여부
									XXX.PRDT_REQ_FLAG,          -- 물품 청구 여부Y인 출하처로 출고시 IF 하지 않고 물품청구 처리 위한 정보 남김
									XXX.BAS_SHIPTO_FLAG,        -- 기준 출하처 여부
									XXX.ELTR_OQC_INSP_CHK_FLAG, -- 전극 OQC 검사 체크 여부 전극 포장시 출하검사 체크 여부
									XXX.SHIPTO_COMPANY_CODE,    -- 출하처 COMPANY 코드
									'PR_XIF_MMD_ALL_R',
									GETDATE(),
									'PR_XIF_MMD_ALL_R',
									GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_SHIPTO'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_SHIPTO'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- @BAS_ITEM_ID = 'TB_MMD_SHIPTO'
			-- 2020-01-10 kimcd 도착지 Master 정보 입력 끝
			-- 2020-01-16 kimcd LOTTYPE 유형 입력 시작
            ELSE IF @BAS_ITEM_ID = 'LOTTYPE'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_SYS_LOOKUP_VALUE LOTTYPE'
                        MERGE INTO [DBO].[SCM_SYS_LOOKUP_VALUE] SLV
						USING ( SELECT  'MES_LOT_TYPE'    AS   LOOKUP_TYPE_CODE,
						                @BAS_KEY_ATTR1    AS   SEGMENT1,              --  LOTTYPE LOT 유형
										'-'               AS   SEGMENT2,
										'-'               AS   SEGMENT3,
										'-'               AS   SEGMENT4,
										'-'               AS   SEGMENT5,
										@USE_FLAG         AS   ACTIVE_FLAG,            -- 사용 여부
                                        ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
											  , [DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
											  )           AS   VALUE_DESCRIPTION,      -- LOTYNAME LOT 유형명
										@BAS_ATTR3   	  AS ATTRIBUTE1, -- DEMAND_TYPE FP DEMAND 유형
										@BAS_ATTR4   	  AS ATTRIBUTE2  -- ERP_WOTYPE  ERP 작업지시유형
											 ) XXX
						ON    (     SLV.[LOOKUP_TYPE_CODE]   = XXX.LOOKUP_TYPE_CODE
						        AND SLV.[SEGMENT1] = XXX.SEGMENT1 )
						WHEN MATCHED THEN
							UPDATE SET  SLV.[ACTIVE_FLAG]       = XXX.ACTIVE_FLAG,      -- 사용 여부
                                        SLV.[VALUE_DESCRIPTION] = XXX.VALUE_DESCRIPTION,-- LOTYNAME LOT 유형명
										SLV.[ATTRIBUTE1]        = XXX.ATTRIBUTE1,       -- DEMAND_TYPE FP DEMAND 유형
										SLV.[ATTRIBUTE2]        = XXX.ATTRIBUTE2,       -- ERP_WOTYPE  ERP 작업지시유형
										SLV.[MODIFY_USER_ID]    = 'PR_XIF_MMD_ALL_R',
										SLV.[MODIFY_DATE]       = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT ([LOOKUP_TYPE_CODE],
									[SEGMENT1],          -- LOTTYPE LOT 유형
									[SEGMENT2],
									[SEGMENT3],
									[SEGMENT4],
									[SEGMENT5],
									[ACTIVE_FLAG],       -- 사용 여부
									[VALUE_DESCRIPTION], -- LOTYNAME LOT 유형명
									[ATTRIBUTE1],        -- DEMAND_TYPE FP DEMAND 유형
									[ATTRIBUTE2],        -- ERP_WOTYPE  ERP 작업지시유형
								    [CREATE_USER_ID],	 -- 등록자
								    [CREATE_DATE],	     -- 등록일
								    [MODIFY_USER_ID],	 -- 수정자
								    [MODIFY_DATE]	     -- 수정일
									)
							VALUES (XXX.[LOOKUP_TYPE_CODE],
									XXX.[SEGMENT1],          -- LOTTYPE LOT 유형
									XXX.[SEGMENT2],
									XXX.[SEGMENT3],
									XXX.[SEGMENT4],
									XXX.[SEGMENT5],
									XXX.[ACTIVE_FLAG],       -- 사용 여부
									XXX.[VALUE_DESCRIPTION], -- LOTYNAME LOT 유형명
									XXX.[ATTRIBUTE1],        -- DEMAND_TYPE FP DEMAND 유형
									XXX.[ATTRIBUTE2],        -- ERP_WOTYPE  ERP 작업지시유형
									'PR_XIF_MMD_ALL_R',
									GETDATE(),
									'PR_XIF_MMD_ALL_R',
									GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'LOTTYPE'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'LOTTYPE'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- @BAS_ITEM_ID = 'TB_MMD_SHIPTO'
			-- 2020-01-16 kimcd MES LOTTYPE 유형 갱신 끝
			-- 2021-10-25 kimcd 2nd ocv 관련 제품규격에서 정보 관리 룰 변경에 따른 수정
				--제품 ID BAS_KEY_ATTR1 
				--생산경로 ID BAS_KEY_ATTR2 
				--경로흐름 ID BAS_KEY_ATTR3 
				--공정 ID BAS_KEY_ATTR4 
				--제어항목 BAS_KEY_ATTR5 
				--    PDPCSETU    : 공정 투입 시간 제어
                --    STPERMITCNT : 착공 허용 횟수
				--제어값 BAS_ATTR1 
				--제어값 1 BAS_ATTR2 
				--제어값 2 BAS_ATTR3 
				--제어값 3 BAS_ATTR4 
				--제어값 4 BAS_ATTR5 
				--제어값 5 BAS_ATTR6 
				--제어값 6 BAS_ATTR7 
				--제어값 7 BAS_ATTR8 
				--제어값 8 BAS_ATTR9 
				--제어값 9 BAS_ATTR10 
				--제어값 10 BAS_ATTR11 
				--설비 작업 일련번호 BAS_ATTR12 
            ELSE IF @BAS_ITEM_ID = 'PRODUCTPROCESSCONTROLSPEC'
			    BEGIN
					IF @BAS_KEY_ATTR5 IN ('PDPCSETU','STPERMITCNT') AND   @BAS_KEY_ATTR4 = 'P5300'
						BEGIN
							SET @PROCESS_FLAG = 'N'
							SET @v_temp1 = 'STEP MERGE SCM_MMD_SECOND_OCV_PRE_M'
							MERGE INTO [DBO].[SCM_MMD_SECOND_OCV_PRE_M] SOP
							USING ( SELECT 	@BAS_KEY_ATTR1 AS ITEM_ID,
											@BAS_KEY_ATTR4 AS OPERATION_ID,
											@BAS_KEY_ATTR2 AS ROUTID,
											@BAS_KEY_ATTR3 AS FLOWID,
											--CASE WHEN @BAS_KEY_ATTR5 = 'PDPCSETU' THEN @BAS_ATTR1 END      AS KEEP_MINUTES,
											--CASE WHEN @BAS_KEY_ATTR5 = 'STPERMITCNT' THEN @BAS_ATTR1 END   AS MAX_TIME,
											CASE WHEN @BAS_KEY_ATTR5 = 'PDPCSETU'		THEN IIF(ISNUMERIC(@BAS_ATTR1) = 1, @BAS_ATTR1, NULL) END   AS KEEP_MINUTES,
											CASE WHEN @BAS_KEY_ATTR5 = 'STPERMITCNT'	THEN IIF(ISNUMERIC(@BAS_ATTR1) = 1, @BAS_ATTR1, NULL) END   AS MAX_TIME,
											@USE_FLAG         AS   ACTIVE_FLAG 
											) XXX
							ON    ( SOP.ITEM_ID          = XXX.ITEM_ID
									AND SOP.OPERATION_ID = XXX.OPERATION_ID
									AND SOP.ROUTID       = XXX.ROUTID
									AND SOP.FLOWID       = XXX.FLOWID
								)
							WHEN MATCHED THEN
								UPDATE SET  SOP.[KEEP_MINUTES] = ISNULL(XXX.KEEP_MINUTES,SOP.[KEEP_MINUTES]),
											SOP.[MAX_TIME]     = ISNULL(XXX.MAX_TIME,SOP.[MAX_TIME]),
											SOP.[UPDATE_ID]    = 'PR_XIF_MMD_ALL_R',
											SOP.[UPDATE_TIME]  = GETDATE()
							WHEN NOT MATCHED THEN
								INSERT ([ITEM_ID],
										[ROUTID],
										[FLOWID],
										[OPERATION_ID],
										[KEEP_MINUTES],
										[MAX_TIME],
										[ACTIVE_FLAG],
										[INSERT_ID],
										[INSERT_TIME],
										[UPDATE_ID],
										[UPDATE_TIME]
										)
								VALUES (XXX.ITEM_ID,
										XXX.ROUTID,
										XXX.FLOWID,
										XXX.OPERATION_ID,
										XXX.KEEP_MINUTES,
										XXX.MAX_TIME,
										XXX.ACTIVE_FLAG,
										'PR_XIF_MMD_ALL_R',
										GETDATE(),
										'PR_XIF_MMD_ALL_R',
										GETDATE()
										);

							IF 	@@ROWCOUNT > 0
								SET @PROCESS_FLAG = 'Y'


							IF @PROCESS_FLAG = 'Y'
								BEGIN
									UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
									SET [PROC_FLAG] = 'Y'
									   ,[UPDDTTM]   = GETDATE()
									WHERE [PROC_FLAG] = 'P'
									AND   [BAS_ITEM_ID] = 'PRODUCTPROCESSCONTROLSPEC'
									AND   [IF_SEQ]    = @IF_SEQ;

									SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
									SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

									INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
										([IF_SEQ]             -- [nvarchar](50) NOT NULL,
										,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
										,[IF_ID]              -- [nvarchar](50) NOT NULL,
										,[IF_SND_DATE]        -- [datetime] NULL,
										,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
										,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										)
									VALUES
										(@send_if_seq
										,'R'
										,@if_id_code
										,GETDATE()
										,@IF_SEQ
										,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										);
								END;
							ELSE
								UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
								SET [PROC_FLAG] = 'N'
								   ,[UPDDTTM]   = GETDATE()
								WHERE [PROC_FLAG] = 'P'
								AND   [BAS_ITEM_ID] = 'PRODUCTPROCESSCONTROLSPEC'
								AND   [IF_SEQ]    = @IF_SEQ;
						END; -- IF @BAS_KEY_ATTR5 IN ('PDPCSETU','STPERMITCNT') AND   @BAS_KEY_ATTR4 = 'P5300'
					ELSE -- IF @BAS_KEY_ATTR5 IN ('PDPCSETU','STPERMITCNT') AND   @BAS_KEY_ATTR4 = 'P5300'
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'Y'
							,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'PRODUCTPROCESSCONTROLSPEC'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'PRODUCTPROCESSCONTROLSPEC'
			-- 2021-10-25 kimcd 2nd ocv 관련 제품규격에서 정보 관리 룰 변경에 따른 끝
			-- 2021-10-25 kimcd 2nd ocv 관련 제품규격 로직 재구성
				--영역아이디   BAS_KEY_ATTR1 
				--제품아이디   BAS_KEY_ATTR2 
				--경과 시작 일 BAS_KEY_ATTR3 
				--경과 종료 일 BAS_KEY_ATTR4 
				--ALPHA 값     BAS_ATTR1 
				--BETA 값      BAS_ATTR2 
				--GAMMA 값     BAS_ATTR3 
				--표준 편차 값 BAS_ATTR4 
				--차수 기준 일 BAS_ATTR5 
				--기준 공정아이디 BAS_ATTR6 
				--OCV 차수 기준 일 BAS_ATTR7 
				--QA 판정 편차 값 BAS_ATTR8 
				--PIN 검사 차수 BAS_ATTR9 
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_PRDT_2ND_OCV_VLTG'
			    BEGIN
					SET @PROCESS_FLAG = 'N'
					IF @USE_FLAG = 'Y' 
						BEGIN
							DELETE FROM [DBO].[SCM_MMD_SECOND_OCV_SPEC_M]
							WHERE  FACTORY_ID   = @BAS_KEY_ATTR1
							AND    ITEM_ID      = @BAS_KEY_ATTR2
							AND    FROM_TIME    = @BAS_KEY_ATTR3
							AND    TO_TIME      = @BAS_KEY_ATTR4

							SET	@SECOND_TIME        = 1 -- 차수 1번 초기화
							SET @KEEP_DAYS = CASE WHEN CHARINDEX(',', @BAS_ATTR5) > 0 THEN SUBSTRING(@BAS_ATTR5, 1,CASE WHEN CHARINDEX(',', @BAS_ATTR5) > 0 THEN  CHARINDEX(',', @BAS_ATTR5)-1 ELSE 0 END) ELSE @BAS_ATTR5 END
							SET @CONCATED_KEEP_DAYS = CASE WHEN CHARINDEX(',', @BAS_ATTR5) > 0 THEN SUBSTRING(@BAS_ATTR5, CHARINDEX(',', @BAS_ATTR5)+1, LEN(@BAS_ATTR5)) END

							WHILE(@KEEP_DAYS IS NOT NULL)
								BEGIN
									SET @v_temp1 = 'STEP MERGE SCM_MMD_SECOND_OCV_SPEC_M'
									MERGE INTO [DBO].[SCM_MMD_SECOND_OCV_SPEC_M] SOS
									USING ( SELECT 	@BAS_KEY_ATTR1  AS FACTORY_ID,
													@BAS_KEY_ATTR2  AS ITEM_ID,
													@SECOND_TIME    AS RUN_TIME,
													@BAS_KEY_ATTR3  AS FROM_TIME,
													@BAS_KEY_ATTR4  AS TO_TIME,
													@KEEP_DAYS      AS KEEP_DAYS,
													@BAS_ATTR6      AS OPERATION_ID
												) XXX
									ON    ( SOS.FACTORY_ID       = XXX.FACTORY_ID
											AND SOS.ITEM_ID      = XXX.ITEM_ID
											AND SOS.RUN_TIME     = XXX.RUN_TIME
											AND SOS.FROM_TIME    = XXX.FROM_TIME
											AND SOS.TO_TIME      = XXX.TO_TIME
										)
									WHEN MATCHED THEN
										UPDATE SET  SOS.[KEEP_DAYS]    = XXX.KEEP_DAYS,
													SOS.[OPERATION_ID] = XXX.OPERATION_ID,
													SOS.[UPDATE_ID]    = 'PR_XIF_MMD_ALL_R',
													SOS.[UPDATE_TIME]  = GETDATE()
									WHEN NOT MATCHED THEN
										INSERT ([FACTORY_ID],
												[ITEM_ID],
												[RUN_TIME],     -- 수행 차수
												[FROM_TIME],
												[TO_TIME],
												[KEEP_DAYS],    -- 보관 일자
												[OPERATION_ID], -- 공정
												[INSERT_ID],
												[INSERT_TIME],
												[UPDATE_ID],
												[UPDATE_TIME]
												)
										VALUES (XXX.FACTORY_ID,
												XXX.ITEM_ID,
												XXX.RUN_TIME,
												XXX.FROM_TIME,
												XXX.TO_TIME,
												XXX.KEEP_DAYS,
												XXX.OPERATION_ID,
												'PR_XIF_MMD_ALL_R',
												GETDATE(),
												'PR_XIF_MMD_ALL_R',
												GETDATE()
												);

									IF 	@@ROWCOUNT > 0
										SET @PROCESS_FLAG = 'Y'

									IF @CONCATED_KEEP_DAYS IS NOT NULL
										BEGIN
											SET @KEEP_DAYS = CASE WHEN CHARINDEX(',', @CONCATED_KEEP_DAYS) > 0 THEN SUBSTRING(@CONCATED_KEEP_DAYS, 1,CASE WHEN CHARINDEX(',', @CONCATED_KEEP_DAYS) > 0 THEN  CHARINDEX(',', @CONCATED_KEEP_DAYS)-1 ELSE 0 END) ELSE @CONCATED_KEEP_DAYS END
											SET @CONCATED_KEEP_DAYS = CASE WHEN CHARINDEX(',', @CONCATED_KEEP_DAYS) > 0 THEN SUBSTRING(@CONCATED_KEEP_DAYS, CHARINDEX(',', @CONCATED_KEEP_DAYS)+1, LEN(@CONCATED_KEEP_DAYS)) END
											SET @SECOND_TIME = @SECOND_TIME + 1
										END;
									ELSE
										BEGIN
											SET @KEEP_DAYS = NULL
											SET @CONCATED_KEEP_DAYS = NULL
											SET @SECOND_TIME = NULL 
										END;
								END; -- WHILE(@KEEP_DAYS IS NOT NULL)
						END; -- IF @USE_FLAG = 'Y'
					ELSE -- IF @USE_FLAG = 'Y'
						BEGIN
							SET @PROCESS_FLAG = 'Y'
							DELETE FROM [DBO].[SCM_MMD_SECOND_OCV_SPEC_M]
							WHERE  FACTORY_ID   = @BAS_KEY_ATTR1
							AND    ITEM_ID      = @BAS_KEY_ATTR2
							AND    FROM_TIME    = @BAS_KEY_ATTR3
							AND    TO_TIME      = @BAS_KEY_ATTR4
						END;

					IF @PROCESS_FLAG = 'Y'
						BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
								,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_PRDT_2ND_OCV_VLTG'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
							,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_PRDT_2ND_OCV_VLTG'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_PRDT_2ND_OCV_VLTG'
			-- 2021-10-25 kimcd 2nd ocv 관련 제품규격 로직 재구성 끝
			-- 2021-10-23 kimcd 활성화 Tray(캐리어) 추가 시작
				-- AREAID				BAS_KEY_ATTR1	영역아이디
				-- CST_TYPE_CODE		BAS_KEY_ATTR2	캐리어 유형 코드
				-- CST_LAYOUT_ID		BAS_KEY_ATTR3	캐리어 레이아웃 아이디
				-- CST_TYPE_NAME		BAS_ATTR1	    캐리어 유형 명
				-- CST_CELL_QTY			BAS_ATTR2		캐리어 셀 수량
				-- CST_CELL_TYPE_CODE	BAS_ATTR3		캐리어 셀 유형 코드
				-- CST_CELL_TYPE_NAME	BAS_ATTR4		캐리어 셀 유형 명
				-- CST_STACK_CNT		BAS_ATTR5		캐리어 스택 건수
				-- CST_ROUT_TYPE_CODE	BAS_ATTR6		캐리어 라우트 유형 코드
				-- FROM_SEQNO			BAS_ATTR7		FROM 일련번호
				-- MAX_SEQNO			BAS_ATTR8		최대 일련번호
				-- CURR_SEQNO			BAS_ATTR9		현재 일련번호
				-- VIRT_CST_FLAG		BAS_ATTR10		가상 캐리어 여부
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_FCS_CST_TYPE'
			    BEGIN
					IF @BAS_KEY_ATTR1 IN ('AA', 'AB', 'AC', 'A8', 'S4', 'A5', 'AD', 'A6', 'A7', 'AE', 'S3', 'A3', 'MC', 'AF')  -- NB 2동, GM JV로 한정 일단..
						BEGIN
							SET @PROCESS_FLAG = 'N'
							SET @v_temp1 = 'STEP MERGE SCM_FCS_TRAY_M'
							MERGE INTO [DBO].[SCM_FCS_TRAY_M] FT
							USING ( SELECT 	F.COMPANY_ID,
											F.DIVISION_ID,
											F.SITE_ID,
											F.PLANT_ID,
											ISNULL(ISNULL(L.PSEUDO_FACTORY_ID, IFM.FACTORY_ID),'-') AS PSEUDO_FACTORY_ID, -- 2022-01-20 kimcd 동 추가
											@BAS_KEY_ATTR2 AS TRAY_TYPE_CODE,
											@BAS_ATTR1     AS TRAY_TYPE_NAME,
											CASE WHEN @BAS_ATTR2 = '' THEN NULL ELSE @BAS_ATTR2 END     AS CELL_CNT,
											ISNULL( CASE WHEN @BAS_ATTR6 = '' THEN NULL ELSE @BAS_ATTR6 END, '-') AS DEGAS_BEFORE_TYPE,
											@USE_FLAG      AS USE_YN
									FROM    SCM_FACTORY_M F (NOLOCK)
											-- 2023-01-20 kimcd WA 법인 동별 Tray Simulation에 따라 Master 수신 작업 보완 시작
											LEFT OUTER JOIN (   SELECT IFM.INSTANCE_ID
																	  ,IFM.FACTORY_ID
																FROM   SCM_SYS_LOOKUP_VALUE   F (NOLOCK)
																	  ,FP_INSTANCE_FACTORY_M  IFM  (NOLOCK)
																WHERE  F.LOOKUP_TYPE_CODE = 'FORM_TRAY_SIMUL_OPTION'
																AND    F.SEGMENT1 = IFM.INSTANCE_ID
																AND    F.ACTIVE_FLAG = 'Y'
																AND    F.ATTRIBUTE1 = 'building' ) IFM
												   ON  IFM. FACTORY_ID = F.FACTORY_ID
											LEFT OUTER JOIN (   SELECT SEGMENT1 AS INSTANCE_ID
																	  ,SEGMENT3 AS PLANT_ID
																	  ,SEGMENT4 AS FACTORY_ID
																	  ,SEGMENT5 AS PSEUDO_FACTORY_ID
																FROM   SCM_SYS_LOOKUP_VALUE   L (NOLOCK)
																WHERE  L.LOOKUP_TYPE_CODE = 'FORMATION_TRAY_FACTORY_OPTION'
																AND    L.ACTIVE_FLAG = 'Y' ) L
											   ON  L.PLANT_ID    = F.PLANT_ID
											   AND L.INSTANCE_ID = iFM.INSTANCE_ID
											   AND L.FACTORY_ID  = IFM.FACTORY_ID
									-- 2023-01-20 kimcd WA 법인 동별 Tray Simulation에 따라 Master 수신 작업 보완 종료
									WHERE   F.FACTORY_ID = @BAS_KEY_ATTR1 ) XXX
							ON    (	FT.[DIVISION_ID]        = XXX.[DIVISION_ID]
									AND FT.[SITE_ID]        = XXX.[SITE_ID]
									AND FT.[PLANT_ID]       = XXX.[PLANT_ID]
									AND FT.[FACTORY_ID]     = XXX.[PSEUDO_FACTORY_ID]  -- 2022-01-20 kimcd 동 추가
									AND FT.[TRAY_TYPE_CODE] = XXX.[TRAY_TYPE_CODE] )
							WHEN MATCHED THEN
								UPDATE SET  FT.[TRAY_TYPE_NAME]    = XXX.[TRAY_TYPE_NAME],
											FT.[CELL_CNT]          = XXX.[CELL_CNT],
											FT.[DEGAS_BEFORE_TYPE] = XXX.[DEGAS_BEFORE_TYPE],
											FT.[USE_YN]            = XXX.[USE_YN],
											FT.[UPDATE_ID]         = 'PR_XIF_MMD_ALL_R',
											FT.[UPDATE_DATE]       = GETDATE()
							WHEN NOT MATCHED THEN
								INSERT ( [COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]       -- 2022-01-20 kimcd 동 추가
										,[TRAY_TYPE_CODE]
										,[TRAY_TYPE_NAME]
										,[DEGAS_BEFORE_TYPE]
										,[CELL_CNT]
										,[USE_YN]
										,[INSERT_ID]
										,[INSERT_DATE]
										,[UPDATE_ID]
										,[UPDATE_DATE]
										)
								VALUES ( XXX.[COMPANY_ID]
										,XXX.[DIVISION_ID]
										,XXX.[SITE_ID]
										,XXX.[PLANT_ID]
										,XXX.[PSEUDO_FACTORY_ID]  -- 2022-01-20 kimcd 동 추가
										,XXX.[TRAY_TYPE_CODE]
										,XXX.[TRAY_TYPE_NAME]
										,XXX.[DEGAS_BEFORE_TYPE]
										,XXX.[CELL_CNT]
										,XXX.[USE_YN]
										,'PR_XIF_MMD_ALL_R'
										,GETDATE()
										,'PR_XIF_MMD_ALL_R'
										,GETDATE()
										);

							IF 	@@ROWCOUNT > 0
								SET @PROCESS_FLAG = 'Y'

							IF @PROCESS_FLAG = 'Y'
								BEGIN
									UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
									SET [PROC_FLAG] = 'Y'
										,[UPDDTTM]   = GETDATE()
									WHERE [PROC_FLAG] = 'P'
									AND   [BAS_ITEM_ID] = 'TB_MMD_FCS_CST_TYPE'
									AND   [IF_SEQ]    = @IF_SEQ;

									SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
									SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

									INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
										([IF_SEQ]             -- [nvarchar](50) NOT NULL,
										,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
										,[IF_ID]              -- [nvarchar](50) NOT NULL,
										,[IF_SND_DATE]        -- [datetime] NULL,
										,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
										,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										)
									VALUES
										(@send_if_seq
										,'R'
										,@if_id_code
										,GETDATE()
										,@IF_SEQ
										,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
										,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
										);
								END;
							ELSE
								UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
								SET [PROC_FLAG] = 'N'
									,[UPDDTTM]   = GETDATE()
								WHERE [PROC_FLAG] = 'P'
								AND   [BAS_ITEM_ID] = 'TB_MMD_FCS_CST_TYPE'
								AND   [IF_SEQ]    = @IF_SEQ;
						END;-- IF @BAS_KEY_ATTR1 IN ('AA', 'AB', 'AC', 'A8', 'S4') THEN -- NB 2동, GM JV로 한정 일단..
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'Y'
							,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_FCS_CST_TYPE'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_FCS_CST_TYPE'
			-- 2021-10-23 kimcd 활성화 Tray(캐리어) 추가 끝
			-- 2021-11-01 kimcd 활성화 Route 수신 시작
				--ROUTID			BAS_KEY_ATTR1	라우트아이디
				--ROUT_NAME			BAS_ATTR1	라우트 명
				--AREAID			BAS_ATTR2	영역아이디
				--MDLLOT_ID			BAS_ATTR3	모델LOT 아이디
				--ROUT_TYPE_CODE	BAS_ATTR4	라우트 유형 코드
				--EQSGID			BAS_ATTR5	설비세그먼트아이디
				--ROUT_GR_CODE		BAS_ATTR6	라우트 그룹 코드
				--RWK_AVAIL_GRD_CODE	BAS_ATTR7	재작업 가용 등급 코드
				--ROUT_RSLT_GR_CODE	BAS_ATTR8	라우트 실적 그룹 코드
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_FORM_ROUT'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_FORM_ROUT'
                        MERGE INTO [DBO].[SCM_MMD_FORM_ROUT] MFR
						USING ( SELECT  @BAS_KEY_ATTR1    AS   ROUTID,
                                        ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR1) 
											  , [DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR1) 
											  )           AS   ROUT_NAME,
										@BAS_ATTR2        AS   AREAID,
										@BAS_ATTR3        AS   MDLLOT_ID,
										@BAS_ATTR4        AS   ROUT_TYPE_CODE,
										@BAS_ATTR5        AS   EQSGID,
										@BAS_ATTR6        AS   ROUT_GR_CODE,
										@BAS_ATTR7        AS   RWK_AVAIL_GRD_CODE,
										@BAS_ATTR8        AS   ROUT_RSLT_GR_CODE,
										@USE_FLAG         AS   ACTIVE_FLAG
											 ) XXX
						ON    (     MFR.[ROUTID]   = XXX.ROUTID )
						WHEN MATCHED THEN
							UPDATE SET  MFR.[ROUT_NAME]           = XXX.[ROUT_NAME],
										MFR.[AREAID]			  = XXX.[AREAID],
										MFR.[MDLLOT_ID]		      = XXX.[MDLLOT_ID],
										MFR.[ROUT_TYPE_CODE]	  = XXX.[ROUT_TYPE_CODE],
										MFR.[EQSGID]			  = XXX.[EQSGID],
										MFR.[ROUT_GR_CODE]		  = XXX.[ROUT_GR_CODE],
										MFR.[RWK_AVAIL_GRD_CODE]  = XXX.[RWK_AVAIL_GRD_CODE],
										MFR.[ROUT_RSLT_GR_CODE]   = XXX.[ROUT_RSLT_GR_CODE],
										MFR.[ACTIVE_FLAG]		  = XXX.[ACTIVE_FLAG],
										MFR.[UPDATE_ID]           = 'PR_XIF_MMD_ALL_R',
										MFR.[UPDATE_TIME]         = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([ROUTID]
								  ,[ROUT_NAME]
								  ,[AREAID]
								  ,[MDLLOT_ID]
								  ,[ROUT_TYPE_CODE]
								  ,[EQSGID]
								  ,[ROUT_GR_CODE]
								  ,[RWK_AVAIL_GRD_CODE]
								  ,[ROUT_RSLT_GR_CODE]
								  ,[ACTIVE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
									)
							VALUES (XXX.[ROUTID]
								   ,XXX.[ROUT_NAME]
								   ,XXX.[AREAID]
								   ,XXX.[MDLLOT_ID]
								   ,XXX.[ROUT_TYPE_CODE]
								   ,XXX.[EQSGID]
								   ,XXX.[ROUT_GR_CODE]
								   ,XXX.[RWK_AVAIL_GRD_CODE]
								   ,XXX.[ROUT_RSLT_GR_CODE]
								   ,XXX.[ACTIVE_FLAG]
								   ,'PR_XIF_MMD_ALL_R'
								   ,GETDATE()
								   ,'PR_XIF_MMD_ALL_R'
								   ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_FORM_ROUT'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_FORM_ROUT'
						AND   [IF_SEQ]    = @IF_SEQ;

				END; -- @BAS_ITEM_ID = 'TB_MMD_FORM_ROUT'
					--ROUTID					BAS_KEY_ATTR1	라우트아이디
					--PROCID					BAS_KEY_ATTR2	공정아이디
					--PROC_SEQNO				BAS_ATTR1	공정 일련번호
					--LANE_ID					BAS_ATTR2	LANE 아이디
					--DELTA_OCV_AFTER_PROCID	BAS_ATTR3	델타 OCV 이후 공정아이디
					--DELTA_OCV_PRE_PROCID		BAS_ATTR4	델타 OCV 이전 공정아이디
					--SAS_TRNF_FLAG				BAS_ATTR5	SAS 전송 여부
					--STRT_PROC_FLAG			BAS_ATTR6	시작 공정 여부
					--END_PROC_FLAG				BAS_ATTR7	종료 공정 여부
					--EQPT_GR_DETL_TYPE_CODE	BAS_ATTR8	설비 그룹 상세 유형 코드
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_FORM_ROUT_PROC'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_FORM_ROUT_PROC'
                        MERGE INTO [DBO].[SCM_MMD_FORM_ROUT_PROC] MFP
						USING ( SELECT  @BAS_KEY_ATTR1    AS   ROUTID,
                                        @BAS_KEY_ATTR2    AS   PROCID,
										@BAS_ATTR1        AS   PROC_SEQNO,
										@BAS_ATTR2        AS   LANE_ID,
										@BAS_ATTR3        AS   DELTA_OCV_AFTER_PROCID,
										@BAS_ATTR4        AS   DELTA_OCV_PRE_PROCID,
										@BAS_ATTR5        AS   SAS_TRNF_FLAG,
										@BAS_ATTR6        AS   STRT_PROC_FLAG,
										@BAS_ATTR7        AS   END_PROC_FLAG,
										@BAS_ATTR8        AS   EQPT_GR_DETL_TYPE_CODE,
										@USE_FLAG         AS   ACTIVE_FLAG
											 ) XXX
						ON    (     MFP.[ROUTID]   = XXX.ROUTID
								AND MFP.[PROCID]   = XXX.PROCID )
						WHEN MATCHED THEN
							UPDATE SET  MFP.[PROC_SEQNO]             = XXX.[PROC_SEQNO],
										MFP.[LANE_ID]				 = XXX.[LANE_ID],
										MFP.[DELTA_OCV_AFTER_PROCID] = XXX.[DELTA_OCV_AFTER_PROCID],
										MFP.[DELTA_OCV_PRE_PROCID]	 = XXX.[DELTA_OCV_PRE_PROCID],
										MFP.[SAS_TRNF_FLAG]			 = XXX.[SAS_TRNF_FLAG],
										MFP.[STRT_PROC_FLAG]		 = XXX.[STRT_PROC_FLAG],
										MFP.[END_PROC_FLAG]			 = XXX.[END_PROC_FLAG],
										MFP.[EQPT_GR_DETL_TYPE_CODE] = XXX.[EQPT_GR_DETL_TYPE_CODE],
										MFP.[ACTIVE_FLAG]			 = XXX.[ACTIVE_FLAG],
										MFP.[UPDATE_ID]				 = 'PR_XIF_MMD_ALL_R',
										MFP.[UPDATE_TIME]			 = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([ROUTID]
								  ,[PROCID]
								  ,[PROC_SEQNO]
								  ,[LANE_ID]
								  ,[DELTA_OCV_AFTER_PROCID]
								  ,[DELTA_OCV_PRE_PROCID]
								  ,[SAS_TRNF_FLAG]
								  ,[STRT_PROC_FLAG]
								  ,[END_PROC_FLAG]
								  ,[EQPT_GR_DETL_TYPE_CODE]
								  ,[ACTIVE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
									)
							VALUES ([ROUTID]
								   ,[PROCID]
								   ,[PROC_SEQNO]
								   ,[LANE_ID]
								   ,[DELTA_OCV_AFTER_PROCID]
								   ,[DELTA_OCV_PRE_PROCID]
								   ,[SAS_TRNF_FLAG]
								   ,[STRT_PROC_FLAG]
								   ,[END_PROC_FLAG]
								   ,[EQPT_GR_DETL_TYPE_CODE]
								   ,[ACTIVE_FLAG]
								   ,'PR_XIF_MMD_ALL_R'
								   ,GETDATE()
								   ,'PR_XIF_MMD_ALL_R'
								   ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_FORM_ROUT_PROC'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_FORM_ROUT_PROC'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_FORM_ROUT_PROC'
					--ROUTID					BAS_KEY_ATTR1	라우트아이디
					--PROCID					BAS_KEY_ATTR2	공정아이디
					--PROC_STEP_NO				BAS_KEY_ATTR3	공정 단계 번호
					--END_TIME					BAS_ATTR2	종료 시간
					--CCURNT_VALUE				BAS_ATTR3	정전류 값
					--CVLTG_VALUE				BAS_ATTR4	정전압 값
					--END_CAPA_VALUE			BAS_ATTR5	종료 용량 값
					--END_CURNT_VALUE			BAS_ATTR6	종료 전류 값
					--END_VLTG_VALUE			BAS_ATTR7	종료 전압 값
					--VLTG_MAX_VALUE			BAS_ATTR8	전압 최대 값
					--VLTG_MIN_VALUE			BAS_ATTR9	전압 최소 값
					--JUDG_VLTG_VALUE			BAS_ATTR10	판정 전압 값
					--OCV_MIN_VALUE				BAS_ATTR11	OCV 최소 값
					--OCV_MAX_VALUE				BAS_ATTR12	OCV 최대 값
					--OCV_OFFSET_VALUE			BAS_ATTR13	OCV 오프셋 값
					--CURNT_MIN_VALUE			BAS_ATTR14	전류 최소 값
					--CURNT_MAX_VALUE			BAS_ATTR15	전류 최대 값
					--MGFORM_CURNT_VALUE		BAS_ATTR16	대용량충방전 전류 값
					--MGFORM_TIME				BAS_ATTR17	대용량충방전 시간
					--MGFORM_MEASR_TIME			BAS_ATTR18	대용량충방전 측정 시간
					--LIMIT_TIME				BAS_ATTR19	한계 시간
					--WAIT_TIME					BAS_ATTR20	대기 시간
					--AGING_MIN_TIME			BAS_ATTR21	에이징 최소 시간
					--AGING_MAX_TIME			BAS_ATTR22	에이징 최대 시간
					--TMPR_VALUE				BAS_ATTR23	온도 값
					--PRESS_VALUE				BAS_ATTR24	압력 값
					--SET_AFTER_PROG_TIME		BAS_ATTR25	설정 이후 진행 시간
					--SUBLOT_DFCT_LIMIT_QTY		BAS_ATTR26	SUBLOT 불량 한계 수량
					--SUBLOT_DFCT_LIMIT_USE_FLAG	BAS_ATTR27	SUBLOT 불량 한계 사용 여부
					--PRFL_VLTG_DEVL_VALUE		BAS_ATTR28	프로파일 전압 편차 값
					--RECIPE_DESC				BAS_ATTR29	레시피 설명
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_FORM_ROUT_PROC_RECIPE'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_FORM_ROUT_PROC_RECIPE'
                        MERGE INTO [DBO].[SCM_MMD_FORM_ROUT_PROC_RECIPE] RPR
						USING ( SELECT  @BAS_KEY_ATTR1    AS   ROUTID,
                                        @BAS_KEY_ATTR2    AS   PROCID,
										@BAS_KEY_ATTR3    AS   PROC_STEP_NO,
										@BAS_ATTR2        AS   END_TIME,
										@BAS_ATTR3		  AS   CCURNT_VALUE,
										@BAS_ATTR4		  AS   CVLTG_VALUE,
										@BAS_ATTR5		  AS   END_CAPA_VALUE,
										@BAS_ATTR6		  AS   END_CURNT_VALUE,
										@BAS_ATTR7		  AS   END_VLTG_VALUE,
										@BAS_ATTR8		  AS   VLTG_MAX_VALUE,
										@BAS_ATTR9		  AS   VLTG_MIN_VALUE,
										@BAS_ATTR10		  AS   JUDG_VLTG_VALUE,
										@BAS_ATTR11		  AS   OCV_MIN_VALUE,
										@BAS_ATTR12		  AS   OCV_MAX_VALUE,
										@BAS_ATTR13		  AS   OCV_OFFSET_VALUE,
										@BAS_ATTR14		  AS   CURNT_MIN_VALUE,
										@BAS_ATTR15		  AS   CURNT_MAX_VALUE,
										@BAS_ATTR16		  AS   MGFORM_CURNT_VALUE,
										@BAS_ATTR17		  AS   MGFORM_TIME,
										@BAS_ATTR18		  AS   MGFORM_MEASR_TIME,
										@BAS_ATTR19		  AS   LIMIT_TIME,
										@BAS_ATTR20		  AS   WAIT_TIME,
										@BAS_ATTR21		  AS   AGING_MIN_TIME,
										@BAS_ATTR22		  AS   AGING_MAX_TIME,
										@BAS_ATTR23		  AS   TMPR_VALUE,
										@BAS_ATTR24		  AS   PRESS_VALUE,
										@BAS_ATTR25		  AS   SET_AFTER_PROG_TIME,
										@BAS_ATTR26		  AS   SUBLOT_DFCT_LIMIT_QTY,
										@BAS_ATTR27		  AS   SUBLOT_DFCT_LIMIT_USE_FLAG,
										@BAS_ATTR28		  AS   PRFL_VLTG_DEVL_VALUE,
										@BAS_ATTR29		  AS   RECIPE_DESC,
										@USE_FLAG         AS   ACTIVE_FLAG
											 ) XXX
						ON    (     RPR.[ROUTID]   = XXX.ROUTID
								AND RPR.[PROCID]   = XXX.PROCID
								AND RPR.[PROC_STEP_NO] = XXX.PROC_STEP_NO)
						WHEN MATCHED THEN
							UPDATE SET  RPR.[END_TIME]                   = XXX.[END_TIME],
										RPR.[CCURNT_VALUE]				 = XXX.[CCURNT_VALUE],
										RPR.[CVLTG_VALUE]				 = XXX.[CVLTG_VALUE],
										RPR.[END_CAPA_VALUE]			 = XXX.[END_CAPA_VALUE],
										RPR.[END_CURNT_VALUE]			 = XXX.[END_CURNT_VALUE],
										RPR.[END_VLTG_VALUE]			 = XXX.[END_VLTG_VALUE],
										RPR.[VLTG_MAX_VALUE]			 = XXX.[VLTG_MAX_VALUE],
										RPR.[VLTG_MIN_VALUE]			 = XXX.[VLTG_MIN_VALUE],
										RPR.[JUDG_VLTG_VALUE]			 = XXX.[JUDG_VLTG_VALUE],
										RPR.[OCV_MIN_VALUE]				 = XXX.[OCV_MIN_VALUE],
										RPR.[OCV_MAX_VALUE]				 = XXX.[OCV_MAX_VALUE],
										RPR.[OCV_OFFSET_VALUE]			 = XXX.[OCV_OFFSET_VALUE],
										RPR.[CURNT_MIN_VALUE]			 = XXX.[CURNT_MIN_VALUE],
										RPR.[CURNT_MAX_VALUE]			 = XXX.[CURNT_MAX_VALUE],
										RPR.[MGFORM_CURNT_VALUE]		 = XXX.[MGFORM_CURNT_VALUE],
										RPR.[MGFORM_TIME]				 = XXX.[MGFORM_TIME],
										RPR.[MGFORM_MEASR_TIME]			 = XXX.[MGFORM_MEASR_TIME],
										RPR.[LIMIT_TIME]				 = XXX.[LIMIT_TIME],
										RPR.[WAIT_TIME]					 = XXX.[WAIT_TIME],
										RPR.[AGING_MIN_TIME]			 = XXX.[AGING_MIN_TIME],
										RPR.[AGING_MAX_TIME]			 = XXX.[AGING_MAX_TIME],
										RPR.[TMPR_VALUE]				 = XXX.[TMPR_VALUE],
										RPR.[PRESS_VALUE]				 = XXX.[PRESS_VALUE],
										RPR.[SET_AFTER_PROG_TIME]		 = XXX.[SET_AFTER_PROG_TIME],
										RPR.[SUBLOT_DFCT_LIMIT_QTY]		 = XXX.[SUBLOT_DFCT_LIMIT_QTY],
										RPR.[SUBLOT_DFCT_LIMIT_USE_FLAG] = XXX.[SUBLOT_DFCT_LIMIT_USE_FLAG],
										RPR.[PRFL_VLTG_DEVL_VALUE]		 = XXX.[PRFL_VLTG_DEVL_VALUE],
										RPR.[RECIPE_DESC]				 = XXX.[RECIPE_DESC],
										RPR.[ACTIVE_FLAG]			     = XXX.[ACTIVE_FLAG],
										RPR.[UPDATE_ID]				     = 'PR_XIF_MMD_ALL_R',
										RPR.[UPDATE_TIME]			     = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([ROUTID]
								  ,[PROCID]
								  ,[PROC_STEP_NO]
								  ,[END_TIME]
								  ,[CCURNT_VALUE]
								  ,[CVLTG_VALUE]
								  ,[END_CAPA_VALUE]
								  ,[END_CURNT_VALUE]
								  ,[END_VLTG_VALUE]
								  ,[VLTG_MAX_VALUE]
								  ,[VLTG_MIN_VALUE]
								  ,[JUDG_VLTG_VALUE]
								  ,[OCV_MIN_VALUE]
								  ,[OCV_MAX_VALUE]
								  ,[OCV_OFFSET_VALUE]
								  ,[CURNT_MIN_VALUE]
								  ,[CURNT_MAX_VALUE]
								  ,[MGFORM_CURNT_VALUE]
								  ,[MGFORM_TIME]
								  ,[MGFORM_MEASR_TIME]
								  ,[LIMIT_TIME]
								  ,[WAIT_TIME]
								  ,[AGING_MIN_TIME]
								  ,[AGING_MAX_TIME]
								  ,[TMPR_VALUE]
								  ,[PRESS_VALUE]
								  ,[SET_AFTER_PROG_TIME]
								  ,[SUBLOT_DFCT_LIMIT_QTY]
								  ,[SUBLOT_DFCT_LIMIT_USE_FLAG]
								  ,[PRFL_VLTG_DEVL_VALUE]
								  ,[RECIPE_DESC]
								  ,[ACTIVE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
									)
							VALUES (XXX.[ROUTID]
								  ,XXX.[PROCID]
								  ,XXX.[PROC_STEP_NO]
								  ,XXX.[END_TIME]
								  ,XXX.[CCURNT_VALUE]
								  ,XXX.[CVLTG_VALUE]
								  ,XXX.[END_CAPA_VALUE]
								  ,XXX.[END_CURNT_VALUE]
								  ,XXX.[END_VLTG_VALUE]
								  ,XXX.[VLTG_MAX_VALUE]
								  ,XXX.[VLTG_MIN_VALUE]
								  ,XXX.[JUDG_VLTG_VALUE]
								  ,XXX.[OCV_MIN_VALUE]
								  ,XXX.[OCV_MAX_VALUE]
								  ,XXX.[OCV_OFFSET_VALUE]
								  ,XXX.[CURNT_MIN_VALUE]
								  ,XXX.[CURNT_MAX_VALUE]
								  ,XXX.[MGFORM_CURNT_VALUE]
								  ,XXX.[MGFORM_TIME]
								  ,XXX.[MGFORM_MEASR_TIME]
								  ,XXX.[LIMIT_TIME]
								  ,XXX.[WAIT_TIME]
								  ,XXX.[AGING_MIN_TIME]
								  ,XXX.[AGING_MAX_TIME]
								  ,XXX.[TMPR_VALUE]
								  ,XXX.[PRESS_VALUE]
								  ,XXX.[SET_AFTER_PROG_TIME]
								  ,XXX.[SUBLOT_DFCT_LIMIT_QTY]
								  ,XXX.[SUBLOT_DFCT_LIMIT_USE_FLAG]
								  ,XXX.[PRFL_VLTG_DEVL_VALUE]
								  ,XXX.[RECIPE_DESC]
								  ,XXX.[ACTIVE_FLAG]
								   ,'PR_XIF_MMD_ALL_R'
								   ,GETDATE()
								   ,'PR_XIF_MMD_ALL_R'
								   ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_FORM_ROUT_PROC_RECIPE'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_FORM_ROUT_PROC_RECIPE'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_FORM_ROUT_PROC_RECIPE'
			-- 2021-11-01 kimcd 활성화 Route 수신 끝
			-- 2022-01-18 kimcd 전극 후 공정용 기준 정보 수신 시작
			-- RACK_ID	            랙 아이디	            BAS_KEY_ATTR1	String	50	Not Null
			-- RACK_STAT_CODE	    랙 상태 코드	        BAS_ATTR1	String	50
			-- X_PSTN	            X 위치	                BAS_ATTR2	Integer	22
			-- Y_PSTN	            Y 위치	                BAS_ATTR3	Integer	22
			-- Z_PSTN	            Z 위치	                BAS_ATTR4	Integer	22
			-- LINK_EQSGID	        연결 설비세그먼트아이디	BAS_ATTR5	String	50
			-- RCV_PRIORITY	        입고 우선도	            BAS_ATTR6	Integer	22
			-- ZONE_ID	            구역 아이디	            BAS_ATTR7	String	50	Not NUull
			-- MCS_CST_ID	        MCS캐리어 아이디	    BAS_ATTR8	String	50
			-- EQPTID	            설비아이디	            BAS_ATTR9	String	1	Not Null
			-- EMPTY_REEL_TYPE_CODE	빈 REEL 유형 코드	    BAS_ATTR10	String	50	Not Null
			-- REEL_TYPE_CODE	    REEL 유형 코드	        BAS_ATTR11	DateTime	26	Not Null
			-- USE_FLAG	            사용 여부	            USE_FLAG	String	50
            ELSE IF @BAS_ITEM_ID = 'TB_MCS_RACK'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					SET @v_temp1 = 'STEP MERGE SCM_MMD_MCS_RACK_M'


                    MERGE INTO [DBO].[SCM_MMD_MCS_RACK_M] MMR
					USING ( SELECT  @BAS_KEY_ATTR1    AS   RACK_ID,
									@BAS_ATTR1        AS   RACK_STAT_CODE,
									CASE WHEN @BAS_ATTR2 = '' THEN NULL ELSE @BAS_ATTR2 END AS   X_PSTN,
									CASE WHEN @BAS_ATTR3 = '' THEN NULL ELSE @BAS_ATTR3 END AS   Y_PSTN,
									CASE WHEN @BAS_ATTR4 = '' THEN NULL ELSE @BAS_ATTR4 END AS   Z_PSTN,  -- 2024-01-25 NUMERIC 전환 오류 처리 kimcd
									@BAS_ATTR5		  AS   LINK_EQSGID,
									CASE WHEN @BAS_ATTR6 = '' THEN NULL ELSE @BAS_ATTR6 END	AS   RCV_PRIORITY,
									@BAS_ATTR7		  AS   ZONE_ID,
									@BAS_ATTR8		  AS   MCS_CST_ID,
									ISNULL(@BAS_ATTR9, '-')	 AS   EQPTID,
									@BAS_ATTR10		  AS   EMPTY_REEL_TYPE_CODE,
									@BAS_ATTR11		  AS   REEL_TYPE_CODE,
									@USE_FLAG         AS   USE_FLAG
											) XXX
					ON    (     MMR.[RACK_ID]   = XXX.RACK_ID)
					WHEN MATCHED THEN
						UPDATE SET	MMR.[RACK_STAT_CODE]       = XXX.RACK_STAT_CODE,
									MMR.[X_PSTN]               = XXX.X_PSTN,
									MMR.[Y_PSTN]               = XXX.Y_PSTN,
									MMR.[Z_PSTN]               = XXX.Z_PSTN,
									MMR.[LINK_EQUIPMENT_ID]    = XXX.LINK_EQSGID,
									MMR.[RCV_PRIORITY]         = XXX.RCV_PRIORITY,
									MMR.[ZONE_ID]              = XXX.ZONE_ID,
									MMR.[MCS_CST_ID]           = XXX.MCS_CST_ID,
									MMR.[EQUIPMENT_ID]         = XXX.EQPTID,
									MMR.[EMPTY_REEL_TYPE_CODE] = XXX.EMPTY_REEL_TYPE_CODE,
									MMR.[REEL_TYPE_CODE]       = XXX.REEL_TYPE_CODE,
									MMR.[USE_FLAG]             = XXX.USE_FLAG,
									MMR.[UPDATE_ID]			   = 'PR_XIF_MMD_ALL_R',
									MMR.[UPDATE_TIME]		   = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT([RACK_ID]
								,[RACK_STAT_CODE]
								,[X_PSTN]
								,[Y_PSTN]
								,[Z_PSTN]
								,[LINK_EQUIPMENT_ID]
								,[RCV_PRIORITY]
								,[ZONE_ID]
								,[MCS_CST_ID]
								,[EQUIPMENT_ID]
								,[EMPTY_REEL_TYPE_CODE]
								,[REEL_TYPE_CODE]
								,[USE_FLAG]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
								)
						VALUES ( XXX.[RACK_ID]
								,XXX.[RACK_STAT_CODE]
								,XXX.[X_PSTN]
								,XXX.[Y_PSTN]
								,XXX.[Z_PSTN]
								,XXX.[LINK_EQSGID]
								,XXX.[RCV_PRIORITY]
								,XXX.[ZONE_ID]
								,XXX.[MCS_CST_ID]
								,XXX.[EQPTID]
								,XXX.[EMPTY_REEL_TYPE_CODE]
								,XXX.[REEL_TYPE_CODE]
								,XXX.[USE_FLAG]
								,'PR_XIF_MMD_ALL_R'
								,GETDATE()
								,'PR_XIF_MMD_ALL_R'
								,GETDATE()
								);


					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
						SET @PROCESS_FLAG = 'N'


                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MCS_RACK'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MCS_RACK'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MCS_RACK'

				--AREAID		영역아이디		BAS_KEY_ATTR1	String	50	N
				--PRODID		제품아이디		BAS_KEY_ATTR2	String	50	N
				--LOTTYPE		LOT유형			BAS_KEY_ATTR3	String	50	N
				--COATER_EQPTID	코터 설비아이디	BAS_KEY_ATTR4	String	50	N
				--CERT_GR_NAME	인증 그룹 명	BAS_ATTR1	String	1000	Y
				--NOTE			비고			BAS_ATTR2	String	1000	Y
				--USE_FLAG		사용여부		USE_FLAG	String	1	N
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_ELTR_CERT_GR'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_ELECTRODE_CERTI_GROUP_M'
                        MERGE INTO [DBO].[SCM_MMD_ELECTRODE_CERTI_GROUP_M] MECG
						USING ( SELECT  @BAS_KEY_ATTR1    AS   FACTORY_ID,
										@BAS_KEY_ATTR2    AS   ITEM_ID,
										@BAS_KEY_ATTR3    AS   LOTTYPE,
										@BAS_KEY_ATTR4    AS   COATER_EQUIPMENT_ID,
										@BAS_ATTR1        AS   CERT_GR_NAME,
										@BAS_ATTR2        AS   NOTE,
										@USE_FLAG         AS   USE_FLAG
											 ) XXX
						ON    (     MECG.[FACTORY_ID]		   = XXX.FACTORY_ID
								AND MECG.[ITEM_ID]			   = XXX.ITEM_ID
								AND MECG.[LOTTYPE]			   = XXX.LOTTYPE
								AND MECG.[COATER_EQUIPMENT_ID] = XXX.COATER_EQUIPMENT_ID
								)
						WHEN MATCHED THEN
							UPDATE SET	MECG.[CERT_GR_NAME] = XXX.CERT_GR_NAME,
										MECG.[NOTE]			= XXX.NOTE,
										MECG.[USE_FLAG]     = XXX.USE_FLAG,
										MECG.[UPDATE_ID]	= 'PR_XIF_MMD_ALL_R',
										MECG.[UPDATE_TIME]	= GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([FACTORY_ID]
								  ,[ITEM_ID]
								  ,[LOTTYPE]
								  ,[COATER_EQUIPMENT_ID]
								  ,[CERT_GR_NAME]
								  ,[NOTE]
								  ,[USE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
								   )
							VALUES ( XXX.[FACTORY_ID]
									,XXX.[ITEM_ID]
									,XXX.[LOTTYPE]
									,XXX.[COATER_EQUIPMENT_ID]
									,XXX.[CERT_GR_NAME]
									,XXX.[NOTE]
									,XXX.[USE_FLAG]
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_ELTR_CERT_GR'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_ELTR_CERT_GR'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_ELTR_CERT_GR'
				--AREAID			영역아이디		BAS_KEY_ATTR1	String	50	N
				--PRODID			제품아이디		BAS_KEY_ATTR2	String	50	N
				--LOTTYPE			LOT유형			BAS_KEY_ATTR3	String	50	N
				--COATER_EQPTID		코터 설비아이디	BAS_KEY_ATTR4	String	50	N
				--PROCID			공정아이디		BAS_KEY_ATTR5	String	50	N
				--EQPTID			설비아이디		BAS_KEY_ATTR6	String	50	N
				--USE_FLAG			사용여부		USE_FLAG		String	1	N
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_ELTR_CERT_GR_EQPT'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_ELECTRODE_CERTI_GROUP_EQPT_M'
                        MERGE INTO [DBO].[SCM_MMD_ELECTRODE_CERTI_GROUP_EQPT_M] MECE
						USING ( SELECT  @BAS_KEY_ATTR1    AS   FACTORY_ID,
										@BAS_KEY_ATTR2    AS   ITEM_ID,
										@BAS_KEY_ATTR3    AS   LOTTYPE,
										@BAS_KEY_ATTR4    AS   COATER_EQUIPMENT_ID,
										@BAS_KEY_ATTR5    AS   OPERATION_ID,
										@BAS_KEY_ATTR6    AS   EQUIPMENT_ID,
										@USE_FLAG         AS   USE_FLAG
											 ) XXX
						ON    (     MECE.[FACTORY_ID]		   = XXX.FACTORY_ID
								AND MECE.[ITEM_ID]			   = XXX.ITEM_ID
								AND MECE.[LOTTYPE]			   = XXX.LOTTYPE
								AND MECE.[COATER_EQUIPMENT_ID] = XXX.COATER_EQUIPMENT_ID
								AND MECE.[OPERATION_ID]		   = XXX.OPERATION_ID
								AND MECE.[EQUIPMENT_ID]		   = XXX.EQUIPMENT_ID
								)
						WHEN MATCHED THEN
							UPDATE SET	MECE.[USE_FLAG]     = XXX.USE_FLAG,
										MECE.[UPDATE_ID]	= 'PR_XIF_MMD_ALL_R',
										MECE.[UPDATE_TIME]	= GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([FACTORY_ID]
								  ,[ITEM_ID]
								  ,[LOTTYPE]
								  ,[COATER_EQUIPMENT_ID]
								  ,[OPERATION_ID]
								  ,[EQUIPMENT_ID]
								  ,[USE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
								   )
							VALUES ( XXX.[FACTORY_ID]
									,XXX.[ITEM_ID]
									,XXX.[LOTTYPE]
									,XXX.[COATER_EQUIPMENT_ID]
									,XXX.[OPERATION_ID]
									,XXX.[EQUIPMENT_ID]
									,XXX.[USE_FLAG]
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_ELTR_CERT_GR_EQPT'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_ELTR_CERT_GR_EQPT'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_ELTR_CERT_GR_EQPT'
			-- 2022-01-18 kimcd 전극 후 공정용 기준 정보 수신 끝
			-- 2022-02-23 kimcd 전극 후 공정용 창고, 창고 rack 연결 정보 수신 시작
			-- RACK_ID	            랙 아이디				BAS_KEY_ATTR1	String	50	N
			-- WH_ID	            창고 아이디				BAS_ATTR1	String	50	Y
			-- MAX_LOAD_QTY			최대 적재 수량			BAS_ATTR2	Decimal	18	Y
			-- MTRL_CLSS_CODE		자재 분류 코드			BAS_ATTR3	String	50	Y  J : Jumbo roll, P : Pancake, K : pack, etc
			-- ELTR_TYPE_CODE		전극 유형 코드			BAS_ATTR4	String	50	Y  C : 양극, A : 음극
			-- LOAD_UNIT_CODE		적재 단위 코드			BAS_ATTR5	String	50	Y  L : Lot, C : Slitter Cut, P : Pallet, T : Tray
			-- SCRN_X_POSITN_VALUE	화면 X 위치 값			BAS_ATTR6	Integer	22	Y
			-- SCRN_Y_POSITN_VALUE	화면 Y 위치 값			BAS_ATTR7	Integer	22	Y
			-- SCRN_QTY_PSTN_CODE	화면 수량 위치 코드		BAS_ATTR8	String	50	Y
			-- RACK_USG_CODE		랙 용도 코드			BAS_ATTR9	String	50	Y  STORGE : 보관용, STOPOVER : 경유용
			-- RACK_NAME			랙 명					BAS_ATTR10	String	1000	Y -- 문자열 분리 필요
			-- USE_FLAG				사용 여부				USE_FLAG	String	1	N
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_RACK'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_PRDT_WH_RACK_M'
                        MERGE INTO [DBO].[SCM_MMD_PRDT_WH_RACK_M] MWR
						USING ( SELECT  @BAS_KEY_ATTR1    AS   RACK_ID,
										@BAS_ATTR1        AS   WH_ID,
										CASE WHEN @BAS_ATTR2 = '' THEN NULL ELSE @BAS_ATTR2 END  AS   MAX_LOAD_QTY,
										@BAS_ATTR3		  AS   MTRL_CLSS_CODE,
										@BAS_ATTR4		  AS   ELECTRODE_TYPE,
										@BAS_ATTR5		  AS   LOAD_UNIT_CODE,
										CASE WHEN @BAS_ATTR6 = '' THEN NULL ELSE @BAS_ATTR6 END	 AS   SCRN_X_POSITN_VALUE,
										CASE WHEN @BAS_ATTR7 = '' THEN NULL ELSE @BAS_ATTR7 END	 AS   SCRN_Y_POSITN_VALUE,
										@BAS_ATTR8		  AS   SCRN_QTY_PSTN_CODE,
										@BAS_ATTR9		  AS   RACK_USG_CODE,
										ISNULL( [DBO].[FN_GET_NAME]( @LANG_TXT, @BAS_ATTR10) 
										       ,[DBO].[FN_GET_NAME]( @KR_LANG_TXT, @BAS_ATTR10) 
										       ) 		  AS   RACK_NAME,
										@USE_FLAG         AS   USE_FLAG
											 ) XXX
						ON    (     MWR.[RACK_ID]   = XXX.RACK_ID)
						WHEN MATCHED THEN
							UPDATE SET	MWR.[WH_ID]               = XXX.[WH_ID],
									    MWR.[MAX_LOAD_QTY]		  = XXX.[MAX_LOAD_QTY],
									    MWR.[MTRL_CLSS_CODE]	  = XXX.[MTRL_CLSS_CODE],
									    MWR.[ELECTRODE_TYPE]	  = XXX.[ELECTRODE_TYPE],
									    MWR.[LOAD_UNIT_CODE]	  = XXX.[LOAD_UNIT_CODE],
									    MWR.[SCRN_X_POSITN_VALUE] = XXX.[SCRN_X_POSITN_VALUE],
									    MWR.[SCRN_Y_POSITN_VALUE] = XXX.[SCRN_Y_POSITN_VALUE],
									    MWR.[SCRN_QTY_PSTN_CODE]  = XXX.[SCRN_QTY_PSTN_CODE],
									    MWR.[RACK_USG_CODE]		  = XXX.[RACK_USG_CODE],
									    MWR.[RACK_NAME]			  = XXX.[RACK_NAME],
									    MWR.[USE_FLAG]			  = XXX.[USE_FLAG],
										MWR.[UPDATE_ID]	          = 'PR_XIF_MMD_ALL_R',
										MWR.[UPDATE_TIME]		  = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([RACK_ID]
								  ,[WH_ID]
								  ,[MAX_LOAD_QTY]
								  ,[MTRL_CLSS_CODE]
								  ,[ELECTRODE_TYPE]
								  ,[LOAD_UNIT_CODE]
								  ,[SCRN_X_POSITN_VALUE]
								  ,[SCRN_Y_POSITN_VALUE]
								  ,[SCRN_QTY_PSTN_CODE]
								  ,[RACK_USG_CODE]
								  ,[RACK_NAME]
								  ,[USE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
								   )
							VALUES ( XXX.[RACK_ID]
									,XXX.[WH_ID]
									,XXX.[MAX_LOAD_QTY]
									,XXX.[MTRL_CLSS_CODE]
									,XXX.[ELECTRODE_TYPE]
									,XXX.[LOAD_UNIT_CODE]
									,XXX.[SCRN_X_POSITN_VALUE]
									,XXX.[SCRN_Y_POSITN_VALUE]
									,XXX.[SCRN_QTY_PSTN_CODE]
									,XXX.[RACK_USG_CODE]
									,XXX.[RACK_NAME]
									,XXX.[USE_FLAG]
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_RACK'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_RACK'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_RACK'
			-- WH_ID						창고 아이디					BAS_KEY_ATTR1	String	50	N
			-- WH_NAME						창고 명						BAS_ATTR1	String	1000	Y
			-- WH_TYPE_CODE					창고 유형 코드				BAS_ATTR2	String	50	Y
			-- AREAID						영역아이디					BAS_ATTR3	String	50	Y
			-- FLOOR_NO						층 수						BAS_ATTR4	Integer	22	Y
			-- WH_PHYS_PSTN_CODE			창고 물리 위치 코드			BAS_ATTR5	String	50	Y
			-- WH_MNT_GR_CODE				창고 모니터 그룹 코드		BAS_ATTR6	String	50	Y
			-- WH_ABBR_NAME					창고 약어 명				BAS_ATTR7	String	1000	Y
			-- FCS_OPER_LANE				FCS OPERATION LANE			BAS_ATTR8	String	50	Y
			-- AUTO_WH_FLAG					자동 창고 여부				BAS_ATTR9	String	1	Y
			-- WH_LOAD_CHK_EXCL_FLAG		창고 적재 체크 제외 여부	BAS_ATTR10	String	1	Y
			-- OPTM_LOAD_RATE				적정 적재 율				BAS_ATTR11	Decimal	18	Y
			-- EMPTY_SKID_STORAGE_MIN_QTY	빈 SKID 보관 최소 수량		BAS_ATTR12	Integer	22	Y
			-- ELTR_TYPE_CHK_FLAG			전극 유형 체크 여부			BAS_ATTR13	String	1	Y
			-- EMPTY_CST_STORAGE_QTY		빈 캐리어 보관 수량			BAS_ATTR14	Integer	22	Y
			-- RTN_STORAGE_QTY				반품 보관 수량				BAS_ATTR15	Integer	22	Y
			-- USE_FLAG						사용 여부					USE_FLAG	String	1	Y
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_PRDT_WH'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_PRDT_WH_M'
                        MERGE INTO [DBO].[SCM_MMD_PRDT_WH_M] MPW
						USING ( SELECT  @BAS_KEY_ATTR1    AS   WH_ID,
										@BAS_ATTR1        AS   WH_NAME,
										@BAS_ATTR2        AS   WH_TYPE_CODE,
										@BAS_ATTR3		  AS   FACTORY_ID,
										CASE WHEN @BAS_ATTR4 = '' THEN NULL ELSE @BAS_ATTR4 END		  AS   FLOOR_NO,
										@BAS_ATTR5		  AS   WH_PHYS_PSTN_CODE,
										@BAS_ATTR6        AS   WH_MNT_GR_CODE,
										@BAS_ATTR7		  AS   WH_ABBR_NAME,
										@BAS_ATTR8		  AS   FCS_OPER_LANE,
										@BAS_ATTR9		  AS   AUTO_WH_FLAG,
										@BAS_ATTR10		  AS   WH_LOAD_CHK_EXCL_FLAG,
										CASE WHEN @BAS_ATTR11 = '' THEN NULL ELSE @BAS_ATTR11 END	  AS   OPTM_LOAD_RATE,
										CASE WHEN @BAS_ATTR12 = '' THEN NULL ELSE @BAS_ATTR12 END	  AS   EMPTY_SKID_STORAGE_MIN_QTY,
										@BAS_ATTR13		  AS   ELTR_TYPE_CHK_FLAG,
										CASE WHEN @BAS_ATTR14 = '' THEN NULL ELSE @BAS_ATTR14 END	  AS   EMPTY_CST_STORAGE_QTY,
										CASE WHEN @BAS_ATTR15 = '' THEN NULL ELSE @BAS_ATTR15 END	  AS   RTN_STORAGE_QTY,
										@USE_FLAG         AS   USE_FLAG
											 ) XXX
						ON    (     MPW.[WH_ID]   = XXX.WH_ID)
						WHEN MATCHED THEN
							UPDATE SET	MPW.[WH_NAME]                    = XXX.WH_NAME,
										MPW.[WH_TYPE_CODE]               = XXX.WH_TYPE_CODE,
										MPW.[FACTORY_ID]                 = XXX.FACTORY_ID,
										MPW.[FLOOR_NO]                   = XXX.FLOOR_NO,
										MPW.[WH_PHYS_PSTN_CODE]          = XXX.WH_PHYS_PSTN_CODE,
										MPW.[WH_MNT_GR_CODE]             = XXX.WH_MNT_GR_CODE,
										MPW.[WH_ABBR_NAME]               = XXX.WH_ABBR_NAME,
										MPW.[FCS_OPER_LANE]              = XXX.FCS_OPER_LANE,
										MPW.[AUTO_WH_FLAG]               = XXX.AUTO_WH_FLAG,
										MPW.[WH_LOAD_CHK_EXCL_FLAG]      = XXX.WH_LOAD_CHK_EXCL_FLAG,
										MPW.[OPTM_LOAD_RATE]             = XXX.OPTM_LOAD_RATE,
										MPW.[EMPTY_SKID_STORAGE_MIN_QTY] = XXX.EMPTY_SKID_STORAGE_MIN_QTY,
										MPW.[ELTR_TYPE_CHK_FLAG]         = XXX.ELTR_TYPE_CHK_FLAG,
										MPW.[EMPTY_CST_STORAGE_QTY]      = XXX.EMPTY_CST_STORAGE_QTY,
										MPW.[RTN_STORAGE_QTY]            = XXX.RTN_STORAGE_QTY,
										MPW.[USE_FLAG]                   = XXX.USE_FLAG,
										MPW.[UPDATE_ID]	                 = 'PR_XIF_MMD_ALL_R',
										MPW.[UPDATE_TIME]		         = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([WH_ID]
								  ,[WH_NAME]
								  ,[WH_TYPE_CODE]
								  ,[FACTORY_ID]
								  ,[FLOOR_NO]
								  ,[WH_PHYS_PSTN_CODE]
								  ,[WH_MNT_GR_CODE]
								  ,[WH_ABBR_NAME]
								  ,[FCS_OPER_LANE]
								  ,[AUTO_WH_FLAG]
								  ,[WH_LOAD_CHK_EXCL_FLAG]
								  ,[OPTM_LOAD_RATE]
								  ,[EMPTY_SKID_STORAGE_MIN_QTY]
								  ,[ELTR_TYPE_CHK_FLAG]
								  ,[EMPTY_CST_STORAGE_QTY]
								  ,[RTN_STORAGE_QTY]
								  ,[USE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
								   )
							VALUES ( XXX.[WH_ID]
								    ,XXX.[WH_NAME]
								    ,XXX.[WH_TYPE_CODE]
								    ,XXX.[FACTORY_ID]
								    ,XXX.[FLOOR_NO]
								    ,XXX.[WH_PHYS_PSTN_CODE]
								    ,XXX.[WH_MNT_GR_CODE]
								    ,XXX.[WH_ABBR_NAME]
								    ,XXX.[FCS_OPER_LANE]
								    ,XXX.[AUTO_WH_FLAG]
								    ,XXX.[WH_LOAD_CHK_EXCL_FLAG]
								    ,XXX.[OPTM_LOAD_RATE]
								    ,XXX.[EMPTY_SKID_STORAGE_MIN_QTY]
								    ,XXX.[ELTR_TYPE_CHK_FLAG]
								    ,XXX.[EMPTY_CST_STORAGE_QTY]
								    ,XXX.[RTN_STORAGE_QTY]
								    ,XXX.[USE_FLAG]
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_PRDT_WH'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_PRDT_WH'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_PRDT_WH'
            -- 2022-02-23 kimcd 전극 후 공정용 창고, 창고 rack 연결 정보 수신 끝



			---------------------------- START 2022-08-27 leeseongmin [CSR: C20220826-000120] 신규테이블 ---------------------------		
			--	TBL_NAME					테이블 명			BAS_KEY_ATTR1	String	 100	Y
			--	COL_NAME					컬럼 명				BAS_KEY_ATTR2	String	 100	Y
			--	PROC_DETL_TYPE_CODE			공정 상세 유형 코드	BAS_KEY_ATTR3	String	 50		Y
			--	COL_DESC					컬럼 설명			BAS_ATTR1		String	 1000	Y
			--	UI_DISP_UNIT_VALUE			UI 표시 단위 값	    BAS_ATTR2		String	 50		Y
			--	USE_FLAG					사용 여부			USE_FLAG		String	 1		Y

            ELSE IF @BAS_ITEM_ID = 'TB_MMD_NUM_DATA_UNIT_PROC_DETL_TYPE'  
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					    SET @v_temp1 = 'STEP MERGE SCM_MMD_OPERATION_UNIT_M'
                        MERGE INTO [DBO].[SCM_MMD_OPERATION_UNIT_M] SMOU
						USING ( SELECT  @BAS_KEY_ATTR1    AS   TBL_NAME,
										@BAS_KEY_ATTR2    AS   COL_NAME,
										@BAS_KEY_ATTR3    AS   PROC_DETL_TYPE_CODE,
										@BAS_ATTR1		  AS   COL_DESC,										
										@BAS_ATTR2		  AS   UI_DISP_UNIT_VALUE,
										@USE_FLAG         AS   USE_FLAG		
									   ) XXX
						ON    ( SMOU.[TBL_NAME]              = XXX.TBL_NAME
						    AND SMOU.[COL_NAME]              = XXX.COL_NAME
						    AND SMOU.[PROC_DETL_TYPE_CODE]   = XXX.PROC_DETL_TYPE_CODE )
						WHEN MATCHED THEN
							UPDATE SET	SMOU.[COL_DESC]                   = XXX.COL_DESC,
										SMOU.[UI_DISP_UNIT_VALUE]         = XXX.UI_DISP_UNIT_VALUE,									
										SMOU.[USE_FLAG]                   = XXX.USE_FLAG,
										SMOU.[UPDATE_ID]	              = 'PR_XIF_MMD_ALL_R',
										SMOU.[UPDATE_TIME]		          = GETDATE()
						WHEN NOT MATCHED THEN
							INSERT([TBL_NAME]
								  ,[COL_NAME]
								  ,[PROC_DETL_TYPE_CODE]
								  ,[COL_DESC]
								  ,[UI_DISP_UNIT_VALUE]
								  ,[USE_FLAG]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[UPDATE_ID]
								  ,[UPDATE_TIME]
								   )
							VALUES ( XXX.[TBL_NAME]
								    ,XXX.[COL_NAME]
								    ,XXX.[PROC_DETL_TYPE_CODE]
								    ,XXX.[COL_DESC]
								    ,XXX.[UI_DISP_UNIT_VALUE]
								    ,XXX.[USE_FLAG]
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
								    ,'PR_XIF_MMD_ALL_R'
								    ,GETDATE()
									);

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'Y'
							   ,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_NUM_DATA_UNIT_PROC_DETL_TYPE'
							AND   [IF_SEQ]    = @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
						SET [PROC_FLAG] = 'N'
						   ,[UPDDTTM]   = GETDATE()
						WHERE [PROC_FLAG] = 'P'
						AND   [BAS_ITEM_ID] = 'TB_MMD_NUM_DATA_UNIT_PROC_DETL_TYPE'
						AND   [IF_SEQ]    = @IF_SEQ;
				END; -- @BAS_ITEM_ID = 'TB_MMD_NUM_DATA_UNIT_PROC_DETL_TYPE'            

			---------------------------- END 2022-08-27 leeseongmin [CSR: C20220826-000120] 신규테이블 ---------------------------
			--TB_MMD_EQPT_PRDT_SPEED
            ELSE IF @BAS_ITEM_ID = 'TB_MMD_EQPT_PRDT_SPEED'
			    BEGIN
				    SET @PROCESS_FLAG = 'N'

					SET @v_temp1 = 'STEP MERGE SCM_MMD_EQP_PRDN_SPED'
                    MERGE INTO SCM_MMD_EQP_PRDN_SPED AS SPED
					USING ( 
					      SELECT @BAS_KEY_ATTR1		AS  EQP_ID
						       , @BAS_KEY_ATTR2		AS  BOM_ITEM_ID
							   , @BAS_ATTR1			AS  EQP_SPED 
							   , @BAS_ATTR2			AS  NOCH_CAVT_NVL
							   , @USE_FLAG			AS  USE_FLAG
						  ) XXX
					  ON SPED.EQP_ID		= XXX.EQP_ID
					 AND SPED.BOM_ITEM_ID	= XXX.BOM_ITEM_ID
					WHEN MATCHED THEN
						UPDATE SET 
						       SPED.EQP_SPED		= XXX.EQP_SPED 
							 , SPED.NOCH_CAVT_NVL	= XXX.NOCH_CAVT_NVL
							 , SPED.USE_FLAG		= XXX.USE_FLAG
							 , SPED.UPDATE_ID		= 'PR_XIF_MMD_ALL_R'
							 , SPED.UPDATE_TIME		= GETDATE()
					WHEN NOT MATCHED THEN
						INSERT  
						     ( EQP_ID
							 , BOM_ITEM_ID
							 , EQP_SPED
							 , NOCH_CAVT_NVL
							 , USE_FLAG
							 , INSERT_ID
							 , INSERT_TIME
							 , UPDATE_ID
							 , UPDATE_TIME
							 )
						VALUES ( 
						       XXX.EQP_ID
							 , XXX.BOM_ITEM_ID
							 , XXX.EQP_SPED
							 , XXX.NOCH_CAVT_NVL
							 , XXX.USE_FLAG
							 , 'PR_XIF_MMD_ALL_R'
							 , GETDATE()
							 , 'PR_XIF_MMD_ALL_R'
							 , GETDATE()
							 );

					IF 	@@ROWCOUNT > 0
						SET @PROCESS_FLAG = 'Y'
					ELSE
					    SET @PROCESS_FLAG = 'N'

                    IF @PROCESS_FLAG = 'Y'
					    BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							   SET [PROC_FLAG]		= 'Y'
							     , [UPDDTTM]		= GETDATE()
							 WHERE [PROC_FLAG]		= 'P'
							   AND [BAS_ITEM_ID]	= 'TB_MMD_EQPT_PRDT_SPEED'
							   AND [IF_SEQ]			= @IF_SEQ;

							SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
							SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

							INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
								([IF_SEQ]             -- [nvarchar](50) NOT NULL,
								,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
								,[IF_ID]              -- [nvarchar](50) NOT NULL,
								,[IF_SND_DATE]        -- [datetime] NULL,
								,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
								,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								)
							VALUES
								(@send_if_seq
								,'R'
								,@if_id_code
								,GETDATE()
								,@IF_SEQ
								,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
								,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
								);
						END;
					ELSE
						BEGIN
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							   SET [PROC_FLAG] = 'N'
								 , [UPDDTTM]   = GETDATE()
							 WHERE [PROC_FLAG] = 'P'
							   AND [BAS_ITEM_ID] = 'TB_MMD_EQPT_PRDT_SPEED'
							   AND [IF_SEQ]    = @IF_SEQ;
						END
				END; -- @BAS_ITEM_ID = 'TB_MMD_EQPT_PRDT_SPEED'

			FETCH NEXT FROM C_DATA INTO @IF_SEQ
									  , @IF_SOURCE      -- 2019-03-12 kimcd 재료 구분자
									  , @IF_RCV_DATE    -- 2020-06-26 kimcd IF_RCV_DATE 조회추가
									  , @BAS_ITEM_ID
									  , @DISTRB_TG_BAS_ITEM_NAME
									  , @SRC_REPSTR_ID
									  , @SRC_BAS_ITEM_ID
									  , @SRC_KEY_SEQ_NO
									  , @SRC_HIST_SEQ_NO
									  , @BAS_KEY_ATTR1
									  , @BAS_KEY_ATTR2
									  , @BAS_KEY_ATTR3
									  , @BAS_KEY_ATTR4
									  , @BAS_KEY_ATTR5
									  , @BAS_KEY_ATTR6
									  , @BAS_KEY_ATTR7
									  , @BAS_KEY_ATTR8
									  , @BAS_KEY_ATTR9
									  , @BAS_KEY_ATTR10
									  , @BAS_ATTR1
									  , @BAS_ATTR2
									  , @BAS_ATTR3
									  , @BAS_ATTR4
									  , @BAS_ATTR5
									  , @BAS_ATTR6
									  , @BAS_ATTR7
									  , @BAS_ATTR8
									  , @BAS_ATTR9
									  , @BAS_ATTR10
									  , @BAS_ATTR11
									  , @BAS_ATTR12
									  , @BAS_ATTR13
									  , @BAS_ATTR14
									  , @BAS_ATTR15
									  , @BAS_ATTR16
									  , @BAS_ATTR17  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
									  , @BAS_ATTR18  -- 2018-07-11 kimcd 라인별 창고 수신하면서 추가
									  , @BAS_ATTR19
									  , @BAS_ATTR20
									  , @BAS_ATTR21
									  , @BAS_ATTR22
									  , @BAS_ATTR23
									  , @BAS_ATTR24
									  , @BAS_ATTR25
									  , @BAS_ATTR26
									  , @BAS_ATTR27
									  , @BAS_ATTR28
									  , @BAS_ATTR29
									  , @BAS_ATTR31
									  , @BAS_ATTR32
									  , @BAS_ATTR33
									  , @BAS_ATTR34
									  , @BAS_ATTR35
									  , @BAS_ATTR36
									  , @BAS_ATTR37
									  , @BAS_ATTR38
									  , @BAS_ATTR39
									  , @BAS_ATTR40
									  , @BAS_ATTR41
									  , @BAS_ATTR42
									  , @BAS_ATTR43
									  , @BAS_ATTR44
									  , @BAS_ATTR45
									  , @BAS_ATTR46
									  , @BAS_ATTR47
									  , @BAS_ATTR48
									  , @BAS_ATTR49
									  , @BAS_ATTR50
									  , @BAS_ATTR56  -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_GR_CODE 수신 추가
									  , @BAS_ATTR57  -- 2022-08-26 leeseongmin [CSR: C20220826-000120] Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
									  , @BAS_ATTR80  -- 2021-06-30 kimcd Interface 시스템 명 MES SOURCE GROUP 수신 추가
									  , @BAS_ATTR_MSG
									  , @USE_FLAG
									  , @DEL_FLAG

        END  -- WHILE @@FETCH_STATUS = 0  C_DATA
        CLOSE C_DATA;
        DEALLOCATE C_DATA;   -- 메모리 해제

		IF @SCM_LINE_CREATE = 'Y' -- FP Line 추가 필요. Pack 공정에 Main 설비 표시
			BEGIN
			    SET @v_temp1 = 'STEP ADD SCM_LINE_M'
				INSERT INTO [DBO].[SCM_LINE_M]
					( [COMPANY_ID]
					, [DIVISION_ID]
					, [SITE_ID]
					, [PLANT_ID]
					, [FACTORY_ID]
					, [OPERATION_ID]
					, [LINE_ID]
					, [LINE_NAME]
					, [ELECTRODE_TYPE]
					, [LINE_TYPE]
					, [ACTIVE_FLAG]
					, [DESCRIPTION]
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME]
					, [LOCATION] -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
					, [MES_LINE_ID]     -- 2022-07-12 kimcd 설비 정보 영향도 제거용 컬럼 추가
					, [WORK_CENTER_ID]) -- 2022-07-12 kimcd 설비 정보 영향도 제거용 컬럼 추가 
				-- 2017-12-04 kimcd 입력 문장 GROUP BY로 전환
				SELECT EM.[COMPANY_ID]	    -- 회사 코드
					  ,EM.[DIVISION_ID]	    -- 사업부 코드
					  ,EM.[SITE_ID]	        -- 지역 코드
					  ,EM.[PLANT_ID]	        -- 공장 코드
					  ,EM.[FACTORY_ID]	    -- 공장 동 코드
					  ,EM.[OPERATION_ID]	    -- 단위 공정(OPERATION_ID) ID
					  ,EM.[MES_LINE_ID]      -- MES LINE
					  ,MAX(MLM.[LINE_NAME])
					  ,ISNULL(EM.[ELECTRODE_TYPE],'-')	-- 전극
					  ,MAX(MLM.[LINE_TYPE])
					  ,MAX(MLM.[ACTIVE_FLAG])	    -- "유효 여부- Y/N"
					  ,MAX(MLM.[DESCRIPTION])
					  ,'PR_XIF_MMD_ALL_R'
					  ,GETDATE()
					  ,'PR_XIF_MMD_ALL_R'
					  ,GETDATE()
					  ,MAX(EM.[LOCATION]) -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
					  ,MAX(EM.[MES_LINE_ID])    -- 2022-07-12 kimcd 설비 정보 영향도 제거용 컬럼 추가
					  ,MAX(EM.[WORK_CENTER_ID]) -- 2022-07-12 kimcd 설비 정보 영향도 제거용 컬럼 추가
				FROM  [DBO].[SCM_EQUIPMENT_M] EM   WITH(NOLOCK)
					, [DBO].[SCM_MMD_LINE_M]  MLM  WITH(NOLOCK)
				WHERE EM.[COMPANY_ID]  = MLM.[COMPANY_ID]
				AND   EM.[DIVISION_ID] = MLM.[DIVISION_ID]
				AND   EM.[SITE_ID]     = MLM.[SITE_ID]
				AND   EM.[PLANT_ID]    = MLM.[PLANT_ID]
				AND   EM.[FACTORY_ID]  = MLM.[FACTORY_ID]
				AND   EM.[MES_LINE_ID] = MLM.[LINE_ID]
				AND   EM.[ACTIVE_FLAG] = 'Y'
				AND   EM.[OPERATION_ID] != '*'
				AND   NOT EXISTS ( SELECT 1
								   FROM   [DBO].[SCM_LINE_M]  LM  WITH(NOLOCK)
								   WHERE  LM.[COMPANY_ID]     = EM.[COMPANY_ID]
								   AND    LM.[DIVISION_ID]    = EM.[DIVISION_ID]
								   AND    LM.[SITE_ID]        = EM.[SITE_ID]
								   AND    LM.[PLANT_ID]       = EM.[PLANT_ID]
								   AND    LM.[FACTORY_ID]     = EM.[FACTORY_ID]
								   AND    LM.[OPERATION_ID]   = EM.[OPERATION_ID]
								   AND    LM.[LINE_ID]        = EM.[MES_LINE_ID]
								   AND    LM.[ELECTRODE_TYPE] = ISNULL(EM.[ELECTRODE_TYPE],'-') )
				GROUP BY EM.[COMPANY_ID]	    -- 회사 코드
						,EM.[DIVISION_ID]	    -- 사업부 코드
						,EM.[SITE_ID]	        -- 지역 코드
						,EM.[PLANT_ID]	        -- 공장 코드
						,EM.[FACTORY_ID]	    -- 공장 동 코드
						,EM.[OPERATION_ID]	    -- 단위 공정(OPERATION_ID) ID
						,EM.[MES_LINE_ID]      -- MES LINE
						,ISNULL(EM.[ELECTRODE_TYPE],'-')	-- 전극
						;
				/* 2017-12-04 kimcd Group by로 전환하기위해 막음
				SELECT DISTINCT 
					   EM.[COMPANY_ID]	    -- 회사 코드
					  ,EM.[DIVISION_ID]	    -- 사업부 코드
					  ,EM.[SITE_ID]	        -- 지역 코드
					  ,EM.[PLANT_ID]	        -- 공장 코드
					  ,EM.[FACTORY_ID]	    -- 공장 동 코드
					  ,EM.[OPERATION_ID]	    -- 단위 공정(OPERATION_ID) ID
					  ,EM.[MES_LINE_ID]      -- MES LINE
					  ,MLM.[LINE_NAME]
					  ,ISNULL(EM.[ELECTRODE_TYPE],'-')	-- 전극
					  ,MLM.[LINE_TYPE]
					  ,MLM.[ACTIVE_FLAG]	    -- "유효 여부- Y/N"
					  ,MLM.[DESCRIPTION]
					  ,'PR_XIF_MMD_ALL_R'
					  ,GETDATE()
					  ,'PR_XIF_MMD_ALL_R'
					  ,GETDATE()
					  ,EM.[LOCATION] -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO]
				FROM  [DBO].[SCM_EQUIPMENT_M] EM   WITH(NOLOCK)
					, [DBO].[SCM_MMD_LINE_M]  MLM  WITH(NOLOCK)
				WHERE EM.[COMPANY_ID]  = MLM.[COMPANY_ID]
				AND   EM.[DIVISION_ID] = MLM.[DIVISION_ID]
				AND   EM.[SITE_ID]     = MLM.[SITE_ID]
				AND   EM.[PLANT_ID]    = MLM.[PLANT_ID]
				AND   EM.[FACTORY_ID]  = MLM.[FACTORY_ID]
				AND   EM.[MES_LINE_ID] = MLM.[LINE_ID]
				AND   EM.[ACTIVE_FLAG] = 'Y'
				AND   EM.[OPERATION_ID] != '*'
				AND   NOT EXISTS ( SELECT 1
								   FROM   [DBO].[SCM_LINE_M]  LM  WITH(NOLOCK)
								   WHERE  LM.[COMPANY_ID]     = EM.[COMPANY_ID]
								   AND    LM.[DIVISION_ID]    = EM.[DIVISION_ID]
								   AND    LM.[SITE_ID]        = EM.[SITE_ID]
								   AND    LM.[PLANT_ID]       = EM.[PLANT_ID]
								   AND    LM.[FACTORY_ID]     = EM.[FACTORY_ID]
								   AND    LM.[OPERATION_ID]   = EM.[OPERATION_ID]
								   AND    LM.[LINE_ID]        = EM.[MES_LINE_ID]
								   AND    LM.[ELECTRODE_TYPE] = ISNULL(EM.[ELECTRODE_TYPE],'-') );*/

			    -- 2017-11-08 kimcd 설비 층 번호[EQPT_FLOOR_NO] 라인에 반영
				SET @v_temp1 = 'STEP UPDATE SCM_LINE_M - LOCATION'
/*
				UPDATE LM
				SET	   LM.[LOCATION]    = ISNULL(EM.[LOCATION],'-')
					,  LM.[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
					,  LM.[UPDATE_TIME] = GETDATE()
				FROM   [DBO].[SCM_EQUIPMENT_M] EM   WITH(NOLOCK)
					,  [DBO].[SCM_LINE_M]      LM  WITH(NOLOCK)
				WHERE  LM.[COMPANY_ID]     = EM.[COMPANY_ID]
				AND    LM.[DIVISION_ID]    = EM.[DIVISION_ID]
				AND    LM.[SITE_ID]        = EM.[SITE_ID]
				AND    LM.[PLANT_ID]       = EM.[PLANT_ID]
				AND    LM.[FACTORY_ID]     = EM.[FACTORY_ID]
				AND    LM.[OPERATION_ID]   = EM.[OPERATION_ID]
				AND    LM.[LINE_ID]        = EM.[LINE_ID]
				AND    LM.[ELECTRODE_TYPE] = ISNULL(EM.[ELECTRODE_TYPE],'-')
				AND    ISNULL(LM.[LOCATION],'-') != ISNULL(EM.[LOCATION],'-')
				AND    EM.[EQUIPMENT_TYPE] = 'M' -- 2017-12-27 kimcd 메인 설비로만 갱신하도록 조건 추가
				AND    EM.EQUIPMENT_ID = (  SELECT TOP 1 EMT.EQUIPMENT_ID
				                            FROM   [DBO].[SCM_EQUIPMENT_M] EMT WITH(NOLOCK)
											WHERE  LM.[COMPANY_ID]      = EMT.[COMPANY_ID]
											AND    LM.[DIVISION_ID]     = EMT.[DIVISION_ID]
											AND    LM.[SITE_ID]         = EMT.[SITE_ID]
											AND    LM.[PLANT_ID]        = EMT.[PLANT_ID]
											AND    LM.[FACTORY_ID]      = EMT.[FACTORY_ID]
											AND    LM.[OPERATION_ID]    = EMT.[OPERATION_ID]
											AND    LM.[LINE_ID]         = EMT.[LINE_ID]
											AND    LM.[ELECTRODE_TYPE]  = ISNULL(EMT.[ELECTRODE_TYPE],'-')
											AND    EMT.[EQUIPMENT_TYPE] = 'M' -- 2017-12-27 kimcd 메인 설비로만 갱신하도록 조건 추가
											ORDER BY EMT.EQUIPMENT_ID )  -- 2017-12-30 kimcd 설비 중 최초 설비 기준으로 라인의 층 정보 통일.
*/
				-- 속도개선
				select lm.company_id, lm.division_id, lm.site_id, lm.plant_id, lm.factory_id, lm.operation_id, lm.line_id, lm.ELECTRODE_TYPE, lm.location
				  into #LINE_EQUP_LOCATION_TEMP
				  FROM [DBO].[SCM_EQUIPMENT_M] EM   WITH(NOLOCK)
				     , [DBO].[SCM_LINE_M]      LM  WITH(NOLOCK)
				 WHERE LM.[COMPANY_ID]     = EM.[COMPANY_ID]
				   AND LM.[DIVISION_ID]    = EM.[DIVISION_ID]
				   AND LM.[SITE_ID]        = EM.[SITE_ID]
				   AND LM.[PLANT_ID]       = EM.[PLANT_ID]
				   AND LM.[FACTORY_ID]     = EM.[FACTORY_ID]
				   AND LM.[OPERATION_ID]   = EM.[OPERATION_ID]
				   AND LM.[LINE_ID]        = EM.[LINE_ID]
				   AND LM.[ELECTRODE_TYPE] = ISNULL(EM.[ELECTRODE_TYPE],'-')
				   AND ISNULL(LM.[LOCATION],'-') != ISNULL(EM.[LOCATION],'-')
				   AND EM.[EQUIPMENT_TYPE] = 'M' -- 2017-12-27 kimcd 메인 설비로만 갱신하도록 조건 추가
				group by lm.company_id, lm.division_id, lm.site_id, lm.plant_id, lm.factory_id, lm.operation_id, lm.line_id, lm.ELECTRODE_TYPE, lm.location

				update t
				   set t.[LOCATION]    = s.eq_location
					  ,t.[UPDATE_ID]   = 'PR_XIF_MMD_ALL_R'
					  ,t.[UPDATE_TIME] = getdate()
				from scm_line_m as t
					 join (
							select x2.company_id, x2.division_id, x2.site_id, x2.plant_id, x2.factory_id, x2.operation_id, x2.line_id, x2.ELECTRODE_TYPE, ISNULL(y2.[LOCATION],'-') as eq_location
							from (
								select x.company_id, x.division_id, x.site_id, x.plant_id, x.factory_id, x.operation_id, x.line_id, x.ELECTRODE_TYPE, x.location, min(y.equipment_id) as equipment_id
								from #LINE_EQUP_LOCATION_TEMP as x
									  join scm_equipment_m as y
									 on x.company_id = y.company_id
									and x.division_id = y.division_id
									and x.site_id = y.site_id
									and x.plant_id = y.plant_id
									and x.factory_id = y.factory_id
									and x.operation_id = y.operation_id
									and x.line_id = y.line_id
									and y.equipment_type = 'M'
									and x.[ELECTRODE_TYPE]  = ISNULL(y.[ELECTRODE_TYPE],'-')
									group by  x.company_id, x.division_id, x.site_id, x.plant_id, x.factory_id, x.operation_id, x.line_id, x.ELECTRODE_TYPE, x.location
							   )  as x2
							  join scm_equipment_m as y2
							 on x2.company_id = y2.company_id
							and x2.division_id = y2.division_id
							and x2.site_id = y2.site_id
							and x2.plant_id = y2.plant_id
							and x2.factory_id = y2.factory_id
							and x2.equipment_id = y2.equipment_id
							and x2.operation_id = y2.operation_id
							and x2.line_id = y2.line_id
							and y2.equipment_type = 'M'
							and x2.[ELECTRODE_TYPE]  = ISNULL(y2.[ELECTRODE_TYPE],'-')
							and ISNULL(x2.[LOCATION],'-') != ISNULL(y2.[LOCATION],'-')
				) as s
				 on t.company_id  = s.company_id
				and t.division_id = s.division_id
				and t.site_id     = s.site_id
				and t.plant_id    = s.plant_id
				and t.factory_id  = s.factory_id
				and t.operation_id = s.operation_id
				and t.line_id = s.line_id
				and t.electrode_type = s.electrode_type

				drop table #LINE_EQUP_LOCATION_TEMP
				--

				SET @v_temp1 = 'STEP UPDATE PACK MAIN EQUIPMENT'
				UPDATE [DBO].[SCM_EQUIPMENT_M]
				SET    [EQUIPMENT_TYPE] = ( SELECT TOP 1 CASE WHEN UP.EQUIPMENT_ID = EP.EQUIPMENT_ID THEN
															 'M'
														 ELSE
															 'U'
														 END 
											FROM   [DBO].[SCM_EQUIPMENT_M] UP  WITH(NOLOCK)
											WHERE  UP.[COMPANY_ID]   = EP.[COMPANY_ID]
											AND    UP.[DIVISION_ID]  = EP.[DIVISION_ID]
											AND	   UP.[SITE_ID]      = EP.[SITE_ID]
											AND	   UP.[PLANT_ID]     = EP.[PLANT_ID]
											AND	   UP.[FACTORY_ID]   = EP.[FACTORY_ID]
											AND	   UP.[OPERATION_ID] = EP.[OPERATION_ID]
											AND	   UP.[LINE_ID]      = EP.[LINE_ID]
											AND	   ISNULL(UP.[ELECTRODE_TYPE],'-') = ISNULL(EP.[ELECTRODE_TYPE],'-')
											ORDER BY UP.WORK_CENTER_ID DESC
												   , UP.EQUIPMENT_ID )
				FROM   [DBO].[SCM_EQUIPMENT_M]           EP
				     , [DBO].[SCM_MMD_OPERATION_GROUP_M] SOG
					 , [DBO].[SCM_OPERATION_M]           SOM
				WHERE  SOG.[OPERATION_GROUP_ID] = SOM.[OPERATION_GROUP_ID]
				AND    SOM.[COMPANY_ID]   = EP.[COMPANY_ID]
				AND    SOM.[DIVISION_ID]  = EP.[DIVISION_ID]
				AND    SOM.[SITE_ID]      = EP.[SITE_ID]
				AND    SOM.[OPERATION_ID] = EP.[OPERATION_ID]
				AND    SOG.[ROUTE_TYPE]   = 'P'
				AND    SOM.[MES_ERP_INTERFACE_FLAG] = 'Y';

			END;

		IF @ROUTEPATH_FLAG = 'Y'
		    BEGIN
			    -- 2017-08-02 kimcd add start
			    SET @v_temp1 = 'STEP UPDATE SCM_MMD_ROUTEPATH_M NORM'
				UPDATE A
				SET	   A.[FLOWNORM]    = B.[FLOWNORM]
				FROM   [DBO].[SCM_MMD_ROUTEPATH_M] A
					,  [DBO].[SCM_MMD_ROUTEPATH_M] B
				WHERE  B.[ROUTID]      = A.[ROUTID]	 -- [ROUTID] 생산경로 ID
				AND    B.[FLOWID]      = A.[FLOWID]	 -- [FLOWID] 경로흐름 ID
				AND    B.[FLOWID_TO]   = A.[FLOWID_TO] -- [FLOWID] 경로흐름 ID
				AND    B.[FLOWNORM]    = 'Y'
				AND    A.[REVISE_FLAG] = 'Y'
				AND    ( A.[FLOWNORM] IS NULL OR A.[FLOWNORM] = 'N' ) -- [FLOWNORM] 경로흐름 정상 여부 다시 판단. 동일 Route,Flow ID로 양산 Route 존재 여부 확인
				AND    B.[COMPANY_ID]  = A.[COMPANY_ID]    -- 2019-03-12 kimcd 재료 사업본부 추가에 따른 재조정
				AND    B.[DIVISION_ID] = A.[DIVISION_ID]   -- 2019-03-12 kimcd 재료 사업본부 추가에 따른 재조정
				AND    B.[SITE_ID]     = A.[SITE_ID];      -- 2019-03-12 kimcd 재료 사업본부 추가에 따른 재조정
				-- 2017-08-02 kimcd add end

			    SET @v_temp1 = 'STEP UPDATE SCM_MMD_ROUTEPATH_M NOT NORM'
				UPDATE [DBO].[SCM_MMD_ROUTEPATH_M]
				SET    [REVISE_FLAG] = 'N'
				WHERE  [REVISE_FLAG]   = 'Y'
				AND    ( [FLOWNORM] IS NULL OR [FLOWNORM] = 'N' ) ; -- [FLOWNORM] 경로흐름 정상이 아닌 경우. 비양산용의 경우 REVISE FLAG를 초기화 함

			    SET @v_temp1 = 'STEP CREATE OPERATION_FLOW'
				DECLARE C_REVISE_OP CURSOR FOR
				    SELECT DISTINCT
					       SMR.[COMPANY_ID]
					      ,SMR.[DIVISION_ID]
						  ,SMR.[SITE_ID]
						  ,SMR.[ROUTID]
						  ,SMR.[FLOWID]
					FROM   [DBO].[SCM_MMD_ROUTEPATH_M] SMR  WITH(NOLOCK)
					WHERE  SMR.[REVISE_FLAG]   = 'Y'
					AND    SMR.[FLOWNORM]      = 'Y'; -- [FLOWNORM] 경로흐름 정상설정 여부. 양산용 ROUTE 구분

                SET @v_temp1 = 'STEP OPEN CURSOR C_REVISE_OP'
    		    OPEN C_REVISE_OP
                FETCH NEXT FROM C_REVISE_OP INTO @COMPANY_ID
                                                ,@DIVISION_ID
                                                ,@SITE_ID
												,@ROUTID
												,@FLOWID_FOR_QUERY
                WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
                BEGIN
				    SET @v_temp1 = 'STEP CLEAR OLD FLOWID'
					UPDATE[DBO].[SCM_MMD_ROUTEPATH_M]
					SET   [FIRST_FLOW_ID] = NULL
						 ,[FLOW_ID]       = NULL
						 ,[UPDATE_ID]     = @v_proc_name
						 ,[UPDATE_TIME]   = GETDATE()
					WHERE [COMPANY_ID]  = @COMPANY_ID
					AND   [DIVISION_ID] = @DIVISION_ID
					AND   [SITE_ID]     = @SITE_ID
					AND   [ROUTID]      = @ROUTID
					AND   [FLOWID]      = @FLOWID_FOR_QUERY
					AND   [FLOWID_TO]   = @FLOWID_FOR_QUERY

					-- SELECT @ROUTID

					SET @v_temp1 = 'STEP SPREAD MMD ROUTE'
					DECLARE C_SPREAD_RT CURSOR FOR
						WITH ROUTE_LEVEL ( FLOWID_TO, PROCID_TO, FLOWID, PROCID, NLEVEL, PATH )
						AS     (
								SELECT FLOWID_TO, PROCID_TO, FLOWID, PROCID, 1 NLEVEL, CONVERT(NVARCHAR(1000), PROCID_TO) PATH
								FROM   [DBO].[SCM_MMD_ROUTEPATH_M] M  WITH(NOLOCK)
								WHERE  M.[COMPANY_ID]  = @COMPANY_ID
								AND    M.[DIVISION_ID] = @DIVISION_ID
								AND    M.[SITE_ID]     = @SITE_ID
								AND    M.[ROUTID]      = @ROUTID
								AND    M.[FLOWID]	   = @FLOWID_FOR_QUERY
								AND    M.[FLOWID_TO]   = @FLOWID_FOR_QUERY
								AND    ( M.[PATHTYPE] IS NULL OR M.[PATHTYPE] != 'BEFORE')
								AND    NOT EXISTS (	SELECT 'A'
													FROM   [DBO].[SCM_MMD_ROUTEPATH_M] A  WITH(NOLOCK)
													WHERE  A.[COMPANY_ID]  = @COMPANY_ID
													AND    A.[DIVISION_ID] = @DIVISION_ID
													AND    A.[SITE_ID]     = @SITE_ID
													AND    A.[ROUTID]      = @ROUTID
													AND    A.[FLOWID]      = M.[FLOWID_TO]    -- 경로흐름 ID
													AND    A.[PROCID]      = M.[PROCID_TO]    -- 공정 ID
													AND    A.[FLOWID]	   = @FLOWID_FOR_QUERY
													AND    A.[FLOWID_TO]   = @FLOWID_FOR_QUERY
													AND    ( A.[PATHTYPE] IS NULL OR A.[PATHTYPE] != 'BEFORE')
													) 
								UNION  ALL
								SELECT A.FLOWID_TO, A.PROCID_TO, A.FLOWID, A.PROCID, NLEVEL + 1, CONVERT(NVARCHAR(1000), PATH + A.PROCID_TO)
								FROM   [DBO].[SCM_MMD_ROUTEPATH_M] A  WITH(NOLOCK)
									  ,ROUTE_LEVEL B
								WHERE  A.[COMPANY_ID]  = @COMPANY_ID
								AND    A.[DIVISION_ID] = @DIVISION_ID
								AND    A.[SITE_ID]     = @SITE_ID
								AND    A.[ROUTID]      = @ROUTID
								AND    A.[FLOWID]	   = @FLOWID_FOR_QUERY
								AND    A.[FLOWID_TO]   = @FLOWID_FOR_QUERY
								AND    A.[FLOWID_TO]   = B.FLOWID
								AND    A.[PROCID_TO]   = B.PROCID
								AND    ( A.[PATHTYPE] IS NULL OR A.[PATHTYPE] != 'BEFORE')
								AND NLEVEL < 100
								)
						SELECT DISTINCT
							   FLOWID_TO, PROCID_TO, FLOWID, PROCID, NLEVEL, PATH
						FROM   ROUTE_LEVEL 
						ORDER  BY PATH, NLEVEL;
						--SELECT FLOWID_TO, PROCID_TO, FLOWID, PROCID, MIN(NLEVEL) AS NLEVEL, MIN(PATH) AS PATH
						--  FROM ROUTE_LEVEL 
						-- GROUP BY FLOWID_TO, PROCID_TO, FLOWID, PROCID
						-- ORDER BY MIN(PATH), MIN(NLEVEL) 
						--;


					SET @v_temp1 = 'STEP OPEN CURSOR C_SPREAD_RT'
    				OPEN C_SPREAD_RT
					FETCH NEXT FROM C_SPREAD_RT INTO  @FLOWID_TO
													, @PROCID_TO
													, @FLOWID
													, @PROCID
													, @NLEVEL
													, @PATH
					SET @FLOW_ID = '' -- OPERATION FLOW ID 변수 초기화
					DELETE @OP_TABLE; -- clear temp table

					WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
					BEGIN

						-- 최초 공정의 경우 Route에 최종적으로 넣기 위해서 별도 변수로 받아 놓음
						SET @LAST_FLOWID_TO = @FLOWID_TO
						SET @LAST_PROCID_TO = @PROCID_TO
						SET @LAST_FLOWID    = @FLOWID
						SET @LAST_PROCID    = @PROCID

						SET @v_temp1 = 'CHECK CMA, BMA, WO OPERATION'
						SELECT DISTINCT 
							   @CHECK_ROUTE_TYPE       = SOG.[ROUTE_TYPE],
						       @MES_ERP_INTERFACE_FLAG = SOM.[MES_ERP_INTERFACE_FLAG],
							   @WO_FLAG                = SOM.[WO_FLAG]
						FROM   [DBO].[SCM_MMD_OPERATION_GROUP_M] SOG  WITH(NOLOCK)
							  ,[DBO].[SCM_OPERATION_M]           SOM  WITH(NOLOCK)
						WHERE  SOG.[OPERATION_GROUP_ID] = SOM.[OPERATION_GROUP_ID]
						AND    SOM.[COMPANY_ID]   = @COMPANY_ID
						AND    SOM.[DIVISION_ID]  = @DIVISION_ID
						AND    SOM.[SITE_ID]      = @SITE_ID
						AND    SOM.[OPERATION_ID] = @PROCID_TO
						AND    SOM.[ACTIVE_FLAG]  = 'Y' -- 2017-11-17 kimcd 조건 추가 Site별로 active한 공정만 수신함.
						-- AND    ( SOM.[WO_FLAG] = 'Y' OR SOM.[MO_FLAG] = 'Y' ) BLOCK 2016-11-29
						AND    NOT EXISTS ( SELECT 1
						                    FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV  WITH(NOLOCK)
											WHERE  LV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
											AND    LV.ACTIVE_FLAG      = 'Y'
											AND    LV.SEGMENT1         = SOM.OPERATION_ID
											AND    LV.ATTRIBUTE3       = 'Y') -- ADD 2016-12-02

						IF @@ROWCOUNT > 0
							BEGIN
								IF ( @CHECK_ROUTE_TYPE = 'P' AND @MES_ERP_INTERFACE_FLAG = 'Y')
								OR @CHECK_ROUTE_TYPE != 'P'
								OR @CHECK_ROUTE_TYPE IS NULL
									BEGIN
										SET @FLOW_ID = @PROCID_TO + @FLOW_ID
										SET @v_temp1 = 'STEP INSERT @OP_TABLE'
										INSERT INTO @OP_TABLE
											( COMPANY_ID
											, DIVISION_ID
											, SITE_ID
											, ROUTID
											, FLOWID_TO
											, PROCID_TO
											, FLOWID
											, PROCID
											, NLEVEL
											)
										VALUES 
											( @COMPANY_ID
											, @DIVISION_ID
											, @SITE_ID
											, @ROUTID
											, @FLOWID_TO
											, @PROCID_TO
											, @FLOWID
											, @PROCID
											, @NLEVEL
											);

										IF @WO_FLAG = 'Y' -- W/O 형성하는 공정 단위로 Operation Flow를 끊음. MES는 Cell 제품 기준으로 
											BEGIN
												DECLARE C_OP_TEMP CURSOR FOR
													SELECT COMPANY_ID
														 , DIVISION_ID
														 , SITE_ID
														 , FLOWID_TO
														 , PROCID_TO
														 , FLOWID
														 , PROCID
														 , NLEVEL
													FROM   @OP_TABLE
													ORDER  BY NLEVEL DESC;

												SET @v_temp1 = 'STEP OPEN CURSOR C_OP_TEMP'
    											OPEN C_OP_TEMP
												FETCH NEXT FROM C_OP_TEMP INTO @I_COMPANY_ID
																			 , @I_DIVISION_ID
																			 , @I_SITE_ID
																			 , @I_FLOWID_TO
																			 , @I_PROCID_TO
																			 , @I_FLOWID
																			 , @I_PROCID
																			 , @I_NLEVEL
												SET @I_OPERATION_SEQ = 1;

												WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
												BEGIN

													SET @v_temp1 = 'STEP MERGE SCM_OPERATION_FLOW_M'
													MERGE INTO [DBO].[SCM_OPERATION_FLOW_M] SOF
													USING ( SELECT @I_COMPANY_ID     AS COMPANY_ID
																 , @I_DIVISION_ID    AS DIVISION_ID
																 , @I_SITE_ID        AS SITE_ID
																 , @FLOW_ID          AS FLOW_ID
																 , @I_PROCID_TO      AS OPERATION_ID
																 , @I_OPERATION_SEQ  AS OPERATION_SEQ
															)      XXX
													ON    (     SOF.[COMPANY_ID]   = XXX.COMPANY_ID
															AND SOF.[DIVISION_ID]  = XXX.DIVISION_ID
															AND SOF.[SITE_ID]      = XXX.SITE_ID
															AND SOF.[FLOW_ID]      = XXX.FLOW_ID
															AND SOF.[OPERATION_ID] = XXX.OPERATION_ID
															)
													WHEN MATCHED THEN
														UPDATE SET SOF.[OPERATION_SEQ] = XXX.OPERATION_SEQ
																 , SOF.[ACTIVE_FLAG]   = 'Y'
																 , SOF.[UPDATE_ID]     = @v_proc_name
																 , SOF.[UPDATE_TIME]   = GETDATE()
													WHEN NOT MATCHED THEN
														INSERT (  [COMPANY_ID]	    -- 회사 코드
																, [DIVISION_ID]	    -- 사업부 코드
																, [SITE_ID]	        -- 지역 코드
																, [FLOW_ID]         -- 경로흐름 ID
																, [OPERATION_ID]    -- 공정 ID
																, [OPERATION_SEQ]   -- 공정 순서
																, [ACTIVE_FLAG]     -- 사용 여부
																, [INSERT_ID]	    -- 등록자
																, [INSERT_TIME]	    -- 등록일
																, [UPDATE_ID]	    -- 수정자
																, [UPDATE_TIME]	    -- 수정일
																)
														VALUES (  XXX.[COMPANY_ID]	    -- 회사 코드
																, XXX.[DIVISION_ID]	    -- 사업부 코드
																, XXX.[SITE_ID]	        -- 지역 코드
																, XXX.[FLOW_ID]         -- 경로흐름 ID
																, XXX.[OPERATION_ID]    -- 공정 ID
																, XXX.[OPERATION_SEQ]   -- 공정 순서
																, 'Y'               -- ACTIVE FLAG
																, @v_proc_name
																, GETDATE()
																, @v_proc_name
																, GETDATE()
																);

													SET @v_temp1 = 'STEP UPDATE SCM_MMD_ROUTEPATH_M-FLOW_ID'
													UPDATE  [DBO].[SCM_MMD_ROUTEPATH_M]
													SET     [FLOW_ID]     = @FLOW_ID
														  , [PATH_LEVEL]  = @I_NLEVEL
														  , [UPDATE_ID]   = @v_proc_name
														  , [UPDATE_TIME] = GETDATE()
													WHERE 	[COMPANY_ID]  = @I_COMPANY_ID
													AND     [DIVISION_ID] = @I_DIVISION_ID
													AND	    [SITE_ID]     = @I_SITE_ID
													AND     [ROUTID]      = @ROUTID
													AND	    [FLOWID_TO]   = @I_FLOWID_TO
													AND	    [PROCID_TO]   = @I_PROCID_TO
													AND	    [FLOWID]      = @I_FLOWID
													AND	    [PROCID]      = @I_PROCID;

    												SET @v_count = @v_count + 1;
													FETCH NEXT FROM C_OP_TEMP INTO @I_COMPANY_ID
																				 , @I_DIVISION_ID
																				 , @I_SITE_ID
																				 , @I_FLOWID_TO
																				 , @I_PROCID_TO
																				 , @I_FLOWID
																				 , @I_PROCID
																				 , @I_NLEVEL

													SET @I_OPERATION_SEQ = @I_OPERATION_SEQ + 1;
												END; -- C_OP_TEMP
												CLOSE C_OP_TEMP;
												DEALLOCATE C_OP_TEMP;   -- 메모리 해제

												SET @v_temp1 = 'STEP MERGE SCM_OPERATION_FLOW_M'

												DELETE @OP_TABLE; -- clear temp table
												SET @FLOW_ID = '' -- OPERATION FLOW ID 변수 초기화

											END; -- IF @WO_FLAG = 'Y'
									END;  -- IF ( @CHECK_ROUTE_TYPE = 'Y' AND @MES_ERP_INTERFACE_FLAG = 'Y')
							END;

						SET @v_temp1 = 'STEP FETCH AGAIN C_SPREAD_RT'
						FETCH NEXT FROM C_SPREAD_RT INTO  @FLOWID_TO
														, @PROCID_TO
														, @FLOWID
														, @PROCID
														, @NLEVEL
														, @PATH

					END -- WHILE @@FETCH_STATUS = 0  C_SPREAD_RT
					CLOSE C_SPREAD_RT;
					DEALLOCATE C_SPREAD_RT;   -- 메모리 해제

					-- 최초 공정에 대한 Operation 입력
					BEGIN
						DECLARE C_LAST_OP CURSOR FOR
							SELECT A.COMPANY_ID
								 , A.DIVISION_ID
								 , A.SITE_ID
								 , A.FLOWID_TO
								 , A.PROCID_TO
								 , A.FLOWID
								 , A.PROCID
								 , A.NLEVEL
							FROM ( SELECT @COMPANY_ID    AS COMPANY_ID
										, @DIVISION_ID   AS DIVISION_ID
										, @SITE_ID       AS SITE_ID
										, @LAST_FLOWID   AS FLOWID_TO
										, @LAST_PROCID   AS PROCID_TO
										, '*'            AS FLOWID
										, '*'            AS PROCID
										, 9999           AS NLEVEL
								   FROM   [DBO].[SCM_MMD_OPERATION_GROUP_M] SOG  WITH(NOLOCK)
										 ,[DBO].[SCM_OPERATION_M]           SOM  WITH(NOLOCK)
								   WHERE  SOG.[OPERATION_GROUP_ID] = SOM.[OPERATION_GROUP_ID]
								   AND    SOM.[COMPANY_ID]   = @COMPANY_ID
								   AND    SOM.[DIVISION_ID]  = @DIVISION_ID
								   AND    SOM.[SITE_ID]      = @SITE_ID
								   AND    SOM.[OPERATION_ID] = @LAST_PROCID
   								   AND    ( ( SOG.[ROUTE_TYPE] = 'P' AND SOM.[MES_ERP_INTERFACE_FLAG] = 'Y' )
											OR SOG.[ROUTE_TYPE] != 'P'
											OR SOG.[ROUTE_TYPE] IS NULL
										  )
								   -- AND    ( SOM.[WO_FLAG] = 'Y' OR SOM.[MO_FLAG] = 'Y' )
								   AND    SOM.[ACTIVE_FLAG]  = 'Y' -- 2017-11-17 kimcd 조건 추가 Site별로 active한 공정만 수신함.
								   AND    NOT EXISTS ( SELECT 1
									                   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV  WITH(NOLOCK)
													   WHERE  LV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
													   AND    LV.ACTIVE_FLAG      = 'Y'
													   AND    LV.SEGMENT1         = SOM.OPERATION_ID
													   AND    LV.ATTRIBUTE3       = 'Y') -- ADD 2016-12-02
								   UNION  ALL
								   SELECT COMPANY_ID
										, DIVISION_ID
										, SITE_ID
										, FLOWID_TO
										, PROCID_TO
										, FLOWID
										, PROCID
										, NLEVEL	 
								   FROM   @OP_TABLE ) A
							ORDER  BY A.NLEVEL DESC;

						SET @v_temp1 = 'STEP OPEN CURSOR C_LAST_OP'
    					OPEN C_LAST_OP
						FETCH NEXT FROM C_LAST_OP INTO @I_COMPANY_ID
													 , @I_DIVISION_ID
													 , @I_SITE_ID
													 , @I_FLOWID_TO
													 , @I_PROCID_TO
													 , @I_FLOWID
													 , @I_PROCID
													 , @I_NLEVEL

                        SET @I_OPERATION_SEQ = 1;
						IF @I_FLOWID = '*' AND @I_PROCID = '*' AND @I_NLEVEL = 9999
							SET @FLOW_ID = @LAST_PROCID + @FLOW_ID  -- @LAST_PROCID가 실제 ROUTE에 포함될 경우만 이름에도 연결한다.

						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							SET @v_temp1 = 'STEP MERGE SCM_OPERATION_FLOW_M AT LAST'
							MERGE INTO [DBO].[SCM_OPERATION_FLOW_M] SOF
							USING ( SELECT @I_COMPANY_ID     AS COMPANY_ID
										 , @I_DIVISION_ID    AS DIVISION_ID
										 , @I_SITE_ID        AS SITE_ID
										 , @FLOW_ID          AS FLOW_ID
										 , @I_PROCID_TO      AS OPERATION_ID
										 , @I_OPERATION_SEQ  AS OPERATION_SEQ
									)      XXX
							ON    (     SOF.[COMPANY_ID]   = XXX.COMPANY_ID
									AND SOF.[DIVISION_ID]  = XXX.DIVISION_ID
									AND SOF.[SITE_ID]      = XXX.SITE_ID
									AND SOF.[FLOW_ID]      = XXX.FLOW_ID
									AND SOF.[OPERATION_ID] = XXX.OPERATION_ID
									)
							WHEN MATCHED THEN
								UPDATE SET SOF.[OPERATION_SEQ] = XXX.OPERATION_SEQ
										 , SOF.[ACTIVE_FLAG]   = 'Y'
										 , SOF.[UPDATE_ID]     = @v_proc_name
										 , SOF.[UPDATE_TIME]   = GETDATE()
							WHEN NOT MATCHED THEN
								INSERT (  [COMPANY_ID]	    -- 회사 코드
										, [DIVISION_ID]	    -- 사업부 코드
										, [SITE_ID]	        -- 지역 코드
										, [FLOW_ID]         -- 경로흐름 ID
										, [OPERATION_ID]    -- 공정 ID
										, [OPERATION_SEQ]   -- 공정 순서
										, [ACTIVE_FLAG]     -- 사용 여부
										, [INSERT_ID]	    -- 등록자
										, [INSERT_TIME]	    -- 등록일
										, [UPDATE_ID]	    -- 수정자
										, [UPDATE_TIME]	    -- 수정일
										)
								VALUES (  XXX.[COMPANY_ID]	    -- 회사 코드
										, XXX.[DIVISION_ID]	    -- 사업부 코드
										, XXX.[SITE_ID]	        -- 지역 코드
										, XXX.[FLOW_ID]         -- 경로흐름 ID
										, XXX.[OPERATION_ID]    -- 공정 ID
										, XXX.[OPERATION_SEQ]   -- 공정 순서
										, 'Y'               -- ACTIVE FLAG
										, @v_proc_name
										, GETDATE()
										, @v_proc_name
										, GETDATE()
										);

							IF @I_FLOWID = '*'
								BEGIN
									SET @v_temp1 = 'STEP UPDATE SCM_MMD_ROUTEPATH_M-FLOW_ID AT FIST OP'
									UPDATE  [DBO].[SCM_MMD_ROUTEPATH_M]
									SET     [FIRST_FLOW_ID] = @FLOW_ID
										  , [PATH_LEVEL]  = ISNULL([PATH_LEVEL],@I_NLEVEL)  -- add 2017-03-29 kimcd - TO AVOID E0500 NULL EXCEPTION..
										  , [UPDATE_ID]   = @v_proc_name
										  , [UPDATE_TIME] = GETDATE()
									WHERE 	[COMPANY_ID]  = @I_COMPANY_ID
									AND     [DIVISION_ID] = @I_DIVISION_ID
									AND	    [SITE_ID]     = @I_SITE_ID
									AND     [ROUTID]      = @ROUTID
									AND	    [FLOWID_TO]   = @LAST_FLOWID_TO
									AND	    [PROCID_TO]   = @LAST_PROCID_TO
									AND	    [FLOWID]      = @LAST_FLOWID
									AND	    [PROCID]      = @LAST_PROCID;
								END;
							ELSE
								BEGIN
									SET @v_temp1 = 'STEP UPDATE SCM_MMD_ROUTEPATH_M-FLOW_ID AT LAST'
									UPDATE  [DBO].[SCM_MMD_ROUTEPATH_M]
									SET     [FLOW_ID]     = @FLOW_ID
										  , [PATH_LEVEL]  = @I_NLEVEL
										  , [UPDATE_ID]   = @v_proc_name
										  , [UPDATE_TIME] = GETDATE()
									WHERE 	[COMPANY_ID]  = @I_COMPANY_ID
									AND     [DIVISION_ID] = @I_DIVISION_ID
									AND	    [SITE_ID]     = @I_SITE_ID
									AND     [ROUTID]      = @ROUTID
									AND	    [FLOWID_TO]   = @I_FLOWID_TO
									AND	    [PROCID_TO]   = @I_PROCID_TO
									AND	    [FLOWID]      = @I_FLOWID
									AND	    [PROCID]      = @I_PROCID;
								END;
    						SET @v_count = @v_count + 1;
							FETCH NEXT FROM C_LAST_OP INTO @I_COMPANY_ID
														 , @I_DIVISION_ID
														 , @I_SITE_ID
														 , @I_FLOWID_TO
														 , @I_PROCID_TO
														 , @I_FLOWID
														 , @I_PROCID
														 , @I_NLEVEL

							SET @I_OPERATION_SEQ = @I_OPERATION_SEQ + 1;
						END; -- C_LAST_OP
						CLOSE C_LAST_OP;
						DEALLOCATE C_LAST_OP;   -- 메모리 해제
					END;

					-- 2020-09-23 kimcd Route Path 형성에서 P5200 P5000 존재하는 경우 P5000은 제거하는 로직 추가
					UPDATE  A
					SET     A.[FLOW_ID]     = NULL
						  , A.[PATH_LEVEL]  = NULL
					FROM    [DBO].[SCM_MMD_ROUTEPATH_M]  A,
							[DBO].[SCM_SYS_LOOKUP_VALUE] AV (NOLOCK),
							[DBO].[SCM_MMD_ROUTEPATH_M]  B (NOLOCK),
							[DBO].[SCM_SYS_LOOKUP_VALUE] BV (NOLOCK)
					WHERE  	A.[COMPANY_ID]   = B.[COMPANY_ID]
					AND     A.[DIVISION_ID]  = B.[DIVISION_ID]
					AND	    A.[SITE_ID]      = B.[SITE_ID]
					AND     A.[ROUTID]       = B.[ROUTID]
					AND	    A.[FLOWID_TO]    = B.[FLOWID_TO]
					AND	    A.[FLOWID]       = B.[FLOWID]
					AND     AV.[LOOKUP_TYPE_CODE] = 'FP_OPERATION'
					AND     A.[FLOW_ID]      = AV.[SEGMENT1]
					AND     AV.[ACTIVE_FLAG] = 'Y'
					AND     AV.[ATTRIBUTE11] = 'Y'
					AND     BV.[LOOKUP_TYPE_CODE] = 'FP_OPERATION'
					AND     B.[FLOW_ID]      = BV.[SEGMENT1]
					AND     BV.[ACTIVE_FLAG] = 'Y'
					AND     BV.[ATTRIBUTE11] = 'N'
					AND     AV.[ATTRIBUTE10] = BV.[ATTRIBUTE10]
					AND     A.[COMPANY_ID]   = @COMPANY_ID
					AND     A.[DIVISION_ID]  = @DIVISION_ID
					AND	    A.[SITE_ID]      = @SITE_ID
					AND     A.[ROUTID]       = @ROUTID
					AND	    A.[FLOWID_TO]    = @FLOWID_FOR_QUERY
					AND	    A.[FLOWID]       = @FLOWID_FOR_QUERY;
					-- 2020-09-23 kimcd Route Path 형성에서 P5200 P5000 존재하는 경우 P5000은 제거하는 로직 추가

					SET @v_temp1 = 'STEP CLEAR SCM_MMD_ROUTEPATH_M REVISE_FLAG'
					UPDATE [DBO].[SCM_MMD_ROUTEPATH_M]
					SET    [REVISE_FLAG]   = 'N'
					WHERE  [COMPANY_ID]    = @COMPANY_ID
					AND    [DIVISION_ID]   = @DIVISION_ID
					AND	   [SITE_ID]       = @SITE_ID
					AND	   [ROUTID]        = @ROUTID
					AND    [REVISE_FLAG]   = 'Y';

					DELETE @OP_TABLE; -- clear temp table
					SET @FLOW_ID = '' -- OPERATION FLOW ID 변수 초기화

					SET @v_temp1 = 'STEP FETCH AGAIN C_REVISE_OP'
					FETCH NEXT FROM C_REVISE_OP INTO @COMPANY_ID
													,@DIVISION_ID
													,@SITE_ID
													,@ROUTID
													,@FLOWID_FOR_QUERY

				END -- WHILE @@FETCH_STATUS = 0  C_REVISE_OP
				CLOSE C_REVISE_OP;
				DEALLOCATE C_REVISE_OP;   -- 메모리 해제

			END; -- IF @ROUTEPATH_FLAG = 'Y'

		SET @v_temp1 = 'STEP OPEN CURSOR ITEM OP'
    	OPEN C_ITEM_OP_DATA  -- ROUTE 정보가 먼저 수신되고 품목별 ROUTE 정보를 설정하기 위해 CURSOR 분리
        FETCH NEXT FROM C_ITEM_OP_DATA INTO @IF_SEQ
										  , @IF_SOURCE      -- 2019-03-12 kimcd 재료 구분자
										  , @IF_RCV_DATE    -- 2020-06-26 kimcd IF_RCV_DATE 조회추가
										  , @BAS_ITEM_ID
										  , @DISTRB_TG_BAS_ITEM_NAME
										  , @SRC_REPSTR_ID
										  , @SRC_BAS_ITEM_ID
										  , @SRC_KEY_SEQ_NO
										  , @SRC_HIST_SEQ_NO
										  , @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
										  , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
										  , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
										  , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
										  , @BAS_ATTR_MSG
										  , @USE_FLAG
										  , @DEL_FLAG
										  , @FORM_ROUTE -- kimcd 2017-08-18 add



        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			SET @if_id_code = REPLACE( @if_id_code, 'OSC1', @IF_SOURCE)  -- 2019-03-12 kimcd IF ID 변경
			SET @PROCESS_FLAG = 'N'  -- 기본값 설정
			SET @SKIP_ROUTE_FLAG = 'N' -- kimcd 2017-09-02 add MCSS20253-A4 MCSS20253-A2의 Cell 하위 Cell의 경우 정상 Route 적용 제외하기 위해 로직 추가

				
			IF @USE_FLAG = 'Y'
			BEGIN
				SET @v_temp1 = 'STEP clear old data'
				DELETE [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
				WHERE  [MMD_PLANT_ID] = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
				AND    [MODEL_ID]     = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
				AND    [MMD_ROUTID]   = @BAS_KEY_ATTR3;  -- [ROUTID] 경로아이디

				SET @R_OPERATION_GROUP_ID = NULL
				SELECT @R_OPERATION_GROUP_ID = SO.[OPERATION_GROUP_ID]
				FROM   [DBO].[SCM_OPERATION_M]  SO  WITH(NOLOCK)
					  ,[DBO].[SCM_LINE_M]       SL  WITH(NOLOCK)
				WHERE  SO.[COMPANY_ID]   = SL.[COMPANY_ID]
				AND    SO.[DIVISION_ID]  = SL.[DIVISION_ID]
				AND    SO.[SITE_ID]      = SL.[SITE_ID]
				AND    SO.[OPERATION_ID] = SL.[OPERATION_ID]
				AND    SL.LINE_ID = @BAS_ATTR1;

				IF @R_OPERATION_GROUP_ID IS NULL
					BEGIN
						SET @R_OPERATION_GROUP_ID = 'M';
					END;

				IF @BAS_ATTR1 IS NULL
					BEGIN
						SET @BAS_ATTR1 = '-';
					END;

				BEGIN
					SET @v_temp1 = 'STEP insert first item - cell model'
					INSERT INTO [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
						( [MMD_PLANT_ID]
						, [MODEL_ID]
						, [MMD_ROUTID]
						, [MMD_LINE_ID]
						, [OPERATION_GROUP_ID]
						, [COMPANY_ID]
						, [DIVISION_ID]
						, [SITE_ID]
						, [PLANT_ID]
						, [PARENT_ITEM_ID]
						, [CHILD_ITEM_ID]
						, [PHANTOM]
						, [NLEVEL]
						, [CONCATENATE_ITEM]
						, [SORT_ORDER]
						, [ITEM_TYPE]
						, [CHILD_OP_GR_ID]
						, [PARENT_DIVISION_ID]
						, [PARENT_PLANT_ID]
						, [ITEM_CLASS]  -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
						, [INSERT_ID]
						, [INSERT_TIME]
						, [UPDATE_ID]
						, [UPDATE_TIME] )
					SELECT 	  @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
							, @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
							, @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
							, @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
							, @R_OPERATION_GROUP_ID
							, BM.[COMPANY_ID]
							, BM.[DIVISION_ID]
							, BM.[SITE_ID]
							, BM.[PLANT_ID]
							, '*'                    -- [PARENT_ITEM_ID]
							, BM.[PARENT_ITEM_ID]    -- [CHILD_ITEM_ID]
							, 'N'					  -- [PHANTOM]
							, 0					  -- [NLEVEL]
							, BM.[PARENT_ITEM_ID]    -- [CONCATENATE_ITEM]
							, '0000'                 -- [SORT_ORDER]
							, MAX(IM.[ITEM_TYPE])    -- [ITEM_TYPE]
							, MAX(ICL.[OPERATION_GROUP_ID]) -- [CHILD_OP_GR_ID] CHILD_ITEM Operation Group ID
							, BM.[DIVISION_ID]       -- [PARENT_DIVISION_ID]
							, BM.[PLANT_ID]          -- [PARENT_PLANT_ID]
							, MAX(IM.[ITEM_CLASS])   -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
							, @v_proc_name			  -- [INSERT_ID]
							, GETDATE()			  -- [INSERT_TIME]
							, @v_proc_name			  -- [UPDATE_ID]
							, GETDATE()			  -- [UPDATE_TIME]
					FROM   [DBO].[SCM_ITEM_CLASS_LEVEL_M]  ICL  WITH(NOLOCK)
							, [DBO].[SCM_ITEM_CLASS_M]  ICM     WITH(NOLOCK)
							, [DBO].[SCM_BOM_M]  BM    WITH(NOLOCK)
							, [DBO].[SCM_ITEM_M] IM    WITH(NOLOCK)
					WHERE  BM.[COMPANY_ID]  = IM.[COMPANY_ID]
					AND    BM.[DIVISION_ID] = IM.[DIVISION_ID]
					AND    BM.[SITE_ID]     = IM.[SITE_ID]
					AND    BM.[PARENT_ITEM_ID] = IM.[ITEM_ID]
					AND    ICM.[CLASS_ID]   = IM.[ITEM_CLASS]
					AND    ICL.[LEVEL_ID]   = ICM.[LEVEL_3_ID]
					AND    ICL.[LEVEL_CODE] = ICM.[LEVEL_3_CODE]
					AND    ICL.[LEVEL]      = 3
					AND    IM.[ITEM_ID]     = @BAS_KEY_ATTR2 -- [PRODID] 제품아이디
					AND    (@BAS_KEY_ATTR1 = 'ALL' OR BM.[PLANT_ID] = @BAS_KEY_ATTR1)
					GROUP BY BM.[COMPANY_ID]
							, BM.[DIVISION_ID]
							, BM.[SITE_ID]
							, BM.[PLANT_ID]
							, BM.[PARENT_ITEM_ID];
				END;

				-- kimcd 2017-08-18 add start
				IF @FORM_ROUTE = 'Y' 
					BEGIN
						--EM01	M	Mobile
						--EM02	A	Automotive
						--EM03	E	ESS
						SET @PROCESS_FLAG = 'Y' 
						IF @BAS_KEY_ATTR3 != 'FRT005' -- 2018-08-15 kimcd FRT005가 아닌 경우만 활성화 후 공정 Route 갱신. FRT005는 다음 로직에서 처리
							BEGIN
								UPDATE IMU
								SET    IMU.FLOW_ID     = ISNULL(  ( SELECT TOP 1 SMR.[FLOW_ID]
																	FROM   [dbo].[SCM_OPERATION_M]     SO   WITH(NOLOCK)
																		 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR  WITH(NOLOCK)
																	WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
																	AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
																	AND    SO.[SITE_ID]      = SMR.[SITE_ID]
																	AND    SO.[OPERATION_ID] = SMR.[PROCID_TO]
																	AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
																	AND    SO.[COMPANY_ID]   = MIR.[COMPANY_ID]
																	AND    SO.[DIVISION_ID]  = MIR.[DIVISION_ID]
																	AND    SO.[SITE_ID]      = MIR.[SITE_ID]
																	AND    SMR.[FLOW_ID]    IS NOT NULL )
																, ( SELECT TOP 1 SMR.[FIRST_FLOW_ID]
																	FROM   [dbo].[SCM_OPERATION_M]     SO    WITH(NOLOCK)
																		 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR   WITH(NOLOCK)
																	WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
																	AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
																	AND    SO.[SITE_ID]      = SMR.[SITE_ID]
																	AND    SO.[OPERATION_ID] = SMR.[PROCID]
																	AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
																	AND    SO.[COMPANY_ID]   = MIR.[COMPANY_ID]
																	AND    SO.[DIVISION_ID]  = MIR.[DIVISION_ID]
																	AND    SO.[SITE_ID]      = MIR.[SITE_ID]
																	AND    SMR.[FIRST_FLOW_ID] IS NOT NULL)  )
									,  IMU.UPDATE_ID   = @v_proc_name
									,  IMU.UPDATE_TIME = GETDATE()
								FROM  [DBO].[SCM_ITEM_M]              IMU  WITH(NOLOCK)
									, [DBO].[SCM_ITEM_CLASS_LEVEL_M]  ICL  WITH(NOLOCK)
									, [DBO].[SCM_ITEM_CLASS_M]        ICM  WITH(NOLOCK)
									, [DBO].[SCM_BOM_M]               BM   WITH(NOLOCK)
									, [DBO].[SCM_ITEM_M]              IM   WITH(NOLOCK)
									, [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] MIR  WITH(NOLOCK)
								WHERE MIR.[COMPANY_ID]    = BM.[COMPANY_ID]
								AND   MIR.[DIVISION_ID]   = BM.[DIVISION_ID]
								AND   MIR.[SITE_ID]       = BM.[SITE_ID]
								AND   MIR.[PLANT_ID]      = BM.[PLANT_ID]
								AND   MIR.[CHILD_ITEM_ID] = BM.[PARENT_ITEM_ID]
								AND   BM.[COMPANY_ID]     = IM.[COMPANY_ID]
								AND   BM.[DIVISION_ID]    = IM.[DIVISION_ID]
								AND   BM.[SITE_ID]        = IM.[SITE_ID]
								AND   BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
								AND   ICM.[CLASS_ID]      = IM.[ITEM_CLASS]
								AND   ICL.[LEVEL_ID]      = ICM.[LEVEL_2_ID]
								AND   ICL.[LEVEL_CODE]    = ICM.[LEVEL_2_CODE]
								AND   ICL.[LEVEL]         = 2
								AND   ICL.[LEVEL_ID]     IN ('EM01','EM02','EM03') -- 제품 구분. cell, pack..
								AND   MIR.[COMPANY_ID]    = IMU.[COMPANY_ID]
								AND	  MIR.[DIVISION_ID]   = IMU.[DIVISION_ID]
								AND	  MIR.[SITE_ID]       = IMU.[SITE_ID]
								AND	  MIR.[CHILD_ITEM_ID] = IMU.[ITEM_ID]
								AND   MIR.[MMD_PLANT_ID]  = @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
								AND   MIR.[MODEL_ID]      = @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
								AND   MIR.[MMD_ROUTID]    = @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
								AND   MIR.[MMD_LINE_ID]   = @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
								AND   EXISTS (  SELECT 1
												FROM   [dbo].[SCM_OPERATION_M]     SO    WITH(NOLOCK)
													 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR   WITH(NOLOCK)
												WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
												AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
												AND    SO.[SITE_ID]      = SMR.[SITE_ID]
												AND    SO.[OPERATION_ID] = SMR.[PROCID]
												AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
												AND    SO.[COMPANY_ID]   = MIR.[COMPANY_ID]
												AND    SO.[DIVISION_ID]  = MIR.[DIVISION_ID]
												AND    SO.[SITE_ID]      = MIR.[SITE_ID]
												AND    SMR.[FIRST_FLOW_ID] IS NOT NULL
												UNION
												SELECT 1
												FROM   [dbo].[SCM_OPERATION_M]     SO   WITH(NOLOCK)
													 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR  WITH(NOLOCK)
												WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
												AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
												AND    SO.[SITE_ID]      = SMR.[SITE_ID]
												AND    SO.[OPERATION_ID] = SMR.[PROCID_TO]
												AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
												AND    SO.[COMPANY_ID]   = MIR.[COMPANY_ID]
												AND    SO.[DIVISION_ID]  = MIR.[DIVISION_ID]
												AND    SO.[SITE_ID]      = MIR.[SITE_ID]
												AND    SMR.[FLOW_ID]    IS NOT NULL )
							END;

						-- 2017-12-16 kimcd add start ROUTID = 'FRT005'인 경우 제품 item class 기반으로 route 설정
						IF @BAS_KEY_ATTR3 = 'FRT005'
							BEGIN
								UPDATE IMU
								SET    IMU.FLOW_ID     = CASE WHEN ICM.[DEFAULT_OPERATION_ID] = 'F7300' AND   ( SELECT TOP 1 MMR.MMD_ROUTID 
																												FROM   SCM_MMD_MODEL_ROUTE_M  MMR WITH(NOLOCK)
																													  ,SCM_BOM_M              BOM WITH(NOLOCK)
																												WHERE  BOM.PARENT_ITEM_ID = @BAS_KEY_ATTR2
																												AND    BOM.CHILD_ITEM_ID  = MMR.MODEL_ID 
																												AND    BOM.EFF_END_DATE  >= GETDATE()
																												AND    MMR.MMD_ROUTID     IN ( 'ART006', 'ART008', 'ART011', 'ART016')   --2020-04-13 kimcd ART008 공정 추가
																												AND    MMR.ACTIVE_FLAG    = 'Y'
																												AND    BOM.COMPANY_ID     = IMU.COMPANY_ID
																												AND    BOM.DIVISION_ID    = IMU.DIVISION_ID
																												AND    BOM.SITE_ID        = IMU.SITE_ID ) IN ('ART006', 'ART008', 'ART011', 'ART016' ) THEN  --2020-04-13 kimcd ART008 공정 추가
															 'F7200'
														 ELSE ICM.[DEFAULT_OPERATION_ID] END -- 2018-06-08 kimcd 2D는 F7200 Taping을 할당, 그 외 모델은 F7300 Side Taping 공정 할당
									,  IMU.UPDATE_ID   = @v_proc_name
									,  IMU.UPDATE_TIME = GETDATE()
								FROM  [DBO].[SCM_ITEM_M]              IMU  WITH(NOLOCK)
									, [DBO].[SCM_ITEM_CLASS_M]        ICM  WITH(NOLOCK)
									, [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] MIR  WITH(NOLOCK)
								WHERE ICM.[CLASS_ID]      = IMU.[ITEM_CLASS]
								AND   MIR.[COMPANY_ID]    = IMU.[COMPANY_ID]
								AND	  MIR.[DIVISION_ID]   = IMU.[DIVISION_ID]
								AND	  MIR.[SITE_ID]       = IMU.[SITE_ID]
								AND	  MIR.[CHILD_ITEM_ID] = IMU.[ITEM_ID]
								AND   MIR.[MMD_PLANT_ID]  = @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
								AND   MIR.[MODEL_ID]      = @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
								AND   MIR.[MMD_ROUTID]    = @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
								AND   MIR.[MMD_LINE_ID]   = @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
								AND   ICM.[DEFAULT_OPERATION_ID] IS NOT NULL
							END;
						-- 2017-12-16 kimcd add end
					END;
				ELSE
					BEGIN
					-- kimcd 2017-08-18 add end
						SET @LOOP_FLAG = 'Y'
						SET @LOOP_COUNT = 0

						-- kimcd 2017-09-02 add start
						SELECT TOP 1 @SKIP_ROUTE_FLAG = 'Y'
						FROM   [DBO].[SCM_ITEM_CLASS_M]         ICM   WITH(NOLOCK)
							 , [DBO].[SCM_ITEM_CLASS_M]         PCM   WITH(NOLOCK)
							 , [DBO].[SCM_ITEM_M]               IM    WITH(NOLOCK)
							 , [DBO].[SCM_ITEM_M]               PM    WITH(NOLOCK)
							 , [DBO].[SCM_BOM_M]                BM    WITH(NOLOCK)
							 , [DBO].[SCM_SYS_LOOKUP_VALUE]     SSLV  WITH(NOLOCK)
							 , [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  MIR   WITH(NOLOCK)
						WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
						AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
						AND    BM.[SITE_ID]        = IM.[SITE_ID]
						AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
						AND    SSLV.[LOOKUP_TYPE_CODE] = 'BOM_LINK_PLANT'
						AND    SSLV.[ACTIVE_FLAG]  = 'Y'
						AND    SSLV.[SEGMENT1]     = MIR.[PLANT_ID]
						AND    BM.[SITE_ID]        = MIR.[SITE_ID]
						AND    BM.[PLANT_ID]       = SSLV.[SEGMENT2]
						AND    BM.[COMPANY_ID]     = MIR.[COMPANY_ID]
						AND    BM.[PARENT_ITEM_ID] = MIR.[CHILD_ITEM_ID]
						AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
						AND    MIR.[COMPANY_ID]    = PM.[COMPANY_ID]
						AND    MIR.[DIVISION_ID]   = PM.[DIVISION_ID]
						AND    MIR.[SITE_ID]       = PM.[SITE_ID]
						AND    MIR.[CHILD_ITEM_ID] = PM.[ITEM_ID]
						AND    IM.[ITEM_CLASS]     = ICM.[CLASS_ID]
						AND    PM.[ITEM_CLASS]     = PCM.[CLASS_ID]
						--AND    ICM.[CLASS_ID]      = PCM.[CLASS_ID] -- kimcd 2017-12-09 조건 block. 남경 소형 조립. 활성화 후공정 반영
						AND    ICM.[SKIP_ROUTE_FLAG] = 'Y'
						AND    PCM.[SKIP_ROUTE_FLAG] = 'Y'            -- kimcd 2017-12-09 남경 소형 조립. 활성화 후공정 반영. 상하위 품목이 모두 skip인 경우만 skip
						AND    MIR.[MMD_PLANT_ID]  = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
						AND    MIR.[MODEL_ID]      = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
						AND    MIR.[MMD_ROUTID]    = @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
						AND    MIR.[NLEVEL]        = @LOOP_COUNT
						--AND    BM.EFF_END_DATE    >= CAST(GETDATE() AS DATE)
						AND    BM.EFF_END_DATE    >= getdate()
						AND    BM.EFF_START_DATE  < getdate()

						IF @SKIP_ROUTE_FLAG = 'Y'
							SET @LOOP_FLAG = 'N'
						-- kimcd 2017-09-02 add end

						WHILE @LOOP_FLAG = 'Y' -- BOM 전개 수행
						BEGIN
							SET @PROCESS_FLAG = 'Y'  -- 일단 진행으로
							SET @v_temp1 = 'STEP INSERT LOOP'
							INSERT INTO [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
								( [MMD_PLANT_ID]
								, [MODEL_ID]
								, [MMD_ROUTID]
								, [MMD_LINE_ID]
								, [OPERATION_GROUP_ID]
								, [COMPANY_ID]
								, [DIVISION_ID]
								, [SITE_ID]
								, [PLANT_ID]
								, [PARENT_ITEM_ID]
								, [CHILD_ITEM_ID]
								, [PHANTOM]
								, [NLEVEL]
								, [CONCATENATE_ITEM]
								, [SORT_ORDER]
								, [ITEM_TYPE]
								, [CHILD_OP_GR_ID]
								, [PARENT_DIVISION_ID]
								, [PARENT_PLANT_ID]
								, [ITEM_CLASS]  -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
								, [INSERT_ID]
								, [INSERT_TIME]
								, [UPDATE_ID]
								, [UPDATE_TIME] )
							SELECT @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
								 , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
								 , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
								 , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
								 , @R_OPERATION_GROUP_ID
								 , BS.[COMPANY_ID]
								 , BS.[DIVISION_ID]
								 , BS.[SITE_ID]
								 , BS.[PLANT_ID]
								 , BS.[PARENT_ITEM_ID]
								 , BS.[CHILD_ITEM_ID]
								 , BS.[PHANTOM]
								 , BS.[NLEVEL]
								 , BS.[CONCATENATE_ITEM]
								 , BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER]) ) + CAST( BS.[RANK_ORDER] AS NVARCHAR)        -- [SORT_ORDER]
								 , BS.[ITEM_TYPE]
								 , BS.[OPERATION_GROUP_ID]   -- [CHILD_OP_GR_ID]
								 , BS.[PARENT_DIVISION_ID]
								 , BS.[PARENT_PLANT_ID]
								 , BS.[ITEM_CLASS]        -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
								 , @v_proc_name			  -- [INSERT_ID]
								 , GETDATE()			  -- [INSERT_TIME]
								 , @v_proc_name			  -- [UPDATE_ID]
								 , GETDATE()			  -- [UPDATE_TIME]
							FROM  ( SELECT BM.[COMPANY_ID]
										 , BM.[DIVISION_ID]
										 , BM.[SITE_ID]
										 , BM.[PLANT_ID]
										 , BM.[PARENT_ITEM_ID]
										 , BM.[CHILD_ITEM_ID]
										 , BM.[PHANTOM]
										 , @LOOP_COUNT+1			AS NLEVEL
										 , MAX(MIR.[SORT_ORDER])    AS SORT_ORDER
										 , RANK() OVER ( PARTITION BY BM.[COMPANY_ID]
																	, BM.[DIVISION_ID]
																	, BM.[SITE_ID]
																	, BM.[PLANT_ID]
																	, BM.[PARENT_ITEM_ID]
														 ORDER BY BM.[COMPANY_ID]
																, BM.[DIVISION_ID]
																, BM.[SITE_ID]
																, BM.[PLANT_ID]
																, BM.[PARENT_ITEM_ID]
																, BM.[CHILD_ITEM_ID] )  AS RANK_ORDER
										 , MIR.[CONCATENATE_ITEM] + '^' + BM.[CHILD_ITEM_ID]  AS CONCATENATE_ITEM
										 , MAX(IM.[ITEM_TYPE])      AS ITEM_TYPE
										 , ( SELECT ICL.[OPERATION_GROUP_ID]
											 FROM   [DBO].[SCM_ITEM_CLASS_LEVEL_M]  ICL  WITH(NOLOCK)
												  , [DBO].[SCM_ITEM_CLASS_M]  ICM   WITH(NOLOCK)
											 WHERE  ICM.[CLASS_ID]      = MAX(IM.[ITEM_CLASS])
											 AND    ICL.[LEVEL_ID]      = ICM.[LEVEL_3_ID]
											 AND    ICL.[LEVEL_CODE]    = ICM.[LEVEL_3_CODE]
											 AND    ICL.[LEVEL]         = 3
											 )                               AS OPERATION_GROUP_ID  -- [CHILD_OP_GR_ID] CHILD_ITEM Operation Group ID
										 , MIR.[DIVISION_ID]                 AS PARENT_DIVISION_ID
										 , MIR.[PLANT_ID]                    AS PARENT_PLANT_ID
										 , MAX(IM.[ITEM_CLASS])              AS ITEM_CLASS          -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
									FROM   [DBO].[SCM_BOM_M]  BM   WITH(NOLOCK)
										 , [DBO].[SCM_ITEM_M] IM   WITH(NOLOCK)
										 , [DBO].[SCM_SYS_LOOKUP_VALUE]   SSLV   WITH(NOLOCK)
										 , [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  MIR  WITH(NOLOCK)
									WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
									AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
									AND    BM.[SITE_ID]        = IM.[SITE_ID]
									AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
									AND    SSLV.[LOOKUP_TYPE_CODE] = 'BOM_LINK_PLANT'
									AND    SSLV.[ACTIVE_FLAG]  = 'Y'
									AND    SSLV.[SEGMENT1]     = MIR.[PLANT_ID]
									AND    BM.[SITE_ID]        = MIR.[SITE_ID]
									AND    BM.[PLANT_ID]       = SSLV.[SEGMENT2]
									AND    BM.[COMPANY_ID]     = MIR.[COMPANY_ID]
									AND    BM.[PARENT_ITEM_ID] = MIR.[CHILD_ITEM_ID]
									AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
									AND    IM.[ITEM_CLASS]    != MIR.[ITEM_CLASS] -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
									AND    MIR.[MMD_PLANT_ID]  = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
									AND    MIR.[MODEL_ID]      = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
									AND    MIR.[MMD_ROUTID]    = @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
									AND    MIR.[NLEVEL]        = @LOOP_COUNT
									--AND    BM.EFF_END_DATE    >= CAST(GETDATE() AS DATE)
									AND    BM.EFF_END_DATE    >= getdate()
									AND    BM.EFF_START_DATE  <  getdate()
									-- AND    IM.ITEM_TYPE       IN ('H', 'P')  kimcd block condition. 2017-06-05 item 확장이 BOM 형성보다 나중에 되는 경우 route 수신 안 됨
									GROUP BY BM.[COMPANY_ID]
										   , BM.[DIVISION_ID]
										   , BM.[SITE_ID]
										   , BM.[PLANT_ID]
										   , BM.[PARENT_ITEM_ID]
										   , BM.[CHILD_ITEM_ID]
										   , BM.[PHANTOM]
										   , MIR.[CONCATENATE_ITEM]
										   , MIR.[DIVISION_ID]
										   , MIR.[PLANT_ID]) BS
							;

							IF @@ROWCOUNT > 0
								SET @LOOP_COUNT = @LOOP_COUNT+1
							ELSE
								SET @LOOP_FLAG = 'N'

						END -- WHILE @LOOP_FLAG = 'Y'

						SET @v_temp1 = 'STEP ADD ADDITIONAL CHILD FOR SUB DIVISION'
						INSERT INTO [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
							( [MMD_PLANT_ID]
							, [MODEL_ID]
							, [MMD_ROUTID]
							, [MMD_LINE_ID]
							, [OPERATION_GROUP_ID]
							, [COMPANY_ID]
							, [DIVISION_ID]
							, [SITE_ID]
							, [PLANT_ID]
							, [PARENT_ITEM_ID]
							, [CHILD_ITEM_ID]
							, [PHANTOM]
							, [NLEVEL]
							, [CONCATENATE_ITEM]
							, [SORT_ORDER]
							, [ITEM_TYPE]
							, [CHILD_OP_GR_ID]
							, [PARENT_DIVISION_ID]
							, [PARENT_PLANT_ID]
							, [INSERT_ID]
							, [INSERT_TIME]
							, [UPDATE_ID]
							, [UPDATE_TIME] )
						SELECT @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
							 , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
							 , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
							 , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
							 , @R_OPERATION_GROUP_ID
							 , BS.[COMPANY_ID]
							 , BS.[DIVISION_ID]
							 , BS.[SITE_ID]
							 , BS.[PLANT_ID]
							 , BS.[PARENT_ITEM_ID]
							 , BS.[CHILD_ITEM_ID]
							 , BS.[PHANTOM]
							 , BS.[NLEVEL]
							 , BS.[CONCATENATE_ITEM]
							 , BS.[SORT_ORDER]       -- [SORT_ORDER]
							 , BS.[ITEM_TYPE]
							 , BS.[OPERATION_GROUP_ID]   -- [CHILD_OP_GR_ID]
							 , BS.[PARENT_DIVISION_ID]
							 , BS.[PARENT_PLANT_ID]
							 , @v_proc_name			  -- [INSERT_ID]
							 , GETDATE()			  -- [INSERT_TIME]
							 , @v_proc_name			  -- [UPDATE_ID]
							 , GETDATE()			  -- [UPDATE_TIME]
						FROM  ( SELECT MIR.[COMPANY_ID]
									 , MIR.[DIVISION_ID]
									 , MIR.[SITE_ID]
									 , MIR.[PLANT_ID]
									 , MIR.[PARENT_ITEM_ID]
									 , MIR.[PARENT_ITEM_ID]     AS CHILD_ITEM_ID
									 , 'N'                      AS PHANTOM
									 , MAX(UMIR.[NLEVEL])		AS NLEVEL
									 , MAX(UMIR.[SORT_ORDER])   AS SORT_ORDER
									 , UMIR.[CONCATENATE_ITEM]  AS CONCATENATE_ITEM
									 , MAX(IM.[ITEM_TYPE])		AS ITEM_TYPE
									 , ( SELECT ICL.[OPERATION_GROUP_ID]
										 FROM   [DBO].[SCM_ITEM_CLASS_LEVEL_M]  ICL   WITH(NOLOCK)
											  , [DBO].[SCM_ITEM_CLASS_M]  ICM   WITH(NOLOCK)
										 WHERE  ICM.[CLASS_ID]       = MAX(IM.[ITEM_CLASS])
										 AND    ICL.[LEVEL_ID]       = ICM.[LEVEL_3_ID]
										 AND    ICL.[LEVEL_CODE]     = ICM.[LEVEL_3_CODE]
										 AND    ICL.[LEVEL]          = 3 )        AS OPERATION_GROUP_ID  -- [CHILD_OP_GR_ID] CHILD_ITEM Operation Group ID
									 , MIR.[DIVISION_ID]                 AS PARENT_DIVISION_ID
									 , MIR.[PLANT_ID]                    AS PARENT_PLANT_ID
								FROM   [DBO].[SCM_ITEM_M] IM  WITH(NOLOCK)
									 , [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  UMIR  WITH(NOLOCK)
									 , [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  MIR   WITH(NOLOCK)
								WHERE  MIR.[COMPANY_ID]     = IM.[COMPANY_ID]
								AND    MIR.[DIVISION_ID]    = IM.[DIVISION_ID]
								AND    MIR.[SITE_ID]        = IM.[SITE_ID]
								AND    MIR.[PARENT_ITEM_ID] = IM.[ITEM_ID]
								AND    MIR.[MMD_PLANT_ID]              = UMIR.[MMD_PLANT_ID]        -- [SHOPID] 플랜트아이디
								AND    MIR.[MODEL_ID]                  = UMIR.[MODEL_ID]            -- [PRODID] 제품아이디
								AND	   MIR.[MMD_ROUTID]                = UMIR.[MMD_ROUTID]          -- [ROUTID] 경로아이디
								AND	   MIR.[OPERATION_GROUP_ID]        = UMIR.[OPERATION_GROUP_ID]
								AND    MIR.[COMPANY_ID]                = UMIR.[COMPANY_ID]
								AND    MIR.[PARENT_DIVISION_ID]        = UMIR.[DIVISION_ID]
								AND    MIR.[SITE_ID]                   = UMIR.[SITE_ID]
								AND    MIR.[PARENT_PLANT_ID]           = UMIR.[PLANT_ID]
								AND    MIR.[PARENT_ITEM_ID]            = UMIR.[CHILD_ITEM_ID]
								AND    MIR.[CONCATENATE_ITEM]       LIKE UMIR.[CONCATENATE_ITEM] + '^%'
								AND    UMIR.[MMD_PLANT_ID]             = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
								AND    UMIR.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
								AND    UMIR.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    MIR.[MMD_PLANT_ID]              = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
								AND    MIR.[MODEL_ID]                  = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
								AND    MIR.[MMD_ROUTID]                = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    ( MIR.[DIVISION_ID] != MIR.[PARENT_DIVISION_ID]
										 OR MIR.[PLANT_ID] != MIR.[PARENT_PLANT_ID] ) 
								GROUP BY MIR.[COMPANY_ID]
									   , MIR.[DIVISION_ID]
									   , MIR.[SITE_ID]
									   , MIR.[PLANT_ID]
									   , MIR.[PARENT_ITEM_ID]
									   , UMIR.[CONCATENATE_ITEM]
									   , MIR.[DIVISION_ID]
									   , MIR.[PLANT_ID] ) BS
						WHERE NOT EXISTS (  SELECT 1
											FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] CMIR  WITH(NOLOCK)
											WHERE  CMIR.[MMD_PLANT_ID]             = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
											AND    CMIR.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
											AND    CMIR.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
											AND    CMIR.[COMPANY_ID]               = BS.[COMPANY_ID]
											AND    CMIR.[DIVISION_ID]              = BS.[DIVISION_ID]
											AND    CMIR.[SITE_ID]                  = BS.[SITE_ID]
											AND    CMIR.[PLANT_ID]                 = BS.[PLANT_ID]
											AND    CMIR.[CONCATENATE_ITEM]         = BS.[CONCATENATE_ITEM]
											AND    CMIR.[PARENT_DIVISION_ID]       = BS.[PARENT_DIVISION_ID]
											AND    CMIR.[PARENT_PLANT_ID]          = BS.[PARENT_PLANT_ID]
										 );


						-- 2023-06-23 FP Pjt. 활성화 공정 반제품 전환 / Cell Assy 일 경우 상위 Product 항목 제거
						DELETE T
						  FROM [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] AS T
						 WHERE 1 = 1
						   AND T.[MMD_PLANT_ID]			= @BAS_KEY_ATTR1
						   AND T.[MODEL_ID]				= @BAS_KEY_ATTR2
						   AND T.[MMD_ROUTID]			= @BAS_KEY_ATTR3
						   AND T.[MMD_LINE_ID]			= @BAS_ATTR1 
						   AND T.[MMD_ROUTID]			LIKE 'ART%'
						   AND T.NLEVEL < (
							   SELECT MIN(S.NLEVEL)
							     FROM [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] AS S WITH(NOLOCK)
							          JOIN SCM_ITEM_M AS X WITH(NOLOCK)
							      ON S.COMPANY_ID			= X.COMPANY_ID
							     AND S.DIVISION_ID			= X.DIVISION_ID
							     AND S.SITE_ID				= X.SITE_ID
							     AND S.CHILD_ITEM_ID		= X.ITEM_ID  
							     AND X.ITEM_CLASS			= 'ES1901'
							   WHERE 1 = 1
							     AND S.[MMD_PLANT_ID]		= T.[MMD_PLANT_ID]
							     AND S.[MODEL_ID]			= T.[MODEL_ID]
							     AND S.[MMD_ROUTID]			= T.[MMD_ROUTID]
							     AND S.[MMD_LINE_ID]		= T.[MMD_LINE_ID]
							   )

						--3050 제거
						DELETE T
						FROM [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] AS T
						WHERE 1 = 1
						AND T.[MMD_PLANT_ID]		= @BAS_KEY_ATTR1
						AND T.[MODEL_ID]			= @BAS_KEY_ATTR2
						AND T.[MMD_ROUTID]			= @BAS_KEY_ATTR3
						AND T.[MMD_LINE_ID]			= @BAS_ATTR1 
						AND T.PLANT_ID              = '3050'

					END; -- IF @FORM_ROUTE = 'Y'  kimcd 2017-08-18 -- 활성화 Route가 아닌 경우만 BOM 전개하도록 수정
            END; -- IF @USE_FLAG = 'Y'

			IF @PROCESS_FLAG = 'Y' AND ISNULL(@FORM_ROUTE,'N')  != 'Y' AND @SKIP_ROUTE_FLAG = 'N'
			-- kimcd 2017-08-18 -- 활성화 Route가 아닌 경우만 아래 과정 수행되도록 "AND ISNULL(@FORM_ROUTE,'N')  != 'Y'"조건 추가
			-- kimcd 2017-09-02 -- 활성화 후 공정 Tab Cell의 Route 제한을 위해 "AND @SKIP_ROUTE_FLAG = 'N'" 조건 추가
				BEGIN
					SET @v_temp1 = 'STEP CURSOR  C_MMD_ROUTE'
					DECLARE C_MMD_ROUTE CURSOR FOR
						SELECT A.[COMPANY_ID]
							 , A.[DIVISION_ID]  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
							 , A.[SITE_ID]
							 , A.[FLOW_ID]
							 , MAX(A.[PATH_LEVEL])          AS PATH_LEVEL
							 , MAX(A.[OPERATION_GROUP_ID])  AS OPERATION_GROUP_ID
						FROM  ( SELECT SMR.[COMPANY_ID]
									 , SMR.[DIVISION_ID]
									 , SMR.[SITE_ID]
									 , SMR.[FIRST_FLOW_ID]     AS FLOW_ID
									 , SMR.[PATH_LEVEL]+0.5    AS PATH_LEVEL
									 , SO.[OPERATION_GROUP_ID]
								FROM   [dbo].[SCM_OPERATION_M]     SO    WITH(NOLOCK)
									 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR   WITH(NOLOCK)
								WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
								AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
								AND    SO.[SITE_ID]      = SMR.[SITE_ID]
								AND    SO.[OPERATION_ID] = SMR.[PROCID]
								AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    SMR.[FIRST_FLOW_ID] IS NOT NULL
								UNION
								SELECT SMR.[COMPANY_ID]
									 , SMR.[DIVISION_ID]
									 , SMR.[SITE_ID]
									 , SMR.[FLOW_ID]
									 , SMR.[PATH_LEVEL]
									 , SO.[OPERATION_GROUP_ID]
								FROM   [dbo].[SCM_OPERATION_M]     SO   WITH(NOLOCK)
									 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR  WITH(NOLOCK)
								WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
								AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
								AND    SO.[SITE_ID]      = SMR.[SITE_ID]
								AND    SO.[OPERATION_ID] = SMR.[PROCID_TO]
								AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    SMR.[FLOW_ID]    IS NOT NULL
								) A
						WHERE A.[FLOW_ID] != ( CASE WHEN  ( @BAS_KEY_ATTR2 LIKE 'ASLPD%' OR @BAS_KEY_ATTR2 LIKE 'ASLPW%' ) THEN -- kimcd 2018-12-03 ASLPW 조건 추가
													    'E1000'
													ELSE
													    '-1'
													END  ) -- 2017-03-29. 선분산 Route가 E1000, E0500으로 구성됨. 선분산 코드 HARD CODING...
					    GROUP  BY A.[COMPANY_ID]
								, A.[DIVISION_ID]  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								, A.[SITE_ID]
								, A.[FLOW_ID] 
						ORDER  BY A.[COMPANY_ID]
								, A.[DIVISION_ID]  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								, A.[SITE_ID]
								, MAX(A.[PATH_LEVEL]);


					SET @v_temp1 = 'STEP OPEN CURSOR C_MMD_ROUTE'
					SET @MIN_LEVEL = -1
					OPEN C_MMD_ROUTE
					FETCH NEXT FROM C_MMD_ROUTE INTO  @COMPANY_ID
													, @DIVISION_ID -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
													, @SITE_ID
													, @FLOW_ID
													, @PATH_LEVEL
													, @OPERATION_GROUP_ID
					SET @HOLD_COMPANY_ID  = @COMPANY_ID
					SET @HOLD_DIVISION_ID = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
					SET @HOLD_SITE_ID     = @SITE_ID

					WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
					BEGIN
						IF @HOLD_COMPANY_ID  != @COMPANY_ID
						OR @HOLD_DIVISION_ID != @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
						OR @HOLD_SITE_ID     != @SITE_ID
							BEGIN
								SET @MIN_LEVEL = -1
								SET @HOLD_COMPANY_ID  = @COMPANY_ID
								SET @HOLD_DIVISION_ID = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								SET @HOLD_SITE_ID     = @SITE_ID
							END;

						/*IF @BAS_KEY_ATTR2 = 'E' -- 전극의 경우만 @BAS_KEY_ATTR3 (PRDT_CLSS_CODE) 제품 분류 코드가 의미각 있음
												-- 전극 Part No 5번째 6번째 자리가 @BAS_KEY_ATTR3 (PRDT_CLSS_CODE) 제품 분류 코드에 대응되는 자리임.
							BEGIN
								SET @v_temp1 = 'STEP UPDATE SCM_MMD_ITEM_ROUTE_TEMP AT E'
								UPDATE [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
								SET    [FLOW_ID]   = @FLOW_ID
								WHERE  [MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
								AND    [OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
								AND    [ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
								AND    [MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
								AND    [COMPANY_ID]               = @COMPANY_ID
								-- AND    [DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
								AND    [SITE_ID]                  = @SITE_ID
								AND    [CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    [CHILD_ITEM_ID]         LIKE '___' + @BAS_KEY_ATTR3 + '%'  -- -- PRDT_CLSS_CODE 제품 분류 코드
								AND    ISNULL([PHANTOM], 'N')    != 'Y'                 
								AND    [NLEVEL] = ( SELECT MIN(S.NLEVEL)
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
													WHERE  S.[MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
													AND    S.[OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
													AND    S.[ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
													AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
													AND    S.[COMPANY_ID]               = @COMPANY_ID
													-- AND    S.[DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
													AND    S.[SITE_ID]                  = @SITE_ID
													AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    S.[CHILD_ITEM_ID]         LIKE '___' + @BAS_KEY_ATTR3 + '%'  -- -- PRDT_CLSS_CODE 제품 분류 코드
													AND    ISNULL(S.[PHANTOM], 'N')    != 'Y'
													AND    S.[NLEVEL]                   > @MIN_LEVEL )
								AND    NOT EXISTS ( SELECT 1
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] C  WITH(NOLOCK)
													WHERE  C.[MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
													AND    C.[OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
													AND    C.[ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
													AND    C.[MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
													AND    C.[COMPANY_ID]               = @COMPANY_ID
													-- AND    C.[DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
													AND    C.[SITE_ID]                  = @SITE_ID
													AND    C.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    C.[CHILD_ITEM_ID]            = [DBO].[SCM_MMD_ITEM_ROUTE_TEMP].[CHILD_ITEM_ID]
													AND    ISNULL(C.[PHANTOM], 'N')    != 'Y'
													AND    C.[NLEVEL]                  <= @MIN_LEVEL );

								SET @v_temp1 = 'STEP GET MAX LEVEL AT E'
								SELECT @MIN_LEVEL = MAX(S.NLEVEL)
								FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
								WHERE  S.[MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
								AND    S.[OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
								AND    S.[ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
								AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
								AND    S.[COMPANY_ID]               = @COMPANY_ID
								-- AND    S.[DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
								AND    S.[SITE_ID]                  = @SITE_ID
								AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    S.[CHILD_ITEM_ID]         LIKE '___' + @BAS_KEY_ATTR3 + '%'  -- -- PRDT_CLSS_CODE 제품 분류 코드
								AND    S.[FLOW_ID]               IS NOT NULL;

							END
						ELSE*/
							BEGIN
								SET @v_temp1 = 'STEP UPDATE SCM_MMD_ITEM_ROUTE_TEMP AT ELSE'
								UPDATE [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
								SET    [FLOW_ID]   = @FLOW_ID
								WHERE  [MMD_PLANT_ID]             = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
								AND    [MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
								AND    [MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    [COMPANY_ID]               = @COMPANY_ID
								AND    [DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								AND    [SITE_ID]                  = @SITE_ID
								AND    [CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    ISNULL([PHANTOM], 'N')    != 'Y'                 
								AND    [NLEVEL] = ( SELECT MIN(S.NLEVEL)
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
													WHERE  S.[MMD_PLANT_ID]             = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
													AND    S.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
													AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
													AND    S.[COMPANY_ID]               = @COMPANY_ID
													AND    S.[DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
													AND    S.[SITE_ID]                  = @SITE_ID
													AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    ISNULL(S.[PHANTOM], 'N')    != 'Y'
													AND    S.[NLEVEL]                   > @MIN_LEVEL )
								AND    NOT EXISTS ( SELECT 1
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] C  WITH(NOLOCK)
													WHERE  C.[MMD_PLANT_ID]             = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
													AND    C.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
													AND    C.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
													AND    C.[COMPANY_ID]               = @COMPANY_ID
													AND    C.[DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
													AND    C.[SITE_ID]                  = @SITE_ID
													AND    C.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    C.[CHILD_ITEM_ID]            = [DBO].[SCM_MMD_ITEM_ROUTE_TEMP].[CHILD_ITEM_ID]
													AND    ISNULL(C.[PHANTOM], 'N')    != 'Y'
													AND    C.[NLEVEL]                  <= @MIN_LEVEL );

								SET @v_temp1 = 'STEP GET MAX LEVEL AT ELSE'
								SELECT @MIN_LEVEL = ISNULL(MAX(S.NLEVEL),-1)
								FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
								WHERE  S.[MMD_PLANT_ID]             = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
								AND    S.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
								AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    S.[COMPANY_ID]               = @COMPANY_ID
								AND    S.[DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								AND    S.[SITE_ID]                  = @SITE_ID
								AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    S.[FLOW_ID]               IS NOT NULL;
							END

						FETCH NEXT FROM C_MMD_ROUTE INTO  @COMPANY_ID
														, @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
														, @SITE_ID
														, @FLOW_ID
														, @PATH_LEVEL
														, @OPERATION_GROUP_ID

					END; -- C_MMD_ROUTE
					CLOSE C_MMD_ROUTE;
					DEALLOCATE C_MMD_ROUTE;   -- 메모리 해제

					SET @PROCESS_FLAG = 'N'
	                -- OPERATION FLOW 입력용 ROUTE CURSOR
					DECLARE C_ITEM_FLOW CURSOR FOR
						SELECT COMPANY_ID
							 , DIVISION_ID
							 , SITE_ID
							 , CHILD_ITEM_ID
							 , FLOW_ID
						FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  WITH(NOLOCK)
						WHERE  [MMD_PLANT_ID]             = @BAS_KEY_ATTR1   -- [SHOPID] 플랜트아이디
						AND    [MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
						AND    [MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
						AND    [FLOW_ID] IS NOT NULL;
							

						SET @v_temp1 = 'STEP OPEN CURSOR ITEM FLOW'
    					OPEN C_ITEM_FLOW
						FETCH NEXT FROM C_ITEM_FLOW INTO @COMPANY_ID
														,@DIVISION_ID
														,@SITE_ID
														,@CHILD_ITEM_ID
														,@FLOW_ID
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
							SET @PROCESS_FLAG = 'Y'

							SET @v_temp1 = 'STEP UPDATE ITEM FLOW'
							UPDATE A
							SET    A.FLOW_ID     = CASE WHEN @FLOW_ID LIKE 'A5000%' THEN
													   (SELECT 'A5000'+ISNULL(MAX(SOM.OPERATION_ID),'')
													    FROM   SCM_OPERATION_M SOM WITH(NOLOCK)
														WHERE  SOM.COMPANY_ID   = @COMPANY_ID
														AND    SOM.DIVISION_ID  = @DIVISION_ID
														AND    SOM.SITE_ID      = @SITE_ID
														AND    SOM.OPERATION_ID = 'A6000'
														AND    SOM.ACTIVE_FLAG  = 'Y')
							                       ELSE 
												       @FLOW_ID
												   END -- 2019-08-01 kimcd A6000 공정이 Option형태로 바뀜에 따라 수정
								 , A.FORMATION_FLOW_ID = -- CASE WHEN @FLOW_ID = 'A9000' THEN 'F6000' END -- 2017-11-08 kimcd 활성화 특성 공정 hard coding 2018-07-11 kimcd block
														CASE WHEN A.FORMATION_FLOW_ID LIKE '%F5600' THEN
															A.FORMATION_FLOW_ID -- 2018-10-02 kimcd 수작업 특성 품목의 경우 FORMATION_FLOW_ID 값 유지
														ELSE
								 							(   SELECT CASE WHEN (SELECT TOP 1 'Y'
																				  FROM   SCM_BOM_M B WITH(NOLOCK)
																						,SCM_ITEM_M P WITH(NOLOCK)
																				  WHERE  B.COMPANY_ID     = P.COMPANY_ID
																				  AND    B.DIVISION_ID    = P.DIVISION_ID
																				  AND    B.SITE_ID        = P.SITE_ID
																				  AND    B.PARENT_ITEM_ID = P.ITEM_ID
																				  AND    P.FLOW_ID        = 'F7000' -- DSF
																				  AND    B.COMPANY_ID     = A.COMPANY_ID
																				  AND    B.DIVISION_ID    = A.DIVISION_ID
																				  AND    B.SITE_ID        = A.SITE_ID
																				  AND    B.CHILD_ITEM_ID  = A.ITEM_ID
																				  AND    B.EFF_END_DATE  >= GETDATE() ) = 'Y' THEN  SUBSTRING(SLV.ATTRIBUTE1, 1,5)
																	   ELSE CASE WHEN SLV.ATTRIBUTE4 = A.ITEM_CLASS THEN SLV.ATTRIBUTE5 ELSE SLV.ATTRIBUTE1 END END -- 2018-10-02 kimcd DSF 품목의 하위 품목은 특성만 OPERATION FLOW 형성
																	   -- 2020-01-21 kimcd 초소형 특성 공정 반영 위해 CASE WHEN SLV.ATTRIBUTE4 = A.ITEM_CLASS THEN SLV.ATTRIBUTE5 ELSE SLV.ATTRIBUTE1 END 문장으로 수정
																	   --                  SCM,SSP 전송용 View에서 'FORMATION_MMD_ROUTE_CONVERT' lookup 사용하여 SEGMENT5에 ITEM CLASS 넣지 못 하고 ATTRIBUTE4,5 사용
																	   --                  특이 사항 추가되면 LOOKUP 분리 필요
																FROM   SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																WHERE  SLV.LOOKUP_TYPE_CODE = 'FORMATION_MMD_ROUTE_CONVERT'
																AND    SLV.SEGMENT1  = SITE_ID
																AND    SLV.SEGMENT2  = DIVISION_ID
																AND    SLV.SEGMENT3  = @FLOW_ID
																AND    SLV.SEGMENT4  = A.COMPANY_ID -- 2019-08-29 kimcd COMPANY_ID 조건 추가
																AND    SLV.ACTIVE_FLAG = 'Y' )  -- 2018-07-11 kimcd SITE, 공정 기반 LOOKUP으로 전환
														END
								 , UPDATE_ID   = 'PR_XIF_MMD_ALL_R'
								 , UPDATE_TIME = GETDATE()
							FROM   [DBO].[SCM_ITEM_M] A
							WHERE  [COMPANY_ID]  = @COMPANY_ID
							AND    [DIVISION_ID] = @DIVISION_ID
							AND    [SITE_ID]     = @SITE_ID
							AND    [ITEM_ID]     = @CHILD_ITEM_ID
    						SET @v_count = @v_count + 1;

							FETCH NEXT FROM C_ITEM_FLOW INTO @COMPANY_ID
															,@DIVISION_ID
															,@SITE_ID
															,@CHILD_ITEM_ID
															,@FLOW_ID

						END -- WHILE @@FETCH_STATUS = 0  C_ITEM_FLOW
						CLOSE C_ITEM_FLOW;
						DEALLOCATE C_ITEM_FLOW;   -- 메모리 해제

						IF @PROCESS_FLAG = 'Y'
							BEGIN
								UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
								SET [PROC_FLAG] = 'Y'
								   ,[UPDDTTM]   = GETDATE()
								WHERE [PROC_FLAG] = 'P'
								AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
								AND   [IF_SEQ]    = @IF_SEQ;

								SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
								SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

								INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
									([IF_SEQ]             -- [nvarchar](50) NOT NULL,
									,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
									,[IF_ID]              -- [nvarchar](50) NOT NULL,
									,[IF_SND_DATE]        -- [datetime] NULL,
									,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
									,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
									,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
									)
								VALUES
									(@send_if_seq
									,'R'
									,@if_id_code
									,GETDATE()
									,@IF_SEQ
									,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
									,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
									);

								-- 2018-06-08 kimcd 2D Taping Route 형성용 Update 시작
								IF @BAS_KEY_ATTR3 IN ( 'ART006', 'ART008', 'ART011', 'ART016') -- 2020-04-13 kimcd Taping 변경 대상에 ART008추가
									BEGIN
										UPDATE IMU
										SET    IMU.FLOW_ID     = 'F7200'
											,  IMU.UPDATE_ID   = @v_proc_name
											,  IMU.UPDATE_TIME = GETDATE()
										FROM  [DBO].[SCM_ITEM_M] IMU  WITH(NOLOCK)
											, [DBO].[SCM_BOM_M]  BOM  WITH(NOLOCK)
										WHERE BOM.CHILD_ITEM_ID  = @BAS_KEY_ATTR2
										AND   BOM.PARENT_ITEM_ID = IMU.ITEM_ID
										AND   BOM.COMPANY_ID     = IMU.COMPANY_ID
										AND   BOM.DIVISION_ID    = IMU.DIVISION_ID
										AND   BOM.SITE_ID        = IMU.SITE_ID
										AND   BOM.EFF_END_DATE  >= GETDATE()
										AND   IMU.FLOW_ID        = 'F7300'
									END;
								-- 2018-06-08 kimcd 2D Taping Route 형성용 Update 끝
							END;
						ELSE
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = CASE WHEN @IF_RCV_DATE < @MONTH_DATE THEN 'Y' ELSE 'N' END -- 2020-06-26 kimcd 한달이상 BOM 없어서 수신 안 된 것은 수신 처리
								,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
							AND   [IF_SEQ]    = @IF_SEQ;
				END;
			ELSE IF @USE_FLAG = 'N' OR ( @PROCESS_FLAG = 'Y' AND @FORM_ROUTE = 'Y') -- kimcd OR "OR ( @PROCESS_FLAG = 'Y' AND @FORM_ROUTE = 'Y')" 조건 추가. Process 가 Y이고 활성화 공정의 경우 수신 완료로 갱신
					OR @SKIP_ROUTE_FLAG = 'Y' -- kimcd 2017-09-02 -- 활성화 후 공정 Tab Cell의 Route 제한을 위해 "AND @SKIP_ROUTE_FLAG = 'N'" 조건 추가
				BEGIN
					UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
					SET [PROC_FLAG] = 'Y'
						,[UPDDTTM]   = GETDATE()
					WHERE [PROC_FLAG] = 'P'
					AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
					AND   [IF_SEQ]    = @IF_SEQ;

					SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]
					SET @send_if_seq = @send_date + REPLICATE('0', 10 - LEN(@if_seq_next)) + CAST( @if_seq_next AS NVARCHAR)

					INSERT INTO [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_S]
						([IF_SEQ]             -- [nvarchar](50) NOT NULL,
						,[IF_TYPE]            -- [nvarchar](1) NOT NULL,
						,[IF_ID]              -- [nvarchar](50) NOT NULL,
						,[IF_SND_DATE]        -- [datetime] NULL,
						,[RSLT_IF_SEQ]        -- 수신 받은 IF_SEQ 저장
						,[RSLT_PROC_FLAG]     -- FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,[RSLT_PROC_MSG]      -- FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						)
					VALUES
						(@send_if_seq
						,'R'
						,@if_id_code
						,GETDATE()
						,@IF_SEQ
						,'S'	    -- RSLT_PROC_FLAG : FP 프로시져 처리 결과 저장 (S : 성공, F : 실패)
						,@PROC_MSG 	-- RSLT_PROC_MSG : FP 프로시져 처리 결과 저장 (성공 or 에러 메시지)
						);

				END;
			ELSE -- PROCESS가 아닌 경우 N 상태로 복원 작업 수행
			    BEGIN
					UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
					SET [PROC_FLAG] = CASE WHEN @IF_RCV_DATE < @MONTH_DATE THEN 'Y' ELSE 'N' END -- 2020-06-26 kimcd 한달이상 BOM 없어서 수신 안 된 것은 수신 처리
						,[UPDDTTM]   = GETDATE()
					WHERE [PROC_FLAG] = 'P'
					AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
					AND   [IF_SEQ]    = @IF_SEQ;
				END;

			SET @v_temp1 = 'STEP MERGE [SCM_MMD_MODEL_ROUTE_M]'
			MERGE INTO [DBO].[SCM_MMD_MODEL_ROUTE_M] MR
			USING ( SELECT @BAS_KEY_ATTR1          AS MMD_PLANT_ID  -- [SHOPID] 플랜트아이디
						 , @BAS_KEY_ATTR2          AS MODEL_ID      -- [PRODID] 제품아이디
						 , @BAS_KEY_ATTR3          AS MMD_ROUTID    -- [ROUTID] 경로아이디
					     , ISNULL(@BAS_ATTR1,'-')  AS MMD_LINE_ID   -- [EQSGID] 설비세그먼트아이디
						 , @R_OPERATION_GROUP_ID   AS OPERATION_GROUP_ID
						 , @USE_FLAG	           AS ACTIVE_FLAG ) XXX
			ON    (     MR.[MMD_PLANT_ID] = XXX.[MMD_PLANT_ID]
					AND MR.[MODEL_ID]     = XXX.[MODEL_ID]
					AND MR.[MMD_ROUTID]   = XXX.[MMD_ROUTID]
					)
			WHEN MATCHED THEN
				UPDATE SET MR.[MMD_LINE_ID] = XXX.[MMD_LINE_ID]
						 , MR.[OPERATION_GROUP_ID] = XXX.[OPERATION_GROUP_ID]
						 , MR.[ACTIVE_FLAG] = XXX.[ACTIVE_FLAG]
						 , MR.[UPDATE_ID]   = @v_proc_name
						 , MR.[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT ( [MMD_PLANT_ID]
						,[MODEL_ID]
						,[MMD_ROUTID]
						,[MMD_LINE_ID]
						,[OPERATION_GROUP_ID]
						,[ACTIVE_FLAG]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
					    )
				VALUES ( XXX.[MMD_PLANT_ID]
					   , XXX.[MODEL_ID]
					   , XXX.[MMD_ROUTID]
					   , XXX.[MMD_LINE_ID]
					   , XXX.[OPERATION_GROUP_ID]
					   , XXX.[ACTIVE_FLAG]
					   , @v_proc_name
					   , GETDATE()
					   , @v_proc_name
					   , GETDATE()
					   );
    		SET @v_count = @v_count + 1;


			SET @v_temp1 = 'STEP FETCH AGAIN C_ITEM_OP_DATA'
			FETCH NEXT FROM C_ITEM_OP_DATA INTO @IF_SEQ
											  , @IF_SOURCE      -- 2019-03-12 kimcd 재료 구분자
											  , @IF_RCV_DATE    -- 2020-06-26 kimcd IF_RCV_DATE 조회추가
											  , @BAS_ITEM_ID
											  , @DISTRB_TG_BAS_ITEM_NAME
											  , @SRC_REPSTR_ID
											  , @SRC_BAS_ITEM_ID
											  , @SRC_KEY_SEQ_NO
											  , @SRC_HIST_SEQ_NO
											  , @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
											  , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
											  , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
											  , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
											  , @BAS_ATTR_MSG
											  , @USE_FLAG
											  , @DEL_FLAG
											  , @FORM_ROUTE -- kimcd 2017-08-18 add

		END -- WHILE @@FETCH_STATUS = 0  C_ITEM_OP_DATA
		CLOSE C_ITEM_OP_DATA;
		DEALLOCATE C_ITEM_OP_DATA;   -- 메모리 해제
        -- COMMIT TRANSACTION; 2020-01-10 kimcd transaction block 제거

        SET @v_temp1 = 'STEP END PROCEDURE'
        EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @v_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

    END TRY

	BEGIN CATCH

	   -- ROLLBACK TRANSACTION;  2020-01-10 kimcd transaction block 제거
		-- 에러나도 로그는 인서트
		SET @data_s = CURSOR_STATUS('global','C_DATA')
		IF @data_s IN (1,0)
						 BEGIN
		                     CLOSE C_DATA;
                             DEALLOCATE C_DATA;   -- 메모리 해제
                         END

		SET @site_s = CURSOR_STATUS('global','C_ITEM_OP_DATA')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_ITEM_OP_DATA;
                             DEALLOCATE C_ITEM_OP_DATA;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_PROCESS_SITE')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_PROCESS_SITE;
                             DEALLOCATE C_PROCESS_SITE;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_EQUIPMENT_LINE')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_EQUIPMENT_LINE;
                             DEALLOCATE C_EQUIPMENT_LINE;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_EQUIPMENT')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_EQUIPMENT;
                             DEALLOCATE C_EQUIPMENT;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_OP_CHECK')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_OP_CHECK;
                             DEALLOCATE C_OP_CHECK;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_LINE_FACTORY')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_LINE_FACTORY;
                             DEALLOCATE C_LINE_FACTORY;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_LOOKUP_PRODUCT')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_LOOKUP_PRODUCT;
                             DEALLOCATE C_LOOKUP_PRODUCT;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_CHECK_OPERATION')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_CHECK_OPERATION;
                             DEALLOCATE C_CHECK_OPERATION;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_REVISE_OP')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_REVISE_OP;
                             DEALLOCATE C_REVISE_OP;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_SPREAD_RT')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_SPREAD_RT;
                             DEALLOCATE C_SPREAD_RT;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_OP_TEMP')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_OP_TEMP;
                             DEALLOCATE C_OP_TEMP;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_LAST_OP')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_LAST_OP;
                             DEALLOCATE C_LAST_OP;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_BOM')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_BOM;
                             DEALLOCATE C_BOM;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_MMD_ROUTE')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_MMD_ROUTE;
                             DEALLOCATE C_MMD_ROUTE;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_ITEM_FLOW')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_ITEM_FLOW;
                             DEALLOCATE C_ITEM_FLOW;   -- 메모리 해제
			             END

		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_temp1, @v_descr, @sysdate

	END CATCH

END

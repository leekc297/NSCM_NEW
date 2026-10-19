
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_FIX_MISMATCHING
 * Description  : INPUT 데이터 처리후 후처리작업(엔진요청작업) 모음

                  -------------------------------------------------
                  -- 1  엔진요청 임시실행모음 및 기타
                  -------------------------------------------------
                     1-1 ITEM 임시변경


                  -------------------------------------------------
                  -- 2. Cell Biz Demand 의 Late 계획수립 결과와 관련한 모델링 변경 처리에 필요한 후처리( 티라에서 생성한 쿼리 그대로 사용함)
                  -------------------------------------------------
                    1.TH_ENG_PLAN_BOM	" [INSERT]
                        1) Cell 출하창고와 Cell Biz Sales Site 사이에 가상 Item 과 가상 Plant Site 를 추가해서 FLO 를 구성
                        2) Cell Biz Demand 의 Cell Item / Sales Site 의 종류만큼 Record 생성
                          - PARENT_ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'
                          - CHILD_ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item)
                          - SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - ROUTE_ID/OPERATION_ID : 'DUMMY' (가상 Dummy 공정)
                          - PARENT_ITEM_RATE : 1
                          - CHILD_ITEM_RATE : 1
                          - ITEM_TYPE : 'H'"

                    2.TH_ENG_ITEM	" [INSERT]
                        1) 가상 PLAN_BOM 구성을 위한 가상 Item 등록
                        2) Cell Biz Demand 의 Cell Item 의 종류만큼 Record 생성
                          - ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'"

                    3.TH_ENG_ROUTE	" [INSERT]
                      1) 가상 PLAN_BOM 구성을 위한 가상의 Dummy Route 등록
                      2) Record 1건 등록
                       - ROUTE_ID : 'DUMMY' (가상 Dummy 공정)"
   
                    4. TH_ENG_SITE	" [INSERT]
                        1) 가상 PLAN_BOM 구성을 위한 가상 Plant Site 등록
                        2) Cell Biz Demand 의 Sales Site 의 종류만큼 Record 생성
                          - SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - SITE_GROUP : 'PLANT'
                          - PLANT_FLAG : 'Y'"
      
                    5. TH_ENG_ITEM_ROUTE_SITE	" [INSERT]
                        1) Cell 출하창고와 Cell Biz Sales Site 사이에 가상 Dummy Route 를 등록
                        2) Cell Biz Demand 의 Cell Item / Sales Site 의 종류만큼 Record 생성
                          - TH_ENG_PLAN_BOM 데이터를 이용해서 생성 (1:1)
                          - ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'
                          - SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - ROUTE_ID/OPERATION_ID : 'DUMMY' (가상 Dummy 공정)
                          - MIN_TAT/AVG_TAT/MAX_TAT : 0
                          - YIELD : 1
                          - EARLY_PRODUCING_TERM : 0"

                    6. TH_ENG_SALES_PRODUCT_MAP	" [UPDATE]
                        1) Cell Biz Demand 의 Sales Model 과 Cell Item 을 기반으로 생성된 가상 Item 을 Mapping
                        2) Cell Biz Demand Record 를 대상으로 Update 실행
                          - PRODUCT_ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'"
      
                    7-1.TH_ENG_BOD	" [INSERT]
                        1) Cell Biz Demand 기준의 가상 Plant Site 와 해당 Cell Biz Sales Site 간에 가상의 Dummy BOD 를 등록
                        2) Cell Biz Demand 의 Cell Item / Sales Site 의 종류만큼 Record 생성
                          - BOD_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D' + '::' + 일련번호(Sales Site 기준 생성)
                          - FROM_SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - TO_SITE_ID : 각 Cell Biz Demand 의 Sales Site
                          - ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'
                          - TRANSPORT_MODE : 'TRK'
                          - TRANSPORT_TIME : 0
                          - FIXED_TERM : 0

                    7-2.TH_ENG_BOD	"  [UPDATE]
                      1) Cell Biz Demand 의 Cell Item 을 기준으로 Cell Plant Site 와 Cell Biz Sales Site 간에 등록된 BOD 의 To Site 를 가상 Plant Site 로 Update
                      2) 기존 Cell Item 기준의 Cell Plant Site - Cell Biz Sales Site 간 BOD_ID 별로 데이터 Update
                        - TO_SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'"

                    8.TH_ENG_ITEM_BOD	" [INSERT]
                        1) Cell Biz Demand 기준의 가상 Plant Site 와 해당 Cell Biz Sales Site 간에 가상의 Dummy BOD 를 등록
                        2) Cell Biz Demand 의 Cell Item / Sales Site 의 종류만큼 Record 생성
                          - BOD_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D' + '::' + 일련번호(Sales Site 기준 생성)
                          - ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'
                          - FROM_SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'"

                    9. TH_ENG_OP_RES_GROUP	" [INSERT]
                        1) Cell Biz Demand 기준의 가상 Dummy Route 별로 가상의 Dummy Reosurce Map 을 등록
                        2) Cell Biz Demand 의 Cell Item / Sales Site 의 수만큼 가상의 Dummy Resource Map Record 등록
                          - SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - ROUTE_ID/OPERATION_ID : 'DUMMY' (가상 Dummy 공정)
                          - ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'
                          - RESOURCE_MAP_ID : 상단 ITEM_ID + '::DUMMY::' + 상단 SITE_ID
                          - MIN_TACT_TIME/AVG_TACT_TIME/MAX_TACT_TIME : 0
                          - YIELD : 1
                          - DESCR : 'DUMMY_LINE'"

                    10. TH_ENG_OP_RES_GROUP_MAP	" [INSERT]
                        1) Cell Biz Demand 기준의 가상 Dummy Route 별로 가상의 Dummy Reosurce Group 을 등록
                        2) Cell Biz Demand 의 Cell Item / Sales Site 의 수만큼 가상의 Dummy Resource Group Record 등록
                          - SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - ROUTE_ID/OPERATION_ID : 'DUMMY' (가상 Dummy 공정)
                          - ITEM_ID : 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'
                          - RESOURCE_MAP_ID : 상단 ITEM_ID + '::DUMMY::' + 상단 SITE_ID
                          - RESOURCE_GROUP_ID : 'DUMMY::' + 상단 SITE_ID
                          - TACT_TIME : 0.0000000001
                          - YIELD : 1
                          - DESCR : 'DUMMY_LINE'"

                    11.TH_ENG_RESOURCE	" [INSERT]
                        1) Cell Biz Demand 기준의 가상 Dummy Route 별로 가상의 Dummy Reosurce 를 등록
                        2) Cell Biz Demand 의 Cell Item / Sales Site 의 수만큼 가상의 Dummy Resource Record 등록
                          - RESOURCE_GROUP_ID : 'DUMMY::' + 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - RESOURCE_TYPE : 'MAIN'
                          - SITE_ID : 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - ROUTE_ID : 'DUMMY' (가상 Dummy 공정)
                          - IS_FINITE : 'Y'
                          - IS_DUMMY : 'N'
                          - RESOURCE_GROUP_ID : 'DUMMY::' + 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - FIXED_TERM/NCP_TERM : 0
                          - DESCR : DUMMY_LINE"
      
                    12. TH_ENG_BUCKET_RES_CAPA	" [INSERT]
                        1) Cell Biz Demand 의 Sales Site 별 가상 Dummy Resource 를 기준으로 Plan Horizon 구간만큼 Record 등록
                        2) TH_ENG_RESOURCE / TH_ENG_BUCKET_RES_CAPA 테이블을 Join 해서 데이터 생성
                          - 휴일 없이 전구간 MAX CAPA
                          - RESOURCE_ID : 'DUMMY::' + 각 Cell Biz Demand 의 Sales Site + '-A~***'"

                    13-1. TH_ENG_FIXED_PLAN	" [INSERT]
                        1) Cell Biz Demand 의 납기(DUE_DATE) 를 기준으로 CELL 의 FIXED_TERM 구간에 속한 Demand 를 대상으로 가상의 Fixed Plan 을 등록
                        2) 해당 기준에 부합하는 Cell Biz Demand 데이터를 Fixed Plan 으로 등록
                          - TH_ENG_NET_DEMAND 데이터를 이용해서 생성 (1:1)
                            : Fixed Term 구간 내에 납기가 포함되어 있는 Cell Biz Demand의 총량 만큼만 Fixed Plan 을 생성
                          - WORK_ORDER_ID : 'WO::DUMMY_LINE::' + 일련번호(DUE_DATE, DEMAND_ID 기준)
                          - WORK_ORDER_SEQ : '50001'
                          - SITE_ID : TH_ENG_NET_DEMAND.SITE + '-A~***'
                          - ROUTE_ID/OPERATION_ID : 'DUMMY' (가상 Dummy 공정)
                          - ITEM_ID : TH_ENG_NET_DEMAND.ITEM + '^D'
                          - RESOURCE_ID : 'DUMMY::' + TH_ENG_NET_DEMAND.SITE + '-A~***'
                          - START_DTTM/END_DTTM : CONVERT(DATETIME,CONVERT(CHAR(8),TH_ENG_NET_DEMAND.DUE_DATE,112))
                          - OPERATION_QTY/COMPLETE_QTY : TH_ENG_NET_DEMAND.QTY
                          - LOT_ID : 상단 WORK_ORDER_ID 와 동일
                          - IS_FIXED : 'N'
                          - DESCR : 상단 WORK_ORDER_ID 와 동일

				    13-2. TH_ENG_FIXED_PLAN - TO_SITE UPDATE

                    14. TH_ENG_STOCK_PLAN UPDATE

                    15. TH_ENG_DEMAND_ATTRIBUTE	" [UPDATE]
                        1) 기존 Cell Biz Demand 의 Preference Site/Item 에 가상 Plant Site 와 가상 Item 을 추가 등록
                        2) 전체 Cell Biz Demand 를 대상으로 해당 가상 Plant Site 와 가상 Item 을 추가하여 Update
                          - PREFERENCE_SITE_ID : PREFERENCE_SITE_ID + '##' + 각 Cell Biz Demand 의 Sales Site + '-A~***'
                          - PREFERENCE_PRODUCT_ID : PREFERENCE_PRODUCT_ID + '##' + 각 Cell Biz Demand 의 Model ID (A9000 Cell Item) + '^D'"

                     
                  -------------------------------------------------
                  -- 3. WORK_ORDER_SEQ 재설정
                  -------------------------------------------------

                    3-1. TH_ENG_FIXED_PLAN [UPDATE]
                        1) WORK_ORDER_SEQ 재설정
                          - 전극(E) 생산공정 : '10000'
                          - 전극(E) → CELL(A) 물류공정 : '20000'
                          - CELL(A) 생산공정 : '30000'
                          - CELL(A) → PACK(P) 물류공정 : '40000'
                          - CELL(A) → Sales Site 물류공정 : '40000'
                          - PACK(P) 생산공정 : '50000'
                          - CELL(A) 가상공정 : '50000'
                          - PACK(P) → Sales Site 물류공정 : '60000'"
                           
                  -------------------------------------------------
                  -- 4. Production Lot Size 설정
                  -------------------------------------------------

                    4-1. TH_ENG_ITEM_ROUTE_SITE [UPDATE]
                    
                           
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.25   KSW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.10   KSW         공용 모델만 Cell Biz Demand 관련 처리
 * 2018.07.16   KSW         공용 모델만 Cell Biz Demand 관련 처리 추가수정
 * 2018.08.22   KSG         TH_ENG_FIXED_PLAN - TO_SITE UPDATE 추가 수정
 * 2018.09.20   KSG         TH_ENG_ITEM_ROUTE_SITE - Lot Size UPDATE 추가 수정
 * 2018.10.26   KSW         TH_ENG_FIXED_PLAN 일부 KEEP_WORK_TIME_TYPE, END_DTTM 컬럼값 수정 (참고) 주석13-1
 * 2018.11.07   KSW         ITEM 변경 대상 및 변경값을 하드코딩에서 LOOKUP테이블로 변경함(참고)주석1-1
 * 2018.11.26   KSW         TH_ENG_STOCK_PLAN UPDATE 부분 추가(참고)주석2-14
 * 2018.12.04   KSW         #COMMON_CELL_ITEM , #COMMON_CELL_DEMAND 로직 변경(참고)주석2(step 0-2, stop 0-3)
 * 2018.12.26   KSW         #COMMON_CELL_ITEM 로직 변경(참고)주석2(step 0-2)
 * 2019.02.18   KSW         Production Lot Size 설정부분의 조회조건 변경(th_eng_product_mix_sn.descr='OSP'조회조건추가, 특성CAPA데이터(descr='CHAR') 제외시키기위해서) (참고)주석4 
 * 2019.03.13   KSW         (티라 엔진 속도개선) #COMMON_CELL_ITEM 처리부분 수정(참고)주석2(step 0-2)
 * 2019.07.25   KSG         소형 전 구간 LATE 적용
 * 2019.08.01   KSG         OSP Production Lot Size 적용 제거
 * 2019.09.20   KKC         ①Dummy W/O ID 생성 규칙 변경 및 ②전체 W/O의 WORK_ORDER_SEQ 채번 Update 변경
                            ①Dummy W/O ID : W/O ID의 길이가 일정하게 변경
							②W/O의 WORK_ORDER_SEQ : 기본적인 공정그룹 > 확정계획 시작일자 > 설비 > W/O ID 순으로
 * 2019.10.21   KKC         [IT서비스 요청번호:G20191025_000509] [CSR]GSCM 생산라인 우선순위 Logic 적용 요청
                            Line 우선 순위 적용 : Input은 전 사업부 생성 => 엔진 설정으로 소형사업부만 적용함 : Default = '99'
 *                          TH_ENG_OP_RES_GROUP_MAP.ALT_PRIORITY Default 값(99) 셋팅
 * 2019.11.11   KKC         1. Pack Site 중 Cell→Pack BOD확정계획과 Pack 생산확정계획의 WORK_ORDER_GROUP 변경
                            2. 속도 문제로 일괄쿼리를 분리해서 Update하는 로직으로 변경
 * 2019.11.22   KKC         1. Cell Biz Dummy확정계획의 전/후공정 FIXED TERM 조정
                            2. Cell Biz 출하확정계획을 Dummy 후공정으로 변경
 * 2019.11.26   KKC         Cell Biz Dummy확정계획의 시작일자에 선행일자 반영 로직 추가
 * 2019.12.02   KKC         Cell Dummy공정 앞 출하공정으로 Cell Biz 출하확정계획 생성 및 WO SEQ 로직 추가
 * 2020.03.11   KKC         Cell Biz Dummy확정계획의 W/O ID 생성 규칙 보완
 * 2020.03.20   KKC         Cell Biz Dummy 출하 확정계획 순서 변경 보완
 * 2020.03.23   KKC         [소형]TCO Biz 확정계획 순서 변경 보완
 * 2020.04.13   KKC         Cell Biz Dummy W/O ID 생성 규칙 변경 및 Fixed W/O 계획 순서 변경
 * 2021.01.13   KKC         ESS Rack Biz W/O ID 생성 규칙 및 Fixed W/O 계획 순서 변경
 * 2021.01.25   KKC         ESS Project별 SSP FG Shipplan 유지방안
                            - 해당 FCST들의 우선순위를 변경
 * 2021.07.21   KKC         Business Type = ALL Update (엔진신규패치 기능으로 Default값 설정)
                             -> 추후 해당 테이블블 프로시져 Business Type 값 활용시 주석 처리 필요 
 * 2021.09.08   KKC         [PJ20214997] MEB BIZ 추가로 Fixed W/O의 계획 순서 재정의
 * 2021.11.09   KKC         [PJ20214997] RACK/DC item 구분 추가 및 계획 순서 재정리 
 * 2022.01.17   LHS			[PJ20216891] LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2022.02.09   KKC			[PJ20216891] LGES Digital SCM 3 Level 가속화를 위한 개선: PACK 공용 투입 반제품(RACK/DC) 확정계획 순서 조정
 * 2022.04.04   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2022.04.29   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: [TH_ENG_BUCKET_RES_CAPA] 무한CAPA일 경우 TIME_UOM = 'DAY'로 설정 (엔진 패치)
 * 2023.02.08   SHS			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행: Dummy Modeling 생성 로직 제거. FixedPlan, NetDemand 생생로직 변경
 * 2023.02.14   SHS			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행: Dummy Modeling 생성 로직 제거. 수정/보완
 * 2023.03.17   LHS         PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행: Pack Site부분의 work_order_seq 재정의 (ISZ고려)
 * 2023.03.21   KKC         PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행: Dummy Demand 순번 MIX 로직 부여 / 속도튜닝 (ISZ고려)
 * 2023.04.06   KKC         PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행: SPLIT_QTY를 UI에서 보기 때문에, QTY/SPLIT_QTY를 같도록 유지 
 * 2023.04.13   KSG         PJ20230691  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 도전과제 계획
 * 2023.05.31   KKC         PJ20230691  LGES SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 개발 임시(n-ERP 1차 데이터 변경, 7월한시적)
 * 2023.07.07	SHS			PJ20230691  LGES SCM 역량 강화 위한 SCP 개선과제 이행: CELL PRODUCT 기준 CELL DUMMY ITEM 생성, 7월 오픈 기준 임시 모델링 정리
 * 2023.09.05   LHS         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2: 소형CAPA분리 - IM 일부품목만 LPST 강제설정
 * 2023.10.24   KKC         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2: 소형CAPA분리 - 소형 전체 품목 LPST 설정
 * 2024.02.06   KKC         CSR:E20240206-000725 : 자동차 시스템 확산 지원 (81_UC TE Plan시 계획방식 변경 요청(EPST -> LPST 계획수립)
 * 2024.11.07   KKC         PJ20249346  LGES SCP 개선과제 이행 : PET(엔진계획구간의 종료일)이후 FIXED PLAN SPLIT 로직 제거 및 보완
                            -> FN 프로시져처럼, FIXED PLAN SPLIT로직이 없지만, 계획 안정성 차원에서 추가/보완 
 * 2025.04.21   KJJ         E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발         
 */
CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_FIX_MISMATCHING_0725_ORG]  
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)   
    
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

     --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;
    
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_FIX_MISMATCHING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;

    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_cur_wednesday     NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'WED')), 112); -- 당주 수요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
    DECLARE @v_plan_group        NVARCHAR(100) = '-'; -- Plan Group : PJ20230691 도전과제 계획 
	
    --DECLARE @v_wo_dmd_plan_yn    NVARCHAR(1) = 'Y'; -- Dummy W/O Demand Plan로 fix 2023.02.14, SHS
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date (2022.01.17 추가) 

    DECLARE @v_division_group   NVARCHAR(30);   ---(2022.04.04) 추가.
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.attribute4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id  ;  

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	    ---------------------------------------------
        -- PJ20230691 도전과제 계획 추가용 기간 설정 
		---------------------------------------------
		SELECT @v_plan_group = ISNULL(segment5, '-')
		FROM   scm_adm_lookup_master_detail a(nolock)
		WHERE  a.lookup_type = 'PLAN_TYPE'
		AND    a.segment1    = @p_plan_type
		AND    a.valid_yn    = 'Y'
        
/*     (2022.01.17) lookup 반영 전 코드 
        SELECT @v_pet_date = p.horizon_end_date
          FROM dbo.scm_mst_plan p WITH (NOLOCK)
         WHERE p.division_id = @p_division_id 
           AND p.plan_id     = @p_plan_id 
		;
*/ 

        --  Plan End Date  -- PJ20230691 도전과제 계획 추가용 기간 설정
	    SELECT @v_pet_date      = CASE WHEN @v_plan_group = 'BIZ' THEN p.attribute1
                                       ELSE p.horizon_end_date 
                                  END 
			,  @v_add_pet_date  = CASE WHEN @v_plan_group = 'BIZ' 
                                       THEN CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(b.add_day,(13*7)), CONVERT(DATETIME, p.attribute1)), 112)
                                       ELSE CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(b.add_day,(13*7)), CONVERT(DATETIME, p.horizon_end_date)), 112) -- 추가기간이 NULL이면 디폴트 13주 설정 
                                  END	
	  --  SELECT @v_pet_date      = p.horizon_end_date 
			--,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day,(13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112) -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		/** (2022.01.17) 사업부별 추가계획기간 lookup으로 반영  **/ 
		LEFT OUTER JOIN 
			  (
				SELECT a.SEGMENT1 as DIVISION_ID 
                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN 13
                            ELSE a.segment2 
                       END AS ADD_WEEK

                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN (13*7)
                            ELSE (a.segment2 * 7)
                       END AS ADD_DAY
					 --, a.segment2 as ADD_WEEK , A.segment2*7 AS ADD_DAY 
				FROM   scm_adm_lookup_master_detail a(nolock)
				WHERE  a.lookup_type = 'ADD_PLAN_PERIOD'
				and    a.valid_yn    = 'Y' 
			  ) B
				ON ( 1=1
				AND  P.DIVISION_ID  =  B.DIVISION_ID )  
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id 
		; 

        ------------------------------------------------------------------------------------------
        -- 1. 엔진요청 임시실행모음 및 기타
        ------------------------------------------------------------------------------------------
        
        ----------------------------------------------------------
        -- 1-1  ITEM 임시변경
        --      (이부분 추가전에는 PR_SCP_ENG_IN_FN_ALL 존재하였음,  PR_SCP_ENG_IN_FN_PRE_ALL 프로시저에서는 삭제처리해야함)

        --      20181107 수정 (변경item LOOKUP 테이블처리로변경)
                /*
                (참고)  segment1 : UPDATE 대상 item, segment2 : UPDATE 변경 item
		                select * from SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		                where lookup_type = 'MODEL_CHANGE'
		                and valid_yn = 'Y'
                */
        ----------------------------------------------------------		
        UPDATE th_eng_stock_plan_sn
        SET    item_id = b.segment2
        FROM   th_eng_stock_plan_sn a WITH (NOLOCK)
               INNER JOIN (  SELECT segment1  -- UPDATE 대상 item
                                  , segment2  -- UPDATE 변경 item
                             FROM   scm_adm_lookup_master_detail WITH (NOLOCK)
                             WHERE  lookup_type = 'MODEL_CHANGE'
		                     AND    valid_yn = 'Y'
                          ) b
               ON a.item_id = b.segment1
        WHERE  1 = 1
        AND    a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id 
        ;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-0 END'; 
        SET @v_description = N'1-0. STOCK_PLAN의 Item Id update' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ------------------------------------------------------------------------------------------
        -- 2. 공용 모델만 Cell Biz Demand 관련 처리
              -- Cell Biz Demand 의 Late 계획수립 결과와 관련한 모델링 변경 처리에 필요한 후처리( 티라에서 생성한 쿼리 그대로 사용함)
        ------------------------------------------------------------------------------------------
        DECLARE @N_COUNT INTEGER
			  , @N_LOOP  INTEGER = 1;

		IF(OBJECT_ID('tempdb.dbo.#tmp_MODEL_BOM') IS NOT NULL)
		BEGIN
			DROP TABLE #tmp_MODEL_BOM;
        END

		CREATE TABLE #tmp_MODEL_BOM
		   (
			MODEL_ID	   NVARCHAR(50)
		  , SITE_ID		   NVARCHAR(50)
		  , ROUTE_ID	   NVARCHAR(50)
		  , PARENT_ITEM_ID NVARCHAR(50)
		  , CHILD_ITEM_ID  NVARCHAR(50)
		  , ITEM_TYPE	   NVARCHAR(10)
		  , SORT		   NVARCHAR(500)
		  , BOM_LEVEL      INTEGER
		    )
		;

		-- STEP 0-1. #tmp_MODEL_BOM INSERT
		INSERT INTO #tmp_MODEL_BOM
			 (
			   MODEL_ID
			 , SITE_ID
			 , ROUTE_ID
			 , PARENT_ITEM_ID
			 , CHILD_ITEM_ID
			 , ITEM_TYPE
			 , SORT
			 , BOM_LEVEL
			)
		SELECT DISTINCT
			   A.PARENT_ITEM_ID	AS MODEL_ID
			 , A.SITE_ID
			 , A.ROUTE_ID
			 , A.PARENT_ITEM_ID	
			 , A.CHILD_ITEM_ID	
			 , B.ITEM_TYPE
			 , A.PARENT_ITEM_ID + ' > ' + A.CHILD_ITEM_ID	AS SORT
			 , 1				AS BOM_LEVEL
		  FROM TH_ENG_PLAN_BOM_SN A WITH(NOLOCK)
		 INNER MERGE JOIN TH_ENG_ITEM_SN B WITH(NOLOCK)
			ON A.MASTER_ID = B.MASTER_ID 
		   AND A.PLAN_ID   = B.PLAN_ID 
		   AND A.CHILD_ITEM_ID = B.ITEM_ID
		 WHERE 1=1
		   AND A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID = @p_engine_plan_id
		   AND A.PARENT_ITEM_ID IN	(
            						SELECT DISTINCT X.ITEM
            						  FROM TH_ENG_NET_DEMAND_SN X WITH(NOLOCK)
            						 WHERE 1=1
            						   AND X.MASTER_ID = @p_master_id
            						   AND X.PLAN_ID = @p_engine_plan_id
									)
        ;

		SET @N_COUNT = @@ROWCOUNT;

		WHILE 1=1
		BEGIN

			INSERT INTO #tmp_MODEL_BOM
				 (
				   MODEL_ID
				 , SITE_ID
				 , ROUTE_ID
				 , PARENT_ITEM_ID
				 , CHILD_ITEM_ID
				 , ITEM_TYPE
				 , SORT
				 , BOM_LEVEL
 				)
			SELECT DISTINCT
				   A.MODEL_ID
				 , C.SITE_ID
				 , C.ROUTE_ID
				 , A.CHILD_ITEM_ID PARENT_ITEM_ID	
				 , C.CHILD_ITEM_ID	
				 , B.ITEM_TYPE
				 , A.SORT + ' > ' + C.CHILD_ITEM_ID	AS SORT
				 , A.BOM_LEVEL + 1			        AS BOM_LEVEL
			  FROM #tmp_MODEL_BOM A WITH(NOLOCK)
			 INNER JOIN TH_ENG_PLAN_BOM_SN C WITH(NOLOCK)
				ON C.MASTER_ID = @p_master_id 
			   AND C.PLAN_ID   = @p_engine_plan_id 
			   AND C.PARENT_ITEM_ID = A.CHILD_ITEM_ID
			 INNER MERGE JOIN TH_ENG_ITEM_SN B WITH(NOLOCK)
				ON C.MASTER_ID = B.MASTER_ID 
			   AND C.PLAN_ID   = B.PLAN_ID 
			   AND C.CHILD_ITEM_ID = B.ITEM_ID
			 WHERE 1=1
			 AND A.BOM_LEVEL = @N_LOOP
			;
		
			IF @@ROWCOUNT > 0
				SET @N_LOOP = @N_LOOP + 1;
			ELSE 
				SET @N_LOOP = 0;

			IF @N_LOOP = 0
				BREAK;

		END


		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-0 END'; 
        SET @v_description = N'2-0. 엔진 모델별 BOM Tree 생성(#tmp_MODEL_BOM) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- STEP 0-2. #COMMON_CELL_ITEM INSERT
		IF(OBJECT_ID('tempdb.dbo.#CELL_ITEM') IS NOT NULL)
        BEGIN
			DROP TABLE #CELL_ITEM;
		END

        SELECT X.*
          INTO #CELL_ITEM 
          FROM
		      (
			  -- TCO CELL ITEM
			  SELECT A.MASTER_ID, A.PLAN_ID, 'TCO' AS CELL_TYPE, B.PARENT_ITEM_ID AS CELL_ITEM_ID, A.ITEM_ID AS PACKAGE_CELL_ITEM_ID   
			   FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)     
			   INNER JOIN TH_ENG_PLAN_BOM_SN B WITH(NOLOCK)   
				 ON A.MASTER_ID = B.MASTER_ID 
			    AND A.PLAN_ID   = B.PLAN_ID 
				AND A.ITEM_ID   = B.CHILD_ITEM_ID   
			  WHERE 1=1     
				AND A.MASTER_ID = @p_master_id      
				AND A.PLAN_ID   = @p_engine_plan_id     
				AND 'A' = SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1)     
				AND ( A.ROUTE_ID IN ('A3000','A9000')  OR  A.ROUTE_ID LIKE 'F%' )
				AND 'A' = SUBSTRING(B.SITE_ID,CHARINDEX('-',B.SITE_ID,1)+1,1)  --//2023.07.07, equal 조건 으로 변경
				--2023.07.07 CELL PRODUCT 기준으로 CELL ITEM 생성, By SHS
				AND EXISTS (SELECT 'X' 
		    				  FROM SCP_MST_CELL_PROD_ASSY_MAP X WITH(NOLOCK) 
		    				 WHERE X.ITEM_ID_PROD = B.PARENT_ITEM_ID
		    				   AND CHARINDEX(X.PLANT_ID, B.SITE_ID ) > 0
                               AND X.VALID_YN = 'Y'
		    			   )
			  UNION
			 -- CELL PRODUCT ITEM 기준으로 변경, 2023.07.07
			 SELECT DISTINCT A.MASTER_ID, A.PLAN_ID, 'PACKAGE' AS CELL_TYPE, A.ITEM_ID AS CELL_ITEM_ID, A.ITEM_ID AS PACKAGE_CELL_ITEM_ID     
			   FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK) 
			  WHERE 1=1     
				AND A.MASTER_ID = @p_master_id     
				AND A.PLAN_ID =   @p_engine_plan_id    
				AND 'A' = SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1)     
				AND A.ROUTE_ID IN ('A3000','A9000')  
				--2023.07.07 CELL PRODUCT 기준으로 CELL ITEM 생성, By SHS
				AND EXISTS (SELECT 'X' 
		    				  FROM SCP_MST_CELL_PROD_ASSY_MAP X WITH(NOLOCK) 
		    				 WHERE X.ITEM_ID_PROD = A.ITEM_ID
		    				   AND CHARINDEX(X.PLANT_ID, A.SITE_ID ) > 0
                               AND X.VALID_YN = 'Y'
		    			   )
			 ) X
        ;

        IF(OBJECT_ID('tempdb.dbo.#CELL_BIZ_DEMAND') IS NOT NULL)
        BEGIN
			DROP TABLE #CELL_BIZ_DEMAND;
		END

        SELECT DISTINCT A.*
		     , B.PACKAGE_CELL_ITEM_ID 
          INTO #CELL_BIZ_DEMAND  
          FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)     
         INNER JOIN #CELL_ITEM B WITH(NOLOCK)   
            ON A.MASTER_ID = B.MASTER_ID 
		   AND A.PLAN_ID   = B.PLAN_ID 
		   AND A.ITEM = B.CELL_ITEM_ID			
         /* 속도 개선, 조건절 추가, 2023.03.21 */
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		;  


        IF(OBJECT_ID('tempdb.dbo.#PACK_ITEM') IS NOT NULL)
		BEGIN
			DROP TABLE #PACK_ITEM;
		END
     
		 --2023.07.07	SHS. 최종 TO-BE에서는 CELL PRODUCT를 참조하도록 로직 변경 필요
        SELECT DISTINCT 
		       A.MASTER_ID
		     , A.PLAN_ID
			 , A.ITEM_ID        AS PACK_ITEM_ID
			 , B.PARENT_ITEM_ID AS PACKAGE_CELL_ITEM_ID 
          INTO #PACK_ITEM   
          FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
         INNER JOIN #tmp_MODEL_BOM B WITH(NOLOCK)   
            ON A.ITEM_ID = B.MODEL_ID 
		   AND B.ROUTE_ID IN ('A3000','A9000')
         WHERE 1=1     
           AND A.MASTER_ID = @p_master_id     
           AND A.PLAN_ID   = @p_engine_plan_id    
           AND 'P' = SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1) 
	       --2023.07.07 CELL PRODUCT 기준으로 CELL ITEM 생성, By SHS
	       AND EXISTS (SELECT 'X' 
		   			     FROM SCP_MST_CELL_PROD_ASSY_MAP X WITH(NOLOCK) 
		   			    WHERE X.ITEM_ID_PROD = B.PARENT_ITEM_ID
					      AND CHARINDEX(X.PLANT_ID, B.SITE_ID ) > 0
                          AND X.VALID_YN = 'Y'
		   		       )
		;
   
        IF(OBJECT_ID('tempdb.dbo.#PACK_BIZ_DEMAND') IS NOT NULL)
        BEGIN
			DROP TABLE #PACK_BIZ_DEMAND;  
		END
    
         SELECT DISTINCT A.*
		      , B.PACKAGE_CELL_ITEM_ID   
           INTO #PACK_BIZ_DEMAND 
           FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)     
          INNER JOIN #PACK_ITEM B WITH(NOLOCK)   
             ON A.MASTER_ID = B.MASTER_ID 
			AND A.PLAN_ID   = B.PLAN_ID 
			AND A.ITEM = B.PACK_ITEM_ID  
          /* 속도 개선, 조건절 추가, 2023.03.21 */
		  WHERE A.MASTER_ID = @p_master_id
			AND A.PLAN_ID   = @p_engine_plan_id
		;

        IF(OBJECT_ID('tempdb.dbo.#COMMON_CELL_ITEM') IS NOT NULL)
		BEGIN
			DROP TABLE #COMMON_CELL_ITEM;
		END

		--CELL ITEM 기준으로 중복되지 않도록 방지코드 추가,2023.05.31
		SELECT *
		 INTO #COMMON_CELL_ITEM
		 FROM
			(
			SELECT PACKAGE_CELL_ITEM_ID AS PACKAGE_CELL_ITEM_ID
				 , ITEM                 AS CELL_ITEM_ID
				 , ROW_NUMBER() OVER(PARTITION BY ITEM 
										 ORDER BY PACKAGE_CELL_ITEM_ID
									) SEQ
			FROM #CELL_BIZ_DEMAND A(NOLOCK)   
			WHERE 1=1   
			AND EXISTS (   
						SELECT 1
							FROM #PACK_BIZ_DEMAND W(NOLOCK)
							WHERE 1=1
							AND EXISTS (
										SELECT 1
										FROM TH_ENG_FIXED_PLAN_SN X WITH(NOLOCK)
										/* 속도 개선, 조건절 변경, 2023.03.21 */
										WHERE X.MASTER_ID   = @p_master_id
											AND X.PLAN_ID   = @p_engine_plan_id
											AND LEFT(X.WORK_ORDER_ID,4) = 'WO::'   --생산FIX인 경우/WORK_ORDER_ID 생성규칙이 변경되면, 변경 필요
											AND X.ITEM_ID = W.ITEM
										)
							AND W.PACKAGE_CELL_ITEM_ID = A.PACKAGE_CELL_ITEM_ID    --활성화 코드분리 기준으로는 최종적으로 CELL PRODUCT 기준으로 되어 데이터 안정성을 확보할듯, 2023.05.31
						)
			) A
		WHERE A.SEQ = 1
		;

        --//임시테이블 정리
        IF(OBJECT_ID('tempdb.dbo.#CELL_ITEM') IS NOT NULL)
        BEGIN 
			DROP TABLE #CELL_ITEM;
        END

        IF(OBJECT_ID('tempdb.dbo.#CELL_BIZ_DEMAND') IS NOT NULL)
        BEGIN 
			DROP TABLE #CELL_BIZ_DEMAND;
        END

        IF(OBJECT_ID('tempdb.dbo.#PACK_ITEM') IS NOT NULL)
        BEGIN 
			DROP TABLE #PACK_ITEM;
        END

        IF(OBJECT_ID('tempdb.dbo.#PACK_BIZ_DEMAND') IS NOT NULL)
        BEGIN 
			DROP TABLE #PACK_BIZ_DEMAND;
        END

		-- STEP 0-3. #COMMON_CELL_DEMAND INSERT
        IF(OBJECT_ID('tempdb.dbo.#COMMON_CELL_DEMAND') IS NOT NULL)
        BEGIN 
             DROP TABLE #COMMON_CELL_DEMAND;
        END
        
        SELECT *
          INTO #COMMON_CELL_DEMAND
        FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
        INNER JOIN #COMMON_CELL_ITEM B
           ON  A.ITEM = B.CELL_ITEM_ID
        WHERE 1=1
        AND A.MASTER_ID = @p_master_id  
        AND A.PLAN_ID   = @p_engine_plan_id  
        ;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-0 END'; 
        SET @v_description = N'3-0. 공용 Cell Biz Demand 생성(#COMMON_CELL_DEMAND) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		/* TMP_CELL_DEMAND 작업을 위한 Local 변수 선언 */
        DECLARE @V_DEMAND_ID VARCHAR(150);
        DECLARE @V_DUE_DATE DATETIME;
        DECLARE @V_SITE_ID VARCHAR(50);
        DECLARE @V_ITEM_ID VARCHAR(50);
        DECLARE @V_QTY NUMERIC(30,10);
        DECLARE @V_MAX_DEMAND_QTY NUMERIC(30,10);
        DECLARE @V_SUM_DEMAND_QTY NUMERIC(30,10);
        DECLARE @V_DEMAND_PRIORITY VARCHAR(200);    --//DEMAND PRIORITY 추가, 2020/03/11, By KKC

		IF(OBJECT_ID('tempdb.dbo.#TMP_CELL_DEMAND') IS NOT NULL)
		BEGIN
			DROP TABLE #TMP_CELL_DEMAND;
        END

        --//DEMAND_PRIORITY 추가, 2020/03/11, By KKC
        CREATE TABLE #TMP_CELL_DEMAND(
		    DEMAND_ID	        NVARCHAR(100) NOT NULL,
		    DUE_DATE	        DATETIME NOT NULL,
		    SITE_ID		        NVARCHAR(50) NOT NULL,
		    ITEM_ID		        NVARCHAR(50) NOT NULL,
		    QTY			        NUMERIC(30,10),
			DEMAND_PRIORITY     NVARCHAR(200),
			/* 컬럼 추가, 2023.03.21 */
			SEQ_UPDATE_YN       NVARCHAR(1),  
		    ITEM_ACC_QTY        NUMERIC(30,10),
		    PARENT_ITEM_ID      NVARCHAR(50),
		    PARENT_TOT_NEED_QTY NUMERIC(30,10)
        );


        DECLARE curDEMAND CURSOR LOCAL
        FOR
		SELECT A.DEMAND_ID
			, A.DUE_DATE
				    AS DUE_DATE
		    /* 선행일자 고려 로직 추가, 2019/11/26, KKC */
			--DATEADD(DAY, -(ISNULL(A.EARLY_PRODUCING_TERM,0)+1), A.DUE_DATE) AS DUE_DATE
			, A.SITE AS SITE_ID
			, A.ITEM AS ITEM_ID
			, A.QTY
			, B.MAX_DEMAND_QTY
			, A.PRIORITY --//DEMAND PRIORITY 추가, 2020/03/11, By KKC
        FROM #COMMON_CELL_DEMAND A
		    INNER JOIN (
				--FIXED TERM 구간내의 물량만 생성, 주석추가, 2023.03.14 
			    SELECT SUM(X.QTY) AS MAX_DEMAND_QTY
			        FROM #COMMON_CELL_DEMAND X WITH(NOLOCK)
					INNER JOIN (
						SELECT A.PLAN_START_DTTM AS FROM_DATE, DATEADD(DAY,MAX(B.FIXED_TERM),A.PLAN_START_DTTM) AS TO_DATE
						FROM TH_ENG_PLAN_INFO_SN A WITH(NOLOCK)
						INNER JOIN TH_ENG_RESOURCE_SN B WITH(NOLOCK)
							ON A.MASTER_ID = B.MASTER_ID 
							AND A.PLAN_ID = B.PLAN_ID
						WHERE 1=1
							AND A.MASTER_ID = @p_master_id
							AND A.PLAN_ID = @p_engine_plan_id
						    AND 'A' = SUBSTRING(B.SITE_ID,CHARINDEX('-',B.SITE_ID,1)+1,1)
						GROUP 
						    BY A.PLAN_START_DTTM
					) Y
				    ON 1=1
			    WHERE 1=1
			        AND CONVERT(CHAR(8),X.DUE_DATE,112) BETWEEN CONVERT(CHAR(8),Y.FROM_DATE,112) AND CONVERT(CHAR(8),Y.TO_DATE,112)
			    ) B
			    ON 1=1
        WHERE 1=1
        ORDER BY PRIORITY
        ;
        
		--//Cursor Start
        BEGIN

	        SET NOCOUNT ON;
        
			--//Ttran Start
			BEGIN TRAN

				SET @V_DEMAND_ID = NULL;
				SET @V_DUE_DATE = NULL;
				SET @V_SITE_ID = NULL;
				SET @V_ITEM_ID = NULL;
				SET @V_QTY = NULL;
				SET @V_MAX_DEMAND_QTY = NULL;
				SET @V_SUM_DEMAND_QTY = 0;
				SET @V_DEMAND_PRIORITY = NULL;  --//DEMAND_PRIORITY 추가, 2020/03/11, By KKC

				OPEN curDEMAND

				--//DEMAND_PRIORITY 추가, 2020/03/11, By KKC 
				FETCH NEXT FROM curDEMAND 
				 INTO @V_DEMAND_ID, @V_DUE_DATE, @V_SITE_ID, @V_ITEM_ID, @V_QTY, @V_MAX_DEMAND_QTY, @V_DEMAND_PRIORITY
	
				WHILE @@FETCH_STATUS = 0
				BEGIN

					SET @V_SUM_DEMAND_QTY = @V_SUM_DEMAND_QTY + @V_QTY;

					IF @V_SUM_DEMAND_QTY <= @V_MAX_DEMAND_QTY
						BEGIN

						--PRINT 'DEMAND_ID: ' + @V_DEMAND_ID + ', ITEM: ' + @V_ITEM_ID + ', START_DATE: ' + CONVERT(CHAR(8),@V_START_DATE,112) + ', BOH_QTY: ' + CONVERT(VARCHAR,@V_BOH_QTY) + ', IN_QTY: ' + CONVERT(VARCHAR,@V_IN_QTY) + ', OUT_QTY: ' + CONVERT(VARCHAR,@V_OUT_QTY) + ', EOH_QTY: ' + CONVERT(VARCHAR,@V_EOH_QTY);
						--//DEMAND_PRIORITY 추가, 2020/03/11, By KKC  
						INSERT INTO #TMP_CELL_DEMAND 
							   (DEMAND_ID
							  , DUE_DATE
							  , SITE_ID
							  , ITEM_ID
							  , QTY
							  , DEMAND_PRIORITY
							  , SEQ_UPDATE_YN     --CELL DUMMY DEMAND관련 SEQ UPDATE 여부 추가, 2023.03.21
							  )
						VALUES(@V_DEMAND_ID
							 , @V_DUE_DATE
							 , @V_SITE_ID
							 , @V_ITEM_ID
							 , @V_QTY
							 , @V_DEMAND_PRIORITY
							 , 'N'                --CELL DUMMY DEMAND관련 SEQ UPDATE 여부 추가, 2023.03.21
						);

						END
					--//DEMAND_PRIORITY 추가, 2020/03/11, By KKC 
					FETCH NEXT FROM curDEMAND 
					 INTO @V_DEMAND_ID, @V_DUE_DATE, @V_SITE_ID, @V_ITEM_ID, @V_QTY, @V_MAX_DEMAND_QTY, @V_DEMAND_PRIORITY
				END

				CLOSE curDEMAND

				DEALLOCATE curDEMAND

		   COMMIT; --//Tran End

	       SET NOCOUNT OFF;
        
		END --//Cursor End

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-0 END'; 
        SET @v_description = N'4-0. Dummy 대상 최종 Cell Biz Demand 생성(#TMP_CELL_DEMAND) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/***************************************************************************** 
		 1. PACK 반제품/완제품 FIX 물량 가르기, 2023.03.21 추가
		 *****************************************************************************/
		UPDATE A 
		   SET A.SEQ_UPDATE_YN         = 'Y'
		     , A.ITEM_ACC_QTY          = B.ITEM_ACC_QTY
			 , A.PARENT_ITEM_ID        = B.PARENT_ITEM_ID
			 , A.PARENT_TOT_NEED_QTY   = B.PARENT_TOT_NEED_QTY
		  FROM #TMP_CELL_DEMAND A
		 JOIN (
			SELECT A.DEMAND_ID
				 , A.DUE_DATE
				 , A.SITE_ID
				 , A.ITEM_ID
				 , A.QTY
				 , A.DEMAND_PRIORITY
				   /* 모듈 FIX 수량만큼은 모듈 FIX와 경쟁 / 그외는 PACK FIX와 경쟁 */
				 , CASE WHEN (SUM(A.QTY) OVER(PARTITION BY A.ITEM_ID 
												  ORDER BY A.DEMAND_PRIORITY, A.DEMAND_ID)- A.QTY
							  ) < B.ITEM_TOT_CELL_NEED_QTY THEN 'Y'
						ELSE 'N'
					END                                                                             AS SEQ_UPDATE_YN
				 , SUM(A.QTY) OVER(PARTITION BY A.ITEM_ID ORDER BY A.DEMAND_PRIORITY, A.DEMAND_ID)  AS ITEM_ACC_QTY
				 , B.PARENT_ITEM_ID                                                                 AS PARENT_ITEM_ID 
				 , B.ITEM_TOT_CELL_NEED_QTY                                                         AS PARENT_TOT_NEED_QTY 
			  FROM #TMP_CELL_DEMAND   A WITH(NOLOCK)
			  JOIN (
					SELECT B.CHILD_ITEM_ID
						 , MAX(A.ITEM_ID)   AS PARENT_ITEM_ID 
						 , CEILING(SUM((A.OPERATION_QTY * B.CHILD_ITEM_RATE))) AS ITEM_TOT_CELL_NEED_QTY
					  FROM TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
					  JOIN TH_ENG_PLAN_BOM_SN B WITH(NOLOCK)   --공용 CELL 반제품에 한해서
						ON A.MASTER_ID = B.MASTER_ID
					   AND A.PLAN_ID   = B.PLAN_ID
					   AND A.SITE_ID   = B.SITE_ID
					   AND A.ITEM_ID   = B.PARENT_ITEM_ID
					 WHERE A.MASTER_ID = @p_master_id
					   AND A.PLAN_ID   = @p_engine_plan_id
					   --AND A.ITEM_ID   = 'AMDMO0001A'
					   AND A.ROUTE_ID IN ('P5000', 'P5200') --P5000/P5200 모듈 FIX PLAN에 한해서
					 GROUP 
						BY B.CHILD_ITEM_ID
				   ) B
			   ON A.ITEM_ID = B.CHILD_ITEM_ID 
			WHERE 1=1 --A.ITEM_ID = 'MCCM348018A2'
			--ORDER BY A.DEMAND_PRIORITY, A.DEMAND_ID
			) B
		   ON A.DEMAND_ID = B.DEMAND_ID
		WHERE B.SEQ_UPDATE_YN = 'Y'
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-1 END'; 
        SET @v_description = N'5-1. Dummy Cell Biz Demand별 배분(모듈FIX/PACKFIX) 기준 Update(#TMP_CELL_DEMAND) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/***************************************************************************** 
		 2. 배분된 물량 중 잔량 SPLIT DEMAND 만들기, 2023.03.21 추가
		 2-1. #TMP_CELL_SPLIT_DEMAND 생성
		 *****************************************************************************/
		--SPLIT DEMAND 생성(#TMP_CELL_SPLIT_DEMAND)
       IF(OBJECT_ID('tempdb.dbo.#TMP_CELL_SPLIT_DEMAND') IS NOT NULL)
        BEGIN 
             DROP TABLE #TMP_CELL_SPLIT_DEMAND;
        END
 
		SELECT A.ORG_DEMAND_ID
			 , A.DEMAND_PRIORITY
			 , A.DUE_DATE
			 , A.ITEM_ID
			 , A.SITE_ID
			 , A.ORG_QTY
			 , A.ITEM_ACC_QTY
			 , A.PARENT_ITEM_ID
			 , A.PARENT_TOT_NEED_QTY
			 , A.REMAIN_QTY
			 , A.NEW_SEQ_UPDATE_YN
			 , A.NEW_DEMAND_ID
			 , A.NEW_SPLIT_QTY
		  INTO #TMP_CELL_SPLIT_DEMAND  
		  FROM
			(
			SELECT A.DEMAND_ID                               AS ORG_DEMAND_ID
				 , A.DEMAND_PRIORITY                         AS DEMAND_PRIORITY
				 , A.DUE_DATE                                AS DUE_DATE
				 , A.ITEM_ID                                 AS ITEM_ID
				 , A.SITE_ID                                 AS SITE_ID
				 , A.QTY                                     AS ORG_QTY 
				 , A.ITEM_ACC_QTY
				 , A.PARENT_ITEM_ID
				 , A.PARENT_TOT_NEED_QTY
				 , A.ITEM_ACC_QTY - A.PARENT_TOT_NEED_QTY    AS REMAIN_QTY
				  , CASE WHEN B.SEQ = 1 THEN 'Y'
						 ELSE 'N' 
					 END                                     AS NEW_SEQ_UPDATE_YN
				  , CASE WHEN B.SEQ = 1 THEN A.DEMAND_ID
						 ELSE A.DEMAND_ID+'^F_1' 
					 END                                     AS NEW_DEMAND_ID
				 , CASE WHEN B.SEQ = 1 THEN A.QTY - (A.ITEM_ACC_QTY - A.PARENT_TOT_NEED_QTY)
						ELSE (A.ITEM_ACC_QTY - A.PARENT_TOT_NEED_QTY)
					END                                      AS NEW_SPLIT_QTY
				  , SUM(CASE WHEN B.SEQ = 1 THEN A.QTY - (A.ITEM_ACC_QTY - A.PARENT_TOT_NEED_QTY)
							 ELSE (A.ITEM_ACC_QTY - A.PARENT_TOT_NEED_QTY)
						 END) OVER(PARTITION BY A.DEMAND_ID) AS ORG_DEMAND_SUM_QTY
			  FROM #TMP_CELL_DEMAND A WITH(NOLOCK) 
			  JOIN (
					SELECT 1 SEQ
					UNION ALL
					SELECT 2 SEQ
				   ) B
				ON 1=1
			 WHERE 1=1
			 --AND A.ITEM_ID = 'MCCM348018A2'
			   AND A.SEQ_UPDATE_YN = 'Y'
			   AND A.PARENT_TOT_NEED_QTY < A.ITEM_ACC_QTY
			 ) A
		/* 계산된 수량이 같은때만 */
		WHERE A.ORG_QTY = A.ORG_DEMAND_SUM_QTY
		--ORDER 
		--   BY A.DEMAND_PRIORITY
		;


		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-2 END'; 
        SET @v_description = N'5-2. Dummy Cell Biz Demand별 배분(모듈FIX/PACKFIX) 데이터 생성(#TMP_CELL_SPLIT_DEMAND) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/***************************************************************************** 
		 2-2. SPLIT DEMAND 수량 기준으로 원 데이터 수량 갱신 및 잔량 등록
		 *****************************************************************************/
		--1) SPLIT 수량 UPDATE (원 DEMAND ID 수량 변경)
		UPDATE A
		   SET A.QTY       = B.NEW_SPLIT_QTY
		     , A.SPLIT_QTY = B.NEW_SPLIT_QTY   --2023.04.06 추가
		  FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
		  JOIN #TMP_CELL_SPLIT_DEMAND B WITH(NOLOCK)
		    ON A.DEMAND_ID  = B.ORG_DEMAND_ID
		   AND B.ORG_DEMAND_ID = B.NEW_DEMAND_ID
		 WHERE A.MASTER_ID  = @p_master_id
		   AND A.PLAN_ID    = @p_engine_plan_id
         ;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-3 END'; 
        SET @v_description = N'5-3. 배분(모듈FIX) 기준 Split Qty Update(TH_ENG_NET_DEMAND_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--2)잔량 수량 INSERT (원 DEMAND ID의 SPLIT 수량 추가)
		INSERT INTO TH_ENG_NET_DEMAND_SN
			(  MASTER_ID
			 , PLAN_ID
			 , DEMAND_ID
			 , SALES_MODEL_ID
			 , SHIPPING_DATE
			 , DUE_DATE
			 , DUE_FENCE_DATE
			 , EARLY_PRODUCING_TERM
			 , EARLY_PRODUCING_TERM_UOM
			 , QTY
			 , SPLIT_QTY
			 , ORDER_TYPE
			 , DEMAND_TYPE
			 , PRODUCING_TYPE
			 , PRIORITY_GROUP_CODE
			 , PRIORITY
			 , ATTRIBUTE_CHECKER_ID
			 , DEMAND_GROUP_ID
			 , LATE_TYPE
			 , DESCR
			 , MOVE_TIME_RATE
			 , BUFFER_TIME_RATE
			 , IS_EXCEPTION
			 , IS_CONSUME
			 , ITEM
			 , SITE
			 , SCM_SITE
			 , DEMAND_PRIORITY     
			 , COMPLETED_SHIPPING_ID
			 , PROJECT_CODE 
			 , BUSINESS_TYPE
			 , ATTR05             --원수량 백업, 2023.04.06 추가 
			 , PLANT_TYPE     -- 2025.04.21 추가
			 )
		SELECT A.MASTER_ID
             , A.PLAN_ID
             , B.NEW_DEMAND_ID
             , A.SALES_MODEL_ID
             , A.SHIPPING_DATE
             , A.DUE_DATE
             , A.DUE_FENCE_DATE
             , A.EARLY_PRODUCING_TERM
             , A.EARLY_PRODUCING_TERM_UOM
             , B.NEW_SPLIT_QTY    --QTY/SPLIT_QTY 동기화, 2023.04.06 변경
             , B.NEW_SPLIT_QTY    --QTY/SPLIT_QTY 동기화, 2023.04.06 변경
             , A.ORDER_TYPE
             , A.DEMAND_TYPE
             , A.PRODUCING_TYPE
             , A.PRIORITY_GROUP_CODE
             , A.PRIORITY
             , A.ATTRIBUTE_CHECKER_ID
             , A.DEMAND_GROUP_ID
             , A.LATE_TYPE
             , A.DESCR
             , A.MOVE_TIME_RATE
             , A.BUFFER_TIME_RATE
             , A.IS_EXCEPTION
             , A.IS_CONSUME
             , A.ITEM
             , A.SITE
             , A.SCM_SITE
             , A.DEMAND_PRIORITY     
		     , A.COMPLETED_SHIPPING_ID
             , A.PROJECT_CODE 
		     , A.BUSINESS_TYPE
             , A.ATTR05
			 , A.PLANT_TYPE     -- 2025.04.21 추가
		  FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
		  JOIN #TMP_CELL_SPLIT_DEMAND B WITH(NOLOCK)
		    ON A.DEMAND_ID = B.ORG_DEMAND_ID
		   AND B.ORG_DEMAND_ID <> B.NEW_DEMAND_ID
		 WHERE A.MASTER_ID  = @p_master_id
		   AND A.PLAN_ID    = @p_engine_plan_id
        ;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-4 END'; 
        SET @v_description = N'5-4. 배분(PackFIX) 기준 Split Qty Insert(TH_ENG_NET_DEMAND_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		BEGIN
			/*	2023.02.08 SHS
				DummyModeling  제거로 Site, Route , Operaion 대표값 코드 설정
				* FixedPlan 의 WorkOrderId 를 Demand Id로 설정 시 나머지 정보는 사용하지 않음.
				  기존 FixedPlan Loading 로직 상 DummyModeling 만들지 않으면 기준정보 데이터 누락으로 확정계획 로딩시 ProblemData 처리함.
				  하여 나머지 정보는 출하 Site 기준 Priority 1순위 대표값 설정하여 로딩 가능하게 변경함.

				  RouteId 는 Dummy 로 활용함. dummy modeling 을 제거하여 route를 대표값 설정시 출하 Site기준 WorkOrderSeq 를 채번하여, 기존과 다른 work 할당 순번을 가져가게됨. 
				  계획수립순서는 동일하게 가져가기 위해 Dummy 인 경우 구분함.
				2023.03.21 수정 : PACK 반제품/완제품 FIX 존재시, SPLIT 수량 추가 고려
			*/
			INSERT INTO [dbo].[TH_ENG_FIXED_PLAN_SN]
						([MASTER_ID]
						,[PLAN_ID]
						,[WORK_ORDER_ID]
						,[WORK_ORDER_SEQ]
						,[SITE_ID]
						,[ROUTE_ID]
						,[OPERATION_ID]
						,[ITEM_ID]
						,[RESOURCE_ID]
						,[SUB_RESOURCE_ID]
						,[START_DTTM]
						,[END_DTTM]
						,[OPERATION_QTY]
						,[COMPLETE_QTY]
						,[LOT_ID]
						,[IS_FIXED]
						,[IS_PREV_SCHEDULE]
						,[KEEP_WORK_TIME_TYPE]
						,[KEEP_QTY_TYPE]
						,[SALES_MODEL_ID]
						,[ATTRIBUTE_SET_ID]
						,[DEMAND_ID]
						,[DESCR]
						,[IS_NOH_CONSUME])
				   SELECT @p_master_id		      AS MASTER_ID
						, @p_engine_plan_id	      AS PLAN_ID
						/* 2023.03.21 수정 : SPLIT DEMAND 추가 */								   
						, ISNULL(B.NEW_DEMAND_ID, A.DEMAND_ID) 
												  AS WORK_ORDER_ID
						--,'51000' 			  AS WORK_ORDER_SEQ
						/* 2023.03.21 수정*/						
						, CASE WHEN ISNULL(B.NEW_SEQ_UPDATE_YN, A.SEQ_UPDATE_YN) = 'Y' THEN '50000'
		 					   ELSE '51000'
		 				   END                    AS  WORK_ORDER_SEQ
						, A.SITE_ID			      AS SITE_ID
						-- 2023.02.08 SHS ROUTE ID 는 DUMMY 로 유지함. 아래 WokrOrderSequence 채번시 기존 로직유지
						, C.BOD_ID				  AS ROUTE_ID
						, C.BOD_ID				  AS OPERATION_ID
						, A.ITEM_ID			      AS ITEM_ID
						, C.BOD_ID				  AS RESOURCE_ID
						, NULL					  AS SUB_RESOURCE_ID		              
						, CONVERT(DATETIME,CONVERT(CHAR(8),A.DUE_DATE,112))	
		  										  AS START_DTTM
						, DATEADD(dd, 0, CONVERT(DATETIME, @v_add_pet_date))  -- 2024.11.07 수정
--						, DATEADD(dd, 1, CONVERT(DATETIME, @v_add_pet_date))  -- 2022.01.17 @v_pet_date를 @v_add_pet_date로 변경
		  										  AS END_DTTM
						, ISNULL(B.NEW_SPLIT_QTY, A.QTY)
												  AS OPERATION_QTY
						, ISNULL(B.NEW_SPLIT_QTY, A.QTY)		
												  AS COMPLETE_QTY
						--//DEMAND_PRIORITY 추가, 2020/03/11, By KKC 
   						, 'DM::DUMMY::' + CONVERT(VARCHAR, 90000000 + DENSE_RANK() OVER(ORDER BY A.DUE_DATE, A.DEMAND_PRIORITY, ISNULL(B.NEW_DEMAND_ID, A.DEMAND_ID))) 
		  										  AS LOT_ID
						, 'N'				      AS IS_FIXED
						, 'Y'				      AS IS_PREV_SCHEDULE		              
						, 'END_FENCE_FIX'         AS KEEP_WORK_TIME_TYPE --20181026 티라요청으로 수정 (변경전 : ,'START_FIX' AS KEEP_WORK_TIME_TYPE )
						, 'ALL_QTY_FIX'	          AS KEEP_QTY_TYPE
						, A.ITEM_ID		          AS SALES_MODEL_ID
						, NULL				      AS ATTRIBUTE_SET_ID
						, NULL				      AS DEMAND_ID
						--//DEMAND_PRIORITY 추가, 2020/03/11, By KKC 
   						, 'DM::DUMMY::' + CONVERT(VARCHAR, 90000000 + DENSE_RANK() OVER(ORDER BY A.DUE_DATE, A.DEMAND_PRIORITY, ISNULL(B.NEW_DEMAND_ID, A.DEMAND_ID))) 
		  									      AS DESCR
						, 'Y'                     AS IS_NOH_CONSUME
				FROM #TMP_CELL_DEMAND A
				LEFT OUTER HASH JOIN #TMP_CELL_SPLIT_DEMAND B
				  ON A.DEMAND_ID = B.ORG_DEMAND_ID
				INNER JOIN ( -- 2023.02.14 SHS
							SELECT A.BOD_ID, A.TO_SITE_ID, A.ITEM_ID
				 			FROM (
								SELECT A.BOD_ID, A.TO_SITE_ID, B.ITEM_ID, 
										ROW_NUMBER() OVER (PARTITION BY B.ITEM_ID, A.TO_SITE_ID ORDER BY B.ALT_PRIORITY, B.BOD_ID) AS PRIORITY
									FROM TH_ENG_BOD_SN A WITH(NOLOCK)
									JOIN  TH_ENG_ITEM_BOD_SN B WITH(NOLOCK)
									ON A.MASTER_ID = B.MASTER_ID
									AND A.PLAN_ID   = B.PLAN_ID
									AND A.BOD_ID    = B.BOD_ID
									WHERE A.MASTER_ID = @p_master_id  
									AND A.PLAN_ID   = @p_engine_plan_id  
								) A
								WHERE A.PRIORITY = 1
							) C
			    ON A.ITEM_ID = C.ITEM_ID
			   AND A.SITE_ID = C.TO_SITE_ID
		     WHERE NOT EXISTS (SELECT 'X'
			                     FROM TH_ENG_FIXED_PLAN_SN X WITH(NOLOCK)
								WHERE X.MASTER_ID = @p_master_id  
								  AND X.PLAN_ID   = @p_engine_plan_id
								  AND X.WORK_ORDER_ID = ISNULL(B.NEW_DEMAND_ID, A.DEMAND_ID)
							   )
		     ;
		END


		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-0 END'; 
        SET @v_description = N'6-0. Dummy Demand(대상 공용Cell Biz Demand기준) 생성 Insert(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			

        -------------------------------------------------
        -- 4. WORK_ORDER_SEQ 재설정
        -------------------------------------------------
        -- STEP4-1. WORK_ORDER_SEQ 설정
		/*********************************************************************************
		[PJ20214997] LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선
		FIXED W/O 계획순서 재정의 수정/보완 : 2021.09.08, By KKC 
		***********************************************************************************/
	
		/* 로직보완 : 20191111, By KKC
		1. Pack Site 중 Cell→Pack BOD확정계획과 Pack 생산확정계획의 WORK_ORDER_GROUP 변경
		2. 속도 문제로 일괄쿼리를 분리해서 Update하는 로직으로 변경
        3. 2023.03.17  SEQ 재정의 :3. Pack Site (P) 부분 
		/**********************************************************************************
			  [WO_SEQ_GROUP Rule] 
			1. 전극 Site (E)  : 10000
				(생산) E~***  : 10000
			 (출하공정)E~003  : 13000
				(이동) A~***  : 19000
            ---------------------------------
			2. Cell Site (A)  : 30000
				(생산) A~***  : 30000
			   (활성화)A~001  : 31000
			 (특성완료)A~002  : 32000

			  (생산TCO)A~002  : 32100  (OP:F7000)
				(이동) A~003  : 33000  (TCO) 
			   (생산TCO) A~외주 : 35000  (Site : 외주Cell)
			   (생산TCO) A~외주 : 36000  (OP:F7000, Site : A~002)				
			   (이동TCO) A~외주 : 36900  (To Site : 외주Cell)
			   (이동TCO) A~외주 : 37000  (From Site : 외주Cell)

			 (출하공정)P~***    : 39000
			 (출하공정)Cell Biz Sales Site : 39000
            ---------------------------------  
			3. Pack Site (P)  : 50000
			 (생산모듈)P~***  : 50000   (OP.P5000, P5200 )
			 (생산Cell Dummy) : 50000   (Cell Dummy Demand) / 모듈FIX물량만큼 경쟁, 2023.03.21 추가
			 (이동Pack)       : 50500   (ISZ BIZ 특화 : Pack to Pack or Pack to Sales로 이동)
			 
			 (생산Pack)P~***  : 51000   (OP.P5500, P5900, 외주공정 : 주 Capa공정의 기본값)			 
			 (생산Cell Dummy) : 51000   (Cell Dummy Demand) /PACK FIX와 경쟁

             (생산RACK)       : 56000   (Rack Biz 특화)
			 (이동Pack)P~003  : 56000   (D/O to 출하창고)
			 (이동Pack)외주   : 56000   (일반적인 고객향D/O)
			 (생산JABIL)      : 59000   (DC BIZ 특화)
            ---------------------------------
			 4. Sales Site    : 80000
			 5. Etc           : 90000
		  **************************************************************************************/
		*/

		/* [PJ20214997] RACK/DC item 구분 추가, 2021.11.09, By KKC */
		UPDATE A
		   SET A.RESERVE01 = CASE WHEN B.RACK_YN = 'Y' THEN 'RACK'
								  WHEN B.DC_YN   = 'Y' THEN 'DC'
                                  WHEN B.IS_YN   = 'Y' THEN 'ISZ'   --+ 2023.03.17 ISUZU 구분 추가 
								  ELSE NULL
							  END
		  FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
		     , SCP_MST_FINAL_ITEM_V B WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		   AND A.ITEM_ID   = B.ITEM_ID
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-1 END'; 
        SET @v_description = N'6-1. 특이 공정 구분 표시(RACK/DC/ISZ등) Update(TH_ENG_ITEM_ROUTE_SITE_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--6-2. BOD 공정에 대한 계획순서(WO_SEQ) Update 
	    --BOD공정의 순서 Rule       
		/* [PJ20216891] RACK/DC PACK 투입 공용 반제품 추가 고려, 2022.02.09, By KKC 
           2023.03.17  PACK 부분 ISUZU 고려 ORDER_SEQ 재 정의   
        */
        --BOD공정의 순서 Rule       
        WITH VW_BOD_GROUP_SEQ AS ( 
		                           /* 기본적인 Site별 계획 순서 (fixed_plan의 site_id별 기본값) */
								   SELECT A.SITE_ID
										, A.SITE_GROUP
										, SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1)   AS SITE_GUBUN
										, CASE WHEN A.SITE_GROUP = 'SALES' THEN '8'
											   ELSE CASE WHEN SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1) = 'E' THEN '1'
														 WHEN SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1) = 'A' THEN '3'
														 WHEN SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1) = 'P' THEN '5'
														 ELSE '9'
													END
											END AS LARGE_SEQ
										, CASE WHEN A.SITE_GROUP = 'SALES' THEN '0'
											  ELSE CASE WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)+1, 3) = '***' THEN '0'
														WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)+1, 3) = '001' THEN '1'
														WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)+1, 3) = '002' THEN '2'
														WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)+1, 3) = '003' THEN CASE WHEN SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1) = 'P' THEN '6'
																																	ELSE '3'
																																END
														ELSE '9'
													END
											END AS MIDIUM_SEQ
										 , A.DESCR
									FROM TH_ENG_SITE_SN A WITH(NOLOCK)
   								   WHERE A.MASTER_ID    = @p_master_id
									 AND A.PLAN_ID      = @p_engine_plan_id		
							     )
                --PACK 공용 아이템 조회, 22.02.09 ADD
			  , VW_PACK_COMMON_ITEM AS (
									    SELECT A.ITEM_ID
										 FROM
											(
											SELECT DISTINCT 
													B.ITEM_ID
												  , C.SITE_GROUP
											  FROM TH_ENG_BOD_SN A WITH(NOLOCK)
												 , TH_ENG_ITEM_BOD_SN B WITH(NOLOCK)
												 , TH_ENG_SITE_SN C WITH(NOLOCK)
											 WHERE A.MASTER_ID = @p_master_id
											   AND A.PLAN_ID   = @p_engine_plan_id
											   AND SUBSTRING(A.FROM_SITE_ID,CHARINDEX('~',A.FROM_SITE_ID,1)-1,1) = 'P' 
											   AND B.MASTER_ID = A.MASTER_ID
											   AND B.PLAN_ID   = A.PLAN_ID
											   AND B.BOD_ID    = A.BOD_ID
											   AND C.MASTER_ID = A.MASTER_ID
											   AND C.PLAN_ID   = A.PLAN_ID
											   AND C.SITE_ID   = A.TO_SITE_ID
											) A                                        
								        WHERE A.ITEM_ID NOT IN (SELECT X.ITEM_ID 
										                          FROM SCP_MST_FINAL_ITEM_V X WITH(NOLOCK)
																 WHERE ISNULL(X.IS_YN, 'N') = 'Y')  -- IZU 아이템 제외 처리. 2023.03.17
										GROUP BY A.ITEM_ID
										HAVING COUNT(A.SITE_GROUP) > 1                                        
									    )   
		 UPDATE A
			SET A.WORK_ORDER_SEQ = B.NEW_WORK_ORDER_SEQ
		   FROM TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
			  , (	   
                    SELECT A.WORK_ORDER_ID
					    ,  A.WORK_ORDER_SEQ
					    ,  A.SITE_ID
					    ,  C.FROM_SITE_ID
					    ,  A.ITEM_ID
					    ,  A.START_DTTM
					    ,  E.LARGE_SEQ+E.MIDIUM_SEQ         AS SITE_GROUP_SEQ
					    ,  CASE WHEN E.SITE_GROUP = 'SALES' THEN CASE WHEN A.DESCR LIKE '%DUMMY%'  THEN CASE WHEN A.WORK_ORDER_SEQ = '50000' THEN 50*1000 --DUMMY DEMAND 관련, 2023.03.21 추가
						                                                                                     ELSE 51*1000
																									     END
						                                              WHEN C.FROM_SITE_GUBUN = 'A' THEN 39*1000  --CELL BIZ FG Ship 확정계획은 Pack Semi 확정계획과 경쟁해야 함
																      WHEN B.ITEM_ID IS NOT NULL   THEN 56*1000  --PACK공용 DC투입과 Pack FG 확정계획과 경쟁해야 함
																      WHEN D.ITEM_ID IS NOT NULL   THEN 505*100  --IZU BIZ  FG Ship 확정계획은 IZU BIZ(모듈:AMD~) Semi 확정계획과 경쟁해야 함
																      ELSE 80*1000
															     END
								/*  전극 Site내에서 이동 (-E~ -> -E~) */
								WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'E'
								 AND SUBSTRING(C.TO_SITE_ID,CHARINDEX('~',C.TO_SITE_ID,1)-1,1) = 'E'                                      THEN 13*1000
								/*  전극  -> Cell Site 이동 (-E~-> -A~) */
								WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'E'
								 AND SUBSTRING(C.TO_SITE_ID,CHARINDEX('~',C.TO_SITE_ID,1)-1,1) = 'A'                                      THEN 19*1000
								/*  Cell Site내에서 이동 (-A~002 -> -A~003) */
								WHEN C.FROM_SITE_ID LIKE '%A~002' 
								 AND C.TO_SITE_ID   LIKE '%A~003'                                                                         THEN 33*1000
								/*  Cell Site내에서 이동 (-A~003 -> -A~***) TCO 특이 Case */
								WHEN C.FROM_SITE_ID LIKE '%A~003' 
								 AND C.TO_SITE_ID   LIKE '%A~***'                                                                         THEN 369*100  --FIX PLAN으로 생성될 일은 없겠지만, 정의
								/*  Cell Site내에서 이동 (-A~***(외주) -> -A~003) TCO 특이 Case */
								WHEN C.FROM_SITE_ID LIKE '%A~***'
								 AND C.FROM_SITE_OSP_YN = 'Y'
 								 AND C.TO_SITE_ID   LIKE '%A~003'                                                                         THEN 37*1000  --FIX PLAN으로 생성될 일은 없겠지만, 정의
								/*  Cell -> Pack Site 이동 (-A~-> -P~) */
								WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'A'                                  
								AND C.TO_SITE_ID LIKE '%P~***'                                                                            THEN 39*1000
								/*  Pack Site내에 이동 (-P~(외주)-> -P~(외주) --DC BIZ  */
								WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'P' 
								 AND SUBSTRING(C.TO_SITE_ID,CHARINDEX('~',C.TO_SITE_ID,1)-1,1) = 'P' 
								 AND C.FROM_SITE_OSP_YN = 'Y'
								 AND C.TO_SITE_OSP_YN   = 'Y'                                                                             THEN 56*1000   
								/*  IZU BIZ : Pack Site내에 이동 (AMD~ --> AM~)   */
								WHEN D.ITEM_ID IS NOT NULL                                                                                THEN 505*100   
								ELSE CONVERT(NUMERIC, E.LARGE_SEQ+E.MIDIUM_SEQ)*1000 
						    END*10000
						    + DENSE_RANK() OVER (PARTITION BY CASE WHEN E.SITE_GROUP = 'SALES' THEN CASE WHEN A.DESCR LIKE '%DUMMY%'  THEN CASE WHEN A.WORK_ORDER_SEQ = '50000' THEN 50*1000 --DUMMY DEMAND 관련, 2023.03.21 추가
																																				ELSE 51*1000
																																			END
																										 WHEN C.FROM_SITE_GUBUN = 'A' THEN 39*1000
																										 WHEN B.ITEM_ID IS NOT NULL   THEN 56*1000 
																										 WHEN D.ITEM_ID IS NOT NULL   THEN 505*100  --IZU 모델링 추가. 2023.03.17
																										 ELSE 80*1000
																								     END
																   WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'E'
																     AND SUBSTRING(C.TO_SITE_ID,CHARINDEX('~',C.TO_SITE_ID,1)-1,1) = 'E'                                      THEN 13*1000
																    WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'E'
																     AND SUBSTRING(C.TO_SITE_ID,CHARINDEX('~',C.TO_SITE_ID,1)-1,1) = 'A'                                      THEN 19*1000
																    WHEN C.FROM_SITE_ID LIKE '%A~002' 
																     AND C.TO_SITE_ID   LIKE '%A~003'                                                                         THEN 33*1000
																    WHEN C.FROM_SITE_ID LIKE '%A~003' 
																     AND C.TO_SITE_ID   LIKE '%A~***'                                                                         THEN 369*100
																    WHEN C.FROM_SITE_ID LIKE '%A~***'
																     AND C.FROM_SITE_OSP_YN = 'Y'
 																     AND C.TO_SITE_ID   LIKE '%A~003'                                                                         THEN 37*1000
																    WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'A'                                  
																     AND C.TO_SITE_ID LIKE '%P~***'                                                                           THEN 39*1000
																    WHEN SUBSTRING(C.FROM_SITE_ID,CHARINDEX('~',C.FROM_SITE_ID,1)-1,1) = 'P' 
																     AND SUBSTRING(C.TO_SITE_ID,CHARINDEX('~',C.TO_SITE_ID,1)-1,1) = 'P' 
																     AND C.FROM_SITE_OSP_YN = 'Y'
																     AND C.TO_SITE_OSP_YN   = 'Y'                                                                             THEN 56*1000   
																    WHEN D.ITEM_ID IS NOT NULL                                                                                THEN 505*100  --IZU Pack 이동 추가, 2023.03.17           
																    ELSE CONVERT(NUMERIC, E.LARGE_SEQ+E.MIDIUM_SEQ)*1000 
															        END
								   				 ORDER BY A.START_DTTM
														, A.RESOURCE_ID
														, A.WORK_ORDER_ID
                                                )  AS NEW_WORK_ORDER_SEQ
				FROM TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
				LEFT OUTER JOIN
					 VW_PACK_COMMON_ITEM B
				  ON  A.ITEM_ID = B.ITEM_ID 
			    --외주정보
				INNER JOIN	(		
                     SELECT A.BOD_ID
	                      , A.FROM_SITE_ID
	                      , A.TO_SITE_ID
	                      , SUBSTRING(A.FROM_SITE_ID,CHARINDEX('-',A.FROM_SITE_ID,1)+1,1) AS FROM_SITE_GUBUN
	                      , SUBSTRING(A.TO_SITE_ID,CHARINDEX('-',A.TO_SITE_ID,1)+1,1)     AS TO_SITE_GUBUN
	                      , CASE WHEN B.SITE_ID IS NOT NULL THEN 'Y'
			                      ELSE 'N'
		                          END  FROM_SITE_OSP_YN
	                      , CASE WHEN C.SITE_ID IS NOT NULL THEN 'Y'
			                      ELSE 'N'
		                          END  TO_SITE_OSP_YN
                       FROM TH_ENG_BOD_SN A (NOLOCK)
					   --From Site
					   LEFT OUTER JOIN (
					   		SELECT DISTINCT B.SITE_ID
					   		FROM   TH_ENG_RESOURCE_SN B (NOLOCK)
					   		WHERE  B.MASTER_ID = @p_master_id
					   		AND    B.PLAN_ID   = @p_engine_plan_id
					   		AND    B.DESCR    IN  ('OSP', 'OSP_L') --외주						  
					   		) B				
					   		ON A.FROM_SITE_ID = B.SITE_ID
					   --To Site
					   LEFT OUTER JOIN (
					   		SELECT DISTINCT C.SITE_ID
					   		FROM TH_ENG_RESOURCE_SN C (NOLOCK)
					   		WHERE C.MASTER_ID = @p_master_id
					   		AND C.PLAN_ID     = @p_engine_plan_id
					   		AND C.DESCR    IN  ('OSP', 'OSP_L') --외주						  
					   		) C		
					   		ON A.TO_SITE_ID = C.SITE_ID
   					   WHERE A.MASTER_ID    = @p_master_id
					   AND A.PLAN_ID        = @p_engine_plan_id				   
				        ) C
				  ON A.RESOURCE_ID = C.BOD_ID
				-- ISZ P5000 모델 CHECK 추가  2023.03.17
				LEFT OUTER JOIN (
                     SELECT  DISTINCT X.ITEM_ID
                     FROM    SCP_MST_FINAL_ITEM_V X WITH(NOLOCK)
                     JOIN    SCM_MST_ITEM_SN      Y WITH(NOLOCK)
                             ON X.ITEM_ID  = Y.ITEM_ID
                     WHERE   X.IS_YN       = 'Y'      -- ISUZU 품목 여부
                     AND     Y.SCP_FLOW_ID = 'P5000'  -- P5000공정
                     ) D
				  ON A.ITEM_ID = D.ITEM_ID
				 --기본 WO GROUP SEQ 정보
				INNER JOIN
					 VW_BOD_GROUP_SEQ E
				   ON A.SITE_ID = E.SITE_ID
				WHERE A.MASTER_ID = @p_master_id
				 AND A.PLAN_ID    = @p_engine_plan_id
				) B
		 WHERE A.MASTER_ID     = @p_master_id
		   AND A.PLAN_ID       = @p_engine_plan_id
		   AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;		    

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-2 END'; 
        SET @v_description = N'6-2. BOD공정 확정계획 계획순서 정렬 Update(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--6-3. ROUTE 공정에 대한 계획순서(WO_SEQ) Update 
		--ROUTE공정(BOD공정外)의 순서 Rule
		/* [PJ20216891] RACK/DC PACK 투입 공용 반제품 추가 고려, 2022.02.09, By KKC 
           PACK부분 ISUZU고려 ORDER_SEQ 재정의  2023.03.17
        */
        WITH VW_ROUTE_GROUP_SEQ AS (SELECT A.SITE_ID
										 , A.ITEM_ID
										 , A.ROUTE_ID
										 , A.OPERATION_ID
										 , SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) AS SCM_SITE
										 , SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) AS LARGE_OP_GROUP
										 , DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) AS IDX
										 , CASE 
												WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'E'
												                                                           THEN 100
												WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'A'
												                                                           THEN CASE WHEN A.OPERATION_ID = 'F7000'    THEN 321
																													 WHEN B.SITE_ID IS NOT NULL       THEN 350
																													 WHEN A.OPERATION_ID = 'F7100'    THEN 360
																													 ELSE 300
																												 END
                                                /* MEB/RACK/DC 신규 BIZ별 공정 계획 순서 채번 수정, 2022.02.09 */
												WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'P' THEN CASE WHEN A.RESERVE01    = 'DC'    THEN 590    --//DC Biz
                                                                                                                         WHEN A.RESERVE01    = 'RACK'  THEN 560    --//RACK Biz
                                                                                                                         WHEN A.OPERATION_ID IN ('P5000', 'P5200') THEN 500    --//MEB Biz, 23.03.17 P5000추가
																														 ELSE 510      -- Default값 (P5500, P9500, 외주PACK)
																													END
												ELSE 900
											END*100 AS WO_SEQ_GROUP
									FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
									--외주여부
									LEFT OUTER JOIN 
													(
													SELECT DISTINCT B.SITE_ID
													FROM TH_ENG_RESOURCE_SN B WITH(NOLOCK)
													WHERE B.MASTER_ID = @p_master_id
														AND B.PLAN_ID = @p_engine_plan_id
														AND B.DESCR    IN  ('OSP', 'OSP_L') --외주						  
													) B	  
									   ON A.SITE_ID   = B.SITE_ID
								    WHERE A.MASTER_ID = @p_master_id
									  AND A.PLAN_ID   = @p_engine_plan_id
								)
		UPDATE A   
			SET A.WORK_ORDER_SEQ = B.NEW_WORK_ORDER_SEQ
			FROM TH_ENG_FIXED_PLAN_SN A
			, (
				/* TCO 외주공정은 모델링 보고 추가 필요 */ 
				SELECT A.WORK_ORDER_ID
					,  A.SITE_ID
					,  A.ROUTE_ID
					,  A.ITEM_ID
					,  A.START_DTTM
					,  A.WORK_ORDER_SEQ
					,  B.WO_SEQ_GROUP
					,  ISNULL(B.WO_SEQ_GROUP, 90*1000)* 10000
						+ DENSE_RANK() OVER(PARTITION BY ISNULL(B.WO_SEQ_GROUP, 90*1000)
												ORDER BY A.START_DTTM
														, ISNULL(A.LOT_ID, A.WORK_ORDER_ID)
											)  AS NEW_WORK_ORDER_SEQ
				  FROM TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
				  LEFT OUTER JOIN 
				       VW_ROUTE_GROUP_SEQ B  --//누락없도록 Join, 2020/03/12, By KKC
				    ON A.SITE_ID   = B.SITE_ID
				   AND A.ROUTE_ID  = B.ROUTE_ID
				   AND A.ITEM_ID   = B.ITEM_ID
			 	 WHERE A.MASTER_ID = @p_master_id
				   AND A.PLAN_ID   = @p_engine_plan_id
		           AND NOT EXISTS (SELECT 'X' 
									FROM TH_ENG_BOD_SN X WITH(NOLOCK)
								    WHERE X.MASTER_ID = A.MASTER_ID
									  AND X.PLAN_ID   = A.PLAN_ID
									  AND X.BOD_ID    = A.RESOURCE_ID
								  )
				) B
		  WHERE A.MASTER_ID     = @p_master_id
			AND A.PLAN_ID       = @p_engine_plan_id
			AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;	

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-3 END'; 
        SET @v_description = N'6-3. 생산공정 확정계획 계획순서 정렬 Update(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/* [PJ20216891] RACK/DC PACK 투입 공용 반제품 추가 고려, 2022.02.09, By KKC 
		   - RACK BIZ 공용반제품에 대해, PACK투입 W/O과 SAELS D/O에, 순서 재정렬 처리.
		   - 이런, 데이터가 극히 없겠지만, 보완해 놓자~
		*/
        UPDATE A   
		    SET A.WORK_ORDER_SEQ = B.NEW_WORK_ORDER_SEQ
		   FROM TH_ENG_FIXED_PLAN_SN A
		      , (
			    SELECT B.WORK_ORDER_ID
				     , B.WORK_ORDER_SEQ
					 , B.START_DTTM
				     , 56*1000*10000
					 + DENSE_RANK() OVER(ORDER BY B.START_DTTM, ISNULL(B.LOT_ID, B.WORK_ORDER_ID))
											  AS NEW_WORK_ORDER_SEQ
				  FROM TH_ENG_FIXED_PLAN_SN B WITH(NOLOCK)
			     WHERE B.MASTER_ID     = @p_master_id
				   AND B.PLAN_ID       = @p_engine_plan_id
				   AND B.WORK_ORDER_SEQ LIKE '56%'	
			     ) B
		  WHERE A.MASTER_ID     = @p_master_id
			AND A.PLAN_ID       = @p_engine_plan_id
			AND A.WORK_ORDER_SEQ LIKE '56%'
			AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-4 END'; 
        SET @v_description = N'6-4. 특정 확정계획(RACK BIZ관련) 순서 재정렬 Update(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/* 2023.03.21 추가  
		   Cell Dummy 출하 FixedWork 과 생산Pack FixedWork 재정렬 (MODULE 생산 FIX와 경쟁)
		*/
		UPDATE A   
		   SET A.WORK_ORDER_SEQ = B.NEW_WORK_ORDER_SEQ
		  FROM TH_ENG_FIXED_PLAN_SN A
		      , (
			    SELECT B.WORK_ORDER_ID
				     , B.WORK_ORDER_SEQ
					 , B.START_DTTM
				     , 50*1000*10000
					 + DENSE_RANK() OVER(ORDER BY B.START_DTTM, ISNULL(B.LOT_ID, B.WORK_ORDER_ID))
											  AS NEW_WORK_ORDER_SEQ
				  FROM TH_ENG_FIXED_PLAN_SN B WITH(NOLOCK)
			     WHERE B.MASTER_ID     = @p_master_id
				   AND B.PLAN_ID       = @p_engine_plan_id
				   AND B.WORK_ORDER_SEQ LIKE '50%'	
			     ) B
		  WHERE A.MASTER_ID     = @p_master_id
			AND A.PLAN_ID       = @p_engine_plan_id
			AND A.WORK_ORDER_SEQ LIKE '50%'
			AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-5 END'; 
        SET @v_description = N'6-5. 특정 확정계획(모듈관련) 순서 재정렬 Update(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/* 2023.02.14 SHS  
			Cell Dummy 출하 FixedWork 과 생산Pack FixedWork Sorting (PACK 생산 FIX와 경쟁)
		*/
		UPDATE A   
		    SET A.WORK_ORDER_SEQ = B.NEW_WORK_ORDER_SEQ
		   FROM TH_ENG_FIXED_PLAN_SN A
		      , (
			    SELECT B.WORK_ORDER_ID
				     , B.WORK_ORDER_SEQ
					 , B.START_DTTM
				     , 51* 1000 * 10000
					 + DENSE_RANK() OVER(ORDER BY B.START_DTTM, ISNULL(B.LOT_ID, B.WORK_ORDER_ID))
											  AS NEW_WORK_ORDER_SEQ
				  FROM TH_ENG_FIXED_PLAN_SN B WITH(NOLOCK)
			     WHERE B.MASTER_ID     = @p_master_id
				   AND B.PLAN_ID       = @p_engine_plan_id
				   AND B.WORK_ORDER_SEQ LIKE '51%'	
			     ) B
		  WHERE A.MASTER_ID     = @p_master_id
			AND A.PLAN_ID       = @p_engine_plan_id
			AND A.WORK_ORDER_SEQ LIKE '51%'
			AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-6 END'; 
        SET @v_description = N'6-6. 특정 확정계획(PACK관련) 순서 재정렬 Update(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        --fixed plan의 end dttm이 정상적인 계획 BUCKET를 넘어가는 확정계획 발생 방지, 요건 변경시 적용. 2024.11.07 추가
        --bod lt가 너무 크거나 또는 다른 예외case로 만들어지는 fixed plan 생성방지.
        /*
        DELETE A
          FROM TH_ENG_FIXED_PLAN_SN A
            JOIN (
                   SELECT A.MASTER_ID
                        , A.PLAN_ID
                        , A.WORK_ORDER_ID
                    FROM
                        (
                       SELECT A.MASTER_ID
                            , A.PLAN_ID
                            , A.WORK_ORDER_ID
                            , A.SITE_ID
                            , A.RESOURCE_ID
                            , A.START_DTTM
                            , B.TRANSPORT_TIME
                            , B.TRANSPORT_TIME_UOM
                            , A.KEEP_WORK_TIME_TYPE
                            , CASE WHEN B.TRANSPORT_TIME_UOM = 'DAY'    THEN DATEADD(DAY, B.TRANSPORT_TIME, A.START_DTTM)
                                   WHEN B.TRANSPORT_TIME_UOM = 'WEEK'   THEN DATEADD(DAY, B.TRANSPORT_TIME*7, A.START_DTTM) 
                                    /* 정의되지 TIME UOM이 기준 변경시는 재검토 필요 */
                                   ELSE 
                                        DATEADD(DAY, 0, A.START_DTTM)
                               END AS END_DTTM                   
                        FROM TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
                        JOIN TH_ENG_BOD_SN B WITH(NOLOCK)
                          ON A.MASTER_ID   = B.MASTER_ID
                         AND A.PLAN_ID     = B.PLAN_ID
                         AND A.RESOURCE_ID = B.BOD_ID
                       WHERE A.MASTER_ID = @p_master_id
                         AND A.PLAN_ID   = @p_engine_plan_id 
                         AND A.DESCR NOT LIKE 'DM::DUMMY%'   --DEMAND로 수립되는 건 정상Bucket내에서 엔진계획수립하기 때문에 제외
                         AND A.KEEP_WORK_TIME_TYPE = 'START_FIX'
                        ) A
                     WHERE A.END_DTTM >= DATEADD(DAY, 1, CONVERT(DATETIME, @v_add_pet_date))
                ) B
           ON A.MASTER_ID = B.MASTER_ID
          AND A.PLAN_ID   = B.PLAN_ID
          AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
        WHERE A.MASTER_ID = @p_master_id 
          AND A.PLAN_ID   = @p_engine_plan_id 
        ;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6-7 END'; 
        SET @v_description = N'6-7. END DTTM이 계획Bucket을 넘어가는 확정계획 Delete(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        */

        -----------------------------------------------------------
                           
        -------------------------------------------------
        -- 4. Production Lot Size 설정 : 2018.09.20
        -------------------------------------------------
		-- 4-1. TH_ENG_ITEM_ROUTE_SITE [UPDATE] : MIN_LOT_SIZE / INCREMENT_LOT_SIZE 설정
        -------------------------------------------------
        /*   -- 20190801 OSP Production Lot Size 적용 제거		
        UPDATE B
        SET    B.MIN_LOT_SIZE       = A.QTY
		     , B.INCREMENT_LOT_SIZE = A.QTY
        FROM   TH_ENG_ITEM_ROUTE_SITE_SN B
	        INNER JOIN
			(
			 SELECT DISTINCT MASTER_ID, PLAN_ID, SITE_ID, ROUTE_ID, RIGHT(PRODUCT_MIX_ID, CHARINDEX('_', REVERSE(PRODUCT_MIX_ID),1)-1 ) AS ITEM_ID, QTY
			 FROM   TH_ENG_PRODUCT_MIX_SN
			 WHERE  1=1
			 AND    MASTER_ID      = @p_master_id
			 AND    PLAN_ID        = @p_engine_plan_id
			 AND    BUCKET         ='DAY'
			 AND    PRODUCT_MIX_ID NOT LIKE '%TOTAL%'
             AND    DESCR          = 'OSP' --20190218 추가( OSP 데이터만 대상임, 특성CAPA관련데이터 제외)
			) A
            ON  A.MASTER_ID = B.MASTER_ID 
			AND A.PLAN_ID   = B.PLAN_ID 
			AND A.SITE_ID   = B.SITE_ID 
			AND A.ROUTE_ID  = B.ROUTE_ID 
			AND A.ITEM_ID   = B.ITEM_ID;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4 END';
        SET @v_description = N'4-1. Production Lot Size 설정' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      */          

		-----------------------------------------------------------------
		-- 5. ESS SSP동기화를 위한 DEMAND 우선순위 변경, 2021/01/25, By KKC
		-----------------------------------------------------------------
		/* 5.1. 기존  PRIORITY 및 PROJECT코드 Update */ 
		UPDATE A
		   SET A.ORG_PRIORITY  = PRIORITY
		     , A.BUSINESS_TYPE = CASE WHEN A.BUSINESS_TYPE IS NULL THEN 'ALL' --//2021.07.21 추가
			                          ELSE A.BUSINESS_TYPE
								  END									
		  --  ,  A.PROJECT_CODE = SUBSTRING(A.DEMAND_ID, CHARINDEX('::', A.DEMAND_ID,1)+2, 8)
		  FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id 
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		/* 5.2. BUSINESS TYPE Update, 2021.07.21 추가 */ 
		UPDATE A
		   SET A.BUSINESS_TYPE = CASE WHEN A.BUSINESS_TYPE IS NULL THEN 'ALL' --//2021.07.21 추가
			                          ELSE A.BUSINESS_TYPE
								  END									
		  FROM TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id 
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		UPDATE A
		   SET A.BUSINESS_TYPE = CASE WHEN A.BUSINESS_TYPE IS NULL THEN 'ALL' --//2021.07.21 추가
			                          ELSE A.BUSINESS_TYPE
								  END									
		  FROM TH_ENG_STOCK_PLAN_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id 
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 7-0 END'; 
        SET @v_description = N'7-0. BUSINESS_TYPE 관련 테이블 Default값 Update ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/* ===========================================================
		  (2022.04.29) Engine기능 패치작업과 연관.
	      - work_time이 무한capa로 설정될 경우 단위는 'DAY'로 세팅한다. 
		  - 무한CAPA' 정의: 1일 86,400초 작업시간을 넘어가는 경우
		==============================================================*/ 
		UPDATE  A   
		SET     A.WORK_TIME_UOM = 'DAY' 
        FROM  (
                SELECT A.* 
                    ,  CASE WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'DAY'     THEN WORK_TIME * (24*60*60)    --> day to second 로 환산
			                WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'HOUR'    THEN WORK_TIME * (60*60)       --> hour to second 로 환산
			                WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'MINUTE'  THEN WORK_TIME * (60)          --> minute to second 로 환산
			                WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'SECOND'  THEN WORK_TIME                 --> 환산기준

			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'WEEK'    THEN (WORK_TIME/7) * (7*24*60*60)   --> 일 평균기준 week to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'DAY'     THEN (WORK_TIME/7) * (24*60*60)     --> 일 평균기준 day to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'HOUR'    THEN (WORK_TIME/7) * (60*60)        --> 일 평균기준 hour to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'MINUTE'  THEN (WORK_TIME/7) * (60)           --> 일 평균기준 minute to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'SECOND'  THEN (WORK_TIME/7)                  --> 일 평균기준 second값 기준.
		                END  CONVERT_SECOND
                FROM   TH_ENG_BUCKET_RES_CAPA_SN  A WITH(NOLOCK) 
                WHERE  MASTER_ID =  @p_master_id      
                AND    PLAN_ID   =  @p_engine_plan_id  
              ) A
        WHERE  A.CONVERT_SECOND > 86400   --> 1일 86,400초 초과대상
        ; 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type  = 'TXN';
        SET @v_log_message = 'PART 7-1 END'; 
        SET @v_description = N'7-1. 무한CAPA 시간단위 DAY설정(TH_ENG_BUCKET_RES_CAPA_SN) UPDATE ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        /************************************************************************************************************ 
	      2023.05.31  KKC PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 개발 임시(n-ERP 1차 데이터 변경, 7월한시적)
          2023.07.07  SHS PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 임시 모델링 이하 제거 
		 ************************************************************************************************************/


        /************************************************************************************************************ 
          LPST 계획 옵션
          일괄 변경작업 >  (1) [TH_ENG_NET_DEMAND].PRODUCTING_TYPE 
                           (2) [TH_ENG_ITEM_ROUTE_SITE].PRODUCTING_TYPE
                           (3) [TH_ENG_ITEM_BOD].IS_PULL
                           (4) [TH_ENG_ITEM_BOD_CAL].IS_PULL
		 ************************************************************************************************************/                  
        --LPST 적용 관련 로직 정리, CSR:E20240206-000725, 2024.02.06
        IF  @p_division_id  IN ('40') 
        BEGIN  
            
            ---(1) TH_ENG_NET_DEMAND : PRODUCING_TYPE (계획할당방식 옵션) 
            ---EPST : EPST부터, 계획할당 
            -- LPST : LPST부터, 계획할당 / 납기차질시에는 납기다음 BUCKET부터
            UPDATE A  
               SET A.PRODUCING_TYPE =  'LPST'
              FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
            ; 

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-1 END'; 
            SET @v_description = N'8-1. LPST설정 UPDATE(TH_ENG_NET_DEMAND) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            ---(2) TH_ENG_ITEM_ROUTE_SITE의 계획할당 방식 UPDATE 
            -- 공정별 OPERATION_TYPE은 NET DEMAND의 PRODUCING_TYPE = "LPST"일때만, 기능 동작
            UPDATE A  
               SET A.OPERATION_TYPE = 'PULL' 
              FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
            ;
            
            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-2 END'; 
            SET @v_description = N'8-2. LPST설정 UPDATE(TH_ENG_ITEM_ROUTE_SITE) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            --- (3) TH_ENG_ITEM_BOD : 활성화, 특성 BOD에서 IS_PULL을 'N'으로 설정.
            --  쿼리 직관화, 소스 수정, 2024.02.06
            UPDATE A
               SET A.IS_PULL = 'N'  
              FROM TH_ENG_ITEM_BOD_SN A WITH(NOLOCK)  
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
               AND EXISTS (SELECT 'X'
                             FROM TH_ENG_BOD_SN X WITH(NOLOCK)
                            WHERE X.MASTER_ID = @p_master_id
                              AND X.PLAN_ID   = @p_engine_plan_id
                              AND X.BOD_ID    = A.BOD_ID
                              AND (( X.TO_SITE_ID LIKE '%~001')  --//활성화
                                OR ( X.TO_SITE_ID LIKE '%~002')  --//특성
                                  )
                          )
            ; 
  
            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-3 END'; 
            SET @v_description = N'8-3. LPST설정 UPDATE(TH_ENG_ITEM_BOD) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            --- (4) TH_ENG_ITEM_BOD_CAL : 활성화, 특성 BOD에서 IS_PULL을 'N'으로 설정.
            --  쿼리 직관화, 소스 수정, 2024.02.06
            UPDATE A
               SET A.IS_PULL = 'N'  
              FROM TH_ENG_ITEM_BOD_CAL_SN A WITH(NOLOCK)  
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
               AND EXISTS (SELECT 'X'
                             FROM TH_ENG_BOD_SN X WITH(NOLOCK)
                            WHERE X.MASTER_ID = @p_master_id
                              AND X.PLAN_ID   = @p_engine_plan_id
                              AND X.BOD_ID    = A.BOD_ID
                              AND (( X.TO_SITE_ID LIKE '%~001')  --//활성화
                                OR ( X.TO_SITE_ID LIKE '%~002')  --//특성
                                  )
                          )
            ; 

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-4 END'; 
            SET @v_description = N'8-4. LPST설정 UPDATE(TH_ENG_ITEM_BOD_CAL) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        END -- LPST 설정 CLOSE'

        --81_UC TE시 계획방식 변경, CSR:E20240206-000725, 2024.02.06 
        ELSE IF (@p_division_id IN ( '81_UC') AND @p_plan_type IN ('TE'))
		BEGIN
            ---(1) TH_ENG_NET_DEMAND : PRODUCING_TYPE (계획할당방식 옵션) 
            ---EPST : EPST부터, 계획할당 
            -- LPST : LPST부터, 계획할당 / 납기차질시에는 납기다음 BUCKET부터
            UPDATE A  
               SET A.PRODUCING_TYPE =  'LPST'
              FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
            ; 

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-1 END'; 
            SET @v_description = N'8-1. LPST설정 UPDATE(TH_ENG_NET_DEMAND) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            ---(2) TH_ENG_ITEM_ROUTE_SITE의 계획할당 방식 UPDATE 
            -- 공정별 OPERATION_TYPE은 NET DEMAND의 PRODUCING_TYPE = "LPST"일때만, 기능 동작
            UPDATE A  
               SET A.OPERATION_TYPE = 'PULL' 
              FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
            ;
            
            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-2 END'; 
            SET @v_description = N'8-2. LPST설정 UPDATE(TH_ENG_ITEM_ROUTE_SITE) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            --- (3) TH_ENG_ITEM_BOD : 활성화, 특성 BOD에서 IS_PULL을 'N'으로 설정.
            --  쿼리 직관화, 소스 수정, 2024.02.06
            UPDATE A
               SET A.IS_PULL = 'N'  
              FROM TH_ENG_ITEM_BOD_SN A WITH(NOLOCK)  
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
               AND EXISTS (SELECT 'X'
                             FROM TH_ENG_BOD_SN X WITH(NOLOCK)
                            WHERE X.MASTER_ID = @p_master_id
                              AND X.PLAN_ID   = @p_engine_plan_id
                              AND X.BOD_ID    = A.BOD_ID
                              AND (( X.TO_SITE_ID LIKE '%~001')  --//활성화
                                OR ( X.TO_SITE_ID LIKE '%~002')  --//특성
                                  )
                          )
            ; 
  
            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-3 END'; 
            SET @v_description = N'8-3. LPST설정 UPDATE(TH_ENG_ITEM_BOD) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            --- (4) TH_ENG_ITEM_BOD_CAL : 활성화, 특성 BOD에서 IS_PULL을 'N'으로 설정.
            --  쿼리 직관화, 소스 수정, 2024.02.06
            UPDATE A
               SET A.IS_PULL = 'N'  
              FROM TH_ENG_ITEM_BOD_CAL_SN A WITH(NOLOCK)  
             WHERE A.MASTER_ID = @p_master_id
               AND A.PLAN_ID   = @p_engine_plan_id
               AND EXISTS (SELECT 'X'
                             FROM TH_ENG_BOD_SN X WITH(NOLOCK)
                            WHERE X.MASTER_ID = @p_master_id
                              AND X.PLAN_ID   = @p_engine_plan_id
                              AND X.BOD_ID    = A.BOD_ID
                              AND (( X.TO_SITE_ID LIKE '%~001')  --//활성화
                                OR ( X.TO_SITE_ID LIKE '%~002')  --//특성
                                  )
                          )
            ; 

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 8-4 END'; 
            SET @v_description = N'8-4. LPST설정 UPDATE(TH_ENG_ITEM_BOD_CAL) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END

		IF  @p_division_id  = '40' 
        BEGIN 
		    -- 2025.04.21   KJJ         E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발
			-- Plan ID전체 대상
			UPDATE  A   SET A.PLANT_TYPE = B.SCM_SITE_ID
            FROM    TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
              ,    (
			        SELECT AA.BOD_ID,AA.TO_SITE_ID, AA.FROM_SITE_ID, BB.SCM_SITE_ID 
					FROM   TH_ENG_BOD_SN AA WITH(NOLOCK)
                           JOIN  SCM_MST_SITE_ENG BB WITH(NOLOCK)
	                       ON    BB.DIVISION_ID  =  @p_division_id
	                       AND   BB.PLAN_ID      =  @p_plan_id
	                       AND   BB.PLAN_TYPE    =  @p_plan_type
	                       AND   BB.PLAN_SEQ     =  @p_seq
	                       AND   BB.MODELING_ID  =  @p_modeling_id
	                       AND   AA.MASTER_ID    =  @p_master_id
	                       AND   AA.PLAN_ID      =  @p_engine_plan_id
	                       AND   AA.FROM_SITE_ID =  BB.ENG_SCM_SITE_ID
		           ) B
            WHERE  A.MASTER_ID  = @p_master_id
			AND    A.PLAN_ID    = @p_engine_plan_id 
			AND    A.ROUTE_ID   = B.BOD_ID
			;

			-- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type  = 'TXN';
            SET @v_log_message = 'PART 9-1 END'; 
            SET @v_description = N'9-1. 소형 확정 출하 CELL SITE UPDATE(TH_ENG_FIXED_PLAN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END --소형 셀 생산지 지정
        ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
        
		IF(OBJECT_ID('tempdb.dbo.#tmp_MODEL_BOM') IS NOT NULL)
        BEGIN
			DROP TABLE #tmp_MODEL_BOM;
        END

        IF(OBJECT_ID('tempdb.dbo.#CELL_ITEM') IS NOT NULL)
        BEGIN
			DROP TABLE #CELL_ITEM;
        END
        
        IF(OBJECT_ID('tempdb.dbo.#CELL_BIZ_DEMAND') IS NOT NULL)
        BEGIN
	        DROP TABLE #CELL_BIZ_DEMAND;
        END
        
        IF(OBJECT_ID('tempdb.dbo.#PACK_ITEM') IS NOT NULL)
        BEGIN
	        DROP TABLE #PACK_ITEM;
        END
        
        IF(OBJECT_ID('tempdb.dbo.#PACK_BIZ_DEMAND') IS NOT NULL)
        BEGIN
	        DROP TABLE #PACK_BIZ_DEMAND;  
        END
        
        IF(OBJECT_ID('tempdb.dbo.#COMMON_CELL_ITEM') IS NOT NULL)
        BEGIN
	        DROP TABLE #COMMON_CELL_ITEM;
        END
        
        IF(OBJECT_ID('tempdb.dbo.#TMP_CELL_DEMAND') IS NOT NULL)
        BEGIN
	        DROP TABLE #TMP_CELL_DEMAND;
        END
        
		--2023.03.21 추가
        IF(OBJECT_ID('tempdb.dbo.#TMP_CELL_SPLIT_DEMAND') IS NOT NULL)
        BEGIN
	        DROP TABLE #TMP_CELL_SPLIT_DEMAND;
        END
                
        -----------------------------------------------------------
        -- TXN LOG                
        -------------------------------------------------
		SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
        BEGIN
	        COMMIT WORK;
        END

      END

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      RETURN -1
    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    RETURN 1

  END

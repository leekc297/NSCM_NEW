CREATE OR REPLACE PROCEDURE           "DMF0003_SAVE_MKT_FCST"
    -- Add the parameters for the stored procedure here
      ( P_ACTIVE_FLAG      IN  VARCHAR2
      , P_DIVISION_ID      IN  VARCHAR2
      , P_PROJECT_CODE     IN  VARCHAR2
      , P_SCM_SITE_ID      IN  VARCHAR2
      , P_ITEM_ID          IN  VARCHAR2
      , P_DOM_EXP          IN  VARCHAR2
      , P_FCST_TYPE        IN  VARCHAR2
      , P_INCOTERMS        IN  VARCHAR2
      , P_MEASURE          IN  VARCHAR2
      , P_PLANT_SITE_ID    IN  VARCHAR2
      , P_YYYYMMDD         IN  VARCHAR2
      , P_QTY              IN  VARCHAR2
      , P_CREATED_BY       IN  VARCHAR2
      , P_AS_FROM_SITE     IN  VARCHAR2
      , P_BUCKET           IN  VARCHAR2  --[E20250313-001251]_화면의 bucket 정보 받음
      , P_AUTHORITY        IN  VARCHAR2 DEFAULT NULL  --[E20260604-000994]_저장 시 로그인 권한 그룹 수신 (저장 시간창 게이트 본문은 AS-IS SP 원문 확보 후 이식 예정 — 2026-07-20)
      , O_RC1              OUT SYS_REFCURSOR
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
      )
/*============================================================================================================================
 * Program ID  : [DMF0003_SAVE_MKT_FCST]
 * Description : MKT FCST 저장, 수정, 삭제
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=============================================================================================================================
 * Date        In Charge    Description
 *=============================================================================================================================
 * 2018.03.27	KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31				insert시 테이블 컬럼지정
 * 2018.06.11				MKT_FCST_QTY_BALANCE_CREATE 로직 추가
 * 2018.06.14	KHSONG		상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (임시로직으로 차후삭제필요)
 * 2018.06.18	KHSONG		40 DIVISION 조건 추가
 * 2018.06.27	KHSONG		MKT_FCST 소형 SAVE시 VMI재고 확인후 RTF 생성 로직 개발
 * 2018.07.03	KHSONG		SCM_MST_SITE테이블의 VMI대상조건 추가
 * 2018.07.03	KHSONG		1. 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함.
 *							BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴.
 *							2. 저장하려는 SITE의 4주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함.
 *							SITE SHIP-TO가 없다고 Alert을 띄우고 ROLLBACK시킴.
 * ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
 * 2018.07.10	SKH			속도개선 수정 버전
 * ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
 * 2018.07.13   KHSONG		VMI_In_Plan 조건 추가, 당주월요일 초재고 VMI_Inv 값은 SCM_DNM_STOCK_V 에서 산출
 * 2018.07.17   KHSONG		속도개선 커서제거 로직으로 수정 (VMI재고 확인후 RTF 생성 로직)
 * 2018.07.20   KHSONG		ACTIVE_FLAG 조건추가
 * 2018.07.25   ytchoi		vmi stock qty 를 초재고로 적용
 * 2018.07.30   KHSONG		대상 Row 수가 20건 이하일 때만 수행하도록 처리
 * 2018.07.31   KHSONG		balance등 저장속도개선
 * 2018.08.06   KHSONG		2018년 10월 scp오픈전까지 vmi값이 존재하지않아 주석처리함 (ui에서 vmi RTF를 수동으로 입력가능하도록함)
 * 2018.08.10-1 KHSONG		소형은 BOM Validation 에서 제외
 * 2018.08.10-3 KHSONG		소형은 SHIP-TO Validation 에서 제외
 * 2018.08.10-2 KHSONG		소형은 BALANCE_CREATE 에서 제외 (임시)
 * 2018.08.13   KHSONG		당주 월요일이후 데이터만 대상으로 하도록 로직보완
 * 2018.08.13   ytchoi		상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직은 Div:40 소형은 제외로직 추가
 * 2018.08.16   KHSONG		DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출
 * 2018.08.16   KHSONG		Unit Price가 없는 MKT_FCST validation
 * 2018.09.14-1 KHSONG		(20180810-1 KHSONG 소형은 BOM Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
 * 2018.09.14-2 KHSONG		(20180810-3 KHSONG 소형은 SHIP-TO Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
 * 2018.09.14				소형도 FROM_SITE 조건에 추가
 * 2018.09.17	KHSONG		fcst_type LOOKUP참조하여 출력으로 변경
 * 2018.10.02	KHSONG		BALANCE CREATE 프로시져 호출로직으로 변경
 * 2018.10.05	khsong		공백제거로직추가
 * 2018.10.11	khsong		Price가 없는 case Validation 에서 제외
 * 2018.10.12				BLOCK Model
 * 2018.10.16	KHSONG		SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
 * 2018.11.07	KHSONG		소형 반품예정수량(RMA) fcst_type 조건추가
 * 2018.11.08				RMA FCST_TYPE 이외의 MEASURE 정수값 validation
 * 2018.11.21	KHSONG		MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
 * 2019.01.15	KHSONG		SALES_TYPE_CODE 'ASF' 신규 추가 (ESS측 요청사항)
 * 2019.01.18	KHSONG		ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
 * 2019.06.14	KHSONG		김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
 * 2019.07.08	KHSONG		김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
 * 2019.07.09	KHSONG		[CSR ID:4034895]  GSCM RTF[system] Measure 관련 요청건
 * 2020.03.04	KHSONG		날짜선택 오류수정
 * 2020.05.07	KHSONG		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.05.22	P.C.I		[C20200525-000296] (81 사업부) MKT Fcst 입력 시 Unit Price 체크 기준에 Plant Site 조건 추가
 * 2020.05.29	KHSONG		[C20200424-000010] (Sales Price 필수 입력 구간 관련의 건)
 * 2020.06.08	P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
 * 2020.06.15	P.C.I		[C20200615-000238] [ESS사업부] Sales Company/Plant 저장시 기준정보 재생성 로직 삭제
 * 2020.07.07	hwi1993		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화 -- 제품일경우에만 적용
 * 2020.07.09	P.C.I		[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가
 * 2020.07.16	hwi1993		[C20200713-000189] [VMI-in Req] 에 의해 자동계산된 mkt fcst 는 무시하고, 다시 자동계산해서 insert 함.
 * 2020.07.20	P.C.I		[C20200717-000157] ESS 사업부 Sales Site Project Model validation 추가
 * 2020.07.29	P.C.I		[C20200707-000149] 자동차- 환산정보 Validation에 제품(P), 반제품(H), 원재료(R), 상품(Q) 모두 포함
 * 2020.08.31	hwi1993		[C20200812-000104] [시스템 변경요청]  Active = 'N' 인 Model 도 조회되도록 변경( 미래구간 에만 적용 )
 *                           --> 그에따라 MKT FCST 에서 저장시 ACTIVE = 'N' 이면 저장 안되도록 변경
 * 2020.09.02	P.C.I		[C20200819-000105] VMI-In Request 입력시 Sales Price 필수 입력 Validation 추가
 * 2020.09.02	P.C.I		[C20200814-000183] RMA 수요의 MKT FCST 입력 제약 조건 제외
 * 2020.10.15	hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
 * 2020.11.03	P.C.I		[C20201103-000114] [ESS사업부] VMI In Req 자동화
 * 2020.11.27	hwi1993		[C20201103-000114] [ESS사업부] VMI In Req 자동화 - 수정버전
 * 2020.12.18	hwi1993		[C20201217-000126] ESS 판매법인 VMI inventory 수신 프로세스 수정 - MKT FCST ->VMI Req 변환기간을 52주에서 62주로 변경
 * 2020.12.22	kuni		[C20201211-000353] SALES PRICE 팝업 창 문구 변경 : Start  ~ End date
 * 2021.01.01	HWI1993		[C20200804-000123] SSP 동기화 수량보다 작은 수량으로 수정 불가 ( 소형 & MKT FCST 메저 )
 * 2021.01.14	HWI1993		[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( 초록색도 수정가능하도록 변경 )
 * 2021.02.03	KUNI		[C20210203-000427] Sales Price가 없는 MKT FCST DATA
 * 2021.02.26	P.C.I 		[C20210225-000385] 동기화, Carry Over 된 CONFIRM_ID 추가, 동기화 수량보다 작은 수량은 입력 불가(원복)
 * 2021.02.26	P.C.I 		[C20210420-000162] #RESULTS Table v_attribute4, v_attribute4 사이즈 변경
 * 2021.04.20	hwi1993		[PJ20209642R] PR Request 가 완료된 건은 수정되지 않도록 함. - 수정전 버전은 김영휘에게 문의
 * 2021.08.06	hwi1993		중장기과제 -- 특정 기간동안은 2022년 데이터 수정할 수 없도록
 * 2021.08.11	hwi1993		[C20210811-000230] NET DEMAND 생성 구간 확장
 * 2021.08.18	HWI1993		[C20210817-000420] Net Demand 구간 확장 로직 수정
 * 2021.09.29	hwi1993		[PJ20209643] AS 프로세스
 * 2021.09.29	hwi1993		[PJ20209643] AS 프로세스, SALES SITE 가 AS PLANT 일 경우 INCOTERMS 를 제한함.
 * 2021.12.15	HWI1993		[PJ20209643] AS 프로세스 - AS PLANT 향은 FROM SITE 를 넣지 않도록 변경
 * 2021.12.20	hwi1993		속도개선 버전
 * 2022.01.13	hwi1993		2차 속도개선 버전
 * 2022.01.20	HWI1993		3차 속도개선 및 로그프로시저 변경
 * 2022.01.22	HWI1993		[22년 하반기 과제] PRICE 자동화 진행 중 PRICE 유효성체크 로직이 필요한 기간보다 하루 더 들어가있어서 수정함
 * 2022.03.04	rosia27		[C20220224-000160]DM_LONG_PLAN 기능 고도화 요청의 건
 * 2022.03.30	kdw2819     [C20220328-000205] MKT FCST 입력, 저장 간 오류 확인 요청
 * 2022.04.07	rosia27		[과제PJ20216891R]GM_JV
 * 2022.04.27	hwi1993		C20220428-000211 자동차 VMI Biz 로직 수정 요청의 건 - 자동차 사업부 vmi 는 mkt fcst 메저를 사용하는 관계로 관련 로직 수정
 * 2022.07.15	rosia27		[C20220713-000194][영업마케팅PI P]GSCM DM 시스템의 각 모델별 Cell,Module,Pack 환산자 누락오류 방안 검토
 * 2022.07.27	rosia27		[C20220722-000367][영업마케팅PI]등급품(-K)자재 MKT FCST 입력 요청의 건
 * 2023.06.08	chano0612   [E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건
 * 2023.07.18	CHANO0612   [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선
 * 2023.11.25	HMIN        [E20231020-001565] GSCM 현장설치품 DP입력 시스템/프로세스 개선 요청의 건
 * 2024.02.05	KJJ			MKT FCST 수정시 PR_DETAIL_AUTO 수량도 업데이트 (가장 마지막 줄에 DMF0070_SAVE_QTY_PR_DETAIL_AUTO 호출)
 * 2024.12.11	JSSBAE		[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
 * 2025.03.26	JSSBAE		[E20250313-001251]_MKT FCST화면 Period 관련 조회입력 기능 개선
 * 2025.05.21   KANG.H.J	[PJ2025-50188] CELL_PROD_SITE_ID 추가 - RTF_BALANCE 계산시 40 사업부와 통일 필요
 * 2025.07.07	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.21	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2025.08.26	JSSBAE		[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * 2025.10.02	JSSBAE		[E20250919-001699]_Incoterms 데이터 처리 VALID 처리
 * 2026.02.20	JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
 * 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                              SCM_MST_SITE_ITEM Table Column 삭제에 따른 반영
 *                              #mshychu1 → T_STR_TAB TYPE 사용 (SEGMENT2 단일 컬럼, 1000건 이내, DML 없음)
 *                              #mshychu2 → T_STR_TAB TYPE 사용
 *                              #ess_price_except_model → T_STR_TAB TYPE 사용
 *============================================================================================================================*/
AS
    -- 내부 변수
    V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
    V_DIVISION_ID           VARCHAR2(4000 CHAR);
    V_PROJECT_CODE          VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
    V_ITEM_ID               VARCHAR2(4000 CHAR);
    V_DOM_EXP               VARCHAR2(4000 CHAR);
    V_FCST_TYPE             VARCHAR2(4000 CHAR);
    V_INCOTERMS             VARCHAR2(4000 CHAR);
    V_MEASURE               VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID         VARCHAR2(4000 CHAR);
    V_YYYYMMDD              VARCHAR2(4000 CHAR);
    V_QTY                   VARCHAR2(4000 CHAR);
    V_CREATED_BY            VARCHAR2(4000 CHAR);
    V_AS_FROM_SITE          VARCHAR2(4000 CHAR);
    V_AS_FROM_PLANT         VARCHAR2(4000 CHAR);
    V_MAX_INV_DAYS          PLS_INTEGER;         -- [C20210817-000420]
    PLAN_START_YYYYMMDD     VARCHAR2(4000 CHAR); -- 20180611 KHSONG ADDED
    V_BUCKET                VARCHAR2(4000 CHAR); -- [E20250313-001251]_화면의 bucket 정보 받음

    -- 작업용 복사본 파라미터 (IN 파라미터 직접 조작 불가이므로 로컬 복사)
    LP_ACTIVE_FLAG          VARCHAR2(32767 CHAR);
    LP_DIVISION_ID          VARCHAR2(32767 CHAR);
    LP_PROJECT_CODE         VARCHAR2(32767 CHAR);
    LP_SCM_SITE_ID          VARCHAR2(32767 CHAR);
    LP_ITEM_ID              VARCHAR2(32767 CHAR);
    LP_DOM_EXP              VARCHAR2(32767 CHAR);
    LP_FCST_TYPE            VARCHAR2(32767 CHAR);
    LP_INCOTERMS            VARCHAR2(32767 CHAR);
    LP_MEASURE              VARCHAR2(32767 CHAR);
    LP_PLANT_SITE_ID        VARCHAR2(32767 CHAR);
    LP_YYYYMMDD             VARCHAR2(32767 CHAR);
    LP_QTY                  VARCHAR2(32767 CHAR);
    LP_CREATED_BY           VARCHAR2(32767 CHAR);
    LP_AS_FROM_SITE         VARCHAR2(32767 CHAR);

    -- 인덱스 변수
    N_INDEX_ACTIVE_FLAG     PLS_INTEGER;
    N_INDEX_DIVISION_ID     PLS_INTEGER;
    N_INDEX_PROJECT_CODE    PLS_INTEGER;
    N_INDEX_SCM_SITE_ID     PLS_INTEGER;
    N_INDEX_ITEM_ID         PLS_INTEGER;
    N_INDEX_DOM_EXP         PLS_INTEGER;
    N_INDEX_FCST_TYPE       PLS_INTEGER;
    N_INDEX_INCOTERMS       PLS_INTEGER;
    N_INDEX_MEASURE         PLS_INTEGER;
    N_INDEX_PLANT_SITE_ID   PLS_INTEGER;
    N_INDEX_YYYYMMDD        PLS_INTEGER;
    N_INDEX_QTY             PLS_INTEGER;
    N_INDEX_CREATED_BY      PLS_INTEGER;
    N_INDEX_AS_FROM_SITE    PLS_INTEGER; -- [E20260211-001189]

    READ_CNT                PLS_INTEGER := 0;
    READ_1000_CNT           PLS_INTEGER := 0;

    -- LOG 용 변수
    V_PROGRAM_NAME          VARCHAR2(150 CHAR);
    V_LOG_TYPE              VARCHAR2(30 CHAR);
    N_LOG_COUNT             NUMBER(10) := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;
    V_PROC_INPUT            CLOB;
    V_SQL_CODE              VARCHAR2(20 CHAR);
    V_SQL_ERRMSG            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);

    -- 검증용 변수
    V_CHECK_CNT             NUMBER(10);
    V_VALID_PROJECT_CODE    VARCHAR2(4000 CHAR);
    V_VALID_ITEM_ID         VARCHAR2(4000 CHAR);
    V_VALID_ITEM_ID_2       VARCHAR2(4000 CHAR);
    V_VALID_TYPE            VARCHAR2(100 CHAR);
    V_VALID_BOM             VARCHAR2(4000 CHAR);
    V_VALID_SHIPTO          VARCHAR2(4000 CHAR);
    V_S_BLOCK_MODEL         VARCHAR2(4000 CHAR);
    V_S_UNIT_PRICE_VALID    VARCHAR2(4000 CHAR);
    V_ERR_CNT               PLS_INTEGER;

    -- INVENTORY/DATE 변수
    V_MIN_DATE              CHAR(8 CHAR);
    V_MAX_DATE              CHAR(8 CHAR);
    V_FROM_DATE             CHAR(8 CHAR);
    V_TO_DATE               CHAR(8 CHAR);

    -- 중장기 계획 DIVISION 변수
    V_C_DIVISION_ID         VARCHAR2(4000 CHAR);

    -- TYPE 변수 (#mshychu1, #mshychu2, #ess_price_except_model 대체)
    T_MSHYCHU1              SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
    T_MSHYCHU2              SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
    T_ESS_PRICE_EXCEPT      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();

    -- ESS VMI 커서용 변수
    EV_DIVISION_ID          VARCHAR2(30 CHAR);
    EV_SCM_SITE_ID          VARCHAR2(50 CHAR);
    EV_PROJECT_CODE         VARCHAR2(50 CHAR);
    EV_ITEM_ID              VARCHAR2(50 CHAR);
    EV_DOM_EXP              VARCHAR2(3 CHAR);
    EV_FCST_TYPE            VARCHAR2(20 CHAR);
    EV_INCOTERMS            VARCHAR2(10 CHAR);
    EV_PLANT_SITE_ID        VARCHAR2(30 CHAR);
    EV_DIO                  PLS_INTEGER;
    EV_BINV                 PLS_INTEGER;

    -- ESS VMI 커서
    CURSOR CURSOR_ESSVMI1 IS
        --[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건으로 기존 SCM_MST_SITE ATTRIBUTE5에서 SSPM INVENTORY DAYS 컬럼으로 변경 [START]
        -- 2026.04.06 SCM_MST_SITE_ITEM 칼럼 삭제에 따른 조회 컬럼 제거
        SELECT DISTINCT A.V_DIVISION_ID, A.V_SCM_SITE_ID, A.V_PROJECT_CODE, A.V_ITEM_ID, A.V_DOM_EXP
                      , A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
        FROM  SCM_MGR.GT_DMF3_RESULTS A
        JOIN  SCM_MGR.SCM_MST_SITE_ITEM B
          ON  A.V_DIVISION_ID   = B.DIVISION_ID
         AND  A.V_SCM_SITE_ID   = B.SCM_SITE_ID
         AND  A.V_ITEM_ID       = B.ITEM_ID
         AND  A.V_PROJECT_CODE  = B.PROJECT_CODE
        WHERE A.V_MEASURE       = 'MKT_FCST'
          AND A.V_VMI_YN        = 'Y'
          AND A.V_DIVISION_ID   = '82';
        --[E20230619-000273] [END]

    -- INVALID 플래그
    V_INVALID               BOOLEAN := FALSE;
    V_R_CURSOR              SYS_REFCURSOR;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- GTT 초기화 (프로시저 시작 시 이전에 일반 테이블 DML 없으므로 DELETE 사용)
    -- ※ TRUNCATE는 DDL로 자동 COMMIT 발생 위험이 있으므로 DELETE 사용
    DELETE FROM SCM_MGR.GT_DMF3_RESULTS;
    DELETE FROM SCM_MGR.GT_DMF3_T_PRICE;
    DELETE FROM SCM_MGR.GT_DMF3_TMP_MKT_FCST;
    DELETE FROM SCM_MGR.GT_DMF3_SEND_TARGET_DATA;
    --DELETE FROM SCM_MGR.GT_DMF3_INVENTORY_SITE; 2026.04.06 SCM_MST_SITE_ITEM 미사용으로 제거
    DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_DMF3_T_ERR;
    DELETE FROM SCM_MGR.GT_DMF3_T_ERR2;
    DELETE FROM SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP;

    -- 로컬 복사
    LP_ACTIVE_FLAG   := RTRIM(P_ACTIVE_FLAG)  || '^';
    LP_DIVISION_ID   := RTRIM(P_DIVISION_ID)  || '^';
    LP_PROJECT_CODE  := RTRIM(P_PROJECT_CODE) || '^';
    LP_SCM_SITE_ID   := RTRIM(P_SCM_SITE_ID)  || '^';
    LP_ITEM_ID       := RTRIM(P_ITEM_ID)       || '^';
    LP_DOM_EXP       := RTRIM(P_DOM_EXP)       || '^';
    LP_FCST_TYPE     := RTRIM(P_FCST_TYPE)     || '^';
    LP_INCOTERMS     := RTRIM(P_INCOTERMS)     || '^';
    LP_MEASURE       := RTRIM(P_MEASURE)       || '^';
    LP_PLANT_SITE_ID := RTRIM(P_PLANT_SITE_ID) || '^';
    LP_YYYYMMDD      := RTRIM(P_YYYYMMDD)      || '^';
    LP_QTY           := RTRIM(P_QTY)           || '^';
    LP_CREATED_BY    := RTRIM(P_CREATED_BY)    || '^';
    LP_AS_FROM_SITE  := P_AS_FROM_SITE;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    V_CREATED_BY  := SUBSTR(LP_CREATED_BY, 1,
                        CASE WHEN INSTR(LP_CREATED_BY, '^') > 1 THEN INSTR(LP_CREATED_BY, '^') - 1
                             ELSE 100 END);
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    V_CREATED_BY  := NULL;
    -- 시작 LOG (END)

    ------------------------------------------------------------------------------------------------------
    -- [E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
    /*
    -- AS_FROM_SITE 를 뽑는다.
    IF P_AS_FROM_SITE <> 'ALL'
    THEN
        -- as from site 세팅
        SELECT A.TOKEN INTO V_AS_FROM_SITE
        FROM (
            SELECT TRIM(REGEXP_SUBSTR(P_AS_FROM_SITE, '[^' || CHR(94) || ']+', 1, LEVEL)) AS TOKEN
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_AS_FROM_SITE, '[^' || CHR(94) || ']+', 1, LEVEL) IS NOT NULL
        ) A
        JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON A.TOKEN    = B.SEGMENT2
         AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
         AND B.SEGMENT2 <> '-'
         AND B.SEGMENT3 = SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1)
        WHERE ROWNUM = 1;
    END IF;
    */
    --[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선

    --[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건의 속도저하문제로 SSPM 테이블을 임시테이블로 생성 [START]
    -- 2026.04.06 SCM_MST_SITE_ITEM 미사용으로 제거
    /*IF SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1) = '82' THEN
        INSERT INTO SCM_MGR.GT_DMF3_INVENTORY_SITE
        ( DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID )
        SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
        FROM   SCM_MGR.SCM_MST_SITE_ITEM
        WHERE  DIVISION_ID = SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1)
          AND  SCM_SITE_ID IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'INVENTORY_DAYS_SETUP_SITE');
    END IF;*/
    --[E20230619-000273] [END]

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    -- 1. 화면에서 전달받은 데이터 -> GTT로 insert
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

    WHILE LENGTH(LP_DIVISION_ID) > 0
    LOOP
        N_INDEX_ACTIVE_FLAG   := INSTR(LP_ACTIVE_FLAG,   '^');
        N_INDEX_DIVISION_ID   := INSTR(LP_DIVISION_ID,   '^');
        N_INDEX_PROJECT_CODE  := INSTR(LP_PROJECT_CODE,  '^');
        N_INDEX_SCM_SITE_ID   := INSTR(LP_SCM_SITE_ID,   '^');
        N_INDEX_ITEM_ID       := INSTR(LP_ITEM_ID,        '^');
        N_INDEX_DOM_EXP       := INSTR(LP_DOM_EXP,        '^');
        N_INDEX_FCST_TYPE     := INSTR(LP_FCST_TYPE,      '^');
        N_INDEX_INCOTERMS     := INSTR(LP_INCOTERMS,      '^');
        N_INDEX_MEASURE       := INSTR(LP_MEASURE,        '^');
        N_INDEX_PLANT_SITE_ID := INSTR(LP_PLANT_SITE_ID,  '^');
        N_INDEX_YYYYMMDD      := INSTR(LP_YYYYMMDD,       '^');
        N_INDEX_QTY           := INSTR(LP_QTY,            '^');
        N_INDEX_CREATED_BY    := INSTR(LP_CREATED_BY,     '^');
        --[E20260211-001189]_index_as_from_site추가
        N_INDEX_AS_FROM_SITE  := INSTR(LP_AS_FROM_SITE || '^', '^');

        IF N_INDEX_DIVISION_ID > 0 THEN
            V_ACTIVE_FLAG   := SUBSTR(LP_ACTIVE_FLAG,   1, N_INDEX_ACTIVE_FLAG   - 1);
            V_DIVISION_ID   := SUBSTR(LP_DIVISION_ID,   1, N_INDEX_DIVISION_ID   - 1);
            V_PROJECT_CODE  := SUBSTR(LP_PROJECT_CODE,  1, N_INDEX_PROJECT_CODE  - 1);
            V_SCM_SITE_ID   := SUBSTR(LP_SCM_SITE_ID,   1, N_INDEX_SCM_SITE_ID   - 1);
            V_ITEM_ID       := SUBSTR(LP_ITEM_ID,        1, N_INDEX_ITEM_ID       - 1);
            V_DOM_EXP       := SUBSTR(LP_DOM_EXP,        1, N_INDEX_DOM_EXP       - 1);
            V_FCST_TYPE     := SUBSTR(LP_FCST_TYPE,      1, N_INDEX_FCST_TYPE     - 1);
            V_INCOTERMS     := SUBSTR(LP_INCOTERMS,      1, N_INDEX_INCOTERMS     - 1);
            V_MEASURE       := SUBSTR(LP_MEASURE,        1, N_INDEX_MEASURE       - 1);
            V_PLANT_SITE_ID := SUBSTR(LP_PLANT_SITE_ID,  1, N_INDEX_PLANT_SITE_ID - 1);
            V_YYYYMMDD      := SUBSTR(LP_YYYYMMDD,       1, N_INDEX_YYYYMMDD      - 1);
            V_QTY           := SUBSTR(LP_QTY,            1, N_INDEX_QTY           - 1);
            V_CREATED_BY    := SUBSTR(LP_CREATED_BY,     1, N_INDEX_CREATED_BY    - 1);
            --[E20260211-001189]_index_as_from_site추가
            V_AS_FROM_SITE  := SUBSTR(LP_AS_FROM_SITE || '^', 1, N_INDEX_AS_FROM_SITE - 1);

            LP_ACTIVE_FLAG   := SUBSTR(LP_ACTIVE_FLAG,   LENGTH(V_ACTIVE_FLAG   || '^') + 1);
            LP_DIVISION_ID   := SUBSTR(LP_DIVISION_ID,   LENGTH(V_DIVISION_ID   || '^') + 1);
            LP_PROJECT_CODE  := SUBSTR(LP_PROJECT_CODE,  LENGTH(V_PROJECT_CODE  || '^') + 1);
            LP_SCM_SITE_ID   := SUBSTR(LP_SCM_SITE_ID,   LENGTH(V_SCM_SITE_ID   || '^') + 1);
            LP_ITEM_ID       := SUBSTR(LP_ITEM_ID,        LENGTH(V_ITEM_ID       || '^') + 1);
            LP_DOM_EXP       := SUBSTR(LP_DOM_EXP,        LENGTH(V_DOM_EXP       || '^') + 1);
            LP_FCST_TYPE     := SUBSTR(LP_FCST_TYPE,      LENGTH(V_FCST_TYPE     || '^') + 1);
            LP_INCOTERMS     := SUBSTR(LP_INCOTERMS,      LENGTH(V_INCOTERMS     || '^') + 1);
            LP_MEASURE       := SUBSTR(LP_MEASURE,        LENGTH(V_MEASURE       || '^') + 1);

            IF V_MEASURE = 'MKT_FCST_RP' THEN
                V_MEASURE := 'MKT_FCST';
            END IF;

            LP_PLANT_SITE_ID := SUBSTR(LP_PLANT_SITE_ID, LENGTH(V_PLANT_SITE_ID || '^') + 1);
            LP_YYYYMMDD      := SUBSTR(LP_YYYYMMDD,      LENGTH(V_YYYYMMDD      || '^') + 1);
            LP_QTY           := SUBSTR(LP_QTY,           LENGTH(V_QTY           || '^') + 1);
            LP_CREATED_BY    := SUBSTR(LP_CREATED_BY,    LENGTH(V_CREATED_BY    || '^') + 1);
            --[E20260211-001189]_index_as_from_site추가
            IF N_INDEX_AS_FROM_SITE > 0 AND LENGTH(LP_AS_FROM_SITE) >= N_INDEX_AS_FROM_SITE THEN
                LP_AS_FROM_SITE := SUBSTR(LP_AS_FROM_SITE, LENGTH(V_AS_FROM_SITE || '^') + 1);
            ELSE
                LP_AS_FROM_SITE := NULL;
            END IF;

            --20181005 khsong 공백제거로직추가 (START)
            V_ACTIVE_FLAG   := TRIM(V_ACTIVE_FLAG);
            V_DIVISION_ID   := TRIM(V_DIVISION_ID);
            V_PROJECT_CODE  := TRIM(V_PROJECT_CODE);
            V_SCM_SITE_ID   := TRIM(V_SCM_SITE_ID);
            --[E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)
            --1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
            V_ITEM_ID       := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID), CHR(13),''), CHR(10),''), CHR(9),''), ' ','');
            --[E20250522-001188] (END)
            V_DOM_EXP       := TRIM(V_DOM_EXP);
            V_FCST_TYPE     := TRIM(V_FCST_TYPE);
            V_INCOTERMS     := TRIM(V_INCOTERMS);
            V_MEASURE       := TRIM(V_MEASURE);
            V_PLANT_SITE_ID := TRIM(V_PLANT_SITE_ID);
            V_YYYYMMDD      := TRIM(V_YYYYMMDD);
            V_QTY           := TRIM(V_QTY);
            V_CREATED_BY    := TRIM(V_CREATED_BY);
            --[E20260211-001189]_index_as_from_site추가
            V_AS_FROM_SITE  := TRIM(V_AS_FROM_SITE);
            --20181005 khsong 공백제거로직추가 (END)

            -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
            IF V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND REGEXP_LIKE(V_YYYYMMDD, '^[0-9]+$')  -- 2021.09.27
            THEN
                -- 2021.12.15
                DECLARE
                    V_EXISTS_W PLS_INTEGER := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS_W FROM DUAL
                    WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.SCM_MST_SITE
                        WHERE DIVISION_ID    = V_DIVISION_ID
                          AND SCM_SITE_ID    = V_SCM_SITE_ID
                          AND SITE_TYPE      = 'SALES'
                          AND OPERATION_GROUP = 'W'
                    );
                    -- SITE_TYPE=SALES, OPERATION_GROUP=W 인 AS PLANT 이면 ATTRIBUTE10 비움
                    V_AS_FROM_PLANT := '-';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- AS PLANT 가 아닌 일반 Sales Site
                        BEGIN
                            SELECT SEGMENT2 INTO V_AS_FROM_PLANT
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                              AND  SEGMENT2    = V_AS_FROM_SITE
                              AND  SEGMENT3    = V_DIVISION_ID
                              AND  SEGMENT1   <> V_SCM_SITE_ID
                              AND  ROWNUM      = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_AS_FROM_PLANT := '-';
                        END;
                END;

                INSERT INTO SCM_MGR.GT_DMF3_RESULTS
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
                VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, TO_NUMBER(V_QTY), V_CREATED_BY
                --[E20260211-001189]_index_as_from_site 원소스 주석처리 (START)
                --, NVL(V_AS_FROM_PLANT,'-')
                , NVL(V_AS_FROM_SITE, '-')  --[E20260211-001189]_변경
                --[E20260211-001189]_index_as_from_site 원소스 주석처리 (END)
                );
            ELSE
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := ' Check date values (only future dates can be entered after this week) !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;

        ELSE
            -- 마지막 토큰 처리
            V_DIVISION_ID   := LP_DIVISION_ID;
            LP_DIVISION_ID  := NULL;

            --20181005 khsong 공백제거로직추가 (START)
            V_ACTIVE_FLAG   := TRIM(V_ACTIVE_FLAG);
            V_DIVISION_ID   := TRIM(V_DIVISION_ID);
            V_PROJECT_CODE  := TRIM(V_PROJECT_CODE);
            V_SCM_SITE_ID   := TRIM(V_SCM_SITE_ID);
            V_ITEM_ID       := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID), CHR(13),''), CHR(10),''), CHR(9),''), ' ','');
            V_DOM_EXP       := TRIM(V_DOM_EXP);
            V_FCST_TYPE     := TRIM(V_FCST_TYPE);
            V_INCOTERMS     := TRIM(V_INCOTERMS);
            V_MEASURE       := TRIM(V_MEASURE);
            V_PLANT_SITE_ID := TRIM(V_PLANT_SITE_ID);
            V_YYYYMMDD      := TRIM(V_YYYYMMDD);
            V_QTY           := TRIM(V_QTY);
            V_CREATED_BY    := TRIM(V_CREATED_BY);
            --[E20260211-001189]_v_as_from_site 추가
            V_AS_FROM_SITE  := TRIM(V_AS_FROM_SITE);
            --20181005 khsong 공백제거로직추가 (END)

            -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
            IF V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND REGEXP_LIKE(V_YYYYMMDD, '^[0-9]+$')
            THEN
                DECLARE
                    V_EXISTS_W2 PLS_INTEGER := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS_W2 FROM DUAL
                    WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.SCM_MST_SITE
                        WHERE DIVISION_ID     = V_DIVISION_ID
                          AND SCM_SITE_ID     = V_SCM_SITE_ID
                          AND SITE_TYPE       = 'SALES'
                          AND OPERATION_GROUP = 'W'
                    );
                    V_AS_FROM_PLANT := '-';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        BEGIN
                            SELECT SEGMENT2 INTO V_AS_FROM_PLANT
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                              AND  SEGMENT2    = V_AS_FROM_SITE
                              AND  SEGMENT3    = V_DIVISION_ID
                              AND  SEGMENT1   <> V_SCM_SITE_ID
                              AND  ROWNUM      = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_AS_FROM_PLANT := '-';
                        END;
                END;

                INSERT INTO SCM_MGR.GT_DMF3_RESULTS
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
                VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, TO_NUMBER(V_QTY), V_CREATED_BY
                --[E20260211-001189]_v_as_from_site 원소스 주석처리 (START)
                --, NVL(V_AS_FROM_PLANT,'-')
                , NVL(V_AS_FROM_SITE, '-')  --변경
                --[E20260211-001189]_v_as_from_site 원소스 주석처리 (END)
                );
            ELSE
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := ' Check date values (only future dates can be entered after this week) !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;

            EXIT; -- WHILE 종료
        END IF;

        --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        -- 2. 데이터 정합성 Validation
        --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        ----------- 20180810 KHSONG NULL VALIDATION ADDED
        IF    NVL(V_DIVISION_ID,  '-') = '-'  OR V_DIVISION_ID  = ''
           OR NVL(V_PROJECT_CODE, '-') = '-'  OR V_PROJECT_CODE = ''
           OR NVL(V_SCM_SITE_ID,  '-') = '-'  OR V_SCM_SITE_ID  = ''
           OR NVL(V_ITEM_ID,      '-') = '-'  OR V_ITEM_ID      = ''
           OR NVL(V_DOM_EXP,      '-') = '-'  OR V_DOM_EXP      = ''
           OR NVL(V_FCST_TYPE,    '-') = '-'  OR V_FCST_TYPE    = ''
           OR NVL(V_INCOTERMS,    '-') = '-'  OR V_INCOTERMS    = ''
           OR NVL(V_MEASURE,      '-') = '-'  OR V_MEASURE      = ''
        THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := ' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook ) !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
        -----------
    END LOOP;

    -- [C20220328-000205] MKT FCST 입력, 저장 간 오류 확인 요청
    DECLARE
        V_DUP_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_DUP_CNT
        FROM (
            SELECT COUNT(V_DIVISION_ID) AS CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS
            GROUP BY V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                   , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
            HAVING COUNT(V_DIVISION_ID) > 1
        );
        IF V_DUP_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일한 일자에 AS From Site 만 다른 DP 를 입력할 수 없습니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;

    -- ----------------------- SALES PRICE 미리 수집 --------------------------------
    SELECT MIN(BASIS_START_DATE), MAX(BASIS_END_DATE)
    INTO   V_MIN_DATE, V_MAX_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M M
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
    /*
    WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD')  --당주 월요일부터
                                AND TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7 + 52*7,'YYYYMMDD')  -- 52주후 월요일까지
    */
    -----------------------------------------------------------------------------------------------------------------------------------
    WHERE  M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD')   --당주 월요일부터
      AND  M.BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7 + 52*7,'YYYYMMDD');  -- 52주후 월요일까지
    -- [E20250825-000297] (END)
    -----------------------------------------------------------------------------------------------------------------------------------

    INSERT INTO SCM_MGR.GT_DMF3_T_PRICE
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID
                  , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE
    FROM   SCM_MGR.GT_DMF3_RESULTS A
    JOIN   SCM_MGR.SCM_MST_FUTURE_PRICE B
      ON   A.V_DIVISION_ID    = B.DIVISION_ID
     AND   A.V_PROJECT_CODE   = B.PROJECT_CODE
     AND   A.V_SCM_SITE_ID    = B.SCM_SITE_ID
     AND   A.V_PLANT_SITE_ID  = CASE WHEN A.V_DIVISION_ID LIKE '81%' THEN B.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
     AND   A.V_ITEM_ID        = B.ITEM_ID
     AND   A.V_DOM_EXP        = B.DOM_EXP
     AND   A.V_FCST_TYPE      = B.FCST_TYPE
     AND   A.V_INCOTERMS      = B.INCOTERMS
    WHERE  B.DIVISION_ID      = V_DIVISION_ID
      AND  B.YYYYMMDD        BETWEEN V_MIN_DATE AND V_MAX_DATE
      AND  B.PRICE           <> 0;

    ---------------------------------------------------------------------------------------------------------

    -- GT_DMF3_RESULTS 테이블의 VMI_YN UPDATE
    UPDATE SCM_MGR.GT_DMF3_RESULTS A
    SET    V_VMI_YN = (
               SELECT CASE WHEN NVL(B.VMI_YN, '-') = 'Y' THEN 'Y' ELSE 'N' END
               FROM   SCM_MGR.SCM_MST_SITE B
               WHERE  B.DIVISION_ID = A.V_DIVISION_ID
                 AND  B.SCM_SITE_ID = A.V_SCM_SITE_ID
           );

    -- AS 이더라도 AS Plant 에는 Attribute10 을 지워준다.
    UPDATE SCM_MGR.GT_DMF3_RESULTS A
    SET    V_ATTRIBUTE10 = '-'
    WHERE  V_SCM_SITE_ID = V_ATTRIBUTE10;

    /*
    [E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선 사용하지 않아도 됨 (START)
    -- AS 인데, FROM Site 가 없는 건들은 오류처리한다. ( WS, 20211103 )
	-- FCST Type 에 WS, WSF가 포함되어있는데, From Site 가 없는 경우 에러처리
	IF EXISTS ( SELECT *
				FROM #results A
				JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON A.v_division_id = B.DIVISION_ID
					AND A.v_scm_site_id = B.SCM_SITE_ID
					AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
					ON A.v_fcst_type = C.SEGMENT1
					AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					AND C.ATTRIBUTE2 = 'Y'
				)
		AND NOT EXISTS ( SELECT *
							FROM SCM_MST_SITE WITH(NOLOCK)
							WHERE DIVISION_ID = @v_division_id
							AND SCM_SITE_ID = @v_as_from_site
						)
		BEGIN
			SET @v_log_type = 'INVALID';
			--[E20260211-001189]_내용변경 (START)
			--SELECT N'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
			SELECT N'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
			--SET @v_description =  N'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
			SET @v_description =  N'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
			--[E20260211-001189]_내용변경 (END)
			GOTO ERR_RTN
		END

	-- AS 유효성 체크
	-- AS FROM SITE 가 여러개 있거나 없는 경우
	IF NOT EXISTS (	SELECT COUNT(*)
					FROM DBO.UF_FX_String_Split(@p_as_from_site, '^') A
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
						ON A.TOKEN = B.SEGMENT1
						AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
						AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						HAVING COUNT(*) = 1
					)
		-- 고객향이 포함된 경우 ( AS PLANT 로 가는 데이터만 있을 경우 FROM SITE 필요 없음 )
		AND EXISTS ( SELECT *
						FROM #results A
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									ON A.v_scm_site_id = B.SEGMENT1
									AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
									AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						WHERE B.SEGMENT1 IS NULL
					) -- AS FCST TYPE 이 있을 경우
		AND EXISTS ( SELECT *
						FROM #results A
						JOIN SCM_MST_SITE B WITH(NOLOCK)
						ON A.v_division_id = B.DIVISION_ID
						AND A.v_scm_site_id = B.SCM_SITE_ID
						AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
						ON A.v_fcst_type = C.SEGMENT1
						AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND C.ATTRIBUTE2 = 'Y'
					)
		BEGIN
			SET @v_log_type = 'INVALID';
			--[E20260211-001189]_내용변경 (START)
			--SELECT N'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.'
			SELECT N'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.'
			--SET @v_description =  N'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.!'
			SET @v_description =  N'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.!'
			--[E20260211-001189]_내용변경 (END)
			goto err_rtn
		END
    [E20260211-001189] (END)
    */

    -- AS PLANT 로 가는 DP의 INCOTERMS 를 제한한다.
    DECLARE
        V_INCO_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_INCO_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.V_DIVISION_ID = B.SEGMENT3
         AND   A.V_SCM_SITE_ID = B.SEGMENT1
         AND   B.LOOKUP_TYPE   = 'AS_SITE_PLANT'
         AND   B.VALID_YN      = 'Y'
        LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.V_DIVISION_ID = C.SEGMENT1
         AND   A.V_INCOTERMS   = C.SEGMENT2
         AND   C.VALID_YN      = 'Y'
        WHERE  C.SEGMENT1 IS NULL;

        IF V_INCO_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;

    --==========================================================================================================================
    -- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
    --==========================================================================================================================
    DECLARE
        V_OLD_INCO_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_OLD_INCO_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  A.V_INCOTERMS IN (
                   SELECT OLD_VALUE1
                   FROM   SCM_MGR.NERP_CONV_MASTER
                   WHERE  CODETYPE = 'INCOTERMS_ID'
                   GROUP BY OLD_VALUE1
               );
        IF V_OLD_INCO_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '구코드 INCOTERMS는 저장할 수 없습니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    --==========================================================================================================================
    -- [E20250919-001699] (END)
    --==========================================================================================================================

    -- 중장기계획 기간 조회
    SELECT MIN(C.BASIS_YYYYMMDD), MAX(C.BASIS_YYYYMMDD)
    INTO   V_FROM_DATE, V_TO_DATE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
    JOIN   SCM_MGR.SCM_SYS_CALENDAR_M C
      ON   C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
    WHERE  L.LOOKUP_TYPE = 'DM_LONG_PLAN'
      AND  L.SEGMENT1    = '40'
      AND  L.SEGMENT2    = 'MKT FCST'
      AND  L.VALID_YN    = 'Y';

    -- 소형일 경우 중장기계획 관련 기간 확인
    IF V_DIVISION_ID = '40' THEN
        DECLARE
            V_OOB_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_OOB_CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS R
            WHERE  R.V_YYYYMMDD < V_FROM_DATE OR R.V_YYYYMMDD > V_TO_DATE;
            IF V_OOB_CNT > 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := V_FROM_DATE || ' ~ ' || V_TO_DATE || ' 구간 내의 데이터만 수정할 수 있습니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181012 BLOCK Model (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    V_S_BLOCK_MODEL := '-';
    BEGIN
        SELECT V_ITEM_ID INTO V_S_BLOCK_MODEL
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE  LOOKUP_TYPE = 'FCST_EXCEPT_MODEL'
                     AND  SEGMENT1   = '40'
                     AND  VALID_YN   = 'Y'
                     AND  SEGMENT2   = A.V_ITEM_ID
               )
          AND  A.V_QTY <> 0
          AND  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_S_BLOCK_MODEL := '-';
    END;

    IF V_S_BLOCK_MODEL <> '-' THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := 'Model : ' || V_S_BLOCK_MODEL || CHR(10) || 'FCST INPUT BLOCK Model. contact 영업관리팀';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181012 BLOCK Model (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 저장전 변수 초기화
    V_CHECK_CNT          := 0;
    V_VALID_PROJECT_CODE := NULL;
    V_VALID_ITEM_ID      := NULL;
    V_VALID_ITEM_ID_2    := NULL;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID <> '40';

    IF V_CHECK_CNT > 0 THEN
        BEGIN
            SELECT A.V_PROJECT_CODE INTO V_VALID_PROJECT_CODE
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            WHERE  NOT EXISTS (
                       SELECT C.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_PROJECT C
                       WHERE  A.V_DIVISION_ID  = C.DIVISION_ID
                         AND  A.V_PROJECT_CODE = C.PROJECT_CODE
                         AND  C.DIVISION_ID   <> '40'
                   )
              AND  A.V_DIVISION_ID <> '40'
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_PROJECT_CODE := NULL;
        END;
        IF V_VALID_PROJECT_CODE IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_PROJECT_CODE || '] Invalid Project Code !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;

    BEGIN
        SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  NOT EXISTS (
                   SELECT ITEM.DIVISION_ID
                   FROM   SCM_MGR.SCM_MST_SITE_ITEM ITEM
                   JOIN   SCM_MGR.SCM_MST_ITEM_SN   SN
                     ON   ITEM.DIVISION_ID = SN.DIVISION_ID
                    AND   ITEM.ITEM_ID     = SN.ITEM_ID
                   WHERE  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                     AND  ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                     AND  ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                     AND  ITEM.ITEM_ID      = A.V_ITEM_ID
                     AND  SN.ACTIVE_FLAG    = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                     AND  ITEM.VALID_YN     = 'Y'  -- [C20200812-000104]
               )
          AND  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
    END;
    IF V_VALID_ITEM_ID IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Invalid Site Item ID !';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;

    -- [C20200717-000157] ESS사업부 Sales Site Project Model Sales Company, Sales Plant Validation 추가
    V_CHECK_CNT          := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82';

    IF V_CHECK_CNT > 0 THEN
        BEGIN
            SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            WHERE  EXISTS (
                       SELECT ITEM.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_SITE_ITEM ITEM
                       JOIN   SCM_MGR.SCM_MST_ITEM_SN   SN
                         ON   ITEM.DIVISION_ID = SN.DIVISION_ID
                        AND   ITEM.ITEM_ID     = SN.ITEM_ID
                       WHERE  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                         AND  ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                         AND  ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                         AND  ITEM.ITEM_ID      = A.V_ITEM_ID
                         AND  SN.ACTIVE_FLAG    = 'Y'
                         AND  ( (ITEM.SALES_COMPANY IS NULL OR ITEM.SALES_COMPANY = '-')
                              OR (ITEM.SALES_PLANT   IS NULL OR ITEM.SALES_PLANT   = '-') )
                   )
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
        END;
        IF V_VALID_ITEM_ID IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Sales Company/Plant does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    --  20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건) Unit Price 유무 Validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎

    -- #mshychu1 → T_MSHYCHU1 (단일 컬럼 Type)
    SELECT SEGMENT2
    BULK COLLECT INTO T_MSHYCHU1
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
      AND  MST.SEGMENT1    = 'MEASURE'
      AND  MST.VALID_YN    = 'Y';

    -- #mshychu2 → T_MSHYCHU2
    SELECT SEGMENT2
    BULK COLLECT INTO T_MSHYCHU2
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
      AND  MST.SEGMENT1    = 'FCST_TYPE'
      AND  MST.VALID_YN    = 'Y';

    -- [E20231020-001565] 현장설치품 예외 모델 로드
    SELECT SEGMENT2
    BULK COLLECT INTO T_ESS_PRICE_EXCEPT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'ESS_PRICE_EXCEPT_MODEL'
      AND  MST.SEGMENT1    = V_DIVISION_ID   -- 82번사업부만해당
      AND  MST.VALID_YN    = 'Y';

    V_S_UNIT_PRICE_VALID := NULL;
    BEGIN
        SELECT
            CASE WHEN A.V_DIVISION_ID = '40'
                 THEN 'End Customer________ : ' || NVL(V_PROJECT_CODE, '-')
                 ELSE 'Project_________ : '     || NVL(V_PROJECT_CODE, '-') END
            || CHR(10) || 'Sales site_____________ : '   || NVL(V_SCM_SITE_ID,   '-')
            || CHR(10) || 'Model________________ : '     || NVL(V_ITEM_ID,        '-')
            || CHR(10) || 'Customs Handbook__ : '        || NVL(V_DOM_EXP,        '-')
            || CHR(10) || 'Fcst Type_____________ : '    ||
                NVL(( SELECT SEGMENT2
                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                      WHERE  MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND  MST.SEGMENT1    = A.V_FCST_TYPE
                        AND  ROWNUM = 1 ), '-')  -- 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
            || CHR(10) || 'Incoterms____________ : '     || NVL(V_INCOTERMS,      '-')
            || CHR(10) || 'Plant Site___________ : '     || NVL(V_PLANT_SITE_ID,  '-')  -- [C20200525-000296]
            || CHR(10) || 'YYYYMMDD_________ : '         || NVL(MIN(M.BASIS_START_DATE),'-') || ' ~ ' || NVL(MAX(M.BASIS_START_DATE),'-')  -- [C20210203-000427]
            || CHR(10) || CHR(10)
        INTO V_S_UNIT_PRICE_VALID
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        --  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
        JOIN   SCM_MGR.SCM_MST_SITE_ITEM Z
          ON   A.V_DIVISION_ID   = Z.DIVISION_ID
         AND   A.V_PROJECT_CODE  = Z.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = Z.SCM_SITE_ID
         AND   A.V_ITEM_ID       = Z.ITEM_ID
         AND   Z.VALID_YN        = 'Y'
         AND   ( Z.SALES_PLAN_ADJUST_YN = 'Y' OR NVL(Z.SALES_PLAN_ADJUST_YN,'-') = '-' )  -- 20181023 보완
        --  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
        LEFT   JOIN (  -- [C20210203-000427]
                       SELECT BASIS_START_DATE
                       FROM   SCM_MGR.SCM_SYS_CALENDAR_M M
                       -----------------------------------------------------------------------------------------------------------------------------------
                       -- [E20250825-000297] (START)
                       /*
                       WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
                                               AND TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
                       */
                       WHERE  M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')   --당주 월요일부터
                         AND  M.BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')  -- 52주후 월요일까지
                       -- [E20250825-000297] (END)
                       -----------------------------------------------------------------------------------------------------------------------------------
                       GROUP BY BASIS_START_DATE
                   ) M
          ON   1=1
        LEFT   JOIN SCM_MGR.GT_DMF3_T_PRICE P
          ON   A.V_DIVISION_ID   = P.DIVISION_ID
         AND   A.V_PROJECT_CODE  = P.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = P.SCM_SITE_ID
         AND   A.V_ITEM_ID       = P.ITEM_ID
         AND   A.V_DOM_EXP       = P.DOM_EXP
         AND   A.V_FCST_TYPE     = P.FCST_TYPE
         AND   A.V_INCOTERMS     = P.INCOTERMS
         AND   A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID LIKE '81%' THEN P.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END  -- [C20200525-000296]
         AND   P.YYYYMMDD        = M.BASIS_START_DATE
         AND   P.PRICE > 0
        WHERE  P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
          AND  A.V_MEASURE IN (SELECT COLUMN_VALUE FROM TABLE(T_MSHYCHU1))
          AND  A.V_QTY     <> 0
          AND  A.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_MSHYCHU2))
          AND  A.V_ITEM_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_ESS_PRICE_EXCEPT))  -- [E20231020-001565]
        GROUP  BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID
                , A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_MEASURE, A.V_PLANT_SITE_ID, P.YYYYMMDD
        ORDER  BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID
                , A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_MEASURE, A.V_PLANT_SITE_ID, P.YYYYMMDD
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_S_UNIT_PRICE_VALID := NULL;
    END;

    IF V_S_UNIT_PRICE_VALID IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := V_S_UNIT_PRICE_VALID || 'Unit Price Not Found !' || CHR(10)
                      || '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)
                      || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    --  20200529 KHSONG C20200424-000010 Unit Price 유무 Validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 RMA FCST_TYPE 음수값 validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DECLARE
        V_RMA_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(*),0) INTO V_RMA_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS
        WHERE  V_FCST_TYPE = 'RMA'
          AND  V_QTY > 0;
        IF V_RMA_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '반품수량(RMA)은 음수값만 입력가능합니다 !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 RMA FCST_TYPE 음수값 validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DECLARE
        V_NEG_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(*),0) INTO V_NEG_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS
        WHERE  V_FCST_TYPE <> 'RMA'
          AND  V_QTY < 0;
        IF V_NEG_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '정수값만 입력가능합니다 !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -- Start [C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
    V_VALID_TYPE := NULL;
    V_CHECK_CNT          := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID LIKE '81%';


    IF V_CHECK_CNT > 0 THEN

        INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_V
        ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
        , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
        , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
        , CELL_QUANTITY )
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
             , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
             , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
             , CELL_QUANTITY
        FROM (
            SELECT T2.DIVISION_ID, T2.ITEM_ID, T2.ITEM_NAME, T2.ITEM_CLASS, T2.ITEM_CLASS_NAME
                 , T2.NICK_NAME, T2.ITEM_TYPE, T2.MATERIAL_CLASS_NAME, T2.ITEM_UOM, T2.SPEC
                 , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
                 , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T2.ACTIVE_FLAG, T2.CELL_TYPE, T2.ENERGE
                 , T2.CELL_QUANTITY
            FROM  SCM_MGR.DM_MST_ITEM_SINGLE_V T2
            JOIN  SCM_MGR.GT_DMF3_RESULTS A
              ON  A.V_DIVISION_ID = T2.DIVISION_ID
             AND  A.V_ITEM_ID     = T2.ITEM_ID
        ) G
        GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
               , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
               , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
               , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
               , CELL_QUANTITY;

        BEGIN
            SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_ITEM F
              ON   A.V_DIVISION_ID   = F.DIVISION_ID
             AND   A.V_ITEM_ID       = F.ITEM_ID
             AND   A.V_PROJECT_CODE  = F.PROJECT_CODE
             AND   A.V_SCM_SITE_ID   = F.SCM_SITE_ID
            JOIN   SCM_MGR.GT_DMF3_ITEM_SINGLE_V X
              ON   A.V_DIVISION_ID = X.DIVISION_ID
             AND   A.V_ITEM_ID     = X.ITEM_ID
            WHERE  CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Cell') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Pack') > 0  AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        ELSE 0
                   END = 1
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
        END;

        IF V_VALID_ITEM_ID IS NOT NULL THEN
            BEGIN
                SELECT CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 THEN 'Cell/Car or Cell/Module'
                            ELSE 'Cell/Car' END
                INTO   V_VALID_TYPE
                FROM   SCM_MGR.GT_DMF3_ITEM_SINGLE_V X
                WHERE  X.ITEM_ID = V_VALID_ITEM_ID
                  AND  ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN V_VALID_TYPE := '-';
            END;
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] ' || V_VALID_TYPE || ' does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;
    -- END [C20200511-000360]

    -- START [C20220713-000194]
    V_CHECK_CNT  := 0;
    SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF3_RESULTS A WHERE A.V_DIVISION_ID LIKE '81%')
           THEN 1 ELSE 0 END
    INTO V_CHECK_CNT
    FROM DUAL;

    IF V_CHECK_CNT > 0 THEN -- Case 28 변환
        DECLARE
            V_DESC_81 VARCHAR2(4000 CHAR);
        BEGIN
            SELECT V_DESCRIPTION INTO V_DESC_81
            FROM (
                SELECT '[' || RTRIM(A.V_ITEM_ID) || '] '
                    || CASE WHEN (NOT REGEXP_LIKE(B.ATTRIBUTE8, '^[0-9.]+$') OR NVL(TO_NUMBER(B.ATTRIBUTE8),0) <= 0)
                            THEN 'Kwh/Cell does not exist !'
                            WHEN B.ATTRIBUTE10 NOT IN (
                                     SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                                 )
                            THEN 'CELL_TYPE does not exist !'
                            WHEN NVL(B.CELL_PER_CAR,0) <= 0
                            THEN 'Cell/Car does not exist !'
                       END
                    || CHR(10) || 'Sales Site Project Model 에서 해당 항목을 채워주세요.' AS V_DESCRIPTION
                FROM SCM_MGR.GT_DMF3_RESULTS A
                JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                  ON A.V_DIVISION_ID  = B.DIVISION_ID
                 AND A.V_PROJECT_CODE = B.PROJECT_CODE
                 AND A.V_SCM_SITE_ID  = B.SCM_SITE_ID
                 AND A.V_ITEM_ID      = B.ITEM_ID
                JOIN SCM_MGR.GT_DMF3_ITEM_SINGLE_V C
                  ON A.V_DIVISION_ID  = C.DIVISION_ID
                 AND A.V_ITEM_ID      = C.ITEM_ID
                 AND C.ITEM_TYPE      = 'P'
                WHERE A.V_DIVISION_ID LIKE '81%'
                  AND (
                        ( NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                          OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0 )
                        OR B.ATTRIBUTE10 NOT IN (
                               SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                           )
                        OR NVL(B.CELL_PER_CAR,0) <= 0
                      )
                ORDER BY A.V_ITEM_ID
                FETCH FIRST 1 ROW ONLY
            );
            IF V_DESC_81 IS NOT NULL THEN
                V_DESCRIPTION := V_DESC_81;
                V_LOG_TYPE    := 'INVALID';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
    END IF;
    -- END [C20220713-000194]

    -- [C20200804-000123] SSP 동기화 수량보다 작은 수량으로 수정 불가 ( 소형 & MKT FCST 메저 ) ------------ START
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40' AND V_MEASURE = 'MKT_FCST';

    IF V_CHECK_CNT > 0 THEN

        -- 아래에서 I/O 처리시 DELETE 후 INSERT 이므로 ATTRIBUTE를 보존하기 위해 업데이트
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    ( V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5 ) =
               ( SELECT B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.ATTRIBUTE5
                 FROM   SCM_MGR.DM_PLN_MKT_FCST B
                 WHERE  B.DIVISION_ID  = A.V_DIVISION_ID
                   AND  B.PROJECT_CODE = A.V_PROJECT_CODE
                   AND  B.SCM_SITE_ID  = A.V_SCM_SITE_ID
                   AND  B.ITEM_ID      = A.V_ITEM_ID
                   AND  B.DOM_EXP      = A.V_DOM_EXP
                   AND  B.FCST_TYPE    = A.V_FCST_TYPE
                   AND  B.INCOTERMS    = A.V_INCOTERMS
                   AND  B.MEASURE      = A.V_MEASURE
                   AND  B.YYYYMMDD     = A.V_YYYYMMDD
                   AND  B.MEASURE      = 'MKT_FCST'
                   AND  REGEXP_LIKE(NVL(B.ATTRIBUTE1,'-'), '^[0-9.]+$')
                   AND  B.DIVISION_ID  = V_DIVISION_ID
                   AND  EXISTS ( SELECT 1 FROM SCM_MGR.SCM_MST_SITE C
                                 WHERE B.DIVISION_ID = C.DIVISION_ID
                                   AND B.SCM_SITE_ID = C.SCM_SITE_ID
                                   AND C.VMI_YN <> 'Y' )
               );

        -- [C20210225-000385] 동기화 수량보다 작은 수량은 입력 불가(원복)
        INSERT INTO SCM_MGR.GT_DMF3_T_ERR
        ( PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, SYNC_QTY, QTY )
        SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS
             , A.V_MEASURE, A.V_YYYYMMDD
             , CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE2,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE2) ELSE 0 END
             + CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE3,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE3) ELSE 0 END
               AS SYNC_QTY
             , A.V_QTY
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE C
          ON   A.V_DIVISION_ID = C.DIVISION_ID
         AND   A.V_SCM_SITE_ID = C.SCM_SITE_ID
         AND   C.VMI_YN <> 'Y'
        WHERE  A.V_DIVISION_ID = V_DIVISION_ID
          AND  REGEXP_LIKE(NVL(A.V_ATTRIBUTE1,'-'), '^[0-9.]+$')
          AND  A.V_MEASURE     = 'MKT_FCST'
          AND  CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE2,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE2) ELSE 0 END
             + CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE3,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE3) ELSE 0 END
               > A.V_QTY
          AND  A.V_YYYYMMDD <> TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');

        DECLARE
            V_T_ERR_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_T_ERR_CNT FROM SCM_MGR.GT_DMF3_T_ERR;
            IF V_T_ERR_CNT > 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := 'SSP 동기화 수량보다 작은 수량으로 수정된 건이 있습니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;
    -- [C20200804-000123] END ------------

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG BOM 검증 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    --IF (SELECT count(1) FROM GT_DMF3_RESULTS where V_DIVISION_ID = '40') = 0  -- 20180914-1 주석처리
    BEGIN
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    V_BOM_YN = 'N'
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
                   WHERE  B.LOOKUP_TYPE    = 'AS_SITE_PLANT'
                     AND  B.SEGMENT3       = V_DIVISION_ID
                     AND  B.VALID_YN       = 'Y'
                     AND  A.V_ATTRIBUTE10  = B.SEGMENT2
               )
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_MST_ITEM_SN C
                   WHERE  C.DIVISION_ID = A.V_DIVISION_ID
                     AND  C.ITEM_ID     = A.V_ITEM_ID
               )
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
                   JOIN   SCM_MGR.SCM_MST_ITEM_SN CC
                     ON   CC.DIVISION_ID = A.V_DIVISION_ID
                    AND   CC.ITEM_ID     = A.V_ITEM_ID
                    AND   CC.EVAL_CLASS  = D.SEGMENT1
                   WHERE  D.LOOKUP_TYPE = 'DM_BOM_EXCEPT_CLASS'
                     AND  D.VALID_YN    = 'Y'
               )
          AND  A.V_DIVISION_ID = V_DIVISION_ID
          AND  A.V_MEASURE     = 'MKT_FCST';

        V_CHECK_CNT  := 0;
        SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_BOM_YN IS NULL;

        IF V_CHECK_CNT > 0 THEN
            V_VALID_BOM   := NULL;
            V_VALID_SHIPTO := NULL;

            BEGIN
                SELECT A.V_ITEM_ID INTO V_VALID_BOM
                FROM   SCM_MGR.GT_DMF3_RESULTS A
                JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V C
                  ON   A.V_ITEM_ID     = C.ITEM_ID
                 AND   A.V_DIVISION_ID = C.DIVISION_ID
                 AND   C.ITEM_TYPE     IN ('P','H')
                 AND   C.ACTIVE_FLAG   = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                LEFT   JOIN SCM_MGR.SCM_MST_BOM_ENG_SN X
                  ON   A.V_DIVISION_ID    = X.DIVISION_ID
                 AND   A.V_ITEM_ID        = X.PARENT_ITEM_ID
                LEFT   JOIN (
                                SELECT DIVISION_ID
                                     , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END AS FROM_SITE  -- 20180914 소형도 FROM_SITE 조건에 추가
                                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                                FROM  SCM_MGR.SCP_MST_BOD_V
                                WHERE PRIORITY = 1
                                GROUP BY DIVISION_ID
                                       , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END
                                       , TO_SITE, INCOTERMS  -- 20180914 소형도 FROM_SITE 조건에 추가
                            ) BOD
                  ON   A.V_DIVISION_ID   = BOD.DIVISION_ID
                 AND   A.V_PLANT_SITE_ID = BOD.FROM_SITE
                 AND   A.V_SCM_SITE_ID   = BOD.TO_SITE
                 AND   A.V_INCOTERMS     = BOD.INCOTERMS
                WHERE  A.V_MEASURE  IN ('MKT_FCST','Vmi_In_Req')
                  AND  A.V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
                  AND  A.V_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') + NVL(BOD.LT_TOTAL,0) + 70, 'YYYYMMDD')  -- 당주 월요일 + 11주 까지
                  AND  A.V_QTY      > 0
                  AND  X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
                  AND  A.V_ITEM_ID NOT IN ('ECE0074N5-01')  -- 20190614 김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
                  AND  A.V_ITEM_ID NOT IN ('MCCH120022B2-K','MCCH120022B2-GD')  -- 20190708 김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
                  AND  A.V_BOM_YN IS NULL
                  AND  ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN V_VALID_BOM := NULL;
            END;

            IF V_VALID_BOM IS NOT NULL THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[' || V_VALID_BOM || '] BOM does not exist !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG BOM 검증 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG SHIPTO 검증 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- IF (SELECT count(1) FROM GT_DMF3_RESULTS where V_DIVISION_ID = '40') = 0  -- 20180914-2 주석처리
    BEGIN
        BEGIN
            SELECT A.V_SCM_SITE_ID INTO V_VALID_SHIPTO
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER X
              ON   A.V_DIVISION_ID = X.DIVISION_ID
             AND   A.V_SCM_SITE_ID = X.SCM_SITE_ID
             AND   X.VALID_YN      = 'Y'
             AND   X.REP_YN        = 'Y'
            LEFT   JOIN (
                            SELECT DIVISION_ID
                                 , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END AS FROM_SITE  -- 20180914 소형도 FROM_SITE 조건에 추가
                                 , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                            FROM  SCM_MGR.SCP_MST_BOD_V
                            WHERE PRIORITY = 1
                            GROUP BY DIVISION_ID
                                   , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END
                                   , TO_SITE, INCOTERMS  -- 20180914 소형도 FROM_SITE 조건에 추가
                        ) BOD
              ON   A.V_DIVISION_ID   = BOD.DIVISION_ID
             AND   A.V_PLANT_SITE_ID = BOD.FROM_SITE
             AND   A.V_SCM_SITE_ID   = BOD.TO_SITE
             AND   A.V_INCOTERMS     = BOD.INCOTERMS
            WHERE  A.V_MEASURE  IN ('MKT_FCST','Vmi_In_Req')
              AND  A.V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
              AND  A.V_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') + NVL(BOD.LT_TOTAL,0) + 21, 'YYYYMMDD')   -- BOD LT + 4W
              AND  A.V_QTY      > 0
              AND  X.SHIPTO_CODE IS NULL
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_SHIPTO := NULL;
        END;

        IF V_VALID_SHIPTO IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_SHIPTO || '] SITE SHIP-TO does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG SHIPTO 검증 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 2021.4.20 hwi1993 [PJ20209642R]과제 - PR Request 가 존재하는 건들은 수정 못하도록 함. (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82' AND V_MEASURE = 'BNPIn';

    IF V_CHECK_CNT > 0 THEN

        INSERT INTO SCM_MGR.GT_DMF3_T_ERR2
        ( SCM_SITE_ID, ITEM_ID, FCST_TYPE, YYYYMMDD )
        SELECT DISTINCT B.SCM_SITE_ID, B.ITEM_ID, B.FCST_TYPE, B.YYYYMMDD
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.DM_PLN_PR_DETAIL B
          ON   A.V_DIVISION_ID   = B.DIVISION_ID
         AND   A.V_PROJECT_CODE  = B.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = B.SCM_SITE_ID
         AND   A.V_ITEM_ID       = B.ITEM_ID
         AND   A.V_DOM_EXP       = B.DOM_EXP
         AND   A.V_FCST_TYPE     = B.FCST_TYPE
         AND   A.V_INCOTERMS     = B.INCOTERMS
         AND   A.V_PLANT_SITE_ID = B.PLANT_SITE_ID
         AND   A.V_YYYYMMDD      = B.YYYYMMDD;

        DECLARE
            V_T_ERR2_CNT PLS_INTEGER := 0;
            V_ERR2_SCM   VARCHAR2(30 CHAR);
            V_ERR2_ITEM  VARCHAR2(50 CHAR);
            V_ERR2_FCST  VARCHAR2(20 CHAR);
            V_ERR2_YYYY  VARCHAR2(8 CHAR);
        BEGIN
            SELECT COUNT(1) INTO V_T_ERR2_CNT FROM SCM_MGR.GT_DMF3_T_ERR2;
            IF V_T_ERR2_CNT > 0 THEN
                SELECT SCM_SITE_ID, ITEM_ID, FCST_TYPE, YYYYMMDD
                INTO   V_ERR2_SCM, V_ERR2_ITEM, V_ERR2_FCST, V_ERR2_YYYY
                FROM   SCM_MGR.GT_DMF3_T_ERR2
                WHERE  ROWNUM = 1;
                V_ERR_CNT := V_T_ERR2_CNT;
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[Sales Site:' || RTRIM(V_ERR2_SCM)  || ']'
                              || '[Model :' || RTRIM(V_ERR2_ITEM) || ']'
                              || '[FCST Type :' || RTRIM(V_ERR2_FCST) || ']'
                              || '[YYYYMMDd :' || RTRIM(V_ERR2_YYYY) || ']'
                              || CASE WHEN V_ERR_CNT > 1 THEN '외 ' || TO_CHAR(V_ERR_CNT-1) || '건' ELSE ' ' END
                              || '은 기 Request 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요';
                V_INVALID := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;

    -- ATTRIBUTE9 가 '' 이 아닌 경우 수정불가 ( ESS )
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82' AND V_MEASURE = 'BNPIn';

    IF V_CHECK_CNT > 0 THEN
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    V_ATTRIBUTE9 = (
                   SELECT B.ATTRIBUTE9
                   FROM   SCM_MGR.DM_PLN_MKT_FCST B
                   WHERE  B.DIVISION_ID  = A.V_DIVISION_ID
                     AND  B.PROJECT_CODE = A.V_PROJECT_CODE
                     AND  B.SCM_SITE_ID  = A.V_SCM_SITE_ID
                     AND  B.ITEM_ID      = A.V_ITEM_ID
                     AND  B.DOM_EXP      = A.V_DOM_EXP
                     AND  B.FCST_TYPE    = A.V_FCST_TYPE
                     AND  B.INCOTERMS    = A.V_INCOTERMS
                     AND  B.MEASURE      = A.V_MEASURE
                     AND  B.YYYYMMDD     = A.V_YYYYMMDD
                     AND  B.MEASURE      = 'BNPIn'
                     AND  B.DIVISION_ID  = V_DIVISION_ID
               );

        DECLARE
            V_ATTR9_CNT PLS_INTEGER := 0;
            V_ATTR9_SCM VARCHAR2(30 CHAR);
            V_ATTR9_ITM VARCHAR2(50 CHAR);
            V_ATTR9_FCT VARCHAR2(20 CHAR);
            V_ATTR9_YYY VARCHAR2(8 CHAR);
        BEGIN
            SELECT COUNT(1) INTO V_ATTR9_CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS
            WHERE  NVL(V_ATTRIBUTE9,'-') <> '-';

            IF V_ATTR9_CNT > 0 THEN
                SELECT V_SCM_SITE_ID, V_ITEM_ID, V_FCST_TYPE, V_YYYYMMDD
                INTO   V_ATTR9_SCM, V_ATTR9_ITM, V_ATTR9_FCT, V_ATTR9_YYY
                FROM   SCM_MGR.GT_DMF3_RESULTS
                WHERE  NVL(V_ATTRIBUTE9,'-') <> '-'
                  AND  ROWNUM = 1;
                V_ERR_CNT     := V_ATTR9_CNT;
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[Sales Site:' || RTRIM(V_ATTR9_SCM) || ']'
                              || '[Model :' || RTRIM(V_ATTR9_ITM) || ']'
                              || '[FCST Type :' || RTRIM(V_ATTR9_FCT) || ']'
                              || '[YYYYMMDd :' || RTRIM(V_ATTR9_YYY) || ']'
                              || CASE WHEN V_ERR_CNT > 1 THEN '외 ' || TO_CHAR(V_ERR_CNT-1) || '건' ELSE ' ' END
                              || '은 기 Confirm ID 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요';
                V_INVALID := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 2021.4.20 hwi1993 [PJ20209642R] (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    --  INPUT MEASURE 중복값 delete후 INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    -- 3. MKT FCST 테이블 INSERT
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

    --[E20250313-001251]_bucket = 'Monthly' or 'Weekly'인 경우 우선 데이터를 0으로 UPDATE를 한뒤 데이터 작업을 시작한다. START
    IF P_BUCKET = 'MONTHLY' THEN
        UPDATE SCM_MGR.DM_PLN_MKT_FCST A
        SET    A.QTY = 0
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF3_RESULTS R
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BR
                     ON   R.V_YYYYMMDD = BR.BASIS_YYYYMMDD
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BA
                     ON   A.YYYYMMDD = BA.BASIS_YYYYMMDD
                   WHERE  A.DIVISION_ID    = R.V_DIVISION_ID
                     AND  A.PROJECT_CODE   = R.V_PROJECT_CODE
                     AND  A.SCM_SITE_ID    = R.V_SCM_SITE_ID
                     AND  A.ITEM_ID        = R.V_ITEM_ID
                     AND  A.DOM_EXP        = R.V_DOM_EXP
                     AND  A.FCST_TYPE      = R.V_FCST_TYPE
                     AND  A.INCOTERMS      = R.V_INCOTERMS
                     AND  A.MEASURE        = R.V_MEASURE
                     AND  A.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                     AND  BA.BASIS_YYYYMM  = BR.BASIS_YYYYMM
               );
    ELSIF P_BUCKET = 'WEEKLY' THEN
        UPDATE SCM_MGR.DM_PLN_MKT_FCST A
        SET    A.QTY = 0
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF3_RESULTS R
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BR
                     ON   R.V_YYYYMMDD = BR.BASIS_YYYYMMDD
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BA
                     ON   A.YYYYMMDD = BA.BASIS_YYYYMMDD
                   WHERE  A.DIVISION_ID    = R.V_DIVISION_ID
                     AND  A.PROJECT_CODE   = R.V_PROJECT_CODE
                     AND  A.SCM_SITE_ID    = R.V_SCM_SITE_ID
                     AND  A.ITEM_ID        = R.V_ITEM_ID
                     AND  A.DOM_EXP        = R.V_DOM_EXP
                     AND  A.FCST_TYPE      = R.V_FCST_TYPE
                     AND  A.INCOTERMS      = R.V_INCOTERMS
                     AND  A.MEASURE        = R.V_MEASURE
                     AND  A.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                     AND  BA.BASIS_YYYYMM  = BR.BASIS_YYYYMM
                     AND  BA.ISO_YYYYWW    = BR.ISO_YYYYWW
               );
    END IF;
    --[E20250313-001251] END

    -- [] 81 -VMI 에 MKT FCST 가 있으면 VMI IN REQ 메저도 동일하게 생성/삭제한다.
    V_CHECK_CNT  := 0;
    SELECT COUNT(1)
    INTO   V_CHECK_CNT
    FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE B
          ON   A.V_SCM_SITE_ID = B.SCM_SITE_ID AND A.V_DIVISION_ID = B.DIVISION_ID AND B.VMI_YN = 'Y'
        WHERE  A.V_DIVISION_ID LIKE '81%'
          AND  A.V_MEASURE = 'MKT_FCST';

    IF V_CHECK_CNT > 0
    THEN
        INSERT INTO SCM_MGR.GT_DMF3_RESULTS
        ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
        , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
        , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
        SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
             , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'VMI_In_Req' AS V_MEASURE, V_PLANT_SITE_ID
             , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE B
          ON   A.V_SCM_SITE_ID = B.SCM_SITE_ID
         AND   A.V_DIVISION_ID = B.DIVISION_ID
         AND   B.VMI_YN        = 'Y'
        WHERE  A.V_DIVISION_ID LIKE '81%'
          AND  A.V_MEASURE     = 'MKT_FCST';
    END IF;

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS R
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = R.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = R.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = R.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = R.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = R.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = R.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = R.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.MEASURE        = R.V_MEASURE
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       = R.V_YYYYMMDD
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
         , V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
         , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5  -- [C20210225-000385]
         , NULL, NULL, NULL, NULL, V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_RESULTS;

    -----------------------------------------------------------------------
    -- [C20201103-000114] ESS 법인 MKT_FCST 메저에 따라 VMI_IN_REQ 자동 계산
    -----------------------------------------------------------------------
    FOR R_VMI IN CURSOR_ESSVMI1
    LOOP
        EV_DIVISION_ID   := R_VMI.V_DIVISION_ID;
        EV_SCM_SITE_ID   := R_VMI.V_SCM_SITE_ID;
        EV_PROJECT_CODE  := R_VMI.V_PROJECT_CODE;
        EV_ITEM_ID       := R_VMI.V_ITEM_ID;
        EV_DOM_EXP       := R_VMI.V_DOM_EXP;
        EV_FCST_TYPE     := R_VMI.V_FCST_TYPE;
        EV_INCOTERMS     := R_VMI.V_INCOTERMS;
        EV_PLANT_SITE_ID := R_VMI.V_PLANT_SITE_ID;

        -- 기초재고를 가져온다.
        EV_BINV := 0;
        BEGIN
            SELECT NVL(QTY,0) INTO EV_BINV
            FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
            WHERE  A.DIVISION_ID       = '82'
              AND  A.MEASURE           = 'VMI_Inv'
              AND  A.YYYYMMDD          = TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 8, 'YYYYMMDD')   -- 실적구간 마지막일자
              AND  A.SCM_SITE_ID       = EV_SCM_SITE_ID
              AND  A.PROJECT_CODE      = EV_PROJECT_CODE
              AND  A.ITEM_ID           = EV_ITEM_ID
              AND  A.DOM_EXP           = EV_DOM_EXP
              AND  A.FCST_TYPE         = EV_FCST_TYPE
              AND  A.INCOTERMS         = EV_INCOTERMS
              AND  A.PLANT_SITE_ID     = EV_PLANT_SITE_ID
              AND  A.CELL_PROD_SITE_ID = '-';  -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
        EXCEPTION
            WHEN NO_DATA_FOUND THEN EV_BINV := 0;
        END;

        -- 해당 SITE 의 미래구간의 VMI_IN_REQ 를 모두 지운다.
        DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A
        WHERE  A.DIVISION_ID  = '82'
          AND  A.MEASURE       = 'VMI_In_Req'
          AND  A.YYYYMMDD     >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 계획구간만
          AND  A.SCM_SITE_ID   = EV_SCM_SITE_ID
          AND  A.PROJECT_CODE  = EV_PROJECT_CODE
          AND  A.ITEM_ID       = EV_ITEM_ID
          AND  A.DOM_EXP       = EV_DOM_EXP
          AND  A.FCST_TYPE     = EV_FCST_TYPE
          AND  A.INCOTERMS     = EV_INCOTERMS
          AND  A.PLANT_SITE_ID = EV_PLANT_SITE_ID;

        -- 계산 및 INSERT
        INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
        , INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE
             , X.INCOTERMS, 'VMI_In_Req' AS MEASURE
             , TO_CHAR(TO_DATE(X.YYYYMMDD,'YYYYMMDD') - 0, 'YYYYMMDD')  -- MKT FCST 의 일자를 기준으로 집계했으므로 재고일수만큼 앞으로 밀어준다.
             , X.PLANT_SITE_ID
             , CASE WHEN ROW_NUM <= 0 THEN 0
                    WHEN ROW_NUM = 0 + 1 THEN CASE WHEN SUM_QTY > EV_BINV THEN SUM_QTY - EV_BINV ELSE 0 END
                    WHEN SUM_QTY > EV_BINV AND BF_SUM <= EV_BINV THEN SUM_QTY - EV_BINV
                    WHEN BF_SUM  > EV_BINV THEN QTY
                    ELSE 0
               END AS QTY
             , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
        FROM (
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
                 , A.INCOTERMS, A.YYYYMMDD, A.PLANT_SITE_ID
                 , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD )                                              AS SUM_QTY
                 , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS BF_SUM
                 , QTY
                 , ROW_NUMBER() OVER ( ORDER BY A.YYYYMMDD )                                            AS ROW_NUM
            FROM (
                SELECT A.BASIS_YYYYMMDD AS YYYYMMDD, 'MKT_FCST' AS MEASURE
                     , NVL(B.QTY, 0) AS QTY
                     , EV_DIVISION_ID  AS DIVISION_ID
                     , EV_SCM_SITE_ID  AS SCM_SITE_ID
                     , EV_PROJECT_CODE AS PROJECT_CODE
                     , EV_ITEM_ID      AS ITEM_ID
                     , EV_DOM_EXP      AS DOM_EXP
                     , EV_FCST_TYPE    AS FCST_TYPE
                     , EV_INCOTERMS    AS INCOTERMS
                     , EV_PLANT_SITE_ID AS PLANT_SITE_ID
                FROM  SCM_MGR.SCM_SYS_CALENDAR_M A
                LEFT  JOIN SCM_MGR.DM_PLN_MKT_FCST B
                  ON  A.BASIS_YYYYMMDD  = B.YYYYMMDD
                 AND  B.MEASURE         = 'MKT_FCST'
                 AND  B.DIVISION_ID     = '82'
                 AND  B.SCM_SITE_ID     = EV_SCM_SITE_ID
                 AND  B.PROJECT_CODE    = EV_PROJECT_CODE
                 AND  B.ITEM_ID         = EV_ITEM_ID
                 AND  B.DOM_EXP         = EV_DOM_EXP
                 AND  B.FCST_TYPE       = EV_FCST_TYPE
                 AND  B.INCOTERMS       = EV_INCOTERMS
                 AND  B.PLANT_SITE_ID   = EV_PLANT_SITE_ID
                WHERE A.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 계획구간만
                  AND A.BASIS_YYYYMMDD <= TO_CHAR(
                          TO_DATE(TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD'),'YYYYMMDD')
                          + CASE WHEN 0 > 0 THEN 0 + 1 ELSE 0 + 10 END + 7*84
                        , 'YYYYMMDD')
                -- [C20201217-000126], [C20210811-000230] 62주에서 92주로 확장(MKT FCST 메저 기준), [C20210817-000420]
            ) A
        ) X
        WHERE CASE WHEN ROW_NUM <= 0 THEN 0
                   WHEN ROW_NUM = 0 + 1 THEN CASE WHEN SUM_QTY > EV_BINV THEN SUM_QTY - EV_BINV ELSE 0 END
                   WHEN SUM_QTY > EV_BINV AND BF_SUM <= EV_BINV THEN SUM_QTY - EV_BINV
                   WHEN BF_SUM  > EV_BINV  THEN QTY
                   ELSE 0
              END > 0;

    END LOOP;

    -------------------------------------------------------------------------------------◎◎◎◎
    -- HISTORY INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
    , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT V_DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
         , V_YYYYMMDD, V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY
         , SYSDATE, NULL, NULL, NULL, NULL, NULL
         , NULL, NULL, NULL, NULL, V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_RESULTS;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- HISTORY INSERT (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_MST_CUSTOMER_FCST map create (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP
    ( DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY )
    SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.MEASURE
         , A.SUMMARY_BUCKET_VALUE AS START_DAY
         , CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY'
                THEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE,'YYYYMMDD'),'SUN'),'YYYYMMDD')
                ELSE A.SUMMARY_BUCKET_VALUE
           END AS END_DAY
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID
           FROM   SCM_MGR.GT_DMF3_RESULTS
           WHERE  V_MEASURE NOT IN ('MKT_FCST','RTF')  -- 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
         ) RSLT
      ON  A.DIVISION_ID = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID = RSLT.V_SCM_SITE_ID
    WHERE A.VALID_YN           = 'Y'
      AND A.MEASURE_GROUP      = 'CUST_FCST'
      AND A.PLAN_WEEK          = (SELECT MAX(PLAN_WEEK) FROM SCM_MGR.DM_MST_CUSTOMER_FCST)
      AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 당주 월요일 이후데이터만
      AND A.SUMMARY_BUCKET_TYPE IN ('DAILY','WEEKLY')
    UNION ALL
    SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.MEASURE
         , CASE WHEN A.SUMMARY_BUCKET_VALUE = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE,-1))+1,'YYYYMMDD')
                THEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
                ELSE A.SUMMARY_BUCKET_VALUE
           END AS START_DAY
         , TO_CHAR(LAST_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE,'YYYYMMDD')),'YYYYMMDD') AS END_DAY
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID
           FROM   SCM_MGR.GT_DMF3_RESULTS
           WHERE  V_MEASURE NOT IN ('MKT_FCST','RTF')
         ) RSLT
      ON  A.DIVISION_ID = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID = RSLT.V_SCM_SITE_ID
    WHERE A.VALID_YN           = 'Y'
      AND A.MEASURE_GROUP      = 'CUST_FCST'
      AND A.PLAN_WEEK          = (SELECT MAX(PLAN_WEEK) FROM SCM_MGR.DM_MST_CUSTOMER_FCST)
      AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD')
      AND A.SUMMARY_BUCKET_TYPE IN ('MONTHLY');
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_MST_CUSTOMER_FCST map create (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_TMP_MKT_FCST
    ( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
    , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
    , V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY )
    SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                  , A.FCST_TYPE, A.INCOTERMS, 'CUST_FCST', A.PLANT_SITE_ID, A.YYYYMMDD
                  , A.QTY, A.CREATED_BY, A.LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID, V_ITEM_ID, V_INCOTERMS
                         , V_PLANT_SITE_ID, V_PROJECT_CODE, V_DOM_EXP, V_FCST_TYPE, V_ATTRIBUTE10
           FROM  SCM_MGR.GT_DMF3_RESULTS
         ) RSLT
      ON  A.DIVISION_ID   = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
     AND  A.ITEM_ID        = RSLT.V_ITEM_ID
     AND  A.INCOTERMS      = RSLT.V_INCOTERMS
     AND  A.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
     AND  A.PROJECT_CODE   = RSLT.V_PROJECT_CODE
     AND  A.DOM_EXP        = RSLT.V_DOM_EXP
     AND  A.FCST_TYPE      = RSLT.V_FCST_TYPE
    JOIN (
        SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
        FROM   SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP
        GROUP  BY DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
    ) MAP
      ON  A.DIVISION_ID = MAP.DIVISION_ID
     AND  A.SCM_SITE_ID = MAP.SCM_SITE_ID
     AND  A.MEASURE     = MAP.MEASURE
    WHERE A.YYYYMMDD BETWEEN MAP.START_DAY AND MAP.END_DAY
      AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_TMP_MKT_FCST T
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = T.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = T.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = T.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = T.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = T.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = T.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = T.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.MEASURE        = T.V_MEASURE
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = T.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE10 )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
         , V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
         , V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_TMP_MKT_FCST;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    PLAN_START_YYYYMMDD := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200427 변경
      AND  YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      -- modified by ytchoi 20180813
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = RSLT.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = RSLT.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = RSLT.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = RSLT.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= PLAN_START_YYYYMMDD
                 AND  ITEM.ACTIVE_FLAG = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 AND  ( ITEM.ITEM_TYPE IN ('Q','R')
                     OR RSLT.V_ITEM_ID IN (
                            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                            WHERE K.DIVISION_ID = RSLT.V_DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                        )
                      )  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
                 --AND DM_PLN_MKT_FCST.DIVISION_ID IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895]
                 AND  DM_PLN_MKT_FCST.DIVISION_ID IN ('82')  -- 20190709 KHSONG [CSR ID:4034895]
                 --[E20241211-000856] END
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
    , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS
         --, 'RTF'
         , 'RTF_SYS_RP'  -- 20200427 변경
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
         , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
         , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  A.MEASURE   = 'MKT_FCST'
      AND  A.YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      -- modified by ytchoi 20180813
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  A.ITEM_ID       = RSLT.V_ITEM_ID
                 AND  A.DOM_EXP       = RSLT.V_DOM_EXP
                 AND  A.FCST_TYPE     = RSLT.V_FCST_TYPE
                 AND  A.INCOTERMS     = RSLT.V_INCOTERMS
                 AND  A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID
                 AND  ITEM.ACTIVE_FLAG = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 AND  ( ITEM.ITEM_TYPE IN ('Q','R')
                     OR RSLT.V_ITEM_ID IN (
                            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                            WHERE K.DIVISION_ID = RSLT.V_DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                        )
                      )  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
                 --AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895]
                 AND  A.DIVISION_ID IN ('82')  -- 20190709 KHSONG [CSR ID:4034895]
                 --[E20241211-000856] END
           );
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    PLAN_START_YYYYMMDD := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200507 변경
      AND  YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = RSLT.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = RSLT.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = RSLT.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = RSLT.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= PLAN_START_YYYYMMDD
                 AND  ITEM.ACTIVE_FLAG  = 'Y'
                 AND  RSLT.V_FCST_TYPE  = 'RMA'
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
    , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS
         --, 'RTF'
         , 'RTF_SYS_RP'  -- 20200507 변경
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
         , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
         , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  A.MEASURE   = 'MKT_FCST'
      AND  A.YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  A.ITEM_ID       = RSLT.V_ITEM_ID
                 AND  A.DOM_EXP       = RSLT.V_DOM_EXP
                 AND  A.FCST_TYPE     = RSLT.V_FCST_TYPE
                 AND  A.INCOTERMS     = RSLT.V_INCOTERMS
                 AND  A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID
                 AND  ITEM.ACTIVE_FLAG = 'Y'
                 AND  RSLT.V_FCST_TYPE = 'RMA'
           );
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 KHSONG 소형 반품예정수량(RMA) (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- BALANCE_CREATE 호출 로직 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_SEND_TARGET_DATA
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, PLANT_SITE_ID
    , CELL_PROD_SITE_ID  -- [PJ2025-00188]
    , VMI_YN )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
         , '-' AS CELL_PROD_SITE_ID  -- [PJ2025-00188] 그외는 - 로 처리
         , 'N' AS VMI_YN             -- vmi_yn 초기값
    FROM   SCM_MGR.GT_DMF3_RESULTS
    GROUP  BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
            , V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID;

    SELECT DIVISION_ID INTO V_C_DIVISION_ID
    FROM   SCM_MGR.GT_DMF3_SEND_TARGET_DATA
    WHERE  ROWNUM = 1;

    -- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (START)
    -- 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
    -- 2026.04.06 POC 테스트를 위해 임시 막음. PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE이 참조 작업이 너무 많아 일단 막음
    -- SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(V_C_DIVISION_ID, P_PLAN_ID => 'CALL');
    -- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (END)

    -------------------------------------------------------------------------------------◎◎◎◎
    -- BALANCE_CREATE 호출 로직 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    --[E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건 [START]
    IF V_DIVISION_ID = '82' THEN
        PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC(V_DIVISION_ID, V_CREATED_BY, V_R_CURSOR);
        IF V_R_CURSOR%ISOPEN THEN
            CLOSE V_R_CURSOR;
        END IF;
    END IF;
    --[E20230608-000891] [END]

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180816 KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- SCP가 Open 했기 때문에 RTF 값을 MKT FCST에서 수정하지 않음.
    V_CHECK_CNT := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40';

    IF V_CHECK_CNT > 0 THEN
        SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180816 KHSONG DIVISION_ID = '40' (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -----------------------------------------------------------------------
    -- DMF0070_SAVE_QTY_PR_DETAIL_AUTO 호출
    -----------------------------------------------------------------------
    -- MKT FCST 수정시 PR_DETAIL_AUTO 수량도 업데이트--KJJ 2024.02.05
    /*
    EXEC dbo.DMF0070_SAVE_QTY_PR_DETAIL_AUTO
        */
    /* 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
       DMF0070 기능 미사용 DMF0070_SAVE_QTY_PR_DETAIL_AUTO 작업 호출 안 함
    SCM_MGR.DMF0070_SAVE_QTY_PR_DETAIL_AUTO(
        V_DIVISION_ID,
        V_PROJECT_CODE,
        V_SCM_SITE_ID,
        V_ITEM_ID,
        V_DOM_EXP,
        V_FCST_TYPE,
        V_INCOTERMS,
        V_PLANT_SITE_ID,
        V_YYYYMMDD,
        V_QTY
    ); */

    -- COMMIT은 프로시저 종료 직전 1회만 수행
    COMMIT;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    RETURN;

    -- 트랜잭션 (END)
    <<ERR_RTN>>
    IF V_LOG_TYPE = 'INVALID' THEN

        V_LOG_MESSAGE := '########## END of procedure ##########';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[C20200804-000123]
        V_CHECK_CNT := 0;
        SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40';

        IF V_CHECK_CNT > 0 THEN
            OPEN O_RC1 FOR
            SELECT A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD
                , A.SYNC_QTY, A.QTY
            FROM SCM_MGR.GT_DMF3_T_ERR A
            ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD;

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_DESCRIPTION AS MSG , '0' AS EVENT FROM DUAL;
        ELSE
            OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_DESCRIPTION AS MSG , '0' AS EVENT FROM DUAL;
        END IF;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF V_R_CURSOR%ISOPEN THEN
            CLOSE V_R_CURSOR;
        END IF;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'   VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_ITEM_ID'       VALUE P_ITEM_ID,
            'P_DOM_EXP'       VALUE P_DOM_EXP,
            'P_FCST_TYPE'     VALUE P_FCST_TYPE,
            'P_INCOTERMS'     VALUE P_INCOTERMS,
            'P_MEASURE'       VALUE P_MEASURE,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_YYYYMMDD'      VALUE P_YYYYMMDD,
            'P_QTY'           VALUE P_QTY,
            'P_CREATED_BY'    VALUE P_CREATED_BY,
            'P_AS_FROM_SITE'  VALUE P_AS_FROM_SITE,
            'P_BUCKET'        VALUE P_BUCKET
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END DMF0003_SAVE_MKT_FCST;
/

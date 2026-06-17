CREATE OR REPLACE PROCEDURE           "DMF0003_GET_MKT_FCST_DATA"
    ( P_DIVISION_ID      IN  VARCHAR2
    , P_SCM_SITE_ID      IN  VARCHAR2
    , P_PLANT_SITE_ID    IN  VARCHAR2
    , P_TEAM_ID          IN  VARCHAR2
    , P_CUSTOMER         IN  VARCHAR2
    , P_BIZ_TYPE         IN  VARCHAR2
    , P_PROJECT_CODE     IN  VARCHAR2
    , P_ITEM_ID          IN  VARCHAR2
    , P_FROM_YYYYMMDD    IN  VARCHAR2
    , P_TO_YYYYMMDD      IN  VARCHAR2
    , P_CREATED_BY       IN  VARCHAR2
    , P_USER_GROUP       IN  VARCHAR2
    , P_ITEM_TYPE        IN  VARCHAR2
    , P_OWNER            IN  VARCHAR2
    , P_QTY_YN           IN  VARCHAR2
    , P_CELL_YN          IN  VARCHAR2
    , P_INVALID_EXEC     IN  VARCHAR2   -- [C20200612-000174] ESS사업부 New Model Flag
    , P_AS_YN            IN  VARCHAR2
    , P_USER_DEPT_ID     IN  VARCHAR2   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
    , P_SENDER_CODE      IN  VARCHAR2   -- SENDER_CODE 추가
    , P_USER_ID          IN VARCHAR2
    , P_MENU_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RC2              OUT SYS_REFCURSOR   -- 8주 이내 bucket 정보
    , O_RC3              OUT SYS_REFCURSOR   -- 현재 주차 정보
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR

    )
/*=====================================================================================================================================================
 * Program ID  : DMF0003_GET_MKT_FCST_DATA
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date				In Charge    Description
 *=====================================================================================================================================================
 * 2017.11.24		SongDH		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.14		KHSONG		BALANCE MEASURE 신규추가로 MINUS값까지 보여주기위하여 QTY <> 0 로 수정
 * 2018.05.30		JYE			복수 팀 권한 관련  수정
 * 2018.07.12		KHSONG		속도개선 수정버젼임
 * 2018.07.27		SonYoungSuk 컬럼 정렬 정보
 * 2018.07.30		SonYoungSuk 검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정
 * 2018.08.08		KHSONG		실적구간 중복되어 between 에서 수식으로 수정/p_from 변수사용
 * 2018.08.09		ytchoi		조건수정으로 속도개선
 * 2018.08.10		ytchoi		조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
 * 2018.08.09		JYE			멀티 오너 추가
 * 2018.08.13		JYE			Qty '0' 포함 추가
 * 2018.08.16		KHSONG		VALID_YN 조건추가
 * 2018.08.23		JYE			멀티 오너에 대한 수정 권한 수정. 신규 함수 적용.
 * 2018.09.04		JYE			멀티 오너에 대한 수정 권한 변경 수정 -- 주석처리.20180912
 * 2018.09.11		SonYoungSuk 조회 컬럼 CELL_TYPE 추가 #TEMP_DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회
 * 2018.09.28		JYE			RTF 수정 불가 처리
 * 2018.10.04		SonYoungSuk MEASURE VMI_IN_Req, VMI_IN_Plan Edit 가능
 * 2018.11.01		khsong		특정기간(20181101-20190531) 조회시 에러발생으로 BUCKET_PER null조건추가
 * 2018.11.02					속도개선을 의해서 추가
 * 2018.11.14		JYE			Cell Qty 환산 추가
 * 2018.11.15		JYE			소형 사업부 8주 이내는 일별로만 입력되도록
 * 2018.12.21		KHSONG		PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS 참조하여 주석처리함
 * 2019.01.18		KHSONG		중복제거위한 DISTINCT추가
 * 2019.01.21		KHSONG		MERGE 추가
 * 2019.01.23		KHSONG		전지재료DIV설정 (''42'',''44'') -> 20190624 모두 제거함
 * 2019.02.13		KHSONG		[CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건
 * 2019.02.14		JYE			정렬 쿼리에 디비전 조건 추가
 * ----------------------------------------------------------------------------------------
 * 20190219 KHSONG JOIN 조건 위로 올려서 속도개선한 버전
 * ----------------------------------------------------------------------------------------
 * 2019.02.19		KHSONG		숫자가 아닌 MEASURE는 FORECAST_INFO_CELL_PACK_COUNT로 곱하지 않도록 수정
 * 2019.03.08		KHSONG		[CSR ID:3940493] MKT FcstUI상 Shipping Plan Measure 추가 (SHIPMENT_PLAN)
 * 2019.03.22		KHSONG		고객군, 판매처 컬럼 NULL처리조건 추가
 * 2019.04.01		KHSONG		81,82인경우 PROJECT_CODE 를 출력하면 GROUP이 묶이지 않으므로 END_CUSTOMER 출력으로 변경함
 * 2019.04.19		KHSONG		[CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
 * 2019.06.24		KHSONG		[CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용
 * 2019.07.04		KHSONG		ITEM_ID = ('MCCM346010A1,MCCM346010A1-D06') 이렇게 조회시 두배로 보이는 현상으로 재 GROUP
 * 2019.07.05		KHSONG		[CSR ID:4023158] Column / Measure 추가 Setting 요청건 (Column 3개 : Cell/Module , Cell/Car , Module/Car) (Measure 4개:MKT_FCST_RP_CAR,MKT_FCST_RP_CELL,RTF_RP_CAR,RTF_RP_CELL)
 * 2019.02.14		JYE			Warranty 용도 권한 추가
 * 2019.08.09		KHSONG		[CSR ID:4059971] VMI-In Request 로직 변경 -> ESS 사업부 별도추가 필요없음
 * 2019.10.02		KHSONG		조회시 DB Lock 현상으로 로직수정
 * 2019.10.29		KYH			Shipment_Plan 관련 MKT_FCST 의 기간조건 제거
 * 2019.11.18		KHSONG		[CSR ID:C20191031-000137] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
 * 2019.11.19		KHSONG		Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
 * 2020.01.30		KHSONG		[C20200114-000201] ESS사업부 ENERGE, CELL_QUANTITY 컬럼/Measure추가
 * 2020.02.17		KHSONG		C20200103-000586 'SCM PI Admin' ADD
 * 2020.02.18		KHSONG		C20200212-000304 : GSCM 차량대수 환산 오류 개선 요청 건
 * 2020.02.25		KHSONG		C20200221-000056 Sales plan waterfall 차량대수 환산 logic 변경 요청 RTF MEASURE 삭제
 * 2020.03.09		KHSONG		C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
 * 2020.03.11		KHSONG		C20200103-000586 권한그룹을 LOOKUP관리
 * 2020.06.05		P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
 * 2020.06.18		P.C.I		[C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터
 * 2020.07.02		P.C.I		[C20200702-000136] Sales Price check시 currency 제외, new_flag 추가
 * 2020.07.16		HWI1993		[C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가
 * 2020.07.23		P.C.I		[prepare] MKT_FCST_RP 실적 구간 변경(현재 기준 전주 일요일까지)
 * 2020.08.31		hwi1993		[C20200812-000104] [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경
 * 2020.10.15		hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
 * 2020.11.13		hwi1993		개발에서 ssp sync 작업한 버전을 [DMF0003_GET_MKT_FCST_DATA_SSP_SYNC_작업분] 으로 백업하고, 운영에서 새로 내려받음
 * 2020.11.13		hwi1993		[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건
 * 2020.11.27		hwi1993		[C20201103-000114]. Sales Price 기반으로 데이터 가져오는 부분에서는 VMI 메저 강제추가 제거함.
 * 2020.12.15		hwi1993		[C20201105-000099] 오류 데이터 삭제요청 -- ESS 의 경우 Future Price 를 참조할 때 FCST_TYPE = '' 인 것들 제외
 * 2020.12.28		HWI1993		[C20200804-000123] MKT FCST - SSP 동기화
 * 2021.01.14		HWI1993		[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( ATP 메저 보완 )
 * 2021.02.26		P.C.I		[C20210225-000385] 동기화 기준은 ATTRIBUTE4, ATTRIBUTE5으로 구분
 * 2021.05.12		hwi1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - ESS 상품 PR
 * 2021.05.17		HWI1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - 중장기계획
 * 2021.06.18		HWI1993		[PJ20209642R] PR REQUEST 에 원재료 추가
 * 2021.08.10		hwi1993		[C20210810-000268] 메저 순서 변경 시 오류 발생
 * 2021.08.24		HWI1993		[과제]_BOD 유효기간 추가
 * 2021.09.01		SJHAN		[C20210827-000130] GSCM내 VMI inventory값 표시 변경 요청
 * 2021.09.15		SJHAN		[PJ20209643]-속도개선
 * 2021.09.17		hwi1993		[PJ20209643] AS 프로세스
 * 2021.11.02		hwi1993		[PJ20209643] AS 프로세스 - balance 메저 표시방법 변경, 룩업 컬럼 변경
 * 2021.11.17		hwi1993		[PJ20209643] 성능개선 - hash 옵션 추가 등
 * 2021.11.18		kdw2819		[과제]_자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021.11.19		ROSIA27		[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021.11.30		rosia27		[C20211122-000414]
속도개선을 위한 색구현 및 조회조건 변경안
 * 2021.12.07		rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2021.12.15		kdw2819		[C20211215-000076] 1년 이상 조회기간을 설정하여도 가능하도록 변경 건
 * 2022.01.06		hwi1993		[] sales_type_code 룩업의 as 전용 fcst type 을 사용할수 없게 되어서, as 구분방법 변경
								( 고객향은 attribute10, 플랜트향은 scm_site_id 이용 )
 * 2022.02.07		kdw2819		[C20220125-000192] MKT FSCT 상 From stie 표기 요청의 건
 * 2022.02.24		HWI1993		[C20220218-000409] GSCM-DM AS Inventory 메저 계산 로직 수정 -- INV 메저 표시방법 변경, INTRANSIT 메저의 ATTR10 오류 수정
 * 2022.04.05		rosia27		[과제PJ20216891R]GM_JV
 * 2022.12.14		rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023.03.13		rosia27		[E20230308-000315] [시스템 오류] Owner 조회조건 수정 요청 건
 * 2023.05.03		kdmcc14		[EDI과제]
 * 2023.08.25		JSSBAE		[E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청(LOOKUP이용)
 * 2023.10.19		JSSBAE		[E20231018-000776]_[영업/마케팅 PI팀] MKT FCST 화면 SHIPMENT_PLAN 메저 로직 수정 프로그램 화면 내 메져의 VALID가 Y인 대상만 나오도록 수정
 * 2023.11.21		chano0612	[고객수요분석시스템 정비] EDI데이터 중복건 제거
 * 2023.12.07		kcw3408		[개발요청] 수요분석시스템_4_고객수요 Measure 통합
 * 2024.01.15		JSSBAE		[E20240102-000545] [마케팅PI] 82번 사업부 - VMI표기 로직 개선
 * 2024.03.07       kcw3408     DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
 * 2024.05.17       kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024.07.18		JSSBAE		[E20240712-001683]_'MKT FCST 미등록제외' 관련 소스 수정
 * 2024.08.02		JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024.09.05		JSSBAE		[E20240812-000094]_82사업부 MKT FCST 화면 Energy Measure 소수점 자리수 수정 요청
 * 2024.08.27		KJJ			[PJ2024-50461] Team Mapping
 * 2024.09.12		JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.11.04		JSSBAE		[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건
 *                              SSPM에 신규 추가 요청드린 'Project(S&OP Report)' 컬럼 MKT FCST Waterfall 사용자 화면에 추가 요청
 * 2024.11.12		JSSBAE		[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건
 * 2024.12.04		JSSBAE		[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
 * 2025.07.07		KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.01.23		JSSBAE		[E20260123-001715]_E20241015-000415 CSR 원복 요청
 * 2026.02.20		JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
 * 2026.04.13       kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                                  SCM_MST_SITE_ITEM Table PROJECT_S_OP_REPORT Column 삭제에 따라 컬럼 사용 문장 삭제
 *                                  ORA-01799: a column may not be outer-joined to a subquery 방지용으로 불필요한 outer join 제거
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='40', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='81', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='82', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
 *===================================================================================================================================================*/
-- 2026-05-11 전병주 컴파일 오류 수정
AS
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME      VARCHAR2(150);

    -- 동적 SQL / PIVOT 관련
    V_SQL_TEXT          CLOB;
    V_PV_LIST           CLOB    := '';
    V_PV_COL_LIST       CLOB    := '';
    V_PV_COLUMN_NAME    VARCHAR2(1000);
    V_PV_NAME           VARCHAR2(200);
    V_SORT_ORDER_NO     VARCHAR2(50);
    V_COLUMN_NAME       VARCHAR2(100);
    V_COLUMN            CLOB    := '';
    V_GROUPBY           CLOB    := '';
    V_ORDERBY           CLOB    := '';

    -- 프로그램 / 시트 고정값
    VA_PROGRAM_ID       VARCHAR2(50)  := 'DMF0003';
    VA_SHEET_NAME       VARCHAR2(50)  := 'main';

    -- 권한 / 부서
    V_GROUP_ID          VARCHAR2(50)  := '';
    V_DEPT_ID           VARCHAR2(50)  := '';

    -- 조회 구간 날짜 변수
    V_EXP_YYYYMMDD      VARCHAR2(8);
    V_FROM_YYYYMMDD     VARCHAR2(8)   := '';   -- 계획 구간 FROM (당주 월요일 기준)
    V_TO_YYYYMMDD       VARCHAR2(8)   := '';   -- 계획 구간 TO
    V_FROM_RESULT       VARCHAR2(8)   := '';   -- 실적 구간 FROM
    V_TO_RESULT         VARCHAR2(8)   := '';   -- 실적 구간 TO
    V_USER_TIME_ZONE    VARCHAR2(50)  := '';

    -- 사용자 컬럼/메저 카운트
    V_USER_COL_CNT      PLS_INTEGER   := 0;
    V_USER_MEA_CNT      PLS_INTEGER   := 0;

    -- IN 파라미터를 로컬 복사본으로 사용 (IN 파라미터 직접 수정 불가)
    LP_AS_YN            VARCHAR2(1);
    LP_SCM_SITE_ID      VARCHAR2(4000);
    LP_PROJECT_CODE     VARCHAR2(4000);

    -- 팀 WHERE 조건 (동적 SQL에 삽입)
    V_TEAM_WHERE        VARCHAR2(4000);

    -- 예외처리 / 로그 변수
    V_LOG_TYPE          VARCHAR2(30);
    V_LOG_MESSAGE       VARCHAR2(1000);
    V_DESCRIPTION       VARCHAR2(500);
    D_EVENT_DATE        DATE;
    V_SQL_CODE          VARCHAR2(20);
    V_SQL_ERRMSG        VARCHAR2(4000);
    V_BACKTRACE         VARCHAR2(4000);
    V_PROC_INPUT        CLOB;

    -- T_SSP_SYNC 컬렉션용
    T_SCM_SITE_IDS      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();

BEGIN
    -----------------------------------------------------------------------
    -- 프로그램명 설정
    -----------------------------------------------------------------------
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- IN 파라미터 로컬 복사
    LP_AS_YN        := P_AS_YN;
    LP_SCM_SITE_ID  := P_SCM_SITE_ID;
    LP_PROJECT_CODE := P_PROJECT_CODE;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    -----------------------------------------------------------------------
    -- GTT 초기화 (세션 재사용 시 이전 데이터 제거)
    -----------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_GGET_T_SSP_SYNC;
    DELETE FROM SCM_MGR.GT_GGET_T_BNP;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_ORI;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_A;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_B;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE;
    DELETE FROM SCM_MGR.GT_GGET_VMI_DIO;
    DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM_ALL;
    DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM;
    DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
    DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DST;
    DELETE FROM SCM_MGR.GT_GGET_SALES_PRICE;
    DELETE FROM SCM_MGR.GT_GGET_EDI_SENDER;
    DELETE FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP;
    DELETE FROM SCM_MGR.GT_GGET_EDI_END_CUST;
    DELETE FROM SCM_MGR.GT_GGET_RPA_END_CUST;
    DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_RESULT;
    DELETE FROM SCM_MGR.GT_GGET_MF;
    DELETE FROM SCM_MGR.GT_GGET_CAL_MONTH_END;
    DELETE FROM SCM_MGR.GT_GGET_CAL_WEEK_END;
    DELETE FROM SCM_MGR.GT_GGET_SHIPMENT_PLAN;
    DELETE FROM SCM_MGR.GT_GGET_INTRANSIT_DATA;
    DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
    DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;
    -- ============================================================
    -- ⭐ Phase 3 (2026-06-16): GT_GGET_SPLIT_* 사전 적재 (룰 2+6)
    --   SP body 시작 시점 (GT cleanup 직후) 에 11 SPLIT GT INSERT.
    --   룰 6: 'ALL' / '%' / '' / NULL 시 INSERT skip → 후속 SELECT EXISTS short-circuit.
    --   매개변수 인벤토리 (DMF0003 11개):
    --     P_ITEM_ID, P_PROJECT_CODE (=LP_PROJECT_CODE), P_SCM_SITE_ID (=LP_SCM_SITE_ID),
    --     P_PLANT_SITE_ID, P_TEAM_ID, P_CUSTOMER, P_BIZ_TYPE, P_ITEM_TYPE,
    --     P_OWNER, P_SENDER_CODE
    -- ============================================================

    -- 기존 SPLIT GT 잔존 row cleanup (멱등)
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_PLANT_SITE_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_TEAM_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_CUSTOMER;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_BIZ_TYPE;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_TYPE;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_OWNER;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_SENDER_CODE;
    DELETE FROM SCM_MGR.GT_GGET_OWNER_TOKEN;

    -- P_ITEM_ID
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_ITEM_ID IS NOT NULL AND P_ITEM_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- LP_PROJECT_CODE (P_PROJECT_CODE 의 사본)
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  LP_PROJECT_CODE IS NOT NULL AND LP_PROJECT_CODE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL;

    -- LP_SCM_SITE_ID (P_SCM_SITE_ID 의 사본)
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  LP_SCM_SITE_ID IS NOT NULL AND LP_SCM_SITE_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_PLANT_SITE_ID
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_PLANT_SITE_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_PLANT_SITE_ID IS NOT NULL AND P_PLANT_SITE_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_TEAM_ID
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_TEAM_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_TEAM_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_TEAM_ID IS NOT NULL AND P_TEAM_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_TEAM_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_CUSTOMER
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_CUSTOMER (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_CUSTOMER IS NOT NULL AND P_CUSTOMER NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_BIZ_TYPE
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_BIZ_TYPE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_BIZ_TYPE IS NOT NULL AND P_BIZ_TYPE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_ITEM_TYPE
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_TYPE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_ITEM_TYPE IS NOT NULL AND P_ITEM_TYPE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_OWNER
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_OWNER (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_OWNER IS NOT NULL AND P_OWNER NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_SENDER_CODE
    INSERT INTO SCM_MGR.GT_GGET_SPLIT_SENDER_CODE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_SENDER_CODE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_SENDER_CODE IS NOT NULL AND P_SENDER_CODE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_SENDER_CODE,'[^,]+',1,LEVEL) IS NOT NULL;

    -----------------------------------------------------------------------
    -- 권한그룹 LOOKUP 관리 [20200311 KHSONG C20200103-000586]
    -----------------------------------------------------------------------
    DECLARE
        V_ADMIN_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(1),0) INTO V_ADMIN_CNT
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
          AND  VALID_YN    = 'Y'
          AND  SEGMENT2   IN ('ALL','DMF0003')
          AND  SEGMENT1    = P_USER_GROUP;
        IF V_ADMIN_CNT > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    END;

    -----------------------------------------------------------------------
    -- 조회 만료 기준 계산 (from + 40주)
    -- SM임시작업 20240621 화면 장애 오류로 인하여 임시조치
    -----------------------------------------------------------------------
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD') + 40*7, 'YYYYMMDD');

    -----------------------------------------------------------------------
    -- 버킷 컬럼 목록 동적 생성 (일별 D_, 주별 W_, 월별 M_)
    -- CURSOR FAST_FORWARD → FOR LOOP
    -----------------------------------------------------------------------
    FOR R IN (
        SELECT 'D_' || A.BASIS_YYYYMMDD || ' AS D_' || A.BASIS_YYYYMMDD     AS COLUMN_NAME
             , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD AS PV_NAME
             , A.BASIS_YYYYMMDD || '_31'                                    AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
             , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
             , A.BASIS_START_DATE || '_21'
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM || ' AS M_' || A.BASIS_YYYYMM
             , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM
             , MIN(A.BASIS_START_DATE) || '_01'
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM
        ORDER BY 3 -- SORT_ORDER_NO -- 컴파일 오류로 번호로 변경
    )
    LOOP
        IF V_PV_COL_LIST IS NULL OR V_PV_COL_LIST = '' THEN
            V_PV_COL_LIST := R.COLUMN_NAME;
            V_PV_LIST     := R.PV_NAME;
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || R.COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || R.PV_NAME;
        END IF;
    END LOOP;

    -----------------------------------------------------------------------
    -- 사용자 컬럼 초기화 처리
    -----------------------------------------------------------------------
    V_COLUMN_NAME  := '';
    V_COLUMN       := '';
    V_GROUPBY      := '';
    V_USER_COL_CNT := 0;
    V_USER_MEA_CNT := 0;

    -- 사용자 컬럼 존재 여부 확인
    SELECT COUNT(1) INTO V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
      AND  U.SHEET_NAME                    = VA_SHEET_NAME
      AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
      AND  U.USER_ID                       = P_CREATED_BY;

    IF V_USER_COL_CNT = 0 THEN
        -- 사용자 컬럼이 없으면 기본값으로 복사
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'C'
             , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
             , P_CREATED_BY, SYSDATE
             , P_CREATED_BY, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
          AND  C.SHEET_NAME   = VA_SHEET_NAME
          AND  C.DEFAULT_FLAG = 'Y'
          AND  C.VALID_YN     = 'Y';

          COMMIT WORK;
    END IF;

    -- 사용자 메저 존재 여부 확인
    SELECT COUNT(1) INTO V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
      AND  U.SHEET_NAME                    = VA_SHEET_NAME
      AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
      AND  U.USER_ID                       = P_CREATED_BY;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'M'
             , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
             , P_CREATED_BY, SYSDATE
             , P_CREATED_BY, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
          AND  C.SHEET_NAME   = VA_SHEET_NAME
          AND  C.DEFAULT_FLAG = 'Y'
          AND  C.VALID_YN     = 'Y';

          COMMIT WORK;
    END IF;

    -----------------------------------------------------------------------
    -- 컬럼/정렬 문자열 동적 조립
    -- CURSOR FAST_FORWARD c_title → FOR LOOP
    -----------------------------------------------------------------------
    FOR R IN (
        SELECT U.COLUMN_NAME
             , U.SORT_ORDER_NO
        FROM  ( SELECT U.COLUMN_NAME
                     , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                            WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                            ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
                FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                     , SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  U.PROGRAM_ID  = C.PROGRAM_ID
                  AND  U.SHEET_NAME  = C.SHEET_NAME
                  AND  U.COLUMN_NAME = C.COLUMN_NAME
                  AND  U.PROGRAM_ID  = VA_PROGRAM_ID
                  AND  U.SHEET_NAME  = VA_SHEET_NAME
                  AND  U.USER_ID     = P_CREATED_BY
                  AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                UNION ALL
                -- 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID 추가
                SELECT C.COLUMN_NAME
                     , CASE WHEN C.COLUMN_NAME = 'GROUP_ID'
                            THEN TO_CHAR(NVL(U.SORT_ORDER_NO,85) - 0.5)
                            ELSE TO_CHAR(C.SORT_ORDER_NO) END AS SORT_ORDER_NO
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                LEFT   OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
                  ON   U.PROGRAM_ID  = C.PROGRAM_ID
                 AND   U.SHEET_NAME  = C.SHEET_NAME
                 AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                 AND   U.COLUMN_NAME IN ('ITEM_ID')
                 AND   U.USER_ID     = P_CREATED_BY
                WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
                  AND  C.SHEET_NAME   = VA_SHEET_NAME
                  AND  ( C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' '  OR C.DEFAULT_FLAG = '' )
                  AND  C.VALID_YN     = 'Y' ) U
        ORDER BY TO_NUMBER(U.SORT_ORDER_NO)
    )
    LOOP
        IF V_COLUMN IS NULL OR V_COLUMN = '' THEN
            V_COLUMN  := R.COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || R.COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, '
                      || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
                               THEN R.COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || R.COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || R.COLUMN_NAME;
            V_ORDERBY := V_ORDERBY
                      || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
                               THEN ', ' || R.COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;

    -- [E20240812-000094] NOTATION 컬럼 추가
    V_COLUMN  := V_COLUMN  || ',NOTATION';
    V_GROUPBY := V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO';
    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');

    -----------------------------------------------------------------------
    -- 사용자 시차(TIMEZONE) 조회
    -----------------------------------------------------------------------
    BEGIN
        SELECT U.TMZ_CD INTO V_USER_TIME_ZONE
        FROM   SCM_MGR.SCM_ADM_USER_M U
        WHERE  U.USER_ID = P_CREATED_BY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := '';
    END;

    -----------------------------------------------------------------------
    -- 계획/실적 기준 날짜 계산
    -----------------------------------------------------------------------
    -- @v_from_yyyymmdd : (User 시차 고려) 당주 월요일
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD) INTO V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
             , ( SELECT DISTINCT ISO_YYYYWW
                 FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                 WHERE  BASIS_YYYYMMDD =
                        TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE),'YYYYMMDD')
               ) T
        WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := TO_CHAR(SYSDATE,'YYYYMMDD');
    END;

    -- From 실적 : From 조회 구간 월요일
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT := '';
    END;

    -- To 실적 : To 조회 구간 월요일 전까지
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := '';
    END;

    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
        -- 실적 보여줌
        V_TO_YYYYMMDD := P_TO_YYYYMMDD;
        V_TO_RESULT   := V_FROM_YYYYMMDD;  -- To 실적 : 당주 월요일 전까지
    ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := P_TO_YYYYMMDD;
        V_FROM_RESULT := '19000101';
        V_TO_RESULT   := '19000101';
    ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
        -- 실적만 보여줌
        V_FROM_YYYYMMDD := '19000101';
        V_TO_YYYYMMDD   := '19000101';
        V_FROM_RESULT   := P_FROM_YYYYMMDD;
        V_TO_RESULT     := P_TO_YYYYMMDD;
    ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
        V_FROM_RESULT := P_FROM_YYYYMMDD;
        V_TO_RESULT   := P_TO_YYYYMMDD;
    END IF;

    -----------------------------------------------------------------------
    -- [E20260211-001189] 조회 SALES SITE 중 AS용 데이터가 있으면 AS_YN = 'Y'로 처리
    -- TABLE()은 컬렉션 변수만 허용 → 먼저 변수에 COLLECT 후 참조
    -----------------------------------------------------------------------
    DECLARE
        V_AS_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT CAST(
                   COLLECT(DISTINCT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)))
               AS SCM_MGR.T_STR_TAB)
        INTO   T_SCM_SITE_IDS
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;

        SELECT COUNT(DISTINCT A.COLUMN_VALUE) INTO V_AS_CNT
        FROM   TABLE(T_SCM_SITE_IDS) A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.COLUMN_VALUE = B.SEGMENT1
         AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT';

        IF V_AS_CNT > 0 THEN
            LP_AS_YN := 'Y';
        END IF;
    END;
    -- [E20260211-001189] END

    -----------------------------------------------------------------------
    -- [C20200804-000123] SSP 동기화 / BNP 데이터 수집
    -----------------------------------------------------------------------
    -- Division 40: DM_PLN_MKT_FCST 기반 PIVOT → GT_GGET_T_SSP_SYNC
    IF P_DIVISION_ID = '40' THEN
        INSERT INTO SCM_MGR.GT_GGET_T_SSP_SYNC
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
            || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
            || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
            || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
            || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
            || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
            || '^' || NVL(A31,'') AS ATTR1
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
                 , YYYYMMDD || '/'
                   || CASE
                          WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                           AND A.QTY >
                               CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                                    THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
                             + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
                                    THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
                          THEN 'P'
                          ELSE 'A'
                      END AS SYNC_YN
                 , 'A' || TO_CHAR(
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                        DOM_EXP, A.FCST_TYPE, INCOTERMS
                           ORDER BY YYYYMMDD
                       )) AS ROW_NUM
            FROM   SCM_MGR.DM_PLN_MKT_FCST A
            -- [E20260211-001189] #T_WS_FCST JOIN 주석처리된 원본 그대로 반영
            WHERE  A.DIVISION_ID = P_DIVISION_ID
              AND  A.MEASURE     = 'MKT_FCST'
              AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
              AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')  -- [C20210225-000385]
              AND  A.QTY <> 0
              AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
                          ELSE A.SCM_SITE_ID END
                     IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
              AND  ( LP_PROJECT_CODE IS NULL
                     OR CASE WHEN LP_PROJECT_CODE = '' THEN LP_PROJECT_CODE
                          ELSE A.PROJECT_CODE END
                     IN (SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL) )
              AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID
                          ELSE A.PLANT_SITE_ID END
                     IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
        ) A
        PIVOT (
            MAX(SYNC_YN) FOR ROW_NUM IN (
                'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                'A31' A31
            )
        );

    -- Division 82: DM_PLN_PR_DETAIL 기반 PIVOT → GT_GGET_T_BNP [PJ20209642R]
    ELSIF P_DIVISION_ID = '82' THEN
        INSERT INTO SCM_MGR.GT_GGET_T_BNP
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
            || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
            || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
            || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
            || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
            || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
            || '^' || NVL(A31,'') AS ATTR1
        FROM (
            SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                            DOM_EXP, FCST_TYPE, INCOTERMS
                 , YYYYMMDD || '/A' AS SYNC_YN
                 , 'A' || TO_CHAR(
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                        DOM_EXP, FCST_TYPE, INCOTERMS
                           ORDER BY YYYYMMDD
                       )) AS ROW_NUM
            FROM   SCM_MGR.DM_PLN_PR_DETAIL A
            WHERE  A.DIVISION_ID = P_DIVISION_ID
              AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        ) A
        PIVOT (
            MAX(SYNC_YN) FOR ROW_NUM IN (
                'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                'A31' A31
            )
        );
    END IF;
    -- [C20200804-000123] 끝

    -----------------------------------------------------------------------
    -- [E20240920-000300] ITEM_SINGLE_V 속도 개선 - 3단계로 나눠서 INSERT
    -----------------------------------------------------------------------
    -- Step 1: SCM_MST_ITEM_SN 전체를 GT_GGET_ITEM_SINGLE_ORI에 적재
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
    , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
         , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
         , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    FROM   SCM_MGR.SCM_MST_ITEM_SN
    WHERE  DIVISION_ID = P_DIVISION_ID
      AND  ACTIVE_FLAG = 'Y';

    -- Step 2A: 기본 컬럼 GROUP BY → GT_GGET_ITEM_SINGLE_A
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_A
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)
         , MAX(T1.ITEM_CLASS)
         , MAX(T1.ITEM_CLASS_NAME)
         , MAX(T1.NICK_NAME)
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END)
               WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END
         , MAX(T1.MATERIAL_CLASS_NAME)
         , MAX(T1.ITEM_UOM)
         , MAX(T1.SPEC)
         , MAX(T1.MDM_PROJECT_NAME)
         , MAX(T1.MIN_CAPACITY)
         , MAX(T1.ACTIVE_FLAG)
         , MAX(T1.ENERGE)
         , MAX(T1.CELL_QUANTITY)
         , MAX(T1.SCP_EXTRA_SPEC)
    FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI T1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

    -- Step 2B: FORECAST_INFO 계열 LEFT(12) 기준 집계 → GT_GGET_ITEM_SINGLE_B
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_B
    ( DIVISION_ID, ITEM_ID
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)
         , MAX(FORECAST_INFO_PRODUCT_GROUP)
         , MAX(FORECAST_INFO_CELL_MODEL)
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(FORECAST_INFO_SPEC)
         , MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_TYPE)
    FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

    -- Step 3: A+B JOIN 후 ITEM_ID/NICK_NAME LIKE 필터 적용 → GT_GGET_ITEM_SINGLE_V
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_V
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID, T1.ITEM_ID
         , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
         , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
         , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
         , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_A T1
    JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_B T2
      ON   T1.DIVISION_ID          = T2.DIVISION_ID
     AND   SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
    WHERE  T1.DIVISION_ID = P_DIVISION_ID
      AND  EXISTS (
               SELECT 1
               FROM (
                   SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' AS TST
                   FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
               ) B
               WHERE T1.ITEM_ID   LIKE B.TST
                  OR T1.NICK_NAME LIKE B.TST
           )
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
           , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
           , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
           , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
           , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
           , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC;

    -- [E20240731-000856] Wh → KWh 환산
    UPDATE SCM_MGR.GT_GGET_ITEM_SINGLE_V
    SET    ENERGE = CASE WHEN REGEXP_LIKE(NVL(ENERGE,'X'),'^[0-9.]+$')
                         THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE)/1000, 4))
                         ELSE NULL END;

    -----------------------------------------------------------------------
    -- GT_GGET_SELECT_MEASURE 수집
    -- [C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
    SELECT DISTINCT U.PROGRAM_ID
                  , U.SHEET_NAME
                  , U.USER_ID
                  , CASE WHEN U.COLUMN_NAME IN ('CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO')
                         THEN 'CUST. PSI'
                         WHEN U.COLUMN_NAME IN ('MKT_INV_I','MKT_PRODUCT_S','MKT_WHIN_P','MKT_DIO')
                         THEN 'MKT PSI'
                         ELSE U.COLUMN_NAME END AS MEASURE_GROUP
                  , U.COLUMN_NAME AS MEASURE
                  , CASE WHEN U.COLUMN_NAME IN ('CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG')
                         THEN SMSM.SORT_ORDER_NO   -- 20231212 kcw3408 4_고객수요 Measure 통합
                         ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
      ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID
     AND   U.SHEET_NAME  = SMSM.SHEET_NAME
     AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
     AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
     AND   SMSM.VALID_YN = 'Y'
    LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
      ON   U.USER_ID    = T.SEGMENT4     -- 20200309 KHSONG TMM MEASURE 권한추가
     AND   P_CREATED_BY = T.SEGMENT4
     AND   T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
     AND   T.VALID_YN    = 'Y'
    WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
      AND  U.PROGRAM_ID = 'DMF0003'
      AND  U.SHEET_NAME = 'main'
      AND  U.USER_ID    = P_CREATED_BY
      AND  U.USER_ID    = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4
                               ELSE P_CREATED_BY END
    -----------------------------------------------------------------------
    -- [20191118 KHSONG CSR ID:C20191031-000137] CUST_FCST_EDI 계열 sub-measure 추가
    -----------------------------------------------------------------------
    UNION ALL
    SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
         , A.SORT_ORDER_NO + B.SORT_ORDER_NO
    FROM (
        SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID
             -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
             , 'CUST_FCST' AS MEASURE_GROUP
             , SMSM.SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
          ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
         AND   SMSM.VALID_YN = 'Y'
        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
          AND  U.PROGRAM_ID  = 'DMF0003'
          AND  U.SHEET_NAME  = 'main'
          AND  U.USER_ID     = P_CREATED_BY
          -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
          AND  U.COLUMN_NAME = 'CUST_FCST'
    ) A,
    (
        -- [E20241126-000426] CUST_FCST_EDI 추가 및 순서 변경
        SELECT 'Immidiate'                   AS MEASURE, 0.15 AS SORT_ORDER_NO FROM DUAL UNION ALL
        SELECT 'Planning_Forecast'                      , 0.18 FROM DUAL UNION ALL
        SELECT 'Commercial_Agreement'                   , 0.13 FROM DUAL UNION ALL
        SELECT 'Firm_Temp'                              , 0.14 FROM DUAL UNION ALL
        SELECT 'Manumacturing_Material_Temp'            , 0.16 FROM DUAL UNION ALL
        SELECT 'Material_Temp'                          , 0.17 FROM DUAL UNION ALL
        SELECT 'Backorder'                              , 0.12 FROM DUAL UNION ALL
        SELECT 'CUST_FCST_EDI'                          , 0.11 FROM DUAL
    ) B
    GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
           , A.SORT_ORDER_NO + B.SORT_ORDER_NO
    -----------------------------------------------------------------------
    -- CUST_FCST_2 : DM_MST_CUSTOMER_FCST 기반 동적 Measure
    -----------------------------------------------------------------------
    UNION ALL
    SELECT DISTINCT 'DMF0003'   AS PROGRAM_ID
                  , 'main'  AS SHEET_NAME
                  , P_CREATED_BY AS USER_ID
                  , 'CUST_FCST_2' AS MEASURE_GROUP
                  , C.MEASURE
                  ,
                      ( SELECT SMSM.SORT_ORDER_NO
                        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                          ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
                         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
                         AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
                        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'main'
                          AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST' )
                      + 0.1
                     AS SORT_ORDER_NO
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE  C.MEASURE_GROUP = 'CUST_FCST'
      AND  NVL(C.MEASURE,'-') <> '-'
      AND  C.VALID_YN = 'Y'
      AND  EXISTS (
               SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
               WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'main'
                 AND  X.USER_ID    = P_CREATED_BY
                 AND  X.COLUMN_NAME = 'CUST_FCST' AND X.COLUMN_NAME = C.MEASURE_GROUP
           )
    -----------------------------------------------------------------------
    -- CUST_FCST_3 : Customer Fcst[Org.] 고정 Measure
    -----------------------------------------------------------------------
    UNION ALL
    SELECT DISTINCT 'DMF0003', 'main', P_CREATED_BY
                  , 'CUST_FCST_3', 'Customer Fcst[Org.]'
                  ,
                      ( SELECT SMSM.SORT_ORDER_NO
                        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                          ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
                         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
                         AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
                        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'main'
                          AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST_ORG' )
                      + 0.1
                     AS SORT_ORDER_NO
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE  C.MEASURE_GROUP = 'CUST_FCST'
      AND  NVL(C.MEASURE,'-') <> '-'
      AND  C.VALID_YN = 'Y'
      AND  EXISTS (
               SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
               WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'main'
                 AND  X.USER_ID    = P_CREATED_BY AND X.COLUMN_NAME = 'CUST_FCST_ORG'
           );

    -----------------------------------------------------------------------
    -- [C20201103-000114] Division 82: MKT_FCST_RP 선택 시 VMI 관련 메저 강제 추가
    -----------------------------------------------------------------------
    DECLARE
        V_MKT_RP_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_MKT_RP_CNT
        FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
        WHERE  MEASURE = 'MKT_FCST_RP';

        IF V_MKT_RP_CNT > 0 AND P_DIVISION_ID = '82' THEN
            -- 순서 조정을 위해 기존 항목 제거 후 재삽입
            DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_SYS_RP','VMI_IN_PLAN','VMI_IN_REQ','VMI_INV');

            INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
            ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
            SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID
                 , B.MEASURE_GROUP, B.MEASURE
                 , REPLACE(A.SORT_ORDER_NO, '.0', B.SORTKEY)
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
            JOIN   (
                       SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' AS SORTKEY FROM DUAL UNION ALL
                       SELECT 'VMI_In_Plan'               , 'VMI_In_Plan'               , '.2' FROM DUAL UNION ALL
                       SELECT 'VMI_In_Req'                , 'VMI_In_Req'                , '.3' FROM DUAL UNION ALL
                       SELECT 'VMI_Inv'                   , 'VMI_Inv'                   , '.4' FROM DUAL
                   ) B ON 1=1
            WHERE  A.MEASURE = 'MKT_FCST_RP';
        END IF;
    END;

    -- MKT FCST 메저 순서 변경
    UPDATE SCM_MGR.GT_GGET_SELECT_MEASURE
    SET    SORT_ORDER_NO = REPLACE(SORT_ORDER_NO, '.0', '.9')
    WHERE  MEASURE = 'MKT_FCST_RP';

    -----------------------------------------------------------------------
    -- GT_GGET_VMI_DIO 수집
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '40' THEN
        INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_STD_DIO )
        SELECT A.ITEM_ID, A.VMI_STD_DIO
        FROM   SCM_MGR.SCP_MST_DIO A
        JOIN (
            SELECT DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN, MAX(YYYYMM) AS YYYYMM
            FROM   SCM_MGR.SCP_MST_DIO
            WHERE  DIVISION_ID = '40' AND TOTAL_YN = 'Y' AND PLANT_ID = '*'
            GROUP  BY DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
        ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
           AND A.ITEM_ID     = B.ITEM_ID     AND A.TOTAL_YN = B.TOTAL_YN
           AND A.YYYYMM      = B.YYYYMM
        WHERE  A.DIVISION_ID = '40' AND A.TOTAL_YN = 'Y' AND A.PLANT_ID = '*';

    ELSIF P_DIVISION_ID = '82' THEN   -- [C20201103-000114]
        INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_VAL )
        SELECT A.SCM_SITE_ID
             , A.VMI_YN || '^' || NVL(TO_CHAR(A.ATTRIBUTE5),'')
        FROM   SCM_MGR.SCM_MST_SITE A
        WHERE  DIVISION_ID = P_DIVISION_ID;
    END IF;

    -----------------------------------------------------------------------
    -- GT_GGET_SITE_ITEM_ALL 수집 (81/82 vs 40 분기)
    -----------------------------------------------------------------------
    IF P_DIVISION_ID LIKE '81%' OR P_DIVISION_ID = '82' THEN
        -- ============================================================
        -- ⭐ Phase 1 (2026-06-16): 6 룰 적용 — 99% bottleneck 영역
        --   - 룰 1: LISTAGG correlated subquery → FROM 절 OW LEFT JOIN
        --   - 룰 2: INNER JOIN B/C (LIKE split) 제거 → WHERE EXISTS GT_GGET_SPLIT_*
        --   - 룰 5: NVL(T2.FORECAST_INFO_CELL_MODEL,'')=T4.ITEM_ID → 직접 비교 (SARGable)
        --   - 룰 6: 'ALL'/'%'/'' 시 EXISTS skip (P_ITEM_ID / LP_PROJECT_CODE / P_OWNER)
        --
        -- 의미 1:1 보존 검증:
        --   - 'ALL' 시: Before LIKE '%ALL%' 0 row → 전체 제외 (FE 'ALL'=전체 의도 위반)
        --                After OR 분기 → 전체 row 통과 (정합 fix — 이전 사고 root cause)
        --   - 'specific' 시: Before/After 동일 (LIKE 매치 row 만 통과)
        -- ============================================================
        INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, T3.PROJECT_NAME
             , ''   AS CELL_MODEL      -- 20180809 ytchoi modify
             , T3.BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             -- ⭐ 룰 1: FROM 절 OW inline view 의 OWNER_NAME 참조 (correlated 제거)
             , OW.OWNER_NAME  AS OWNER
             , CASE WHEN F.DIVISION_ID NOT IN ('40') THEN T3.PROJECT_OWNER
                    ELSE J.USER_NAME_EN END AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , T3.PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE   -- 20180911 LookUp TABLE JOIN
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME  -- 20190419 KHSONG (SELECT 절 NVL 은 유지 — SARGable 무관)
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES    -- 20190213 KHSONG
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER -- 20190213 KHSONG
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM_DEPT.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE  -- [E20260123-001715] 원소스 복원
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        JOIN   SCM_MGR.SCM_MST_PROJECT T3
          ON   F.DIVISION_ID = T3.DIVISION_ID AND F.PROJECT_CODE = T3.PROJECT_CODE
        -- ⭐ 룰 2: INNER JOIN B/C (LIKE split cartesian) 제거 → WHERE EXISTS GT_GGET_SPLIT_*
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES' AND S.VALID_YN = 'Y'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        -- [PJ2024-50461] Team Mapping
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM_DEPT
          ON   TEAM.DEPT_ID = TEAM_DEPT.DEPT_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K ON J.DEPT_ID = K.DEPT_ID
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        -- ⭐ 룰 5: NVL(T2.X,'')=T4.ITEM_ID → 직접 비교 (T4.ITEM_ID NOT NULL 이라 NULL row 어차피 매치 X)
        LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID  -- 20190419 KHSONG (NVL 제거)
        -- ⭐ 룰 1: FROM 절 OW inline view — F.OWNER 사전 집계 (correlated 제거)
        LEFT   JOIN (
                        SELECT OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                             , LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN) AS OWNER_NAME
                        FROM (
                            SELECT FF.DIVISION_ID, FF.PROJECT_CODE, FF.SCM_SITE_ID, FF.ITEM_ID
                                 , TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) AS TOK
                            FROM   SCM_MGR.SCM_MST_SITE_ITEM FF
                            CROSS JOIN ( SELECT LEVEL AS LV
                                         FROM DUAL CONNECT BY LEVEL <= 30 ) HIER
                            WHERE  FF.DIVISION_ID = P_DIVISION_ID
                              AND  FF.OWNER IS NOT NULL
                              AND  TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) IS NOT NULL
                        ) OT
                        JOIN SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = OT.TOK
                        GROUP BY OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                    ) OW
          ON   F.DIVISION_ID  = OW.DIVISION_ID
         AND   F.PROJECT_CODE = OW.PROJECT_CODE
         AND   F.SCM_SITE_ID  = OW.SCM_SITE_ID
         AND   F.ITEM_ID      = OW.ITEM_ID
        WHERE  F.DIVISION_ID <> '40'   -- hard coding (20190123 KHSONG)
          AND  F.DIVISION_ID = P_DIVISION_ID
          -- [E20260211-001189] SCM_SITE_ID 조건 주석처리
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE S.END_CUSTOMER END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      ELSE T3.BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- ⭐ 룰 6: P_OWNER 'ALL' 분기 추가 + EXISTS GT_GGET_SPLIT_OWNER
          AND  ( P_OWNER IS NULL OR P_OWNER IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_OWNER O WHERE F.OWNER = O.TOK) )
          -- ⭐ 룰 2+6: P_ITEM_ID — INNER JOIN B 제거 + EXISTS GT_GGET_SPLIT_ITEM_ID + 'ALL' short-circuit
          AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                                WHERE F.ITEM_ID    LIKE '%' || B.TOK || '%'
                                   OR T2.NICK_NAME LIKE '%' || B.TOK || '%') )
          -- ⭐ 룰 2+6: LP_PROJECT_CODE — INNER JOIN C 제거 + EXISTS GT_GGET_SPLIT_PROJECT_CODE + 'ALL' short-circuit
          AND  ( LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE C
                                WHERE F.PROJECT_CODE  LIKE '%' || C.TOK || '%'
                                   OR T3.PROJECT_NAME LIKE '%' || C.TOK || '%') );

    ELSE
        -- Division 40 (소형) 케이스
        -- ============================================================
        -- ⭐ Phase 2 (2026-06-16): 6 룰 적용 — DIV='40' (소형 사업부) 분기
        --   Phase 1 과 동일 패턴 + DIV=40 전용 컬럼/JOIN 보존 (LOOKA / TEAM inline / DEPT_NAME_KO 등)
        -- ============================================================
        -- Division 40 (소형) 케이스
        INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, F.PROJECT_CODE  AS PROJECT_NAME
             , F.ATTRIBUTE5  AS CELL_MODEL   -- 20180810 ytchoi 조회속도개선
             , ''  AS BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             -- ⭐ 룰 1: FROM 절 OW inline view 의 OWNER_NAME 참조 (correlated 제거)
             , OW.OWNER_NAME  AS OWNER
             , J.USER_NAME_EN  AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , ''  AS PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             -- [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                    ELSE T2.FORECAST_INFO_BIZ_TYPE END  AS FORECAST_INFO_BIZ_TYPE
             , T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT)
                    ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END  AS FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        -- ⭐ 룰 2: INNER JOIN B/C (LIKE split) 제거 → WHERE EXISTS
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        LEFT   JOIN (
                        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
                        JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
                    ) TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
                                 -- 원본 IN (SELECT ... FROM DUAL) → 단일 row 비교로 변환 (의미 동등)
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
          ON   CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                    ELSE F.DEPT_ID END = K.DEPT_ID   -- 20190123 KHSONG
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        -- ⭐ 룰 5: NVL(T2.X,'')=T4.ITEM_ID → 직접 비교
        LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
        -- [E20230720-001573] 40번사업부 AMDMO0001A모델 BIZ_TYPE/CELL_PACK_COUNT LOOKUP 적용
        LEFT   JOIN (
                        SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT
                        FROM (
                            SELECT SEGMENT2 AS MODEL
                                 , SEGMENT3 AS BIZ_TYPE
                                 , SEGMENT4 AS CELL_PACK_COUNT
                                 , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40'
                        ) A WHERE MODEL_RANK = 1
                    ) LOOKA ON LOOKA.MODEL = F.ITEM_ID
        -- ⭐ 룰 1: FROM 절 OW inline view — F.OWNER 사전 집계 (correlated 제거)
        LEFT   JOIN (
                        SELECT OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                             , LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN) AS OWNER_NAME
                        FROM (
                            SELECT FF.DIVISION_ID, FF.PROJECT_CODE, FF.SCM_SITE_ID, FF.ITEM_ID
                                 , TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) AS TOK
                            FROM   SCM_MGR.SCM_MST_SITE_ITEM FF
                            CROSS JOIN ( SELECT LEVEL AS LV
                                         FROM DUAL CONNECT BY LEVEL <= 30 ) HIER
                            WHERE  FF.DIVISION_ID = '40'
                              AND  FF.OWNER IS NOT NULL
                              AND  TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) IS NOT NULL
                        ) OT
                        JOIN SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = OT.TOK
                        GROUP BY OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                    ) OW
          ON   F.DIVISION_ID  = OW.DIVISION_ID
         AND   F.PROJECT_CODE = OW.PROJECT_CODE
         AND   F.SCM_SITE_ID  = OW.SCM_SITE_ID
         AND   F.ITEM_ID      = OW.ITEM_ID
        WHERE  F.DIVISION_ID = '40'
          -- ⭐ 룰 2+6: LP_SCM_SITE_ID — CASE 패턴 유지 (Before 의 의미 1:1) — split 은 일반적인 동작 그대로
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
                      ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE F.PROJECT_CODE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- [E20230720-001573] BIZ_TYPE LOOKUP 우선 적용
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                      ELSE T2.FORECAST_INFO_BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- ⭐ 룰 6: P_OWNER 'ALL' 분기 추가 + EXISTS GT_GGET_SPLIT_OWNER
          AND  ( P_OWNER IS NULL OR P_OWNER IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_OWNER O WHERE F.OWNER = O.TOK) )
          -- ⭐ 룰 2+6: P_ITEM_ID — INNER JOIN B 제거 + EXISTS + 'ALL' short-circuit
          AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                                WHERE F.ITEM_ID    LIKE '%' || B.TOK || '%'
                                   OR T2.NICK_NAME LIKE '%' || B.TOK || '%') )
          -- ⭐ 룰 2+6: LP_PROJECT_CODE — INNER JOIN C 제거 + EXISTS + 'ALL' short-circuit
          --   원본: JOIN C ON F.PROJECT_CODE LIKE C.TST (PROJECT_NAME LIKE 분기 없음 — DIV=40)
          AND  ( LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE C
                                WHERE F.PROJECT_CODE LIKE '%' || C.TOK || '%') );

    END IF;

    -----------------------------------------------------------------------
    -- [20190704 KHSONG] ITEM_ID 중복 현상 방지를 위해 재 GROUP
    -- GT_GGET_SITE_ITEM_ALL → GT_GGET_SITE_ITEM
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)
         , MAX(BIZ_TYPE)
         , MAX(END_CUSTOMER)
         , MAX(SOLDTO_CUSTOMER)
         , MAX(COUNTRY)
         , MAX(COUNTRY_NAME)
         , MAX(CITY)
         , MAX(CITY_NAME)
         , MAX(OWNER)
         , MAX(PROJECT_OWNER)
         , MAX(USER_ID)
         , MAX(ITEM_NAME)
         , MAX(ITEM_TYPE)
         , MAX(PROJECT_STATUS)
         , MAX(CUST_GROUP)
         , MAX(CUST_GROUP_DTL)
         , MAX(APPLICATION)
         , MAX(ROUTE)
         , MAX(MDM_PROJECT_NAME)
         , MAX(MIN_CAPACITY)
         , MAX(FORECAST_INFO_BIZ_TYPE)
         , MAX(FORECAST_INFO_PRODUCT_GROUP)
         , MAX(CELL_TYPE)
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(FORECAST_INFO_ALL)
         , MAX(FORECAST_INFO_SPEC)
         , MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_MODEL_NICK_NAME)
         , MAX(VMI_YN)
         , MAX(DMS_SALES)
         , MAX(DMS_CUSTOMER)
         , MAX(DEPT_ID)
         , MAX(DEPT_NAME_KO)
         , MAX(CELL_PER_CAR)
         , MAX(CELL_PER_MODULE)
         , MAX(MODULE_PER_CAR)
         , MAX(ITEM_CLASS_NAME)
         , MAX(ENERGE)
         , MAX(CELL_QUANTITY)
         , MAX(ITEM_VALID_YN)
    FROM   SCM_MGR.GT_GGET_SITE_ITEM_ALL
    GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;

    -----------------------------------------------------------------------
    -- GT_GGET_EDI_SENDER 수집
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
    SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
    FROM   SCM_MGR.SCM_MST_SITE A
    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   A.END_CUSTOMER = B.SEGMENT2
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
    GROUP  BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6;

    -----------------------------------------------------------------------
    -- GT_GGET_LAST_DATA_SETUP 수집 (최종 입력일시 및 입력자)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_LAST_DATA_SETUP
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    , CREATE_DATE, LAST_UPDATED_BY )
    SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
         , X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
         , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
    FROM (
        -- DM_PLN_MKT_FCST (계획 테이블)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , CASE WHEN A.MEASURE IN (
                        'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
                        'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
                        'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
                        'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
                        'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
                        'Material_Temp[Org.]','Backorder[Org.]')
                    THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
                                THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
                                ELSE MAX(A.ATTRIBUTE9) END )
                    ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
               END AS LAST_UPDATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
          ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
                                WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
                                WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
                                                   'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                                               THEN 'RTF'
                                ELSE B.MEASURE END
        WHERE  A.DIVISION_ID = P_DIVISION_ID
          AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
          AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
        GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        UNION ALL
        -- DM_PLN_MKT_FCST_RESULT (실적 테이블)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , CASE WHEN A.MEASURE IN (
                        'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
                        'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
                        'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
                        'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
                        'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
                        'Material_Temp[Org.]','Backorder[Org.]')
                    THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
                                THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
                                ELSE MAX(A.ATTRIBUTE9) END )
                    ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
               END AS LAST_UPDATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
          ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
                                WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
                                WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
                                                   'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                                               THEN 'RTF'
                                ELSE B.MEASURE END
        WHERE  A.DIVISION_ID = P_DIVISION_ID
          AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
          AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
        GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
    ) X
    WHERE  ( X.PROJECT_CODE IS NOT NULL OR NVL(X.PROJECT_CODE,'') <> '' )
      AND  ( X.SCM_SITE_ID IS NOT NULL OR NVL(X.SCM_SITE_ID,'')  <> '' )
      AND  ( X.ITEM_ID IS NOT NULL OR NVL(X.ITEM_ID,'')      <> '' )
    GROUP  BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
           ,  X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;

    -----------------------------------------------------------------------
    -- GT_GGET_EDI_END_CUST 수집 (EDI END_CUSTOMER별 기간 설정)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_EDI_END_CUST
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , NVL(B.SEGMENT4, '-')
         , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
                ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
         , NVL(B.ATTRIBUTE2, 'TUE')
         , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
         , NVL(B.ATTRIBUTE4, 'MON')
         , NVL(B.SEGMENT5, 'Off')
    FROM   SCM_MGR.SCM_MST_SITE A
    LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   A.END_CUSTOMER = B.SEGMENT2
     AND   B.VALID_YN     = 'Y'
    WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
    GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
           ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

    -----------------------------------------------------------------------
    -- GT_GGET_RPA_END_CUST 수집 (RPA END_CUSTOMER별 기간 설정)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_RPA_END_CUST
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , NVL(B.SEGMENT4, '-')
         , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
                ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
         , NVL(B.ATTRIBUTE2, 'TUE')
         , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
         , NVL(B.ATTRIBUTE4, 'MON')
         , NVL(B.SEGMENT5, 'Off')
    FROM   SCM_MGR.SCM_MST_SITE A
    LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   B.LOOKUP_TYPE  = 'RPA_END_CUSTOMER'
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   A.END_CUSTOMER = B.SEGMENT2
     AND   B.VALID_YN     = 'Y'
    WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
    GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
           ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

    -----------------------------------------------------------------------
    -- CAL_MONTH_END / CAL_WEEK_END 수집 (월말일 / 주말일 목록)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_CAL_MONTH_END ( MONTH_END_DATE )
    SELECT TO_CHAR(LAST_DAY(TO_DATE(BASIS_YYYYMM,'YYYYMM')),'YYYYMMDD') AS MONTH_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP  BY BASIS_YYYYMM;

    INSERT INTO SCM_MGR.GT_GGET_CAL_WEEK_END ( WEEK_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP  BY BASIS_YYYYMM, ISO_WEEK;


    -----------------------------------------------------------------------
    -- 계획 구간 INSERT 조건:
    --   V_TO_YYYYMMDD >= 당주 월요일  →  계획구간 데이터 존재
    -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
    --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
    -----------------------------------------------------------------------
    IF V_TO_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN

        -----------------------------------------------------------------------
        -- Block 1-A : MKT_FCST 계열 (CUST_FCST_EDI/Immidiate 등 제외)
        --             AS콤보박스 제거로 T4(AS_SITE_PLANT) LEFT JOIN 추가 [E20260211-001189]
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
        , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
        , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
        , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
        , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE
                   AND  QTY         <> 0 )
             , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE )
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        -- [E20260211-001189] AS콤보박스 제거 → AS_SITE_PLANT LEFT JOIN으로 AS데이터 포함
        LEFT   OUTER JOIN (
                               SELECT SEGMENT1, SEGMENT2
                               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                                 AND  SEGMENT3    = P_DIVISION_ID
                           ) T4 ON NVL(F.ATTRIBUTE10,'') = T4.SEGMENT2
        WHERE  F.QTY <> 0
          AND  F.MEASURE NOT IN (
                   'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
                   'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
                   'CUST_FCST','Customer FCST' )
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL)
                 OR
                 CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE T4.SEGMENT1 END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- Block 1-B : CUST_FCST_EDI 계열 (EDI/RPA Sender 기반)
        --             YYYYMMDD 범위: v_to_result ~ p_to_yyyymmdd  [고객수요분석시스템 정비]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                    'Commercial_Agreement','Firm_Temp',
                                    'Manumacturing_Material_Temp','Material_Temp','Backorder') )
             , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
                   ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
             , CASE WHEN ( F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' ) THEN
                   ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
             , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> -9999999999
          AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                             'Commercial_Agreement','Firm_Temp',
                             'Manumacturing_Material_Temp','Material_Temp','Backorder')
          -- [고객수요분석시스템 정비] EDI데이터 중복건 제거: v_to_result 이후부터만 조회
          AND  F.YYYYMMDD    BETWEEN V_TO_RESULT AND P_TO_YYYYMMDD
          AND  F.DIVISION_ID = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
                      THEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END )
                      ELSE F.ATTRIBUTE4 END
                 IN ( SELECT TRIM(REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
                      FROM DUAL
                      CONNECT BY REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )

        -----------------------------------------------------------------------
        -- Block 1-C : Customer FCST (RPA/EXCEL 경로, Cust.FCST_RPA[P+P] / Cust.FCST_EXCEL[P+P] 으로 표시)
        --             [E20241126-000426] Customer FCST 전용 로직
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , CASE WHEN F.MEASURE = 'Customer FCST' THEN
                        CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                             THEN 'Cust.FCST_RPA[P+P]'
                             ELSE 'Cust.FCST_EXCEL[P+P]' END
                    ELSE F.MEASURE END  AS MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             -- [E20241126-000426] Customer FCST 전용 LAST_DATA_SETUP
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
             , CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                    THEN F.LAST_UPDATED_BY || '_RPA'
                    ELSE F.LAST_UPDATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND   ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                   ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          -- [E20241126-000426] Customer FCST 전용
          AND  F.MEASURE      = 'Customer FCST'
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- Block 1-D : CUST_FCST 전용  [E20241126-000426]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
             , F.LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND  ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                        ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                          ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          AND  F.MEASURE      = 'CUST_FCST'
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );

        -----------------------------------------------------------------------
        -- Block 2 : MKT_FCST_RP / MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
        --           (Cell/Car/Module 환산 포함)
        -----------------------------------------------------------------------
        DECLARE
            V_RP_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RP_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');

            IF V_RP_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                            THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE = 'MKT_FCST_RP' THEN F.QTY
                           WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell') > 0   AND NVL(T2.CELL_PER_CAR,0) > 0
                                        THEN F.QTY / T2.CELL_PER_CAR
                                   -- [C20200212-000304] Module: QTY / MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0
                                        THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack') > 0   THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID LIKE '81%' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   -- [C20200511-000360] Pack → CELL_PER_CAR 곱
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20200114-000201] ESS(82): CELL_QUANTITY 곱
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID = '82' THEN
                               F.QTY * T2.CELL_QUANTITY
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'MKT_FCST'
                 AND   M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                                        THEN 'MKT_FCST' ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 2 END
        END;

        -----------------------------------------------------------------------
        -- Block 3 : RTF_RP_CAR / RTF_SYS_RP_CAR / RTF_RP_CELL / RTF_SYS_RP_CELL / RTF_ENERGY
        --           [CSR ID:4023158] 20190705 KHSONG
        --           [C20211103-000146] 20211119 RTF_ENERGY 추가
        -----------------------------------------------------------------------
        DECLARE
            V_RTF_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RTF_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY');

            IF V_RTF_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     -- Measure명 결정
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
                                    ELSE '' END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
                                    ELSE '' END
                           WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
                       END  AS MEASURE
                     , F.YYYYMMDD
                     -- QTY 환산
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
                                        THEN F.QTY / T2.CELL_PER_CAR
                                   -- [C20200212-000304] Module → MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0
                                    AND NVL(T2.CELL_PER_CAR,0) > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0
                                        THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') AND F.DIVISION_ID LIKE '81%' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20200114-000201] ESS(82) RTF_RP_CELL: CELL_QUANTITY 곱
                           WHEN M.MEASURE = 'RTF_RP_CELL' AND F.DIVISION_ID = '82' THEN
                               F.QTY * T2.CELL_QUANTITY
                           -- [C20211103-000146] RTF_ENERGY: ENERGE * QTY / 1000
                           WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP')
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
                 AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.MEASURE = CASE
                                       WHEN M.MEASURE IN ('RTF_RP_CAR', 'RTF_RP_CELL')                    THEN 'RTF'
                                       WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF_SYS_RP'
                                       ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 3 END
        END;


        -----------------------------------------------------------------------
        -- Block 4 : MKT_FCST_ENERGY  [C20221207-000080] 20221214 rosia27
        --           소스: GT_GGET_MKT_FCST_DATA 에 이미 들어간 MKT_FCST_RP 행에서 파생
        --           (원본: #TempMktFcstData JOIN #TempSiteItem)
        -----------------------------------------------------------------------
        DECLARE
            V_ENERGY_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_ENERGY_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE = 'MKT_FCST_ENERGY';

            IF V_ENERGY_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'MKT_FCST_RP'
                            THEN 'MKT_FCST_ENERGY' END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                            ELSE 0 END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     -- MKT_FCST_ENERGY는 GT_GGET_MKT_FCST_DATA의 MKT_FCST_RP 행에서 파생
                     -- CREATE_DATE / LAST_UPDATED_BY / SENDER_* 는 원본 F 행 값 그대로 사용
                     , F.AS_FROM_SITE
                     , F.CREATE_DATE
                     , F.LAST_UPDATED_BY
                     , F.SENDER_CODE
                     , F.SENDER_NAME
                FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F   -- 이미 삽입된 MKT_FCST_RP 행을 소스로 사용
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'MKT_FCST_RP'
                 AND   M.MEASURE = 'MKT_FCST_ENERGY'
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 4 END
        END;

    END IF;  -- 계획 구간 조건 END (V_TO_YYYYMMDD >= 당주 월요일)


    -----------------------------------------------------------------------
    -- 실적 구간 INSERT 조건:
    --   V_FROM_YYYYMMDD <= 당주 월요일
    -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
    --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
    -----------------------------------------------------------------------
    IF V_FROM_YYYYMMDD <= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN

        -----------------------------------------------------------------------
        -- [PJ2025-50188] GT_GGET_MKT_FCST_RESULT 생성
        --   DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 컬럼이 추가되어
        --   DUP 방지를 위해 CELL_PROD_SITE_ID 제거 후 GROUP BY로 집계
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, YYYYMMDD
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        , QTY )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, YYYYMMDD
             , MAX(CREATED_BY)        AS CREATED_BY
             , MAX(CREATION_DATE)     AS CREATION_DATE
             , MAX(LAST_UPDATED_BY)   AS LAST_UPDATED_BY
             , MAX(LAST_UPDATE_DATE)  AS LAST_UPDATE_DATE
             , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
             , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
             , SUM(QTY)               AS QTY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
        WHERE  DIVISION_ID  = P_DIVISION_ID
          AND  YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  YYYYMMDD     < V_TO_RESULT
        GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
               ,  MEASURE, PLANT_SITE_ID, YYYYMMDD
               ,  ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
               ,  ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10;

        -----------------------------------------------------------------------
        -- Block R-1 ~ R-4: 단일 INSERT … UNION ALL
        --   소스: GT_GGET_MKT_FCST_RESULT (= 집계된 실적 테이블)
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
        , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
        , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
        , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
        , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )

        -----------------------------------------------------------------------
        -- R-1: MKT_FCST 계열 (CUST_FCST_EDI 계열 및 CUST_FCST/Customer FCST 제외)
        -----------------------------------------------------------------------
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
             , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
                   AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                        WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                          AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                          AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                          AND  INCOTERMS   = F.INCOTERMS
                                          AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        WHERE  F.QTY <> 0
          AND  F.MEASURE NOT IN (
                   'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
                   'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
                   'CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]',
                   'Commercial_Agreement[Org.]','Firm_Temp[Org.]',
                   'Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]',
                   'CUST_FCST','Customer FCST' )
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- R-2: CUST_FCST_EDI 계열 (EDI Sender 포함)
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE    IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                       'Commercial_Agreement','Firm_Temp',
                                       'Manumacturing_Material_Temp','Material_Temp','Backorder') )
             , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
                   ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
             , CASE WHEN F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' THEN
                   ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
             , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> -9999999999
          AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                             'Commercial_Agreement','Firm_Temp',
                             'Manumacturing_Material_Temp','Material_Temp','Backorder')
          -- [E20241126-000426] EDI 기간 필터 주석처리(배치에서 정리) → 단순 날짜 범위만 적용
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
                      THEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END )
                      ELSE F.ATTRIBUTE4 END
                 IN ( SELECT TRIM(REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
                      FROM DUAL
                      CONNECT BY REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )

        -----------------------------------------------------------------------
        -- R-3: Customer FCST (RPA/EXCEL → Cust.FCST_RPA/EXCEL[P+P])
        --      [E20241126-000426] Customer FCST 전용; LAST_UPDATED_BY는 CREATED_BY 기반
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , CASE WHEN F.MEASURE = 'Customer FCST' THEN
                        CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                             THEN 'Cust.FCST_RPA[P+P]'
                             ELSE 'Cust.FCST_EXCEL[P+P]' END
                    ELSE F.MEASURE END  AS MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             -- [E20241126-000426] Customer FCST 전용 CREATE_DATE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
             -- [PJ2025-50188] 실적은 CREATED_BY 기반으로 _RPA/_EXCEL 결정
             , CASE WHEN F.CREATED_BY LIKE '%robot'
                    THEN F.CREATED_BY || '_RPA'
                    ELSE F.CREATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          -- [E20241126-000426] Customer FCST 전용
          AND  F.MEASURE      = 'Customer FCST'
          -- [E20241126-000426] 날짜 필터 단순화(배치에서 RPA 기간 정리)
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- R-4: CUST_FCST 전용  [E20241126-000426]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
             , F.LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          AND  F.MEASURE      = 'CUST_FCST'
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );

        -----------------------------------------------------------------------
        -- Block R-5 : MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
        --   소스: GT_GGET_MKT_FCST_RESULT (RTF → 실적 기준)
        --   20190722 KHSONG: MKT_FCST_RESULT에서 RTF 컬럼이 실적값
        -----------------------------------------------------------------------
        DECLARE
            V_RP_RESULT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RP_RESULT_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');

            IF V_RP_RESULT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                            THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
                -- 실적에서 RTF는 MKT_FCST_RP_CAR/CELL 환산 소스 (20190722 KHSONG)
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'RTF'
                 AND   M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                                        THEN 'RTF' ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-5 END
        END;

        -----------------------------------------------------------------------
        -- Block R-6: RTF_RP_CAR/CELL/ENERGY + MKT_FCST_ENERGY
        --   소스: GT_GGET_MKT_FCST_RESULT (RTF/RTF_SYS_RP)
        --   [CSR ID:4023158] + [C20211103-000146] + [C20221207-000080]
        -----------------------------------------------------------------------
        DECLARE
            V_RTF_RESULT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RTF_RESULT_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
                               'RTF_ENERGY','MKT_FCST_ENERGY');

            IF V_RTF_RESULT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
                                    ELSE '' END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
                                    ELSE '' END
                           WHEN M.MEASURE = 'RTF_ENERGY'      AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
                           WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'MKT_FCST_ENERGY'
                       END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20211103-000146] RTF_ENERGY
                           WHEN M.MEASURE = 'RTF_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                           -- [C20221207-000080] MKT_FCST_ENERGY
                           WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE     IN ('RTF','RTF_SYS_RP')
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
                 AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
                                     'RTF_ENERGY','MKT_FCST_ENERGY')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.MEASURE = CASE
                                       WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_RP_CELL')                        THEN 'RTF'
                                       WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL',
                                                          'RTF_ENERGY','MKT_FCST_ENERGY')                   THEN 'RTF_SYS_RP'
                                       ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-6 END
        END;

        -----------------------------------------------------------------------
        -- Block R-7: MKT_FCST_RP
        --   소스: GT_GGET_MKT_FCST_RESULT (RTF → MKT_FCST_RP 표시)
        -----------------------------------------------------------------------
        DECLARE
            V_MFTRP_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_MFTRP_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE = 'MKT_FCST_RP';

            IF V_MFTRP_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , 'MKT_FCST_RP'  AS MEASURE   -- RTF 실적 → MKT_FCST_RP 로 표시
                     , F.YYYYMMDD, F.QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND QTY         <> 0
                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE  = 'RTF'         -- 실적은 RTF
                 AND   M.MEASURE  = 'MKT_FCST_RP' -- → MKT_FCST_RP 로 표시
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-7 END
        END;

        -----------------------------------------------------------------------
        -- Block R-8: IN_TRANSIT
        --   소스: GT_GGET_INTRANSIT_DATA
        --   [E20241126-000426] SHIPMENT_PLAN 주석처리됨; IN_TRANSIT만 사용
        --   주의: YYYYMMDD 범위가 p_from_yyyymmdd ~ v_to_yyyymmdd (계획+실적 모두)
        -----------------------------------------------------------------------
        DECLARE
            V_IT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_IT_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE = 'IN_TRANSIT';

            IF V_IT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , F.MEASURE
                     , F.YYYYMMDD, F.QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , ''  AS AS_FROM_SITE
                     , ''  AS CREATE_DATE
                     , ''  AS LAST_UPDATED_BY
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_INTRANSIT_DATA F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'IN_TRANSIT'
                 AND   F.MEASURE = M.MEASURE
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-8 END
        END;

    END IF;  -- 실적 구간 조건 END (V_FROM_YYYYMMDD <= 당주 월요일)

    -----------------------------------------------------------------------
    -- Step 1: GT_GGET_MKT_FCST_DATA → GT_GGET_MKT_FCST_DST  집계
    --   [E20240712-001683] YYYYMMDD 포함 GROUP BY
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
    , MEASURE_GROUP, FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
    , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
    , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
    , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
    , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
    , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
    , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
         , F.YYYYMMDD
         , MAX(F.MEASURE_GROUP)             AS MEASURE_GROUP
         , MAX(F.CELL_MODEL)               AS FORECAST_INFO_CELL_MODEL
         , MAX(F.END_CUSTOMER)             AS END_CUSTOMER
         , MAX(F.NICK_NAME)               AS NICK_NAME
         , MAX(F.DMS_SALES)               AS DMS_SALES
         , MAX(F.DMS_CUSTOMER)            AS DMS_CUSTOMER
         , MAX(F.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(F.DEPT_ID)                 AS DEPT_ID
         , MAX(F.DEPT_NAME_KO)            AS DEPT_NAME_KO
         , MAX(F.ITEM_TYPE)               AS ITEM_TYPE
         , MAX(F.PROJECT_NAME)            AS PROJECT_NAME
         , MAX(F.PROJECT_OWNER)           AS PROJECT_OWNER
         , MAX(F.OWNER)                   AS OWNER
         , MAX(F.BIZ_TYPE)               AS BIZ_TYPE
         , MAX(F.SOLDTO_CUSTOMER)         AS SOLDTO_CUSTOMER
         , MAX(F.COUNTRY_NAME)            AS COUNTRY_NAME
         , MAX(F.CITY_NAME)              AS CITY_NAME
         , MAX(F.PROJECT_STATUS)          AS PROJECT_STATUS
         , MAX(F.ITEM_NAME)              AS ITEM_NAME
         , MAX(F.VMI_YN)                 AS VMI_YN
         , MAX(F.CUST_GROUP)             AS CUST_GROUP
         , MAX(F.CUST_GROUP_DTL)         AS CUST_GROUP_DTL
         , MAX(F.APPLICATION)            AS APPLICATION
         , MAX(F.ROUTE)                  AS ROUTE
         , MAX(F.MDM_PROJECT_NAME)       AS MDM_PROJECT_NAME
         , MAX(F.MIN_CAPACITY)           AS MIN_CAPACITY
         , MAX(F.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
         , MAX(F.CELL_TYPE)              AS CELL_TYPE
         , MAX(F.FORECAST_INFO_ALL)      AS FORECAST_INFO_ALL
         , MAX(F.FORECAST_INFO_SPEC)     AS FORECAST_INFO_SPEC
         , MAX(F.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
         , MAX(F.CELL_MODEL_NICK_NAME)   AS CELL_MODEL_NICK_NAME
         , MAX(F.CELL_PER_CAR)           AS CELL_PER_CAR
         , MAX(F.CELL_PER_MODULE)        AS CELL_PER_MODULE
         , MAX(F.MODULE_PER_CAR)         AS MODULE_PER_CAR
         , MAX(F.SORT_ORDER_NO)          AS SORT_ORDER_NO
         , MAX(F.ENERGE)                 AS ENERGE
         , MAX(F.CELL_QUANTITY)          AS CELL_QUANTITY
         , MAX(F.AS_FROM_SITE)           AS AS_FROM_SITE
         , MAX(F.CREATE_DATE)            AS CREATE_DATE
         , MAX(F.LAST_UPDATED_BY)        AS LAST_UPDATED_BY
         , MAX(F.SENDER_CODE)            AS SENDER_CODE
         , MAX(F.SENDER_NAME)            AS SENDER_NAME
    FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F
    GROUP  BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
           ,  F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD;

    -----------------------------------------------------------------------
    -- Step 2: Division 82, MKT_FCST_RP 선택 + VMI 사이트 존재 시
    --         빠진 메저(RTF_SYS_RP, VMI_In_Plan/Req, VMI_Inv, MKT_FCST_RP) 행 보완
    --   [C20201103-000114]
    -----------------------------------------------------------------------
    DECLARE
        V_MKT_FCST_RP_VMI_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_MKT_FCST_RP_VMI_CNT
        FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
        WHERE  A.MEASURE = 'MKT_FCST_RP'
          AND  P_DIVISION_ID = '82'
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_GGET_MKT_FCST_DST D
                   JOIN   SCM_MGR.SCM_MST_SITE B
                     ON   D.DIVISION_ID = B.DIVISION_ID
                    AND   D.SCM_SITE_ID = B.SCM_SITE_ID
                    AND   B.VMI_YN      = 'Y'
                   WHERE  D.MEASURE     = 'MKT_FCST_RP'
               );

        IF V_MKT_FCST_RP_VMI_CNT > 0 THEN
            -- VMI 사이트 × 빠진 메저 조합 보완
            INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
            , DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, MEASURE_GROUP
            , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
            , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
            , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
            , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
            , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
            , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
            , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
            , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
            , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
            , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , A.MEASURE, A.MEASURE_GROUP
                 , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                 , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
                 , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
                 , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                 , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                 , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                 , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                 , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                 , REPLACE(D.SORT_ORDER_NO, '.0', A.SORTKEY)  AS SORT_ORDER_NO
                 , A.ENERGE, A.CELL_QUANTITY
                 , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
            FROM (
                -- VMI 사이트 기반 DISTINCT 헤더
                SELECT B2.MEASURE    AS MEASURE
                     , B2.MEASURE_GROUP
                     , B2.SORTKEY
                     , A2.*
                FROM (
                    SELECT DISTINCT
                           A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                         , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                         , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                         , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                         , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                         , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                         , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                         , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                         , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                         , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                         , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                         , A2.ENERGE, A2.CELL_QUANTITY
                         , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
                    JOIN   SCM_MGR.SCM_MST_SITE S
                      ON   A2.DIVISION_ID = S.DIVISION_ID
                     AND   A2.SCM_SITE_ID = S.SCM_SITE_ID
                     AND   S.VMI_YN       = 'Y'
                ) A2,
                (
                    SELECT 'MKT_FCST_RP' AS MEASURE_GROUP, 'MKT_FCST_RP' AS MEASURE, '.9' AS SORTKEY FROM DUAL UNION ALL
                    SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' FROM DUAL UNION ALL
                    SELECT 'VMI_In_Plan' AS MEASURE_GROUP, 'VMI_In_Plan' AS MEASURE, '.2' FROM DUAL UNION ALL
                    SELECT 'VMI_In_Req'  AS MEASURE_GROUP, 'VMI_In_Req'  AS MEASURE, '.3' FROM DUAL UNION ALL
                    SELECT 'VMI_Inv'     AS MEASURE_GROUP, 'VMI_Inv'     AS MEASURE, '.4' FROM DUAL
                ) B2
            ) A
            -- 이미 GT_GGET_MKT_FCST_DST에 존재하는 조합은 제외
            LEFT OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST C
              ON  A.DIVISION_ID    = C.DIVISION_ID
             AND  A.PROJECT_CODE   = C.PROJECT_CODE
             AND  A.SCM_SITE_ID    = C.SCM_SITE_ID
             AND  A.PLANT_SITE_ID  = C.PLANT_SITE_ID
             AND  A.ITEM_ID        = C.ITEM_ID
             AND  A.DOM_EXP        = C.DOM_EXP
             AND  A.FCST_TYPE      = C.FCST_TYPE
             AND  A.INCOTERMS      = C.INCOTERMS
             AND  A.MEASURE        = C.MEASURE
             AND  A.MEASURE_GROUP  = C.MEASURE_GROUP
            LEFT OUTER JOIN SCM_MGR.GT_GGET_SELECT_MEASURE D
              ON  A.MEASURE = D.MEASURE AND A.MEASURE_GROUP = D.MEASURE_GROUP
            WHERE C.MEASURE IS NULL
            ORDER BY A.INCOTERMS, A.MEASURE;
        END IF;
    END;

    -----------------------------------------------------------------------
    -- Step 3: Division 82 + P_INVALID_EXEC='N'
    --         → GT_GGET_SALES_PRICE 수집 (mapping 미등록 Sales Price 제공)
    --   [C20200612-000174]
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN

        -- LOC measure → MKT_FCST_RP, BNPIn(상품/전극) 행 수집
        INSERT INTO SCM_MGR.GT_GGET_SALES_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS
        , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
        , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
        , PROJECT_STATUS, NICK_NAME, DEPT_ID, DEPT_NAME_KO, VMI_YN
        , PROJECT_NAME, END_CUSTOMER, ENERGE, CELL_QUANTITY
        , MEASURE, MEASURE_GROUP, SORT_ORDER_NO )
        SELECT DISTINCT
               A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
             , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
             , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
             , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
             , 'MKT_FCST_RP'  AS MEASURE
             , 'MKT_FCST_RP'  AS MEASURE_GROUP
             , CASE WHEN NVL(B.VMI_YN,'N') <> 'Y' THEN '00.0' ELSE '.9' END  AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
          ON   A.DIVISION_ID  = B.DIVISION_ID
         AND   A.PROJECT_CODE = B.PROJECT_CODE
         AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   A.ITEM_ID      = B.ITEM_ID
         AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
        WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.MEASURE     = 'LOC'
          AND  A.FCST_TYPE  <> 'ETC'    -- [C20200702-000136] ETC 제외

        UNION ALL

        SELECT DISTINCT
               A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
             , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
             , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
             , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
             , 'BNPIn'  AS MEASURE
             , 'BNPIn'  AS MEASURE_GROUP
             , '00.0'   AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
          ON   A.DIVISION_ID  = B.DIVISION_ID
         AND   A.PROJECT_CODE = B.PROJECT_CODE
         AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   A.ITEM_ID      = B.ITEM_ID
         AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
         AND   B.ITEM_TYPE   IN ('Q','R')  -- 상품/전극만
        WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.MEASURE     = 'LOC'
          AND  A.FCST_TYPE  <> 'ETC';

        -- SORT_ORDER_NO: GT_GGET_SELECT_MEASURE 기준으로 업데이트
        UPDATE SCM_MGR.GT_GGET_SALES_PRICE A
        SET    A.SORT_ORDER_NO = (
                   SELECT B.SORT_ORDER_NO
                   FROM   SCM_MGR.GT_GGET_SELECT_MEASURE B
                   WHERE  A.MEASURE       = B.MEASURE
                     AND  A.MEASURE_GROUP = B.MEASURE_GROUP
                     AND  ROWNUM          = 1 );

        -- VMI/RTF/MKT_FCST_RP 계열 SORT_ORDER_NO 소수점 자리 조정
        UPDATE SCM_MGR.GT_GGET_SALES_PRICE
        SET    SORT_ORDER_NO =
               CASE WHEN MEASURE = 'RTF_SYS_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.1')
                    WHEN MEASURE = 'VMI_In_Plan'  THEN REPLACE(SORT_ORDER_NO, '.0', '.2')
                    WHEN MEASURE = 'VMI_In_Req'   THEN REPLACE(SORT_ORDER_NO, '.0', '.3')
                    WHEN MEASURE = 'VMI_Inv'      THEN REPLACE(SORT_ORDER_NO, '.0', '.4')
                    WHEN MEASURE = 'MKT_FCST_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.9')
               END
        WHERE  MEASURE IN ('MKT_FCST_RP','RTF_SYS_RP','VMI_In_Plan','VMI_In_Req','VMI_Inv');

    END IF;

    -----------------------------------------------------------------------
    -- Step 4: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 GT_GGET_MKT_FCST_DST에 추가
    --   조건: AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID인 데이터 중
    --         아직 GT_GGET_MKT_FCST_DATA에 AS 메저가 없는 조합 삽입
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND LP_AS_YN = 'Y' THEN
        DECLARE
            V_AS_MEA_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_AS_MEA_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');

            IF V_AS_MEA_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, MEASURE_GROUP
                , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
                , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
                , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
                , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
                , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
                , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
                , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                     , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                     , C.MEASURE, C.MEASURE_GROUP
                     , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                     , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
                     , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
                     , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                     , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                     , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                     , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                     , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                     , C.SORT_ORDER_NO
                     , A.ENERGE, A.CELL_QUANTITY
                     , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
                FROM (
                    -- AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID 기반 DST 헤더 (중복 제거)
                    SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                         , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
                         , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                         , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                         , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                         , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                         , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                         , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                         , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                         , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                         , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                         , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                         , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
                      ON   A2.SCM_SITE_ID = B2.SEGMENT1
                     AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND   B2.SEGMENT3    = P_DIVISION_ID
                    GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                           ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
                           ,  A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                           ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                           ,  A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                           ,  A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                           ,  A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                           ,  A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                           ,  A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                           ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                           ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                           ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                           ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                ) A
                -- AS_IN_REQ/PLAN/INV 메저 목록 (CROSS JOIN)
                JOIN (
                    SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
                    FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
                    WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
                ) C ON 1=1
                -- 이미 GT_GGET_MKT_FCST_DATA에 AS 메저가 있는 조합은 제외
                LEFT OUTER JOIN (
                    SELECT DISTINCT
                           D2.DIVISION_ID, D2.PROJECT_CODE, D2.SCM_SITE_ID, D2.ITEM_ID
                         , D2.DOM_EXP, D2.FCST_TYPE, D2.INCOTERMS, D2.MEASURE, D2.PLANT_SITE_ID
                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
                      ON   D2.SCM_SITE_ID = B3.SEGMENT1
                     AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND   B3.SEGMENT3    = P_DIVISION_ID
                ) D ON  A.DIVISION_ID   = D.DIVISION_ID
                    AND A.PROJECT_CODE  = D.PROJECT_CODE
                    AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                    AND A.ITEM_ID       = D.ITEM_ID
                    AND A.DOM_EXP       = D.DOM_EXP
                    AND A.FCST_TYPE     = D.FCST_TYPE
                    AND A.INCOTERMS     = D.INCOTERMS
                    AND C.MEASURE       = D.MEASURE
                    AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
                WHERE D.DIVISION_ID IS NULL;
            END IF;
        END;
   END IF;

    -----------------------------------------------------------------------
    -- Step 5: Division 82 VMI 재고계산  [E20240102-000545]
    --   5-1) GT_GGET_VMI_INV: RANK=1(최신 일자) 행 추출
    --   5-2) DELETE: VMI_INV 일자 이후에 MKT_FCST/VMI_In_Plan/VMI_In_Req 있는 경우 제거
    --   5-3) DELETE: MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 (VMI_INV만 남김)
    --   5-4) GT_GGET_VMI_INV_RESULT: GT_GGET_MKT_FCST_DATA와 JOIN → 헤더 정보 붙임
    --   5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 확장
    --   5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
    --   5-7) GT_GGET_MKT_FCST_DATA에 최종 INSERT
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' THEN

        -- 5-1) 최신 날짜 VMI 관련 데이터 추출 (RANK=1)
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;

        INSERT INTO SCM_MGR.GT_GGET_VMI_INV
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                 , RANK() OVER (
                       PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                    DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
                       ORDER BY YYYYMMDD DESC
                   ) AS SEQ
            FROM (
                -- 계획 테이블
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                FROM   SCM_MGR.DM_PLN_MKT_FCST
                WHERE  DIVISION_ID = P_DIVISION_ID
                  AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
                  AND  QTY        <> 0
                  AND  YYYYMMDD  BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                UNION ALL
                -- 실적 테이블 (RESULT): 당주 월요일 이전까지
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
                     , SUM(QTY) AS QTY   -- [PJ2025-50188] CELL_PROD_SITE_ID 제거 후 집계
                FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
                WHERE  DIVISION_ID = P_DIVISION_ID
                  AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
                  AND  QTY        <> 0
                  AND  YYYYMMDD  >= P_FROM_YYYYMMDD
                  AND  YYYYMMDD   < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
                GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                       ,  DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
            ) A
        ) B
        WHERE SEQ = 1;

        -- 5-2) VMI_INV 일자 이후에 MKT_FCST 계열이 있는 경우 → VMI_INV 행 제거
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV C
        WHERE EXISTS (
            SELECT 1
            FROM (
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                     , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                FROM   SCM_MGR.GT_GGET_VMI_INV A    -- VMI_INV
                JOIN   SCM_MGR.GT_GGET_VMI_INV B    -- MKT_FCST 계열
                  ON   A.DIVISION_ID   = B.DIVISION_ID
                 AND   A.PROJECT_CODE  = B.PROJECT_CODE
                 AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                 AND   A.ITEM_ID       = B.ITEM_ID
                 AND   A.DOM_EXP       = B.DOM_EXP
                 AND   A.FCST_TYPE     = B.FCST_TYPE
                 AND   A.INCOTERMS     = B.INCOTERMS
                 AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                 AND   A.MEASURE       = 'VMI_INV'
                 AND   B.MEASURE      IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req')
                 AND   B.YYYYMMDD     >= A.YYYYMMDD + 1
            ) T
            WHERE C.DIVISION_ID   = T.DIVISION_ID
              AND C.PROJECT_CODE  = T.PROJECT_CODE
              AND C.SCM_SITE_ID   = T.SCM_SITE_ID
              AND C.ITEM_ID       = T.ITEM_ID
              AND C.DOM_EXP       = T.DOM_EXP
              AND C.FCST_TYPE     = T.FCST_TYPE
              AND C.INCOTERMS     = T.INCOTERMS
              AND C.PLANT_SITE_ID = T.PLANT_SITE_ID
        );

        -- 5-3) MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 → VMI_INV만 남김
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV
        WHERE  MEASURE IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req');

        -- 5-4) GT_GGET_MKT_FCST_DATA와 JOIN하여 헤더 정보 포함 → GT_GGET_VMI_INV_RESULT
        INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
             , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
             , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
             , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
             , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
             , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
             , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
             , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
             , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
             , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
        FROM   SCM_MGR.GT_GGET_VMI_INV A
        JOIN   SCM_MGR.GT_GGET_MKT_FCST_DATA B
          ON   A.DIVISION_ID   = B.DIVISION_ID
         AND   A.PROJECT_CODE  = B.PROJECT_CODE
         AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
         AND   A.ITEM_ID       = B.ITEM_ID
         AND   A.DOM_EXP       = B.DOM_EXP
         AND   A.FCST_TYPE     = B.FCST_TYPE
         AND   A.INCOTERMS     = B.INCOTERMS
         AND   A.MEASURE       = B.MEASURE
         AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
         AND   A.YYYYMMDD      = B.YYYYMMDD;

        -- 5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 행 확장
        --       (원본 날짜 이후의 모든 날짜에 동일 QTY 행 생성)
        INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT DISTINCT
               B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID
             , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE
             , A.BASIS_YYYYMMDD  AS YYYYMMDD   -- 캘린더 날짜로 확장
             , B.PLANT_SITE_ID, B.QTY
             , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
             , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
             , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
             , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
             , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
             , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
             , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
             , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
             , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        LEFT   OUTER JOIN SCM_MGR.GT_GGET_VMI_INV_RESULT B
          ON   A.BASIS_YYYYMMDD > B.YYYYMMDD   -- 원본 날짜 이후 모든 날짜
        WHERE  A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.BASIS_YYYYMMDD > B.YYYYMMDD;

        -- 5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT A
        WHERE  DIVISION_ID = '82'
          AND  MEASURE     = 'VMI_INV'
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_GGET_VMI_INV Z
                   WHERE  A.DIVISION_ID   = Z.DIVISION_ID
                     AND  A.PROJECT_CODE  = Z.PROJECT_CODE
                     AND  A.SCM_SITE_ID   = Z.SCM_SITE_ID
                     AND  A.ITEM_ID       = Z.ITEM_ID
                     AND  A.DOM_EXP       = Z.DOM_EXP
                     AND  A.FCST_TYPE     = Z.FCST_TYPE
                     AND  A.INCOTERMS     = Z.INCOTERMS
                     AND  A.PLANT_SITE_ID = Z.PLANT_SITE_ID
                     AND  A.YYYYMMDD      = Z.YYYYMMDD
               );

        -- 5-7) GT_GGET_MKT_FCST_DATA에 VMI_INV 보완 행 INSERT
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
        , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
        , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
        , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
             , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
             , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
             , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
             , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
             , CUST_GROUP, CUST_GROUP_DTL
             , NULL  AS APPLICATION   -- GT_GGET_VMI_INV_RESULT에 APPLICATION/ROUTE 없음
             , NULL  AS ROUTE
             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
             , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
             , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
             , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
             , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
        FROM   SCM_MGR.GT_GGET_VMI_INV_RESULT;

    END IF;  -- Division 82 VMI 재고계산 END

    -----------------------------------------------------------------------
    -- Step 6: NOTATION 컬럼 업데이트  [E20240812-000094]
    --   DM_MEASURE_POSITIONAL_NOTATION LOOKUP → MEASURE별 소수점 표기형태 설정
    -----------------------------------------------------------------------
    UPDATE SCM_MGR.GT_GGET_MKT_FCST_DATA A
    SET    A.NOTATION = NVL(
               ( SELECT C.SEGMENT3
                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
                 WHERE  C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION'
                   AND  A.MEASURE     = C.SEGMENT2
                   AND  A.DIVISION_ID = C.SEGMENT1
                   AND  ROWNUM        = 1 ),
               'DEFAULT' );

    -----------------------------------------------------------------------
    -- 팀 WHERE 조건 생성 (FN_SCM_GET_WHERE_SQL → 인라인 변환)
    -----------------------------------------------------------------------
    IF P_TEAM_ID = 'ALL' THEN
        V_TEAM_WHERE := '1=1';
    ELSE
        -- P_TEAM_ID 가 콤마 구분 목록일 경우 IN 절 생성
        V_TEAM_WHERE := 'A.DEPT_ID IN ('''
                     || REPLACE(P_TEAM_ID, ',', ''',''')
                     || ''')';
    END IF;

    -----------------------------------------------------------------------
    -- 분기: Division 82 + P_INVALID_EXEC='N'  → PIVOT SQL #1 (AS용)
    --        그 외                             → AS_IN_REQ 보완 + PIVOT SQL #2
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN

        -- -----------------------------------------------------------------------
        -- PIVOT SQL #1 (AS용)
        --   소스: GT_GGET_SALES_PRICE  FULL OUTER JOIN  GT_GGET_MKT_FCST_DST
        --         → GT_GGET_MF (임시 조인 결과)
        --         → PIVOT + EXECUTE IMMEDIATE → O_RC
        -- -----------------------------------------------------------------------
        V_SQL_TEXT :=
        'WITH MF_BASE AS (' || CHR(10) ||
        'SELECT' || CHR(10) ||
        '      A.DIVISION_ID' || CHR(10) ||
        '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
        '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
        '    , A.SCM_SITE_ID' || CHR(10) ||
        '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
        '    , A.PLANT_SITE_ID' || CHR(10) ||
        '    , A.PROJECT_CODE' || CHR(10) ||
        '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
        '    , A.ITEM_ID' || CHR(10) ||
        '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
        '    , A.INCOTERMS' || CHR(10) ||
        '    , A.FCST_TYPE' || CHR(10) ||
        '    , A.DOM_EXP' || CHR(10) ||
        '    , A.MEASURE' || CHR(10) ||
        '    , A.END_CUSTOMER' || CHR(10) ||
        '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
        '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
        '    , A.NICK_NAME' || CHR(10) ||
        '    , A.DMS_SALES' || CHR(10) ||
        '    , A.DMS_CUSTOMER' || CHR(10) ||
        '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
        '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
        '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
        '    , C.DAYOFWEEK' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
        '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
        '    , A.ITEM_TYPE' || CHR(10) ||
        '    , A.PROJECT_NAME' || CHR(10) ||
        '    , A.PROJECT_OWNER' || CHR(10) ||
        '    , A.OWNER' || CHR(10) ||
        '    , A.BIZ_TYPE' || CHR(10) ||
        '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
        '    , A.COUNTRY_NAME' || CHR(10) ||
        '    , A.CITY_NAME' || CHR(10) ||
        '    , A.PROJECT_STATUS' || CHR(10) ||
        '    , A.ITEM_NAME' || CHR(10) ||
        '    , A.VMI_YN' || CHR(10) ||
        '    , A.CUST_GROUP' || CHR(10) ||
        '    , A.CUST_GROUP_DTL' || CHR(10) ||
        '    , A.APPLICATION' || CHR(10) ||
        '    , A.ROUTE' || CHR(10) ||
        '    , A.MDM_PROJECT_NAME' || CHR(10) ||
        '    , A.MIN_CAPACITY' || CHR(10) ||
        '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '    , A.CELL_TYPE' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '    , A.FORECAST_INFO_ALL' || CHR(10) ||
        '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
        '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
        '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
        '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
        '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
        '                THEN D.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                ELSE D.QTY END AS NUMBER(10)) AS QTY' || CHR(10) ||
        '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
        '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
        '    , CASE' || CHR(10) ||
        '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
        '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
        '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
        '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          ELSE ''N''' || CHR(10) ||
        '      END AS EDIT_FLAG' || CHR(10) ||
        '    , A.CELL_PER_CAR' || CHR(10) ||
        '    , A.CELL_PER_MODULE' || CHR(10) ||
        '    , A.MODULE_PER_CAR' || CHR(10) ||
        '    , A.SORT_ORDER_NO' || CHR(10) ||
        '    , A.MEASURE_GROUP' || CHR(10) ||
        '    , A.ENERGE' || CHR(10) ||
        '    , A.CELL_QUANTITY' || CHR(10) ||
        '    , A.NEW_FLAG' || CHR(10) ||
        '    , NVL(VM.VMI_VAL,'''')                                  AS VMI_STD_DIO' || CHR(10) ||
        '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
        '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
        '    , A.AS_YN' || CHR(10) ||
        '    , A.AS_FROM_SITE' || CHR(10) ||
        '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
        '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
        '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
        '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
        '    , CASE WHEN 1 = 2 THEN '' '' END AS NOTATION' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT' || CHR(10) ||
        '          NVL(M.DIVISION_ID,  P.DIVISION_ID)                AS DIVISION_ID' || CHR(10) ||
        '        , NVL(M.PROJECT_CODE, P.PROJECT_CODE)               AS PROJECT_CODE' || CHR(10) ||
        '        , NVL(M.SCM_SITE_ID,  P.SCM_SITE_ID)                AS SCM_SITE_ID' || CHR(10) ||
        '        , NVL(M.PLANT_SITE_ID,P.PLANT_SITE_ID)              AS PLANT_SITE_ID' || CHR(10) ||
        '        , NVL(M.ITEM_ID,      P.ITEM_ID)                    AS ITEM_ID' || CHR(10) ||
        '        , NVL(M.DOM_EXP,      P.DOM_EXP)                    AS DOM_EXP' || CHR(10) ||
        '        , NVL(M.FCST_TYPE,    P.FCST_TYPE)                  AS FCST_TYPE' || CHR(10) ||
        '        , NVL(M.INCOTERMS,    P.INCOTERMS)                  AS INCOTERMS' || CHR(10) ||
        '        , CASE WHEN P.MEASURE IS NOT NULL OR NVL(P.MEASURE,'''') <> '''' THEN P.MEASURE' || CHR(10) ||
        '               WHEN M.MEASURE IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
        '               ELSE M.MEASURE END                           AS MEASURE' || CHR(10) ||
        '        , CASE WHEN P.MEASURE_GROUP IS NOT NULL OR NVL(P.MEASURE_GROUP,'''') <> '''' THEN P.MEASURE_GROUP' || CHR(10) ||
        '               WHEN M.MEASURE_GROUP IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
        '               ELSE M.MEASURE_GROUP END                     AS MEASURE_GROUP' || CHR(10) ||
        '        , M.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '        , NVL(M.END_CUSTOMER,   P.END_CUSTOMER)             AS END_CUSTOMER' || CHR(10) ||
        '        , NVL(M.NICK_NAME,      P.NICK_NAME)                AS NICK_NAME' || CHR(10) ||
        '        , M.DMS_SALES' || CHR(10) ||
        '        , M.DMS_CUSTOMER' || CHR(10) ||
        '        , M.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '        , NVL(M.DEPT_ID,        P.DEPT_ID)                  AS DEPT_ID' || CHR(10) ||
        '        , NVL(M.DEPT_NAME_KO,   P.DEPT_NAME_KO)             AS DEPT_NAME_KO' || CHR(10) ||
        '        , NVL(M.ITEM_TYPE,      P.ITEM_TYPE)                AS ITEM_TYPE' || CHR(10) ||
        '        , NVL(M.PROJECT_NAME,   P.PROJECT_NAME)             AS PROJECT_NAME' || CHR(10) ||
        '        , NVL(M.PROJECT_OWNER,  P.PROJECT_OWNER)            AS PROJECT_OWNER' || CHR(10) ||
        '        , NVL(M.OWNER,          P.OWNER)                    AS OWNER' || CHR(10) ||
        '        , NVL(M.BIZ_TYPE,       P.BIZ_TYPE)                 AS BIZ_TYPE' || CHR(10) ||
        '        , NVL(M.SOLDTO_CUSTOMER,P.SOLDTO_CUSTOMER)          AS SOLDTO_CUSTOMER' || CHR(10) ||
        '        , NVL(M.COUNTRY_NAME,   P.COUNTRY_NAME)             AS COUNTRY_NAME' || CHR(10) ||
        '        , NVL(M.CITY_NAME,      P.CITY_NAME)                AS CITY_NAME' || CHR(10) ||
        '        , NVL(M.PROJECT_STATUS, P.PROJECT_STATUS)           AS PROJECT_STATUS' || CHR(10) ||
        '        , NVL(M.ITEM_NAME,      P.ITEM_NAME)                AS ITEM_NAME' || CHR(10) ||
        '        , NVL(M.VMI_YN,         P.VMI_YN)                   AS VMI_YN' || CHR(10) ||
        '        , M.CUST_GROUP' || CHR(10) ||
        '        , M.CUST_GROUP_DTL' || CHR(10) ||
        '        , M.APPLICATION' || CHR(10) ||
        '        , M.ROUTE' || CHR(10) ||
        '        , M.MDM_PROJECT_NAME' || CHR(10) ||
        '        , M.MIN_CAPACITY' || CHR(10) ||
        '        , M.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '        , M.CELL_TYPE' || CHR(10) ||
        '        , M.FORECAST_INFO_ALL' || CHR(10) ||
        '        , M.FORECAST_INFO_SPEC' || CHR(10) ||
        '        , M.FORECAST_INFOR_VERSION' || CHR(10) ||
        '        , M.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '        , M.CELL_PER_CAR' || CHR(10) ||
        '        , M.CELL_PER_MODULE' || CHR(10) ||
        '        , M.MODULE_PER_CAR' || CHR(10) ||
        '        , NVL(P.SORT_ORDER_NO, M.SORT_ORDER_NO)             AS SORT_ORDER_NO' || CHR(10) ||
        '        , NVL(M.ENERGE,         P.ENERGE)                   AS ENERGE' || CHR(10) ||
        '        , NVL(M.CELL_QUANTITY,  P.CELL_QUANTITY)            AS CELL_QUANTITY' || CHR(10) ||
        '        , CASE WHEN M.DIVISION_ID IS NULL THEN ''Y'' ELSE ''N'' END AS NEW_FLAG' || CHR(10) ||
        '        , ''' || LP_AS_YN || '''                             AS AS_YN' || CHR(10) ||
        '        , M.AS_FROM_SITE' || CHR(10) ||
        '        , M.CREATE_DATE' || CHR(10) ||
        '        , M.LAST_UPDATED_BY' || CHR(10) ||
        '        , M.SENDER_CODE' || CHR(10) ||
        '        , M.SENDER_NAME' || CHR(10) ||
        '        , M.YYYYMMDD' || CHR(10) ||
        '    FROM SCM_MGR.GT_GGET_SALES_PRICE P' || CHR(10) ||
        '    FULL OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST M' || CHR(10) ||
        '      ON  P.DIVISION_ID   = M.DIVISION_ID' || CHR(10) ||
        '      AND P.PROJECT_CODE  = M.PROJECT_CODE' || CHR(10) ||
        '      AND P.SCM_SITE_ID   = M.SCM_SITE_ID' || CHR(10) ||
        '      AND P.PLANT_SITE_ID = M.PLANT_SITE_ID' || CHR(10) ||
        '      AND P.ITEM_ID       = M.ITEM_ID' || CHR(10) ||
        '      AND P.FCST_TYPE     = M.FCST_TYPE' || CHR(10) ||
        '      AND P.INCOTERMS     = M.INCOTERMS' || CHR(10) ||
        '      AND P.DOM_EXP       = M.DOM_EXP' || CHR(10) ||
        '      AND P.MEASURE       = M.MEASURE' || CHR(10) ||
        ') A' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_GGET_MKT_FCST_DATA D' || CHR(10) ||
        '  ON  A.DIVISION_ID   = D.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE  = D.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID   = D.SCM_SITE_ID' || CHR(10) ||
        '  AND A.PLANT_SITE_ID = D.PLANT_SITE_ID' || CHR(10) ||
        '  AND A.ITEM_ID       = D.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP       = D.DOM_EXP' || CHR(10) ||
        '  AND A.FCST_TYPE     = D.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS     = D.INCOTERMS' || CHR(10) ||
        '  AND A.MEASURE       = D.MEASURE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '  ON  C.BASIS_YYYYMMDD = D.YYYYMMDD' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
        '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
        '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
        '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
        '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
        '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
        '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
        '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
        '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
        '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
        '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
        '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
        '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = VM.KEY_JOIN' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
        '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
        '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
        '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
        '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
        '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
        '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
        '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
        '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
        '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
        ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
        '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
        '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
        '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
        '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
        '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
        '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
        '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
        '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
        '    UNION' || CHR(10) ||
        '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
        ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
        'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
        ')' || CHR(10) ||
        -- ── PIVOT WRAPPER (일별/주별/월별 UNION ALL + PIVOT) ──────────────────────
        'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
        ') F' || CHR(10) ||
        'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
        '[@V_ORDERBY]';


    ELSE

        -- -----------------------------------------------------------------------
        -- 비AS 경로 보완 처리: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 추가
        -- -----------------------------------------------------------------------
		-- IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND AND LP_AS_YN = 'Y' THEN
        IF LP_AS_YN = 'Y' THEN
            DECLARE
                V_AS_CNT2 PLS_INTEGER := 0;
            BEGIN
                SELECT COUNT(1) INTO V_AS_CNT2
                FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
                WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');

                IF V_AS_CNT2 > 0 THEN
                    -- AS 사이트에 해당하는 조합 중 AS 메저가 없는 날짜에 QTY=0 행 삽입
                    INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
                    , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                    , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
                    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER
                    , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
                    , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
                    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
                    , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
                    , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                    , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                         , C.MEASURE
                         , A.YYYYMMDD   -- MAX(YYYYMMDD) 기준 날짜 사용
                         , 0  AS QTY
                         , C.MEASURE_GROUP
                         , A.CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                         , A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO
                         , A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER
                         , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                         , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                         , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                         , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                         , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                         , C.SORT_ORDER_NO
                         , A.ENERGE, A.CELL_QUANTITY
                         , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
                    FROM (
                        -- AS 사이트 기반 헤더 (최신 YYYYMMDD)
                        SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                             , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                             , MAX(A2.YYYYMMDD) AS YYYYMMDD
                             , 0 AS QTY
                             , A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                             , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
                             , A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
                             , A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
                             , A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
                             , A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
                             , A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                             , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                             , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                             , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                             , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                        FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA A2
                        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
                          ON   A2.SCM_SITE_ID = B2.SEGMENT1
                         AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
                         AND   B2.SEGMENT3    = P_DIVISION_ID
                        GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                               ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                               ,  A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                               ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
                               ,  A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
                               ,  A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
                               ,  A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
                               ,  A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
                               ,  A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                               ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                               ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                               ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                               ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    ) A
                    -- AS_IN_REQ/PLAN/INV 메저 CROSS JOIN
                    JOIN (
                        SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
                        FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
                        WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
                    ) C ON 1=1
                    -- 이미 존재하는 조합 제외
                    LEFT OUTER JOIN (
                        SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                                      , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                        FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
                        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
                          ON   D2.SCM_SITE_ID = B3.SEGMENT1
                         AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
                         AND   B3.SEGMENT3    = P_DIVISION_ID
                    ) D ON  A.DIVISION_ID   = D.DIVISION_ID
                        AND A.PROJECT_CODE  = D.PROJECT_CODE
                        AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                        AND A.ITEM_ID       = D.ITEM_ID
                        AND A.DOM_EXP       = D.DOM_EXP
                        AND A.FCST_TYPE     = D.FCST_TYPE
                        AND A.INCOTERMS     = D.INCOTERMS
                        AND C.MEASURE       = D.MEASURE
                        AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
                    WHERE D.DIVISION_ID IS NULL;
                END IF;
            END;
        END IF;

        -- -----------------------------------------------------------------------
        -- PIVOT SQL #2 (비AS용, 일반 경로)
        --   소스: GT_GGET_MKT_FCST_DATA  → #MF (임시)
        --         → PIVOT + EXECUTE IMMEDIATE
        -- -----------------------------------------------------------------------
        V_SQL_TEXT :=
        'WITH MF_BASE AS (' || CHR(10) ||
        'SELECT' || CHR(10) ||
        '      A.DIVISION_ID' || CHR(10) ||
        '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
        '    , A.SCM_SITE_ID' || CHR(10) ||
        '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
        '    , A.PLANT_SITE_ID' || CHR(10) ||
        '    , A.PROJECT_CODE' || CHR(10) ||
        '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
        '    , A.ITEM_ID' || CHR(10) ||
        '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
        '    , A.INCOTERMS' || CHR(10) ||
        '    , A.FCST_TYPE' || CHR(10) ||
        '    , A.DOM_EXP' || CHR(10) ||
        '    , A.MEASURE' || CHR(10) ||
        '    , A.END_CUSTOMER' || CHR(10) ||
        '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
        '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
        '    , A.NICK_NAME' || CHR(10) ||
        '    , A.DMS_SALES' || CHR(10) ||
        '    , A.DMS_CUSTOMER' || CHR(10) ||
        '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
        '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
        '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
        '    , C.DAYOFWEEK' || CHR(10) ||
        '    , A.CELL_MODEL                                          AS FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
        '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
        '    , A.ITEM_TYPE' || CHR(10) ||
        '    , A.PROJECT_NAME' || CHR(10) ||
        '    , A.PROJECT_OWNER' || CHR(10) ||
        '    , A.OWNER' || CHR(10) ||
        '    , A.BIZ_TYPE' || CHR(10) ||
        '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
        '    , A.COUNTRY_NAME' || CHR(10) ||
        '    , A.CITY_NAME' || CHR(10) ||
        '    , A.PROJECT_STATUS' || CHR(10) ||
        '    , A.ITEM_NAME' || CHR(10) ||
        '    , A.VMI_YN' || CHR(10) ||
        '    , A.CUST_GROUP' || CHR(10) ||
        '    , A.CUST_GROUP_DTL' || CHR(10) ||
        '    , A.APPLICATION' || CHR(10) ||
        '    , A.ROUTE' || CHR(10) ||
        '    , A.MDM_PROJECT_NAME' || CHR(10) ||
        '    , A.MIN_CAPACITY' || CHR(10) ||
        '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '    , A.CELL_TYPE' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '    , A.FORECAST_INFO_ALL' || CHR(10) ||
        '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
        '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
        '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
        '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
        '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
        '                THEN A.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                ELSE A.QTY END AS NUMBER(36,10)) AS QTY' || CHR(10) ||
        '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
        '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
        '    , CASE' || CHR(10) ||
        '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
        '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
        '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
        '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          ELSE ''N''' || CHR(10) ||
        '      END AS EDIT_FLAG' || CHR(10) ||
        '    , A.CELL_PER_CAR' || CHR(10) ||
        '    , A.CELL_PER_MODULE' || CHR(10) ||
        '    , A.MODULE_PER_CAR' || CHR(10) ||
        '    , A.SORT_ORDER_NO' || CHR(10) ||
        '    , A.MEASURE_GROUP' || CHR(10) ||
        '    , A.ENERGE' || CHR(10) ||
        '    , A.CELL_QUANTITY' || CHR(10) ||
        '    , ''N''                                                 AS NEW_FLAG' || CHR(10) ||
        '    , CASE WHEN A.DIVISION_ID = ''40''' || CHR(10) ||
        '           THEN TO_CHAR(CAST(VM.VMI_STD_DIO AS NUMBER))' || CHR(10) ||
        '           ELSE VM.VMI_VAL END                              AS VMI_STD_DIO' || CHR(10) ||
        '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
        '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
        '    , ''' || LP_AS_YN || '''                                AS AS_YN' || CHR(10) ||
        '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
        '    , NVL(A.AS_FROM_SITE,'''')                             AS AS_FROM_SITE' || CHR(10) ||
        '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
        '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
        '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
        '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
        '    , A.NOTATION' || CHR(10) ||
        'FROM SCM_MGR.GT_GGET_MKT_FCST_DATA A' || CHR(10) ||
        'INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '  ON  C.BASIS_YYYYMMDD = A.YYYYMMDD' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
        '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
        '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
        '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
        '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
        '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
        '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
        '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
        '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
        '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
        '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
        '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
        '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
        '  ON  A.ITEM_ID     = CASE WHEN ''' || P_DIVISION_ID || ''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END' || CHR(10) ||
        '  AND ( ''' || P_DIVISION_ID || ''' = ''40''  ' || CHR(10) ||
        '        OR A.SCM_SITE_ID = VM.KEY_JOIN )' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
        '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
        '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
        '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
        '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
        '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
        '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
        '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
        '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
        '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
        ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
        '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
        '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
        '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
        '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
        '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
        '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
        '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
        '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
        '    UNION' || CHR(10) ||
        '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
        ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
        'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
        ')' || CHR(10) ||
        -- ── PIVOT WRAPPER (동일) ──────────────────────────────────────────────────
        'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
        ') F' || CHR(10) ||
        'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
        '[@V_ORDERBY]';

    END IF;



    -----------------------------------------------------------------------
    -- 플레이스홀더 치환
    -----------------------------------------------------------------------
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]',  V_PV_COL_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',      V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',       V_COLUMN);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_groupby]',      V_GROUPBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_team_id]',      V_TEAM_WHERE);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_created_by]',   P_CREATED_BY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_group_id]',     V_GROUP_ID);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_orderby]',      V_ORDERBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',      V_ORDERBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_from_yyyymmdd]',P_FROM_YYYYMMDD);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_to_yyyymmdd]',  P_TO_YYYYMMDD);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@CellQtyYN]',      P_CELL_YN);
    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -----------------------------------------------------------------------
    -- EXECUTE IMMEDIATE → O_RC 반환
    -----------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);
    OPEN O_RC1 FOR V_SQL_TEXT;

    -----------------------------------------------------------------------
    -- O_RC2: 8주 이내 버킷 정보 (20181115 소형 사업부 일별 입력 전용)
    -- 원본: SELECT TOP 1 * FROM SCM_SYS_CALENDAR_M
    --       WHERE ISO_WEEK = DATEPART(ISO_WEEK, DATEADD(WEEK,7,GETDATE()))
    --         AND CALENDAR_YYYY = DATEPART(YEAR, DATEADD(WEEK,7,GETDATE()))
    --       ORDER BY BASIS_YYYYMMDD
    -----------------------------------------------------------------------
    OPEN O_RC2 FOR
        SELECT *
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE  ISO_YYYYWW  = TO_CHAR(SYSDATE + (7*7), 'IYYY') ||
                             TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE + (7*7), 'IW')), 'FM00')
        ORDER  BY BASIS_YYYYMMDD
        FETCH  FIRST 1 ROW ONLY;

    -----------------------------------------------------------------------
    -- O_RC3: 현재 주차 정보 (20211130)
    -- 원본: SELECT 'M_'+THIS_YYYYMM, 'W_'+THIS_YYYYMMWW, ...
    --                현재주 + 전주 정보
    -----------------------------------------------------------------------
    OPEN O_RC3 FOR
        SELECT 'M_' || A.BASIS_YYYYMM                         AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK           AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM                         AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK           AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM, A.ISO_WEEK
        FROM   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) A
        JOIN   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')) B ON 1=1;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;

        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'    VALUE P_CREATED_BY,
            'P_USER_GROUP'    VALUE P_USER_GROUP,
            'P_ITEM_ID'       VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE
         || ' / SQLERRM='   || V_SQL_ERRMSG
         || ' / BACKTRACE=' || V_BACKTRACE
         || ' / PARAMS='    || V_PROC_INPUT
        );

END DMF0003_GET_MKT_FCST_DATA;
/
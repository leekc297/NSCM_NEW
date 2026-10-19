-- SOURCE-FRESH: SCM_MGR.PKG_DMF0021 PACKAGE BODY LAST_DDL=2026-09-22 13:09:31 FETCHED=2026-09-22 14:22 DB=ZIOUI1
PACKAGE BODY         "PKG_DMF0021" AS

  PROCEDURE P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX
/* [E20260715] MSSQL '' = Oracle NULL 변환 함정 정정 — 숨김 필수 컬럼 포함 조건 DEFAULT_FLAG=''(항상 거짓, 실데이터 'N')를 NVL(DEFAULT_FLAG,'N')<>'Y' 로. SALES_PLAN_ADJUST_YN/GROUP_ID 커서 탈락 → R1 전행 잠금 사고. admin */
(
      p_division_id      IN  VARCHAR2        -- NVARCHAR(30)    사업부 코드 (DIVISION_ID)
    , p_dept_id          IN  VARCHAR2        -- NVARCHAR(4000)  부서 코드 (콤마구분 멀티, 'ALL' 시 전체)
    , p_end_customer     IN  VARCHAR2        -- NVARCHAR(4000)  End Customer (콤마구분 멀티, 'ALL' 시 전체)
    , p_scm_site_id      IN  VARCHAR2        -- NVARCHAR(4000)  SCM Site ID (콤마구분 멀티, 'ALL' 시 전체)
    , p_project_code     IN  VARCHAR2        -- NVARCHAR(4000)  프로젝트 코드/명 (콤마구분 멀티, LIKE 검색)
    , p_item_id          IN  VARCHAR2        -- NVARCHAR(4000)  아이템 ID/닉네임 (콤마구분 멀티, LIKE 검색)
    , p_item_type        IN  VARCHAR2        -- NVARCHAR(4000)  아이템 타입 (콤마구분 멀티, 'ALL' 시 전체)
    , p_from_yyyymmdd    IN  VARCHAR2        -- NVARCHAR(8)     조회 시작일 (YYYYMMDD)
    , p_now_yyyymmdd     IN  VARCHAR2        -- NVARCHAR(8)     실적(R)/계획(P) 구간 분기 기준일 (YYYYMMDD)
    , p_to_yyyymmdd      IN  VARCHAR2        -- NVARCHAR(8)     조회 종료일 (YYYYMMDD)
    , p_created_by       IN  VARCHAR2        -- NVARCHAR(4000)  조회/생성 사용자 ID (타이틀셋·팀 기준)
    , p_plant_site_id    IN  VARCHAR2        -- NVARCHAR(4000)  Plant Site ID (콤마구분 멀티, 'ALL' 시 전체)
    , p_biztype          IN  VARCHAR2        -- NVARCHAR(4000)  Biz Type (콤마구분 멀티, 'ALL' 시 전체)
    , p_owner            IN  VARCHAR2        -- NVARCHAR(4000)  Owner(담당자) (콤마구분 멀티, LIKE 검색)
    , p_internal_yn      IN  VARCHAR2        -- NVARCHAR(1)     내부거래(사내) 포함 여부 (Y/N)
    , p_userinfo         IN  VARCHAR2        -- NVARCHAR(150)   권한 판단용 사용자 정보(권한그룹)
    , p_bucket           IN  VARCHAR2        -- NVARCHAR(10)    조회 버킷 (DAILY/WEEKLY/MONTHLY) -- 20211026 SALES PLAN 속도 개선
    , p_user_dept_id     IN  VARCHAR2        -- NVARCHAR(50)    사용자 부서 (JV Planner 시 Sales Site 산출용)
    , p_cur_result       OUT SYS_REFCURSOR   -- 메인 결과셋: 버킷별 PIVOT 매출계획/실적 그리드
    , p_cur_calendar     OUT SYS_REFCURSOR   -- 당주/전주 기준 YYYYMM·주차 정보
    , p_cur_edit_auth    OUT SYS_REFCURSOR   -- 메져 편집권한 (EDIT_AUTH_SalesAmt_LOC / EDIT_AUTH_RTF_SYS_RP)
)
/* ============================================================
 * Program ID   : DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx
 * Description  : Sales Plan(매출계획) 조회 — 사업부/사이트/아이템/메져별 매출계획·실적을
 *                기간(from~now~to) 기준으로 집계하여 버킷(DAILY/WEEKLY/MONTHLY) PIVOT 형태로 반환.
 * Usage        : GSCM SCM.DM 'Sales Plan' 화면(DMF0021) 조회 시 호출.
 *                메인 PIVOT 그리드 + 당주/전주 달력정보 + 메져 편집권한, 총 3개 결과셋(REF CURSOR) 반환.
 * 화면 / 시트  : DMF0021 / 'Sales Plan'
 *                (SCM_MST_TITLESET_USER·SCM_MST_SHEET_MEASURE·SCM_MST_SHEET_COLUMNS 의 PROGRAM_ID='DMF0021', SHEET_NAME='Sales Plan')
 * 기능 요약    : 사용자 권한/팀 정보를 산출하고, 사용자가 선택한 메져와 계산용 보조 메져를 셋팅한 뒤,
 *                계획(DM_PLN_SALES_PLAN/ETC_PLAN)·실적(DM_PLN_SALES_PLAN_RESULT)을 GTT(RAW_DATA)로 통합 적재한다.
 *                조회조건 필터링 후 실적/계획 구간 단가(LOC/KRW/USD)와 파생 메져(CAR/CELL/ENERGY/RTF_BALANCE 등)를 생성하고,
 *                컬럼리스트·날짜버킷을 동적으로 만들어 WITH WF 인라인뷰 + 동적 PIVOT 으로 최종 그리드를 반환한다.
 *
 * 주요 흐름    : 1) 권한 산출: GET_ADMIN_GROUP(ADMIN), GET_ADMIN_GROUP_MEASURE(메져편집권한), 사용자 팀(부서) LISTAGG
 *                2) 메져 셋팅: 타이틀셋 기반 조회메져 + 계산용 보조메져(RTF_SYS_RP/SalesAmt 등) 추가
 *                3) RAW_DATA 적재: 계획(P)·기타매출·실적(R) + MKT_FCST_RP/RTF_PR/RTF_BALANCE/SCM_FCST 파생
 *                4) 아이템/사이트 마스터 TEMP(GTT) 적재 (ITEM_SINGLE_ORI/A/B/V, SCM_MST_SITE_ITEM)
 *                5) 조회조건 필터링 (project/item/owner/dept/end_customer/site/plant/item_type/biztype)
 *                6) 실적구간 PRICE(LOC/KRW) + 계획구간 PRICE(40:DM_PLN_CFM_SELLING_PRICE / 그외:SCM_MST_FUTURE_PRICE)
 *                7) 보조메져 삭제 + 물리 미생성 메져(CAR/CELL/ENERGY) 생성
 *                8) 컬럼리스트/날짜버킷 동적 생성 → WITH WF + PIVOT 동적 SQL OPEN(p_cur_result)
 *                9) 당주/전주 달력(p_cur_calendar), 편집권한(p_cur_edit_auth) 반환
 *
 * 입력 파라미터:
 *     p_division_id      IN     VARCHAR2     : 사업부 코드
 *     p_dept_id          IN     VARCHAR2     : 부서 코드(콤마 멀티, 'ALL'=전체)
 *     p_end_customer     IN     VARCHAR2     : End Customer(콤마 멀티, 'ALL'=전체)
 *     p_scm_site_id      IN     VARCHAR2     : SCM Site ID(콤마 멀티, 'ALL'=전체)
 *     p_project_code     IN     VARCHAR2     : 프로젝트 코드/명(콤마 멀티, LIKE)
 *     p_item_id          IN     VARCHAR2     : 아이템 ID/닉네임(콤마 멀티, LIKE)
 *     p_item_type        IN     VARCHAR2     : 아이템 타입(콤마 멀티, 'ALL'=전체)
 *     p_from_yyyymmdd    IN     VARCHAR2     : 조회 시작일(YYYYMMDD)
 *     p_now_yyyymmdd     IN     VARCHAR2     : 실적/계획 분기 기준일(YYYYMMDD)
 *     p_to_yyyymmdd      IN     VARCHAR2     : 조회 종료일(YYYYMMDD)
 *     p_created_by       IN     VARCHAR2     : 조회/생성 사용자 ID
 *     p_plant_site_id    IN     VARCHAR2     : Plant Site ID(콤마 멀티, 'ALL'=전체)
 *     p_biztype          IN     VARCHAR2     : Biz Type(콤마 멀티, 'ALL'=전체)
 *     p_owner            IN     VARCHAR2     : Owner(콤마 멀티, LIKE)
 *     p_internal_yn      IN     VARCHAR2     : 내부거래 포함 여부(Y/N)
 *     p_userinfo         IN     VARCHAR2     : 권한 판단용 사용자 정보
 *     p_bucket           IN     VARCHAR2     : 조회 버킷(DAILY/WEEKLY/MONTHLY)
 *     p_user_dept_id     IN     VARCHAR2     : 사용자 부서(JV Planner용)
 *     p_cur_result       OUT    SYS_REFCURSOR: 버킷별 PIVOT 매출계획/실적 메인 그리드
 *     p_cur_calendar     OUT    SYS_REFCURSOR: 당주/전주 기준 YYYYMM·주차 정보
 *     p_cur_edit_auth    OUT    SYS_REFCURSOR: 메져 편집권한(SalesAmt_LOC / RTF_SYS_RP)
 *
 * 관련 테이블  : [조회]   DM_PLN_SALES_PLAN, DM_PLN_SALES_ETC_PLAN, DM_PLN_SALES_PLAN_RESULT,
 *                         DM_PLN_CFM_SELLING_PRICE, SCM_MST_FUTURE_PRICE, SCM_SYS_CALENDAR_M,
 *                         SCM_ADM_LOOKUP_MASTER_DETAIL, TB_FX_User, SCM_MST_SHEET_MEASURE,
 *                         SCM_MST_SHEET_COLUMNS, SCM_MST_SITE, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN,
 *                         SCM_MST_SSO_USER_INFO, SCM_MST_COMPANY_SN, SCM_MST_PROJECT,
 *                         SCM_MST_SITE_CUSTOMER, SCM_MST_CITY, SCM_MST_COUNTRY, SCM_MST_CUSTOMER,
 *                         SCP_PLAN_VERSION_V, SCP_ANL_SHIPMENT_PLAN_FG, SCP_ANL_PROBLEM_REPORT_PEGGING,
 *                         SCP_MST_ITEM_GROUP_DETAIL
 *                [I/U]    SCM_MST_TITLESET_USER (기본 메져 미보유 사용자에 기본 메져 INSERT)
 *                [GTT]    GT_DMF0021_SCM_MST_SHEET_MEASURE, GT_DMF0021_SELECT_MEASURE, GT_DMF0021_RAW_DATA,
 *                         GT_DMF0021_DM_MST_ITEM_SINGLE_ORI/_A/_B/_V, GT_DMF0021_SCM_MST_SITE_ITEM,
 *                         GT_DMF0021_SCM_MST_SITE, GT_DMF0021_SHIPMENT_SITE, GT_DMF0021_SHIPMENT_SITE_ROW,
 *                         GT_DMF0021_COLUMN_SETUP, GT_DMF0021_T
 * 관련 함수    : FN_NEXT_DAY (차주 월요일 등 산출), FN_GET_DM_MKT_OWNER_NAME (Owner 표시명 EN/KO),
 *                String_Split (콤마 파라미터 분해), UF_FX_String_Split (컬럼리스트 분해)
 * 마이그레이션 : #TEMP → GTT(GT_DMF0021_*) / ISNULL→NVL / LEN→LENGTH / CHARINDEX→INSTR /
 *                ISNUMERIC→REGEXP_LIKE / GETDATE()→SYSDATE·SYSTIMESTAMP / DATEADD(DD,-7,FN_NEXT_DAY)→FN_NEXT_DAY()-7 /
 *                STUFF+FOR XML PATH→LISTAGG / UPDATE…FROM→MERGE / DELETE…JOIN→DELETE WHERE NOT EXISTS /
 *                STRING_SPLIT·CROSS APPLY→TABLE(String_Split()) / CURSOR FAST_FORWARD→FOR LOOP /
 *                EXEC SP_EXECUTESQL + PIVOT([X]) → WITH WF 인라인뷰 + 동적 PIVOT('X' AS "X") + OPEN cursor /
 *                결과셋 3개 → SYS_REFCURSOR OUT 3개 / NVARCHAR(MAX) TEXT → VARCHAR2(4000, GROUP BY 호환) /
 *                [dbo]. 스키마·대괄호·GO 제거, 문자열 '+'→'||'
 *
 * [주의사항]
 *     - 최종 메인 그리드는 동적 SQL(WITH WF + PIVOT)이며 PIVOT IN 리스트/컬럼타입은 OPEN 시점에 해석됨 → 운영 데이터로 실행 검증 필수.
 *     - 82사업부 수치표기는 원본 CONVERT(float,FORMAT(...,'##0.##########')) 를 ROUND(A.QTY,10) 으로 근사 변환함.
 *     - RAW_DATA.TEXT 는 GROUP BY/DISTINCT/조인 키로 사용되어 CLOB→VARCHAR2(4000) 로 변경(4000자 초과 시 검토 필요).
 *     - 동적 SQL 에 파라미터(bucket/dept_list/group_id/from/to)를 리터럴로 임베드(원본 SP_EXECUTESQL 동작 보존).
 *     - Oracle GTT 는 세션/COMMIT 시 자동 정리되므로 원본 DROP TABLE 블록은 시작 시 DELETE 초기화로 대체.
 *     - 상세 전환 이슈는 ISSUE_REPORT\ISSUE_REPORT_conversion.xlsx(DMF0021) 참조.
 *
 * [변경이력]
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
  * 2021.11.02	hwi1993		2021 하반기 과제 - 속도개선을 위해서 구조 번경
 * 2021.11.18	kdw2819		[과제]	자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021.11.19	ROSIA27		[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021.12.07	rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2022.01.21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2022.03.22   kdw2819     [C20220318-000248] GSCM Sales Plan 및 Sales Monitoring의 Unit Price 컬럼값 표기 오류 수정 요청의 건
 * 2022.04.07	rosia27		[과제PJ20216891R]GM_JV
 * 2022.12.14	rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023.06.21   leetw85     [E20230619-000151]  GSCM.DM 소수점 표기 방식 변경
 * 2023.09.18	jssbae		[E20230912-000426]_소형사업부- Sales Plan 화면 'Module' Biz Type 표기 룩업
 * 2023.12.19   JSSBAE      [E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall
 * 2024.04.04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선)
 * 2024.04.16   KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
 * 2024.05.17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024.08.02   JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024.08.26   JSSBAE		[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼메저 추가
 * 2024.08.27	KJJ			[PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 * 2024.09.12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.11.04	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
 * 2024.11.27	KJJ			[PJ2024-50611] 소형사업부는 원래대로 ETC만 수정 가능하게 처리 : 잘못 추가된 로직 제거
 * 2024.11.28	KJJ			[PJ2024-50611] 소형사업부는 Catch Up도 수정 가능하게 처리
 * 2024.12.12	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.03.12   dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.04.15   dsiol		[PJ2025-50188]LGES SCM DM 소형사업부 매출계획 동기화 개선 : SCM_FCST - MEASURE 추가
 * 2025.04.29   JSSBAE		[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가
 * 2025.05.21   JSSBAE		[E20250520-000574]_SALES PLAN, SALES PLAN WATERFALL UI의 RTF_PR Measure 조회 로직 변경
 * 2025.06.02   kjiyoon		[PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
 * 2025.06.02	kjiyoon		[PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
 * 2025.07.02	JSSBAE		[E20250520-000605]_[영업.마케팅PI] Sales Plan - ETC Data 'Monthly' 입력 Bucket 기능 수정 요청
 * 2025.07.07	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.11.21	JSSBAE		[E20251120-001430]_Sales Plan 당주 구간 RTF 수정 불가 개선
 * 2026.04.01	JSSBAE		[E20260331-000648]_[자동차 SCM] 자동차사업부 '기준수요'기능 중 'RTF수정기능'만 우선 적용 요청 건
 * 2026.05.12	JSSBAE		[E20260512-000502]_자동차 사업부 Cell Prod Site ID
 * 2026.05.29	ZIONEX			[PJ202650304] NextSCM Migration
 * ============================================================ */
 /* EXEC DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx @p_division_id='82', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='8minute Energy_US_EFS', @p_project_code='', @p_item_id='', @p_item_type='ALL', @p_from_yyyymmdd='20230501', @p_now_yyyymmdd='20230814', @p_to_yyyymmdd='20231031', @p_created_by='chano0612', @p_plant_site_id='ALL', @p_biztype='ALL', @p_userinfo='ADMIN', @p_owner='', @p_internal_yn='N', @p_bucket='MONTHLY', @p_user_dept_id='ICH' */
IS
    --=================================================================================================================================
    -- 사용 변수 선언 (START)
    --=================================================================================================================================
    v_Prod                  CLOB;
    v_ColList               CLOB;
    v_OrderList             CLOB;
    v_nsql                  CLOB;
    v_nsql2                 CLOB;
    v_p_program_id          VARCHAR2(50 CHAR)   := 'DMF0021';
    v_p_sheet_name          VARCHAR2(50 CHAR)   := 'Sales Plan';
    v_dept_list             VARCHAR2(4000 CHAR) := '';
    v_group_id              VARCHAR2(50 CHAR)   := '';
    -- [2026-09-21 / POJ] 팀명 다국어 표시용 사용자 언어코드
    v_lang_cd               VARCHAR2(10 CHAR)   := 'KO';

    v_MEASURE               PLS_INTEGER := 0;
    v_i_count               PLS_INTEGER := 0;
    -- 20200316 KHSONG C20200224-000109
    v_user_mea_cnt          PLS_INTEGER := 0;
    -- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
    v_start_yyyymmdd        VARCHAR2(8 CHAR);

    v_admin_cnt             PLS_INTEGER := 0;
    v_meas_cnt              PLS_INTEGER := 0;

    -- [PJ2025-50188] GET_ADMIN_GROUP_MEASURE 권한
    v_EDIT_AUTH_SalesAmt_LOC  VARCHAR2(1 CHAR) := 'N'; --SalesAmt_LOC
    v_EDIT_AUTH_RTF_SYS_RP    VARCHAR2(1 CHAR) := 'N'; --RTF_SYS_RP

    -- 동적 SQL용 변수
    v_sql_text              CLOB;
    v_PV_LIST               CLOB;
    v_PV_COL_LIST           CLOB;
    v_column_name           VARCHAR2(100 CHAR);
    v_column                VARCHAR2(1000 CHAR);
    v_orderby               VARCHAR2(1000 CHAR);
    v_column_text           VARCHAR2(1000 CHAR);
    v_PV_column_name        VARCHAR2(100 CHAR);
    v_PV_NAME               VARCHAR2(50 CHAR);
    v_column_type           VARCHAR2(50 CHAR);
    v_column_value          VARCHAR2(50 CHAR);
    v_sort_order_no         VARCHAR2(50 CHAR);
    v_sum_qty               VARCHAR2(1000 CHAR);
    v_qty_div               VARCHAR2(1000 CHAR);
    v_avg_qty               VARCHAR2(1000 CHAR);

    -- SHIPMENT 컬럼용 [PJ20200138]
    v_SHIP_DIVISION_ID            VARCHAR2(30 CHAR);
    v_SHIP_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR);
    v_SHIP_PLAN_TYPE              VARCHAR2(50 CHAR);
    v_SHIP_PPLAN_SEQ              PLS_INTEGER;
    v_SHIP_PPLAN_ID               VARCHAR2(30 CHAR);
    v_SHIP_PMODELING_ID           VARCHAR2(30 CHAR);

    -- 동적 SQL SELECT/GROUPBY 작성용
    v_SQL_SELECT            CLOB;
    v_SQL_GROUPBY           CLOB;
    v_I                     PLS_INTEGER;
    v_CNT                   PLS_INTEGER;
    --=================================================================================================================================
    -- 사용 변수 선언 (END)
    --=================================================================================================================================
BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
    -- SET NOCOUNT ON / SET ANSI_NULLS ON / SET ANSI_WARNINGS ON;  (Oracle: 불필요)
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    v_ColList   := '';
    v_OrderList := '';
    v_Prod      := '';

    -- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
    SELECT BASIS_START_DATE
      INTO v_start_yyyymmdd
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD = p_from_yyyymmdd;

    --=================================================================================================================================
    -- Temp Table 존재 여부 체크 (START)
    -- 원본 MSSQL DROP TABLE #X → Oracle GTT 사용. 세션 재사용 대비 시작 시 DELETE 로 초기화.
    --=================================================================================================================================
    DELETE FROM GT_DMF0021_SCM_MST_SHEET_MEASURE;
    DELETE FROM GT_DMF0021_SELECT_MEASURE;
    DELETE FROM GT_DMF0021_RAW_DATA;
    DELETE FROM GT_DMF0021_SCM_MST_SITE_ITEM;
    DELETE FROM GT_DMF0021_SHIPMENT_SITE;
    DELETE FROM GT_DMF0021_SHIPMENT_SITE_ROW;
    DELETE FROM GT_DMF0021_SCM_MST_SITE;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_ORI;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_A;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_B;
    DELETE FROM GT_DMF0021_COLUMN_SETUP;
    DELETE FROM GT_DMF0021_T;
    --=================================================================================================================================
    -- Temp Table 존재 여부 체크 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 권한 관리 (START)
    --=================================================================================================================================
    -- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
    SELECT COUNT(1)
      INTO v_admin_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN    = 'Y'
       AND (SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
            OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'))
       AND SEGMENT2    = 'ALL'
       --AND SEGMENT3 = LEFT(@p_division_id,2)
    ;
    IF NVL(v_admin_cnt, 0) > 0 THEN
        v_group_id := 'ADMIN';
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188] 그룹 + 화면 + 사업부 + MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가
    -- Measure 별로 다른 권한을 부여해달라는 요청으로 인하여 GET_ADMIN_GROUP_MEASURE 룩업을 만들었음.
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO v_meas_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
       AND VALID_YN    = 'Y'
       AND (SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
            OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y')) --ADMIN , SCM PI Admin , DM ADMIN , DM Planner , SCP Planner
       AND SEGMENT2    = v_p_program_id
       --[E20260331-000648]_DIVISION_ID별로 변경되었으므로 원소스 주석처리 후 수정
       --AND SEGMENT3  = LEFT(@p_division_id,2) --[E20260331-000648]_원소스 주석처리
       AND SEGMENT3    = p_division_id
       AND SEGMENT4    = 'SalesAmt_LOC';
    IF NVL(v_meas_cnt, 0) > 0 THEN
        v_EDIT_AUTH_SalesAmt_LOC := 'Y';
    END IF;

    SELECT COUNT(1)
      INTO v_meas_cnt
      --[RTFGATE2-FIX 2026-08-18] 별칭 L 필수 — 아래 서브쿼리의 DM_MST_VERSION 도 ATTRIBUTE1~10 을
      --  가지고 있어, 무한정 ATTRIBUTE1/2 는 lookup 이 아니라 **버전 테이블 컬럼**으로 잡힌다
      --  (NULL → DECODE NULL → 앵커 NULL → 비교 UNKNOWN → 권한 상시 0 = RTF 편집 전면 불가).
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
     WHERE L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
       AND L.VALID_YN    = 'Y'
       AND (L.SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
            OR L.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'))
       AND L.SEGMENT2    = v_p_program_id
       --AND SEGMENT3  = LEFT(@p_division_id, 2) --[E20260331-000648]_원소스 주석처리
       AND L.SEGMENT3    = p_division_id
       AND L.SEGMENT4    = 'RTF_SYS_RP';
    IF NVL(v_meas_cnt, 0) > 0 THEN
        v_EDIT_AUTH_RTF_SYS_RP := 'Y';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 사용자의 팀정보 & 권한 - [C20210504-000057] SalesPlan 권한은 있으나 편집안되는 현상 수정 2021/05/13 SJHan
    -- 원본의 STUFF + FOR XML PATH('') 를 Oracle LISTAGG 로 변환
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT LISTAGG(D.SEGMENT3, ',') WITHIN GROUP (ORDER BY D.SEGMENT3) AS SEGMENT
      INTO v_dept_list
      FROM (
            SELECT LOOK.SEGMENT1, LOOK.SEGMENT3
              FROM TB_FX_User USR
              INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                      ON USR.DEPT_ID     = LOOK.SEGMENT1
                     AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                     AND LOOK.VALID_YN   = 'Y'
             WHERE LOOK.VALID_YN = 'Y'
               AND USR.USERID    = p_created_by
             UNION
            -- 매핑이 없는 경우 자기 부서
            SELECT DEPT_ID AS SEGMENT1, DEPT_ID AS SEGMENT3
              FROM TB_FX_User
             WHERE USERID = p_created_by
           ) D
     WHERE D.SEGMENT1 = ( SELECT DEPT_ID FROM TB_FX_User WHERE UserID = p_created_by );

    -- [2026-09-21 / POJ] 팀명 다국어 — 사용자 언어코드를 구한다 (없으면 KO)
    BEGIN
        SELECT NVL(MAX(LANG_CD), 'KO') INTO v_lang_cd
          FROM SCM_MGR.SCM_ADM_USER_M
         WHERE USER_ID = p_created_by;
    EXCEPTION
        WHEN OTHERS THEN v_lang_cd := 'KO';
    END;

    -- DAILY 일 경우 EDIT 불가
    --IF @P_BUCKET = 'DAILY'
    --BEGIN
    --	SELECT @v_group_id = '', @v_dept_list = ''
    --END
    --=================================================================================================================================
    -- 권한 관리 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.*/

    --=================================================================================================================================
    -- 메져정보 셋팅 (START)
    --=================================================================================================================================
    -- 20200316 KHSONG C20200224-000109
    SELECT COUNT(*)
      INTO v_user_mea_cnt
      FROM SCM_MST_TITLESET_USER U
     WHERE 1 = 1
       AND U.PROGRAM_ID                    = v_p_program_id
       AND U.SHEET_NAME                    = v_p_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND U.USER_ID                       = p_created_by;

    IF v_user_mea_cnt = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
            ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
            , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
            , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE   -- DATE 컬럼: 원본 CONVERT(varchar(19),GETDATE(),121) → SYSDATE 직접 입력(ORA-01861 회피)
             , p_created_by
             , SYSDATE   -- DATE 컬럼: 원본 CONVERT(varchar(19),GETDATE(),121) → SYSDATE 직접 입력(ORA-01861 회피)
          FROM SCM_MST_SHEET_MEASURE C
         WHERE 1 = 1
           AND C.PROGRAM_ID   = v_p_program_id
           AND C.SHEET_NAME   = v_p_sheet_name
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN     = 'Y';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A005--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정
    -- RTF_PR은 40 사업부만 사용하나, 생성은 모든 사업부에서 진행하게 되면서, 모든 사업부에 메져가 노출됨.
    -- USER TITLE 정보와 MEASURE MASTER 정보를 JOIN하여 사업부별 정보를 보관한다.
    -- 원본 CROSS APPLY STRING_SPLIT(A.DIVISION_ID, ',') → Oracle 상관 TABLE() 함수
    -----------------------------------------------------------------------------------------------------------------------------------
    -- 원본 CROSS APPLY STRING_SPLIT(B.DIVISION_ID,',') 후 token=p_division_id 필터
    -- → 콤마목록 포함여부 LIKE 로 동등 변환 (분해 불필요, 저장 DIVISION_ID 는 p_division_id)
    INSERT INTO GT_DMF0021_SCM_MST_SHEET_MEASURE ( USER_ID, MEASURE, SORT_ORDER_NO, SYSTEM_ADD, DIVISION_ID )
    SELECT U.USER_ID, U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, 'N' AS SYSTEM_ADD, p_division_id AS DIVISION_ID
      FROM SCM_MST_TITLESET_USER U
      INNER JOIN SCM_MST_SHEET_MEASURE B
              ON U.PROGRAM_ID  = B.PROGRAM_ID
             AND U.SHEET_NAME  = B.SHEET_NAME
             AND U.COLUMN_NAME = B.COLUMN_NAME
     WHERE 1 = 1
       AND U.PROGRAM_ID                    = v_p_program_id
       AND U.SHEET_NAME                    = v_p_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND U.USER_ID                       = p_created_by
       AND B.VALID_YN                      = 'Y'
       AND ',' || B.DIVISION_ID || ',' LIKE '%,' || p_division_id || ',%';

    INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SORT_ORDER_NO, SYSTEM_ADD )
    SELECT DISTINCT U.MEASURE, U.SORT_ORDER_NO, U.SYSTEM_ADD
      FROM GT_DMF0021_SCM_MST_SHEET_MEASURE U
      LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
             ON U.USER_ID      = T.SEGMENT4   -- 20200309 KHSONG TMM MEASURE 권한추가
            AND p_created_by   = T.SEGMENT4   -- USER_ID
            AND T.LOOKUP_TYPE  = 'TMM_MEASURE_ADMIN'
            AND T.VALID_YN     = 'Y'          -- VALID_YN 여부
     WHERE 1 = 1
       AND U.USER_ID = CASE WHEN U.MEASURE = 'TMM_FCST' THEN T.SEGMENT4 ELSE p_created_by END;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A006--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'LOC', 'KRW' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP'   AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'SALESAMT_KRW' AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'SALESAMT_LOC' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'MKT_FCST'   AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'RTF_PR' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50017] RTF_BALANCE 추가 요청
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'RTF_BALANCE' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'RTF_PR'     AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A007--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO GT_DMF0021_RAW_DATA
        ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
        , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
        , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
        , QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
         -- , A.PLANT_SITE_ID, A.ITEM_ID, NVL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP   --*[2026-09-16] POJ 원본
         -- [2026-09-16 / POJ] Text 원천 정정. 오라클은 ''=NULL 이라 NVL(x,'') 은 무효과다(MSSQL ISNULL 이식 함정). 기타매출 원장 REMARK_TEXT 는 NOT NULL 이라 '-' 로 내려가는데 여기만 NULL 이 되어 같은 키가 두 행으로 갈렸다. ATTRIBUTE9 는 NULL 1,375,473 · 공백 120 건이라 TRIM 까지 씌운다
         , A.PLANT_SITE_ID, A.ITEM_ID, NVL(TRIM(A.ATTRIBUTE9),'-') AS TEXT, A.INCOTERMS, A.DOM_EXP
         , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD
         , A.QTY, 'P' AS PLAN_RESULT
         --[E20260331-000648]_원소스 주석처리 후 CELL_PROD_SITE_ID NULL인 경우 '-' 나오도록 수정
         , NVL(A.CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
      FROM DM_PLN_SALES_PLAN A
      JOIN GT_DMF0021_SELECT_MEASURE B
        ON A.MEASURE = B.MEASURE
      JOIN SCM_MST_SITE C
        ON A.DIVISION_ID = C.DIVISION_ID
       AND A.SCM_SITE_ID = C.SCM_SITE_ID
       AND C.VALID_YN    = 'Y'
     WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
       AND A.DIVISION_ID = p_division_id
       AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' )) --[PJ2025-50017]
       --마이그레이션 된 데이터 지우면 조건삭제
       AND A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                   AND VALID_YN    = 'Y'
                                   AND SEGMENT1    = A.DIVISION_ID )
       AND A.ITEM_ID   NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                   AND VALID_YN    = 'Y'
                                   AND SEGMENT1    = A.DIVISION_ID )
       AND A.MEASURE   NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
                                   AND VALID_YN    = 'Y' );

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO GT_DMF0021_RAW_DATA
        ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
        , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
        , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
        , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
    SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
         , A.PLANT_SITE_ID, A.ITEM_ID, A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP
         , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD
         , A.QTY, 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID
      FROM DM_PLN_SALES_ETC_PLAN A
      JOIN GT_DMF0021_SELECT_MEASURE B
        ON A.MEASURE = B.MEASURE
      JOIN SCM_MST_SITE C
        ON A.DIVISION_ID = C.DIVISION_ID
       AND A.SCM_SITE_ID = C.SCM_SITE_ID
       AND C.VALID_YN    = 'Y'
     WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
       AND A.DIVISION_ID = p_division_id
       AND A.QTY <> 0;

    INSERT INTO GT_DMF0021_RAW_DATA
        ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
        , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
        , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
        , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
    SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
         -- , A.PLANT_SITE_ID, A.ITEM_ID, NVL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP   --*[2026-09-16] POJ 원본
         -- [2026-09-16 / POJ] Text 원천 정정. 오라클은 ''=NULL 이라 NVL(x,'') 은 무효과다(MSSQL ISNULL 이식 함정). 기타매출 원장 REMARK_TEXT 는 NOT NULL 이라 '-' 로 내려가는데 여기만 NULL 이 되어 같은 키가 두 행으로 갈렸다. ATTRIBUTE9 는 NULL 1,375,473 · 공백 120 건이라 TRIM 까지 씌운다
         , A.PLANT_SITE_ID, A.ITEM_ID, NVL(TRIM(A.ATTRIBUTE9),'-') AS TEXT, A.INCOTERMS, A.DOM_EXP
         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, A.YYYYMMDD
         , A.QTY + CASE WHEN p_internal_yn = 'Y' AND p_division_id = '82'
                             AND ( CASE WHEN REGEXP_LIKE(A.ATTRIBUTE2, '^[0-9]+(\.[0-9]+)?$') THEN 1 ELSE 0 END ) > 0
                        THEN CAST(A.ATTRIBUTE2 AS NUMBER) ELSE 0 END AS QTY
         , 'R' AS PLAN_RESULT
         , A.CELL_PROD_SITE_ID --[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
      FROM DM_PLN_SALES_PLAN_RESULT A
      JOIN GT_DMF0021_SELECT_MEASURE B
        ON A.MEASURE = B.MEASURE
     WHERE A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < p_now_yyyymmdd
       AND A.DIVISION_ID = p_division_id
       AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' )) --[PJ2025-50017]
       AND A.MEASURE NOT IN ('RTF_PR'); --[PJ2025-50017] 실적구간은 RTF_SYS_RP 가져오도록
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --[PLANTNORM 2026-08-04] PLANT_SITE_ID 센티널 정규화 1지점 (''/공백/CHR(0)/'-'/'--' → '-', 사용자 확정. ETC '#' 보존)
    UPDATE GT_DMF0021_RAW_DATA
       SET PLANT_SITE_ID = '-'
     WHERE PLANT_SITE_ID IS NULL
        OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), ' ')) IS NULL
        OR TRIM(PLANT_SITE_ID) IN ('-','--');


    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE
             , SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
             , QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE A.MEASURE = 'MKT_FCST'
           AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                  ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END -- [C20200521-000202] Version cutoff 기준으로 MKT_FCST 조회
           AND A.YYYYMMDD <= p_to_yyyymmdd;

        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
             , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
             , QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE MEASURE = 'RTF_SYS_RP'
           AND A.YYYYMMDD >= p_from_yyyymmdd
           AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                 ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                            END; -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'RTF_PR' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
             , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'RTF_PR' AS MEASURE, YYYYMMDD
             , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE MEASURE = 'RTF_SYS_RP'
           AND A.YYYYMMDD >= p_from_yyyymmdd
           AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                 ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                            END;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A010--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50017] RTF_BALANCE 추가 요청
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'RTF_BALANCE' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        -- P : PLAN(계획) 구간
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'RTF_BALANCE' AS MEASURE, A.YYYYMMDD
             , ( SUM(CASE WHEN MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
               - SUM(CASE WHEN MEASURE = 'RTF_PR'     THEN A.QTY ELSE 0 END) ) AS QTY
             , 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE A.MEASURE IN ('RTF_SYS_RP','RTF_PR')
           AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                  ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END
           AND A.YYYYMMDD <= p_to_yyyymmdd
           AND A.QTY > 0
         GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'SCM_FCST' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
             , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'SCM_FCST' AS MEASURE, YYYYMMDD
             , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE MEASURE = 'RTF_SYS_RP'
           AND A.YYYYMMDD >= p_from_yyyymmdd
           AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                 ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                            END;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A011--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    --=================================================================================================================================
    -- 메져정보 셋팅 (END)
    --=================================================================================================================================

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 아래서부터는 CURRENCY를 사용해야 하므로 여기서 UPDATE 한다.
    -- 원본 UPDATE A SET CURRENCY = B.CURRENCY FROM #RAW_DATA A JOIN SCM_MST_SITE_ITEM B → MERGE (ORA-01779 방지)
    -----------------------------------------------------------------------------------------------------------------------------------
    MERGE INTO GT_DMF0021_RAW_DATA A
    USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY
              FROM SCM_MST_SITE_ITEM ) B
       ON ( A.DIVISION_ID = B.DIVISION_ID
        AND A.PROJECT_CODE = B.PROJECT_CODE
        AND A.SCM_SITE_ID = B.SCM_SITE_ID
        AND A.ITEM_ID = B.ITEM_ID )
     WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
        -- 원본 WHERE ISNULL(A.CURRENCY,'')='' (Oracle ''=NULL). ON 절에 갱신컬럼 참조 불가(ORA-38104)이므로 WHEN MATCHED WHERE 로 이동
        WHERE NVL(A.CURRENCY,'CHR#') = 'CHR#';

    IF ( p_internal_yn <> 'Y' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA
         WHERE SCM_SITE_ID IN ( SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN );
    END IF;

    --=================================================================================================================================
    -- MDM -> FP테이블 SCM_MST_ITEM_SN 셋팅 (START) [E20240920-000300]_SCM.DM 화면 조회 속도 개선
    --=================================================================================================================================
    --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_ORI
        ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
        , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG
        , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
        , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    -- 원본 #temp 는 문자형 그대로 보관했으나 GTT 는 NUMBER(표준)이므로, 비숫자값 적재 시 ORA-01722 방지 위해 REGEXP 가드 변환
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
         , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME
         , CASE WHEN REGEXP_LIKE(MIN_CAPACITY, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(MIN_CAPACITY) ELSE NULL END AS MIN_CAPACITY
         , ACTIVE_FLAG
         , ENERGE
         , CASE WHEN REGEXP_LIKE(CELL_QUANTITY, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(CELL_QUANTITY) ELSE NULL END AS CELL_QUANTITY
         , SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , CASE WHEN REGEXP_LIKE(FORECAST_INFO_CELL_PACK_COUNT, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(FORECAST_INFO_CELL_PACK_COUNT) ELSE NULL END AS FORECAST_INFO_CELL_PACK_COUNT
         , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
      FROM SCM_MST_ITEM_SN
     WHERE DIVISION_ID = p_division_id;

    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_A
        ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
        , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)              AS ITEM_NAME
         , MAX(T1.ITEM_CLASS)             AS ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME)        AS ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME)              AS NICK_NAME
         , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                          WHEN T1.ITEM_TYPE = 'H' THEN 2
                          WHEN T1.ITEM_TYPE = 'Q' THEN 3
                     ELSE 4 END )
                            WHEN 1 THEN 'P'
                            WHEN 2 THEN 'H'
                            WHEN 3 THEN 'Q'
                            ELSE 'R' END  AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME)    AS MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM)               AS ITEM_UOM
         , MAX(T1.SPEC)                   AS SPEC
         , MAX(T1.MDM_PROJECT_NAME)       AS MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY)           AS MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG)            AS ACTIVE_FLAG
         , MAX(T1.ENERGE)                 AS ENERGE
         , MAX(T1.CELL_QUANTITY)          AS CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC)         AS SCP_EXTRA_SPEC
      FROM GT_DMF0021_DM_MST_ITEM_SINGLE_ORI T1
     WHERE 1=1
     GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_B
        ( DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE)                     AS CELL_TYPE
      FROM GT_DMF0021_DM_MST_ITEM_SINGLE_ORI T2
     GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

    --TEMP 테이블에 넣은 데이터를 JOIN 한다.
    -- [E20240731-000852]_82은 KWH, 40은 WH를 사용하므로 ENERGE_WH(원본) / ENERGE(KWH) 두 종류 모두 추가
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_V
        ( DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_QUANTITY, MDM_PROJECT_NAME, CELL_TYPE
        , ENERGE_WH, ENERGE )
    --[PERFHINT 2026-08-12] LOOKA(RANK 뷰) VIEW PUSHED PREDICATE 행별 재실행 → 1회 HASH JOIN 강제
    --  (ASH 실측: 본 INSERT 가 SEARCH 지연의 지배 지분 — 30분 창 639샘플. EXPLAIN 원형태 비교 채택)
    SELECT /*+ NO_PUSH_PRED(LOOKA) NO_MERGE(LOOKA) */ DISTINCT A.DIVISION_ID, A.ITEM_ID, A.ITEM_CLASS, A.ITEM_NAME, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MIN_CAPACITY
         , CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE        ELSE A.FORECAST_INFO_BIZ_TYPE        END AS FORECAST_INFO_BIZ_TYPE
         , CASE WHEN A.ITEM_ID = LOOKA.MODEL
                THEN CASE WHEN REGEXP_LIKE(LOOKA.CELL_PACK_COUNT, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT) ELSE NULL END
                ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT  -- SEGMENT4(VARCHAR2)→NUMBER, 비숫자 가드

         , A.FORECAST_INFO_PRODUCT_GROUP, A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
         , A.CELL_QUANTITY, A.MDM_PROJECT_NAME, A.CELL_TYPE
         , A.ENERGE AS ENERGE_WH
         , CASE WHEN ( CASE WHEN REGEXP_LIKE(A.ENERGE, '^[0-9]+(\.[0-9]+)?$') THEN 1 ELSE 0 END ) > 0
                THEN ROUND( TO_NUMBER(A.ENERGE) / 1000, 7) ELSE NULL END AS ENERGE
      FROM (
            SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME
                 , T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
                 , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG
                 , T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
              FROM GT_DMF0021_DM_MST_ITEM_SINGLE_A T1
              INNER JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_B T2
                      ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
             WHERE 1=1
           ) A
      LEFT JOIN ( SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
                    FROM ( SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT
                                , RANK () OVER ( PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC ) AS MODEL_RANK
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40' ) A
                   WHERE MODEL_RANK = '1' ) LOOKA ON LOOKA.MODEL = A.ITEM_ID
      JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM GT_DMF0021_RAW_DATA ) B
        ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
     WHERE A.DIVISION_ID = p_division_id;

    /* CREATE CLUSTERED INDEX 원본 — Oracle GTT 에서는 인덱스 별도 DDL 로 생성 (이슈 기록) */
    -- CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V] ( DIVISION_ID ASC, ITEM_ID ASC )
    --=================================================================================================================================
    -- MDM -> FP테이블 SCM_MST_ITEM_SN 셋팅 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A013--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
    --=================================================================================================================================
    INSERT INTO GT_DMF0021_SCM_MST_SITE_ITEM
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL
        , CELL_PER_CAR, CELL_PER_MODULE, CURRENCY
        , SALES_COMPANY, SALES_PLANT, SALES_PLAN_ADJUST_YN
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
        , OWNER, OWNER_NAME, OWNER_NAME_KO, DEPT_ID, VALID_YN )   -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP6 미존재 (Oracle 마이그레이션) → GTT REPORT_GROUP6 는 NULL 유지
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL, CELL_PER_CAR, CELL_PER_MODULE
         , CURRENCY, SALES_COMPANY, SALES_PLANT, SALES_PLAN_ADJUST_YN
         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
         , A.OWNER  -- [컬럼삭제] REPORT_GROUP6 제거
         , FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'EN' ) AS OWNER_NAME
         , FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
--       , ( SELECT SU.DEPT_ID
--             FROM SCM_MST_SSO_USER_INFO SU
--            WHERE SU.USER_ID = REGEXP_SUBSTR(A.OWNER, '[^,]+', 1, 1)  -- 원본 (SELECT TOP 1 token FROM String_Split(owner,',')) = 첫 토큰
--         ) AS DEPT_ID
         , A.DEPT_ID   /* 부서코드 : 아이템 원장 */                                    -- 2026.09.06 AJS
         , VALID_YN
      FROM SCM_MST_SITE_ITEM A
      JOIN ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM GT_DMF0021_RAW_DATA ) B
        ON A.DIVISION_ID = B.DIVISION_ID
       AND A.SCM_SITE_ID = B.SCM_SITE_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
       AND A.ITEM_ID = B.ITEM_ID
     WHERE A.DIVISION_ID = p_division_id;

    -- [2026-09-21 / POJ] 팀명 채우기 — 집합 단위 1회. 적재 SELECT 는 건드리지 않는다
    MERGE INTO GT_DMF0021_SCM_MST_SITE_ITEM T
    USING SCM_MGR.SCM_MST_SSO_DEPT_INFO SD
       ON ( SD.DEPT_ID = T.DEPT_ID )
     WHEN MATCHED THEN UPDATE SET T.TEAM_NAME = CASE v_lang_cd WHEN 'EN' THEN SD.DEPT_NAME_EN WHEN 'CN' THEN SD.DEPT_NAME_CN ELSE SD.DEPT_NAME_KO END;
    --=================================================================================================================================
    -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A014--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- [PJ2024-50611] 화면에서 저장한 dept_id 업데이트 (화면 병합 위해 RESULT에도 동일값 필요)
    -- 원본 UPDATE A SET ATTRIBUTE1 = B.ATTRIBUTE1 FROM #RAW_DATA A JOIN (...) B → MERGE
    --=================================================================================================================================
    MERGE INTO GT_DMF0021_RAW_DATA A
    USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
                 , ATTRIBUTE1, REMARK_TEXT --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 필드추가
                 -- [2026-09-21 / POJ] 40 기타매출은 부서코드가 행에 있다. 팀명도 같이 싣는다
                 , TEAM_NAME
                 , '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
              --[E20260819-ETCMERGE] 원천은 MEASURE(SalesAmt_KRW/LOC/USD) 행별 적재가 정상인데
              --  본 MERGE 키에 MEASURE 가 없어 동일 타깃 3회 갱신 → ORA-30926.
              --  소비 컴럼은 ATTRIBUTE1/REMARK_TEXT 뿐이므로 RN=1 dedup (의미 불변).
              FROM ( SELECT E.DIVISION_ID, E.PROJECT_CODE, E.SCM_SITE_ID, E.ITEM_ID, E.DOM_EXP, E.FCST_TYPE
                          , E.INCOTERMS, E.PLANT_SITE_ID, E.YYYYMMDD, E.ATTRIBUTE1, E.REMARK_TEXT
                          -- [2026-09-21 / POJ] 팀명 (사용자 언어)
                          , CASE v_lang_cd WHEN 'EN' THEN SD.DEPT_NAME_EN WHEN 'CN' THEN SD.DEPT_NAME_CN ELSE SD.DEPT_NAME_KO END AS TEAM_NAME
                          , ROW_NUMBER() OVER ( PARTITION BY E.DIVISION_ID, E.PROJECT_CODE, E.SCM_SITE_ID, E.ITEM_ID
                                                    , E.DOM_EXP, E.FCST_TYPE, E.INCOTERMS, E.PLANT_SITE_ID, E.YYYYMMDD
                                                ORDER BY E.LAST_UPDATE_DATE DESC, E.MEASURE ) AS RN
                       FROM DM_PLN_SALES_ETC_PLAN E --[PJ2024-50611]
                       -- [2026-09-21 / POJ] 팀명 조인. DEPT_ID 는 유일해 행이 늘지 않는다
                       LEFT OUTER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO SD ON SD.DEPT_ID = E.ATTRIBUTE1
                      WHERE E.DIVISION_ID = '40'
                        AND E.FCST_TYPE   = 'ETC'
                        AND E.YYYYMMDD >= p_now_yyyymmdd AND E.YYYYMMDD <= p_to_yyyymmdd
                        AND E.QTY <> 0 )
             WHERE RN = 1 ) B
       ON ( A.DIVISION_ID      = B.DIVISION_ID
        AND A.PROJECT_CODE     = B.PROJECT_CODE
        AND A.SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.ITEM_ID          = B.ITEM_ID
        AND A.DOM_EXP          = B.DOM_EXP
        AND A.FCST_TYPE        = B.FCST_TYPE
        AND A.INCOTERMS        = B.INCOTERMS
        AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.YYYYMMDD         = B.YYYYMMDD
        -- AND NVL(A.TEXT,'#') = NVL(B.REMARK_TEXT,'#') --[PJ2024-50611] 조인추가 (TEXT=VARCHAR2, ''/NULL 매칭 보존)   --*[2026-09-16] POJ 원본
        -- [2026-09-16 / POJ] TEXT 조인 센티널을 '#' 에서 '-' 기준으로 통일. B 쪽 REMARK_TEXT 는 NOT NULL 로 '-' 규약을 지킨다
        AND NVL(A.TEXT,'-') = NVL(B.REMARK_TEXT,'-') --[PJ2024-50611] 조인추가
        AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID ) --[PJ2025-50017]
     -- WHEN MATCHED THEN UPDATE SET A.ATTRIBUTE1 = B.ATTRIBUTE1;   --*[2026-09-21] POJ 원본
     -- [2026-09-21 / POJ] 40 기타매출 팀명도 함께 채운다
     WHEN MATCHED THEN UPDATE SET A.ATTRIBUTE1 = B.ATTRIBUTE1, A.TEAM_NAME = B.TEAM_NAME;
    --=================================================================================================================================
    -- [PJ2024-50611] 화면에서 저장한 dept_id 처리 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A015--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 조회조건에 따른 필터링 처리 (START)
    -- 원본 DELETE A FROM #RAW_DATA A LEFT JOIN (split) C WHERE C.TOKEN IS NULL → DELETE ... WHERE NOT EXISTS
    --=================================================================================================================================
    IF ( p_project_code IS NOT NULL ) THEN -- 소형은 UI 에서 PROJECT DISABLE 됨 (원본 <>'' → Oracle ''=NULL 이므로 IS NOT NULL)
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_PROJECT B
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_project_code,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_project_code,',')+1) ) C
                    ON ( UPPER(B.PROJECT_CODE) LIKE '%' || UPPER(C.TOKEN) || '%' OR UPPER(B.PROJECT_NAME) LIKE '%' || UPPER(C.TOKEN) || '%' )
                 WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE );  --260820 조회조건 Upper 처리
    END IF;

    IF ( p_item_id IS NOT NULL ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V B
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_item_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id,',')+1) ) C
                    ON UPPER(A.ITEM_ID) LIKE '%' || UPPER(C.TOKEN) || '%'
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_item_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id,',')+1) ) D
                    ON UPPER(B.NICK_NAME) LIKE '%' || UPPER(D.TOKEN) || '%'
                 WHERE A.ITEM_ID = B.ITEM_ID
                   AND ( C.TOKEN IS NOT NULL OR D.TOKEN IS NOT NULL ) ); --260820 조회조건 Upper 처리
    END IF;

    IF ( p_owner IS NOT NULL ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_SCM_MST_SITE_ITEM B
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_owner,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_owner,',')+1) ) C
                    ON UPPER(B.OWNER) LIKE '%' || UPPER(C.TOKEN) || '%'
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_owner,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_owner,',')+1) ) D
                    ON UPPER(B.OWNER_NAME) LIKE '%' || UPPER(D.TOKEN) || '%'
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_owner,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_owner,',')+1) ) E
                    ON UPPER(B.OWNER_NAME_KO) LIKE '%' || UPPER(E.TOKEN) || '%'
                 WHERE A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND ( C.TOKEN IS NOT NULL OR D.TOKEN IS NOT NULL OR E.TOKEN IS NOT NULL ) ); --260820 조회조건 Upper 처리
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A016--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_dept_id <> 'ALL' ) THEN
        -- [PJ2024-50461] Team Mapping / 기타매출 이외
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE A.FCST_TYPE <> 'ETC'
           AND NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_SCM_MST_SITE_ITEM B
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_dept_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_dept_id,',')+1) ) C
                    ON B.DEPT_ID = C.TOKEN
                 WHERE A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE );

        -- 기타매출(40 이외 사업부)
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE A.FCST_TYPE = 'ETC' AND A.DIVISION_ID <> '40' --[PJ2024-50611] 40 이외 사업부는 기타일 경우 SCM_MST_SITE 에서 가져옴
           AND NOT EXISTS (
                SELECT 1
--                FROM SCM_MST_SITE B
                  FROM SCM_MST_SITE_ITEM B   /* 부서 원천 : 아이템 원장 */             -- 2026.09.06 AJS
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_dept_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_dept_id,',')+1) ) C
                    ON B.DEPT_ID = C.TOKEN
                 WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = p_division_id );

        -- [PJ2024-50611]_기타매출(40사업부)
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE A.FCST_TYPE = 'ETC' AND A.DIVISION_ID = '40'
           AND NOT EXISTS (
                SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_dept_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_dept_id,',')+1) ) C
                 WHERE A.ATTRIBUTE1 = C.TOKEN ); --[PJ2024-50611] 40사업부 기타매출은 ATTRIBUTE1 에 부서코드 있음
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A017--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_end_customer <> 'ALL' ) THEN
        IF ( p_division_id = '40' ) THEN
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_end_customer,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_end_customer,',')+1) ) C
                     WHERE A.PROJECT_CODE = C.TOKEN );
        ELSE
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1
                      FROM SCM_MST_SITE B
                      JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_end_customer,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_end_customer,',')+1) ) C
                        ON B.END_CUSTOMER = C.TOKEN
                     WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = p_division_id );
        END IF;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A018--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_scm_site_id <> 'ALL' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id,',')+1) ) C
                 WHERE A.SCM_SITE_ID = C.TOKEN );
    END IF;

    IF ( p_plant_site_id <> 'ALL' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_plant_site_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_plant_site_id,',')+1) ) C
                 WHERE A.PLANT_SITE_ID = C.TOKEN );
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A019--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_item_type <> 'ALL' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V B
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_item_type,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_item_type,',')+1) ) C
                    ON B.ITEM_TYPE = C.TOKEN
                 WHERE A.ITEM_ID = B.ITEM_ID );
    END IF;

    IF ( p_biztype <> 'ALL' ) THEN
        IF ( p_division_id = '40' ) THEN
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1
                      FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V B
                      JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_biztype,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_biztype,',')+1) ) C
                        ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
                     WHERE A.ITEM_ID = B.ITEM_ID );
        ELSE
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1
                      FROM SCM_MST_PROJECT B
                      JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_biztype,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_biztype,',')+1) ) C
                        ON B.BIZ_TYPE LIKE '%' || C.TOKEN || '%'
                     WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE );
        END IF;
    END IF;
    --=================================================================================================================================
    -- 조회조건에 따른 필터링 처리 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A020--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 실적구간 PRICE 처리 (START)
    --=================================================================================================================================
    -- LOC 메져 생성
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'LOC' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC' AS MEASURE, A.YYYYMMDD
             , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'RTF_SYS_RP'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) A
          JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'SalesAmt_LOC'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) B
            ON A.VERSION_NO    = B.VERSION_NO
           AND A.DIVISION_ID   = B.DIVISION_ID
           AND A.PROJECT_CODE  = B.PROJECT_CODE
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
           AND A.ITEM_ID       = B.ITEM_ID
           AND A.INCOTERMS     = B.INCOTERMS
           AND A.DOM_EXP       = B.DOM_EXP
           AND A.FCST_TYPE     = B.FCST_TYPE
           -- AND A.CURRENCY      = B.CURRENCY   --*[2026-09-16] POJ 원본
           -- [2026-09-16 / POJ] CURRENCY 조인에 빈값 '-' 기준 적용. 계획 원장 CURRENCY 는 nullable 이고 NULL 29,420건, 실적 원장은 NOT NULL 로 '-' 366,325건이라 NULL = '-' 가 UNKNOWN 이 되어 단가가 산출되지 않는다
           AND NVL(A.CURRENCY,'-')      = NVL(B.CURRENCY,'-')
           AND A.YYYYMMDD      = B.YYYYMMDD
           -- AND NVL(A.COMPANY_ID,'#') = NVL(B.COMPANY_ID,'#')   --*[2026-09-16] POJ 원본
           -- [2026-09-16 / POJ] COMPANY_ID 조인 센티널을 '#' 에서 '-' 기준으로. 실적 원장 COMPANY_ID 는 NOT NULL 이고 컬럼 기본값이 '-' 라 값이 없으면 '-' 가 들어간다(실측 '-' 999,554건 · 공백 511건). 계획 원장에는 이 컬럼이 없어 조회가 NULL 을 넣으므로, '#' 로 접으면 NULL 과 '-' 가 서로 다른 키가 된다
           AND NVL(TRIM(A.COMPANY_ID),'-') = NVL(TRIM(B.COMPANY_ID),'-')
           AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A021--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -- KRW 메져 생성
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'KRW' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW' AS MEASURE, A.YYYYMMDD
             , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'RTF_SYS_RP'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) A
          JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'SalesAmt_KRW'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) B
            ON A.VERSION_NO    = B.VERSION_NO
           AND A.DIVISION_ID   = B.DIVISION_ID
           AND A.PROJECT_CODE  = B.PROJECT_CODE
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
           AND A.ITEM_ID       = B.ITEM_ID
           AND A.INCOTERMS     = B.INCOTERMS
           AND A.DOM_EXP       = B.DOM_EXP
           AND A.FCST_TYPE     = B.FCST_TYPE
           -- AND A.CURRENCY      = B.CURRENCY   --*[2026-09-16] POJ 원본
           -- [2026-09-16 / POJ] CURRENCY 조인에 빈값 '-' 기준 적용. 계획 원장 CURRENCY 는 nullable 이고 NULL 29,420건, 실적 원장은 NOT NULL 로 '-' 366,325건이라 NULL = '-' 가 UNKNOWN 이 되어 단가가 산출되지 않는다
           AND NVL(A.CURRENCY,'-')      = NVL(B.CURRENCY,'-')
           AND A.YYYYMMDD      = B.YYYYMMDD
           -- AND NVL(A.COMPANY_ID,'#') = NVL(B.COMPANY_ID,'#')   --*[2026-09-16] POJ 원본
           -- [2026-09-16 / POJ] COMPANY_ID 조인 센티널을 '#' 에서 '-' 기준으로. 실적 원장 COMPANY_ID 는 NOT NULL 이고 컬럼 기본값이 '-' 라 값이 없으면 '-' 가 들어간다(실측 '-' 999,554건 · 공백 511건). 계획 원장에는 이 컬럼이 없어 조회가 NULL 을 넣으므로, '#' 로 접으면 NULL 과 '-' 가 서로 다른 키가 된다
           AND NVL(TRIM(A.COMPANY_ID),'-') = NVL(TRIM(B.COMPANY_ID),'-')
           AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;
    END IF;
    --=================================================================================================================================
    -- 실적구간 PRICE 처리 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A022--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 계획구간 PRICE 처리 (START)
    -- 'KRW', 'LOC', 'USD' 메져 생성. 40사업부 PRICE: DM_PLN_CFM_SELLING_PRICE, 타 사업부: SCM_MST_FUTURE_PRICE
    --=================================================================================================================================
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        IF ( p_division_id = '40' ) THEN
            INSERT INTO GT_DMF0021_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
                , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
                , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
                , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
            --[PRICEJOIN 2026-08-15] 조인 순서 고정 — 판가(C)를 빌드입력으로 만들지 않는다.
            --  CALENDAR x 판가 선조인 결과(40 기준 2,149K행)가 해시 빌드가 되어 Used-Tmp 313M 스필 발생 → RAW_DATA(7,286행) 선행으로 고정. 실측 2.38초 → 0.61초, 결과 10,119행 동일.
            SELECT /*+ LEADING(A B C D) USE_HASH(B) USE_HASH(C) USE_HASH(D) NO_SWAP_JOIN_INPUTS(C) */
                   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
                 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
              FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                          , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                          , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                       FROM GT_DMF0021_RAW_DATA A
                      WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
                        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'Catch_Up' )
                   ) A
              JOIN SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
              JOIN DM_PLN_CFM_SELLING_PRICE C
                ON A.DIVISION_ID      = C.DIVISION_ID
               --[PRICEPRUNE 2026-08-15] 판가 원장 사업부 선필터 (결과 항등 · 해시조인 빌드입력 축소)
               --  RAW_DATA 는 p_division_id 단일 적재(L508·L543·L563 원장 INSERT 필터, 이후는 자기파생)이므로
               --  A.DIVISION_ID = C.DIVISION_ID 와 등가. 실측 40 기준 4.24초 → 1.82초, 결과 10,119행 동일.
               AND C.DIVISION_ID      = p_division_id
               AND A.PROJECT_CODE     = C.PROJECT_CODE
               AND A.SCM_SITE_ID      = C.SCM_SITE_ID
               AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID --[PJ2025-50017]
               AND A.PLANT_SITE_ID    = CASE WHEN C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(C.PLANT_SITE_ID, CHR(0), ' ')) IS NULL OR TRIM(C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE C.PLANT_SITE_ID END  --[PLANTNORM-PRICE 2026-08-06] 판가 원장 다중 센티널('--' 등) 흡수 — GT측은 적재 정규화('-') 완료
               AND A.ITEM_ID          = C.ITEM_ID
               AND A.INCOTERMS        = C.INCOTERMS
               AND A.DOM_EXP          = C.DOM_EXP
               AND A.FCST_TYPE        = C.FCST_TYPE
               AND B.BASIS_START_DATE = C.YYYYMMDD
               AND C.YYYYMMDD         <= p_to_yyyymmdd
              JOIN GT_DMF0021_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        ELSE -- ( p_division_id <> '40' )
            INSERT INTO GT_DMF0021_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
                , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
                , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
                , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
            --[PRICEJOIN 2026-08-15] 조인 순서 고정 — 판가(C)를 빌드입력으로 만들지 않는다.
            --  40 분기와 대칭 적용(판가 원장 SCM_MST_FUTURE_PRICE). 실측 81 기준 1.34초 → 0.32초, 결과 6,065행 동일.
            SELECT /*+ LEADING(A B C D) USE_HASH(B) USE_HASH(C) USE_HASH(D) NO_SWAP_JOIN_INPUTS(C) */
                   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
                 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
              FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                          , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                          , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                       FROM GT_DMF0021_RAW_DATA A
                      WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
                        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'Catch_Up' )
                   ) A
              JOIN SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
              JOIN SCM_MST_FUTURE_PRICE C
                ON A.DIVISION_ID      = C.DIVISION_ID
               --[PRICEPRUNE 2026-08-15] 판가 원장 사업부 선필터 (결과 항등 · 해시조인 빌드입력 축소)
               --  40 분기와 대칭 적용. SCM_MST_FUTURE_PRICE 1,732,210행 중 사업부분만 스캔.
               AND C.DIVISION_ID      = p_division_id
               AND A.PROJECT_CODE     = C.PROJECT_CODE
               AND A.SCM_SITE_ID      = C.SCM_SITE_ID
               AND A.PLANT_SITE_ID    = CASE WHEN C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(C.PLANT_SITE_ID, CHR(0), ' ')) IS NULL OR TRIM(C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE C.PLANT_SITE_ID END  --[PLANTNORM-PRICE 2026-08-06] 대칭 적용(실값=항등, 멱등)
               AND A.ITEM_ID          = C.ITEM_ID
               AND A.INCOTERMS        = C.INCOTERMS
               AND A.DOM_EXP          = C.DOM_EXP
               AND A.FCST_TYPE        = C.FCST_TYPE
               AND B.BASIS_START_DATE = C.YYYYMMDD
               AND C.YYYYMMDD         <= p_to_yyyymmdd
              JOIN GT_DMF0021_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        END IF;
    END IF;
    --=================================================================================================================================
    -- 계획구간 PRICE 처리 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A023--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 필요없는 메저 삭제 (메져를 만들기 위해 임의로 추가한 메져를 삭제)
    --=================================================================================================================================
    DELETE FROM GT_DMF0021_RAW_DATA A
     WHERE EXISTS ( SELECT 1 FROM GT_DMF0021_SELECT_MEASURE B
                     WHERE A.MEASURE = B.MEASURE AND B.SYSTEM_ADD = 'Y' );

    --=================================================================================================================================
    -- 물리적으로 생성하지 않는 메져의 경우 하단에서 생성해준다 (START)
    -- MEASURE: 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY'
    --=================================================================================================================================
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE
     WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
             , CASE WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR')
                    THEN CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0   AND D.CELL_PER_CAR > 0 THEN A.QTY / D.CELL_PER_CAR
                              WHEN INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN A.QTY / ( D.CELL_PER_CAR / D.CELL_PER_MODULE )
                              WHEN INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0   THEN A.QTY
                              ELSE 0
                         END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%'
                    THEN CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
                              WHEN ( INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
                              ELSE 0
                         END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
                    -- 20211119 ROSIA27 [C20211103-000146] GSCM 용량 Measure
                    WHEN B.MEASURE_CALC = 'RTF_ENERGY'
                    THEN CASE WHEN C.ENERGE IS NOT NULL THEN (A.QTY * C.ENERGE)/1000 END
                    -- 20221214 ROSIA27 [C20221207-000080] MKT FCST[R+P] Energy
                    WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R'
                    THEN CASE WHEN C.ENERGE IS NOT NULL THEN (A.QTY * C.ENERGE)/1000 END
                    ELSE 0
               END
             , A.PLAN_RESULT
             , A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
          JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP' ELSE 'RTF_SYS_RP' END AS MEASURE_ORI
                      , A.MEASURE AS MEASURE_CALC
                   FROM GT_DMF0021_SELECT_MEASURE A
                  WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY' )
               ) B ON A.MEASURE = B.MEASURE_ORI
          JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
          LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE_ITEM D
                       ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
         WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' );
    END IF;
    --=================================================================================================================================
    -- 물리적으로 생성하지 않는 메져의 경우 하단에서 생성해준다 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A024--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 20221214 ROSIA27 [C20221207-000080] MKT FCST[R+P] Energy (START)
    --=================================================================================================================================
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ('MKT_FCST_ENERGY') AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
             , CASE WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'MKT_FCST_RP' AND A.PLAN_RESULT = 'P'
                    THEN CASE WHEN C.ENERGE IS NOT NULL THEN (A.QTY * C.ENERGE)/1000 END
                    ELSE 0
               END
             , A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
          JOIN ( SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC
                   FROM GT_DMF0021_SELECT_MEASURE A
                  WHERE MEASURE IN ('MKT_FCST_ENERGY')
               ) B ON A.MEASURE = B.MEASURE_ORI
          JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
          LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE_ITEM D
                       ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
         WHERE A.MEASURE IN ( 'MKT_FCST_RP' );
    END IF;
    --=================================================================================================================================
    -- 20221214 ROSIA27 [C20221207-000080] MKT FCST[R+P] Energy (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A025--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- 컬럼리스트 생성 (START) — 날짜컬럼: 원본 CURSOR FAST_FORWARD → Oracle 명시적 커서 LOOP
    --=================================================================================================================================
    v_PV_LIST     := '';
    v_PV_COL_LIST := '';

    FOR rec IN (
        SELECT '[D_' || A.BASIS_YYYYMMDD || '] AS D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
             , '[D_' || A.BASIS_YYYYMMDD || ']' AS PV_NAME
             , A.BASIS_YYYYMMDD || '_' || TO_CHAR(31) AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
           AND p_bucket = 'DAILY'
        UNION ALL
        SELECT '[W_' || A.BASIS_YYYYMM || A.ISO_WEEK || '] AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
             , '[W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ']' AS PV_NAME
             , MAX(A.BASIS_START_DATE) || '_' || TO_CHAR(21) AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK
        UNION ALL
        SELECT '[M_' || A.BASIS_YYYYMM || '] AS M_' || A.BASIS_YYYYMM AS COLUMN_NAME
             , '[M_' || A.BASIS_YYYYMM || ']' AS PV_NAME
             , MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1) AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
         GROUP BY A.BASIS_YYYYMM
         ORDER BY SORT_ORDER_NO
    )
    LOOP
        -- 원본 CASE WHEN v_PV_LIST <> '' (MSSQL 빈문자) → Oracle ''=NULL 이라 항상 거짓이 되어 콤마 누락됨 → 길이로 판정
        v_PV_COL_LIST := v_PV_COL_LIST || CASE WHEN DBMS_LOB.GETLENGTH(v_PV_COL_LIST) > 0 THEN ',' ELSE '' END || rec.COLUMN_NAME;
        v_PV_LIST     := v_PV_LIST     || CASE WHEN DBMS_LOB.GETLENGTH(v_PV_LIST)     > 0 THEN ',' ELSE '' END || rec.PV_NAME;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A026--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    /* 20240518 KCW3408 속도개선_템프사용 */
    INSERT INTO GT_DMF0021_SCM_MST_SITE
        ( SCM_SITE_ID, DIVISION_ID, DEPT_ID, SOLDTO_CODE, VMI_YN, END_CUSTOMER
        , CITY_NAME, COUNTRY_NAME, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, ATTRIBUTE3 )
--  SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN
    SELECT B.SCM_SITE_ID, B.DIVISION_ID
         , NVL(( SELECT MAX(SA.DEPT_ID)
                   FROM SCM_MST_SITE_ITEM SA
                  WHERE SA.DIVISION_ID = B.DIVISION_ID
                    AND SA.SCM_SITE_ID = B.SCM_SITE_ID
                    AND SA.DEPT_ID IS NOT NULL ), '-') AS DEPT_ID   /* 부서코드 : 아이템 원장 대표 부서 */   -- 2026.09.06 AJS
         , K.SOLDTO_CODE, B.VMI_YN
         , B.END_CUSTOMER, H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION
         , B.ATTRIBUTE3  --20240913 SM 임시작업 존재하지 않는 경우 화면 오류 발생으로 임의로 지정함
      FROM SCM_MST_SITE B
      LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K
                   ON B.DIVISION_ID = K.DIVISION_ID AND B.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = 'Y'
      LEFT OUTER JOIN SCM_MST_CITY H    ON B.CITY = H.CITY
      LEFT OUTER JOIN SCM_MST_COUNTRY J ON B.COUNTRY = J.COUNTRY
      LEFT OUTER JOIN SCM_MST_CUSTOMER L
                   ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE;

    -- [2026-09-21 / POJ] 팀명 채우기 — 집합 단위 1회. 적재 SELECT 는 건드리지 않는다
    MERGE INTO GT_DMF0021_SCM_MST_SITE T
    USING SCM_MGR.SCM_MST_SSO_DEPT_INFO SD
       ON ( SD.DEPT_ID = T.DEPT_ID )
     WHEN MATCHED THEN UPDATE SET T.TEAM_NAME = CASE v_lang_cd WHEN 'EN' THEN SD.DEPT_NAME_EN WHEN 'CN' THEN SD.DEPT_NAME_CN ELSE SD.DEPT_NAME_KO END;


    --일반 컬럼
    v_column_name := '';
    v_column      := '';
    v_orderby     := '';

    SELECT COUNT(*)
      INTO v_i_count
      FROM SCM_MST_TITLESET_USER U
     WHERE 1 = 1
       AND U.PROGRAM_ID = v_p_program_id
       AND U.SHEET_NAME = v_p_sheet_name
       AND U.USER_ID    = p_created_by
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A027--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF v_i_count = 0 THEN
        FOR rec IN (
            SELECT '[' || COLUMN_NAME || '],' AS COL_PART
                 , '[' || COLUMN_NAME || '] ' || DATA_SORT_METHOD_CODE || ',' AS ORD_PART
              FROM ( --[E20260812-COLDEDUP] ColList COLUMN_NAME dedup 안전망 — 클라우드 titleset 'C' 오염·DIVISION 스코프 2행이 SELECT 목록 중복(ORA-00960)으로 번지는 것을 차단
                     SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.COLUMN_NAME ORDER BY t.SORT_ORDER_NO) AS COL_DEDUP_RN
                     FROM ( -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
                    SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                      FROM SCM_MST_SHEET_COLUMNS C
                     WHERE 1 = 1
                       AND C.PROGRAM_ID = v_p_program_id
                       AND C.SHEET_NAME = v_p_sheet_name
                       AND ( C.DEFAULT_FLAG = 'Y' OR ( C.VISIBLE_FLAG = 'N' AND NVL(C.DEFAULT_FLAG,'N') <> 'Y' AND C.VALID_YN = 'Y' ) ) --[E20260715] ''=NULL 함정 정정
                   ) t ) tbColList
             WHERE COL_DEDUP_RN = 1
             ORDER BY SORT_ORDER_NO
        )
        LOOP
            v_ColList   := v_ColList   || rec.COL_PART;
            v_OrderList := v_OrderList || rec.ORD_PART;
        END LOOP;
    ELSE
        FOR rec IN (
            SELECT '[' || COLUMN_NAME || '],' AS COL_PART
                 , '[' || COLUMN_NAME || '] ' || DATA_SORT_METHOD_CODE || ',' AS ORD_PART
              FROM ( --[E20260812-COLDEDUP] ColList COLUMN_NAME dedup 안전망 — 클라우드 titleset 'C' 오염·DIVISION 스코프 2행이 SELECT 목록 중복(ORA-00960)으로 번지는 것을 차단
                     SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.COLUMN_NAME ORDER BY t.SORT_ORDER_NO) AS COL_DEDUP_RN
                     FROM ( -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
                    SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
                      FROM SCM_MST_TITLESET_USER U
                      INNER JOIN SCM_MST_SHEET_COLUMNS C
                              ON U.PROGRAM_ID  = C.PROGRAM_ID
                             AND U.SHEET_NAME  = C.SHEET_NAME
                             AND U.COLUMN_NAME = C.COLUMN_NAME
                             AND U.PROGRAM_ID  = v_p_program_id
                             AND U.SHEET_NAME  = v_p_sheet_name
                             AND U.USER_ID     = p_created_by
                             AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                    UNION ALL
                    /* 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
                    SELECT * FROM (
                        SELECT CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO,85) - 0.5
                                    -- [PJ2024-50611] Catch Up 입력가능 : 수정여부 필드(400)를 MEASURE(500) 뒤(510)로 정렬
                                    WHEN C.COLUMN_NAME = 'SALES_PLAN_ADJUST_YN' THEN NVL(C.SORT_ORDER_NO,400) + 110
                                    ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
                             , C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                          FROM SCM_MST_SHEET_COLUMNS C
                          LEFT OUTER JOIN SCM_MST_TITLESET_USER U
                                       ON U.PROGRAM_ID = C.PROGRAM_ID
                                      AND U.SHEET_NAME = C.SHEET_NAME
                                      AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                                      AND U.COLUMN_NAME IN ('ITEM_ID')
                                      AND U.USER_ID = p_created_by
                         WHERE 1 = 1
                           AND C.PROGRAM_ID  = v_p_program_id
                           AND C.SHEET_NAME  = v_p_sheet_name
                           AND C.VISIBLE_FLAG = 'N'
                           AND NVL(C.DEFAULT_FLAG,'N') <> 'Y' --[E20260715] ''=NULL 함정 정정
                           AND C.VALID_YN     = 'Y'
                    ) WHERE ROWNUM <= 100
                   ) t ) tbColList
             WHERE COL_DEDUP_RN = 1
             ORDER BY SORT_ORDER_NO
        )
        LOOP
            v_ColList   := v_ColList   || rec.COL_PART;
            v_OrderList := v_OrderList || rec.ORD_PART;
        END LOOP;
    END IF;

    v_ColList   := SUBSTR(v_ColList,   1, LENGTH(v_ColList)   - 1);
    v_OrderList := SUBSTR(v_OrderList, 1, LENGTH(v_OrderList) - 1);

    --[E20231128-000738]숫자표기형태 구분 컬럼(NOTATION) 추가
    v_ColList   := v_ColList || ',[NOTATION]';
    -- MEASURE 는 내부 집계/필터(F.MEASURE) 및 PIVOT 행 차원으로 필수. 사용자 컬럼셋에 없으면 강제 추가
    -- (원본은 SHEET_COLUMNS/타이틀셋 구성상 항상 MEASURE 포함을 전제). [SORT_ORDER_NO],[MEASURE] 정렬도 함께 보강.
    IF INSTR(v_ColList, '[MEASURE]') = 0 THEN
        v_ColList   := v_ColList   || ',[MEASURE]';
        v_OrderList := v_OrderList || ',[MEASURE]';  -- 아래 REPLACE 가 [SORT_ORDER_NO],[MEASURE] 로 확장
    END IF;
    v_ColList   := REPLACE(v_ColList,   '[VERSION_NO]', '[VERSION_SORT],[VERSION_NO]');
    v_OrderList := REPLACE(v_OrderList, '[VERSION_NO]', '[VERSION_SORT] DESC,[VERSION_NO]');
    v_OrderList := REPLACE(v_OrderList, '[MEASURE]',    '[SORT_ORDER_NO],[MEASURE]');
    --=================================================================================================================================
    -- 컬럼리스트 생성 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A028--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- SHIPMENT 컬럼 (START) [PJ20200138]
    --=================================================================================================================================
    IF v_ColList LIKE '%SHIPMENT_SITE%' AND p_division_id = '82' THEN
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
          INTO v_SHIP_DIVISION_ID, v_SHIP_PLAN_START_YYYYMMDD, v_SHIP_PLAN_TYPE
             , v_SHIP_PPLAN_SEQ, v_SHIP_PPLAN_ID, v_SHIP_PMODELING_ID
          FROM ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
                      , ROW_NUMBER() OVER ( ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC ) ROW_NUM
                   FROM SCP_PLAN_VERSION_V
                  WHERE 1=1
                    AND DIVISION_ID = '82'
                    AND PLAN_CYCLE  = 'WEEKLY'
                    AND PLAN_TYPE   = 'FN'
                    AND PLAN_START_YYYYMMDD >= TO_CHAR( FN_NEXT_DAY(SYSDATE, 'MON') - 60, 'YYYYMMDD') ) PV
         WHERE PV.ROW_NUM = 1;

        -- 2020.11.26 hwi1993 FROM_SITE 를 MAX 값으로 변경
        INSERT INTO GT_DMF0021_SHIPMENT_SITE_ROW
            ( DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE, FROM_SITE )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE AS SCM_SITE_ID, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
          INNER JOIN SCM_SYS_CALENDAR_M O ON A.YYYYMMDD = O.BASIS_YYYYMMDD
          LEFT OUTER JOIN ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE
                                 , MAX(REPLACE(SUBSTR(ENG_DEMAND_ID, INSTR(ENG_DEMAND_ID, '::', INSTR(ENG_DEMAND_ID, '::', INSTR(ENG_DEMAND_ID, '::', INSTR(ENG_DEMAND_ID, '::') + 1) + 1) + 1) + 2, 3), ':', '')) AS FCST_TYPE
                              FROM SCP_ANL_PROBLEM_REPORT_PEGGING
                             WHERE DIVISION_ID         = v_SHIP_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = v_SHIP_PLAN_START_YYYYMMDD
                               AND PLAN_TYPE           = v_SHIP_PLAN_TYPE
                               AND SEQ                 = v_SHIP_PPLAN_SEQ
                               AND PEGGING_OPERATION_CODE IN ( 'CSHIP', 'PSHIP' )
                             GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE ) FC
                       ON A.ITEM_ID = FC.ITEM_ID AND A.FROM_SITE = FC.FROM_SITE AND A.TO_SITE = FC.TO_SITE
         WHERE A.DIVISION_ID         = v_SHIP_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = v_SHIP_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = v_SHIP_PLAN_TYPE
           AND A.SEQ                 = v_SHIP_PPLAN_SEQ
           AND A.MEASURE             = 'SHIP_PLAN'
           AND A.QTY                 > 0
         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE;

        --[C20201202-000394][ESS] Shipment Site(생산지) 중복 콤마(,) 처리
        INSERT INTO GT_DMF0021_SHIPMENT_SITE ( DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE, SHIPMENT_SITE )
        SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE
             , NVL("1", '')
                || CASE WHEN "2" IS NULL THEN '' ELSE ',' || "2" END
                || CASE WHEN "3" IS NULL THEN '' ELSE ',' || "3" END
                || CASE WHEN "4" IS NULL THEN '' ELSE ',' || "4" END
                || CASE WHEN "5" IS NULL THEN '' ELSE ',' || "5" END AS SHIPMENT_SITE
          FROM ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS, A.FCST_TYPE, A.FROM_SITE
                      , ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS, A.FCST_TYPE ORDER BY A.FROM_SITE) AS ROW_NUM
                   FROM GT_DMF0021_SHIPMENT_SITE_ROW A )
         PIVOT ( MAX(FROM_SITE) FOR ROW_NUM IN (1, 2, 3, 4, 5) );
    END IF;
    --=================================================================================================================================
    -- SHIPMENT 컬럼 (END)
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A030--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --=================================================================================================================================
    -- CTE 에서 사용할 SELECT COLUMN 정리 (#T_COLUMN_SETUP)
    -- ※ COLUMN_STRING 은 동적 SQL(EXECUTE) 에 삽입되는 SQL 조각이므로 Oracle 문법으로 작성 (ISNULL→NVL, LEN→LENGTH, '+'→'||', CONVERT(FLOAT)→TO_NUMBER)
    --=================================================================================================================================
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'VERSION_NO',     'A.VERSION_NO', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'DIVISION_ID',    'A.DIVISION_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE',   'A.PROJECT_CODE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID',    'A.SCM_SITE_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'PLANT_SITE_ID',  'A.PLANT_SITE_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'GROUP_ID',       'NVL(I.GROUP_ID,'' '') AS GROUP_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID',        'A.ITEM_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'TEXT',           'CASE WHEN A.TEXT IS NULL THEN '' '' ELSE A.TEXT END AS TEXT', 1 );           -- 원본 LEN(A.TEXT)=0 (Oracle ''=NULL)
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'TEXT4082',       'CASE WHEN A.TEXT IS NULL THEN '' '' ELSE A.TEXT END AS TEXT4082', 1 ); --[PJ2024-50611]40,82용 text 컬럼 추가
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'INCOTERMS',      'A.INCOTERMS', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'DOM_EXP',        'A.DOM_EXP', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'FCST_TYPE',      'A.FCST_TYPE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'MEASURE',        'A.MEASURE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'INTERNAL_YN',    'CASE WHEN LENGTH(A.SCM_SITE_ID) > 2 AND LENGTH(A.SCM_SITE_ID) < 6 THEN ''Y'' ELSE ''N'' END AS INTERNAL_YN', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'YYYYMMDD',       'A.YYYYMMDD', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'QTY',            'A.QTY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'VERSION_SORT',   'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'VMI_YN',         'B.VMI_YN', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'END_CUSTOMER',   'NVL(B.END_CUSTOMER,'' '') AS END_CUSTOMER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'CURRENCY',      'CASE WHEN A.CURRENCY IS NOT NULL THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID', 1 ); --[PJ2025-50017]
    -- [PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드(attribute1) 사용
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID',      'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID', 1 );
    -- [2026-09-21 / POJ] Team 칸 표시값을 팀명으로. 부서코드와 같은 세 갈래를 그대로 따른다. 새 조인은 없다
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'ABC', 'TEAM_NAME',    'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.TEAM_NAME ELSE B.TEAM_NAME END ELSE C.TEAM_NAME END AS TEAM_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'APPLICATION',    'C.APPLICATION', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP',     'C.CUST_GROUP', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'OWNER',          'C.OWNER_NAME AS OWNER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'ROUTE',          'C.ROUTE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP_DTL', 'C.CUST_GROUP_DTL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_CAR',   'C.CELL_PER_CAR', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_MODULE','C.CELL_PER_MODULE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'COMPANY_ID',    'CASE WHEN A.COMPANY_ID IS NULL THEN C.SALES_COMPANY ELSE A.COMPANY_ID END AS COMPANY_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'MODULE_PER_CAR', 'CASE WHEN C.CELL_PER_MODULE <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'DMS_SALES',      'NVL(C.ATTRIBUTE1,'''') AS DMS_SALES', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'DMS_CUSTOMER',   'NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL',     'C.ATTRIBUTE5 AS CELL_MODEL', 1 ); --[C20211112-000213]
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'PRIORITY',       'C.ATTRIBUTE7 AS PRIORITY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'KWH_CELL',       'C.ATTRIBUTE8 AS KWH_CELL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL_INFO','NVL(C.REPORT_GROUP6,'''') AS CELL_MODEL_INFO', 1 ); --[C20211112-000213]
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'KWH_MODULE',    'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND C.ATTRIBUTE8 IS NOT NULL THEN (C.CELL_PER_MODULE * TO_NUMBER(C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'KWH_PACK',      'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND C.ATTRIBUTE8 IS NOT NULL THEN (C.CELL_PER_CAR * TO_NUMBER(C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'BIZ_TYPE_NAME40','D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ENERGE',         'D.ENERGE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ENERGE_WH',      'D.ENERGE_WH', 1 ); --[E20240731-000852]_40 사업부 용 ENERGE 컬럼 추가
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'CELL_QUANTITY',  'D.CELL_QUANTITY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ITEM_CLASS_NAME','NVL(D.ITEM_CLASS_NAME,'''') AS ITEM_CLASS_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ITEM_NAME',      'NVL(D.ITEM_NAME,'''') AS ITEM_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ITEM_TYPE',      'NVL(D.ITEM_TYPE,'''') AS ITEM_TYPE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'NICK_NAME',      'NVL(D.NICK_NAME,'''') AS NICK_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'MIN_CAPACITY',   'D.MIN_CAPACITY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC || D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'E', 'CELL_TYPE',      'E.SEGMENT2 AS CELL_TYPE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'F', 'CELL_MODEL_NICK_NAME', 'NVL(F.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'BIZ_TYPE_NAME',  'G.BIZ_TYPE AS BIZ_TYPE_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PROJECT_NAME',   'G.PROJECT_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PROJECT_OWNER',  'G.PROJECT_OWNER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PROJECT_STATUS', 'G.PROJECT_STATUS', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PRODUCT_GROUP_NAME', 'G.PRODUCT_GROUP_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'CITY_NAME',      'B.CITY_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'COUNTRY_NAME',   'B.COUNTRY_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'SHIPTO_DESCRIPTION', 'B.SHIPTO_DESCRIPTION', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'M', 'SORT_ORDER_NO',  'M.SORT_ORDER_NO', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_NAME',      'C.ATTRIBUTE9 AS CELL_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'DISTRIBUTION_CHANNEL', 'B.ATTRIBUTE3 AS DISTRIBUTION_CHANNEL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'SALES_COMPANY',  'C.SALES_COMPANY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'SALES_PLANT',    'C.SALES_PLANT', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'N', 'SHIPMENT_SITE',  'N.SHIPMENT_SITE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'O', 'SEGMENT3',       'NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION', 1 ); --[E20231128-000738]
    --[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'SCP_USE_YN', 'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN ( ''VMI_In_Req'', ''VMI_In_Plan'') THEN ''Y'' WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN ( ''RTF_PR'',''MKT_FCST_RP'',''MKT_FCST'', ''RTF'',''RTF_SCP'',''RTF_SYS_RP'' ) THEN ''Y'' ELSE ''N'' END AS SCP_USE_YN', 1 );
    --[E20260512-000502]_FROM SITE ID 컬럼 추가
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'FROM_SITE_ID', 'CASE WHEN NVL(A.CELL_PROD_SITE_ID,''-'') = ''-'' THEN ''N/A'' ELSE A.CELL_PROD_SITE_ID END AS FROM_SITE_ID', 1 );

    -- 원본: SELECT ... INTO #T FROM UF_FX_String_Split(@ColList, ',') A JOIN #T_COLUMN_SETUP B
    -- → 외부 함수 의존 제거: 인라인 REGEXP_SUBSTR + CONNECT BY 로 ColList(콤마구분) 분해
    INSERT INTO GT_DMF0021_T ( COLUMN_STRING, SEQ )
    SELECT B.COLUMN_STRING, ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
      FROM ( SELECT REGEXP_SUBSTR(TO_CHAR(v_ColList), '[^,]+', 1, LEVEL) AS TOKEN
               FROM DUAL
            CONNECT BY LEVEL <= REGEXP_COUNT(TO_CHAR(v_ColList), ',') + 1 ) A
      JOIN GT_DMF0021_COLUMN_SETUP B ON REPLACE(REPLACE(A.TOKEN, '[', ''), ']', '') = B.COLUMN_NAME;

    -- 동적 SELECT/GROUPBY 작성
    SELECT 1, COUNT(*), '', ''
      INTO v_I, v_CNT, v_SQL_SELECT, v_SQL_GROUPBY
      FROM GT_DMF0021_T;

    WHILE ( v_I <= v_CNT )
    LOOP
        FOR rec IN ( SELECT COLUMN_STRING FROM GT_DMF0021_T WHERE SEQ = v_I )
        LOOP
            v_SQL_SELECT  := v_SQL_SELECT  || CASE WHEN v_I = 1 THEN '' ELSE ',' END || rec.COLUMN_STRING;
            v_SQL_GROUPBY := v_SQL_GROUPBY || CASE WHEN v_I = 1 THEN '' ELSE ',' END
                                || CASE WHEN INSTR(UPPER(rec.COLUMN_STRING), ' AS ') > 0
                                        THEN SUBSTR(rec.COLUMN_STRING, 1, INSTR(UPPER(rec.COLUMN_STRING), ' AS ') - 1)
                                        ELSE rec.COLUMN_STRING END;
        END LOOP;
        v_I := v_I + 1;
    END LOOP;

    ----- [E20230619-000151] 82 사업부는 소수점 표기방식 변경 (FORMAT → ROUND 10자리)
    IF p_division_id = '82' THEN
        v_qty_div := 'ROUND(A.QTY,10)';   -- 원본: CONVERT(float,FORMAT(A.QTY,N'##0.##########'))  [이슈기록]
        v_sum_qty := 'SUM(QTY)';
        v_avg_qty := 'AVG(QTY)';
    ELSE
        v_qty_div := 'A.QTY';
        v_sum_qty := 'SUM(QTY)';
        v_avg_qty := 'AVG(QTY)';
    END IF;

    --=================================================================================================================================
    -- 동적 SQL 생성 및 실행 (원본 #WF SELECT INTO + UNION ALL + PIVOT → WITH WF 인라인 뷰 + 동적 PIVOT)
    --   MSSQL PIVOT 대괄호 식별자 [X] → Oracle 변환 규칙:
    --     · PIVOT IN 리스트   : [X] → 'X' AS "X"
    --     · 피벗 결과 컬럼 투영 : [X] → "X"
    --     · 그룹/정렬 컬럼([@V_COLUMN]/[@v_orderby]) : [X] → X (대괄호만 제거)
    --   ※ 동적 SQL 내 PIVOT IN 리스트/컬럼타입은 OPEN 시점에 해석되므로 운영 데이터로 별도 검증 필요(이슈 기록).
    --   ※ 원본의 중복 NOTATION(명시 + [@SQL_SELECT]) 은 ORA 모호성 방지를 위해 [@SQL_SELECT] 쪽 1건으로 통일.
    --=================================================================================================================================
    DECLARE
        v_col_plain      CLOB;   -- v_ColList   대괄호 제거 (그룹/투영 컬럼)
        v_orderby_plain  CLOB;   -- v_OrderList 대괄호 제거 (ORDER BY)
        v_pv_in          CLOB;   -- PIVOT IN 리스트 ( 'X' AS "X" )
        v_pv_proj        CLOB;   -- 피벗 결과 컬럼 투영 ( "X" )
    BEGIN
        v_col_plain     := REPLACE(REPLACE(v_ColList,   '[', ''), ']', '');
        v_orderby_plain := REPLACE(REPLACE(v_OrderList, '[', ''), ']', '');
        v_pv_in         := REGEXP_REPLACE(v_PV_LIST, '\[([^]]+)\]', '''\1'' AS "\1"');
        v_pv_proj       := REGEXP_REPLACE(v_PV_LIST, '\[([^]]+)\]', '"\1"');

        v_sql_text :=
'WITH WF AS (
    SELECT
        ' || v_qty_div || ' AS QTY
        , CASE WHEN ''' || p_bucket || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
        , M.SORT_ORDER_NO
        , CASE WHEN D.ITEM_ID IS NULL THEN ''N_''
               WHEN A.DIVISION_ID = ''40'' AND A.MEASURE = ''Catch_Up'' THEN ''N_''
               WHEN ( A.DIVISION_ID = ''40'' OR A.DIVISION_ID LIKE ''81%'' ) AND A.MEASURE = ''RTF_SYS_RP'' THEN ''N_''
               WHEN NVL(C.SALES_PLAN_ADJUST_YN,'''') = ''N'' THEN ''N_''
               ELSE ''Y_''
               END
        || CASE WHEN ''' || v_dept_list || ''' LIKE ''%''|| CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END ||''%'' THEN ''Y''
                WHEN ''' || v_group_id || ''' = ''ADMIN'' THEN ''Y''
            ELSE ''N''
            END AS SALES_PLAN_ADJUST_YN
        , CAL.BASIS_YYYYMM, CAL.ISO_WEEK
        , NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION   --[E20231128-000738] 원본 #WF 명시 NOTATION 컬럼 복원 (ColList [NOTATION] 이 참조)
        , ' || v_SQL_SELECT || '
    FROM GT_DMF0021_RAW_DATA A
    LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE B          ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
    LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE_ITEM C     ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
    LEFT OUTER JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V D  ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E     ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
    LEFT OUTER JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V F  ON D.DIVISION_ID = F.DIVISION_ID AND NVL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID
    LEFT OUTER JOIN SCM_MST_PROJECT G                  ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
    LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I        ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
    JOIN GT_DMF0021_SELECT_MEASURE M                   ON A.MEASURE = M.MEASURE
    LEFT OUTER JOIN GT_DMF0021_SHIPMENT_SITE N         ON A.DIVISION_ID = N.DIVISION_ID AND A.PROJECT_CODE = N.PROJECT_CODE AND A.SCM_SITE_ID = N.SCM_SITE_ID
                                                      AND A.ITEM_ID = N.ITEM_ID AND A.FCST_TYPE = N.FCST_TYPE AND A.INCOTERMS = N.INCOTERMS
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL O     ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1
    JOIN SCM_SYS_CALENDAR_M CAL                        ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD AND CAL.BASIS_DATE BETWEEN TO_DATE(''' || p_from_yyyymmdd || ''', ''YYYYMMDD'') AND TO_DATE(''' || p_to_yyyymmdd || ''', ''YYYYMMDD'') + 1
)
SELECT ' || v_col_plain || '
     , SORT_ORDER_NO
     , ' || v_pv_proj || '
FROM (';

        -- @P_BUCKET = 'DAILY' 인 경우 D_YYYYMMDD UNION ALL 추가
        IF p_bucket = 'DAILY' THEN
            v_sql_text := v_sql_text || '
        SELECT ' || v_col_plain || ', F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY
        FROM WF F
        WHERE 1=1
          AND ( ( F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0 ) OR ( F.MEASURE = ''RTF_SYS_RP'' ) )
        UNION ALL';
        END IF;

        --[PJ20209642R] Sales Price 는 Sum 대신 Avg로 계산
        v_sql_text := v_sql_text || '
        SELECT ' || v_col_plain || ', F.SORT_ORDER_NO, ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN ' || v_avg_qty || ' ELSE ' || v_sum_qty || ' END AS QTY
        FROM WF F
        WHERE 1=1
          AND ( ( F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0 ) OR ( F.MEASURE = ''RTF_SYS_RP'' ) )
        GROUP BY ' || v_col_plain || ', F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK
        UNION ALL
        SELECT ' || v_col_plain || ', F.SORT_ORDER_NO, ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN ' || v_avg_qty || ' ELSE ' || v_sum_qty || ' END AS QTY
        FROM WF F
        WHERE 1=1
          AND ( ( F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0 ) OR ( F.MEASURE = ''RTF_SYS_RP'' ) )
        GROUP BY ' || v_col_plain || ', F.SORT_ORDER_NO, F.BASIS_YYYYMM
    )
    PIVOT (
        SUM(QTY) FOR YYYYMMDD IN ( ' || v_pv_in || ' )
    )
    ORDER BY ' || v_orderby_plain;

        DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A033--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        -- 원본: EXEC SP_EXECUTESQL @v_sql_text → Oracle: OPEN cursor FOR (첫 번째 결과셋)
        OPEN p_cur_result FOR v_sql_text;
    END;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50017]/[E20251120-001430]_파셔주차 보정. 당주/전주 기준 YYYYMM/주차 정보 (두 번째 결과셋)
    -----------------------------------------------------------------------------------------------------------------------------------
    OPEN p_cur_calendar FOR
        SELECT 'M_' || A.BASIS_YYYYMM AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM, A.ISO_WEEK
          FROM ( -- [E20250520-000605]_월기준은 MAX 로 조회
                 SELECT MAX(BASIS_YYYYMM) AS BASIS_YYYYMM, MIN(ISO_WEEK) AS ISO_WEEK, MIN(BASIS_DATE) AS BASIS_DATE
                   FROM SCM_SYS_CALENDAR_M
                  -- WHERE BASIS_YYYYMM = ( SELECT BASIS_YYYYMM FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD') )   --*[2026-09-21] POJ 원본
                  -- [2026-09-21 / POJ] AS-IS [E20260720-000270] 당주 월요일 기준 — 파셜주차 월 판정
                  WHERE BASIS_YYYYMM = ( SELECT BASIS_YYYYMM FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') )
                    -- AND ISO_YYYYWW   = ( SELECT ISO_YYYYWW   FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD') )   --*[2026-09-21] POJ 원본
                    -- [2026-09-21 / POJ] AS-IS [E20260720-000270] 당주 월요일 기준 — 파셜주차 주차 판정
                    AND ISO_YYYYWW   = ( SELECT ISO_YYYYWW   FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') )
               ) A
          JOIN ( SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                   FROM SCM_SYS_CALENDAR_M
                  -- WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')   --*[2026-09-21] POJ 원본
                  -- [2026-09-21 / POJ] AS-IS [E20260720-000270] 당주 월요일 기준 — 전주(PRE) 기준일
                  WHERE BASIS_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
               ) B ON 1 = 1;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50017] 그룹+화면+사업부+MEASURE 별 권한 (세 번째 결과셋)
    -----------------------------------------------------------------------------------------------------------------------------------
    OPEN p_cur_edit_auth FOR
        SELECT v_EDIT_AUTH_SalesAmt_LOC AS EDIT_AUTH_SalesAmt_LOC
             , v_EDIT_AUTH_RTF_SYS_RP   AS EDIT_AUTH_RTF_SYS_RP
          FROM DUAL;

    --=================================================================================================================================
    -- Temp Table 존재 여부 체크 (원본 DROP TABLE 블록)
    -- Oracle GTT 는 세션 종료 또는 COMMIT 시 자동 정리되므로 별도 DROP 불필요.
    -- 커서(p_cur_result)가 GTT 데이터를 참조하므로 여기서 DELETE 하지 않음(커서 FETCH 시점까지 유지 필요).
    --=================================================================================================================================
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A034--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

END P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX;


  PROCEDURE P_DMF0021_GET_SPREAD_TITLE
/* [E20260715] MSSQL '' = Oracle NULL 변환 함정 정정 — 숨김 필수 컬럼 포함 조건(2개소)이 실데이터 DEFAULT_FLAG='N' 을 탈락시켜 SALES_PLAN_ADJUST_YN/GROUP_ID 헤더 메타 누락. admin */
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,   -- 20180604 division 추가
    P_BUCKET          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0021_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/06/04     JYE				Div별로 연동                                                            */
/* 2018/10/26     JYE				스프레드 해더 칼럼 통합(일반 데이터 + 날짜데이터)                       */
/* 2021/10/12	rosia27				Sales Plan 속도 개선											        */
/* 2024.03.29   kcw3408             USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 추가					            */
/* 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
AS

    v_user_col_cnt   PLS_INTEGER := 0;
    v_program_id     VARCHAR2(4000 CHAR);
    v_sheet_name     VARCHAR2(4000 CHAR);

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    v_program_id   := 'DMF0021';
    v_sheet_name   := 'Sales Plan';
    v_user_col_cnt := 0;

    SELECT COUNT(*)
    INTO   v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'    /* 2024.03.29   kcw3408  추가 */
    AND    U.USER_ID    = P_CREATED_BY;

    IF v_user_col_cnt > 0 THEN

        OPEN O_RC1 FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , U.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = v_program_id
        AND    U.SHEET_NAME  = v_sheet_name
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,'N') <> 'Y'   --[E20260715] ''=NULL 함정 정정 (실데이터 'N' 탈락 보정)
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO    -- ORA-01790 방지
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER    -- ORA-01790 방지: NUMBER 리터럴
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- ORA-01790 방지: NUMBER NULL
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' || A.BASIS_YYYYMMDD ...
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK ...
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' || A.BASIS_YYYYMM ...
             ) T
        ORDER BY SORT_ORDER_NO;

    ELSE

        OPEN O_RC1 FOR
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,'N') <> 'Y'   --[E20260715] ''=NULL 함정 정정 (실데이터 'N' 탈락 보정)
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO    -- ORA-01790 방지
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , 'FPNumber'              AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER    -- ORA-01790 방지: NUMBER 리터럴
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- ORA-01790 방지: NUMBER NULL
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' || A.BASIS_YYYYMMDD ...
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK ...
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' || A.BASIS_YYYYMM ...
             ) T
        ORDER BY SORT_ORDER_NO;

    END IF;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID,
                'P_BUCKET'         VALUE P_BUCKET
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_GET_SPREAD_TITLE;


  PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15	JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.11.15	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
							룩업에 등록된 메저 가져옴(DM_SALES_PLAN_MEASURE)
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 EXEC DMF0021_GET_SALES_PLAN_MEASUREINFO
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT SEGMENT1    AS CODE
         , SEGMENT2    AS NAME
         , DISPLAY_SEQ
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_SALES_PLAN_MEASURE'
    AND    VALID_YN    = 'Y'
    ORDER BY DISPLAY_SEQ;
    --[PJ2024-50611]기존 쿼리 주석처리
    /*
    SELECT  COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME, SORT_ORDER_NO AS DISPLAY_SEQ
    FROM     SCM_MST_SHEET_MEASURE
    WHERE
    PROGRAM_ID = 'DMF1007' AND SHEET_NAME = 'Sales Plan'
    */

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_GET_SALES_PLAN_MEASUREINFO;


  PROCEDURE P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
(
    P_ACTIVE_FLAG         IN VARCHAR2,
    P_DIVISION_ID         IN VARCHAR2,
    P_PROJECT_CODE        IN VARCHAR2,
    P_SCM_SITE_ID         IN VARCHAR2,
    P_PLANT_SITE_ID       IN VARCHAR2,
    P_ITEM_ID             IN VARCHAR2,
    P_DOM_EXP             IN VARCHAR2,
    P_FCST_TYPE           IN VARCHAR2,
    P_INCOTERMS           IN VARCHAR2,
    P_MEASURE             IN VARCHAR2,
    P_YYYYMMDD            IN VARCHAR2,
    P_QTY                 IN VARCHAR2,
    P_CURRENCY            IN VARCHAR2,
    P_CREATED_BY          IN VARCHAR2,
    P_LAST_UPDATED_BY     IN VARCHAR2,
    P_TEXT                IN VARCHAR2,
    P_DEPT_ID             IN VARCHAR2,  --[PJ2024-50611] 부서ID추가
    P_CELL_PROD_SITE_ID   IN VARCHAR2,  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
/*========================================================================================================================
 * Program ID   : DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
 * Description  : SALES PLAN SAVE 버튼 클릭시 실행 프로시져 ('DM_PLN_SALES_PLAN' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *========================================================================================================================
 *   Date       In Charge      Description
 *========================================================================================================================
 * 2018.03.12   KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.14	KHSOMG		40 DIVISION 조건 추가
 * 2021.05.13	P.C.I		[PJ20209642R] DM_MST_EXCHANGE_RATE_C에 CURRENCY = 'KRW' 조건 추가
 * 2021.08.31	hwi1993		[C20210830-000508] [ESS영업관리팀] GSCM Sales Plan창 입력 가능 최대값 수정 요청의 건
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선. 323라인 DELETE 구문 변경
 * 2021.12.22	rosia27		[C20211220-000276]Sales Plan, Sales Monitoring - 색상 수정 필요
 * 2024.04.04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선)
 * 2024.04.16   KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
 * 2024.11.05	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
 * 2024.11.27	KJJ			[PJ2024-50611] 소형사업부 Sales Plan Catch Up 입력 추가
 * 2024.12.12	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.02.13	JSSBAE		[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
 * 2025.03.12   dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.04.04   JSSBAE		[E20250401-000548] SMS 선감지 대상 정리
 * 2025.05.07   dsiol	    [PJ2025-50017] 프로젝트와 관련한 각종 주석 추가 작성 및 임시테이블 명칭 변경
 * 2025.05.20   JSSBAE	    [E20250520-000572]_Sales Plan 데이터 Validation 로직 변경
 * 2025.06.02   KANG.H.J	[PJ2025-50188] SALES_PLAN 추가 및 수정시 ATTRIBUTE2(FROM_SITE_ID) 데이터 생성
 * 2025.06.12   KANG.H.J	[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
 * 2025.06.20   JSSBAE	    [E20250520-000605]_[영업.마케팅PI] Sales Plan - ETC Data 'Monthly' 입력 Bucket 기능 수정 요청
 * 2025.10.03	JSSBAE		[E20250919-001699]_N-ERP 3차 Roll-in 관련 DM Incoterms 전환 대응 건
 * 2025.11.17	JSSBAE		[E20251027-000091]_Sales Plan UI RTF 간편조정 시 RTF_SYS_RP, RTF_SCP 데이터 동기화
 * 2026.03.17   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 ========================================================================================================================*/
AS

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    v_active_flag         VARCHAR2(4000 CHAR);
    v_division_id_val     VARCHAR2(4000 CHAR);
    v_project_code_val    VARCHAR2(4000 CHAR);
    v_scm_site_id_val     VARCHAR2(4000 CHAR);
    v_plant_site_id_val   VARCHAR2(4000 CHAR);
    v_item_id_val         VARCHAR2(4000 CHAR);
    v_dom_exp_val         VARCHAR2(4000 CHAR);
    v_fcst_type_val       VARCHAR2(4000 CHAR);
    v_incoterms_val       VARCHAR2(4000 CHAR);
    v_measure_val         VARCHAR2(4000 CHAR);
    v_wyyyymmdd           VARCHAR2(4000 CHAR);
    v_yyyymmdd_val        VARCHAR2(8 CHAR);
    v_currency_val        VARCHAR2(4000 CHAR);
    v_qty_val             NUMBER(30,10);
    v_created_by_val      VARCHAR2(4000 CHAR);
    v_last_updated_by_val VARCHAR2(4000 CHAR);
    v_text_val            VARCHAR2(4000 CHAR);
    v_dept_id_val         VARCHAR2(4000 CHAR);
    v_cell_prod_val       VARCHAR2(4000 CHAR);
    v_bucket_val          VARCHAR2(10 CHAR);
    v_weeknumber          VARCHAR2(2 CHAR);
    v_yyyy                VARCHAR2(4 CHAR);
    v_yyyymm              VARCHAR2(6 CHAR);
    v_max_cnt             PLS_INTEGER := 0;

    -- FCST_TYPE 룩업
    T_FCST_TYPE           T_STR_TAB := T_STR_TAB();

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    v_log_type            VARCHAR2(30 CHAR);
    n_log_count           PLS_INTEGER := 0;
    v_log_message         VARCHAR2(1000 CHAR);
    v_description         VARCHAR2(4000 CHAR);
    d_event_date          DATE;
    n_del_count           PLS_INTEGER := 0;
    n_insert_count        PLS_INTEGER := 0;
    n_event_count         PLS_INTEGER := 0;

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION        VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE              VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version    VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_max_sf_w_version    VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_start        VARCHAR2(8 CHAR);
    v_cutoff_end          VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100 CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);

    V_CNT                 NUMBER;
BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=============================================================================================================
    -- GTT TRUNCATE
    --=============================================================================================================
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_LOC;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_RTF;
    DELETE FROM SCM_MGR.GT_F021_DATA_DUP;
    DELETE FROM SCM_MGR.GT_F021_PRICE_RTF_SYS_RP;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_INSERT;

    -- 당주 월요일 관련 날짜 미리 계산
-- 2026.09.22 AJS 마감 버전 선정 기간을 AS-IS 원문 FN_NEXT_DAY 기준으로 (START)
--    v_cutoff_start := TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD');
--    v_cutoff_end   := TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD');
    v_cutoff_start := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
    v_cutoff_end   := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON'), 'YYYYMMDD');
-- 2026.09.22 AJS 마감 버전 선정 기간을 AS-IS 원문 FN_NEXT_DAY 기준으로 (END)

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================
    -- '^' 구분자 파싱 → GT_F021_SALES_PLAN INSERT (PL/SQL FOR LOOP)
    -- MSSQL WHILE 루프 내부에 날짜변환(M_bucket→월말일/01일, W_bucket→IIF+CALENDAR조회) 로직이 있어
    -- 단순 REGEXP INSERT 불가 → 행별 루프 처리
    --=============================================================================================================
    v_max_cnt := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;

    FOR i IN 1..v_max_cnt LOOP

        v_active_flag         := TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,       '[^\^]+', 1, i));
        v_division_id_val     := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,       '[^\^]+', 1, i));
        v_project_code_val    := TRIM(REGEXP_SUBSTR(P_PROJECT_CODE,      '[^\^]+', 1, i));
        v_scm_site_id_val     := TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID,      '[^\^]+', 1, i));
        v_plant_site_id_val   := TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,    '[^\^]+', 1, i));
        --[PLANTNORM 2026-08-04] 인입 센티널 정규화 → '-' (ETC '#' 보존)
        IF v_plant_site_id_val IS NULL OR TRIM(REPLACE(v_plant_site_id_val, CHR(0), ' ')) IS NULL
           OR TRIM(v_plant_site_id_val) IN ('-','--') THEN
            v_plant_site_id_val := '-';
        END IF;
        v_item_id_val         := TRIM(REGEXP_SUBSTR(P_ITEM_ID,          '[^\^]+', 1, i));
        -- v_dom_exp_val         := TRIM(REGEXP_SUBSTR(P_DOM_EXP,          '[^\^]+', 1, i));   --*[2026-09-17] POJ 원본
        -- [2026-09-17 / POJ] 빈 토큰 보존 + NOT NULL 센티널 — 빈 Customs Handbook 이 NULL 로 INSERT 되어 ORA-01400
        v_dom_exp_val         := NVL(TRIM(REGEXP_SUBSTR(P_DOM_EXP          || '^', '(.*?)\^', 1, i, 'n', 1)), '-');
        v_fcst_type_val       := TRIM(REGEXP_SUBSTR(P_FCST_TYPE,        '[^\^]+', 1, i));
        -- v_incoterms_val       := TRIM(REGEXP_SUBSTR(P_INCOTERMS,        '[^\^]+', 1, i));   --*[2026-09-17] POJ 원본
        -- [2026-09-17 / POJ] 빈 토큰 보존 + NOT NULL 센티널 — 빈 Incoterms 가 NULL 로 INSERT 되어 ORA-01400
        v_incoterms_val       := NVL(TRIM(REGEXP_SUBSTR(P_INCOTERMS        || '^', '(.*?)\^', 1, i, 'n', 1)), '-');
        v_measure_val         := TRIM(REGEXP_SUBSTR(P_MEASURE,          '[^\^]+', 1, i));
        v_wyyyymmdd           := TRIM(REGEXP_SUBSTR(P_YYYYMMDD,         '[^\^]+', 1, i));
        v_currency_val        := TRIM(REGEXP_SUBSTR(P_CURRENCY,         '[^\^]+', 1, i));
        v_qty_val             := TO_NUMBER(TRIM(REGEXP_SUBSTR(P_QTY,    '[^\^]+', 1, i)));
        v_created_by_val      := TRIM(REGEXP_SUBSTR(P_CREATED_BY,       '[^\^]+', 1, i));
        v_last_updated_by_val := TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY,  '[^\^]+', 1, i));
        -- v_text_val            := TRIM(REGEXP_SUBSTR(P_TEXT,              '[^\^]+', 1, i));   --*[2026-09-17] POJ 원본
        -- [2026-09-17 / POJ] 빈 토큰 보존 + NOT NULL 센티널 — 빈 비고가 NULL 로 INSERT 되어 ORA-01400 (신고된 증상)
        v_text_val            := NVL(TRIM(REGEXP_SUBSTR(P_TEXT             || '^', '(.*?)\^', 1, i, 'n', 1)), '-');
        v_dept_id_val         := TRIM(REGEXP_SUBSTR(P_DEPT_ID,          '[^\^]+', 1, i));
        v_cell_prod_val       := TRIM(REGEXP_SUBSTR(P_CELL_PROD_SITE_ID,'[^\^]+', 1, i));

        -- Bucket 구분: 첫글자
        v_bucket_val := SUBSTR(v_wyyyymmdd, 1, 1);
        v_weeknumber := SUBSTR(v_wyyyymmdd, -2);
        v_yyyy       := SUBSTR(v_wyyyymmdd, 3, 4);
        v_yyyymm     := SUBSTR(v_wyyyymmdd, 3, 6);

        -- 날짜 변환 로직
        IF v_bucket_val = 'M' THEN
            --[E20250520-000605]_40사업부 + ETC → 달의 마지막 날
            IF v_division_id_val = '40' AND v_fcst_type_val = 'ETC' THEN
                SELECT v_yyyymm || MAX(CALENDAR_DAY)
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMM = v_yyyymm;
            ELSE
                v_yyyymmdd_val := v_yyyymm || '01';
            END IF;
        ELSE
            IF SUBSTR(v_yyyymm, 5, 2) <> '12' THEN
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber;
            ELSE
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber
                AND    A.BASIS_YYYYMM  = v_yyyymm;
            END IF;
        END IF;

        INSERT INTO GT_F021_SALES_PLAN
        (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
         V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
         V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY,
         V_TEXT, V_DEPT_ID, V_BUCKET, V_CELL_PROD_SITE_ID)
        VALUES
        (v_active_flag, v_division_id_val, v_project_code_val, v_scm_site_id_val, v_plant_site_id_val,
         v_item_id_val, v_dom_exp_val, v_fcst_type_val, v_incoterms_val, v_measure_val,
         v_yyyymmdd_val, v_currency_val, v_qty_val, v_created_by_val, v_last_updated_by_val,
         v_text_val, v_dept_id_val, v_bucket_val, v_cell_prod_val);

    END LOOP;

    --COMMIT;

    --=============================================================================================================
    -- [PJ2025-50188] FROM_SITE_ID 업데이트
    --=============================================================================================================
    MERGE INTO GT_F021_SALES_PLAN A
    USING (
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
             , FCST_TYPE, INCOTERMS, MEASURE
             , CASE WHEN PLANT_SITE_ID IS NULL OR TRIM(REPLACE(PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE PLANT_SITE_ID END AS PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , MAX(ATTRIBUTE2) AS FROM_SITE_ID
        FROM   DM_PLN_SALES_PLAN
        WHERE  DIVISION_ID = v_division_id_val
        AND    MEASURE     = 'RTF_SYS_RP'
        AND    YYYYMMDD   >= v_cutoff_start
        AND    ATTRIBUTE2 IS NOT NULL
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
               , FCST_TYPE, INCOTERMS, MEASURE
               , CASE WHEN PLANT_SITE_ID IS NULL OR TRIM(REPLACE(PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE PLANT_SITE_ID END
               , CELL_PROD_SITE_ID
    ) B
    ON (    A.V_DIVISION_ID      = B.DIVISION_ID
        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.V_PLANT_SITE_ID 	 = B.PLANT_SITE_ID
        AND A.V_ITEM_ID          = B.ITEM_ID
        AND A.V_DOM_EXP          = B.DOM_EXP
        AND A.V_FCST_TYPE        = B.FCST_TYPE
        AND A.V_INCOTERMS        = B.INCOTERMS
        AND A.V_MEASURE          = B.MEASURE
        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    )
    WHEN MATCHED THEN UPDATE SET A.V_FROM_SITE_ID = B.FROM_SITE_ID;

    --COMMIT;

    --=============================================================================================================
    -- GTT 통계 수집
    --=============================================================================================================
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

    --=============================================================================================================
    -- 저장 데이터 유형 별로 GTT 분리
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'SalesAmt_LOC';

    INSERT INTO GT_F021_SALES_PLAN_RTF SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'RTF_SYS_RP';

    --[E20251027-000091]_RTF_SYS_RP 메져로 RTF_SCP, RTF 생성
    INSERT INTO GT_F021_SALES_PLAN_RTF
    SELECT A.V_ACTIVE_FLAG, A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_PLANT_SITE_ID
         , A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, B.MEASURE
         , A.V_YYYYMMDD, A.V_CURRENCY, A.V_QTY, A.V_CREATED_BY, A.V_LAST_UPDATED_BY
         , A.V_TEXT, A.V_DEPT_ID, A.V_BUCKET, A.V_CELL_PROD_SITE_ID, A.V_FROM_SITE_ID
    FROM GT_F021_SALES_PLAN_RTF A
    CROSS JOIN (SELECT 'RTF' AS MEASURE FROM DUAL UNION ALL SELECT 'RTF_SCP' FROM DUAL) B
    WHERE A.V_MEASURE = 'RTF_SYS_RP';

    --COMMIT;

    --=============================================================================================================
    -- VALIDATION (START)
    --=============================================================================================================

    -- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN R
            WHERE R.V_INCOTERMS IN (
                SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1
            )
        );
        v_log_type    := 'INVALID';
        V_S_CODE      := 'MSG00467';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- PROJECT_CODE 유효성 (40사업부 제외)
    BEGIN
        SELECT V_PROJECT_CODE INTO V_S_VALIDATION
        FROM (
            SELECT A.V_PROJECT_CODE
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_PROJECT B
                ON A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
            WHERE A.V_PROJECT_CODE <> 'N'
            AND   A.V_DIVISION_ID  <> '40'
            AND   B.PROJECT_CODE IS NULL
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00457';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    --[E20250520-000572]_INVALID2, INVALID4 VALIDATION 통합
    INSERT INTO GT_F021_DATA_DUP
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP,
     V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD, V_CELL_PROD_SITE_ID)
    SELECT LOC.V_DIVISION_ID, LOC.V_PROJECT_CODE, LOC.V_SCM_SITE_ID, LOC.V_ITEM_ID, LOC.V_DOM_EXP
         , LOC.V_FCST_TYPE, LOC.V_INCOTERMS, LOC.V_MEASURE, LOC.V_PLANT_SITE_ID, LOC.V_YYYYMMDD
         , LOC.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC LOC
    INNER JOIN DM_PLN_SALES_ETC_PLAN P
        ON  LOC.V_DIVISION_ID   = P.DIVISION_ID
        AND LOC.V_PROJECT_CODE  = P.PROJECT_CODE
        AND LOC.V_SCM_SITE_ID   = P.SCM_SITE_ID
        AND LOC.V_ITEM_ID       = P.ITEM_ID
        AND LOC.V_DOM_EXP       = P.DOM_EXP
        AND LOC.V_FCST_TYPE     = P.FCST_TYPE
        AND LOC.V_INCOTERMS     = P.INCOTERMS
        AND LOC.V_MEASURE       = P.MEASURE
        AND LOC.V_PLANT_SITE_ID = CASE WHEN P.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(P.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(P.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE P.PLANT_SITE_ID END
        AND LOC.V_YYYYMMDD      = P.YYYYMMDD
        AND LOC.V_TEXT           = P.REMARK_TEXT
    WHERE LOC.V_ACTIVE_FLAG = 'I'
    UNION ALL
    SELECT RTF.V_DIVISION_ID, RTF.V_PROJECT_CODE, RTF.V_SCM_SITE_ID, RTF.V_ITEM_ID, RTF.V_DOM_EXP
         , RTF.V_FCST_TYPE, RTF.V_INCOTERMS, RTF.V_MEASURE, RTF.V_PLANT_SITE_ID, RTF.V_YYYYMMDD
         , RTF.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF RTF
    INNER JOIN DM_PLN_SALES_PLAN P
        ON  RTF.V_DIVISION_ID       = P.DIVISION_ID
        AND RTF.V_PROJECT_CODE      = P.PROJECT_CODE
        AND RTF.V_SCM_SITE_ID       = P.SCM_SITE_ID
        AND RTF.V_ITEM_ID           = P.ITEM_ID
        AND RTF.V_DOM_EXP           = P.DOM_EXP
        AND RTF.V_FCST_TYPE         = P.FCST_TYPE
        AND RTF.V_INCOTERMS         = P.INCOTERMS
        AND RTF.V_MEASURE           = P.MEASURE
        AND RTF.V_PLANT_SITE_ID = CASE WHEN P.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(P.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(P.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE P.PLANT_SITE_ID END
        AND RTF.V_YYYYMMDD          = P.YYYYMMDD
        AND RTF.V_CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
    WHERE RTF.V_ACTIVE_FLAG = 'I';

    BEGIN
        SELECT CHR(10) || '*Div : ' || NVL(V_DIVISION_ID,'')
             || CHR(10) || CASE WHEN V_DIVISION_ID = '40' THEN '*End Customer : ' ELSE '*Project Code : ' END || NVL(V_PROJECT_CODE,'')
             || CHR(10) || '*Sales Site : '          || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || '*Model : '               || NVL(V_ITEM_ID,'')
             || CHR(10) || '*Customer Handbook : '   || NVL(V_DOM_EXP,'')
             || CHR(10) || '*FCST Type : '           || NVL(V_FCST_TYPE,'')
             || CHR(10) || '*INCOTERMS : '           || NVL(V_INCOTERMS,'')
             || CHR(10) || '*Measure : '             || NVL(V_MEASURE,'')
             || CHR(10) || '*Plant Site : '          || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || '*YYYYMMDD : '            || NVL(V_YYYYMMDD,'')
             || CHR(10) || '*Cell Prod Site ID : '   || NVL(V_CELL_PROD_SITE_ID,'')
        INTO V_S_VALIDATION
        FROM (SELECT * FROM GT_F021_DATA_DUP ORDER BY V_YYYYMMDD)
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00428';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- Catch_Up 모델 유효성
    BEGIN
        SELECT A.V_ITEM_ID INTO V_S_VALIDATION
        FROM (
            SELECT A.V_ITEM_ID
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_SITE_ITEM B
                ON  A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
                AND A.V_SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.V_ITEM_ID      = B.ITEM_ID
            WHERE A.V_DIVISION_ID = '40'
            AND   A.V_MEASURE     = 'Catch_Up'
            AND   B.ITEM_ID IS NULL
        ) A
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00458';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- Catch_Up 판가 유효성 체크
    SELECT SEGMENT2
    BULK COLLECT INTO T_FCST_TYPE
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND    MST.SEGMENT1    = 'FCST_TYPE'
    AND    VALID_YN        = 'Y';

    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_DIVISION_ID = '40'
            AND   TMP.V_MEASURE     = 'Catch_Up'
            AND   TMP.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_FCST_TYPE))
            AND   NOT EXISTS (
                SELECT 1 FROM DM_PLN_CFM_SELLING_PRICE FP
                WHERE FP.DIVISION_ID               = TMP.V_DIVISION_ID
                AND   FP.PROJECT_CODE              = TMP.V_PROJECT_CODE
                AND   FP.SCM_SITE_ID               = TMP.V_SCM_SITE_ID
                AND   CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
                AND   FP.ITEM_ID                   = TMP.V_ITEM_ID
                AND   SUBSTR(FP.YYYYMMDD,1,6)      = SUBSTR(TMP.V_YYYYMMDD,1,6)
                AND   FP.MEASURE                   = 'LOC'
                AND   FP.DOM_EXP                   = TMP.V_DOM_EXP
                AND   FP.FCST_TYPE                 = TMP.V_FCST_TYPE
                AND   FP.INCOTERMS                 = TMP.V_INCOTERMS
                AND   FP.CELL_PROD_SITE_ID         = TMP.V_CELL_PROD_SITE_ID
            )
        );
        v_log_type     := 'INVALID';
        V_S_CODE       := 'MSG00328';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

	---------------------------------------------------------------------------------------------------------------
	--AS-IS [E20260331-000648]_SALES PLAN CUTOFF가 한번도 진행되지 않은 경우에는 RTF를 수정하지 못하게한다. (START)
    --버전 정보가 한건이라도 있는 경우 최종 결과 값은 NO DATA이어야 하고 데이터가 한건도 없는 경우에 1을 RETURN(오)
    --NO DATA인 경우 EXCEPTION문으로 들어가고 다음줄을 실행, 최종 결과 1건이상이면 VALIDATION_FAIL로 이동하여 메시지 리턴
	---------------------------------------------------------------------------------------------------------------
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_MEASURE = 'RTF_SYS_RP'
            AND NOT EXISTS (
                SELECT 1 FROM DM_MST_VERSION
				WHERE DIVISION_ID = TMP.V_DIVISION_ID
				AND VERSION_TYPE = 'SP_W'
--				AND YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'),'YYYYMMDD')	--당주 기준으로 월요일에 해당하는 일자
				AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')	--당주 기준으로 월요일에 해당하는 일자  -- 2026.09.22 AJS
            )
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00473'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;
	---------------------------------------------------------------------------------------------------------------
	--AS-IS [E20260331-000648]_SALES PLAN CUTOFF가 한번도 진행되지 않은 경우에는 RTF를 수정하지 못하게한다. (END)
	---------------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------------
	--AS-IS [E20260331-000648]_룩업에 지정된 시간이 지나면 저장을 하지 못하도록 한다.(START)
	---------------------------------------------------------------------------------------------------------------
    --[RTFGATE 2026-08-12] RTF[R+P] Sales Plan Cutoff 게이트 (통합테스트 1st No.58 ①②)
    --  RTF_SYS_RP 저장 행이 있는데, 그 행 division 에 대해 사용자 보유그룹(AUTHUNION) 매칭 +
    --  시간창 통과 lookup 행이 하나도 없으면 저장 전체 차단 (MSG00704).
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_MEASURE = 'RTF_SYS_RP'
            AND EXISTS (
                SELECT 1
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B
                WHERE  B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                AND    B.VALID_YN    = 'Y'
                AND    B.SEGMENT2    = 'DMF0021'
                AND    B.SEGMENT3    = TMP.V_DIVISION_ID
                AND    B.SEGMENT4    = 'RTF_SYS_RP'
                AND    (B.SEGMENT1 = TMP.V_CREATED_BY
                        OR B.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                          WHERE G.USER_ID = TMP.V_CREATED_BY AND G.USE_YN = 'Y'))
--                AND    (B.ATTRIBUTE1 IS NULL
--                        OR SYSDATE >= TRUNC(SYSDATE, 'IW')
--                           + DECODE(B.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
--                           + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 1, 2)), 0) / 24
--                           + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 3, 2)), 0) / 1440)
               --*[2026.08.18] ASIS 비교 로직 적용
               AND NVL(B.ATTRIBUTE1,'-') NOT IN ('-',' ')
               -- 1. 현재 요일 > ATTRIBUTE1 이거나,
               AND ((MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1 ) > DECODE(B.ATTRIBUTE1, 'SUN', 1, 'MON', 2, 'TUE', 3, 'WED', 4, 'THU', 5, 'FRI', 6, 'SAT', 7)
               -- 2. 현재 요일 = ATTRIBUTE1 이고 현재 시간 > ATTRIBUTE2 인 경우
  				 OR ((MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1 ) = DECODE(B.ATTRIBUTE1, 'SUN', 1, 'MON', 2, 'TUE', 3, 'WED', 4, 'THU', 5, 'FRI', 6, 'SAT', 7)
  				 AND TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI')) > TO_NUMBER(TRIM(B.ATTRIBUTE2))
  				    )	--시분
  				   )
            )
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00474'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;
	---------------------------------------------------------------------------------------------------------------
	--AS-IS [E20260331-000648]_SALES PLAN CUTOFF가 3번인 경우, SALES PLAN 수정을 못하게한다. 81, 81_JV(END)
	---------------------------------------------------------------------------------------------------------------

    -- RMA 음수값 확인
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE = 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) > 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00459'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RMA 이외 정수값 확인
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE <> 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) < 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00460'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RTF Price 존재 체크
    --*[2026-09-07] POJ [E20260331-000648] 사업부 분기 복원 — AS-IS 는 40 과 40 외가 바라보는 판가 테이블이 다르다.
    --   40    : DM_PLN_CFM_SELLING_PRICE (END_CUSTOMER · CELL_PROD_SITE_ID 조인 포함)
    --   40 외 : SCM_MST_FUTURE_PRICE      (두 컬럼이 없어 조인 대상이 아니다)
    --   분기가 없으면 81·81_JV 는 판가가 있어도 못 찾아 MSG00462 가 잘못 뜬다.
    --*[2026-09-07] POJ 분기 판정은 AS-IS 와 같게 계획 데이터의 사업부로 한다 (AS-IS: #TEMP_SALES_PLAN)
    SELECT COUNT(1) INTO v_max_cnt FROM GT_F021_SALES_PLAN WHERE V_DIVISION_ID = '40';
    IF v_max_cnt > 0 THEN
	    INSERT INTO GT_F021_PRICE_RTF_SYS_RP
	    (V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_CELL_PROD_SITE_ID, WEEK_NAME)
	    SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE
	         , A.V_INCOTERMS, A.V_PLANT_SITE_ID, A.V_CELL_PROD_SITE_ID, A.WEEK_NAME
	    FROM (
	        SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
	             , AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
	             , AA.V_MEASURE, M.BASIS_START_DATE, AA.V_QTY, M.WEEK_NAME
	        FROM   GT_F021_SALES_PLAN_RTF AA
	        JOIN   SCM_SYS_CALENDAR_M M ON AA.V_YYYYMMDD = M.BASIS_YYYYMMDD
	        WHERE  AA.V_MEASURE = 'RTF_SYS_RP'
	    ) A
	    LEFT JOIN (
	        SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
	             , BB.CELL_PROD_SITE_ID, BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS
	             , BB.MEASURE, M.BASIS_START_DATE, BB.END_CUSTOMER
	        FROM   DM_PLN_CFM_SELLING_PRICE BB
	        JOIN   SCM_SYS_CALENDAR_M M ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
	        WHERE  BB.MEASURE = 'LOC'
	    ) B
	        ON  A.V_DIVISION_ID      = B.DIVISION_ID
	        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
	        AND A.V_PROJECT_CODE     = B.END_CUSTOMER
	        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
	        AND A.V_PLANT_SITE_ID = CASE WHEN B.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(B.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(B.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE B.PLANT_SITE_ID END
	        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
	        AND A.V_ITEM_ID          = B.ITEM_ID
	        AND A.V_DOM_EXP          = B.DOM_EXP
	        AND A.V_FCST_TYPE        = B.FCST_TYPE
	        AND A.V_INCOTERMS        = B.INCOTERMS
	        AND A.BASIS_START_DATE   = B.BASIS_START_DATE
	    WHERE B.BASIS_START_DATE IS NULL
	    AND   A.V_FCST_TYPE <> 'ETC'
	    AND   NVL(A.V_QTY, 0) <> 0
    	--*[2026-09-07] POJ [E20260708-001170] 룩업에 등록된 FCST_TYPE 은 검증에서 뺀다 (AS-IS #TMP_FCST_TYPE)
        AND   A.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_FCST_TYPE));

    ELSE
        --*[2026-09-07] POJ 40 외(81 · 81_JV) — 선물가 마스터를 본다. AS-IS L1184~1222 와 같은 조인이다.
	    INSERT INTO GT_F021_PRICE_RTF_SYS_RP
	    (V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_CELL_PROD_SITE_ID, WEEK_NAME)
	    SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE
	         , A.V_INCOTERMS, A.V_PLANT_SITE_ID, A.V_CELL_PROD_SITE_ID, A.WEEK_NAME
	        FROM (
	            SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
	                 , AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
	                 , AA.V_MEASURE, M.BASIS_START_DATE, AA.V_QTY, M.WEEK_NAME
	            FROM   GT_F021_SALES_PLAN_RTF AA
	            JOIN   SCM_SYS_CALENDAR_M M ON AA.V_YYYYMMDD = M.BASIS_YYYYMMDD
	            WHERE  AA.V_MEASURE = 'RTF_SYS_RP'
	        ) A
	        LEFT JOIN (
	            SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
	                 , BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS
	                 , BB.MEASURE, M.BASIS_START_DATE
	            FROM   SCM_MST_FUTURE_PRICE BB
	            JOIN   SCM_SYS_CALENDAR_M M ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
	            WHERE  BB.MEASURE = 'LOC'
	        ) B
	            ON  A.V_DIVISION_ID      = B.DIVISION_ID
	            AND A.V_PROJECT_CODE     = B.PROJECT_CODE
	            AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
	            AND A.V_PLANT_SITE_ID    = B.PLANT_SITE_ID
	            AND A.V_ITEM_ID          = B.ITEM_ID
	            AND A.V_DOM_EXP          = B.DOM_EXP
	            AND A.V_FCST_TYPE        = B.FCST_TYPE
	            AND A.V_INCOTERMS        = B.INCOTERMS
	            AND A.BASIS_START_DATE   = B.BASIS_START_DATE
	        WHERE B.BASIS_START_DATE IS NULL
	        AND   A.V_FCST_TYPE <> 'ETC'
	        AND   NVL(A.V_QTY, 0) <> 0
	        --*[2026-09-07] POJ [E20260708-001170] 룩업에 등록된 FCST_TYPE 은 검증에서 뺀다 (AS-IS #TMP_FCST_TYPE)
	        AND   A.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_FCST_TYPE));

    END IF;

    BEGIN
        SELECT CHR(10) || 'Project Code________ : '      || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Sales site_____________ : '  || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model________________ : '    || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Customs Handbook__ : '       || NVL(V_DOM_EXP,'')
             || CHR(10) || 'Fcst Type_____________ : '   || NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT1 = V_FCST_TYPE AND ROWNUM = 1), '')
             || CHR(10) || 'Incoterms____________ : '    || NVL(V_INCOTERMS,'')
             || CHR(10) || 'Plant Site___________ : '    || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || 'Cell Prod Site___________ : ' || NVL(V_CELL_PROD_SITE_ID,'')
             || CHR(10) || 'Week_________ : '            || NVL(WEEK_NAME,'')
        INTO V_S_VALIDATION
        FROM GT_F021_PRICE_RTF_SYS_RP WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00462';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- [E20250401-000548] 동일일자 CURRENCY 중복 체크
    BEGIN
        SELECT CHR(10) || 'Div: '            || NVL(V_DIVISION_ID,'')
             || CHR(10) || 'Project Code: '  || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Scm Site Id: '   || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model: '         || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Currency : '     || NVL(V_CURRENCY,'')
        INTO V_S_VALIDATION
        FROM (
            SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                 , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            FROM   GT_F021_SALES_PLAN_LOC
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                   , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            HAVING COUNT(*) > 1
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00461';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    --=============================================================================================================
    -- VALIDATION (END)
    --=============================================================================================================

    --=============================================================================================================
    -- DELETE SECTION
    --=============================================================================================================

    -- [E20250211-000653] Monthly / Weekly 분기
    SELECT COUNT(1) INTO V_CNT FROM GT_F021_SALES_PLAN WHERE V_BUCKET = 'M';
    IF V_CNT > 0 THEN

        -- Monthly: DM_PLN_SALES_ETC_PLAN (SalesAmt_LOC)
        -- [E20260819-NVLSAVE2] 선삭제 키 비교 양변 NVL(x,'-') 정규화 (hook #119 §1.5) — ''(=NULL) 저장분 재저장 시 ORA-00001 방지
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    NVL(A.DIVISION_ID,'-')       = NVL(TMP.V_DIVISION_ID,'-')
            AND    NVL(A.PROJECT_CODE,'-')      = NVL(TMP.V_PROJECT_CODE,'-')
            AND    NVL(A.SCM_SITE_ID,'-')       = NVL(TMP.V_SCM_SITE_ID,'-')
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    NVL(A.ITEM_ID,'-')           = NVL(TMP.V_ITEM_ID,'-')
            AND    NVL(A.DOM_EXP,'-')           = NVL(TMP.V_DOM_EXP,'-')
            AND    NVL(A.FCST_TYPE,'-')         = NVL(TMP.V_FCST_TYPE,'-')
            AND    NVL(A.INCOTERMS,'-')         = NVL(TMP.V_INCOTERMS,'-')
            -- AND    NVL(A.REMARK_TEXT,'-')       = NVL(TMP.V_TEXT,'-')   --*[2026-09-16] POJ 원본
            -- [2026-09-16 / POJ] 기타매출 원장 Text 비교에 TRIM 적용. FE 가 보내는 값은 trim 된 상태인데 저장된 REMARK_TEXT 에 끝 공백이 있는 행이 있어(81 12건 · 81_UC 5건 · 82 1건) 선삭제가 빗나가 새 행이 생겼다. REMARK_TEXT 는 PK 구성 컬럼이다
            AND    NVL(TRIM(A.REMARK_TEXT),'-')       = NVL(TRIM(TMP.V_TEXT),'-')
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

        n_del_count := n_del_count + SQL%ROWCOUNT;

        -- Monthly: DM_PLN_SALES_PLAN (RTF_SYS_RP)
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            -- [2026-09-16 / POJ] 원본 시작 — DM_PLN_SALES_PLAN 선삭제 키 비교를 빈값 '-' 기준으로 통일
            --    기타매출 원장 선삭제는 이미 NVL(x,'-') 인데 여기만 원시 비교라 기준이 달랐다.
            --    인입값은 파싱에서 빈 토큰이 NULL 이 되므로 NULL = '-' 가 UNKNOWN 이 되어 선삭제가 빗나간다.
            -- AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            -- AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            -- AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            -- AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            -- AND    A.ITEM_ID               = TMP.V_ITEM_ID
            -- AND    A.DOM_EXP               = TMP.V_DOM_EXP
            -- AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            -- AND    A.INCOTERMS             = TMP.V_INCOTERMS
            -- AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            -- AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
            -- [2026-09-16 / POJ] 원본 끝
            AND    NVL(A.DIVISION_ID,'-') = NVL(TMP.V_DIVISION_ID,'-')
            AND    NVL(A.PROJECT_CODE,'-') = NVL(TMP.V_PROJECT_CODE,'-')
            AND    NVL(A.SCM_SITE_ID,'-') = NVL(TMP.V_SCM_SITE_ID,'-')
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    NVL(A.ITEM_ID,'-') = NVL(TMP.V_ITEM_ID,'-')
            AND    NVL(A.DOM_EXP,'-') = NVL(TMP.V_DOM_EXP,'-')
            AND    NVL(A.FCST_TYPE,'-') = NVL(TMP.V_FCST_TYPE,'-')
            AND    NVL(A.INCOTERMS,'-') = NVL(TMP.V_INCOTERMS,'-')
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    NVL(A.CELL_PROD_SITE_ID,'-') = NVL(TMP.V_CELL_PROD_SITE_ID,'-')
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    ELSE
        -- Weekly: DM_PLN_SALES_ETC_PLAN (SalesAmt_LOC)
        -- [E20260819-NVLSAVE2] 선삭제 키 비교 양변 NVL(x,'-') 정규화 (hook #119 §1.5) — ''(=NULL) 저장분 재저장 시 ORA-00001 방지
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    NVL(A.DIVISION_ID,'-')       = NVL(TMP.V_DIVISION_ID,'-')
            AND    NVL(A.PROJECT_CODE,'-')      = NVL(TMP.V_PROJECT_CODE,'-')
            AND    NVL(A.SCM_SITE_ID,'-')       = NVL(TMP.V_SCM_SITE_ID,'-')
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    NVL(A.ITEM_ID,'-')           = NVL(TMP.V_ITEM_ID,'-')
            AND    NVL(A.DOM_EXP,'-')           = NVL(TMP.V_DOM_EXP,'-')
            AND    NVL(A.FCST_TYPE,'-')         = NVL(TMP.V_FCST_TYPE,'-')
            AND    NVL(A.INCOTERMS,'-')         = NVL(TMP.V_INCOTERMS,'-')
            -- AND    NVL(A.REMARK_TEXT,'-')       = NVL(TMP.V_TEXT,'-')   --*[2026-09-16] POJ 원본
            -- [2026-09-16 / POJ] 기타매출 원장 Text 비교에 TRIM 적용. FE 가 보내는 값은 trim 된 상태인데 저장된 REMARK_TEXT 에 끝 공백이 있는 행이 있어(81 12건 · 81_UC 5건 · 82 1건) 선삭제가 빗나가 새 행이 생겼다. REMARK_TEXT 는 PK 구성 컬럼이다
            AND    NVL(TRIM(A.REMARK_TEXT),'-')       = NVL(TRIM(TMP.V_TEXT),'-')
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW       = C1.ISO_YYYYWW
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

        n_del_count := n_del_count + SQL%ROWCOUNT;

        -- Weekly: DM_PLN_SALES_PLAN (RTF_SYS_RP)
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            -- [2026-09-16 / POJ] 원본 시작 — DM_PLN_SALES_PLAN 선삭제 키 비교를 빈값 '-' 기준으로 통일
            --    기타매출 원장 선삭제는 이미 NVL(x,'-') 인데 여기만 원시 비교라 기준이 달랐다.
            --    인입값은 파싱에서 빈 토큰이 NULL 이 되므로 NULL = '-' 가 UNKNOWN 이 되어 선삭제가 빗나간다.
            -- AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            -- AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            -- AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            -- AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            -- AND    A.ITEM_ID               = TMP.V_ITEM_ID
            -- AND    A.DOM_EXP               = TMP.V_DOM_EXP
            -- AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            -- AND    A.INCOTERMS             = TMP.V_INCOTERMS
            -- AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            -- AND    C2.ISO_YYYYWW           = C1.ISO_YYYYWW
            -- AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
            -- [2026-09-16 / POJ] 원본 끝
            AND    NVL(A.DIVISION_ID,'-') = NVL(TMP.V_DIVISION_ID,'-')
            AND    NVL(A.PROJECT_CODE,'-') = NVL(TMP.V_PROJECT_CODE,'-')
            AND    NVL(A.SCM_SITE_ID,'-') = NVL(TMP.V_SCM_SITE_ID,'-')
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    NVL(A.ITEM_ID,'-') = NVL(TMP.V_ITEM_ID,'-')
            AND    NVL(A.DOM_EXP,'-') = NVL(TMP.V_DOM_EXP,'-')
            AND    NVL(A.FCST_TYPE,'-') = NVL(TMP.V_FCST_TYPE,'-')
            AND    NVL(A.INCOTERMS,'-') = NVL(TMP.V_INCOTERMS,'-')
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW           = C1.ISO_YYYYWW
            AND    NVL(A.CELL_PROD_SITE_ID,'-') = NVL(TMP.V_CELL_PROD_SITE_ID,'-')
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    END IF;

    -- SalesAmt_LOC/CATCH_UP/RTF_SYS_RP delete
    -- [E20260819-NVLSAVE2] 선삭제 키 비교 양변 NVL(x,'-') 정규화 (hook #119 §1.5) — ''(=NULL) 저장분 재저장 시 ORA-00001 방지
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'SalesAmt_LOC'
        AND   NVL(A.DIVISION_ID,'-')   = NVL(TMP.V_DIVISION_ID,'-')
        AND   NVL(A.PROJECT_CODE,'-')  = NVL(TMP.V_PROJECT_CODE,'-')
        AND   NVL(A.SCM_SITE_ID,'-')   = NVL(TMP.V_SCM_SITE_ID,'-')
        AND   CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
        AND   NVL(A.ITEM_ID,'-')       = NVL(TMP.V_ITEM_ID,'-')
        AND   NVL(A.DOM_EXP,'-')       = NVL(TMP.V_DOM_EXP,'-')
        AND   NVL(A.FCST_TYPE,'-')     = NVL(TMP.V_FCST_TYPE,'-')
        AND   NVL(A.INCOTERMS,'-')     = NVL(TMP.V_INCOTERMS,'-')
        -- AND   NVL(A.REMARK_TEXT,'-')   = NVL(TMP.V_TEXT,'-')   --*[2026-09-16] POJ 원본
        -- [2026-09-16 / POJ] 기타매출 원장 Text 비교에 TRIM 적용. FE 가 보내는 값은 trim 된 상태인데 저장된 REMARK_TEXT 에 끝 공백이 있는 행이 있어(81 12건 · 81_UC 5건 · 82 1건) 선삭제가 빗나가 새 행이 생겼다. REMARK_TEXT 는 PK 구성 컬럼이다
        AND   NVL(TRIM(A.REMARK_TEXT),'-')   = NVL(TRIM(TMP.V_TEXT),'-')
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    -- CATCH_UP delete
    -- [E20260819-NVLSAVE2] 선삭제 키 비교 양변 NVL(x,'-') 정규화 (hook #119 §1.5) — ''(=NULL) 저장분 재저장 시 ORA-00001 방지
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'CATCH_UP'
        AND   NVL(A.DIVISION_ID,'-')   = NVL(TMP.V_DIVISION_ID,'-')
        AND   NVL(A.PROJECT_CODE,'-')  = NVL(TMP.V_PROJECT_CODE,'-')
        AND   NVL(A.SCM_SITE_ID,'-')   = NVL(TMP.V_SCM_SITE_ID,'-')
        AND   CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
        AND   NVL(A.ITEM_ID,'-')       = NVL(TMP.V_ITEM_ID,'-')
        AND   NVL(A.DOM_EXP,'-')       = NVL(TMP.V_DOM_EXP,'-')
        AND   NVL(A.FCST_TYPE,'-')     = NVL(TMP.V_FCST_TYPE,'-')
        AND   NVL(A.INCOTERMS,'-')     = NVL(TMP.V_INCOTERMS,'-')
        -- AND   NVL(A.REMARK_TEXT,'-')   = NVL(TMP.V_TEXT,'-')   --*[2026-09-16] POJ 원본
        -- [2026-09-16 / POJ] 기타매출 원장 Text 비교에 TRIM 적용. FE 가 보내는 값은 trim 된 상태인데 저장된 REMARK_TEXT 에 끝 공백이 있는 행이 있어(81 12건 · 81_UC 5건 · 82 1건) 선삭제가 빗나가 새 행이 생겼다. REMARK_TEXT 는 PK 구성 컬럼이다
        AND   NVL(TRIM(A.REMARK_TEXT),'-')   = NVL(TRIM(TMP.V_TEXT),'-')
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE IN ('CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    -- RTF_SYS_RP delete from DM_PLN_SALES_PLAN
    DELETE FROM DM_PLN_SALES_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE           = 'RTF_SYS_RP'
        -- [2026-09-16 / POJ] 원본 시작 — DM_PLN_SALES_PLAN 선삭제 키 비교를 빈값 '-' 기준으로 통일
        --    기타매출 원장 선삭제는 이미 NVL(x,'-') 인데 여기만 원시 비교라 기준이 달랐다.
        --    인입값은 파싱에서 빈 토큰이 NULL 이 되므로 NULL = '-' 가 UNKNOWN 이 되어 선삭제가 빗나간다.
        -- AND   A.DIVISION_ID          = TMP.V_DIVISION_ID
        -- AND   A.PROJECT_CODE         = TMP.V_PROJECT_CODE
        -- AND   A.SCM_SITE_ID          = TMP.V_SCM_SITE_ID
        -- AND   CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
        -- AND   A.ITEM_ID              = TMP.V_ITEM_ID
        -- AND   A.DOM_EXP              = TMP.V_DOM_EXP
        -- AND   A.FCST_TYPE            = TMP.V_FCST_TYPE
        -- AND   A.INCOTERMS            = TMP.V_INCOTERMS
        -- AND   C2.BASIS_YYYYMM        = C1.BASIS_YYYYMM
        -- AND   C2.ISO_YYYYWW          = C1.ISO_YYYYWW
        -- AND   A.CELL_PROD_SITE_ID    = TMP.V_CELL_PROD_SITE_ID
        -- [2026-09-16 / POJ] 원본 끝
        AND    NVL(A.DIVISION_ID,'-') = NVL(TMP.V_DIVISION_ID,'-')
        AND    NVL(A.PROJECT_CODE,'-') = NVL(TMP.V_PROJECT_CODE,'-')
        AND    NVL(A.SCM_SITE_ID,'-') = NVL(TMP.V_SCM_SITE_ID,'-')
        AND   CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
        AND    NVL(A.ITEM_ID,'-') = NVL(TMP.V_ITEM_ID,'-')
        AND    NVL(A.DOM_EXP,'-') = NVL(TMP.V_DOM_EXP,'-')
        AND    NVL(A.FCST_TYPE,'-') = NVL(TMP.V_FCST_TYPE,'-')
        AND    NVL(A.INCOTERMS,'-') = NVL(TMP.V_INCOTERMS,'-')
        AND   C2.BASIS_YYYYMM        = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW          = C1.ISO_YYYYWW
        AND    NVL(A.CELL_PROD_SITE_ID,'-') = NVL(TMP.V_CELL_PROD_SITE_ID,'-')
    )
    AND A.DIVISION_ID = '40'
    AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    --=============================================================================================================
    -- KRW INSERT (SalesAmt_LOC → SalesAmt_KRW 파생)
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN tmp.V_QTY
                WHEN tmp.V_CURRENCY = 'USD' THEN NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

    --=============================================================================================================
    -- USD INSERT (SalesAmt_LOC → SalesAmt_USD 파생)
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN NVL(tmp.V_QTY / (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                WHEN tmp.V_CURRENCY = 'USD' THEN tmp.V_QTY
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE)
                    / (SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                       WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                       AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

    --=============================================================================================================
    -- Catch_Up 관련 메저 추가 (SalesAmt_KRW_Catch_Up, SalesAmt_LOC_Catch_Up, SalesAmt_USD_Catch_Up)
    --=============================================================================================================
    -- 1) SalesAmt_KRW_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

    -- 2) SalesAmt_LOC_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

    -- 3) SalesAmt_USD_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

    --=============================================================================================================
    -- DM_PLN_SALES_ETC_PLAN INSERT
    --=============================================================================================================
    -- SELECT COUNT(1) INTO n_insert_count FROM GT_F021_SALES_PLAN WHERE V_MEASURE IN ('SalesAmt_LOC','Catch_Up');

    INSERT INTO DM_PLN_SALES_ETC_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    -- [E20260819-NVLSAVE] NOT NULL 문자 컬럼 경계 NVL(x,'-') — ''=NULL 유입 시 ORA-01400 방지 (REMARK_TEXT 실사고)
    -- [E20260819-NVLSAVE2] 정규화 후 동일 PK collapse 대비 ROW_NUMBER dedup 안전망 (DMF0049 PKGUARD 계보)
    SELECT S_DIVISION_ID, S_PROJECT_CODE, S_SCM_SITE_ID, S_PLANT_SITE_ID, S_ITEM_ID, S_TEXT,
           S_DOM_EXP, S_FCST_TYPE, S_INCOTERMS, S_MEASURE, S_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM (
        SELECT V_DIVISION_ID AS S_DIVISION_ID, V_PROJECT_CODE AS S_PROJECT_CODE, V_SCM_SITE_ID AS S_SCM_SITE_ID,
               V_PLANT_SITE_ID AS S_PLANT_SITE_ID, V_ITEM_ID AS S_ITEM_ID, V_TEXT AS S_TEXT,
               V_DOM_EXP AS S_DOM_EXP, V_FCST_TYPE AS S_FCST_TYPE, V_INCOTERMS AS S_INCOTERMS,
               V_MEASURE AS S_MEASURE, V_YYYYMMDD AS S_YYYYMMDD,
               V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_DEPT_ID,
               ROW_NUMBER() OVER (PARTITION BY NVL(V_DIVISION_ID,'-'), NVL(V_PROJECT_CODE,'-'), NVL(V_SCM_SITE_ID,'-'),
                                               NVL(V_PLANT_SITE_ID,'-'), NVL(V_ITEM_ID,'-'), NVL(V_TEXT,'-'),
                                               NVL(V_DOM_EXP,'-'), NVL(V_FCST_TYPE,'-'), NVL(V_INCOTERMS,'-'),
                                               NVL(V_MEASURE,'-'), NVL(V_YYYYMMDD,'-')
                                  ORDER BY NULL) RN
        FROM   GT_F021_SALES_PLAN_LOC
        WHERE  V_ACTIVE_FLAG <> 'D'
    )
    WHERE  RN = 1;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;



    -- HISTORY INSERT
    INSERT INTO DM_PLN_SALES_ETC_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    -- [E20260819-NVLSAVE] NOT NULL 문자 컬럼 경계 NVL(x,'-') (MEASURE 는 _H 에서 nullable — 미래핑)
    SELECT V_DIVISION_ID,
    	   SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL,
    	   V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_TEXT,
           V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
    FROM   GT_F021_SALES_PLAN_LOC;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    --DBMS_OUTPUT.PUT_LINE('DM_PLN_SALES_ETC_PLAN_H: '||n_insert_count);

    --=============================================================================================================
    -- RTF_SYS_RP 기반 SalesAmt_KRW/LOC/USD 파생 INSERT into GT_F021_SALES_PLAN_RTF
    -- (판가 조회: SCM_MST_FUTURE_PRICE 또는 DM_PLN_CFM_SELLING_PRICE - 사업부별 분기)
    --=============================================================================================================
    -- 1) RTF_SYS_RP → SalesAmt_KRW
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    -- 2) RTF_SYS_RP → SalesAmt_LOC (동일 패턴, MEASURE='LOC')
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    -- 3) RTF_SYS_RP → SalesAmt_USD (동일 패턴, MEASURE='USD')
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    --=============================================================================================================
    -- DM_PLN_SALES_PLAN INSERT (RTF_SYS_RP 계열)
    --=============================================================================================================
    INSERT INTO DM_PLN_SALES_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
         , V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
    AND    V_ACTIVE_FLAG <> 'D';

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

    -- HISTORY INSERT
    INSERT INTO DM_PLN_SALES_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    -- [E20260819-NVLSAVE] NOT NULL 문자 컬럼 경계 NVL(x,'-') (PLANT_SITE_ID 는 _H 에서 nullable — 미래핑 / 감사컬럼 제외)
    SELECT V_DIVISION_ID, SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
         , V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

    --=============================================================================================================
    -- [PJ2025-50017] CFM_MKT_DEMAND_PLAN / MKT_FCST 동기화
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_INSERT
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID,
     V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY,
     V_CELL_PROD_SITE_ID, V_YYYYMM, V_FROM_SITE_ID)
    SELECT DISTINCT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY
         , V_CELL_PROD_SITE_ID, SUBSTR(V_YYYYMMDD,1,6), V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF;

    --COMMIT;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN_INSERT',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

    -- DELETE CFM_MKT_DEMAND_PLAN
    DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID
        AND   Z.V_PROJECT_CODE     = DM_PLN_CFM_MKT_DEMAND_PLAN.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.SCM_SITE_ID
        AND   Z.V_ITEM_ID          = DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID
        AND   Z.V_DOM_EXP          = DM_PLN_CFM_MKT_DEMAND_PLAN.DOM_EXP
        AND   Z.V_FCST_TYPE        = DM_PLN_CFM_MKT_DEMAND_PLAN.FCST_TYPE
        AND   Z.V_INCOTERMS        = DM_PLN_CFM_MKT_DEMAND_PLAN.INCOTERMS
        AND   Z.V_MEASURE          = DM_PLN_CFM_MKT_DEMAND_PLAN.MEASURE
        AND   Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID END
--        AND   Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID
        AND   CASE WHEN (DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID = '40' OR SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID, 1, 2) = '81') THEN NVL(DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID                    -- 2026.09.22 AJS
        AND   Z.V_YYYYMM           = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;

    -- INSERT CFM_MKT_DEMAND_PLAN
    INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
    (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE,
     LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
     ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID
--        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND CASE WHEN (A.DIVISION_ID = '40' OR SUBSTR(A.DIVISION_ID, 1, 2) = '81') THEN NVL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID                    -- 2026.09.22 AJS
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

    -- DELETE/INSERT DM_PLN_MKT_FCST
    DELETE FROM DM_PLN_MKT_FCST
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID   = DM_PLN_MKT_FCST.DIVISION_ID
        AND   Z.V_PROJECT_CODE  = DM_PLN_MKT_FCST.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID   = DM_PLN_MKT_FCST.SCM_SITE_ID
        AND   Z.V_ITEM_ID       = DM_PLN_MKT_FCST.ITEM_ID
        AND   Z.V_DOM_EXP       = DM_PLN_MKT_FCST.DOM_EXP
        AND   Z.V_FCST_TYPE     = DM_PLN_MKT_FCST.FCST_TYPE
        AND   Z.V_INCOTERMS     = DM_PLN_MKT_FCST.INCOTERMS
        AND   Z.V_MEASURE       = DM_PLN_MKT_FCST.MEASURE
        AND   Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_MKT_FCST.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_MKT_FCST.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_MKT_FCST.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
        AND   Z.V_YYYYMM        = SUBSTR(DM_PLN_MKT_FCST.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;


    INSERT INTO DM_PLN_MKT_FCST
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
         , MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID
--        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND CASE WHEN (A.DIVISION_ID = '40' OR SUBSTR(A.DIVISION_ID, 1, 2) = '81') THEN NVL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID                    -- 2026.09.22 AJS
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
           , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

    --=============================================================================================================
    -- VERSION 기반 _C 테이블 동기화 (MF_W, SF_W)
    --=============================================================================================================
    -- MF_W VERSION
    SELECT MAX(VERSION_NO) INTO v_max_mf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'MF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;


    IF v_max_mf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_mf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val
        AND    VERSION_NO   = v_max_mf_w_version
        AND    VERSION_TYPE = 'MF_W';

        -- DELETE/INSERT DM_PLN_CFM_MKT_DEMAND_PLAN_C (MF_W)
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
        WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W'
        AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
--        AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID END AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));
        AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID END AND CASE WHEN (Z.V_DIVISION_ID = '40' OR SUBSTR(Z.V_DIVISION_ID, 1, 2) = '81') THEN NVL(Z.V_CELL_PROD_SITE_ID, '-') ELSE '-' END = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));                    -- 2026.09.22 AJS

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
--        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, CASE WHEN (A.DIVISION_ID = '40' OR SUBSTR(A.DIVISION_ID, 1, 2) = '81') THEN NVL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL                    -- 2026.09.22 AJS
--        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND CASE WHEN (A.DIVISION_ID = '40' OR SUBSTR(A.DIVISION_ID, 1, 2) = '81') THEN NVL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM                    -- 2026.09.22 AJS
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

        -- DELETE/INSERT DM_PLN_MKT_FCST_C (MF_W)
        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_MKT_FCST_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_MKT_FCST_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_MKT_FCST_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_MKT_FCST_C.PLANT_SITE_ID END AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
--        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND CASE WHEN (A.DIVISION_ID = '40' OR SUBSTR(A.DIVISION_ID, 1, 2) = '81') THEN NVL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM                    -- 2026.09.22 AJS
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

    END IF;

    -- SF_W VERSION (동일 패턴)
    SELECT MAX(VERSION_NO) INTO v_max_sf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'SF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;


    IF v_max_sf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_sf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND VERSION_TYPE = 'SF_W';

--        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID END AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID END AND CASE WHEN (DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID = '40' OR SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID, 1, 2) = '81') THEN NVL(DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));                    -- 2026.09.22 AJS

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
--        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND CASE WHEN (A.DIVISION_ID = '40' OR SUBSTR(A.DIVISION_ID, 1, 2) = '81') THEN NVL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM                    -- 2026.09.22 AJS
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_MKT_FCST_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_MKT_FCST_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_MKT_FCST_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_MKT_FCST_C.PLANT_SITE_ID END AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
--        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND CASE WHEN (A.DIVISION_ID = '40' OR SUBSTR(A.DIVISION_ID, 1, 2) = '81') THEN NVL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM                    -- 2026.09.22 AJS
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
        A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD,
        v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd;

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

    END IF;

    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count= ' || TO_CHAR(n_del_count) || ' / insert_count= ' || TO_CHAR(n_insert_count);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    IF P_ACTIVE_FLAG = 'I' THEN
        n_event_count := n_insert_count;
    ELSIF P_ACTIVE_FLAG = 'D' THEN
        n_event_count := n_del_count;
    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_event_count) AS EVENT FROM DUAL;


    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID' VALUE SUBSTR(P_DIVISION_ID,1,500),
            'P_CREATED_BY'  VALUE P_CREATED_BY
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL;

END PKG_DMF0021;

--==========================================================================================;
